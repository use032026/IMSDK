import 'package:im_sdk/features/chat/domain/entities/message.dart';

class MessageContextCapabilities {
  final bool canUseServerMessage;
  final bool canMultiSelect;
  final bool canReply;
  final bool canAiReply;
  final bool canCopy;
  final bool canVoiceToText;
  final bool canTextToSpeech;
  final bool canTranslate;
  final bool canSaveToAlbum;
  final bool canForward;
  final bool canFavorite;
  final bool canRecall;
  final bool canDelete;

  const MessageContextCapabilities({
    required this.canUseServerMessage,
    required this.canMultiSelect,
    required this.canReply,
    required this.canAiReply,
    required this.canCopy,
    required this.canVoiceToText,
    required this.canTextToSpeech,
    required this.canTranslate,
    required this.canSaveToAlbum,
    required this.canForward,
    required this.canFavorite,
    required this.canRecall,
    required this.canDelete,
  });
}

MessageContextCapabilities messageContextCapabilities(
  Message message, {
  required String currentUserId,
  bool allowAiReply = false,
  DateTime? now,
}) {
  final isText =
      message.type == MessageType.text || message.type == MessageType.markdown;
  final isCopyableText = isText || message.type == MessageType.link;
  final isVoice = message.type == MessageType.voice;
  final isImageOrVideo =
      message.type == MessageType.image || message.type == MessageType.video;
  final isCallLog = message.type == MessageType.callLog;
  final isSent = message.status.isServerUsable;
  final canUseServerMessage = !message.isRecalled && isSent;
  final hasText = message.body.text?.isNotEmpty ?? false;
  final hasTrimmedText = message.body.text?.trim().isNotEmpty ?? false;
  final isSelf = message.operatorUserId == null
      ? message.senderUserId == currentUserId
      : message.operatorUserId == currentUserId;
  final elapsed = (now ?? DateTime.now()).difference(message.sentAt);

  return MessageContextCapabilities(
    canUseServerMessage: canUseServerMessage,
    canMultiSelect: canUseServerMessage,
    canReply: canUseServerMessage && message.type != MessageType.event,
    canAiReply: allowAiReply &&
        !isSelf &&
        canUseServerMessage &&
        isText &&
        hasTrimmedText,
    canCopy: !message.isRecalled && isCopyableText && hasText,
    canVoiceToText: canUseServerMessage && isVoice,
    canTextToSpeech: canUseServerMessage && isText && hasTrimmedText,
    canTranslate: canUseServerMessage && isText,
    canSaveToAlbum: canUseServerMessage && isImageOrVideo,
    canForward: canUseServerMessage && !isCallLog,
    canFavorite: canUseServerMessage,
    canRecall: isSelf && isSent && elapsed.inMinutes < 2,
    canDelete: true,
  );
}

String? latestAiReplyPeerText(
  List<Message>? messages, {
  required String currentUserId,
}) {
  if (messages == null || messages.isEmpty) return null;
  for (final message in messages.reversed) {
    final capabilities = messageContextCapabilities(
      message,
      currentUserId: currentUserId,
      allowAiReply: true,
    );
    if (!capabilities.canAiReply) continue;
    return message.body.text!.trim();
  }
  return null;
}
