import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/notifications/push_notification_service.dart';
import 'package:im_sdk/core/platform/platform_capabilities.dart';
import 'package:im_sdk/core/privacy/privacy_consent_service.dart';
import 'package:im_sdk/core/space/space_manager.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/features/settings/presentation/providers/settings_providers.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spaceId = ref.watch(
      currentSpaceProvider.select((space) => space?.spaceId.trim()),
    );
    if (spaceId == null || spaceId.isEmpty) {
      return Scaffold(
        backgroundColor: null,
        appBar: buildSettingsAppBar(context, l10n.notificationTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final settingsAsync = ref.watch(notificationSettingsProvider(spaceId));
    final authorizationAsync =
        ref.watch(localNotificationAuthorizationProvider);
    final privacyDecision = ref.watch(privacyConsentControllerProvider);

    return Scaffold(
      backgroundColor: null,
      appBar: buildSettingsAppBar(context, l10n.notificationTitle),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: TextButton(
            onPressed: () =>
                ref.read(notificationSettingsProvider(spaceId).notifier).load(),
            child: const Text('加载失败，点击重试'),
          ),
        ),
        data: (settings) => ListView(
          children: [
            const SizedBox(height: 16),
            SettingGroup(
              children: [
                SettingTile(
                  label: '消息通知授权',
                  value: privacyDecision.allowsPushRuntime ? '已同意' : '未同意',
                  showArrow: !privacyDecision.allowsPushRuntime,
                  onTap: privacyDecision.allowsPushRuntime
                      ? null
                      : () => _requestPushPrivacyConsent(context, ref),
                ),
                SettingTile(
                  label: '系统通知权限',
                  value: authorizationAsync.when(
                    data: (status) => switch (status) {
                      LocalNotificationAuthorizationStatus.enabled => '已开启',
                      LocalNotificationAuthorizationStatus.disabled => '未开启',
                      LocalNotificationAuthorizationStatus.unknown => '未知',
                      LocalNotificationAuthorizationStatus.unsupported => '不支持',
                    },
                    loading: () => '检查中',
                    error: (_, __) => '检查失败',
                  ),
                  onTap: () =>
                      _requestSystemNotificationPermission(context, ref),
                ),
                if (PlatformCapabilities.isAndroid)
                  SettingTile(
                    label: '来电全屏提醒',
                    value: '点击检查并授权',
                    onTap: () async {
                      if (!ref
                          .read(privacyConsentControllerProvider)
                          .allowsPushRuntime) {
                        final accepted = await _requestPushPrivacyConsent(
                          context,
                          ref,
                        );
                        if (!accepted || !context.mounted) return;
                      }
                      final granted = await PushNotificationService
                          .requestCallFullScreenPermission();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            granted == true
                                ? '来电全屏提醒已开启'
                                : '来电全屏提醒未开启，请在系统设置中允许',
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SettingGroup(
              children: [
                SettingSwitchTile(
                  label: l10n.notificationGlobalMute,
                  value: settings.globalMute,
                  onChanged: (v) => ref
                      .read(notificationSettingsProvider(spaceId).notifier)
                      .patch((s) => s.copyWith(globalMute: v)),
                ),
                SettingSwitchTile(
                  label: l10n.notificationPreview,
                  value: settings.previewEnabled,
                  onChanged: (v) => ref
                      .read(notificationSettingsProvider(spaceId).notifier)
                      .patch((s) => s.copyWith(previewEnabled: v)),
                ),
                SettingSwitchTile(
                  label: l10n.notificationSound,
                  value: settings.soundEnabled,
                  onChanged: (v) => ref
                      .read(notificationSettingsProvider(spaceId).notifier)
                      .patch((s) => s.copyWith(soundEnabled: v)),
                ),
                SettingSwitchTile(
                  label: l10n.notificationVibration,
                  value: settings.vibrationEnabled,
                  onChanged: (v) => ref
                      .read(notificationSettingsProvider(spaceId).notifier)
                      .patch((s) => s.copyWith(vibrationEnabled: v)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 免打扰时段
            SettingGroup(
              children: [
                SettingTile(
                  label: '免打扰时段',
                  value: settings.dndStartTime != null &&
                          settings.dndEndTime != null
                      ? '${settings.dndStartTime} - ${settings.dndEndTime}'
                      : '未设置',
                  onTap: () => _showDndPicker(context, ref, spaceId, settings),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _requestPushPrivacyConsent(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppAlertDialog(
        title: const Text('开启消息通知'),
        content: const Text(
          '开启后，极光 JPush/JCore 及手机厂商推送服务可能处理设备信息、'
          '推送标识和通知送达信息，用于消息、客服和来电提醒。您仍可在系统设置中关闭通知权限。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.privacyConsentDecline),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.privacyConsentAccept),
          ),
        ],
      ),
    );
    if (accepted != true || !context.mounted) return false;
    try {
      await ref.read(privacyConsentControllerProvider.notifier).accept();
      ref.invalidate(localNotificationAuthorizationProvider);
      return true;
    } catch (_) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.privacyConsentSaveFailure)),
      );
      return false;
    }
  }

  Future<void> _requestSystemNotificationPermission(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!ref.read(privacyConsentControllerProvider).allowsPushRuntime) {
      final accepted = await _requestPushPrivacyConsent(context, ref);
      if (!accepted || !context.mounted) return;
    }
    final status =
        await PushNotificationService.requestLocalNotificationPermission();
    ref.invalidate(localNotificationAuthorizationProvider);
    if (context.mounted &&
        status == LocalNotificationAuthorizationStatus.disabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('系统通知仍未开启，请在手机系统设置中允许微界通知'),
        ),
      );
    }
  }

  void _showDndPicker(
    BuildContext context,
    WidgetRef ref,
    String spaceId,
    dynamic settings,
  ) {
    // 简单实现：弹出时间选择
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text('免打扰时段',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('22:00 - 08:00（夜间）'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(notificationSettingsProvider(spaceId).notifier).patch(
                    (s) =>
                        s.copyWith(dndStartTime: '22:00', dndEndTime: '08:00'));
              },
            ),
            ListTile(
              title: const Text('关闭免打扰'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(notificationSettingsProvider(spaceId).notifier).patch(
                    (s) => s.copyWith(dndStartTime: null, dndEndTime: null));
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
