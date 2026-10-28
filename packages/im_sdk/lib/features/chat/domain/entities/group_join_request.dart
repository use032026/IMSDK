enum GroupJoinRequestStatus {
  pending,
  approved,
  rejected,
  handled,
}

class GroupJoinRequest {
  final String requestId;
  final String groupId;
  final String conversationId;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final String? message;
  final GroupJoinRequestStatus status;
  final DateTime? createdAt;
  final DateTime? reviewedAt;
  final String? reviewerUserId;
  final String? rejectReason;

  const GroupJoinRequest({
    required this.requestId,
    required this.groupId,
    required this.conversationId,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.message,
    required this.status,
    this.createdAt,
    this.reviewedAt,
    this.reviewerUserId,
    this.rejectReason,
  });

  bool get isPending => status == GroupJoinRequestStatus.pending;

  GroupJoinRequest reviewed({
    required GroupJoinRequestStatus status,
    String? rejectReason,
  }) {
    return GroupJoinRequest(
      requestId: requestId,
      groupId: groupId,
      conversationId: conversationId,
      userId: userId,
      displayName: displayName,
      avatarUrl: avatarUrl,
      message: message,
      status: status,
      createdAt: createdAt,
      reviewedAt: reviewedAt,
      reviewerUserId: reviewerUserId,
      rejectReason: rejectReason,
    );
  }
}
