import 'package:im_sdk/features/chat/domain/entities/message.dart';

enum ChatSendAction {
  text,
  media,
  file,
  voice,
  location,
  contactCard,
  retryFailed,
}

bool shouldShowSendFailureSnack(MessageType type) {
  return switch (type) {
    MessageType.text || MessageType.markdown || MessageType.link => false,
    _ => true,
  };
}

bool shouldBlockChatSendAction(
  ChatSendAction action, {
  required bool isSingleActionRunning,
}) {
  if (!isSingleActionRunning) return false;
  return switch (action) {
    ChatSendAction.text ||
    ChatSendAction.media ||
    ChatSendAction.file ||
    ChatSendAction.voice ||
    ChatSendAction.contactCard =>
      false,
    ChatSendAction.location || ChatSendAction.retryFailed => true,
  };
}
