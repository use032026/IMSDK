import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation_page.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation_clear_watermark.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/entities/scheduled_message.dart';
import 'package:im_sdk/features/chat/domain/repositories/chat_repository.dart';
import 'package:im_sdk/features/customer_service/data/repositories/customer_service_repository.dart';

/// Bridges customer-service thread sending into the shared chat send lifecycle.
///
/// Customer service keeps its own business routes and permissions, while media
/// upload/progress/local recovery are handled by [SendMessageUseCase].
class CustomerServiceChatRepositoryAdapter implements ChatRepository {
  final CustomerServiceRepository customerServiceRepository;
  final ChatRemoteDataSource mediaRemote;
  final String threadType;
  final String threadId;
  final String senderUserId;
  final CsThread? receptionThread;
  final ChatLocalDataSource? local;
  final String? spaceId;
  final bool resolveReceptionBeforeSend;

  const CustomerServiceChatRepositoryAdapter({
    required this.customerServiceRepository,
    required this.mediaRemote,
    required this.threadType,
    required this.threadId,
    required this.senderUserId,
    this.receptionThread,
    this.local,
    this.spaceId,
    this.resolveReceptionBeforeSend = false,
  });

  @override
  Future<ConversationDeletionResult> deleteConversation(
    String conversationId,
  ) {
    throw UnsupportedError(
      'Customer-service temporary conversations cannot be deleted.',
    );
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required bool isGroup,
    required String clientMsgId,
    required MessageType type,
    required MessageBody body,
    String? replyToMessageId,
    List<Mention>? mentions,
  }) async {
    var thread = receptionThread;
    if (resolveReceptionBeforeSend && threadType != 'temp_session') {
      final detail = await customerServiceRepository.getThread(CsThread(
          threadType: threadType,
          threadId: threadId,
          conversationId: conversationId,
          status: 'active',
          title: '客户'));
      thread = CsThread(
          threadType: detail.threadType,
          threadId: detail.threadId,
          conversationId: detail.conversationId,
          status: detail.status,
          title: detail.title,
          handoffMode: detail.handoffMode,
          officialUserId: detail.officialUserId,
          assignedStaffUserId: detail.assignedStaffUserId);
    }
    if (thread?.isOfficialReception == true &&
        thread?.assignedStaffUserId != senderUserId) {
      throw const ServerError(
          code: 'CUSTOMER_SERVICE_DIRECT_NOT_ASSIGNED',
          message: '当前会话未分配给你',
          statusCode: 403);
    }
    final sent = await customerServiceRepository.sendThreadMessage(
      threadType: threadType,
      threadId: threadId,
      conversationId: conversationId,
      clientMsgId: clientMsgId,
      type: type,
      body: body,
      replyToMessageId: replyToMessageId,
      senderUserId: thread?.isOfficialReception == true
          ? thread?.officialUserId
          : senderUserId,
    );
    return thread?.isOfficialReception == true
        ? sent.copyWith(
            operatorUserId: sent.operatorUserId ?? senderUserId, isSelf: true)
        : sent;
  }

  @override
  Future<MediaResource> uploadMedia(
    String filePath, {
    String? mediaKind,
    MediaUploadProgressCallback? onProgress,
  }) {
    return mediaRemote.uploadMedia(
      filePath,
      mediaKind: mediaKind,
      onProgress: onProgress,
    );
  }

  @override
  Future<ConversationsPage> getConversations({
    String? cursor,
    int limit = 50,
  }) async {
    throw UnsupportedError('Customer service adapter does not list chats.');
  }

  @override
  Future<List<Message>> getMessages(
    String conversationId, {
    bool isGroup = false,
    int? beforeSeq,
    int limit = 50,
  }) async {
    final thread = receptionThread;
    if (thread?.isOfficialReception != true ||
        local == null ||
        spaceId == null) {
      throw UnsupportedError(
          'Customer service adapter requires an official reception snapshot.');
    }
    if (beforeSeq != null) {
      final cached = await local!.getMessages(spaceId!, conversationId,
          beforeSeq: beforeSeq, limit: limit);
      final cachedSequences =
          cached.map((message) => message.conversationSeq).toSet();
      if (cached.length >= limit &&
          List.generate(limit, (offset) => beforeSeq - offset - 1)
              .every(cachedSequences.contains)) {
        return cached;
      }
      // The workbench contract has an ascending cursor, not beforeSeq.
      // Materialize missing history; complete local windows need no request.
      var afterSeq = 0;
      while (afterSeq < beforeSeq - 1) {
        final detail = await customerServiceRepository.getThread(thread!,
            afterSeq: afterSeq, limit: 200);
        final page = detail.messages;
        await local!.upsertMessages(spaceId!, conversationId, page);
        final nextSeq = page.fold<int>(
            afterSeq,
            (seq, message) =>
                message.conversationSeq > seq ? message.conversationSeq : seq);
        if (page.length < 200 || nextSeq <= afterSeq) break;
        afterSeq = nextSeq;
      }
      return local!.getMessages(spaceId!, conversationId,
          beforeSeq: beforeSeq, limit: limit);
    }
    final cached =
        await local!.getMessages(spaceId!, conversationId, limit: 100);
    var afterSeq = cached.fold<int>(
        0,
        (seq, message) =>
            message.conversationSeq > seq ? message.conversationSeq : seq);
    while (true) {
      final detail = await customerServiceRepository.getThread(thread!,
          afterSeq: afterSeq > 0 ? afterSeq : null,
          limit: afterSeq > 0 ? 200 : 100);
      final page = detail.messages;
      await local!.upsertMessages(spaceId!, conversationId, page);
      final nextSeq = page.fold<int>(
          afterSeq,
          (seq, message) =>
              message.conversationSeq > seq ? message.conversationSeq : seq);
      if (afterSeq == 0 || page.length < 200 || nextSeq <= afterSeq) break;
      afterSeq = nextSeq;
    }
    return local!.getMessages(spaceId!, conversationId, limit: 100);
  }

  @override
  Future<void> pinConversation(String conversationId, bool pinned) {
    throw UnsupportedError('Customer service adapter does not pin chats.');
  }

  @override
  Future<void> muteConversation(String conversationId, bool muted) {
    throw UnsupportedError('Customer service adapter does not mute chats.');
  }

  @override
  Future<ScheduledMessage> createScheduledMessage({
    required String conversationId,
    required bool isGroup,
    required MessageType type,
    required MessageBody body,
    required DateTime scheduledAt,
    String? replyToMessageId,
  }) {
    throw UnsupportedError(
      'Customer service adapter does not schedule messages.',
    );
  }

  @override
  Future<List<ScheduledMessage>> getScheduledMessages(String conversationId) {
    throw UnsupportedError(
      'Customer service adapter does not load scheduled messages.',
    );
  }

  @override
  Future<void> cancelScheduledMessage(String scheduledMessageId) {
    throw UnsupportedError(
      'Customer service adapter does not cancel scheduled messages.',
    );
  }

  @override
  Future<ScheduledMessage> updateScheduledMessage({
    required String scheduledMessageId,
    MessageBody? body,
    DateTime? scheduledAt,
  }) {
    throw UnsupportedError(
      'Customer service adapter does not update scheduled messages.',
    );
  }

  @override
  Future<void> recallMessage(String messageId) {
    throw UnsupportedError(
        'Customer service adapter does not recall messages.');
  }

  @override
  Future<void> markRead(String conversationId, bool isGroup, int readSeq) {
    final thread = receptionThread;
    if (thread == null) throw StateError('Reception snapshot is missing');
    return customerServiceRepository
        .markThreadRead(thread, readSeq)
        .then((_) {});
  }
}
