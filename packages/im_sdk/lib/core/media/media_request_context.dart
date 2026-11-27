/// Request metadata only. Message snapshots and downloaded files retain their
/// existing account-scoped owners; these headers never leave the transport.
class MediaRequestContext {
  final String conversationId;
  final String messageId;
  final int conversationSeq;
  final String kind;
  final bool download;
  final String variant;
  final String? fallbackUrl;

  const MediaRequestContext({
    required this.conversationId,
    required this.messageId,
    required this.conversationSeq,
    required this.kind,
    this.download = false,
    this.variant = 'source',
    this.fallbackUrl,
  });

  Map<String, String> get headers => {
        'x-app-media-conversation': conversationId,
        'x-app-media-message': messageId,
        'x-app-media-seq': '$conversationSeq',
        'x-app-media-kind': kind,
        'x-app-media-download': '$download',
        'x-app-media-variant': variant,
        if (fallbackUrl != null) 'x-app-media-fallback': fallbackUrl!,
      };

  static MediaRequestContext? fromHeaders(Map<String, String>? headers) {
    if (headers == null) return null;
    final conversation = headers['x-app-media-conversation'];
    final message = headers['x-app-media-message'];
    final seq = int.tryParse(headers['x-app-media-seq'] ?? '');
    final kind = headers['x-app-media-kind'];
    if (conversation == null ||
        message == null ||
        seq == null ||
        kind == null) {
      return null;
    }
    return MediaRequestContext(
      conversationId: conversation,
      messageId: message,
      conversationSeq: seq,
      kind: kind,
      download: headers['x-app-media-download'] == 'true',
      variant: headers['x-app-media-variant'] ?? 'source',
      fallbackUrl: headers['x-app-media-fallback'],
    );
  }
}

typedef MediaUrlRefresh = Future<String?> Function(
    MediaRequestContext context, String failedUrl);

/// The message owner rejected access. A media transport must not bypass this
/// decision using a previously issued link or an authenticated raw URL.
class MediaAccessDenied implements Exception {
  const MediaAccessDenied();
}
