import 'package:im_sdk/features/chat/domain/entities/conversation.dart';

bool shouldShowNumericUnreadBadge(Conversation conversation) {
  if (conversation.unreadCount <= 0 || conversation.isMuted) return false;
  return true;
}

int calculateMessageBadgeCount(List<Conversation> conversations) {
  var total = 0;
  for (final conversation in conversations) {
    if (!shouldShowNumericUnreadBadge(conversation)) continue;
    total += conversation.unreadCount;
  }
  return total;
}

int calculateBackNavigationUnreadCount(
  List<Conversation> conversations, {
  required String activeConversationId,
}) {
  return calculateMessageBadgeCount(
    conversations
        .where(
          (conversation) => conversation.conversationId != activeConversationId,
        )
        .toList(growable: false),
  );
}

int calculateNumericUnreadConversationCount(List<Conversation> conversations) {
  var total = 0;
  for (final conversation in conversations) {
    if (shouldShowNumericUnreadBadge(conversation)) total += 1;
  }
  return total;
}
