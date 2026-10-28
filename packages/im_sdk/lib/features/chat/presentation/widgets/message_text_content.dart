import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/services/link_message_policy.dart';
import 'package:im_sdk/features/chat/presentation/providers/link_message_provider.dart';

class MessageTextContent extends ConsumerStatefulWidget {
  final Message message;
  final List<TextMessageLink> links;
  final bool isSelf;

  const MessageTextContent({
    super.key,
    required this.message,
    required this.isSelf,
    this.links = const [],
  });

  @override
  ConsumerState<MessageTextContent> createState() => _MessageTextContentState();
}

class _MessageTextContentState extends ConsumerState<MessageTextContent> {
  final _recognizers = <TapGestureRecognizer>[];
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    _updateRecognizers();
  }

  @override
  void didUpdateWidget(covariant MessageTextContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateRecognizers();
  }

  void _updateRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers
      ..clear()
      ..addAll(widget.links.map(
        (link) => TapGestureRecognizer()..onTap = () => _open(link.url),
      ));
  }

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  Future<void> _open(String url) async {
    if (_opening) return;
    _opening = true;
    try {
      final opened = await ref.read(externalLinkControllerProvider).open(url);
      if (!opened && mounted) AppToast.error(context, '无法打开该链接');
    } finally {
      _opening = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final message = widget.message;
    final text = message.body.text ?? '';
    final baseStyle = TextStyle(
      fontSize: 15,
      color: Theme.of(context).colorScheme.onSurface,
      height: 1.4,
    );
    final mentions = message.mentions
            ?.where((mention) =>
                mention.offset >= 0 &&
                mention.length > 0 &&
                mention.offset + mention.length <= text.length)
            .toList(growable: false) ??
        const <Mention>[];
    if (mentions.isEmpty && widget.links.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final spans = <TextSpan>[];
    void addText(int start, int end) {
      var cursor = start;
      for (var i = 0; i < widget.links.length; i++) {
        final link = widget.links[i];
        if (link.start < start || link.end > end) continue;
        if (link.start > cursor) {
          spans.add(TextSpan(text: text.substring(cursor, link.start)));
        }
        spans.add(TextSpan(
          text: text.substring(link.start, link.end),
          style: TextStyle(
            color: widget.isSelf
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
            decoration: TextDecoration.underline,
          ),
          recognizer: _recognizers[i],
        ));
        cursor = link.end;
      }
      if (cursor < end) spans.add(TextSpan(text: text.substring(cursor, end)));
    }

    final sorted = [...mentions]..sort((a, b) => a.offset.compareTo(b.offset));
    var cursor = 0;
    for (final mention in sorted) {
      if (mention.offset < cursor) continue;
      addText(cursor, mention.offset);
      spans.add(TextSpan(
        text: text.substring(mention.offset, mention.offset + mention.length),
        style: const TextStyle(
          color: Color(0xFF2F6FED),
          fontWeight: FontWeight.w600,
        ),
      ));
      cursor = mention.offset + mention.length;
    }
    addText(cursor, text.length);

    return Text.rich(TextSpan(style: baseStyle, children: spans));
  }
}
