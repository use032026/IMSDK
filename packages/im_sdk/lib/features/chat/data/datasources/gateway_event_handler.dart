import 'package:im_sdk/features/chat/data/models/message_model.dart';
import 'package:im_sdk/features/chat/data/models/conversation_model.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';

/// 处理 Gateway 下行事件，将原始 JSON 转换为 Domain 实体并回调给上层。
class GatewayEventHandler {
  void onMessageUpdated(
    Map<String, dynamic> data, {
    required String spaceId,
    required void Function(
      String spaceId,
      String conversationId,
      Message message,
    ) onMessage,
  }) {
    final conversationId = data['conversationId'] as String?;
    final messageId = data['messageId'] as String?;
    if (conversationId == null ||
        conversationId.isEmpty ||
        messageId == null ||
        messageId.isEmpty) {
      return;
    }
    onMessage(
      spaceId,
      conversationId,
      MessageModel.fromJson(data),
    );
  }

  /// 处理 msg.new 事件
  ///
  /// [data] 为 Gateway 推送的 `msg.new` 事件 data 字段。
  /// [onMessage] 收到新消息时回调（spaceId、conversationId、Message）。
  /// [onConversationUpdate] 需要更新会话列表时回调（spaceId、Conversation）。
  Future<void> onNewMessage(
    Map<String, dynamic> data, {
    required String spaceId,
    required void Function(
      String spaceId,
      String conversationId,
      Message message,
    ) onMessage,
    required void Function(
      String spaceId,
      Conversation conversation,
    ) onConversationUpdate,
  }) async {
    final conversationId = data['conversationId'] as String?;
    if (conversationId == null) return;

    // 将 msg.new data 转换为 Message 实体
    final message = MessageModel.fromJson(data);

    // 回调消息
    onMessage(spaceId, conversationId, message);

    // 构建最小化的 Conversation 更新（仅更新 lastMessage 和 lastActivityAt）
    final conversationType = _conversationTypeFromGatewayData(data);

    final updatedConversation = Conversation(
      conversationId: conversationId,
      type: conversationType,
      title: '',
      lastMessage: LastMessage(
        messageId: message.messageId,
        text: message.body.text,
        messageType: messageTypeToApiString(message.type),
        senderUserId: message.senderUserId,
        sentAt: message.sentAt,
        mentions: message.mentions,
      ),
      lastActivityAt: message.sentAt,
      lastMessageSeq: message.conversationSeq,
    );

    onConversationUpdate(spaceId, updatedConversation);
  }

  static String messageTypeToApiString(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 'text';
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
    }
  }
}

ConversationType _conversationTypeFromGatewayData(Map<String, dynamic> data) {
  final records = _candidateRecords(data);
  final hasTempSessionIdentity = records.any((record) {
    return const [
      'sessionId',
      'session_id',
      'tempSessionId',
      'visitorSessionId',
    ].any((key) => _stringValue(record[key])?.isNotEmpty == true);
  });
  final rawValues = <String?>[
    for (final record in records) ...[
      _stringValue(record['threadType']),
      _stringValue(record['thread_type']),
      _stringValue(record['conversationType']),
      _stringValue(record['conversation_type']),
      _stringValue(record['sourceType']),
      _stringValue(record['source_type']),
      _stringValue(record['targetModule']),
      _stringValue(record['target_module']),
      _stringValue(record['channel']),
      _stringValue(record['type']),
    ],
  ];
  if (hasTempSessionIdentity ||
      rawValues.any((value) {
        final normalized = _normalizeType(value);
        return const {
          'temp_session',
          'widget',
          'customer_service',
          'online_service',
          'onlineservice',
          'service_queue',
        }.contains(normalized);
      })) {
    return ConversationType.tempSession;
  }
  final raw = rawValues.firstWhere(
    (value) => value != null && value.trim().isNotEmpty,
    orElse: () => null,
  );
  return ConversationModel.parseType(raw);
}

List<Map<String, dynamic>> _candidateRecords(Map<String, dynamic> data) {
  return [
    data,
    if (_mapValue(data['message']) case final record?) record,
    if (_mapValue(data['msg']) case final record?) record,
    if (_mapValue(data['thread']) case final record?) record,
    if (_mapValue(data['tempSession']) case final record?) record,
    if (_mapValue(data['temp_session']) case final record?) record,
    if (_mapValue(data['conversation']) case final record?) record,
    if (_mapValue(data['chat']) case final record?) record,
  ];
}

String _normalizeType(String? value) =>
    (value ?? '').trim().toLowerCase().replaceAll('-', '_');

String? _stringValue(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

Map<String, dynamic>? _mapValue(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}
