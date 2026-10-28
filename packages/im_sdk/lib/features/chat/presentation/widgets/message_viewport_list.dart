import 'package:flutter/material.dart';

typedef MessageViewportChanged = void Function(
  List<String> visibleMessageIds,
  bool isScrolling,
);

/// A lazily built message list that reports only items intersecting its
/// viewport. Cached but off-screen children are deliberately excluded.
class MessageViewportList extends StatefulWidget {
  final List<String> itemIds;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollController scrollController;
  final EdgeInsetsGeometry? padding;
  final bool reverse;
  final MessageViewportChanged onViewportChanged;

  const MessageViewportList({
    super.key,
    required this.itemIds,
    required this.itemBuilder,
    required this.scrollController,
    required this.onViewportChanged,
    this.padding,
    this.reverse = false,
  });

  @override
  State<MessageViewportList> createState() => _MessageViewportListState();
}

class _MessageViewportListState extends State<MessageViewportList> {
  final GlobalKey _viewportKey = GlobalKey();
  final Map<String, GlobalKey> _itemKeys = {};
  List<String> _lastVisibleIds = const [];
  bool _lastReportedScrolling = false;
  bool _isScrolling = false;
  bool _measureScheduled = false;
  Map<String, double> _previousVisibleTops = const {};
  double? _previousPixels;
  Size? _previousViewportSize;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScrollPositionChanged);
    _scheduleMeasure();
  }

  @override
  void didUpdateWidget(covariant MessageViewportList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScrollPositionChanged);
      widget.scrollController.addListener(_onScrollPositionChanged);
    }
    if (oldWidget.scrollController != widget.scrollController ||
        oldWidget.reverse != widget.reverse) {
      _previousVisibleTops = const {};
      _previousPixels = null;
    }
    final retainedIds = widget.itemIds.toSet();
    _itemKeys.removeWhere((id, _) => !retainedIds.contains(id));
    _scheduleMeasure();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollPositionChanged);
    super.dispose();
  }

  void _onScrollPositionChanged() => _scheduleMeasure();

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification ||
        notification is ScrollUpdateNotification ||
        notification is OverscrollNotification) {
      _isScrolling = true;
    } else if (notification is ScrollEndNotification) {
      _isScrolling = false;
    }
    _scheduleMeasure();
    return false;
  }

  void _scheduleMeasure() {
    if (_measureScheduled) return;
    _measureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      if (mounted) _measureVisibleItems();
    });
  }

  void _measureVisibleItems() {
    final viewportBox =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewportBox == null || !viewportBox.hasSize) return;

    final viewportOrigin = viewportBox.localToGlobal(Offset.zero);
    final viewportRect = viewportOrigin & viewportBox.size;
    final visible = <({String id, double top})>[];
    for (final entry in _itemKeys.entries) {
      final itemBox =
          entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (itemBox == null || !itemBox.attached || !itemBox.hasSize) continue;
      final itemOrigin = itemBox.localToGlobal(Offset.zero);
      final itemRect = itemOrigin & itemBox.size;
      if (viewportRect.overlaps(itemRect)) {
        visible.add((id: entry.key, top: itemRect.top));
      }
    }
    visible.sort((a, b) => a.top.compareTo(b.top));
    if (_preserveVisibleAnchor(visible, viewportRect)) return;
    final visibleIds = visible.map((item) => item.id).toList(growable: false);
    if (_sameIds(visibleIds, _lastVisibleIds) &&
        _isScrolling == _lastReportedScrolling) {
      return;
    }
    _lastVisibleIds = visibleIds;
    _lastReportedScrolling = _isScrolling;
    widget.onViewportChanged(visibleIds, _isScrolling);
  }

  bool _preserveVisibleAnchor(
    List<({String id, double top})> visible,
    Rect viewportRect,
  ) {
    if (!widget.scrollController.hasClients) return false;
    final position = widget.scrollController.position;
    if (!position.hasContentDimensions) return false;
    final pixels = position.pixels;
    final tops = {
      for (final item in visible) item.id: item.top - viewportRect.top,
    };
    // At the bottom of a reversed chat, a new row should stay visible instead
    // of moving the viewport to keep an older row at its previous position.
    final atLatestEdge =
        widget.reverse && pixels <= position.minScrollExtent + 1;
    if (_previousPixels != null &&
        !atLatestEdge &&
        _previousViewportSize == viewportRect.size) {
      // For a reversed list, a scroll offset delta moves a row by the same
      // delta on screen. An additional displacement is a row-height change,
      // often from a decoded media thumbnail without stored dimensions.
      final direction = widget.reverse ? 1.0 : -1.0;
      for (final entry in _previousVisibleTops.entries) {
        final currentTop = tops[entry.key];
        if (currentTop == null) continue;
        final expectedTop =
            entry.value + direction * (pixels - _previousPixels!);
        final layoutShift = currentTop - expectedTop;
        if (layoutShift.abs() > 1) {
          final target = (pixels - direction * layoutShift)
              .clamp(position.minScrollExtent, position.maxScrollExtent)
              .toDouble();
          if ((target - pixels).abs() > 1) {
            _previousPixels = pixels;
            _previousVisibleTops = tops;
            position.jumpTo(target);
            _scheduleMeasure();
            return true;
          }
        }
        break;
      }
    }
    _previousPixels = pixels;
    _previousVisibleTops = tops;
    _previousViewportSize = viewportRect.size;
    return false;
  }

  bool _sameIds(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _scheduleMeasure();
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _scheduleMeasure();
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: SizedBox.expand(
          key: _viewportKey,
          child: ListView.builder(
            controller: widget.scrollController,
            reverse: widget.reverse,
            padding: widget.padding,
            itemCount: widget.itemIds.length,
            itemBuilder: (context, index) {
              final id = widget.itemIds[index];
              final itemKey = _itemKeys.putIfAbsent(id, GlobalKey.new);
              return SizeChangedLayoutNotifier(
                key: itemKey,
                child: widget.itemBuilder(context, index),
              );
            },
          ),
        ),
      ),
    );
  }
}
