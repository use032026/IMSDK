import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';

OfficialAccountCard? optionalOfficialAccountCard(Object? value) {
  if (value == null) return null;
  if (value is! Map) throw const FormatException('Invalid official account');
  final data = Map<String, dynamic>.from(value);
  if (data['isMember'] is! bool) {
    throw const FormatException('Missing official account membership');
  }
  return OfficialAccountCard(
    tenantId: _required(data, 'tenantId'),
    tenantCode: _required(data, 'tenantCode'),
    tenantName: _required(data, 'tenantName'),
    officialUserId: _required(data, 'officialUserId'),
    displayName: _required(data, 'displayName'),
    tenantLogoUrl: _optional(data['tenantLogoUrl']),
    avatarUrl: _optional(data['avatarUrl']),
    lppId: _optional(data['lppId']),
    isMember: data['isMember'] as bool,
    conversationId: _optional(data['conversationId']),
    customerUserId: _optional(data['customerUserId']),
    joined: data['joined'] == true,
  );
}

OfficialAccountConversationSummary officialAccountSummaryFromJson(
    Map<String, dynamic> data) {
  final card = optionalOfficialAccountCard(data['officialAccount']);
  final unread = data['unreadCount'];
  final time = _optional(data['lastMessageAt']);
  final parsedTime = time == null ? null : DateTime.tryParse(time);
  if (card == null ||
      !card.canOpenConversation ||
      unread is! int ||
      unread < 0 ||
      (time != null && parsedTime == null)) {
    throw const FormatException('Invalid official account inbox summary');
  }
  return OfficialAccountConversationSummary(
    officialAccount: card,
    unreadCount: unread,
    lastMessagePreview: data['lastMessagePreview'] as String?,
    lastMessageAt: parsedTime,
  );
}

Map<String, Object?> officialAccountCardToJson(OfficialAccountCard card) => {
      'tenantId': card.tenantId,
      'tenantCode': card.tenantCode,
      'tenantName': card.tenantName,
      'tenantLogoUrl': card.tenantLogoUrl,
      'officialUserId': card.officialUserId,
      'displayName': card.displayName,
      'avatarUrl': card.avatarUrl,
      'lppId': card.lppId,
      'isMember': card.isMember,
      'conversationId': card.conversationId,
      'customerUserId': card.customerUserId,
      'joined': card.joined,
    };

Map<String, Object?> officialAccountSummaryToJson(
        OfficialAccountConversationSummary summary) =>
    {
      'officialAccount': officialAccountCardToJson(summary.officialAccount),
      'unreadCount': summary.unreadCount,
      'lastMessagePreview': summary.lastMessagePreview,
      'lastMessageAt': summary.lastMessageAt?.toIso8601String(),
    };

String _required(Map<String, dynamic> data, String field) {
  final value = _optional(data[field]);
  if (value == null) throw FormatException('Missing official account $field');
  return value;
}

String? _optional(Object? value) {
  if (value == null) return null;
  if (value is! String) throw const FormatException('Expected string');
  return value.trim().isEmpty ? null : value.trim();
}
