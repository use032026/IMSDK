import 'dart:convert';
import 'dart:async';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/diagnostics/media_diagnostics.dart';
import 'package:im_sdk/core/media/image_file_service.dart';
import 'package:im_sdk/core/network/chat_media_url.dart';
import 'package:im_sdk/core/network/http_client.dart';
import 'package:im_sdk/core/platform/local_file.dart';

export 'package:just_audio/just_audio.dart' show PlayerState, ProcessingState;

bool isVoicePlaybackCompleted(PlayerState state) =>
    state.processingState == ProcessingState.completed;

// ---------------------------------------------------------------------------
// AudioPlayerService — 单例播放器，保证同一时刻只有一条语音在播放
// ---------------------------------------------------------------------------

class AudioPlayerService {
  final Dio? _dio;
  final Dio _unauthenticatedDio;
  final bool _ownsUnauthenticatedDio;
  final String Function() _apiBaseUrl;
  final AudioPlayer _player;
  final DiagnosticScope diagnosticScope;
  late final StreamSubscription<PlaybackEvent> _diagnosticSubscription;
  MediaDiagnosticOperation? _diagnostic;
  MediaFailureStage _diagnosticStage = MediaFailureStage.load;
  int _playbackRequestVersion = 0;
  bool _disposed = false;

  AudioPlayerService(
      {Dio? dio,
      Dio? unauthenticatedDio,
      String Function()? apiBaseUrl,
      AudioPlayer? player,
      this.diagnosticScope = DiagnosticScope.unattributed})
      : _player = player ?? AudioPlayer(),
        _dio = dio,
        _unauthenticatedDio = unauthenticatedDio ?? Dio(),
        _ownsUnauthenticatedDio = unauthenticatedDio == null,
        _apiBaseUrl = apiBaseUrl ?? (() => HttpClient.baseUrl) {
    _diagnosticSubscription = _player.playbackEventStream.listen((_) {},
        onError: (Object error, StackTrace stack) {
      _recordFailure(_diagnostic, _diagnosticStage, error, stack);
    });
  }

  void _recordFailure(MediaDiagnosticOperation? diagnostic,
      MediaFailureStage stage, Object error, StackTrace stack) {
    if (error is PlayerInterruptedException) return;
    diagnostic?.failedNative(stage, error, stack,
        nativeCode: error is PlayerException ? error.code : null);
  }

  /// 当前正在播放的消息 ID
  String? currentlyPlayingId;

  bool get isPlaying => _player.playing;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;

  /// 播放指定消息的语音
  /// 若当前有其他消息在播放，先停止再播放新的
  int beginPlaybackRequest() => ++_playbackRequestVersion;

  bool isCurrentPlaybackRequest(int requestVersion) =>
      requestVersion == _playbackRequestVersion;

  Future<void> play(
    String messageId,
    String url, {
    String? token,
    int? requestVersion,
  }) async {
    final effectiveRequestVersion = requestVersion ?? beginPlaybackRequest();
    if (!isCurrentPlaybackRequest(effectiveRequestVersion)) return;
    if (currentlyPlayingId == messageId && _player.playing) return;

    final diagnostic = MediaDiagnosticOperation(
        scope: diagnosticScope,
        kind: DiagnosticMediaKind.audio,
        resource: url,
        messageId: messageId);
    // 停止当前播放；失败仅记录，原异常和播放顺序保持不变。
    try {
      await stop();
    } catch (error, stack) {
      _recordFailure(diagnostic, MediaFailureStage.playback, error, stack);
      rethrow;
    }
    _diagnostic = diagnostic;
    var stage = MediaFailureStage.load;
    _diagnosticStage = stage;
    try {
      final source = await _buildAudioSource(url, diagnostic: diagnostic);
      if (!isCurrentPlaybackRequest(effectiveRequestVersion)) return;
      stage = MediaFailureStage.initialize;
      _diagnosticStage = stage;
      await _player.setAudioSource(source);
      if (!isCurrentPlaybackRequest(effectiveRequestVersion)) return;
      currentlyPlayingId = messageId;
      stage = MediaFailureStage.playback;
      _diagnosticStage = stage;
      await _player.play();
    } catch (error, stack) {
      _recordFailure(diagnostic, stage, error, stack);
      currentlyPlayingId = null;
      rethrow;
    }
  }

  Future<void> pause() async {
    await _observePlayback(() => _player.pause());
  }

  Future<void> stop() async {
    await _observePlayback(() => _player.stop());
    _diagnostic = null;
    currentlyPlayingId = null;
  }

  Future<void> _observePlayback(Future<void> Function() action) async {
    final diagnostic = _diagnostic;
    try {
      await action();
    } catch (error, stack) {
      _recordFailure(diagnostic, MediaFailureStage.playback, error, stack);
      rethrow;
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    await _diagnosticSubscription.cancel();
    await _player.dispose();
    if (_ownsUnauthenticatedDio) _unauthenticatedDio.close(force: true);
  }

  Future<AudioSource> _buildAudioSource(String rawUrl,
      {required MediaDiagnosticOperation diagnostic}) async {
    final url = rawUrl.trim();
    if (url.isEmpty) throw ArgumentError('Voice url is empty');

    final filePath = _localFilePath(url);
    if (filePath != null && await localFileExists(filePath)) {
      return AudioSource.file(filePath);
    }

    final uri = ChatMediaRequest.resolve(url, _apiBaseUrl()).uri;
    final downloaded = await diagnostic.observe(
        MediaFailureStage.download, () => _downloadRemoteVoice(uri));
    if (downloaded != null) {
      return downloaded;
    }

    // Without an account transport there is no credential owner. The native
    // fallback remains anonymous, including any redirects it may follow.
    return AudioSource.uri(uri);
  }

  Future<AudioSource?> _downloadRemoteVoice(Uri uri) async {
    final dio = _dio;
    if (dio == null) return null;

    final response = await ImageDownloadTransport(
      accountDio: dio,
      publicDio: _unauthenticatedDio,
      apiBaseUrl: _apiBaseUrl,
      isCurrent: () => !_disposed,
      namespace: 'voice',
      diagnosticScope: diagnosticScope,
      kind: DiagnosticMediaKind.audio,
    ).get(uri.toString());
    final bytes = await response.content
        .fold<List<int>>([], (buffer, chunk) => buffer..addAll(chunk));
    if (bytes.isEmpty) throw StateError('Voice response is empty');
    final contentType = switch (response.fileExtension.toLowerCase()) {
      '.mp3' => 'audio/mpeg',
      '.aac' => 'audio/aac',
      '.ogg' || '.oga' || '.opus' => 'audio/ogg',
      '.wav' => 'audio/wav',
      _ => 'audio/mp4',
    };
    try {
      final path = await cacheBytesToLocalFile(
        bytes: bytes,
        directoryName: 'lpp_voice',
        fileName: _cacheFileName(uri, contentType),
      );
      return AudioSource.file(path);
    } on UnsupportedError {
      return _DownloadedAudioSource(bytes, contentType);
    }
  }

  String _cacheFileName(Uri uri, String? contentType) {
    final digest = sha1.convert(utf8.encode(uri.toString())).toString();
    final ext =
        _extensionFromUri(uri) ?? _extensionFromContentType(contentType);
    return '$digest${ext ?? '.m4a'}';
  }

  String? _extensionFromUri(Uri uri) {
    final lastSegment = uri.pathSegments.isEmpty ? '' : uri.pathSegments.last;
    final dot = lastSegment.lastIndexOf('.');
    if (dot <= 0 || dot == lastSegment.length - 1) return null;
    final ext = lastSegment.substring(dot).toLowerCase();
    if (ext.length > 8) return null;
    return ext;
  }

  String? _extensionFromContentType(String? contentType) {
    final type = contentType?.toLowerCase() ?? '';
    if (type.contains('mp4') || type.contains('m4a')) return '.m4a';
    if (type.contains('aac')) return '.aac';
    if (type.contains('mpeg')) return '.mp3';
    if (type.contains('ogg')) return '.ogg';
    if (type.contains('wav')) return '.wav';
    return null;
  }

  String? _localFilePath(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.scheme == 'file') {
      return uri.toFilePath();
    }
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return null;
    }
    if (url.startsWith('/api/') ||
        url.startsWith('/media/') ||
        url.startsWith('/uploads/') ||
        url.startsWith('/files/')) {
      return null;
    }
    return url;
  }
}

// just_audio's byte source keeps network access in the credential transport
// when a platform has no local file runtime.
// ignore: experimental_member_use
class _DownloadedAudioSource extends StreamAudioSource {
  _DownloadedAudioSource(this.bytes, this.contentType);
  final List<int> bytes;
  final String contentType;

  @override
  // ignore: experimental_member_use
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final offset = start ?? 0;
    final limit = end ?? bytes.length;
    // ignore: experimental_member_use
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: limit - offset,
      offset: offset,
      stream: Stream.value(bytes.sublist(offset, limit)),
      contentType: contentType,
    );
  }
}

bool isSameOriginMediaUri(Uri mediaUri, Uri apiBaseUri) =>
    mediaUri.scheme == apiBaseUri.scheme &&
    mediaUri.host == apiBaseUri.host &&
    mediaUri.port == apiBaseUri.port;

// ---------------------------------------------------------------------------
// Provider — 全局单例，跨 widget 共享播放状态
// ---------------------------------------------------------------------------

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService(
      dio: ref.watch(dioProvider),
      diagnosticScope: ref.watch(mediaDiagnosticScopeProvider));
  ref.onDispose(service.dispose);
  return service;
}, dependencies: [dioProvider, mediaDiagnosticScopeProvider]);
