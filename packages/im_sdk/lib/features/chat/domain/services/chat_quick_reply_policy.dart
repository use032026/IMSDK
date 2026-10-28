class ChatQuickReplyPolicy {
  const ChatQuickReplyPolicy();

  String? scopeFor({
    required bool isGroup,
    required bool canReadQuickReplies,
    String? customerServiceThreadType,
  }) {
    if (!canReadQuickReplies) return null;
    if (isGroup) return 'all';
    return customerServiceThreadType == 'temp_session'
        ? 'temp_session'
        : 'direct_customer';
  }
}
