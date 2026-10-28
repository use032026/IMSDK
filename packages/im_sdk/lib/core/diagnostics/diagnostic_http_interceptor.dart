import 'package:dio/dio.dart';
import 'app_diagnostics.dart';

/// Captures the source before authentication can suspend or replay a request.
class DiagnosticRequestScopeInterceptor extends Interceptor {
  DiagnosticRequestScopeInterceptor(this.scope);
  final DiagnosticScope Function() scope;
  static const scopeKey = 'lppDiagnosticScope';
  static const timerKey = 'lppDiagnosticTimer';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra.putIfAbsent(scopeKey, () {
      final source = scope();
      if (source == DiagnosticScope.public) {
        // A missing account owner must not turn business traffic into public logs.
        const anonymousAuth = {'login', 'register', 'login-by-code'};
        final parts = options.uri.path.split('/');
        if (!parts.contains('auth') || !anonymousAuth.contains(parts.last)) {
          return DiagnosticScope.unattributed;
        }
      }
      return source;
    });
    options.extra[timerKey] = Stopwatch()..start();
    handler.next(options);
  }
}

class DiagnosticHttpInterceptor extends Interceptor {
  DiagnosticHttpInterceptor({this.prefix = 'http'});
  final String prefix;

  Map<String, Object?> _context(RequestOptions options) => {
        'method': options.method,
        'endpoint': options.uri.path,
        'clientTraceId': options.extra['clientTraceId'],
        'elapsedMs': (options.extra[DiagnosticRequestScopeInterceptor.timerKey]
                as Stopwatch?)
            ?.elapsedMilliseconds,
      };
  DiagnosticScope _scope(RequestOptions options) =>
      options.extra[DiagnosticRequestScopeInterceptor.scopeKey]
          as DiagnosticScope? ??
      DiagnosticScope.unattributed;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final reportRevision = options.extra['diagnosticReportRevision'];
    if (reportRevision != null &&
        reportRevision != AppDiagnostics.instance.scopeRevision) {
      handler.reject(DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
      ));
      return;
    }
    if (options.extra['skipDiagnosticsLog'] != true) {
      final existing = options.extra['clientTraceId']?.toString();
      final trace = AppDiagnostics.instance.redactor.identifier(existing) ??
          AppDiagnostics.instance.nextTraceId(prefix);
      options.extra['clientTraceId'] = trace;
      options.headers.putIfAbsent('X-Client-Trace-Id', () => trace);
      AppDiagnostics.instance.debug('$prefix.request', 'HTTP request',
          scope: _scope(options), context: _context(options));
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.extra['skipDiagnosticsLog'] != true) {
      AppDiagnostics.instance.debug('$prefix.response', 'HTTP response',
          scope: _scope(response.requestOptions),
          context: {
            ..._context(response.requestOptions),
            'statusCode': response.statusCode,
            if (response.data is Map) 'requestId': response.data['requestId'],
            if (response.data is Map) 'serverCode': response.data['code'],
          });
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.extra['skipDiagnosticsLog'] != true) {
      final body = err.response?.data;
      final expected = err.response?.statusCode == 403 &&
          body is Map &&
          body['code'] == 'TENANT_MEMBER_LIST_FORBIDDEN';
      AppDiagnostics.instance.record(
          expected ? AppDiagnosticLevel.info : AppDiagnosticLevel.error,
          expected ? '$prefix.notice' : '$prefix.error',
          'HTTP failure',
          scope: _scope(err.requestOptions),
          context: {
            ..._context(err.requestOptions),
            'statusCode': err.response?.statusCode,
            'networkErrorType': err.type.name,
            if (body is Map) 'requestId': body['requestId'],
            if (body is Map) 'serverCode': body['code'],
          });
    }
    handler.next(err);
  }
}
