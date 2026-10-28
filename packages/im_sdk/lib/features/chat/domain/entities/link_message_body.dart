enum LinkPreviewStatus {
  pending,
  ready,
  failed,
  blocked,
}

class LinkMessageBody {
  static const schema = 1;
  static const maxTitleLength = 120;
  static const maxDescriptionLength = 240;

  final int schemaVersion;
  final String url;
  final String? title;
  final String? description;
  final String? siteName;
  final String? faviconUrl;
  final String? imageUrl;
  final LinkPreviewStatus previewStatus;
  final int previewVersion;

  const LinkMessageBody({
    this.schemaVersion = schema,
    required this.url,
    this.title,
    this.description,
    this.siteName,
    this.faviconUrl,
    this.imageUrl,
    this.previewStatus = LinkPreviewStatus.pending,
    this.previewVersion = 0,
  });

  factory LinkMessageBody.fromJson(Map<String, dynamic> json) {
    return LinkMessageBody(
      url: _text(json['url']) ?? '',
      title: _bounded(json['title'], maxTitleLength),
      description: _bounded(json['description'], maxDescriptionLength),
      siteName: _bounded(json['siteName'] ?? json['site_name'], 80),
      faviconUrl: _safeAssetUrl(json['faviconUrl'] ?? json['favicon_url']),
      imageUrl: _safeAssetUrl(json['imageUrl'] ?? json['image_url']),
      previewStatus:
          _previewStatus(json['previewStatus'] ?? json['preview_status']),
      previewVersion:
          _nonNegativeInt(json['previewVersion'] ?? json['preview_version']),
    );
  }

  static LinkMessageBody? tryFromJson(Map<String, dynamic> json) {
    final body = LinkMessageBody.fromJson(json);
    return tryParseUrl(body.url) == null ? null : body;
  }

  static Uri? tryParseUrl(String input) {
    final uri = Uri.tryParse(input.trim());
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      return null;
    }
    return uri;
  }

  factory LinkMessageBody.fallback(Uri uri) {
    return LinkMessageBody(url: uri.toString(), siteName: uri.host);
  }

  String get displayTitle =>
      title?.trim().isNotEmpty == true ? title!.trim() : siteName ?? url;

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'url': url,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (siteName != null) 'siteName': siteName,
      if (faviconUrl != null) 'faviconUrl': faviconUrl,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'previewStatus': previewStatus.name,
      'previewVersion': previewVersion,
    };
  }

  static String? _bounded(Object? value, int maxLength) {
    final text = _text(value);
    if (text == null) return null;
    return text.length <= maxLength ? text : text.substring(0, maxLength);
  }

  static String? _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  static String? _safeAssetUrl(Object? value) {
    final normalized = _text(value);
    if (normalized == null) return null;
    final uri = Uri.tryParse(normalized);
    if (uri == null || uri.userInfo.isNotEmpty) return null;
    if (!uri.hasScheme && normalized.startsWith('/')) return normalized;
    if ((uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty) {
      return uri.toString();
    }
    return null;
  }

  static LinkPreviewStatus _previewStatus(Object? value) {
    return switch (_text(value)?.toLowerCase()) {
      'ready' => LinkPreviewStatus.ready,
      'failed' => LinkPreviewStatus.failed,
      'blocked' => LinkPreviewStatus.blocked,
      _ => LinkPreviewStatus.pending,
    };
  }

  static int _nonNegativeInt(Object? value) {
    final parsed = value is int ? value : int.tryParse(value?.toString() ?? '');
    return parsed != null && parsed > 0 ? parsed : 0;
  }
}
