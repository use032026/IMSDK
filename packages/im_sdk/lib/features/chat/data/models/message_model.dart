import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/data/models/message_payload_classifier.dart';

/// API 响应 → Message 实体的映射模型
class MessageModel {
  static Message fromJson(Map<String, dynamic> json) {
    final isRecalled = json['isRecalled'] as bool? ?? false;
    final direction = normalizeMessagePayloadToken(json['direction']);
    final bodyJson = _mapValue(json['body']);
    final body = MessageBody.fromJson(bodyJson);
    final isSelf = _boolValue(json['isSelf']) ||
        _boolValue(json['isMine']) ||
        const {'out', 'outgoing', 'sent', 'self'}.contains(direction);
    final status = isRecalled
        ? MessageStatus.recalled
        : parseMessageStatus(json['status'] as String?);
    return Message(
      messageId: json['messageId'] as String,
      clientMsgId: json['clientMsgId'] as String?,
      operatorUserId: _nullableString(json['operatorUserId']),
      conversationId: json['conversationId'] as String,
      conversationSeq: json['conversationSeq'] as int? ?? 0,
      senderUserId: _firstNonEmptyString(json, const [
        'senderUserId',
        'senderId',
        'fromUserId',
        'userId',
        'senderPlatformUserId',
        'platformUserId',
        'senderLppId',
        'lppId',
      ]),
      type: fromApiType(
        json['messageType'],
        body: body,
        isSystemEvent: isExplicitSystemMessagePayload(json),
      ),
      body: body,
      isRecalled: isRecalled,
      sentAt:
          DateTime.tryParse(json['sentAt'] as String? ?? '') ?? DateTime.now(),
      replyToMessageId: json['replyToMessageId'] as String?,
      forwardFromMessageId: json['forwardFromMessageId'] as String?,
      mentions: (json['mentions'] as List<dynamic>?)
          ?.map((e) => Mention.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: status,
      translation: _nullableString(json['translation']),
      translationLanguage: _nullableString(
        json['translationLanguage'] ?? json['translationTargetLanguage'],
      ),
      readCount: _intValue(json['readCount'] ?? json['read_count']),
      isReadByPeer: _boolValue(json['isReadByPeer']) ||
          _boolValue(json['readByPeer']) ||
          _boolValue(json['isRead']) ||
          json['readAt'] != null ||
          (isSelf && status == MessageStatus.read),
      failureReason: json['failureReason'] as String?,
      isSelf: isSelf,
    );
  }

  /// 从发送接口响应构建 Message（服务端只返回 messageId/conversationSeq/serverTime）
  static Message fromSendResponse(
    Map<String, dynamic> json, {
    required String clientMsgId,
    required MessageType type,
    required MessageBody body,
    required String conversationId,
    String? replyToMessageId,
    String? senderUserId,
    List<Mention>? mentions,
  }) {
    return Message(
      messageId: json['messageId'] as String,
      clientMsgId: clientMsgId,
      conversationId: json['conversationId'] as String? ?? conversationId,
      conversationSeq: json['conversationSeq'] as int? ?? 0,
      // 发送接口不返回 senderUserId，由调用方传入（当前用户 userId）
      senderUserId: senderUserId ?? '',
      type: type,
      body: body,
      isRecalled: false,
      sentAt: DateTime.tryParse(json['serverTime'] as String? ?? '') ??
          DateTime.now(),
      replyToMessageId: replyToMessageId,
      mentions: mentions,
      status: MessageStatus.sent,
      isSelf: true,
    );
  }

  static Map<String, dynamic> toJson(Message m) {
    return {
      'messageId': m.messageId,
      'clientMsgId': m.clientMsgId,
      'conversationId': m.conversationId,
      'conversationSeq': m.conversationSeq,
      'senderUserId': m.senderUserId,
      if (m.operatorUserId != null) 'operatorUserId': m.operatorUserId,
      'messageType': _typeToString(m.type),
      'body': m.body.toJson(),
      'isRecalled': m.isRecalled,
      'sentAt': m.sentAt.toIso8601String(),
      'replyToMessageId': m.replyToMessageId,
      'forwardFromMessageId': m.forwardFromMessageId,
      'mentions': m.mentions?.map((e) => e.toJson()).toList(),
      'status': m.status.wireName,
      if (m.translation != null) 'translation': m.translation,
      if (m.translationLanguage != null)
        'translationLanguage': m.translationLanguage,
      'readCount': m.readCount,
      'isReadByPeer': m.isReadByPeer,
      'isSelf': m.isSelf,
      if (m.failureReason != null) 'failureReason': m.failureReason,
    };
  }

  /// Maps a domain message type to the current server transport contract.
  ///
  /// Link remains a first-class domain type, while the server-compatible wire
  /// type is text and the structured semantics live in `body.link`.
  static String toApiType(MessageType type) {
    if (type == MessageType.link) return 'text';
    return _typeToString(type);
  }

  static MessageType fromApiType(
    Object? raw, {
    required MessageBody body,
    bool isSystemEvent = false,
  }) {
    final type = normalizeMessagePayloadToken(raw);
    if (isSystemEvent) return MessageType.event;
    if (type == 'text' && body.link != null) return MessageType.link;

    switch (type) {
      case 'markdown':
        return MessageType.markdown;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'voice':
        return MessageType.voice;
      case 'file':
        return MessageType.file;
      case 'event':
        return MessageType.event;
      case 'contact_card':
        return MessageType.contactCard;
      case 'call_log':
        return MessageType.callLog;
      case 'location':
        return MessageType.location;
      case 'link':
        return MessageType.link;
      default:
        return MessageType.text;
    }
  }

  static String? _nullableString(Object? value) {
    if (value is! String) return null;
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  static String _firstNonEmptyString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = _stringValue(json[key]);
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  static String _stringValue(Object? value) {
    if (value == null) return '';
    final text = value.toString().trim();
    return text;
  }

  static Map<String, dynamic> _mapValue(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return const {};
  }

  static bool _boolValue(Object? value) {
    return value == true || value == 'true' || value == 1 || value == '1';
  }

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _typeToString(MessageType type) {
    switch (type) {
      case MessageType.markdown:
        return 'markdown';
      case MessageType.image:
        return 'image';
      case MessageType.video:
        return 'video';
      case MessageType.voice:
        return 'voice';
      case MessageType.file:
        return 'file';
      case MessageType.event:
        return 'event';
      case MessageType.contactCard:
        return 'contact_card';
      case MessageType.callLog:
        return 'call_log';
      case MessageType.location:
        return 'location';
      case MessageType.link:
        return 'link';
      default:
        return 'text';
    }
  }
}
