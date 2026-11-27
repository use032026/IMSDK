import 'package:im_sdk/features/chat/data/models/conversation_model.dart';
import 'package:im_sdk/features/chat/data/models/message_model.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';

/// Anti-corruption model for one conversation item returned by `GET /sync`.
class GatewaySyncConversationModel {
  final String conversationId;
  final ConversationType? conversationType;
  final int lastReadSeq;
  final List<Message> messages;

  const GatewaySyncConversationModel({
    required this.conversationId,
    required this.conversationType,
    required this.lastReadSeq,
    required this.messages,
  });

  static GatewaySyncConversationModel? tryParse(
    Map<String, dynamic> json, {
    required String currentUserId,
  }) {
    final conversationId = (json['conversationId'] as String?)?.trim() ?? '';
    if (conversationId.isEmpty) return null;

    final normalizedUserId = currentUserId.trim().toLowerCase();
    final rawMessages = json['messages'];
    if (rawMessages is! List) {
      throw const FormatException('Invalid sync messages list');
    }
    final messages = rawMessages.map((raw) {
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Invalid sync message record');
      }
      final message = MessageModel.fromJson(raw);
      if (message.conversationId != conversationId ||
          message.messageId.trim().isEmpty ||
          message.conversationSeq <= 0) {
        throw const FormatException('Invalid sync message identity');
      }
      final senderUserId = message.senderUserId.trim().toLowerCase();
      final isSelf = message.isSelf ||
          (normalizedUserId.isNotEmpty && senderUserId == normalizedUserId);
      return isSelf == message.isSelf
          ? message
          : message.copyWith(isSelf: true);
    }).toList(growable: false);

    final rawLastReadSeq = json['lastReadSeq'];
    final lastReadSeq = rawLastReadSeq is num
        ? rawLastReadSeq.toInt()
        : int.tryParse(rawLastReadSeq?.toString() ?? '') ?? 0;
    final rawConversationType =
        (json['conversationType'] ?? json['type'])?.toString().trim();
    final normalizedConversationType =
        rawConversationType?.toLowerCase().replaceAll('-', '_');
    final conversationType = const {
      'direct',
      'group',
      'temp_session',
    }.contains(normalizedConversationType)
        ? ConversationModel.parseType(rawConversationType)
        : null;
    return GatewaySyncConversationModel(
      conversationId: conversationId,
      conversationType: conversationType,
      lastReadSeq: lastReadSeq < 0 ? 0 : lastReadSeq,
      messages: messages,
    );
  }
}
