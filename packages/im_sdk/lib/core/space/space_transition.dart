import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SpaceTransitionPhase { idle, preparing, activating, failed }

class SpaceTransitionState {
  const SpaceTransitionState._({
    required this.phase,
    required this.revision,
    this.targetSpaceId,
    this.error,
  });

  const SpaceTransitionState.idle()
      : this._(phase: SpaceTransitionPhase.idle, revision: 0);

  final SpaceTransitionPhase phase;
  final String? targetSpaceId;
  final int revision;
  final Object? error;

  bool get isInProgress =>
      phase == SpaceTransitionPhase.preparing ||
      phase == SpaceTransitionPhase.activating;
}

final spaceTransitionProvider =
    NotifierProvider<SpaceTransitionNotifier, SpaceTransitionState>(
  SpaceTransitionNotifier.new,
);

class SpaceTransitionNotifier extends Notifier<SpaceTransitionState> {
  int _revision = 0;
  final _completions = <int, Completer<void>>{};

  @override
  SpaceTransitionState build() => const SpaceTransitionState.idle();

  int begin(String targetSpaceId) {
    final target = targetSpaceId.trim();
    if (target.isEmpty) throw ArgumentError.value(targetSpaceId);
    final revision = ++_revision;
    for (final completion in _completions.values) {
      if (!completion.isCompleted) completion.complete();
    }
    _completions.clear();
    _completions[revision] = Completer<void>();
    state = SpaceTransitionState._(
      phase: SpaceTransitionPhase.preparing,
      targetSpaceId: target,
      revision: revision,
    );
    return revision;
  }

  void markActivating(int revision) {
    if (state.revision != revision || !state.isInProgress) return;
    state = SpaceTransitionState._(
      phase: SpaceTransitionPhase.activating,
      targetSpaceId: state.targetSpaceId,
      revision: revision,
    );
  }

  void complete(int revision) {
    if (state.revision != revision) return;
    _completions.remove(revision)?.complete();
    state = SpaceTransitionState._(
      phase: SpaceTransitionPhase.idle,
      revision: revision,
    );
  }

  void fail(int revision, Object error) {
    if (state.revision != revision) return;
    _completions.remove(revision)?.complete();
    state = SpaceTransitionState._(
      phase: SpaceTransitionPhase.failed,
      targetSpaceId: state.targetSpaceId,
      revision: revision,
      error: error,
    );
  }

  Future<void> waitFor(int revision) =>
      _completions[revision]?.future ?? Future<void>.value();

  void clearFailure() {
    if (state.phase != SpaceTransitionPhase.failed) return;
    state = SpaceTransitionState._(
      phase: SpaceTransitionPhase.idle,
      revision: state.revision,
    );
  }

  void cancel() {
    for (final completion in _completions.values) {
      if (!completion.isCompleted) completion.complete();
    }
    _completions.clear();
    state = SpaceTransitionState._(
      phase: SpaceTransitionPhase.idle,
      revision: ++_revision,
    );
  }
}
