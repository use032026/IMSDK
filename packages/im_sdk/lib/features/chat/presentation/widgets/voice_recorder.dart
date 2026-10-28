import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

abstract class VoiceRecordingBackend {
  Future<bool> hasPermission();
  Future<String> createOutputPath();
  Future<void> start(String path);
  Future<String?> stop();
  Future<void> dispose();
}

int voiceRecordingDurationSeconds(Duration elapsed) =>
    elapsed.inSeconds.clamp(0, 60);

class DeviceVoiceRecordingBackend implements VoiceRecordingBackend {
  final AudioRecorder _recorder;

  DeviceVoiceRecordingBackend({AudioRecorder? recorder})
      : _recorder = recorder ?? AudioRecorder();

  @override
  Future<bool> hasPermission() => _recorder.hasPermission();

  @override
  Future<String> createOutputPath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  @override
  Future<void> start(String path) {
    return _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        bitRate: 128000,
      ),
      path: path,
    );
  }

  @override
  Future<String?> stop() => _recorder.stop();

  @override
  Future<void> dispose() => _recorder.dispose();
}

class VoiceRecorder extends StatefulWidget {
  final FutureOr<void> Function(String filePath, int durationSeconds)
      onSendVoice;
  final FutureOr<bool> Function(String text)? onSendText;
  final FutureOr<String?> Function(String filePath)? onTranscribeVoice;
  final VoidCallback onCancel;
  final VoiceRecordingBackend? recordingBackend;

  const VoiceRecorder({
    super.key,
    required this.onSendVoice,
    this.onSendText,
    this.onTranscribeVoice,
    required this.onCancel,
    this.recordingBackend,
  });

  @override
  State<VoiceRecorder> createState() => _VoiceRecorderState();
}

enum _VoiceReleaseAction { sendVoice, cancel, convertToText }

class _VoiceRecorderState extends State<VoiceRecorder>
    with TickerProviderStateMixin {
  late final VoiceRecordingBackend _recorder;

  bool _isRecording = false;
  bool _isStartingRecording = false;
  bool _shouldStopAfterStart = false;
  bool _isStopping = false;
  _VoiceReleaseAction _releaseAction = _VoiceReleaseAction.sendVoice;
  Offset? _pressStartGlobalPosition;
  int _durationSeconds = 0;
  final Stopwatch _recordingClock = Stopwatch();
  Timer? _timer;
  String? _recordedFilePath;
  int _recordedDuration = 0;

  // 声波动画控制器（5 根竖条）
  late final List<AnimationController> _waveControllers;
  late final List<Animation<double>> _waveAnimations;

  Timer? _tipTimer;
  OverlayEntry? _tooShortOverlayEntry;
  OverlayEntry? _recordingOverlayEntry;
  OverlayEntry? _convertOverlayEntry;

  @override
  void initState() {
    super.initState();
    _recorder = widget.recordingBackend ?? DeviceVoiceRecordingBackend();
    _waveControllers = List.generate(5, (i) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + i * 80),
      );
      ctrl.repeat(reverse: true);
      return ctrl;
    });

    final heights = [0.4, 0.8, 1.0, 0.7, 0.5];
    _waveAnimations = List.generate(5, (i) {
      return Tween<double>(begin: 0.15, end: heights[i]).animate(
        CurvedAnimation(parent: _waveControllers[i], curve: Curves.easeInOut),
      );
    });
  }

  @override
  void dispose() {
    for (final c in _waveControllers) {
      c.dispose();
    }
    _timer?.cancel();
    _tipTimer?.cancel();
    _hideTooShortTip();
    _hideRecordingOverlay();
    _hideConvertOverlay();
    final draftPath = _recordedFilePath;
    if (draftPath != null) unawaited(_deleteTemporaryRecording(draftPath));
    unawaited(_recorder.dispose());
    super.dispose();
  }

  void _showRecordingOverlay() {
    if (_recordingOverlayEntry != null) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _recordingOverlayEntry = OverlayEntry(
      builder: (_) => _RecordingOverlay(
        durationSeconds: _durationSeconds,
        waveAnimations: _waveAnimations,
        releaseAction: _releaseAction,
        liveText: '',
      ),
    );
    overlay.insert(_recordingOverlayEntry!);
  }

  void _hideRecordingOverlay() {
    _recordingOverlayEntry?.remove();
    _recordingOverlayEntry = null;
  }

  void _showConvertOverlay() {
    if (_convertOverlayEntry != null) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    final path = _recordedFilePath;
    if (overlay == null || path == null) return;
    _convertOverlayEntry = OverlayEntry(
      builder: (_) => _VoiceConvertOverlay(
        transcription: Future<String?>.sync(
          () => widget.onTranscribeVoice?.call(path),
        ),
        onCancel: _cancelConvertedDraft,
        onSendText: _sendConvertedText,
        onSendVoice: _sendConvertedVoice,
      ),
    );
    overlay.insert(_convertOverlayEntry!);
  }

  void _hideConvertOverlay() {
    _convertOverlayEntry?.remove();
    _convertOverlayEntry = null;
  }

  Future<void> _startRecording() async {
    if (_isRecording || _isStartingRecording) return;
    _isStartingRecording = true;
    _shouldStopAfterStart = false;
    _releaseAction = _VoiceReleaseAction.sendVoice;

    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        _isStartingRecording = false;
        if (mounted) {
          AppToast.error(context, '需要麦克风权限');
        }
        return;
      }

      final path = await _recorder.createOutputPath();
      await _recorder.start(path);
      _recordingClock
        ..reset()
        ..start();

      if (!mounted) return;
      setState(() {
        _isRecording = true;
        _isStartingRecording = false;
        _durationSeconds = 0;
        _recordedFilePath = path;
      });
      _showRecordingOverlay();

      _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
        if (!mounted) return;
        final elapsed = voiceRecordingDurationSeconds(_recordingClock.elapsed);
        if (elapsed != _durationSeconds) {
          setState(() => _durationSeconds = elapsed);
          _recordingOverlayEntry?.markNeedsBuild();
        }
        // 60 秒自动停止
        if (elapsed >= 60) {
          _stopRecording(action: _VoiceReleaseAction.sendVoice);
        }
      });

      if (_shouldStopAfterStart) {
        unawaited(
          _stopRecording(
            action: _releaseAction,
          ),
        );
      }
    } catch (_) {
      _isStartingRecording = false;
      _isRecording = false;
      _recordingClock
        ..stop()
        ..reset();
      _timer?.cancel();
      _timer = null;
      _hideRecordingOverlay();
      if (mounted) {
        AppToast.error(context, '录音启动失败');
      }
    }
  }

  void _handlePressStart(Offset globalPosition) {
    if (_isRecording || _isStartingRecording) return;
    _pressStartGlobalPosition = globalPosition;
    unawaited(_startRecording());
  }

  void _handlePressEnd({required bool cancel}) {
    _pressStartGlobalPosition = null;
    final action = cancel ? _VoiceReleaseAction.cancel : _releaseAction;
    if (_isStartingRecording && !_isRecording) {
      _shouldStopAfterStart = true;
      _releaseAction = action;
      return;
    }
    unawaited(_stopRecording(action: action));
  }

  void _handlePressMove(Offset globalPosition) {
    final start = _pressStartGlobalPosition;
    if (start == null) return;
    final delta = globalPosition - start;
    final nextAction = delta.dy >= -48
        ? _VoiceReleaseAction.sendVoice
        : delta.dx > 40
            ? _VoiceReleaseAction.convertToText
            : _VoiceReleaseAction.cancel;
    if (nextAction != _releaseAction) {
      _releaseAction = nextAction;
      unawaited(HapticFeedback.selectionClick());
      if (mounted) {
        setState(() {});
      }
      _recordingOverlayEntry?.markNeedsBuild();
    }
  }

  Future<void> _stopRecording({
    required _VoiceReleaseAction action,
  }) async {
    if (!_isRecording || _isStopping) return;
    _isStopping = true;
    _timer?.cancel();
    _timer = null;
    _recordingClock.stop();
    final recordedDuration =
        voiceRecordingDurationSeconds(_recordingClock.elapsed);
    _recordingClock.reset();
    String? path;
    try {
      path = await _recorder.stop();
    } finally {
      _isStopping = false;
    }

    if (!mounted) return;
    _hideRecordingOverlay();
    setState(() {
      _isRecording = false;
      _releaseAction = _VoiceReleaseAction.sendVoice;
    });

    if (action == _VoiceReleaseAction.cancel || path == null) {
      if (path != null) unawaited(_deleteTemporaryRecording(path));
      _recordedFilePath = null;
      widget.onCancel();
      return;
    }

    if (recordedDuration < 1) {
      unawaited(_deleteTemporaryRecording(path));
      _recordedFilePath = null;
      _showTooShort();
      widget.onCancel();
      return;
    }

    if (action == _VoiceReleaseAction.convertToText) {
      _recordedFilePath = path;
      _recordedDuration = recordedDuration;
      _showConvertOverlay();
      return;
    }

    _recordedFilePath = null;
    await Future.sync(() => widget.onSendVoice(path!, recordedDuration));
  }

  Future<bool> _sendConvertedText(String text) async {
    final sendText = widget.onSendText;
    final path = _recordedFilePath;
    if (sendText == null || path == null) return false;
    final sent = await Future.sync(() => sendText(text.trim()));
    if (!sent) return false;
    _hideConvertOverlay();
    _recordedFilePath = null;
    _recordedDuration = 0;
    unawaited(_deleteTemporaryRecording(path));
    return true;
  }

  Future<void> _sendConvertedVoice() async {
    final path = _recordedFilePath;
    if (path == null) return;
    await Future.sync(
      () => widget.onSendVoice(path, _recordedDuration),
    );
    _hideConvertOverlay();
    _recordedFilePath = null;
    _recordedDuration = 0;
  }

  Future<void> _cancelConvertedDraft() async {
    final path = _recordedFilePath;
    _hideConvertOverlay();
    _recordedFilePath = null;
    _recordedDuration = 0;
    if (path != null) unawaited(_deleteTemporaryRecording(path));
    widget.onCancel();
  }

  Future<void> _deleteTemporaryRecording(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Temporary cleanup failure must not block the compose flow.
    }
  }

  void _showTooShort() {
    _hideTooShortTip();
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _tooShortOverlayEntry = OverlayEntry(
      builder: (_) => const _VoiceTooShortTip(),
    );
    overlay.insert(_tooShortOverlayEntry!);
    _tipTimer?.cancel();
    _tipTimer = Timer(const Duration(milliseconds: 1600), _hideTooShortTip);
  }

  void _hideTooShortTip() {
    _tooShortOverlayEntry?.remove();
    _tooShortOverlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Listener(
      onPointerDown: (event) => _handlePressStart(event.position),
      onPointerUp: (_) => _handlePressEnd(cancel: false),
      onPointerCancel: (_) => _handlePressEnd(cancel: true),
      onPointerMove: (event) => _handlePressMove(event.position),
      child: Container(
        width: double.infinity,
        height: 42,
        decoration: BoxDecoration(
          color: _isRecording ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color:
                _isRecording ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _isRecording ? '录音中...' : '按住 说话',
          style: TextStyle(
            fontSize: 15,
            color: _isRecording ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _VoiceTooShortTip extends StatelessWidget {
  const _VoiceTooShortTip();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            key: const ValueKey('voice-recording-too-short-tip'),
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              color: colorScheme.inverseSurface.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: colorScheme.onInverseSurface,
                  child: Text(
                    '!',
                    style: TextStyle(
                      color: colorScheme.inverseSurface,
                      fontSize: 38,
                      height: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '说话时间太短',
                  style: TextStyle(
                    color: colorScheme.onInverseSurface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 录音覆盖层（全屏）
// ---------------------------------------------------------------------------

class _RecordingOverlay extends StatelessWidget {
  final int durationSeconds;
  final List<Animation<double>> waveAnimations;
  final _VoiceReleaseAction releaseAction;
  final String liveText;

  const _RecordingOverlay({
    required this.durationSeconds,
    required this.waveAnimations,
    required this.releaseAction,
    required this.liveText,
  });

  @override
  Widget build(BuildContext context) {
    final willCancel = releaseAction == _VoiceReleaseAction.cancel;
    final willConvert = releaseAction == _VoiceReleaseAction.convertToText;
    return Material(
      color: Colors.black.withValues(alpha: 0.70),
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.08),
              child: Semantics(
                label: '正在录音，$durationSeconds 秒',
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      key: const ValueKey('voice-recording-wave-card'),
                      width: MediaQuery.sizeOf(context).width - 48,
                      constraints: const BoxConstraints(
                        minHeight: 112,
                        maxHeight: 220,
                      ),
                      padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                      decoration: BoxDecoration(
                        color: willCancel
                            ? const Color(0xFFE05A5A)
                            : const Color(0xFF95EC69),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: liveText.trim().isEmpty
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 3,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: willCancel
                                            ? Colors.white
                                            : const Color(0xFF68D74D),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    reverse: true,
                                    child: Text(
                                      liveText,
                                      key: const ValueKey(
                                        'voice-recording-live-text',
                                      ),
                                      style: TextStyle(
                                        color: willCancel
                                            ? Colors.white
                                            : const Color(0xFF111111),
                                        fontSize: 22,
                                        height: 1.35,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 18),
                          _RecordingWaveform(
                            waveAnimations: waveAnimations,
                            color: willCancel
                                ? Colors.white.withValues(alpha: 0.92)
                                : const Color(0xFF548F3F),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -7,
                      child: Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: willCancel
                                ? const Color(0xFFE05A5A)
                                : const Color(0xFF95EC69),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 230,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      left: -26,
                      bottom: 102,
                      child: _VoiceActionRegion(
                        key: const ValueKey('voice-recording-cancel'),
                        isLeft: true,
                        selected: willCancel,
                        selectedColor: const Color(0xFFE05A5A),
                        label: '取消',
                      ),
                    ),
                    Positioned(
                      right: -26,
                      bottom: 102,
                      child: _VoiceActionRegion(
                        key: const ValueKey('voice-recording-convert'),
                        isLeft: false,
                        selected: willConvert,
                        selectedColor: const Color(0xFF95EC69),
                        label: '滑到这里 转文字',
                      ),
                    ),
                    Positioned(
                      left: -48,
                      right: -48,
                      bottom: -136,
                      child: Container(
                        height: 265,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.42),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.elliptical(320, 110),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -44,
                      right: -44,
                      bottom: -139,
                      child: Container(
                        height: 265,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.82),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.elliptical(320, 110),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 95,
                      child: Text(
                        switch (releaseAction) {
                          _VoiceReleaseAction.cancel => '松开 取消',
                          _VoiceReleaseAction.convertToText => '松手 编辑文字',
                          _VoiceReleaseAction.sendVoice => '松开 发送',
                        },
                        key: const ValueKey('voice-recording-release-send'),
                        style: const TextStyle(
                          color: Color(0xFF111111),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceActionRegion extends StatelessWidget {
  final bool isLeft;
  final bool selected;
  final Color selectedColor;
  final String label;

  const _VoiceActionRegion({
    super.key,
    required this.isLeft,
    required this.selected,
    required this.selectedColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final foreground =
        selected && !isLeft ? const Color(0xFF111111) : Colors.white;
    final background = selected
        ? selectedColor.withValues(alpha: 0.92)
        : const Color(0xFF666666).withValues(alpha: 0.96);
    return SizedBox(
      width: 191,
      height: 104,
      child: CustomPaint(
        painter: _VoiceActionRegionPainter(
          isLeft: isLeft,
          color: background,
        ),
        child: Align(
          alignment: const Alignment(0, 0.24),
          child: Transform.rotate(
            angle: isLeft ? -0.08 : 0.08,
            child: Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VoiceActionRegionPainter extends CustomPainter {
  final bool isLeft;
  final Color color;

  const _VoiceActionRegionPainter({
    required this.isLeft,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isLeft) {
      canvas
        ..translate(size.width, 0)
        ..scale(-1, 1);
    }

    final centerline = Path()
      ..moveTo(-12, size.height * 0.88)
      ..quadraticBezierTo(
        size.width * 0.48,
        size.height * 0.52,
        size.width * 0.88,
        size.height * 0.48,
      );
    canvas.drawPath(
      centerline,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 44
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(_VoiceActionRegionPainter oldDelegate) =>
      oldDelegate.isLeft != isLeft || oldDelegate.color != color;
}

class _RecordingWaveform extends StatelessWidget {
  final List<Animation<double>> waveAnimations;
  final Color color;

  const _RecordingWaveform({
    required this.waveAnimations,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    const profile = <double>[
      .25,
      .36,
      .54,
      .72,
      .90,
      .76,
      .58,
      .42,
      .32,
      .27,
      .30,
      .38,
      .48,
      .58,
      .46,
      .36,
      .31,
      .28,
      .34,
      .44,
      .62,
      .78,
      .68,
      .53,
      .41,
      .33,
      .28,
    ];
    return SizedBox(
      key: const ValueKey('voice-recording-waveform'),
      width: 88,
      height: 26,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(profile.length, (index) {
          final animation = waveAnimations[index % waveAnimations.length];
          return AnimatedBuilder(
            animation: animation,
            builder: (_, __) => Container(
              width: 2.2,
              height: 6 + 22 * profile[index] * animation.value,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _VoiceConvertOverlay extends StatefulWidget {
  final Future<String?> transcription;
  final Future<void> Function() onCancel;
  final Future<bool> Function(String text) onSendText;
  final Future<void> Function() onSendVoice;

  const _VoiceConvertOverlay({
    required this.transcription,
    required this.onCancel,
    required this.onSendText,
    required this.onSendVoice,
  });

  @override
  State<_VoiceConvertOverlay> createState() => _VoiceConvertOverlayState();
}

class _VoiceConvertOverlayState extends State<_VoiceConvertOverlay> {
  late final TextEditingController _controller;
  bool _recognizing = true;
  bool _recognizedText = false;
  bool _sending = false;

  bool get _hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    unawaited(_loadTranscription());
  }

  Future<void> _loadTranscription() async {
    String text = '';
    try {
      text = (await widget.transcription)?.trim() ?? '';
    } catch (_) {
      text = '';
    }
    if (!mounted) return;
    _controller.text = text;
    setState(() {
      _recognizing = false;
      _recognizedText = text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendText() async {
    if (!_hasText || _sending) return;
    setState(() => _sending = true);
    final sent = await widget.onSendText(_controller.text);
    if (mounted && !sent) setState(() => _sending = false);
  }

  Future<void> _sendVoice() async {
    if (_sending) return;
    setState(() => _sending = true);
    await widget.onSendVoice();
  }

  @override
  Widget build(BuildContext context) {
    final canSendText = !_recognizing && _hasText;
    final bubbleColor = _recognizing || _recognizedText
        ? const Color(0xFF95EC69)
        : const Color(0xFFFF5155);
    return Material(
      color: Colors.black.withValues(alpha: 0.70),
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.08),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width - 48,
                    constraints: const BoxConstraints(
                      minHeight: 112,
                      maxHeight: 260,
                    ),
                    padding: const EdgeInsets.fromLTRB(28, 22, 28, 22),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _recognizing
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Color(0xFF198754),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  '正在转文字…',
                                  style: TextStyle(
                                    color: Color(0xFF111111),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _recognizedText
                            ? TextField(
                                key: const ValueKey('voice-convert-editor'),
                                controller: _controller,
                                autofocus: false,
                                maxLines: null,
                                minLines: 2,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(
                                  color: Color(0xFF111111),
                                  fontSize: 22,
                                  height: 1.35,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  filled: false,
                                  fillColor: Colors.transparent,
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    '未识别到文字',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                  Positioned(
                    bottom: -7,
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 28,
              right: 28,
              bottom: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _VoiceConvertRoundAction(
                    key: const ValueKey('voice-convert-cancel'),
                    icon: Icons.close,
                    label: '取消',
                    onTap: _sending ? null : widget.onCancel,
                  ),
                  _VoiceConvertRoundAction(
                    key: const ValueKey('voice-convert-send-voice'),
                    icon: Icons.volume_up_rounded,
                    label: '发送原语音',
                    onTap: _sending ? null : _sendVoice,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: InkWell(
                      key: const ValueKey('voice-convert-send-text'),
                      borderRadius: BorderRadius.circular(36),
                      onTap: canSendText && !_sending ? _sendText : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 126,
                        height: 68,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: canSendText && !_sending
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Text(
                          _sending ? '发送中' : '发送',
                          style: TextStyle(
                            color: canSendText && !_sending
                                ? const Color(0xFF111111)
                                : Colors.white.withValues(alpha: 0.35),
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceConvertRoundAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final FutureOr<void> Function()? onTap;

  const _VoiceConvertRoundAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(38),
          onTap: onTap == null ? null : () => Future.sync(onTap!),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }
}
