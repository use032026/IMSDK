import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/utils/debouncer.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_settings_page.dart';

// ---------------------------------------------------------------------------
// TransferOwnerPage — 选择新群主（微信风格：独立页面 + 搜索 + 字母分组）
// ---------------------------------------------------------------------------

class TransferOwnerPage extends ConsumerStatefulWidget {
  final String groupId;

  const TransferOwnerPage({super.key, required this.groupId});

  @override
  ConsumerState<TransferOwnerPage> createState() => _TransferOwnerPageState();
}

class _TransferOwnerPageState extends ConsumerState<TransferOwnerPage> {
  String? _selectedUserId;
  String _keyword = '';
  bool _transferring = false;
  final _searchCtrl = TextEditingController();
  final _searchDebouncer = Debouncer();

  @override
  void dispose() {
    _searchDebouncer.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebouncer.run(() {
      if (mounted) {
        setState(() => _keyword = value.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(groupDetailProvider(widget.groupId));
    final currentUserId = ref.watch(currentSpaceProvider)?.userId ?? '';
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: Text(
            '取消',
            style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
          ),
        ),
        leadingWidth: 72,
        title: Text(
          '选择新群主',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _selectedUserId != null && !_transferring
                ? _confirmTransfer
                : null,
            child: _transferring
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  )
                : Text(
                    '完成',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedUserId != null
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (_, __) => Center(
          child: Text(
            '加载失败',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        data: (detail) {
          if (detail.myRole != GroupRole.superAdmin) {
            return Center(
              child: Text(
                '仅群主可转让群主',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            );
          }
          final membersAsync = ref.watch(groupMembersProvider(widget.groupId));
          return Column(
            children: [
              // 搜索框
              Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _onSearchChanged,
                  style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: '搜索',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),

              // 成员列表
              Expanded(
                child: membersAsync.when(
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      '加载失败',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  data: (members) {
                    // 排除自己
                    final candidates = members
                        .where((m) => m.userId != currentUserId)
                        .where((m) =>
                            _keyword.isEmpty ||
                            m.displayName
                                .toLowerCase()
                                .contains(_keyword.toLowerCase()))
                        .toList();

                    if (candidates.isEmpty) {
                      return Center(
                        child: Text(
                          '暂无其他成员',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      );
                    }

                    // 按首字母分组
                    final grouped = _groupByInitial(candidates);
                    final keys = grouped.keys.toList()..sort();

                    return ListView.builder(
                      itemCount: keys.fold<int>(
                          0, (sum, k) => sum + 1 + grouped[k]!.length),
                      itemBuilder: (ctx, i) {
                        // 展开分组
                        int idx = 0;
                        for (final k in keys) {
                          if (i == idx) {
                            // 字母 header
                            return _SectionHeader(label: k);
                          }
                          idx++;
                          final items = grouped[k]!;
                          if (i < idx + items.length) {
                            final m = items[i - idx];
                            return _MemberTile(
                              member: m,
                              selected: _selectedUserId == m.userId,
                              onTap: () =>
                                  setState(() => _selectedUserId = m.userId),
                            );
                          }
                          idx += items.length;
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, List<GroupMember>> _groupByInitial(List<GroupMember> members) {
    final map = <String, List<GroupMember>>{};
    for (final m in members) {
      final name = m.displayName;
      final initial = name.isNotEmpty ? name[0].toUpperCase() : '#';
      // 非字母归入 #
      final key = RegExp(r'[A-Z]').hasMatch(initial) ? initial : '#';
      map.putIfAbsent(key, () => []).add(m);
    }
    return map;
  }

  Future<void> _confirmTransfer() async {
    if (_selectedUserId == null) return;

    final membersAsync = ref.read(groupMembersProvider(widget.groupId));
    final member = membersAsync.valueOrNull
        ?.firstWhere((m) => m.userId == _selectedUserId);
    if (member == null) return;
    final colorScheme = Theme.of(context).colorScheme;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppAlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('转让群主'),
        content: Text('确定将群主转让给「${member.displayName}」吗？转让后你将成为普通成员。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              '取消',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              '确定转让',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _transferring = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.post(
        '/api/client/v1/groups/${widget.groupId}/transfer-owner',
        data: {'newOwnerUserId': _selectedUserId},
      );
      ref.read(groupDetailProvider(widget.groupId).notifier).refresh();
      ref.read(groupMembersProvider(widget.groupId).notifier).refresh();
      if (mounted) {
        AppToast.success(context, '群主已转让');
        context.pop(); // 返回群管理页
      }
    } catch (_) {
      if (mounted) {
        setState(() => _transferring = false);
        AppToast.error(context, '转让失败，请重试');
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final GroupMember member;
  final bool selected;
  final VoidCallback onTap;

  const _MemberTile({
    required this.member,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // 选中圆圈
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: selected
                  ? Icon(Icons.check, size: 14, color: colorScheme.onPrimary)
                  : null,
            ),
            // 头像
            UserAvatar(
              avatarUrl: member.avatarUrl,
              name: member.displayName,
              size: 44,
              borderRadius: 8,
            ),
            const SizedBox(width: 12),
            // 名字 + 角色
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.displayName,
                      style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurface,
                      )),
                  if (member.role == GroupRole.admin)
                    Text(
                      '管理员',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
