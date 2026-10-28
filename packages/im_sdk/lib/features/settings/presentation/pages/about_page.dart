import 'package:im_sdk/features/settings/presentation/widgets/diagnostics_version_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/branding/startlink_brand_logo.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/features/app_update/domain/app_release_update.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key});

  @override
  ConsumerState<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  Future<void> _checkUpdate(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final latestVersionText = l10n.aboutLatestVersion;
    try {
      final update = await ref
          .read(appUpdateControllerProvider.notifier)
          .checkForUpdates(manual: true);
      if (!mounted || update == null) return;
      if (update.status == AppUpdateStatus.none) {
        messenger.showSnackBar(SnackBar(content: Text(latestVersionText)));
        return;
      }
      if (!update.canStartUpdate) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.appUpdateUnavailable)),
        );
      }
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.appUpdateCheckFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final updateState = ref.watch(appUpdateControllerProvider);
    final updatesEnabled =
        ref.read(appUpdateControllerProvider.notifier).updatesEnabled;
    return Scaffold(
      backgroundColor: null,
      appBar: buildSettingsAppBar(context, l10n.aboutTitle),
      body: ListView(
        children: [
          // Logo & Version
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Column(
              children: [
                const StartlinkBrandLogo(dimension: 80),
                const SizedBox(height: 16),
                Text('微界',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 4),
                FutureBuilder<PackageInfo>(
                  future: _packageInfo,
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version ?? '1.0.0';
                    return DiagnosticsVersionGate(
                        onOpen: () => context.push('/settings/diagnostics'),
                        child: Text('${l10n.aboutVersion} $version',
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (updatesEnabled) ...[
            SettingGroup(
              children: [
                SettingTile(
                  label: l10n.aboutCheckUpdate,
                  value: updateState.isChecking ? l10n.appUpdateChecking : null,
                  onTap: updateState.isChecking
                      ? null
                      : () => _checkUpdate(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          SettingGroup(
            children: [
              SettingTile(
                label: l10n.aboutTerms,
                onTap: () => context.push('/terms'),
              ),
              SettingTile(
                label: l10n.aboutPrivacy,
                onTap: () => context.push('/privacy'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SettingGroup(
            children: [
              SettingTile(
                label: l10n.feedbackTitle,
                onTap: () => context.push('/feedback'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Text('© 2026 湖南鸿斯科技有限公司',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text('保留所有权利',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
