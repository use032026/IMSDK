import 'package:im_sdk/core/network/trusted_media_url.dart';

enum ImageRequestAccess { public, client, platform, admin }

/// URL and credential policy only; no widget or token ownership.
class ImageResource {
  ImageResource(String raw, String apiBaseUrl, {String? adminBaseUrl})
      : uri = _resolve(raw, apiBaseUrl, adminBaseUrl),
        _apiBaseUrl = apiBaseUrl,
        _adminBaseUrl = adminBaseUrl;

  final Uri uri;
  final String _apiBaseUrl;
  final String? _adminBaseUrl;

  String get url => uri.toString();

  ImageRequestAccess get access {
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw ArgumentError('Unsupported network image scheme');
    }
    if (uri.userInfo.isNotEmpty) {
      throw ArgumentError('Network image URL cannot contain credentials');
    }
    final clientPath = _pathWithinBase(uri, _apiBaseUrl);
    final adminPath =
        _adminBaseUrl == null ? null : _pathWithinBase(uri, _adminBaseUrl);
    final useAdminBase = adminPath != null &&
        (clientPath == null ||
            Uri.parse(_adminBaseUrl!).path.length >
                Uri.parse(_apiBaseUrl).path.length);
    final path = useAdminBase ? adminPath : clientPath;
    if (path == null || path.startsWith('/api/admin/v1/public/')) {
      return ImageRequestAccess.public;
    }
    if (useAdminBase) return ImageRequestAccess.admin;
    if (path.startsWith('/api/platform/v1/')) {
      return ImageRequestAccess.platform;
    }
    if (path.startsWith('/api/admin/v1/')) {
      return ImageRequestAccess.admin;
    }
    return ImageRequestAccess.client;
  }

  // Relative paths let the existing HttpClient select platform/client tokens
  // and keep its route fence and refresh/replay behavior.
  String get requestPath {
    final path = access == ImageRequestAccess.admin && _adminBaseUrl != null
        ? _pathWithinBase(uri, _adminBaseUrl) ??
            _pathWithinBase(uri, _apiBaseUrl)
        : _pathWithinBase(uri, _apiBaseUrl);
    return '${path ?? uri.path}${uri.hasQuery ? '?${uri.query}' : ''}';
  }

  static String? _pathWithinBase(Uri uri, String baseUrl) {
    if (trustedServerMediaUrl(uri.toString(), baseUrl) == null) return null;
    final prefix = Uri.parse(baseUrl).path.replaceFirst(RegExp(r'/+$'), '');
    if (prefix.isEmpty) return uri.path;
    if (uri.path == prefix) return '/';
    return uri.path.startsWith('$prefix/')
        ? uri.path.substring(prefix.length)
        : null;
  }

  static Uri _resolve(String raw, String apiBaseUrl, String? adminBaseUrl) {
    final value = raw.trim();
    final base = Uri.parse(apiBaseUrl);
    final candidate = Uri.parse(value);
    if (candidate.hasScheme || candidate.hasAuthority) {
      return base.resolveUri(candidate);
    }
    if (candidate.path.startsWith('/')) {
      final rooted = base.resolveUri(candidate);
      // URLs already containing a configured proxy prefix are origin-relative.
      for (final endpoint in [
        apiBaseUrl,
        if (adminBaseUrl != null) adminBaseUrl
      ]) {
        if (Uri.parse(endpoint).path.replaceAll('/', '').isNotEmpty &&
            _pathWithinBase(rooted, endpoint) != null) {
          return rooted;
        }
      }
    }
    final endpoint =
        adminBaseUrl != null && candidate.path.startsWith('/api/admin/v1/')
            ? Uri.parse(adminBaseUrl)
            : base;
    final directory = endpoint.replace(
        path: '${endpoint.path.replaceFirst(RegExp(r'/+$'), '')}/');
    return directory
        .resolve(value.startsWith('/') ? value.substring(1) : value);
  }

  static String withRevision(String url, int revision) {
    if (revision <= 0) return url;
    final uri = Uri.parse(url);
    return uri
        .replace(
          query: '${uri.query}${uri.hasQuery ? '&' : ''}_v=$revision',
        )
        .toString();
  }
}
