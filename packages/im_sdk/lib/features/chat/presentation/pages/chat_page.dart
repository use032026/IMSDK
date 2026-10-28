import 'dart:async';
import 'package:im_sdk/features/customer_service/domain/official_reception_policy.dart';

import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';
import 'package:im_sdk/core/platform/local_file.dart';
import 'package:im_sdk/core/platform/local_image_dimensions.dart';
import 'package:im_sdk/core/platform/local_video_poster.dart';
import 'package:im_sdk/core/platform/media_saver.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:im_sdk/core/widgets/identity_badge.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/features/call/presentation/models/call_route_intent.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/chat/data/mappers/group_read_receipts_mapper.dart';
import 'package:im_sdk/features/chat/data/repositories/translation_repository.dart';
import 'package:im_sdk/features/chat/application/auto_translation_coordinator.dart';
import 'package:im_sdk/features/chat/application/providers/draft_translation_selection_provider.dart';
import 'package:im_sdk/features/chat/application/providers/auto_translate_preferences_provider.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/services/auto_translation_policy.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_peer_identity.dart';
import 'package:im_sdk/features/chat/domain/services/audio_player_service.dart';
import 'package:im_sdk/features/chat/domain/services/chat_quick_reply_policy.dart';
import 'package:im_sdk/features/chat/domain/services/call_log_policy.dart';
import 'package:im_sdk/features/chat/domain/entities/media_local_file.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/entities/scheduled_message.dart';
import 'package:im_sdk/features/chat/domain/services/mention_reminder.dart';
import 'package:im_sdk/features/chat/domain/services/message_read_receipt_service.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_failure.dart';
import 'package:im_sdk/features/chat/domain/services/message_transport_retry_policy.dart';
import 'package:im_sdk/features/chat/domain/services/scheduled_message_input_panel_policy.dart';
import 'package:im_sdk/features/chat/domain/services/scheduled_message_time_policy.dart';
import 'package:im_sdk/features/chat/domain/usecases/message_badge_count.dart';
import 'package:im_sdk/features/chat/presentation/controllers/conversation_actions_controller.dart';
import 'package:im_sdk/features/chat/presentation/controllers/customer_service_chat_controller.dart';
import 'package:im_sdk/features/chat/presentation/controllers/direct_chat_entry_controller.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_open_controller.dart';
import 'package:im_sdk/features/chat/presentation/controllers/message_translation_controller.dart';
import 'package:im_sdk/features/chat/presentation/controllers/outgoing_media_localizer.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_draft_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/group_member_nickname_preference_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/active_chat_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/link_message_provider.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_settings_page.dart'
    show groupDetailProvider, groupMembersProvider;
import 'package:im_sdk/features/chat/presentation/pages/favorites_page.dart'
    show favoritesProvider, favoritesSummaryProvider;
import 'package:im_sdk/features/chat/presentation/pages/image_viewer_page.dart';
import 'package:im_sdk/features/chat/presentation/models/chat_picked_media.dart';
import 'package:im_sdk/features/chat/presentation/models/call_log_display_model.dart';
import 'package:im_sdk/features/chat/presentation/models/conversation_route_policy.dart';
import 'package:im_sdk/features/chat/presentation/models/chat_send_interaction_policy.dart';
import 'package:im_sdk/features/chat/presentation/models/customer_service_chat_state_model.dart';
import 'package:im_sdk/features/chat/presentation/models/message_context_action_model.dart';
import 'package:im_sdk/features/chat/presentation/models/message_media_preview_model.dart';
import 'package:im_sdk/features/chat/presentation/models/scheduled_message_cancel_failure_policy.dart';
import 'package:im_sdk/features/chat/presentation/models/scheduled_message_input_status.dart';
import 'package:im_sdk/features/chat/presentation/widgets/chat_input_toolbar.dart';
import 'package:im_sdk/features/chat/presentation/widgets/chat_back_button.dart';
import 'package:im_sdk/features/chat/presentation/widgets/conversation_avatar.dart';
import 'package:im_sdk/features/chat/presentation/widgets/customer_service_ended_notice.dart';
import 'package:im_sdk/features/chat/presentation/widgets/marketing_toolbar.dart';
import 'package:im_sdk/features/chat/presentation/widgets/message_bubble.dart';
import 'package:im_sdk/features/chat/presentation/widgets/message_viewport_list.dart';
import 'package:im_sdk/features/chat/presentation/widgets/scheduled_message_input_status_bar.dart';
import 'package:im_sdk/features/contacts/presentation/pages/profile_page.dart';
import 'package:im_sdk/features/contacts/domain/services/profile_public_id_visibility.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/features/customer_service/application/customer_service_ai_reply_controller.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_realtime_models.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_role_capabilities.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';
import 'package:im_sdk/features/customer_service/presentation/widgets/customer_service_ai_reply_sheet.dart';
import 'package:im_sdk/features/settings/presentation/providers/chat_background_provider.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';
import 'package:im_sdk/features/space/presentation/providers/spaces_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:im_sdk/features/official_account/domain/services/official_account_menu_policy.dart';
import 'package:im_sdk/features/official_account/presentation/widgets/official_account_menu_bar.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/features/teen_mode/presentation/utils/teen_mode_ui.dart';

@visibleForTesting
bool shouldShowGroupSenderInfo({
  required bool isGroup,
  required bool isSelf,
}) {
  return isGroup && !isSelf;
}

class ChatPage extends ConsumerStatefulWidget {
  /// Restricts the embedded messenger to messaging rather than App services.
  final bool messagingOnly;
  final String conversationId;
  final bool isGroup;
  final String title;
  final String? avatarUrl;
  final String? peerUserId;
  final bool isMuted;
  final int? memberCount;
  final String? scrollToMessageId;
  final int? scrollBeforeSeq;
  final String? customerServiceThreadType;
  final String? customerServiceThreadId;
  final String? customerServiceCustomerUserId;
  final String? customerServiceVisitorId;
  final String? customerServiceSource;
  final String? customerServiceInitialStatus;
  final bool customerServiceReadOnly;

  const ChatPage({
    super.key,
    this.messagingOnly = false,
    required this.conversationId,
    this.isGroup = false,
    required this.title,
    this.avatarUrl,
    this.peerUserId,
    this.isMuted = false,
    this.memberCount,
    this.scrollToMessageId,
    this.scrollBeforeSeq,
    this.customerServiceThreadType,
    this.customerServiceThreadId,
    this.customerServiceCustomerUserId,
    this.customerServiceVisitorId,
    this.customerServiceSource,
    this.customerServiceInitialStatus,
    this.customerServiceReadOnly = false,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  static const _uuid = Uuid();

  static const PlatformMediaSaver _mediaSaver = PlatformMediaSaver();
  static const ScheduledMessageCancelFailurePolicy
      _scheduledCancelFailurePolicy = ScheduledMessageCancelFailurePolicy();

  final _scrollController = ScrollController();
  final _mediaPreviewLayoutCache = MediaPreviewLayoutCache();
  late final ActiveChatLifecycle _activeChatLifecycle;
  bool _isSending = false;
  String _spaceId = '';
  Timer? _refreshTimer;
  Timer? _groupDetailRefreshTimer;
  Timer? _groupReadReceiptAutoSyncTimer;
  Timer? _scheduledMessagesDueRefreshTimer;
  ProviderSubscription<AsyncValue<CsThreadsData>>? _customerServiceThreadsSub;
  final Set<String> _groupReadReceiptAutoSyncingMessageIds = {};
  final Set<String> _groupReadReceiptAutoSyncedKeys = {};
  final Set<String> _textToSpeechInFlightMessageIds = {};
  late final AutoTranslationCoordinator _autoTranslationCoordinator;
  final Map<String, AutoTranslationCancellation>
      _manualTranslationCancellations = {};
  List<Message> _latestAutoTranslationMessages = const [];
  List<String> _visibleMessageIds = const [];
  AutoTranslateEffectiveSetting? _latestAutoTranslationSetting;
  String _latestAutoTranslationUserId = '';
  bool _isMessageViewportScrolling = false;
  bool _autoTranslationSyncScheduled = false;
  String? _lastImmediateScheduledMessageProbeKey;
  bool _requestedScrollTarget = false;
  // 退出时上报已读的 seq（微信做法：进入立即本地清零，退出时才上报服务器）
  int? _pendingReadSeq;
  int? _initialMentionLastReadSeq;
  // 非好友/无权限发消息（MSG_MEMBER_FORBIDDEN）
  bool _notFriend = false;
  bool _customerServiceDetailLoaded = false;
  bool _isQuickTranslating = false;
  bool _isReceptionActionRunning = false;
  int _customerServiceSnapshotVersion = 0;
  bool _isCustomerServiceEndedRefreshing = false;
  bool? _customerServiceReadOnlyOverride;

  // 多选模式
  bool _multiSelectMode = false;
  final Set<String> _selectedMessages = {};

  // 上下文菜单
  String? _selectedMessageId;

  // 回复引用
  ({String id, String text, String sender})? _replyingTo;
  List<ScheduledMessage> _scheduledMessages = const [];
  bool _scheduledMessagesLoading = false;
  String? _cancelingScheduledMessageId;
  ScheduledMessage? _editingScheduledMessage;
  DateTime? _localScheduledSendAt;
  bool _resolvedIsGroup = false;
  bool _releaseFaceRedirectScheduled = false;
  String? _createdConversationId;
  String? _externalInsertText;
  int _externalInsertToken = 0;
  int _inputSurfaceDismissToken = 0;
  CsThreadDetail? _customerServiceDetail;

  bool get _isCustomerServiceThread => canOpenCustomerServiceThreadRoute(
        capabilities: ref.read(currentCustomerServiceRoleCapabilitiesProvider),
        threadType: widget.customerServiceThreadType,
        threadId: widget.customerServiceThreadId,
      );

  bool get _isReadOnlyConversation {
    final routeReadOnly =
        _customerServiceReadOnlyOverride ?? widget.customerServiceReadOnly;
    if (!_isCustomerServiceThread) return routeReadOnly;
    if (routeReadOnly) return true;
    if (!ref
        .read(currentCustomerServiceRoleCapabilitiesProvider)
        .canUseStaffEndpoints) {
      return true;
    }
    final detail = _customerServiceDetail;
    final base = _customerServiceThread();
    if (base.isOfficialReception &&
        !canOperateOfficialReception(
            inOfficial: true,
            assignedStaffUserId:
                detail?.assignedStaffUserId ?? base.assignedStaffUserId,
            userId: ref.read(currentSpaceProvider)?.userId ?? '')) {
      return true;
    }
    if (detail != null &&
        !canOperateOfficialReception(
            inOfficial: detail.isOfficialReception,
            assignedStaffUserId: detail.assignedStaffUserId,
            userId: ref.read(currentSpaceProvider)?.userId ?? '')) {
      return true;
    }
    if (detail != null && !detail.isTerminal) return false;
    return routeReadOnly;
  }

  CustomerServiceChatState get _customerServiceChatState =>
      CustomerServiceChatState.fromDetail(
        _customerServiceDetail,
        isCustomerServiceThread: _isCustomerServiceThread,
        readOnly: _isReadOnlyConversation ||
            (_isCustomerServiceThread &&
                _customerServiceThread().isOfficialReception &&
                _customerServiceDetail == null),
      );

  bool get _customerServiceRequiresManualEntry {
    if (_customerServiceDetail == null) {
      return false;
    }
    return _customerServiceChatState.requiresManualEntry;
  }

  bool get _canClaimCustomerServiceThread {
    if (!_isCustomerServiceThread || _customerServiceThreadEnded) return false;
    if (!ref
        .read(currentCustomerServiceRoleCapabilitiesProvider)
        .canControlReception) {
      return false;
    }
    return _customerServiceThreadForDisplay().isQueued;
  }

  ScheduledMessage? get _visibleScheduledMessage {
    const policy = ScheduledMessageInputPanelPolicy();
    return policy.visibleTask(_scheduledMessages);
  }

  ScheduledMessageInputStatus get _scheduledInputStatus {
    final editing = _editingScheduledMessage;
    if (editing != null) {
      return ScheduledMessageInputStatus.editingTask(editing);
    }
    final visibleTask = _visibleScheduledMessage;
    if (visibleTask != null) {
      return ScheduledMessageInputStatus.pendingTask(
        visibleTask,
        canceling:
            _cancelingScheduledMessageId == visibleTask.scheduledMessageId,
      );
    }
    final localScheduledAt = _localScheduledSendAt;
    if (localScheduledAt != null) {
      return ScheduledMessageInputStatus.localDraft(localScheduledAt);
    }
    return const ScheduledMessageInputStatus.none();
  }

  String get _activeConversationId =>
      _createdConversationId ?? widget.conversationId;

  String get _autoTranslateScopeKey => conversationAutoTranslateScopeKey(
        spaceId: _spaceId,
        conversationId: _activeConversationId,
      );

  CustomerServiceActionReplyGate get _customerServiceActionReplyGate {
    if (!_isCustomerServiceThread ||
        _isReadOnlyConversation ||
        _customerServiceThreadEnded) {
      return CustomerServiceActionReplyGate.readonly;
    }
    return switch (_customerServiceChatState.replyGate) {
      CustomerServiceReplyGate.claim => CustomerServiceActionReplyGate.claim,
      CustomerServiceReplyGate.takeover =>
        CustomerServiceActionReplyGate.takeover,
      CustomerServiceReplyGate.open => CustomerServiceActionReplyGate.open,
    };
  }

  CustomerServiceActionPermission _customerServiceActionPermission(
    CustomerServiceAction action, {
    CustomerServiceRoleCapabilities? capabilities,
  }) {
    return customerServiceActionPermission(
      action,
      CustomerServiceActionPermissionInput(
        hasThread: _isCustomerServiceThread,
        capabilities: capabilities ??
            ref.read(currentCustomerServiceRoleCapabilitiesProvider),
        replyGate: _customerServiceActionReplyGate,
      ),
    );
  }

  CustomerServiceAiReplyTarget? _customerServiceAiReplyTarget({
    String? customerMessageId,
    CustomerServiceRoleCapabilities? capabilities,
  }) {
    final permission = _customerServiceActionPermission(
      CustomerServiceAction.reply,
      capabilities: capabilities,
    );
    return customerServiceAiReplyTarget(
      threadType: widget.customerServiceThreadType,
      threadId: widget.customerServiceThreadId,
      hasLoadedThreadDetail:
          _customerServiceDetailLoaded && _customerServiceDetail != null,
      canReply: permission.enabled && _customerServiceChatState.canReply,
      customerMessageId: customerMessageId,
    );
  }

  String _customerServiceActionDeniedText(
    CustomerServiceActionPermission permission,
  ) {
    return switch (permission.reason) {
      CustomerServiceActionReason.requiresClaim => '请先接入该会话',
      CustomerServiceActionReason.requiresTakeover => '请先人工接管该会话',
      CustomerServiceActionReason.readonly => '当前为只读会话，不能执行该操作',
      CustomerServiceActionReason.roleDenied => '当前角色不能执行该客服操作',
      CustomerServiceActionReason.noThread => '当前会话暂不可操作',
      _ => '当前状态暂不可操作',
    };
  }

  bool get _isPendingDirectChat =>
      _createdConversationId == null &&
      widget.conversationId.startsWith('pending_direct_') &&
      widget.peerUserId?.isNotEmpty == true;

  bool get _effectiveIsGroup {
    if (widget.isGroup) {
      _resolvedIsGroup = true;
      return true;
    }
    if (_resolvedIsGroup) return true;
    if (_spaceId.isEmpty) return false;
    final conversations = ref.read(conversationsProvider(_spaceId)).valueOrNull;
    final conversation = conversations
        ?.where((c) => c.conversationId == widget.conversationId)
        .firstOrNull;
    final isGroup = conversation?.type == ConversationType.group ||
        conversation?.type == ConversationType.tempSession;
    if (isGroup) {
      _resolvedIsGroup = true;
    }
    return _resolvedIsGroup;
  }

  @override
  void initState() {
    super.initState();
    _autoTranslationCoordinator = AutoTranslationCoordinator(
      executor: (message, targetLanguage, cancellation) async {
        await _translateMessage(
          message,
          targetLanguage: targetLanguage,
          showToastOnError: false,
          cancellation: cancellation,
          automatic: true,
        );
      },
    );
    _activeChatLifecycle = ActiveChatLifecycle(
      ref.read(activeChatConversationProvider.notifier),
    );
    _resolvedIsGroup = widget.isGroup;
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _markActiveChatForNotifications();
    });
    // 进入聊天页时立即本地清零未读数
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _spaceId.isEmpty) return;
      if (_isPendingDirectChat) return;
      if (_isReadOnlyConversation) return;
      if (_isCustomerServiceThread) {
        final space = ref.read(currentSpaceProvider);
        final threadId = widget.customerServiceThreadId;
        if (space != null && threadId != null && threadId.isNotEmpty) {
          final scopeKey = customerServiceReminderScopeKey(
            spaceId: space.spaceId,
            userId: space.userId,
          );
          ref
              .read(customerServiceUnreadLedgerProvider(scopeKey).notifier)
              .clear(
                threadId: threadId,
                conversationId: widget.conversationId,
              );
        }
      }
      _captureInitialMentionReadSeq();
      if (!_isCustomerServiceThread ||
          !_customerServiceThread().isOfficialReception) {
        ref.read(conversationsProvider(_spaceId).notifier).markReadLocally(
              _activeConversationId,
              isGroup: _effectiveIsGroup,
            );
      }
      // 监听消息加载完成，只有有未读时才上报已读到服务器
      ref.listenManual(
        chatProvider((_spaceId, _activeConversationId, _effectiveIsGroup)),
        (prev, next) {
          next.whenData((msgs) {
            if (msgs.isNotEmpty) {
              final maxSeq = msgs
                  .map((m) => m.conversationSeq)
                  .reduce((a, b) => a > b ? a : b);
              if (_pendingReadSeq != null && maxSeq <= _pendingReadSeq!) {
                return;
              }
              _pendingReadSeq = maxSeq;
              // 进入聊天页后立即上报已读（无论 unreadCount 是否为 0，
              // 确保服务端也清零；后台同步拉到更大 seq 时继续补报）
              if (_isCustomerServiceThread &&
                  !_customerServiceThread().isTempSession) {
                final detail = _customerServiceThreadDetailForSend();
                if (canOperateOfficialReception(
                    inOfficial: detail.isOfficialReception,
                    assignedStaffUserId: detail.assignedStaffUserId,
                    userId: ref.read(currentSpaceProvider)?.userId ?? '')) {
                  unawaited(ref
                      .read(customerServiceRepositoryProvider)
                      .markThreadRead(
                          _customerServiceThreadForDisplay(), maxSeq)
                      .catchError((Object error) {
                    _pendingReadSeq = null;
                    return 0;
                  }));
                } else {
                  _pendingReadSeq = null;
                }
              } else {
                ref
                    .read(conversationsProvider(_spaceId).notifier)
                    .markRead(_activeConversationId, _effectiveIsGroup, maxSeq);
              }
              if (_effectiveIsGroup) {
                _scheduleGroupReadReceiptAutoSync(msgs);
              }
            }
          });
        },
        fireImmediately: true,
      );
      if (_isCustomerServiceThread) {
        _customerServiceThreadsSub ??= ref.listenManual(
          customerServiceThreadsProvider,
          (_, next) {
            next.whenData((data) {
              final threadId = widget.customerServiceThreadId;
              if (threadId == null || threadId.isEmpty) return;
              final thread = [
                ...data.queueItems,
                ...data.activeItems,
              ].where((item) => item.threadId == threadId).firstOrNull;
              if (thread?.isOfficialReception == true &&
                  !thread!.isQueued &&
                  thread.assignedStaffUserId !=
                      ref.read(currentSpaceProvider)?.userId) {
                _markCustomerServiceThreadEnded(
                    status: 'transferred', showToast: false);
              }
              if (thread?.isTerminal == true) {
                _markCustomerServiceThreadEnded(
                  status: thread!.status,
                  showToast: !_isReadOnlyConversation,
                );
              }
            });
          },
        );
      }
    });
  }

  void _markActiveChatForNotifications() {
    _activeChatLifecycle.markActive(_activeConversationId);
  }

  void _captureInitialMentionReadSeq() {
    if (_initialMentionLastReadSeq != null) return;
    final conversation = ref
        .read(conversationsProvider(_spaceId))
        .valueOrNull
        ?.where((c) => c.conversationId == _activeConversationId)
        .firstOrNull;
    if (conversation == null || conversation.unreadCount <= 0) return;
    _initialMentionLastReadSeq = conversation.lastReadSeq;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final space = ref.read(currentSpaceProvider);
    final nextSpaceId = space?.spaceId ?? '';
    final spaceChanged = nextSpaceId != _spaceId;
    _spaceId = nextSpaceId;
    if (spaceChanged && _spaceId.isNotEmpty) {
      unawaited(_refreshScheduledMessages());
    }
    if (_isCustomerServiceThread && !_customerServiceDetailLoaded) {
      _customerServiceDetailLoaded = true;
      unawaited(_syncCustomerServiceThread(showError: false));
    }
    // 启动轮询（只启动一次，作为 WebSocket 兜底；客服会话更短，避免漏推后长时间空白）
    _refreshTimer ??= Timer.periodic(
        _isCustomerServiceThread
            ? const Duration(seconds: 10)
            : const Duration(minutes: 5), (_) {
      if (mounted && _spaceId.isNotEmpty) {
        if (_isCustomerServiceThread && !_customerServiceThreadEnded) {
          unawaited(_syncCustomerServiceThread(showError: false));
        }
        ref.invalidate(conversationsProvider(_spaceId));
      }
    });
  }

  CsThread _customerServiceThread() {
    final official =
        ref.read(officialReceptionThreadProvider(widget.conversationId));
    if (official != null) return official;
    return CsThread(
      threadType: widget.customerServiceThreadType ?? 'direct_customer',
      threadId: widget.customerServiceThreadId ?? '',
      conversationId: widget.conversationId,
      status: widget.customerServiceInitialStatus ?? 'active',
      title: widget.title,
      avatarUrl: widget.avatarUrl,
      source: widget.customerServiceSource,
    );
  }

  CsThreadDetail _customerServiceThreadDetailForSend() {
    final detail = _customerServiceDetail;
    if (detail != null) return detail;
    final base = _customerServiceThread();
    return CsThreadDetail(
      handoffMode: base.handoffMode,
      officialUserId: base.officialUserId,
      assignedStaffUserId: base.assignedStaffUserId,
      threadType: base.threadType,
      threadId: base.threadId,
      conversationId: base.conversationId,
      status: base.status,
      title: base.title,
      avatarUrl: base.avatarUrl,
      customerUserId: base.customerUserId,
      visitorId: base.visitorId,
      source: base.source,
    );
  }

  CsThread _customerServiceThreadForDisplay() {
    final detail = _customerServiceDetail;
    final base = _customerServiceThread();
    return detail == null ? base : base.fromDetail(detail);
  }

  String? _usableCustomerServiceTitle(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty || text.startsWith('历史会话')) {
      return null;
    }
    return text;
  }

  CustomerServiceTypingPreview? _typingPreviewFor(
    Map<String, CustomerServiceTypingPreview> previews, {
    required String threadType,
    required String threadId,
    required String conversationId,
  }) {
    final normalizedType = threadType.trim().replaceAll('-', '_');
    final effectiveType =
        normalizedType.isEmpty ? 'temp_session' : normalizedType;
    final keys = [
      '$effectiveType:${threadId.trim()}',
      '$effectiveType:${conversationId.trim()}',
    ];
    for (final key in keys) {
      final preview = previews[key];
      if (preview != null) return preview;
    }
    return null;
  }

  String _customerServiceSubtitle(
    CustomerProfileCard? profile,
    CsThread? thread,
  ) {
    final parts = <String>[
      if (_isReadOnlyConversation) '历史会话',
      if (!_isReadOnlyConversation) '在线客服',
      profile?.identity.source ??
          thread?.source ??
          widget.customerServiceSource ??
          '',
      if (_isReadOnlyConversation)
        CustomerServiceChatState.statusLabelFor(thread?.status),
    ]
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty && item != '--')
        .toList(growable: false);
    return parts.isEmpty ? '在线客服' : parts.join(' · ');
  }

  bool get _customerServiceThreadEnded => _customerServiceChatState.ended;

  Future<void> _handleCustomerServiceEndedRefresh() async {
    if (_isCustomerServiceEndedRefreshing) return;
    setState(() => _isCustomerServiceEndedRefreshing = true);
    try {
      await _syncCustomerServiceThread(showError: true);
      if (!mounted) return;
      if (!_customerServiceThreadEnded) {
        ref.invalidate(customerServiceThreadsProvider);
        ref.invalidate(customerServiceDashboardProvider);
        AppToast.success(context, '会话已恢复，可继续接待');
      } else {
        AppToast.info(context,
            _customerServiceChatState.transferred ? '当前会话由其他客服接待' : '客户尚未继续对话');
      }
    } finally {
      if (mounted) {
        setState(() => _isCustomerServiceEndedRefreshing = false);
      }
    }
  }

  void _markCustomerServiceThreadEnded({
    String status = 'closed',
    bool showToast = true,
  }) {
    if (!_isCustomerServiceThread) return;
    final current = _customerServiceDetail;
    final base = _customerServiceThread();
    final ended = (current ??
            CsThreadDetail(
              threadType: base.threadType,
              threadId: base.threadId,
              conversationId: base.conversationId,
              status: base.status,
              title: base.title,
              avatarUrl: base.avatarUrl,
              customerUserId: base.customerUserId,
              visitorId: base.visitorId,
              assignedStaffUserId: base.assignedStaffUserId,
              assignedStaffDisplayName: base.assignedStaffDisplayName,
              source: base.source,
              assignedAt: base.assignedAt,
              currentResponderType: base.currentResponderType,
              aiStatus: base.aiStatus,
            ))
        .copyWith(status: status);
    if (!mounted) {
      _customerServiceDetail = ended;
      return;
    }
    final wasEnded = _customerServiceThreadEnded;
    setState(() => _customerServiceDetail = ended);
    if (!wasEnded && showToast) {
      AppToast.info(context, '会话已结束');
    }
  }

  bool _shouldShowReceptionBar(CsThread? thread) {
    if (!_isCustomerServiceThread || _isReadOnlyConversation) return false;
    if (thread == null || thread.isQueued || thread.isTerminal) return false;
    return thread.isAiHandled || thread.isManualHandled;
  }

  Future<void> _syncCustomerServiceThread({required bool showError}) async {
    if (!_isCustomerServiceThread || _spaceId.isEmpty) return;
    final snapshotVersion = _customerServiceSnapshotVersion;
    try {
      final detail = await ref
          .read(customerServiceChatControllerProvider)
          .fetchThread(_customerServiceThread());
      if (snapshotVersion != _customerServiceSnapshotVersion) return;
      final wasEnded = _customerServiceThreadEnded;
      if (mounted) {
        setState(() => _customerServiceDetail = detail);
      }
      if (detail.isTerminal &&
          !wasEnded &&
          mounted &&
          !_isReadOnlyConversation) {
        AppToast.info(context, '会话已结束');
      }
      if (detail.messages.isEmpty) return;

      await ref.read(chatLocalDataSourceProvider).upsertMessages(
            _spaceId,
            widget.conversationId,
            detail.messages,
          );

      final notifier = ref.read(
          chatProvider((_spaceId, widget.conversationId, _effectiveIsGroup))
              .notifier);
      for (final message in detail.messages) {
        notifier.appendMessage(message);
      }
      _applyCustomerServiceReadStatus(detail, notifier);
    } catch (error) {
      final mapped = error is dio_package.DioException
          ? ErrorHandler.fromDioException(error)
          : error;
      if (mapped.toString().contains('CUSTOMER_SERVICE_DIRECT_NOT_ASSIGNED')) {
        _markCustomerServiceThreadEnded(
            status: 'transferred', showToast: false);
      }
      if (showError &&
          mounted &&
          snapshotVersion == _customerServiceSnapshotVersion) {
        AppToast.error(context, AppLocalizations.of(context).commonLoadFailed);
      }
    }
  }

  void _applyCustomerServiceReadStatus(
    CsThreadDetail detail,
    ChatNotifier notifier,
  ) {
    final directReadSeq = detail.customerLastReadSeq;
    if (directReadSeq != null && directReadSeq > 0) {
      notifier.updatePeerReadSeq(
        detail.customerUserId ?? detail.peerUserId ?? '',
        directReadSeq,
      );
      return;
    }
    final readStatus = detail.readStatus;
    if (readStatus == null) return;
    final visitorUserId = readStatus.visitorUserId;
    if (visitorUserId == null || visitorUserId.trim().isEmpty) return;
    final visitorMember = readStatus.members
        .where((member) => member.userId == visitorUserId)
        .firstOrNull;
    if (visitorMember == null || visitorMember.lastReadSeq <= 0) return;
    notifier.updatePeerReadSeq(visitorUserId, visitorMember.lastReadSeq);
  }

  Future<void> _handleCustomerServiceTakeover(CsThread thread) async {
    if (_isReceptionActionRunning) return;
    setState(() => _isReceptionActionRunning = true);
    try {
      final detail = await ref
          .read(customerServiceChatControllerProvider)
          .takeoverThread(thread);
      if (!mounted) return;
      setState(() => _customerServiceDetail = detail);
      ref.invalidate(customerServiceThreadsProvider);
      ref.invalidate(customerServiceDashboardProvider);
      AppToast.success(context, '已人工接管');
      unawaited(_syncCustomerServiceThread(showError: false));
    } catch (_) {
      if (mounted) AppToast.error(context, '接管失败，请重试');
    } finally {
      if (mounted) setState(() => _isReceptionActionRunning = false);
    }
  }

  Future<void> _handleCustomerServiceClaim(CsThread thread) async {
    if (_isReceptionActionRunning) return;
    setState(() => _isReceptionActionRunning = true);
    try {
      final detail =
          await ref.read(customerServiceChatControllerProvider).claimThread(
                thread,
              );
      if (!mounted) return;
      setState(() {
        _customerServiceDetail = detail;
        _customerServiceReadOnlyOverride = false;
      });
      ref.invalidate(customerServiceThreadsProvider);
      ref.invalidate(customerServiceDashboardProvider);
      AppToast.success(context, '已接入会话');
      unawaited(_syncCustomerServiceThread(showError: false));
    } catch (_) {
      if (mounted) AppToast.error(context, '接入失败，请重试');
    } finally {
      if (mounted) setState(() => _isReceptionActionRunning = false);
    }
  }

  Future<void> _handleCustomerServiceClose(CsThread thread) async {
    if (_isReceptionActionRunning) return;
    final permission =
        _customerServiceActionPermission(CustomerServiceAction.close);
    if (!permission.enabled) {
      AppToast.info(context, _customerServiceActionDeniedText(permission));
      return;
    }
    setState(() => _isReceptionActionRunning = true);
    try {
      final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AppAlertDialog(
              title: const Text('关闭会话'),
              content: const Text('关闭后不会删除底层聊天记录，可由服务端策略重新排队或分配。'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('关闭'),
                ),
              ],
            ),
          ) ??
          false;
      if (!confirmed || !mounted) return;
      if (_customerServiceThreadEnded) {
        AppToast.info(context, '会话已结束');
        return;
      }
      final currentPermission =
          _customerServiceActionPermission(CustomerServiceAction.close);
      if (!currentPermission.enabled) {
        AppToast.info(
            context, _customerServiceActionDeniedText(currentPermission));
        return;
      }
      final detail = await ref
          .read(customerServiceChatControllerProvider)
          .closeThread(thread, currentDetail: _customerServiceDetail);
      if (!mounted) return;
      _customerServiceSnapshotVersion++;
      setState(() => _customerServiceDetail = detail);
      ref.invalidate(customerServiceThreadsProvider);
      ref.invalidate(customerServiceDashboardProvider);
      final space = ref.read(currentSpaceProvider);
      if (space != null) {
        final scopeKey = customerServiceReminderScopeKey(
          spaceId: space.spaceId,
          userId: space.userId,
        );
        ref.read(customerServiceTypingPreviewProvider(scopeKey).notifier).clear(
              threadType: thread.threadType,
              threadId: thread.threadId,
              conversationId: thread.conversationId,
            );
      }
      AppToast.success(context, '已关闭会话');
    } catch (_) {
      if (mounted) AppToast.error(context, '关闭失败，请重试');
    } finally {
      if (mounted) setState(() => _isReceptionActionRunning = false);
    }
  }

  Future<void> _openCustomerServiceTransferSheet() async {
    final permission =
        _customerServiceActionPermission(CustomerServiceAction.transfer);
    if (!permission.enabled) {
      AppToast.info(context, _customerServiceActionDeniedText(permission));
      return;
    }
    final thread = _customerServiceThreadForDisplay();
    if (thread.threadId.trim().isEmpty) {
      AppToast.error(context, '当前会话暂不能转接');
      return;
    }
    final currentUserId = ref.read(currentSpaceProvider)?.userId ?? '';
    final members = ref.read(tenantMembersProvider).valueOrNull ?? const [];
    final targets = createCustomerServiceTransferTargets(
      members
          .map((member) => CustomerServiceStaffCandidate(
                userId: member.userId,
                displayName: member.displayName,
                avatarUrl: member.avatarUrl,
                membershipRole: member.customerTag == '客服' ? 2 : null,
              ))
          .toList(growable: false),
      currentUserIds: [
        currentUserId,
        thread.assignedStaffUserId,
      ],
    );
    if (targets.isEmpty) {
      AppToast.info(context, '暂无可转接的客服');
      return;
    }
    final result = await showModalBottomSheet<_CustomerServiceTransferResult>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CustomerServiceTransferSheet(targets: targets),
    );
    if (result == null) return;
    try {
      await ref.read(customerServiceRepositoryProvider).transferThread(
            threadType: thread.threadType,
            threadId: thread.threadId,
            toStaffUserId: result.toStaffUserId,
            reason: result.reason,
            fallbackTitle: thread.title,
            fallbackAvatarUrl: thread.avatarUrl,
          );
      ref.invalidate(customerServiceThreadsProvider);
      ref.invalidate(customerServiceDashboardProvider);
      if (!mounted) return;
      if (thread.isOfficialReception) {
        _markCustomerServiceThreadEnded(
            status: 'transferred', showToast: false);
      }
      AppToast.success(context, '已转交会话');
      unawaited(_syncCustomerServiceThread(showError: false));
    } catch (error) {
      AppDiagnostics.instance.error(
        'customer-service.transfer',
        'transfer failed',
        context: {
          'threadType': thread.threadType,
          'threadId': thread.threadId,
          'error': error.toString(),
        },
      );
      if (mounted) AppToast.error(context, '转交失败，请重试');
    }
  }

  String? get _customerProfileUserId {
    final direct = widget.customerServiceCustomerUserId?.trim();
    if (direct?.isNotEmpty == true) return direct;
    final detailCustomer = _customerServiceDetail?.customerUserId?.trim();
    if (detailCustomer?.isNotEmpty == true) return detailCustomer;
    final peer = widget.peerUserId?.trim();
    if (widget.customerServiceThreadType == 'direct_customer' &&
        peer?.isNotEmpty == true) {
      return peer;
    }
    return null;
  }

  CustomerProfileCard _fallbackCustomerProfileCard() {
    final isRegistered = _customerProfileUserId != null;
    final visitorId = widget.customerServiceVisitorId?.trim().isNotEmpty == true
        ? widget.customerServiceVisitorId!.trim()
        : _customerServiceDetail?.visitorId;
    return CustomerProfileCard(
      identity: CustomerProfileIdentity(
        customerUserId: _customerProfileUserId,
        displayName: widget.title.isNotEmpty ? widget.title : '客户',
        avatarUrl: widget.avatarUrl,
        registered: isRegistered,
        language: 'zh-CN',
        source: widget.customerServiceThreadType == 'temp_session'
            ? (widget.customerServiceSource ?? '在线客服')
            : (widget.customerServiceSource ?? '客户会话'),
      ),
      visitor: !isRegistered
          ? VisitorProfileSummary(
              visitorId: visitorId,
              locale: 'zh-CN',
            )
          : null,
    );
  }

  void _openCustomerProfileSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CustomerProfileSheet(
        customerUserId: _customerProfileUserId,
        customerServiceThreadType: widget.customerServiceThreadType,
        customerServiceThreadId: widget.customerServiceThreadId,
        fallbackCard: _fallbackCustomerProfileCard(),
      ),
    );
  }

  String? _resolveCallTargetUserId({bool logResolution = true}) {
    if (_effectiveIsGroup) return null;
    final currentUserId = ref.read(currentSpaceProvider)?.userId;

    final conversations = ref.read(conversationsProvider(_spaceId)).valueOrNull;
    final conversation = conversations
        ?.where((c) => c.conversationId == widget.conversationId)
        .firstOrNull;
    final freshPeerUserId = conversation?.peerUserId;
    if (freshPeerUserId != null &&
        freshPeerUserId.isNotEmpty &&
        freshPeerUserId != currentUserId) {
      if (logResolution) {
        debugPrint(
            '[ChatPage] call target from conversation: $freshPeerUserId, routePeer=${widget.peerUserId}');
      }
      return freshPeerUserId;
    }

    final routePeerUserId = widget.peerUserId;
    if (routePeerUserId != null &&
        routePeerUserId.isNotEmpty &&
        routePeerUserId != currentUserId) {
      if (logResolution) {
        debugPrint('[ChatPage] call target from route extra: $routePeerUserId');
      }
      return routePeerUserId;
    }

    if (logResolution) {
      debugPrint(
          '[ChatPage] call target unavailable: conversation=${widget.conversationId}, routePeer=${widget.peerUserId}, currentUser=$currentUserId');
    }
    return null;
  }

  Future<void> _startCall({required bool isVideo}) async {
    if (widget.messagingOnly) return;
    final targetUserId = _resolveCallTargetUserId();
    final currentUserId = ref.read(currentSpaceProvider)?.userId;
    if (targetUserId == null ||
        targetUserId.isEmpty ||
        targetUserId == currentUserId) {
      AppToast.error(
          context, AppLocalizations.of(context).commonOperationFailed);
      return;
    }
    final friends = ref.read(friendsProvider).valueOrNull;
    final isFriend =
        friends?.any((contact) => contact.userId == targetUserId) == true;
    if (!ref
        .read(teenModePolicyProvider)
        .canAttemptStartCall(isFriend: isFriend)) {
      AppToast.error(
        context,
        AppLocalizations.of(context).teenModeActionBlocked,
      );
      return;
    }
    if (_isPendingDirectChat) {
      try {
        await _ensureDirectConversationForSend();
      } catch (error) {
        if (!mounted) return;
        AppDiagnostics.instance.error(
          'call.start',
          'failed to create direct conversation before call',
          context: {
            'targetUserId': targetUserId,
            'error': error.toString(),
          },
        );
        AppToast.error(
          context,
          AppLocalizations.of(context).commonOperationFailed,
        );
        return;
      }
    }
    if (!mounted) return;
    context.push('/call/$targetUserId', extra: {
      freshOutgoingCallIntentKey: true,
      'isVideo': isVideo,
      'title': widget.title,
      'targetUserId': targetUserId,
      'avatarUrl': widget.avatarUrl,
    });
  }

  void _handleCallLogTap(Message message) {
    final semantic = CallLogPolicy.resolve(
      message,
      currentUserId: ref.read(currentSpaceProvider)?.userId ?? '',
    );
    if (semantic.mediaKind == CallLogMediaKind.unknown) {
      AppDiagnostics.instance.warning(
        'call_log.contract',
        'call log media mode is missing or invalid',
        context: {
          'messageId': message.messageId,
          'callId': message.body.callLog?.callId,
          'mediaMode': message.body.callLog?.mediaMode,
        },
      );
      return;
    }
    _startCall(isVideo: semantic.mediaKind == CallLogMediaKind.video);
  }

  void _scheduleGroupReadReceiptAutoSync(List<Message> messages) {
    if (!_effectiveIsGroup || _spaceId.isEmpty || messages.isEmpty) return;
    _groupReadReceiptAutoSyncTimer?.cancel();
    _groupReadReceiptAutoSyncTimer =
        Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      unawaited(_syncGroupReadReceiptSnapshots(messages));
    });
  }

  Future<void> _syncGroupReadReceiptSnapshots(List<Message> messages) async {
    if (!_effectiveIsGroup || _spaceId.isEmpty || messages.isEmpty) return;
    final currentSpace = ref.read(currentSpaceProvider);
    final currentUserId = currentSpace?.userId ?? '';
    final targets = const MessageReadReceiptService()
        .groupReadReceiptSnapshotTargets(
          messages,
          currentUserId: currentUserId,
        )
        .where((message) => !_groupReadReceiptAutoSyncedKeys.contains(
              _groupReadReceiptAutoSyncKey(message, message.readCount),
            ))
        .toList(growable: false);
    if (targets.isEmpty) return;

    var currentProfile = ref.read(currentUserProfileProvider);
    if (currentProfile == null && currentUserId.isNotEmpty) {
      await ref.read(profileProvider.notifier).loadProfile();
      if (!mounted) return;
      currentProfile = ref.read(currentUserProfileProvider);
    }

    final dio = ref.read(dioProvider);
    final notifier = ref.read(
      chatProvider((_spaceId, _activeConversationId, true)).notifier,
    );
    for (final message in targets) {
      if (_groupReadReceiptAutoSyncingMessageIds.contains(message.messageId)) {
        continue;
      }
      _groupReadReceiptAutoSyncingMessageIds.add(message.messageId);
      try {
        final resp = await dio.get<Map<String, dynamic>>(
          '/api/client/v1/groups/$_activeConversationId/read-receipts',
          queryParameters: {'messageId': message.messageId},
        );
        final receipts = parseGroupReadReceiptsPayload(
          resp.data?['data'],
          currentUser: GroupReadReceiptIdentity(
            userId: currentProfile?.userId ?? currentUserId,
            platformUserId: currentProfile?.platformUserId,
            lppId: currentProfile?.lppId,
            displayName: currentProfile?.displayName,
          ),
          messageSeq: message.conversationSeq,
        );
        notifier.syncGroupReadReceiptSnapshot(
          messageId: message.messageId,
          messageSeq: message.conversationSeq,
          readCount: receipts.readCount,
        );
        _groupReadReceiptAutoSyncedKeys
          ..add(_groupReadReceiptAutoSyncKey(message, message.readCount))
          ..add(_groupReadReceiptAutoSyncKey(message, receipts.readCount));
      } catch (_) {
        // 回执快照只是首屏修正，失败时保留本地消息并允许下次消息变更再同步。
      } finally {
        _groupReadReceiptAutoSyncingMessageIds.remove(message.messageId);
      }
    }
  }

  String _groupReadReceiptAutoSyncKey(Message message, int readCount) {
    return '${message.messageId}:${message.conversationSeq}:$readCount';
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _groupDetailRefreshTimer?.cancel();
    _groupReadReceiptAutoSyncTimer?.cancel();
    _scheduledMessagesDueRefreshTimer?.cancel();
    _customerServiceThreadsSub?.close();
    _autoTranslationCoordinator.dispose();
    for (final cancellation in _manualTranslationCancellations.values) {
      cancellation.cancel();
    }
    _manualTranslationCancellations.clear();
    _scrollController.dispose();
    // 退出时上报已读（微信做法：退出才调服务器接口）
    // 注意：dispose 里不能用 ref，用 fire-and-forget 方式在 deactivate 里处理
    super.dispose();
  }

  @override
  void deactivate() {
    // 路由退出时 Element 会先失活、后 dispose。账号切换期间如果只在
    // dispose 取消定时器，回调可能在这段窗口读取已经失活的 ProviderScope。
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _groupDetailRefreshTimer?.cancel();
    _groupDetailRefreshTimer = null;
    _groupReadReceiptAutoSyncTimer?.cancel();
    _groupReadReceiptAutoSyncTimer = null;
    _scheduledMessagesDueRefreshTimer?.cancel();
    _scheduledMessagesDueRefreshTimer = null;
    _activeChatLifecycle.deactivate({
      _activeConversationId,
      widget.conversationId,
    });
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    _activeChatLifecycle.activate(_activeConversationId);
  }

  void _onScroll() {
    // reverse: true 时，滚到 maxScrollExtent 表示到达顶部（历史消息方向）
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 80) {
      final notifier = ref.read(
          chatProvider((_spaceId, widget.conversationId, _effectiveIsGroup))
              .notifier);
      notifier.loadMore();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0); // reverse: true 时 0 是底部（最新消息）
      }
    });
  }

  void _ensureScrollTargetLoaded(List<Message> messages) {
    final targetId = widget.scrollToMessageId;
    final beforeSeq = widget.scrollBeforeSeq;
    if (_requestedScrollTarget || targetId == null || beforeSeq == null) {
      return;
    }
    if (messages.any((m) => m.messageId == targetId)) {
      _requestedScrollTarget = true;
      return;
    }
    _requestedScrollTarget = true;
    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(
              chatProvider((_spaceId, widget.conversationId, _effectiveIsGroup))
                  .notifier)
          .loadAround(beforeSeq: beforeSeq);
    });
  }

  void _handleLongPress(
      BuildContext context, Message message, Offset position) {
    if (_multiSelectMode) return;
    HapticFeedback.mediumImpact();
    final selectedMessageId = message.messageId;
    setState(() {
      _selectedMessageId = selectedMessageId;
    });

    final capabilities = messageContextCapabilities(
      message,
      currentUserId: ref.read(currentSpaceProvider)?.userId ?? '',
      allowAiReply: _customerServiceAiReplyTarget(
            customerMessageId: message.messageId,
          ) !=
          null,
    );
    final currentUserId = ref.read(currentSpaceProvider)?.userId ?? '';
    final silentRecallPermission =
        _customerServiceActionPermission(CustomerServiceAction.silentRecall);
    final canCustomerServiceSilentRecall = _isCustomerServiceThread &&
        silentRecallPermission.enabled &&
        message.status.isServerUsable &&
        !message.isRecalled &&
        canRecallReceptionMessage(message, currentUserId);

    // 构建菜单项列表
    final items = <_WxMenuItem>[
      if (capabilities.canMultiSelect)
        _WxMenuItem('multiselect', Icons.check_box_outlined,
            AppLocalizations.of(context).chatMenuMultiSelect),
      if (capabilities.canReply)
        _WxMenuItem('reply', Icons.reply_outlined,
            AppLocalizations.of(context).chatMenuReply),
      if (capabilities.canAiReply)
        const _WxMenuItem('ai_reply', Icons.auto_awesome_outlined, 'AI回复'),
      if (capabilities.canCopy)
        _WxMenuItem('copy', Icons.copy_outlined,
            AppLocalizations.of(context).chatMenuCopy),
      if (capabilities.canVoiceToText)
        _WxMenuItem('voice_to_text', Icons.text_fields_outlined,
            AppLocalizations.of(context).chatMenuVoiceToText),
      if (capabilities.canTextToSpeech)
        _WxMenuItem('text_to_speech', Icons.volume_up_outlined,
            AppLocalizations.of(context).chatMenuTextToSpeech),
      if (capabilities.canTranslate)
        _WxMenuItem('translate', Icons.translate_outlined,
            AppLocalizations.of(context).chatMenuTranslate),
      if (capabilities.canSaveToAlbum)
        const _WxMenuItem('save_album', Icons.save_alt_outlined, '保存到相册'),
      if (capabilities.canForward)
        _WxMenuItem('forward', Icons.forward_outlined,
            AppLocalizations.of(context).chatMenuForward),
      if (capabilities.canFavorite)
        _WxMenuItem('favorite', Icons.star_outline,
            AppLocalizations.of(context).chatMenuFavorite),
      if (capabilities.canRecall || canCustomerServiceSilentRecall)
        _WxMenuItem('recall', Icons.undo_outlined,
            AppLocalizations.of(context).chatMenuRecall,
            danger: true),
      if (capabilities.canDelete)
        _WxMenuItem('delete', Icons.delete_outline,
            AppLocalizations.of(context).chatMenuDelete,
            danger: true),
    ];

    // 微信风格：无暗色遮罩，菜单在长按位置附近弹出。
    showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (ctx, anim, _) => _WxMessageMenu(
        position: position,
        items: items,
        screenSize: MediaQuery.of(context).size,
      ),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(
            CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          ),
          child: child,
        ),
      ),
    ).then((value) {
      if (value == null || !mounted) return;
      _selectedMessageId = selectedMessageId;
      final messages = ref
              .read(chatProvider(
                  (_spaceId, widget.conversationId, _effectiveIsGroup)))
              .valueOrNull ??
          [];
      switch (value) {
        case 'multiselect':
          _handleEnterMultiSelect();
          break;
        case 'reply':
          _handleReply(messages);
          break;
        case 'ai_reply':
          unawaited(_handleAiReply(messages));
          break;
        case 'copy':
          unawaited(_handleCopy(messages));
          break;
        case 'translate':
          unawaited(_handleTranslate(messages));
          break;
        case 'forward':
          unawaited(_handleForward());
          break;
        case 'save_album':
          unawaited(_handleSaveToAlbum(messages));
          break;
        case 'recall':
          unawaited(_handleRecall(messages));
          break;
        case 'delete':
          unawaited(_handleDelete(messages));
          break;
        case 'voice_to_text':
          final msg = _findSelectedMessage(messages);
          if (msg != null) unawaited(_handleVoiceToText(msg));
          break;
        case 'text_to_speech':
          final msg = _findSelectedMessage(messages);
          if (msg != null) unawaited(_handleTextToSpeech(msg));
          break;
        case 'favorite':
          unawaited(_handleFavorite(messages));
          break;
      }
    });
  }

  Message? _findSelectedMessage(List<Message> messages) {
    final selectedMessageId = _selectedMessageId;
    if (selectedMessageId == null) return null;
    for (final message in messages) {
      if (message.messageId == selectedMessageId) return message;
    }
    return null;
  }

  Future<void> _handleCopy(List<Message> messages) async {
    final msg = _findSelectedMessage(messages);
    final text = msg?.body.text;
    if (text == null || text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _handleAiReply(List<Message> messages) async {
    final msg = _findSelectedMessage(messages);
    final contextText = msg?.body.text?.trim();
    final target = msg == null
        ? null
        : _customerServiceAiReplyTarget(customerMessageId: msg.messageId);
    if (contextText == null || contextText.isEmpty || target == null) return;
    final selected = await showCustomerServiceAiReplySheet(
      context,
      target: target,
      contextText: contextText,
    );
    if (selected == null || !mounted) return;
    setState(() {
      _externalInsertText = selected;
      _externalInsertToken++;
    });
  }

  Future<void> _openMessageSenderProfile({
    required String userId,
    required bool isSelf,
    required bool allowAddFriendFromGroup,
    required ProfileAccessContext accessContext,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _inputSurfaceDismissToken++);

    if (isSelf) {
      await context.push('/my-profile');
      return;
    }
    if (!mounted || userId.isEmpty) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfilePage(
          userId: userId,
          allowAddFriendFromGroup: allowAddFriendFromGroup,
          accessContext: accessContext,
        ),
      ),
    );
  }

  /// 撤回消息。普通 IM 保持 2 分钟占位撤回；客服线程使用静默撤回。
  Future<void> _handleRecall(List<Message> messages) async {
    final msg = _findSelectedMessage(messages);
    if (msg == null) return;
    final msgId = msg.messageId;
    final notifier = ref.read(
        chatProvider((_spaceId, widget.conversationId, _effectiveIsGroup))
            .notifier);

    if (_isCustomerServiceThread) {
      final permission =
          _customerServiceActionPermission(CustomerServiceAction.silentRecall);
      if (!permission.enabled ||
          !msg.status.isServerUsable ||
          msg.isRecalled ||
          !(msg.isSelf ||
              msg.senderUserId ==
                  (ref.read(currentSpaceProvider)?.userId ?? ''))) {
        AppToast.info(context, _customerServiceActionDeniedText(permission));
        return;
      }
      try {
        await ref
            .read(customerServiceRepositoryProvider)
            .recallThreadMessageSilently(msgId);
        notifier.deleteMessageLocally(msgId);
        ref.invalidate(customerServiceThreadsProvider);
        ref.invalidate(customerServiceDashboardProvider);
      } catch (error) {
        AppDiagnostics.instance.error(
          'customer-service.recall',
          'silent recall failed',
          context: {
            'conversationId': widget.conversationId,
            'messageId': msgId,
            'error': error.toString(),
          },
        );
        if (mounted) {
          AppToast.error(
              context, AppLocalizations.of(context).chatRecallFailed);
        }
      }
      return;
    }

    // 检查是否在 2 分钟内
    final elapsed = DateTime.now().difference(msg.sentAt);
    if (elapsed.inMinutes >= 2) {
      AppToast.info(context, AppLocalizations.of(context).chatRecallTimeout);
      return;
    }
    try {
      await ref
          .read(conversationActionsControllerProvider)
          .recallMessage(msgId);
      notifier.markRecalled(msgId);
      ref.invalidate(conversationsProvider(_spaceId));
    } catch (_) {
      if (mounted) {
        AppToast.error(context, AppLocalizations.of(context).chatRecallFailed);
      }
    }
  }

  Future<void> _handleDelete(List<Message> messages) async {
    final msg = _findSelectedMessage(messages);
    if (msg == null) return;
    final msgId = msg.messageId;
    final notifier = ref.read(
        chatProvider((_spaceId, widget.conversationId, _effectiveIsGroup))
            .notifier);

    if (!msg.status.isServerUsable) {
      notifier.deleteMessageLocally(msgId);
      return;
    }
    try {
      await ref
          .read(conversationActionsControllerProvider)
          .deleteMessage(msgId);
      notifier.deleteMessageLocally(msgId);
      ref.invalidate(conversationsProvider(_spaceId));
    } catch (_) {
      if (mounted) {
        AppToast.error(
            context, AppLocalizations.of(context).friendDeleteFailed);
      }
    }
  }

  Future<void> _handleFavorite(List<Message> messages) async {
    final msg = _findSelectedMessage(messages);
    if (msg == null || msg.isRecalled || !msg.status.isServerUsable) {
      return;
    }

    try {
      await ref.read(conversationActionsControllerProvider).addFavorite(
            messageId: msg.messageId,
            conversationId: msg.conversationId.isNotEmpty
                ? msg.conversationId
                : widget.conversationId,
          );
      ref.invalidate(favoritesProvider);
      ref.invalidate(favoritesSummaryProvider);
      if (mounted) {
        AppToast.success(
          context,
          AppLocalizations.of(context).chatFavoriteSuccess,
        );
      }
    } catch (_) {
      if (mounted) {
        AppToast.error(
            context, AppLocalizations.of(context).chatFavoriteFailed);
      }
    }
  }

  Future<void> _handleSaveToAlbum(List<Message> messages) async {
    final msg = _findSelectedMessage(messages);
    if (msg == null || msg.isRecalled || !msg.status.isServerUsable) {
      return;
    }
    final resource = switch (msg.type) {
      MessageType.image => msg.body.image,
      MessageType.video => msg.body.video,
      _ => null,
    };
    if (resource == null || resource.url.trim().isEmpty) return;

    try {
      final fileName = _safeGalleryFileName(resource, msg.type);
      final mimeType = resource.mimeType ?? _defaultMimeType(msg.type);
      final bytes = await ref
          .read(mediaOpenControllerProvider(_spaceId))
          .bytesForResource(resource);
      final result = await _mediaSaver.saveMedia(
        bytes: bytes,
        fileName: fileName,
        mimeType: mimeType,
        isVideo: msg.type == MessageType.video,
      );
      if (!mounted) return;
      AppToast.success(context, result.message);
    } catch (error) {
      debugPrint('[ChatPage] save media to album failed: $error');
      if (!mounted) return;
      AppToast.error(
        context,
        AppLocalizations.of(context).commonOperationFailed,
      );
    }
  }

  String _safeGalleryFileName(MediaResource resource, MessageType type) {
    final original = resource.fileName?.trim();
    final fallback =
        type == MessageType.video ? 'lpp_video.mp4' : 'lpp_image.jpg';
    final raw = original?.isNotEmpty == true ? original! : fallback;
    final sanitized = raw.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    if (p.extension(sanitized).isNotEmpty) return sanitized;
    return '$sanitized${type == MessageType.video ? '.mp4' : '.jpg'}';
  }

  String _defaultMimeType(MessageType type) {
    return type == MessageType.video ? 'video/mp4' : 'image/jpeg';
  }

  void _handleReply(List<Message> messages) {
    final msg = _findSelectedMessage(messages);
    if (msg == null) return;
    final text = _messagePreviewForAction(msg);
    setState(() {
      _replyingTo = (
        id: msg.messageId,
        text: text,
        sender:
            msg.senderUserId == (ref.read(currentSpaceProvider)?.userId ?? '')
                ? AppLocalizations.of(context).chatSelf
                : _displayNameForUser(
                    msg.senderUserId,
                    preferFriendRemark: _preferGroupMemberRemark(),
                  ),
      );
    });
  }

  bool _preferGroupMemberRemark() {
    if (!(widget.isGroup || _resolvedIsGroup)) return true;
    return ref.read(
      groupMemberNicknamePreferenceProvider(
        groupMemberNicknamePreferenceScopeKey(
          spaceId: _spaceId,
          conversationId: _activeConversationId,
        ),
      ),
    );
  }

  String _displayNameForUser(
    String userId, {
    bool preferFriendRemark = true,
  }) {
    if (userId.isEmpty) return widget.title;
    final isGroup = widget.isGroup || _resolvedIsGroup;
    final friends = ref.read(friendsProvider).valueOrNull ?? const <Contact>[];
    Contact? friend;
    for (final candidate in friends) {
      if (candidate.userId == userId) {
        friend = candidate;
        break;
      }
    }
    String? groupDisplayName;
    if (isGroup) {
      final groupMembers =
          ref.read(groupMembersProvider(_activeConversationId)).valueOrNull;
      for (final member in groupMembers ?? const []) {
        if (member.userId == userId && member.displayName.trim().isNotEmpty) {
          groupDisplayName = member.displayName;
          break;
        }
      }
    }
    for (final contact
        in ref.read(tenantMembersProvider).valueOrNull ?? const <Contact>[]) {
      if (contact.userId == userId && contact.displayName.trim().isNotEmpty) {
        return resolveFriendDisplayName(
          friend: friend,
          contextualDisplayName: groupDisplayName,
          fallback: contact.displayName.trim(),
          preferFriendRemark: preferFriendRemark,
        );
      }
    }
    return resolveFriendDisplayName(
      friend: friend,
      contextualDisplayName: groupDisplayName,
      fallback:
          isGroup ? AppLocalizations.of(context).groupRoleMember : widget.title,
      preferFriendRemark: preferFriendRemark,
    );
  }

  String? _avatarUrlForUser(String userId) {
    if (userId.isEmpty) return null;
    if (widget.isGroup || _resolvedIsGroup) {
      final groupMembers =
          ref.read(groupMembersProvider(_activeConversationId)).valueOrNull;
      for (final member in groupMembers ?? const []) {
        if (member.userId == userId && member.avatarUrl?.isNotEmpty == true) {
          return member.avatarUrl;
        }
      }
    }
    final contacts = [
      ...?ref.read(tenantMembersProvider).valueOrNull,
      ...?ref.read(friendsProvider).valueOrNull,
    ];
    for (final contact in contacts) {
      if (contact.userId == userId && contact.avatarUrl?.isNotEmpty == true) {
        return contact.avatarUrl;
      }
    }
    return null;
  }

  ({String label, String shortLabel, IdentityBadgeTone tone})? _identityForUser(
      String userId) {
    final space = ref.read(currentSpaceProvider);
    if (space == null || space.isPersonal) return null;
    if (userId.isEmpty) return null;
    final contacts = [
      ...?ref.read(tenantMembersProvider).valueOrNull,
      ...?ref.read(friendsProvider).valueOrNull,
    ];
    for (final contact in contacts) {
      if (contact.userId != userId) continue;
      final identity = identityBadgeFor(
        userType: contact.userType,
        customerTag: contact.customerTag,
      );
      if (identity != null) return identity;
      return null;
    }
    return null;
  }

  String _messagePreviewForAction(Message msg) {
    if (msg.type == MessageType.link && msg.body.link != null) {
      return msg.body.link!.displayTitle;
    }
    final text = msg.body.text?.trim();
    if (text != null && text.isNotEmpty) return text;

    final l10n = AppLocalizations.of(context);
    return switch (msg.type) {
      MessageType.image => l10n.chatImageMessage,
      MessageType.voice => l10n.chatVoiceMessage,
      MessageType.video => l10n.chatVideoMessage,
      MessageType.file => msg.body.file?.fileName?.trim().isNotEmpty == true
          ? msg.body.file!.fileName!.trim()
          : l10n.chatFileMessage,
      MessageType.contactCard =>
        msg.body.contactCard?.displayName.trim().isNotEmpty == true
            ? msg.body.contactCard!.displayName.trim()
            : l10n.chatContactCardMessage,
      MessageType.callLog => _callLogPreview(msg),
      MessageType.location =>
        msg.body.location?.title?.trim().isNotEmpty == true
            ? msg.body.location!.title!.trim()
            : l10n.chatLocationMessage,
      MessageType.event => l10n.chatGenericMessage,
      MessageType.link => msg.body.link?.displayTitle ??
          msg.body.link?.url ??
          l10n.chatGenericMessage,
      MessageType.text || MessageType.markdown => l10n.chatGenericMessage,
    };
  }

  String _callLogPreview(Message message) {
    if (message.body.callLog == null) {
      return AppLocalizations.of(context).chatCallLogMessage;
    }
    final semantic = CallLogPolicy.resolve(
      message,
      currentUserId: ref.read(currentSpaceProvider)?.userId ?? '',
    );
    final display = localizedCallLogDisplay(
      AppLocalizations.of(context),
      semantic,
    );
    return '${display.mediaTitle} ${display.statusWithDetail}';
  }

  Future<void> _handleTranslate(List<Message> messages) async {
    if (messages.isEmpty || _selectedMessageId == null) return;
    final selectedMessageId = _selectedMessageId!;
    Message? selectedMessage;
    for (final message in messages) {
      if (message.messageId == selectedMessageId) {
        selectedMessage = message;
        break;
      }
    }
    final msg = selectedMessage;
    if (msg == null) return;
    final targetLanguage = ref.read(autoTranslateGlobalProvider).targetLanguage;

    if (const AutoTranslationPolicy()
        .hasTranslationForTarget(msg, targetLanguage)) {
      await _persistChatMessageTranslation(
        selectedMessageId,
        (current) => current.copyWith(
          translation: '',
          clearTranslationLanguage: true,
        ),
        fallback: msg,
      );
      return;
    }

    await _translateVisibleMessage(msg, targetLanguage: targetLanguage);
  }

  Future<void> _handleQuickTranslate(
    List<Message> messages,
    String currentUserId,
  ) async {
    if (_isQuickTranslating) return;
    final targetLanguage = ref.read(autoTranslateGlobalProvider).targetLanguage;
    final byId = {
      for (final message in messages) message.messageId: message,
    };
    final candidates = _visibleMessageIds
        .map((messageId) => byId[messageId])
        .whereType<Message>()
        .where((message) => const AutoTranslationPolicy().shouldTranslate(
              message: message,
              targetLanguage: targetLanguage,
              currentUserId: currentUserId,
            ))
        .toList(growable: false);

    if (candidates.isEmpty) {
      if (mounted) {
        AppToast.info(context, '暂无对方可翻译的消息');
      }
      return;
    }

    if (mounted) setState(() => _isQuickTranslating = true);
    var translatedCount = 0;
    try {
      for (final message in candidates) {
        if (!mounted) break;
        if (!_visibleMessageIds.contains(message.messageId)) continue;
        final translated = await _translateVisibleMessage(
          message,
          targetLanguage: targetLanguage,
          showToastOnError: false,
        );
        if (translated) translatedCount += 1;
      }
    } finally {
      if (mounted) setState(() => _isQuickTranslating = false);
    }

    if (!mounted) return;
    if (translatedCount == 0) {
      AppToast.error(
        context,
        AppLocalizations.of(context).chatTranslateFailed,
      );
    }
  }

  Future<void> _showAutoTranslateSheet(
    List<Message> messages,
    String currentUserId,
  ) async {
    if (_spaceId.isEmpty) return;
    final scopeKey = _autoTranslateScopeKey;
    final selected = await showModalBottomSheet<Object>(
      context: context,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Consumer(
          builder: (context, sheetRef, _) {
            final colorScheme = Theme.of(context).colorScheme;
            final setting =
                sheetRef.watch(autoTranslateEffectiveProvider(scopeKey));
            final currentPreference = setting.preference;
            Widget option({
              required ConversationAutoTranslatePreference preference,
              required String title,
              required String subtitle,
            }) {
              final selected = currentPreference == preference;
              return ListTile(
                leading: Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected ? colorScheme.primary : null,
                ),
                title: Text(title),
                subtitle: Text(subtitle),
                onTap: () => Navigator.pop(sheetContext, preference),
              );
            }

            return SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ListTile(
                    title: const Text(
                      '自动翻译',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(setting.statusLabel),
                  ),
                  option(
                    preference: ConversationAutoTranslatePreference.inherit,
                    title: '跟随全局',
                    subtitle: '当前全局${setting.globalEnabled ? '已开启' : '已关闭'}',
                  ),
                  option(
                    preference: ConversationAutoTranslatePreference.enabled,
                    title: '本会话开启',
                    subtitle: '仅自动翻译当前屏幕内的对方消息',
                  ),
                  option(
                    preference: ConversationAutoTranslatePreference.disabled,
                    title: '本会话关闭',
                    subtitle: '即使全局开启，本会话也不自动翻译',
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: _isQuickTranslating
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.translate_outlined),
                    title: const Text('翻译当前屏幕消息'),
                    enabled: !_isQuickTranslating,
                    onTap: () => Navigator.pop(sheetContext, 'quick'),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
    if (selected == null || !mounted) return;
    if (selected == 'quick') {
      await _handleQuickTranslate(messages, currentUserId);
      return;
    }
    if (selected is ConversationAutoTranslatePreference) {
      ref
          .read(conversationAutoTranslatePreferenceProvider(scopeKey).notifier)
          .setPreference(selected);
      _scheduleAutoTranslationSync(
        messages: messages,
        setting: ref.read(autoTranslateEffectiveProvider(scopeKey)),
        currentUserId: currentUserId,
      );
    }
  }

  void _scheduleAutoTranslationSync({
    required List<Message> messages,
    required AutoTranslateEffectiveSetting setting,
    required String currentUserId,
  }) {
    final previousTarget = _latestAutoTranslationSetting?.targetLanguage;
    _latestAutoTranslationMessages = messages;
    _latestAutoTranslationSetting = setting;
    _latestAutoTranslationUserId = currentUserId;
    if (previousTarget != null && previousTarget != setting.targetLanguage) {
      for (final cancellation in _manualTranslationCancellations.values) {
        cancellation.cancel();
      }
    }
    if (_autoTranslationSyncScheduled) return;
    _autoTranslationSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoTranslationSyncScheduled = false;
      if (mounted) _syncAutoTranslationCoordinator();
    });
  }

  void _handleMessageViewportChanged(
    List<String> visibleMessageIds,
    bool isScrolling,
  ) {
    _visibleMessageIds = visibleMessageIds;
    _isMessageViewportScrolling = isScrolling;
    for (final entry in _manualTranslationCancellations.entries.toList()) {
      if (!visibleMessageIds.contains(entry.key)) {
        entry.value.cancel();
      }
    }
    _syncAutoTranslationCoordinator();
  }

  void _syncAutoTranslationCoordinator() {
    final setting = _latestAutoTranslationSetting;
    _autoTranslationCoordinator.update(
      scopeKey: _autoTranslateScopeKey,
      enabled: setting?.enabled ?? false,
      targetLanguage: setting?.targetLanguage ?? 'zh-CN',
      currentUserId: _latestAutoTranslationUserId,
      messages: _latestAutoTranslationMessages,
      visibleMessageIds: _visibleMessageIds,
      isScrolling: _isMessageViewportScrolling,
    );
  }

  bool _canTranslateMessage(Message message) =>
      const AutoTranslationPolicy().isTranslatable(message);

  Message _latestChatMessage(String messageId, Message fallback) {
    final currentMessages = ref
            .read(chatProvider(
                (_spaceId, _activeConversationId, _effectiveIsGroup)))
            .valueOrNull ??
        const <Message>[];
    return currentMessages.firstWhere(
      (message) => message.messageId == messageId,
      orElse: () => fallback,
    );
  }

  void _updateChatMessageTransient(
    String messageId,
    Message Function(Message current) update, {
    required Message fallback,
  }) {
    final notifier = ref.read(
        chatProvider((_spaceId, _activeConversationId, _effectiveIsGroup))
            .notifier);
    notifier.updateMessageTransient(
      messageId,
      update(_latestChatMessage(messageId, fallback)),
    );
  }

  Future<void> _persistChatMessageTranslation(
    String messageId,
    Message Function(Message current) update, {
    required Message fallback,
  }) {
    final notifier = ref.read(
        chatProvider((_spaceId, _activeConversationId, _effectiveIsGroup))
            .notifier);
    return notifier.updateMessageTranslation(
      messageId,
      update(_latestChatMessage(messageId, fallback)),
    );
  }

  Future<bool> _translateVisibleMessage(
    Message message, {
    required String targetLanguage,
    bool showToastOnError = true,
  }) async {
    if (!_visibleMessageIds.contains(message.messageId) ||
        _manualTranslationCancellations.containsKey(message.messageId)) {
      return false;
    }
    final cancellation = AutoTranslationCancellation();
    _manualTranslationCancellations[message.messageId] = cancellation;
    try {
      return await _translateMessage(
        message,
        targetLanguage: targetLanguage,
        showToastOnError: showToastOnError,
        cancellation: cancellation,
      );
    } finally {
      cancellation.dispose();
      if (identical(
        _manualTranslationCancellations[message.messageId],
        cancellation,
      )) {
        _manualTranslationCancellations.remove(message.messageId);
      }
    }
  }

  Future<bool> _translateMessage(
    Message msg, {
    required String targetLanguage,
    bool showToastOnError = true,
    AutoTranslationCancellation? cancellation,
    bool automatic = false,
  }) async {
    final latestMessage = _latestChatMessage(msg.messageId, msg);
    if (!_canTranslateMessage(msg) ||
        latestMessage.isTranslating ||
        cancellation?.isCancelled == true) {
      return false;
    }

    _updateChatMessageTransient(
      msg.messageId,
      (current) => current.copyWith(isTranslating: true),
      fallback: latestMessage,
    );

    final normalizedTarget =
        const AutoTranslationPolicy().normalizeTargetLanguage(targetLanguage);
    final cancelToken = dio_package.CancelToken();
    cancellation?.onCancel(
      () => cancelToken.cancel('message left the visible viewport'),
    );
    var persistedResult = false;
    try {
      final translated =
          await ref.read(messageTranslationControllerProvider).translateMessage(
                messageId: msg.messageId,
                targetLanguage: normalizedTarget,
                cancelToken: cancelToken,
              );
      if (!mounted || cancellation?.isCancelled == true) return false;
      final currentTargetLanguage =
          ref.read(autoTranslateGlobalProvider).targetLanguage;
      final automaticStillEnabled = !automatic ||
          ref
              .read(autoTranslateEffectiveProvider(_autoTranslateScopeKey))
              .enabled;
      if (!_visibleMessageIds.contains(msg.messageId) ||
          _activeConversationId != msg.conversationId ||
          currentTargetLanguage != normalizedTarget ||
          !automaticStillEnabled) {
        return false;
      }
      if (translated == null) {
        if (mounted && showToastOnError) {
          AppToast.error(
            context,
            AppLocalizations.of(context).chatTranslateFailed,
          );
        }
        return false;
      }
      await _persistChatMessageTranslation(
        msg.messageId,
        (current) => current.copyWith(
          translation: translated,
          translationLanguage: normalizedTarget,
          isTranslating: false,
        ),
        fallback: latestMessage,
      );
      persistedResult = true;
      return true;
    } catch (e) {
      if (mounted &&
          showToastOnError &&
          !(e is dio_package.DioException &&
              dio_package.CancelToken.isCancel(e)) &&
          cancellation?.isCancelled != true) {
        // 检查是否是服务端未配置翻译服务
        String errMsg = AppLocalizations.of(context).chatTranslateFailed;
        if (e.toString().contains('TRANSLATE_NOT_CONFIGURED')) {
          errMsg = AppLocalizations.of(context).chatTranslateNotConfigured;
        }
        AppToast.error(context, errMsg);
      }
      return false;
    } finally {
      if (!persistedResult && mounted) {
        _updateChatMessageTransient(
          msg.messageId,
          (current) => current.copyWith(isTranslating: false),
          fallback: latestMessage,
        );
      }
    }
  }

  /// 语音消息转文字
  Future<void> _handleVoiceToText(Message msg) async {
    if (msg.messageId.isEmpty || msg.type != MessageType.voice) {
      if (mounted) {
        AppToast.error(
          context,
          AppLocalizations.of(context).chatVoiceToTextFailed,
        );
      }
      return;
    }

    final notifier = ref.read(
        chatProvider((_spaceId, widget.conversationId, _effectiveIsGroup))
            .notifier);

    Message latestMessage() {
      if (!mounted) return msg;
      final currentMessages = ref
              .read(chatProvider(
                  (_spaceId, widget.conversationId, _effectiveIsGroup)))
              .valueOrNull ??
          const <Message>[];
      for (final message in currentMessages) {
        if (message.messageId == msg.messageId) return message;
      }
      return msg;
    }

    void updateVoiceMessage(Message Function(Message current) update) {
      notifier.updateMessage(msg.messageId, update(latestMessage()));
    }

    if (msg.isTranslating) return;
    updateVoiceMessage((current) => current.copyWith(isTranslating: true));

    try {
      final text = await ref
          .read(conversationActionsControllerProvider)
          .voiceToText(msg.messageId);
      if (text == null) {
        debugPrint('[ChatPage] voice-to-text empty response');
        updateVoiceMessage((current) => current.copyWith(isTranslating: false));
        if (mounted) {
          AppToast.error(
            context,
            AppLocalizations.of(context).chatVoiceToTextFailed,
          );
        }
        return;
      }
      updateVoiceMessage(
        (current) => current.copyWith(
          translation: text,
          isTranslating: false,
        ),
      );
    } catch (error) {
      debugPrint('[ChatPage] voice-to-text failed: $error');
      updateVoiceMessage((current) => current.copyWith(isTranslating: false));
      if (mounted) {
        AppToast.error(
          context,
          AppLocalizations.of(context).chatVoiceToTextFailed,
        );
      }
    }
  }

  Future<void> _handleTextToSpeech(Message msg) async {
    if (msg.messageId.isEmpty ||
        !messageContextCapabilities(
          msg,
          currentUserId: ref.read(currentSpaceProvider)?.userId ?? '',
        ).canTextToSpeech ||
        !_textToSpeechInFlightMessageIds.add(msg.messageId)) {
      return;
    }
    final audioPlayer = ref.read(audioPlayerServiceProvider);
    final requestVersion = audioPlayer.beginPlaybackRequest();

    try {
      final url = await ref
          .read(conversationActionsControllerProvider)
          .textToSpeech(msg.messageId);
      await audioPlayer.play(
        'tts:${msg.messageId}',
        url,
        requestVersion: requestVersion,
      );
    } catch (_) {
      if (mounted) {
        AppToast.error(
          context,
          AppLocalizations.of(context).chatTextToSpeechFailed,
        );
      }
    } finally {
      _textToSpeechInFlightMessageIds.remove(msg.messageId);
    }
  }

  Future<String?> _transcribeVoiceDraft(String filePath) async {
    try {
      return await ref
          .read(conversationActionsControllerProvider)
          .speechToText(filePath);
    } catch (error) {
      debugPrint('[ChatPage] speech-to-text failed: $error');
      return null;
    }
  }

  Future<void> _sendVoiceMessage(
    String filePath,
    int duration,
  ) async {
    final notifier = ref.read(chatProvider(
      (_spaceId, widget.conversationId, _effectiveIsGroup),
    ).notifier);
    try {
      await _sendChatMessage(
        type: MessageType.voice,
        body: MessageBody(
          voice: MediaResource(
            url: filePath,
            durationSeconds: duration,
            mimeType: 'audio/m4a',
          ),
        ),
        onOptimisticInsert: (msg) {
          notifier.optimisticInsert(msg);
          _scrollToBottom();
        },
        onMessageUpdate: (clientMsgId, updated) async {
          await notifier.updateMessage(clientMsgId, updated);
        },
      );
    } catch (error) {
      _handleSendError(error);
    }
  }

  Future<Message> _sendChatMessage({
    required MessageType type,
    required MessageBody body,
    String? clientMsgId,
    String? replyToMessageId,
    List<Mention>? mentions,
    required void Function(Message message) onOptimisticInsert,
    required FutureOr<void> Function(
      String clientMsgId,
      Message updated,
    ) onMessageUpdate,
  }) async {
    if (_isCustomerServiceThread) {
      final action = type == MessageType.text
          ? CustomerServiceAction.sendText
          : CustomerServiceAction.sendMedia;
      final permission = _customerServiceActionPermission(action);
      if (!permission.enabled) {
        throw ServerError(
          code: 'CS_ACTION_DENIED',
          message: _customerServiceActionDeniedText(permission),
        );
      }
    }
    if (_isReadOnlyConversation) {
      throw const ServerError(
        code: 'CHAT_READ_ONLY',
        message: '当前为会话查看模式，不能发言',
      );
    }
    if (_customerServiceThreadEnded) {
      throw const ServerError(
        code: 'TEMP_SESSION_CLOSED',
        message: '会话已结束，不能继续发送消息',
      );
    }
    if (_customerServiceRequiresManualEntry) {
      throw const ServerError(
        code: 'TEMP_SESSION_NOT_CLAIMED',
        message: '请先接入或人工接管后再回复',
      );
    }
    if (_isCustomerServiceThread) {
      return _sendCustomerServiceMessage(
        type: type,
        body: body,
        clientMsgId: clientMsgId,
        replyToMessageId: replyToMessageId,
        onOptimisticInsert: onOptimisticInsert,
        onMessageUpdate: onMessageUpdate,
      );
    }

    final conversationId = await _ensureDirectConversationForSend();
    final isGroup = _effectiveIsGroup;
    final useCase = ref
        .read(sendMessageUseCaseProvider((_spaceId, conversationId, isGroup)));
    return useCase.execute(
      conversationId: conversationId,
      isGroup: isGroup,
      type: type,
      body: body,
      clientMsgId: clientMsgId,
      replyToMessageId: replyToMessageId,
      mentions: mentions,
      onOptimisticInsert: onOptimisticInsert,
      onMessageUpdate: onMessageUpdate,
    );
  }

  Future<bool> _sendTextMessage({
    required String text,
    String? replyToMessageId,
    List<Mention>? mentions,
    bool clearReplyOnSuccess = false,
  }) async {
    var sent = false;
    try {
      final draft = ref.read(linkMessageDraftResolverProvider).resolve(text);
      final sendConversationId = await _ensureDirectConversationForSend();
      if (!mounted) return false;
      final notifier = ref.read(
          chatProvider((_spaceId, sendConversationId, _effectiveIsGroup))
              .notifier);
      await _sendChatMessage(
        type: draft.type,
        body: draft.body,
        replyToMessageId: replyToMessageId,
        mentions: _effectiveIsGroup ? mentions : null,
        onOptimisticInsert: (msg) {
          notifier.optimisticInsert(msg);
          _scrollToBottom();
        },
        onMessageUpdate: (clientMsgId, updated) async {
          await notifier.updateMessage(clientMsgId, updated);
        },
      );
      sent = true;
    } catch (e) {
      _handleSendError(e, showSnack: false);
    }
    if (sent && clearReplyOnSuccess && mounted) {
      setState(() => _replyingTo = null);
    }
    return sent;
  }

  Future<bool> _scheduleTextMessage(String text, DateTime scheduledAt) async {
    const timePolicy = ScheduledMessageTimePolicy();
    final now = DateTime.now();
    if (timePolicy.isBeforeMinLeadTime(scheduledAt, now)) {
      AppToast.error(context, '请选择至少 1 分钟后的时间');
      return false;
    }
    if (timePolicy.exceedsMaxLeadTime(scheduledAt, now)) {
      AppToast.error(context, '定时发送最多支持 14 天内');
      return false;
    }
    final visibleTask = _visibleScheduledMessage;
    if (visibleTask != null) {
      return _updateScheduledTextMessage(
        scheduledMessageId: visibleTask.scheduledMessageId,
        text: text,
        scheduledAt: scheduledAt,
      );
    }
    try {
      await ref
          .read(scheduledMessageRepositoryProvider(_spaceId))
          .createScheduledMessage(
            conversationId: _activeConversationId,
            isGroup: _effectiveIsGroup,
            type: MessageType.text,
            body: MessageBody(text: text),
            scheduledAt: scheduledAt,
            replyToMessageId: _replyingTo?.id,
          );
      if (!mounted) return true;
      if (_replyingTo != null || _localScheduledSendAt != null) {
        setState(() {
          _replyingTo = null;
          _localScheduledSendAt = null;
        });
      }
      unawaited(_refreshScheduledMessages());
      return true;
    } catch (error) {
      if (!mounted) return false;
      AppToast.error(context, _friendlyErrorMessage(error));
      return false;
    }
  }

  Future<bool> _updateScheduledTextMessage({
    required String scheduledMessageId,
    required String text,
    required DateTime scheduledAt,
  }) async {
    const timePolicy = ScheduledMessageTimePolicy();
    final now = DateTime.now();
    if (timePolicy.isBeforeMinLeadTime(scheduledAt, now)) {
      AppToast.error(context, '请选择至少 1 分钟后的时间');
      return false;
    }
    if (timePolicy.exceedsMaxLeadTime(scheduledAt, now)) {
      AppToast.error(context, '定时发送最多支持 14 天内');
      return false;
    }
    try {
      await ref
          .read(scheduledMessageRepositoryProvider(_spaceId))
          .updateScheduledMessage(
            scheduledMessageId: scheduledMessageId,
            body: MessageBody(text: text),
            scheduledAt: scheduledAt,
          );
      if (!mounted) return true;
      setState(() {
        _editingScheduledMessage = null;
        _localScheduledSendAt = null;
      });
      unawaited(_refreshScheduledMessages());
      return true;
    } catch (error) {
      if (!mounted) return false;
      AppToast.error(context, _friendlyErrorMessage(error));
      return false;
    }
  }

  Future<void> _refreshScheduledMessages() async {
    if (_spaceId.isEmpty || _isPendingDirectChat || _isReadOnlyConversation) {
      _scheduledMessagesDueRefreshTimer?.cancel();
      if (mounted && _scheduledMessages.isNotEmpty) {
        setState(() => _scheduledMessages = const []);
      }
      return;
    }
    final conversationId = _activeConversationId;
    if (_scheduledMessagesLoading) return;
    if (mounted) {
      setState(() => _scheduledMessagesLoading = true);
    }
    try {
      final items = await ref
          .read(scheduledMessageRepositoryProvider(_spaceId))
          .getScheduledMessages(conversationId);
      if (!mounted || conversationId != _activeConversationId) return;
      final pending = items.where((item) => item.canEdit).toList()
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      setState(() {
        _scheduledMessages = pending;
        final editing = _editingScheduledMessage;
        if (editing != null &&
            !pending.any(
              (item) => item.scheduledMessageId == editing.scheduledMessageId,
            )) {
          _editingScheduledMessage = null;
        }
      });
      _scheduleScheduledMessagesDueRefresh(pending);
    } catch (_) {
      _scheduledMessagesDueRefreshTimer?.cancel();
      if (mounted) {
        setState(() => _scheduledMessages = const []);
      }
    } finally {
      if (mounted) {
        setState(() => _scheduledMessagesLoading = false);
      }
    }
  }

  void _scheduleScheduledMessagesDueRefresh(List<ScheduledMessage> messages) {
    _scheduledMessagesDueRefreshTimer?.cancel();
    const policy = ScheduledMessageInputPanelPolicy();
    final visibleTask = policy.visibleTask(messages);
    final delay = policy.refreshDelayForVisibleTask(
      visibleTask: visibleTask,
      now: DateTime.now(),
    );
    if (visibleTask == null || delay == null) {
      _lastImmediateScheduledMessageProbeKey = null;
      return;
    }
    final probeKey =
        '${visibleTask.scheduledMessageId}:${visibleTask.status}:${visibleTask.scheduledAt.toUtc().toIso8601String()}';
    final effectiveDelay = delay == Duration.zero &&
            _lastImmediateScheduledMessageProbeKey == probeKey
        ? const Duration(seconds: 15)
        : delay;
    _scheduledMessagesDueRefreshTimer = Timer(effectiveDelay, () {
      if (!mounted) return;
      if (delay == Duration.zero) {
        _lastImmediateScheduledMessageProbeKey = probeKey;
      }
      unawaited(_handleScheduledMessageDueRefresh());
    });
  }

  Future<void> _handleScheduledMessageDueRefresh() async {
    if (_spaceId.isEmpty) return;
    await _refreshScheduledMessages();
    if (!mounted || _spaceId.isEmpty) return;
    ref.invalidate(
        chatProvider((_spaceId, _activeConversationId, _effectiveIsGroup)));
    ref.invalidate(conversationsProvider(_spaceId));
    if (_effectiveIsGroup) {
      await ref
          .read(groupDetailProvider(_activeConversationId).notifier)
          .refresh();
    }
  }

  void _startEditingScheduledMessage(ScheduledMessage message) {
    if (message.type != MessageType.text || !message.canEdit) return;
    setState(() {
      _replyingTo = null;
      _editingScheduledMessage = message;
      _localScheduledSendAt = null;
    });
  }

  void _handleLocalScheduledSendAtChanged(DateTime? scheduledAt) {
    if (_localScheduledSendAt == scheduledAt) return;
    setState(() => _localScheduledSendAt = scheduledAt);
  }

  void _clearLocalScheduledSendAt() {
    if (_localScheduledSendAt == null) return;
    setState(() => _localScheduledSendAt = null);
  }

  void _cancelScheduledMessageEdit() {
    if (_editingScheduledMessage == null) return;
    setState(() => _editingScheduledMessage = null);
  }

  Future<void> _cancelScheduledMessageFromInput(
      ScheduledMessage message) async {
    if (!message.canCancel || _cancelingScheduledMessageId != null) return;
    final previousMessages = _scheduledMessages;
    setState(() {
      _cancelingScheduledMessageId = message.scheduledMessageId;
      _scheduledMessages = _scheduledMessages
          .where(
              (item) => item.scheduledMessageId != message.scheduledMessageId)
          .toList(growable: false);
      if (_editingScheduledMessage?.scheduledMessageId ==
          message.scheduledMessageId) {
        _editingScheduledMessage = null;
      }
    });
    try {
      await ref
          .read(scheduledMessageRepositoryProvider(_spaceId))
          .cancelScheduledMessage(message.scheduledMessageId)
          .timeout(const Duration(seconds: 8));
      if (!mounted) return;
      unawaited(_refreshScheduledMessages());
    } catch (error) {
      if (mounted) {
        if (_scheduledCancelFailurePolicy.shouldRestoreAfterCancelFailure(
          error,
        )) {
          setState(() => _scheduledMessages = previousMessages);
        } else {
          unawaited(_refreshScheduledMessages());
        }
        AppToast.error(
          context,
          _scheduledCancelFailurePolicy.messageForCancelFailure(error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _cancelingScheduledMessageId = null);
      }
    }
  }

  String _friendlyErrorMessage(Object error) {
    if (error is ServerError) return error.message;
    if (error is NetworkError) return error.message;
    if (error is AuthError) return '登录状态已失效，请重新登录';
    return '定时发送设置失败';
  }

  Future<String> _ensureDirectConversationForSend() async {
    final chatId =
        await ref.read(directChatEntryControllerProvider).ensureConversationId(
              isPendingDirectChat: _isPendingDirectChat,
              activeConversationId: _activeConversationId,
              peerUserId: widget.peerUserId,
            );
    if (mounted) {
      setState(() => _createdConversationId = chatId);
    } else {
      _createdConversationId = chatId;
    }
    _markActiveChatForNotifications();
    if (_spaceId.isNotEmpty) {
      ref.invalidate(conversationsProvider(_spaceId));
    }
    return chatId;
  }

  void _handleSendError(Object error, {bool showSnack = true}) {
    AppDiagnostics.instance.error('chat.send', 'message send failed', context: {
      'conversationId': widget.conversationId,
      'isGroup': _effectiveIsGroup,
      'error': error.toString(),
      if (error is ServerError) 'code': error.code,
      if (error is ServerError) 'requestId': error.requestId,
    });
    if (!mounted) return;
    if (showTeenModeServerAction(context, ref, error)) return;

    final code = error is ServerError
        ? error.code
        : error is MessageSendFailure
            ? error.code ?? error.message
            : error.toString();
    if (code.contains('TEMP_SESSION_CLOSED')) {
      _markCustomerServiceThreadEnded(showToast: false);
      if (showSnack) AppToast.info(context, '会话已结束，不能继续发送消息');
      return;
    }
    if (code.contains('MSG_MEMBER_FORBIDDEN')) {
      setState(() => _notFriend = true);
      return;
    }
    if (!showSnack) return;

    final moderationMessage = switch (error) {
      ServerError(:final code, :final message) =>
        moderationBlockMessage(code, message),
      MessageSendFailure(:final code, :final message) =>
        moderationBlockMessage(code, message),
      _ => null,
    };
    final l10n = AppLocalizations.of(context);
    final message = moderationMessage ??
        (isModerationBlockedCode(code)
            ? '内容不符合规范，已禁止发送'
            : switch (code) {
                'MSG_GROUP_MUTED' => l10n.chatMutedFullNotice,
                'MSG_MEMBER_MUTED' => '你已被禁言，暂时无法发言',
                'MSG_USER_MUTED' => '当前账号已被禁言，暂时无法发言',
                'INVALID_OPERATION' when _effectiveIsGroup =>
                  '群消息发送失败，请稍后重试（INVALID_OPERATION）',
                _ => l10n.chatSendFailed,
              });

    AppToast.error(context, message);
  }

  Future<Message> _sendCustomerServiceMessage({
    required MessageType type,
    required MessageBody body,
    String? clientMsgId,
    String? replyToMessageId,
    required void Function(Message message) onOptimisticInsert,
    required FutureOr<void> Function(
      String clientMsgId,
      Message updated,
    ) onMessageUpdate,
  }) async {
    final thread = _customerServiceThreadDetailForSend();

    try {
      return await ref.read(customerServiceChatControllerProvider).sendMessage(
            spaceId: _spaceId,
            currentUserId: ref.read(currentSpaceProvider)?.userId ?? '',
            thread: thread,
            conversationId: widget.conversationId,
            type: type,
            body: body,
            clientMsgId: clientMsgId,
            replyToMessageId: replyToMessageId,
            readOnly: _isReadOnlyConversation,
            onOptimisticInsert: onOptimisticInsert,
            onMessageUpdate: onMessageUpdate,
          );
    } catch (e) {
      if (e.toString().contains('CUSTOMER_SERVICE_DIRECT_NOT_ASSIGNED')) {
        _markCustomerServiceThreadEnded(
            status: 'transferred', showToast: false);
      }
      if (_isCustomerServiceTerminalWriteError(e)) {
        _markCustomerServiceThreadEnded(showToast: false);
      }
      rethrow;
    }
  }

  bool _isCustomerServiceTerminalWriteError(Object error) {
    if (!_isCustomerServiceThread) return false;
    if (error is dio_package.DioException) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;
      final code = data is Map ? data['code']?.toString() : '';
      return statusCode == 401 ||
          code == 'TEMP_SESSION_CLOSED' ||
          code == 'TEMP_SESSION_ENDED' ||
          code == 'TEMP_SESSION_NOT_ACTIVE' ||
          code == 'INVALID_SESSION_STATUS';
    }
    if (error is AuthError) return true;
    if (error is ServerError) {
      return error.statusCode == 401 ||
          {
            'TEMP_SESSION_CLOSED',
            'TEMP_SESSION_ENDED',
            'TEMP_SESSION_NOT_ACTIVE',
            'INVALID_SESSION_STATUS',
          }.contains(error.code);
    }
    return false;
  }

  /// 发送文件消息
  Future<void> _handleSendFile(
      String filePath, String fileName, String mimeType, int sizeBytes) async {
    try {
      final sendConversationId = await _ensureDirectConversationForSend();
      if (!mounted) return;
      final clientMsgId = _uuid.v4();
      final localized = await OutgoingMediaLocalizer(
        runtime: ref.read(mediaFileRuntimeProvider),
      ).localize(
        spaceId: _spaceId,
        conversationId: sendConversationId,
        messageId: clientMsgId,
        variant: MediaVariant.attachment,
        sourcePath: filePath,
        fileName: fileName,
      );
      final notifier = ref.read(
          chatProvider((_spaceId, sendConversationId, _effectiveIsGroup))
              .notifier);
      await _sendChatMessage(
        type: MessageType.file,
        clientMsgId: clientMsgId,
        body: MessageBody(
          file: MediaResource(
            url: localized.localPath,
            fileName: fileName,
            mimeType: mimeType,
            sizeBytes:
                localized.sizeBytes > 0 ? localized.sizeBytes : sizeBytes,
            localPreviewUrl: localized.localPath,
          ),
        ),
        onOptimisticInsert: (message) {
          notifier.optimisticInsert(message);
          _scrollToBottom();
        },
        onMessageUpdate: (clientMsgId, updated) async {
          await notifier.updateMessage(clientMsgId, updated);
        },
      );
    } catch (e) {
      if (mounted) {
        if (e is ServerError || e is MessageSendFailure) {
          _handleSendError(e);
        } else {
          AppToast.error(
            context,
            AppLocalizations.of(context).chatFileUploadFailed,
          );
        }
      }
    }
  }

  Future<void> _handleSendMedia(List<ChatPickedMedia> mediaItems) async {
    if (mediaItems.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    final uploadFailedText = l10n.chatImageUploadUnsupported;
    try {
      final sendConversationId = await _ensureDirectConversationForSend();
      if (!mounted) return;
      final notifier = ref.read(
        chatProvider((_spaceId, sendConversationId, _effectiveIsGroup))
            .notifier,
      );
      await sendChatPickedMediaBatch(mediaItems, (item) async {
        final clientMsgId = _uuid.v4();
        final localized = await OutgoingMediaLocalizer(
          runtime: ref.read(mediaFileRuntimeProvider),
        ).localize(
          spaceId: _spaceId,
          conversationId: sendConversationId,
          messageId: clientMsgId,
          variant:
              item.isVideo ? MediaVariant.videoSource : MediaVariant.original,
          sourcePath: item.path,
          fileName: item.fileName,
        );
        final sizeBytes = localized.sizeBytes > 0
            ? localized.sizeBytes
            : item.sizeBytes ?? await localFileLength(item.path);
        final localPosterUrl = item.isVideo
            ? await generateLocalVideoPoster(
                localized.localPath,
                accountMediaRoot:
                    ref.read(mediaFileRuntimeProvider).accountMediaRoot,
              )
            : null;
        final mediaDimensions = item.isImage
            ? await readLocalImageDimensions(localized.localPath)
            : await readLocalImageDimensions(localPosterUrl);
        final resource = MediaResource(
          url: localized.localPath,
          fileName: item.fileName,
          mimeType: item.mimeType,
          sizeBytes: sizeBytes,
          width: mediaDimensions?.$1,
          height: mediaDimensions?.$2,
          localPreviewUrl: localized.localPath,
          localPosterUrl: localPosterUrl,
        );
        final type = item.isVideo ? MessageType.video : MessageType.image;
        final body = item.isVideo
            ? MessageBody(video: resource)
            : MessageBody(image: resource);
        await _sendChatMessage(
          type: type,
          body: body,
          clientMsgId: clientMsgId,
          replyToMessageId: _replyingTo?.id,
          onOptimisticInsert: (msg) {
            notifier.optimisticInsert(msg);
            _scrollToBottom();
          },
          onMessageUpdate: (clientMsgId, updated) async {
            await notifier.updateMessage(clientMsgId, updated);
          },
        );
      });
      if (mounted) setState(() => _replyingTo = null);
    } catch (e) {
      if (!mounted) return;
      if (e is ServerError) {
        _handleSendError(e);
      } else {
        AppToast.show(
          context,
          uploadFailedText,
          type: AppToastType.error,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  /// 发送失败感叹号点击：弹出「重发 / 删除」ActionSheet（参考微信）
  void _showFailedMessageSheet(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    if (message.failureReason?.isNotEmpty == true) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                        child: Text(
                          '发送失败：${message.failureReason}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Divider(height: 1, indent: 0),
                    ],
                    if (canRetryMessageTransport(message)) ...[
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context).chatResend,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _retryMessage(message);
                        },
                      ),
                      const Divider(height: 1, indent: 0),
                    ],
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context).commonDelete,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 17, color: Colors.red),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        final notifier = ref.read(chatProvider((
                          _spaceId,
                          widget.conversationId,
                          _effectiveIsGroup
                        )).notifier);
                        notifier.deleteMessageLocally(message.messageId);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(context).commonCancel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 重发失败消息
  Future<void> _retryMessage(Message message) async {
    if (!canRetryMessageTransport(message)) return;
    if (shouldBlockChatSendAction(
      ChatSendAction.retryFailed,
      isSingleActionRunning: _isSending,
    )) {
      return;
    }
    setState(() => _isSending = true);
    final notifier = ref.read(
        chatProvider((_spaceId, widget.conversationId, _effectiveIsGroup))
            .notifier);
    // 先把消息状态改回 sending
    notifier.updateMessage(
      message.messageId,
      message.copyWith(status: MessageStatus.sending),
    );
    try {
      await _sendChatMessage(
        type: message.type,
        body: message.body,
        clientMsgId: message.clientMsgId ?? message.messageId,
        onOptimisticInsert: (_) {}, // 不重复插入，已有消息
        onMessageUpdate: (clientMsgId, updated) async {
          await notifier.updateMessage(message.messageId, updated);
        },
      );
    } catch (e) {
      final awaitsServerReplay =
          teenModeServerActionForError(ref, e)?.awaitsServerReplay == true;
      if (!awaitsServerReplay) {
        await notifier.updateMessage(
          message.messageId,
          message.copyWith(
            status: e is ServerError
                ? MessageStatus.rejected
                : MessageStatus.failed,
            failureReason: _sendFailureReason(e),
          ),
        );
      }
      _handleSendError(
        e,
        showSnack: shouldShowSendFailureSnack(message.type),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  String _sendFailureReason(Object error) {
    if (error is ServerError) {
      final moderationMessage =
          moderationBlockMessage(error.code, error.message);
      if (moderationMessage != null) return moderationMessage;
      if (isModerationBlockedCode(error.code)) {
        return '内容不符合规范，已禁止发送';
      }
      return error.code.isNotEmpty ? error.code : error.message;
    }
    if (error is MessageSendFailure) {
      if (isModerationBlockedCode(error.code) && error.message.trim().isEmpty) {
        return '内容不符合规范，已禁止发送';
      }
      return error.displayReason;
    }
    if (error is AuthError) return error.code;
    if (error is NetworkError) return error.message;
    return error.toString();
  }

  /// 转发消息：打开会话选择页面，选中后调用 POST /messages/forward
  Future<void> _handleForward({Iterable<String>? messageIds}) async {
    final sourceIds = messageIds ??
        (_selectedMessageId == null ? const <String>[] : [_selectedMessageId!]);
    final forwardIds = sourceIds.where((id) => id.isNotEmpty).toList();
    if (forwardIds.isEmpty) return;
    if (!_allMessagesCanForward(forwardIds)) {
      if (mounted) {
        AppToast.error(
          context,
          AppLocalizations.of(context).chatForwardFailed,
        );
      }
      return;
    }

    // 获取当前空间会话列表供选择
    final convs =
        ref.read(releaseVisibleConversationsProvider(_spaceId)).valueOrNull ??
            [];
    if (convs.isEmpty) {
      if (mounted) {
        AppToast.info(
            context, AppLocalizations.of(context).chatNoConversations);
      }
      return;
    }

    // 打开转发选择页面（全屏页面，不用底部弹窗）
    final target = await Navigator.of(context).push<Conversation>(
      MaterialPageRoute(
        builder: (_) => _ForwardSelectPage(conversations: convs),
      ),
    );
    if (target == null || !mounted) return;

    try {
      await ref.read(conversationActionsControllerProvider).forwardMessages(
            sourceMessageIds: forwardIds,
            targetConversationId: target.conversationId,
          );
      ref.invalidate(conversationsProvider(_spaceId));
      ref.invalidate(chatProvider((
        _spaceId,
        target.conversationId,
        target.type == ConversationType.group,
      )));
      if (_multiSelectMode) _handleExitMultiSelect();
      if (mounted) {
        AppToast.show(
          context,
          AppLocalizations.of(context).chatForwardSuccess,
          type: AppToastType.success,
          duration: const Duration(milliseconds: 900),
        );
      }
    } catch (_) {
      if (mounted) {
        AppToast.error(
          context,
          AppLocalizations.of(context).chatForwardFailed,
        );
      }
    }
  }

  bool _allMessagesCanForward(List<String> messageIds) {
    final messages = ref
            .read(chatProvider(
                (_spaceId, widget.conversationId, _effectiveIsGroup)))
            .valueOrNull ??
        const <Message>[];
    final byId = {for (final message in messages) message.messageId: message};
    final currentUserId = ref.read(currentSpaceProvider)?.userId ?? '';
    for (final id in messageIds) {
      final message = byId[id];
      if (message == null ||
          !messageContextCapabilities(
            message,
            currentUserId: currentUserId,
          ).canForward) {
        return false;
      }
    }
    return true;
  }

  void _handleEnterMultiSelect() {
    setState(() {
      _multiSelectMode = true;
      _selectedMessages.clear();
      if (_selectedMessageId != null) {
        _selectedMessages.add(_selectedMessageId!);
      }
    });
  }

  void _handleExitMultiSelect() {
    setState(() {
      _multiSelectMode = false;
      _selectedMessages.clear();
    });
  }

  Future<void> _handleOfficialAccountDecision(
    OfficialAccountClickDecision decision,
  ) async {
    switch (decision.kind) {
      case OfficialAccountClickKind.openUrl:
        final uri = Uri.tryParse(decision.value ?? '');
        if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
          if (mounted) AppToast.info(context, '此菜单暂不可用');
          return;
        }
        final opened = await launchUrl(
          uri,
          mode: LaunchMode.inAppBrowserView,
        );
        if (!opened && mounted) {
          AppToast.error(context, '无法打开链接');
        }
        return;
      case OfficialAccountClickKind.openRoute:
        if (decision.value == 'ztchat://profile' && mounted) {
          await context.push('/my-profile');
        }
        return;
      case OfficialAccountClickKind.openHandoff:
        final handoff = decision.handoff;
        final conversationId = handoff?.conversationId;
        if (handoff == null ||
            conversationId == null ||
            conversationId.isEmpty ||
            !mounted) {
          if (mounted) AppToast.info(context, '客服会话正在准备，请稍后重试');
          return;
        }
        ref.invalidate(conversationsProvider(_spaceId));
        await context.push(
          '/chat/$conversationId',
          extra: {
            'isGroup': false,
            'title': handoff.staffDisplayName ?? '在线客服',
            'peerUserId': handoff.staffUserId,
          },
        );
        return;
      case OfficialAccountClickKind.queued:
        if (mounted) {
          AppToast.info(context, '已为您排队，坐席空闲后会主动联系您');
        }
        return;
      case OfficialAccountClickKind.replied:
        return;
      case OfficialAccountClickKind.ignore:
        if (mounted) AppToast.info(context, '此菜单暂不可用');
        return;
    }
  }

  Future<void> _handleSendContactCard() async {
    // 打开联系人选择页面（全屏，参考微信"选择朋友"）
    final contact = await Navigator.of(context).push<_ContactPickResult>(
      MaterialPageRoute(builder: (_) => const _ContactPickPage()),
    );
    if (contact == null || !mounted) return;

    final notifier = ref.read(
        chatProvider((_spaceId, widget.conversationId, _effectiveIsGroup))
            .notifier);
    try {
      await _sendChatMessage(
        type: MessageType.contactCard,
        body: MessageBody(
          contactCard: ContactCardDto(
            userId: contact.userId,
            displayName: contact.displayName,
            avatarUrl: contact.avatarUrl,
          ),
        ),
        onOptimisticInsert: (msg) {
          notifier.optimisticInsert(msg);
        },
        onMessageUpdate: (clientMsgId, updated) async {
          await notifier.updateMessage(clientMsgId, updated);
        },
      );
    } catch (e) {
      if (mounted) {
        if (e is ServerError) {
          _handleSendError(e);
        } else {
          AppToast.error(
            context,
            AppLocalizations.of(context).chatCardSendFailed,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversationsAsync = _spaceId.isNotEmpty
        ? ref.watch(conversationsProvider(_spaceId))
        : const AsyncData(<Conversation>[]);
    final effectiveIsGroup = _effectiveIsGroup;
    final activeConversationId = _activeConversationId;
    final currentConversation = conversationsAsync.valueOrNull
        ?.where((conversation) =>
            conversation.conversationId == activeConversationId)
        .firstOrNull;
    final blocksGroupFeatures =
        ref.watch(appUpdateGroupFeaturesBlockedProvider);
    if (blocksGroupFeatures &&
        currentConversation?.type == ConversationType.group) {
      if (!_releaseFaceRedirectScheduled) {
        _releaseFaceRedirectScheduled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.go('/');
        });
      }
      return const SizedBox.shrink();
    }
    _ensureGroupDetailRefreshTimer(effectiveIsGroup);
    final AsyncValue<List<Message>> messagesAsync = _isPendingDirectChat
        ? const AsyncData(<Message>[])
        : ref.watch(chatMessagesForDisplayProvider(
            (_spaceId, activeConversationId, effectiveIsGroup)));
    final messageLoadStatus = _isPendingDirectChat
        ? (false, false)
        : ref.watch(
            chatProvider((_spaceId, activeConversationId, effectiveIsGroup))
                .select((value) => (value.hasError, value.isLoading)));
    final groupDetail = effectiveIsGroup
        ? ref.watch(groupDetailProvider(activeConversationId))
        : null;
    final groupMembersAsync = effectiveIsGroup
        ? ref.watch(groupMembersProvider(activeConversationId))
        : null;
    final friendContacts =
        ref.watch(friendsProvider).valueOrNull ?? const <Contact>[];
    final friendsByUserId = {
      for (final friend in friendContacts) friend.userId: friend,
    };
    final visibleCallTargetUserId = effectiveIsGroup
        ? null
        : _resolveCallTargetUserId(logResolution: false);
    final canStartCall = !widget.messagingOnly &&
        visibleCallTargetUserId != null &&
        ref.watch(teenModePolicyProvider).canAttemptStartCall(
              isFriend: friendsByUserId.containsKey(visibleCallTargetUserId),
            );
    final currentUserId = ref.watch(currentSpaceProvider)?.userId ?? '';
    final space = ref.watch(currentSpaceProvider);
    final customerServiceCapabilities =
        ref.watch(currentCustomerServiceRoleCapabilitiesProvider);
    final groupDetailValue = groupDetail?.valueOrNull;
    final groupPermissions = groupDetailValue == null
        ? null
        : AppPermissions.group(
            myRole: groupDetailValue.myRole,
            isAllMuted: groupDetailValue.muteMode,
            allowMemberInvite: true,
            allowMemberModifyTitle: true,
            allowMemberAtAll: groupDetailValue.allowMemberAtAll,
            allowMemberViewMemberList: true,
            allowMemberAddFriend: groupDetailValue.allowMemberAddFriend,
            space: space,
          );
    final groupMutedForMe = groupPermissions?.canSpeak == false;
    final allowAddFriendFromGroup =
        groupPermissions?.canAddFriendFromGroup ?? true;
    final groupProfileAccessContext = ProfileAccessContext.group(
      role: groupDetailValue?.myRole,
    );
    final mentionCandidates = groupMembersAsync?.valueOrNull
            ?.where((member) => member.userId != currentUserId)
            .map(
              (member) => ChatMentionCandidate(
                userId: member.userId,
                displayName: resolveFriendDisplayName(
                  friend: friendsByUserId[member.userId],
                  contextualDisplayName: member.displayName,
                  fallback: AppLocalizations.of(context).groupRoleMember,
                ),
                avatarUrl: member.avatarUrl,
              ),
            )
            .toList(growable: false) ??
        const <ChatMentionCandidate>[];
    final isEmployee = space?.type == SpaceType.employee;
    final quickReplyScope = const ChatQuickReplyPolicy().scopeFor(
      isGroup: effectiveIsGroup,
      canReadQuickReplies: customerServiceCapabilities.canReadQuickReplies,
      customerServiceThreadType: widget.customerServiceThreadType,
    );
    final aiReplyContextText = latestAiReplyPeerText(
      messagesAsync.valueOrNull,
      currentUserId: currentUserId,
    );
    final aiReplyTarget = _customerServiceAiReplyTarget(
      capabilities: customerServiceCapabilities,
    );
    final customerServiceProfileAsync = _isCustomerServiceThread
        ? ref.watch(customerThreadProfileCardProvider((
            customerUserId: widget.customerServiceCustomerUserId ?? '',
            threadType: widget.customerServiceThreadType ?? 'temp_session',
            threadId: widget.customerServiceThreadId ?? '',
          )))
        : null;
    final customerServiceProfile = customerServiceProfileAsync?.valueOrNull;
    // 读取当前用户头像和名字，用于消息气泡头像
    final myProfile = ref.watch(currentUserProfileProvider);
    final myAvatarUrl = myProfile?.avatarUrl;
    final myName = myProfile?.displayName ?? '';
    final teenConversationRestricted =
        !ref.watch(teenModePolicyProvider).canUseConversation(
              isReliefConversation: _isCustomerServiceThread ||
                  currentConversation?.isOfficialServiceUser == true,
            );
    final currentPeerUserId =
        currentConversation?.peerUserId ?? widget.peerUserId;
    final officialAccountScope =
        !effectiveIsGroup && _spaceId.isNotEmpty && currentUserId.isNotEmpty
            ? (
                siteId: SiteLineManager.instance.currentSite.id,
                spaceId: _spaceId,
                userId: currentUserId,
              )
            : null;
    final serviceThreadForDisplay =
        _isCustomerServiceThread ? _customerServiceThreadForDisplay() : null;
    final currentSpace = ref.watch(currentSpaceProvider);
    final accountSession = ref.watch(activeAccountSessionProvider);
    final accountScopeKey = accountSession?.scope.storageKeyHash;
    final draftTranslationSelections =
        ref.watch(draftTranslationSelectionStoreProvider);
    final customerTypingScopeKey =
        _isCustomerServiceThread && currentSpace != null
            ? customerServiceReminderScopeKey(
                spaceId: currentSpace.spaceId,
                userId: currentSpace.userId,
              )
            : null;
    final customerTypingPreviewMap = customerTypingScopeKey != null
        ? ref.watch(
            customerServiceTypingPreviewProvider(customerTypingScopeKey),
          )
        : const <String, CustomerServiceTypingPreview>{};
    final customerTypingPreview = _isCustomerServiceThread
        ? _typingPreviewFor(
            customerTypingPreviewMap,
            threadType: widget.customerServiceThreadType ?? 'temp_session',
            threadId: widget.customerServiceThreadId ?? '',
            conversationId: activeConversationId,
          )
        : null;
    final currentTitle = _isCustomerServiceThread
        ? (_usableCustomerServiceTitle(
                customerServiceProfile?.identity.displayName) ??
            _usableCustomerServiceTitle(serviceThreadForDisplay?.title) ??
            _usableCustomerServiceTitle(widget.title) ??
            '未知客户')
        : effectiveIsGroup
            ? (groupDetailValue?.title.isNotEmpty == true
                ? groupDetailValue!.title
                : currentConversation?.title.isNotEmpty == true
                    ? currentConversation!.title
                    : widget.title)
            : (currentConversation?.title.isNotEmpty == true
                ? currentConversation!.title
                : widget.title);
    final currentAvatarUrl = _isCustomerServiceThread
        ? (customerServiceProfile?.identity.avatarUrl ??
            serviceThreadForDisplay?.avatarUrl ??
            currentConversation?.avatarUrl ??
            widget.avatarUrl)
        : currentConversation?.avatarUrl ?? widget.avatarUrl;
    final currentMemberCount =
        groupDetailValue?.memberCount ?? currentConversation?.memberCount;
    final localDraft = ref.watch(
        chatDraftProvider((_spaceId, currentUserId, activeConversationId)));
    final initialDraft = localDraft.isLoading || localDraft.hasError
        ? null
        : localDraft.valueOrNull ?? currentConversation?.draft;
    final chatBackground =
        ref.watch(chatBackgroundProvider(activeConversationId));
    final receptionThread = _customerServiceDetail == null
        ? null
        : _customerServiceThreadForDisplay();
    final transferPermission = _isCustomerServiceThread
        ? _customerServiceActionPermission(
            CustomerServiceAction.transfer,
            capabilities: customerServiceCapabilities,
          )
        : null;
    final closePermission = _isCustomerServiceThread
        ? _customerServiceActionPermission(
            CustomerServiceAction.close,
            capabilities: customerServiceCapabilities,
          )
        : null;
    final autoTranslateSetting = ref.watch(
      autoTranslateEffectiveProvider(_autoTranslateScopeKey),
    );
    _scheduleAutoTranslationSync(
      messages: messagesAsync.valueOrNull ?? const <Message>[],
      setting: autoTranslateSetting,
      currentUserId: currentUserId,
    );
    final colorScheme = Theme.of(context).colorScheme;

    PreferredSizeWidget appBarWidget;
    if (_multiSelectMode) {
      appBarWidget = _MultiSelectAppBar(
        selectedCount: _selectedMessages.length,
        onCancel: _handleExitMultiSelect,
        onForward: () {
          // 多选转发：逐条转发选中消息
          if (_selectedMessages.isEmpty) return;
          unawaited(_handleForward(messageIds: _selectedMessages));
        },
      );
    } else {
      appBarWidget = _ChatAppBar(
        conversationId: activeConversationId,
        conversationType: currentConversation?.type ??
            (effectiveIsGroup
                ? ConversationType.group
                : ConversationType.direct),
        groupFeaturesBlocked: blocksGroupFeatures,
        title: currentTitle,
        avatarUrl: currentAvatarUrl,
        isGroup: effectiveIsGroup,
        subtitle: effectiveIsGroup && currentMemberCount != null
            ? '($currentMemberCount)'
            : null,
        memberCount: currentMemberCount,
        isQuickTranslating: _isQuickTranslating,
        readOnly: _isReadOnlyConversation,
        isCustomerServiceThread: _isCustomerServiceThread,
        autoTranslateStatusLabel: autoTranslateSetting.statusLabel,
        onCustomerProfile:
            _isCustomerServiceThread ? _openCustomerProfileSheet : null,
        onCustomerServiceTransfer:
            _isCustomerServiceThread && (transferPermission?.enabled ?? false)
                ? _openCustomerServiceTransferSheet
                : null,
        customerServiceSubtitle: _isCustomerServiceThread
            ? _customerServiceSubtitle(
                customerServiceProfile,
                serviceThreadForDisplay,
              )
            : null,
        onAutoTranslateSettings: () => unawaited(
          _showAutoTranslateSheet(
            messagesAsync.valueOrNull ?? const <Message>[],
            currentUserId,
          ),
        ),
        onQuickTranslate: () => unawaited(
          _handleQuickTranslate(
            messagesAsync.valueOrNull ?? const <Message>[],
            currentUserId,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: appBarWidget,
      body: Stack(
        children: [
          Positioned.fill(
            child: _ChatBackground(setting: chatBackground),
          ),
          Column(
            children: [
              // 营销工具栏（仅员工端显示）
              if (!widget.messagingOnly &&
                  isEmployee &&
                  !_isReadOnlyConversation)
                MarketingToolbar(
                  onToolClick: (toolId) {
                    AppToast.info(
                      context,
                      AppLocalizations.of(context)
                          .chatFeatureComingSoon(toolId),
                    );
                  },
                ),
              if (_shouldShowReceptionBar(receptionThread))
                _CustomerServiceReceptionBar(
                  thread: receptionThread!,
                  currentStaffUserId: space?.userId,
                  actionRunning: _isReceptionActionRunning,
                  onTakeover: () =>
                      _handleCustomerServiceTakeover(receptionThread),
                  onClose: closePermission?.enabled == true
                      ? () => _handleCustomerServiceClose(receptionThread)
                      : null,
                ),
              if (messageLoadStatus.$1 &&
                  messagesAsync.valueOrNull?.isNotEmpty == true)
                MaterialBanner(
                  content: Text(AppLocalizations.of(context).commonLoadFailed),
                  actions: [
                    TextButton(
                      onPressed: messageLoadStatus.$2
                          ? null
                          : () => ref.invalidate(chatProvider((
                                _spaceId,
                                activeConversationId,
                                effectiveIsGroup
                              ))),
                      child: Text(AppLocalizations.of(context).commonRetry),
                    ),
                  ],
                ),
              Expanded(
                child: messagesAsync.when(
                  // 首次加载时显示空列表而不是转圈，视觉更流畅
                  loading: () => _MessageList(
                    messages: const [],
                    chatBackground: chatBackground,
                    mediaPreviewLayoutCache: _mediaPreviewLayoutCache,
                    showEmptyState: false,
                    spaceId: _spaceId,
                    currentUserId: currentUserId,
                    officialSenderUserId: _isCustomerServiceThread
                        ? _customerServiceThreadDetailForSend().officialUserId
                        : null,
                    myAvatarUrl: myAvatarUrl,
                    myName: myName,
                    peerName: currentTitle,
                    peerAvatarUrl: currentAvatarUrl,
                    scrollController: _scrollController,
                    isGroup: _effectiveIsGroup,
                    conversationId: activeConversationId,
                    lastReadSeq: currentConversation?.lastReadSeq ?? 0,
                    mentionReminderReadSeq: _initialMentionLastReadSeq,
                    onSenderAvatarTap: (userId, isSelf) =>
                        _openMessageSenderProfile(
                      userId: userId,
                      isSelf: isSelf,
                      allowAddFriendFromGroup: allowAddFriendFromGroup,
                      accessContext: groupProfileAccessContext,
                    ),
                    multiSelectMode: _multiSelectMode,
                    selectedMessages: _selectedMessages,
                    onLongPress: (_, __) {},
                    onToggleSelect: (_) {},
                    onConvertVoiceToText: (_) {},
                    onViewportChanged: _handleMessageViewportChanged,
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(AppLocalizations.of(context).commonLoadFailed,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            )),
                        TextButton(
                          onPressed: () => ref.invalidate(chatProvider((
                            _spaceId,
                            activeConversationId,
                            _effectiveIsGroup
                          ))),
                          child: Text(AppLocalizations.of(context).commonRetry),
                        ),
                      ],
                    ),
                  ),
                  data: (msgs) {
                    _ensureScrollTargetLoaded(msgs);
                    return _MessageList(
                      messages: msgs,
                      chatBackground: chatBackground,
                      mediaPreviewLayoutCache: _mediaPreviewLayoutCache,
                      spaceId: _spaceId,
                      currentUserId: currentUserId,
                      officialSenderUserId: _isCustomerServiceThread
                          ? _customerServiceThreadDetailForSend().officialUserId
                          : null,
                      myAvatarUrl: myAvatarUrl,
                      myName: myName,
                      peerName: currentTitle,
                      peerAvatarUrl: currentAvatarUrl,
                      scrollController: _scrollController,
                      isGroup: _effectiveIsGroup,
                      conversationId: activeConversationId,
                      lastReadSeq: currentConversation?.lastReadSeq ?? 0,
                      mentionReminderReadSeq: _initialMentionLastReadSeq,
                      onSenderAvatarTap: (userId, isSelf) =>
                          _openMessageSenderProfile(
                        userId: userId,
                        isSelf: isSelf,
                        allowAddFriendFromGroup: allowAddFriendFromGroup,
                        accessContext: groupProfileAccessContext,
                      ),
                      multiSelectMode: _multiSelectMode,
                      selectedMessages: _selectedMessages,
                      onLongPress: _isReadOnlyConversation
                          ? (_, __) {}
                          : (msg, pos) => _handleLongPress(context, msg, pos),
                      onToggleSelect: (id) {
                        setState(() {
                          if (_selectedMessages.contains(id)) {
                            _selectedMessages.remove(id);
                          } else {
                            _selectedMessages.add(id);
                          }
                        });
                      },
                      scrollToMessageId: widget.scrollToMessageId,
                      onConvertVoiceToText: _isReadOnlyConversation
                          ? (_) {}
                          : (msg) => unawaited(_handleVoiceToText(msg)),
                      onCallLogTap:
                          widget.messagingOnly ? null : _handleCallLogTap,
                      onFailedTap: _isReadOnlyConversation
                          ? null
                          : (msg) => _showFailedMessageSheet(context, msg),
                      onViewportChanged: _handleMessageViewportChanged,
                    );
                  },
                ),
              ),
              // 回复预览条（对照 figma ChatPage 的 replyingTo 区域）
              if (_replyingTo != null)
                _ReplyPreview(
                  senderName: _replyingTo!.sender,
                  text: _replyingTo!.text,
                  onClose: () => setState(() => _replyingTo = null),
                ),
              if (!_customerServiceThreadEnded &&
                  customerTypingPreview != null &&
                  customerTypingPreview.previewText.isNotEmpty)
                _CustomerTypingPreviewBar(
                  previewText: customerTypingPreview.previewText,
                ),
              if (!_isReadOnlyConversation &&
                  !_customerServiceThreadEnded &&
                  !_customerServiceRequiresManualEntry &&
                  !teenConversationRestricted &&
                  !_notFriend)
                ScheduledMessageInputStatusBar(
                  status: _scheduledInputStatus,
                  onEditTask: _startEditingScheduledMessage,
                  onCancelTask: _cancelScheduledMessageFromInput,
                  onClearLocalDraft: _clearLocalScheduledSendAt,
                  onCancelEditing: _cancelScheduledMessageEdit,
                ),
              if (officialAccountScope != null)
                OfficialAccountMenuSlot(
                  scope: officialAccountScope,
                  peerUserId: currentPeerUserId,
                  isCustomer: currentSpace?.isCustomer == true,
                  isKnownOfficialConversation:
                      currentConversation?.isOfficialServiceUser == true,
                  onDecision: _handleOfficialAccountDecision,
                ),
              // 非好友提示 or 输入框。群全员禁言时仍展示工具栏，但统一置灰不可操作。
              if (_canClaimCustomerServiceThread)
                _CustomerServiceClaimNotice(
                  actionRunning: _isReceptionActionRunning,
                  onClaim: () => _handleCustomerServiceClaim(
                    _customerServiceThreadForDisplay(),
                  ),
                )
              else if (_isReadOnlyConversation)
                const _ReadOnlyConversationNotice()
              else if (_customerServiceThreadEnded)
                CustomerServiceEndedNotice(
                  statusLabel: _customerServiceChatState.statusLabel,
                  description: _customerServiceChatState.noticeDescription,
                  onRefresh: _handleCustomerServiceEndedRefresh,
                  refreshing: _isCustomerServiceEndedRefreshing,
                )
              else if (_customerServiceRequiresManualEntry)
                _CustomerServiceManualEntryNotice(
                  gate: _customerServiceChatState.replyGate,
                )
              else if (teenConversationRestricted)
                const _TeenModeConversationNotice()
              else if (_notFriend)
                const _NotFriendNotice()
              else
                ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SafeArea(
                    top: false,
                    child: ChatInputToolbar(
                      conversationId: activeConversationId,
                      translationSessionKey: accountSession?.sessionId,
                      translationSelections: draftTranslationSelections,
                      translationScopeKey: accountScopeKey == null
                          ? ''
                          : [
                              accountScopeKey,
                              _spaceId,
                              currentUserId,
                              _isCustomerServiceThread
                                  ? 'customer-service'
                                  : 'im',
                              _isCustomerServiceThread
                                  ? '${widget.customerServiceThreadType}:${widget.customerServiceThreadId}'
                                  : activeConversationId,
                            ].join('::'),
                      onTranslateDraft: accountScopeKey == null
                          ? null
                          : (content, language, cancellation) => ref
                              .read(translationRepositoryProvider)
                              .translateDraft(
                                content: content,
                                targetLanguage: language,
                                cancellation: cancellation,
                              ),
                      isGroup: _effectiveIsGroup,
                      isMuted: groupMutedForMe,
                      canSpeak: !groupMutedForMe,
                      muteReason: groupPermissions?.muteReason,
                      initialDraft: initialDraft,
                      scheduledSendAt: _localScheduledSendAt,
                      onScheduledSendAtChanged:
                          _handleLocalScheduledSendAtChanged,
                      scheduledMessageForEdit: _editingScheduledMessage,
                      onSendText: (text) async {
                        return _sendTextMessage(
                          text: text,
                          replyToMessageId: _replyingTo?.id,
                          clearReplyOnSuccess: true,
                        );
                      },
                      onSendTextRequest: (request) async {
                        return _sendTextMessage(
                          text: request.text,
                          mentions: request.mentions,
                          replyToMessageId: _replyingTo?.id,
                          clearReplyOnSuccess: true,
                        );
                      },
                      onScheduleText: _scheduleTextMessage,
                      onUpdateScheduledText: _updateScheduledTextMessage,
                      onCancelScheduledEdit: () {
                        if (_editingScheduledMessage != null && mounted) {
                          _cancelScheduledMessageEdit();
                        }
                      },
                      onSendVoice: _sendVoiceMessage,
                      onTranscribeVoice: _transcribeVoiceDraft,
                      onSendMedia: _handleSendMedia,
                      onVoiceCall: canStartCall
                          ? () => _startCall(isVideo: false)
                          : null,
                      onVideoCall:
                          canStartCall ? () => _startCall(isVideo: true) : null,
                      onSendFile: (filePath, fileName, mimeType, sizeBytes) =>
                          _handleSendFile(
                              filePath, fileName, mimeType, sizeBytes),
                      mentionCandidates: mentionCandidates,
                      canMentionAll: groupPermissions?.canAtAll ?? false,
                      onFavorite: () => context.push('/favorites'),
                      onSendContactCard: () => _handleSendContactCard(),
                      quickReplyScope: quickReplyScope,
                      aiReplyTarget: aiReplyTarget,
                      aiReplyContextText: aiReplyContextText,
                      externalInsertText: _externalInsertText,
                      externalInsertToken: _externalInsertToken,
                      inputSurfaceDismissToken: _inputSurfaceDismissToken,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _ensureGroupDetailRefreshTimer(bool effectiveIsGroup) {
    if (!effectiveIsGroup || _groupDetailRefreshTimer != null) return;
    _groupDetailRefreshTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!mounted) return;
      unawaited(
        ref.read(groupDetailProvider(widget.conversationId).notifier).refresh(),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Multi-select AppBar
// ---------------------------------------------------------------------------

class _MultiSelectAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int selectedCount;
  final VoidCallback onCancel;
  final VoidCallback onForward;

  const _MultiSelectAppBar({
    required this.selectedCount,
    required this.onCancel,
    required this.onForward,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: null,
      elevation: 0.5,
      leading: TextButton(
        onPressed: onCancel,
        child: Text(AppLocalizations.of(context).commonCancel,
            style: TextStyle(fontSize: 15, color: colorScheme.primary)),
      ),
      title: Text(
        AppLocalizations.of(context).chatSelectedCount(selectedCount),
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: selectedCount > 0 ? onForward : null,
          child: Text(
            AppLocalizations.of(context).chatMenuForward,
            style: TextStyle(
                fontSize: 15,
                color: selectedCount > 0
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// AppBar
// ---------------------------------------------------------------------------

class _CustomerServiceReceptionBar extends StatelessWidget {
  final CsThread thread;
  final String? currentStaffUserId;
  final bool actionRunning;
  final VoidCallback onTakeover;
  final VoidCallback? onClose;
  const _CustomerServiceReceptionBar({
    required this.thread,
    required this.currentStaffUserId,
    required this.actionRunning,
    required this.onTakeover,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isAi = thread.isAiHandled;
    final colorScheme = Theme.of(context).colorScheme;
    final assignedName = thread.assignedStaffDisplayName?.trim();
    final assignedToMe = thread.assignedStaffUserId?.isNotEmpty == true &&
        thread.assignedStaffUserId == currentStaffUserId;
    final title = isAi
        ? 'AI 正在接待'
        : assignedToMe || assignedName == null || assignedName.isEmpty
            ? '我正在接待'
            : '$assignedName 正在接待';
    final sourceLabel = _csChannelLabel(thread.source);
    final subtitle = isAi
        ? '客户消息由 AI 客服回复 · 来源 $sourceLabel'
        : '人工客服正在处理此会话 · 来源 $sourceLabel';
    final icon = isAi ? Icons.auto_awesome_outlined : Icons.support_agent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.65),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isAi ? const Color(0xFFEAF1FF) : const Color(0xFFEAF7F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: isAi ? const Color(0xFF2563EB) : const Color(0xFF059669),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
          ),
          if (isAi) ...[
            const SizedBox(width: 10),
            SizedBox(
              height: 32,
              child: FilledButton(
                onPressed: actionRunning ? null : onTakeover,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(86, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: _ReceptionActionLabel(
                  label: '人工接管',
                  loading: actionRunning,
                ),
              ),
            ),
          ],
          if (!isAi && onClose != null)
            IconButton(
              onPressed: actionRunning ? null : onClose,
              tooltip: '关闭会话',
              constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              icon: const Icon(Icons.close, size: 20),
            ),
        ],
      ),
    );
  }
}

String _csChannelLabel(String? source) {
  final value = source?.trim();
  if (value == null || value.isEmpty) return '未知';
  if (value.contains('抖音')) return '抖音';
  if (value.contains('微信')) return '微信';
  if (value.contains('网页') || value.contains('网站')) return '网页';
  if (value.contains('自有') || value.contains('APP') || value.contains('App')) {
    return '自有 App';
  }
  final normalized = value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  if (normalized.contains('douyin') || normalized.contains('tiktok')) {
    return '抖音';
  }
  if (normalized.contains('whatsapp') || normalized.contains('wathsup')) {
    return 'WhatsApp';
  }
  if (normalized.contains('telegram') || normalized == 'tg') {
    return 'Telegram';
  }
  if (normalized.contains('app') || normalized.contains('native')) {
    return '自有 App';
  }
  if (normalized.contains('widget') ||
      normalized.contains('web') ||
      normalized.contains('site')) {
    return '网页';
  }
  return value.length <= 16 ? value : '${value.substring(0, 16)}…';
}

class _ReceptionActionLabel extends StatelessWidget {
  final String label;
  final bool loading;

  const _ReceptionActionLabel({
    required this.label,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    return const SizedBox(
      width: 14,
      height: 14,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

({String label, String shortLabel, IdentityBadgeTone tone})?
    _chatPeerIdentityBadge(ConversationPeerIdentityKind kind) {
  return switch (kind) {
    ConversationPeerIdentityKind.customer => identityBadgeFor(userType: 1),
    ConversationPeerIdentityKind.customerService =>
      identityBadgeFor(customerTag: '客服'),
    ConversationPeerIdentityKind.admin => identityBadgeFor(customerTag: '管理员'),
    ConversationPeerIdentityKind.owner => identityBadgeFor(customerTag: '所有者'),
    ConversationPeerIdentityKind.employee ||
    ConversationPeerIdentityKind.unknown =>
      null,
  };
}

class _ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;
  final bool isGroup;
  final String conversationId;
  final ConversationType conversationType;
  final bool groupFeaturesBlocked;
  final String? subtitle;
  final int? memberCount;
  final bool isQuickTranslating;
  final bool readOnly;
  final bool isCustomerServiceThread;
  final String autoTranslateStatusLabel;
  final String? customerServiceSubtitle;
  final VoidCallback? onCustomerProfile;
  final VoidCallback? onCustomerServiceTransfer;
  final VoidCallback onAutoTranslateSettings;
  final VoidCallback onQuickTranslate;

  const _ChatAppBar({
    required this.title,
    this.avatarUrl,
    required this.isGroup,
    required this.conversationId,
    required this.conversationType,
    required this.groupFeaturesBlocked,
    this.subtitle,
    this.memberCount,
    required this.isQuickTranslating,
    this.readOnly = false,
    this.isCustomerServiceThread = false,
    required this.autoTranslateStatusLabel,
    this.customerServiceSubtitle,
    this.onCustomerProfile,
    this.onCustomerServiceTransfer,
    required this.onAutoTranslateSettings,
    required this.onQuickTranslate,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final spaceId = ref.watch(currentSpaceProvider)?.spaceId ?? '';
    final space = ref.watch(currentSpaceProvider);
    final convs =
        ref.watch(releaseVisibleConversationsProvider(spaceId)).valueOrNull ??
            [];
    final conv =
        convs.where((c) => c.conversationId == conversationId).firstOrNull;
    final unreadCount = calculateBackNavigationUnreadCount(
      convs,
      activeConversationId: conversationId,
    );
    ({String label, String shortLabel, IdentityBadgeTone tone})? identity;
    if (!isGroup &&
        conv?.peerUserId?.isNotEmpty == true &&
        space != null &&
        !space.isPersonal) {
      final contacts = [
        ...?ref.watch(tenantMembersProvider).valueOrNull,
        ...?ref.watch(friendsProvider).valueOrNull,
      ];
      int? directoryUserType;
      String? directoryRoleLabel;
      for (final contact in contacts) {
        if (contact.userId != conv!.peerUserId) continue;
        directoryUserType = contact.userType;
        directoryRoleLabel = contact.customerTag;
        break;
      }
      identity = _chatPeerIdentityBadge(
        resolveConversationPeerIdentity(
          peerUserType: conv?.peerUserType,
          directoryUserType: directoryUserType,
          directoryRoleLabel: directoryRoleLabel,
        ),
      );
    }

    // 企业空间单聊：副标题显示 @企业名称（参考微信，个人空间不显示）
    String? effectiveSubtitle = customerServiceSubtitle ?? subtitle;
    if (effectiveSubtitle == null &&
        !isGroup &&
        space != null &&
        !space.isPersonal) {
      final spacesAsync = ref.watch(spacesProvider);
      final companyName = spacesAsync.valueOrNull
          ?.where((s) => s.spaceId == space.spaceId)
          .map((s) => s.name)
          .firstOrNull;
      if (companyName != null && companyName.isNotEmpty) {
        effectiveSubtitle = companyName;
      }
    }
    final reserveSubtitleSlot = customerServiceSubtitle?.isNotEmpty == true ||
        isGroup ||
        (space != null && !space.isPersonal);

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.35),
              colorScheme.surface,
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(height: 0.5, color: colorScheme.outlineVariant),
      ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ChatBackButton(),
          Visibility(
            visible: unreadCount > 0,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: Container(
              constraints: const BoxConstraints(minWidth: 20),
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      leadingWidth: 80,
      title: reserveSubtitleSlot
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (identity != null) ...[
                      const SizedBox(width: 6),
                      IdentityBadge(
                        label: identity.label,
                        tone: identity.tone,
                        compact: true,
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: 15,
                  child: Text(
                    effectiveSubtitle ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (identity != null) ...[
                  const SizedBox(width: 6),
                  IdentityBadge(
                    label: identity.label,
                    tone: identity.tone,
                    compact: true,
                  ),
                ],
              ],
            ),
      centerTitle: true,
      actions: [
        if (onCustomerProfile != null)
          IconButton(
            tooltip: '客户资料',
            onPressed: onCustomerProfile,
            icon: Icon(
              Icons.badge_outlined,
              color: colorScheme.onSurface,
            ),
          ),
        if (isCustomerServiceThread)
          PopupMenuButton<String>(
            tooltip: '更多',
            icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
            onSelected: (value) {
              switch (value) {
                case 'auto_translate':
                  onAutoTranslateSettings();
                  break;
                case 'quick_translate':
                  if (!isQuickTranslating) onQuickTranslate();
                  break;
                case 'transfer':
                  onCustomerServiceTransfer?.call();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'auto_translate',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.translate_outlined),
                  title: const Text('自动翻译'),
                  subtitle: Text(autoTranslateStatusLabel),
                ),
              ),
              PopupMenuItem(
                value: 'quick_translate',
                enabled: !isQuickTranslating,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: isQuickTranslating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.translate_outlined),
                  title: const Text('翻译最近消息'),
                ),
              ),
              if (onCustomerServiceTransfer != null)
                PopupMenuItem(
                  value: 'transfer',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.switch_account_outlined),
                    title: Text(AppLocalizations.of(context)
                        .customerServiceTransferConversation),
                  ),
                ),
            ],
          )
        else ...[
          IconButton(
            tooltip:
                '${AppLocalizations.of(context).autoTranslateTitle}：$autoTranslateStatusLabel',
            onPressed: onAutoTranslateSettings,
            icon: Icon(
              Icons.translate_outlined,
              color: colorScheme.onSurface,
            ),
          ),
          if (!readOnly &&
              !(groupFeaturesBlocked &&
                  conversationType == ConversationType.tempSession))
            IconButton(
              icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
              onPressed: () {
                if (isGroup) {
                  context.push('/group-settings/$conversationId', extra: {
                    ...conversationRouteMetadata(
                      conversationId: conversationId,
                      conversationType: ConversationType.group,
                    ),
                    'title': title,
                    'avatarUrl': avatarUrl,
                    'memberCount': memberCount,
                  });
                } else {
                  context.push(
                    '/chat-settings/$conversationId',
                    extra: conversationRouteMetadata(
                      conversationId: conversationId,
                      conversationType: ConversationType.direct,
                    ),
                  );
                }
              },
            ),
        ],
      ],
    );
  }
}

class _CustomerProfileSheet extends ConsumerWidget {
  final String? customerUserId;
  final String? customerServiceThreadType;
  final String? customerServiceThreadId;
  final CustomerProfileCard fallbackCard;

  const _CustomerProfileSheet({
    required this.customerUserId,
    this.customerServiceThreadType,
    this.customerServiceThreadId,
    required this.fallbackCard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = customerUserId?.trim();
    final threadType = customerServiceThreadType?.trim();
    final threadId = customerServiceThreadId?.trim();
    final hasThreadContext =
        threadType?.isNotEmpty == true && threadId?.isNotEmpty == true;
    final asyncCard = hasThreadContext
        ? ref.watch(customerThreadProfileCardProvider((
            customerUserId: id ?? '',
            threadType: threadType!,
            threadId: threadId!,
          )))
        : id?.isNotEmpty == true
            ? ref.watch(customerProfileCardProvider(id!))
            : null;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.86,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: asyncCard == null
            ? _CustomerProfileContent(card: fallbackCard)
            : asyncCard.when(
                loading: () => const SizedBox(
                  height: 320,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => _CustomerProfileContent(
                  card: fallbackCard,
                  warning: '客户画像接口暂不可用',
                ),
                data: (card) => _CustomerProfileContent(card: card),
              ),
      ),
    );
  }
}

class _CustomerServiceTransferResult {
  final String toStaffUserId;
  final String? reason;

  const _CustomerServiceTransferResult({
    required this.toStaffUserId,
    this.reason,
  });
}

class _CustomerServiceTransferSheet extends StatefulWidget {
  final List<CustomerServiceTransferTarget> targets;

  const _CustomerServiceTransferSheet({required this.targets});

  @override
  State<_CustomerServiceTransferSheet> createState() =>
      _CustomerServiceTransferSheetState();
}

class _CustomerServiceTransferSheetState
    extends State<_CustomerServiceTransferSheet> {
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedUserId;

  @override
  void initState() {
    super.initState();
    _selectedUserId = widget.targets.firstOrNull?.userId;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '转交会话',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.targets.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final target = widget.targets[index];
                    final selected = target.userId == _selectedUserId;
                    return ListTile(
                      leading: UserAvatar(
                        avatarUrl: target.avatarUrl,
                        name: target.displayName,
                        size: 40,
                      ),
                      title: Text(
                        target.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: const Text('客服'),
                      trailing: selected
                          ? Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                            )
                          : const Icon(Icons.radio_button_unchecked),
                      onTap: () {
                        setState(() => _selectedUserId = target.userId);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: TextField(
                  controller: _reasonController,
                  minLines: 2,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    hintText: '添加备注（可选）',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: FilledButton(
                    onPressed: _selectedUserId == null
                        ? null
                        : () {
                            final reason = _reasonController.text.trim();
                            Navigator.of(context).pop(
                              _CustomerServiceTransferResult(
                                toStaffUserId: _selectedUserId!,
                                reason: reason.isEmpty ? null : reason,
                              ),
                            );
                          },
                    child: const Text('确认转交'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerProfileContent extends ConsumerWidget {
  final CustomerProfileCard card;
  final String? warning;

  const _CustomerProfileContent({
    required this.card,
    this.warning,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tzOffset = ref.watch(timezoneOffsetProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ProfileSection(
            title: '客户画像',
            icon: Icons.person_outline,
            children: [
              _ProfileLine(label: '姓名', value: card.identity.displayName),
              _ProfileLine(label: '等级', value: card.identity.level ?? '--'),
              _ProfileLine(
                  label: 'KYC', value: _kycLabel(card.identity.kycStatus)),
              _ProfileLine(
                  label: '风险', value: _riskLabel(card.identity.riskLevel)),
              _ProfileLine(label: '语言', value: card.identity.language ?? '--'),
              _ProfileLine(label: '来源', value: card.identity.source ?? '--'),
              _ProfileLine(
                label: '归属客服',
                value: card.identity.assignedStaffDisplayName ?? '--',
              ),
              _TagsLine(tags: card.identity.tags),
            ],
          ),
          if (warning != null) ...[
            const SizedBox(height: 12),
            _WarningBox(text: warning!),
          ],
          if (card.isRegisteredCustomer) ...[
            const SizedBox(height: 12),
            _ProfileSection(
              title: '账户概况',
              icon: Icons.account_balance_wallet_outlined,
              children: [
                _ProfileLine(
                  label: '账户余额',
                  value: card.isMasked('balance')
                      ? '--'
                      : _moneyText(card.account?.balance),
                ),
                _ProfileLine(
                  label: '累计入金',
                  value: _moneyText(card.account?.totalDeposit),
                ),
                _ProfileLine(
                  label: '净入金',
                  value: _moneyText(card.account?.netDeposit),
                ),
                _ProfileLine(
                  label: '账户状态',
                  value: _statusLabel(card.account?.accountStatus),
                ),
                _ProfileLine(
                  label: '注册日期',
                  value: _dateText(card.account?.registeredAt, tzOffset),
                ),
                _ProfileLine(label: 'IB', value: card.account?.ibCode ?? '--'),
              ],
            ),
            const SizedBox(height: 12),
            _ProfileSection(
              title: '历史交易概况',
              icon: Icons.business_center_outlined,
              children: [
                _ProfileLine(
                  label: '总订单',
                  value: card.trading?.totalOrders?.toString() ?? '--',
                ),
                _ProfileLine(
                  label: '交易产品',
                  value: card.trading?.products.isNotEmpty == true
                      ? card.trading!.products.join('、')
                      : '--',
                ),
                _ProfileLine(
                  label: '胜率',
                  value: _percentText(card.trading?.winRate),
                ),
                _ProfileLine(
                  label: '最近交易时间',
                  value: _dateTimeText(card.trading?.lastTradeAt, tzOffset),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _TemporaryOrdersSection(
              orders: card.temporaryOrders,
              timezoneOffset: tzOffset,
            ),
            const SizedBox(height: 12),
            _TicketSection(
              tickets: card.tickets,
              timezoneOffset: tzOffset,
            ),
          ] else ...[
            const SizedBox(height: 12),
            _ProfileSection(
              title: '访客画像',
              icon: Icons.travel_explore_outlined,
              children: [
                _ProfileLine(
                  label: '访客 ID',
                  value: card.visitor?.visitorId ?? '--',
                ),
                _ProfileLine(
                  label: '语言',
                  value: card.visitor?.locale ?? card.identity.language ?? '--',
                ),
                _ProfileLine(
                  label: '历史会话',
                  value: '${card.visitor?.totalSessions ?? 0}',
                ),
                _ProfileLine(
                  label: '来源页面',
                  value: card.visitor?.sourceUrl ?? '--',
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _WarningBox(text: '客户注册并绑定后可查看账户、交易和工单资料'),
          ],
        ],
      ),
    );
  }

  String _kycLabel(String? value) {
    return switch (value) {
      'verified' => '已认证',
      'pending' => '审核中',
      'rejected' => '未通过',
      null || '' => '--',
      _ => value,
    };
  }

  String _riskLabel(String? value) {
    return switch (value) {
      'low' => '低',
      'medium' => '中',
      'high' => '高',
      null || '' => '--',
      _ => value,
    };
  }

  String _statusLabel(String? value) {
    return switch (value) {
      'active' => '活跃',
      'disabled' => '停用',
      'frozen' => '冻结',
      null || '' => '--',
      _ => value,
    };
  }

  String _moneyText(num? value) {
    if (value == null) return '--';
    final fixed = value % 1 == 0 ? value.toInt().toString() : value.toString();
    return '\$$fixed';
  }

  String _percentText(num? value) {
    if (value == null) return '--';
    final percent = value <= 1 ? value * 100 : value;
    final fixed =
        percent % 1 == 0 ? percent.toInt().toString() : percent.toString();
    return '$fixed%';
  }

  String _dateText(DateTime? value, double tzOffset) {
    if (value == null) return '--';
    return formatDateWithTimezone(value, tzOffset);
  }

  String _dateTimeText(DateTime? value, double tzOffset) {
    if (value == null) return '--';
    return formatFullMinuteWithTimezone(value, tzOffset);
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ProfileSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileLine extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsLine extends StatelessWidget {
  final List<String> tags;

  const _TagsLine({required this.tags});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              '标签',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: tags.isEmpty
                ? Text(
                    '--',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 6,
                    runSpacing: 6,
                    children: tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TicketSection extends StatelessWidget {
  final List<CustomerTicketSummary> tickets;
  final double timezoneOffset;

  const _TicketSection({
    required this.tickets,
    required this.timezoneOffset,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _ProfileSection(
      title: '工单信息',
      icon: Icons.assignment_outlined,
      children: tickets.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '暂无工单',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ]
          : tickets
              .map(
                (ticket) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.title,
                        style: TextStyle(
                          fontSize: 15,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_ticketStatus(ticket.status)} · ${ticket.assigneeDisplayName ?? '未分配'} · ${_ticketTime(ticket.updatedAt, timezoneOffset)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(growable: false),
    );
  }

  String _ticketStatus(String status) {
    return switch (status) {
      'open' => '处理中',
      'pending' => '待处理',
      'closed' => '已关闭',
      _ => status,
    };
  }

  String _ticketTime(DateTime? value, double tzOffset) {
    if (value == null) return '--';
    return formatFullMinuteWithTimezone(value, tzOffset);
  }
}

class _TemporaryOrdersSection extends StatelessWidget {
  final List<CustomerTemporaryOrderSummary> orders;
  final double timezoneOffset;

  const _TemporaryOrdersSection({
    required this.orders,
    required this.timezoneOffset,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _ProfileSection(
      title: '临时订单数据',
      icon: Icons.receipt_long_outlined,
      children: orders.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '暂无临时订单',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ]
          : orders.map((order) => _orderCard(context, order)).toList(
                growable: false,
              ),
    );
  }

  Widget _orderCard(
    BuildContext context,
    CustomerTemporaryOrderSummary order,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final status = _orderStatus(order.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.product?.isNotEmpty == true ? order.product! : '订单',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _miniInfo(context, '单号',
                  order.orderId.isNotEmpty ? order.orderId : '--'),
              _miniInfo(context, '方向', _sideLabel(order.side)),
              _miniInfo(context, '手数', _numText(order.volume)),
              _miniInfo(context, '开仓价', _numText(order.price)),
              _miniInfo(
                context,
                '浮盈亏',
                _moneyText(order.floatingProfit),
              ),
              _miniInfo(context, '开仓时间', _dateTimeText(order.openedAt)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniInfo(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _sideLabel(String? value) {
    return switch (value?.toLowerCase()) {
      'buy' || 'long' => '买入',
      'sell' || 'short' => '卖出',
      null || '' => '--',
      _ => value!,
    };
  }

  String _orderStatus(String? value) {
    return switch (value?.toLowerCase()) {
      'open' || 'opened' || 'active' => '持仓中',
      'pending' => '挂单中',
      'closed' => '已平仓',
      'cancelled' || 'canceled' => '已取消',
      null || '' => '--',
      _ => value!,
    };
  }

  String _numText(num? value) {
    if (value == null) return '--';
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  String _moneyText(num? value) {
    if (value == null) return '--';
    final fixed = value % 1 == 0 ? value.toInt().toString() : value.toString();
    return '\$$fixed';
  }

  String _dateTimeText(DateTime? value) {
    if (value == null) return '--';
    return formatFullMinuteWithTimezone(value, timezoneOffset);
  }
}

class _WarningBox extends StatelessWidget {
  final String text;

  const _WarningBox({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: colorScheme.onTertiaryContainer,
          height: 1.4,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reply Preview Bar（对照 figma ChatPage replyingTo 区域）
// ---------------------------------------------------------------------------

class _ReplyPreview extends StatelessWidget {
  final String senderName;
  final String text;
  final VoidCallback onClose;

  const _ReplyPreview({
    required this.senderName,
    required this.text,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context).chatReplyTo(senderName),
                  style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerTypingPreviewBar extends StatelessWidget {
  final String previewText;

  const _CustomerTypingPreviewBar({required this.previewText});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        border: Border(top: BorderSide(color: colorScheme.tertiary)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.edit_note_outlined,
            size: 18,
            color: colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '客户正在输入：$previewText',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onTertiaryContainer,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 非好友提示（参考微信：「你已不是对方好友，无法发送消息」）
// ---------------------------------------------------------------------------

class _NotFriendNotice extends StatelessWidget {
  const _NotFriendNotice();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.block_outlined,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            AppLocalizations.of(context).chatNotFriendSendBlocked,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyConversationNotice extends StatelessWidget {
  const _ReadOnlyConversationNotice();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility_outlined,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            '会话查看模式，仅可查看，不能发言',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeenModeConversationNotice extends StatelessWidget {
  const _TeenModeConversationNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.teenModeRestrictedNotice,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.teenModeReliefHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerServiceClaimNotice extends StatelessWidget {
  final bool actionRunning;
  final VoidCallback onClaim;

  const _CustomerServiceClaimNotice({
    required this.actionRunning,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.support_agent_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '接入后可回复客户',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(
              height: 36,
              child: FilledButton(
                onPressed: actionRunning ? null : onClaim,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
                child: actionRunning
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Text('接入'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerServiceManualEntryNotice extends StatelessWidget {
  final CustomerServiceReplyGate gate;

  const _CustomerServiceManualEntryNotice({required this.gate});

  @override
  Widget build(BuildContext context) {
    final isClaim = gate == CustomerServiceReplyGate.claim;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isClaim ? Icons.support_agent_outlined : Icons.smart_toy_outlined,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            isClaim ? '请先接入会话后再回复' : '请先人工接管后再回复',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBackground extends StatelessWidget {
  final ChatBackgroundSetting setting;

  const _ChatBackground({required this.setting});

  @override
  Widget build(BuildContext context) {
    if (setting.hasImage) {
      return FutureBuilder<bool>(
        future: localFileExists(setting.imagePath!),
        builder: (context, snapshot) {
          if (snapshot.data != true) {
            return ColoredBox(color: setting.color);
          }
          return localImageWidget(
            setting.imagePath!,
            fit: BoxFit.cover,
          );
        },
      );
    }
    return ColoredBox(color: setting.color);
  }
}

// ---------------------------------------------------------------------------
// Message List
// ---------------------------------------------------------------------------

class _MessageList extends ConsumerWidget {
  final List<Message> messages;
  final ChatBackgroundSetting chatBackground;
  final MediaPreviewLayoutCache mediaPreviewLayoutCache;
  final bool showEmptyState;
  final String spaceId;
  final String currentUserId;
  final String? officialSenderUserId;
  final String? myAvatarUrl;
  final String? myName;
  final String? peerName;
  final String? peerAvatarUrl;
  final ScrollController scrollController;
  final bool isGroup;
  final String conversationId;
  final int lastReadSeq;
  final int? mentionReminderReadSeq;
  final Future<void> Function(String userId, bool isSelf) onSenderAvatarTap;
  final bool multiSelectMode;
  final Set<String> selectedMessages;
  final void Function(Message msg, Offset position) onLongPress;
  final void Function(String id) onToggleSelect;
  final String? scrollToMessageId;
  final void Function(Message msg)? onConvertVoiceToText;
  final void Function(Message msg)? onCallLogTap;
  final void Function(Message msg)? onFailedTap;
  final MessageViewportChanged onViewportChanged;

  const _MessageList({
    required this.messages,
    required this.chatBackground,
    required this.mediaPreviewLayoutCache,
    this.showEmptyState = true,
    required this.spaceId,
    required this.currentUserId,
    this.officialSenderUserId,
    this.myAvatarUrl,
    this.myName,
    this.peerName,
    this.peerAvatarUrl,
    required this.scrollController,
    required this.isGroup,
    required this.conversationId,
    this.lastReadSeq = 0,
    this.mentionReminderReadSeq,
    required this.onSenderAvatarTap,
    required this.multiSelectMode,
    required this.selectedMessages,
    required this.onLongPress,
    required this.onToggleSelect,
    this.scrollToMessageId,
    this.onConvertVoiceToText,
    this.onCallLogTap,
    this.onFailedTap,
    required this.onViewportChanged,
  });

  bool get _isSelfChat => conversationId.startsWith('self-');
  bool get _isPersonalSelf => conversationId == 'self-personal';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    mediaPreviewLayoutCache.useScope(spaceId, conversationId);
    final l10n = AppLocalizations.of(context);
    final tzOffset = ref.watch(timezoneOffsetProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final showGroupMemberNicknames = !isGroup ||
        ref.watch(
          groupMemberNicknamePreferenceProvider(
            groupMemberNicknamePreferenceScopeKey(
              spaceId: spaceId,
              conversationId: conversationId,
            ),
          ),
        );
    if (messages.isEmpty) {
      if (!showEmptyState) {
        return const SizedBox.expand();
      }
      if (_isSelfChat) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isPersonalSelf ? '🧑' : '👔',
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 16),
                Text(
                  _isPersonalSelf
                      ? l10n.chatPersonalNotesTitle
                      : l10n.chatWorkNotesTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isPersonalSelf
                      ? l10n.chatPersonalNotesDescription
                      : l10n.chatWorkNotesDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Center(
        child: Text(
          l10n.chatNoMessages,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      );
    }

    final mentionReminder = _latestUnreadMentionReminder();
    final mediaViewerItems = mediaViewerItemsFromMessages(messages);
    final viewportItemIds = List<String>.generate(messages.length, (index) {
      final message = messages[messages.length - 1 - index];
      final messageId = message.messageId.trim();
      if (messageId.isNotEmpty) return messageId;
      final clientMessageId = message.clientMsgId?.trim() ?? '';
      if (clientMessageId.isNotEmpty) return clientMessageId;
      return 'local:${message.conversationSeq}:$index';
    }, growable: false);
    final listView = MessageViewportList(
      itemIds: viewportItemIds,
      scrollController: scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      onViewportChanged: onViewportChanged,
      itemBuilder: (context, index) {
        // reverse: true 时 index 0 是最新消息，需要反转
        final realIndex = messages.length - 1 - index;
        final message = messages[realIndex];
        final officialMessage =
            isOfficialReceptionStaffMessage(message, officialSenderUserId);
        final isSelf = message.senderUserId == currentUserId || officialMessage;
        final senderName = officialMessage
            ? '官方号'
            : isSelf
                ? (myName ?? '')
                : _displayNameForSender(
                    context,
                    message,
                    preferFriendRemark: showGroupMemberNicknames,
                  );
        final senderAvatarUrl = officialMessage
            ? null
            : isSelf
                ? myAvatarUrl
                : _avatarUrlForSender(context, message) ?? peerAvatarUrl;
        final senderIdentity =
            !isSelf ? _identityForSender(context, message) : null;

        // 判断是否需要显示时间戳（与上一条消息间隔超过5分钟）
        // reverse 时，"上一条"是 realIndex + 1（更早的消息）
        bool showTimestamp = false;
        if (realIndex == 0) {
          showTimestamp = true; // 最早的消息总是显示时间
        } else {
          final prevMessage = messages[realIndex - 1];
          final diff = message.sentAt.difference(prevMessage.sentAt).abs();
          showTimestamp = diff.inMinutes >= 5;
        }

        // 滚动到指定消息（首次渲染后执行）。
        final targetRealIndex = scrollToMessageId == null
            ? -1
            : messages.indexWhere((m) => m.messageId == scrollToMessageId);
        final targetRenderIndex =
            targetRealIndex < 0 ? -1 : messages.length - 1 - targetRealIndex;
        if (scrollToMessageId != null &&
            message.messageId == scrollToMessageId &&
            index == targetRenderIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              // 估算目标位置（每条消息约 80px）
              final estimatedOffset = index * 80.0;
              scrollController.animateTo(
                estimatedOffset.clamp(
                    0.0, scrollController.position.maxScrollExtent),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          });
        }

        // 系统事件消息居中显示；text 为空时不渲染
        if (message.type == MessageType.event) {
          final text = message.body.text ?? '';
          if (text.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            // 时间戳分隔（微信风格，居中灰色小字）
            if (showTimestamp)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _formatMessageTime(message.sentAt, tzOffset),
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            GestureDetector(
              onTap: multiSelectMode
                  ? () => onToggleSelect(message.messageId)
                  : null,
              onLongPressStart: (details) {
                if (!multiSelectMode) {
                  onLongPress(message, details.globalPosition);
                }
              },
              child: Row(
                children: [
                  // 多选 checkbox
                  if (multiSelectMode)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        selectedMessages.contains(message.messageId)
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: selectedMessages.contains(message.messageId)
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  Expanded(
                    child: MessageBubble(
                      message: message,
                      enableTextActions: !multiSelectMode,
                      chatBackground: chatBackground,
                      mediaPreviewLayoutCache: mediaPreviewLayoutCache,
                      isSelf: isSelf,
                      currentUserId: currentUserId,
                      senderAvatarUrl: senderAvatarUrl,
                      senderName: senderName,
                      senderIdentityLabel:
                          isGroup ? senderIdentity?.label : null,
                      senderIdentityTone: isGroup ? senderIdentity?.tone : null,
                      senderAvatarBadgeLabel:
                          !isGroup ? senderIdentity?.shortLabel : null,
                      senderAvatarBadgeTone:
                          !isGroup ? senderIdentity?.tone : null,
                      showSenderInfo: shouldShowGroupSenderInfo(
                        isGroup: isGroup,
                        isSelf: isSelf,
                      ),
                      onAvatarTap: isSelf && !officialMessage
                          ? () => unawaited(
                                onSenderAvatarTap(currentUserId, true),
                              )
                          : message.senderUserId.isNotEmpty
                              ? () => unawaited(
                                    onSenderAvatarTap(
                                      message.senderUserId,
                                      false,
                                    ),
                                  )
                              : null,
                      onConvertVoiceToText: message.type == MessageType.voice
                          ? () => onConvertVoiceToText?.call(message)
                          : null,
                      onCallLogTap: message.type == MessageType.callLog
                          ? () => onCallLogTap?.call(message)
                          : null,
                      mediaViewerItems: mediaViewerItems,
                      // 查找被引用的消息，传给气泡显示引用内容
                      replyMessage: message.replyToMessageId != null
                          ? messages
                              .where((m) =>
                                  m.messageId == message.replyToMessageId)
                              .firstOrNull
                          : null,
                      replySenderName: message.replyToMessageId != null
                          ? (() {
                              final replied = messages
                                  .where((m) =>
                                      m.messageId == message.replyToMessageId)
                                  .firstOrNull;
                              if (replied == null) return null;
                              return replied.senderUserId == currentUserId
                                  ? (myName ?? l10n.chatSelf)
                                  : _displayNameForSender(
                                      context,
                                      replied,
                                      preferFriendRemark:
                                          showGroupMemberNicknames,
                                    );
                            })()
                          : null,
                      groupId: isGroup ? conversationId : null,
                      onGroupReadReceiptTap: const MessageReadReceiptService()
                              .canShowGroupReadReceipt(
                        message,
                        isSelf: isSelf,
                        isGroup: isGroup,
                      )
                          ? () => context.push(
                                '/group-read-receipts/'
                                '${Uri.encodeComponent(conversationId)}/'
                                '${Uri.encodeComponent(message.messageId)}'
                                '?seq=${message.conversationSeq}',
                              )
                          : null,
                      onFailedTap: message.status.isSendFailure && isSelf
                          ? () => onFailedTap?.call(message)
                          : null,
                      onTrustedMediaDimensionsResolved:
                          (resolvedMessage, displaySize) {
                        final clientMsgId = resolvedMessage.clientMsgId?.trim();
                        final stableMessageId =
                            clientMsgId != null && clientMsgId.isNotEmpty
                                ? clientMsgId
                                : resolvedMessage.messageId.trim();
                        if (stableMessageId.isEmpty ||
                            displaySize.width <= 0 ||
                            displaySize.height <= 0) {
                          return;
                        }
                        unawaited(
                          ref
                              .read(chatProvider((
                                spaceId,
                                conversationId,
                                isGroup,
                              )).notifier)
                              .enrichLocalMediaDimensions(
                                messageId: stableMessageId,
                                type: resolvedMessage.type,
                                displayWidth: displaySize.width.round(),
                                displayHeight: displaySize.height.round(),
                              )
                              .catchError(
                                  (Object error, StackTrace stackTrace) {
                            debugPrint(
                              '[ChatPage] persist media dimensions failed: '
                              '$error',
                            );
                          }),
                        );
                      },
                      // 时间仅由居中的五分钟分隔展示，避免每条消息重复时间。
                      showTimestamp: false,
                    ),
                  ),
                ],
              ),
            ), // GestureDetector
          ], // Column children
        ); // Column
      },
    );
    if (mentionReminder == null) return listView;
    return Stack(
      children: [
        listView,
        Positioned(
          top: 8,
          left: 12,
          right: 12,
          child: _MentionReminderJumpBar(
            kind: mentionReminder.kind,
            onTap: () => _scrollToMessage(mentionReminder.messageId),
          ),
        ),
      ],
    );
  }

  UnreadMentionReminder? _latestUnreadMentionReminder() {
    return latestUnreadMentionReminderForMessages(
      messages: messages,
      currentUserId: currentUserId,
      isGroup: isGroup,
      lastReadSeq: mentionReminderReadSeq ?? lastReadSeq,
    );
  }

  void _scrollToMessage(String messageId) {
    final realIndex = messages.indexWhere((m) => m.messageId == messageId);
    if (!scrollController.hasClients) return;
    if (realIndex < 0) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }
    final renderIndex = messages.length - 1 - realIndex;
    final estimatedOffset = renderIndex * 80.0;
    scrollController.animateTo(
      estimatedOffset.clamp(0.0, scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeInOut,
    );
  }

  String _displayNameForSender(
    BuildContext context,
    Message message, {
    required bool preferFriendRemark,
  }) {
    final state = context.findAncestorStateOfType<_ChatPageState>();
    final name = state?._displayNameForUser(
      message.senderUserId,
      preferFriendRemark: preferFriendRemark,
    );
    if (name?.trim().isNotEmpty == true) return name!.trim();
    return peerName ?? AppLocalizations.of(context).chatPeer;
  }

  String? _avatarUrlForSender(BuildContext context, Message message) {
    final state = context.findAncestorStateOfType<_ChatPageState>();
    return state?._avatarUrlForUser(message.senderUserId);
  }

  ({String label, String shortLabel, IdentityBadgeTone tone})?
      _identityForSender(BuildContext context, Message message) {
    final state = context.findAncestorStateOfType<_ChatPageState>();
    return state?._identityForUser(message.senderUserId);
  }
}

class _MentionReminderJumpBar extends StatelessWidget {
  final MentionReminderKind kind;
  final VoidCallback onTap;

  const _MentionReminderJumpBar({
    required this.kind,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = kind == MentionReminderKind.me ? '有 @你的消息' : '有 @所有人的消息';
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: const Color(0xFF2F6FED).withValues(alpha: 0.22),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.22),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.alternate_email_rounded,
                  size: 15,
                  color: Color(0xFF2F6FED),
                ),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2F6FED),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '查看',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.66),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 时间格式化辅助函数
// ---------------------------------------------------------------------------

String _formatMessageTime(DateTime dt, double tzOffset) {
  return formatChatSeparatorTime(dt, tzOffset);
}

// ---------------------------------------------------------------------------
// 转发会话选择页面（全屏，参考微信"选择聊天"页面）
// ---------------------------------------------------------------------------

class _ForwardSelectPage extends StatefulWidget {
  final List<Conversation> conversations;

  const _ForwardSelectPage({required this.conversations});

  @override
  State<_ForwardSelectPage> createState() => _ForwardSelectPageState();
}

class _ForwardSelectPageState extends State<_ForwardSelectPage> {
  String _query = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = _query.isEmpty
        ? widget.conversations
        : widget.conversations.where((c) {
            final title = c.title.toLowerCase();
            return title.contains(_query.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: null,
      appBar: AppBar(
        backgroundColor: null,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonClose,
              style: TextStyle(color: colorScheme.primary, fontSize: 16)),
        ),
        title: Text(l10n.chatForwardSelectTitle,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 搜索框
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l10n.commonSearch,
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                prefixIcon: Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 会话列表
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final conv = filtered[i];
                final title = conv.title;
                final isGroup = conv.type == ConversationType.group ||
                    conv.type == ConversationType.tempSession;
                return Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(conv),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              isGroup
                                  ? ConversationAvatar(
                                      conversation: conv,
                                      isPersonal: true,
                                      isEmployee: false,
                                      showIdentity: false,
                                    )
                                  : UserAvatar(
                                      avatarUrl: conv.avatarUrl,
                                      name: title,
                                      size: 48,
                                      borderRadius: 24,
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: colorScheme.onSurface)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (i < filtered.length - 1)
                        Divider(
                          height: 1,
                          indent: 76,
                          color: colorScheme.outlineVariant,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 名片联系人选择结果
// ---------------------------------------------------------------------------

class _ContactPickResult {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  const _ContactPickResult(
      {required this.userId, required this.displayName, this.avatarUrl});
}

// ---------------------------------------------------------------------------
// 名片联系人选择页面（全屏，参考微信"选择朋友"）
// ---------------------------------------------------------------------------

class _ContactPickPage extends ConsumerStatefulWidget {
  const _ContactPickPage();

  @override
  ConsumerState<_ContactPickPage> createState() => _ContactPickPageState();
}

class _ContactPickPageState extends ConsumerState<_ContactPickPage> {
  String _query = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final friendsAsync = ref.watch(friendsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: null,
      appBar: AppBar(
        backgroundColor: null,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.chatContactSelectTitle,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 搜索框
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l10n.commonSearch,
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                prefixIcon: Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: friendsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(child: Text(l10n.commonLoadFailed)),
              data: (friends) {
                final filtered = _query.isEmpty
                    ? friends
                    : friends
                        .where((f) => f.displayName
                            .toLowerCase()
                            .contains(_query.toLowerCase()))
                        .toList();
                if (filtered.isEmpty) {
                  return Center(
                      child: Text(l10n.chatNoContacts,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          )));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final f = filtered[i];
                    return Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(
                              _ContactPickResult(
                                userId: f.userId,
                                displayName: f.displayName,
                                avatarUrl: f.avatarUrl,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  UserAvatar(
                                    avatarUrl: f.avatarUrl,
                                    name: f.displayName,
                                    size: 48,
                                    borderRadius: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(f.displayName,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: colorScheme.onSurface)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (i < filtered.length - 1)
                            Divider(
                                height: 1,
                                indent: 76,
                                color: colorScheme.outlineVariant),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 微信风格长按菜单
// ---------------------------------------------------------------------------

class _WxMenuItem {
  final String value;
  final IconData icon;
  final String label;
  final bool danger;
  const _WxMenuItem(this.value, this.icon, this.label, {this.danger = false});
}

class _WxMessageMenu extends StatelessWidget {
  final Offset position;
  final List<_WxMenuItem> items;
  final Size screenSize;

  const _WxMessageMenu({
    required this.position,
    required this.items,
    required this.screenSize,
  });

  static const double _itemW = 64.0;
  static const double _itemH = 64.0;
  static const int _maxCols = 5;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final availableW = screenSize.width - 16;
    var cols = (availableW / _itemW).floor();
    if (cols < 1) cols = 1;
    if (cols > _maxCols) cols = _maxCols;
    final menuW = _itemW * cols;

    // 每行最多 5 个，计算行数
    final rows = (items.length / cols).ceil();
    final menuH = rows * _itemH + 12.0; // 12 = padding

    // 计算菜单位置：优先显示在长按点上方，避免超出屏幕
    double left = position.dx - menuW / 2;
    double top = position.dy - menuH - 16;

    // 左右边界保护
    if (left < 8) left = 8;
    if (left + menuW > screenSize.width - 8) {
      left = screenSize.width - menuW - 8;
    }
    // 上方空间不足时显示在下方
    if (top < 80) top = position.dy + 16;
    if (top + menuH > screenSize.height - 8) {
      top = screenSize.height - menuH - 8;
    }
    if (top < 8) top = 8;

    return Stack(
      children: [
        // 点击空白区域关闭
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),
        ),
        // 菜单主体
        Positioned(
          left: left,
          top: top,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: menuW,
              decoration: BoxDecoration(
                color: colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Wrap(
                children:
                    items.map((item) => _buildItem(context, item)).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, _WxMenuItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final color =
        item.danger ? colorScheme.error : colorScheme.onInverseSurface;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(item.value),
      child: SizedBox(
        width: _itemW,
        height: _itemH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(fontSize: 11, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
