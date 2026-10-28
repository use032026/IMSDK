import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:im_sdk/core/admin/admin_access.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/auth/presentation/providers/effective_space_provider.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/customer_service/application/customer_service_reception_service.dart';
import 'package:im_sdk/features/customer_service/application/customer_service_ai_reply_controller.dart';
import 'package:im_sdk/features/customer_service/data/datasources/customer_service_remote_datasource.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/features/customer_service/data/repositories/customer_service_repository.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_realtime_models.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_role_capabilities.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_unread_ledger.dart';

final customerServiceRepositoryProvider =
    Provider<CustomerServiceRepository>((ref) {
  return CustomerServiceRepository(
    CustomerServiceRemoteDataSource(ref.watch(dioProvider)),
  );
}, dependencies: [dioProvider]);

final customerServiceReceptionServiceProvider =
    Provider<CustomerServiceReceptionService>((ref) {
  return CustomerServiceReceptionService(
    ref.watch(customerServiceRepositoryProvider),
  );
}, dependencies: [customerServiceRepositoryProvider]);

final adminCustomerServiceRepositoryProvider =
    Provider<AdminCustomerServiceRepository>((ref) {
  return AdminCustomerServiceRepository(
    AdminCustomerServiceRemoteDataSource(ref.watch(adminDioProvider)),
  );
}, dependencies: [adminDioProvider]);

final currentCustomerServiceRoleCapabilitiesProvider =
    Provider<CustomerServiceRoleCapabilities>((ref) {
  final space = ref.watch(effectiveCurrentSpaceProvider);
  return customerServiceRoleCapabilities(
    membershipRole: space?.membershipRole,
  );
}, dependencies: [effectiveCurrentSpaceProvider]);

final customerServiceTypingPreviewProvider = StateNotifierProvider.family<
    CustomerServiceTypingPreviewNotifier,
    Map<String, CustomerServiceTypingPreview>,
    String>((ref, scopeKey) {
  return CustomerServiceTypingPreviewNotifier();
});

final customerServiceTransferNoticeProvider = StateNotifierProvider<
    CustomerServiceTransferNoticeNotifier,
    List<CustomerServiceTransferNotice>>((ref) {
  return CustomerServiceTransferNoticeNotifier();
});

class CustomerServiceTransferNoticeNotifier
    extends StateNotifier<List<CustomerServiceTransferNotice>> {
  CustomerServiceTransferNoticeNotifier() : super(const []);

  void apply({
    required String threadType,
    required String threadId,
    required String conversationId,
    String? customerUserId,
    String? fromStaffUserId,
    required String toStaffUserId,
    String? reason,
    String? recipientRole,
    required String currentStaffUserId,
    DateTime? transferredAt,
  }) {
    final notice = createCustomerServiceTransferNotice(
      CustomerServiceTransferNoticeEvent(
        threadType: threadType,
        threadId: threadId,
        conversationId: conversationId,
        customerUserId: customerUserId,
        fromStaffUserId: fromStaffUserId,
        toStaffUserId: toStaffUserId,
        reason: reason,
        recipientRole: recipientRole,
      ),
      currentStaffUserId: currentStaffUserId,
      receivedAt: transferredAt,
    );
    if (notice == null) return;
    state = [
      notice,
      ...state.where((item) => item.threadKey != notice.threadKey),
    ].take(5).toList(growable: false);
  }

  void dismiss(String noticeId) {
    state = state.where((item) => item.noticeId != noticeId).toList();
  }

  void clear() {
    state = const [];
  }
}

class CustomerServiceTypingPreviewNotifier
    extends StateNotifier<Map<String, CustomerServiceTypingPreview>> {
  final Map<String, DateTime> _lastEventAt = {};

  CustomerServiceTypingPreviewNotifier() : super(const {});

  void apply({
    required String threadType,
    required String threadId,
    required String conversationId,
    required bool isTyping,
    String? preview,
    String? senderRole,
    String? senderUserId,
    DateTime? at,
  }) {
    final primaryId = threadId.trim().isNotEmpty ? threadId : conversationId;
    if (primaryId.trim().isEmpty) return;
    final event = CustomerServiceTypingPreviewEvent(
      threadId: primaryId,
      threadType: threadType,
      isTyping: isTyping,
      previewText: preview,
      senderRole: senderRole,
      senderUserId: senderUserId,
      receivedAt: at ?? DateTime.now(),
    );
    final result = reduceCustomerServiceTypingPreview(event);
    final keys = {
      _key(threadType, primaryId),
      if (conversationId.trim().isNotEmpty) _key(threadType, conversationId),
    };
    if (result == null) return;
    for (final key in keys) {
      final lastEventAt = _lastEventAt[key];
      if (lastEventAt != null && event.receivedAt.isBefore(lastEventAt)) {
        continue;
      }
      _lastEventAt[key] = event.receivedAt;
      if (result == CustomerServiceTypingPreviewResult.clear) {
        _clearKey(key);
      } else {
        state = {
          ...state,
          key: result as CustomerServiceTypingPreview,
        };
      }
    }
  }

  void clear({
    required String threadType,
    required String threadId,
    required String conversationId,
    DateTime? at,
  }) {
    apply(
      threadType: threadType,
      threadId: threadId,
      conversationId: conversationId,
      isTyping: false,
      senderRole: 'customer',
      at: at,
    );
  }

  CustomerServiceTypingPreview? previewFor({
    required String threadType,
    required String threadId,
    required String conversationId,
  }) {
    final normalizedThreadType =
        threadType.trim().isEmpty ? 'temp_session' : threadType;
    return state[_key(normalizedThreadType, threadId)] ??
        state[_key(normalizedThreadType, conversationId)];
  }

  void _clearKey(String key) {
    if (!state.containsKey(key)) return;
    final next = Map<String, CustomerServiceTypingPreview>.from(state)
      ..remove(key);
    state = next;
  }

  static String _key(String threadType, String id) {
    final normalizedType = normalizeCustomerServiceThreadType(threadType);
    return '$normalizedType:${id.trim()}';
  }

  @override
  void dispose() {
    _lastEventAt.clear();
    super.dispose();
  }
}

final adminAccessibleTenantsProvider =
    FutureProvider<List<AdminAccessibleTenant>>((ref) async {
  final platformToken = ref.watch(authProvider).valueOrNull?.platformToken;
  if (platformToken == null || platformToken.isEmpty) return const [];
  try {
    final resp = await ref.watch(dioProvider).get<Map<String, dynamic>>(
          '/api/platform/v1/my/admin-tenants',
          options: Options(headers: {
            'Authorization': 'Bearer $platformToken',
          }),
        );
    final raw = resp.data?['data'] as List<dynamic>? ?? const [];
    return raw
        .whereType<Map>()
        .map(
            (e) => AdminAccessibleTenant.fromJson(Map<String, dynamic>.from(e)))
        .where((tenant) => tenant.canAccess)
        .toList(growable: false);
  } catch (_) {
    return const [];
  }
}, dependencies: [dioProvider]);

final currentSpaceHasAdminConsoleAccessProvider = Provider<bool>((ref) {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || !space.isEmployee) return false;
  if (ref
      .watch(currentCustomerServiceRoleCapabilitiesProvider)
      .canUseManagementReadonly) {
    return true;
  }
  final tenants = ref.watch(adminAccessibleTenantsProvider).valueOrNull;
  return tenants?.any(
        (tenant) =>
            tenant.tenantId == space.spaceId &&
            tenant.hasManagementConsoleAccess,
      ) ??
      false;
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  currentCustomerServiceRoleCapabilitiesProvider,
  adminAccessibleTenantsProvider,
]);

final currentSpaceAdminAccessibleTenantProvider =
    Provider<AdminAccessibleTenant?>((ref) {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || !space.isEmployee) return null;
  final tenants = ref.watch(adminAccessibleTenantsProvider).valueOrNull;
  for (final tenant in tenants ?? const <AdminAccessibleTenant>[]) {
    if (tenant.tenantId == space.spaceId) return tenant;
  }
  return null;
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  adminAccessibleTenantsProvider,
]);

final customerServiceThreadsProvider =
    FutureProvider<CsThreadsData>((ref) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null) return const CsThreadsData([], []);
  if (!ref
      .watch(currentCustomerServiceRoleCapabilitiesProvider)
      .canUseStaffEndpoints) {
    throw StateError('当前角色不是客服，不能调用客服工作台接口');
  }
  final data = await ref.read(customerServiceRepositoryProvider).getThreads();
  final scopeKey = customerServiceReminderScopeKey(
      spaceId: space.spaceId, userId: space.userId);
  ref
      .read(customerServiceThreadIdentityIndexProvider(scopeKey).notifier)
      .rememberAll(
        [...data.queueItems, ...data.activeItems]
            .map(_customerServiceThreadIdentity),
      );
  return data;
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  currentCustomerServiceRoleCapabilitiesProvider,
  customerServiceRepositoryProvider,
]);

final customerServiceUnreadLedgerProvider = StateNotifierProvider.family<
    CustomerServiceUnreadLedgerNotifier,
    CustomerServiceUnreadLedger,
    String>((ref, scopeKey) {
  return CustomerServiceUnreadLedgerNotifier();
});

final customerServiceThreadIdentityIndexProvider = StateNotifierProvider.family<
    CustomerServiceThreadIdentityIndexNotifier,
    CustomerServiceThreadIdentityIndex,
    String>((ref, scopeKey) {
  return CustomerServiceThreadIdentityIndexNotifier();
});

class CustomerServiceUnreadLedgerNotifier
    extends StateNotifier<CustomerServiceUnreadLedger> {
  CustomerServiceUnreadLedgerNotifier()
      : super(const CustomerServiceUnreadLedger());

  void record(CustomerServiceIncomingMessage message) {
    state = state.record(message);
  }

  void clear({
    required String threadId,
    required String conversationId,
  }) {
    state = state.clear(
      threadId: threadId,
      conversationId: conversationId,
      clearedAt: DateTime.now(),
    );
  }
}

class CustomerServiceThreadIdentityIndexNotifier
    extends StateNotifier<CustomerServiceThreadIdentityIndex> {
  CustomerServiceThreadIdentityIndexNotifier()
      : super(const CustomerServiceThreadIdentityIndex());

  void remember(CustomerServiceThreadIdentity identity) {
    state = state.remember(identity);
  }

  void rememberAll(Iterable<CustomerServiceThreadIdentity> identities) {
    state = state.rememberAll(identities);
  }
}

String customerServiceReminderScopeKey({
  required String spaceId,
  required String userId,
}) {
  return '${spaceId.trim()}:${userId.trim()}';
}

final customerServiceEffectiveThreadsProvider =
    Provider<AsyncValue<CsThreadsData>>((ref) {
  final threads = ref.watch(customerServiceThreadsProvider);
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null) return threads;
  final scopeKey = customerServiceReminderScopeKey(
    spaceId: space.spaceId,
    userId: space.userId,
  );
  final ledger = ref.watch(customerServiceUnreadLedgerProvider(scopeKey));
  return threads.whenData(
    (data) => applyCustomerServiceRealtimeUnread(data, ledger),
  );
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  customerServiceThreadsProvider,
]);

final customerServiceReminderProjectionProvider =
    Provider<CustomerServiceReminderProjection>((ref) {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  final threads = ref.watch(customerServiceThreadsProvider).valueOrNull;
  if (space == null) {
    return const CustomerServiceReminderProjection(
      totalCount: 0,
      onlineCount: 0,
      totalMessageCount: 0,
      onlineMessageCount: 0,
    );
  }
  final scopeKey = customerServiceReminderScopeKey(
    spaceId: space.spaceId,
    userId: space.userId,
  );
  final ledger = ref.watch(customerServiceUnreadLedgerProvider(scopeKey));
  return projectCustomerServiceReminders(
    threads: _customerServiceReminderSnapshots(threads),
    realtimeLedger: ledger,
  );
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  customerServiceThreadsProvider,
]);

final customerServiceWorkbenchReminderCountProvider = Provider<int?>((ref) {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null) return null;
  final threads = ref.watch(customerServiceThreadsProvider).valueOrNull;
  final scopeKey = customerServiceReminderScopeKey(
    spaceId: space.spaceId,
    userId: space.userId,
  );
  final ledger = ref.watch(customerServiceUnreadLedgerProvider(scopeKey));
  if (threads == null && ledger.entries.isEmpty) return null;
  // 工作台只提醒在线客服临时会话；普通客户私聊归消息页提醒。
  return ref
      .watch(customerServiceReminderProjectionProvider)
      .onlineMessageCount;
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  customerServiceThreadsProvider,
  customerServiceReminderProjectionProvider,
]);

CsThreadsData applyCustomerServiceRealtimeUnread(
  CsThreadsData threads,
  CustomerServiceUnreadLedger ledger,
) {
  CsThread apply(CsThread thread) {
    final identity = _customerServiceThreadIdentity(thread);
    final effectiveUnread = ledger.resolveUnread(
      identity: identity,
      serverUnreadCount: thread.unreadCount,
      serverLastMessageAt: thread.lastMessageAt,
    );
    final latest = ledger.latestFor(identity);
    final effectiveLastMessageAt = latest != null &&
            (thread.lastMessageAt == null ||
                latest.lastMessageAt.isAfter(thread.lastMessageAt!))
        ? latest.lastMessageAt
        : thread.lastMessageAt;
    final effectivePreview = latest?.latestPreview?.trim().isNotEmpty == true
        ? latest!.latestPreview
        : thread.lastMessagePreview;
    if (effectiveUnread == thread.unreadCount &&
        effectiveLastMessageAt == thread.lastMessageAt &&
        effectivePreview == thread.lastMessagePreview) {
      return thread;
    }
    return thread.copyWith(
      unreadCount: effectiveUnread,
      lastMessageAt: effectiveLastMessageAt,
      lastMessagePreview: effectivePreview,
    );
  }

  return CsThreadsData(
    projectCustomerServiceQueueDisplay(
      threads.queueItems.map(apply).toList(growable: false),
    ),
    threads.activeItems.map(apply).toList(growable: false),
  );
}

Iterable<CustomerServiceThreadReminderSnapshot>
    _customerServiceReminderSnapshots(CsThreadsData? threads) sync* {
  if (threads == null) return;
  for (final thread in [...threads.queueItems, ...threads.activeItems]) {
    yield CustomerServiceThreadReminderSnapshot(
      identity: _customerServiceThreadIdentity(thread),
      isQueued: thread.isQueued,
      serverUnreadCount: thread.unreadCount,
      lastMessageAt: thread.lastMessageAt,
    );
  }
}

CustomerServiceThreadIdentity _customerServiceThreadIdentity(CsThread thread) {
  return CustomerServiceThreadIdentity(
    handoffMode: thread.handoffMode,
    officialUserId: thread.officialUserId,
    assignedStaffUserId: thread.assignedStaffUserId,
    threadType: thread.threadType,
    threadId: thread.threadId,
    conversationId: thread.conversationId,
  );
}

final customerServiceStaffHistoryProvider =
    FutureProvider<List<CsThread>>((ref) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null) return const <CsThread>[];
  if (!ref
      .watch(currentCustomerServiceRoleCapabilitiesProvider)
      .canUseStaffEndpoints) {
    throw StateError('当前角色不是客服，不能调用客服接待历史接口');
  }
  return ref
      .read(customerServiceRepositoryProvider)
      .getStaffServiceHistory(threadType: 'temp_session', limit: 50);
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  currentCustomerServiceRoleCapabilitiesProvider,
  customerServiceRepositoryProvider,
]);

final customerServiceDashboardProvider =
    FutureProvider<CsDashboardData>((ref) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null) return const CsDashboardData();
  if (!ref
      .watch(currentCustomerServiceRoleCapabilitiesProvider)
      .canUseStaffEndpoints) {
    throw StateError('当前角色不是客服，不能调用客服工作台接口');
  }
  return ref.read(customerServiceRepositoryProvider).getDashboard();
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  currentCustomerServiceRoleCapabilitiesProvider,
  customerServiceRepositoryProvider,
]);

final customerProfileCardProvider =
    FutureProvider.family<CustomerProfileCard, String>((ref, customerUserId) {
  if (customerUserId.trim().isEmpty) {
    throw StateError('缺少客户 ID');
  }
  return ref
      .read(customerServiceRepositoryProvider)
      .getCustomerProfileCard(customerUserId);
}, dependencies: [customerServiceRepositoryProvider]);

final customerThreadProfileCardProvider = FutureProvider.family<
    CustomerProfileCard,
    ({String customerUserId, String threadType, String threadId})>((ref, args) {
  return ref.read(customerServiceRepositoryProvider).getCustomerProfileCard(
        args.customerUserId,
        threadType: args.threadType,
        threadId: args.threadId,
      );
}, dependencies: [customerServiceRepositoryProvider]);

final customerServiceReceptionStatusProvider = AsyncNotifierProvider<
    CustomerServiceReceptionStatusNotifier, CsReceptionStatus>(
  CustomerServiceReceptionStatusNotifier.new,
  dependencies: [
    accountRuntimeCurrentSpaceProvider,
    currentCustomerServiceRoleCapabilitiesProvider,
    customerServiceRepositoryProvider,
    customerServiceThreadsProvider,
    customerServiceDashboardProvider,
  ],
);

class CustomerServiceReceptionStatusNotifier
    extends AsyncNotifier<CsReceptionStatus> {
  @override
  Future<CsReceptionStatus> build() async {
    final space = ref.watch(accountRuntimeCurrentSpaceProvider);
    if (space == null ||
        !ref
            .watch(currentCustomerServiceRoleCapabilitiesProvider)
            .canUseStaffEndpoints) {
      throw StateError('当前角色不是客服，不能调用客服接待状态接口');
    }
    return ref.read(customerServiceRepositoryProvider).getReceptionStatus();
  }

  Future<void> setStatus(String serviceStatus) async {
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null ||
        !ref
            .read(currentCustomerServiceRoleCapabilitiesProvider)
            .canUseStaffEndpoints) {
      state = AsyncError(
        StateError('当前角色不是客服，不能切换客服接待状态'),
        StackTrace.current,
      );
      return;
    }

    final previous = state.valueOrNull;
    state = const AsyncLoading<CsReceptionStatus>().copyWithPrevious(state);
    try {
      final updated = await ref
          .read(customerServiceRepositoryProvider)
          .updateReceptionStatus(
            serviceStatus: serviceStatus,
            queueAcceptEnabled: serviceStatus == 'online'
                ? (previous?.queueAcceptEnabled ?? false)
                : false,
          );
      state = AsyncData(updated);
      ref.invalidate(customerServiceThreadsProvider);
      ref.invalidate(customerServiceDashboardProvider);
    } catch (e, st) {
      if (previous != null) {
        state = AsyncData(previous);
      } else {
        state = AsyncError(e, st);
      }
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> setQueueAcceptEnabled(bool enabled) async {
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null ||
        !ref
            .read(currentCustomerServiceRoleCapabilitiesProvider)
            .canUseStaffEndpoints) {
      state = AsyncError(
        StateError('当前角色不是客服，不能切换接入模式'),
        StackTrace.current,
      );
      return;
    }

    final previous = state.valueOrNull;
    final serviceStatus = previous?.serviceStatus ?? 'offline';
    state = const AsyncLoading<CsReceptionStatus>().copyWithPrevious(state);
    try {
      final updated = await ref
          .read(customerServiceRepositoryProvider)
          .updateReceptionStatus(
            serviceStatus: serviceStatus,
            queueAcceptEnabled: serviceStatus == 'online' ? enabled : false,
          );
      state = AsyncData(updated);
      ref.invalidate(customerServiceThreadsProvider);
      ref.invalidate(customerServiceDashboardProvider);
    } catch (e, st) {
      if (previous != null) {
        state = AsyncData(previous);
      } else {
        state = AsyncError(e, st);
      }
      Error.throwWithStackTrace(e, st);
    }
  }
}

final customerServiceQuickRepliesProvider = AsyncNotifierProvider.family<
    CustomerServiceQuickRepliesNotifier, List<CsQuickReply>, String?>(
  CustomerServiceQuickRepliesNotifier.new,
  dependencies: [
    accountRuntimeCurrentSpaceProvider,
    currentCustomerServiceRoleCapabilitiesProvider,
    customerServiceRepositoryProvider,
    accountProfileBoxResolverProvider,
  ],
);

final customerServiceAiReplyProvider = StateNotifierProvider.autoDispose.family<
    CustomerServiceAiReplyController,
    CustomerServiceAiReplyState,
    CustomerServiceAiReplyTarget>((ref, target) {
  final repository = ref.watch(customerServiceRepositoryProvider);
  final controller = CustomerServiceAiReplyController(
    target: target,
    loadHistory: (value) => repository.getAiSuggestions(
      threadType: value.threadType,
      threadId: value.threadId,
      limit: 20,
    ),
    generate: (value) => repository.createAiSuggestion(
      threadType: value.threadType,
      threadId: value.threadId,
      customerMessageId: value.customerMessageId,
    ),
    adopt: repository.adoptAiSuggestion,
  );
  unawaited(controller.loadHistory());
  return controller;
}, dependencies: [customerServiceRepositoryProvider]);

final adminCustomerServiceDashboardProvider =
    FutureProvider<AdminCustomerServiceDashboard>((ref) async {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看管理工作台数据');
  }
  return ref.read(adminCustomerServiceRepositoryProvider).getCenterDashboard();
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

final adminCustomerServiceStaffStatusesProvider =
    FutureProvider<List<AdminStaffStatus>>((ref) async {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看客服状态');
  }
  return ref.read(adminCustomerServiceRepositoryProvider).getStaffStatuses();
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

final adminTempSessionStatsProvider =
    FutureProvider<AdminTempSessionStats>((ref) async {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看客服绩效');
  }
  return ref.read(adminCustomerServiceRepositoryProvider).getTempSessionStats();
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

final adminGroupsProvider = FutureProvider<List<AdminGroup>>((ref) async {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看群列表');
  }
  return ref.read(adminCustomerServiceRepositoryProvider).getGroups();
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

class AdminCustomerQuery {
  final String? keyword;
  final AdminCustomerAssignment assignment;
  final String? staffUserId;
  final String sortBy;

  const AdminCustomerQuery({
    this.keyword,
    this.assignment = AdminCustomerAssignment.all,
    this.staffUserId,
    this.sortBy = 'createdAt',
  });

  @override
  bool operator ==(Object other) {
    return other is AdminCustomerQuery &&
        other.keyword == keyword &&
        other.assignment == assignment &&
        other.staffUserId == staffUserId &&
        other.sortBy == sortBy;
  }

  @override
  int get hashCode => Object.hash(
        keyword,
        assignment,
        staffUserId,
        sortBy,
      );
}

class AdminCustomerListState {
  final List<AdminCustomer> items;
  final AdminCustomerQuery query;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isApplyingQuery;
  final Object? loadMoreError;
  final Object? queryError;

  const AdminCustomerListState({
    this.items = const [],
    this.query = const AdminCustomerQuery(),
    this.page = 0,
    this.pageSize = 50,
    this.total = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isApplyingQuery = false,
    this.loadMoreError,
    this.queryError,
  });

  AdminCustomerListState copyWith({
    List<AdminCustomer>? items,
    AdminCustomerQuery? query,
    int? page,
    int? pageSize,
    int? total,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isApplyingQuery,
    Object? loadMoreError,
    Object? queryError,
    bool clearLoadMoreError = false,
    bool clearQueryError = false,
  }) {
    return AdminCustomerListState(
      items: items ?? this.items,
      query: query ?? this.query,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isApplyingQuery: isApplyingQuery ?? this.isApplyingQuery,
      loadMoreError:
          clearLoadMoreError ? null : loadMoreError ?? this.loadMoreError,
      queryError: clearQueryError ? null : queryError ?? this.queryError,
    );
  }
}

class AdminCustomersNotifier extends AsyncNotifier<AdminCustomerListState> {
  static const _pageSize = 50;
  bool _loadingMore = false;
  int _queryRevision = 0;

  AdminCustomerServiceRepository get _repository =>
      ref.read(adminCustomerServiceRepositoryProvider);

  @override
  Future<AdminCustomerListState> build() async {
    final space = ref.watch(effectiveCurrentSpaceProvider);
    _assertCanViewAllCustomers(space);
    const query = AdminCustomerQuery();
    return _loadFirstPage(query);
  }

  Future<AdminCustomerListState> _loadFirstPage(
    AdminCustomerQuery query,
  ) async {
    final result = await _loadPage(
      query: query,
      page: 1,
      pageSize: _pageSize,
    );
    return _fromPage(result, query);
  }

  Future<void> applyQuery(AdminCustomerQuery query) async {
    _assertCanViewAllCustomers(ref.read(effectiveCurrentSpaceProvider));
    final current = state.valueOrNull;
    if (current == null ||
        current.query == query &&
            !current.isApplyingQuery &&
            current.queryError == null) {
      return;
    }

    final revision = ++_queryRevision;
    state = AsyncData(
      current.copyWith(
        isApplyingQuery: true,
        clearLoadMoreError: true,
        clearQueryError: true,
      ),
    );
    try {
      final next = await _loadFirstPage(query);
      if (revision != _queryRevision) return;
      state = AsyncData(next);
    } catch (error) {
      if (revision != _queryRevision) return;
      state = AsyncData(
        current.copyWith(
          isApplyingQuery: false,
          queryError: error,
          clearLoadMoreError: true,
        ),
      );
    }
  }

  Future<void> refreshCustomers() async {
    final previous = state.valueOrNull;
    final query = previous?.query ?? const AdminCustomerQuery();
    final revision = ++_queryRevision;
    try {
      final next = await _loadFirstPage(query);
      if (revision != _queryRevision) return;
      state = AsyncData(next);
    } catch (error, stackTrace) {
      if (revision != _queryRevision) return;
      if (previous == null) {
        state = AsyncError(error, stackTrace);
      } else {
        state = AsyncData(
          previous.copyWith(
            isLoadingMore: false,
            isApplyingQuery: false,
            queryError: error,
            clearLoadMoreError: true,
          ),
        );
      }
    }
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.isApplyingQuery ||
        _loadingMore) {
      return;
    }
    final revision = _queryRevision;
    _loadingMore = true;
    state = AsyncData(
      current.copyWith(
        isLoadingMore: true,
        clearLoadMoreError: true,
      ),
    );
    try {
      final result = await _loadPage(
        query: current.query,
        page: current.page + 1,
        pageSize: current.pageSize,
      );
      if (revision != _queryRevision) return;
      final merged = <String, AdminCustomer>{
        for (final customer in current.items) customer.userId: customer,
        for (final customer in result.items) customer.userId: customer,
      };
      state = AsyncData(
        AdminCustomerListState(
          items: merged.values.toList(growable: false),
          query: current.query,
          page: result.page,
          pageSize: result.pageSize,
          total: result.total,
          hasMore: result.hasMore,
        ),
      );
    } catch (error) {
      if (revision != _queryRevision) return;
      state = AsyncData(
        current.copyWith(
          isLoadingMore: false,
          loadMoreError: error,
        ),
      );
    } finally {
      _loadingMore = false;
    }
  }

  Future<PagedResult<AdminCustomer>> _loadPage({
    required AdminCustomerQuery query,
    required int page,
    required int pageSize,
  }) {
    _assertCanViewAllCustomers(ref.read(effectiveCurrentSpaceProvider));
    return _repository.getCustomers(
      keyword: query.keyword,
      assignment: query.assignment,
      staffUserId: query.staffUserId,
      sortBy: query.sortBy,
      page: page,
      pageSize: pageSize,
    );
  }

  void _assertCanViewAllCustomers(SpaceContext? space) {
    if (!AppPermissions.canSeeAllCustomers(space)) {
      throw StateError('当前角色不能查看客户目录');
    }
  }

  AdminCustomerListState _fromPage(
    PagedResult<AdminCustomer> result,
    AdminCustomerQuery query,
  ) {
    return AdminCustomerListState(
      items: result.items,
      query: query,
      page: result.page,
      pageSize: result.pageSize,
      total: result.total,
      hasMore: result.hasMore,
    );
  }
}

final adminCustomersProvider =
    AsyncNotifierProvider<AdminCustomersNotifier, AdminCustomerListState>(
  AdminCustomersNotifier.new,
  dependencies: [
    effectiveCurrentSpaceProvider,
    adminCustomerServiceRepositoryProvider,
  ],
);

final adminCustomerManagementSummaryProvider =
    FutureProvider<AdminCustomerManagementSummary>((ref) async {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看客户管理统计');
  }
  return ref
      .read(adminCustomerServiceRepositoryProvider)
      .getCustomerManagementSummary();
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

final adminCustomerDetailProvider =
    FutureProvider.family<AdminCustomerDetail, String>((ref, customerUserId) {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看客户详情');
  }
  return ref
      .read(adminCustomerServiceRepositoryProvider)
      .getCustomerDetail(customerUserId);
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

final adminCustomerProfileCardProvider =
    FutureProvider.family<CustomerProfileCard, String>((ref, customerUserId) {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看客户画像');
  }
  if (customerUserId.trim().isEmpty) {
    throw StateError('缺少客户 ID');
  }
  return ref
      .read(adminCustomerServiceRepositoryProvider)
      .getCustomerProfileCard(customerUserId);
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

class AdminCustomerServiceThreadQuery {
  final String? status;
  final String? threadType;
  final String? assignedStaffUserId;

  const AdminCustomerServiceThreadQuery({
    this.status,
    this.threadType,
    this.assignedStaffUserId,
  });

  @override
  bool operator ==(Object other) {
    return other is AdminCustomerServiceThreadQuery &&
        other.status == status &&
        other.threadType == threadType &&
        other.assignedStaffUserId == assignedStaffUserId;
  }

  @override
  int get hashCode => Object.hash(status, threadType, assignedStaffUserId);
}

final adminCustomerServiceThreadsProvider =
    FutureProvider.family<List<CsThread>, AdminCustomerServiceThreadQuery>(
        (ref, query) async {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看客服会话');
  }
  return ref.read(adminCustomerServiceRepositoryProvider).getCenterThreads(
        status: query.status,
        threadType: query.threadType,
        assignedStaffUserId: query.assignedStaffUserId,
      );
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

final adminCustomerServiceThreadDetailProvider = FutureProvider.family<
    CsThreadDetail, ({String threadType, String threadId})>((ref, args) async {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看客服会话详情');
  }
  return ref.read(adminCustomerServiceRepositoryProvider).getCenterThreadDetail(
        threadType: args.threadType,
        threadId: args.threadId,
      );
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

final adminDirectCustomerThreadsProvider =
    FutureProvider.family<List<CsThread>, bool>((ref, unassignedOnly) async {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看客户线程池');
  }
  return ref
      .read(adminCustomerServiceRepositoryProvider)
      .getDirectCustomerThreads(unassignedOnly: unassignedOnly);
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

final adminAuditLogsProvider = FutureProvider<List<AdminAuditLog>>((ref) async {
  if (!ref.watch(currentSpaceHasAdminConsoleAccessProvider)) {
    throw StateError('当前角色不能查看操作审计');
  }
  return ref.read(adminCustomerServiceRepositoryProvider).getAuditLogs();
}, dependencies: [
  currentSpaceHasAdminConsoleAccessProvider,
  adminCustomerServiceRepositoryProvider,
]);

class CustomerServiceQuickRepliesNotifier
    extends FamilyAsyncNotifier<List<CsQuickReply>, String?> {
  static const _cacheKeyPrefix = 'quick_replies_';

  @override
  Future<List<CsQuickReply>> build(String? arg) async {
    final space = ref.watch(accountRuntimeCurrentSpaceProvider);
    if (space == null) return const [];
    if (!ref
        .watch(currentCustomerServiceRoleCapabilitiesProvider)
        .canReadQuickReplies) {
      throw StateError('当前角色不能读取企业话术');
    }

    final cached = await _loadFromCache(space.spaceId, arg);
    if (cached != null) {
      unawaited(_syncFromRemote(space.spaceId, arg, silent: true));
      return cached;
    }

    return _syncFromRemote(space.spaceId, arg, silent: false);
  }

  Future<void> refresh() async {
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null) {
      state = const AsyncData([]);
      return;
    }
    if (!ref
        .read(currentCustomerServiceRoleCapabilitiesProvider)
        .canReadQuickReplies) {
      state = AsyncError(
        StateError('当前角色不能读取企业话术'),
        StackTrace.current,
      );
      return;
    }

    final previous = state.valueOrNull;
    state = const AsyncLoading<List<CsQuickReply>>().copyWithPrevious(state);
    try {
      final fresh = await _syncFromRemote(space.spaceId, arg, silent: false);
      state = AsyncData(fresh);
    } catch (e, st) {
      if (previous != null) {
        state = AsyncData(previous);
      } else {
        state = AsyncError(e, st);
      }
    }
  }

  Future<List<CsQuickReply>> _syncFromRemote(
    String spaceId,
    String? scope, {
    required bool silent,
  }) async {
    try {
      final fresh = await ref
          .read(customerServiceRepositoryProvider)
          .getQuickReplies(scope: scope);
      await _saveToCache(spaceId, scope, fresh);
      if (silent && state.hasValue && state.valueOrNull != fresh) {
        state = AsyncData(fresh);
      }
      return fresh;
    } catch (e, st) {
      if (!silent) Error.throwWithStackTrace(e, st);
      return state.valueOrNull ?? const [];
    }
  }

  Future<List<CsQuickReply>?> _loadFromCache(
      String spaceId, String? scope) async {
    try {
      final box = await ref.read(accountProfileBoxResolverProvider)(spaceId);
      final raw = box.get(_cacheKey(scope));
      if (raw is! String || raw.isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded
          .whereType<Map>()
          .map((e) => CsQuickReply.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToCache(
    String spaceId,
    String? scope,
    List<CsQuickReply> replies,
  ) async {
    try {
      final box = await ref.read(accountProfileBoxResolverProvider)(spaceId);
      await box.put(
        _cacheKey(scope),
        jsonEncode(replies.map((e) => e.toJson()).toList()),
      );
    } catch (_) {
      // 缓存失败不阻塞话术使用。
    }
  }

  String _cacheKey(String? scope) =>
      '$_cacheKeyPrefix${scope == null || scope.isEmpty ? 'all' : scope}';
}

CsThread? officialReceptionThreadForConversation(
    Ref ref, String conversationId) {
  final space = ref.read(accountRuntimeCurrentSpaceProvider);
  if (space == null ||
      !customerServiceRoleCapabilities(membershipRole: space.membershipRole)
          .canUseStaffEndpoints) {
    return null;
  }
  final data = ref.read(customerServiceThreadsProvider).valueOrNull;
  for (final thread in [...?data?.queueItems, ...?data?.activeItems]) {
    if (thread.isOfficialReception && thread.conversationId == conversationId) {
      return thread;
    }
  }
  final identity = ref
      .read(customerServiceThreadIdentityIndexProvider(
          customerServiceReminderScopeKey(
              spaceId: space.spaceId, userId: space.userId)))
      .match(threadId: '', conversationId: conversationId);
  if (identity?.handoffMode != 'in_official') return null;
  return CsThread(
      threadType: identity!.threadType,
      threadId: identity.threadId,
      conversationId: identity.conversationId,
      handoffMode: identity.handoffMode!,
      officialUserId: identity.officialUserId,
      assignedStaffUserId: identity.assignedStaffUserId,
      status: 'active',
      title: '客户');
}

final officialReceptionThreadProvider =
    Provider.family<CsThread?, String>((ref, conversationId) {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (!customerServiceRoleCapabilities(membershipRole: space?.membershipRole)
      .canUseStaffEndpoints) {
    return null;
  }
  ref.watch(customerServiceThreadsProvider);
  if (space != null) {
    ref.watch(customerServiceThreadIdentityIndexProvider(
        customerServiceReminderScopeKey(
            spaceId: space.spaceId, userId: space.userId)));
  }
  return officialReceptionThreadForConversation(ref, conversationId);
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  customerServiceThreadsProvider,
  customerServiceThreadIdentityIndexProvider,
]);
