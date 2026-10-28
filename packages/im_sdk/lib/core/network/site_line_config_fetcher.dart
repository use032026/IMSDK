import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/network/site_line_config.dart';

typedef SiteLineConfigLoader = Future<VerifiedSiteLineConfig> Function(
  String url,
  Duration timeout,
);

class SiteLineSourceResult {
  final String url;
  final VerifiedSiteLineConfig config;
  const SiteLineSourceResult(this.url, this.config);
}

/// Unauthenticated, bounded config transport. Business Dio/token interceptors
/// must never be used for site-line configuration requests.
class SiteLineConfigFetcher {
  static const maxResponseBytes = 512 * 1024;
  static const _delays = <Duration>[
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(milliseconds: 500),
    Duration(milliseconds: 750),
    Duration(milliseconds: 1500),
    Duration(milliseconds: 2500),
    Duration(seconds: 4),
    Duration(seconds: 6),
  ];

  final SiteLineConfigCodec codec;
  final SiteLineConfigLoader? loader;
  final Dio Function(BaseOptions options)? dioFactory;

  const SiteLineConfigFetcher({
    required this.codec,
    this.loader,
    this.dioFactory,
  });

  Future<VerifiedSiteLineConfig> fetch(
    String url, {
    Duration timeout = const Duration(seconds: 8),
    CancelToken? cancelToken,
  }) async {
    if (!isPublicHttpsConfigUrl(url)) {
      throw const SiteLineConfigException('invalid_url');
    }
    if (loader != null) return loader!(url, timeout);

    final diagnostics = AppDiagnostics.instance;
    final traceId = diagnostics.nextTraceId('site-line-fetch');
    final diagnosticUrl = url.split(RegExp(r'[?#]')).first;
    final watch = Stopwatch()..start();
    var phase = 'response_headers';
    var phaseStartedMs = 0;
    void logStage(
      String stage, {
      AppDiagnosticLevel level = AppDiagnosticLevel.info,
      Map<String, Object?> details = const {},
    }) {
      diagnostics.record(
        level,
        'site_line.config_fetch',
        'Site line configfile fetch $stage',
        context: {
          'traceId': traceId,
          'url': diagnosticUrl,
          'stage': stage,
          'phase': phase,
          'totalElapsedMs': watch.elapsedMilliseconds,
          ...details,
        },
      );
    }

    final options = BaseOptions(
      connectTimeout: timeout,
      receiveTimeout: timeout,
      followRedirects: false,
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    );
    final dio = dioFactory?.call(options) ?? Dio(options);
    final token = cancelToken ?? CancelToken();
    var requestDeadlineExpired = false;
    logStage('started', details: {'timeoutMs': timeout.inMilliseconds});
    try {
      final response = await dio
          .get<ResponseBody>(
        url,
        cancelToken: token,
        options: Options(
          responseType: ResponseType.stream,
          headers: const {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        ),
      )
          .timeout(timeout, onTimeout: () {
        requestDeadlineExpired = true;
        token.cancel('timeout');
        throw const SiteLineConfigException('timeout');
      });
      final declaredLength = int.tryParse(
        response.headers.value(Headers.contentLengthHeader) ?? '',
      );
      logStage('headers_received', details: {
        'phaseElapsedMs': watch.elapsedMilliseconds - phaseStartedMs,
        'statusCode': response.statusCode,
        if (declaredLength != null) 'contentLength': declaredLength,
      });
      if (declaredLength != null && declaredLength > maxResponseBytes) {
        token.cancel('content_too_large');
        throw const SiteLineConfigException('content_too_large');
      }
      phase = 'response_body';
      phaseStartedMs = watch.elapsedMilliseconds;
      final body = <int>[];
      final stream = response.data?.stream;
      if (stream == null) throw const SiteLineConfigException('network');
      await for (final chunk in stream.timeout(timeout)) {
        if (body.length + chunk.length > maxResponseBytes) {
          token.cancel('content_too_large');
          throw const SiteLineConfigException('content_too_large');
        }
        body.addAll(chunk);
      }
      logStage('body_received', details: {
        'phaseElapsedMs': watch.elapsedMilliseconds - phaseStartedMs,
        'bytesRead': body.length,
      });
      phase = 'decode';
      phaseStartedMs = watch.elapsedMilliseconds;
      final config = codec.decode(utf8.decode(body));
      logStage('completed', details: {
        'phaseElapsedMs': watch.elapsedMilliseconds - phaseStartedMs,
        'version': config.version,
      });
      return config;
    } on SiteLineConfigException catch (error) {
      logStage('failed', level: AppDiagnosticLevel.warning, details: {
        'phaseElapsedMs': watch.elapsedMilliseconds - phaseStartedMs,
        'reason': error.code,
        'exceptionType': error.runtimeType.toString(),
        if (requestDeadlineExpired) 'timeoutSource': 'request_deadline',
      });
      rethrow;
    } on TimeoutException catch (error) {
      logStage('failed', level: AppDiagnosticLevel.warning, details: {
        'phaseElapsedMs': watch.elapsedMilliseconds - phaseStartedMs,
        'reason': 'timeout',
        'exceptionType': error.runtimeType.toString(),
        'timeoutSource': 'response_body_idle',
      });
      throw const SiteLineConfigException('timeout');
    } on DioException catch (error) {
      final socketError = error.error;
      final timeoutSource = switch (error.type) {
        DioExceptionType.connectionTimeout => 'connect',
        DioExceptionType.sendTimeout => 'request_write',
        DioExceptionType.receiveTimeout =>
          phase == 'response_body' ? 'response_body_idle' : 'response_headers',
        _ => null,
      };
      logStage('failed', level: AppDiagnosticLevel.warning, details: {
        'phaseElapsedMs': watch.elapsedMilliseconds - phaseStartedMs,
        'reason': timeoutSource != null
            ? 'timeout'
            : error.response?.statusCode == null
                ? 'network'
                : 'http_status',
        'exceptionType': error.runtimeType.toString(),
        'dioExceptionType': error.type.name,
        if (timeoutSource != null) 'timeoutSource': timeoutSource,
        if (socketError != null)
          'underlyingErrorType': socketError.runtimeType.toString(),
        if (socketError is SocketException && socketError.osError != null)
          'osErrorCode': socketError.osError!.errorCode,
        if (error.response?.statusCode != null)
          'statusCode': error.response!.statusCode,
      });
      if (timeoutSource != null) {
        throw const SiteLineConfigException('timeout');
      }
      if (error.response?.statusCode != null) {
        throw const SiteLineConfigException('http_status');
      }
      throw const SiteLineConfigException('network');
    } catch (error) {
      logStage('failed', level: AppDiagnosticLevel.warning, details: {
        'phaseElapsedMs': watch.elapsedMilliseconds - phaseStartedMs,
        'reason': 'network',
        'exceptionType': error.runtimeType.toString(),
      });
      throw const SiteLineConfigException('network');
    } finally {
      dio.close(force: true);
    }
  }

  Future<SiteLineSourceResult?> race(
    List<String> urls, {
    int? minimumVersion,
  }) async {
    final candidates = <String>[];
    for (final url in urls) {
      if (candidates.length >= _delays.length) break;
      if (!candidates.contains(url)) candidates.add(url);
    }
    if (candidates.isEmpty) return null;
    final winner = Completer<SiteLineSourceResult?>();
    final tokens = List.generate(candidates.length, (_) => CancelToken());
    var pending = candidates.length;
    for (var index = 0; index < candidates.length; index++) {
      final url = candidates[index];
      final delay = _delays[index];
      unawaited(() async {
        try {
          if (delay > Duration.zero) await Future<void>.delayed(delay);
          if (winner.isCompleted || tokens[index].isCancelled) return;
          final config = await fetch(url, cancelToken: tokens[index]);
          if (minimumVersion != null &&
              (config.version == null || config.version! < minimumVersion)) {
            throw const SiteLineConfigException('stale_version');
          }
          if (!winner.isCompleted) {
            winner.complete(SiteLineSourceResult(url, config));
            for (var other = 0; other < tokens.length; other++) {
              if (other != index) {
                tokens[other].cancel('another_source_verified');
              }
            }
          }
        } catch (_) {
          // A source failure is isolated; another signed source may win.
        } finally {
          pending -= 1;
          if (pending == 0 && !winner.isCompleted) {
            winner.complete(null);
          }
        }
      }());
    }
    return winner.future;
  }

  static bool isPublicHttpsConfigUrl(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null ||
        uri.scheme != 'https' ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      return false;
    }
    final host = uri.host.toLowerCase();
    if (host == 'localhost' || host.endsWith('.localhost')) return false;
    final address = InternetAddress.tryParse(host);
    if (address == null) return true;
    if (address.isLoopback || address.isLinkLocal) return false;
    final bytes = address.rawAddress;
    if (address.type == InternetAddressType.IPv4) {
      final first = bytes[0], second = bytes[1];
      return !(first == 0 ||
          first == 10 ||
          first == 127 ||
          (first == 100 && second >= 64 && second <= 127) ||
          (first == 172 && second >= 16 && second <= 31) ||
          (first == 192 && second == 168) ||
          first >= 224);
    }
    if (bytes[0] & 0xfe == 0xfc) return false;
    if (bytes[0] == 0xfe && bytes[1] & 0xc0 == 0x80) return false;
    return true;
  }
}
