import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/platform/local_file.dart';
import 'package:im_sdk/core/diagnostics/media_diagnostics.dart';
import 'package:im_sdk/core/widgets/app_network_image.dart';
import 'package:im_sdk/features/chat/domain/entities/media_local_file.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_open_controller.dart';
import 'package:im_sdk/features/chat/presentation/models/message_media_preview_model.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';

const chatMediaVideoControlsHideDelay = Duration(milliseconds: 2500);

class ChatMediaVideoPage extends ConsumerStatefulWidget {
  final bool active;
  final String? spaceId;
  final Message message;
  final MediaResource media;
  final String? posterUrl;
  final Size? posterSize;
  final ImageProvider? posterProvider;
  final VoidCallback onClose;
  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;
  final Future<String> Function()? loadLocalPath;

  const ChatMediaVideoPage({
    super.key,
    required this.active,
    required this.spaceId,
    required this.message,
    required this.media,
    required this.posterUrl,
    required this.onClose,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.posterSize,
    this.posterProvider,
    this.loadLocalPath,
  });

  @override
  ConsumerState<ChatMediaVideoPage> createState() => _ChatMediaVideoPageState();
}

class _ChatMediaVideoPageState extends ConsumerState<ChatMediaVideoPage>
    with WidgetsBindingObserver {
  VideoPlayerController? _player;
  MediaDiagnosticOperation? _diagnostic;
  Timer? _controlsTimer;
  bool _loading = false;
  bool _failed = false;
  bool _controlsVisible = true;
  bool _scrubbing = false;
  bool _videoVisible = false;
  bool _wasEnded = false;
  bool _allowsAutoPlay = true;
  int _loadRevision = 0;
  int _transitionRevision = 0;
  Future<void> _playerTransition = Future<void>.value();

  double get _fallbackAspectRatio {
    final width = widget.media.width;
    final height = widget.media.height;
    if (width != null && height != null && width > 0 && height > 0) {
      return width / height;
    }
    final posterSize = widget.posterSize;
    if (posterSize != null && posterSize.width > 0 && posterSize.height > 0) {
      return posterSize.width / posterSize.height;
    }
    return 16 / 9;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final state = WidgetsBinding.instance.lifecycleState;
    _allowsAutoPlay = state == null || state == AppLifecycleState.resumed;
    _schedulePlayerTransition();
  }

  @override
  void didUpdateWidget(ChatMediaVideoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final sourceChanged =
        oldWidget.message.messageId != widget.message.messageId ||
            oldWidget.media.url != widget.media.url;
    if (sourceChanged || oldWidget.active != widget.active) {
      _schedulePlayerTransition();
    }
  }

  void _schedulePlayerTransition() {
    final revision = ++_transitionRevision;
    _loadRevision++;
    _playerTransition = _playerTransition.then((_) async {
      if (!mounted || revision != _transitionRevision) return;
      if (widget.active && _allowsAutoPlay) {
        await _activate();
      } else {
        await _releasePlayer(updateState: true);
      }
    });
  }

  Future<void> _activate() async {
    final revision = ++_loadRevision;
    await _releasePlayer(updateState: false, invalidate: false);
    if (!mounted ||
        !widget.active ||
        !_allowsAutoPlay ||
        revision != _loadRevision) {
      return;
    }
    setState(() {
      _loading = true;
      _failed = false;
      _controlsVisible = true;
      _videoVisible = false;
      _wasEnded = false;
    });
    final diagnostic = MediaDiagnosticOperation(
        scope: ref.read(mediaDiagnosticScopeProvider),
        kind: DiagnosticMediaKind.video,
        resource: widget.media.url,
        messageId: widget.message.messageId);
    _diagnostic = diagnostic;
    var stage = MediaFailureStage.load;
    try {
      final path = await (widget.loadLocalPath?.call() ?? _resolveLocalPath());
      if (!mounted ||
          !widget.active ||
          !_allowsAutoPlay ||
          revision != _loadRevision) {
        return;
      }
      final controller = VideoPlayerController.file(File(path));
      stage = MediaFailureStage.initialize;
      await controller.initialize();
      if (!mounted ||
          !widget.active ||
          !_allowsAutoPlay ||
          revision != _loadRevision) {
        await controller.dispose();
        return;
      }
      controller.addListener(_onPlayerChanged);
      _player = controller;
      setState(() => _loading = false);
      if (_allowsAutoPlay) {
        stage = MediaFailureStage.playback;
        await controller.play();
        _scheduleControlsHide();
      }
    } catch (error, stack) {
      diagnostic.failed(stage, error, stack);
      if (!mounted || !widget.active || revision != _loadRevision) return;
      setState(() {
        _loading = false;
        _failed = true;
        _controlsVisible = true;
      });
    }
  }

  Future<String> _resolveLocalPath() {
    final spaceId = widget.spaceId;
    if (spaceId == null || spaceId.isEmpty) {
      return Future<String>.error(StateError('Current space is empty'));
    }
    return ref.read(mediaOpenControllerProvider(spaceId)).localPathFor(
          MediaOpenRequest.fromResource(
            message: widget.message,
            mediaKind: MediaKind.video,
            variant: MediaVariant.videoSource,
            resource: widget.media,
            fallbackName: widget.media.fileName ?? 'video.mp4',
          ),
        );
  }

  Future<void> _releasePlayer({
    required bool updateState,
    bool invalidate = true,
  }) async {
    final revision = invalidate ? ++_loadRevision : _loadRevision;
    _controlsTimer?.cancel();
    final player = _player;
    final diagnostic = _diagnostic;
    _diagnostic = null;
    _player = null;
    player?.removeListener(_onPlayerChanged);
    try {
      await player?.pause();
    } catch (error, stack) {
      diagnostic?.failed(MediaFailureStage.playback, error, stack);
    }
    try {
      await player?.dispose();
    } catch (error, stack) {
      diagnostic?.failed(MediaFailureStage.playback, error, stack);
    }
    if (updateState && mounted && revision == _loadRevision) {
      setState(() {
        _loading = false;
        _failed = false;
        _controlsVisible = true;
        _videoVisible = false;
      });
    }
  }

  void _onPlayerChanged() {
    final player = _player;
    if (!mounted || player == null) return;
    final value = player.value;
    if (value.hasError) {
      // The native description can contain a private file path or signed URL.
      _diagnostic?.failed(
          MediaFailureStage.playback, StateError('native_player_error'));
    }
    if (value.hasError && !_failed) {
      _controlsTimer?.cancel();
      _failed = true;
      _loading = false;
      _controlsVisible = true;
      _videoVisible = false;
    } else if (!_videoVisible && value.position > Duration.zero) {
      _videoVisible = true;
    }
    final ended =
        value.duration > Duration.zero && value.position >= value.duration;
    if (ended && !_wasEnded) {
      _controlsTimer?.cancel();
      _controlsVisible = true;
    }
    _wasEnded = ended;
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final resumed = state == AppLifecycleState.resumed;
    _allowsAutoPlay = resumed;
    _schedulePlayerTransition();
  }

  void _scheduleControlsHide() {
    _controlsTimer?.cancel();
    final player = _player;
    if (player == null || !player.value.isPlaying || _scrubbing) return;
    _controlsTimer = Timer(chatMediaVideoControlsHideDelay, () {
      if (mounted && widget.active) setState(() => _controlsVisible = false);
    });
  }

  void _toggleControls() {
    if (!widget.active) return;
    setState(() => _controlsVisible = !_controlsVisible);
    if (_controlsVisible) _scheduleControlsHide();
  }

  Future<void> _togglePlayback() async {
    final player = _player;
    if (player == null) return;
    final ended = player.value.duration > Duration.zero &&
        player.value.position >= player.value.duration;
    final diagnostic = _diagnostic;
    if (ended) {
      await _observePlayback(diagnostic, () => player.seekTo(Duration.zero));
    }
    if (ended || !player.value.isPlaying) {
      await _observePlayback(diagnostic, player.play);
    } else {
      await _observePlayback(diagnostic, player.pause);
    }
    if (!mounted) return;
    setState(() => _controlsVisible = true);
    _scheduleControlsHide();
  }

  Future<void> _observePlayback(MediaDiagnosticOperation? diagnostic,
      Future<void> Function() action) async {
    if (diagnostic == null) return action();
    await diagnostic.observe(MediaFailureStage.playback, action);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _transitionRevision++;
    _loadRevision++;
    _controlsTimer?.cancel();
    final player = _player;
    _player = null;
    player?.removeListener(_onPlayerChanged);
    unawaited(player?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey('media-viewer-video-page'),
      behavior: HitTestBehavior.opaque,
      onTap: _toggleControls,
      onVerticalDragUpdate: widget.onVerticalDragUpdate,
      onVerticalDragEnd: widget.onVerticalDragEnd,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: _buildVideoSurface()),
          IgnorePointer(
            ignoring: !_controlsVisible || !widget.active,
            child: AnimatedOpacity(
              opacity: _controlsVisible && widget.active ? 1 : 0,
              duration: const Duration(milliseconds: 160),
              child: _buildControls(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSurface() {
    final player = _player;
    final ratio = player != null && player.value.isInitialized
        ? player.value.aspectRatio
        : _fallbackAspectRatio;
    return AspectRatio(
      aspectRatio: ratio > 0 ? ratio : 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (player != null && player.value.isInitialized) VideoPlayer(player),
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _videoVisible ? 0 : 1,
              duration: const Duration(milliseconds: 120),
              child: _buildPoster(),
            ),
          ),
          if (_loading)
            const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 1.8,
                  color: Colors.white,
                ),
              ),
            ),
          if (_failed)
            Center(
              child: TextButton.icon(
                key: const ValueKey('media-viewer-video-retry'),
                onPressed: _schedulePlayerTransition,
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  '${AppLocalizations.of(context).chatLoadFailed}，${AppLocalizations.of(context).commonRetry}',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPoster() {
    final provider = widget.posterProvider;
    if (provider != null) {
      return Image(image: provider, fit: BoxFit.contain, gaplessPlayback: true);
    }
    final source = widget.posterUrl?.trim();
    if (source == null || source.isEmpty) {
      return const ColoredBox(color: Colors.black);
    }
    if (isLocalVisualMediaUrl(source)) {
      return localImageWidget(localPathFromUriOrPath(source),
          diagnostic: MediaDiagnosticOperation(
              scope: ref.read(mediaDiagnosticScopeProvider),
              kind: DiagnosticMediaKind.image,
              resource: source),
          fit: BoxFit.contain);
    }
    return AppNetworkImage(
      url: source,
      fit: BoxFit.contain,
      cacheInMemory: true,
      placeholderBuilder: (_) => const ColoredBox(color: Colors.black),
      errorBuilder: (_) => const ColoredBox(color: Colors.black),
    );
  }

  Widget _buildControls() {
    final player = _player;
    final value = player?.value;
    final duration = value?.duration ?? Duration.zero;
    final position = value?.position ?? Duration.zero;
    final ended = duration > Duration.zero && position >= duration;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: 8,
          top: 0,
          child: SafeArea(
            child: IconButton(
              key: const ValueKey('media-viewer-video-close'),
              tooltip: AppLocalizations.of(context).commonClose,
              onPressed: widget.onClose,
              icon: const Icon(Icons.close_rounded, color: Colors.white),
            ),
          ),
        ),
        if (player != null && value!.isInitialized)
          Center(
            child: IconButton(
              key: ValueKey(ended
                  ? 'media-viewer-video-replay'
                  : 'media-viewer-video-play'),
              onPressed: _togglePlayback,
              iconSize: 54,
              color: Colors.white,
              icon: Icon(
                ended
                    ? Icons.replay_rounded
                    : value.isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
              ),
            ),
          ),
        if (player != null && value!.isInitialized)
          Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Text(_formatDuration(position),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                  Expanded(
                    child: Slider(
                      key: const ValueKey('media-viewer-video-progress'),
                      min: 0,
                      max: duration.inMilliseconds
                          .toDouble()
                          .clamp(1, double.infinity),
                      value: position.inMilliseconds.toDouble().clamp(
                            0,
                            duration.inMilliseconds
                                .toDouble()
                                .clamp(1, double.infinity),
                          ),
                      onChangeStart: (_) {
                        _scrubbing = true;
                        _controlsTimer?.cancel();
                      },
                      onChanged: (next) => unawaited(
                        _observePlayback(
                            _diagnostic,
                            () => player
                                .seekTo(Duration(milliseconds: next.round()))),
                      ),
                      onChangeEnd: (_) {
                        _scrubbing = false;
                        _scheduleControlsHide();
                      },
                    ),
                  ),
                  Text(_formatDuration(duration),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _formatDuration(Duration value) =>
      '${value.inMinutes}:${value.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}
