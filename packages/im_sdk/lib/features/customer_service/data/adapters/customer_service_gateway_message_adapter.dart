import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_unread_ledger.dart';

CustomerServiceIncomingMessage? adaptCustomerServiceGatewayMessage({
  required Map<String, dynamic> payload,
  required Message message,
  required String? currentUserId,
  Iterable<CustomerServiceThreadIdentity> knownThreads = const [],
}) {
  final records = _candidateRecords(payload);
  final conversationId = _firstString(records, const [
        'conversationId',
        'conversation_id',
        'chatId',
        'chat_id',
      ]) ??
      message.conversationId;
  final explicitThreadId = _firstString(records, const [
    'threadId',
    'thread_id',
    'sessionId',
    'session_id',
    'tempSessionId',
    'visitorSessionId',
  ]);
  final knownThread =
      knownThreads.cast<CustomerServiceThreadIdentity?>().firstWhere(
            (thread) =>
                thread?.matches(
                  threadId: explicitThreadId ?? '',
                  conversationId: conversationId,
                ) ==
                true,
            orElse: () => null,
          );
  final explicitType = _firstCustomerServiceThreadType(records);
  final hasTempSessionIdentity = _firstString(records, const [
        'sessionId',
        'session_id',
        'tempSessionId',
        'visitorSessionId',
      ]) !=
      null;
  final sourceType = _normalize(_firstString(records, const [
    'sourceType',
    'source_type',
  ]));
  final domainMarker = _firstCustomerServiceDomainMarker(records);
  final isCustomerService = knownThread != null ||
      explicitType != null ||
      hasTempSessionIdentity ||
      sourceType == 'widget' ||
      domainMarker != null;
  if (!isCustomerService) return null;

  final threadType = knownThread?.threadType ??
      explicitType ??
      (hasTempSessionIdentity ||
              sourceType == 'widget' ||
              domainMarker == 'temp_session'
          ? 'temp_session'
          : 'im_direct');
  final threadId = explicitThreadId ?? knownThread?.threadId ?? conversationId;
  if (threadId.trim().isEmpty || conversationId.trim().isEmpty) return null;

  return CustomerServiceIncomingMessage(
    kind: message.type == MessageType.event
        ? CustomerServiceIncomingItemKind.timelineEvent
        : CustomerServiceIncomingItemKind.message,
    threadType: threadType,
    threadId: threadId,
    conversationId: conversationId,
    messageId: message.messageId.isNotEmpty
        ? message.messageId
        : (message.clientMsgId ?? ''),
    conversationSeq: message.conversationSeq,
    sentAt: message.sentAt,
    preview: _messagePreview(message),
    isSelf: _isSelfMessage(
      payload: payload,
      message: message,
      currentUserId: currentUserId,
    ),
  );
}

String? _messagePreview(Message message) {
  if (message.type == MessageType.link) {
    return message.body.link?.displayTitle ?? message.body.text ?? '[链接]';
  }
  final text = message.body.text?.trim();
  if (text != null && text.isNotEmpty) return text;
  switch (message.type) {
    case MessageType.text:
    case MessageType.markdown:
      return null;
    case MessageType.image:
      return '[图片]';
    case MessageType.video:
      return '[视频]';
    case MessageType.voice:
      return '[语音]';
    case MessageType.file:
      return '[文件]';
    case MessageType.event:
      return message.body.event?.trim().isNotEmpty == true
          ? message.body.event!.trim()
          : '[系统消息]';
    case MessageType.contactCard:
      return '[名片]';
    case MessageType.callLog:
      return '[通话]';
    case MessageType.location:
      return '[位置]';
    case MessageType.link:
      return '[链接]';
  }
}

List<Map<String, dynamic>> _candidateRecords(Map<String, dynamic> payload) {
  return [
    payload,
    if (_asMap(payload['message']) case final record?) record,
    if (_asMap(payload['msg']) case final record?) record,
    if (_asMap(payload['thread']) case final record?) record,
    if (_asMap(payload['tempSession']) case final record?) record,
    if (_asMap(payload['temp_session']) case final record?) record,
    if (_asMap(payload['conversation']) case final record?) record,
    if (_asMap(payload['chat']) case final record?) record,
  ];
}

String? _firstCustomerServiceThreadType(
  Iterable<Map<String, dynamic>> records,
) {
  for (final record in records) {
    for (final key in const [
      'threadType',
      'thread_type',
      'sourceType',
      'source_type',
      'conversationType',
      'conversation_type',
    ]) {
      final normalized = _normalize(_string(record[key]));
      if (normalized == 'temp_session') return 'temp_session';
      if (normalized == 'im_direct' || normalized == 'direct_customer') {
        return 'im_direct';
      }
    }
  }
  return null;
}

String? _firstCustomerServiceDomainMarker(
  Iterable<Map<String, dynamic>> records,
) {
  for (final record in records) {
    for (final key in const [
      'targetModule',
      'target_module',
      'module',
      'channel',
      'route',
      'scenario',
      'scene',
      'sourceType',
      'source_type',
    ]) {
      final normalized = _normalize(_string(record[key]));
      if (normalized == 'widget' ||
          normalized == 'temp_session' ||
          normalized == 'customer_service' ||
          normalized == 'online_service' ||
          normalized == 'onlineservice' ||
          normalized == 'service_queue' ||
          normalized == 'servicequeue' ||
          normalized.contains('customer_service') ||
          normalized.contains('online_service')) {
        return normalized == 'im_direct' ? 'im_direct' : 'temp_session';
      }
    }
  }
  return null;
}

String? _firstString(
  Iterable<Map<String, dynamic>> records,
  Iterable<String> keys,
) {
  for (final record in records) {
    for (final key in keys) {
      final value = _string(record[key]);
      if (value != null) return value;
    }
  }
  return null;
}

bool _isSelfMessage({
  required Map<String, dynamic> payload,
  required Message message,
  required String? currentUserId,
}) {
  if (message.operatorUserId != null) {
    return message.operatorUserId == currentUserId;
  }
  if (message.isSelf) return true;
  final records = _candidateRecords(payload);
  for (final record in records) {
    if (record['isSelf'] == true || record['isMine'] == true) return true;
    final roleText = [
      _string(record['senderRole']),
      _string(record['sender_role']),
      _string(record['senderType']),
      _string(record['sender_type']),
      _string(record['authorType']),
      _string(record['author_type']),
      _string(record['fromType']),
      _string(record['from_type']),
      _string(record['role']),
    ].map(_normalize).join('|');
    if (const {
      'visitor',
      'guest',
      'customer',
      'client',
      'user',
      'end_user',
      'widget',
    }.any(roleText.contains)) {
      return false;
    }
    final direction = _normalize(_string(record['direction']));
    if (const {'in', 'incoming', 'inbound', 'received', 'receive'}
        .contains(direction)) {
      return false;
    }
    if (const {'out', 'outgoing', 'sent', 'self'}.contains(direction)) {
      return true;
    }
  }
  final userId = currentUserId?.trim();
  return userId != null &&
      userId.isNotEmpty &&
      message.senderUserId.trim() == userId;
}

String _normalize(String? value) =>
    (value ?? '').trim().toLowerCase().replaceAll('-', '_');

String? _string(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}
