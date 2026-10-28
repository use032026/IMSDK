import 'dart:async';

class GatewaySyncCoordinator {
  final Map<String, Future<void>> _inFlight = {};
  final Map<String, Future<void> Function()> _followUps = {};

  Future<void> run({
    required String spaceId,
    required String userId,
    required Future<void> Function() task,
    bool rerunIfRunning = false,
  }) {
    final normalizedSpaceId = spaceId.trim();
    final normalizedUserId = userId.trim();
    if (normalizedSpaceId.isEmpty || normalizedUserId.isEmpty) {
      throw ArgumentError('A complete space/user identity is required');
    }

    final key = '$normalizedSpaceId::$normalizedUserId';
    final running = _inFlight[key];
    if (running != null) {
      if (rerunIfRunning) _followUps[key] = task;
      return running;
    }

    Future<void> drain() async {
      var next = task;
      while (true) {
        Object? failure;
        StackTrace? failureStack;
        try {
          await next();
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
      }
    }

    final completion = Completer<void>();
    _inFlight[key] = completion.future;
    unawaited(drain().then(completion.complete,
        onError: (Object error, StackTrace stack) =>
            completion.completeError(error, stack)));
    return completion.future;
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
