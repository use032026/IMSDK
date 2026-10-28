String normalizeMessagePayloadToken(Object? value) {
  return value?.toString().trim().toLowerCase().replaceAll('-', '_') ?? '';
}

bool isExplicitSystemMessagePayload(Map<String, dynamic> json) {
  final type = normalizeMessagePayloadToken(json['messageType']);
  final direction = normalizeMessagePayloadToken(json['direction']);
  final senderRole = _firstNormalizedToken(json, const [
    'senderRole',
    'senderType',
    'fromRole',
  ]);
  final body = _mapValue(json['body']);

  return const {'event', 'notice', 'system'}.contains(type) ||
      direction == 'system' ||
      senderRole == 'system' ||
      _hasExplicitEventValue(body['event']) ||
      _hasNonBlankText(body['eventText']) ||
      _hasNonBlankText(body['notice']);
}

String normalizedConversationMessageType(Map<String, dynamic> json) {
  if (isExplicitSystemMessagePayload(json)) return 'event';
  final type = normalizeMessagePayloadToken(json['messageType']);
  return type.isEmpty ? 'text' : type;
}

String _firstNormalizedToken(
  Map<String, dynamic> json,
  List<String> keys,
) {
  for (final key in keys) {
    final value = normalizeMessagePayloadToken(json[key]);
    if (value.isNotEmpty) return value;
  }
  return '';
}

Map<String, dynamic> _mapValue(Object? value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return const {};
}

bool _hasExplicitEventValue(Object? value) {
  if (_hasNonBlankText(value)) return true;
  return value is Map && value.isNotEmpty;
}

bool _hasNonBlankText(Object? value) {
  return value is String && value.trim().isNotEmpty;
}
