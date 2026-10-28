class ChatTextSendDraftPolicy {
  const ChatTextSendDraftPolicy();

  String resolveAfterSend({
    required bool sent,
    required String sentText,
    required String currentInput,
    bool preserveSourceOnFailure = false,
  }) {
    if (currentInput.isNotEmpty) return currentInput;
    return !sent && preserveSourceOnFailure ? sentText : '';
  }
}
