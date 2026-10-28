import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';

class Contact {
  final String userId;
  final String name;
  final String? avatarUrl;
  final String? remark;
  final bool isOnline;
  final String? customerTag;
  final String? lppId;
  final String? signature;
  final bool? isFriend;

  /// userType: 1=客户, 2=员工/客服（来自 API）
  final int? userType;
  final OfficialAccountCard? officialAccount;

  const Contact({
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.remark,
    this.isOnline = false,
    this.customerTag,
    this.lppId,
    this.signature,
    this.isFriend,
    this.userType,
    this.officialAccount,
  });

  String get displayName => remark?.isNotEmpty == true ? remark! : name;

  bool get isEmployee => userType == 2;
  bool get isCustomer => userType == 1;
}

/// Resolves the display name from the current account's point of view.
///
/// A private friend remark is authoritative for presentation only. Group
/// nicknames and directory names remain unchanged in their own aggregates.
String resolveFriendDisplayName({
  Contact? friend,
  String? contextualDisplayName,
  required String fallback,
  bool preferFriendRemark = true,
}) {
  final remark = friend?.remark?.trim();
  if (preferFriendRemark && remark?.isNotEmpty == true) return remark!;
  final contextualName = contextualDisplayName?.trim();
  if (contextualName?.isNotEmpty == true) return contextualName!;
  final friendName = friend?.name.trim();
  if (friendName?.isNotEmpty == true) return friendName!;
  return fallback;
}

class Department {
  final String departmentId;
  final String departmentName;
  final String? parentId;
  final String? leaderUserId;
  final int memberCount;
  final List<Department> children;

  const Department({
    required this.departmentId,
    required this.departmentName,
    this.parentId,
    this.leaderUserId,
    this.memberCount = 0,
    this.children = const [],
  });
}

class DepartmentMember {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final bool isPrimary;
  final String? position;
  final int? userType;
  final int? membershipRole;
  final String? customerTag;

  const DepartmentMember({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.isPrimary = false,
    this.position,
    this.userType,
    this.membershipRole,
    this.customerTag,
  });

  bool get isCustomer => userType == 1 || customerTag == '客户';
}

/// 好友申请
enum FriendRequestStatus {
  pending,
  accepted,
  rejected,
  cancelled,
  unknown;

  static FriendRequestStatus fromWire(Object? value) {
    return switch (value?.toString().trim().toLowerCase()) {
      'pending' => FriendRequestStatus.pending,
      'accepted' => FriendRequestStatus.accepted,
      'rejected' => FriendRequestStatus.rejected,
      'cancelled' => FriendRequestStatus.cancelled,
      null => FriendRequestStatus.unknown,
      '' => FriendRequestStatus.unknown,
      _ => FriendRequestStatus.unknown,
    };
  }

  String get wireValue => name;
}

enum FriendRequestSource {
  search,
  qr;

  static FriendRequestSource? fromWire(Object? value) {
    return switch (value?.toString().trim().toLowerCase()) {
      'search' => FriendRequestSource.search,
      'qr' => FriendRequestSource.qr,
      _ => null,
    };
  }
}

class FriendRequestSubmission {
  final String requestId;
  final FriendRequestStatus status;
  final OfficialAccountCard? officialAccount;

  const FriendRequestSubmission({
    required this.requestId,
    required this.status,
    this.officialAccount,
  });

  bool get becameFriends => status == FriendRequestStatus.accepted;
}

class FriendInvitePreview {
  const FriendInvitePreview({
    required this.inviterUserId,
    required this.displayName,
    required this.expired,
    required this.alreadyFriends,
    this.avatarUrl,
    this.message,
    this.officialAccount,
  });

  final String? inviterUserId;
  final String displayName;
  final String? avatarUrl;
  final String? message;
  final bool expired;
  final bool alreadyFriends;
  final OfficialAccountCard? officialAccount;
}

class FriendRequest {
  final String requestId;
  final String fromUserId;
  final String fromDisplayName;
  final String? fromAvatarUrl;
  final String toUserId;
  final String toDisplayName;
  final String? toAvatarUrl;
  final String? message;
  final FriendRequestStatus status;
  final FriendRequestSource? source;
  final DateTime createdAt;
  final DateTime? handledAt;

  const FriendRequest({
    required this.requestId,
    required this.fromUserId,
    required this.fromDisplayName,
    this.fromAvatarUrl,
    this.toUserId = '',
    this.toDisplayName = '',
    this.toAvatarUrl,
    this.message,
    required this.status,
    this.source,
    required this.createdAt,
    this.handledAt,
  });

  bool isPendingIncomingFor(String currentUserId) =>
      currentUserId.isNotEmpty &&
      status == FriendRequestStatus.pending &&
      toUserId == currentUserId &&
      fromUserId.isNotEmpty &&
      fromUserId != currentUserId;
}

/// 黑名单用户
class BlockedUser {
  final String userId;
  final String displayName;
  final String? avatarUrl;

  const BlockedUser({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
  });
}
