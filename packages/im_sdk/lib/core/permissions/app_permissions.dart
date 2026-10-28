import 'package:im_sdk/core/space/space_context.dart';

enum GroupMemberRole { owner, admin, member }

enum CustomerDirectoryScope { none, assigned, all }

class BroadcastAccess {
  final bool canUseClientBulkSend;
  final bool canUseEnterpriseBroadcast;

  const BroadcastAccess({
    required this.canUseClientBulkSend,
    required this.canUseEnterpriseBroadcast,
  });
}

class PermissionDecision {
  final bool allowed;
  final String? reason;

  const PermissionDecision.allow()
      : allowed = true,
        reason = null;

  const PermissionDecision.deny(this.reason) : allowed = false;
}

class GroupPermissionSet {
  final GroupMemberRole role;
  final bool isAllMuted;
  final bool canManage;
  final bool canDismiss;
  final bool canSpeak;
  final bool canInviteMembers;
  final bool canModifyTitle;
  final bool canAtAll;
  final bool canViewMembers;
  final bool canAddFriendFromGroup;
  final String? muteReason;

  const GroupPermissionSet({
    required this.role,
    required this.isAllMuted,
    required this.canManage,
    required this.canDismiss,
    required this.canSpeak,
    required this.canInviteMembers,
    required this.canModifyTitle,
    required this.canAtAll,
    required this.canViewMembers,
    required this.canAddFriendFromGroup,
    this.muteReason,
  });
}

class AppPermissions {
  static const groupManageDeniedReason = '仅群主/管理员可修改群管理设置';
  static const groupNameDeniedReason = '仅群主/管理员可修改群名称';
  static const groupMutedReason = '已开启仅群主或特定成员可发言';
  // Review-only kill switch. Defaults to false for normal releases.
  static const isGroupCreationDisabled =
      bool.fromEnvironment('DISABLE_GROUP_CREATION', defaultValue: false);

  const AppPermissions._();

  static GroupMemberRole parseGroupRole(Object? value) {
    final source = value?.toString().trim().toLowerCase() ?? '';
    final raw = source.contains('.') ? source.split('.').last : source;
    if (raw == 'owner' || raw == 'superadmin' || raw == 'super_admin') {
      return GroupMemberRole.owner;
    }
    if (raw == 'admin' || raw == 'administrator') {
      return GroupMemberRole.admin;
    }
    return GroupMemberRole.member;
  }

  static bool isGroupManager(Object? role) {
    final parsed = parseGroupRole(role);
    return parsed == GroupMemberRole.owner || parsed == GroupMemberRole.admin;
  }

  static bool isGroupOwner(Object? role) =>
      parseGroupRole(role) == GroupMemberRole.owner;

  static PermissionDecision canManageGroup(Object? role) {
    return isGroupManager(role)
        ? const PermissionDecision.allow()
        : const PermissionDecision.deny(groupManageDeniedReason);
  }

  static GroupPermissionSet group({
    required Object? myRole,
    required bool isAllMuted,
    required bool allowMemberInvite,
    required bool allowMemberModifyTitle,
    required bool allowMemberAtAll,
    required bool allowMemberViewMemberList,
    required bool allowMemberAddFriend,
    SpaceContext? space,
  }) {
    final role = parseGroupRole(myRole);
    final isTenantAdminOrOwner = space?.isAdminOrAbove ?? false;
    final canManage = role == GroupMemberRole.owner ||
        role == GroupMemberRole.admin ||
        isTenantAdminOrOwner;
    final isCustomerService = space?.isCustomerService ?? false;
    final canSpeak = !isAllMuted || canManage || isCustomerService;
    final isMember = role == GroupMemberRole.member;

    return GroupPermissionSet(
      role: role,
      isAllMuted: isAllMuted,
      canManage: canManage,
      canDismiss: role == GroupMemberRole.owner,
      canSpeak: canSpeak,
      canInviteMembers: canManage || allowMemberInvite,
      canModifyTitle: canManage || allowMemberModifyTitle,
      canAtAll: canManage || allowMemberAtAll,
      canViewMembers: canManage || allowMemberViewMemberList,
      canAddFriendFromGroup: !isMember || allowMemberAddFriend,
      muteReason: canSpeak ? null : groupMutedReason,
    );
  }

  static CustomerDirectoryScope customerDirectoryScope(SpaceContext? space) {
    if (space == null || !space.isEmployee) {
      return CustomerDirectoryScope.none;
    }
    return switch (space.membershipRole) {
      2 => CustomerDirectoryScope.assigned,
      3 || 4 => CustomerDirectoryScope.all,
      _ => CustomerDirectoryScope.none,
    };
  }

  static bool canSeeCustomers(SpaceContext? space) =>
      customerDirectoryScope(space) != CustomerDirectoryScope.none;

  static BroadcastAccess broadcast(SpaceContext? space) {
    final isEmployee = space?.isEmployee == true;
    final role = space?.membershipRole;
    return BroadcastAccess(
      canUseClientBulkSend: isEmployee && (role == 2 || role == 3 || role == 4),
      canUseEnterpriseBroadcast: isEmployee && (role == 3 || role == 4),
    );
  }

  static bool canSeeAllCustomers(SpaceContext? space) =>
      customerDirectoryScope(space) == CustomerDirectoryScope.all;

  static bool canManageCustomerAssignments(SpaceContext? space) =>
      customerDirectoryScope(space) == CustomerDirectoryScope.all;

  static bool canSeeCustomerGroups(SpaceContext? space) =>
      space != null &&
      space.isEmployee &&
      (space.membershipRole == 2 ||
          space.membershipRole == 3 ||
          space.membershipRole == 4);

  static bool canSeeJoinApplications(SpaceContext? space) =>
      space != null && space.isEmployee && space.isAdminOrAbove;

  static bool canSeeCustomerOverview(SpaceContext? space) =>
      canSeeAllCustomers(space);

  static bool canSeeWorkbench(SpaceContext? space) =>
      space != null && space.isEmployee;

  static bool canUseCustomerWorkbench(SpaceContext? space) =>
      space != null && space.isEmployee && space.membershipRole == 2;

  static bool canUseOwnerWorkbench(SpaceContext? space) =>
      space != null && space.isEmployee && space.isOwner;

  static bool canBeAssignedAsCustomerService({
    int? membershipRole,
    String? roleTag,
  }) {
    if (membershipRole != null) return membershipRole == 2;
    return roleTag == '客服';
  }

  static bool canCreateGroup(SpaceContext? space) =>
      canCreateGroupForReleaseFace(space, releaseFaceBlocks: false);

  static bool canCreateGroupForReleaseFace(
    SpaceContext? space, {
    required bool releaseFaceBlocks,
  }) {
    if (isGroupCreationDisabled || releaseFaceBlocks) return false;
    if (space == null) return false;
    if (space.isCustomer) return false;
    if (space.isEmployee) return space.isAdminOrAbove;
    return true;
  }

  static bool canJoinSpaceFromHome(SpaceContext? space) =>
      space != null && space.isEmployee && space.isAdminOrAbove;

  static bool canDirectMessageProfile({
    required SpaceContext? space,
    required bool adminCustomerView,
    required bool targetIsFriend,
    required bool targetIsEmployee,
  }) {
    if (adminCustomerView) return false;
    return (space?.isEmployee ?? false) || targetIsFriend || targetIsEmployee;
  }

  static PermissionDecision canSendFriendRequest({
    required SpaceContext? space,
    required bool groupAllowsFriendRequest,
    required bool targetIsEmployee,
  }) {
    if (!groupAllowsFriendRequest) {
      return const PermissionDecision.deny('该群已关闭群成员互加好友');
    }
    if (space?.type == SpaceType.customerRestricted && !targetIsEmployee) {
      return const PermissionDecision.deny('当前企业已开启客户隔离，暂不支持添加客户好友');
    }
    return const PermissionDecision.allow();
  }

  static bool canDiscoverFriendCandidate({
    required SpaceContext? space,
    required bool targetIsEmployee,
  }) {
    return space?.type != SpaceType.customerRestricted || targetIsEmployee;
  }
}
