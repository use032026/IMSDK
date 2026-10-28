import 'package:flutter/material.dart';

/// Keeps the app's confirmation and input alerts visually consistent on both
/// mobile platforms while preserving each alert's existing actions and content.
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    this.icon,
    this.title,
    this.content,
    this.actions,
    this.shape,
    this.backgroundColor,
    this.contentPadding,
    this.titlePadding,
    this.actionsPadding,
    this.insetPadding,
    this.scrollable = false,
  });

  final Widget? icon;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? actionsPadding;
  final EdgeInsets? insetPadding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dialogWidth = MediaQuery.sizeOf(context).width - 100;
    final actionTextStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.primary,
    );
    return Theme(
      data: theme.copyWith(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            minimumSize: const Size(0, 44),
            textStyle: actionTextStyle,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: theme.colorScheme.primary,
            elevation: 0,
            minimumSize: const Size(0, 44),
            textStyle: actionTextStyle.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      child: AlertDialog(
        icon: icon,
        title: title == null
            ? null
            : Center(
                child: DefaultTextStyle.merge(
                  textAlign: TextAlign.center,
                  child: title!,
                ),
              ),
        content: content is Text
            ? Center(
                widthFactor: 1,
                heightFactor: 1,
                child: DefaultTextStyle.merge(
                  textAlign: TextAlign.center,
                  child: content!,
                ),
              )
            : content,
        actions: actions,
        shape: shape,
        backgroundColor: backgroundColor,
        contentPadding: contentPadding,
        titlePadding: titlePadding,
        actionsPadding: actionsPadding,
        insetPadding: insetPadding ??
            const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
        constraints: BoxConstraints.tightFor(width: dialogWidth),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        buttonPadding: EdgeInsets.zero,
        scrollable: scrollable,
      ),
    );
  }
}
