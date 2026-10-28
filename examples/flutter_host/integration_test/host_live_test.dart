import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/im_sdk.dart';
import 'package:im_sdk_flutter_host/diagnostics.dart' as host;
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

/// Real-server acceptance only. A local launcher stages short-lived test
/// credentials in this debug App's private files directory, never in the APK.
/// The peer API is an independent real test participant, not an SDK data stub.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('live host authentication, chat transport and account exit',
      (tester) async {
    final directory = await getApplicationSupportDirectory();
    final staged = File('${directory.path}/host-validation.json');
    debugPrint('IMSDK_HOST_TEST_WAITING_FOR_PRIVATE_INPUT');
    await tester.runAsync(() async {
      final until = DateTime.now().add(const Duration(seconds: 30));
      while (!await staged.exists() && DateTime.now().isBefore(until)) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    });
    if (!await staged.exists()) {
      throw StateError('Stage a private test configuration before this test.');
    }
    final config =
        jsonDecode(await staged.readAsString()) as Map<String, dynamic>;
    await staged.delete();
    final evidence = <Map<String, Object?>>[];
    final report = File('${directory.path}/host-live-result.json');

    Future<void> record(String step,
        [Map<String, Object?> data = const {}]) async {
      evidence.add({'step': step, ...data});
      await report.writeAsString(jsonEncode({'steps': evidence}));
      debugPrint('IMSDK_HOST_EVIDENCE ${jsonEncode(evidence.last)}');
    }

    Future<void> waitFor(bool Function() condition, String step,
        {int seconds = 35}) async {
      final until = DateTime.now().add(Duration(seconds: seconds));
      while (!condition()) {
        if (DateTime.now().isAfter(until)) {
          throw StateError('Timed out: $step');
        }
        await tester.pump(const Duration(milliseconds: 200));
        final error = tester.takeException();
        if (error != null)
          throw StateError('Flutter UI error at $step: ${error.runtimeType}');
      }
    }

    Finder field(String name) => find.byKey(ValueKey('host.$name'));
    Future<void> show(String name) async {
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .jumpTo(0);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(field(name), 350,
          scrollable: find.byType(Scrollable).first);
      await tester.ensureVisible(field(name));
      await tester.pumpAndSettle();
    }

    Future<void> enter(String name, Object? value) async {
      if (value == null || value.toString().isEmpty) return;
      await show(name);
      await tester.enterText(field(name), value.toString());
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    }

    final configuration =
        (config['configuration'] ?? config['config']) as Map<String, dynamic>;
    final credentials = config['credentials'] as Map<String, dynamic>;
    final peer = config['peer'] as Map<String, dynamic>;
    final peerCredentials = peer['credentials'] as Map<String, dynamic>;
    final base = configuration['apiBaseUrl'] as String;

    Future<Map<String, dynamic>> request(
        String method, String path, String token,
        [Map<String, Object?>? body]) async {
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 15);
      try {
        final req = await client.openUrl(method, Uri.parse('$base$path'));
        req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
        req.headers.contentType = ContentType.json;
        if (body != null) req.write(jsonEncode(body));
        final response = await req.close().timeout(const Duration(seconds: 20));
        final result = jsonDecode(await utf8.decoder.bind(response).join())
            as Map<String, dynamic>;
        // Never attach raw responses, headers or token values to test failures.
        if (response.statusCode != 200 || result['code'] != 'OK') {
          throw StateError(
              'Peer request $method $path: HTTP ${response.statusCode}, code=${result['code']}');
        }
        return result;
      } finally {
        client.close(force: true);
      }
    }

    String uuid() {
      final random = Random.secure();
      final values = List<int>.generate(16, (_) => random.nextInt(256));
      values[6] = (values[6] & 15) | 64;
      values[8] = (values[8] & 63) | 128;
      final h = values.map((v) => v.toRadixString(16).padLeft(2, '0')).join();
      return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
    }

    final service = config['customerServiceTarget'] is Map;
    final scenario = service ? 'customer' : 'direct';
    final marker =
        'IMSDK-Flutter-$scenario-${DateTime.now().toUtc().millisecondsSinceEpoch}';
    try {
      host.main();
      await tester.pumpAndSettle();
      for (final key in ['apiBaseUrl', 'gatewayBaseUrl', 'serviceRealmId']) {
        await enter(key, configuration[key]);
      }
      for (final key in [
        'platformUserId',
        'userId',
        'spaceId',
        'accessToken',
        'refreshToken',
        'expiresAt',
        'platformToken',
        'platformRefreshToken',
        'deviceSessionToken'
      ]) {
        await enter(key, credentials[key]);
      }
      await show('consent');
      await tester.tap(field('consent'));
      await tester.pumpAndSettle();
      await show('authenticate');
      await tester.tap(field('authenticate'));
      await tester.pump();
      await show('status');
      await waitFor(() => tester.widget<Text>(field('status')).data != '操作进行中…',
          'authentication operation completion');
      final authStatus = tester.widget<Text>(field('status')).data ?? '';
      if (!authStatus.startsWith('SDK已认证')) {
        throw StateError('Authentication host status: $authStatus');
      }
      final openKey = service ? 'openCustomerService' : 'openDirect';
      await show(openKey);
      await waitFor(
          () => tester.widget<OutlinedButton>(field(openKey)).onPressed != null,
          'real SDK authentication');
      await record('authenticated', {'scenario': scenario});
      for (final key in ['accessToken', 'refreshToken']) {
        await show(key);
        expect(tester.widget<TextField>(field(key)).controller!.text.isEmpty,
            isTrue,
            reason: 'Credential presentation copy must be cleared.');
      }
      final target = config[service ? 'customerServiceTarget' : 'directTarget']
          as Map<String, dynamic>;
      if (service) {
        await enter('serviceAccountId', target['serviceAccountId']);
      } else {
        await enter('conversationId', target['conversationId']);
        await enter('peerUserId', target['peerUserId']);
      }
      await show(openKey);
      await tester.tap(field(openKey));
      await tester.pump();
      if (service) {
        final queued =
            find.byKey(const ValueKey('im_sdk.customerService.queued'));
        await waitFor(
            () => queued.evaluate().isNotEmpty, 'real customer-service queue');
        final view = tester.widget<ImSdkCustomerServiceView>(
            find.byType(ImSdkCustomerServiceView));
        final session = view.initialSession!;
        expect(session.status, ImSdkCustomerServiceStatus.queued);
        expect(session.threadId.isNotEmpty, isTrue);
        expect(session.canOpenConversation, isFalse);
        expect(find.byType(ImSdkChatView), findsNothing);
        await record('customerQueued', {
          'threadId': session.threadId,
          'status': session.status.name,
          'hasConversationId': session.conversationId?.isNotEmpty == true,
          'staffAction': 'not attempted: assignee is outside supplied accounts',
        });
        final refresh =
            find.byKey(const ValueKey('im_sdk.customerService.refresh'));
        await tester.tap(refresh);
        await tester.pump();
        await waitFor(
            () => tester.widget<FilledButton>(refresh).onPressed != null,
            'explicit queue status request');
        expect(queued, findsOneWidget);
        expect(find.byKey(const ValueKey('im_sdk.customerService.error')),
            findsNothing);
        await record('queueStatusChecked');
        if (Platform.isAndroid) await binding.convertFlutterSurfaceToImage();
        await tester.pump();
        final image = await binding.takeScreenshot('flutter-live-customer');
        await File('${directory.path}/host-live-customer.png')
            .writeAsBytes(image);
        debugPrint('IMSDK_HOST_SCREENSHOT_READY customer');
        await tester
            .tap(find.byKey(const ValueKey('im_sdk.customerService.close')));
        await tester.pumpAndSettle();
        await show(openKey);
        await tester.tap(field(openKey));
        await tester.pump();
        await waitFor(() => queued.evaluate().isNotEmpty, 'reopened queue');
        await record('reopenedQueue');
        await tester
            .tap(find.byKey(const ValueKey('im_sdk.customerService.close')));
        await tester.pumpAndSettle();
        await show('logout');
        await tester.tap(field('logout'));
        await tester.pump();
        await show('status');
        await waitFor(() => find.text('SDK已退出登录。').evaluate().isNotEmpty,
            'customer logout');
        await record('logoutCompleted');
        return;
      }
      await waitFor(() => find.byType(ImSdkChatView).evaluate().isNotEmpty,
          'SDK chat page');
      final opened = tester.widget<ImSdkChatView>(find.byType(ImSdkChatView));
      final conversation = opened.target.conversationId;
      final thread = opened.target.serviceThreadId;
      await record('chatOpened', {
        'scenario': scenario,
        'conversationId': conversation,
        'threadId': thread
      });

      final composer = find.byWidgetPredicate((widget) =>
          widget is TextField &&
          widget.textInputAction == TextInputAction.send);
      await waitFor(() => composer.evaluate().isNotEmpty, 'chat composer');
      await tester.enterText(composer, marker);
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();
      final historyPath = '/api/client/v1/direct-chats/$conversation/messages';
      var accepted = false;
      for (var attempt = 0; attempt < 15; attempt++) {
        final history = await request(
            'GET', historyPath, credentials['accessToken'] as String);
        if (jsonEncode(history['data']).contains(marker)) {
          accepted = true;
          break;
        }
        await tester.pump(const Duration(seconds: 1));
      }
      expect(accepted, isTrue,
          reason: 'An optimistic bubble alone is not server acceptance.');
      await record('outboundPersistedOnServer', {'marker': marker});
      final reply = '$marker-reply';
      await request(
          'POST', historyPath, peerCredentials['accessToken'] as String, {
        'clientMsgId': uuid(),
        'messageType': 'text',
        'body': {'text': reply},
        'mentions': <Object>[]
      });
      await waitFor(
          () => find
              .textContaining(reply, findRichText: true)
              .evaluate()
              .isNotEmpty,
          'actual peer message arriving through SDK');
      await record('inboundRendered', {'marker': reply});
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      if (Platform.isAndroid) await binding.convertFlutterSurfaceToImage();
      await tester.pump();
      final screenshot = await binding.takeScreenshot('flutter-live-$scenario');
      await File('${directory.path}/host-live-$scenario.png')
          .writeAsBytes(screenshot);
      debugPrint('IMSDK_HOST_SCREENSHOT_READY $scenario');
      await tester.tap(find.byIcon(Icons.arrow_back_ios).first);
      await tester.pumpAndSettle();
      await show(openKey);
      expect(tester.widget<OutlinedButton>(field(openKey)).onPressed != null,
          isTrue);
      await tester.tap(field(openKey));
      await tester.pump();
      await waitFor(() => find.byType(ImSdkChatView).evaluate().isNotEmpty,
          'reopened SDK page');
      await waitFor(
          () => find
              .textContaining(reply, findRichText: true)
              .evaluate()
              .isNotEmpty,
          'persisted message after page reopening');
      await record('reopenedWithMessage');
      await tester.tap(find.byIcon(Icons.arrow_back_ios).first);
      await tester.pumpAndSettle();
      await show('logout');
      await tester.tap(field('logout'));
      await tester.pump();
      await show('status');
      await waitFor(
          () => find.text('SDK已退出登录。').evaluate().isNotEmpty, 'SDK logout');
      await record('logoutCompleted');
    } finally {
      await report
          .writeAsString(jsonEncode({'scenario': scenario, 'steps': evidence}));
    }
  });
}
