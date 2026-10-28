import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class MessageCopyButton extends StatefulWidget {
  final String text;

  const MessageCopyButton({super.key, required this.text});

  @override
  State<MessageCopyButton> createState() => _MessageCopyButtonState();
}

class _MessageCopyButtonState extends State<MessageCopyButton> {
  bool _copying = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('message-copy-button'),
      tooltip: AppLocalizations.of(context).chatMenuCopy,
      onPressed: _copying ? null : _copy,
      constraints: const BoxConstraints.tightFor(width: 44, height: 44),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 2),
      iconSize: 17,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      icon: const Icon(Icons.copy_outlined),
    );
  }

  Future<void> _copy() async {
    setState(() => _copying = true);
    try {
      await Clipboard.setData(ClipboardData(text: widget.text));
      if (mounted) {
        AppToast.success(context, AppLocalizations.of(context).commonCopied);
      }
    } catch (_) {
      if (mounted) {
        AppToast.error(
            context, AppLocalizations.of(context).commonOperationFailed);
      }
    } finally {
      if (mounted) setState(() => _copying = false);
    }
  }
}
