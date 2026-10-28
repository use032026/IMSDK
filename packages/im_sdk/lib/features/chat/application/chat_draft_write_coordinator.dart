import 'dart:async';

class ChatDraftWriteCoordinator {
  final Map<String, Future<void>> _tails = {};
  final Map<String, int> _revisions = {};

  int revision(String scopeKey) => _revisions[scopeKey] ?? 0;

  void markChanged(String scopeKey) {
    _revisions[scopeKey] = revision(scopeKey) + 1;
  }

  Future<void> run(String scopeKey, Future<void> Function() operation) {
    final previous = _tails[scopeKey] ?? Future<void>.value();
    final current = previous.then<void>((_) => operation(),
        onError: (_, __) => operation());
    late final Future<void> settled;
    settled = current
        .then<void>(
      (_) {},
      onError: (_, __) {},
    )
        .whenComplete(() {
      if (identical(_tails[scopeKey], settled)) {
        _tails.remove(scopeKey);
      }
    });
    _tails[scopeKey] = settled;
    return current;
  }
}
