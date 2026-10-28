import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_settings_page.dart';

// ---------------------------------------------------------------------------
// GroupAdminPage — 群管理员（微信风格：说明 + 管理员列表 + 添加成员）
// ---------------------------------------------------------------------------

class GroupAdminPage extends ConsumerWidget {
  final String groupId;

  const GroupAdminPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(groupDetailProvider(groupId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: 18, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('群管理员',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: detailAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: colorScheme.primary)),
        error: (_, __) => Center(
            child: Text('加载失败',
                style: TextStyle(color: colorScheme.onSurfaceVariant))),
        data: (detail) {
          final permissions = AppPermissions.group(
            myRole: detail.myRole,
            isAllMuted: detail.muteMode,
            allowMemberInvite: detail.allowMemberInvite,
            allowMemberModifyTitle: detail.allowMemberModifyTitle,
            allowMemberAtAll: detail.allowMemberAtAll,
            allowMemberViewMemberList: !detail.onlyOwnerViewMembers,
            allowMemberAddFriend: detail.allowMemberAddFriend,
            space: ref.watch(currentSpaceProvider),
          );
          final canView = permissions.canManage;
          final canManage = detail.myRole == GroupRole.superAdmin;
          if (!canView) {
            return Center(
              child: Text('仅群主/管理员/企业管理员可查看群管理员',
                  style: TextStyle(color: colorScheme.onSurfaceVariant)),
            );
          }

          final membersAsync = ref.watch(groupMembersProvider(groupId));
          return membersAsync.when(
            loading: () => Center(
                child: CircularProgressIndicator(color: colorScheme.primary)),
            error: (_, __) => Center(
                child: Text('加载失败',
                    style: TextStyle(color: colorScheme.onSurfaceVariant))),
            data: (members) {
              final admins =
                  members.where((m) => m.role == GroupRole.admin).toList();

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                children: [
                  // ── 说明文字（微信风格）
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('群管理员',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface)),
                        const SizedBox(height: 16),
                        _bulletText(context, '管理员可协助群主管理群聊，拥有发布群公告、移除群成员等能力。'),
                        const SizedBox(height: 8),
                        _bulletText(context, '只有群主具备设置管理员、转让群主、解散群聊的能力。'),
                        const SizedBox(height: 8),
                        _bulletText(context, '最多可设置 3 个管理员。'),
                      ],
                    ),
                  ),

                  // ── 管理员列表 + 添加
                  Container(
                    color: colorScheme.surface,
                    child: Column(
                      children: [
                        ...admins.asMap().entries.map((e) {
                          final m = e.value;
                          return Column(
                            children: [
                              _AdminTile(
                                member: m,
                                canManage: canManage,
                                onRemove: () => _removeAdmin(context, ref, m),
                              ),
                              if (e.key < admins.length - 1)
                                Divider(
                                    height: 1,
                                    indent: 72,
                                    color: Theme.of(context).dividerColor),
                            ],
                          );
                        }),
                        // 分割线
                        if (admins.isNotEmpty)
                          Divider(
                              height: 1,
                              indent: 72,
                              color: Theme.of(context).dividerColor),
                        // 添加成员
                        if (canManage && admins.length < 3)
                          InkWell(
                            onTap: () => context
                                .push('/group-manage/$groupId/admins/select'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.3),
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.add,
                                        size: 22,
                                        color: colorScheme.onSurfaceVariant),
                                  ),
                                  const SizedBox(width: 12),
                                  Text('添加成员',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: colorScheme.onSurface)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _bulletText(BuildContext context, String text) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(fontSize: 14, color: color)),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: 14, color: color)),
        ),
      ],
    );
  }

  Future<void> _removeAdmin(
      BuildContext context, WidgetRef ref, GroupMember member) async {
    final colorScheme = Theme.of(context).colorScheme;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppAlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('移除管理员'),
        content: Text('确定移除「${member.displayName}」的管理员权限吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('取消',
                style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('移除', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final dio = ref.read(dioProvider);
      await dio.put(
        '/api/client/v1/groups/$groupId/members/${member.userId}/role',
        data: {'role': 'member'},
      );
      ref.read(groupMembersProvider(groupId).notifier).refresh();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('操作失败，请重试')));
      }
    }
  }
}

// ---------------------------------------------------------------------------
// AdminTile
// ---------------------------------------------------------------------------

class _AdminTile extends StatelessWidget {
  final GroupMember member;
  final bool canManage;
  final VoidCallback onRemove;

  const _AdminTile({
    required this.member,
    required this.canManage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
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
          if (canManage)
            TextButton(
              onPressed: onRemove,
              child: Text('移除',
                  style: TextStyle(fontSize: 14, color: colorScheme.primary)),
            ),
        ],
      ),
    );
  }
}
