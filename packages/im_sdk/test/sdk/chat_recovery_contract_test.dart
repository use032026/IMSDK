import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/core/database/app_database.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/data/models/gateway_sync_page_model.dart';
import 'package:im_sdk/features/chat/data/models/message_model.dart';
import 'package:im_sdk/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/services/direct_history_coverage.dart';
import 'package:im_sdk/features/chat/domain/services/message_read_receipt_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Message _message(int sequence, {String conversationId = 'chat'}) => Message(
      messageId: 'm$sequence',
      conversationId: conversationId,
      conversationSeq: sequence,
      senderUserId: 'peer',
      type: MessageType.text,
      body: const MessageBody(text: 'fixture'),
      sentAt: DateTime.utc(2026),
      status: MessageStatus.sent,
    );

GatewaySyncPageModel _page(Message message, Object cursor) =>
    GatewaySyncPageModel.fromJson({
      'nextSinceSeq': cursor,
      'conversations': [
        {
          'conversationId': 'chat',
          'messages': [MessageModel.toJson(message)],
        },
      ],
    }, currentUserId: 'me', sinceSeq: 300);

void main() {
  test('only a valid advancing sync cursor acknowledges recovered messages',
      () {
    final message = _message(108);
    expect(_page(message, 300).canCommitCursor, isFalse);
    expect(_page(message, 299).canCommitCursor, isFalse);
    expect(_page(message, '301').nextSinceSeq, 301);
    expect(_page(message, '301').canCommitCursor, isTrue);
    expect(() => _page(_message(108, conversationId: 'other'), 301),
        throwsFormatException);
  });

  test('automatic read cannot exceed the displayed verified history', () {
    final coverage = DirectHistoryCoverage()
      ..cover(105, 108)
      ..observe(111);
    const receipts = MessageReadReceiptService();
    final displayed = [_message(108), _message(111)];
    final maximum = receipts.lastDisplayedSeq(displayed);
    expect(
        receipts.lastDisplayedSeq(displayed,
            throughSeq: coverage.boundRead(maximum)),
        108);
    expect(
        receipts.lastDisplayedSeq([_message(111)],
            throughSeq: coverage.boundRead(maximum)),
        0);
    coverage.cover(109, 110);
    expect(
        receipts.lastDisplayedSeq(displayed,
            throughSeq: coverage.boundRead(maximum)),
        111);
  });

  test('directory prunes only after the last valid page and retains history',
      () async {
    sqfliteFfiInit();
    final db = await AppDatabase.openAccountScopedAt(
      inMemoryDatabasePath,
      factory: databaseFactoryFfi,
    );
    addTearDown(db.close);
    const space = 'test-space';
    final local = ChatLocalDataSourceImpl(
      databaseProvider: (_) async => db,
      databaseDeleter: (_) async {},
    );
    await local.cacheConversations(space, const [
      Conversation(
          conversationId: 'chat',
          type: ConversationType.direct,
          title: 'Previously visible'),
    ]);
    await local.upsertMessage(space, 'chat', _message(1));
    var validLastPage = false;
    final requested = <Object?>[];
    final dio = Dio()
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          final cursor = options.queryParameters['cursor'];
          requested.add(cursor);
          handler.resolve(Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 200,
            data: {
              'code': 'OK',
              'data': {
                if (cursor == null) 'nextCursor': 'next',
                if (cursor == null || validLastPage)
                  'items': [
                    {
                      'conversationId': cursor == null ? 'one' : 'two',
                      'conversationType': 'direct',
                    },
                  ],
              },
            },
          ));
        },
      ));
    addTearDown(dio.close);
    final repository = ChatRepositoryImpl(
      remote: ChatRemoteDataSourceImpl(dio),
      local: local,
      spaceId: space,
    );

    await expectLater(
        repository.syncConversationsFromRemote(), throwsFormatException);
    expect(
        (await local.getConversations(space))
            .map((item) => item.conversationId),
        ['chat']);

    validLastPage = true;
    final items = await repository.syncConversationsFromRemote();
    expect(items.map((item) => item.conversationId),
        unorderedEquals(['one', 'two']));
    expect(requested, [null, 'next', null, 'next']);
    expect(await local.isConversationDirectoryVisible(space, 'chat'), isFalse);
    expect((await local.getMessages(space, 'chat')).single.messageId, 'm1');
  });
}
