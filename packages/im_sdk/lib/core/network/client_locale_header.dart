import 'dart:ui' show Locale;

import 'package:dio/dio.dart';

/// Projects the host's resolved display language into first-party IM requests.
class ClientLocaleHeader extends Interceptor {
  const ClientLocaleHeader(this._locale);

  static const _header = 'X-Client-Locale';
  static const _displayLocale = 'imSdkDisplayLocale';
  final Locale Function() _locale;

  String get _tag => switch (_locale().toLanguageTag()) {
        'en' => 'en-US',
        'vi' => 'vi-VN',
        final tag => tag,
      };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers
        .removeWhere((name, _) => name.toLowerCase() == 'x-client-locale');
    options.extra.remove(_displayLocale);
    final base = Uri.tryParse(options.baseUrl);
    final destination = options.uri;
    final prefix = base?.path.replaceFirst(RegExp(r'/+$'), '');
    if (base != null &&
        (base.scheme == 'https' || base.scheme == 'http') &&
        base.host.isNotEmpty &&
        destination.userInfo.isEmpty &&
        destination.scheme == base.scheme &&
        destination.host == base.host &&
        destination.port == base.port &&
        destination.path.startsWith('$prefix/api/')) {
      final tag = _tag;
      options.headers[_header] = tag;
      // Redirected requests must be classified against their own origin.
      options.followRedirects = false;
      final path = destination.path.substring(prefix!.length);
      if (options.method == 'GET' && _isDisplaySnapshot(path)) {
        options.extra[_displayLocale] = tag;
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final request = response.requestOptions;
    final requested = request.extra[_displayLocale];
    if (requested != null && requested != _tag) {
      handler.reject(DioException(
        requestOptions: request,
        type: DioExceptionType.cancel,
        error: StateError('Host language changed while loading display data'),
      ));
    } else {
      handler.next(response);
    }
  }

  bool _isDisplaySnapshot(String path) {
    const prefix = '/api/client/v1/';
    if (!path.startsWith(prefix)) return false;
    final segments = path.substring(prefix.length).split('/');
    return switch (segments) {
      ['friends'] ||
      ['tenant', 'members'] ||
      ['profile', 'me'] ||
      ['users', _, 'profile'] ||
      ['search', 'users'] ||
      ['groups', _] ||
      ['groups', _, 'members'] ||
      ['conversations'] ||
      ['conversations', _] ||
      ['official-account'] ||
      ['official-account', 'menu'] =>
        true,
      _ => false,
    };
  }
}
