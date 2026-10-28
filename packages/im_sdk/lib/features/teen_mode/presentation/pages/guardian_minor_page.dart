import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/domain/services/teen_mode_policy.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/features/teen_mode/presentation/utils/teen_mode_ui.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class GuardianMinorPage extends ConsumerStatefulWidget {
  const GuardianMinorPage({
    super.key,
    required this.minorPlatformUserId,
  });

  final String minorPlatformUserId;

  @override
  ConsumerState<GuardianMinorPage> createState() => _GuardianMinorPageState();
}

class _GuardianMinorPageState extends ConsumerState<GuardianMinorPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final minorAsync = ref.watch(
      guardianMinorControllerProvider(widget.minorPlatformUserId),
    );
    return Scaffold(
      appBar: buildSettingsAppBar(context, l10n.guardianPolicyTitle),
      body: minorAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: OutlinedButton(
            onPressed: () => ref
                .read(
                    guardianMinorControllerProvider(widget.minorPlatformUserId)
                        .notifier)
                .refresh(),
            child: Text(teenModeErrorText(error, l10n)),
          ),
        ),
        data: (editor) {
          final minor = editor.minor;
          final policy = GuardianMinorPolicy(minor, editor.catalog);
          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              ListTile(
                title: Text(minor.displayName),
                subtitle: Text(minor.relation),
                trailing: Text(minor.teenModeActive
                    ? l10n.teenModeStatusOn
                    : l10n.teenModeStatusOff),
              ),
              ..._policyWidgets(context, editor),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: FilledButton(
                  onPressed: editor.canSave ? () => _save(context) : null,
                  child: Text(l10n.commonSave),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                  onPressed: policy.canExtend
                      ? () => _extend(
                            context,
                            minor,
                            policy.maxExtensionMinutes,
                          )
                      : null,
                  child: Text(l10n.guardianExtend),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _policyWidgets(
    BuildContext context,
    GuardianMinorEditorState editor,
  ) {
    final widgets = <Widget>[];
    String? group;
    for (final item in editor.catalog) {
      if (group != item.group) {
        group = item.group;
        widgets.add(SettingSectionHeader(
          label: group.isNotEmpty
              ? group
              : AppLocalizations.of(context).guardianPolicyTitle,
        ));
      }
      widgets.add(_policyField(context, editor, item));
    }
    if (widgets.isEmpty) {
      widgets
          .add(ListTile(title: Text(AppLocalizations.of(context).commonEmpty)));
    }
    return widgets;
  }

  Widget _policyField(
    BuildContext context,
    GuardianMinorEditorState editor,
    TeenPolicyCatalogItem item,
  ) {
    final l10n = AppLocalizations.of(context);
    final minor = editor.minor;
    final enabled = minor.canManagePolicy &&
        minor.editablePolicyKeys.contains(item.key) &&
        !item.locked;
    final value = editor.valueFor(item);
    final controller = ref.read(
      guardianMinorControllerProvider(widget.minorPlatformUserId).notifier,
    );
    final subtitle = [
      if (item.description.isNotEmpty) item.description,
      if (item.locked) l10n.guardianPolicyLocked,
    ].join('\n');
    switch (item.kind) {
      case TeenPolicyKind.boolValue:
        return SwitchListTile(
          title: Text(item.label),
          subtitle: subtitle.isEmpty ? null : Text(subtitle),
          value: value == true,
          onChanged: enabled
              ? (next) => controller.setDraftValue(item.key, next)
              : null,
        );
      case TeenPolicyKind.intValue:
        return ListTile(
          title: Text(item.label),
          subtitle: subtitle.isEmpty ? null : Text(subtitle),
          trailing: SizedBox(
            width: 92,
            child: TextFormField(
              key: ValueKey('${item.key}-${minor.policy[item.key]}'),
              initialValue: value?.toString() ?? '',
              enabled: enabled,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              decoration: const InputDecoration(isDense: true),
              onChanged: (text) {
                final parsed = int.tryParse(text);
                if (parsed != null) controller.setDraftValue(item.key, parsed);
              },
            ),
          ),
        );
      case TeenPolicyKind.enumValue:
        final values = item.options.map((option) => option.value).toSet();
        final selected = values.contains(value) ? value : null;
        return ListTile(
          title: Text(item.label),
          subtitle: subtitle.isEmpty ? null : Text(subtitle),
          trailing: DropdownButton<Object>(
            value: selected,
            onChanged: enabled
                ? (next) {
                    if (next != null) controller.setDraftValue(item.key, next);
                  }
                : null,
            items: item.options
                .map((option) => DropdownMenuItem<Object>(
                      value: option.value,
                      child: Text(option.label),
                    ))
                .toList(growable: false),
          ),
        );
      case TeenPolicyKind.unknown:
        return const SizedBox.shrink();
    }
  }

  Future<void> _save(BuildContext context) async {
    try {
      await ref
          .read(guardianMinorControllerProvider(widget.minorPlatformUserId)
              .notifier)
          .savePolicy();
    } catch (error) {
      if (context.mounted) showTeenModeError(context, error, ref: ref);
    }
  }

  Future<void> _extend(
    BuildContext context,
    GuardianMinor minor,
    int? maxExtensionMinutes,
  ) async {
    final l10n = AppLocalizations.of(context);
    final text = await showTeenTextInputDialog(
      context,
      title: l10n.guardianExtend,
      label: l10n.teenModeMinutesUnit,
      initialValue: '30',
      numeric: true,
    );
    if (!context.mounted || text == null) return;
    var minutes = int.tryParse(text);
    if (minutes == null || minutes <= 0) return;
    if (maxExtensionMinutes != null && minutes > maxExtensionMinutes) {
      minutes = maxExtensionMinutes;
    }
    try {
      await ref.read(guardianCenterControllerProvider.notifier).extendMinor(
            minorPlatformUserId: minor.minorPlatformUserId,
            minutes: minutes,
          );
      ref.invalidate(guardianMinorSnapshotProvider(widget.minorPlatformUserId));
    } catch (error) {
      if (context.mounted) showTeenModeError(context, error, ref: ref);
    }
  }
}
