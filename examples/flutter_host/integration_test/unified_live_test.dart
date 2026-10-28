import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/im_sdk.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/features/chat/presentation/pages/chat_page.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/contacts/presentation/pages/new_friends_page.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

/// Real service acceptance. Private account input is staged at runtime; no
/// endpoint, account, password, token or received response is compiled here.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('real registration, login, friends, direct and group messaging',
      (tester) async {
    final directory = await getApplicationSupportDirectory();
    final input = File('${directory.path}/unification-live-input.json');
    final status = File('${directory.path}/unification-mobile-status.json');
    final evidence = <Map<String, Object?>>[];
    final privateState = <String, Object?>{};
    final client = ImSdkClient();
    String phase = 'waitingForInput';

    Future<void> record(String step,
        [Map<String, Object?> data = const {}]) async {
      phase = step;
      evidence.add({'step': step, ...data});
      privateState.addAll({'phase': phase, 'steps': evidence});
      await status.writeAsString(jsonEncode(privateState), flush: true);
      debugPrint('IMSDK_UNIFICATION_EVIDENCE ${jsonEncode(evidence.last)}');
    }

    Future<void> until(bool Function() condition, String description,
        {int seconds = 90}) async {
      final deadline = DateTime.now().add(Duration(seconds: seconds));
      while (!condition()) {
        if (DateTime.now().isAfter(deadline)) {
          throw StateError('Timed out at $description');
        }
        await tester.pump(const Duration(milliseconds: 250));
        final error = tester.takeException();
        if (error != null) {
          throw StateError('UI error at $description: ${error.runtimeType}');
        }
      }
    }

    Future<void> tap(Finder finder) async {
      await tester.ensureVisible(finder.first);
      await tester.tap(finder.first);
      await tester.pump(const Duration(milliseconds: 300));
    }

    Future<void> enter(String key, String value) async {
      final finder = find.byKey(ValueKey(key));
      await tester.ensureVisible(finder);
      await tester.enterText(finder, value);
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump(const Duration(milliseconds: 200));
    }

    debugPrint('IMSDK_UNIFICATION_WAITING_FOR_PRIVATE_INPUT');
    await tester.runAsync(() async {
      final deadline = DateTime.now().add(const Duration(seconds: 90));
      while (!await input.exists() && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    });
    if (!await input.exists()) throw StateError('Private input was not staged');
    final config =
        jsonDecode(await input.readAsString()) as Map<String, dynamic>;
    await input.delete();
    final runId = config['runId'] as String;
    privateState['runId'] = runId;
    final configuration =
        Map<String, dynamic>.from(config['configuration'] as Map);
    final accounts = config['accounts'] as Map<String, dynamic>;
    final source = accounts['mobile'] as Map<String, dynamic>;
    final peer = accounts['web'] as Map<String, dynamic>;
    final resume = config['resumeExistingAccount'] == true;
    final resumeState = config['resumeState'] is Map
        ? Map<String, dynamic>.from(config['resumeState'] as Map)
        : <String, dynamic>{};
    if (resume) {
      privateState.addAll(resumeState);
      evidence.addAll((resumeState['steps'] as List? ?? [])
          .whereType<Map>()
          .where((item) => item['step'] != 'failed')
          .map((item) => Map<String, Object?>.from(item)));
    }
    final sourceIdentifier = source['identifier'] as String;
    final sourcePassword = source['password'] as String;
    final peerName = peer['displayName'] as String;
    final directMarker = 'IMSDK-$runId-mobile-direct';
    final groupMarker = 'IMSDK-$runId-mobile-group';
    final groupTitle = 'IMSDK-$runId-Mobile';
    try {
      await tester.pumpWidget(ImSdkMessagingView(
          client: client, configuration: ImSdkConfig.fromMap(configuration)));
      await tap(find.byKey(const ValueKey('messaging.consent')));
      if (resume) {
        await enter('messaging.account', sourceIdentifier);
        await enter('messaging.password', sourcePassword);
        await tap(find.byKey(const ValueKey('messaging.login')));
        await until(
            () => client.isAuthenticated, 'resume existing registered account');
        await record('resumedExistingAccount',
            {'freshPasswordLogin': true, 'registrationRepeated': false});
      } else {
        await tap(find.byKey(const ValueKey('messaging.register')));
        await until(
            () => find
                .byKey(const ValueKey('registration.identifier'))
                .evaluate()
                .isNotEmpty,
            'registration channels');
        if (source['channel'] == 'email') await tap(find.text('邮箱'));
        await enter('registration.name', source['displayName'] as String);
        await enter('registration.identifier', sourceIdentifier);
        await enter('registration.password', sourcePassword);
        await enter('registration.confirmation', sourcePassword);
        await tap(find.byKey(const ValueKey('registration.submit')));
        await until(() => client.isAuthenticated,
            'registration and runtime activation');
      }
      await until(
          () => find.text('会话').evaluate().isNotEmpty, 'conversation list');
      var scope = client.accountContainer!;
      var space = scope.read(currentSpaceProvider)!;
      if (resume && resumeState['userId'] != space.userId)
        throw StateError('Resume account identity mismatch');
      privateState.addAll({
        'userId': space.userId,
        'spaceId': space.spaceId,
        'user': {'userId': space.userId, 'spaceId': space.spaceId}
      });
      if (!resume)
        await record('registered', {
          'authenticated': true,
          'spaceKind': space.isPersonal ? 'personal' : 'enterprise',
          'spaceSelectorShown': false,
          'verificationMessagesSent': false
        });
      String peerUserId = resumeState['peerUserId'] as String? ?? '';
      final existingFriends =
          await scope.read(contactsRepositoryProvider).getFriends();
      if (!resume ||
          !existingFriends.any((friend) => friend.userId == peerUserId)) {
        await record('waitingForWebFriendRequest');
        FriendRequest? incoming;
        final friendDeadline = DateTime.now().add(const Duration(minutes: 4));
        while (incoming == null && DateTime.now().isBefore(friendDeadline)) {
          final requests =
              await scope.read(contactsRepositoryProvider).getFriendRequests();
          for (final request in requests) {
            if (request.fromDisplayName == peerName &&
                request.toUserId == space.userId &&
                request.status == FriendRequestStatus.pending)
              incoming = request;
          }
          if (incoming == null) await tester.pump(const Duration(seconds: 2));
        }
        if (incoming == null)
          throw StateError('Dedicated peer request did not arrive');
        peerUserId = incoming.fromUserId;
        privateState['peerUserId'] = peerUserId;
        await tap(find.byTooltip('好友申请'));
        await until(() => find.text('接受').evaluate().isNotEmpty,
            'incoming friend request UI');
        await tap(find.text('接受'));
        final acceptedDeadline =
            DateTime.now().add(const Duration(seconds: 40));
        var friends = await scope.read(contactsRepositoryProvider).getFriends();
        while (!friends.any((c) => c.userId == peerUserId) &&
            DateTime.now().isBefore(acceptedDeadline)) {
          await tester.pump(const Duration(seconds: 1));
          friends = await scope.read(contactsRepositoryProvider).getFriends();
        }
        if (!friends.any((c) => c.userId == peerUserId))
          throw StateError('Accepted friend not persisted');
        await record('friendAccepted', {
          'requestHandledThroughSdkUi': true,
          'friendshipReadFromServer': true
        });
        GoRouter.of(tester.element(find.byType(NewFriendsPage))).go('/');
        await until(() => find.byTooltip('发起聊天').evaluate().isNotEmpty,
            'conversation route after acceptance');
      } else {
        await record('friendshipRestored',
            {'serverReadback': true, 'requestRepeated': false});
      }
      await scope.read(friendsProvider.notifier).refresh();
      await tap(find.byTooltip('发起聊天'));
      await until(() => find.text(peerName).evaluate().isNotEmpty,
          'friend visible in new chat');
      await tap(find.text(peerName));
      await until(
          () => find.byType(ChatPage).evaluate().isNotEmpty, 'direct chat');
      final direct = tester.widget<ChatPage>(find.byType(ChatPage));
      privateState['directConversationId'] = direct.conversationId;
      privateState['direct'] = {
        'conversationId': direct.conversationId,
        'type': 'direct'
      };
      final repository =
          scope.read(scheduledMessageRepositoryProvider(space.spaceId));

      Future<void> roundTrip(String id, bool isGroup, String marker) async {
        final composer = find.byWidgetPredicate((widget) =>
            widget is TextField &&
            widget.textInputAction == TextInputAction.send);
        await until(() => composer.evaluate().isNotEmpty, 'message composer');
        final before = resume
            ? await repository.getMessages(id, isGroup: isGroup, limit: 100)
            : const [];
        final reused =
            resume && before.any((message) => message.body.text == marker);
        if (!reused) {
          await tester.enterText(composer.first, marker);
          await tester.testTextInput.receiveAction(TextInputAction.send);
          await tester.pump(const Duration(milliseconds: 500));
        }
        var persisted = reused;
        for (var n = 0; n < 30 && !persisted; n++) {
          final messages =
              await repository.getMessages(id, isGroup: isGroup, limit: 100);
          persisted = messages.any((m) => m.body.text == marker);
          if (!persisted) await tester.pump(const Duration(seconds: 1));
        }
        if (!persisted)
          throw StateError('SDK message not persisted by service');
        await record(isGroup ? 'groupSent' : 'directSent', {
          'uiSubmission': !reused,
          'resumedPersistedMessage': reused,
          'serverReadback': true,
          'marker': marker
        });
        await until(
            () => find
                .textContaining('$marker-web-reply', findRichText: true)
                .evaluate()
                .isNotEmpty,
            isGroup ? 'Web group reply rendered' : 'Web direct reply rendered',
            seconds: 240);
        final messages =
            await repository.getMessages(id, isGroup: isGroup, limit: 100);
        if (!messages.any((m) => m.body.text == '$marker-web-reply')) {
          throw StateError('Rendered peer reply not persisted by service');
        }
        await record(isGroup ? 'groupReplyRendered' : 'directReplyRendered',
            {'serverReadback': true, 'peerReplyVisibleInSdk': true});
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pump(const Duration(milliseconds: 500));
        final image = await binding
            .takeScreenshot(isGroup ? 'mobile-group' : 'mobile-direct');
        await File(
                '${directory.path}/unification-${isGroup ? 'group' : 'direct'}.png')
            .writeAsBytes(image);
        debugPrint(
            'IMSDK_UNIFICATION_SCREENSHOT_READY ${isGroup ? 'group' : 'direct'}');
      }

      if (!resume ||
          !evidence.any((step) => step['step'] == 'directReplyRendered')) {
        await roundTrip(direct.conversationId, false, directMarker);
      } else {
        final history =
            await repository.getMessages(direct.conversationId, limit: 100);
        if (!history.any((message) => message.body.text == directMarker) ||
            !history.any(
                (message) => message.body.text == '$directMarker-web-reply'))
          throw StateError('Previous direct roundtrip missing from service');
        await record('directHistoryRestored',
            {'serverReadback': true, 'messageResent': false});
      }
      if (resume &&
          (resumeState['groupConversationId'] as String? ?? '').isNotEmpty) {
        final id = resumeState['groupConversationId'] as String;
        GoRouter.of(tester.element(find.byType(ChatPage)))
            .go('/chat/$id', extra: {'isGroup': true, 'title': groupTitle});
        await until(
            () =>
                find.byType(ChatPage).evaluate().isNotEmpty &&
                tester.widget<ChatPage>(find.byType(ChatPage)).conversationId ==
                    id,
            'existing dedicated group route');
      } else {
        GoRouter.of(tester.element(find.byType(ChatPage))).go('/new-chat');
        await until(() => find.text('新建群聊').evaluate().isNotEmpty,
            'new chat route group action');
        await tap(find.text('新建群聊'));
        final nameField = find.byWidgetPredicate(
            (w) => w is TextField && w.decoration?.hintText == '输入群聊名称（可选）');
        await until(() => nameField.evaluate().isNotEmpty, 'create group page');
        await tester.enterText(nameField, groupTitle);
        FocusManager.instance.primaryFocus?.unfocus();
        await until(() => find.text(peerName).evaluate().isNotEmpty,
            'group friend selection');
        await tap(find.text(peerName));
        await tap(find.textContaining('完成('));
        await until(() => find.byType(ChatPage).evaluate().isNotEmpty,
            'created group chat');
      }
      final group = tester.widget<ChatPage>(find.byType(ChatPage));
      if (!group.isGroup) throw StateError('Created page is not a group chat');
      privateState['groupConversationId'] = group.conversationId;
      privateState['group'] = {
        'groupId': group.conversationId,
        'target': {
          'conversationId': group.conversationId,
          'type': 'group',
          'title': groupTitle
        },
        'ownerUserId': space.userId,
        'selectedMemberUserIds': [space.userId, peerUserId]
      };
      await record(
          'groupCreated', {'sdkUiCreation': true, 'selectedPeerCount': 1});
      await roundTrip(group.conversationId, true, groupMarker);

      GoRouter.of(tester.element(find.byType(ChatPage))).go('/');
      await tester.pump(const Duration(milliseconds: 500));
      await scope.read(conversationsProvider(space.spaceId).notifier).refresh();
      final conversations =
          scope.read(conversationsProvider(space.spaceId)).valueOrNull ?? [];
      if (!conversations
              .any((c) => c.conversationId == direct.conversationId) ||
          !conversations.any((c) => c.conversationId == group.conversationId)) {
        throw StateError('Direct/group missing from SDK conversation list');
      }
      await record('conversationListVerified', {'directAndGroupPresent': true});
      await client.logout();
      await tester.pump(const Duration(milliseconds: 500));
      if (client.isAuthenticated || client.accountContainer != null) {
        throw StateError('Logout retained an active runtime');
      }
      await enter('messaging.account', sourceIdentifier);
      await enter('messaging.password', sourcePassword);
      await tap(find.byKey(const ValueKey('messaging.login')));
      await until(() => client.isAuthenticated,
          'fresh registered-account password login');
      scope = client.accountContainer!;
      space = scope.read(currentSpaceProvider)!;
      if (space.userId != privateState['userId'])
        throw StateError('Fresh login changed account identity');
      await record(
          'reloginVerified', {'sameIdentity': true, 'oneActiveRuntime': true});
      await client.logout();
      if (client.isAuthenticated || client.accountContainer != null)
        throw StateError('Final logout retained runtime');
      await record('finalLogoutVerified', {'activeRuntimeCleared': true});
      await record(
          'completed', {'passed': true, 'resumedExistingAccount': resume});
    } catch (error) {
      try {
        if (client.isAuthenticated) {
          final image = await binding.takeScreenshot('mobile-failure');
          await File('${directory.path}/unification-failure.png')
              .writeAsBytes(image);
          debugPrint('IMSDK_UNIFICATION_SCREENSHOT_READY failure');
        }
      } catch (_) {}
      await record('failed', {
        'passed': false,
        'lastPhase': phase,
        'errorType': error.runtimeType.toString()
      });
      rethrow;
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await client.dispose();
    }
  }, timeout: const Timeout(Duration(minutes: 18)));
}
