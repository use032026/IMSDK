import 'dart:async';
import 'package:im_sdk/features/customer_service/data/repositories/customer_service_chat_repository_adapter.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/storage/account_storage_context.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/pending_message_queue.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/gateway_event_handler.dart';
import 'package:im_sdk/features/chat/application/teen_mode_message_send_failure_mapper.dart';
import 'package:im_sdk/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/group_entities.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/entities/read_receipt.dart';
import 'package:im_sdk/features/chat/domain/repositories/chat_repository.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_deletion_policy.dart';
import 'package:im_sdk/features/chat/domain/services/call_log_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_read_receipt_service.dart';
import 'package:im_sdk/features/chat/domain/services/message_timeline_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_policy.dart';
import 'package:im_sdk/features/chat/domain/services/link_preview_update_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_media_dimension_policy.dart';
import 'package:im_sdk/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_prefetch_controller.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/domain/services/teen_mode_policy.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';

// ---------------------------------------------------------------------------
// Repository Provider (per spaceId)
// ---------------------------------------------------------------------------

final _chatRepositoryProvider =
    Provider.family<ChatRepository, String>((ref, spaceId) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(accountStorageContextProvider);
  return ChatRepositoryImpl(
    remote: ChatRemoteDataSourceImpl(dio),
    local: ref.watch(chatLocalDataSourceProvider),
    spaceId: spaceId,
    draftStore: storage == null ? null : ref.watch(chatDraftLocalStoreProvider),
    draftUserId: storage?.scope.userId,
  );
}, dependencies: [
  dioProvider,
  accountStorageContextProvider,
  chatLocalDataSourceProvider,
  chatDraftLocalStoreProvider,
]);

// ---------------------------------------------------------------------------
// ChatNotifier — keyed by (spaceId, conversationId)
// ---------------------------------------------------------------------------

class ChatNotifier
    extends FamilyAsyncNotifier<List<Message>, (String, String, bool)> {
  static const _timelinePolicy = MessageTimelinePolicy();
  static const _mediaDimensionPolicy = MessageMediaDimensionPolicy();
  late ChatRepository _repo;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  Timer? _directReadStatusFastTrackTimer;
  int? _deletedThroughSeq;
  DateTime? _explicitDeletedAt;
  bool _initialLoadCompleted = false;
  final List<Message> _pendingRealtimeMessages = [];
  (AccountStorageContext?, String)? _pendingRealtimeOwner;
  final Map<String, Future<void>> _messageWriteTails = {};
  final Set<String> _diagnosedInvalidCallLogIds = <String>{};
  int? _oldestRawServerSequence;
  int _loadRevision = 0;
  // Ownership metadata for the existing snapshot; no separate message cache.
  (AccountStorageContext?, String)? _messageOwner;

  ChatLocalDataSource get _local => ref.read(chatLocalDataSourceProvider);

  @override
  Future<List<Message>> build((String, String, bool) arg) async {
    // keepAlive：退出聊天页不销毁，保持消息缓存（微信做法）
    ref.keepAlive();
    final revision = ++_loadRevision;
    ref.onDispose(() {
      _loadRevision++;
      _directReadStatusFastTrackTimer?.cancel();
      _directReadStatusFastTrackTimer = null;
    });
    final (spaceId, _, _) = arg;
    _oldestRawServerSequence = null;
    _initialLoadCompleted = false;
    _isLoadingMore = false;
    _hasMore = true;
    final space = ref.watch(accountRuntimeCurrentSpaceProvider);
    if (space == null || space.spaceId != spaceId) return const [];
    final owner = (ref.watch(accountStorageContextProvider), space.userId);
    listenSelf((_, next) {
      if (next.isLoading || !next.hasError || _initialLoadCompleted) return;
      // Resume only after Riverpod has published the build failure, so the
      // original load Future still fails instead of completing with cached data.
      Future<void>.microtask(() {
        if (revision != _loadRevision ||
            _currentMessageOwner() != owner ||
            _initialLoadCompleted) {
          return;
        }
        final retained = _retainedMessages(owner) ?? const <Message>[];
        if (revision != _loadRevision) return;
        _publishTimeline(_finishInitialLoad(owner, retained));
      });
    });
    _repo = ref.watch(_chatRepositoryProvider(spaceId));
    // Subscribe to routing identity, not every workbench snapshot/poll.
    ref.watch(officialReceptionThreadProvider(arg.$2).select((thread) => (
          thread?.threadType,
          thread?.threadId,
          thread?.conversationId,
          thread?.handoffMode,
          thread?.officialUserId,
          thread?.assignedStaffUserId,
        )));
    final officialThread = ref.read(officialReceptionThreadProvider(arg.$2));
    if (officialThread != null) {
      _repo = CustomerServiceChatRepositoryAdapter(
          customerServiceRepository:
              ref.read(customerServiceRepositoryProvider),
          mediaRemote: ChatRemoteDataSourceImpl(ref.read(dioProvider)),
          threadType: officialThread.threadType,
          threadId: officialThread.threadId,
          senderUserId: space.userId,
          receptionThread: officialThread,
          local: _local,
          spaceId: spaceId);
    }
    if (_messageOwner != owner) {
      _deletedThroughSeq = null;
      _explicitDeletedAt = null;
    }
    final deletion = await _local.getConversationDeletionState(spaceId, arg.$2);
    if (revision != _loadRevision) return const [];
    _deletedThroughSeq = deletion.deletedThroughSeq;
    _explicitDeletedAt = deletion.explicitDeletedAt;
    final initial = await _loadInitial(revision, owner);
    if (revision != _loadRevision) return const [];
    return _finishInitialLoad(owner, initial);
  }

  (AccountStorageContext?, String)? _currentMessageOwner() {
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null || space.spaceId != arg.$1) return null;
    return (ref.read(accountStorageContextProvider), space.userId);
  }

  List<Message> _finishInitialLoad(
      (AccountStorageContext?, String) owner, List<Message> initial) {
    final pending = _pendingRealtimeOwner == owner
        ? _visibleMessages(_pendingRealtimeMessages)
        : const <Message>[];
    _pendingRealtimeMessages.clear();
    _pendingRealtimeOwner = null;
    _messageOwner = owner;
    _initialLoadCompleted = true;
    final merged = _visibleMessages(_mergeMessages(initial, pending));
    _recordRawPaginationWindow(merged);
    for (final message in pending) {
      _persistMessage(arg.$1, arg.$2, message);
    }
    return merged;
  }

  void _publishTimeline(List<Message> messages) {
    final failure = state.hasError
        ? AsyncError<List<Message>>(state.error!, state.stackTrace!)
        : null;
    // Riverpod 2 copies the previous value into an AsyncError on assignment.
    // Publish the new snapshot first, then restore the original load failure.
    state = AsyncData(messages);
    if (failure != null) state = failure;
  }

  void _updateTimeline(List<Message> Function(List<Message>) reduce) {
    final owner = _currentMessageOwner();
    if (owner == null) return;
    if (!_initialLoadCompleted && state.isLoading) {
      // Keep new outgoing updates with the existing realtime buffer. Publishing
      // AsyncData here would complete the pending build Future before it fails.
      if (_pendingRealtimeOwner == owner) {
        final pending =
            _visibleMessages(reduce(List.of(_pendingRealtimeMessages)));
        _pendingRealtimeMessages
          ..clear()
          ..addAll(pending);
      }
      return;
    }
    final current = _retainedMessages(owner);
    if (current == null) return;
    _publishTimeline(_visibleMessages(reduce(current)));
  }

  void _bufferMessage((AccountStorageContext?, String) owner, Message message) {
    if (_pendingRealtimeOwner != owner) {
      _pendingRealtimeMessages.clear();
      _pendingRealtimeOwner = owner;
    }
    _pendingRealtimeMessages.add(message);
  }

  Future<List<Message>> _loadInitial(
      int revision, (AccountStorageContext?, String) owner) async {
    final (spaceId, conversationId, argIsGroup) = arg;
    final isGroup = _resolveIsGroup(spaceId, conversationId, argIsGroup);
    final repo = _repo;

    if (repo is CustomerServiceChatRepositoryAdapter) {
      final cached =
          await _local.getMessages(spaceId, conversationId, limit: 100);
      if (revision != _loadRevision) return const [];
      final visibleCached = _mergeInitialMessages(cached, owner);
      if (visibleCached.isNotEmpty) {
        _recordRawPaginationWindow(cached);
        _recordRawPaginationWindow(visibleCached);
        _messageOwner = owner;
        state = AsyncData(visibleCached);
        Future.microtask(() async {
          try {
            if (revision != _loadRevision) return;
            final synced = await repo.getMessages(conversationId);
            if (revision != _loadRevision) return;
            _updateTimeline(
                (current) => _visibleMessages(_mergeMessages(current, synced)));
          } catch (_) {}
        });
        return visibleCached;
      }
    }

    // ── 微信本地优先策略 ──────────────────────────────────────────────────
    // 1. 立即读本地缓存，有数据就先渲染（用户秒看到消息）
    if (repo is ChatRepositoryImpl) {
      final cached = await repo.getCachedMessages(conversationId);
      if (revision != _loadRevision) return const [];
      final visibleCached = _mergeInitialMessages(cached ?? const [], owner);
      _recordRawPaginationWindow(cached ?? const []);
      _recordRawPaginationWindow(visibleCached);
      if (visibleCached.isNotEmpty) {
        _hasMore = _timelinePolicy.hasFullServerPage(cached ?? const [], 50);
        _messageOwner = owner;
        state = AsyncData(visibleCached);
        ref.read(mediaPrefetchControllerProvider(spaceId)).prefetchMessages(
              visibleCached,
            );

        // 2. 后台增量同步：只拉比本地更新的消息
        _syncInBackground(conversationId, isGroup);
        if (!isGroup) {
          _syncDirectPeerReadStatusInBackground(conversationId);
          _startDirectReadStatusFastTrack(conversationId);
        }

        return visibleCached;
      }
    }

    // 3. 无缓存（首次进入）：走网络，显示 loading
    try {
      final messages = await repo.getMessages(conversationId, isGroup: isGroup);
      if (revision != _loadRevision) return const [];
      _recordRawPaginationWindow(messages);
      final visibleMessages = _projectForDisplay(
        _visibleMessages(messages),
      );
      _hasMore = messages.length >= 50;
      ref.read(mediaPrefetchControllerProvider(spaceId)).prefetchMessages(
            visibleMessages,
          );
      final merged = _mergeInitialMessages(visibleMessages, owner);
      if (!isGroup) {
        _syncDirectPeerReadStatusInBackground(conversationId);
        _startDirectReadStatusFastTrack(conversationId);
      }
      return merged;
    } catch (e) {
      if (revision != _loadRevision) return const [];
      // 网络失败时返回空列表，不显示错误页
      _hasMore = false;
      final current = _retainedMessages(owner);
      if (current != null && current.isNotEmpty) return current;
      return [];
    }
  }

  List<Message>? _retainedMessages((AccountStorageContext?, String) owner) {
    if (_messageOwner != owner) return null;
    final messages = state.valueOrNull;
    _refreshConfirmedDeletionState();
    return messages == null ||
            (_deletedThroughSeq == null && _explicitDeletedAt == null)
        ? messages
        : _visibleMessages(messages);
  }

  List<Message> _mergeInitialMessages(
      List<Message> incoming, (AccountStorageContext?, String) owner) {
    // Retain the expanded window only within this notifier's owning runtime.
    // Apply deletion boundaries to both sources before publishing the result.
    return _visibleMessages(_mergeMessages(_retainedMessages(owner), incoming));
  }

  void _refreshConfirmedDeletionState() {
    // This is the existing store's confirmed SQLite metadata, including deletes
    // committed between reloads. A subsequent read failure cannot roll it back.
    final confirmed =
        _local.getConfirmedConversationDeletionState(arg.$1, arg.$2);
    if (confirmed != null) {
      _deletedThroughSeq = confirmed.deletedThroughSeq;
      _explicitDeletedAt = confirmed.explicitDeletedAt;
    }
  }

  List<Message> _visibleMessages(Iterable<Message> messages) {
    _refreshConfirmedDeletionState();
    return ConversationDeletionPolicy.visibleMessages(
      messages,
      deletedThroughSeq: _deletedThroughSeq,
      explicitDeletedAt: _explicitDeletedAt,
    );
  }

  /// 后台增量同步（不阻塞 UI）
  void _syncInBackground(String conversationId, bool isGroup) {
    final revision = _loadRevision;
    final repo = _repo;
    Future.microtask(() async {
      try {
        if (revision != _loadRevision) return;
        if (repo is! ChatRepositoryImpl) return;

        // syncMessagesFromRemote 内部自动调用 getLocalMaxSeq 获取增量游标
        final rawNewMessages = await repo.syncMessagesFromRemote(
          conversationId,
          isGroup: isGroup,
        );
        if (revision != _loadRevision) return;
        _recordRawPaginationWindow(rawNewMessages);
        final newMsgs = _visibleMessages(rawNewMessages);

        if (newMsgs.isNotEmpty) {
          ref.read(mediaPrefetchControllerProvider(arg.$1)).prefetchMessages(
                newMsgs,
              );
          // 合并新消息到当前状态
          _updateTimeline((list) => _mergeMessages(list, newMsgs));
          if (!isGroup) {
            _syncDirectPeerReadStatusInBackground(conversationId);
            _startDirectReadStatusFastTrack(conversationId);
          }
        }
      } catch (_) {
        // 后台同步失败静默处理，本地缓存继续展示
      }
    });
  }

  /// 加载更多历史消息（向上翻页）— 优先本地缓存，本地没有才请求网络
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    final current = state.valueOrNull;
    if (current == null || current.isEmpty) return;

    _isLoadingMore = true;
    final revision = _loadRevision;
    try {
      final (spaceId, conversationId, argIsGroup) = arg;
      final isGroup = _resolveIsGroup(spaceId, conversationId, argIsGroup);
      final beforeSeq = _oldestRawServerSequence ??
          _timelinePolicy.oldestServerSequence(current);
      if (beforeSeq == null) {
        _hasMore = false;
        return;
      }

      List<Message> older = [];
      final repo = _repo;

      if (repo is ChatRepositoryImpl) {
        // 优先从本地缓存读历史消息
        older = await repo.getOlderMessagesFromCache(
          conversationId,
          beforeSeq: beforeSeq,
        );

        // 本地没有足够数据才请求网络
        if (older.length < 20) {
          final remote = await repo.getOlderMessagesFromRemote(
            conversationId,
            isGroup: isGroup,
            beforeSeq: beforeSeq,
          );
          // 合并本地和网络数据
          final map = <String, Message>{};
          for (final m in older) {
            map[m.messageId] = m;
          }
          for (final m in remote) {
            map[m.messageId] = m;
          }
          older = map.values.toList()
            ..sort((a, b) => a.conversationSeq.compareTo(b.conversationSeq));
        }
      } else {
        older = await _repo.getMessages(
          conversationId,
          isGroup: isGroup,
          beforeSeq: beforeSeq,
        );
      }

      if (revision != _loadRevision) return;
      _recordRawPaginationWindow(older);
      _hasMore = older.length >= 20;

      // Apply the persisted deletion boundary at the common merge point so
      // cache-only pages cannot rehydrate locally deleted history.
      older = _visibleMessages(older);

      if (older.isNotEmpty) {
        ref.read(mediaPrefetchControllerProvider(spaceId)).prefetchMessages(
              older,
            );
        _updateTimeline((latest) => _mergeMessages(older, latest));
      }
    } finally {
      if (revision == _loadRevision) _isLoadingMore = false;
    }
  }

  Future<void> loadAround({required int beforeSeq}) async {
    final revision = _loadRevision;
    final (spaceId, conversationId, argIsGroup) = arg;
    final isGroup = _resolveIsGroup(spaceId, conversationId, argIsGroup);
    try {
      final repo = _repo;
      final rawMessages = repo is ChatRepositoryImpl
          ? await repo.getOlderMessagesFromRemote(
              conversationId,
              isGroup: isGroup,
              beforeSeq: beforeSeq,
            )
          : await _repo.getMessages(
              conversationId,
              isGroup: isGroup,
              beforeSeq: beforeSeq,
            );
      if (revision != _loadRevision) return;
      _recordRawPaginationWindow(rawMessages);
      final messages = _visibleMessages(rawMessages);
      if (messages.isEmpty) return;
      ref.read(mediaPrefetchControllerProvider(spaceId)).prefetchMessages(
            messages,
          );
      _updateTimeline((current) => _mergeMessages(current, messages));
    } catch (_) {
      // 定位补拉失败不影响当前会话展示。
    }
  }

  /// 乐观插入消息（发送中状态）
  void optimisticInsert(Message message) {
    final (spaceId, conversationId, _) = arg;
    final owner = _currentMessageOwner();
    if (owner == null) return;
    if (!_initialLoadCompleted) {
      _bufferMessage(owner, message);
    } else {
      _updateTimeline((list) => [...list, message]);
    }
    final key = message.clientMsgId ?? message.messageId;
    unawaited(
      _serializeMessageWrite(
        key,
        () => _local.upsertMessage(spaceId, conversationId, message),
      ).catchError((_) {}),
    );
  }

  /// 更新消息状态（通过 clientMsgId 匹配）
  Future<void> updateMessage(String clientMsgId, Message updated) {
    return _serializeMessageWrite(
      clientMsgId,
      () => _applyMessageUpdate(clientMsgId, updated),
    );
  }

  /// Updates presentation-only message state without touching SQLite.
  void updateMessageTransient(String messageId, Message updated) {
    _updateTimeline((list) => list.map((message) {
          if (message.clientMsgId == messageId ||
              message.messageId == messageId) {
            return updated;
          }
          return message;
        }).toList(growable: false));
  }

  /// Persists a translated snapshot without mutating the conversation summary.
  Future<void> updateMessageTranslation(String messageId, Message updated) {
    final (spaceId, conversationId, _) = arg;
    updateMessageTransient(messageId, updated);
    return _serializeMessageWrite(
      messageId,
      () => _local.upsertMessage(spaceId, conversationId, updated),
    );
  }

  /// Persists trusted, display-oriented dimensions resolved from a local
  /// image/video source without replacing newer message state.
  Future<void> enrichLocalMediaDimensions({
    required String messageId,
    required MessageType type,
    required int displayWidth,
    required int displayHeight,
  }) {
    if (messageId.trim().isEmpty || displayWidth <= 0 || displayHeight <= 0) {
      return Future<void>.value();
    }
    return _serializeMessageWrite(messageId, () async {
      final current = state.valueOrNull;
      if (current == null) return;
      final index = current.indexWhere(
        (message) =>
            message.messageId == messageId || message.clientMsgId == messageId,
      );
      if (index < 0) return;

      final enriched = _mediaDimensionPolicy.enrich(
        current[index],
        type: type,
        displayWidth: displayWidth,
        displayHeight: displayHeight,
      );
      if (identical(enriched, current[index])) return;

      final (spaceId, conversationId, _) = arg;
      await _local.upsertMessage(spaceId, conversationId, enriched);
      _updateTimeline((messages) {
        var changed = false;
        final next = messages.map((message) {
          if (message.messageId != messageId &&
              message.clientMsgId != messageId) {
            return message;
          }
          final updated = _mediaDimensionPolicy.enrich(
            message,
            type: type,
            displayWidth: displayWidth,
            displayHeight: displayHeight,
          );
          changed = changed || !identical(updated, message);
          return updated;
        }).toList(growable: false);
        return changed ? next : messages;
      });
    });
  }

  Future<void> _applyMessageUpdate(
    String clientMsgId,
    Message updated,
  ) async {
    final (spaceId, conversationId, argIsGroup) = arg;
    Message? applied = updated;
    _updateTimeline((list) => list.map((m) {
          if (m.clientMsgId == clientMsgId || m.messageId == clientMsgId) {
            final reconciled = _timelinePolicy.reconcileUpdate(m, updated);
            applied = identical(reconciled, m) ? null : reconciled;
            return reconciled;
          }
          return m;
        }).toList());
    final message = applied;
    if (message == null) return;
    final local = _local;
    if (!message.status.isServerUsable) {
      await local.upsertMessage(spaceId, conversationId, message);
      return;
    }
    final summary = await local.persistMessageAndAdvanceConversation(
      spaceId,
      conversationId: conversationId,
      fallbackType:
          argIsGroup ? ConversationType.group : ConversationType.direct,
      message: message,
      isSelf: true,
    );
    ref
        .read(conversationsProvider(spaceId).notifier)
        .mergeConversationFromGateway(summary, isSelf: true);
    if (!argIsGroup) {
      _syncDirectPeerReadStatusInBackground(conversationId);
      _startDirectReadStatusFastTrack(conversationId);
    }
  }

  Future<void> _serializeMessageWrite(
    String clientMsgId,
    Future<void> Function() operation,
  ) {
    final previous = _messageWriteTails[clientMsgId];
    late final Future<void> current;
    current = (() async {
      if (previous != null) {
        try {
          await previous;
        } catch (_) {
          // A later terminal transition must still be allowed to persist.
        }
      }
      await operation();
    })();
    _messageWriteTails[clientMsgId] = current;
    return current.whenComplete(() {
      if (identical(_messageWriteTails[clientMsgId], current)) {
        _messageWriteTails.remove(clientMsgId);
      }
    });
  }

  void syncGroupReadReceiptSnapshot({
    required String messageId,
    required int messageSeq,
    required int readCount,
  }) {
    final (spaceId, conversationId, _) = arg;
    Message? updatedMessage;
    _updateTimeline((list) {
      var changed = false;
      final next = list.map((message) {
        final matchesMessageId =
            messageId.isNotEmpty && message.messageId == messageId;
        final matchesSeq =
            messageSeq > 0 && message.conversationSeq == messageSeq;
        if (!matchesMessageId && !matchesSeq) return message;
        if (!message.status.isServerUsable || message.conversationSeq <= 0) {
          return message;
        }
        final normalizedReadCount = readCount < 0 ? 0 : readCount;
        if (message.readCount == normalizedReadCount) return message;
        changed = true;
        updatedMessage = message.copyWith(readCount: normalizedReadCount);
        return updatedMessage!;
      }).toList(growable: false);
      return changed ? next : list;
    });

    final messageToPersist = updatedMessage;
    if (messageToPersist != null) {
      _persistMessage(spaceId, conversationId, messageToPersist);
    }
  }

  /// 追加新消息（WebSocket 收到时调用）
  void appendMessage(Message message) {
    final owner = _currentMessageOwner();
    if (owner == null) return;
    if (!_initialLoadCompleted) {
      _bufferMessage(owner, message);
      return;
    }
    if (_messageOwner != owner) return;
    final (spaceId, conversationId, _) = arg;
    final visible = _visibleMessages([message]);
    if (visible.isEmpty) return;
    final accepted = visible.single;
    final current = state.valueOrNull;
    _publishTimeline(_mergeMessages(current, [accepted]));
    unawaited(
      ref.read(mediaPrefetchControllerProvider(spaceId)).prefetchMessage(
            accepted,
          ),
    );
    _persistMessage(spaceId, conversationId, accepted);
  }

  /// Applies server-enriched link metadata to an existing message only.
  Future<void> updateLinkPreview(Message snapshot) async {
    if (snapshot.body.link == null) return;
    final (spaceId, conversationId, _) = arg;
    final persisted = await _local.updateExistingLinkPreview(
        spaceId, conversationId, snapshot);
    if (persisted == null) return;
    var changed = false;
    _updateTimeline((messages) {
      final next = messages.map((message) {
        final merged = mergeLinkPreviewSnapshot(message, persisted);
        if (merged == null) return message;
        changed = true;
        return merged;
      }).toList(growable: false);
      return changed ? next : messages;
    });
  }

  void _persistMessage(
    String spaceId,
    String conversationId,
    Message message,
  ) {
    Future.microtask(() async {
      try {
        await _local.upsertMessage(spaceId, conversationId, message);
      } catch (_) {}
    });
  }

  List<Message> _mergeMessages(
    List<Message>? existing,
    List<Message> incoming,
  ) {
    _diagnoseCallLogs(incoming);
    return _timelinePolicy.merge(existing ?? const <Message>[], incoming);
  }

  List<Message> _projectForDisplay(Iterable<Message> messages) {
    _diagnoseCallLogs(messages);
    return _timelinePolicy.projectCallLogs(messages);
  }

  void _diagnoseCallLogs(Iterable<Message> messages) {
    for (final message in messages) {
      if (message.type != MessageType.callLog ||
          CallLogPolicy.mediaKind(message.body.callLog) !=
              CallLogMediaKind.unknown ||
          !_diagnosedInvalidCallLogIds.add(message.messageId)) {
        continue;
      }
      AppDiagnostics.instance.warning(
        'call_log.contract',
        'call log media mode is missing or invalid',
        context: {
          'spaceId': arg.$1,
          'conversationId': arg.$2,
          'messageId': message.messageId,
          'callId': message.body.callLog?.callId,
          'mediaMode': message.body.callLog?.mediaMode,
          'schemaVersion': message.body.callLog?.schemaVersion,
        },
      );
    }
  }

  void _recordRawPaginationWindow(Iterable<Message> messages) {
    final oldest = _timelinePolicy.oldestServerSequence(messages);
    if (oldest == null) return;
    final current = _oldestRawServerSequence;
    if (current == null || oldest < current) {
      _oldestRawServerSequence = oldest;
    }
  }

  /// 标记消息为已撤回
  void markRecalled(String messageId) {
    _updateTimeline((list) => list.map((m) {
          if (m.messageId == messageId) {
            return m.copyWith(isRecalled: true);
          }
          return m;
        }).toList());
  }

  /// 本地删除消息（从列表移除，不调服务端）
  void deleteMessageLocally(String messageId) {
    final (spaceId, conversationId, _) = arg;
    _updateTimeline(
      (list) => list
          .where((m) => m.messageId != messageId && m.clientMsgId != messageId)
          .toList(),
    );
    Future.microtask(() async {
      try {
        await _local.deleteMessage(spaceId, conversationId, messageId);
      } catch (_) {}
    });
  }

  /// 对端已读回执：将 seq <= readSeq 且自己发送的消息标记为已读
  void updatePeerReadSeq(String peerUserId, int readSeq) {
    final myUserId = ref.read(accountRuntimeCurrentSpaceProvider)?.userId ?? '';
    final reception = ref.read(officialReceptionThreadProvider(arg.$2));
    if (reception != null && peerUserId == reception.officialUserId) return;
    const receiptService = MessageReadReceiptService();
    _updateTimeline(
      (list) => receiptService.applyDirectPeerReadSeq(
        list,
        currentUserId: reception?.officialUserId ?? myUserId,
        readSeq: readSeq,
      ),
    );
    final (spaceId, conversationId, argIsGroup) = arg;
    if (argIsGroup || myUserId.isEmpty || readSeq <= 0) return;
    Future.microtask(() async {
      try {
        await _local.markOwnMessagesReadByPeer(
          spaceId,
          conversationId,
          currentUserId: reception?.officialUserId ?? myUserId,
          readSeq: readSeq,
        );
      } catch (_) {}
    });
  }

  void _syncDirectPeerReadStatusInBackground(String conversationId) {
    final revision = _loadRevision;
    final repository = _repo;
    Future.microtask(() async {
      try {
        if (revision != _loadRevision) return;
        if (repository is! DirectReadStatusReader) return;
        final reader = repository as DirectReadStatusReader;
        final status = await reader.getDirectReadStatus(conversationId);
        if (revision != _loadRevision) return;
        final readSeq = status.peerLastReadSeq;
        if (readSeq <= 0) return;
        final myUserId =
            ref.read(accountRuntimeCurrentSpaceProvider)?.userId ?? '';
        if (myUserId.isEmpty) return;
        const receiptService = MessageReadReceiptService();
        _updateTimeline(
          (list) => receiptService.applyDirectPeerReadSeq(
            list,
            currentUserId: myUserId,
            readSeq: readSeq,
          ),
        );
        await _local.markOwnMessagesReadByPeer(
          arg.$1,
          conversationId,
          currentUserId: myUserId,
          readSeq: readSeq,
        );
      } catch (_) {
        // read-status 是回执增强能力，失败时保留 Gateway/历史快照状态。
      }
    });
  }

  void _startDirectReadStatusFastTrack(String conversationId) {
    if (_repo is CustomerServiceChatRepositoryAdapter) return;
    final myUserId = ref.read(accountRuntimeCurrentSpaceProvider)?.userId ?? '';
    if (myUserId.isEmpty || !_hasPendingDirectReadReceipt(myUserId)) return;
    if (_directReadStatusFastTrackTimer?.isActive == true) return;

    final startedAt = DateTime.now();
    _directReadStatusFastTrackTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) {
      if (DateTime.now().difference(startedAt) > const Duration(seconds: 30) ||
          !_hasPendingDirectReadReceipt(myUserId)) {
        timer.cancel();
        if (_directReadStatusFastTrackTimer == timer) {
          _directReadStatusFastTrackTimer = null;
        }
        return;
      }
      _syncDirectPeerReadStatusInBackground(conversationId);
    });
  }

  bool _hasPendingDirectReadReceipt(String myUserId) {
    final messages = state.valueOrNull;
    if (messages == null || messages.isEmpty) return false;
    return const MessageReadReceiptService().hasPendingDirectPeerReadReceipt(
      messages,
      currentUserId: myUserId,
    );
  }

  bool get hasMore => _hasMore;

  bool _resolveIsGroup(
    String spaceId,
    String conversationId,
    bool fallback,
  ) {
    if (fallback) return true;
    final conversation = ref
        .read(conversationsProvider(spaceId))
        .valueOrNull
        ?.where((c) => c.conversationId == conversationId)
        .firstOrNull;
    return conversation?.type == ConversationType.group ||
        conversation?.type == ConversationType.tempSession;
  }
}

/// 以 (spaceId, conversationId, isGroup) 为 key 的消息列表 Provider
final chatProvider = AsyncNotifierProvider.family<ChatNotifier, List<Message>,
    (String, String, bool)>(
  ChatNotifier.new,
  dependencies: [
    dioProvider,
    accountRuntimeCurrentSpaceProvider,
    accountStorageContextProvider,
    _chatRepositoryProvider,
    officialReceptionThreadProvider,
    customerServiceRepositoryProvider,
    chatLocalDataSourceProvider,
    pendingMessageQueueProvider,
    mediaPrefetchControllerProvider,
    conversationsProvider,
  ],
);

/// Reuses the notifier snapshot during a reload only in its owning runtime.
/// Invalid/retiring runtimes and other conversations never inherit old data.
final chatMessagesForDisplayProvider =
    Provider.family<AsyncValue<List<Message>>, (String, String, bool)>(
        (ref, arg) {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  final storage = ref.watch(accountStorageContextProvider);
  final messages = ref.watch(chatProvider(arg));
  if (space == null || space.spaceId != arg.$1) {
    return const AsyncData(<Message>[]);
  }
  if (messages.hasValue) {
    final notifier = ref.read(chatProvider(arg).notifier);
    final retained = notifier._retainedMessages((storage, space.userId));
    if (retained == null) {
      if (messages.hasError && !messages.isLoading) {
        return AsyncError<List<Message>>(messages.error!, messages.stackTrace!);
      }
      return const AsyncLoading<List<Message>>();
    }
    if (messages.isLoading || (messages.hasError && retained.isNotEmpty)) {
      return AsyncData(retained);
    }
    if (messages.hasError) {
      return AsyncError<List<Message>>(messages.error!, messages.stackTrace!);
    }
  }
  return messages;
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  accountStorageContextProvider,
  chatProvider,
]);

final scheduledMessageRepositoryProvider =
    Provider.family<ChatRepository, String>((ref, spaceId) {
  return ref.watch(_chatRepositoryProvider(spaceId));
}, dependencies: [_chatRepositoryProvider]);

// ---------------------------------------------------------------------------
// SendMessageUseCase Provider
// ---------------------------------------------------------------------------

final sendMessageUseCaseProvider =
    Provider.family<SendMessageUseCase, (String, String, bool)>((ref, args) {
  final (spaceId, conversationId, _) = args;
  final repo = ref.watch(_chatRepositoryProvider(spaceId));
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  final currentUserId = space?.userId ?? '';
  final conversation = ref
      .watch(conversationsProvider(spaceId))
      .valueOrNull
      ?.where((item) => item.conversationId == conversationId)
      .firstOrNull;
  final teenState = ref.watch(teenModeControllerProvider).valueOrNull;
  return SendMessageUseCase(
    repository: repo,
    currentUserId: currentUserId,
    failureMapper: mapTeenModeAwareMessageSendFailure,
    sendPolicy: MessageSendPolicy(
      context: messageSendPolicyContextForSpace(space),
      restrictions: messageSendRestrictionsForTeenMode(
        teenState,
        isReliefConversation: conversation?.isOfficialServiceUser == true,
      ),
    ),
    onPendingEnqueue: ({
      required clientMsgId,
      required conversationId,
      required isGroup,
      required type,
      required body,
      mentions,
    }) {
      return ref.read(pendingMessageQueueProvider).enqueue(PendingMessage(
            spaceId: spaceId,
            userId: currentUserId,
            clientMsgId: clientMsgId,
            conversationId: conversationId,
            isGroup: isGroup,
            messageType: GatewayEventHandler.messageTypeToApiString(type),
            body: body.toLocalJson(),
            mentions: mentions,
            createdAt: DateTime.now(),
          ));
    },
  );
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  _chatRepositoryProvider,
  pendingMessageQueueProvider,
  conversationsProvider,
  teenModeControllerProvider,
]);

MessageSendRestrictions messageSendRestrictionsForTeenMode(
  TeenModeState? state, {
  required bool isReliefConversation,
}) {
  final profile = state?.profile;
  if (profile == null || !profile.active || isReliefConversation) {
    return const MessageSendRestrictions();
  }
  final policy = TeenModePolicy(state);
  final restricted = profile.session.isRestricted;
  return MessageSendRestrictions(
    allowed: !restricted,
    blockedCode: profile.session.reason == TeenSessionReason.curfew
        ? 'LOCAL_POLICY_TEEN_CURFEW'
        : 'LOCAL_POLICY_TEEN_DAILY_LIMIT',
    mediaAllowed: policy.sendMediaAllowed,
    locationAllowed: policy.sendLocationAllowed,
    contactCardAllowed: policy.sendContactCardAllowed,
  );
}

MessageSendPolicyContext messageSendPolicyContextForSpace(
  SpaceContext? space,
) {
  if (space?.isCustomer == true) {
    return MessageSendPolicyContext.enterpriseCustomer;
  }
  if (space?.isEmployee == true) {
    return MessageSendPolicyContext.enterpriseEmployee;
  }
  return MessageSendPolicyContext.personal;
}

// ---------------------------------------------------------------------------
// Group Providers
// ---------------------------------------------------------------------------

/// 群详情 Provider
final groupDetailEntityProvider =
    FutureProvider.family<GroupDetailEntity, String>((ref, groupId) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || space.accessToken.isEmpty) throw Exception('未登录');
  final dio = ref.watch(dioProvider);
  final resp = await dio.get('/api/client/v1/groups/$groupId');
  return GroupDetailEntity.fromJson(resp.data['data'] as Map<String, dynamic>);
}, dependencies: [accountRuntimeCurrentSpaceProvider, dioProvider]);

/// 群成员 Provider
final groupMembersEntityProvider =
    FutureProvider.family<List<GroupMemberEntity>, String>(
        (ref, groupId) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || space.accessToken.isEmpty) return [];
  final dio = ref.watch(dioProvider);
  final resp = await dio.get('/api/client/v1/groups/$groupId/members');
  final list = resp.data['data'] as List<dynamic>;
  return list
      .map((e) => GroupMemberEntity.fromJson(e as Map<String, dynamic>))
      .toList();
}, dependencies: [accountRuntimeCurrentSpaceProvider, dioProvider]);
