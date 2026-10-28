import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';

/// Uses the existing immutable runtime identity; never the currently selected
/// account at error time, nor a cache namespace as an identity substitute.
final mediaDiagnosticScopeProvider = Provider<DiagnosticScope>((ref) {
  final storage = ref.watch(accountStorageContextProvider);
  return storage == null
      ? DiagnosticScope.unattributed
      : DiagnosticScope.account(storage.scope);
}, dependencies: [accountStorageContextProvider]);

enum DiagnosticMediaKind { image, video, audio, file }

enum MediaFailureStage { load, download, decode, initialize, playback }

/// Passive telemetry only. Owns no credentials, cache, retry or player state.
class MediaDiagnosticOperation {
  MediaDiagnosticOperation({
    required this.scope,
    required this.kind,
    required String resource,
    String? messageId,
  })  : resourceHash = sha256.convert(utf8.encode(resource)).toString(),
        messageHash = messageId == null
            ? null
            : sha256.convert(utf8.encode(messageId)).toString(),
        traceId = AppDiagnostics.instance.nextTraceId('media');

  final DiagnosticScope scope;
  final DiagnosticMediaKind kind;
  final String resourceHash;
  final String? messageHash;
  final String traceId;
  final Set<MediaFailureStage> _reported = {};

  void failed(MediaFailureStage stage, Object error, [StackTrace? stack]) =>
      _failed(stage, error, stack);

  void imageFailed(Object error, [StackTrace? stack]) => failed(
      error is DioException
          ? MediaFailureStage.download
          : MediaFailureStage.decode,
      error,
      stack);

  void _failed(MediaFailureStage stage, Object error, StackTrace? stack,
      {int? nativeCode}) {
    if (error is AccountOperationSuperseded ||
        (error is DioException && error.type == DioExceptionType.cancel) ||
        !_reported.add(stage)) {
      return;
    }
    final category = '${kind.name}.${stage.name}.failed';
    AppDiagnostics.instance.record(
      AppDiagnosticLevel.warning,
      category,
      category,
      scope: scope,
      traceId: traceId,
      context: {
        'source': kind.name,
        'stage': stage.name,
        'resourceHash': resourceHash,
        if (messageHash != null) 'messageHash': messageHash,
        'errorType': error.runtimeType.toString(),
        if (nativeCode != null) 'code': nativeCode.toString(),
        if (error is DioException) ...{
          'statusCode': error.response?.statusCode,
          'networkErrorType': error.type.name,
        },
        // Plugin descriptions/details may contain URLs, paths and credentials.
        // Only a small known code vocabulary is retained, never arbitrary text.
        if (error is PlatformException &&
            (_safeCodes.contains(error.code) ||
                int.tryParse(error.code) != null))
          'code': error.code,
        if (stack != null) 'stack': stack.toString(),
      },
    );
  }

  void failedNative(MediaFailureStage stage, Object error, StackTrace stack,
      {int? nativeCode}) {
    // The integer is safe; descriptions and arbitrary plugin details are not.
    _failed(stage, error, stack, nativeCode: nativeCode);
  }

  Future<T> observe<T>(
      MediaFailureStage stage, Future<T> Function() action) async {
    try {
      return await action();
    } catch (error, stack) {
      failed(stage, error, stack);
      rethrow;
    }
  }

  static const _safeCodes = {
    'VideoError',
    'video_error',
    'decode_error',
    'source_error',
    'network_error',
    'MEDIA_ERR_DECODE',
    'MEDIA_ERR_SRC_NOT_SUPPORTED',
  };
}
