import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:im_sdk/core/media/authenticated_image_cache.dart';
import 'package:im_sdk/core/diagnostics/media_diagnostics.dart';
import 'package:im_sdk/core/diagnostics/media_image_observer.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/media/image_resource.dart';

export 'package:im_sdk/core/media/authenticated_image_cache.dart'
    show
        AuthCacheManager,
        accountAuthCacheManagerProvider,
        prefetchAvatarUrls,
        NetworkImageCacheScope;

final myAvatarCacheBuster = ValueNotifier<int>(0);

class UserAvatar extends ConsumerWidget {
  final String? avatarUrl;
  final String name;
  final double size;
  final double borderRadius;
  final bool isGroup;
  final bool isMyAvatar;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    required this.name,
    this.size = 40,
    this.borderRadius = 8,
    this.isGroup = false,
    this.isMyAvatar = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: avatarUrl != null && avatarUrl!.isNotEmpty
            ? isMyAvatar
                ? ValueListenableBuilder<int>(
                    valueListenable: myAvatarCacheBuster,
                    builder: (_, version, __) {
                      final url =
                          ImageResource.withRevision(avatarUrl!, version);
                      return AuthNetworkImage(
                        key: ValueKey(url),
                        url: url,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallback(context),
                      );
                    },
                  )
                : AuthNetworkImage(
                    url: avatarUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallback(context),
                  )
            : _fallback(context),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isGroup) {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.group,
          size: size * 0.55,
          color: colorScheme.onSurfaceVariant,
        ),
      );
    }
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00B27A), Color(0xFF00D68F)],
        ),
      ),
      child: Center(
        child: Text(initial,
            style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary)),
      ),
    );
  }
}

class UserAvatarCircle extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final double size;

  const UserAvatarCircle(
      {super.key, this.avatarUrl, required this.name, this.size = 40});

  @override
  Widget build(BuildContext context) => UserAvatar(
      avatarUrl: avatarUrl, name: name, size: size, borderRadius: size / 2);
}

// ---------------------------------------------------------------------------
// AuthNetworkImage
// ---------------------------------------------------------------------------

class AuthNetworkImage extends ConsumerWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final bool cacheInMemory;
  final NetworkImageCacheScope cacheScope;
  final ValueChanged<Size>? onImageSize;
  final ValueChanged<ImageProvider>? onImageProviderResolved;

  const AuthNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
    this.cacheInMemory = true,
    this.cacheScope = NetworkImageCacheScope.accountSpace,
    this.onImageSize,
    this.onImageProviderResolved,
  });

  static String resolveUrl(String url) {
    return resolveNetworkImageUrl(url);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(
        cacheScope == NetworkImageCacheScope.spaceDirectory
            ? spaceDirectoryImageCacheManagerProvider
            : networkImageCacheManagerProvider);
    return _AuthNetworkImageContent(
      key: ValueKey(manager.namespace),
      image: this,
      cacheManager: manager,
      diagnosticScope: ref.watch(mediaDiagnosticScopeProvider),
    );
  }
}

class _AuthNetworkImageContent extends StatefulWidget {
  const _AuthNetworkImageContent(
      {super.key,
      required this.image,
      required this.cacheManager,
      required this.diagnosticScope});
  final AuthNetworkImage image;
  final AuthCacheManager cacheManager;
  final DiagnosticScope diagnosticScope;

  @override
  State<_AuthNetworkImageContent> createState() => _AuthNetworkImageState();
}

class _AuthNetworkImageState extends State<_AuthNetworkImageContent> {
  int _svgRevision = 0;
  late MediaDiagnosticOperation _diagnostic;

  void _startDiagnostic(String url) {
    _diagnostic = MediaDiagnosticOperation(
        scope: widget.diagnosticScope,
        kind: DiagnosticMediaKind.image,
        resource: url);
  }

  late AuthCacheManager _cacheManager;
  String? _resolvedUrl;
  bool _isSvg = false;
  Uint8List? _svgBytes;
  bool _svgLoading = true;
  ImageStream? _sizeStream;
  ImageStreamListener? _sizeListener;
  String? _observedSizeKey;

  @override
  void initState() {
    super.initState();
    _cacheManager = widget.cacheManager;
    _resolvedUrl = AuthNetworkImage.resolveUrl(widget.image.url);
    _startDiagnostic(_resolvedUrl!);
    _isSvg = _checkIsSvg(_resolvedUrl!);
    if (_isSvg) _loadSvg(_resolvedUrl!);
  }

  @override
  void didUpdateWidget(_AuthNetworkImageContent old) {
    super.didUpdateWidget(old);
    final newUrl = AuthNetworkImage.resolveUrl(widget.image.url);
    if (newUrl != _resolvedUrl) {
      _startDiagnostic(newUrl);
      _svgRevision++;
      _clearSizeObservation();
      _resolvedUrl = newUrl;
      _isSvg = _checkIsSvg(newUrl);
      if (_isSvg) {
        _svgBytes = null;
        _svgLoading = true;
        _loadSvg(newUrl);
      }
    }
  }

  static bool _checkIsSvg(String url) =>
      url.contains('.svg') || url.contains('/svg') || url.contains('image/svg');

  @override
  void dispose() {
    _clearSizeObservation();
    super.dispose();
  }

  void _observeImageSize(ImageProvider provider, String key) {
    widget.image.onImageProviderResolved?.call(provider);
    if (widget.image.onImageSize == null || _observedSizeKey == key) return;
    _clearSizeObservation();
    _observedSizeKey = key;
    final diagnostic = _diagnostic;
    final stream = provider.resolve(createLocalImageConfiguration(context));
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        stream.removeListener(listener);
        if (!mounted || _observedSizeKey != key) return;
        final size = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _observedSizeKey == key) {
            widget.image.onImageSize?.call(size);
          }
        });
      },
      onError: (error, stack) {
        diagnostic.failed(MediaFailureStage.decode, error, stack);
        stream.removeListener(listener);
      },
    );
    _sizeStream = stream;
    _sizeListener = listener;
    stream.addListener(listener);
  }

  void _clearSizeObservation() {
    final stream = _sizeStream;
    final listener = _sizeListener;
    if (stream != null && listener != null) stream.removeListener(listener);
    _sizeStream = null;
    _sizeListener = null;
    _observedSizeKey = null;
  }

  Future<void> _loadSvg(String url) async {
    final revision = ++_svgRevision;
    final cm = _cacheManager;
    final diagnostic = _diagnostic;
    bool current() => mounted && revision == _svgRevision;
    final memory = cm.memoryBytes(url);
    if (memory != null) {
      _svgBytes = memory;
      _svgLoading = false;
    }
    try {
      await for (final bytes in cm.imageBytes(url)) {
        if (!current()) return;
        setState(() {
          _svgBytes = bytes;
          _svgLoading = false;
        });
      }
    } catch (error, stack) {
      diagnostic.failed(MediaFailureStage.load, error, stack);
      if (current()) setState(() => _svgLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedUrl =
        _resolvedUrl ?? AuthNetworkImage.resolveUrl(widget.image.url);
    final diagnostic = _diagnostic;
    final decodeWidth = _decodeDimension(context, widget.image.width);
    final decodeHeight = _decodeDimension(context, widget.image.height);

    Widget placeholder() =>
        widget.image.width != null || widget.image.height != null
            ? SizedBox(
                width: widget.image.width,
                height: widget.image.height,
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ))
            : const SizedBox.shrink();

    Widget error() => widget.image.errorBuilder != null
        ? widget.image.errorBuilder!(context, 'error', null)
        : SizedBox(
            width: widget.image.width,
            height: widget.image.height,
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.broken_image,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ));

    if (_isSvg) {
      if (_svgLoading) return placeholder();
      if (_svgBytes == null) return error();
      return SizedBox(
        width: widget.image.width,
        height: widget.image.height,
        child: SvgPicture.memory(_svgBytes!, fit: widget.image.fit,
            errorBuilder: (_, cause, stack) {
          diagnostic.failed(MediaFailureStage.decode, cause, stack);
          return const SizedBox();
        }),
      );
    }

    // 普通图片：先查内存缓存，命中直接 Image.memory（零延迟）
    final memoryKey = _cacheManager.memoryKey(resolvedUrl);
    final memBytes = widget.image.cacheInMemory
        ? _cacheManager.memoryBytes(resolvedUrl)
        : null;
    if (memBytes != null) {
      final provider = MemoryImage(memBytes);
      final displayProvider = ResizeImage.resizeIfNeeded(
        decodeWidth,
        decodeHeight,
        provider,
      );
      _observeImageSize(displayProvider, memoryKey);
      return SizedBox(
        width: widget.image.width,
        height: widget.image.height,
        child: Image(
          image: displayProvider,
          fit: widget.image.fit,
          errorBuilder: (_, cause, stack) {
            diagnostic.failed(MediaFailureStage.decode, cause, stack);
            return error();
          },
        ),
      );
    }

    // 内存无缓存：走 CachedNetworkImage，同时异步写入内存缓存
    return CachedNetworkImage(
      imageUrl: resolvedUrl,
      cacheManager: _cacheManager,
      cacheKey: memoryKey,
      width: widget.image.width,
      height: widget.image.height,
      fit: widget.image.fit,
      memCacheWidth: decodeWidth,
      memCacheHeight: decodeHeight,
      placeholder: (_, __) => widget.image.errorBuilder != null
          ? widget.image.errorBuilder!(context, 'loading', null)
          : placeholder(),
      imageBuilder: (ctx, imageProvider) {
        // 下载完成后写入内存缓存，下次直接用 Image.memory
        if (widget.image.cacheInMemory) {
          _cacheManager.cacheToMemory(resolvedUrl);
        }
        _observeImageSize(imageProvider, memoryKey);
        return MediaImageObserver(
            provider: imageProvider,
            operation: diagnostic,
            child: Image(image: imageProvider, fit: widget.image.fit));
      },
      errorWidget: (ctx, url, cause) {
        diagnostic.imageFailed(cause);
        return widget.image.errorBuilder != null
            ? widget.image.errorBuilder!(ctx, cause, null)
            : error();
      },
    );
  }

  int? _decodeDimension(BuildContext context, double? logicalSize) {
    if (logicalSize == null || logicalSize <= 0 || !logicalSize.isFinite) {
      return null;
    }
    final ratio = MediaQuery.devicePixelRatioOf(context);
    return (logicalSize * ratio).round().clamp(1, 2048);
  }
}
