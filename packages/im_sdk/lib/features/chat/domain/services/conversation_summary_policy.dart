import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_read_state_policy.dart';

class ConversationSummaryPolicy {
  final ConversationReadStatePolicy _readStatePolicy;

  const ConversationSummaryPolicy({
    ConversationReadStatePolicy readStatePolicy =
        const ConversationReadStatePolicy(),
  }) : _readStatePolicy = readStatePolicy;

  bool shouldAdvance({
    required Conversation current,
    required Conversation incoming,
  }) {
    final currentLast = current.lastMessage;
    final incomingLast = incoming.lastMessage;
    if (incomingLast == null) return false;
    if (currentLast == null) return true;
    if (_sameMessage(current, incoming)) return true;

    final currentSeq = current.lastMessageSeq;
    final incomingSeq = incoming.lastMessageSeq;
    if (currentSeq > 0 && incomingSeq > 0) {
      return incomingSeq > currentSeq;
    }

    final currentAt = current.lastActivityAt ?? currentLast.sentAt;
    final incomingAt = incoming.lastActivityAt ?? incomingLast.sentAt;
    return incomingAt.isAfter(currentAt);
  }

  Conversation mergeRemoteSnapshot({
    required Conversation local,
    required Conversation remote,
  }) {
    final keepLocalSummary = shouldAdvance(current: remote, incoming: local);
    final resolved = keepLocalSummary
        ? remote.copyWith(
            lastMessage: local.lastMessage,
            lastActivityAt: local.lastActivityAt,
            lastMessageSeq: local.lastMessageSeq,
          )
        : remote;
    final readState = _readStatePolicy.reconcile(
      local: local,
      remote: remote,
      resolvedLastMessageSeq: resolved.lastMessageSeq,
    );
    return resolved.copyWith(
      lastReadSeq: readState.lastReadSeq,
      unreadCount: readState.unreadCount,
    );
  }

  bool _sameMessage(Conversation left, Conversation right) {
    final leftLast = left.lastMessage;
    final rightLast = right.lastMessage;
    if (leftLast == null || rightLast == null) return false;
    if (leftLast.messageId.isNotEmpty &&
        rightLast.messageId.isNotEmpty &&
        leftLast.messageId == rightLast.messageId) {
      return true;
    }
    return left.lastMessageSeq > 0 &&
        right.lastMessageSeq > 0 &&
        left.lastMessageSeq == right.lastMessageSeq;
  }
}
