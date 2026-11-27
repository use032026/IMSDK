import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_logout_reason.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/connectivity_provider.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/features/call/presentation/providers/call_provider.dart';
import 'package:im_sdk/features/chat/application/services/gateway_sync_coordinator.dart';
import 'package:im_sdk/features/chat/application/services/interrupted_outgoing_message_recovery.dart';
import 'package:im_sdk/features/chat/application/teen_mode_message_send_failure_mapper.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/gateway_event_handler.dart';
import 'package:im_sdk/features/chat/data/datasources/gateway_service.dart';
import 'package:im_sdk/features/chat/data/datasources/pending_message_queue.dart';
import 'package:im_sdk/features/chat/data/models/conversation_model.dart';
import 'package:im_sdk/features/chat/data/models/gateway_sync_page_model.dart';
import 'package:im_sdk/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/services/mention_reminder.dart';
import 'package:im_sdk/features/chat/domain/services/message_notification_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_transport_retry_policy.dart';
import 'package:im_sdk/features/chat/domain/services/outgoing_message_policy.dart';
import 'package:im_sdk/features/chat/presentation/providers/active_chat_provider.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_open_controller.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_prefetch_controller.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_draft_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/group_invitation_notice_provider.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_settings_page.dart'
    show groupDetailProvider;
import 'package:im_sdk/features/chat/presentation/providers/presence_provider.dart';
import 'package:im_sdk/features/contacts/application/friend_request_result_handler.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/contacts/presentation/providers/friend_acceptance_conversation_provider.dart';
import 'package:im_sdk/features/customer_service/data/adapters/customer_service_gateway_message_adapter.dart';
import 'package:im_sdk/features/customer_service/data/repositories/customer_service_chat_repository_adapter.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_role_capabilities.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_unread_ledger.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';
import 'package:im_sdk/features/space/presentation/providers/spaces_provider.dart';
import 'package:im_sdk/features/teen_mode/application/teen_mode_realtime_refresh_plan.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';

// ---------------------------------------------------------------------------
// GatewayService Provider（单例）
// ---------------------------------------------------------------------------

/// 全局单例 GatewayService Provider
///
/// 当前账号 Runtime 持有 Gateway 与 HTTP 增量同步。
final gatewayProvider = Provider<GatewayService>((ref) {
  final storageScope = ref.read(accountStorageContextProvider)?.scope;
  final diagnosticScope =
      storageScope == null ? null : DiagnosticScope.account(storageScope);
  final service = GatewayService(diagnosticScope: diagnosticScope);
  final handler = GatewayEventHandler();
  final syncCoordinator = GatewaySyncCoordinator();
  // Captured before this runtime exposes its chat UI. Sends started while the
  // initial /sync is pending belong to this run, not startup recovery.
  final recoveryStartedBefore = DateTime.now();
  final recoveredIdentityKeys = <String>{};
  StreamSubscription<GatewayEvent>? subscription;
  var disposed = false;

  bool ownsCurrentRuntime(SpaceContext? space) {
    if (disposed || space == null) return false;
    final storage = ref.read(accountStorageContextProvider);
    return storage?.scope.ownsSpace(space) == true;
  }

  void connectOnCurrentRoute(SpaceContext space) {
    final site = SiteLineManager.instance;
    final routeRevision = site.routeRevision;
    unawaited(
        service.connect(space.accessToken, site.gatewayBaseUrl, isCurrent: () {
      if (disposed || routeRevision != site.routeRevision) return false;
      final current = ref.read(accountRuntimeCurrentSpaceProvider);
      return current != null &&
          ownsCurrentRuntime(current) &&
          current.spaceId == space.spaceId &&
          current.userId == space.userId &&
          current.accessToken == space.accessToken;
    }));
  }

  Future<void> synchronizeCurrentIdentity({bool rerunIfRunning = false}) async {
    if (disposed) return;
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null || !ownsCurrentRuntime(space)) return;
    final userId = space.userId.trim();
    if (userId.isEmpty) {
      AppDiagnostics.instance.info(
        'gateway.sync',
        'skipped until authenticated identity is hydrated',
        context: {'spaceId': space.spaceId},
      );
      return;
    }
    final routeRevision = SiteLineManager.instance.routeRevision;
    bool isCurrent() {
      if (disposed || routeRevision != SiteLineManager.instance.routeRevision) {
        return false;
      }
      final current = ref.read(accountRuntimeCurrentSpaceProvider);
      return current != null &&
          ownsCurrentRuntime(current) &&
          current.spaceId == space.spaceId &&
          current.userId.trim() == userId &&
          current.accessToken == space.accessToken;
    }

    await syncCoordinator.run(
      spaceId: space.spaceId,
      userId: userId,
      rerunIfRunning: rerunIfRunning,
      canRetry: () =>
          isCurrent() &&
          ref.read(connectivityStatusProvider).valueOrNull !=
              AppConnectivityStatus.offline,
      task: () async {
        if (!isCurrent()) return;
        final dio = ref.read(dioProvider);
        await syncCoordinator.runAfterSuccessfulSync(
          synchronize: () => syncGatewayMessages(
            dio,
            space.spaceId,
            userId,
            ref,
            isActive: isCurrent,
            retryOnTransientFailure: true,
          ),
          onSynchronized: () async {
            if (!isCurrent()) return;
            final identityKey = '${space.spaceId}:$userId';
            if (!recoveredIdentityKeys.contains(identityKey)) {
              try {
                await InterruptedOutgoingMessageRecovery(
                  local: ref.read(chatLocalDataSourceProvider),
                  pending: ref.read(pendingMessageQueueProvider),
                  fileExists: ref.read(mediaFileRuntimeProvider).fileExists,
                  sendPolicy: MessageSendPolicy(
                    context: messageSendPolicyContextForSpace(space),
                  ),
                ).recover(
                  spaceId: space.spaceId,
                  userId: userId,
                  startedBefore: recoveryStartedBefore,
                );
                recoveredIdentityKeys.add(identityKey);
              } catch (error) {
                AppDiagnostics.instance.warning(
                  'chat.pending.recovery',
                  'startup recovery failed',
                  context: {
                    'spaceId': space.spaceId,
                    'userId': userId,
                    'error': error.toString(),
                  },
                );
              }
            }
            if (!isCurrent()) return;
            await _flushPendingMessages(dio, space.spaceId, ref);
            if (!isCurrent()) return;
            await ref
                .read(conversationsProvider(space.spaceId).notifier)
                .flushPendingReadReceipts();
          },
        );
      },
    );
  }

  void startSync({bool rerunIfRunning = false}) {
    unawaited(synchronizeCurrentIdentity(rerunIfRunning: rerunIfRunning)
        .catchError((Object error) {
      if (disposed) return;
      AppDiagnostics.instance.warning(
        'gateway.sync',
        'runtime recovery failed',
        scope: diagnosticScope,
        context: {'errorType': error.runtimeType.toString()},
      );
    }));
  }

  void recoverCurrentRuntime() {
    if (disposed) return;
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null || !ownsCurrentRuntime(space)) return;
    connectOnCurrentRoute(space);
    startSync(rerunIfRunning: true);
  }

  var observedRouteRevision = SiteLineManager.instance.routeRevision;
  void onSiteLineChanged() {
    if (observedRouteRevision == SiteLineManager.instance.routeRevision) return;
    observedRouteRevision = SiteLineManager.instance.routeRevision;
    recoverCurrentRuntime();
  }

  SiteLineManager.instance.addListener(onSiteLineChanged);

  // Close the gap between the HTTP catch-up and a live Hub connection.
  service.onConnected = () => synchronizeCurrentIdentity(rerunIfRunning: true);

  // 监听空间变化
  ref.listen(accountRuntimeCurrentSpaceProvider, (prev, next) {
    if (next != null && ownsCurrentRuntime(next)) {
      // 取消旧事件订阅
      subscription?.cancel();
      // Preload the current space's notification preferences once. The
      // Gateway callback only reads this space-scoped snapshot and never owns
      // or persists settings.
      ref.read(notificationSettingsProvider(next.spaceId));

      // 订阅事件流
      subscription = service.events.listen((event) {
        if (disposed) return;
        if (ownsCurrentRuntime(ref.read(accountRuntimeCurrentSpaceProvider))) {
          _handleEvent(event, next.spaceId, handler, ref);
        }
      });
      connectOnCurrentRoute(next);
      startSync(
        rerunIfRunning: prev?.accessToken != next.accessToken ||
            prev?.spaceId != next.spaceId ||
            prev?.userId != next.userId,
      );
    } else {
      syncCoordinator.cancelPendingRetries();
      subscription?.cancel();
      subscription = null;
      unawaited(service.disconnect());
    }
  }, fireImmediately: true);

  final lifecycle = AppLifecycleListener(onResume: recoverCurrentRuntime);

  // A network restore can complete HTTP sync even if the Hub is unavailable.
  ref.listen<AsyncValue<AppConnectivityStatus>>(connectivityStatusProvider,
      (prev, next) {
    if (next.valueOrNull == AppConnectivityStatus.offline) {
      syncCoordinator.cancelPendingRetries();
    } else if (prev?.valueOrNull == AppConnectivityStatus.offline &&
        next.valueOrNull == AppConnectivityStatus.online) {
      recoverCurrentRuntime();
    }
  });

  // Provider 销毁时清理
  ref.onDispose(() {
    disposed = true;
    syncCoordinator.cancelPendingRetries();
    lifecycle.dispose();
    SiteLineManager.instance.removeListener(onSiteLineChanged);
    subscription?.cancel();
    service.dispose();
  });

  return service;
}, dependencies: [
  dioProvider,
  accountRuntimeCurrentSpaceProvider,
  accountStorageContextProvider,
  chatDraftLocalStoreProvider,
  chatDraftProvider,
  chatLocalDataSourceProvider,
  chatSyncCursorStoreProvider,
  pendingMessageQueueProvider,
  chatProvider,
  conversationsProvider,
  groupInvitationNoticeProvider,
  mediaPrefetchControllerProvider,
  spacesProvider,
  friendsProvider,
  friendRequestsProvider,
  pendingFriendRequestsProvider,
  assignedStaffProvider,
  groupDetailProvider,
  presenceProvider,
  callProvider,
  customerServiceRepositoryProvider,
  currentCustomerServiceRoleCapabilitiesProvider,
  customerServiceThreadsProvider,
  officialReceptionThreadProvider,
  customerServiceDashboardProvider,
  customerServiceReceptionStatusProvider,
  adminCustomerServiceDashboardProvider,
  adminCustomerServiceStaffStatusesProvider,
  adminCustomerServiceThreadsProvider,
  adminDirectCustomerThreadsProvider,
  adminCustomersProvider,
  adminCustomerManagementSummaryProvider,
  adminAuditLogsProvider,
  teenModeControllerProvider,
  guardianCenterControllerProvider,
  guardianMinorSnapshotProvider,
  teenRequestsControllerProvider,
  notificationSettingsProvider,
  pushNotificationServiceProvider,
  appUpdateGroupFeaturesBlockedProvider,
  mediaFileRuntimeProvider,
]);

final gatewayConnectionStatusProvider =
    StreamProvider<GatewayConnectionStatus>((ref) async* {
  final service = ref.watch(gatewayProvider);
  yield service.status;
  yield* service.statusStream;
}, dependencies: [gatewayProvider]);

// ---------------------------------------------------------------------------
// 事件处理
// ---------------------------------------------------------------------------

void _handleEvent(
  GatewayEvent event,
  String spaceId,
  GatewayEventHandler handler,
  Ref ref,
) {
  if (event is ConversationDeletedEvent) {
    unawaited(_handleConversationDeleted(event, spaceId, ref));
  } else if (event is MessageUpdatedEvent) {
    handler.onMessageUpdated(
      event.data,
      spaceId: spaceId,
      onMessage: (spaceId, conversationId, message) {
        final conversationType = _conversationTypeFromGatewayData(event.data) ??
            _resolveConversationType(ref, spaceId, conversationId) ??
            ConversationType.direct;
        ref
            .read(chatProvider((
              spaceId,
              conversationId,
              conversationType == ConversationType.group,
            )).notifier)
            .updateLinkPreview(message);
        AppDiagnostics.instance.info(
          'gateway.msg',
          'message_updated',
          context: {
            'spaceId': spaceId,
            'conversationId': conversationId,
            'messageId': message.messageId,
            'messageType': message.type.name,
            'linkPreviewVersion': message.body.link?.previewVersion,
            'linkPreviewStatus': message.body.link?.previewStatus.name,
          },
        );
      },
    );
  } else if (event is NewMessageEvent) {
    bool? projectedIsSelf;
    handler.onNewMessage(
      event.data,
      spaceId: spaceId,
      onMessage: (spaceId, conversationId, message) {
        AppDiagnostics.instance.info(
          'gateway.msg',
          'new_message',
          context: {
            'spaceId': spaceId,
            'conversationId': conversationId,
            'messageId': message.messageId,
            'clientMsgId': message.clientMsgId,
            'messageType': message.type.name,
            'conversationSeq': message.conversationSeq,
          },
        );
        final pushedConversationType =
            _conversationTypeFromGatewayData(event.data);
        final fallbackType = pushedConversationType ??
            _resolveConversationType(ref, spaceId, conversationId) ??
            ConversationType.direct;
        final isKnownCustomerServiceConversation =
            _isCustomerServiceConversation(ref, conversationId, fallbackType);
        final currentUserId =
            ref.read(accountRuntimeCurrentSpaceProvider)?.userId;
        final isSelf = _isSelfGatewayMessage(
              event.data,
              message,
              currentUserId,
            ) ||
            _isActiveLocalSelfEcho(
              ref,
              spaceId: spaceId,
              conversationId: conversationId,
              fallbackType: fallbackType,
              message: message,
            );
        projectedIsSelf = isSelf;
        final normalizedMessage = isSelf && !message.isSelf
            ? message.copyWith(isSelf: true)
            : message;
        if (fallbackType == ConversationType.group &&
            normalizedMessage.type == MessageType.event &&
            currentUserId != null) {
          ref.read(groupInvitationNoticeProvider.notifier).receiveLiveMessage(
                spaceId: spaceId,
                userId: currentUserId,
                type: fallbackType,
                message: normalizedMessage,
              );
        }
        final customerServiceCapabilities =
            ref.read(currentCustomerServiceRoleCapabilitiesProvider);
        final canUseCustomerServiceReception =
            customerServiceCapabilities.canUseStaffEndpoints;
        final customerServiceThreads =
            ref.read(customerServiceThreadsProvider).valueOrNull;
        final customerServiceScopeKey =
            _customerServiceReminderScopeKeyForCurrentSpace(ref);
        final indexedCustomerServiceThreads = customerServiceScopeKey == null
            ? const <CustomerServiceThreadIdentity>[]
            : ref
                .read(
                  customerServiceThreadIdentityIndexProvider(
                    customerServiceScopeKey,
                  ),
                )
                .identities;
        final customerServiceMessage = adaptCustomerServiceGatewayMessage(
          payload: event.data,
          message: message,
          currentUserId: currentUserId,
          knownThreads: [
            ...indexedCustomerServiceThreads,
            for (final thread in [
              ...?customerServiceThreads?.queueItems,
              ...?customerServiceThreads?.activeItems,
            ])
              CustomerServiceThreadIdentity(
                threadType: thread.threadType,
                threadId: thread.threadId,
                conversationId: thread.conversationId,
              ),
          ],
        );
        final canOpenCustomerServiceThread = canOpenCustomerServiceThreadRoute(
          capabilities: customerServiceCapabilities,
          threadType: customerServiceMessage?.threadType,
          threadId: customerServiceMessage?.threadId,
        );
        final isCustomerServiceConversation = customerServiceMessage != null ||
            isKnownCustomerServiceConversation;
        if (customerServiceMessage != null && canUseCustomerServiceReception) {
          if (!customerServiceMessage.isSelf &&
              customerServiceMessage.kind ==
                  CustomerServiceIncomingItemKind.message &&
              customerServiceScopeKey != null) {
            ref
                .read(
                  customerServiceTypingPreviewProvider(
                    customerServiceScopeKey,
                  ).notifier,
                )
                .clear(
                  threadType: customerServiceMessage.threadType,
                  threadId: customerServiceMessage.threadId,
                  conversationId: customerServiceMessage.conversationId,
                );
          }
          final space = ref.read(accountRuntimeCurrentSpaceProvider);
          if (space != null) {
            final scopeKey = customerServiceReminderScopeKey(
              spaceId: space.spaceId,
              userId: space.userId,
            );
            _rememberCustomerServiceThreadIdentity(
              ref,
              CustomerServiceThreadIdentity(
                threadType: customerServiceMessage.threadType,
                threadId: customerServiceMessage.threadId,
                conversationId: customerServiceMessage.conversationId,
              ),
            );
            ref
                .read(customerServiceUnreadLedgerProvider(scopeKey).notifier)
                .record(customerServiceMessage);
            AppDiagnostics.instance.info(
              'gateway.customer_service',
              'message_projected',
              context: {
                'spaceId': space.spaceId,
                'conversationId': customerServiceMessage.conversationId,
                'threadId': customerServiceMessage.threadId,
                'threadType': customerServiceMessage.threadType,
                'messageId': customerServiceMessage.messageId,
                'isSelf': customerServiceMessage.isSelf,
                'kind': customerServiceMessage.kind.name,
              },
            );
          }
          _refreshCustomerServiceWorkbench(ref);
        } else if (isCustomerServiceConversation) {
          _refreshCustomerServiceWorkbench(ref);
        }
        unawaited(_showGatewayMessageNotificationIfAllowed(
          ref: ref,
          spaceId: spaceId,
          conversationId: conversationId,
          activeConversationId: ref.read(activeChatConversationProvider),
          fallbackType: fallbackType,
          message: message,
          data: event.data,
          currentUserId: currentUserId,
          isSelf: customerServiceMessage?.isSelf ?? isSelf,
          isTimelineEvent: customerServiceMessage?.kind ==
                  CustomerServiceIncomingItemKind.timelineEvent ||
              message.type == MessageType.event,
          customerServiceMessage:
              canOpenCustomerServiceThread ? customerServiceMessage : null,
        ));
        // 写入 SQLite 本地事实源，并从同一条消息派生会话摘要（fire-and-forget）。
        unawaited(Future<void>.microtask(() async {
          final local = ref.read(chatLocalDataSourceProvider);
          await local.upsertMessage(
            spaceId,
            conversationId,
            normalizedMessage,
          );
          unawaited(
            ref
                .read(mediaPrefetchControllerProvider(spaceId))
                .prefetchMessage(normalizedMessage),
          );
          if (isCustomerServiceConversation) {
            await local.deleteConversation(spaceId, conversationId);
          } else {
            await local.updateConversationSummaryFromMessage(
              spaceId,
              conversationId: conversationId,
              fallbackType: fallbackType,
              message: normalizedMessage,
              isSelf: isSelf,
            );
          }
        }));
        appendGatewayMessageToKnownChat(
          ref,
          spaceId,
          conversationId,
          normalizedMessage,
          conversationType: pushedConversationType,
        );
        _refreshGroupDetailIfNeeded(
          ref,
          spaceId,
          conversationId,
          message,
          conversationType: pushedConversationType,
        );
      },
      onConversationUpdate: (spaceId, partial) {
        if (_isCustomerServiceConversation(
          ref,
          partial.conversationId,
          partial.type,
        )) {
          _refreshCustomerServiceWorkbench(ref);
          return;
        }
        final currentUserId =
            ref.read(accountRuntimeCurrentSpaceProvider)?.userId;
        final isSelf = projectedIsSelf ??
            (_isSelfGatewayData(event.data, currentUserId) ||
                (partial.lastMessage?.senderUserId != null &&
                    partial.lastMessage!.senderUserId == currentUserId));
        final normalizedPartial = isSelf && partial.lastMessage != null
            ? partial.copyWith(
                lastMessage: partial.lastMessage!.copyWith(isSelf: true),
              )
            : partial;
        final peerUserId = partial.type == ConversationType.direct &&
                !isSelf &&
                partial.peerUserId == null &&
                partial.lastMessage?.senderUserId.isNotEmpty == true
            ? partial.lastMessage!.senderUserId
            : null;
        ref
            .read(conversationsProvider(spaceId).notifier)
            .mergeConversationFromGateway(
              peerUserId == null
                  ? normalizedPartial
                  : normalizedPartial.copyWith(peerUserId: peerUserId),
              isSelf: isSelf,
            );
      },
    );
  } else if (event is PresenceChangedEvent) {
    ref.read(presenceProvider.notifier).updatePresence(
          event.userId,
          event.isOnline,
          event.customStatus,
        );
  } else if (event is PushNoticeEvent) {
    final accountScopeKey = ref.read(accountScopeProvider)?.scopeKey;
    if (accountScopeKey != null) {
      unawaited(ref.read(pushNotificationServiceProvider).showGatewayPushNotice(
            event.data,
            accountScopeKey: accountScopeKey,
          ));
    }
  } else if (event is SpaceNoticeEvent) {
    // 跨空间未读通知：刷新空间列表；如果是当前空间，同时刷新消息会话，
    // 保证空间切换页和消息页用同一套普通 IM 未读口径校正。
    requestSpaceUnreadSummaryRefresh(ref);
    final currentSpace = ref.read(accountRuntimeCurrentSpaceProvider);
    if (currentSpace != null &&
        _spaceNoticeTargetsCurrentSpace(event, currentSpace.spaceId)) {
      ref.invalidate(conversationsProvider(currentSpace.spaceId));
    }
  } else if (event is MessageRecalledEvent) {
    // 消息撤回：更新本地消息状态为已撤回
    _handleMessageRecalled(event, spaceId, ref);
  } else if (event is MessageReadEvent) {
    // 对端已读回执：更新对应会话里自己发的消息的已读状态
    _handleMessageRead(event, spaceId, ref);
  } else if (event is ForceLogoutEvent) {
    // 强制登出：清除 token 并跳转到登录页
    ref.read(authProvider.notifier).logout(
          reason: AuthLogoutReason.gatewaySecurityEvent,
          serverCode: event.reason,
        );
  } else if (event is CustomerServiceAssignedEvent) {
    _handleCustomerServiceAssigned(event, spaceId, ref);
  } else if (event is TempSessionAssignedEvent) {
    _rememberCustomerServiceThreadIdentity(
      ref,
      CustomerServiceThreadIdentity(
        threadType: 'temp_session',
        threadId: event.sessionId,
        conversationId: event.conversationId,
      ),
    );
    // 客服工作台相关事件：刷新会话列表（客服端）
    ref.invalidate(conversationsProvider(spaceId));
    _refreshCustomerServiceWorkbench(ref);
  } else if (event is TempSessionClosedEvent) {
    final scopeKey = _customerServiceReminderScopeKeyForCurrentSpace(ref);
    if (scopeKey != null) {
      ref.read(customerServiceTypingPreviewProvider(scopeKey).notifier).clear(
            threadType: 'temp_session',
            threadId: event.sessionId,
            conversationId: '',
          );
    }
    ref.invalidate(conversationsProvider(spaceId));
    _refreshCustomerServiceWorkbench(ref);
  } else if (event is TempSessionRatedEvent) {
    // 客服工作台相关事件：刷新会话列表（客服端）
    ref.invalidate(conversationsProvider(spaceId));
    _refreshCustomerServiceWorkbench(ref);
  } else if (event is CustomerServiceThreadTransferredEvent) {
    _rememberCustomerServiceThreadIdentity(
      ref,
      CustomerServiceThreadIdentity(
        threadType: event.threadType,
        threadId: event.threadId,
        conversationId: event.conversationId,
      ),
    );
    final currentUserId =
        ref.read(accountRuntimeCurrentSpaceProvider)?.userId ?? '';
    ref.read(customerServiceTransferNoticeProvider.notifier).apply(
          threadType: event.threadType,
          threadId: event.threadId,
          conversationId: event.conversationId,
          customerUserId: event.customerUserId,
          fromStaffUserId: event.fromStaffUserId,
          toStaffUserId: event.toStaffUserId,
          reason: event.reason,
          recipientRole: event.recipientRole,
          currentStaffUserId: currentUserId,
          transferredAt: event.transferredAt,
        );
    ref.invalidate(conversationsProvider(spaceId));
    _refreshCustomerServiceWorkbench(ref);
  } else if (event is CustomerServiceTypingEvent) {
    final scopeKey = _customerServiceReminderScopeKeyForCurrentSpace(ref);
    if (scopeKey != null) {
      ref.read(customerServiceTypingPreviewProvider(scopeKey).notifier).apply(
            threadType: event.threadType,
            threadId: event.threadId,
            conversationId: event.conversationId,
            isTyping: event.isTyping,
            preview: event.preview,
            senderRole: event.senderRole,
            senderUserId: event.senderUserId,
            at: event.at,
          );
    }
    _refreshCustomerServiceWorkbench(ref);
  } else if (event is TenantJoinRequestReviewedEvent) {
    // 加入申请被拒绝：刷新空间列表（用户可能需要重新申请）
    ref.invalidate(spacesProvider);
  } else if (event is FriendRequestChangedEvent) {
    final identity = ref.read(accountRuntimeCurrentSpaceProvider);
    if (identity?.spaceId == spaceId && identity!.userId.trim().isNotEmpty) {
      unawaited(
        _handleFriendRequestChanged(
          event,
          ref,
          eventSpaceId: spaceId,
          eventUserId: identity.userId,
        ),
      );
    }
  } else if (event is CustomerServiceStatusChangedEvent) {
    _handleCustomerServiceStatusChanged(event, ref);
  } else if (event is CustomerServiceSlaEvent) {
    _handleCustomerServiceSla(event, ref);
  } else if (event is FriendProfileUpdatedEvent) {
    _handleFriendProfileUpdated(event, ref);
  } else if (event is TeenModeRealtimeEvent) {
    _handleTeenModeRealtime(event, spaceId, ref);
  } else if (event is VoiceCallIncomingEvent) {
    final accountScopeKey = ref.read(accountScopeProvider)?.scopeKey;
    if (accountScopeKey != null) {
      unawaited(ref
          .read(pushNotificationServiceProvider)
          .showIncomingCallNotification(
            accountScopeKey: accountScopeKey,
            callId: event.callId,
            callerUserId: event.callerUserId,
            callerDisplayName: event.callerDisplayName,
            relayUrl: event.relayUrl,
            mediaMode: event.mediaMode,
          ));
    }
    ref.read(callProvider.notifier).receiveIncomingCall(
          callId: event.callId,
          callerUserId: event.callerUserId,
          callerDisplayName: event.callerDisplayName,
          relayUrl: event.relayUrl,
          mediaMode: event.mediaMode,
          callerVideoProfile: event.callerVideoProfile,
        );
  }
}

void _handleTeenModeRealtime(
  TeenModeRealtimeEvent event,
  String spaceId,
  Ref ref,
) {
  final plan = TeenModeRealtimeRefreshPlan.forEvent(
    event.name,
    approved: event.data['approved'] == true,
  );
  if (plan.refreshGuardianCenter) {
    ref.invalidate(guardianCenterControllerProvider);
  }
  if (plan.refreshGuardianMinorSnapshots) {
    ref.invalidate(guardianMinorSnapshotProvider);
  }
  if (plan.refreshRequests) {
    ref.invalidate(teenRequestsControllerProvider);
  }
  if (plan.refreshProfile) {
    unawaited(
      ref
          .read(teenModeControllerProvider.notifier)
          .refresh()
          .catchError((_) {}),
    );
  }
  if (plan.refreshSession) {
    unawaited(
      ref
          .read(teenModeControllerProvider.notifier)
          .refreshSession()
          .catchError((_) {}),
    );
  }
  if (plan.refreshFriendsAfterApprovedReplay) {
    ref.invalidate(friendsProvider);
    ref.invalidate(conversationsProvider(spaceId));
  }
}

Future<void> _handleConversationDeleted(
  ConversationDeletedEvent event,
  String spaceId,
  Ref ref,
) async {
  final identity = ref.read(accountRuntimeCurrentSpaceProvider);
  if (identity?.spaceId != spaceId || identity?.userId != event.userId) return;
  if (event.tenantId.isNotEmpty && event.tenantId != spaceId) return;

  await ref.read(conversationsProvider(spaceId).notifier).applyClearWatermark(
        event.conversationId,
        clearedSeq: event.clearedSeq,
        removeConversation: true,
      );
  try {
    await ref.read(chatDraftLocalStoreProvider).saveDraft(
          spaceId: spaceId,
          userId: event.userId,
          conversationId: event.conversationId,
          text: '',
        );
  } catch (_) {}
  try {
    await ref.read(pendingMessageQueueProvider).removeConversation(
          spaceId: spaceId,
          userId: event.userId,
          conversationId: event.conversationId,
        );
  } catch (_) {
    // The explicit deletion tombstone remains authoritative. flushAll drops
    // queued records created before it, so a transient Hive failure cannot
    // resurrect deleted history.
  }
  ref.invalidate(
      chatDraftProvider((spaceId, event.userId, event.conversationId)));
  ref.invalidate(chatProvider((spaceId, event.conversationId, false)));
  ref.invalidate(chatProvider((spaceId, event.conversationId, true)));
}

bool _spaceNoticeTargetsCurrentSpace(
  SpaceNoticeEvent event,
  String currentSpaceId,
) {
  final noticeSpaceId =
      event.sourceSpaceType == 1 ? 'personal' : event.sourceTenantId;
  return noticeSpaceId == currentSpaceId;
}

void _handleMessageRead(
  MessageReadEvent event,
  String spaceId,
  Ref ref,
) {
  AppDiagnostics.instance.info(
    'gateway.msg',
    'read',
    context: {
      'spaceId': spaceId,
      'conversationId': event.conversationId,
      'userId': event.userId,
      'readSeq': event.readSeq,
    },
  );

  final currentUserId = ref.read(accountRuntimeCurrentSpaceProvider)?.userId;
  final officialReception =
      ref.read(officialReceptionThreadProvider(event.conversationId));
  if (officialReception != null) {
    if (event.userId != officialReception.officialUserId &&
        event.userId != currentUserId) {
      ref
          .read(chatProvider((spaceId, event.conversationId, false)).notifier)
          .updatePeerReadSeq(event.userId, event.readSeq);
    }
    return;
  }
  if (event.userId == currentUserId) {
    unawaited(
      ref
          .read(conversationsProvider(spaceId).notifier)
          .applyReadSeqLocally(event.conversationId, event.readSeq),
    );
    return;
  }

  final conversationType =
      _resolveConversationType(ref, spaceId, event.conversationId);
  final isCustomerServiceConversation = conversationType != null &&
      _isCustomerServiceConversation(
        ref,
        event.conversationId,
        conversationType,
      );
  if (conversationType != ConversationType.direct &&
      !isCustomerServiceConversation) {
    return;
  }

  // 对端已读回执：只更新私聊或客服线程里自己发的消息；群聊人数以服务端详情接口为准。
  _updateChatIfKnown(ref, spaceId, event.conversationId, (notifier) {
    notifier.updatePeerReadSeq(event.userId, event.readSeq);
  });
  final selfUserId = currentUserId;
  if (selfUserId != null && selfUserId.isNotEmpty && event.readSeq > 0) {
    unawaited(Future<void>.microtask(() async {
      try {
        await ref.read(chatLocalDataSourceProvider).markOwnMessagesReadByPeer(
              spaceId,
              event.conversationId,
              currentUserId: selfUserId,
              readSeq: event.readSeq,
            );
      } catch (_) {}
    }));
  }
}

// ---------------------------------------------------------------------------
// 客服归属变更处理
// ---------------------------------------------------------------------------

void _handleCustomerServiceAssigned(
  CustomerServiceAssignedEvent event,
  String spaceId,
  Ref ref,
) {
  // 1. 刷新归属客服信息（客户视角）
  ref.invalidate(assignedStaffProvider);

  // 2. 刷新好友列表（新客服会自动建立好友关系）
  ref.invalidate(friendsProvider);

  // 3. 如果转移了会话（transferConversation=true），刷新会话列表
  if (event.transferConversation) {
    ref.invalidate(conversationsProvider(spaceId));
  }

  _refreshCustomerServiceWorkbench(ref);
}

Future<void> _handleFriendRequestChanged(
  FriendRequestChangedEvent event,
  Ref ref, {
  required String eventSpaceId,
  required String eventUserId,
}) async {
  bool isCurrentIdentity() {
    final current = ref.read(accountRuntimeCurrentSpaceProvider);
    return current?.spaceId == eventSpaceId && current?.userId == eventUserId;
  }

  if (!isCurrentIdentity()) return;
  AppDiagnostics.instance.info(
    'gateway.friend',
    'request_changed',
    context: {
      'requestId': event.requestId,
      'status': event.status,
      'eventName': event.eventName,
      'spaceId': eventSpaceId,
    },
  );
  final applicationHandler = FriendRequestResultApplicationHandler(
    isCurrentScope: isCurrentIdentity,
    readRequests: () =>
        ref.read(friendRequestsProvider).valueOrNull ?? const [],
    refreshRequests: () async {
      final _ = await ref.refresh(friendRequestsProvider.future);
    },
    invalidatePendingRequests: () =>
        ref.invalidate(pendingFriendRequestsProvider),
    readFriends: () => ref.read(friendsProvider).valueOrNull ?? const [],
    refreshFriends: (peerUserId) async {
      if (peerUserId.isNotEmpty) {
        await ref
            .read(friendsProvider.notifier)
            .refreshUntilContains(peerUserId);
      } else {
        await ref.read(friendsProvider.notifier).refresh();
      }
    },
    showResultNotification: (requestId, status) {
      final accountScopeKey = ref.read(accountScopeProvider)?.scopeKey;
      if (accountScopeKey == null) return Future<void>.value();
      return ref
          .read(pushNotificationServiceProvider)
          .showFriendRequestResultNotification(
            accountScopeKey: accountScopeKey,
            requestId: requestId,
            status: status.wireValue,
            spaceId: eventSpaceId,
          );
    },
    ensureAcceptanceConversation: (draft) =>
        ensureFriendAcceptanceConversationFromProvider(
      ref,
      draft,
      expectedSpaceId: eventSpaceId,
      expectedUserId: eventUserId,
    ),
    invalidateConversationList: () =>
        ref.invalidate(conversationsProvider(eventSpaceId)),
    diagnostic: (name, context) => AppDiagnostics.instance.warning(
      'gateway.friend',
      name,
      context: context,
    ),
  );
  await applicationHandler.handle(
    signal: FriendRequestResultSignal(
      requestId: event.requestId,
      status: FriendRequestStatus.fromWire(event.status),
      eventName: event.eventName,
      autoAccepted: event.autoAccepted,
      peerUserId: event.peerUserId,
      peerDisplayName: event.peerDisplayName,
      peerAvatarUrl: event.peerAvatarUrl,
      requestMessage: event.requestMessage,
    ),
    currentUserId: eventUserId,
  );
}

void _handleCustomerServiceStatusChanged(
  CustomerServiceStatusChangedEvent event,
  Ref ref,
) {
  AppDiagnostics.instance.info(
    'gateway.customer_service',
    'status_changed',
    context: {
      'staffUserId': event.staffUserId,
      'serviceStatus': event.serviceStatus,
      'queueAcceptEnabled': event.queueAcceptEnabled,
      'eventName': event.eventName,
    },
  );
  _refreshCustomerServiceWorkbench(ref);
}

void _handleCustomerServiceSla(
  CustomerServiceSlaEvent event,
  Ref ref,
) {
  AppDiagnostics.instance.info(
    'gateway.customer_service',
    'sla',
    context: {
      'threadId': event.threadId,
      'riskLevel': event.riskLevel,
      'eventName': event.eventName,
    },
  );
  _refreshCustomerServiceWorkbench(ref);
}

void _handleFriendProfileUpdated(
  FriendProfileUpdatedEvent event,
  Ref ref,
) {
  AppDiagnostics.instance.info(
    'gateway.friend',
    'profile_updated',
    context: {
      'friendUserId': event.friendUserId,
    },
  );
  ref.invalidate(friendsProvider);
}

void _refreshCustomerServiceWorkbench(Ref ref) {
  final space = ref.read(accountRuntimeCurrentSpaceProvider);
  if (space == null || !space.isEmployee) return;
  final capabilities = ref.read(currentCustomerServiceRoleCapabilitiesProvider);

  if (capabilities.canUseStaffEndpoints) {
    ref.invalidate(customerServiceReceptionStatusProvider);
    ref.invalidate(customerServiceThreadsProvider);
    ref.invalidate(customerServiceDashboardProvider);
  }

  if (capabilities.canUseManagementReadonly) {
    ref.invalidate(adminCustomerServiceDashboardProvider);
    ref.invalidate(adminCustomerServiceStaffStatusesProvider);
    ref.invalidate(adminCustomerServiceThreadsProvider);
    ref.invalidate(adminDirectCustomerThreadsProvider);
    ref.invalidate(adminCustomersProvider);
    ref.invalidate(adminCustomerManagementSummaryProvider);
    ref.invalidate(adminAuditLogsProvider);
  }
}

String? _customerServiceReminderScopeKeyForCurrentSpace(Ref ref) {
  final space = ref.read(accountRuntimeCurrentSpaceProvider);
  if (space == null) return null;
  return customerServiceReminderScopeKey(
    spaceId: space.spaceId,
    userId: space.userId,
  );
}

void _rememberCustomerServiceThreadIdentity(
  Ref ref,
  CustomerServiceThreadIdentity identity,
) {
  final scopeKey = _customerServiceReminderScopeKeyForCurrentSpace(ref);
  if (scopeKey == null) return;
  ref
      .read(customerServiceThreadIdentityIndexProvider(scopeKey).notifier)
      .remember(identity);
}

// ---------------------------------------------------------------------------
// 消息撤回处理
// ---------------------------------------------------------------------------

void _handleMessageRecalled(
  MessageRecalledEvent event,
  String spaceId,
  Ref ref,
) {
  AppDiagnostics.instance.info(
    'gateway.msg',
    'recalled',
    context: {
      'spaceId': spaceId,
      'conversationId': event.conversationId,
      'messageId': event.messageId,
      'conversationSeq': event.conversationSeq,
      'operatorUserId': event.operatorUserId,
      'silent': event.silent,
    },
  );
  // 客服静默撤回：所有客户端直接移除消息，不展示撤回占位。
  final convId = event.conversationId;
  if (event.silent) {
    _updateChatIfKnown(ref, spaceId, convId, (notifier) {
      notifier.deleteMessageLocally(event.messageId);
    });
    Future.microtask(() async {
      try {
        final local = ref.read(chatLocalDataSourceProvider);
        await local.deleteMessage(spaceId, convId, event.messageId);
      } catch (_) {}
    });
    return;
  }
  // 普通撤回：更新 chatProvider 内存中的消息状态为已撤回。
  _updateChatIfKnown(ref, spaceId, convId, (notifier) {
    notifier.markRecalled(event.messageId);
  });
  // 同步更新本地 SQLite
  Future.microtask(() async {
    try {
      final local = ref.read(chatLocalDataSourceProvider);
      await local.markMessageRecalled(spaceId, convId, event.messageId);
    } catch (_) {}
  });
}

// ---------------------------------------------------------------------------
// /sync 补齐离线消息
// ---------------------------------------------------------------------------

@visibleForTesting
Future<bool> syncGatewayMessages(
  Dio dio,
  String spaceId,
  String userId,
  Ref ref, {
  required bool Function() isActive,
  bool retryOnTransientFailure = false,
}) async {
  const pageLimit = 200;
  const maxPages = 8;
  final storage = ref.read(accountStorageContextProvider);
  final routeRevision = SiteLineManager.instance.routeRevision;
  bool isCurrent() {
    if (!isActive() ||
        storage == null ||
        !identical(storage, ref.read(accountStorageContextProvider)) ||
        routeRevision != SiteLineManager.instance.routeRevision) {
      return false;
    }
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    return storage.scope.ownsSpace(space) &&
        space?.spaceId == spaceId &&
        space?.userId.trim() == userId;
  }

  int? sinceSeq;
  int? statusCode;
  String? serverCode;
  String? requestId;
  String? conversationId;
  int? nextSinceSeq;
  var stage = 'read_cursor';
  try {
    if (!isCurrent()) return false;
    final cursorStore = ref.read(chatSyncCursorStoreProvider);
    final local = ref.read(chatLocalDataSourceProvider);
    sinceSeq = cursorStore.read(spaceId: spaceId, userId: userId);

    for (var pageNumber = 1; pageNumber <= maxPages; pageNumber++) {
      stage = 'request';
      statusCode = null;
      serverCode = null;
      requestId = null;
      conversationId = null;
      nextSinceSeq = null;
      final response = await dio.get<Map<String, dynamic>>(
        '/api/client/v1/sync',
        queryParameters: {
          if (sinceSeq != null) 'sinceSeq': sinceSeq,
          'limit': pageLimit,
        },
      );
      if (!isCurrent()) return false;

      stage = 'decode';
      statusCode = response.statusCode;
      final body = response.data;
      serverCode = body?['code']?.toString();
      requestId = body?['requestId']?.toString();
      if (serverCode != 'OK') {
        throw const FormatException('Sync did not return a success response');
      }
      final page = GatewaySyncPageModel.fromJson(
        body?['data'],
        currentUserId: userId,
        sinceSeq: sinceSeq,
      );
      nextSinceSeq = page.nextSinceSeq;

      var conversationChanged = false;
      for (final watermark in page.clearWatermarks) {
        stage = 'apply_watermark';
        conversationId = watermark.conversationId;
        final previous = local
            .getConfirmedConversationDeletionState(spaceId, conversationId)
            ?.deletedThroughSeq;
        if (previous != null && previous >= watermark.clearedSeq) continue;
        await ref
            .read(conversationsProvider(spaceId).notifier)
            .applyClearWatermark(
              conversationId,
              clearedSeq: watermark.clearedSeq,
              removeConversation: false,
            );
        if (!isCurrent()) return false;
        ref.invalidate(chatProvider((spaceId, conversationId, false)));
        ref.invalidate(chatProvider((spaceId, conversationId, true)));
        conversationChanged = true;
      }

      for (final item in page.conversations) {
        stage = 'apply_conversation';
        final id = item.conversationId;
        conversationId = id;
        final type =
            item.conversationType ?? _resolveConversationType(ref, spaceId, id);
        final fallbackType = type ?? ConversationType.direct;
        if (_isCustomerServiceConversation(ref, id, fallbackType)) {
          await local.deleteConversation(spaceId, id);
          if (!isCurrent()) return false;
          for (final message in item.messages) {
            appendGatewayMessageToKnownChat(
              ref,
              spaceId,
              id,
              message,
              conversationType: fallbackType,
            );
          }
          _refreshCustomerServiceWorkbench(ref);
          continue;
        }

        final committed = await local.applySyncedConversation(
          spaceId,
          conversationId: id,
          fallbackType: fallbackType,
          messages: item.messages,
          lastReadSeq: item.lastReadSeq,
          currentUserId: userId,
        );
        if (!isCurrent()) return false;

        stage = 'project_conversation';
        if (committed.conversation != null) conversationChanged = true;
        if (committed.messages.isNotEmpty) {
          for (final notifier in _gatewayChatNotifiers(
            ref,
            spaceId,
            id,
            conversationType: type,
            initializedOnly: true,
          )) {
            ref.read(notifier).mergePersistedMessages(committed.messages);
          }
          for (final message in committed.messages) {
            _refreshGroupDetailIfNeeded(
              ref,
              spaceId,
              id,
              message,
              conversationType: type,
            );
          }
        }
      }

      if (!isCurrent()) return false;
      conversationId = null;
      stage = 'commit_cursor';
      if (conversationChanged) ref.invalidate(conversationsProvider(spaceId));
      if (!page.canCommitCursor) {
        throw const FormatException('Invalid or non-advancing sync cursor');
      }
      if (nextSinceSeq != null) {
        await cursorStore.write(
          spaceId: spaceId,
          userId: userId,
          sinceSeq: nextSinceSeq,
        );
      }
      if (!isCurrent()) return false;
      AppDiagnostics.instance.info(
        'gateway.sync',
        'page committed',
        context: {
          'spaceId': spaceId,
          'userId': userId,
          'stage': 'commit_cursor',
          'requestId': requestId,
          'sinceSeq': sinceSeq,
          'nextSinceSeq': nextSinceSeq,
          'page': pageNumber,
          'conversationCount': page.conversations.length,
          'messageCount': page.messageCount,
        },
      );
      if (page.messageCount < pageLimit) return true;
      sinceSeq = nextSinceSeq;
    }
    AppDiagnostics.instance.warning(
      'gateway.sync',
      'page limit reached before catch-up completed',
      context: {'spaceId': spaceId, 'userId': userId, 'sinceSeq': sinceSeq},
    );
    if (retryOnTransientFailure) {
      throw const GatewaySyncTemporarilyUnavailable();
    }
    return false;
  } on GatewaySyncTemporarilyUnavailable {
    rethrow;
  } catch (error) {
    if (!isCurrent()) return false;
    if (error is DioException) {
      statusCode = error.response?.statusCode;
      final body = error.response?.data;
      if (body is Map<String, dynamic>) {
        serverCode = body['code']?.toString();
        requestId = body['requestId']?.toString();
      }
    }
    AppDiagnostics.instance.warning(
      'gateway.sync',
      'failed',
      context: {
        'spaceId': spaceId,
        'userId': userId,
        'conversationId': conversationId,
        'sinceSeq': sinceSeq,
        'nextSinceSeq': nextSinceSeq,
        'stage': stage,
        'statusCode': statusCode,
        'serverCode': serverCode,
        'requestId': requestId,
        'errorType': error.runtimeType.toString(),
      },
    );
    if (retryOnTransientFailure &&
        stage == 'request' &&
        error is DioException &&
        _isTransientSyncFailure(error)) {
      throw const GatewaySyncTemporarilyUnavailable();
    }
    // Only flush pending sends after the offline stream has caught up.
    return false;
  }
}

bool _isTransientSyncFailure(DioException error) {
  final statusCode = error.response?.statusCode;
  if (statusCode == 408 ||
      (statusCode != null && statusCode >= 500 && statusCode < 600)) {
    return true;
  }
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError =>
      true,
    _ => false,
  };
}

Future<void> _flushPendingMessages(Dio dio, String spaceId, Ref ref) async {
  try {
    final pending = ref.read(pendingMessageQueueProvider);
    final userId = ref.read(accountRuntimeCurrentSpaceProvider)?.userId ?? '';
    final before = await pending.getAll(spaceId: spaceId, userId: userId);
    if (before.isEmpty) return;
    final local = ref.read(chatLocalDataSourceProvider);
    final defaultRepository = ChatRepositoryImpl(
      remote: ChatRemoteDataSourceImpl(dio),
      local: local,
      spaceId: spaceId,
    );
    await pending.flushAll(
      defaultRepository,
      spaceId: spaceId,
      userId: userId,
      repositoryForMessage: (message) {
        final threadType = message.threadType?.trim();
        final threadId = message.threadId?.trim();
        if (threadType != null &&
            threadType.isNotEmpty &&
            threadId != null &&
            threadId.isNotEmpty) {
          return CustomerServiceChatRepositoryAdapter(
            customerServiceRepository:
                ref.read(customerServiceRepositoryProvider),
            mediaRemote: ChatRemoteDataSourceImpl(dio),
            resolveReceptionBeforeSend: true,
            threadType: threadType,
            threadId: threadId,
            senderUserId:
                ref.read(accountRuntimeCurrentSpaceProvider)?.userId ?? '',
          );
        }
        return defaultRepository;
      },
      onMessageResent: (pendingMessage, sent) async {
        final confirmed = OutgoingMessagePolicy.confirm(
          message: sent,
          clientMsgId: pendingMessage.clientMsgId,
          currentUserId: userId,
          mentions: pendingMessage.mentions,
        );
        await local.upsertMessage(
          spaceId,
          pendingMessage.conversationId,
          confirmed,
        );
        appendGatewayMessageToKnownChat(
          ref,
          spaceId,
          pendingMessage.conversationId,
          confirmed,
        );
      },
      isAlreadyConfirmed: (pendingMessage) async {
        return await local.findConfirmedMessageByClientMsgId(
              spaceId,
              pendingMessage.conversationId,
              pendingMessage.clientMsgId,
            ) !=
            null;
      },
      onAttemptStarted: (pendingMessage) async {
        final current = await _findLocalPendingMessage(local, pendingMessage);
        if (current == null || current.status.isServerUsable) return;
        final retrying = current.copyWith(
          status: MessageStatus.sending,
          localUploadState: const MessageLocalUploadState(
            status: MessageLocalUploadStatus.sending,
            phase: MessageLocalUploadPhase.sending,
          ),
        );
        await local.upsertMessage(
          spaceId,
          pendingMessage.conversationId,
          retrying,
        );
        appendGatewayMessageToKnownChat(
          ref,
          spaceId,
          pendingMessage.conversationId,
          retrying,
        );
      },
      onAttemptFailed: (pendingMessage, error, exhausted) async {
        final current = await _findLocalPendingMessage(local, pendingMessage);
        if (current == null || current.status.isServerUsable) return;
        final failure = mapTeenModeAwareMessageSendFailure(error);
        final failed = current.copyWith(
          status: failure.awaitsServerReplay
              ? MessageStatus.awaitingApproval
              : failure.shouldMarkRejected
                  ? MessageStatus.rejected
                  : MessageStatus.failed,
          failureReason: failure.displayReason,
          localUploadState: failure.awaitsServerReplay
              ? null
              : MessageLocalUploadState(
                  status: MessageLocalUploadStatus.failed,
                  phase: MessageLocalUploadPhase.failed,
                  error: failure.displayReason,
                ),
          clearLocalUploadState: failure.awaitsServerReplay,
        );
        await local.upsertMessage(
          spaceId,
          pendingMessage.conversationId,
          failed,
        );
        appendGatewayMessageToKnownChat(
          ref,
          spaceId,
          pendingMessage.conversationId,
          failed,
        );
      },
      onReconciliationFailed: (pendingMessage, sent, error) async {
        final confirmed = await local.findConfirmedMessageByClientMsgId(
          spaceId,
          pendingMessage.conversationId,
          pendingMessage.clientMsgId,
        );
        if (confirmed != null) {
          appendGatewayMessageToKnownChat(
            ref,
            spaceId,
            pendingMessage.conversationId,
            confirmed,
          );
          return;
        }
        final current = await _findLocalPendingMessage(local, pendingMessage);
        if (current == null || current.status.isServerUsable) return;
        final unresolved = current.copyWith(
          status: MessageStatus.failed,
          failureReason: localConfirmationPendingFailureReason,
          localUploadState: const MessageLocalUploadState(
            status: MessageLocalUploadStatus.failed,
            phase: MessageLocalUploadPhase.failed,
            error: localConfirmationPendingFailureReason,
          ),
        );
        await local.upsertMessage(
          spaceId,
          pendingMessage.conversationId,
          unresolved,
        );
        appendGatewayMessageToKnownChat(
          ref,
          spaceId,
          pendingMessage.conversationId,
          unresolved,
        );
      },
      failureMapper: mapTeenModeAwareMessageSendFailure,
      localFileExists: ref.read(mediaFileRuntimeProvider).fileExists,
    );
    final after = await pending.getAll(spaceId: spaceId, userId: userId);
    AppDiagnostics.instance.info(
      'chat.pending',
      'flushed',
      context: {
        'spaceId': spaceId,
        'before': before.length,
        'after': after.length,
      },
    );
  } catch (error) {
    AppDiagnostics.instance.warning(
      'chat.pending',
      'flush failed',
      context: {
        'spaceId': spaceId,
        'error': error.toString(),
      },
    );
  }
}

Future<Message?> _findLocalPendingMessage(
  ChatLocalDataSource local,
  PendingMessage pending,
) async {
  final messages = await local.getMessages(
    pending.spaceId,
    pending.conversationId,
  );
  for (final message in messages.reversed) {
    if (message.clientMsgId == pending.clientMsgId ||
        message.messageId == pending.clientMsgId) {
      return message;
    }
  }
  return null;
}

/// Delivers through the existing timeline reducer even before its directory
/// entry is available. Missing routing metadata must never create a guessed
/// direct/group timeline; only already initialized instances can be reused.
void appendGatewayMessageToKnownChat(
  Ref ref,
  String spaceId,
  String conversationId,
  Message message, {
  ConversationType? conversationType,
}) {
  final space = ref.read(accountRuntimeCurrentSpaceProvider);
  if (space == null ||
      space.spaceId != spaceId ||
      message.conversationId != conversationId) {
    return;
  }
  for (final notifier in _gatewayChatNotifiers(
    ref,
    spaceId,
    conversationId,
    conversationType: conversationType,
    initializedOnly: false,
  )) {
    try {
      ref.read(notifier).appendMessage(message);
    } catch (_) {}
  }
}

Iterable<ProviderListenable<ChatNotifier>> _gatewayChatNotifiers(
  Ref ref,
  String spaceId,
  String conversationId, {
  required ConversationType? conversationType,
  required bool initializedOnly,
}) sync* {
  final resolvedType = conversationType ??
      _resolveConversationType(ref, spaceId, conversationId);
  final routes = resolvedType == null
      ? const [false, true]
      : [_isGroupConversationType(resolvedType)];
  for (final isGroup in routes) {
    final timeline = chatProvider((spaceId, conversationId, isGroup));
    if (initializedOnly || resolvedType == null) {
      // exists() also sees ancestor runtime elements. Reuse only those owned
      // by the current account container.
      final initializedHere = ref.exists(timeline) &&
          ref.container
              .getAllProviderElements()
              .any((element) => element.origin == timeline);
      if (!initializedHere) continue;
    }
    yield timeline.notifier;
  }
}

ConversationType? _resolveConversationType(
  Ref ref,
  String spaceId,
  String conversationId,
) {
  return ref
      .read(conversationsProvider(spaceId))
      .valueOrNull
      ?.where((c) => c.conversationId == conversationId)
      .firstOrNull
      ?.type;
}

bool _isGroupConversationType(ConversationType type) {
  return type == ConversationType.group || type == ConversationType.tempSession;
}

bool _isCustomerServiceConversation(
  Ref ref,
  String conversationId,
  ConversationType type,
) {
  if (type == ConversationType.tempSession) return true;

  final threads = ref.read(customerServiceThreadsProvider).valueOrNull;
  if (threads == null) return false;

  return threads.queueItems.any((thread) =>
          thread.isTempSession && thread.conversationId == conversationId) ||
      threads.activeItems.any((thread) =>
          thread.isTempSession && thread.conversationId == conversationId);
}

ConversationType? _conversationTypeFromGatewayData(Map<String, dynamic> data) {
  final records = _gatewayCandidateRecords(data);
  final hasTempSessionIdentity = records.any((record) {
    return const [
      'sessionId',
      'session_id',
      'tempSessionId',
      'visitorSessionId',
    ].any((key) => _gatewayString(record[key])?.isNotEmpty == true);
  });
  final rawValues = <String?>[
    for (final record in records) ...[
      _gatewayString(record['threadType']),
      _gatewayString(record['thread_type']),
      _gatewayString(record['conversationType']),
      _gatewayString(record['conversation_type']),
      _gatewayString(record['sourceType']),
      _gatewayString(record['source_type']),
      _gatewayString(record['targetModule']),
      _gatewayString(record['target_module']),
      _gatewayString(record['channel']),
      _gatewayString(record['type']),
    ],
  ];
  final hasCustomerServiceMarker = rawValues.any((value) {
    final normalized = _normalizeGatewayType(value);
    return const {
      'temp_session',
      'widget',
      'customer_service',
      'online_service',
      'onlineservice',
      'service_queue',
    }.contains(normalized);
  });
  if (hasTempSessionIdentity || hasCustomerServiceMarker) {
    return ConversationType.tempSession;
  }
  final raw = rawValues.firstWhere(
    (value) => value != null && value.trim().isNotEmpty,
    orElse: () => null,
  );
  if (raw == null || raw.isEmpty) return null;
  return ConversationModel.parseType(raw);
}

String _normalizeGatewayType(String? value) =>
    (value ?? '').trim().toLowerCase().replaceAll('-', '_');

List<Map<String, dynamic>> _gatewayCandidateRecords(
  Map<String, dynamic> data,
) {
  return [
    data,
    if (_gatewayMap(data['message']) case final record?) record,
    if (_gatewayMap(data['msg']) case final record?) record,
    if (_gatewayMap(data['thread']) case final record?) record,
    if (_gatewayMap(data['tempSession']) case final record?) record,
    if (_gatewayMap(data['temp_session']) case final record?) record,
    if (_gatewayMap(data['conversation']) case final record?) record,
    if (_gatewayMap(data['chat']) case final record?) record,
  ];
}

String? _gatewayString(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

Map<String, dynamic>? _gatewayMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}

String? _gatewayNotificationTitle(Map<String, dynamic> data) {
  for (final key in const [
    'conversationTitle',
    'title',
    'senderDisplayName',
    'senderName',
  ]) {
    final value = data[key]?.toString();
    if (value != null && value.isNotEmpty) return value;
  }
  return null;
}

Future<void> _showGatewayMessageNotificationIfAllowed({
  required Ref ref,
  required String spaceId,
  required String conversationId,
  required String? activeConversationId,
  required ConversationType fallbackType,
  required Message message,
  required Map<String, dynamic> data,
  required String? currentUserId,
  required bool isSelf,
  required bool isTimelineEvent,
  CustomerServiceIncomingMessage? customerServiceMessage,
}) async {
  if (ref.read(accountStorageContextProvider) != null &&
      !await ref
          .read(chatLocalDataSourceProvider)
          .isConversationDirectoryVisible(spaceId, conversationId)) {
    return;
  }
  if (fallbackType == ConversationType.group &&
      ref.read(appUpdateGroupFeaturesBlockedProvider)) {
    AppDiagnostics.instance.info(
      'notification.message',
      'suppressed_for_release_face',
      context: {
        'spaceId': spaceId,
        'conversationId': conversationId,
        'messageId': message.messageId,
      },
    );
    return;
  }
  if (fallbackType != ConversationType.tempSession &&
      message.conversationSeq > 0) {
    final deletedThroughSeq = await ref
        .read(chatLocalDataSourceProvider)
        .getConversationDeletionBoundary(spaceId, conversationId);
    if (deletedThroughSeq != null &&
        message.conversationSeq <= deletedThroughSeq) {
      return;
    }
  }
  final isMuted =
      await _isGatewayConversationMuted(ref, spaceId, conversationId);
  final visibility = _currentChatAppVisibility();
  final settings = ref.read(notificationSettingsProvider(spaceId)).valueOrNull;
  final decision = decideSystemMessageNotification(
    visibility: visibility,
    incomingConversationId: conversationId,
    activeConversationId: activeConversationId,
    isMuted: isMuted,
    isSelf: isSelf,
    isSilentMessage: message.type == MessageType.callLog,
    isTimelineEvent: isTimelineEvent,
    nativePushOwnsBackground:
        ref.read(mobilePushTokenProvider).ownsBackgroundMessageNotifications,
    preferences: MessageNotificationPreferences(
      globalMute: settings?.globalMute ?? false,
      dndStartTime: settings?.dndStartTime,
      dndEndTime: settings?.dndEndTime,
      soundEnabled: settings?.soundEnabled ?? true,
      vibrationEnabled: settings?.vibrationEnabled ?? true,
      previewEnabled: settings?.previewEnabled ?? true,
    ),
  );
  if (!decision.shouldShow) {
    AppDiagnostics.instance.info(
      'notification.message',
      'suppressed',
      context: {
        'spaceId': spaceId,
        'conversationId': conversationId,
        'messageId': message.messageId,
        'reason': decision.suppressionReason?.name,
        'visibility': visibility.name,
      },
    );
    return;
  }
  final mentionKind = mentionReminderKindForMessage(
    mentions: message.mentions,
    currentUserId: currentUserId,
    isGroup: fallbackType == ConversationType.group,
    isSelf: isSelf,
  );
  try {
    final accountScopeKey = ref.read(accountScopeProvider)?.scopeKey;
    if (accountScopeKey == null) return;
    final notificationTitle =
        decision.previewEnabled ? _gatewayNotificationTitle(data) : null;
    await ref
        .read(pushNotificationServiceProvider)
        .showGatewayMessageNotification(
          accountScopeKey: accountScopeKey,
          conversationId: conversationId,
          isGroup: fallbackType == ConversationType.group,
          messageId: message.messageId,
          messageType: GatewayEventHandler.messageTypeToApiString(message.type),
          title: notificationTitle,
          body: decision.previewEnabled ? message.body.text : null,
          peerUserId: message.senderUserId,
          mentionKind: switch (mentionKind) {
            MentionReminderKind.me => 'me',
            MentionReminderKind.all => 'all',
            MentionReminderKind.none => null,
          },
          senderDisplayName: decision.previewEnabled
              ? _gatewayString(data['senderDisplayName']) ??
                  _gatewayString(data['senderName'])
              : null,
          previewEnabled: decision.previewEnabled,
          playSound: decision.soundEnabled,
          enableVibration: decision.vibrationEnabled,
          customerServiceThreadType: customerServiceMessage?.threadType,
          customerServiceThreadId: customerServiceMessage?.threadId,
        );
    AppDiagnostics.instance.info(
      'notification.message',
      'display_requested',
      context: {
        'spaceId': spaceId,
        'conversationId': conversationId,
        'messageId': message.messageId,
        'visibility': visibility.name,
      },
    );
  } catch (error) {
    AppDiagnostics.instance.warning(
      'notification.message',
      'display_failed',
      context: {
        'spaceId': spaceId,
        'conversationId': conversationId,
        'messageId': message.messageId,
        'error': error.toString(),
      },
    );
  }
}

ChatAppVisibility _currentChatAppVisibility() {
  return switch (WidgetsBinding.instance.lifecycleState) {
    AppLifecycleState.resumed ||
    AppLifecycleState.inactive =>
      ChatAppVisibility.foreground,
    AppLifecycleState.hidden ||
    AppLifecycleState.paused ||
    AppLifecycleState.detached ||
    null =>
      ChatAppVisibility.background,
  };
}

Future<bool> _isGatewayConversationMuted(
  Ref ref,
  String spaceId,
  String conversationId,
) async {
  try {
    final conversations =
        await ref.read(chatLocalDataSourceProvider).getConversations(spaceId);
    return conversations
            .where(
                (conversation) => conversation.conversationId == conversationId)
            .firstOrNull
            ?.isMuted ==
        true;
  } catch (_) {
    return false;
  }
}

bool _isSelfGatewayMessage(
  Map<String, dynamic> data,
  Message message,
  String? currentUserId,
) {
  if (message.operatorUserId != null) {
    return _sameIdentity(message.operatorUserId, currentUserId);
  }
  if (message.isSelf) return true;
  if (_sameIdentity(message.senderUserId, currentUserId)) return true;
  return _isSelfGatewayData(data, currentUserId);
}

bool _isActiveLocalSelfEcho(
  Ref ref, {
  required String spaceId,
  required String conversationId,
  required ConversationType fallbackType,
  required Message message,
}) {
  if (message.operatorUserId != null &&
      message.operatorUserId !=
          ref.read(accountRuntimeCurrentSpaceProvider)?.userId) {
    return false;
  }
  final clientMsgId = message.clientMsgId?.trim();
  if (clientMsgId == null || clientMsgId.isEmpty) return false;
  final localMessages = ref
      .read(
        chatProvider((
          spaceId,
          conversationId,
          fallbackType == ConversationType.group,
        )),
      )
      .valueOrNull;
  if (localMessages == null) return false;
  return localMessages.any(
    (local) =>
        local.clientMsgId == clientMsgId &&
        (local.isSelf || local.status == MessageStatus.sending),
  );
}

bool _isSelfGatewayData(Map<String, dynamic> data, String? currentUserId) {
  final records = _gatewayCandidateRecords(data);
  final isCustomerServiceLike =
      _conversationTypeFromGatewayData(data) == ConversationType.tempSession;
  for (final record in records) {
    if (_gatewayBool(record['isSelf']) || _gatewayBool(record['isMine'])) {
      return true;
    }
    final roleText = [
      _gatewayString(record['senderRole']),
      _gatewayString(record['sender_role']),
      _gatewayString(record['senderType']),
      _gatewayString(record['sender_type']),
      _gatewayString(record['authorType']),
      _gatewayString(record['author_type']),
      _gatewayString(record['fromType']),
      _gatewayString(record['from_type']),
      _gatewayString(record['role']),
    ].map(_normalizeGatewayType).join('|');
    final visitorRole = const {
      'visitor',
      'guest',
      'end_user',
      'widget',
    }.any(roleText.contains);
    final customerRole = isCustomerServiceLike &&
        const {
          'customer',
          'client',
          'user',
        }.any(roleText.contains);
    if (visitorRole || customerRole) {
      return false;
    }
    final direction =
        _normalizeGatewayType(_gatewayString(record['direction']));
    if (const {'in', 'incoming', 'inbound', 'received', 'receive'}
        .contains(direction)) {
      return false;
    }
    if (const {'out', 'outgoing', 'sent', 'self'}.contains(direction)) {
      return true;
    }
    for (final key in const [
      'senderUserId',
      'senderId',
      'fromUserId',
      'userId',
      'senderPlatformUserId',
      'platformUserId',
      'senderLppId',
      'lppId',
    ]) {
      if (_sameIdentity(_gatewayString(record[key]), currentUserId)) {
        return true;
      }
    }
  }
  return false;
}

bool _sameIdentity(String? left, String? right) {
  final a = left?.trim().toLowerCase();
  final b = right?.trim().toLowerCase();
  return a != null && a.isNotEmpty && b != null && b.isNotEmpty && a == b;
}

bool _gatewayBool(Object? value) {
  return value == true || value == 'true' || value == 1 || value == '1';
}

void _refreshGroupDetailIfNeeded(
  Ref ref,
  String spaceId,
  String conversationId,
  Message message, {
  ConversationType? conversationType,
}) {
  final resolvedType = conversationType ??
      _resolveConversationType(ref, spaceId, conversationId);
  if (resolvedType != ConversationType.group) return;
  if (message.type != MessageType.event) return;

  unawaited(
    ref.read(groupDetailProvider(conversationId).notifier).refresh(),
  );
}

void _updateChatIfKnown(
  Ref ref,
  String spaceId,
  String conversationId,
  void Function(ChatNotifier notifier) update,
) {
  final type = _resolveConversationType(ref, spaceId, conversationId);
  final keys = <(String, String, bool)>[];
  if (type != null) {
    keys.add((spaceId, conversationId, _isGroupConversationType(type)));
    if (type == ConversationType.tempSession) {
      keys.add((spaceId, conversationId, false));
    }
  } else {
    keys.add((spaceId, conversationId, false));
  }
  for (final key in keys) {
    try {
      update(ref.read(chatProvider(key).notifier));
    } catch (_) {}
  }
}
