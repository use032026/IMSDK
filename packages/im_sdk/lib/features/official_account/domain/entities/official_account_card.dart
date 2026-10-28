/// A public official identity. Its conversation always belongs to [tenantId],
/// even when this card is discovered from the personal space.
class OfficialAccountCard {
  const OfficialAccountCard({
    required this.tenantId,
    required this.tenantCode,
    required this.tenantName,
    required this.officialUserId,
    required this.displayName,
    required this.isMember,
    this.tenantLogoUrl,
    this.avatarUrl,
    this.lppId,
    this.conversationId,
    this.customerUserId,
    this.joined = false,
  });

  final String tenantId;
  final String tenantCode;
  final String tenantName;
  final String? tenantLogoUrl;
  final String officialUserId;
  final String displayName;
  final String? avatarUrl;
  final String? lppId;
  final bool isMember;
  final String? conversationId;
  final String? customerUserId;
  final bool joined;

  bool get canOpenConversation => isMember && conversationId != null;
  String? get effectiveAvatarUrl => avatarUrl ?? tenantLogoUrl;
}

/// A platform snapshot for the inbox, never a tenant message or read ledger.
class OfficialAccountConversationSummary {
  const OfficialAccountConversationSummary({
    required this.officialAccount,
    required this.unreadCount,
    this.lastMessagePreview,
    this.lastMessageAt,
  });

  final OfficialAccountCard officialAccount;
  final int unreadCount;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;

  String get key =>
      '${officialAccount.tenantId}/${officialAccount.conversationId}';
}
