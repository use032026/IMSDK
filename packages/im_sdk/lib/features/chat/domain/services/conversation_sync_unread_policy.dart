import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';

class ConversationSyncUnreadProjection {
  final int lastReadSeq;
  final int unreadCount;

  const ConversationSyncUnreadProjection({
    required this.lastReadSeq,
    required this.unreadCount,
  });
}

/// Reconciles an incremental `/sync` batch without treating the local message
/// cache as a complete unread ledger.
class ConversationSyncUnreadPolicy {
  const ConversationSyncUnreadPolicy();

  ConversationSyncUnreadProjection project({
    required Conversation? existing,
    required int resolvedLastMessageSeq,
    required int serverLastReadSeq,
    required int knownNewlyReadMessageCount,
    required List<Message> syncedMessages,
  }) {
    final existingReadSeq = existing?.lastReadSeq ?? 0;
    final normalizedServerReadSeq =
        serverLastReadSeq < 0 ? 0 : serverLastReadSeq;
    final lastReadSeq = normalizedServerReadSeq > existingReadSeq
        ? normalizedServerReadSeq
        : existingReadSeq;
    final existingLastMessageSeq = existing?.lastMessageSeq ?? 0;
    var unreadCount = existing?.unreadCount ?? 0;
    if (unreadCount < 0) unreadCount = 0;

    if (existingLastMessageSeq > 0 && lastReadSeq >= existingLastMessageSeq) {
      unreadCount = 0;
    } else if (knownNewlyReadMessageCount > 0) {
      unreadCount -= knownNewlyReadMessageCount;
      if (unreadCount < 0) unreadCount = 0;
    }

    final baselineSeq = existingLastMessageSeq > lastReadSeq
        ? existingLastMessageSeq
        : lastReadSeq;
    final seen = <String>{};
    for (final message in syncedMessages) {
      if (message.conversationSeq <= baselineSeq ||
          message.conversationSeq <= 0 ||
          message.isSelf ||
          message.isRecalled ||
          message.type == MessageType.event ||
          !message.status.isServerUsable) {
        continue;
      }
      // conversationSeq is the server's unique, monotonic identity inside a
      // conversation. It also protects against malformed retries that carry
      // the same sequence under a different message id.
      final identity = 'seq:${message.conversationSeq}';
      if (seen.add(identity)) unreadCount++;
    }

    if (resolvedLastMessageSeq > 0 && lastReadSeq >= resolvedLastMessageSeq) {
      unreadCount = 0;
    }
    return ConversationSyncUnreadProjection(
      lastReadSeq: lastReadSeq,
      unreadCount: unreadCount,
    );
  }
}
