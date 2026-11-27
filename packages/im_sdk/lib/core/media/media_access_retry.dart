import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/media/media_request_context.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';

/// Bound by the authenticated app composition root, never by a widget build.
final mediaUrlRefreshProvider = Provider<MediaUrlRefresh?>((ref) => null);

/// One refresh and one trusted-route fallback per load, without a second cache
/// or a timer. The transport remains responsible for URL/credential policy.
class MediaAccessRetry {
  const MediaAccessRetry({this.refresh, this.isCurrent});
  final MediaUrlRefresh? refresh;
  final bool Function()? isCurrent;

  Future<T> run<T>({
    required String url,
    required Future<T> Function(String url) load,
    MediaRequestContext? context,
    bool Function(String url)? canFallback,
  }) async {
    var current = url;
    var refreshed = false;
    Object? refreshError;
    StackTrace? refreshStack;

    Future<void> renew() async {
      refreshed = true;
      try {
        final next = await refresh!(context!, current);
        _verifyCurrent();
        if (next != null && next.trim().isNotEmpty) current = next;
      } on AccountOperationSuperseded {
        rethrow;
      } on MediaAccessDenied {
        rethrow;
      } catch (error, stack) {
        refreshError = error;
        refreshStack = stack;
      }
    }

    _verifyCurrent();
    if (context != null && refresh != null && _expired(current)) await renew();
    try {
      final result = await load(current);
      _verifyCurrent();
      return result;
    } on DioException catch (error) {
      if (!_accessFailure(error)) rethrow;
      if (!refreshed && context != null && refresh != null) {
        await renew();
        try {
          final result = await load(current);
          _verifyCurrent();
          return result;
        } on DioException catch (retryError) {
          if (!_accessFailure(retryError)) rethrow;
        }
      }
      final fallback = context?.fallbackUrl;
      if (fallback != null &&
          fallback != current &&
          canFallback?.call(fallback) == true) {
        _verifyCurrent();
        final result = await load(fallback);
        _verifyCurrent();
        return result;
      }
      if (refreshError != null) {
        Error.throwWithStackTrace(refreshError!, refreshStack!);
      }
      rethrow;
    }
  }

  void _verifyCurrent() {
    if (isCurrent?.call() == false) throw AccountOperationSuperseded();
  }

  bool _accessFailure(DioException error) =>
      const [401, 403, 404].contains(error.response?.statusCode);

  bool _expired(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.queryParameters.containsKey('sig')) return false;
    final exp = int.tryParse(uri.queryParameters['exp'] ?? '');
    if (exp == null) return false;
    return exp <= DateTime.now().millisecondsSinceEpoch ~/ 1000 + 5;
  }
}
