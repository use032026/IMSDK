import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/core/database/app_database.dart';
import 'package:im_sdk/core/widgets/official_verified_name.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/mappers/group_member_payload_mapper.dart';
import 'package:im_sdk/features/chat/data/models/conversation_model.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/contacts/data/models/user_profile.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('a verified profile round-trips and requires an explicit true', () {
    const person = {'userId': 'peer', 'displayName': 'Test profile'};
    final verified =
        UserProfile.fromJson({...person, 'isOfficialVerified': true});
    expect(UserProfile.fromJson(verified.toCache()).showOfficialVerification,
        isTrue);
    expect(UserProfile.fromJson(person).showOfficialVerification, isFalse);
    expect(
        UserProfile.fromJson({...person, 'isOfficialVerified': false})
            .showOfficialVerification,
        isFalse);
    expect(
        UserProfile.fromJson({...person, 'isOfficialVerified': 'true'})
            .showOfficialVerification,
        isFalse);
    expect(
        UserProfile.fromJson({
          ...person,
          'isOfficialVerified': true,
          'officialAccountKind': 'broadcast',
        }).showOfficialVerification,
        isFalse);
  });

  test('ordinary direct summaries preserve verification separately', () {
    final chat = ConversationModel.fromJson({
      'conversationId': 'direct',
      'conversationType': 'direct',
      'peerOfficialVerified': true,
    });
    expect(chat.copyWith(unreadCount: 2).showsPeerOfficialVerification, isTrue);
    expect(
        chat
            .copyWith(peerOfficialVerified: false)
            .showsPeerOfficialVerification,
        isFalse);
    expect(
        ConversationModel.fromJson({
          'conversationId': 'direct',
          'conversationType': 'direct',
          'peerOfficialVerified': true,
          'isOfficialServiceUser': true,
        }).showsPeerOfficialVerification,
        isFalse);
  });

  test('a group member revocation takes priority over nested profile data', () {
    const payload = {
      'user': {'userId': 'peer', 'isOfficialVerified': true}
    };
    expect(parseGroupMemberPayload(payload).showOfficialVerification, isTrue);
    expect(
        parseGroupMemberPayload({...payload, 'isOfficialVerified': false})
            .showOfficialVerification,
        isFalse);
    expect(
        parseGroupMemberPayload({...payload, 'officialAccountKind': 'service'})
            .showOfficialVerification,
        isFalse);
  });

  test('cached verification survives a message summary and accepts revocation',
      () async {
    sqfliteFfiInit();
    final storage = await AppDatabase.openAccountScopedAt(
      inMemoryDatabasePath,
      factory: databaseFactoryFfi,
    );
    addTearDown(storage.close);
    final local = ChatLocalDataSourceImpl(
      databaseProvider: (_) async => storage,
      databaseDeleter: (_) async {},
    );
    const conversation = Conversation(
      conversationId: 'direct',
      title: 'Peer',
      type: ConversationType.direct,
      peerOfficialVerified: true,
    );
    await local.upsertConversations('space', [conversation]);
    await local.updateConversationSummaryFromMessage(
      'space',
      conversationId: conversation.conversationId,
      fallbackType: conversation.type,
      message: Message(
        messageId: 'msg',
        conversationId: conversation.conversationId,
        conversationSeq: 1,
        senderUserId: 'peer',
        type: MessageType.text,
        body: const MessageBody(text: 'fixture'),
        sentAt: DateTime.utc(2026),
        status: MessageStatus.sent,
      ),
      isSelf: false,
    );
    expect(
        (await local.getConversations('space'))
            .single
            .showsPeerOfficialVerification,
        isTrue);
    await local.upsertConversations('space', [
      conversation.copyWith(peerOfficialVerified: false),
    ]);
    expect(
        (await local.getConversations('space'))
            .single
            .showsPeerOfficialVerification,
        isFalse);
  });

  testWidgets('verification remains visible next to a long, constrained name',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Center(
        child: SizedBox(
          width: 56,
          child: OfficialVerifiedName(
            verified: true,
            name: Text('A long member name',
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.verified), findsOneWidget);
    expect(find.bySemanticsLabel('Verified'), findsOneWidget);
    semantics.dispose();
  });
}
