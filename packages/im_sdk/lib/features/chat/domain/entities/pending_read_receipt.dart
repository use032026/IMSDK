class PendingReadReceipt {
  const PendingReadReceipt({
    required this.conversationId,
    required this.isGroup,
    required this.readSeq,
    required this.updatedAt,
  });

  final String conversationId;
  final bool isGroup;
  final int readSeq;
  final DateTime updatedAt;
}
