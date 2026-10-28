import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// A continuous hold; the gesture arena cancels it on movement or scrolling.
class DiagnosticsVersionGate extends StatelessWidget {
  const DiagnosticsVersionGate(
      {required this.child, required this.onOpen, super.key});
  final Widget child;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => RawGestureDetector(
        key: const Key('diagnostics-version'),
        gestures: {
          LongPressGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(
                duration: const Duration(seconds: 5)),
            (recognizer) => recognizer.onLongPress = onOpen,
          )
        },
        child: child,
      );
}
