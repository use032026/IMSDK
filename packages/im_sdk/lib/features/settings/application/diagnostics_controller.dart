import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/diagnostics/diagnostic_runtime.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/core/diagnostics/diagnostic_share.dart';

enum DiagnosticAction {
  idle,
  loading,
  sharing,
  completed,
  cancelled,
  unconfirmed,
  failed
}

class DiagnosticsView {
  const DiagnosticsView(
      {this.action = DiagnosticAction.idle,
      this.range = const Duration(hours: 24),
      this.count = 0,
      this.first,
      this.last,
      this.persistent = false});
  final DiagnosticAction action;
  final Duration range;
  final int count;
  final DateTime? first;
  final DateTime? last;
  final bool persistent;
  bool get busy =>
      action == DiagnosticAction.loading || action == DiagnosticAction.sharing;
}

final diagnosticsControllerProvider =
    StateNotifierProvider.autoDispose<DiagnosticsController, DiagnosticsView>(
        (ref) {
  final session = ref.watch(activeAccountSessionProvider);
  final scope = session == null
      ? DiagnosticScope.public
      : DiagnosticScope.account(session.scope);
  return DiagnosticsController(
      scope: scope, runtime: DiagnosticRuntime.instance);
});

/// Owns export authorization and feedback; pages never read the global buffer.
class DiagnosticsController extends StateNotifier<DiagnosticsView> {
  DiagnosticsController(
      {required this.scope,
      required this.runtime,
      this.share = const SystemDiagnosticFileShare()})
      : super(const DiagnosticsView()) {
    refresh();
  }
  final DiagnosticScope scope;
  final DiagnosticRuntime runtime;
  final DiagnosticFileShare share;
  File? _file;

  Future<void> refresh([Duration? range]) async {
    final selected = range ?? state.range;
    state = DiagnosticsView(action: DiagnosticAction.loading, range: selected);
    try {
      final events = await runtime.read(scope, selected);
      if (!mounted) return;
      _file = null;
      state = DiagnosticsView(
          range: selected,
          count: events.length,
          first: events.isEmpty ? null : events.first.timestamp,
          last: events.isEmpty ? null : events.last.timestamp,
          persistent: runtime.persistent);
    } catch (_) {
      if (mounted) {
        state =
            DiagnosticsView(action: DiagnosticAction.failed, range: selected);
      }
    }
  }

  Future<void> exportAndShare(Rect origin) async {
    if (state.busy) return;
    final previous = state;
    state = DiagnosticsView(
        action: DiagnosticAction.sharing,
        range: previous.range,
        count: previous.count,
        first: previous.first,
        last: previous.last,
        persistent: previous.persistent);
    var action = DiagnosticAction.failed;
    try {
      final file = _file ??= await runtime.export(scope, previous.range);
      if (!mounted) return;
      runtime.authorizeShare(file, scope);
      final result = await share.share(file, origin);
      action = switch (result) {
        DiagnosticShareOutcome.completed => DiagnosticAction.completed,
        DiagnosticShareOutcome.cancelled => DiagnosticAction.cancelled,
        DiagnosticShareOutcome.unconfirmed => DiagnosticAction.unconfirmed,
      };
    } catch (_) {}
    if (!mounted) return;
    state = DiagnosticsView(
        action: action,
        range: previous.range,
        count: previous.count,
        first: previous.first,
        last: previous.last,
        persistent: runtime.persistent);
  }

  Future<void> clear() async {
    if (state.busy) return;
    state =
        DiagnosticsView(action: DiagnosticAction.loading, range: state.range);
    try {
      await runtime.clear(scope);
      await refresh();
    } catch (_) {
      if (mounted) {
        state = DiagnosticsView(
            action: DiagnosticAction.failed, range: state.range);
      }
    }
  }
}
