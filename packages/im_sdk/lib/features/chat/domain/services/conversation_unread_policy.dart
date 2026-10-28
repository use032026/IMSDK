import 'package:im_sdk/features/chat/domain/entities/conversation.dart';

class ConversationUnreadPolicy {
  const ConversationUnreadPolicy._();

  static bool isCurrentUserMessage({
    required bool transportMarkedSelf,
    bool localClientMessageMatch = false,
    required LastMessage? message,
    required String? currentUserId,
  }) {
    if (transportMarkedSelf ||
        localClientMessageMatch ||
        message?.isSelf == true) {
      return true;
    }
    final direction =
        (message?.direction ?? '').trim().toLowerCase().replaceAll('-', '_');
    if (const {'out', 'outgoing', 'sent', 'self'}.contains(direction)) {
      return true;
    }
    return _sameIdentity(message?.senderUserId, currentUserId);
  }

  static int mergeUnreadCount({
    required int currentUnreadCount,
    required bool isCurrentUserMessage,
    required bool isEvent,
    required bool isDuplicate,
    required bool isActiveConversation,
    bool advancesConversation = true,
  }) {
    if (isActiveConversation) return 0;
    if (!advancesConversation ||
        isCurrentUserMessage ||
        isEvent ||
        isDuplicate) {
      return currentUnreadCount;
    }
    return currentUnreadCount + 1;
  }

  static bool _sameIdentity(String? left, String? right) {
    final a = left?.trim().toLowerCase();
    final b = right?.trim().toLowerCase();
    return a != null && a.isNotEmpty && b != null && b.isNotEmpty && a == b;
  }
}
