import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/features/teen_mode/presentation/utils/teen_mode_ui.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

@visibleForTesting
bool shouldShowTeenModeSelfEnrollmentControl(TeenModeState value) =>
    value.active || value.config.selfEnrollmentEnabled;

class TeenModePage extends ConsumerWidget {
  const TeenModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(teenModeControllerProvider);
    return Scaffold(
      appBar: buildSettingsAppBar(context, l10n.teenModeTitle),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _LoadError(
          message: teenModeErrorText(error, l10n),
          onRetry: () => ref.invalidate(teenModeControllerProvider),
        ),
        data: (value) {
          if (!value.config.enabled) {
            return _LoadError(
              message: l10n.teenModeUnavailable,
              onRetry: () => ref.invalidate(teenModeControllerProvider),
            );
          }
          return _TeenModeContent(value: value);
        },
      ),
    );
  }
}

class _TeenModeContent extends ConsumerWidget {
  const _TeenModeContent({required this.value});

  final TeenModeState value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = value.profile;
    final active = profile?.active == true;
    final showEnrollmentControl =
        shouldShowTeenModeSelfEnrollmentControl(value);
    return RefreshIndicator(
      onRefresh: () => ref.read(teenModeControllerProvider.notifier).refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (showEnrollmentControl) ...[
            SettingSectionHeader(label: l10n.teenModeTitle),
            SettingGroup(
              children: [
                SettingSwitchTile(
                  label: l10n.teenModeTitle,
                  description: l10n.teenModeEnableDescription,
                  value: active,
                  onChanged: (next) => _toggle(context, ref, next),
                ),
                if (profile != null && active)
                  SettingTile(
                    label: l10n.teenModeSource,
                    value: profile.sourceLabel,
                    showArrow: false,
                  ),
              ],
            ),
          ],
          if (profile != null && active) ...[
            SettingSectionHeader(label: l10n.teenModeDailyUsage),
            SettingGroup(
              children: [
                SettingTile(
                  label: l10n.teenModeDailyUsage,
                  value: _minutes(l10n, profile.session.usedSeconds),
                  showArrow: false,
                ),
                SettingTile(
                  label: l10n.teenModeRemaining,
                  value: profile.session.hasUnlimitedTime
                      ? l10n.teenModeUnlimited
                      : _minutes(l10n, profile.session.remainingSeconds),
                  showArrow: false,
                ),
                if (profile.session.isRestricted)
                  SettingTile(
                    label: profile.session.reason == TeenSessionReason.curfew
                        ? l10n.teenModeCurfewActive
                        : l10n.teenModeTimeLimitReached,
                    value: l10n.teenModeRequestExtension,
                    onTap: () => _requestExtension(context, ref),
                  ),
              ],
            ),
            SettingSectionHeader(label: l10n.settingsSectionFeatures),
            SettingGroup(
              children: [
                SettingTile(
                  label: l10n.teenModeChangePasscode,
                  onTap: () => _changePasscode(context, ref, profile),
                ),
                SettingTile(
                  label: l10n.teenModeMyRequests,
                  value: profile.pendingApprovalCount > 0
                      ? profile.pendingApprovalCount.toString()
                      : null,
                  onTap: () => context.push('/settings/teen-mode/requests'),
                ),
              ],
            ),
          ],
          if (value.config.guardianEnabled) ...[
            SettingSectionHeader(label: l10n.guardianCenterTitle),
            SettingGroup(
              children: [
                SettingTile(
                  label: l10n.guardianCenterTitle,
                  onTap: () => context.push('/settings/teen-mode/guardian'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (enabled && !value.config.selfEnrollmentEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.teenModeUnavailable)),
      );
      return;
    }
    final profile = value.profile;
    if (!enabled && profile?.lockLevel == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.teenModeActionBlocked)),
      );
      return;
    }
    String passcode = '';
    final requiresPasscode = enabled || profile?.lockLevel == 0;
    if (requiresPasscode) {
      final input = await showTeenTextInputDialog(
        context,
        title: enabled ? l10n.teenModeEnable : l10n.teenModeDisable,
        label: l10n.teenModePasscode,
        hint: l10n.teenModePasscodeHint,
        numeric: true,
        obscure: true,
      );
      if (!context.mounted || input == null) return;
      if (!RegExp(r'^\d{4,6}$').hasMatch(input)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.teenModePasscodeHint)),
        );
        return;
      }
      passcode = input;
    }
    await _submitToggle(context, ref, enabled: enabled, passcode: passcode);
  }

  Future<void> _submitToggle(
    BuildContext context,
    WidgetRef ref, {
    required bool enabled,
    required String passcode,
  }) async {
    try {
      final notifier = ref.read(teenModeControllerProvider.notifier);
      if (enabled) {
        final offset = ref.read(timezoneOffsetProvider);
        await notifier.enable(
          passcode: passcode,
          timeZoneId: timezoneIdForOffset(offset),
        );
      } else {
        final result = await notifier.disable(passcode);
        if (context.mounted && result.message.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(result.message)));
        }
      }
    } catch (error) {
      if (!context.mounted) return;
      showTeenModeError(
        context,
        error,
        ref: ref,
        onPasscodeSubmitted: (retryPasscode) => _submitToggle(
          context,
          ref,
          enabled: enabled,
          passcode: retryPasscode,
        ),
      );
    }
  }

  Future<void> _changePasscode(
    BuildContext context,
    WidgetRef ref,
    TeenModeProfile profile,
  ) async {
    final l10n = AppLocalizations.of(context);
    String? current;
    if (profile.hasPasscode) {
      current = await showTeenTextInputDialog(
        context,
        title: l10n.teenModeChangePasscode,
        label: l10n.teenModeCurrentPasscode,
        hint: l10n.teenModePasscodeHint,
        numeric: true,
        obscure: true,
      );
      if (!context.mounted || current == null) return;
    }
    final next = await showTeenTextInputDialog(
      context,
      title: l10n.teenModeChangePasscode,
      label: l10n.teenModeNewPasscode,
      hint: l10n.teenModePasscodeHint,
      numeric: true,
      obscure: true,
    );
    if (!context.mounted || next == null) return;
    if (!RegExp(r'^\d{4,6}$').hasMatch(next)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.teenModePasscodeHint)),
      );
      return;
    }
    await _submitPasscodeChange(
      context,
      ref,
      currentPasscode: current,
      newPasscode: next,
    );
  }

  Future<void> _submitPasscodeChange(
    BuildContext context,
    WidgetRef ref, {
    required String? currentPasscode,
    required String newPasscode,
  }) async {
    try {
      await ref.read(teenModeControllerProvider.notifier).updatePasscode(
            currentPasscode: currentPasscode,
            newPasscode: newPasscode,
          );
    } catch (error) {
      if (!context.mounted) return;
      showTeenModeError(
        context,
        error,
        ref: ref,
        onPasscodeSubmitted: (retryPasscode) => _submitPasscodeChange(
          context,
          ref,
          currentPasscode: retryPasscode,
          newPasscode: newPasscode,
        ),
      );
    }
  }

  Future<void> _requestExtension(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final text = await showTeenTextInputDialog(
      context,
      title: l10n.teenModeRequestExtension,
      label: l10n.teenModeMinutesUnit,
      initialValue: '30',
      numeric: true,
    );
    if (!context.mounted || text == null) return;
    final minutes = int.tryParse(text);
    if (minutes == null || minutes <= 0) return;
    try {
      final result = await ref
          .read(teenModeControllerProvider.notifier)
          .requestExtension(minutes);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message.isEmpty
                ? l10n.teenModeExtensionSubmitted
                : result.message),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) showTeenModeError(context, error, ref: ref);
    }
  }

  String _minutes(AppLocalizations l10n, int seconds) =>
      '${(seconds.clamp(0, 1 << 30) / 60).ceil()} ${l10n.teenModeMinutesUnit}';
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
          ],
        ),
      ),
    );
  }
}
