import 'dart:async';
import 'dart:developer';

import 'package:im_sdk/core/database/hive_to_sqlite_migration.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 数据库连接管理与 Schema 迁移。
///
/// 每个 [spaceId] 对应独立的 SQLite 文件：`lpp_chat_{spaceId}.db`。
/// 使用单例缓存避免重复打开同一文件。
class AppDatabase {
  AppDatabase._();

  // ── 单例缓存 ──────────────────────────────────────────────────────────────
  static final Map<String, Database> _instances = {};
  static final Map<String, Future<Database>> _opening = {};
  static final Object _migrationDatabaseKey = Object();

  // ── 当前 Schema 版本 ──────────────────────────────────────────────────────
  static const int _currentVersion = 8;

  // ── DDL：conversations 表 ─────────────────────────────────────────────────
  static const String _createConversationsTable = '''
    CREATE TABLE conversations (
      conversation_id       TEXT PRIMARY KEY,
      type                  TEXT NOT NULL,
      title                 TEXT NOT NULL DEFAULT '',
      avatar_url            TEXT,
      last_message_id       TEXT,
      last_message_preview  TEXT,
      last_message_type     TEXT,
	      last_message_sender_id TEXT,
	      last_message_mentions TEXT,
	      last_activity_at      INTEGER,
      unread_count          INTEGER NOT NULL DEFAULT 0,
      last_read_seq         INTEGER NOT NULL DEFAULT 0,
      last_message_seq      INTEGER NOT NULL DEFAULT 0,
      is_pinned             INTEGER NOT NULL DEFAULT 0,
      is_muted              INTEGER NOT NULL DEFAULT 0,
      draft                 TEXT,
      peer_user_id          TEXT,
      member_count          INTEGER,
      member_avatar_urls    TEXT,
      member_names          TEXT
    )
  ''';

  static const String _createConversationsIndex = '''
    CREATE INDEX idx_conversations_sort
      ON conversations (is_pinned DESC, last_activity_at DESC)
  ''';

  // ── DDL：migration_flags 表 ───────────────────────────────────────────────
  static const String _createMigrationFlagsTable = '''
    CREATE TABLE migration_flags (
      key   TEXT PRIMARY KEY,
      value TEXT NOT NULL
    )
  ''';

  static const String createConversationDeletionTombstonesTable = '''
    CREATE TABLE IF NOT EXISTS conversation_deletion_tombstones (
      conversation_id     TEXT PRIMARY KEY,
      deleted_through_seq INTEGER NOT NULL,
      deleted_at          INTEGER NOT NULL,
      explicit_deletion   INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String createMediaLocalFilesTable = '''
    CREATE TABLE IF NOT EXISTS media_local_files (
      id               TEXT PRIMARY KEY,
      space_id         TEXT NOT NULL,
      conversation_id  TEXT NOT NULL,
      message_id       TEXT NOT NULL,
      media_kind       TEXT NOT NULL,
      variant          TEXT NOT NULL,
      remote_url       TEXT NOT NULL,
      local_path       TEXT,
      file_name        TEXT,
      mime_type        TEXT,
      size_bytes       INTEGER,
      status           TEXT NOT NULL,
      failure_reason   TEXT,
      created_at       INTEGER NOT NULL,
      updated_at       INTEGER NOT NULL,
      last_accessed_at INTEGER,
      UNIQUE(space_id, conversation_id, message_id, media_kind, variant)
    )
  ''';

  static const String createPendingReadReceiptsTable = '''
    CREATE TABLE IF NOT EXISTS pending_read_receipts (
      conversation_id TEXT PRIMARY KEY,
      is_group        INTEGER NOT NULL,
      read_seq        INTEGER NOT NULL,
      updated_at      INTEGER NOT NULL
    )
  ''';

  static const List<String> createMediaLocalFilesIndexes = [
    '''
    CREATE INDEX IF NOT EXISTS idx_media_local_files_conversation
      ON media_local_files (space_id, conversation_id, updated_at)
    ''',
    '''
    CREATE INDEX IF NOT EXISTS idx_media_local_files_message
      ON media_local_files (space_id, conversation_id, message_id)
    ''',
    '''
    CREATE INDEX IF NOT EXISTS idx_media_local_files_status
      ON media_local_files (space_id, status)
    ''',
  ];

  // ── 版本迁移脚本 map（key = 目标版本号，支持多条语句用 ';' 分隔）──────────
  static const Map<int, List<String>> _migrations = {
    2: [
      'ALTER TABLE conversations ADD COLUMN last_read_seq INTEGER NOT NULL DEFAULT 0',
      'ALTER TABLE conversations ADD COLUMN last_message_seq INTEGER NOT NULL DEFAULT 0',
    ],
    3: [
      createMediaLocalFilesTable,
      ...createMediaLocalFilesIndexes,
    ],
    5: [
      '''
      UPDATE conversations
      SET unread_count = 0
      WHERE unread_count < 0
         OR (
           unread_count > 0
           AND last_message_seq > 0
           AND last_read_seq >= last_message_seq
         )
      ''',
    ],
    6: [
      createConversationDeletionTombstonesTable,
    ],
    8: [
      createPendingReadReceiptsTable,
    ],
  };

  static const String _messageEventCacheRepairFlag =
      'message_event_cache_repair_v1';
  static const String _confirmedOptimisticDuplicateRepairFlag =
      'confirmed_optimistic_duplicate_repair_v1';

  // ── 公开 API ──────────────────────────────────────────────────────────────

  /// 获取（或打开）指定空间的数据库连接。
  static Future<Database> of(String spaceId) async {
    final scoped = Zone.current[_migrationDatabaseKey];
    if (scoped is _MigrationDatabase && scoped.spaceId == spaceId) {
      return scoped.database;
    }
    final existing = _instances[spaceId];
    if (existing != null) return existing;
    final pending = _opening[spaceId];
    if (pending != null) return pending;

    final opening = _openAndMigrate(spaceId);
    _opening[spaceId] = opening;
    try {
      return await opening;
    } finally {
      if (identical(_opening[spaceId], opening)) {
        _opening.remove(spaceId);
      }
    }
  }

  static Future<Database> _openAndMigrate(String spaceId) async {
    final db = await _open(spaceId);
    try {
      await runZoned(
        () => HiveToSqliteMigration.runIfNeeded(spaceId, db),
        zoneValues: {
          _migrationDatabaseKey: _MigrationDatabase(spaceId, db),
        },
      );
      _instances[spaceId] = db;
      return db;
    } catch (_) {
      await db.close();
      rethrow;
    }
  }

  /// 关闭指定空间的数据库连接（切换空间时调用）。
  static Future<void> close(String spaceId) async {
    final pending = _opening[spaceId];
    if (pending != null) {
      try {
        await pending;
      } catch (_) {
        // Failed openings close their own database handle.
      }
    }
    final db = _instances.remove(spaceId);
    await db?.close();
  }

  /// 删除指定空间的数据库文件（退出登录时调用）。
  static Future<void> delete(String spaceId) async {
    await close(spaceId);
    final path = await _dbPath(spaceId);
    try {
      await deleteDatabase(path);
    } catch (e) {
      log('AppDatabase.delete($spaceId) failed: $e', name: 'AppDatabase');
    }
  }

  // ── 内部方法 ──────────────────────────────────────────────────────────────

  /// 打开数据库，启用 WAL 模式，执行 onCreate / onUpgrade。
  static Future<Database> _open(String spaceId) async {
    final path = await _dbPath(spaceId);
    return openDatabase(
      path,
      version: _currentVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Opens an account-scoped v2 database without consulting the legacy
  /// space-only singleton map or running the Hive v1 migration.
  ///
  /// This is an injection seam for [AccountStorageRegistry]. Production
  /// cutover remains owned by the runtime plan; legacy callers keep using
  /// [of] until that atomic cutover.
  static Future<Database> openAccountScopedAt(
    String path, {
    DatabaseFactory? factory,
  }) {
    final selectedFactory = factory ?? databaseFactory;
    return selectedFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _currentVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  /// 返回数据库文件的完整路径。
  static Future<String> _dbPath(String spaceId) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'lpp_chat_$spaceId.db');
  }

  /// 首次创建数据库时执行（version 1 初始 Schema）。
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createConversationsTable);
    await db.execute(_createConversationsIndex);
    await db.execute(_createMigrationFlagsTable);
    await db.execute(createConversationDeletionTombstonesTable);
    await db.execute(createMediaLocalFilesTable);
    await db.execute(createPendingReadReceiptsTable);
    for (final script in createMediaLocalFilesIndexes) {
      await db.execute(script);
    }
  }

  /// 数据库升级时按序执行迁移脚本。
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    for (int v = oldVersion + 1; v <= newVersion; v++) {
      if (v == 4) {
        await _resetMessageCacheAfterEventTypeCorruption(db);
      }
      if (v == 7) {
        await _removeConfirmedOptimisticDuplicates(db);
      }
      final scripts = _migrations[v];
      if (scripts != null) {
        for (final script in scripts) {
          try {
            await db.execute(script);
          } catch (e) {
            log(
              'AppDatabase migration to v$v failed: $e',
              name: 'AppDatabase',
            );
            rethrow;
          }
        }
      }
    }
  }

  /// Clears only reproducible message snapshots created by the faulty event
  /// classifier release. Conversations, drafts, pending sends and downloaded
  /// media remain intact; message pages are rebuilt from the server snapshot.
  ///
  /// The old cache cannot be repaired row-by-row because it discarded the
  /// original message type. Guessing from message copy would also destroy real
  /// customer-service events, so a versioned cache rebuild is the safe
  /// anti-corruption migration.
  static Future<void> _resetMessageCacheAfterEventTypeCorruption(
    Database db,
  ) async {
    final existingFlag = await db.query(
      'migration_flags',
      where: 'key = ?',
      whereArgs: [_messageEventCacheRepairFlag],
      limit: 1,
    );
    if (existingFlag.isNotEmpty) return;

    final messageTables = await db.rawQuery(
      "SELECT name FROM sqlite_master "
      "WHERE type = 'table' AND name LIKE 'messages_%'",
    );

    await db.transaction((txn) async {
      var droppedTableCount = 0;
      for (final row in messageTables) {
        final tableName = row['name'];
        if (tableName is! String ||
            !RegExp(r'^messages_[a-zA-Z0-9_]+$').hasMatch(tableName)) {
          continue;
        }
        await txn.execute('DROP TABLE IF EXISTS "$tableName"');
        droppedTableCount++;
      }

      // These are derived indexes of the message snapshot and must not retain
      // rows whose source message tables were removed.
      if (await _tableExists(txn, 'chat_message_search_index')) {
        await txn.delete('chat_message_search_index');
      }
      if (await _tableExists(txn, 'chat_media_index')) {
        await txn.delete('chat_media_index');
      }

      await txn.insert(
        'migration_flags',
        {
          'key': _messageEventCacheRepairFlag,
          'value': droppedTableCount.toString(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      log(
        'reset $droppedTableCount message cache tables after event type corruption',
        name: 'AppDatabase',
      );
    });
  }

  /// Removes stale seq-zero copies only when the same client message already
  /// has a server-confirmed row. Genuine pending and failed local messages do
  /// not have such a counterpart and remain untouched.
  static Future<void> _removeConfirmedOptimisticDuplicates(Database db) async {
    final existingFlag = await db.query(
      'migration_flags',
      where: 'key = ?',
      whereArgs: [_confirmedOptimisticDuplicateRepairFlag],
      limit: 1,
    );
    if (existingFlag.isNotEmpty) return;

    final messageTables = await db.rawQuery(
      "SELECT name FROM sqlite_master "
      "WHERE type = 'table' AND name LIKE 'messages_%'",
    );

    await db.transaction((txn) async {
      final hasSearchIndex =
          await _tableExists(txn, 'chat_message_search_index');
      final hasMediaIndex = await _tableExists(txn, 'chat_media_index');
      var removedCount = 0;
      for (final row in messageTables) {
        final tableName = row['name'];
        if (tableName is! String ||
            !RegExp(r'^messages_[a-zA-Z0-9_]+$').hasMatch(tableName)) {
          continue;
        }
        final duplicates = await txn.rawQuery('''
          SELECT optimistic.message_id, optimistic.conversation_id
          FROM "$tableName" AS optimistic
          WHERE optimistic.conversation_seq <= 0
            AND optimistic.client_msg_id IS NOT NULL
            AND trim(optimistic.client_msg_id) != ''
            AND EXISTS (
              SELECT 1
              FROM "$tableName" AS confirmed
              WHERE confirmed.client_msg_id = optimistic.client_msg_id
                AND confirmed.conversation_seq > 0
                AND confirmed.message_id != optimistic.message_id
            )
        ''');
        for (final duplicate in duplicates) {
          final messageId = duplicate['message_id'];
          final conversationId = duplicate['conversation_id'];
          if (hasSearchIndex &&
              messageId is String &&
              conversationId is String) {
            await txn.delete(
              'chat_message_search_index',
              where: 'conversation_id = ? AND message_id = ?',
              whereArgs: [conversationId, messageId],
            );
          }
          if (hasMediaIndex &&
              messageId is String &&
              conversationId is String) {
            await txn.delete(
              'chat_media_index',
              where: 'conversation_id = ? AND message_id = ?',
              whereArgs: [conversationId, messageId],
            );
          }
        }
        removedCount += await txn.rawDelete('''
          DELETE FROM "$tableName" AS optimistic
          WHERE optimistic.conversation_seq <= 0
            AND optimistic.client_msg_id IS NOT NULL
            AND trim(optimistic.client_msg_id) != ''
            AND EXISTS (
              SELECT 1
              FROM "$tableName" AS confirmed
              WHERE confirmed.client_msg_id = optimistic.client_msg_id
                AND confirmed.conversation_seq > 0
                AND confirmed.message_id != optimistic.message_id
            )
        ''');
      }

      await txn.insert(
        'migration_flags',
        {
          'key': _confirmedOptimisticDuplicateRepairFlag,
          'value': removedCount.toString(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log(
        'removed $removedCount confirmed optimistic message duplicates',
        name: 'AppDatabase',
      );
    });
  }

  static Future<bool> _tableExists(
    DatabaseExecutor db,
    String tableName,
  ) async {
    final rows = await db.rawQuery(
      'SELECT 1 FROM sqlite_master WHERE type = ? AND name = ? LIMIT 1',
      ['table', tableName],
    );
    return rows.isNotEmpty;
  }
}

class _MigrationDatabase {
  const _MigrationDatabase(this.spaceId, this.database);

  final String spaceId;
  final Database database;
}
