import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:pointycastle/export.dart';
import 'app_diagnostics.dart';

/// One writer, bounded queue, independent authenticated records. No message DB.
class DiagnosticStore {
  DiagnosticStore({
    required this.root,
    required List<int> key,
    this.maxBytes = 20 * 1024 * 1024,
    this.segmentBytes = 1024 * 1024,
    this.retention = const Duration(days: 7),
    DateTime Function()? now,
  })  : _key = Uint8List.fromList(key),
        _now = now ?? DateTime.now;

  final Directory root;
  final Uint8List _key;
  final int maxBytes;
  final int segmentBytes;
  final Duration retention;
  final DateTime Function() _now;
  final _random = Random.secure();
  final _pending = <DiagnosticEvent>[];
  Future<void> _tail = Future.value();
  Future<void>? _flushing;
  Timer? _timer;
  int dropped = 0;
  int corrupt = 0;
  bool writeFailed = false;
  int _fileSequence = 0;
  final _currentFiles = <String, File>{};

  void enqueue(DiagnosticEvent event) {
    if (!event.scope.isAttributed) return;
    if (_pending.length >= 128) {
      final low = _pending.indexWhere((e) =>
          e.level == AppDiagnosticLevel.debug ||
          e.level == AppDiagnosticLevel.info);
      if (low >= 0 && event.level.index >= AppDiagnosticLevel.warning.index) {
        _pending.removeAt(low);
      } else {
        dropped++;
        return;
      }
      dropped++;
    }
    _pending.add(event);
    if (event.level.index >= AppDiagnosticLevel.warning.index) {
      unawaited(flush());
    } else {
      _timer ??= Timer(const Duration(seconds: 1), () {
        _timer = null;
        unawaited(flush());
      });
    }
  }

  Future<T> _exclusive<T>(Future<T> Function() action) {
    final next = _tail.then((_) => action());
    _tail = next.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return next;
  }

  Future<void> flush() {
    _timer?.cancel();
    _timer = null;
    final running = _flushing;
    if (running != null) return running;
    final next = _exclusive(() async {
      var inFlight = 0;
      try {
        await root.create(recursive: true);
        await _prune();
        while (_pending.isNotEmpty) {
          final batch = List<DiagnosticEvent>.of(_pending);
          _pending.clear();
          inFlight = batch.length;
          for (final event in batch) {
            final directory =
                Directory(p.join(root.path, event.scope.storageHash));
            await directory.create(recursive: true);
            var file = _currentFiles[event.scope.storageHash];
            if (file == null ||
                !await file.exists() ||
                await file.length() >= segmentBytes) {
              file = File(p.join(directory.path,
                  '${_now().toUtc().microsecondsSinceEpoch}-${_fileSequence++}.diag'));
              _currentFiles[event.scope.storageHash] = file;
            }
            final record = '${_encrypt(jsonEncode(event.toJson()))}\n';
            await file.writeAsString(record,
                mode: FileMode.append, flush: true);
          }
        }
        writeFailed = false;
        await _prune();
      } catch (_) {
        dropped += inFlight + _pending.length;
        _pending.clear();
        writeFailed = true;
      }
    });
    _flushing = next.whenComplete(() {
      _flushing = null;
      if (_pending.isNotEmpty) unawaited(flush());
    });
    return _flushing!;
  }

  Future<List<File>> _files() async {
    if (!await root.exists()) return [];
    return root
        .list(recursive: true, followLinks: false)
        .where((e) => e is File && e.path.endsWith('.diag'))
        .cast<File>()
        .toList();
  }

  Future<void> _prune() async {
    final files = await _files();
    final stats = <File, FileStat>{};
    for (final file in files) {
      stats[file] = await file.stat();
    }
    files.sort((a, b) => stats[a]!.modified.compareTo(stats[b]!.modified));
    var total = stats.values.fold<int>(0, (sum, stat) => sum + stat.size);
    for (final file in files) {
      final stat = stats[file]!;
      if (_now().difference(stat.modified) > retention || total > maxBytes) {
        await file.delete();
        total -= stat.size;
      }
    }
  }

  Future<List<DiagnosticEvent>> read(
      DiagnosticScope scope, Duration range) async {
    await flush();
    return _exclusive(() async {
      await _prune();
      corrupt = 0;
      final events = <DiagnosticEvent>[];
      final threshold = _now().subtract(range);
      for (final file in await _files()) {
        final partition = p.basename(p.dirname(file.path));
        if (partition != scope.storageHash && partition != 'public') continue;
        try {
          if (await file.length() > segmentBytes + 64 * 1024) {
            corrupt++;
            continue;
          }
          await for (final line in file
              .openRead()
              .transform(utf8.decoder)
              .transform(const LineSplitter())) {
            if (line.isEmpty) continue;
            try {
              final event = DiagnosticEvent.fromJson(
                  jsonDecode(_decrypt(line)) as Map<String, dynamic>);
              if (scope.includes(event.scope) &&
                  !event.timestamp.isBefore(threshold)) {
                events.add(event);
              }
            } catch (_) {
              corrupt++;
            }
          }
        } catch (_) {
          corrupt++;
        }
      }
      events.sort((a, b) {
        final byTime = a.timestamp.compareTo(b.timestamp);
        return byTime != 0 ? byTime : a.sequence.compareTo(b.sequence);
      });
      return events;
    });
  }

  Future<void> clear(DiagnosticScope scope) async {
    await flush();
    await _exclusive(() async {
      // Clearing a space must never remove another account's data or public logs.
      final directory = Directory(p.join(root.path, scope.storageHash));
      if (await directory.exists()) await directory.delete(recursive: true);
      _currentFiles.remove(scope.storageHash);
    });
  }

  Future<void> close() async {
    _timer?.cancel();
    await flush();
  }

  String _encrypt(String text) {
    final nonce =
        Uint8List.fromList(List.generate(12, (_) => _random.nextInt(256)));
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
          true, AEADParameters(KeyParameter(_key), 128, nonce, Uint8List(0)));
    return base64Encode(
        [...nonce, ...cipher.process(Uint8List.fromList(utf8.encode(text)))]);
  }

  String _decrypt(String text) {
    if (text.length > 64 * 1024) {
      throw const FormatException('oversized record');
    }
    final data = base64Decode(text);
    if (data.length < 28) throw const FormatException('incomplete record');
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
          false,
          AEADParameters(KeyParameter(_key), 128,
              Uint8List.sublistView(data, 0, 12), Uint8List(0)));
    return utf8.decode(cipher.process(Uint8List.sublistView(data, 12)));
  }
}
