import 'package:im_sdk/core/network/service_realm_config.dart';
import 'package:im_sdk/core/network/site_line_manager.dart'
    show kPrimarySiteBaseUrl;

bool hasChatMediaSignature(Uri uri) => const ['tenantId', 'exp', 'sig']
    .every((key) => uri.queryParameters[key]?.trim().isNotEmpty == true);

/// Keeps signed and external resources anonymous. Only known chat media paths
/// may move from the configured primary origin to the selected account route.
class ChatMediaRequest {
  const ChatMediaRequest._(this.uri, this.accountPath, this.isSigned);

  factory ChatMediaRequest.resolve(String rawUrl, String apiBaseUrl,
      {String officialBaseUrl = kPrimarySiteBaseUrl}) {
    final base = Uri.parse(apiBaseUrl);
    final candidate = Uri.parse(rawUrl.trim());
    final uri = _resolve(candidate, base);
    final signed = hasChatMediaSignature(uri);
    if (signed || !_isHttp(uri)) {
      return ChatMediaRequest._(uri, null, signed);
    }

    final path = _pathWithinBase(uri, base) ??
        (ServiceRealmConfig.current.trusts(officialBaseUrl)
            ? _pathWithinBase(uri, Uri.parse(officialBaseUrl))
            : null);
    if (path == null || !_isMediaPath(path)) {
      return ChatMediaRequest._(uri, null, false);
    }
    final route = base.replace(
      path: '${base.path.replaceFirst(RegExp(r'/+$'), '')}$path',
      query: uri.hasQuery ? uri.query : null,
      fragment: uri.hasFragment ? uri.fragment : null,
    );
    final accountPath = '$path${uri.hasQuery ? '?${uri.query}' : ''}';
    return ChatMediaRequest._(route, accountPath, false);
  }

  final Uri uri;
  final String? accountPath;
  final bool isSigned;

  String get url => uri.toString();

  static bool _isHttp(Uri uri) =>
      (uri.scheme == 'https' || uri.scheme == 'http') &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty;

  static Uri _resolve(Uri candidate, Uri base) {
    if (candidate.hasScheme || candidate.hasAuthority) {
      return base.resolveUri(candidate);
    }
    final rooted = base.resolveUri(candidate);
    if (_pathWithinBase(rooted, base) != null &&
        base.path.replaceAll('/', '').isNotEmpty) {
      return rooted;
    }
    final directory =
        base.replace(path: '${base.path.replaceFirst(RegExp(r'/+$'), '')}/');
    final raw = candidate.toString();
    return directory.resolve(raw.startsWith('/') ? raw.substring(1) : raw);
  }

  static String? _pathWithinBase(Uri uri, Uri base) {
    if (!_isHttp(uri) ||
        !_isHttp(base) ||
        uri.scheme != base.scheme ||
        uri.host != base.host ||
        uri.port != base.port) {
      return null;
    }
    final prefix = base.path.replaceFirst(RegExp(r'/+$'), '');
    if (prefix.isEmpty) return uri.path;
    if (uri.path == prefix) return '/';
    return uri.path.startsWith('$prefix/')
        ? uri.path.substring(prefix.length)
        : null;
  }

  static bool _isMediaPath(String path) {
    final segments = Uri.parse(path).pathSegments;
    if (segments.any((segment) =>
        segment == '.' ||
        segment == '..' ||
        segment.contains('/') ||
        segment.contains('\\'))) {
      return false;
    }
    return (path.startsWith('/media/') && path.length > '/media/'.length) ||
        (path.startsWith('/api/client/v1/media/') &&
            path.length > '/api/client/v1/media/'.length);
  }
}
