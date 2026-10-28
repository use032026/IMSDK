import 'package:im_sdk/core/database/app_database.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_deletion_policy.dart';
import 'package:sqflite/sqflite.dart';

typedef ConversationDatabaseProvider = Future<Database> Function(
  String spaceId,
);

class ConversationDeletionBoundaryStore {
  ConversationDeletionBoundaryStore({
    required this.databaseProvider,
  });

  static const createTable =
      AppDatabase.createConversationDeletionTombstonesTable;

  final ConversationDatabaseProvider databaseProvider;

  // Only metadata confirmed by this SQLite owner. A failed read must not undo
  // a deletion that already committed; this never substitutes for message data.
  final _confirmedStates = <(String, String), ConversationDeletionState>{};

  ConversationDeletionState? confirmedState(
          String spaceId, String conversationId) =>
      _confirmedStates[(spaceId, conversationId)];

  void forgetSpace(String spaceId) =>
      _confirmedStates.removeWhere((key, _) => key.$1 == spaceId);

  ConversationDeletionState _confirm(String spaceId, String conversationId,
      ConversationDeletionState incoming) {
    final previous = confirmedState(spaceId, conversationId);
    final previousSeq = previous?.deletedThroughSeq;
    final incomingSeq = incoming.deletedThroughSeq;
    final previousTime = previous?.explicitDeletedAt;
    final incomingTime = incoming.explicitDeletedAt;
    return _confirmedStates[(spaceId, conversationId)] = (
      deletedThroughSeq: previousSeq != null &&
              (incomingSeq == null || previousSeq > incomingSeq)
          ? previousSeq
          : incomingSeq,
      explicitDeletedAt: previousTime != null &&
              (incomingTime == null || previousTime.isAfter(incomingTime))
          ? previousTime
          : incomingTime,
    );
  }

  Future<Map<String, int>> readAll(String spaceId) async {
    final db = await databaseProvider(spaceId);
    await _ensureSchema(db);
    final rows = await db.query(
      'conversation_deletion_tombstones',
      where: 'explicit_deletion = 1',
    );
    return {
      for (final row in rows)
        row['conversation_id'] as String:
            (row['deleted_through_seq'] as num).toInt(),
    };
  }

  Future<Map<String, int>> readAllWatermarks(String spaceId) async {
    final db = await databaseProvider(spaceId);
    await _ensureSchema(db);
    final rows = await db.query('conversation_deletion_tombstones');
    return {
      for (final row in rows)
        row['conversation_id'] as String:
            (row['deleted_through_seq'] as num).toInt(),
    };
  }

  Future<int?> read(String spaceId, String conversationId) async {
    final db = await databaseProvider(spaceId);
    await _ensureSchema(db);
    final rows = await db.query(
      'conversation_deletion_tombstones',
      columns: const ['deleted_through_seq'],
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return (rows.single['deleted_through_seq'] as num).toInt();
  }

  Future<ConversationDeletionState> readState(
      String spaceId, String conversationId) async {
    final db = await databaseProvider(spaceId);
    final state = await readStateWithExecutor(db, conversationId);
    return _confirm(spaceId, conversationId, state);
  }

  /// Transactional readers share the same legacy schema normalization. They
  /// must not confirm metadata until the enclosing transaction commits.
  Future<ConversationDeletionState> readStateWithExecutor(
      DatabaseExecutor db, String conversationId) async {
    await _ensureSchema(db);
    final rows = await db.query(
      'conversation_deletion_tombstones',
      columns: const ['deleted_through_seq', 'deleted_at', 'explicit_deletion'],
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return (deletedThroughSeq: null, explicitDeletedAt: null);
    }
    final row = rows.single;
    return (
      deletedThroughSeq: (row['deleted_through_seq'] as num).toInt(),
      explicitDeletedAt: (row['explicit_deletion'] as num?)?.toInt() == 1
          ? DateTime.fromMillisecondsSinceEpoch(
              (row['deleted_at'] as num).toInt())
          : null,
    );
  }

  Future<int?> readExplicit(String spaceId, String conversationId) async {
    final db = await databaseProvider(spaceId);
    await _ensureSchema(db);
    final rows = await db.query(
      'conversation_deletion_tombstones',
      columns: const ['deleted_through_seq'],
      where: 'conversation_id = ? AND explicit_deletion = 1',
      whereArgs: [conversationId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return (rows.single['deleted_through_seq'] as num).toInt();
  }

  Future<DateTime?> readDeletedAt(
    String spaceId,
    String conversationId,
  ) async {
    final db = await databaseProvider(spaceId);
    await _ensureSchema(db);
    final rows = await db.query(
      'conversation_deletion_tombstones',
      columns: const ['deleted_at'],
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DateTime.fromMillisecondsSinceEpoch(
      (rows.single['deleted_at'] as num).toInt(),
    );
  }

  Future<DateTime?> readExplicitDeletedAt(
    String spaceId,
    String conversationId,
  ) async {
    final db = await databaseProvider(spaceId);
    await _ensureSchema(db);
    final rows = await db.query(
      'conversation_deletion_tombstones',
      columns: const ['deleted_at'],
      where: 'conversation_id = ? AND explicit_deletion = 1',
      whereArgs: [conversationId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DateTime.fromMillisecondsSinceEpoch(
      (rows.single['deleted_at'] as num).toInt(),
    );
  }

  Future<void> record(
    String spaceId,
    String conversationId,
    int deletedThroughSeq,
  ) async {
    final db = await databaseProvider(spaceId);
    final deletion = await db.transaction((txn) async {
      await _ensureSchema(txn);
      return _recordWithExecutor(
        txn,
        conversationId,
        deletedThroughSeq,
        explicitDeletion: true,
      );
    });
    _confirm(spaceId, conversationId, (
      deletedThroughSeq: deletion.boundary,
      explicitDeletedAt: deletion.explicitDeletedAt,
    ));
  }

  Future<int> deleteConversationLocally(
    String spaceId,
    String conversationId, {
    required int deletedThroughSeqHint,
  }) async {
    return applyConversationDeletion(
      spaceId,
      conversationId,
      clearedSeq: deletedThroughSeqHint,
      isNewDeletion: true,
    );
  }

  Future<int> applyClearWatermark(
    String spaceId,
    String conversationId, {
    required int clearedSeq,
  }) {
    return _apply(
      spaceId,
      conversationId,
      clearedSeq: clearedSeq,
      explicitDeletion: false,
    );
  }

  /// User-requested deletes are new operations even without a newer server
  /// sequence; replayed Gateway deletions keep their original cutoff.
  Future<int> applyConversationDeletion(
    String spaceId,
    String conversationId, {
    required int clearedSeq,
    bool isNewDeletion = false,
  }) {
    return _apply(
      spaceId,
      conversationId,
      clearedSeq: clearedSeq,
      explicitDeletion: true,
      isNewDeletion: isNewDeletion,
    );
  }

  Future<int> _apply(
    String spaceId,
    String conversationId, {
    required int clearedSeq,
    required bool explicitDeletion,
    bool isNewDeletion = false,
  }) async {
    final db = await databaseProvider(spaceId);
    final committed = await db.transaction((txn) async {
      await _ensureSchema(txn);
      final conversationRows = await txn.query(
        'conversations',
        columns: const ['type', 'last_message_seq'],
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
        limit: 1,
      );
      if (conversationRows.isNotEmpty &&
          conversationRows.single['type'] == 'temp_session') {
        throw UnsupportedError(
          'Customer-service temporary conversations are not locally deleted',
        );
      }

      var boundary = clearedSeq < 0 ? 0 : clearedSeq;
      final messageTable = _messageTable(conversationId);
      final deletion = await _recordWithExecutor(
        txn,
        conversationId,
        boundary,
        explicitDeletion: explicitDeletion,
        isNewDeletion: isNewDeletion,
      );
      boundary = deletion.boundary;
      var hasNewerMessage = false;
      var removedMessageIds = const <String>[];
      if (await _tableExists(txn, messageTable)) {
        final removedRows = await txn.query(
          messageTable,
          columns: const ['message_id'],
          where: deletion.clearsUnsequenced
              ? '(conversation_seq > 0 AND conversation_seq <= ?) OR conversation_seq <= 0'
              : 'conversation_seq > 0 AND conversation_seq <= ?',
          whereArgs: [boundary],
        );
        removedMessageIds = removedRows
            .map((row) => row['message_id']?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toList(growable: false);
        await txn.delete(
          messageTable,
          where: deletion.clearsUnsequenced
              ? '(conversation_seq > 0 AND conversation_seq <= ?) OR conversation_seq <= 0'
              : 'conversation_seq > 0 AND conversation_seq <= ?',
          whereArgs: [boundary],
        );
        final newerRows = await txn.rawQuery(
          'SELECT 1 FROM $messageTable WHERE conversation_seq > ? LIMIT 1',
          [boundary],
        );
        hasNewerMessage = newerRows.isNotEmpty;
      }
      if (deletion.clearsUnsequenced && !hasNewerMessage) {
        await txn.delete(
          'conversations',
          where: 'conversation_id = ?',
          whereArgs: [conversationId],
        );
      } else if (!explicitDeletion && conversationRows.isNotEmpty) {
        final summarySeq =
            (conversationRows.single['last_message_seq'] as num?)?.toInt() ?? 0;
        if (summarySeq > 0 && summarySeq <= boundary) {
          final columns =
              (await txn.rawQuery('PRAGMA table_info(conversations)'))
                  .map((row) => row['name']?.toString())
                  .whereType<String>()
                  .toSet();
          final values = <String, Object?>{
            if (columns.contains('last_message_id')) 'last_message_id': null,
            if (columns.contains('last_message_preview'))
              'last_message_preview': null,
            if (columns.contains('last_message_type'))
              'last_message_type': null,
            if (columns.contains('last_message_sender_id'))
              'last_message_sender_id': null,
            if (columns.contains('last_message_mentions'))
              'last_message_mentions': null,
            if (columns.contains('last_message_is_self'))
              'last_message_is_self': 0,
            if (columns.contains('last_message_direction'))
              'last_message_direction': null,
            if (columns.contains('unread_count')) 'unread_count': 0,
            if (columns.contains('last_message_seq'))
              'last_message_seq': boundary,
          };
          if (values.isNotEmpty) {
            await txn.update(
              'conversations',
              values,
              where: 'conversation_id = ?',
              whereArgs: [conversationId],
            );
          }
        }
      }
      await _deleteMessageIndexRows(
        txn,
        table: 'chat_message_search_index',
        spaceId: spaceId,
        conversationId: conversationId,
        messageIds: removedMessageIds,
      );
      await _deleteMessageIndexRows(
        txn,
        table: 'chat_media_index',
        spaceId: spaceId,
        conversationId: conversationId,
        messageIds: removedMessageIds,
      );
      return (
        deletedThroughSeq: boundary,
        explicitDeletedAt: deletion.explicitDeletedAt,
      );
    });
    _confirm(spaceId, conversationId, committed);
    return committed.deletedThroughSeq;
  }

  Future<({int boundary, bool clearsUnsequenced, DateTime? explicitDeletedAt})>
      _recordWithExecutor(
          DatabaseExecutor db, String conversationId, int deletedThroughSeq,
          {required bool explicitDeletion, bool isNewDeletion = false}) async {
    final existing = await db.query(
      'conversation_deletion_tombstones',
      columns: const [
        'deleted_through_seq',
        'deleted_at',
        'explicit_deletion',
      ],
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      limit: 1,
    );
    final previous = existing.isEmpty
        ? 0
        : (existing.single['deleted_through_seq'] as num).toInt();
    final boundary =
        deletedThroughSeq > previous ? deletedThroughSeq : previous;
    final wasExplicit = existing.isNotEmpty &&
        (existing.single['explicit_deletion'] as num?)?.toInt() == 1;
    final previousDeletedAt = existing.isEmpty
        ? null
        : (existing.single['deleted_at'] as num?)?.toInt();
    final advancesExplicitDeletion = explicitDeletion &&
        (isNewDeletion || !wasExplicit || boundary > previous);
    final deletedAt = advancesExplicitDeletion || previousDeletedAt == null
        ? DateTime.now().millisecondsSinceEpoch
        : previousDeletedAt;
    await db.insert(
      'conversation_deletion_tombstones',
      {
        'conversation_id': conversationId,
        'deleted_through_seq': boundary,
        'deleted_at': deletedAt,
        'explicit_deletion': wasExplicit || explicitDeletion ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return (
      boundary: boundary,
      clearsUnsequenced: advancesExplicitDeletion,
      explicitDeletedAt: wasExplicit || explicitDeletion
          ? DateTime.fromMillisecondsSinceEpoch(deletedAt)
          : null,
    );
  }

  Future<void> _ensureSchema(DatabaseExecutor db) async {
    await db.execute(createTable);
    final columns = await db.rawQuery(
      'PRAGMA table_info(conversation_deletion_tombstones)',
    );
    if (columns.any((row) => row['name'] == 'explicit_deletion')) return;
    await db.execute(
      'ALTER TABLE conversation_deletion_tombstones '
      'ADD COLUMN explicit_deletion INTEGER NOT NULL DEFAULT 1',
    );
  }

  Future<void> _deleteMessageIndexRows(
    DatabaseExecutor db, {
    required String table,
    required String spaceId,
    required String conversationId,
    required List<String> messageIds,
  }) async {
    if (!await _tableExists(db, table) || messageIds.isEmpty) return;
    final columns = await db.rawQuery('PRAGMA table_info($table)');
    if (!columns.any((column) => column['name'] == 'message_id')) return;
    final placeholders = List.filled(messageIds.length, '?').join(',');
    await db.delete(
      table,
      where:
          'space_id = ? AND conversation_id = ? AND message_id IN ($placeholders)',
      whereArgs: [spaceId, conversationId, ...messageIds],
    );
  }

  Future<bool> _tableExists(DatabaseExecutor db, String tableName) async {
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return rows.isNotEmpty;
  }

  String _messageTable(String conversationId) {
    final sanitized = conversationId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return 'messages_$sanitized';
  }
}
