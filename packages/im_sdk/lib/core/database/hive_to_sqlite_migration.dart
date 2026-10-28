import 'dart:convert';
import 'dart:developer';

import 'package:im_sdk/core/database/app_database.dart';
import 'package:im_sdk/core/storage/hive_storage.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/models/conversation_model.dart';
import 'package:im_sdk/features/chat/data/models/message_model.dart';
import 'package:sqflite/sqflite.dart';

/// Hive → SQLite 一次性数据迁移。
///
/// 首次以 SQLite 模式启动时自动将 Hive 数据迁移到 SQLite，用户无感知。
/// 迁移完成后在 `migration_flags` 表写入标志，确保只执行一次。
class HiveToSqliteMigration {
  static const String _migrationDoneKey = 'hive_migration_done';
  static const String _conversationDeletionBoundaryMigrationDoneKey =
      'conversation_deletion_boundary_hive_migration_done';

  /// 检查并执行 Hive → SQLite 迁移（只执行一次）。
  ///
  /// 由 [AppDatabase.of] 在首次打开数据库后调用。
  static Future<void> runIfNeeded(String spaceId, Database db) async {
    // Deletion boundaries are authoritative. A failure here must prevent the
    // connection from being published, otherwise an old conversation can be
    // rehydrated before the one-time migration completes.
    await _migrateConversationDeletionBoundaries(spaceId, db);

    try {
      // 检查迁移标志，已迁移则跳过
      final rows = await db.query(
        'migration_flags',
        where: 'key = ?',
        whereArgs: [_migrationDoneKey],
      );
      if (rows.isNotEmpty) return;

      log('HiveToSqliteMigration: starting migration for space $spaceId',
          name: 'HiveToSqliteMigration');

      await _migrateConversations(spaceId, db);
      await _migrateMessages(spaceId, db);

      // 无论迁移成功多少条，都写入完成标志（确保只执行一次）
      await db.insert(
        'migration_flags',
        {'key': _migrationDoneKey, 'value': '1'},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      log('HiveToSqliteMigration: migration completed for space $spaceId',
          name: 'HiveToSqliteMigration');
    } catch (e, st) {
      log('HiveToSqliteMigration: unexpected error for space $spaceId: $e\n$st',
          name: 'HiveToSqliteMigration');
      // 静默处理，不影响正常启动流程
    }
  }

  static Future<void> _migrateConversationDeletionBoundaries(
    String spaceId,
    Database db,
  ) async {
    final migrated = await db.query(
      'migration_flags',
      where: 'key = ?',
      whereArgs: [_conversationDeletionBoundaryMigrationDoneKey],
      limit: 1,
    );
    if (migrated.isNotEmpty) return;

    final settings = HiveStorage.settingsBox;
    final key = 'hidden_conversations_$spaceId';
    final raw = settings.get(key);
    final boundaries = <String, int>{};
    if (raw is String && raw.isNotEmpty) {
      for (final entry in raw.split('|')) {
        final separator = entry.lastIndexOf(':');
        if (separator <= 0) continue;
        final conversationId = entry.substring(0, separator);
        final sequence = int.tryParse(entry.substring(separator + 1));
        if (conversationId.isNotEmpty && sequence != null) {
          boundaries[conversationId] = sequence;
        }
      }
    }

    await db.transaction((txn) async {
      await txn.execute(
        AppDatabase.createConversationDeletionTombstonesTable,
      );
      final now = DateTime.now().millisecondsSinceEpoch;
      for (final entry in boundaries.entries) {
        final existing = await txn.query(
          'conversation_deletion_tombstones',
          columns: const ['deleted_through_seq'],
          where: 'conversation_id = ?',
          whereArgs: [entry.key],
          limit: 1,
        );
        final previous = existing.isEmpty
            ? 0
            : (existing.single['deleted_through_seq'] as num).toInt();
        await txn.insert(
          'conversation_deletion_tombstones',
          {
            'conversation_id': entry.key,
            'deleted_through_seq':
                entry.value > previous ? entry.value : previous,
            'deleted_at': now,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await txn.insert(
        'migration_flags',
        {
          'key': _conversationDeletionBoundaryMigrationDoneKey,
          'value': boundaries.length.toString(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await settings.delete(key);
  }

  // ── 迁移会话 ──────────────────────────────────────────────────────────────

  static Future<void> _migrateConversations(String spaceId, Database db) async {
    try {
      final box = await HiveStorage.conversationsBox(spaceId);
      final raw = box.get('conversations_$spaceId');
      if (raw == null) return;

      List<dynamic> jsonList;
      try {
        jsonList = jsonDecode(raw as String) as List<dynamic>;
      } catch (e) {
        log('HiveToSqliteMigration: failed to parse conversations JSON: $e',
            name: 'HiveToSqliteMigration');
        return;
      }

      final local = _legacyMigrationLocalDataSource(db);
      int migrated = 0;

      for (final item in jsonList) {
        try {
          final conversation =
              ConversationModel.fromJson(item as Map<String, dynamic>);
          await local.upsertConversation(spaceId, conversation);
          migrated++;
        } catch (e) {
          // 单条失败，continue
          log('HiveToSqliteMigration: failed to migrate conversation: $e',
              name: 'HiveToSqliteMigration');
          continue;
        }
      }

      // 迁移完成后删除 Hive 中的该 key
      try {
        await box.delete('conversations_$spaceId');
      } catch (e) {
        log('HiveToSqliteMigration: failed to delete Hive conversations key: $e',
            name: 'HiveToSqliteMigration');
      }

      log('HiveToSqliteMigration: migrated $migrated conversations',
          name: 'HiveToSqliteMigration');
    } catch (e) {
      // Hive box 不存在或读取失败，静默处理
      log('HiveToSqliteMigration: _migrateConversations failed: $e',
          name: 'HiveToSqliteMigration');
    }
  }

  // ── 迁移消息 ──────────────────────────────────────────────────────────────

  static Future<void> _migrateMessages(String spaceId, Database db) async {
    try {
      // 先获取所有已迁移的会话 ID，从 SQLite conversations 表读取
      final convRows = await db.query(
        'conversations',
        columns: ['conversation_id'],
      );

      if (convRows.isEmpty) return;

      final local = _legacyMigrationLocalDataSource(db);
      int totalMigrated = 0;

      for (final convRow in convRows) {
        final conversationId = convRow['conversation_id'] as String;
        try {
          await _migrateMessagesForConversation(
            spaceId,
            conversationId,
            local,
          );
          totalMigrated++;
        } catch (e) {
          // 单个会话失败，continue
          log(
              'HiveToSqliteMigration: failed to migrate messages for '
              'conversation $conversationId: $e',
              name: 'HiveToSqliteMigration');
          continue;
        }
      }

      log('HiveToSqliteMigration: migrated messages for $totalMigrated conversations',
          name: 'HiveToSqliteMigration');
    } catch (e) {
      log('HiveToSqliteMigration: _migrateMessages failed: $e',
          name: 'HiveToSqliteMigration');
    }
  }

  static ChatLocalDataSourceImpl _legacyMigrationLocalDataSource(Database db) {
    return ChatLocalDataSourceImpl(
      databaseProvider: (_) async => db,
      databaseDeleter: (_) => throw UnsupportedError(
        'Legacy migration cannot delete its source database',
      ),
    );
  }

  static Future<void> _migrateMessagesForConversation(
    String spaceId,
    String conversationId,
    ChatLocalDataSourceImpl local,
  ) async {
    try {
      final box = await HiveStorage.messagesBox(spaceId, conversationId);
      final raw = box.get('messages_cache');
      if (raw == null) return;

      List<dynamic> jsonList;
      try {
        jsonList = jsonDecode(raw as String) as List<dynamic>;
      } catch (e) {
        log(
            'HiveToSqliteMigration: failed to parse messages JSON for '
            '$conversationId: $e',
            name: 'HiveToSqliteMigration');
        return;
      }

      int migrated = 0;
      for (final item in jsonList) {
        try {
          final message = MessageModel.fromJson(item as Map<String, dynamic>);
          await local.upsertMessage(spaceId, conversationId, message);
          migrated++;
        } catch (e) {
          // 单条失败，continue
          log('HiveToSqliteMigration: failed to migrate message: $e',
              name: 'HiveToSqliteMigration');
          continue;
        }
      }

      // 迁移完成后删除 Hive 中的该 key
      try {
        await box.delete('messages_cache');
      } catch (e) {
        log(
            'HiveToSqliteMigration: failed to delete Hive messages key '
            'for $conversationId: $e',
            name: 'HiveToSqliteMigration');
      }

      log(
          'HiveToSqliteMigration: migrated $migrated messages for '
          'conversation $conversationId',
          name: 'HiveToSqliteMigration');
    } catch (e) {
      // Hive box 不存在或读取失败，静默处理
      log(
          'HiveToSqliteMigration: _migrateMessagesForConversation failed '
          'for $conversationId: $e',
          name: 'HiveToSqliteMigration');
    }
  }
}
