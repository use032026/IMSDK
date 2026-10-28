import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'diagnostic_redactor.dart';
import 'diagnostic_scope.dart';

export 'diagnostic_scope.dart';

enum AppDiagnosticLevel { debug, info, warning, error }

typedef DiagnosticEventListener = void Function(DiagnosticEvent event);

class DiagnosticEvent {
  final DiagnosticScope scope;
  final DateTime timestamp;
  final int sequence;
  final String sessionId;
  final String? traceId;
  final AppDiagnosticLevel level;
  final String category;
  final String message;
  final Map<String, Object?> context;

  const DiagnosticEvent({
    this.scope = DiagnosticScope.unattributed,
    required this.timestamp,
    this.sequence = 0,
    this.sessionId = '',
    this.traceId,
    required this.level,
    required this.category,
    required this.message,
    this.context = const {},
  });

  Map<String, Object?> toJson() => {
        'scope': scope.toJson(),
        'timestamp': timestamp.toUtc().toIso8601String(),
        'sequence': sequence,
        if (sessionId.isNotEmpty) 'sessionId': sessionId,
        if (traceId?.isNotEmpty == true) 'traceId': traceId,
        'level': level.name,
        'category': category,
        'message': message,
        if (context.isNotEmpty) 'context': context,
      };

  factory DiagnosticEvent.fromJson(Map<String, dynamic> json) {
    final scope = json['scope'] as Map<String, dynamic>;
    return DiagnosticEvent(
      scope: DiagnosticScope(
          scope['accountHash'] as String, scope['storageHash'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      sequence: json['sequence'] as int,
      sessionId: json['sessionId'] as String,
      traceId: json['traceId'] as String?,
      level: AppDiagnosticLevel.values.byName(json['level'] as String),
      category: json['category'] as String,
      message: json['message'] as String,
      context: Map<String, Object?>.from(json['context'] as Map? ?? {}),
    );
  }

  @override
  String toString() => '[${level.name}] $category: $message $context';
}

class DiagnosticSnapshot {
  final DateTime exportedAt;
  final String sessionId;
  final List<DiagnosticEvent> events;

  const DiagnosticSnapshot({
    required this.exportedAt,
    required this.sessionId,
    required this.events,
  });

  Map<String, Object?> toJson() => {
        'exportedAt': exportedAt.toIso8601String(),
        'sessionId': sessionId,
        'eventCount': events.length,
        'events': events.map((event) => event.toJson()).toList(),
      };

  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());
}

/// Lightweight in-memory diagnostics buffer.
///
/// This is intentionally dependency-free so networking, Gateway, calls and UI
/// code can record important events without pulling in a logging framework.
class AppDiagnostics {
  static const int _maxEvents = 300;
  static final AppDiagnostics instance = AppDiagnostics._();

  final String sessionId = _newId('session');
  final List<DiagnosticEvent> _events = [];
  final Set<DiagnosticEventListener> _listeners = {};
  final redactor = DiagnosticRedactor();
  DiagnosticScope _activeScope = DiagnosticScope.public;
  int scopeRevision = 0;
  DiagnosticScope get activeScope => _activeScope;
  set activeScope(DiagnosticScope value) {
    _activeScope = value;
    scopeRevision++;
  }

  int _sequence = 0;
  int _traceCounter = 0;

  AppDiagnostics._();

  List<DiagnosticEvent> get events => List.unmodifiable(_events);

  void clear() => _events.clear();

  void clearScope(DiagnosticScope scope) =>
      _events.removeWhere((event) => event.scope == scope);

  String nextTraceId([String prefix = 'trace']) {
    _traceCounter += 1;
    return _newId('$prefix-$_traceCounter');
  }

  DiagnosticSnapshot snapshot({int? last}) {
    final visible =
        _events.where((event) => activeScope.includes(event.scope)).toList();
    final source = last == null || last >= visible.length
        ? visible
        : visible.sublist(visible.length - last);
    return DiagnosticSnapshot(
      exportedAt: DateTime.now(),
      sessionId: sessionId,
      events: List<DiagnosticEvent>.unmodifiable(source),
    );
  }

  String exportPackage({int? last}) => snapshot(last: last).toPrettyJson();

  List<Map<String, Object?>> breadcrumbsBefore(
    DiagnosticEvent event, {
    int limit = 30,
  }) {
    final breadcrumbs = _events
        .where((candidate) =>
            candidate.sequence < event.sequence &&
            candidate.category != 'diagnostics.report' &&
            event.scope.includes(candidate.scope))
        .toList();
    final start = breadcrumbs.length > limit ? breadcrumbs.length - limit : 0;
    return breadcrumbs
        .sublist(start)
        .map((candidate) => candidate.toJson())
        .toList();
  }

  VoidCallback addListener(DiagnosticEventListener listener) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  void debug(
    String category,
    String message, {
    Map<String, Object?> context = const {},
    DiagnosticScope? scope,
  }) =>
      record(AppDiagnosticLevel.debug, category, message,
          context: context, scope: scope);

  void info(
    String category,
    String message, {
    Map<String, Object?> context = const {},
    DiagnosticScope? scope,
  }) =>
      record(AppDiagnosticLevel.info, category, message,
          context: context, scope: scope);

  void warning(
    String category,
    String message, {
    Map<String, Object?> context = const {},
    DiagnosticScope? scope,
  }) =>
      record(AppDiagnosticLevel.warning, category, message,
          context: context, scope: scope);

  void error(
    String category,
    String message, {
    Map<String, Object?> context = const {},
    DiagnosticScope? scope,
  }) =>
      record(AppDiagnosticLevel.error, category, message,
          context: context, scope: scope);

  void record(
    AppDiagnosticLevel level,
    String category,
    String message, {
    Map<String, Object?> context = const {},
    DiagnosticScope? scope,
    String? traceId,
  }) {
    _sequence += 1;
    final event = DiagnosticEvent(
      scope: scope ??
          (category.startsWith('startup.') || category.startsWith('site_line.')
              ? DiagnosticScope.public
              : DiagnosticScope.unattributed),
      timestamp: DateTime.now(),
      sequence: _sequence,
      sessionId: sessionId,
      traceId: redactor.identifier(traceId ?? _traceIdFromContext(context)),
      level: level,
      category: redactor.category(category),
      message: redactor.message(category, message),
      context: redactor.context(context),
    );
    _events.add(event);
    if (_events.length > _maxEvents) {
      _events.removeRange(0, _events.length - _maxEvents);
    }
    debugPrint(event.toString());
    for (final listener in List<DiagnosticEventListener>.of(_listeners)) {
      try {
        listener(event);
      } catch (_) {}
    }
  }

  String? _traceIdFromContext(Map<String, Object?> context) {
    final raw = context['traceId'] ?? context['clientTraceId'];
    final value = raw?.toString();
    return value == null || value.isEmpty ? null : value;
  }

  static String _newId(String prefix) {
    final micros = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    return '$prefix-$micros';
  }
}
