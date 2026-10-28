import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/providers/locale_provider.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/profile/domain/entities/profile_entities.dart';
import 'package:im_sdk/features/chat/presentation/providers/presence_provider.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';
import 'package:im_sdk/features/settings/presentation/providers/network_provider.dart';
import 'package:im_sdk/features/settings/presentation/utils/settings_i18n.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

// 好友列表 provider（总数 + 前几个头像）— 复用 FriendsNotifier 缓存，不重复请求
final _friendAvatarsProvider =
    Provider<({int count, List<(String, String?, String)> avatars})>((ref) {
  final friendsAsync = ref.watch(friendsProvider);
  final friends = friendsAsync.valueOrNull ?? [];
  return (
    count: friends.length,
    avatars: friends
        .take(3)
        .map((f) => (f.userId, f.avatarUrl, f.displayName))
        .toList()
  );
}, dependencies: [friendsProvider]);

// ---------------------------------------------------------------------------
// MyPage
// ---------------------------------------------------------------------------

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authProvider).valueOrNull?.status;
    final space = ref.watch(currentSpaceProvider);
    if (authStatus != AuthStatus.authenticated || space == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: null,
      body: SafeArea(
        child: _buildBody(
          context,
          ref,
          space,
          profileState.profile,
          profileLoadFailed: profileState.hasInitialError,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    SpaceContext space,
    UserProfile? profile, {
    required bool profileLoadFailed,
  }) {
    final l10n = AppLocalizations.of(context);
    final isEmployee = space.isEmployee;
    final isCustomer = space.isCustomer;
    final isPersonal = space.isPersonal;

    // 当前时区标签
    final tzOffset = ref.watch(timezoneOffsetProvider);
    final tzLabel = localizedTimezoneOffsetLabel(tzOffset);

    // 当前线路
    final network = ref.watch(networkProvider);
    final networkLabel = network.displayLabel;

    // 当前语言标签
    final currentLocale = ref.watch(localeProvider);
    final langLabel = kSupportedLocales
            .where((l) =>
                l.$1.languageCode == currentLocale.languageCode &&
                l.$1.countryCode == currentLocale.countryCode)
            .map((l) => l.$2)
            .firstOrNull ??
        '简体中文';

    // 根据空间类型构建不同菜单
    final menuRows = <_MenuRow>[];

    if (isPersonal) {
      // 个人空间菜单
      menuRows.addAll([
        _MenuRow(
          icon: Icons.person_add_alt_1_outlined,
          label: '邀请好友',
          onTap: () => context.push('/invite-friends'),
        ),
        _MenuRow(
          icon: Icons.star_border_rounded,
          label: l10n.myFavorites,
          onTap: () => context.push('/favorites'),
        ),
        _MenuRow(
          icon: Icons.language_outlined,
          label: l10n.myLanguage,
          value: langLabel,
          onTap: () => context.push('/language'),
        ),
        _MenuRow(
          icon: Icons.access_time_outlined,
          label: l10n.myTimezone,
          value: tzLabel,
          onTap: () => context.push('/settings/timezone'),
        ),
        _MenuRow(
          icon: Icons.translate_outlined,
          label: l10n.myAutoTranslate,
          onTap: () => context.push('/auto-translate'),
        ),
        _MenuRow(
          icon: Icons.wifi_outlined,
          label: l10n.myNetworkSwitch,
          value: networkLabel,
          onTap: () => context.push('/network'),
        ),
        _MenuRow(
          icon: Icons.settings_outlined,
          label: l10n.mySettings,
          onTap: () => context.push('/settings'),
        ),
      ]);
    } else if (isEmployee) {
      // 企业员工端菜单
      // 企业信息（所有员工都可查看，管理动作统一放到工作台/控制台）
      menuRows.add(_MenuRow(
        icon: Icons.info_outline,
        label: l10n.myEnterpriseInfo,
        onTap: () => context.push('/enterprise/info'),
      ));
      menuRows.addAll([
        _MenuRow(
          icon: Icons.qr_code_2,
          label: l10n.myQrCode,
          onTap: () => context.push('/qrcode'),
        ),
        _MenuRow(
          icon: Icons.star_border_rounded,
          label: l10n.myFavorites,
          onTap: () => context.push('/favorites'),
        ),
        _MenuRow(
          icon: Icons.language_outlined,
          label: l10n.myLanguage,
          value: langLabel,
          onTap: () => context.push('/language'),
        ),
        _MenuRow(
          icon: Icons.access_time_outlined,
          label: l10n.myTimezone,
          value: tzLabel,
          onTap: () => context.push('/settings/timezone'),
        ),
        _MenuRow(
          icon: Icons.translate_outlined,
          label: l10n.myAutoTranslate,
          onTap: () => context.push('/auto-translate'),
        ),
        _MenuRow(
          icon: Icons.wifi_outlined,
          label: l10n.myNetworkSwitch,
          value: networkLabel,
          onTap: () => context.push('/network'),
        ),
        _MenuRow(
          icon: Icons.settings_outlined,
          label: l10n.mySettings,
          onTap: () => context.push('/settings'),
        ),
      ]);
    } else if (isCustomer) {
      // 企业客户端菜单
      menuRows.addAll([
        _MenuRow(
          icon: Icons.info_outline,
          label: l10n.myEnterpriseInfo,
          onTap: () => context.push('/enterprise/info'),
        ),
        _MenuRow(
          icon: Icons.qr_code_2,
          label: l10n.myQrCode,
          onTap: () => context.push('/qrcode'),
        ),
        _MenuRow(
          icon: Icons.star_border_rounded,
          label: l10n.myFavorites,
          onTap: () => context.push('/favorites'),
        ),
        _MenuRow(
          icon: Icons.language_outlined,
          label: l10n.myLanguage,
          value: langLabel,
          onTap: () => context.push('/language'),
        ),
        _MenuRow(
          icon: Icons.access_time_outlined,
          label: l10n.myTimezone,
          value: tzLabel,
          onTap: () => context.push('/settings/timezone'),
        ),
        _MenuRow(
          icon: Icons.translate_outlined,
          label: l10n.myAutoTranslate,
          onTap: () => context.push('/auto-translate'),
        ),
        _MenuRow(
          icon: Icons.wifi_outlined,
          label: l10n.myNetworkSwitch,
          value: networkLabel,
          onTap: () => context.push('/network'),
        ),
        _MenuRow(
          icon: Icons.settings_outlined,
          label: l10n.mySettings,
          onTap: () => context.push('/settings'),
        ),
      ]);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        _ProfileCard(
          profile: profile,
          loadFailed: profileLoadFailed,
        ),
        const SizedBox(height: 12),
        _buildMenuGroup(context, menuRows),
        const SizedBox(height: 12),
        // 在线状态：仅员工端和个人空间显示，客户端不显示
        if (!isCustomer) _PresenceStatusCard(),
        if (!isCustomer) const SizedBox(height: 12),
        const SizedBox(height: 20),
        const _LogoutButton(),
      ],
    );
  }

  Widget _buildMenuGroup(BuildContext context, List<_MenuRow> rows) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final i = e.key;
          final row = e.value;
          return Column(
            children: [
              InkWell(
                onTap: row.onTap,
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: i == rows.length - 1
                      ? const Radius.circular(16)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 13.5),
                  child: Row(
                    children: [
                      Icon(row.icon, size: 22, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          row.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 132,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (row.value != null)
                              Flexible(
                                child: Text(
                                  row.value!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.55),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.3),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < rows.length - 1)
                Divider(
                    height: 1,
                    indent: 50,
                    color: Theme.of(context).dividerColor),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuRow {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.label,
    this.value,
    required this.onTap,
  });
}

// ---------------------------------------------------------------------------
// Profile Card — 对照 figma MyPage 顶部卡片
// ---------------------------------------------------------------------------

class _ProfileCard extends ConsumerWidget {
  final UserProfile? profile;
  final bool loadFailed;

  const _ProfileCard({
    this.profile,
    required this.loadFailed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final name = profile?.displayName ?? '';
    final ztId = profile?.lppId;
    final avatarUrl = profile?.avatarUrl;
    final friendSummary = ref.watch(_friendAvatarsProvider);
    final friendAvatars = friendSummary.avatars;
    final friendCount = friendSummary.count;

    return GestureDetector(
      onTap: loadFailed
          ? () => ref.read(profileProvider.notifier).refresh()
          : profile != null
              ? () => context.push('/my-profile')
              : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.18
                    : 0.04,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            if (profile != null)
              UserAvatar(
                avatarUrl: avatarUrl,
                name: name,
                size: 64,
                borderRadius: 10,
                isMyAvatar: true,
              )
            else
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: loadFailed
                    ? Icon(
                        Icons.person_outline,
                        color: colorScheme.error,
                        size: 28,
                      )
                    : null,
              ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (profile != null)
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface),
                    )
                  else if (loadFailed)
                    Text(
                      l10n.commonLoadFailed,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.error,
                      ),
                    )
                  else
                    _ProfileSkeletonLine(
                      width: 128,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                  const SizedBox(height: 4),
                  if (ztId?.isNotEmpty == true)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: ztId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context).myLppIdCopied),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              l10n.myLppIdLabel(ztId!),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.55)),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.copy_outlined,
                              size: 13,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.4)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (loadFailed)
                    Text(
                      l10n.commonRetry,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.primary,
                      ),
                    )
                  else if (profile != null)
                    Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () => context.push('/my-profile'),
                            child: Text(
                              profile?.signature?.isNotEmpty == true
                                  ? profile!.signature!
                                  : '添加签名',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.48),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 朋友头像列表：复用通用头像组件，保持和联系人/消息头像一致。
                        if (friendCount > 0) ...[
                          SizedBox(
                            width: friendAvatars.length * 20.0 + 4,
                            height: 24,
                            child: Stack(
                              children: friendAvatars.asMap().entries.map((e) {
                                final userId = e.value.$1;
                                final avatarUrl = e.value.$2;
                                final name = e.value.$3;
                                return Positioned(
                                  left: e.key * 20.0,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          width: 1.5),
                                      color: colorScheme.primary,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: _FriendPreviewAvatar(
                                      userId: userId,
                                      avatarUrl: avatarUrl,
                                      name: name,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l10n.myFriendCount(friendCount),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13, color: colorScheme.onSurface),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // 红点
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  if (profile == null && !loadFailed) ...[
                    const SizedBox(height: 4),
                    _ProfileSkeletonLine(
                      width: 190,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                  ],
                ],
              ),
            ),
            // QR + 箭头
            if (profile != null)
              Column(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/qrcode'),
                    child: Icon(Icons.qr_code_2,
                        color: colorScheme.onSurface.withValues(alpha: 0.78),
                        size: 24),
                  ),
                  const SizedBox(height: 2),
                  Icon(Icons.chevron_right,
                      color: colorScheme.onSurface.withValues(alpha: 0.36),
                      size: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSkeletonLine extends StatelessWidget {
  final double width;
  final Color color;

  const _ProfileSkeletonLine({
    required this.width,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }
}

class _FriendPreviewAvatar extends ConsumerWidget {
  final String userId;
  final String? avatarUrl;
  final String name;

  const _FriendPreviewAvatar({
    required this.userId,
    required this.avatarUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = avatarUrl?.isNotEmpty == true
        ? null
        : ref.watch(userAvatarPreviewProvider(userId)).valueOrNull;
    final effectiveAvatarUrl =
        avatarUrl?.isNotEmpty == true ? avatarUrl : preview?.avatarUrl;
    final effectiveName = name.isNotEmpty ? name : preview?.displayName ?? '';

    return UserAvatar(
      avatarUrl: effectiveAvatarUrl,
      name: effectiveName,
      size: 24,
      borderRadius: 12,
    );
  }
}

// ---------------------------------------------------------------------------
// Presence Status Card — 在线状态切换
// ---------------------------------------------------------------------------

class _PresenceStatusCard extends ConsumerWidget {
  static const List<(String, Color?, IconData)> _statuses = [
    ('online', Color(0xFF00B27A), Icons.circle),
    ('busy', Color(0xFFFF6B35), Icons.do_not_disturb_on_outlined),
    ('away', Color(0xFFFFB800), Icons.access_time_outlined),
    ('invisible', null, Icons.visibility_off_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final myId = ref.watch(currentSpaceProvider)?.userId ?? '';
    final presence = ref.watch(userPresenceProvider(myId));
    final currentStatus = presence?.customStatus ?? 'online';
    final statusInfo = _statuses.firstWhere(
      (s) => s.$1 == currentStatus,
      orElse: () => _statuses.first,
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showStatusPicker(context, ref, myId, currentStatus),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13.5),
          child: Row(
            children: [
              Icon(
                statusInfo.$3,
                size: 22,
                color: statusInfo.$2 ?? colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(l10n.myPresenceStatus,
                    style:
                        TextStyle(fontSize: 15, color: colorScheme.onSurface)),
              ),
              Text(
                _statusLabel(l10n, statusInfo.$1),
                style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5)),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
                  size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusPicker(
      BuildContext context, WidgetRef ref, String myId, String current) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(l10n.myPresenceStatusTitle,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            ..._statuses.map((s) => ListTile(
                  leading: Icon(
                    s.$3,
                    color: s.$2 ?? colorScheme.onSurfaceVariant,
                  ),
                  title: Text(_statusLabel(l10n, s.$1)),
                  trailing: current == s.$1
                      ? Icon(Icons.check, color: colorScheme.primary)
                      : null,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await ref
                        .read(presenceProvider.notifier)
                        .setCustomStatus(myId, s.$1);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    return switch (status) {
      'busy' => l10n.myPresenceBusy,
      'away' => l10n.myPresenceAway,
      'invisible' => l10n.myPresenceInvisible,
      _ => l10n.myPresenceOnline,
    };
  }
}

// ---------------------------------------------------------------------------
// Logout Button
// ---------------------------------------------------------------------------

class _LogoutButton extends ConsumerStatefulWidget {
  const _LogoutButton();

  @override
  ConsumerState<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends ConsumerState<_LogoutButton> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: _isLoggingOut ? null : () => _showLogoutDialog(context),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: _isLoggingOut
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: colorScheme.error,
                  ),
                )
              : Text(l10n.myLogout,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.error)),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        var isDialogLoading = false;
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Future<void> handleLogout() async {
              if (isDialogLoading) return;
              setDialogState(() => isDialogLoading = true);
              if (mounted) {
                setState(() => _isLoggingOut = true);
              }
              try {
                await ref.read(authProvider.notifier).logout(
                      clearDraftTranslationSelections: true,
                    );
                if (ctx.mounted) Navigator.of(ctx).pop();
              } catch (_) {
                if (dialogContext.mounted) {
                  setDialogState(() => isDialogLoading = false);
                }
                if (mounted) {
                  setState(() => _isLoggingOut = false);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('退出失败，请重试')),
                  );
                }
              }
            }

            return PopScope(
              canPop: !isDialogLoading,
              child: AppAlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text(l10n.myLogout,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600)),
                content: Text(
                    isDialogLoading ? '正在退出登录，请稍候' : l10n.myLogoutConfirm,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.58))),
                actions: [
                  TextButton(
                    onPressed: isDialogLoading
                        ? null
                        : () => Navigator.of(dialogContext).pop(),
                    child: Text('取消',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.58))),
                  ),
                  TextButton(
                    onPressed: isDialogLoading ? null : handleLogout,
                    child: isDialogLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: colorScheme.error,
                            ),
                          )
                        : Text(
                            '退出',
                            style: TextStyle(color: colorScheme.error),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    });
  }
}
