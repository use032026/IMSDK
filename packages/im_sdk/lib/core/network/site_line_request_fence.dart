import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';

/// Prevents an old route's response from mutating the newly selected route's
/// account/runtime state. The account scope remains unchanged across lines.
class SiteLineRequestFence extends Interceptor {
  static const _revisionKey = 'siteLineRouteRevision';

  final SiteLineManager manager;
  final String Function() baseUrl;

  SiteLineRequestFence({required this.manager, required this.baseUrl});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.baseUrl = baseUrl();
    options.extra[_revisionKey] = manager.routeRevision;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isStale(response.requestOptions)) {
      handler.reject(_cancelled(response.requestOptions));
    } else {
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isStale(err.requestOptions)) {
      handler.reject(_cancelled(err.requestOptions));
    } else {
      handler.next(err);
    }
  }

  bool _isStale(RequestOptions options) =>
      options.extra[_revisionKey] != manager.routeRevision;

  DioException _cancelled(RequestOptions options) => DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
        error: StateError('Site line changed while request was in flight'),
      );
}
