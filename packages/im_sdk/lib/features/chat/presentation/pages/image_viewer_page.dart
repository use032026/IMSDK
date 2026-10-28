import 'dart:async';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/diagnostics/media_diagnostics.dart';
import 'package:im_sdk/core/diagnostics/media_image_observer.dart';
import 'package:im_sdk/core/platform/local_file.dart';
import 'package:im_sdk/core/widgets/app_network_image.dart';
import 'package:im_sdk/features/chat/domain/entities/media_local_file.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/presentation/controllers/chat_media_gallery_window_controller.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_open_controller.dart';
import 'package:im_sdk/features/chat/presentation/models/message_media_preview_model.dart';
import 'package:im_sdk/features/chat/presentation/pages/chat_media_video_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/image_viewer_transition.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';

export 'image_viewer_transition.dart';

const imageViewerOpenDuration = Duration(milliseconds: 220);
const imageViewerCloseDuration = Duration(milliseconds: 180);
const imageViewerOriginalFadeDuration = Duration(milliseconds: 120);
const imageViewerDismissDistance = 110.0;
const imageViewerDismissVelocity = 900.0;

double imageViewerDoubleTapTarget(double currentScale) =>
    currentScale > 1.001 ? 1 : 2.5;

bool imageViewerShouldDismiss(Offset offset, Offset velocity) =>
    offset.dy >= imageViewerDismissDistance ||
    velocity.dy >= imageViewerDismissVelocity;

@visibleForTesting
bool imageViewerOriginalLoadCanContinue({
  required bool isMounted,
  required int expectedGeneration,
  required int? currentGeneration,
}) =>
    isMounted && currentGeneration == expectedGeneration;

const imageViewerSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.black,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.black,
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarContrastEnforced: false,
);

final Expando<bool> _activeImageViewerNavigators = Expando<bool>();

Future<void> openChatMediaViewer(
  BuildContext context, {
  required ChatMediaViewerRequest request,
}) async {
  final navigator = Navigator.of(context);
  if (_activeImageViewerNavigators[navigator] == true) return;
  _activeImageViewerNavigators[navigator] = true;
  final sourceFocus = FocusManager.instance.primaryFocus;
  ImagePreviewLaunchFrame? launchFrame;
  try {
    try {
      launchFrame = await request.initialAnchor?.capture();
    } catch (_) {
      // The source preview is an animation enhancement, not a navigation
      // prerequisite. A provider can disappear while the user taps it (for
      // example when a message page is recycled), so fall back to the stable
      // centered transition instead of dropping the tap.
      launchFrame = null;
    }
    if (!context.mounted) {
      launchFrame?.dispose();
      return;
    }
    if (launchFrame != null) {
      request.initialAnchor?.hideSource(launchFrame.sourceIdentity);
    }
    final viewerClosed = navigator.push<void>(
      PageRouteBuilder<void>(
        requestFocus: false,
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => ChatMediaViewerPage(
          request: launchFrame == null
              ? request
              : request.withInitialPreview(
                  size: launchFrame.decodedSize,
                  provider: launchFrame.imageProvider,
                ),
          launchFrame: launchFrame,
        ),
      ),
    );
    // Keep focus ownership with the source route until we can clear the exact
    // node that opened the platform text input. Letting Navigator move focus to
    // the viewer first leaves the chat field in its route history, so popping
    // the viewer can briefly restore the keyboard before another hide call.
    sourceFocus?.unfocus(disposition: UnfocusDisposition.scope);
    unawaited(SystemChannels.textInput.invokeMethod<void>('TextInput.hide'));
    await viewerClosed;
  } finally {
    if (launchFrame != null) {
      request.initialAnchor?.showSource(launchFrame.sourceIdentity);
    }
    _activeImageViewerNavigators[navigator] = false;
  }
}

enum ChatMediaViewerKind { image, video }

class ChatMediaViewerItem {
  final ChatMediaViewerKind kind;
  final Message? message;
  final String conversationId;
  final String messageId;
  final int conversationSeq;
  final MediaResource media;
  final String previewUrl;
  final Size? previewSize;
  final ImageProvider? previewProvider;

  const ChatMediaViewerItem({
    this.kind = ChatMediaViewerKind.image,
    this.message,
    required this.conversationId,
    required this.messageId,
    this.conversationSeq = 0,
    required this.media,
    required this.previewUrl,
    this.previewSize,
    this.previewProvider,
  });

  factory ChatMediaViewerItem.fromMessage({
    required Message message,
    required MediaResource media,
    String? previewUrl,
    Size? previewSize,
    ImageProvider? previewProvider,
  }) {
    assert(
      message.type == MessageType.image || message.type == MessageType.video,
    );
    final kind = message.type == MessageType.video
        ? ChatMediaViewerKind.video
        : ChatMediaViewerKind.image;
    return ChatMediaViewerItem(
      kind: kind,
      message: message,
      conversationId: message.conversationId,
      messageId: message.messageId,
      conversationSeq: message.conversationSeq,
      media: media,
      previewUrl: previewUrl ??
          (kind == ChatMediaViewerKind.video
              ? videoBubblePosterSource(media) ?? ''
              : imageBubbleVisualSource(media) ?? media.url),
      previewSize: previewSize,
      previewProvider: previewProvider,
    );
  }

  double get aspectRatio {
    final width = media.width;
    final height = media.height;
    if (width != null && height != null && width > 0 && height > 0) {
      return width / height;
    }
    final size = previewSize;
    if (size != null && size.width > 0 && size.height > 0) {
      return size.width / size.height;
    }
    return 1;
  }

  ChatMediaViewerItem withPreview({
    String? url,
    Size? size,
    ImageProvider? provider,
  }) =>
      ChatMediaViewerItem(
        kind: kind,
        message: message,
        conversationId: conversationId,
        messageId: messageId,
        conversationSeq: conversationSeq,
        media: media,
        previewUrl: url ?? previewUrl,
        previewSize: size ?? previewSize,
        previewProvider: provider ?? previewProvider,
      );
}

class ChatMediaViewerRequest {
  final String conversationId;
  final List<ChatMediaViewerItem> items;
  final int initialIndex;
  final ImagePreviewAnchorHandle? initialAnchor;

  ChatMediaViewerRequest._({
    required this.conversationId,
    required List<ChatMediaViewerItem> items,
    required this.initialIndex,
    required this.initialAnchor,
  }) : items = List.unmodifiable(items);

  factory ChatMediaViewerRequest.forItem({
    required ChatMediaViewerItem item,
    List<ChatMediaViewerItem> availableItems = const [],
    ImagePreviewAnchorHandle? initialAnchor,
  }) {
    final sameConversation = availableItems
        .where((candidate) => candidate.conversationId == item.conversationId)
        .toList(growable: false);
    var sourceItems = sameConversation.any(
      (candidate) => candidate.messageId == item.messageId,
    )
        ? List<ChatMediaViewerItem>.of(sameConversation)
        : <ChatMediaViewerItem>[item];
    var initialIndex = sourceItems.indexWhere(
      (candidate) => candidate.messageId == item.messageId,
    );
    sourceItems[initialIndex] = item;
    final start = (initialIndex - 15).clamp(0, sourceItems.length);
    final end = (initialIndex + 16).clamp(0, sourceItems.length);
    sourceItems = sourceItems.sublist(start, end);
    initialIndex -= start;
    return ChatMediaViewerRequest._(
      conversationId: item.conversationId,
      items: sourceItems,
      initialIndex: initialIndex,
      initialAnchor: initialAnchor,
    );
  }

  factory ChatMediaViewerRequest.fromUrls(
    List<String> urls, {
    int initialIndex = 0,
  }) {
    assert(urls.isNotEmpty);
    assert(initialIndex >= 0 && initialIndex < urls.length);
    return ChatMediaViewerRequest._(
      conversationId: '',
      initialIndex: initialIndex,
      initialAnchor: null,
      items: [
        for (var i = 0; i < urls.length; i++)
          ChatMediaViewerItem(
            kind: ChatMediaViewerKind.image,
            message: null,
            conversationId: '',
            messageId: 'standalone-$i',
            conversationSeq: 0,
            media: MediaResource(url: urls[i]),
            previewUrl: urls[i],
            previewProvider: isLocalVisualMediaUrl(urls[i])
                ? FileImage(File(localPathFromUriOrPath(urls[i])))
                : null,
          ),
      ],
    );
  }

  ChatMediaViewerRequest withInitialPreview({
    required Size size,
    required ImageProvider provider,
  }) {
    final nextItems = List<ChatMediaViewerItem>.of(items);
    nextItems[initialIndex] = nextItems[initialIndex].withPreview(
      size: size,
      provider: provider,
    );
    return ChatMediaViewerRequest._(
      conversationId: conversationId,
      items: nextItems,
      initialIndex: initialIndex,
      initialAnchor: initialAnchor,
    );
  }
}

List<ChatMediaViewerItem> mediaViewerItemsFromMessages(
  List<Message> messages,
) {
  final seen = <String>{};
  final items = <ChatMediaViewerItem>[];
  for (final message in messages) {
    if (message.type != MessageType.image &&
        message.type != MessageType.video) {
      continue;
    }
    final media = message.type == MessageType.video
        ? message.body.video
        : message.body.image;
    if (media == null ||
        message.isRecalled ||
        message.status == MessageStatus.deletedLocal ||
        !seen.add(message.messageId)) {
      continue;
    }
    final previewUrl = message.type == MessageType.video
        ? videoBubblePosterSource(media)
        : imageBubbleVisualSource(media);
    if (media.url.trim().isEmpty ||
        (message.type == MessageType.image && previewUrl == null)) {
      continue;
    }
    items.add(ChatMediaViewerItem.fromMessage(
      message: message,
      media: media,
      previewUrl: previewUrl,
    ));
  }
  return List.unmodifiable(items);
}

enum _ImageViewerPhase { opening, viewing, dragging, closing, disposed }

class ChatMediaViewerPage extends ConsumerStatefulWidget {
  final ChatMediaViewerRequest request;
  final ImagePreviewLaunchFrame? launchFrame;

  const ChatMediaViewerPage({
    super.key,
    required this.request,
    this.launchFrame,
  });

  @override
  ConsumerState<ChatMediaViewerPage> createState() =>
      _ChatMediaViewerPageState();
}

class _ChatMediaViewerPageState extends ConsumerState<ChatMediaViewerPage>
    with TickerProviderStateMixin {
  late final AnimationController _transitionController;
  late final AnimationController _videoReboundController;
  late final ExtendedPageController _pageController;
  final _slidePageKey = GlobalKey<ExtendedImageSlidePageState>();
  final Map<int, GlobalKey<ExtendedImageGestureState>> _gestureKeys = {};
  final Map<(int, ImageProvider), GlobalKey<ExtendedImageGestureState>>
      _providerGestureKeys = {};
  final Map<int, ImageProvider> _providers = {};
  final Map<int, Size> _decodedSizes = {};
  final Map<int, ImageProvider> _pendingOriginalProviders = {};
  final Map<int, Size> _pendingOriginalSizes = {};
  final Map<int, double> _scales = {};
  final Set<int> _zoomedIndexes = {};
  final Map<int, int> _loadGenerations = {};
  final Set<int> _loadingOriginalIndexes = {};
  final Set<int> _originalReadyIndexes = {};
  final Set<int> _failedIndexes = {};
  final Map<int, (ImageStream, ImageStreamListener, Completer<ImageInfo?>)>
      _pendingImageResolutions = {};

  late List<ChatMediaViewerItem> _items;
  ChatMediaGalleryWindowController? _windowController;
  String? _viewerSpaceId;

  late int _currentIndex;
  _ImageViewerPhase _phase = _ImageViewerPhase.opening;
  ImagePreviewLaunchFrame? _closingFrame;
  bool _allowPop = false;
  bool _closeInProgress = false;
  bool _fallbackClose = false;
  double _dragBackdropOpacity = 1;
  double _closingBackdropStart = 1;
  double _videoDragOffset = 0;
  double _videoReboundStart = 0;
  int _nextImageResolutionId = 0;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.request.items);
    _currentIndex = widget.request.initialIndex;
    _pageController = ExtendedPageController(initialPage: _currentIndex);
    _transitionController = AnimationController(
      vsync: this,
      duration: imageViewerOpenDuration,
      reverseDuration: imageViewerCloseDuration,
    )..addListener(_onTransitionTick);
    _videoReboundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )
      ..addListener(_onVideoReboundTick)
      ..addStatusListener(_onVideoReboundStatus);
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      final provider = item.previewProvider ?? _localProvider(item.previewUrl);
      if (provider != null) _providers[i] = provider;
      if (item.previewSize != null) _decodedSizes[i] = item.previewSize!;
    }
    _configureLocalWindow();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchAround(_currentIndex);
      unawaited(_open());
    });
  }

  void _configureLocalWindow() {
    final initialItem = _items[_currentIndex];
    final initialMessage = initialItem.message;
    _viewerSpaceId = ref.read(currentSpaceProvider)?.spaceId;
    final spaceId = _viewerSpaceId;
    if (initialMessage == null ||
        initialMessage.conversationSeq <= 0 ||
        spaceId == null ||
        spaceId.isEmpty) {
      return;
    }
    final local = ref.read(chatLocalDataSourceProvider);
    final controller = ChatMediaGalleryWindowController(
      initialMessage: initialMessage,
      initialMessages: _items.map((item) => item.message).whereType<Message>(),
      loadPage: (cursorSeq, direction, limit) => local.getLocalMediaPage(
        spaceId,
        initialMessage.conversationId,
        cursorSeq: cursorSeq,
        direction: direction,
        limit: limit,
      ),
    );
    _windowController = controller..addListener(_syncWindowItems);
    unawaited(controller.initialize());
  }

  void _syncWindowItems() {
    final controller = _windowController;
    if (!mounted || controller == null) return;
    final previousById = {
      for (var index = 0; index < _items.length; index++)
        _items[index].messageId: (index, _items[index]),
    };
    final nextItems = <ChatMediaViewerItem>[];
    for (final message in controller.items) {
      final media = message.type == MessageType.video
          ? message.body.video
          : message.body.image;
      if (media == null || media.url.trim().isEmpty) continue;
      final previous = previousById[message.messageId]?.$2;
      nextItems.add(ChatMediaViewerItem.fromMessage(
        message: message,
        media: media,
        previewUrl: previous?.previewUrl,
        previewSize: previous?.previewSize,
        previewProvider: previous?.previewProvider,
      ));
    }
    final nextIndex = nextItems.indexWhere(
      (item) => item.messageId == controller.currentMessageId,
    );
    if (nextIndex < 0 || nextItems.isEmpty) return;
    final changed = nextItems.length != _items.length ||
        Iterable.generate(nextItems.length).any(
          (index) =>
              index >= _items.length ||
              nextItems[index].messageId != _items[index].messageId,
        );
    if (!changed) {
      setState(() {});
      return;
    }

    final nextProviders = <int, ImageProvider>{};
    final nextSizes = <int, Size>{};
    for (var index = 0; index < nextItems.length; index++) {
      final previousIndex = previousById[nextItems[index].messageId]?.$1;
      final provider = previousIndex == null ? null : _providers[previousIndex];
      final size = previousIndex == null ? null : _decodedSizes[previousIndex];
      if (provider != null) nextProviders[index] = provider;
      if (size != null) nextSizes[index] = size;
    }
    for (final index in _loadGenerations.keys.toList()) {
      _loadGenerations[index] = _loadGenerations[index]! + 1;
    }
    setState(() {
      _items = nextItems;
      _currentIndex = nextIndex;
      _providers
        ..clear()
        ..addAll(nextProviders);
      _decodedSizes
        ..clear()
        ..addAll(nextSizes);
      _gestureKeys.clear();
      _providerGestureKeys.clear();
      _pendingOriginalProviders.clear();
      _pendingOriginalSizes.clear();
      _scales.clear();
      _zoomedIndexes.clear();
      _loadingOriginalIndexes.clear();
      _originalReadyIndexes.clear();
      _failedIndexes.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_pageController.hasClients &&
          _pageController.page?.round() != nextIndex) {
        _pageController.jumpToPage(nextIndex);
      }
      _prefetchAround(nextIndex);
    });
  }

  void _onTransitionTick() {
    if (mounted) setState(() {});
  }

  void _onVideoReboundTick() {
    if (!mounted) return;
    final remaining =
        1 - Curves.easeOutCubic.transform(_videoReboundController.value);
    setState(() {
      _videoDragOffset = _videoReboundStart * remaining;
      _dragBackdropOpacity = _videoBackdropOpacity(_videoDragOffset);
    });
  }

  void _onVideoReboundStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    setState(() {
      _videoDragOffset = 0;
      _dragBackdropOpacity = 1;
      _phase = _ImageViewerPhase.viewing;
    });
  }

  double _videoBackdropOpacity(double offset) {
    final viewportHeight = MediaQuery.sizeOf(context).height;
    if (viewportHeight <= 0) return 1;
    return (1 - offset.abs() / (viewportHeight * 0.65)).clamp(0.15, 1.0);
  }

  void _onVideoVerticalDragUpdate(DragUpdateDetails details) {
    if (_phase == _ImageViewerPhase.opening ||
        _phase == _ImageViewerPhase.closing ||
        (details.delta.dy < 0 && _videoDragOffset <= 0)) {
      return;
    }
    _videoReboundController.stop();
    setState(() {
      _phase = _ImageViewerPhase.dragging;
      _videoDragOffset =
          (_videoDragOffset + details.delta.dy).clamp(0.0, 600.0);
      _dragBackdropOpacity = _videoBackdropOpacity(_videoDragOffset);
    });
  }

  void _onVideoVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (imageViewerShouldDismiss(
      Offset(0, _videoDragOffset),
      Offset(0, velocity),
    )) {
      unawaited(_requestSlideClose());
      return;
    }
    _videoReboundStart = _videoDragOffset;
    _videoReboundController.forward(from: 0);
  }

  Future<void> _open() async {
    await _transitionController.forward(from: 0);
    if (!mounted) return;
    setState(() => _phase = _ImageViewerPhase.viewing);
    _prefetchAround(_currentIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyPendingOriginals();
    });
  }

  ImageProvider? _localProvider(String source) {
    if (!isLocalVisualMediaUrl(source)) return null;
    return FileImage(File(localPathFromUriOrPath(source)));
  }

  void _prefetchAround(int index) {
    for (final candidate in <int>{index - 1, index, index + 1}) {
      if (candidate >= 0 &&
          candidate < _items.length &&
          _items[candidate].kind == ChatMediaViewerKind.image) {
        unawaited(_loadOriginal(candidate));
      }
    }
  }

  Future<void> _loadOriginal(int index, {bool force = false}) async {
    if (_items[index].kind != ChatMediaViewerKind.image) return;
    if ((_originalReadyIndexes.contains(index) && !force) ||
        !_loadingOriginalIndexes.add(index)) {
      return;
    }
    final generation = (_loadGenerations[index] ?? 0) + 1;
    _loadGenerations[index] = generation;
    final item = _items[index];
    final diagnostic = _imageDiagnostic(item);
    var stage = MediaFailureStage.load;
    final spaceId = ref.read(currentSpaceProvider)?.spaceId;
    if (spaceId == null) {
      _loadingOriginalIndexes.remove(index);
      return;
    }
    try {
      final media = item.media;
      final path =
          await ref.read(mediaOpenControllerProvider(spaceId)).localPathFor(
                MediaOpenRequest(
                  conversationId: item.conversationId,
                  messageId: item.messageId,
                  mediaKind: MediaKind.image,
                  variant: MediaVariant.original,
                  remoteUrl: media.url,
                  localCandidateUrl: media.localPreviewUrl,
                  fileName: media.fileName?.trim().isNotEmpty == true
                      ? media.fileName!.trim()
                      : 'image.jpg',
                  mimeType: media.mimeType,
                  sizeBytes: media.sizeBytes,
                ),
              );
      if (!imageViewerOriginalLoadCanContinue(
        isMounted: mounted,
        expectedGeneration: generation,
        currentGeneration: _loadGenerations[index],
      )) {
        return;
      }
      final provider = FileImage(File(path));
      stage = MediaFailureStage.decode;
      final info = await _resolveImage(provider, diagnostic: diagnostic);
      if (!imageViewerOriginalLoadCanContinue(
        isMounted: mounted,
        expectedGeneration: generation,
        currentGeneration: _loadGenerations[index],
      )) {
        info?.dispose();
        return;
      }
      if (info == null) throw StateError('image decode failed');
      final decodedSize = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
      _originalReadyIndexes.add(index);
      if (_phase == _ImageViewerPhase.opening && index == _currentIndex) {
        _pendingOriginalProviders[index] = provider;
        _pendingOriginalSizes[index] = decodedSize;
      } else {
        setState(() {
          _providers[index] = provider;
          _decodedSizes[index] = decodedSize;
          _failedIndexes.remove(index);
        });
      }
      info.dispose();
    } catch (error, stack) {
      diagnostic.failed(stage, error, stack);
      if (!mounted || _loadGenerations[index] != generation) return;
      setState(() => _failedIndexes.add(index));
    } finally {
      if (_loadGenerations[index] == generation) {
        _loadingOriginalIndexes.remove(index);
      }
    }
  }

  void _applyPendingOriginals() {
    if (!mounted ||
        _phase != _ImageViewerPhase.viewing ||
        _pendingOriginalProviders.isEmpty) {
      return;
    }
    setState(() {
      for (final entry in _pendingOriginalProviders.entries) {
        _providers[entry.key] = entry.value;
        final size = _pendingOriginalSizes[entry.key];
        if (size != null) _decodedSizes[entry.key] = size;
        _failedIndexes.remove(entry.key);
      }
      _pendingOriginalProviders.clear();
      _pendingOriginalSizes.clear();
    });
  }

  Future<ImageInfo?> _resolveImage(ImageProvider provider,
      {MediaDiagnosticOperation? diagnostic}) async {
    final stream = provider.resolve(createLocalImageConfiguration(context));
    final completer = Completer<ImageInfo?>();
    final resolutionId = _nextImageResolutionId++;
    late final ImageStreamListener listener;

    void finish(ImageInfo? result) {
      stream.removeListener(listener);
      _pendingImageResolutions.remove(resolutionId);
      if (!completer.isCompleted) {
        completer.complete(result);
      } else {
        result?.dispose();
      }
    }

    listener = ImageStreamListener(
      (info, _) {
        finish(info.clone());
      },
      onError: (error, stack) {
        diagnostic?.failed(MediaFailureStage.decode, error, stack);
        finish(null);
      },
    );
    _pendingImageResolutions[resolutionId] = (stream, listener, completer);
    stream.addListener(listener);
    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        stream.removeListener(listener);
        _pendingImageResolutions.remove(resolutionId);
        if (!completer.isCompleted) completer.complete(null);
        return null;
      },
    );
  }

  bool _matchesItem(int index, String messageId) =>
      index >= 0 &&
      index < _items.length &&
      _items[index].messageId == messageId;

  void _acceptResolvedProvider(
    int index,
    String messageId,
    ImageProvider provider,
    Size? size,
  ) {
    if (!_matchesItem(index, messageId)) return;
    if (_originalReadyIndexes.contains(index)) return;
    if (_providers[index] == provider &&
        (size == null || _decodedSizes[index] == size)) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !_matchesItem(index, messageId) ||
          _originalReadyIndexes.contains(index)) {
        return;
      }
      setState(() {
        _providers[index] = provider;
        if (size != null) _decodedSizes[index] = size;
      });
    });
  }

  void _acceptResolvedSize(int index, String messageId, Size size) {
    if (!_matchesItem(index, messageId)) return;
    if (_originalReadyIndexes.contains(index)) return;
    if (_decodedSizes[index] == size) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _matchesItem(index, messageId) &&
          !_originalReadyIndexes.contains(index)) {
        setState(() => _decodedSizes[index] = size);
      }
    });
  }

  void _toggleZoom(int index, ExtendedImageGestureState state) {
    final current = state.gestureDetails?.totalScale ?? 1;
    final target = imageViewerDoubleTapTarget(current);
    _scales[index] = target;
    if (target > 1.001) {
      _zoomedIndexes.add(index);
    } else {
      _zoomedIndexes.remove(index);
    }
    state.handleDoubleTap(
      scale: target,
      doubleTapPosition: state.pointerDownPosition,
    );
  }

  Future<void> _waitForKeyboardToSettle() async {
    final deadline = DateTime.now().add(const Duration(milliseconds: 300));
    while (mounted &&
        View.of(context).viewInsets.bottom > 0 &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }
  }

  Future<void> _requestClose() async {
    if (_closeInProgress || !mounted) return;
    _closeInProgress = true;
    await _waitForKeyboardToSettle();
    if (!mounted) return;
    final slideState = _slidePageKey.currentState;
    if (slideState != null && slideState.offset != Offset.zero) {
      await _animateFallbackClose(backdropStart: _dragBackdropOpacity);
      return;
    }

    final scale = _scales[_currentIndex] ?? 1;
    if (scale > 1.001) {
      _gestureKeys[_currentIndex]?.currentState?.reset();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    final initialMessageId =
        widget.request.items[widget.request.initialIndex].messageId;
    final canReturnToSource =
        _items[_currentIndex].messageId == initialMessageId &&
            widget.launchFrame != null &&
            widget.request.initialAnchor?.sourceIdentity ==
                widget.launchFrame?.sourceIdentity &&
            widget.request.initialAnchor?.geometry != null;
    if (canReturnToSource) {
      final sourceIdentity = widget.launchFrame!.sourceIdentity;
      final provider = _providers[_currentIndex];
      final info = provider == null ? null : await _resolveImage(provider);
      if (!mounted) {
        info?.dispose();
        return;
      }
      final geometry = widget.request.initialAnchor?.geometry;
      final identityStillMatches =
          widget.request.initialAnchor?.sourceIdentity == sourceIdentity;
      if (info != null && geometry != null && identityStillMatches) {
        _closingFrame = ImagePreviewLaunchFrame(
          geometry: geometry,
          sourceIdentity: sourceIdentity,
          imageProvider: provider!,
          imageInfo: info,
        );
      } else {
        info?.dispose();
      }
    }
    _fallbackClose = _closingFrame == null;
    _closingBackdropStart = 1;
    setState(() => _phase = _ImageViewerPhase.closing);
    await _transitionController.reverse();
    if (!mounted) return;
    setState(() => _allowPop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _requestSlideClose() async {
    if (_closeInProgress || !mounted) return;
    _closeInProgress = true;
    await _waitForKeyboardToSettle();
    if (!mounted) return;
    await _animateFallbackClose(backdropStart: _dragBackdropOpacity);
  }

  Future<void> _animateFallbackClose({required double backdropStart}) async {
    if (!mounted) return;
    _fallbackClose = true;
    _closingBackdropStart = backdropStart.clamp(0.0, 1.0);
    setState(() => _phase = _ImageViewerPhase.closing);
    await _transitionController.reverse();
    if (!mounted) return;
    setState(() => _allowPop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) Navigator.of(context).pop();
  }

  bool _shouldDismissSlide(
    Offset offset,
    ScaleEndDetails details,
  ) {
    final gestureScale =
        _gestureKeys[_currentIndex]?.currentState?.gestureDetails?.totalScale ??
            _scales[_currentIndex] ??
            1;
    if (_zoomedIndexes.contains(_currentIndex) || gestureScale > 1.001) {
      return false;
    }
    return imageViewerShouldDismiss(
      offset,
      details.velocity.pixelsPerSecond,
    );
  }

  @override
  void dispose() {
    _phase = _ImageViewerPhase.disposed;
    for (final resolution in _pendingImageResolutions.values) {
      resolution.$1.removeListener(resolution.$2);
      if (!resolution.$3.isCompleted) resolution.$3.complete(null);
    }
    _pendingImageResolutions.clear();
    _transitionController
      ..removeListener(_onTransitionTick)
      ..dispose();
    _videoReboundController
      ..removeListener(_onVideoReboundTick)
      ..removeStatusListener(_onVideoReboundStatus)
      ..dispose();
    _pageController.dispose();
    _windowController
      ?..removeListener(_syncWindowItems)
      ..dispose();
    final launchFrame = widget.launchFrame;
    if (launchFrame != null) {
      widget.request.initialAnchor?.showSource(launchFrame.sourceIdentity);
    }
    widget.launchFrame?.dispose();
    _closingFrame?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery =
        MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero);
    final progress = Curves.easeOutCubic.transform(_transitionController.value);
    final backdropOpacity = switch (_phase) {
      _ImageViewerPhase.dragging => _dragBackdropOpacity,
      _ImageViewerPhase.closing when _fallbackClose =>
        _closingBackdropStart * progress,
      _ => progress.clamp(0.0, 1.0),
    };
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: imageViewerSystemUiOverlayStyle,
      child: PopScope<void>(
        canPop: _allowPop,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) unawaited(_requestClose());
        },
        child: MediaQuery(
          data: mediaQuery,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  key: const ValueKey('image-viewer-backdrop'),
                  color: Colors.black.withValues(alpha: backdropOpacity),
                ),
                IgnorePointer(
                  ignoring: _phase == _ImageViewerPhase.opening ||
                      _phase == _ImageViewerPhase.closing,
                  child: _buildGallery(progress),
                ),
                _buildTransition(progress),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGallery(double progress) {
    final showGallery = _phase == _ImageViewerPhase.viewing ||
        _phase == _ImageViewerPhase.dragging ||
        (_phase == _ImageViewerPhase.opening && widget.launchFrame == null) ||
        (_phase == _ImageViewerPhase.closing && _fallbackClose);
    if (!showGallery) return const SizedBox.shrink();
    final gallery = ExtendedImageSlidePage(
      key: _slidePageKey,
      slideAxis: SlideAxis.vertical,
      slideType: SlideType.wholePage,
      slidePageBackgroundHandler: (_, __) => Colors.transparent,
      resetPageDuration: const Duration(milliseconds: 180),
      slideEndHandler: (
        offset, {
        ExtendedImageSlidePageState? state,
        ScaleEndDetails? details,
      }) {
        final dismiss = details != null && _shouldDismissSlide(offset, details);
        if (dismiss) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            unawaited(_requestSlideClose());
          });
        }
        return false;
      },
      onSlidingPage: (state) {
        final next = state.isSliding
            ? _ImageViewerPhase.dragging
            : _ImageViewerPhase.viewing;
        final viewportHeight = MediaQuery.sizeOf(context).height;
        final nextOpacity = state.isSliding && viewportHeight > 0
            ? (1 - (state.offset.dy.abs() / (viewportHeight * 0.65)))
                .clamp(0.15, 1.0)
            : 1.0;
        if (!_closeInProgress &&
            mounted &&
            (_phase != next || _dragBackdropOpacity != nextOpacity)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_closeInProgress) {
              setState(() {
                _phase = next;
                _dragBackdropOpacity = nextOpacity;
              });
            }
          });
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ExtendedImageGesturePageView.builder(
            key: const ValueKey('image-viewer-gallery'),
            controller: _pageController,
            itemCount: _items.length,
            allowImplicitScrolling: false,
            onPageChanged: (index) {
              _videoReboundController.stop();
              setState(() {
                _currentIndex = index;
                _scales[index] = 1;
                _videoDragOffset = 0;
                _dragBackdropOpacity = 1;
                if (_phase == _ImageViewerPhase.dragging) {
                  _phase = _ImageViewerPhase.viewing;
                }
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _gestureKeys[index]?.currentState?.reset();
              });
              _prefetchAround(index);
              unawaited(_windowController?.selectIndex(index));
            },
            itemBuilder: (context, index) => _buildMedia(index),
          ),
          if (_windowController?.olderLoadFailed == true &&
              _currentIndex <= ChatMediaGalleryWindowController.edgeThreshold)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                key: const ValueKey('media-viewer-retry-older'),
                onPressed: _windowController!.retryOlder,
                color: Colors.white70,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ),
          if (_windowController?.newerLoadFailed == true &&
              _currentIndex >=
                  _items.length -
                      1 -
                      ChatMediaGalleryWindowController.edgeThreshold)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                key: const ValueKey('media-viewer-retry-newer'),
                onPressed: _windowController!.retryNewer,
                color: Colors.white70,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ),
        ],
      ),
    );
    if (_phase == _ImageViewerPhase.closing && _fallbackClose) {
      return Opacity(
        opacity: progress,
        child: Transform.scale(
          key: const ValueKey('image-viewer-fallback-close'),
          scale: 0.92 + (0.08 * progress),
          child: gallery,
        ),
      );
    }
    if (_phase == _ImageViewerPhase.opening && widget.launchFrame == null) {
      return Transform.scale(
        key: const ValueKey('image-viewer-fallback-open'),
        scale: 0.96 + (0.04 * progress),
        child: gallery,
      );
    }
    return gallery;
  }

  Widget _buildMedia(int index) {
    final item = _items[index];
    if (item.kind == ChatMediaViewerKind.image) return _buildImage(index);
    final message = item.message;
    if (message == null) return const ColoredBox(color: Colors.black);
    final video = ChatMediaVideoPage(
      key: ValueKey('media-viewer-video-${item.messageId}'),
      active: index == _currentIndex &&
          _phase != _ImageViewerPhase.closing &&
          _phase != _ImageViewerPhase.disposed,
      spaceId: _viewerSpaceId,
      message: message,
      media: item.media,
      posterUrl: item.previewUrl,
      posterSize: _decodedSizes[index] ?? item.previewSize,
      posterProvider: _providers[index] ?? item.previewProvider,
      onClose: () => unawaited(_requestClose()),
      onVerticalDragUpdate:
          index == _currentIndex ? _onVideoVerticalDragUpdate : null,
      onVerticalDragEnd:
          index == _currentIndex ? _onVideoVerticalDragEnd : null,
    );
    final dragOffset = index == _currentIndex ? _videoDragOffset : 0.0;
    return Transform.translate(
      offset: Offset(0, dragOffset),
      child: Transform.scale(
        scale: (1 - dragOffset / 2800).clamp(0.92, 1.0),
        child: video,
      ),
    );
  }

  MediaDiagnosticOperation _imageDiagnostic(ChatMediaViewerItem item) =>
      MediaDiagnosticOperation(
          scope: ref.read(mediaDiagnosticScopeProvider),
          kind: DiagnosticMediaKind.image,
          resource: item.media.url,
          messageId: item.messageId);

  Widget _buildImage(int index) {
    final item = _items[index];
    final provider = _providers[index];
    late final Widget image;
    if (provider == null) {
      image = AppNetworkImage(
        key: ValueKey('viewer-preview-${item.messageId}-${item.previewUrl}'),
        url: item.previewUrl,
        fit: BoxFit.contain,
        cacheInMemory: true,
        placeholderBuilder: (_) => const SizedBox.expand(),
        errorBuilder: (_) => const Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: Colors.white38,
            size: 42,
          ),
        ),
        onImageSize: (size) => _acceptResolvedSize(index, item.messageId, size),
        onImageProviderResolved: (resolved) =>
            _acceptResolvedProvider(index, item.messageId, resolved, null),
      );
    } else {
      final gestureKey = _providerGestureKeys.putIfAbsent(
        (index, provider),
        () => GlobalKey<ExtendedImageGestureState>(),
      );
      _gestureKeys[index] = gestureKey;
      image = MediaImageObserver(
          key: ValueKey(provider),
          provider: provider,
          operation: _imageDiagnostic(item),
          child: ExtendedImage(
            key: ValueKey(provider),
            image: provider,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            enableLoadState: false,
            mode: ExtendedImageMode.gesture,
            enableSlideOutPage: true,
            extendedImageGestureKey: gestureKey,
            initGestureConfigHandler: (_) => GestureConfig(
              minScale: 1,
              animationMinScale: 1,
              maxScale: 4,
              animationMaxScale: 4,
              initialScale: 1,
              inPageView: true,
              cacheGesture: false,
              gestureDetailsIsChanged: (details) {
                final scale = details?.totalScale ?? 1;
                _scales[index] = scale;
                if (scale > 1.001) {
                  _zoomedIndexes.add(index);
                } else if (details?.slidePageOffset == null) {
                  _zoomedIndexes.remove(index);
                }
              },
            ),
            onDoubleTap: (state) {
              _toggleZoom(index, state);
            },
          ));
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (index == _currentIndex &&
                _phase == _ImageViewerPhase.viewing &&
                (_scales[index] ?? 1) <= 1.001) {
              unawaited(_requestClose());
            }
          },
          // Keep single-tap close in the same gesture arena as image zoom.
          // Whichever nested double-tap recognizer wins delegates to the same
          // ExtendedImage gesture state, so the first tap can never close.
          onDoubleTap: () {
            final state = _gestureKeys[index]?.currentState;
            if (state != null) _toggleZoom(index, state);
          },
          child: Padding(
            padding: MediaQuery.viewPaddingOf(context),
            child: AnimatedSwitcher(
              key: ValueKey('image-viewer-safe-viewport-$index'),
              duration: imageViewerOriginalFadeDuration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              layoutBuilder: (currentChild, previousChildren) => Stack(
                fit: StackFit.expand,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              ),
              child: KeyedSubtree(
                key: image.key,
                child: SizedBox.expand(child: image),
              ),
            ),
          ),
        ),
        if (_failedIndexes.contains(index)) _buildRetry(index),
      ],
    );
  }

  Widget _buildRetry(int index) => Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          minimum: const EdgeInsets.only(bottom: 18),
          child: TextButton(
            key: ValueKey('image-viewer-original-retry-$index'),
            onPressed: () => _loadOriginal(index, force: true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
              backgroundColor: Colors.black.withValues(alpha: 0.42),
            ),
            child: const Text('原图加载失败，点击重试'),
          ),
        ),
      );

  Widget _buildTransition(double progress) {
    final frame = _phase == _ImageViewerPhase.closing
        ? _closingFrame
        : widget.launchFrame;
    if (frame == null ||
        (_phase != _ImageViewerPhase.opening &&
            _phase != _ImageViewerPhase.closing)) {
      return const SizedBox.shrink();
    }
    final viewport = MediaQuery.sizeOf(context);
    final destination = imageViewerContainRect(viewport, frame.decodedSize,
        padding: MediaQuery.viewPaddingOf(context));
    return IgnorePointer(
      child: CustomPaint(
        key: const ValueKey('image-viewer-transition-layer'),
        painter: ImagePreviewTransitionPainter(
          image: frame.imageInfo.image,
          progress: progress,
          source: frame.geometry,
          destination: destination,
        ),
        size: viewport,
      ),
    );
  }
}
