import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

@immutable
class ImagePreviewAnchorGeometry {
  final Rect rect;
  final double borderRadius;
  final BoxFit fit;

  const ImagePreviewAnchorGeometry({
    required this.rect,
    required this.borderRadius,
    required this.fit,
  });
}

class ImagePreviewLaunchFrame {
  final ImagePreviewAnchorGeometry geometry;
  final Object sourceIdentity;
  final ImageProvider imageProvider;
  final ImageInfo imageInfo;

  const ImagePreviewLaunchFrame({
    required this.geometry,
    required this.sourceIdentity,
    required this.imageProvider,
    required this.imageInfo,
  });

  Size get decodedSize => Size(
        imageInfo.image.width.toDouble(),
        imageInfo.image.height.toDouble(),
      );

  void dispose() => imageInfo.dispose();
}

class ImagePreviewAnchorHandle {
  _ImagePreviewAnchorState? _state;

  ImagePreviewAnchorGeometry? get geometry => _state?._geometry;
  Object? get sourceIdentity => _state?.widget.sourceIdentity;
  bool get sourceHidden => _state?._hidden ?? false;

  Future<ImagePreviewLaunchFrame?> capture({
    Duration timeout = const Duration(milliseconds: 80),
  }) =>
      _state?._capture(timeout: timeout) ?? Future.value();

  void hideSource(Object expectedIdentity) =>
      _state?._setHidden(true, expectedIdentity: expectedIdentity);

  void showSource(Object expectedIdentity) =>
      _state?._setHidden(false, expectedIdentity: expectedIdentity);

  void _attach(_ImagePreviewAnchorState state) => _state = state;

  void _detach(_ImagePreviewAnchorState state) {
    if (identical(_state, state)) _state = null;
  }
}

class ImagePreviewAnchor extends StatefulWidget {
  final ImagePreviewAnchorHandle handle;
  final Object sourceIdentity;
  final ImageProvider? imageProvider;
  final double borderRadius;
  final BoxFit fit;
  final Widget child;

  const ImagePreviewAnchor({
    super.key,
    required this.handle,
    required this.sourceIdentity,
    required this.imageProvider,
    required this.borderRadius,
    this.fit = BoxFit.cover,
    required this.child,
  });

  @override
  State<ImagePreviewAnchor> createState() => _ImagePreviewAnchorState();
}

class _ImagePreviewAnchorState extends State<ImagePreviewAnchor> {
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    widget.handle._attach(this);
  }

  @override
  void didUpdateWidget(ImagePreviewAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.handle, widget.handle)) {
      oldWidget.handle._detach(this);
      widget.handle._attach(this);
    }
    if (oldWidget.sourceIdentity != widget.sourceIdentity) _hidden = false;
  }

  @override
  void dispose() {
    widget.handle._detach(this);
    super.dispose();
  }

  ImagePreviewAnchorGeometry? get _geometry {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize ||
        renderObject.size.isEmpty) {
      return null;
    }
    return ImagePreviewAnchorGeometry(
      rect: renderObject.localToGlobal(Offset.zero) & renderObject.size,
      borderRadius: widget.borderRadius,
      fit: widget.fit,
    );
  }

  Future<ImagePreviewLaunchFrame?> _capture({required Duration timeout}) async {
    final geometry = _geometry;
    final provider = widget.imageProvider;
    final sourceIdentity = widget.sourceIdentity;
    if (geometry == null || provider == null) return null;
    final stream = provider.resolve(createLocalImageConfiguration(context));
    final completer = Completer<ImageInfo?>();
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        stream.removeListener(listener);
        if (!completer.isCompleted) completer.complete(info.clone());
      },
      onError: (_, __) {
        stream.removeListener(listener);
        if (!completer.isCompleted) completer.complete(null);
      },
    );
    stream.addListener(listener);
    final imageInfo = await completer.future.timeout(
      timeout,
      onTimeout: () {
        stream.removeListener(listener);
        return null;
      },
    );
    if (!mounted ||
        widget.sourceIdentity != sourceIdentity ||
        imageInfo == null) {
      imageInfo?.dispose();
      return null;
    }
    return ImagePreviewLaunchFrame(
      geometry: geometry,
      sourceIdentity: sourceIdentity,
      imageProvider: provider,
      imageInfo: imageInfo,
    );
  }

  void _setHidden(bool hidden, {required Object expectedIdentity}) {
    if (!mounted ||
        widget.sourceIdentity != expectedIdentity ||
        _hidden == hidden) {
      return;
    }
    setState(() => _hidden = hidden);
  }

  @override
  Widget build(BuildContext context) => _hidden
      ? Opacity(
          key: const ValueKey('image-preview-anchor-hidden'),
          opacity: 0,
          child: widget.child,
        )
      : widget.child;
}

Rect imageViewerContainRect(Size viewport, Size imageSize,
    {EdgeInsets padding = EdgeInsets.zero}) {
  final available = padding.deflateRect(Offset.zero & viewport);
  if (available.isEmpty || imageSize.isEmpty) return Rect.zero;
  final fitted =
      applyBoxFit(BoxFit.contain, imageSize, available.size).destination;
  return Alignment.center.inscribe(fitted, available);
}

Rect imageViewerSourceCropRect(
  Size imageSize,
  Size destinationSize,
  BoxFit fit,
) {
  if (imageSize.isEmpty || destinationSize.isEmpty) {
    return Offset.zero & Size.zero;
  }
  final fitted = applyBoxFit(fit, imageSize, destinationSize);
  return Alignment.center.inscribe(fitted.source, Offset.zero & imageSize);
}

Rect imageViewerSourceDisplayRect(
  Size imageSize,
  ImagePreviewAnchorGeometry source,
) {
  if (imageSize.isEmpty || source.rect.isEmpty) return Rect.zero;
  final fitted = applyBoxFit(source.fit, imageSize, source.rect.size);
  return Alignment.center.inscribe(fitted.destination, source.rect);
}

Rect imageViewerTransitionRect({
  required Rect sourceRect,
  required Rect destinationRect,
  required Rect sourceCrop,
  required Rect destinationCrop,
  required double progress,
}) {
  final t = progress.clamp(0.0, 1.0);
  final crop = Rect.lerp(sourceCrop, destinationCrop, t)!;
  if (crop.isEmpty || sourceRect.isEmpty || destinationRect.isEmpty) {
    return Rect.lerp(sourceRect, destinationRect, t)!;
  }
  final aspectRatio = crop.width / crop.height;
  final sourceArea = sourceRect.width * sourceRect.height;
  final destinationArea = destinationRect.width * destinationRect.height;
  final area = ui.lerpDouble(sourceArea, destinationArea, t)!;
  final width = math.sqrt(area * aspectRatio);
  final height = area / width;
  return Rect.fromCenter(
    center: Offset.lerp(sourceRect.center, destinationRect.center, t)!,
    width: width,
    height: height,
  );
}

class ImagePreviewTransitionPainter extends CustomPainter {
  final ui.Image image;
  final double progress;
  final ImagePreviewAnchorGeometry source;
  final Rect destination;

  const ImagePreviewTransitionPainter({
    required this.image,
    required this.progress,
    required this.source,
    required this.destination,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final sourceCrop = imageViewerSourceCropRect(
      imageSize,
      source.rect.size,
      source.fit,
    );
    final fullCrop = Offset.zero & imageSize;
    final crop = Rect.lerp(sourceCrop, fullCrop, progress)!;
    final sourceDisplayRect = imageViewerSourceDisplayRect(imageSize, source);
    final target = imageViewerTransitionRect(
      sourceRect: sourceDisplayRect,
      destinationRect: destination,
      sourceCrop: sourceCrop,
      destinationCrop: fullCrop,
      progress: progress,
    );
    // Letterboxed content sits inside the bubble's rounded clipping corners.
    final sourceRadius =
        sourceDisplayRect == source.rect ? source.borderRadius : 0.0;
    final radius = ui.lerpDouble(sourceRadius, 0, progress)!;
    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(target, Radius.circular(radius)),
      doAntiAlias: true,
    );
    canvas.drawImageRect(
      image,
      crop,
      target,
      Paint()..filterQuality = FilterQuality.medium,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(ImagePreviewTransitionPainter oldDelegate) =>
      oldDelegate.image != image ||
      oldDelegate.progress != progress ||
      oldDelegate.source != source ||
      oldDelegate.destination != destination;
}
