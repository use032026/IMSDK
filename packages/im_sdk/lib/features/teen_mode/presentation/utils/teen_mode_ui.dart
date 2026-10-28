import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/application/teen_mode_action_executor.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

String teenModeErrorText(
  Object error,
  AppLocalizations l10n,
) {
  if (error is AppError) return ErrorHandler.localizedMessage(error, l10n);
  return error.toString();
}

void showTeenModeError(
  BuildContext context,
  Object error, {
  WidgetRef? ref,
  Future<void> Function(String passcode)? onPasscodeSubmitted,
}) {
  if (ref != null &&
      showTeenModeServerAction(
        context,
        ref,
        error,
        onPasscodeSubmitted: onPasscodeSubmitted,
      )) {
    return;
  }
  final text = teenModeErrorText(error, AppLocalizations.of(context));
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

TeenModeServerAction? teenModeServerActionForError(
  WidgetRef ref,
  Object error,
) {
  final normalized =
      error is DioException ? ErrorHandler.fromDioException(error) : error;
  return ref.read(teenModeActionExecutorProvider).classify(normalized);
}

bool showTeenModeServerAction(
  BuildContext context,
  WidgetRef ref,
  Object error, {
  Future<void> Function(String passcode)? onPasscodeSubmitted,
}) {
  final action = teenModeServerActionForError(ref, error);
  if (action == null) return false;
  final l10n = AppLocalizations.of(context);
  final message = action.message.trim().isNotEmpty
      ? action.message
      : l10n.teenModeActionBlocked;
  switch (action.interaction) {
    case TeenModeServerInteraction.openRequests:
      _showActionSnackBar(
        context,
        message: message,
        actionLabel: l10n.commonViewAll,
        onPressed: () => context.push('/settings/teen-mode/requests'),
      );
    case TeenModeServerInteraction.openGuardianBinding:
      _showActionSnackBar(
        context,
        message: message,
        actionLabel: l10n.guardianBind,
        onPressed: () => context.push('/settings/teen-mode/guardian'),
      );
    case TeenModeServerInteraction.promptPasscode:
      if (onPasscodeSubmitted == null) {
        _showActionSnackBar(
          context,
          message: message,
          actionLabel: l10n.teenModeTitle,
          onPressed: () => context.push('/settings/teen-mode'),
        );
      } else {
        unawaited(_showRequiredPasscodeDialog(
          context,
          message: message,
          onSubmitted: onPasscodeSubmitted,
        ));
      }
    case TeenModeServerInteraction.showRestriction:
      unawaited(_showRestrictionDialog(context, action));
    case TeenModeServerInteraction.notice:
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
  }
  return true;
}

void _showActionSnackBar(
  BuildContext context, {
  required String message,
  required String actionLabel,
  required VoidCallback onPressed,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(label: actionLabel, onPressed: onPressed),
    ),
  );
}

Future<void> _showRequiredPasscodeDialog(
  BuildContext context, {
  required String message,
  required Future<void> Function(String passcode) onSubmitted,
}) async {
  final l10n = AppLocalizations.of(context);
  final passcode = await showTeenTextInputDialog(
    context,
    title: l10n.teenModePasscode,
    label: l10n.teenModePasscode,
    hint: message.isEmpty ? l10n.teenModePasscodeHint : message,
    numeric: true,
    obscure: true,
  );
  if (!context.mounted || passcode == null) return;
  if (!RegExp(r'^\d{4,6}$').hasMatch(passcode)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.teenModePasscodeHint)),
    );
    return;
  }
  try {
    await onSubmitted(passcode);
  } catch (error) {
    if (context.mounted) showTeenModeError(context, error);
  }
}

Future<void> _showRestrictionDialog(
  BuildContext context,
  TeenModeServerAction action,
) async {
  final l10n = AppLocalizations.of(context);
  final title = action.kind == TeenModeServerActionKind.curfew
      ? l10n.teenModeCurfewActive
      : l10n.teenModeTimeLimitReached;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AppAlertDialog(
      icon: const Icon(Icons.shield_outlined),
      title: Text(title),
      content: Text(
        action.message.trim().isEmpty
            ? l10n.teenModeReliefHint
            : action.message,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            context.push('/settings/teen-mode');
          },
          child: Text(l10n.teenModeRequestExtension),
        ),
      ],
    ),
  );
}

String approvalStatusLabel(
  AppLocalizations l10n,
  GuardianApprovalStatus status,
) =>
    switch (status) {
      GuardianApprovalStatus.pending => l10n.approvalPending,
      GuardianApprovalStatus.approved => l10n.approvalApproved,
      GuardianApprovalStatus.rejected => l10n.approvalRejected,
      GuardianApprovalStatus.expired => l10n.approvalExpired,
      GuardianApprovalStatus.cancelled => l10n.approvalCancelled,
      GuardianApprovalStatus.unknown => l10n.commonUnknown,
    };

Future<String?> showTeenTextInputDialog(
  BuildContext context, {
  required String title,
  required String label,
  String? hint,
  String? initialValue,
  bool numeric = false,
  bool obscure = false,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _TeenTextInputDialog(
      title: title,
      label: label,
      hint: hint,
      initialValue: initialValue,
      numeric: numeric,
      obscure: obscure,
    ),
  );
}

class _TeenTextInputDialog extends StatefulWidget {
  const _TeenTextInputDialog({
    required this.title,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.numeric,
    required this.obscure,
  });

  final String title;
  final String label;
  final String? hint;
  final String? initialValue;
  final bool numeric;
  final bool obscure;

  @override
  State<_TeenTextInputDialog> createState() => _TeenTextInputDialogState();
}

class _TeenTextInputDialogState extends State<_TeenTextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppAlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        obscureText: widget.obscure,
        keyboardType:
            widget.numeric ? TextInputType.number : TextInputType.text,
        maxLength: widget.numeric ? 6 : null,
        decoration:
            InputDecoration(labelText: widget.label, hintText: widget.hint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: Text(l10n.commonConfirm),
        ),
      ],
    );
  }
}
