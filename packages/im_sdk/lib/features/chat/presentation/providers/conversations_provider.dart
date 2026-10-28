import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/core/media/authenticated_image_cache.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/data/mappers/group_member_payload_mapper.dart';
import 'package:im_sdk/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/chat/domain/repositories/chat_repository.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_read_state_policy.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_unread_policy.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_summary_policy.dart';
import 'package:im_sdk/features/chat/domain/usecases/filter_conversations.dart';
import 'package:im_sdk/features/chat/domain/usecases/sort_conversations.dart';
import 'package:im_sdk/features/chat/presentation/providers/active_chat_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_unread_ledger.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';

// ---------------------------------------------------------------------------
// Repository Provider
// ---------------------------------------------------------------------------

final _chatRepositoryProvider =
    Provider.family<ChatRepository, String>((ref, spaceId) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(accountStorageContextProvider);
  ref.watch(accountRuntimeCurrentSpaceProvider)?.spaceId;
  return ChatRepositoryImpl(
    remote: ChatRemoteDataSourceImpl(
      dio,
      accessTokenGetter: () {
        final space = ref.read(accountRuntimeCurrentSpaceProvider);
        if (space?.spaceId != spaceId) return null;
        return space?.accessToken;
      },
    ),
    local: ref.watch(chatLocalDataSourceProvider),
    spaceId: spaceId,
    draftStore: storage == null ? null : ref.watch(chatDraftLocalStoreProvider),
    draftUserId: storage?.scope.userId,
  );
}, dependencies: [
  dioProvider,
  accountRuntimeCurrentSpaceProvider,
  accountStorageContextProvider,
  chatLocalDataSourceProvider,
  chatDraftLocalStoreProvider,
]);

// ---------------------------------------------------------------------------
// Conversations Notifier
// ---------------------------------------------------------------------------

/// 设计原则（本地优先，参考微信）：
/// - 冷启动/切换空间：先读本地缓存立即渲染，后台静默拉取服务端最新数据
/// - 本地缓存按 spaceId 隔离，切换空间/账号时 provider 被 invalidate 重建
/// - 网络失败时继续显示本地缓存，不清空列表
class ConversationsNotifier
    extends FamilyAsyncNotifier<List<Conversation>, String> {
  static const _readStatePolicy = ConversationReadStatePolicy();
  static const _summaryPolicy = ConversationSummaryPolicy();

  ChatRepository get _repo => ref.read(_chatRepositoryProvider(arg));
  ChatLocalDataSource get _local => ref.read(chatLocalDataSourceProvider);

  String? _nextCursor;
  bool _isLoadingMore = false;
  bool _hasLoadError = false;
  bool _isFlushingReadReceipts = false;
  int _firstPageRequestGeneration = 0;
  final Map<(String, bool), Future<void>> _settingWriteTails = {};

  String? get nextCursor => _nextCursor;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasLoadError => _hasLoadError;

  Map<String, int> _deletionBoundaries = const {};
  Map<String, int> _clearWatermarks = const {};

  @override
  Future<List<Conversation>> build(String arg) async {
    // keepAlive：切换 tab 不销毁，保持内存缓存
    ref.keepAlive();

    // 监听当前空间，确保 token 已就绪再发请求
    final space = ref.watch(accountRuntimeCurrentSpaceProvider);
    if (space == null || space.accessToken.isEmpty || space.spaceId != arg) {
      return [];
    }

    final repo = _repo;
    Future.microtask(flushPendingReadReceipts);

    // ── 本地优先策略（微信做法）──────────────────────────────────────────
    // 1. 先读本地缓存，立即渲染（用户秒看到列表）
    if (repo is ChatRepositoryImpl) {
      final cached = await repo.getCachedConversations();
      if (cached != null) {
        final result = await _prepareVisibleConversations(
          cached,
          waitForCustomerServiceThreads: false,
          cleanupLocalCache: false,
        );
        // 先设置缓存数据，让 UI 立即显示；头像预热放到后台，避免首屏被磁盘/网络拖慢。
        state = AsyncData(result);
        Future.microtask(() => _prefetchAvatars(result));
        // 2. 后台静默拉取最新数据，不阻塞 UI
        _syncFromRemote(repo);
        return result;
      }
    }

    // 3. 无缓存（首次）：走网络，显示 loading
    try {
      final page = await repo.getConversations();
      _nextCursor = page.nextCursor;
      _isLoadingMore = false;
      _hasLoadError = false;
      final fresh = await _prepareVisibleConversations(page.items);
      Future.microtask(() => _prefetchAvatars(fresh));
      return fresh;
    } catch (_) {
      _hasLoadError = true;
      rethrow;
    }
  }

  /// 后台静默同步（不阻塞 UI，不显示 loading）
  void _syncFromRemote(ChatRepositoryImpl repo) {
    final requestGeneration = ++_firstPageRequestGeneration;
    Future.microtask(() async {
      try {
        final fresh = await repo.syncConversationsFromRemote();
        // 竞态守卫：确保当前 spaceId 没有变化
        final currentSpaceId =
            ref.read(accountRuntimeCurrentSpaceProvider)?.spaceId;
        if (currentSpaceId != arg ||
            requestGeneration != _firstPageRequestGeneration) {
          return;
        }
        final result =
            await _prepareVisibleConversations(_keepNewerLocalPreviews(fresh));
        final latestSpaceId =
            ref.read(accountRuntimeCurrentSpaceProvider)?.spaceId;
        if (latestSpaceId != arg ||
            requestGeneration != _firstPageRequestGeneration) {
          return;
        }
        state = AsyncData(result);
        Future.microtask(() => _prefetchAvatars(result));
      } catch (_) {
        // 后台同步失败静默处理，继续显示本地缓存
      }
    });
  }

  Future<List<Conversation>> _prepareVisibleConversations(
    List<Conversation> list, {
    bool waitForCustomerServiceThreads = true,
    bool cleanupLocalCache = true,
  }) async {
    final customerServiceConversationIds =
        await _customerServiceConversationIds(
            waitForRemote: waitForCustomerServiceThreads);
    if (cleanupLocalCache) {
      await _removeCustomerServiceConversationsFromLocalCache(
        list,
        customerServiceConversationIds,
      );
    }
    final homeConversations = filterHomeConversations(
      list,
      customerServiceConversationIds: customerServiceConversationIds,
    );
    final visible = await _filterHiddenConversations(homeConversations);
    return visible.map(_readStatePolicy.normalize).toList(growable: false);
  }

  Future<Set<String>> _customerServiceConversationIds({
    bool waitForRemote = true,
  }) async {
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null || !AppPermissions.canUseCustomerWorkbench(space)) {
      return const <String>{};
    }
    final scopeKey = customerServiceReminderScopeKey(
      spaceId: space.spaceId,
      userId: space.userId,
    );
    final indexedIds = {
      for (final identity in ref
          .read(customerServiceThreadIdentityIndexProvider(scopeKey))
          .identities)
        if (identity.threadType == 'temp_session' &&
            identity.conversationId.isNotEmpty)
          identity.conversationId,
    };
    try {
      final cached = ref.read(customerServiceThreadsProvider).valueOrNull;
      if (cached == null && !waitForRemote) return indexedIds;
      final data = cached ??
          await ref
              .read(customerServiceThreadsProvider.future)
              .timeout(const Duration(seconds: 5));
      final threads = [...data.queueItems, ...data.activeItems];
      ref
          .read(customerServiceThreadIdentityIndexProvider(scopeKey).notifier)
          .rememberAll(
            threads.map(
              (thread) => CustomerServiceThreadIdentity(
                threadType: thread.threadType,
                threadId: thread.threadId,
                conversationId: thread.conversationId,
              ),
            ),
          );
      return {
        ...indexedIds,
        for (final thread in threads)
          if (thread.isTempSession && thread.conversationId.isNotEmpty)
            thread.conversationId,
      };
    } catch (_) {
      return indexedIds;
    }
  }

  Future<void> _removeCustomerServiceConversationsFromLocalCache(
    List<Conversation> list,
    Set<String> customerServiceConversationIds,
  ) async {
    final customerServiceConversations = list.where(
      (c) =>
          c.type == ConversationType.tempSession ||
          customerServiceConversationIds.contains(c.conversationId),
    );
    for (final conversation in customerServiceConversations) {
      try {
        await _local.deleteConversation(arg, conversation.conversationId);
      } catch (_) {}
    }
  }

  Future<List<Conversation>> _filterHiddenConversations(
    List<Conversation> list,
  ) async {
    final repo = _repo;
    _deletionBoundaries = repo is ChatRepositoryImpl
        ? await repo.getConversationDeletionBoundaries()
        : const {};
    _clearWatermarks = repo is ChatRepositoryImpl
        ? await repo.getConversationClearWatermarks()
        : const {};
    if (_deletionBoundaries.isEmpty) return list;

    final visible = <Conversation>[];
    for (final conversation in list) {
      final hiddenSeq = _deletionBoundaries[conversation.conversationId];
      if (hiddenSeq == null) {
        visible.add(conversation);
        continue;
      }
      if (conversation.lastMessageSeq > hiddenSeq) {
        visible.add(conversation);
      }
    }
    return visible;
  }

  Future<void> _prefetchAvatars(List<Conversation> list) async {
    final avatarUrls = <String?>[
      for (final conversation in list) conversation.avatarUrl,
      for (final conversation in list)
        ...(conversation.memberAvatarUrls ?? const <String?>[]).take(9),
    ];
    if (!avatarUrls.any((url) => url?.trim().isNotEmpty == true)) return;
    await prefetchAvatarUrls(
      avatarUrls,
      cacheManager: ref.read(accountAuthCacheManagerProvider),
    );
  }

  List<Conversation> _keepNewerLocalPreviews(List<Conversation> fresh) {
    final current = state.valueOrNull;
    if (current == null || current.isEmpty) return fresh;
    final currentById = {
      for (final conversation in current)
        conversation.conversationId: conversation,
    };
    return fresh.map((remote) {
      final local = currentById[remote.conversationId];
      if (local == null) return remote;
      return _summaryPolicy.mergeRemoteSnapshot(
        local: local,
        remote: remote,
      );
    }).toList();
  }

  /// 刷新：重新从服务端拉取，以服务端为准
  Future<void> refresh() async {
    final requestGeneration = ++_firstPageRequestGeneration;
    try {
      final repo = _repo;
      final page = await repo.getConversations();
      if (requestGeneration != _firstPageRequestGeneration) return;
      _nextCursor = page.nextCursor;
      _isLoadingMore = false;
      _hasLoadError = false;
      final fresh = await _prepareVisibleConversations(
          _keepNewerLocalPreviews(page.items));
      if (requestGeneration != _firstPageRequestGeneration) return;
      await _prefetchAvatars(fresh);
      if (requestGeneration != _firstPageRequestGeneration) return;
      state = AsyncData(fresh);
    } catch (e, st) {
      if (requestGeneration != _firstPageRequestGeneration) return;
      _hasLoadError = true;
      // 刷新失败时保留当前数据，不清空
      if (state.valueOrNull == null) {
        state = AsyncError(e, st);
      }
    }
  }

  /// 加载下一页
  Future<void> loadMore() async {
    if (_isLoadingMore || _nextCursor == null) return;
    _isLoadingMore = true;
    _hasLoadError = false;
    try {
      final page = await _repo.getConversations(cursor: _nextCursor);
      _nextCursor = page.nextCursor;
      final nextItems = await _prepareVisibleConversations(page.items);
      state = state.whenData((list) => [...list, ...nextItems]);
    } catch (_) {
      _hasLoadError = true;
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Immediately reconciles the draft shown by the conversation list and the
  /// chat input with the account-local draft owner. This prevents a stale
  /// server snapshot from rehydrating text that has just been sent.
  Future<void> updateDraftLocally(
    String conversationId,
    String? draft,
  ) async {
    final normalized = draft?.trim();
    final resolvedDraft =
        normalized == null || normalized.isEmpty ? null : draft;
    Conversation? updated;
    state = state.whenData((list) {
      return list.map((conversation) {
        if (conversation.conversationId != conversationId) {
          return conversation;
        }
        updated = conversation.copyWith(
          draft: resolvedDraft,
          clearDraft: resolvedDraft == null,
        );
        return updated!;
      }).toList(growable: false);
    });
    if (updated != null) {
      await _local.updateConversationDraft(arg, conversationId, resolvedDraft);
    }
  }

  /// 标记已读
  Future<void> markRead(
      String conversationId, bool isGroup, int readSeq) async {
    final effectiveReadSeq = await markReadLocally(
      conversationId,
      isGroup: isGroup,
      readSeqHint: readSeq,
    );
    if (effectiveReadSeq == null) return;
    try {
      await _repo.markRead(conversationId, isGroup, effectiveReadSeq);
      await _local.acknowledgePendingReadReceipt(
        arg,
        conversationId,
        throughSeq: effectiveReadSeq,
      );
    } catch (error) {
      AppDiagnostics.instance.warning(
        'chat.read.remote_failed',
        'Remote read receipt failed; local read state is retained',
        context: {
          'spaceId': arg,
          'conversationId': conversationId,
          'readSeq': effectiveReadSeq,
          'error': error.toString(),
        },
      );
    }
  }

  /// 本地标记已读 + 持久化到 SQLite
  Future<int?> markReadLocally(
    String conversationId, {
    bool isGroup = false,
    int readSeqHint = 0,
  }) async {
    var localReadSeq = readSeqHint;
    final current = state.valueOrNull;
    if (current != null) {
      for (final conversation in current) {
        if (conversation.conversationId != conversationId) continue;
        final persistedSeq =
            conversation.lastMessageSeq > conversation.lastReadSeq
                ? conversation.lastMessageSeq
                : conversation.lastReadSeq;
        if (persistedSeq > localReadSeq) localReadSeq = persistedSeq;
        break;
      }
    }
    try {
      await _local.markConversationReadAndEnqueue(
        arg,
        conversationId,
        isGroup: isGroup,
        readSeq: localReadSeq,
      );
      state = state.whenData((list) => list.map((conversation) {
            if (conversation.conversationId != conversationId) {
              return conversation;
            }
            final effectiveSeq = conversation.lastReadSeq > localReadSeq
                ? conversation.lastReadSeq
                : localReadSeq;
            return conversation.copyWith(
              unreadCount: 0,
              lastReadSeq: effectiveSeq,
            );
          }).toList(growable: false));
    } catch (error) {
      AppDiagnostics.instance.error(
        'chat.read.local_persist_failed',
        'Failed to persist local read cursor',
        context: {
          'spaceId': arg,
          'conversationId': conversationId,
          'readSeq': localReadSeq,
          'error': error.toString(),
        },
      );
      return null;
    }
    return localReadSeq;
  }

  Future<void> flushPendingReadReceipts() async {
    if (_isFlushingReadReceipts) return;
    _isFlushingReadReceipts = true;
    try {
      final pending = await _local.getPendingReadReceipts(arg);
      for (final receipt in pending) {
        if (ref.read(accountRuntimeCurrentSpaceProvider)?.spaceId != arg) {
          return;
        }
        try {
          await _repo.markRead(
            receipt.conversationId,
            receipt.isGroup,
            receipt.readSeq,
          );
          await _local.acknowledgePendingReadReceipt(
            arg,
            receipt.conversationId,
            throughSeq: receipt.readSeq,
          );
        } catch (_) {
          // The outbox is durable. A later runtime activation or reconnect
          // retries it without rolling the local unread state back.
        }
      }
    } finally {
      _isFlushingReadReceipts = false;
    }
  }

  Future<void> applyReadSeqLocally(
    String conversationId,
    int readSeq,
  ) async {
    state = state.whenData((list) => list.map((c) {
          if (c.conversationId == conversationId) {
            return _readStatePolicy.advanceReadCursor(c, readSeq);
          }
          return c;
        }).toList());
    try {
      await _local.updateConversationReadState(
        arg,
        conversationId,
        readSeq: readSeq,
      );
    } catch (error) {
      AppDiagnostics.instance.error(
        'chat.read.local_persist_failed',
        'Failed to persist Gateway read cursor',
        context: {
          'spaceId': arg,
          'conversationId': conversationId,
          'readSeq': readSeq,
          'error': error.toString(),
        },
      );
    }
  }

  void markUnreadLocally(String conversationId) {
    state = state.whenData((list) => list.map((c) {
          if (c.conversationId == conversationId && c.unreadCount == 0) {
            return c.copyWith(unreadCount: 1);
          }
          return c;
        }).toList());
    Future.microtask(() async {
      try {
        await _local.updateConversationUnreadCount(arg, conversationId, 1);
      } catch (_) {}
    });
  }

  Future<void> updateConversationTitle(
      String conversationId, String newTitle) async {
    Conversation? updatedConversation;
    state = state.whenData((list) => list.map((c) {
          if (c.conversationId == conversationId) {
            updatedConversation = c.copyWith(title: newTitle);
            return updatedConversation!;
          }
          return c;
        }).toList());
    if (updatedConversation != null) {
      await _persistConversation(updatedConversation!);
    }
  }

  Future<void> togglePin(String conversationId, bool pinned) =>
      _enqueueSetting(conversationId, pinned, isPin: true);

  Future<void> toggleMute(String conversationId, bool muted) =>
      _enqueueSetting(conversationId, muted, isPin: false);

  Future<void> _enqueueSetting(String conversationId, bool value,
      {required bool isPin}) {
    final key = (conversationId, isPin);
    final previous = _settingWriteTails[key] ?? Future<void>.value();
    final write = previous
        .then((_) => _updateSetting(conversationId, value, isPin: isPin));
    late final Future<void> settled;
    settled = write.catchError((Object _) {}).whenComplete(() {
      if (identical(_settingWriteTails[key], settled)) {
        _settingWriteTails.remove(key);
      }
    });
    _settingWriteTails[key] = settled;
    return write;
  }

  Future<void> _updateSetting(String conversationId, bool value,
      {required bool isPin}) async {
    final conversations = state.valueOrNull ?? [];
    final conv = conversations.firstWhere(
      (c) => c.conversationId == conversationId,
      orElse: () => throw StateError('Conversation not found'),
    );
    final previous = isPin ? conv.isPinned : conv.isMuted;
    await _applySetting(conversationId, value, isPin: isPin);
    final repo = _repo;
    final isGroup = conv.type == ConversationType.group ||
        conv.type == ConversationType.tempSession;
    try {
      if (isPin) {
        if (repo is ChatRepositoryImpl) {
          await repo.pinConversationByType(conversationId, value, isGroup);
        } else {
          await repo.pinConversation(conversationId, value);
        }
      } else if (repo is ChatRepositoryImpl) {
        await repo.muteConversationByType(conversationId, value, isGroup);
      } else {
        await repo.muteConversation(conversationId, value);
      }
    } catch (_) {
      await _applySetting(conversationId, previous, isPin: isPin);
      rethrow;
    }
  }

  Future<void> _applySetting(String conversationId, bool value,
      {required bool isPin}) async {
    state = state.whenData((list) => list.map((c) {
          if (c.conversationId == conversationId) {
            return isPin
                ? c.copyWith(isPinned: value)
                : c.copyWith(isMuted: value);
          }
          return c;
        }).toList());
    try {
      await _local.updateConversationSettings(arg, conversationId,
          isPinned: isPin ? value : null, isMuted: isPin ? null : value);
    } catch (_) {}
  }

  Future<void> _persistConversation(Conversation conversation) async {
    try {
      await _local.upsertConversation(arg, conversation);
    } catch (_) {}
  }

  Future<void> hideConversationLocally(String conversationId) async {
    final conversations = state.valueOrNull ?? [];
    final conversation = conversations
        .where(
          (c) => c.conversationId == conversationId,
        )
        .firstOrNull;
    if (conversation?.type == ConversationType.tempSession) {
      throw UnsupportedError(
        'Customer-service temporary conversations cannot be locally deleted',
      );
    }
    final boundary = await _local.deleteConversationLocally(
      arg,
      conversationId,
      deletedThroughSeqHint: conversation?.lastMessageSeq ?? 0,
    );
    _deletionBoundaries = {
      ..._deletionBoundaries,
      conversationId: boundary,
    };
    _clearWatermarks = {..._clearWatermarks, conversationId: boundary};
    state = AsyncData(
      conversations.where((c) => c.conversationId != conversationId).toList(),
    );
  }

  Future<int> deleteConversationFromServer(String conversationId) async {
    final conversation = (state.valueOrNull ?? const <Conversation>[])
        .where((item) => item.conversationId == conversationId)
        .firstOrNull;
    if (conversation?.type == ConversationType.tempSession) {
      throw UnsupportedError(
        'Customer-service temporary conversations cannot be deleted',
      );
    }
    final result = await _repo.deleteConversation(conversationId);
    _deletionBoundaries = {
      ..._deletionBoundaries,
      conversationId: result.clearedSeq,
    };
    _clearWatermarks = {..._clearWatermarks, conversationId: result.clearedSeq};
    state = state.whenData(
      (items) =>
          _removeConversationThrough(items, conversationId, result.clearedSeq),
    );
    return result.clearedSeq;
  }

  Future<int> applyClearWatermark(
    String conversationId, {
    required int clearedSeq,
    required bool removeConversation,
  }) async {
    final effective = removeConversation
        ? await _local.applyConversationDeletion(
            arg,
            conversationId,
            clearedSeq: clearedSeq,
          )
        : await _local.applyConversationClearWatermark(
            arg,
            conversationId,
            clearedSeq: clearedSeq,
          );
    _clearWatermarks = {
      ..._clearWatermarks,
      conversationId: effective,
    };
    if (removeConversation) {
      _deletionBoundaries = {
        ..._deletionBoundaries,
        conversationId: effective,
      };
    }
    if (removeConversation) {
      state = state.whenData(
        (items) => _removeConversationThrough(items, conversationId, effective),
      );
    }
    return effective;
  }

  List<Conversation> _removeConversationThrough(
    List<Conversation> items,
    String conversationId,
    int clearedSeq,
  ) {
    return items.where((item) {
      if (item.conversationId != conversationId) return true;
      return item.lastMessageSeq > clearedSeq;
    }).toList(growable: false);
  }

  /// Gateway 推送新消息时更新会话
  void mergeConversationFromGateway(Conversation partial,
      {bool isSelf = false}) {
    if (partial.type == ConversationType.tempSession ||
        _isKnownCustomerServiceConversation(partial.conversationId)) {
      Future.microtask(() async {
        try {
          await _local.deleteConversation(arg, partial.conversationId);
        } catch (_) {}
      });
      return;
    }
    var requiresRemoteHydration = false;
    final hiddenSeq = _clearWatermarks[partial.conversationId];
    if (hiddenSeq != null && partial.lastMessageSeq <= hiddenSeq) {
      return;
    }
    state = state.whenData((list) {
      final currentUserId =
          ref.read(accountRuntimeCurrentSpaceProvider)?.userId;
      final isCurrentUserMessage =
          ConversationUnreadPolicy.isCurrentUserMessage(
        transportMarkedSelf: isSelf,
        message: partial.lastMessage,
        currentUserId: currentUserId,
      );
      final isActiveConversation =
          ref.read(activeChatConversationProvider) == partial.conversationId;
      final idx =
          list.indexWhere((c) => c.conversationId == partial.conversationId);
      if (idx < 0) {
        requiresRemoteHydration = partial.title.trim().isEmpty;
        final isEvent = partial.lastMessage?.messageType == 'event';
        return [
          ...list,
          partial.copyWith(
            unreadCount: isCurrentUserMessage || isEvent || isActiveConversation
                ? 0
                : partial.unreadCount > 0
                    ? partial.unreadCount
                    : 1,
          ),
        ];
      }
      final existing = list[idx];
      final isEvent = partial.lastMessage?.messageType == 'event';
      final isDuplicateLastMessage = _isSameLastMessage(existing, partial);
      final keepExistingLast = !_summaryPolicy.shouldAdvance(
        current: existing,
        incoming: partial,
      );
      final updated = existing.copyWith(
        type: _shouldKeepExistingType(existing, partial)
            ? existing.type
            : partial.type,
        title: partial.title.isEmpty ? existing.title : partial.title,
        avatarUrl: existing.avatarUrl ?? partial.avatarUrl,
        peerUserId: existing.peerUserId ?? partial.peerUserId,
        peerUserType: existing.peerUserType ?? partial.peerUserType,
        lastMessage: keepExistingLast
            ? existing.lastMessage
            : partial.lastMessage ?? existing.lastMessage,
        lastActivityAt: keepExistingLast
            ? existing.lastActivityAt
            : partial.lastActivityAt ?? existing.lastActivityAt,
        lastMessageSeq:
            keepExistingLast ? existing.lastMessageSeq : partial.lastMessageSeq,
        unreadCount: ConversationUnreadPolicy.mergeUnreadCount(
          currentUnreadCount: existing.unreadCount,
          isCurrentUserMessage: isCurrentUserMessage,
          isEvent: isEvent,
          isDuplicate: isDuplicateLastMessage,
          isActiveConversation: isActiveConversation,
          advancesConversation: !keepExistingLast,
        ),
      );
      final newList = List<Conversation>.from(list);
      newList[idx] = updated;
      _persistConversation(updated);
      return newList;
    });
    if (requiresRemoteHydration) {
      Future.microtask(refresh);
    }
  }

  bool _isKnownCustomerServiceConversation(String conversationId) {
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null || !AppPermissions.canUseCustomerWorkbench(space)) {
      return false;
    }
    final data = ref.read(customerServiceThreadsProvider).valueOrNull;
    if (data == null) return false;
    return [...data.queueItems, ...data.activeItems].any((thread) =>
        thread.isTempSession && thread.conversationId == conversationId);
  }

  bool _isSameLastMessage(
    Conversation existing,
    Conversation incoming,
  ) {
    final existingLast = existing.lastMessage;
    final incomingLast = incoming.lastMessage;
    if (existingLast == null || incomingLast == null) return false;
    if (existingLast.messageId.isNotEmpty &&
        incomingLast.messageId.isNotEmpty &&
        existingLast.messageId == incomingLast.messageId) {
      return true;
    }
    return existing.lastMessageSeq > 0 &&
        incoming.lastMessageSeq > 0 &&
        existing.lastMessageSeq == incoming.lastMessageSeq;
  }

  bool _shouldKeepExistingType(Conversation existing, Conversation incoming) {
    return existing.type != ConversationType.direct &&
        incoming.type == ConversationType.direct &&
        incoming.title.isEmpty;
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final conversationsProvider = AsyncNotifierProvider.family<
    ConversationsNotifier, List<Conversation>, String>(
  ConversationsNotifier.new,
  dependencies: [
    dioProvider,
    accountRuntimeCurrentSpaceProvider,
    accountStorageContextProvider,
    _chatRepositoryProvider,
    chatLocalDataSourceProvider,
    accountAuthCacheManagerProvider,
    customerServiceThreadsProvider,
  ],
);

List<Conversation> filterReleaseVisibleConversations(
  List<Conversation> conversations, {
  required bool hideGroupConversations,
}) {
  if (!hideGroupConversations) return conversations;
  return conversations
      .where((conversation) => conversation.type != ConversationType.group)
      .toList(growable: false);
}

/// Presentation-only projection for Android audit-channel A faces.
///
/// The raw provider remains untouched so Gateway persistence, synchronization,
/// and a later A -> B face transition keep the complete conversation state.
final releaseVisibleConversationsProvider =
    Provider.family<AsyncValue<List<Conversation>>, String>((ref, spaceId) {
  final conversations = ref.watch(conversationsProvider(spaceId));
  final hideGroups = ref.watch(appUpdateGroupFeaturesBlockedProvider);
  return conversations.whenData(
    (list) => filterReleaseVisibleConversations(
      list,
      hideGroupConversations: hideGroups,
    ),
  );
}, dependencies: [
  conversationsProvider,
  appUpdateGroupFeaturesBlockedProvider,
]);

final conversationSearchProvider =
    StateProvider.family<String, String>((ref, spaceId) => '');

class GroupAvatarMember {
  final String displayName;
  final String? avatarUrl;

  const GroupAvatarMember({
    required this.displayName,
    this.avatarUrl,
  });
}

class UserAvatarPreview {
  final String displayName;
  final String? avatarUrl;

  const UserAvatarPreview({
    required this.displayName,
    this.avatarUrl,
  });
}

final userAvatarPreviewProvider =
    FutureProvider.family<UserAvatarPreview?, String>((ref, userId) async {
  ref.keepAlive();
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || space.accessToken.isEmpty || userId.isEmpty) {
    return null;
  }

  final tenantContacts = space.isEmployee
      ? ref.watch(tenantMembersProvider).valueOrNull ?? const <Contact>[]
      : const <Contact>[];
  final friendContacts = ref.watch(friendsProvider).valueOrNull ?? [];
  final contacts = [...tenantContacts, ...friendContacts];
  final contact = contacts.where((c) => c.userId == userId).firstOrNull;
  if (contact?.avatarUrl?.isNotEmpty == true) {
    return UserAvatarPreview(
      displayName: contact!.displayName,
      avatarUrl: contact.avatarUrl,
    );
  }

  final cacheResolver = ref.read(accountProfileBoxResolverProvider);
  final cached = await _loadUserAvatarPreviewFromCache(
    space.spaceId,
    userId,
    cacheResolver,
  );
  if (cached?.avatarUrl?.isNotEmpty == true) {
    return cached;
  }

  try {
    final dio = ref.watch(dioProvider);
    final resp = await dio.get<Map<String, dynamic>>(
      '/api/client/v1/users/$userId/profile',
    );
    final data = resp.data?['data'] as Map<String, dynamic>? ?? {};
    final avatarUrl = _avatarUrlFromJson(data);
    final displayName = data['displayName'] as String? ??
        data['name'] as String? ??
        cached?.displayName ??
        contact?.displayName ??
        '';
    if (avatarUrl?.isNotEmpty == true) {
      await prefetchAvatarUrls(
        [avatarUrl],
        cacheManager: ref.read(accountAuthCacheManagerProvider),
      );
      await _saveUserAvatarPreviewToCache(
        space.spaceId,
        userId,
        displayName,
        avatarUrl!,
        cacheResolver,
      );
    }
    return UserAvatarPreview(
      displayName: displayName,
      avatarUrl: avatarUrl,
    );
  } catch (_) {
    if (cached != null) return cached;
    if (contact == null) return null;
    return UserAvatarPreview(
      displayName: contact.displayName,
      avatarUrl: contact.avatarUrl,
    );
  }
}, dependencies: [
  dioProvider,
  accountRuntimeCurrentSpaceProvider,
  accountStorageContextProvider,
  accountProfileBoxResolverProvider,
  accountAuthCacheManagerProvider,
  friendsProvider,
  tenantMembersProvider,
]);

const _kUserProfileCachePrefix = 'user_profile_';

Future<UserAvatarPreview?> _loadUserAvatarPreviewFromCache(
  String spaceId,
  String userId,
  AccountProfileBoxResolver profileBoxResolver,
) async {
  try {
    final box = await profileBoxResolver(spaceId);
    final raw = box.get('$_kUserProfileCachePrefix$userId');
    if (raw == null) return null;
    final data = jsonDecode(raw as String) as Map<String, dynamic>;
    return UserAvatarPreview(
      displayName: data['name'] as String? ??
          data['displayName'] as String? ??
          data['remarkName'] as String? ??
          '',
      avatarUrl: _avatarUrlFromJson(data),
    );
  } catch (_) {
    return null;
  }
}

Future<void> _saveUserAvatarPreviewToCache(
  String spaceId,
  String userId,
  String displayName,
  String avatarUrl,
  AccountProfileBoxResolver profileBoxResolver,
) async {
  try {
    final box = await profileBoxResolver(spaceId);
    final key = '$_kUserProfileCachePrefix$userId';
    final current = box.get(key);
    final data = current is String && current.isNotEmpty
        ? jsonDecode(current) as Map<String, dynamic>
        : <String, dynamic>{};
    data['userId'] = data['userId'] ?? userId;
    if (displayName.isNotEmpty) data['name'] = displayName;
    data['avatarUrl'] = avatarUrl;
    await box.put(key, jsonEncode(data));
  } catch (_) {}
}

String? _avatarUrlFromJson(Map<String, dynamic> json) {
  final raw = json['avatarUrl'] ??
      json['avatar_url'] ??
      json['avatar'] ??
      json['headImageUrl'] ??
      json['profileAvatarUrl'];
  final value = raw?.toString().trim();
  return value == null || value.isEmpty ? null : value;
}

final groupAvatarMembersProvider =
    FutureProvider.family<List<GroupAvatarMember>, String>(
        (ref, groupId) async {
  ref.keepAlive();
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || space.accessToken.isEmpty || groupId.isEmpty) {
    return const [];
  }

  try {
    final tenantContacts = space.isEmployee
        ? ref.watch(tenantMembersProvider).valueOrNull ?? const <Contact>[]
        : const <Contact>[];
    final friendContacts = ref.watch(friendsProvider).valueOrNull ?? [];
    final avatarByUserId = <String, String>{
      for (final contact in [...tenantContacts, ...friendContacts])
        if (contact.avatarUrl?.isNotEmpty == true)
          contact.userId: contact.avatarUrl!,
    };
    final nameByUserId = <String, String>{
      for (final contact in [...tenantContacts, ...friendContacts])
        if (contact.displayName.isNotEmpty) contact.userId: contact.displayName,
    };
    final dio = ref.watch(dioProvider);
    final resp = await dio
        .get<Map<String, dynamic>>('/api/client/v1/groups/$groupId/members');
    final raw = resp.data?['data'];
    final rawMembers = extractGroupMemberPayloadList(raw);
    if (rawMembers.isEmpty) return const [];
    final members = <GroupAvatarMember>[];
    for (final m in rawMembers.take(9)) {
      final parsed = parseGroupMemberPayload(m);
      final preview = parsed.avatarUrl?.isNotEmpty == true
          ? null
          : await ref.read(userAvatarPreviewProvider(parsed.userId).future);
      members.add(
        GroupAvatarMember(
          displayName: parsed.displayName.isNotEmpty
              ? parsed.displayName
              : nameByUserId[parsed.userId] ?? preview?.displayName ?? '',
          avatarUrl: parsed.avatarUrl?.isNotEmpty == true
              ? parsed.avatarUrl
              : avatarByUserId[parsed.userId] ?? preview?.avatarUrl,
        ),
      );
    }
    await prefetchAvatarUrls(
      members.map((m) => m.avatarUrl).toList(),
      cacheManager: ref.read(accountAuthCacheManagerProvider),
    );
    return members;
  } catch (_) {
    return const [];
  }
}, dependencies: [
  dioProvider,
  accountRuntimeCurrentSpaceProvider,
  accountStorageContextProvider,
  accountAuthCacheManagerProvider,
  userAvatarPreviewProvider,
  friendsProvider,
  tenantMembersProvider,
]);

final filteredConversationsProvider =
    Provider.family<AsyncValue<List<Conversation>>, String>((ref, spaceId) {
  final conversations = ref.watch(releaseVisibleConversationsProvider(spaceId));
  final keyword = ref.watch(conversationSearchProvider(spaceId));
  return conversations.whenData(
    (list) => sortConversations(filterConversations(list, keyword)),
  );
}, dependencies: [releaseVisibleConversationsProvider]);

class ConversationSections {
  final List<Conversation> pinned;
  final List<Conversation> normal;

  const ConversationSections({required this.pinned, required this.normal});
}

final sectionedConversationsProvider =
    Provider.family<AsyncValue<ConversationSections>, String>((ref, spaceId) {
  final filtered = ref.watch(filteredConversationsProvider(spaceId));
  return filtered.whenData((list) => ConversationSections(
        pinned: list.where((c) => c.isPinned).toList(),
        normal: list.where((c) => !c.isPinned).toList(),
      ));
}, dependencies: [filteredConversationsProvider]);
