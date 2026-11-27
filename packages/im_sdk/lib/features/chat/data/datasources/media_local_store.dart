import 'dart:async';

import 'package:im_sdk/core/database/app_database.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/runtime/account_write_gate.dart';
import 'package:im_sdk/features/chat/data/datasources/conversation_deletion_boundary_store.dart';
import 'package:im_sdk/features/chat/domain/entities/media_local_file.dart';
import 'package:sqflite/sqflite.dart';

class MediaLocalStore {
  MediaLocalStore({
    required this.databaseProvider,
    this.writeGate,
    this.operationContext,
  });

  final ConversationDatabaseProvider databaseProvider;
  final AccountWriteGate? writeGate;
  final AccountOperationContext? operationContext;
  final _changes = StreamController<MediaLocalFile>.broadcast(sync: true);
  var _disposed = false;

  /// Observes this account store's existing media identity without another
  /// persisted status owner. Subscribe before reading so a commit cannot be
  /// lost, and discard a late initial snapshot if a newer commit was observed.
  Stream<MediaLocalFile?> watch({
    required String spaceId,
    required String conversationId,
    required String messageId,
    required MediaKind mediaKind,
    required MediaVariant variant,
  }) {
    late final StreamController<MediaLocalFile?> controller;
    StreamSubscription<MediaLocalFile>? subscription;
    var active = true;
    var revision = 0;
    controller = StreamController<MediaLocalFile?>(onListen: () {
      if (_disposed) {
        unawaited(controller.close());
        return;
      }
      subscription = _changes.stream.listen((file) {
        if (file.spaceId != spaceId ||
            file.conversationId != conversationId ||
            file.messageId != messageId ||
            file.mediaKind != mediaKind ||
            file.variant != variant) {
          return;
        }
        revision++;
        controller.add(file);
      }, onDone: () {
        active = false;
        unawaited(controller.close());
      });
      final initialRevision = revision;
      unawaited(get(
        spaceId: spaceId,
        conversationId: conversationId,
        messageId: messageId,
        mediaKind: mediaKind,
        variant: variant,
      ).then((file) {
        if (active && !_disposed && revision == initialRevision) {
          controller.add(file);
        }
      }, onError: (Object error, StackTrace stack) {
        if (active && !_disposed && revision == initialRevision) {
          controller.addError(error, stack);
        }
      }));
    }, onCancel: () {
      active = false;
      return subscription?.cancel();
    });
    return controller.stream;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    unawaited(_changes.close());
  }

  Future<MediaLocalFile?> get({
    required String spaceId,
    required String conversationId,
    required String messageId,
    required MediaKind mediaKind,
    required MediaVariant variant,
  }) async {
    final db = await databaseProvider(spaceId);
    await _ensureTable(db);
    final rows = await db.query(
      'media_local_files',
      where:
          'space_id = ? AND conversation_id = ? AND message_id = ? AND media_kind = ? AND variant = ?',
      whereArgs: [
        spaceId,
        conversationId,
        messageId,
        mediaKind.wireName,
        variant.wireName,
      ],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return MediaLocalFile.fromRow(rows.first);
  }

  Future<MediaLocalFile> upsertMissing({
    required String spaceId,
    required String conversationId,
    required String messageId,
    required MediaKind mediaKind,
    required MediaVariant variant,
    required String remoteUrl,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
  }) async {
    final existing = await get(
      spaceId: spaceId,
      conversationId: conversationId,
      messageId: messageId,
      mediaKind: mediaKind,
      variant: variant,
    );
    final now = DateTime.now();
    final file = MediaLocalFile(
      id: existing?.id ??
          mediaLocalFileId(
            spaceId: spaceId,
            conversationId: conversationId,
            messageId: messageId,
            mediaKind: mediaKind,
            variant: variant,
          ),
      spaceId: spaceId,
      conversationId: conversationId,
      messageId: messageId,
      mediaKind: mediaKind,
      variant: variant,
      remoteUrl: remoteUrl,
      localPath: existing?.localPath,
      fileName: fileName ?? existing?.fileName,
      mimeType: mimeType ?? existing?.mimeType,
      sizeBytes: sizeBytes ?? existing?.sizeBytes,
      status: existing?.status ?? MediaLocalStatus.missing,
      failureReason: existing?.failureReason,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      lastAccessedAt: existing?.lastAccessedAt,
    );
    await _upsert(spaceId, file);
    return file;
  }

  Future<MediaLocalFile> markDownloading(
    String spaceId,
    MediaLocalFile file, {
    required String localPath,
  }) async {
    final updated = file.copyWith(
      localPath: localPath,
      status: MediaLocalStatus.downloading,
      updatedAt: DateTime.now(),
      clearFailureReason: true,
    );
    await _upsert(spaceId, updated);
    return updated;
  }

  Future<MediaLocalFile> markDownloaded(
    String spaceId,
    MediaLocalFile file, {
    required String localPath,
    int? sizeBytes,
  }) async {
    final now = DateTime.now();
    final updated = file.copyWith(
      localPath: localPath,
      sizeBytes: sizeBytes,
      status: MediaLocalStatus.downloaded,
      updatedAt: now,
      lastAccessedAt: now,
      clearFailureReason: true,
    );
    await _upsert(spaceId, updated);
    return updated;
  }

  Future<MediaLocalFile> markMissing(
    String spaceId,
    MediaLocalFile file,
  ) async {
    final updated = file.copyWith(
      status: MediaLocalStatus.missing,
      updatedAt: DateTime.now(),
      clearFailureReason: true,
      clearLastAccessedAt: true,
    );
    await _upsert(spaceId, updated);
    return updated;
  }

  Future<MediaLocalFile> markFailed(
    String spaceId,
    MediaLocalFile file, {
    required String reason,
  }) async {
    final updated = file.copyWith(
      status: MediaLocalStatus.failed,
      failureReason: reason,
      updatedAt: DateTime.now(),
    );
    await _upsert(spaceId, updated);
    return updated;
  }

  Future<MediaLocalFile> touch(String spaceId, MediaLocalFile file) async {
    final updated = file.copyWith(
      lastAccessedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _upsert(spaceId, updated);
    return updated;
  }

  Future<List<MediaLocalFile>> getDownloading(String spaceId) async {
    return getByStatus(spaceId, MediaLocalStatus.downloading);
  }

  Future<List<MediaLocalFile>> getByStatus(
    String spaceId,
    MediaLocalStatus status,
  ) async {
    final db = await databaseProvider(spaceId);
    await _ensureTable(db);
    final rows = await db.query(
      'media_local_files',
      where: 'space_id = ? AND status = ?',
      whereArgs: [spaceId, status.wireName],
    );
    return rows.map(MediaLocalFile.fromRow).toList();
  }

  Future<List<MediaLocalFile>> getForConversation({
    required String spaceId,
    required String conversationId,
  }) async {
    final db = await databaseProvider(spaceId);
    await _ensureTable(db);
    final rows = await db.query(
      'media_local_files',
      where: 'space_id = ? AND conversation_id = ?',
      whereArgs: [spaceId, conversationId],
    );
    return rows.map(MediaLocalFile.fromRow).toList();
  }

  Future<List<MediaLocalFile>> getAll(String spaceId) async {
    final db = await databaseProvider(spaceId);
    await _ensureTable(db);
    final rows = await db.query(
      'media_local_files',
      where: 'space_id = ?',
      whereArgs: [spaceId],
    );
    return rows.map(MediaLocalFile.fromRow).toList();
  }

  Future<void> _upsert(String spaceId, MediaLocalFile file) async {
    Future<void> action() async {
      if (_disposed) throw StateError('Media local store is disposed');
      final db = await databaseProvider(spaceId);
      await _ensureTable(db);
      if (_disposed) throw StateError('Media local store is disposed');
      await db.insert(
        'media_local_files',
        file.toRow(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    final gate = writeGate;
    final context = operationContext;
    await (gate == null || context == null
        ? action()
        : gate.run(context, action));
    if (!_disposed) _changes.add(file);
  }

  Future<void> _ensureTable(Database db) async {
    await db.execute(AppDatabase.createMediaLocalFilesTable);
    for (final script in AppDatabase.createMediaLocalFilesIndexes) {
      await db.execute(script);
    }
  }
}
