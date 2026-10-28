import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:im_sdk/core/privacy/privacy_consent_service.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'app_diagnostics.dart';
import 'diagnostic_redactor.dart';
import 'diagnostic_store.dart';

/// Platform storage and export lifecycle. Never changes authentication state.
class DiagnosticRuntime {
  static final instance = DiagnosticRuntime();
  DiagnosticRuntime();
  DiagnosticStore? _store;
  Future<void>? _initializing;
  void Function()? _removeListener;
  final _metadata = <String, Object?>{};
  final _exports = <String, DiagnosticScope>{};
  bool get persistent => _store != null && !_store!.writeFailed;
  int get dropped => _store?.dropped ?? 0;
  int get corrupt => _store?.corrupt ?? 0;

  Future<void> initialize() =>
      _initializing ??= _initialize().catchError((Object error) {
        _initializing = null;
        throw error;
      });

  Future<void> _initialize() async {
    final decision =
        await const PlatformPrivacyConsentStore().currentPolicyDecision();
    if (decision != PrivacyConsentDecision.accepted) {
      throw StateError('diagnostics consent unavailable');
    }
    final Directory root;
    if (Platform.isIOS) {
      final path = await const MethodChannel('im_sdk/diagnostics_storage')
          .invokeMethod<String>('prepare');
      if (path == null) throw StateError('diagnostics directory unavailable');
      root = Directory(path);
    } else {
      root = Directory(p.join(
          (await getApplicationSupportDirectory()).path, 'diagnostics', 'v1'));
    }
    final storage = SecureStorageServiceImpl();
    var encoded = await storage.read('diagnostics_encryption_key_v1');
    if (encoded == null) {
      final random = Random.secure();
      encoded = base64Encode(List.generate(32, (_) => random.nextInt(256)));
      await storage.write('diagnostics_encryption_key_v1', encoded);
    }
    final key = base64Decode(encoded);
    if (key.length != 32) throw StateError('diagnostics key unavailable');
    final store = DiagnosticStore(root: root, key: key);
    // Attach only after initialization succeeds; retry cannot duplicate writers.
    _store = store;
    _removeListener = AppDiagnostics.instance.addListener(store.enqueue);
    for (final event in AppDiagnostics.instance.events) {
      store.enqueue(event);
    }
    try {
      final info = await PackageInfo.fromPlatform();
      _metadata.addAll(
          {'appVersion': info.version, 'buildNumber': info.buildNumber});
    } catch (_) {}
    _metadata.addAll({
      'platform': Platform.operatingSystem,
      'systemVersion': Platform.operatingSystemVersion,
      'locale': Platform.localeName
    });
    try {
      await cleanupExports();
    } catch (_) {
      // An old staging file must not create duplicate writers on init retry.
    }
  }

  Future<void> flush() async {
    await _store?.flush();
  }

  Future<List<DiagnosticEvent>> read(
      DiagnosticScope scope, Duration range) async {
    await initialize();
    _check(scope);
    final events = await _store!.read(scope, range);
    _check(scope);
    return events;
  }

  void _check(DiagnosticScope scope) {
    if (scope != AppDiagnostics.instance.activeScope || !scope.isAttributed) {
      throw StateError('diagnostics scope changed');
    }
  }

  Future<File> export(DiagnosticScope scope, Duration range) async {
    final events = await read(scope, range);
    final directory = await _exportDirectory();
    await directory.create(recursive: true);
    _check(scope);
    final now = DateTime.now();
    final file = File(p.join(directory.path,
        'diagnostics_${now.toUtc().microsecondsSinceEpoch}.json'));
    final sink = file.openWrite();
    var bytes = 0;
    var omitted = 0;
    // The latest events have priority when the readable export exceeds 10 MB.
    final selected = <String>[];
    for (final event in events.reversed) {
      final clean = DiagnosticEvent(
        scope: event.scope,
        timestamp: event.timestamp,
        sequence: event.sequence,
        sessionId: event.sessionId,
        traceId: event.traceId,
        level: event.level,
        category: AppDiagnostics.instance.redactor.category(event.category),
        message: AppDiagnostics.instance.redactor
            .message(event.category, event.message),
        context: AppDiagnostics.instance.redactor.context(event.context),
      );
      final text = jsonEncode(clean.toJson());
      bytes += utf8.encode(text).length;
      if (bytes > 10 * 1024 * 1024) {
        omitted++;
        continue;
      }
      selected.add(text);
    }
    try {
      sink.write('{"metadata":${jsonEncode({
            'schemaVersion': 1,
            'redactionVersion': DiagnosticRedactor.version,
            ..._metadata,
            'exportedAt': now.toUtc().toIso8601String(),
            'timezoneOffsetMinutes': now.timeZoneOffset.inMinutes,
            'rangeHours': range.inHours,
            'eventCount': selected.length,
            'droppedEvents': dropped,
            'corruptRecords': corrupt,
            'omittedEvents': omitted,
            'persistent': persistent,
          })},"events":[');
      var first = true;
      for (final text in selected.reversed) {
        if (!first) sink.write(',');
        sink.write(text);
        first = false;
      }
      sink.write(']}');
      await sink.flush();
    } finally {
      await sink.close();
    }
    try {
      _check(scope);
    } catch (_) {
      await file.delete();
      rethrow;
    }
    _exports[file.path] = scope;
    return file;
  }

  void authorizeShare(File file, DiagnosticScope scope) {
    _check(scope);
    if (_exports[file.path] != scope) {
      throw StateError('unknown diagnostics export');
    }
  }

  Future<void> clear(DiagnosticScope scope) async {
    _check(scope);
    await initialize();
    _check(scope);
    await _store!.clear(scope);
    AppDiagnostics.instance.clearScope(scope);
    for (final entry in _exports.entries.toList()) {
      if (entry.value == scope) {
        final file = File(entry.key);
        if (await file.exists()) await file.delete();
        _exports.remove(entry.key);
      }
    }
  }

  Future<Directory> _exportDirectory() async => Directory(
      p.join((await getTemporaryDirectory()).path, 'diagnostics_exports_v1'));

  Future<void> cleanupExports() async {
    final directory = await _exportDirectory();
    if (!await directory.exists()) return;
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File ||
          !p.basename(entity.path).startsWith('diagnostics_')) {
        continue;
      }
      if (DateTime.now().difference((await entity.stat()).modified) >
          const Duration(hours: 24)) {
        await entity.delete();
        _exports.remove(entity.path);
      }
    }
  }

  Future<void> close() async {
    _removeListener?.call();
    _removeListener = null;
    await _store?.close();
  }
}
