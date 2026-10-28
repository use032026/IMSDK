import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class BlacklistPage extends ConsumerWidget {
  const BlacklistPage({super.key});

  Future<void> _unblock(
      BuildContext context, WidgetRef ref, String userId) async {
    try {
      await ref.read(contactsRepositoryProvider).unblockUser(userId);
      ref.invalidate(blocklistProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('已取消拉黑')));
      }
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err is ServerError ? err.message : '操作失败')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final listAsync = ref.watch(blocklistProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: null,
      appBar: buildSettingsAppBar(context, l10n.blacklistTitle),
      body: listAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
            child: Text(l10n.commonLoadFailed,
                style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.55)))),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🚫', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(l10n.blacklistEmpty,
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              colorScheme.onSurface.withValues(alpha: 0.55))),
                ],
              ),
            );
          }
          return ListView(
            children: [
              const SizedBox(height: 16),
              SettingGroup(
                children: list.map((u) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.push('/profile/${u.userId}'),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.outline,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: u.avatarUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: AuthNetworkImage(
                                      url: u.avatarUrl!,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ))
                                : Center(
                                    child: Text(
                                      u.displayName.isNotEmpty
                                          ? u.displayName[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.55)),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.displayName,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: colorScheme.onSurface)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              _confirmUnblock(context, ref, u.userId, l10n),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFFF3B30),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                          child: Text(l10n.blacklistRemove),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '将用户加入黑名单后，对方将无法给你发送消息、查看你的个人信息和动态。',
                  style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                      height: 1.6),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmUnblock(BuildContext context, WidgetRef ref, String userId,
      AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AppAlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.blacklistRemove,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        content: Text(l10n.blacklistRemoveConfirm,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.58))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('取消',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.58))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _unblock(context, ref, userId);
            },
            child: Text(l10n.blacklistRemove,
                style: const TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }
}
