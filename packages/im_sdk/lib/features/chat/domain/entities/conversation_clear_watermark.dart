class ConversationClearWatermark {
  final String conversationId;
  final int clearedSeq;

  const ConversationClearWatermark({
    required this.conversationId,
    required this.clearedSeq,
  });
}

class ConversationDeletionResult extends ConversationClearWatermark {
  const ConversationDeletionResult({
    required super.conversationId,
    required super.clearedSeq,
  });
}
