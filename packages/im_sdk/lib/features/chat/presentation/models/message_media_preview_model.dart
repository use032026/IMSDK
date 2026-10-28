import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui' show Size;

import 'package:im_sdk/core/platform/local_file.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';

class MediaBubbleSize {
  final double width;
  final double height;

  const MediaBubbleSize({
    required this.width,
    required this.height,
  });
}

/// Keeps decoded preview proportions across lazy row rebuilds in one chat.
/// These are visual fallbacks only, never authoritative media dimensions.
class MediaPreviewLayoutCache {
  static const _maxEntries = 128;
  final LinkedHashMap<(String, String), Size> _sizes = LinkedHashMap();
  (String, String)? _scope;

  void useScope(String spaceId, String conversationId) {
    final scope = (spaceId, conversationId);
    if (_scope == scope) return;
    _scope = scope;
    _sizes.clear();
  }

  Size? sizeFor(String messageId, String? source) {
    if (messageId.isEmpty || source == null || source.isEmpty) return null;
    return _sizes[(messageId, source)];
  }

  void remember(String messageId, String? source, Size size) {
    if (messageId.isEmpty ||
        source == null ||
        source.isEmpty ||
        !size.width.isFinite ||
        !size.height.isFinite ||
        size.width <= 0 ||
        size.height <= 0) {
      return;
    }
    final key = (messageId, source);
    _sizes.remove(key);
    _sizes[key] = size;
    if (_sizes.length > _maxEntries) _sizes.remove(_sizes.keys.first);
  }
}

String? imageBubbleVisualSource(
  MediaResource? media, {
  bool skipLocalPreview = false,
}) {
  if (media == null) return null;
  final localPreview =
      skipLocalPreview ? null : _nonEmpty(media.localPreviewUrl);
  if (localPreview != null) return localPreview;
  final url = _nonEmpty(media.url);
  if (isLocalVisualMediaUrl(url)) return url;
  return _nonEmpty(media.thumbnailUrl) ?? url;
}

String? imageBubbleFallbackSource(MediaResource? media, String failedSource) {
  if (media == null || failedSource != _nonEmpty(media.thumbnailUrl)) {
    return null;
  }
  final original = _nonEmpty(media.url);
  return original == null || original == failedSource ? null : original;
}

Future<String?> resolveAvailableImageBubbleVisualSource(
  MediaResource? media,
) async {
  final candidate = imageBubbleVisualSource(media);
  if (candidate == null || !isLocalVisualMediaUrl(candidate)) {
    return candidate;
  }
  final exists = await localFileExists(localPathFromUriOrPath(candidate));
  return exists
      ? candidate
      : imageBubbleVisualSource(media, skipLocalPreview: true);
}

bool imageBubbleVisualIdentityChanged(
  MediaResource? previous,
  MediaResource? next,
) {
  return previous?.localPreviewUrl != next?.localPreviewUrl ||
      previous?.thumbnailUrl != next?.thumbnailUrl ||
      previous?.url != next?.url;
}

MediaBubbleSize responsiveMediaBubbleSize({
  MediaResource? media,
  Size? trustedDecodedSize,
  Size? visualFallbackSize,
  required double viewportShortestSide,
  required double availableWidth,
  required double fallbackAspectRatio,
}) {
  final width = media?.width;
  final height = media?.height;
  final mediaRatio = width != null && height != null && width > 0 && height > 0
      ? width / height
      : null;
  final sourceRatio = (_validRatio(mediaRatio) ? mediaRatio : null) ??
      _sizeAspectRatio(trustedDecodedSize) ??
      _sizeAspectRatio(visualFallbackSize) ??
      (_validRatio(fallbackAspectRatio) ? fallbackAspectRatio : 1.0);
  final visibleRatio = sourceRatio.clamp(1 / 3, 3).toDouble();
  final safeShortestSide =
      viewportShortestSide.isFinite && viewportShortestSide > 0
          ? viewportShortestSide
          : 392.0;
  final maxLongEdge = math.min(196.0, safeShortestSide * 0.5);

  var targetWidth =
      visibleRatio >= 1 ? maxLongEdge : maxLongEdge * visibleRatio;
  var targetHeight =
      visibleRatio >= 1 ? maxLongEdge / visibleRatio : maxLongEdge;

  if (availableWidth.isFinite &&
      availableWidth > 0 &&
      targetWidth > availableWidth) {
    final scale = availableWidth / targetWidth;
    targetWidth *= scale;
    targetHeight *= scale;
  }

  return MediaBubbleSize(width: targetWidth, height: targetHeight);
}

MediaBubbleSize imageBubbleSize(
  MediaResource? media, {
  double availableWidth = 196,
  double viewportShortestSide = 393,
  Size? trustedDecodedSize,
  Size? visualFallbackSize,
}) {
  return responsiveMediaBubbleSize(
    media: media,
    trustedDecodedSize: trustedDecodedSize,
    visualFallbackSize: visualFallbackSize,
    viewportShortestSide: viewportShortestSide,
    availableWidth: availableWidth,
    fallbackAspectRatio: 1,
  );
}

double fileBubbleWidth({
  required double viewportWidth,
  required double availableWidth,
}) {
  final preferred = (viewportWidth * 0.56).clamp(196.0, 248.0);
  return math.min(math.max(0, availableWidth), preferred).roundToDouble();
}

MediaBubbleSize videoBubbleSize(
  MediaResource? media, {
  double availableWidth = 196,
  double viewportShortestSide = 393,
  Size? trustedDecodedSize,
  Size? visualFallbackSize,
}) {
  return responsiveMediaBubbleSize(
    media: media,
    trustedDecodedSize: trustedDecodedSize,
    visualFallbackSize: visualFallbackSize,
    viewportShortestSide: viewportShortestSide,
    availableWidth: availableWidth,
    fallbackAspectRatio: 16 / 9,
  );
}

double? _sizeAspectRatio(Size? size) {
  if (size == null ||
      !size.width.isFinite ||
      !size.height.isFinite ||
      size.width <= 0 ||
      size.height <= 0) {
    return null;
  }
  final ratio = size.width / size.height;
  return _validRatio(ratio) ? ratio : null;
}

bool _validRatio(double? ratio) => ratio != null && ratio.isFinite && ratio > 0;

String? videoBubblePosterSource(
  MediaResource? media, {
  String? generatedPosterUrl,
  bool skipLocalPoster = false,
}) {
  if (media == null) return null;
  return (skipLocalPoster ? null : _nonEmpty(media.localPosterUrl)) ??
      _nonEmpty(media.thumbnailUrl) ??
      _nonEmpty(generatedPosterUrl);
}

bool isLocalVisualMediaUrl(String? url) {
  final value = _nonEmpty(url);
  if (value == null) return false;
  if (value.startsWith('/media') ||
      value.startsWith('/api') ||
      value.startsWith('/uploads') ||
      value.startsWith('/files')) {
    return false;
  }
  return value.startsWith('file://') ||
      value.startsWith('/') ||
      (!value.startsWith('http://') && !value.startsWith('https://'));
}

String? _nonEmpty(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
