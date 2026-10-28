import 'package:flutter/foundation.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';

typedef LocalMediaPageLoader = Future<LocalMediaPage> Function(
  int cursorSeq,
  LocalMediaPageDirection direction,
  int limit,
);

class ChatMediaGalleryWindowController extends ChangeNotifier {
  static const initialSideSize = 15;
  static const pageSize = 20;
  static const edgeThreshold = 3;
  static const maxItems = 61;

  final LocalMediaPageLoader loadPage;
  final List<Message> _items;

  String _currentMessageId;
  bool _hasOlder = true;
  bool _hasNewer = true;
  bool _loadingOlder = false;
  bool _loadingNewer = false;
  bool _olderLoadFailed = false;
  bool _newerLoadFailed = false;
  bool _disposed = false;

  ChatMediaGalleryWindowController({
    required Message initialMessage,
    Iterable<Message> initialMessages = const [],
    required this.loadPage,
  })  : _items = _initialItems(initialMessage, initialMessages),
        _currentMessageId = initialMessage.messageId {
    if (initialMessage.conversationSeq <= 0) {
      _hasOlder = false;
      _hasNewer = false;
    }
  }

  List<Message> get items => List.unmodifiable(_items);
  String get currentMessageId => _currentMessageId;
  int get currentIndex => _items.indexWhere(
        (message) => message.messageId == _currentMessageId,
      );
  bool get olderLoadFailed => _olderLoadFailed;
  bool get newerLoadFailed => _newerLoadFailed;

  Future<void> initialize() async {
    final selectedIndex = currentIndex;
    if (selectedIndex < 0 || _items[selectedIndex].conversationSeq <= 0) return;
    final olderNeeded = initialSideSize - selectedIndex;
    final newerNeeded = initialSideSize - (_items.length - 1 - selectedIndex);
    if (olderNeeded > 0) await _loadOlder(olderNeeded);
    if (newerNeeded > 0) await _loadNewer(newerNeeded);
  }

  Future<void> selectIndex(int index) async {
    if (_disposed || index < 0 || index >= _items.length) return;
    _currentMessageId = _items[index].messageId;
    notifyListeners();
    if (index <= edgeThreshold) await _loadOlder(pageSize);
    final stableIndex = currentIndex;
    if (stableIndex >= 0 && stableIndex >= _items.length - 1 - edgeThreshold) {
      await _loadNewer(pageSize);
    }
  }

  Future<void> retryOlder() => _loadOlder(pageSize);
  Future<void> retryNewer() => _loadNewer(pageSize);

  Future<void> _loadOlder(int limit) async {
    if (_disposed || !_hasOlder || _loadingOlder || _items.isEmpty) return;
    final cursor = _items.first.conversationSeq;
    if (cursor <= 0) return;
    _loadingOlder = true;
    _olderLoadFailed = false;
    try {
      final page = await loadPage(
        cursor,
        LocalMediaPageDirection.older,
        limit,
      );
      if (_disposed) return;
      _hasOlder = page.hasMore;
      _merge(page.items);
    } catch (_) {
      if (_disposed) return;
      _olderLoadFailed = true;
    } finally {
      _loadingOlder = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> _loadNewer(int limit) async {
    if (_disposed || !_hasNewer || _loadingNewer || _items.isEmpty) return;
    final cursor = _items.last.conversationSeq;
    if (cursor <= 0) return;
    _loadingNewer = true;
    _newerLoadFailed = false;
    try {
      final page = await loadPage(
        cursor,
        LocalMediaPageDirection.newer,
        limit,
      );
      if (_disposed) return;
      _hasNewer = page.hasMore;
      _merge(page.items);
    } catch (_) {
      if (_disposed) return;
      _newerLoadFailed = true;
    } finally {
      _loadingNewer = false;
      if (!_disposed) notifyListeners();
    }
  }

  void _merge(Iterable<Message> incoming) {
    final byId = <String, Message>{
      for (final message in _items) message.messageId: message,
      for (final message in incoming) message.messageId: message,
    };
    _items
      ..clear()
      ..addAll(byId.values.where((message) => message.conversationSeq > 0))
      ..sort((a, b) => a.conversationSeq.compareTo(b.conversationSeq));

    final selectedIndex = currentIndex;
    if (_items.length <= maxItems || selectedIndex < 0) return;
    final overflow = _items.length - maxItems;
    if (selectedIndex <= (_items.length - 1) / 2) {
      _items.removeRange(_items.length - overflow, _items.length);
      _hasNewer = true;
    } else {
      _items.removeRange(0, overflow);
      _hasOlder = true;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  static List<Message> _initialItems(
    Message initialMessage,
    Iterable<Message> initialMessages,
  ) {
    final byId = <String, Message>{
      for (final message in initialMessages)
        if (message.conversationId == initialMessage.conversationId &&
            message.conversationSeq > 0)
          message.messageId: message,
      initialMessage.messageId: initialMessage,
    };
    final items = byId.values.toList(growable: true);
    items.sort((a, b) {
      if (a.conversationSeq <= 0) return 1;
      if (b.conversationSeq <= 0) return -1;
      return a.conversationSeq.compareTo(b.conversationSeq);
    });
    return items;
  }
}
