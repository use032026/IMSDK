import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/utils/debouncer.dart';
import 'package:im_sdk/core/widgets/identity_badge.dart';
import 'package:im_sdk/core/widgets/person_avatar_with_badge.dart';
import 'package:im_sdk/features/auth/presentation/providers/effective_space_provider.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/presentation/pages/customer_overview_page.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';

Color _primaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface;

Color _secondaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurfaceVariant;

class MyCustomersPage extends ConsumerStatefulWidget {
  const MyCustomersPage({super.key});

  @override
  ConsumerState<MyCustomersPage> createState() => _MyCustomersPageState();
}

class _MyCustomersPageState extends ConsumerState<MyCustomersPage> {
  final _searchDebouncer = Debouncer();
  String _query = '';

  @override
  void dispose() {
    _searchDebouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final space = ref.watch(effectiveCurrentSpaceProvider);
    final scope = AppPermissions.customerDirectoryScope(space);

    // 兼容旧链接：管理员/所有者客户池由 admin 领域能力统一负责。
    if (scope == CustomerDirectoryScope.all) {
      return const CustomerOverviewPage();
    }

    final customersAsync = scope == CustomerDirectoryScope.assigned
        ? ref.watch(customerContactsProvider)
        : const AsyncValue<List<Contact>>.data([]);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: _primaryText(context),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '我的客户',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: _primaryText(context),
          ),
        ),
      ),
      body: scope != CustomerDirectoryScope.assigned
          ? _NoPermissionView()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    onChanged: (value) {
                      _searchDebouncer.run(() {
                        if (mounted) {
                          setState(() => _query = value.trim());
                        }
                      });
                    },
                    style: TextStyle(
                      color: _primaryText(context),
                      fontSize: 15,
                    ),
                    cursorColor: const Color(0xFF00B27A),
                    decoration: InputDecoration(
                      hintText: '搜索客户',
                      hintStyle: TextStyle(
                        color: _secondaryText(context),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: _secondaryText(context),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: customersAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (_, __) => _LoadFailedView(
                      onRetry: () =>
                          ref.read(friendsProvider.notifier).refresh(),
                    ),
                    data: (allCustomers) {
                      final customers = allCustomers
                          .where(
                            (customer) =>
                                _query.isEmpty ||
                                customer.displayName.contains(_query),
                          )
                          .toList(growable: false);
                      if (customers.isEmpty) {
                        return Center(
                          child: Text(
                            _query.isEmpty ? '暂无客户联系人' : '未找到匹配客户',
                            style: TextStyle(
                              color: _secondaryText(context),
                              fontSize: 15,
                            ),
                          ),
                        );
                      }
                      return RefreshIndicator(
                        color: const Color(0xFF00B27A),
                        onRefresh: () =>
                            ref.read(friendsProvider.notifier).refresh(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: customers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 1),
                          itemBuilder: (context, index) {
                            return _CustomerContactTile(customers[index]);
                          },
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

class _CustomerContactTile extends StatelessWidget {
  final Contact customer;

  const _CustomerContactTile(this.customer);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () => context.push('/profile/${customer.userId}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              PersonAvatarWithBadge(
                avatarUrl: customer.avatarUrl,
                name: customer.displayName,
                userType: customer.userType,
                customerTag: '客户',
                size: 48,
                borderRadius: 12,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        customer.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
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
              ),
              Icon(
                Icons.chevron_right,
                color: _secondaryText(context),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadFailedView extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _LoadFailedView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh, size: 18),
        label: const Text('客户联系人加载失败，点击重试'),
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
        style: TextStyle(color: _secondaryText(context)),
      ),
    );
  }
}
