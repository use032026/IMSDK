import 'dart:async';

import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_draft_local_store.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation_clear_watermark.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation_page.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/entities/read_receipt.dart';
import 'package:im_sdk/features/chat/domain/entities/scheduled_message.dart';
import 'package:im_sdk/features/chat/domain/repositories/chat_repository.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_summary_policy.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_deletion_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_media_dimension_policy.dart';
import 'package:im_sdk/features/chat/domain/usecases/filter_conversations.dart';

const _initialConversationRetryDelay = Duration(milliseconds: 250);

class ChatRepositoryImpl implements ChatRepository, DirectReadStatusReader {
  static const _summaryPolicy = ConversationSummaryPolicy();
  static const _mediaDimensionPolicy = MessageMediaDimensionPolicy();

  final ChatRemoteDataSource _remote;
  final ChatLocalDataSource _local;
  final String spaceId;
  final ChatDraftLocalStore? _draftStore;
  final String? _draftUserId;

  int _firstPageRequestGeneration = 0;
  Future<void> _firstPageApplyTail = Future<void>.value();

  ChatRepositoryImpl({
    required ChatRemoteDataSource remote,
    required ChatLocalDataSource local,
    required this.spaceId,
    ChatDraftLocalStore? draftStore,
    String? draftUserId,
  })  : _remote = remote,
        _local = local,
        _draftStore = draftStore,
        _draftUserId = draftUserId;

  // ---------------------------------------------------------------------------
  // Conversations
  // ---------------------------------------------------------------------------

  @override
  Future<ConversationDeletionResult> deleteConversation(
    String conversationId,
  ) async {
    ConversationDeletionResult result;
    try {
      result = await _remote.deleteConversation(conversationId);
    } on ServerError catch (error) {
      if (error.statusCode != 404 && error.code != 'CONVERSATION_NOT_FOUND') {
        rethrow;
      }
      result = ConversationDeletionResult(
        conversationId: conversationId,
        clearedSeq: await _local.getLocalMaxSeq(spaceId, conversationId),
      );
    }
    final effective = await _local.applyConversationDeletion(
      spaceId,
      conversationId,
      clearedSeq: result.clearedSeq,
      isNewDeletion: true,
    );
    return ConversationDeletionResult(
      conversationId: result.conversationId,
      clearedSeq: effective,
    );
  }

  @override
  Future<ConversationsPage> getConversations({
    String? cursor,
    int limit = 50,
  }) async {
    final firstPageGeneration =
        cursor == null ? ++_firstPageRequestGeneration : null;
    try {
      return await _fetchRemoteConversationSnapshot(
        cursor: cursor,
        limit: limit,
        firstPageGeneration: firstPageGeneration,
      );
    } catch (firstError, firstStack) {
      final cached = await _local.getCachedConversations(spaceId);
      if (cached != null) {
        return ConversationsPage(items: await _homeConversations(cached));
      }
      if (cursor == null &&
          _shouldRetryInitialConversationSnapshot(firstError)) {
        try {
          await Future<void>.delayed(_initialConversationRetryDelay);
          return await _fetchRemoteConversationSnapshot(
            limit: limit,
            firstPageGeneration: firstPageGeneration,
          );
        } catch (_) {
          // Keep the original error: it is the first visible failure for the
          // user flow and usually carries the clearest network cause.
        }
      }
      Error.throwWithStackTrace(firstError, firstStack);
    }
  }

  Future<ConversationsPage> _fetchRemoteConversationSnapshot({
    String? cursor,
    int limit = 50,
    int? firstPageGeneration,
  }) async {
    final page = await _remote.getConversations(cursor: cursor, limit: limit);
    final visibleItems = cursor == null
        ? await _applyFirstPageSnapshot(
            generation: firstPageGeneration!,
            remoteItems: page.items,
          )
        : await _homeConversations(
            await _mergeLocalConversationSnapshot(page.items),
          );
    return ConversationsPage(items: visibleItems, nextCursor: page.nextCursor);
  }

  Future<List<Conversation>> _applyFirstPageSnapshot({
    required int generation,
    required List<Conversation> remoteItems,
  }) {
    return _serializeFirstPageApply(() async {
      if (generation != _firstPageRequestGeneration) {
        return _readCurrentVisibleSnapshot();
      }

      final visibleItems = await _homeConversations(
        await _mergeLocalConversationSnapshot(remoteItems),
      );
      await _cacheFirstPageConversationsBestEffort(visibleItems);

      // An authoritative empty snapshot may intentionally preserve local-only
      // draft/failed/sending/rejected summaries. Return the reconciled owner
      // state so the current UI does not hide rows that SQLite retained.
      if (visibleItems.isEmpty) {
        return _readCurrentVisibleSnapshot();
      }
      return visibleItems;
    });
  }

  Future<List<Conversation>> _readCurrentVisibleSnapshot() async {
    final cached = await _local.getCachedConversations(spaceId);
    if (cached == null) return const <Conversation>[];
    return _homeConversations(cached);
  }

  Future<List<Conversation>> _serializeFirstPageApply(
    Future<List<Conversation>> Function() operation,
  ) {
    final result = Completer<List<Conversation>>();
    final previous = _firstPageApplyTail;
    _firstPageApplyTail = () async {
      try {
        await previous;
      } catch (_) {
        // A failed apply must not poison subsequent snapshots.
      }
      try {
        result.complete(await operation());
      } catch (error, stackTrace) {
        result.completeError(error, stackTrace);
      }
    }();
    return result.future;
  }

  Future<void> _cacheFirstPageConversationsBestEffort(
    List<Conversation> conversations,
  ) async {
    try {
      await _local.cacheConversations(spaceId, conversations);
    } catch (error) {
      AppDiagnostics.instance.warning(
        'chat.conversations.cache',
        'conversation cache write failed after remote snapshot',
        context: {
          'spaceId': spaceId,
          'conversationCount': conversations.length,
          'error': error.toString(),
        },
      );
    }
  }

  bool _shouldRetryInitialConversationSnapshot(Object error) {
    if (error is NetworkError) return true;
    if (error is ServerError) {
      final statusCode = error.statusCode;
      return statusCode == 408 ||
          statusCode == 429 ||
          (statusCode != null && statusCode >= 500);
    }
    return false;
  }

  /// 读取本地缓存（立即返回，不阻塞）
  Future<List<Conversation>?> getCachedConversations() async {
    try {
      final cached = await _local.getCachedConversations(spaceId);
      if (cached == null) return null;
      return await _homeConversations(cached);
    } catch (error) {
      AppDiagnostics.instance.warning(
        'chat.conversations.cache',
        'conversation cache read failed before remote snapshot',
        context: {
          'spaceId': spaceId,
          'error': error.toString(),
        },
      );
      return null;
    }
  }

  /// 后台静默同步：拉取最新数据并 upsert 缓存，返回最新列表
  Future<List<Conversation>> syncConversationsFromRemote({
    int limit = 50,
  }) async {
    final generation = ++_firstPageRequestGeneration;
    final page = await _remote.getConversations(limit: limit);
    return _applyFirstPageSnapshot(
      generation: generation,
      remoteItems: page.items,
    );
  }

  Future<List<Conversation>> _mergeLocalConversationSnapshot(
    List<Conversation> remoteItems,
  ) async {
    List<Conversation> cached;
    try {
      cached = await _local.getConversations(spaceId);
    } catch (_) {
      return remoteItems;
    }
    if (cached.isEmpty) return remoteItems;

    final cachedById = {
      for (final conversation in cached)
        conversation.conversationId: conversation,
    };

    return remoteItems.map((remote) {
      final local = cachedById[remote.conversationId];
      final remoteWithLocalMention = _preserveLocalLastMessageMentions(
        remote,
        local,
      );
      return local == null
          ? remoteWithLocalMention
          : _summaryPolicy.mergeRemoteSnapshot(
              local: local,
              remote: remoteWithLocalMention,
            );
    }).toList();
  }

  Conversation _preserveLocalLastMessageMentions(
    Conversation remote,
    Conversation? local,
  ) {
    final remoteLast = remote.lastMessage;
    final localLast = local?.lastMessage;
    if (local == null ||
        remoteLast == null ||
        localLast == null ||
        remoteLast.mentions != null ||
        localLast.mentions == null ||
        !_isSameLastMessage(local, remote)) {
      return remote;
    }
    return remote.copyWith(
      lastMessage: remoteLast.copyWith(mentions: localLast.mentions),
    );
  }

  bool _isSameLastMessage(Conversation local, Conversation remote) {
    final localLast = local.lastMessage;
    final remoteLast = remote.lastMessage;
    if (localLast == null || remoteLast == null) return false;
    if (localLast.messageId.isNotEmpty &&
        remoteLast.messageId.isNotEmpty &&
        localLast.messageId == remoteLast.messageId) {
      return true;
    }
    return local.lastMessageSeq > 0 &&
        remote.lastMessageSeq > 0 &&
        local.lastMessageSeq == remote.lastMessageSeq;
  }

  Future<List<Conversation>> _homeConversations(
    List<Conversation> conversations,
  ) async {
    final visible = await _visibleHomeConversations(conversations);
    unawaited(_cleanupTempSessionsBestEffort(conversations));
    final drafts = _draftStore;
    final userId = _draftUserId;
    if (drafts == null || userId == null) return visible;
    return Future.wait(visible.map((conversation) async {
      final draft = await drafts.readDraft(
        spaceId: spaceId,
        userId: userId,
        conversationId: conversation.conversationId,
      );
      return draft == null
          ? conversation
          : conversation.copyWith(draft: draft, clearDraft: draft.isEmpty);
    }));
  }

  Future<List<Conversation>> _visibleHomeConversations(
    List<Conversation> conversations,
  ) async {
    final boundaries = await _local.getConversationDeletionBoundaries(spaceId);
    return filterHomeConversations(conversations).where((conversation) {
      final boundary = boundaries[conversation.conversationId];
      return boundary == null || conversation.lastMessageSeq > boundary;
    }).toList(growable: false);
  }

  Future<void> _cleanupTempSessionsBestEffort(
    List<Conversation> conversations,
  ) async {
    for (final conversation
        in conversations.where((c) => c.type == ConversationType.tempSession)) {
      try {
        await _local.deleteConversation(spaceId, conversation.conversationId);
      } catch (error) {
        AppDiagnostics.instance.warning(
          'chat.conversations.cleanup',
          'temporary customer-service conversation cleanup failed',
          context: {
            'spaceId': spaceId,
            'conversationId': conversation.conversationId,
            'errorType': error.runtimeType.toString(),
          },
        );
      }
    }
  }

  Future<int?> getConversationDeletionBoundary(String conversationId) {
    return _local.getConversationDeletionBoundary(spaceId, conversationId);
  }

  Future<Map<String, int>> getConversationDeletionBoundaries() {
    return _local.getConversationDeletionBoundaries(spaceId);
  }

  Future<Map<String, int>> getConversationClearWatermarks() {
    return _local.getConversationClearWatermarks(spaceId);
  }

  /// 更新会话草稿
  Future<void> updateConversationDraft(
      String conversationId, String? draft) async {
    await _local.updateConversationDraft(spaceId, conversationId, draft);
  }

  @override
  Future<void> pinConversation(String conversationId, bool pinned) async {
    try {
      await _remote.pinDirectChat(conversationId, pinned);
    } catch (_) {
      await _remote.pinGroup(conversationId, pinned);
    }
  }

  Future<void> pinConversationByType(
      String conversationId, bool pinned, bool isGroup) async {
    if (isGroup) {
      await _remote.pinGroup(conversationId, pinned);
    } else {
      await _remote.pinDirectChat(conversationId, pinned);
    }
  }

  @override
  Future<void> muteConversation(String conversationId, bool muted) async {
    // 尝试单聊，失败则尝试群聊
    try {
      await _remote.muteDirectChat(conversationId, muted);
    } catch (_) {
      await _remote.muteGroup(conversationId, muted);
    }
  }

  Future<void> muteConversationByType(
      String conversationId, bool muted, bool isGroup) async {
    if (isGroup) {
      await _remote.muteGroup(conversationId, muted);
    } else {
      await _remote.muteDirectChat(conversationId, muted);
    }
  }

  // ---------------------------------------------------------------------------
  // Messages
  // ---------------------------------------------------------------------------

  @override
  Future<List<Message>> getMessages(
    String conversationId, {
    bool isGroup = false,
    int? beforeSeq,
    int limit = 50,
  }) async {
    try {
      final effectiveIsGroup =
          await _resolveIsGroupFromCachedConversation(conversationId, isGroup);
      final messages = effectiveIsGroup
          ? await _remote.getGroupMessages(
              conversationId,
              beforeSeq: beforeSeq,
              limit: limit,
            )
          : await _remote.getDirectChatMessages(
              conversationId,
              beforeSeq: beforeSeq,
              limit: limit,
            );
      final mergedMessages = await _mergeLocalMediaSnapshots(
        conversationId,
        messages,
        beforeSeq: beforeSeq,
        limit: limit,
      );
      final visibleMessages = await _visibleMessages(
        conversationId,
        mergedMessages,
      );
      if (beforeSeq == null) {
        await _local.cacheMessages(spaceId, conversationId, visibleMessages);
      }
      return visibleMessages;
    } catch (_) {
      final cached = await _local.getCachedMessages(spaceId, conversationId);
      if (cached != null) return cached;
      rethrow;
    }
  }

  /// 读取本地缓存消息（立即返回，不阻塞）
  Future<List<Message>?> getCachedMessages(String conversationId) async {
    return _local.getCachedMessages(spaceId, conversationId);
  }

  /// 后台增量同步：只拉 seq > localMaxSeq 的新消息，upsert 写入缓存
  Future<List<Message>> syncMessagesFromRemote(
    String conversationId, {
    required bool isGroup,
  }) async {
    // 获取本地最大 seq 作为增量同步游标
    final localMaxSeq = await _local.getLocalMaxSeq(spaceId, conversationId);
    final effectiveIsGroup =
        await _resolveIsGroupFromCachedConversation(conversationId, isGroup);

    // 拉取最新一页
    final fresh = effectiveIsGroup
        ? await _remote.getGroupMessages(conversationId, limit: 50)
        : await _remote.getDirectChatMessages(conversationId, limit: 50);

    if (fresh.isEmpty) return [];

    // 只取比本地更新的消息
    final mergedFresh = await _mergeLocalMediaSnapshots(
      conversationId,
      fresh,
      limit: 50,
    );
    final newMsgs =
        mergedFresh.where((m) => m.conversationSeq > localMaxSeq).toList();

    if (newMsgs.isNotEmpty) {
      await _local.upsertMessages(spaceId, conversationId, newMsgs);
    }

    return newMsgs;
  }

  /// 从本地缓存加载历史消息（向上翻页，本地优先）
  Future<List<Message>> getOlderMessagesFromCache(
    String conversationId, {
    required int beforeSeq,
  }) async {
    return _local.getMessages(spaceId, conversationId, beforeSeq: beforeSeq);
  }

  /// 从网络加载历史消息（本地没有时才调用）
  Future<List<Message>> getOlderMessagesFromRemote(
    String conversationId, {
    required bool isGroup,
    required int beforeSeq,
    int limit = 50,
  }) async {
    final effectiveIsGroup =
        await _resolveIsGroupFromCachedConversation(conversationId, isGroup);
    final messages = effectiveIsGroup
        ? await _remote.getGroupMessages(conversationId,
            beforeSeq: beforeSeq, limit: limit)
        : await _remote.getDirectChatMessages(conversationId,
            beforeSeq: beforeSeq, limit: limit);

    final mergedMessages = await _mergeLocalMediaSnapshots(
      conversationId,
      messages,
      beforeSeq: beforeSeq,
      limit: limit,
    );
    final visibleMessages =
        await _visibleMessages(conversationId, mergedMessages);
    if (visibleMessages.isNotEmpty) {
      await _local.upsertMessages(spaceId, conversationId, visibleMessages);
    }
    return visibleMessages;
  }

  Future<List<Message>> _visibleMessages(
    String conversationId,
    Iterable<Message> messages,
  ) async {
    return ConversationDeletionPolicy.visibleMessages(
      messages,
      deletedThroughSeq:
          await _local.getConversationDeletionBoundary(spaceId, conversationId),
    );
  }

  Future<List<Message>> _mergeLocalMediaSnapshots(
    String conversationId,
    List<Message> remoteMessages, {
    int? beforeSeq,
    required int limit,
  }) async {
    if (remoteMessages.isEmpty) return remoteMessages;
    List<Message> localMessages;
    try {
      localMessages = await _local.getMessages(
        spaceId,
        conversationId,
        beforeSeq: beforeSeq,
        limit: limit,
      );
    } catch (_) {
      return remoteMessages;
    }
    if (localMessages.isEmpty) return remoteMessages;

    final localByMessageId = <String, Message>{};
    final localByClientMsgId = <String, Message>{};
    for (final message in localMessages) {
      if (message.messageId.isNotEmpty) {
        localByMessageId[message.messageId] = message;
      }
      final clientMsgId = message.clientMsgId;
      if (clientMsgId != null && clientMsgId.isNotEmpty) {
        localByClientMsgId[clientMsgId] = message;
      }
    }
    return remoteMessages.map((remote) {
      final local = localByMessageId[remote.messageId] ??
          (remote.clientMsgId == null
              ? null
              : localByClientMsgId[remote.clientMsgId!]);
      return local == null
          ? remote
          : _mediaDimensionPolicy.mergeRemoteSnapshot(
              local: local,
              remote: remote,
            );
    }).toList(growable: false);
  }

  Future<bool> _resolveIsGroupFromCachedConversation(
    String conversationId,
    bool fallback,
  ) async {
    if (fallback) return true;
    try {
      final conversations = await _local.getConversations(spaceId);
      for (final conversation in conversations) {
        if (conversation.conversationId == conversationId) {
          return conversation.type == ConversationType.group;
        }
      }
    } catch (_) {
      return fallback;
    }
    return fallback;
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
    if (isGroup) {
      return _remote.sendGroupMessage(
        groupId: conversationId,
        clientMsgId: clientMsgId,
        type: type,
        body: body,
        replyToMessageId: replyToMessageId,
        mentions: mentions,
      );
    } else {
      return _remote.sendDirectChatMessage(
        chatId: conversationId,
        clientMsgId: clientMsgId,
        type: type,
        body: body,
        replyToMessageId: replyToMessageId,
      );
    }
  }

  @override
  Future<ScheduledMessage> createScheduledMessage({
    required String conversationId,
    required bool isGroup,
    required MessageType type,
    required MessageBody body,
    required DateTime scheduledAt,
    String? replyToMessageId,
  }) async {
    final dto = await _remote.createScheduledMessage(
      conversationId: conversationId,
      isGroup: isGroup,
      type: type,
      body: body,
      scheduledAt: scheduledAt,
      replyToMessageId: replyToMessageId,
    );
    return dto.toDomain();
  }

  @override
  Future<List<ScheduledMessage>> getScheduledMessages(
    String conversationId,
  ) async {
    final items = await _remote.getScheduledMessages(conversationId);
    return items.map((item) => item.toDomain()).toList(growable: false);
  }

  @override
  Future<void> cancelScheduledMessage(String scheduledMessageId) =>
      _remote.cancelScheduledMessage(scheduledMessageId);

  @override
  Future<ScheduledMessage> updateScheduledMessage({
    required String scheduledMessageId,
    MessageBody? body,
    DateTime? scheduledAt,
  }) async {
    final dto = await _remote.updateScheduledMessage(
      scheduledMessageId: scheduledMessageId,
      body: body,
      scheduledAt: scheduledAt,
    );
    return dto.toDomain();
  }

  @override
  Future<MediaResource> uploadMedia(
    String filePath, {
    String? mediaKind,
    MediaUploadProgressCallback? onProgress,
  }) async {
    return _remote.uploadMedia(
      filePath,
      mediaKind: mediaKind,
      onProgress: onProgress,
    );
  }

  @override
  Future<void> recallMessage(String messageId) async {
    await _remote.recallMessage(messageId);
  }

  @override
  Future<void> markRead(
      String conversationId, bool isGroup, int readSeq) async {
    if (isGroup) {
      await _remote.markGroupRead(conversationId, readSeq);
    } else {
      await _remote.markDirectChatRead(conversationId, readSeq);
    }
  }

  @override
  Future<PeerReadStatus> getDirectReadStatus(String conversationId) {
    return _remote.getDirectReadStatus(conversationId);
  }
}
