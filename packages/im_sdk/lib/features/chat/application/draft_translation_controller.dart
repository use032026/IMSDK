import 'dart:async';

import 'package:im_sdk/features/chat/application/auto_translation_coordinator.dart';
import 'package:im_sdk/features/chat/domain/services/auto_translation_policy.dart';

enum DraftTranslationStatus { idle, waiting, loading, success, empty, failed }

class DraftTranslationState {
  const DraftTranslationState({
    this.scopeKey = '',
    this.source = '',
    this.targetLanguage,
    this.status = DraftTranslationStatus.idle,
    this.text = '',
    this.error,
  });

  final String scopeKey;
  final String source;
  final String? targetLanguage;
  final DraftTranslationStatus status;
  final String text;
  final Object? error;

  bool canSend(String scopeKey, String source) =>
      this.scopeKey == scopeKey &&
      this.source == source.trim() &&
      status == DraftTranslationStatus.success &&
      text.isNotEmpty;
}

typedef DraftTranslationExecutor = Future<String?> Function(
  String source,
  String targetLanguage,
  AutoTranslationCancellation cancellation,
);

abstract interface class DraftTranslationSelectionRepository {
  Map<String, String> load();
  Future<void> save(Map<String, String> selections);
}

class DraftTranslationSelectionStore {
  DraftTranslationSelectionStore(
      {DraftTranslationSelectionRepository? repository})
      : _repository = repository,
        _targets = repository?.load() ?? <String, String>{};

  final DraftTranslationSelectionRepository? _repository;
  final Map<String, String> _targets;
  Future<void> _lastWrite = Future<void>.value();

  String? get(String scopeKey) => _targets[scopeKey];

  Future<void> set(String scopeKey, String language) =>
      _mutate((next) => next[scopeKey] = language);

  Future<void> remove(String scopeKey) =>
      _mutate((next) => next.remove(scopeKey));

  Future<void> _mutate(void Function(Map<String, String>) change) {
    final repository = _repository;
    final write = _lastWrite.then((_) async {
      final next = Map<String, String>.from(_targets);
      change(next);
      if (repository != null) await repository.save(next);
      _targets
        ..clear()
        ..addAll(next);
    });
    _lastWrite = write.catchError((Object _) {});
    return write;
  }
}

/// Owns only the transient translation of the current draft, never the draft.
class DraftTranslationController {
  DraftTranslationController({
    required DraftTranslationExecutor executor,
    required void Function(DraftTranslationState) onChanged,
    this.debounce = const Duration(milliseconds: 500),
    DraftTranslationSelectionStore? selections,
  })  : _executor = executor,
        _onChanged = onChanged,
        _selections = selections ?? DraftTranslationSelectionStore();

  final DraftTranslationExecutor _executor;
  final void Function(DraftTranslationState) _onChanged;
  final DraftTranslationSelectionStore _selections;
  final Duration debounce;
  final Map<String, String> _cache = {};

  DraftTranslationState state = const DraftTranslationState();
  String _sessionKey = '';
  Timer? _timer;
  AutoTranslationCancellation? _request;
  int _version = 0;
  int _selectionVersion = 0;
  bool _composing = false;
  bool _disposed = false;

  void update({
    required String scopeKey,
    required String source,
    required bool composing,
    String sessionKey = '',
  }) {
    if (_disposed) return;
    final nextScope = scopeKey.trim();
    final nextSource = source.trim();
    final sessionChanged = _sessionKey != sessionKey;
    final scopeChanged = state.scopeKey != nextScope || sessionChanged;
    if (!scopeChanged &&
        state.source == nextSource &&
        _composing == composing) {
      return;
    }

    _cancelPending();
    if (scopeChanged) _selectionVersion++;
    if (sessionChanged) {
      _cache.clear();
    }
    _sessionKey = sessionKey;
    _composing = composing;
    final target =
        scopeChanged ? _selections.get(nextScope) : state.targetLanguage;
    _publish(DraftTranslationState(
      scopeKey: nextScope,
      source: nextSource,
      targetLanguage: target,
      status: target != null && nextSource.isNotEmpty
          ? DraftTranslationStatus.waiting
          : DraftTranslationStatus.idle,
    ));
    if (target != null && nextSource.isNotEmpty && !composing) {
      _schedule(scopeChanged ? Duration.zero : debounce);
    }
  }

  Future<void> selectTarget(String targetLanguage) async {
    if (_disposed ||
        state.scopeKey.isEmpty ||
        !AutoTranslationPolicy.supportedTargetLanguages
            .contains(targetLanguage)) {
      return;
    }
    final scopeKey = state.scopeKey;
    final sessionKey = _sessionKey;
    final selectionVersion = ++_selectionVersion;
    _cancelPending();
    final previousTarget = _selections.get(scopeKey);
    _publish(DraftTranslationState(
      scopeKey: scopeKey,
      source: state.source,
      targetLanguage: previousTarget,
      status: previousTarget == null || state.source.isEmpty
          ? DraftTranslationStatus.idle
          : DraftTranslationStatus.waiting,
    ));
    try {
      await _selections.set(scopeKey, targetLanguage);
    } catch (_) {
      if (!_disposed &&
          selectionVersion == _selectionVersion &&
          state.scopeKey == scopeKey &&
          _sessionKey == sessionKey) {
        _resumeSelectedTarget(scopeKey);
      }
      rethrow;
    }
    if (_disposed ||
        selectionVersion != _selectionVersion ||
        state.scopeKey != scopeKey ||
        _sessionKey != sessionKey) {
      return;
    }
    _cancelPending();
    _publish(DraftTranslationState(
      scopeKey: scopeKey,
      source: state.source,
      targetLanguage: targetLanguage,
      status: state.source.isEmpty
          ? DraftTranslationStatus.idle
          : DraftTranslationStatus.waiting,
    ));
    if (state.source.isNotEmpty && !_composing) _schedule(Duration.zero);
  }

  void retry() {
    if (state.targetLanguage == null || state.source.isEmpty || _composing) {
      return;
    }
    _cancelPending();
    _publish(DraftTranslationState(
      scopeKey: state.scopeKey,
      source: state.source,
      targetLanguage: state.targetLanguage,
      status: DraftTranslationStatus.waiting,
    ));
    _schedule(Duration.zero);
  }

  Future<void> close() async {
    final scopeKey = state.scopeKey;
    final sessionKey = _sessionKey;
    final selectionVersion = ++_selectionVersion;
    _cancelPending();
    _publish(DraftTranslationState(scopeKey: scopeKey, source: state.source));
    try {
      await _selections.remove(scopeKey);
    } catch (_) {
      if (!_disposed &&
          selectionVersion == _selectionVersion &&
          state.scopeKey == scopeKey &&
          _sessionKey == sessionKey) {
        _resumeSelectedTarget(scopeKey);
      }
      rethrow;
    }
  }

  void _resumeSelectedTarget(String scopeKey) {
    _cancelPending();
    final target = _selections.get(scopeKey);
    _publish(DraftTranslationState(
      scopeKey: scopeKey,
      source: state.source,
      targetLanguage: target,
      status: target == null || state.source.isEmpty
          ? DraftTranslationStatus.idle
          : DraftTranslationStatus.waiting,
    ));
    if (target != null && state.source.isNotEmpty && !_composing) {
      _schedule(Duration.zero);
    }
  }

  void dispose() {
    _disposed = true;
    _cancelPending();
  }

  void _schedule(Duration delay) {
    _timer = Timer(delay, () {
      _timer = null;
      unawaited(_translate());
    });
  }

  Future<void> _translate() async {
    final source = state.source;
    final target = state.targetLanguage;
    if (_disposed || _composing || source.isEmpty || target == null) return;
    final cacheKey = '${state.scopeKey}\u0000$target\u0000$source';
    final cached = _cache[cacheKey];
    if (cached != null) {
      _publish(DraftTranslationState(
        scopeKey: state.scopeKey,
        source: source,
        targetLanguage: target,
        status: DraftTranslationStatus.success,
        text: cached,
      ));
      return;
    }

    final request = AutoTranslationCancellation();
    final version = ++_version;
    _request = request;
    _publish(DraftTranslationState(
      scopeKey: state.scopeKey,
      source: source,
      targetLanguage: target,
      status: DraftTranslationStatus.loading,
    ));
    try {
      final translated = (await _executor(source, target, request))?.trim();
      if (_disposed || request.isCancelled || version != _version) return;
      if (translated == null || translated.isEmpty) {
        _publish(DraftTranslationState(
          scopeKey: state.scopeKey,
          source: source,
          targetLanguage: target,
          status: DraftTranslationStatus.empty,
        ));
        return;
      }
      _cache[cacheKey] = translated;
      if (_cache.length > 100) _cache.remove(_cache.keys.first);
      _publish(DraftTranslationState(
        scopeKey: state.scopeKey,
        source: source,
        targetLanguage: target,
        status: DraftTranslationStatus.success,
        text: translated,
      ));
    } catch (error) {
      if (_disposed || request.isCancelled || version != _version) return;
      _publish(DraftTranslationState(
        scopeKey: state.scopeKey,
        source: source,
        targetLanguage: target,
        status: DraftTranslationStatus.failed,
        error: error,
      ));
    } finally {
      if (identical(_request, request)) _request = null;
      request.dispose();
    }
  }

  void _cancelPending() {
    _version++;
    _timer?.cancel();
    _timer = null;
    _request?.cancel();
    _request = null;
  }

  void _publish(DraftTranslationState next) {
    if (_disposed) return;
    state = next;
    _onChanged(next);
  }
}
