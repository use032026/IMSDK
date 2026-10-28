import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';

/// Display projection only. Cross-space entries never masquerade as local
/// conversations, messages, or targets for current-space mutation commands.
class MessageInboxEntry {
  const MessageInboxEntry.conversation(Conversation value)
      : conversation = value,
        officialAccount = null;
  const MessageInboxEntry.official(OfficialAccountConversationSummary value)
      : officialAccount = value,
        conversation = null;

  final Conversation? conversation;
  final OfficialAccountConversationSummary? officialAccount;
  DateTime? get lastActivityAt =>
      conversation?.lastActivityAt ?? officialAccount?.lastMessageAt;
  bool get isPinned => conversation?.isPinned ?? false;
}

List<MessageInboxEntry> mergeOfficialAccountInbox({
  required String spaceId,
  required List<Conversation> conversations,
  required List<OfficialAccountConversationSummary> officialAccounts,
  String keyword = '',
}) {
  final entries = conversations.map(MessageInboxEntry.conversation).toList();
  if (spaceId != 'personal') return entries;
  final keys = conversations.map((c) => '$spaceId/${c.conversationId}').toSet();
  final query = keyword.trim().toLowerCase();
  for (final summary in officialAccounts) {
    if (!keys.add(summary.key)) continue;
    final card = summary.officialAccount;
    if (query.isNotEmpty &&
        ![
          card.displayName,
          card.tenantName,
          card.lppId ?? '',
          summary.lastMessagePreview ?? '',
        ].any((value) => value.toLowerCase().contains(query))) {
      continue;
    }
    entries.add(MessageInboxEntry.official(summary));
  }
  entries.sort((a, b) {
    if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
    final aTime = a.lastActivityAt;
    final bTime = b.lastActivityAt;
    if (aTime == null) return bTime == null ? 0 : 1;
    if (bTime == null) return -1;
    return bTime.compareTo(aTime);
  });
  return entries;
}
