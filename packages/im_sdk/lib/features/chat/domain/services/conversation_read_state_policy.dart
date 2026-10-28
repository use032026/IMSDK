import 'package:im_sdk/features/chat/domain/entities/conversation.dart';

class ConversationReadState {
  final int lastReadSeq;
  final int unreadCount;

  const ConversationReadState({
    required this.lastReadSeq,
    required this.unreadCount,
  });
}

/// Owns the invariant between a conversation's read cursor and unread count.
///
/// A server snapshot is authoritative when it covers the same or a newer
/// message summary. A newer local realtime summary is retained until the next
/// server snapshot catches up. In all cases the read cursor is monotonic.
class ConversationReadStatePolicy {
  const ConversationReadStatePolicy();

  Conversation advanceReadCursor(Conversation conversation, int readSeq) {
    return normalize(conversation.copyWith(
      lastReadSeq: readSeq > conversation.lastReadSeq
          ? readSeq
          : conversation.lastReadSeq,
    ));
  }

  ConversationReadState reconcile({
    required Conversation local,
    required Conversation remote,
    required int resolvedLastMessageSeq,
  }) {
    final lastReadSeq = local.lastReadSeq > remote.lastReadSeq
        ? local.lastReadSeq
        : remote.lastReadSeq;
    final remoteCoversResolvedSummary =
        remote.lastMessageSeq >= resolvedLastMessageSeq;
    var unreadCount =
        remoteCoversResolvedSummary ? remote.unreadCount : local.unreadCount;

    if (unreadCount < 0) unreadCount = 0;
    if (resolvedLastMessageSeq > 0 && lastReadSeq >= resolvedLastMessageSeq) {
      unreadCount = 0;
    }

    return ConversationReadState(
      lastReadSeq: lastReadSeq,
      unreadCount: unreadCount,
    );
  }

  Conversation normalize(Conversation conversation) {
    var unreadCount = conversation.unreadCount;
    if (unreadCount < 0) unreadCount = 0;
    if (conversation.lastMessageSeq > 0 &&
        conversation.lastReadSeq >= conversation.lastMessageSeq) {
      unreadCount = 0;
    }
    if (unreadCount == conversation.unreadCount) return conversation;
    return conversation.copyWith(unreadCount: unreadCount);
  }
}
