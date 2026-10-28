import 'dart:async';
import 'dart:collection';

import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/services/auto_translation_policy.dart';

typedef AutoTranslationExecutor = Future<void> Function(
  Message message,
  String targetLanguage,
  AutoTranslationCancellation cancellation,
);

/// Cancellation boundary kept independent from Dio and the presentation layer.
class AutoTranslationCancellation {
  bool _isCancelled = false;
  final List<void Function()> _listeners = [];

  bool get isCancelled => _isCancelled;

  void onCancel(void Function() listener) {
    if (_isCancelled) {
      listener();
      return;
    }
    _listeners.add(listener);
  }

  void cancel() {
    if (_isCancelled) return;
    _isCancelled = true;
    final listeners = List<void Function()>.from(_listeners);
    _listeners.clear();
    for (final listener in listeners) {
      listener();
    }
  }

  void dispose() => _listeners.clear();
}

/// Application owner for viewport-scoped automatic translation.
///
/// The coordinator never owns messages. It only schedules work from the latest
/// chat snapshot and cancels tasks as soon as their message leaves the viewport.
class AutoTranslationCoordinator {
  AutoTranslationCoordinator({
    required AutoTranslationExecutor executor,
    AutoTranslationPolicy policy = const AutoTranslationPolicy(),
  })  : _executor = executor,
        _policy = policy;

  final AutoTranslationExecutor _executor;
  final AutoTranslationPolicy _policy;
  final Map<String, _ActiveTranslation> _active = {};
  final Map<String, String> _attemptedMessageIds = {};
  final Queue<String> _priorityMessageIds = Queue<String>();

  String _scopeKey = '';
  String _targetLanguage = 'zh-CN';
  String _currentUserId = '';
  bool _enabled = false;
  bool _isScrolling = false;
  bool _disposed = false;
  Map<String, Message> _messagesById = const {};
  List<String> _visibleMessageIds = const [];
  Set<String> _visibleMessageIdSet = const {};

  int get activeCount => _active.length;

  void update({
    required String scopeKey,
    required bool enabled,
    required String targetLanguage,
    required String currentUserId,
    required List<Message> messages,
    required List<String> visibleMessageIds,
    required bool isScrolling,
  }) {
    if (_disposed) return;

    final nextTarget = _policy.normalizeTargetLanguage(targetLanguage);
    final scopeOrTargetChanged =
        _scopeKey != scopeKey || _targetLanguage != nextTarget;
    final previousVisible = _visibleMessageIdSet;
    final nextVisible = visibleMessageIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet();

    _scopeKey = scopeKey.trim();
    _targetLanguage = nextTarget;
    _currentUserId = currentUserId.trim();
    _enabled = enabled && _scopeKey.isNotEmpty;
    _isScrolling = isScrolling;
    _messagesById = {
      for (final message in messages)
        if (message.messageId.trim().isNotEmpty)
          message.messageId.trim(): message,
    };
    _visibleMessageIds = visibleMessageIds
        .map((id) => id.trim())
        .where((id) => nextVisible.contains(id))
        .toList(growable: false);
    _visibleMessageIdSet = nextVisible;

    if (scopeOrTargetChanged) {
      _attemptedMessageIds.clear();
      _priorityMessageIds.clear();
      _priorityMessageIds.addAll(_visibleMessageIds);
    } else {
      _attemptedMessageIds.removeWhere(
        (_, messageId) => !nextVisible.contains(messageId),
      );
      for (final messageId in _visibleMessageIds.reversed) {
        if (!previousVisible.contains(messageId)) {
          _priorityMessageIds.addFirst(messageId);
        }
      }
    }

    _cancelInvalidActiveTasks();
    if (!_enabled) {
      _priorityMessageIds.clear();
      return;
    }
    _drain();
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    for (final task in _active.values) {
      task.cancellation.cancel();
    }
    _active.clear();
    _attemptedMessageIds.clear();
    _priorityMessageIds.clear();
  }

  int get _maxConcurrentTasks {
    if (_isScrolling) return 1;
    return _visibleMessageIds.length <= 6 ? 2 : 1;
  }

  void _cancelInvalidActiveTasks() {
    for (final task in _active.values) {
      final stillValid = _enabled &&
          task.scopeKey == _scopeKey &&
          task.targetLanguage == _targetLanguage &&
          _visibleMessageIdSet.contains(task.messageId);
      if (!stillValid) task.cancellation.cancel();
    }
  }

  void _drain() {
    if (_disposed || !_enabled) return;
    final temporarilySkippedMessageIds = <String>{};
    while (_active.length < _maxConcurrentTasks) {
      final messageId = _nextCandidateMessageId(temporarilySkippedMessageIds);
      if (messageId == null) return;
      final message = _messagesById[messageId];
      if (message == null) {
        _attemptedMessageIds[_taskKey(messageId)] = messageId;
        continue;
      }
      if (message.isTranslating) {
        temporarilySkippedMessageIds.add(messageId);
        continue;
      }
      if (!_policy.shouldTranslate(
        message: message,
        targetLanguage: _targetLanguage,
        currentUserId: _currentUserId,
      )) {
        _attemptedMessageIds[_taskKey(messageId)] = messageId;
        continue;
      }

      final taskKey = _taskKey(messageId);
      final cancellation = AutoTranslationCancellation();
      _attemptedMessageIds[taskKey] = messageId;
      _active[taskKey] = _ActiveTranslation(
        scopeKey: _scopeKey,
        messageId: messageId,
        targetLanguage: _targetLanguage,
        cancellation: cancellation,
      );
      unawaited(_execute(taskKey, message, cancellation));
    }
  }

  String? _nextCandidateMessageId(Set<String> excludedMessageIds) {
    while (_priorityMessageIds.isNotEmpty) {
      final messageId = _priorityMessageIds.removeFirst();
      if (!excludedMessageIds.contains(messageId) &&
          _isPendingCandidate(messageId)) {
        return messageId;
      }
    }
    for (final messageId in _visibleMessageIds) {
      if (!excludedMessageIds.contains(messageId) &&
          _isPendingCandidate(messageId)) {
        return messageId;
      }
    }
    return null;
  }

  bool _isPendingCandidate(String messageId) {
    final taskKey = _taskKey(messageId);
    return _visibleMessageIdSet.contains(messageId) &&
        !_active.containsKey(taskKey) &&
        !_attemptedMessageIds.containsKey(taskKey);
  }

  String _taskKey(String messageId) =>
      '$_scopeKey\u0000$messageId\u0000$_targetLanguage';

  Future<void> _execute(
    String taskKey,
    Message message,
    AutoTranslationCancellation cancellation,
  ) async {
    try {
      if (!cancellation.isCancelled) {
        await _executor(message, _targetFromTask(taskKey), cancellation);
      }
    } catch (_) {
      // The UI executor owns user-facing failures. A failed item must not
      // poison the viewport queue or surface as an unhandled async error.
    } finally {
      cancellation.dispose();
      _active.remove(taskKey);
      _drain();
    }
  }

  String _targetFromTask(String taskKey) => taskKey.split('\u0000').last;
}

class _ActiveTranslation {
  final String scopeKey;
  final String messageId;
  final String targetLanguage;
  final AutoTranslationCancellation cancellation;

  const _ActiveTranslation({
    required this.scopeKey,
    required this.messageId,
    required this.targetLanguage,
    required this.cancellation,
  });
}
