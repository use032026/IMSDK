import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/features/teen_mode/presentation/utils/teen_mode_ui.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class GuardianCenterPage extends ConsumerWidget {
  const GuardianCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(guardianCenterControllerProvider);
    return Scaffold(
      appBar: buildSettingsAppBar(context, l10n.guardianCenterTitle),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(teenModeErrorText(error, l10n),
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(guardianCenterControllerProvider),
                  child: Text(l10n.commonRetry),
                ),
              ],
            ),
          ),
        ),
        data: (value) => RefreshIndicator(
          onRefresh: () =>
              ref.read(guardianCenterControllerProvider.notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SettingSectionHeader(label: l10n.guardianBind),
              SettingGroup(
                children: [
                  SettingTile(
                    label: l10n.guardianBind,
                    onTap: () => _bind(context, ref),
                  ),
                  SettingTile(
                    label: l10n.guardianCreateMinorCode,
                    onTap: () => _createCode(context, ref, GuardianRole.minor),
                  ),
                  SettingTile(
                    label: l10n.guardianCreateGuardianCode,
                    onTap: () =>
                        _createCode(context, ref, GuardianRole.guardian),
                  ),
                ],
              ),
              SettingSectionHeader(label: l10n.guardianRelationships),
              SettingGroup(
                children: value.links.isEmpty
                    ? [
                        SettingTile(
                          label: l10n.guardianEmpty,
                          showArrow: false,
                        ),
                      ]
                    : value.links
                        .map(
                          (link) => SettingTile(
                            label: link.counterpartDisplayName.isEmpty
                                ? (link.counterpartLppId ?? l10n.commonUnknown)
                                : link.counterpartDisplayName,
                            value: link.relation,
                            onTap: () => _showLink(context, ref, link),
                          ),
                        )
                        .toList(growable: false),
              ),
              SettingSectionHeader(label: l10n.guardianMinors),
              SettingGroup(
                children: value.minors.isEmpty
                    ? [
                        SettingTile(
                          label: l10n.guardianNoMinors,
                          showArrow: false,
                        ),
                      ]
                    : value.minors
                        .map(
                          (minor) => SettingTile(
                            label: minor.displayName.isEmpty
                                ? (minor.lppId ?? l10n.commonUnknown)
                                : minor.displayName,
                            value: minor.session.hasUnlimitedTime
                                ? l10n.teenModeUnlimited
                                : '${(minor.session.remainingSeconds.clamp(0, 1 << 30) / 60).ceil()} ${l10n.teenModeMinutesUnit}',
                            onTap: () => context.push(
                              '/settings/teen-mode/guardian/minor/${Uri.encodeComponent(minor.minorPlatformUserId)}',
                            ),
                          ),
                        )
                        .toList(growable: false),
              ),
              SettingSectionHeader(label: l10n.guardianApprovals),
              SettingGroup(
                children: [
                  SettingTile(
                    label: l10n.guardianApprovals,
                    value: value.approvals.pendingCount > 0
                        ? value.approvals.pendingCount.toString()
                        : null,
                    onTap: () =>
                        context.push('/settings/teen-mode/guardian/approvals'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createCode(
    BuildContext context,
    WidgetRef ref,
    GuardianRole role,
  ) async {
    final l10n = AppLocalizations.of(context);
    final relation = await showTeenTextInputDialog(
      context,
      title: role == GuardianRole.minor
          ? l10n.guardianCreateMinorCode
          : l10n.guardianCreateGuardianCode,
      label: l10n.guardianRelation,
    );
    if (!context.mounted || relation == null || relation.isEmpty) return;
    try {
      final code = await ref
          .read(guardianCenterControllerProvider.notifier)
          .createBindCode(role: role, relation: relation);
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AppAlertDialog(
          title: Text(l10n.guardianCodeCreated),
          content: SelectableText(
            code.code,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(guardianCenterControllerProvider.notifier)
                      .cancelBindCode(code.tokenId);
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } catch (error) {
                  if (dialogContext.mounted) {
                    showTeenModeError(dialogContext, error, ref: ref);
                  }
                }
              },
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code.code));
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: Text(l10n.commonCopy),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.commonDone),
            ),
          ],
        ),
      );
    } catch (error) {
      if (context.mounted) showTeenModeError(context, error, ref: ref);
    }
  }

  Future<void> _bind(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final code = await showTeenTextInputDialog(
      context,
      title: l10n.guardianBind,
      label: l10n.guardianCode,
      hint: l10n.guardianCodeHint,
      numeric: true,
    );
    if (!context.mounted ||
        code == null ||
        !RegExp(r'^\d{6}$').hasMatch(code)) {
      return;
    }
    final relation = await showTeenTextInputDialog(
      context,
      title: l10n.guardianBind,
      label: l10n.guardianRelation,
    );
    if (!context.mounted || relation == null || relation.isEmpty) return;
    try {
      await ref
          .read(guardianCenterControllerProvider.notifier)
          .bind(code: code, relation: relation);
    } catch (error) {
      if (context.mounted) showTeenModeError(context, error, ref: ref);
    }
  }

  Future<void> _showLink(
    BuildContext context,
    WidgetRef ref,
    GuardianLink link,
  ) async {
    final l10n = AppLocalizations.of(context);
    final relationController = TextEditingController(text: link.relation);
    var isPrimary = link.isPrimary;
    var canApprove = link.canApprove;
    var canManagePolicy = link.canManagePolicy;
    final action = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AppAlertDialog(
          title: Text(link.counterpartDisplayName),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: relationController,
                  decoration: InputDecoration(labelText: l10n.guardianRelation),
                ),
                if (link.myRole == GuardianRole.guardian) ...[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.guardianApprovals),
                    value: canApprove,
                    onChanged: (value) =>
                        setDialogState(() => canApprove = value),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.guardianPolicyTitle),
                    value: canManagePolicy,
                    onChanged: (value) =>
                        setDialogState(() => canManagePolicy = value),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.guardianPrimary),
                    value: isPrimary,
                    onChanged: (value) =>
                        setDialogState(() => isPrimary = value),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, 'delete'),
              child: Text(l10n.guardianUnbind),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, 'save'),
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
    final relation = relationController.text.trim();
    relationController.dispose();
    if (!context.mounted || action == null) return;
    try {
      final notifier = ref.read(guardianCenterControllerProvider.notifier);
      if (action == 'save') {
        if (relation.isEmpty) return;
        await notifier.updateLink(
          linkId: link.linkId,
          relation: relation,
          isPrimary: link.myRole == GuardianRole.guardian ? isPrimary : null,
          canApprove: link.myRole == GuardianRole.guardian ? canApprove : null,
          canManagePolicy:
              link.myRole == GuardianRole.guardian ? canManagePolicy : null,
        );
      } else {
        final result = await notifier.deleteLink(link.linkId);
        if (context.mounted && result.message.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(result.message)));
        }
      }
    } catch (error) {
      if (context.mounted) showTeenModeError(context, error, ref: ref);
    }
  }
}
