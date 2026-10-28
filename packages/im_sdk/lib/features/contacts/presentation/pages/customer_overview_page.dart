import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/utils/debouncer.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:im_sdk/core/widgets/identity_badge.dart';
import 'package:im_sdk/core/widgets/person_avatar_with_badge.dart';
import 'package:im_sdk/features/auth/presentation/providers/effective_space_provider.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';

const _primary = Color(0xFF00B27A);

Color _primaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface;

Color _secondaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurfaceVariant;

Color _inputBorder(BuildContext context) => Theme.of(context).dividerColor;

class CustomerOverviewPage extends ConsumerStatefulWidget {
  const CustomerOverviewPage({super.key});

  @override
  ConsumerState<CustomerOverviewPage> createState() =>
      _CustomerOverviewPageState();
}

class _CustomerOverviewPageState extends ConsumerState<CustomerOverviewPage> {
  final _searchDebouncer = Debouncer();
  final _adminScrollController = ScrollController();
  String _query = '';
  _CustomerFilter _filter = _CustomerFilter.all;

  @override
  void initState() {
    super.initState();
    _adminScrollController.addListener(_loadMoreAdminCustomersIfNeeded);
  }

  @override
  void dispose() {
    _searchDebouncer.cancel();
    _adminScrollController
      ..removeListener(_loadMoreAdminCustomersIfNeeded)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebouncer.run(() {
      if (mounted) {
        setState(() => _query = value.trim());
        ref.read(adminCustomersProvider.notifier).applyQuery(_currentQuery);
      }
    });
  }

  void _loadMoreAdminCustomersIfNeeded() {
    if (!_adminScrollController.hasClients) return;
    if (_adminScrollController.position.pixels <
        _adminScrollController.position.maxScrollExtent - 240) {
      return;
    }
    ref.read(adminCustomersProvider.notifier).loadMore();
  }

  AdminCustomerQuery get _currentQuery => AdminCustomerQuery(
        keyword: _query.isEmpty ? null : _query,
        assignment: switch (_filter) {
          _CustomerFilter.all => AdminCustomerAssignment.all,
          _CustomerFilter.assigned => AdminCustomerAssignment.assigned,
          _CustomerFilter.unassigned => AdminCustomerAssignment.unassigned,
        },
      );

  void _onFilterChanged(_CustomerFilter filter) {
    if (filter == _filter) return;
    setState(() => _filter = filter);
    ref.read(adminCustomersProvider.notifier).applyQuery(_currentQuery);
  }

  @override
  Widget build(BuildContext context) {
    final space = ref.watch(effectiveCurrentSpaceProvider);
    final canView = AppPermissions.canSeeAllCustomers(space);
    final adminCustomersAsync =
        canView ? ref.watch(adminCustomersProvider) : null;
    final adminCustomerSummaryAsync =
        canView ? ref.watch(adminCustomerManagementSummaryProvider) : null;

    return Scaffold(
      backgroundColor: null,
      appBar: AppBar(
        backgroundColor: null,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: 18, color: _primaryText(context)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '全部客户',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: _primaryText(context),
          ),
        ),
      ),
      body: !canView
          ? _NoPermissionView()
          : adminCustomersAsync!.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: _primary),
              ),
              error: (error, _) => _buildAdminCustomerBody(
                const AdminCustomerListState(),
                loadError: error,
              ),
              data: (customerState) => _buildAdminCustomerBody(
                customerState,
                summary: adminCustomerSummaryAsync?.valueOrNull,
                loadError: customerState.queryError,
              ),
            ),
    );
  }

  Widget _buildAdminCustomerBody(
    AdminCustomerListState customerState, {
    AdminCustomerManagementSummary? summary,
    Object? loadError,
  }) {
    final customers = customerState.items;
    final dataUnavailable = loadError != null;
    final showPaginationFooter = customers.isNotEmpty &&
        (customerState.hasMore ||
            customerState.isLoadingMore ||
            customerState.loadMoreError != null);
    final contentCount = customers.isEmpty ? 1 : customers.length;

    return Stack(
      children: [
        RefreshIndicator(
          color: _primary,
          onRefresh: () async {
            ref.invalidate(adminCustomerManagementSummaryProvider);
            await ref.read(adminCustomersProvider.notifier).refreshCustomers();
          },
          child: ListView.builder(
            controller: _adminScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: 8 + contentCount + (showPaginationFooter ? 1 : 0),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _CustomerSearchField(
                    onChanged: _onSearchChanged,
                  );
                case 1:
                  return const SizedBox(height: 12);
                case 2:
                  return _CustomerOverviewCard(
                    totalCustomers:
                        summary?.totalCustomers ?? customerState.total,
                    visibleCustomers: customers.length,
                    assignedCustomers: summary?.assignedCount,
                    unassignedCustomers: summary?.unassignedCount,
                    assignedScope: false,
                    dataUnavailable: dataUnavailable,
                  );
                case 3:
                  return const SizedBox(height: 12);
                case 4:
                  return _CustomerFilterActions(
                    filter: _filter,
                    onTagTap: () => AppToast.missingApi(context, '客户标签分页筛选'),
                    onFilterChanged: _onFilterChanged,
                  );
                case 5:
                  return const SizedBox(height: 18);
                case 6:
                  return _SectionHeader(
                    title: '客户 · 已加载 ${customers.length}',
                    count: customerState.total,
                  );
                case 7:
                  return const SizedBox(height: 8);
              }
              if (customers.isEmpty) {
                return _EmptyCustomers(
                  filter: _filter,
                  dataUnavailable: dataUnavailable,
                  onRetry: dataUnavailable
                      ? customerState.queryError == null
                          ? () => ref.invalidate(adminCustomersProvider)
                          : () => ref
                              .read(adminCustomersProvider.notifier)
                              .applyQuery(_currentQuery)
                      : null,
                );
              }
              final customerIndex = index - 8;
              if (customerIndex >= customers.length) {
                return _CustomerPaginationFooter(
                  state: customerState,
                  onRetry: () =>
                      ref.read(adminCustomersProvider.notifier).loadMore(),
                );
              }
              final customer = customers[customerIndex];
              return Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: _AdminCustomerTile(
                  customer: customer,
                  canAssign: true,
                  onAssign: () => _showAssignCustomerSheet(customer),
                ),
              );
            },
          ),
        ),
        if (customerState.isApplyingQuery)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(color: _primary),
          ),
      ],
    );
  }

  Future<void> _showAssignCustomerSheet(AdminCustomer customer) async {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AssignCustomerLoadingSheet(),
    );

    AdminCustomerDetail detail;
    try {
      detail = await ref
          .read(adminCustomerServiceRepositoryProvider)
          .getCustomerDetail(customer.userId);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      AppToast.error(context, '加载可分配客服失败');
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AssignCustomerSheet(
        customer: detail,
        onAssign: (staffUserId) async {
          Navigator.of(sheetContext).pop();
          await _assignCustomer(customer.userId, staffUserId);
        },
      ),
    );
  }

  Future<void> _assignCustomer(
    String customerUserId,
    String? staffUserId,
  ) async {
    try {
      await ref
          .read(adminCustomerServiceRepositoryProvider)
          .assignCustomerService(
            customerUserId: customerUserId,
            staffUserId: staffUserId,
          );
      ref.invalidate(adminCustomersProvider);
      ref.invalidate(adminCustomerManagementSummaryProvider);
      ref.invalidate(adminCustomerServiceDashboardProvider);
      ref.invalidate(
        adminCustomerServiceThreadsProvider(
          const AdminCustomerServiceThreadQuery(),
        ),
      );
      ref.invalidate(adminDirectCustomerThreadsProvider(false));
      ref.invalidate(adminDirectCustomerThreadsProvider(true));
      if (!mounted) return;
      AppToast.success(context, staffUserId == null ? '已按规则自动分配' : '已分配客服');
    } catch (e) {
      if (!mounted) return;
      AppToast.error(context, '分配客服失败');
    }
  }
}

enum _CustomerFilter { all, assigned, unassigned }

class _CustomerOverviewCard extends StatelessWidget {
  final int totalCustomers;
  final int visibleCustomers;
  final int? assignedCustomers;
  final int? unassignedCustomers;
  final bool assignedScope;
  final bool dataUnavailable;

  const _CustomerOverviewCard({
    required this.totalCustomers,
    required this.visibleCustomers,
    this.assignedCustomers,
    this.unassignedCustomers,
    this.assignedScope = false,
    this.dataUnavailable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_alt_outlined,
                  size: 20, color: Color(0xFF00B27A)),
              const SizedBox(width: 8),
              Text(
                '客户概览',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _primaryText(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: assignedScope ? '我的客户' : '客户',
                  value: totalCustomers,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: '已加载',
                  value: visibleCustomers,
                ),
              ),
              if (!assignedScope) ...[
                Expanded(
                  child: _OverviewMetric(
                    label: '已分配',
                    value: dataUnavailable ? null : assignedCustomers,
                  ),
                ),
                Expanded(
                  child: _OverviewMetric(
                    label: '未分配',
                    value: dataUnavailable ? null : unassignedCustomers,
                  ),
                ),
              ],
            ],
          ),
          if (dataUnavailable) ...[
            const SizedBox(height: 12),
            Text(
              '客户数据加载失败，请检查网络或登录状态后重试。',
              style: TextStyle(fontSize: 12, color: _secondaryText(context)),
            ),
          ],
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  final String label;
  final int? value;

  const _OverviewMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value?.toString() ?? '--',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _primaryText(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _secondaryText(context),
          ),
        ),
      ],
    );
  }
}

class _CustomerFilterActions extends StatelessWidget {
  final _CustomerFilter filter;
  final ValueChanged<_CustomerFilter> onFilterChanged;
  final VoidCallback? onTagTap;

  const _CustomerFilterActions({
    required this.filter,
    required this.onFilterChanged,
    this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _FilterChip(
            label: '全部',
            selected: filter == _CustomerFilter.all,
            onTap: () => onFilterChanged(_CustomerFilter.all),
          ),
          _FilterChip(
            label: '已分配',
            selected: filter == _CustomerFilter.assigned,
            onTap: () => onFilterChanged(_CustomerFilter.assigned),
          ),
          _FilterChip(
            label: '未分配',
            selected: filter == _CustomerFilter.unassigned,
            onTap: () => onFilterChanged(_CustomerFilter.unassigned),
          ),
          if (onTagTap != null)
            _FilterChip(
              label: '标签筛选',
              selected: false,
              onTap: onTagTap!,
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? _primary.withValues(alpha: 0.12)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? _primary : _secondaryText(context),
          ),
        ),
      ),
    );
  }
}

class _CustomerPaginationFooter extends StatelessWidget {
  final AdminCustomerListState state;
  final VoidCallback onRetry;

  const _CustomerPaginationFooter({
    required this.state,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (state.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('加载失败，点击重试'),
          ),
        ),
      );
    }
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _primary,
            ),
          ),
        ),
      );
    }
    return const SizedBox(height: 20);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _primaryText(context),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$count人',
              style: TextStyle(
                fontSize: 13,
                color: _secondaryText(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomerSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _CustomerSearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(color: _primaryText(context), fontSize: 15),
      cursorColor: _primary,
      decoration: InputDecoration(
        hintText: '搜索客户',
        hintStyle: TextStyle(color: _secondaryText(context), fontSize: 15),
        prefixIcon:
            Icon(Icons.search, color: _secondaryText(context), size: 20),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _inputBorder(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _inputBorder(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00B27A)),
        ),
      ),
    );
  }
}

class _AdminCustomerTile extends StatelessWidget {
  final AdminCustomer customer;
  final bool canAssign;
  final VoidCallback onAssign;

  const _AdminCustomerTile({
    required this.customer,
    required this.canAssign,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    final assignedName = customer.assignedStaffDisplayName;
    final subtitle = customer.isUnassigned ? '负责客服：未分配' : '负责客服：$assignedName';
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () => context.push(
          '/profile/${customer.userId}',
          extra: canAssign ? {'adminCustomerView': true} : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              PersonAvatarWithBadge(
                avatarUrl: customer.avatarUrl,
                name: customer.displayName,
                userType: 1,
                customerTag: '客户',
                size: 44,
                borderRadius: 11,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            customer.displayName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _primaryText(context),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const IdentityBadge(
                          label: '客户',
                          tone: IdentityBadgeTone.customer,
                          compact: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: _secondaryText(context),
                      ),
                    ),
                    if (customer.tags.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      _CustomerTagsPreview(tags: customer.tags),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (canAssign)
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 58),
                  child: TextButton(
                    onPressed: onAssign,
                    style: TextButton.styleFrom(
                      foregroundColor: _primary,
                      minimumSize: const Size(54, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      customer.isUnassigned ? '分配' : '改分配',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.28),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerTagsPreview extends StatelessWidget {
  final List<String> tags;

  const _CustomerTagsPreview({required this.tags});

  @override
  Widget build(BuildContext context) {
    final visibleTags = tags.take(3).toList(growable: false);
    final extraCount = tags.length - visibleTags.length;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        ...visibleTags.map(
          (tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 11,
                color: _primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (extraCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '+$extraCount',
              style: TextStyle(
                fontSize: 11,
                color: _secondaryText(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyCustomers extends StatelessWidget {
  final _CustomerFilter filter;
  final bool dataUnavailable;
  final VoidCallback? onRetry;

  const _EmptyCustomers({
    required this.filter,
    this.dataUnavailable = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 38),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dataUnavailable
                ? '客户数据加载失败'
                : switch (filter) {
                    _CustomerFilter.assigned => '暂无已分配客户',
                    _CustomerFilter.unassigned => '暂无未分配客户',
                    _CustomerFilter.all => '暂无客户',
                  },
            style: TextStyle(fontSize: 14, color: _secondaryText(context)),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('重试'),
            ),
          ],
        ],
      ),
    );
  }
}

class _AssignCustomerLoadingSheet extends StatelessWidget {
  const _AssignCustomerLoadingSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: _primary),
        ),
      ),
    );
  }
}

class _AssignCustomerSheet extends StatelessWidget {
  final AdminCustomerDetail customer;
  final ValueChanged<String?> onAssign;

  const _AssignCustomerSheet({
    required this.customer,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    final staffList = customer.customerService.assignableStaff;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '分配客服',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: _primaryText(context),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: _secondaryText(context),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            _AssignRow(
              title: '按规则自动分配',
              subtitle: '由服务端选择合适客服',
              selected: customer.isUnassigned,
              onTap: () => onAssign(null),
            ),
            if (staffList.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                child: Text(
                  '暂无可分配客服',
                  style: TextStyle(
                    fontSize: 14,
                    color: _secondaryText(context),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: staffList.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 18,
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  ),
                  itemBuilder: (context, index) {
                    final staff = staffList[index];
                    return _AssignRow(
                      title: staff.displayName,
                      subtitle: staff.lppId?.isNotEmpty == true
                          ? '微界号：${staff.lppId}'
                          : staff.loginName,
                      selected: customer.assignedStaffUserId == staff.userId,
                      onTap: () => onAssign(staff.userId),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _AssignRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _AssignRow({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _primaryText(context),
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: _secondaryText(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (selected) const Icon(Icons.check, color: _primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _NoPermissionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '当前角色没有客户目录权限',
        style: TextStyle(fontSize: 15, color: _secondaryText(context)),
      ),
    );
  }
}
