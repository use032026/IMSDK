import 'package:flutter/widgets.dart';
import 'package:im_sdk/core/diagnostics/media_diagnostics.dart';

/// Observes the existing provider's stream without changing its loader,
/// fallback widget, cache policy or error propagation.
class MediaImageObserver extends StatefulWidget {
  const MediaImageObserver(
      {super.key,
      required this.provider,
      required this.operation,
      required this.child});
  final ImageProvider provider;
  final MediaDiagnosticOperation operation;
  final Widget child;

  @override
  State<MediaImageObserver> createState() => _MediaImageObserverState();
}

class _MediaImageObserverState extends State<MediaImageObserver> {
  ImageStream? _stream;
  ImageStreamListener? _listener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observe();
  }

  @override
  void didUpdateWidget(MediaImageObserver oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider != widget.provider ||
        oldWidget.operation.scope != widget.operation.scope ||
        oldWidget.operation.resourceHash != widget.operation.resourceHash) {
      _observe();
    }
  }

  void _observe() {
    _detach();
    final operation = widget.operation;
    final stream =
        widget.provider.resolve(createLocalImageConfiguration(context));
    late final ImageStreamListener listener;
    listener = ImageStreamListener((_, __) => stream.removeListener(listener),
        onError: (error, stack) {
      operation.failed(MediaFailureStage.decode, error, stack);
      stream.removeListener(listener);
    });
    _stream = stream;
    _listener = listener;
    stream.addListener(listener);
  }

  void _detach() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
