enum PushNotificationScenario {
  message,
  call,
  security,
  friendRequest,
  unknown,
}

class PushNotificationPayload {
  final Map<String, dynamic> data;
  final PushNotificationScenario scenario;

  const PushNotificationPayload._({
    required this.data,
    required this.scenario,
  });

  factory PushNotificationPayload.fromVendorData(Map<String, dynamic> raw) {
    final data = _stringKeyed(raw);
    return PushNotificationPayload._(
      data: data,
      scenario: parseScenario(_stringValue(data, const [
            'scenario',
            'pushScenario',
            'type',
          ]) ??
          ''),
    );
  }

  factory PushNotificationPayload.fromPushNotice(Map<String, dynamic> raw) {
    final notice = _stringKeyed(raw);
    final nested = _mapValue(notice['data']) ?? const <String, dynamic>{};
    final merged = <String, dynamic>{
      ...nested,
      for (final key in const [
        'tenantId',
        'spaceId',
        'userId',
        'scenario',
        'messageId',
        'notificationId',
        'requestId',
        'entityId',
        'status',
        'route',
        'title',
        'body',
        'at',
        'accountScopeKey',
      ])
        if (notice[key] != null) key: notice[key],
    };
    return PushNotificationPayload.fromVendorData(merged);
  }

  static PushNotificationScenario parseScenario(String raw) {
    final normalized = raw.trim().toLowerCase().replaceAll('-', '_');
    return switch (normalized) {
      '1' || 'message' => PushNotificationScenario.message,
      '2' || 'call' => PushNotificationScenario.call,
      '3' ||
      '4' ||
      'friendrequest' ||
      'friend_request' ||
      'friendrequestresult' ||
      'friend_request_result' =>
        PushNotificationScenario.friendRequest,
      'security' ||
      'securitysystem' ||
      'security_system' ||
      'securityalert' ||
      'security_alert' =>
        PushNotificationScenario.security,
      _ => PushNotificationScenario.unknown,
    };
  }

  bool get isMessage => scenario == PushNotificationScenario.message;
  bool get isCall => scenario == PushNotificationScenario.call;
  bool get isSecurity => scenario == PushNotificationScenario.security;
  bool get isFriendRequest =>
      scenario == PushNotificationScenario.friendRequest;

  bool get requiresTargetSpace =>
      isMessage || (!isCall && !isSecurity && conversationId != null);

  String? get title => stringValue(const ['title', 'notificationTitle']);
  String? get body => stringValue(const ['body', 'alert', 'preview']);
  String? get targetSpaceId => stringValue(const ['tenantId', 'spaceId']);
  String? get conversationId => stringValue(const [
        'conversationId',
        'chatId',
        'groupId',
      ]);
  String? get callId => stringValue(const ['callId', 'sessionId']);
  String? get mediaMode =>
      stringValue(const ['mediaMode', 'media_mode']) ?? 'audio';
  String? get messageType => stringValue(const ['messageType']);

  String? stringValue(List<String> keys) => _stringValue(data, keys);

  bool boolValue(List<String> keys) {
    final value = stringValue(keys);
    if (value == null) return false;
    final normalized = value.toLowerCase();
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }

  int stableNotificationId() {
    final raw = _notificationKey();
    return raw.hashCode & 0x7fffffff;
  }

  String _notificationKey() {
    final accountScopeKey = stringValue(const ['accountScopeKey']) ?? '';
    return '$accountScopeKey:${_notificationKeyWithinAccount()}';
  }

  String _notificationKeyWithinAccount() {
    if (isFriendRequest) {
      final requestId = stringValue(const ['requestId', 'entityId']) ?? '';
      if (requestId.isNotEmpty) {
        final status = stringValue(const ['status']) ?? 'pending';
        return 'friend-request:$requestId:${status.toLowerCase()}';
      }
    }
    final explicit = stringValue(const [
      'notificationId',
      'messageId',
      'msgId',
      'callId',
      'clientMsgId',
    ]);
    if (explicit != null && explicit.isNotEmpty) return explicit;
    if (isSecurity) {
      final event = stringValue(const ['securityEvent']) ?? 'security';
      final occurredAt = stringValue(const ['occurredAt', 'at']) ?? '';
      final platformUserId = stringValue(const ['platformUserId']) ?? '';
      return 'security:$event:$platformUserId:$occurredAt';
    }
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}

String? _stringValue(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value == null) continue;
    final text = value.toString();
    if (text.isNotEmpty) return text;
  }
  final lower = {
    for (final entry in data.entries) entry.key.toLowerCase(): entry.value,
  };
  for (final key in keys) {
    final value = lower[key.toLowerCase()];
    if (value == null) continue;
    final text = value.toString();
    if (text.isNotEmpty) return text;
  }
  return null;
}

Map<String, dynamic>? _mapValue(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}

Map<String, dynamic> _stringKeyed(Map<String, dynamic> raw) {
  return raw.map((key, value) => MapEntry(key.toString(), value));
}
