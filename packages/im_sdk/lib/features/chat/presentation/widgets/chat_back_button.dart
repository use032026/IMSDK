import 'package:flutter/material.dart';

/// The chat page's real navigation action, including its localized AX name.
class ChatBackButton extends StatelessWidget {
  const ChatBackButton({super.key});

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 48,
        child: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsetsDirectional.only(start: 8),
          alignment: AlignmentDirectional.centerStart,
          color: Theme.of(context).colorScheme.onSurface,
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
      );
}
