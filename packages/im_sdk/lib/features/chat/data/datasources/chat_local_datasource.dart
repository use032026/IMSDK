import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/runtime/account_write_gate.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_search_index.dart';
import 'package:im_sdk/features/chat/data/datasources/conversation_deletion_boundary_store.dart';
import 'package:im_sdk/features/chat/data/models/message_model.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/entities/pending_read_receipt.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_summary_policy.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_read_state_policy.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_sync_unread_policy.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_deletion_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_timeline_policy.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_unread_policy.dart';
import 'package:im_sdk/features/chat/domain/services/link_preview_update_policy.dart';
import 'package:sqflite/sqflite.dart';

class InterruptedOutgoingMessage {
  final Message message;
  final ConversationType? conversationType;

  const InterruptedOutgoingMessage({
    required this.message,
    required this.conversationType,
  });
}

enum LocalMediaPageDirection { older, newer }

class LocalMediaPage {
  final List<Message> items;
  final bool hasMore;

  const LocalMediaPage({
    required this.items,
    required this.hasMore,
  });
}

abstract class ChatLocalDataSource {
  // ── 旧方法（保持签名兼容）────────────────────────────────────────────────
  Future<List<Conversation>?> getCachedConversations(String spaceId);
  Future<void> cacheConversations(
      String spaceId, List<Conversation> conversations);
  Future<List<Message>?> getCachedMessages(
      String spaceId, String conversationId);
  Future<void> cacheMessages(
      String spaceId, String conversationId, List<Message> messages);
  Future<void> upsertMessage(
      String spaceId, String conversationId, Message message);
  Future<Message?> updateExistingLinkPreview(
      String spaceId, String conversationId, Message snapshot);
  Future<void> deleteMessage(
      String spaceId, String conversationId, String messageId);

  // ── 新增方法 ──────────────────────────────────────────────────────────────
  /// 分页查询消息（beforeSeq = null 时返回最新 limit 条）
  Future<List<Message>> getMessages(
    String spaceId,
    String conversationId, {
    int? beforeSeq,
    int limit = 50,
  });

  /// 批量 upsert 消息（INSERT OR REPLACE）
  Future<void> upsertMessages(
    String spaceId,
    String conversationId,
    List<Message> messages,
  );

  /// Reads one bounded image/video page from the account-scoped message
  /// snapshot. This never reaches the remote history or `/files` endpoints.
  Future<LocalMediaPage> getLocalMediaPage(
    String spaceId,
    String conversationId, {
    required int cursorSeq,
    required LocalMediaPageDirection direction,
    int limit = 20,
  });

  Future<List<InterruptedOutgoingMessage>> getInterruptedOutgoingMessages(
    String spaceId, {
    required String currentUserId,
    required DateTime sentBefore,
  });

  Future<Message?> findConfirmedMessageByClientMsgId(
    String spaceId,
    String conversationId,
    String clientMsgId,
  );

  /// Atomically applies one `/sync` conversation snapshot.
  ///
  /// Historical replay must never use the realtime unread increment rule.
  /// The read cursor from the server is reconciled monotonically and unread is
  /// derived from the persisted messages after that cursor.
  Future<Conversation?> applySyncedConversation(
    String spaceId, {
    required String conversationId,
    required ConversationType fallbackType,
    required List<Message> messages,
    required int lastReadSeq,
    required String currentUserId,
  });

  /// 获取本地最大 conversationSeq（增量同步游标）
  Future<int> getLocalMaxSeq(String spaceId, String conversationId);

  /// 获取会话列表（按 is_pinned DESC, last_activity_at DESC 排序）
  Future<List<Conversation>> getConversations(String spaceId);

  /// 批量 upsert 会话
  Future<void> upsertConversations(
      String spaceId, List<Conversation> conversations);

  /// 更新单个会话（WebSocket 新消息时调用）
  Future<void> upsertConversation(String spaceId, Conversation conversation);

  /// Updates personal settings without replacing the message/read snapshot.
  Future<void> updateConversationSettings(
    String spaceId,
    String conversationId, {
    bool? isPinned,
    bool? isMuted,
  });

  /// 根据一条消息更新会话摘要，同时保留原会话的标题、置顶、免打扰等属性。
  Future<void> updateConversationSummaryFromMessage(
    String spaceId, {
    required String conversationId,
    required ConversationType fallbackType,
    required Message message,
    bool isSelf = false,
  });

  /// Atomically persists a server-usable message and advances its conversation
  /// summary. A successful send must not be reported durable before this
  /// transaction completes.
  Future<Conversation> persistMessageAndAdvanceConversation(
    String spaceId, {
    required String conversationId,
    required ConversationType fallbackType,
    required Message message,
    bool isSelf = false,
  });

  /// 更新草稿
  Future<void> updateConversationDraft(
    String spaceId,
    String conversationId,
    String? draft,
  );

  /// 清除会话消息（用户主动清除聊天记录）
  Future<void> clearConversationMessages(String spaceId, String conversationId);

  /// 删除本地会话入口（不影响服务端群关系/好友关系）。
  Future<void> deleteConversation(String spaceId, String conversationId);

  Future<int> deleteConversationLocally(
    String spaceId,
    String conversationId, {
    required int deletedThroughSeqHint,
  });

  Future<int?> getConversationDeletionBoundary(
    String spaceId,
    String conversationId,
  );

  ConversationDeletionState? getConfirmedConversationDeletionState(
      String spaceId, String conversationId);

  Future<ConversationDeletionState> getConversationDeletionState(
      String spaceId, String conversationId);

  Future<int> applyConversationClearWatermark(
    String spaceId,
    String conversationId, {
    required int clearedSeq,
  });

  Future<int> applyConversationDeletion(
    String spaceId,
    String conversationId, {
    required int clearedSeq,
    bool isNewDeletion = false,
  });

  Future<Map<String, int>> getConversationDeletionBoundaries(String spaceId);
  Future<Map<String, int>> getConversationClearWatermarks(String spaceId);

  /// 删除整个空间数据库（退出登录）
  Future<void> deleteDatabase(String spaceId);

  /// 仅更新会话的未读数（标记已读时调用，避免全量 upsert）
  Future<void> updateConversationUnreadCount(
      String spaceId, String conversationId, int unreadCount);

  /// 更新会话已读游标，可同时更新未读数。
  Future<void> updateConversationReadState(
    String spaceId,
    String conversationId, {
    required int readSeq,
    int? unreadCount,
  });

  Future<void> markConversationReadAndEnqueue(
    String spaceId,
    String conversationId, {
    required bool isGroup,
    required int readSeq,
  });

  Future<List<PendingReadReceipt>> getPendingReadReceipts(String spaceId);

  Future<void> acknowledgePendingReadReceipt(
    String spaceId,
    String conversationId, {
    required int throughSeq,
  });

  /// 标记消息为已撤回（Gateway 推送 msg.recalled 时调用）
  Future<void> markMessageRecalled(
      String spaceId, String conversationId, String messageId);

  /// 按对端已读游标更新当前用户自己发送的消息。
  Future<void> markOwnMessagesReadByPeer(
    String spaceId,
    String conversationId, {
    required String currentUserId,
    required int readSeq,
  });
}

List<Message> sortMessagesForTimeline(Iterable<Message> messages) {
  return const MessageTimelinePolicy().sort(messages);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const _conversationSnapshotReadyKey =
      'conversation_first_page_snapshot_v1';
  static const _summaryPolicy = ConversationSummaryPolicy();
  static const _syncUnreadPolicy = ConversationSyncUnreadPolicy();

  ChatLocalDataSourceImpl({
    required ConversationDatabaseProvider databaseProvider,
    required Future<void> Function(String spaceId) databaseDeleter,
    AccountWriteGate? writeGate,
    AccountOperationContext? operationContext,
  })  : _databaseProvider = databaseProvider,
        _databaseDeleter = databaseDeleter,
        _writeGate = writeGate,
        _operationContext = operationContext,
        _deletionBoundaries = ConversationDeletionBoundaryStore(
          databaseProvider: databaseProvider,
        ),
        _searchIndex = ChatLocalSearchIndex(
          databaseProvider: databaseProvider,
        );

  final ConversationDatabaseProvider _databaseProvider;
  final Future<void> Function(String spaceId) _databaseDeleter;
  final AccountWriteGate? _writeGate;
  final AccountOperationContext? _operationContext;
  final ConversationDeletionBoundaryStore _deletionBoundaries;
  final ChatLocalSearchIndex _searchIndex;

  Future<T> _runGuardedWrite<T>(Future<T> Function() write) {
    final gate = _writeGate;
    final context = _operationContext;
    return gate == null || context == null ? write() : gate.run(context, write);
  }

  Future<int?> _readDeletionBoundary(
    DatabaseExecutor db,
    String conversationId,
  ) async {
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

  // ── 表名生成 ──────────────────────────────────────────────────────────────

  String _messageTable(String conversationId) {
    final sanitized = conversationId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return 'messages_$sanitized';
  }

  Future<void> _ensureMessageTable(Database db, String conversationId) async {
    final table = _messageTable(conversationId);
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        message_id              TEXT PRIMARY KEY,
        client_msg_id           TEXT,
        conversation_id         TEXT NOT NULL,
        conversation_seq        INTEGER NOT NULL,
        sender_user_id          TEXT NOT NULL,
        message_type            TEXT NOT NULL,
        body                    TEXT NOT NULL,
        is_recalled             INTEGER NOT NULL DEFAULT 0,
        sent_at                 INTEGER NOT NULL,
        reply_to_message_id     TEXT,
        forward_from_message_id TEXT,
        mentions                TEXT,
        status                  TEXT NOT NULL DEFAULT 'sent',
        translation             TEXT,
        translation_language    TEXT,
        read_count              INTEGER NOT NULL DEFAULT 0,
        is_read_by_peer         INTEGER NOT NULL DEFAULT 0,
        failure_reason          TEXT,
        is_self                 INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await _ensureColumn(db, table, 'read_count', 'INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn(
        db, table, 'is_read_by_peer', 'INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn(db, table, 'failure_reason', 'TEXT');
    await _ensureColumn(db, table, 'is_self', 'INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn(db, table, 'translation_language', 'TEXT');
    // Additive lazy migration: old rows retain null actor, scope/table keys stay unchanged.
    await _ensureColumn(db, table, 'operator_user_id', 'TEXT');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_${table}_seq
      ON $table (conversation_seq)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_${table}_client_msg_id
      ON $table (client_msg_id)
    ''');
  }

  // ── 序列化：消息 ──────────────────────────────────────────────────────────

  Map<String, dynamic> _messageToRow(Message m) {
    return {
      'message_id': m.messageId,
      'client_msg_id': m.clientMsgId,
      'conversation_id': m.conversationId,
      'conversation_seq': m.conversationSeq,
      'sender_user_id': m.senderUserId,
      'operator_user_id': m.operatorUserId,
      'message_type': MessageModel.toJson(m)['messageType'] as String,
      'body': jsonEncode(m.body.toLocalJson()),
      'is_recalled': m.isRecalled ? 1 : 0,
      'sent_at': m.sentAt.millisecondsSinceEpoch,
      'reply_to_message_id': m.replyToMessageId,
      'forward_from_message_id': m.forwardFromMessageId,
      'mentions': m.mentions != null
          ? jsonEncode(m.mentions!.map((e) => e.toJson()).toList())
          : null,
      'status': m.status.wireName,
      'translation': m.translation,
      'translation_language': m.translationLanguage,
      'read_count': m.readCount,
      'is_read_by_peer': m.isReadByPeer ? 1 : 0,
      'failure_reason': m.failureReason,
      'is_self': m.isSelf ? 1 : 0,
    };
  }

  Message _rowToMessage(Map<String, dynamic> row) {
    MessageBody body;
    try {
      body = MessageBody.fromJson(
          jsonDecode(row['body'] as String) as Map<String, dynamic>);
    } catch (_) {
      body = const MessageBody();
    }

    final mentions = _mentionsFromJson(row['mentions'] as String?);

    final isRecalled = (row['is_recalled'] as int) == 1;
    final status = isRecalled
        ? MessageStatus.recalled
        : parseMessageStatus(row['status'] as String?);

    return Message(
      messageId: row['message_id'] as String,
      clientMsgId: row['client_msg_id'] as String?,
      conversationId: row['conversation_id'] as String,
      conversationSeq: row['conversation_seq'] as int,
      senderUserId: row['sender_user_id'] as String,
      operatorUserId: row['operator_user_id'] as String?,
      type: _parseMessageType(row['message_type'] as String),
      body: body,
      isRecalled: isRecalled,
      sentAt: DateTime.fromMillisecondsSinceEpoch(row['sent_at'] as int,
          isUtc: true),
      replyToMessageId: row['reply_to_message_id'] as String?,
      forwardFromMessageId: row['forward_from_message_id'] as String?,
      mentions: mentions,
      status: status,
      translation: row['translation'] as String?,
      translationLanguage: row['translation_language'] as String?,
      readCount: row['read_count'] as int? ?? 0,
      isReadByPeer: (row['is_read_by_peer'] as int? ?? 0) == 1,
      failureReason: row['failure_reason'] as String?,
      isSelf: (row['is_self'] as int? ?? 0) == 1,
    );
  }

  MessageType _parseMessageType(String raw) {
    switch (raw) {
      case 'markdown':
        return MessageType.markdown;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'voice':
        return MessageType.voice;
      case 'file':
        return MessageType.file;
      case 'event':
        return MessageType.event;
      case 'contact_card':
        return MessageType.contactCard;
      case 'call_log':
        return MessageType.callLog;
      case 'location':
        return MessageType.location;
      case 'link':
        return MessageType.link;
      default:
        return MessageType.text;
    }
  }

  // ── 序列化：会话 ──────────────────────────────────────────────────────────

  Map<String, dynamic> _conversationToRow(Conversation c) {
    return {
      'conversation_id': c.conversationId,
      'type': switch (c.type) {
        ConversationType.group => 'group',
        ConversationType.tempSession => 'temp_session',
        ConversationType.direct => 'direct',
      },
      'title': c.title,
      'avatar_url': c.avatarUrl,
      'last_message_id': c.lastMessage?.messageId,
      'last_message_preview': c.lastMessage?.text,
      'last_message_type': c.lastMessage?.messageType,
      'last_message_sender_id': c.lastMessage?.senderUserId,
      'last_message_mentions': c.lastMessage?.mentions != null
          ? jsonEncode(c.lastMessage!.mentions!.map((e) => e.toJson()).toList())
          : null,
      'last_message_is_self': c.lastMessage?.isSelf == true ? 1 : 0,
      'last_message_direction': c.lastMessage?.direction,
      'last_activity_at': c.lastActivityAt?.millisecondsSinceEpoch,
      'unread_count': c.unreadCount,
      'last_read_seq': c.lastReadSeq,
      'last_message_seq': c.lastMessageSeq,
      'is_pinned': c.isPinned ? 1 : 0,
      'is_muted': c.isMuted ? 1 : 0,
      'draft': c.draft,
      'peer_user_id': c.peerUserId,
      'member_count': c.memberCount,
      'member_avatar_urls':
          c.memberAvatarUrls != null ? jsonEncode(c.memberAvatarUrls) : null,
      'member_names': c.memberNames != null ? jsonEncode(c.memberNames) : null,
    };
  }

  ConversationType? _storedConversationType(Object? type) => switch (type) {
        'direct' => ConversationType.direct,
        'group' => ConversationType.group,
        'temp_session' => ConversationType.tempSession,
        _ => null,
      };

  Conversation _rowToConversation(Map<String, dynamic> row) {
    final type =
        _storedConversationType(row['type']) ?? ConversationType.direct;

    LastMessage? lastMessage;
    final lastMsgId = row['last_message_id'] as String?;
    if (lastMsgId != null) {
      final sentAtRaw = row['last_activity_at'] as int?;
      final mentions =
          _mentionsFromJson(row['last_message_mentions'] as String?);
      lastMessage = LastMessage(
        messageId: lastMsgId,
        text: row['last_message_preview'] as String?,
        messageType: row['last_message_type'] as String? ?? 'text',
        senderUserId: row['last_message_sender_id'] as String? ?? '',
        sentAt: sentAtRaw != null
            ? DateTime.fromMillisecondsSinceEpoch(sentAtRaw, isUtc: true)
            : DateTime.now(),
        isSelf: (row['last_message_is_self'] as int? ?? 0) == 1,
        direction: row['last_message_direction'] as String?,
        mentions: mentions,
      );
    }

    List<String?>? memberAvatarUrls;
    try {
      final raw = row['member_avatar_urls'] as String?;
      if (raw != null) {
        memberAvatarUrls = (jsonDecode(raw) as List<dynamic>)
            .map((e) => e as String?)
            .toList();
      }
    } catch (_) {
      memberAvatarUrls = null;
    }

    List<String>? memberNames;
    try {
      final raw = row['member_names'] as String?;
      if (raw != null) {
        memberNames =
            (jsonDecode(raw) as List<dynamic>).map((e) => e as String).toList();
      }
    } catch (_) {
      memberNames = null;
    }

    final lastActivityAtRaw = row['last_activity_at'] as int?;

    return Conversation(
      conversationId: row['conversation_id'] as String,
      type: type,
      title: row['title'] as String? ?? '',
      avatarUrl: row['avatar_url'] as String?,
      lastMessage: lastMessage,
      unreadCount: row['unread_count'] as int? ?? 0,
      lastReadSeq: row['last_read_seq'] as int? ?? 0,
      lastMessageSeq: row['last_message_seq'] as int? ?? 0,
      isPinned: (row['is_pinned'] as int? ?? 0) == 1,
      isMuted: (row['is_muted'] as int? ?? 0) == 1,
      draft: row['draft'] as String?,
      lastActivityAt: lastActivityAtRaw != null
          ? DateTime.fromMillisecondsSinceEpoch(lastActivityAtRaw, isUtc: true)
          : null,
      peerUserId: row['peer_user_id'] as String?,
      memberCount: row['member_count'] as int?,
      memberAvatarUrls: memberAvatarUrls,
      memberNames: memberNames,
    );
  }

  List<Mention>? _mentionsFromJson(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final mentions = (jsonDecode(raw) as List<dynamic>)
          .map((e) => Mention.fromJson(e as Map<String, dynamic>))
          .toList();
      return mentions.isEmpty ? null : mentions;
    } catch (_) {
      return null;
    }
  }

  // ── 新增方法实现 ──────────────────────────────────────────────────────────

  @override
  Future<List<Message>> getMessages(
    String spaceId,
    String conversationId, {
    int? beforeSeq,
    int limit = 50,
  }) async {
    final db = await _databaseProvider(spaceId);
    final table = _messageTable(conversationId);

    // 表不存在时返回空列表
    final tableExists = await _tableExists(db, table);
    if (!tableExists) return [];

    final deletion =
        await _deletionBoundaries.readState(spaceId, conversationId);
    final deletedThroughSeq = deletion.deletedThroughSeq;
    List<Map<String, dynamic>> rows;
    if (beforeSeq != null) {
      rows = await db.query(
        table,
        where: deletedThroughSeq == null
            ? 'conversation_seq > 0 AND conversation_seq < ?'
            : 'conversation_seq > ? AND conversation_seq < ?',
        whereArgs: [
          if (deletedThroughSeq != null) deletedThroughSeq,
          beforeSeq,
        ],
        orderBy: 'conversation_seq DESC',
        limit: limit,
      );
    } else {
      final serverRows = await db.query(
        table,
        where: deletedThroughSeq == null
            ? 'conversation_seq > 0'
            : 'conversation_seq > ?',
        whereArgs: deletedThroughSeq == null ? null : [deletedThroughSeq],
        orderBy: 'conversation_seq DESC',
        limit: limit,
      );
      final localRows = await db.query(
        table,
        where: deletion.explicitDeletedAt == null
            ? 'conversation_seq <= 0'
            : 'conversation_seq <= 0 AND sent_at > ?',
        whereArgs: deletion.explicitDeletedAt == null
            ? null
            : [deletion.explicitDeletedAt!.millisecondsSinceEpoch],
        orderBy: 'sent_at ASC',
      );
      rows = [...serverRows, ...localRows];
    }

    return sortMessagesForTimeline(rows.map(_rowToMessage));
  }

  @override
  Future<LocalMediaPage> getLocalMediaPage(
    String spaceId,
    String conversationId, {
    required int cursorSeq,
    required LocalMediaPageDirection direction,
    int limit = 20,
  }) async {
    if (cursorSeq <= 0 || limit <= 0) {
      return const LocalMediaPage(items: [], hasMore: false);
    }
    final db = await _databaseProvider(spaceId);
    final table = _messageTable(conversationId);
    if (!await _tableExists(db, table)) {
      return const LocalMediaPage(items: [], hasMore: false);
    }

    final accepted = <Message>[];
    var queryCursor = cursorSeq;
    var exhausted = false;
    final requestedCount = limit + 1;
    final doubled = requestedCount * 2;
    final batchLimit = doubled < 32 ? 32 : doubled;

    while (accepted.length < requestedCount && !exhausted) {
      final older = direction == LocalMediaPageDirection.older;
      final rows = await db.query(
        table,
        where: '''
          conversation_seq > 0
          AND conversation_seq ${older ? '<' : '>'} ?
          AND message_type IN (?, ?)
          AND is_recalled = 0
          AND status NOT IN (?, ?)
        ''',
        whereArgs: [
          queryCursor,
          'image',
          'video',
          MessageStatus.recalled.wireName,
          MessageStatus.deletedLocal.wireName,
        ],
        orderBy: 'conversation_seq ${older ? 'DESC' : 'ASC'}',
        limit: batchLimit,
      );
      if (rows.isEmpty) break;
      for (final row in rows) {
        final message = _rowToMessage(row);
        if (_hasAvailableVisualMedia(message)) accepted.add(message);
        if (accepted.length >= requestedCount) break;
      }
      queryCursor = rows.last['conversation_seq'] as int;
      exhausted = rows.length < batchLimit;
    }

    final hasMore = accepted.length > limit;
    final items = accepted.take(limit).toList(growable: false);
    if (direction == LocalMediaPageDirection.older) {
      items.sort((a, b) => a.conversationSeq.compareTo(b.conversationSeq));
    }
    return LocalMediaPage(items: List.unmodifiable(items), hasMore: hasMore);
  }

  bool _hasAvailableVisualMedia(Message message) {
    final resource = switch (message.type) {
      MessageType.image => message.body.image,
      MessageType.video => message.body.video,
      _ => null,
    };
    return resource != null && resource.url.trim().isNotEmpty;
  }

  @override
  Future<List<InterruptedOutgoingMessage>> getInterruptedOutgoingMessages(
    String spaceId, {
    required String currentUserId,
    required DateTime sentBefore,
  }) async {
    final normalizedUserId = currentUserId.trim();
    if (normalizedUserId.isEmpty) return const [];
    final db = await _databaseProvider(spaceId);
    final conversations = await getConversations(spaceId);
    final conversationTypes = {
      for (final conversation in conversations)
        conversation.conversationId: conversation.type,
    };
    final tableRows = await db.query(
      'sqlite_master',
      columns: const ['name'],
      where: "type = 'table' AND name LIKE 'messages_%'",
    );
    final interrupted = <InterruptedOutgoingMessage>[];
    for (final tableRow in tableRows) {
      final table = tableRow['name'] as String?;
      if (table == null ||
          !RegExp(r'^messages_[a-zA-Z0-9_]+$').hasMatch(table)) {
        continue;
      }
      final rows = await db.rawQuery('''
        SELECT local.*
        FROM $table AS local
        WHERE local.conversation_seq <= 0
          AND local.status = ?
          AND local.sent_at < ?
          AND (local.is_self = 1 OR local.sender_user_id = ?)
          AND NOT EXISTS (
            SELECT 1 FROM $table AS confirmed
            WHERE confirmed.client_msg_id = local.client_msg_id
              AND confirmed.conversation_seq > 0
          )
        ORDER BY local.sent_at ASC
      ''', [
        MessageStatus.sending.wireName,
        sentBefore.millisecondsSinceEpoch,
        normalizedUserId,
      ]);
      interrupted.addAll(rows.map((row) {
        final message = _rowToMessage(row);
        return InterruptedOutgoingMessage(
          message: message,
          conversationType: conversationTypes[message.conversationId],
        );
      }));
    }
    return interrupted;
  }

  @override
  Future<Message?> findConfirmedMessageByClientMsgId(
    String spaceId,
    String conversationId,
    String clientMsgId,
  ) async {
    final normalizedClientMsgId = clientMsgId.trim();
    if (normalizedClientMsgId.isEmpty) return null;
    final db = await _databaseProvider(spaceId);
    final table = _messageTable(conversationId);
    if (!await _tableExists(db, table)) return null;
    final rows = await db.query(
      table,
      where: 'client_msg_id = ? AND conversation_seq > 0',
      whereArgs: [normalizedClientMsgId],
      orderBy: 'conversation_seq DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : _rowToMessage(rows.single);
  }

  @override
  Future<void> upsertMessages(
    String spaceId,
    String conversationId,
    List<Message> messages,
  ) async {
    if (messages.isEmpty) return;
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await _ensureMessageTable(db, conversationId);
      final table = _messageTable(conversationId);
      var visibleMessages = const <Message>[];
      await db.transaction((txn) async {
        final deletion = await _deletionBoundaries.readStateWithExecutor(
            txn, conversationId);
        visibleMessages = ConversationDeletionPolicy.visibleMessages(
          messages,
          deletedThroughSeq: deletion.deletedThroughSeq,
          explicitDeletedAt: deletion.explicitDeletedAt,
        );
        if (visibleMessages.isEmpty) return;
        visibleMessages = await _withoutSupersededOptimisticMessages(
          txn,
          table,
          visibleMessages,
        );
        if (visibleMessages.isEmpty) return;
        await _deleteSupersededOptimisticRows(
          txn,
          table,
          visibleMessages,
        );
        final batch = txn.batch();
        for (final m in visibleMessages) {
          batch.insert(table, _messageToRow(m),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
        await batch.commit(noResult: true);
      });
      if (visibleMessages.isEmpty) return;
      await _searchIndex.upsertMessages(
        spaceId,
        conversationId,
        visibleMessages,
      );
    });
  }

  @override
  Future<Conversation?> applySyncedConversation(
    String spaceId, {
    required String conversationId,
    required ConversationType fallbackType,
    required List<Message> messages,
    required int lastReadSeq,
    required String currentUserId,
  }) async {
    final db = await _databaseProvider(spaceId);
    await _ensureMessageTable(db, conversationId);
    await _ensureConversationLastMessageColumns(db);
    final table = _messageTable(conversationId);
    var sortedMessages = const <Message>[];

    return _runGuardedWrite(() async {
      final result = await db.transaction((txn) async {
        final deletion = await _deletionBoundaries.readStateWithExecutor(
            txn, conversationId);
        final visibleMessages = ConversationDeletionPolicy.visibleMessages(
          messages,
          deletedThroughSeq: deletion.deletedThroughSeq,
          explicitDeletedAt: deletion.explicitDeletedAt,
        );
        sortedMessages = sortMessagesForTimeline(
          await _withoutSupersededOptimisticMessages(
            txn,
            table,
            visibleMessages,
          ),
        );
        await _deleteSupersededOptimisticRows(
          txn,
          table,
          sortedMessages,
        );
        final messageBatch = txn.batch();
        for (final message in sortedMessages) {
          messageBatch.insert(
            table,
            _messageToRow(message),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await messageBatch.commit(noResult: true);

        final normalizedCurrentUserId = currentUserId.trim();
        if (normalizedCurrentUserId.isNotEmpty) {
          // Repairs rows written by older clients that did not normalize the
          // sender identity before persisting `/sync` messages.
          await txn.update(
            table,
            {'is_self': 1},
            where: 'lower(sender_user_id) = lower(?)',
            whereArgs: [normalizedCurrentUserId],
          );
        }

        final existingRows = await txn.query(
          'conversations',
          where: 'conversation_id = ?',
          whereArgs: [conversationId],
          limit: 1,
        );
        final existing = existingRows.isEmpty
            ? null
            : _rowToConversation(existingRows.first);
        if (existing == null && sortedMessages.isEmpty) {
          return null;
        }
        var conversation = existing ??
            Conversation(
              conversationId: conversationId,
              type: fallbackType,
              title: '',
            );

        final effectiveReadSeq = lastReadSeq > conversation.lastReadSeq
            ? lastReadSeq
            : conversation.lastReadSeq;
        final readUpperBound = effectiveReadSeq < conversation.lastMessageSeq
            ? effectiveReadSeq
            : conversation.lastMessageSeq;
        var knownNewlyReadMessageCount = 0;
        if (existing != null && readUpperBound > existing.lastReadSeq) {
          final rows = await txn.rawQuery(
            '''
          SELECT COUNT(*) AS read_count
          FROM $table
          WHERE conversation_seq > ?
            AND conversation_seq <= ?
            AND is_recalled = 0
            AND is_self = 0
            AND message_type != ?
            AND status IN (?, ?, ?)
          ''',
            [
              existing.lastReadSeq,
              readUpperBound,
              'event',
              MessageStatus.sent.wireName,
              MessageStatus.delivered.wireName,
              MessageStatus.read.wireName,
            ],
          );
          knownNewlyReadMessageCount =
              (rows.first['read_count'] as num?)?.toInt() ?? 0;
        }

        for (final message in sortedMessages) {
          final candidate = _conversationSummaryCandidate(
            conversation,
            fallbackType: fallbackType,
            message: message,
          );
          if (_summaryPolicy.shouldAdvance(
            current: conversation,
            incoming: candidate,
          )) {
            conversation = candidate;
          }
        }

        final unreadProjection = _syncUnreadPolicy.project(
          existing: existing,
          resolvedLastMessageSeq: conversation.lastMessageSeq,
          serverLastReadSeq: lastReadSeq,
          knownNewlyReadMessageCount: knownNewlyReadMessageCount,
          syncedMessages: sortedMessages,
        );
        conversation = conversation.copyWith(
          lastReadSeq: unreadProjection.lastReadSeq,
          unreadCount: unreadProjection.unreadCount,
        );
        await txn.insert(
          'conversations',
          _conversationToRow(conversation),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        if (lastReadSeq > 0) {
          await txn.delete(
            'pending_read_receipts',
            where: 'conversation_id = ? AND read_seq <= ?',
            whereArgs: [conversationId, lastReadSeq],
          );
        }
        return conversation;
      });

      if (result != null && sortedMessages.isNotEmpty) {
        await _searchIndex.upsertMessages(
          spaceId,
          conversationId,
          sortedMessages,
        );
      }
      return result;
    });
  }

  @override
  Future<int> getLocalMaxSeq(String spaceId, String conversationId) async {
    final db = await _databaseProvider(spaceId);
    final table = _messageTable(conversationId);

    final tableExists = await _tableExists(db, table);
    final deletedThroughSeq =
        await _deletionBoundaries.read(spaceId, conversationId) ?? 0;
    if (!tableExists) return deletedThroughSeq;

    final result = await db
        .rawQuery('SELECT MAX(conversation_seq) AS max_seq FROM $table');
    final maxSeq = result.first['max_seq'];
    final localMax = maxSeq == null ? 0 : (maxSeq as num).toInt();
    return localMax > deletedThroughSeq ? localMax : deletedThroughSeq;
  }

  @override
  Future<List<Conversation>> getConversations(String spaceId) async {
    final db = await _databaseProvider(spaceId);
    await _ensureConversationLastMessageColumns(db);
    final boundaries = await _deletionBoundaries.readAll(spaceId);
    return db.transaction((txn) async {
      final rows = await txn.query(
        'conversations',
        orderBy: 'is_pinned DESC, last_activity_at DESC',
      );
      final conversations = <Conversation>[];
      for (final row in rows) {
        final conversation =
            await _rowToConversationWithMessageBackfill(txn, row);
        final boundary = boundaries[conversation.conversationId];
        if (boundary == null || conversation.lastMessageSeq > boundary) {
          conversations.add(conversation);
        }
      }
      return conversations;
    });
  }

  /// Narrow, read-only identity lookup. Does not hydrate messages, repair
  /// summaries, create tables or initialize the presentation conversation list.
  Future<Map<String, ConversationType>> getConversationTypes(
    String spaceId,
    Iterable<String> conversationIds,
  ) async {
    final ids = conversationIds.toSet().toList();
    if (ids.isEmpty) return const {};
    final db = await _databaseProvider(spaceId);
    final result = <String, ConversationType>{};
    // Stay below SQLite's bind-parameter limit for large result sets.
    for (var offset = 0; offset < ids.length; offset += 400) {
      final batch = ids.skip(offset).take(400).toList();
      final rows = await db.query(
        'conversations',
        columns: ['conversation_id', 'type'],
        where:
            'conversation_id IN (${List.filled(batch.length, '?').join(',')})',
        whereArgs: batch,
      );
      for (final row in rows) {
        final type = _storedConversationType(row['type']);
        if (type != null) result[row['conversation_id'] as String] = type;
      }
    }
    return result;
  }

  Future<Conversation> _rowToConversationWithMessageBackfill(
    DatabaseExecutor db,
    Map<String, dynamic> row,
  ) async {
    final stored = _rowToConversation(row);
    final conversation =
        await _repairConversationSummaryFromMessages(db, stored);
    final lastMessage = conversation.lastMessage;
    if (lastMessage == null || lastMessage.mentions != null) {
      return conversation;
    }
    final mentions =
        await _lastMessageMentionsFromMessageTable(db, conversation);
    if (mentions == null) return conversation;
    return conversation.copyWith(
      lastMessage: lastMessage.copyWith(mentions: mentions),
    );
  }

  Future<Conversation> _repairConversationSummaryFromMessages(
    DatabaseExecutor db,
    Conversation stored,
  ) async {
    final table = _messageTable(stored.conversationId);
    if (!await _tableExists(db, table)) return stored;
    final rows = await db.query(
      table,
      where: 'is_recalled = 0 AND status IN (?, ?, ?)',
      whereArgs: const ['sent', 'delivered', 'read'],
      orderBy: 'conversation_seq DESC, sent_at DESC',
      limit: 20,
    );
    var repaired = stored;
    for (final row in rows.reversed) {
      final message = _rowToMessage(row);
      final candidate = repaired.copyWith(
        lastMessage: LastMessage(
          messageId: message.messageId,
          text: message.body.text,
          messageType: MessageModel.toJson(message)['messageType'] as String,
          senderUserId: message.senderUserId,
          sentAt: message.sentAt,
          isSelf: message.isSelf,
          direction: message.isSelf ? 'out' : null,
          mentions: message.mentions,
        ),
        lastActivityAt: message.sentAt,
        lastMessageSeq: message.conversationSeq,
      );
      if (_summaryPolicy.shouldAdvance(
          current: repaired, incoming: candidate)) {
        repaired = candidate;
      }
    }
    if (_sameStoredSummary(stored, repaired)) return stored;
    await db.insert(
      'conversations',
      _conversationToRow(repaired),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return repaired;
  }

  bool _sameStoredSummary(Conversation left, Conversation right) {
    final leftLast = left.lastMessage;
    final rightLast = right.lastMessage;
    return left.lastMessageSeq == right.lastMessageSeq &&
        left.lastActivityAt == right.lastActivityAt &&
        leftLast?.messageId == rightLast?.messageId &&
        leftLast?.text == rightLast?.text &&
        leftLast?.messageType == rightLast?.messageType &&
        leftLast?.senderUserId == rightLast?.senderUserId &&
        leftLast?.isSelf == rightLast?.isSelf;
  }

  Future<List<Mention>?> _lastMessageMentionsFromMessageTable(
    DatabaseExecutor db,
    Conversation conversation,
  ) async {
    final lastMessage = conversation.lastMessage;
    if (lastMessage == null) return null;
    final table = _messageTable(conversation.conversationId);
    if (!await _tableExists(db, table)) return null;
    final rows = await db.query(
      table,
      columns: const ['mentions'],
      where: lastMessage.messageId.isNotEmpty
          ? 'message_id = ?'
          : 'conversation_seq = ?',
      whereArgs: [
        lastMessage.messageId.isNotEmpty
            ? lastMessage.messageId
            : conversation.lastMessageSeq,
      ],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _mentionsFromJson(rows.first['mentions'] as String?);
  }

  @override
  Future<void> upsertConversations(
      String spaceId, List<Conversation> conversations) async {
    if (conversations.isEmpty) return;
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await _ensureConversationLastMessageColumns(db);
      final explicitBoundaries = await _deletionBoundaries.readAll(spaceId);
      final allWatermarks =
          await _deletionBoundaries.readAllWatermarks(spaceId);
      await db.transaction((txn) async {
        for (final conversation in conversations) {
          final boundary = explicitBoundaries[conversation.conversationId];
          if (boundary != null && conversation.lastMessageSeq <= boundary) {
            continue;
          }
          final merged =
              await _preserveExistingLastMessageMentions(txn, conversation);
          await txn.insert(
              'conversations',
              _conversationRowRespectingWatermark(
                merged,
                allWatermarks[conversation.conversationId],
              ),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    });
  }

  @override
  Future<void> upsertConversation(
      String spaceId, Conversation conversation) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await _ensureConversationLastMessageColumns(db);
      final boundary = await _deletionBoundaries.readExplicit(
          spaceId, conversation.conversationId);
      final watermark =
          await _deletionBoundaries.read(spaceId, conversation.conversationId);
      await db.transaction((txn) async {
        if (boundary != null && conversation.lastMessageSeq <= boundary) return;
        final merged =
            await _preserveExistingLastMessageMentions(txn, conversation);
        await txn.insert('conversations',
            _conversationRowRespectingWatermark(merged, watermark),
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
    });
  }

  @override
  Future<void> updateConversationSettings(
    String spaceId,
    String conversationId, {
    bool? isPinned,
    bool? isMuted,
  }) async {
    final values = {
      if (isPinned != null) 'is_pinned': isPinned ? 1 : 0,
      if (isMuted != null) 'is_muted': isMuted ? 1 : 0,
    };
    if (values.isEmpty) return;
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await db.update('conversations', values,
          where: 'conversation_id = ?', whereArgs: [conversationId]);
    });
  }

  Map<String, Object?> _conversationRowRespectingWatermark(
    Conversation conversation,
    int? clearedSeq,
  ) {
    final row = _conversationToRow(conversation);
    if (clearedSeq == null || conversation.lastMessageSeq > clearedSeq) {
      return row;
    }
    row
      ..['last_message_id'] = null
      ..['last_message_preview'] = null
      ..['last_message_type'] = null
      ..['last_message_sender_id'] = null
      ..['last_message_mentions'] = null
      ..['last_message_is_self'] = 0
      ..['last_message_direction'] = null
      ..['last_message_seq'] = clearedSeq
      ..['unread_count'] = 0;
    return row;
  }

  Future<Conversation> _preserveExistingLastMessageMentions(
    DatabaseExecutor db,
    Conversation next,
  ) async {
    final rows = await db.query(
      'conversations',
      where: 'conversation_id = ?',
      whereArgs: [next.conversationId],
      limit: 1,
    );
    if (rows.isEmpty) return next;
    final existing = _rowToConversation(rows.first);
    final merged = _summaryPolicy.mergeRemoteSnapshot(
      local: existing,
      remote: next,
    );
    final mergedLast = merged.lastMessage;
    final existingLast = existing.lastMessage;
    if (mergedLast == null ||
        mergedLast.mentions != null ||
        existingLast?.mentions == null ||
        !_isSameLastMessage(existing, merged)) {
      return merged;
    }
    return merged.copyWith(
      lastMessage: mergedLast.copyWith(mentions: existingLast!.mentions),
    );
  }

  @override
  Future<void> updateConversationSummaryFromMessage(
    String spaceId, {
    required String conversationId,
    required ConversationType fallbackType,
    required Message message,
    bool isSelf = false,
  }) async {
    if (fallbackType == ConversationType.tempSession) {
      await deleteConversation(spaceId, conversationId);
      return;
    }
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await _ensureConversationLastMessageColumns(db);
      await db.transaction((txn) async {
        final boundary = await _readDeletionBoundary(txn, conversationId);
        if (boundary != null &&
            message.conversationSeq > 0 &&
            message.conversationSeq <= boundary) {
          return;
        }
        final updated = await _advanceConversationFromMessage(
          txn,
          conversationId: conversationId,
          fallbackType: fallbackType,
          message: message,
          isSelf: isSelf,
        );
        await txn.insert(
          'conversations',
          _conversationToRow(updated),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    });
  }

  @override
  Future<Conversation> persistMessageAndAdvanceConversation(
    String spaceId, {
    required String conversationId,
    required ConversationType fallbackType,
    required Message message,
    bool isSelf = false,
  }) async {
    if (fallbackType == ConversationType.tempSession) {
      await upsertMessage(spaceId, conversationId, message);
      await deleteConversation(spaceId, conversationId);
      return Conversation(
        conversationId: conversationId,
        type: fallbackType,
        title: '',
      );
    }
    return _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await _ensureMessageTable(db, conversationId);
      await _ensureConversationLastMessageColumns(db);
      final normalizedMessage =
          isSelf && !message.isSelf ? message.copyWith(isSelf: true) : message;
      final updated = await db.transaction((txn) async {
        final boundary = await _readDeletionBoundary(txn, conversationId);
        if (boundary != null &&
            normalizedMessage.conversationSeq > 0 &&
            normalizedMessage.conversationSeq <= boundary) {
          throw StateError('MESSAGE_BEFORE_LOCAL_DELETION_BOUNDARY');
        }
        await _deleteSupersededOptimisticRows(
          txn,
          _messageTable(conversationId),
          [normalizedMessage],
        );
        await txn.insert(
          _messageTable(conversationId),
          _messageToRow(normalizedMessage),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        final updated = await _advanceConversationFromMessage(
          txn,
          conversationId: conversationId,
          fallbackType: fallbackType,
          message: normalizedMessage,
          isSelf: isSelf,
        );
        await txn.insert(
          'conversations',
          _conversationToRow(updated),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return updated;
      });
      await _searchIndex.upsertMessages(
        spaceId,
        conversationId,
        [normalizedMessage],
      );
      return updated;
    });
  }

  Future<Conversation> _advanceConversationFromMessage(
    DatabaseExecutor db, {
    required String conversationId,
    required ConversationType fallbackType,
    required Message message,
    required bool isSelf,
  }) async {
    final rows = await db.query(
      'conversations',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      limit: 1,
    );
    final existing = rows.isEmpty ? null : _rowToConversation(rows.first);
    final isSelfMessage = isSelf || message.isSelf;
    final isDuplicateLastMessage =
        existing?.lastMessage != null && _isSameMessage(existing!, message);
    final base = existing ??
        Conversation(
          conversationId: conversationId,
          type: fallbackType,
          title: '',
        );
    final candidate = _conversationSummaryCandidate(
      base,
      fallbackType: fallbackType,
      message: message.copyWith(isSelf: isSelfMessage),
    );
    if (existing == null ||
        _summaryPolicy.shouldAdvance(current: existing, incoming: candidate)) {
      return candidate.copyWith(
        unreadCount: ConversationUnreadPolicy.mergeUnreadCount(
          currentUnreadCount: existing?.unreadCount ?? 0,
          isCurrentUserMessage: isSelfMessage,
          isEvent: message.type == MessageType.event,
          isDuplicate: isDuplicateLastMessage,
          isActiveConversation: false,
        ),
      );
    }
    return existing;
  }

  Conversation _conversationSummaryCandidate(
    Conversation base, {
    required ConversationType fallbackType,
    required Message message,
  }) {
    final inferredPeerUserId =
        fallbackType == ConversationType.direct && !message.isSelf
            ? message.senderUserId
            : null;
    return base.copyWith(
      type: base.type,
      peerUserId: base.peerUserId ?? inferredPeerUserId,
      lastMessage: LastMessage(
        messageId: message.messageId,
        text: message.body.text,
        messageType: MessageModel.toJson(message)['messageType'] as String,
        senderUserId: message.senderUserId,
        sentAt: message.sentAt,
        isSelf: message.isSelf,
        direction: message.isSelf ? 'out' : null,
        mentions: message.mentions,
      ),
      lastActivityAt: message.sentAt,
      lastMessageSeq: message.conversationSeq,
    );
  }

  bool _isSameMessage(Conversation conversation, Message message) {
    final last = conversation.lastMessage;
    if (last == null) return false;
    if (last.messageId.isNotEmpty &&
        message.messageId.isNotEmpty &&
        last.messageId == message.messageId) {
      return true;
    }
    return conversation.lastMessageSeq > 0 &&
        message.conversationSeq > 0 &&
        conversation.lastMessageSeq == message.conversationSeq;
  }

  bool _isSameLastMessage(Conversation current, Conversation next) {
    final currentLast = current.lastMessage;
    final nextLast = next.lastMessage;
    if (currentLast == null || nextLast == null) return false;
    if (currentLast.messageId.isNotEmpty &&
        nextLast.messageId.isNotEmpty &&
        currentLast.messageId == nextLast.messageId) {
      return true;
    }
    return current.lastMessageSeq > 0 &&
        next.lastMessageSeq > 0 &&
        current.lastMessageSeq == next.lastMessageSeq;
  }

  @override
  Future<void> updateConversationDraft(
    String spaceId,
    String conversationId,
    String? draft,
  ) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await db.update(
        'conversations',
        {'draft': draft},
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
      );
    });
  }

  @override
  Future<void> clearConversationMessages(
      String spaceId, String conversationId) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      final table = _messageTable(conversationId);
      final tableExists = await _tableExists(db, table);
      if (!tableExists) return;
      await db.delete(table);
    });
  }

  @override
  Future<void> deleteConversation(String spaceId, String conversationId) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await db.delete(
        'conversations',
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
      );
      final table = _messageTable(conversationId);
      if (await _tableExists(db, table)) await db.delete(table);
    });
  }

  @override
  Future<int> deleteConversationLocally(
    String spaceId,
    String conversationId, {
    required int deletedThroughSeqHint,
  }) {
    return _runGuardedWrite(
      () => _deletionBoundaries.deleteConversationLocally(
        spaceId,
        conversationId,
        deletedThroughSeqHint: deletedThroughSeqHint,
      ),
    );
  }

  @override
  Future<int> applyConversationClearWatermark(
    String spaceId,
    String conversationId, {
    required int clearedSeq,
  }) {
    return _runGuardedWrite(
      () => _deletionBoundaries.applyClearWatermark(
        spaceId,
        conversationId,
        clearedSeq: clearedSeq,
      ),
    );
  }

  @override
  Future<int> applyConversationDeletion(
    String spaceId,
    String conversationId, {
    required int clearedSeq,
    bool isNewDeletion = false,
  }) {
    return _runGuardedWrite(
      () => _deletionBoundaries.applyConversationDeletion(
        spaceId,
        conversationId,
        clearedSeq: clearedSeq,
        isNewDeletion: isNewDeletion,
      ),
    );
  }

  @override
  Future<int?> getConversationDeletionBoundary(
    String spaceId,
    String conversationId,
  ) {
    return _deletionBoundaries.read(spaceId, conversationId);
  }

  @override
  ConversationDeletionState? getConfirmedConversationDeletionState(
          String spaceId, String conversationId) =>
      _deletionBoundaries.confirmedState(spaceId, conversationId);

  @override
  Future<ConversationDeletionState> getConversationDeletionState(
          String spaceId, String conversationId) =>
      _deletionBoundaries.readState(spaceId, conversationId);

  @override
  Future<Map<String, int>> getConversationDeletionBoundaries(String spaceId) {
    return _deletionBoundaries.readAll(spaceId);
  }

  @override
  Future<Map<String, int>> getConversationClearWatermarks(String spaceId) {
    return _deletionBoundaries.readAllWatermarks(spaceId);
  }

  @override
  Future<void> deleteDatabase(String spaceId) async {
    await _databaseDeleter(spaceId);
    _deletionBoundaries.forgetSpace(spaceId);
  }

  @override
  Future<void> updateConversationUnreadCount(
      String spaceId, String conversationId, int unreadCount) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await db.update(
        'conversations',
        {'unread_count': unreadCount},
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
      );
    });
  }

  @override
  Future<void> updateConversationReadState(
    String spaceId,
    String conversationId, {
    required int readSeq,
    int? unreadCount,
  }) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await db.transaction((txn) async {
        final rows = await txn.query('conversations',
            where: 'conversation_id = ?', whereArgs: [conversationId]);
        if (rows.isEmpty) return;
        final current = _rowToConversation(rows.single);
        final updated = const ConversationReadStatePolicy().advanceReadCursor(
          unreadCount == null
              ? current
              : current.copyWith(unreadCount: unreadCount),
          readSeq,
        );
        await txn.update(
          'conversations',
          {
            'last_read_seq': updated.lastReadSeq,
            'unread_count': updated.unreadCount,
          },
          where: 'conversation_id = ?',
          whereArgs: [conversationId],
        );
      });
    });
  }

  @override
  Future<void> markConversationReadAndEnqueue(
    String spaceId,
    String conversationId, {
    required bool isGroup,
    required int readSeq,
  }) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      final normalizedSeq = readSeq < 0 ? 0 : readSeq;
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.transaction((txn) async {
        await txn.rawUpdate(
          '''
        UPDATE conversations
        SET last_read_seq = MAX(last_read_seq, ?), unread_count = 0
        WHERE conversation_id = ?
        ''',
          [normalizedSeq, conversationId],
        );
        await txn.rawInsert(
          '''
        INSERT INTO pending_read_receipts (
          conversation_id, is_group, read_seq, updated_at
        ) VALUES (?, ?, ?, ?)
        ON CONFLICT(conversation_id) DO UPDATE SET
          is_group = excluded.is_group,
          read_seq = MAX(pending_read_receipts.read_seq, excluded.read_seq),
          updated_at = excluded.updated_at
        ''',
          [conversationId, isGroup ? 1 : 0, normalizedSeq, now],
        );
      });
    });
  }

  @override
  Future<List<PendingReadReceipt>> getPendingReadReceipts(
      String spaceId) async {
    final db = await _databaseProvider(spaceId);
    final rows = await db.query(
      'pending_read_receipts',
      orderBy: 'updated_at ASC',
    );
    return rows
        .map(
          (row) => PendingReadReceipt(
            conversationId: row['conversation_id'] as String,
            isGroup: (row['is_group'] as int) == 1,
            readSeq: row['read_seq'] as int,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(
              row['updated_at'] as int,
            ),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> acknowledgePendingReadReceipt(
    String spaceId,
    String conversationId, {
    required int throughSeq,
  }) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await db.delete(
        'pending_read_receipts',
        where: 'conversation_id = ? AND read_seq <= ?',
        whereArgs: [conversationId, throughSeq],
      );
    });
  }

  @override
  Future<void> markMessageRecalled(
      String spaceId, String conversationId, String messageId) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      final table = _messageTable(conversationId);
      final tableExists = await _tableExists(db, table);
      if (!tableExists) return;
      await db.update(
        table,
        {'is_recalled': 1},
        where: 'message_id = ?',
        whereArgs: [messageId],
      );
      await _searchIndex.deleteMessage(spaceId, conversationId, messageId);
    });
  }

  @override
  Future<void> markOwnMessagesReadByPeer(
    String spaceId,
    String conversationId, {
    required String currentUserId,
    required int readSeq,
  }) async {
    if (currentUserId.trim().isEmpty || readSeq <= 0) return;
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await _ensureMessageTable(db, conversationId);
      final table = _messageTable(conversationId);
      await db.update(
        table,
        {
          'is_read_by_peer': 1,
          'status': MessageStatus.read.wireName,
        },
        where: '''
        conversation_seq > 0
        AND conversation_seq <= ?
        AND is_recalled = 0
        AND (
          is_self = 1
          OR lower(sender_user_id) = lower(?)
        )
        AND status NOT IN (?, ?, ?, ?)
      ''',
        whereArgs: [
          readSeq,
          currentUserId,
          MessageStatus.failed.wireName,
          MessageStatus.rejected.wireName,
          MessageStatus.recalled.wireName,
          MessageStatus.deletedLocal.wireName,
        ],
      );
    });
  }

  // ── 旧方法委托（保持接口兼容）────────────────────────────────────────────

  @override
  Future<List<Conversation>?> getCachedConversations(String spaceId) async {
    final list = await getConversations(spaceId);
    if (list.isNotEmpty) return list;
    final db = await _databaseProvider(spaceId);
    final marker = await db.query(
      'migration_flags',
      columns: const ['value'],
      where: 'key = ?',
      whereArgs: const [_conversationSnapshotReadyKey],
      limit: 1,
    );
    return marker.isEmpty ? null : const <Conversation>[];
  }

  @override
  Future<void> cacheConversations(
      String spaceId, List<Conversation> conversations) async {
    if (conversations.isNotEmpty) {
      await upsertConversations(spaceId, conversations);
      await _runGuardedWrite(() async {
        final db = await _databaseProvider(spaceId);
        await db.insert(
          'migration_flags',
          const {'key': _conversationSnapshotReadyKey, 'value': '1'},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
      return;
    }

    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await db.transaction((txn) async {
        final rows = await txn.query(
          'conversations',
          columns: const ['conversation_id', 'draft'],
        );
        for (final row in rows) {
          final conversationId = row['conversation_id'] as String;
          final draft = (row['draft'] as String?)?.trim();
          if (draft?.isNotEmpty == true ||
              await _hasLocalOnlyMessage(txn, conversationId)) {
            continue;
          }
          await txn.delete(
            'conversations',
            where: 'conversation_id = ?',
            whereArgs: [conversationId],
          );
        }
        await txn.insert(
          'migration_flags',
          const {'key': _conversationSnapshotReadyKey, 'value': '1'},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    });
  }

  Future<bool> _hasLocalOnlyMessage(
    DatabaseExecutor db,
    String conversationId,
  ) async {
    final table = _messageTable(conversationId);
    if (!await _tableExists(db, table)) return false;
    final rows = await db.query(
      table,
      columns: const ['message_id'],
      where: 'conversation_seq <= 0 OR status IN (?, ?, ?)',
      whereArgs: const ['sending', 'failed', 'rejected'],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  @override
  Future<List<Message>?> getCachedMessages(
      String spaceId, String conversationId) async {
    final list = await getMessages(spaceId, conversationId);
    return list.isEmpty ? null : list;
  }

  @override
  Future<void> cacheMessages(
      String spaceId, String conversationId, List<Message> messages) async {
    await upsertMessages(spaceId, conversationId, messages);
  }

  @override
  Future<void> upsertMessage(
      String spaceId, String conversationId, Message message) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      await _ensureMessageTable(db, conversationId);
      final table = _messageTable(conversationId);
      var accepted = false;
      await db.transaction((txn) async {
        final deletion = await _deletionBoundaries.readStateWithExecutor(
            txn, conversationId);
        final visible = ConversationDeletionPolicy.visibleMessages(
          [message],
          deletedThroughSeq: deletion.deletedThroughSeq,
          explicitDeletedAt: deletion.explicitDeletedAt,
        );
        if (visible.isEmpty) return;
        final acceptedMessages = await _withoutSupersededOptimisticMessages(
          txn,
          table,
          visible,
        );
        if (acceptedMessages.isEmpty) return;
        await _deleteSupersededOptimisticRows(
          txn,
          table,
          acceptedMessages,
        );
        final batch = txn.batch();
        final acceptedMessage = acceptedMessages.single;
        batch.insert(table, _messageToRow(acceptedMessage),
            conflictAlgorithm: ConflictAlgorithm.replace);
        await batch.commit(noResult: true);
        accepted = true;
      });
      if (!accepted) return;
      await _searchIndex.upsertMessages(spaceId, conversationId, [message]);
    });
  }

  @override
  Future<Message?> updateExistingLinkPreview(
    String spaceId,
    String conversationId,
    Message snapshot,
  ) async {
    return _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      final table = _messageTable(conversationId);
      if (!await _tableExists(db, table)) return null;
      Message? updated;
      await db.transaction((txn) async {
        final rows = await txn.query(
          table,
          where: 'message_id = ?',
          whereArgs: [snapshot.messageId],
          limit: 1,
        );
        if (rows.isEmpty) return;
        updated =
            mergeLinkPreviewSnapshot(_rowToMessage(rows.single), snapshot);
        if (updated != null) {
          await txn.update(
            table,
            _messageToRow(updated!),
            where: 'message_id = ?',
            whereArgs: [snapshot.messageId],
          );
        }
      });
      if (updated != null) {
        await _searchIndex.upsertMessages(spaceId, conversationId, [updated!]);
      }
      return updated;
    });
  }

  @override
  Future<void> deleteMessage(
      String spaceId, String conversationId, String messageId) async {
    await _runGuardedWrite(() async {
      final db = await _databaseProvider(spaceId);
      final table = _messageTable(conversationId);
      final tableExists = await _tableExists(db, table);
      if (!tableExists) return;
      await db.delete(
        table,
        where: 'message_id = ? OR client_msg_id = ?',
        whereArgs: [messageId, messageId],
      );
      await _searchIndex.deleteMessage(spaceId, conversationId, messageId);
    });
  }

  // ── 内部工具 ──────────────────────────────────────────────────────────────

  Future<void> _deleteSupersededOptimisticRows(
    DatabaseExecutor db,
    String table,
    Iterable<Message> messages,
  ) async {
    final confirmedClientIds = messages
        .where((message) => message.conversationSeq > 0)
        .map((message) => message.clientMsgId?.trim())
        .whereType<String>()
        .where((clientMsgId) => clientMsgId.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (confirmedClientIds.isEmpty) return;

    final placeholders = List.filled(confirmedClientIds.length, '?').join(',');
    final duplicateRows = await db.query(
      table,
      columns: const ['message_id', 'conversation_id'],
      where: 'conversation_seq <= 0 AND client_msg_id IN ($placeholders)',
      whereArgs: confirmedClientIds,
    );
    if (duplicateRows.isEmpty) return;

    final duplicateMessageIds = duplicateRows
        .map((row) => row['message_id'])
        .whereType<String>()
        .toList(growable: false);
    if (duplicateMessageIds.isEmpty) return;
    final idPlaceholders =
        List.filled(duplicateMessageIds.length, '?').join(',');
    await db.delete(
      table,
      where: 'message_id IN ($idPlaceholders)',
      whereArgs: duplicateMessageIds,
    );

    final conversationId = duplicateRows.first['conversation_id'] as String?;
    if (conversationId == null) return;
    for (final indexTable in const <String>[
      'chat_message_search_index',
      'chat_media_index',
    ]) {
      if (!await _tableExists(db, indexTable)) continue;
      await db.delete(
        indexTable,
        where: 'conversation_id = ? AND message_id IN ($idPlaceholders)',
        whereArgs: [conversationId, ...duplicateMessageIds],
      );
    }
  }

  Future<List<Message>> _withoutSupersededOptimisticMessages(
    DatabaseExecutor db,
    String table,
    Iterable<Message> messages,
  ) async {
    final candidates = messages.toList(growable: false);
    final confirmedClientIds = candidates
        .where((message) => message.conversationSeq > 0)
        .map((message) => message.clientMsgId?.trim())
        .whereType<String>()
        .where((clientMsgId) => clientMsgId.isNotEmpty)
        .toSet();
    final accepted = <Message>[];
    for (final message in candidates) {
      final clientMsgId = message.clientMsgId?.trim();
      if (message.conversationSeq > 0 ||
          clientMsgId == null ||
          clientMsgId.isEmpty) {
        accepted.add(message);
        continue;
      }
      if (confirmedClientIds.contains(clientMsgId)) continue;
      final confirmedRows = await db.query(
        table,
        columns: const ['message_id'],
        where: 'client_msg_id = ? AND conversation_seq > 0',
        whereArgs: [clientMsgId],
        limit: 1,
      );
      if (confirmedRows.isEmpty) accepted.add(message);
    }
    return accepted;
  }

  Future<bool> _tableExists(DatabaseExecutor db, String tableName) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  Future<void> _ensureColumn(
    Database db,
    String tableName,
    String columnName,
    String definition,
  ) async {
    final columns = await db.rawQuery('PRAGMA table_info($tableName)');
    final exists = columns.any((row) => row['name'] == columnName);
    if (!exists) {
      try {
        await db.execute(
          'ALTER TABLE $tableName ADD COLUMN $columnName $definition',
        );
      } catch (error) {
        if (isDuplicateColumnSqliteError(error, columnName)) return;
        rethrow;
      }
    }
  }

  Future<void> _ensureConversationLastMessageColumns(Database db) async {
    await _ensureColumn(
      db,
      'conversations',
      'last_message_is_self',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _ensureColumn(db, 'conversations', 'last_message_direction', 'TEXT');
    await _ensureColumn(db, 'conversations', 'last_message_mentions', 'TEXT');
  }
}

@visibleForTesting
bool isDuplicateColumnSqliteError(Object error, String columnName) {
  final message = error.toString().toLowerCase();
  final normalizedColumn = columnName.toLowerCase();
  return message.contains('duplicate column name') &&
      message.contains(normalizedColumn);
}
