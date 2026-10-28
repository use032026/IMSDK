import 'package:im_sdk/features/chat/domain/entities/message.dart';

typedef ConversationDeletionState = ({
  int? deletedThroughSeq,
  DateTime? explicitDeletedAt,
});

class ConversationDeletionPolicy {
  const ConversationDeletionPolicy._();

  static List<Message> visibleMessages(
    Iterable<Message> messages, {
    required int? deletedThroughSeq,
    DateTime? explicitDeletedAt,
  }) {
    return messages
        .where((message) => message.conversationSeq <= 0
            ? explicitDeletedAt == null ||
                message.sentAt.isAfter(explicitDeletedAt)
            : deletedThroughSeq == null ||
                message.conversationSeq > deletedThroughSeq)
        .toList(growable: false);
  }
}
