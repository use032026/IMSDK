class ChatDraftHydrationPolicy {
  const ChatDraftHydrationPolicy();

  bool shouldHydrate({
    required String currentConversationId,
    required String previousConversationId,
    required String? incomingDraft,
    required String currentInput,
    required bool hasLocalInputInteraction,
    required bool wasClearedBySend,
  }) {
    final draft = incomingDraft;
    if (draft == null) return false;

    final switchedConversation =
        currentConversationId != previousConversationId;
    if (switchedConversation) {
      return currentInput.isEmpty;
    }

    if (hasLocalInputInteraction || wasClearedBySend) return false;
    if (draft.trim().isEmpty) return currentInput.isNotEmpty;
    return currentInput.isEmpty;
  }
}
