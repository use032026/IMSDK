import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/chat/domain/entities/message_inbox_entry.dart';
import 'package:im_sdk/features/chat/domain/usecases/message_badge_count.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/official_account/presentation/providers/official_account_inbox_provider.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';

class MessageInboxSections {
  const MessageInboxSections(this.pinned, this.normal,
      {this.ordinarySyncFailed = false});
  final List<MessageInboxEntry> pinned;
  final List<MessageInboxEntry> normal;
  final bool ordinarySyncFailed;
}

final messageInboxSectionsProvider =
    Provider.family<AsyncValue<MessageInboxSections>, String>((ref, spaceId) {
  final ordinary = ref.watch(filteredConversationsProvider(spaceId));
  final official = spaceId == 'personal'
      ? ref.watch(officialAccountInboxProvider).valueOrNull ?? const []
      : const <OfficialAccountConversationSummary>[];
  MessageInboxSections sections() {
    final entries = mergeOfficialAccountInbox(
      spaceId: spaceId,
      conversations: ordinary.valueOrNull ?? const [],
      officialAccounts: official,
      keyword: ref.watch(conversationSearchProvider(spaceId)),
    );
    return MessageInboxSections(
      entries.where((entry) => entry.isPinned).toList(),
      entries.where((entry) => !entry.isPinned).toList(),
      ordinarySyncFailed: ordinary.hasError,
    );
  }

  if (spaceId == 'personal' && official.isNotEmpty) {
    return AsyncData(sections());
  }
  return ordinary.whenData((_) => sections());
}, dependencies: [filteredConversationsProvider, officialAccountInboxProvider]);

/// Shared by the inbox title, navigation badge and launcher badge. Space-wide
/// unread totals are never added to per-conversation summaries.
final messageInboxBadgeCountProvider = Provider.family<int?, String>(
    (ref, spaceId) {
  final snapshot = ref.watch(releaseVisibleConversationsProvider(spaceId));
  final conversations = snapshot.valueOrNull;
  final official = spaceId == 'personal'
      ? ref.watch(officialAccountInboxProvider).valueOrNull
      : null;
  if (conversations == null && official == null) return null;
  final base = calculateMessageBadgeCount(conversations ?? const []);
  if (spaceId != 'personal') return base;
  final keys = (conversations ?? const [])
      .map((c) => '$spaceId/${c.conversationId}')
      .toSet();
  return base +
      (official ?? const <OfficialAccountConversationSummary>[])
          .where((item) => keys.add(item.key))
          .fold<int>(0, (count, item) => count + item.unreadCount);
}, dependencies: [
  releaseVisibleConversationsProvider,
  officialAccountInboxProvider
]);
