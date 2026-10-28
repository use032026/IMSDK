import 'package:im_sdk/features/contacts/application/friend_acceptance_conversation_service.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';

typedef FriendResultScopeCheck = bool Function();
typedef FriendRequestSnapshotReader = List<FriendRequest> Function();
typedef FriendRequestSnapshotRefresh = Future<void> Function();
typedef FriendSnapshotReader = List<Contact> Function();
typedef FriendSnapshotRefresh = Future<void> Function(String peerUserId);
typedef FriendResultNotification = Future<void> Function(
  String requestId,
  FriendRequestStatus status,
);
typedef FriendAcceptanceConversation = Future<void> Function(
  FriendAcceptanceConversationDraft draft,
);
typedef FriendResultInvalidation = void Function();
typedef FriendResultDiagnostic = void Function(
  String event,
  Map<String, Object?> context,
);

class FriendRequestResultSignal {
  const FriendRequestResultSignal({
    required this.requestId,
    required this.status,
    required this.eventName,
    this.peerUserId,
    this.peerDisplayName,
    this.peerAvatarUrl,
    this.requestMessage,
  });

  final String requestId;
  final FriendRequestStatus status;
  final String eventName;
  final String? peerUserId;
  final String? peerDisplayName;
  final String? peerAvatarUrl;
  final String? requestMessage;
}

/// Applies friend-request Gateway result signals to authoritative Contacts
/// snapshots. The handler owns orchestration only; repositories, notifications
/// and chat persistence stay behind the injected application ports.
class FriendRequestResultApplicationHandler {
  const FriendRequestResultApplicationHandler({
    required this.isCurrentScope,
    required this.readRequests,
    required this.refreshRequests,
    required this.invalidatePendingRequests,
    required this.readFriends,
    required this.refreshFriends,
    required this.showResultNotification,
    required this.ensureAcceptanceConversation,
    required this.invalidateConversationList,
    required this.diagnostic,
  });

  final FriendResultScopeCheck isCurrentScope;
  final FriendRequestSnapshotReader readRequests;
  final FriendRequestSnapshotRefresh refreshRequests;
  final FriendResultInvalidation invalidatePendingRequests;
  final FriendSnapshotReader readFriends;
  final FriendSnapshotRefresh refreshFriends;
  final FriendResultNotification showResultNotification;
  final FriendAcceptanceConversation ensureAcceptanceConversation;
  final FriendResultInvalidation invalidateConversationList;
  final FriendResultDiagnostic diagnostic;

  Future<void> handle({
    required FriendRequestResultSignal signal,
    required String currentUserId,
  }) async {
    if (!isCurrentScope()) return;
    final requestsBefore = readRequests();
    final friendsBefore = readFriends();

    try {
      await refreshRequests();
    } catch (error) {
      diagnostic('request_refresh_failed', {
        'requestId': signal.requestId,
        'eventName': signal.eventName,
        'error': error.toString(),
      });
    } finally {
      if (isCurrentScope()) invalidatePendingRequests();
    }

    if (!isCurrentScope()) return;
    if (signal.status != FriendRequestStatus.accepted &&
        signal.status != FriendRequestStatus.rejected) {
      return;
    }

    final requestsAfter = readRequests();
    if (_hasAuthoritativeTerminalConflict(
      requestId: signal.requestId,
      targetStatus: signal.status,
      requestsAfter: requestsAfter,
    )) {
      diagnostic('result_terminal_conflict', {
        'requestId': signal.requestId,
        'eventName': signal.eventName,
        'status': signal.status.wireValue,
      });
      return;
    }

    final resolvedRequest = resolveFriendRequestResultTransition(
      eventRequestId: signal.requestId,
      targetStatus: signal.status,
      requestsBefore: requestsBefore,
      requestsAfter: requestsAfter,
    );
    final effectiveRequestId = signal.requestId.trim().isNotEmpty
        ? signal.requestId.trim()
        : resolvedRequest?.requestId ?? '';
    if (effectiveRequestId.isEmpty) {
      diagnostic('result_request_unresolved', {
        'eventName': signal.eventName,
        'status': signal.status.wireValue,
        'beforeCount': requestsBefore.length,
        'afterCount': requestsAfter.length,
      });
      return;
    }

    if (!isCurrentScope()) return;
    try {
      await showResultNotification(effectiveRequestId, signal.status);
    } catch (error) {
      diagnostic('result_notification_failed', {
        'requestId': effectiveRequestId,
        'status': signal.status.wireValue,
        'error': error.toString(),
      });
    }

    if (!isCurrentScope() || signal.status == FriendRequestStatus.rejected) {
      return;
    }

    final requestCandidates = resolvedRequest == null
        ? requestsBefore
        : <FriendRequest>[resolvedRequest];
    final cachedDraft = resolveFriendAcceptanceConversationDraft(
      requestId: effectiveRequestId,
      currentUserId: currentUserId,
      pendingRequests: requestCandidates,
      friendsBefore: friendsBefore,
      friendsAfter: friendsBefore,
      eventPeerUserId: signal.peerUserId,
      eventPeerDisplayName: signal.peerDisplayName,
      eventPeerAvatarUrl: signal.peerAvatarUrl,
      requestMessage: signal.requestMessage,
    );

    try {
      await refreshFriends(cachedDraft?.peerUserId ?? '');
    } catch (error) {
      diagnostic('friends_refresh_failed', {
        'requestId': effectiveRequestId,
        'error': error.toString(),
      });
    }
    if (!isCurrentScope()) return;

    final friendsAfter = readFriends();
    final draft = cachedDraft ??
        resolveFriendAcceptanceConversationDraft(
          requestId: effectiveRequestId,
          currentUserId: currentUserId,
          pendingRequests: requestCandidates,
          friendsBefore: friendsBefore,
          friendsAfter: friendsAfter,
          eventPeerUserId: signal.peerUserId,
          eventPeerDisplayName: signal.peerDisplayName,
          eventPeerAvatarUrl: signal.peerAvatarUrl,
          requestMessage: signal.requestMessage,
        );
    if (draft == null) {
      diagnostic('accepted_peer_unresolved', {
        'requestId': effectiveRequestId,
        'eventName': signal.eventName,
      });
      return;
    }

    invalidateConversationList();
    try {
      await ensureAcceptanceConversation(draft);
    } catch (error) {
      diagnostic('acceptance_conversation_failed', {
        'requestId': effectiveRequestId,
        'peerUserId': draft.peerUserId,
        'error': error.toString(),
      });
    }
  }
}

bool _hasAuthoritativeTerminalConflict({
  required String requestId,
  required FriendRequestStatus targetStatus,
  required List<FriendRequest> requestsAfter,
}) {
  final normalizedRequestId = requestId.trim();
  if (normalizedRequestId.isEmpty) return false;
  for (final request in requestsAfter) {
    if (request.requestId != normalizedRequestId) continue;
    return request.status != FriendRequestStatus.pending &&
        request.status != targetStatus;
  }
  return false;
}
