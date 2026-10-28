import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/settings/application/diagnostics_controller.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class DiagnosticsPage extends ConsumerWidget {
  const DiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(diagnosticsControllerProvider);
    final controller = ref.read(diagnosticsControllerProvider.notifier);
    final feedback = switch (state.action) {
      DiagnosticAction.completed => l10n.diagnosticsShared,
      DiagnosticAction.cancelled => l10n.diagnosticsCancelled,
      DiagnosticAction.unconfirmed => l10n.diagnosticsUnconfirmed,
      DiagnosticAction.failed => l10n.diagnosticsFailed,
      _ => null,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.diagnosticsTitle)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(l10n.diagnosticsExplanation),
        const SizedBox(height: 20),
        Wrap(spacing: 8, children: [
          for (final hours in [1, 24, 168])
            ChoiceChip(
                label: Text(hours == 1
                    ? l10n.diagnosticsHour
                    : hours == 24
                        ? l10n.diagnosticsDay
                        : l10n.diagnosticsWeek),
                selected: state.range.inHours == hours,
                onSelected: state.busy
                    ? null
                    : (_) => controller.refresh(Duration(hours: hours))),
        ]),
        const SizedBox(height: 20),
        Text(l10n.diagnosticsEventCount(state.count)),
        if (state.first != null && state.last != null) ...[
          const SizedBox(height: 8),
          Text('${state.first!.toLocal()} — ${state.last!.toLocal()}'),
        ],
        const SizedBox(height: 8),
        Text(state.persistent
            ? l10n.diagnosticsPersistent
            : l10n.diagnosticsNotPersistent),
        if (feedback != null) ...[
          const SizedBox(height: 16),
          Text(feedback, key: const Key('diagnostics-feedback')),
        ],
        const SizedBox(height: 24),
        Builder(
            builder: (buttonContext) => FilledButton.icon(
                  key: const Key('diagnostics-share'),
                  icon: state.busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.ios_share),
                  label: Text(l10n.diagnosticsExport),
                  onPressed: state.busy || state.count == 0
                      ? null
                      : () {
                          final box =
                              buttonContext.findRenderObject() as RenderBox;
                          controller.exportAndShare(
                              box.localToGlobal(Offset.zero) & box.size);
                        },
                )),
        TextButton(
            onPressed: state.busy ? null : () => controller.refresh(),
            child: Text(l10n.diagnosticsRefresh)),
        TextButton(
            onPressed: state.busy
                ? null
                : () async {
                    final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Text(l10n.diagnosticsClearConfirm),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(l10n.commonCancel)),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(l10n.commonConfirm))
                              ],
                            ));
                    if (confirmed == true) await controller.clear();
                  },
            child: Text(l10n.diagnosticsClear)),
      ]),
    );
  }
}
