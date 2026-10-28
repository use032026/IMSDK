import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';

class FriendAcceptanceConversationDraft {
  final String requestId;
  final String peerUserId;
  final String peerDisplayName;
  final String? peerAvatarUrl;
  final String? requestMessage;
  final String acceptedText;

  const FriendAcceptanceConversationDraft({
    required this.requestId,
    required this.peerUserId,
    required this.peerDisplayName,
    this.peerAvatarUrl,
    this.requestMessage,
    this.acceptedText = '我通过了你的朋友验证请求，现在我们可以开始聊天了',
  });

  factory FriendAcceptanceConversationDraft.fromRequest(
    FriendRequest request, {
    required String? currentUserId,
    String acceptedText = '我通过了你的朋友验证请求，现在我们可以开始聊天了',
  }) {
    final isIncoming = currentUserId == null ||
        request.fromUserId.isEmpty ||
        request.fromUserId != currentUserId;
    return FriendAcceptanceConversationDraft(
      requestId: request.requestId,
      peerUserId: isIncoming ? request.fromUserId : request.toUserId,
      peerDisplayName:
          isIncoming ? request.fromDisplayName : request.toDisplayName,
      peerAvatarUrl: isIncoming ? request.fromAvatarUrl : request.toAvatarUrl,
      requestMessage: request.message,
      acceptedText: acceptedText,
    );
  }
}

/// Recovers the authoritative request behind a sparse result event.
///
/// The event request id wins. When the server omits it, only one transition
/// from pending to the target result is safe to reconcile; multiple candidates
/// remain unresolved rather than attaching the result to the wrong person.
FriendRequest? resolveFriendRequestResultTransition({
  required String eventRequestId,
  required FriendRequestStatus targetStatus,
  required List<FriendRequest> requestsBefore,
  required List<FriendRequest> requestsAfter,
}) {
  final normalizedRequestId = eventRequestId.trim();
  if (normalizedRequestId.isNotEmpty) {
    for (final request in requestsAfter) {
      if (request.requestId != normalizedRequestId) continue;
      if (request.status == targetStatus ||
          request.status == FriendRequestStatus.pending) {
        return request;
      }
      return null;
    }
    for (final request in requestsBefore) {
      if (request.requestId == normalizedRequestId &&
          (request.status == targetStatus ||
              request.status == FriendRequestStatus.pending)) {
        return request;
      }
    }
    return null;
  }

  final previousStatusById = {
    for (final request in requestsBefore) request.requestId: request.status,
  };
  final transitioned = requestsAfter.where((request) {
    return request.requestId.isNotEmpty &&
        request.status == targetStatus &&
        previousStatusById[request.requestId] == FriendRequestStatus.pending;
  }).toList(growable: false);
  return transitioned.length == 1 ? transitioned.single : null;
}

/// Resolves the peer for an accepted friend request from authoritative client
/// snapshots. The event payload wins when the server provides a peer; the
/// cached outgoing request is the exact fallback. After process restoration,
/// a single friend-list addition is safe to reconcile, while multiple changes
/// remain unresolved instead of guessing the wrong person.
FriendAcceptanceConversationDraft? resolveFriendAcceptanceConversationDraft({
  required String requestId,
  required String? currentUserId,
  required List<FriendRequest> pendingRequests,
  required List<Contact> friendsBefore,
  required List<Contact> friendsAfter,
  String? eventPeerUserId,
  String? eventPeerDisplayName,
  String? eventPeerAvatarUrl,
  String? requestMessage,
}) {
  const acceptedText = '对方通过了你的朋友验证请求，现在我们可以开始聊天了';
  final peerUserId = eventPeerUserId?.trim() ?? '';
  if (peerUserId.isNotEmpty) {
    return FriendAcceptanceConversationDraft(
      requestId: requestId,
      peerUserId: peerUserId,
      peerDisplayName: eventPeerDisplayName?.trim().isNotEmpty == true
          ? eventPeerDisplayName!.trim()
          : '好友',
      peerAvatarUrl: eventPeerAvatarUrl?.trim().isNotEmpty == true
          ? eventPeerAvatarUrl!.trim()
          : null,
      requestMessage: requestMessage,
      acceptedText: acceptedText,
    );
  }

  for (final request in pendingRequests) {
    if (request.requestId != requestId) continue;
    final draft = FriendAcceptanceConversationDraft.fromRequest(
      request,
      currentUserId: currentUserId,
      acceptedText: acceptedText,
    );
    return draft.peerUserId.isEmpty ? null : draft;
  }

  final previousIds = friendsBefore.map((friend) => friend.userId).toSet();
  final added = friendsAfter
      .where((friend) =>
          friend.userId.isNotEmpty && !previousIds.contains(friend.userId))
      .toList();
  if (added.length != 1) return null;

  final friend = added.single;
  return FriendAcceptanceConversationDraft(
    requestId: requestId,
    peerUserId: friend.userId,
    peerDisplayName: friend.displayName,
    peerAvatarUrl: friend.avatarUrl,
    requestMessage: requestMessage,
    acceptedText: acceptedText,
  );
}

class FriendAcceptanceConversationResult {
  final String conversationId;

  const FriendAcceptanceConversationResult({
    required this.conversationId,
  });
}

abstract class FriendAcceptanceConversationGateway {
  Future<String?> createDirectConversation(String peerUserId);
}

abstract class FriendAcceptanceConversationStore {
  Future<void> upsertMessages(
    String spaceId,
    String conversationId,
    List<Message> messages,
  );

  Future<List<Conversation>> getConversations(String spaceId);

  Future<void> upsertConversation(String spaceId, Conversation conversation);
}

typedef FriendAcceptanceClock = DateTime Function();

/// 好友通过后按微信体验补齐会话入口。
///
/// 服务端当前好友申请结果事件不返回消息对象，所以这里是本地体验补齐；
/// 后续如果服务端返回正式 event message，SQLite upsert 会按 messageId 去重。
class FriendAcceptanceConversationService {
  final FriendAcceptanceConversationGateway gateway;
  final FriendAcceptanceConversationStore store;
  final FriendAcceptanceClock now;

  const FriendAcceptanceConversationService({
    required this.gateway,
    required this.store,
    FriendAcceptanceClock? now,
  }) : now = now ?? _utcNow;

  Future<FriendAcceptanceConversationResult?> ensureConversation({
    required String spaceId,
    required String currentUserId,
    required FriendAcceptanceConversationDraft draft,
  }) async {
    if (draft.requestId.trim().isEmpty || draft.peerUserId.isEmpty) return null;

    final chatId = await gateway.createDirectConversation(draft.peerUserId);
    if (chatId == null || chatId.isEmpty) return null;

    final acceptedAt = now().toUtc();
    final messages = _buildLocalEventMessages(
      chatId: chatId,
      currentUserId: currentUserId,
      acceptedAt: acceptedAt,
      draft: draft,
    );
    await store.upsertMessages(spaceId, chatId, messages);

    final existing = await _findConversation(spaceId, chatId);
    await store.upsertConversation(
      spaceId,
      _conversationWithLatestAcceptanceEvent(
        existing: existing,
        chatId: chatId,
        draft: draft,
        last: messages.last,
      ),
    );

    return FriendAcceptanceConversationResult(conversationId: chatId);
  }

  List<Message> _buildLocalEventMessages({
    required String chatId,
    required String currentUserId,
    required DateTime acceptedAt,
    required FriendAcceptanceConversationDraft draft,
  }) {
    final requestText = draft.requestMessage?.trim();
    return <Message>[
      if (requestText != null && requestText.isNotEmpty)
        _eventMessage(
          messageId: 'friend_request_${draft.requestId}_request',
          conversationId: chatId,
          conversationSeq: -2,
          senderUserId: draft.peerUserId,
          sentAt: acceptedAt.subtract(const Duration(milliseconds: 1)),
          text: '好友申请：$requestText',
          eventType: 'friend_request',
        ),
      _eventMessage(
        messageId: 'friend_request_${draft.requestId}_accepted',
        conversationId: chatId,
        conversationSeq: -1,
        senderUserId: currentUserId,
        sentAt: acceptedAt,
        text: draft.acceptedText,
        eventType: 'friend_request_accepted',
      ),
    ];
  }

  Future<Conversation?> _findConversation(String spaceId, String chatId) async {
    for (final conversation in await store.getConversations(spaceId)) {
      if (conversation.conversationId == chatId) {
        return conversation;
      }
    }
    return null;
  }

  Conversation _conversationWithLatestAcceptanceEvent({
    required Conversation? existing,
    required String chatId,
    required FriendAcceptanceConversationDraft draft,
    required Message last,
  }) {
    final existingSeq = existing?.lastMessageSeq ?? 0;
    return (existing ??
            Conversation(
              conversationId: chatId,
              type: ConversationType.direct,
              title: draft.peerDisplayName,
              avatarUrl: draft.peerAvatarUrl,
              peerUserId: draft.peerUserId,
            ))
        .copyWith(
      type: ConversationType.direct,
      title: existing?.title.isNotEmpty == true
          ? existing!.title
          : draft.peerDisplayName,
      avatarUrl: existing?.avatarUrl ?? draft.peerAvatarUrl,
      peerUserId: existing?.peerUserId ?? draft.peerUserId,
      lastMessage: LastMessage(
        messageId: last.messageId,
        text: last.body.text,
        messageType: 'event',
        senderUserId: last.senderUserId,
        sentAt: last.sentAt,
      ),
      lastActivityAt: last.sentAt,
      lastMessageSeq: existingSeq <= 0 ? last.conversationSeq : existingSeq,
      unreadCount: existing?.unreadCount ?? 0,
    );
  }
}

Message _eventMessage({
  required String messageId,
  required String conversationId,
  required int conversationSeq,
  required String senderUserId,
  required DateTime sentAt,
  required String text,
  required String eventType,
}) {
  return Message(
    messageId: messageId,
    clientMsgId: messageId,
    conversationId: conversationId,
    conversationSeq: conversationSeq,
    senderUserId: senderUserId,
    type: MessageType.event,
    body: MessageBody(
      text: text,
      eventData: EventDto(
        type: eventType,
        text: text,
      ),
    ),
    sentAt: sentAt,
  );
}

DateTime _utcNow() => DateTime.now().toUtc();
