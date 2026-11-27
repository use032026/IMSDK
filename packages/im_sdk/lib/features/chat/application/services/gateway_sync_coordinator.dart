import 'dart:async';

class GatewaySyncTemporarilyUnavailable implements Exception {
  const GatewaySyncTemporarilyUnavailable();
}

typedef _SyncTask = ({
  Future<void> Function() run,
  bool Function()? canRetry,
});

class GatewaySyncCoordinator {
  final Map<String, Future<void>> _inFlight = {};
  final Map<String, _SyncTask> _followUps = {};
  final Map<String, ({Timer timer, Completer<bool> ready})> _backoffs = {};

  Future<void> run({
    required String spaceId,
    required String userId,
    required Future<void> Function() task,
    bool rerunIfRunning = false,
    bool Function()? canRetry,
  }) {
    final normalizedSpaceId = spaceId.trim();
    final normalizedUserId = userId.trim();
    if (normalizedSpaceId.isEmpty || normalizedUserId.isEmpty) {
      throw ArgumentError('A complete space/user identity is required');
    }

    final key = '$normalizedSpaceId::$normalizedUserId';
    final work = (run: task, canRetry: canRetry);
    final running = _inFlight[key];
    if (running != null) {
      if (rerunIfRunning) {
        _followUps[key] = work;
        _finishBackoff(key, retry: false);
      }
      return running;
    }

    Future<void> drain() async {
      var next = work;
      var retryCount = 0;
      while (true) {
        Object? failure;
        StackTrace? failureStack;
        try {
          await next.run();
        } on GatewaySyncTemporarilyUnavailable {
          final canRetry = next.canRetry;
          if (_followUps[key] == null && canRetry != null && canRetry()) {
            final delay =
                Duration(seconds: retryCount >= 5 ? 30 : 1 << retryCount);
            if (retryCount < 5) retryCount++;
            final ready = Completer<bool>();
            final timer = Timer(delay, () => _finishBackoff(key, retry: true));
            _backoffs[key] = (timer: timer, ready: ready);
            if (await ready.future && _followUps[key] == null && canRetry()) {
              continue;
            }
          }
        } catch (error, stack) {
          failure = error;
          failureStack = stack;
        }
        final followUp = _followUps.remove(key);
        if (followUp == null) {
          // Release ownership in the same turn as the final queue check.
          // A reconnect may arrive before the Future completion callbacks.
          _inFlight.remove(key);
          if (failure != null) {
            Error.throwWithStackTrace(failure, failureStack!);
          }
          return;
        }
        next = followUp;
        retryCount = 0;
      }
    }

    final completion = Completer<void>();
    _inFlight[key] = completion.future;
    unawaited(drain().then(completion.complete,
        onError: (Object error, StackTrace stack) =>
            completion.completeError(error, stack)));
    return completion.future;
  }

  void cancelPendingRetries() {
    for (final key in _backoffs.keys.toList()) {
      _finishBackoff(key, retry: false);
    }
  }

  void _finishBackoff(String key, {required bool retry}) {
    final backoff = _backoffs.remove(key);
    if (backoff == null) return;
    backoff.timer.cancel();
    backoff.ready.complete(retry);
  }

  Future<bool> runAfterSuccessfulSync({
    required Future<bool> Function() synchronize,
    required Future<void> Function() onSynchronized,
  }) async {
    if (!await synchronize()) return false;
    await onSynchronized();
    return true;
  }
}
