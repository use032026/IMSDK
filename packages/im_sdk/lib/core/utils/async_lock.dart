import 'dart:async';

/// FIFO critical section for short local persistence mutations.
class AsyncLock {
  Future<void> _tail = Future<void>.value();

  Future<T> synchronized<T>(Future<T> Function() action) {
    final ready = _tail;
    final released = Completer<void>();
    _tail = ready.then((_) => released.future);
    return ready.then((_) => action()).whenComplete(released.complete);
  }
}
