import 'package:im_sdk/features/chat/domain/entities/message.dart';

/// Keeps locally-originated messages owned by the active account when a
/// server response replaces an optimistic or pending message.
class OutgoingMessagePolicy {
  const OutgoingMessagePolicy._();

  static Message confirm({
    required Message message,
    required String clientMsgId,
    required String currentUserId,
    List<Mention>? mentions,
  }) {
    return message.copyWith(
      clientMsgId: clientMsgId,
      senderUserId:
          message.operatorUserId == null ? currentUserId : message.senderUserId,
      status: MessageStatus.sent,
      mentions: mentions,
      isSelf: true,
      clearLocalUploadState: true,
    );
  }
}
