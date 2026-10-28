import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/utils/debouncer.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_settings_page.dart';

// ---------------------------------------------------------------------------
// SelectGroupMemberPage — 选择群成员（用于添加管理员）
// ---------------------------------------------------------------------------

class SelectGroupMemberPage extends ConsumerStatefulWidget {
  final String groupId;

  const SelectGroupMemberPage({super.key, required this.groupId});

  @override
  ConsumerState<SelectGroupMemberPage> createState() =>
      _SelectGroupMemberPageState();
}

class _SelectGroupMemberPageState extends ConsumerState<SelectGroupMemberPage> {
  final Set<String> _selected = {};
  String _keyword = '';
  bool _saving = false;
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: Text('取消',
              style:
                  TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant)),
        ),
        leadingWidth: 72,
        title: Text('选择群成员',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _selected.isNotEmpty && !_saving ? _confirm : null,
            child: _saving
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: colorScheme.primary))
                : Text(
                    '完成',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selected.isNotEmpty
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: colorScheme.primary)),
        error: (_, __) => Center(
            child: Text('加载失败',
                style: TextStyle(color: colorScheme.onSurfaceVariant))),
        data: (detail) {
          if (detail.myRole != GroupRole.superAdmin) {
            return Center(
              child: Text('仅群主可设置群管理员',
                  style: TextStyle(color: colorScheme.onSurfaceVariant)),
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
                    prefixIcon: Icon(Icons.search,
                        color: colorScheme.onSurfaceVariant, size: 20),
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
              Divider(height: 1, color: Theme.of(context).dividerColor),

              // 成员列表
              Expanded(
                child: membersAsync.when(
                  loading: () => Center(
                      child: CircularProgressIndicator(
                          color: colorScheme.primary)),
                  error: (_, __) => Center(
                      child: Text('加载失败',
                          style:
                              TextStyle(color: colorScheme.onSurfaceVariant))),
                  data: (members) {
                    // 排除自己和已是管理员的成员
                    final candidates = members
                        .where((m) =>
                            m.userId != currentUserId &&
                            m.role != GroupRole.superAdmin &&
                            m.role != GroupRole.admin)
                        .where((m) =>
                            _keyword.isEmpty ||
                            m.displayName
                                .toLowerCase()
                                .contains(_keyword.toLowerCase()))
                        .toList();

                    if (candidates.isEmpty) {
                      return Center(
                        child: Text('暂无可添加的成员',
                            style:
                                TextStyle(color: colorScheme.onSurfaceVariant)),
                      );
                    }

                    final grouped = _groupByInitial(candidates);
                    final keys = grouped.keys.toList()..sort();

                    return ListView.builder(
                      itemCount: keys.fold<int>(
                          0, (sum, k) => sum + 1 + grouped[k]!.length),
                      itemBuilder: (ctx, i) {
                        int idx = 0;
                        for (final k in keys) {
                          if (i == idx) {
                            return _SectionHeader(label: k);
                          }
                          idx++;
                          final items = grouped[k]!;
                          if (i < idx + items.length) {
                            final m = items[i - idx];
                            return _MemberTile(
                              member: m,
                              selected: _selected.contains(m.userId),
                              onTap: () => setState(() {
                                if (_selected.contains(m.userId)) {
                                  _selected.remove(m.userId);
                                } else {
                                  _selected.add(m.userId);
                                }
                              }),
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
      final key = RegExp(r'[A-Z]').hasMatch(initial) ? initial : '#';
      map.putIfAbsent(key, () => []).add(m);
    }
    return map;
  }

  Future<void> _confirm() async {
    if (_selected.isEmpty) return;
    setState(() => _saving = true);
    try {
      final dio = ref.read(dioProvider);
      for (final userId in _selected) {
        await dio.put(
          '/api/client/v1/groups/${widget.groupId}/members/$userId/role',
          data: {'role': 'admin'},
        );
      }
      ref.read(groupMembersProvider(widget.groupId).notifier).refresh();
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('操作失败，请重试')));
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
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(label,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant)),
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
                  ? Icon(Icons.check,
                      size: 14, color: Theme.of(context).colorScheme.surface)
                  : null,
            ),
            UserAvatar(
              avatarUrl: member.avatarUrl,
              name: member.displayName,
              size: 44,
              borderRadius: 8,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(member.displayName,
                  style: TextStyle(fontSize: 15, color: colorScheme.onSurface)),
            ),
          ],
        ),
      ),
    );
  }
}
