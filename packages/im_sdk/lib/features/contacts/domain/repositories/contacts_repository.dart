import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/domain/entities/friend_profile_extra.dart';

abstract class ContactsRepository {
  Future<List<Contact>> getFriends();
  Future<FriendRequestSubmission> sendFriendRequest(String toUserId,
      {String? message});
  Future<FriendRequestSubmission> acceptFriendInviteQr(String token);
  Future<List<Contact>> searchUsers(String keyword);
  Future<List<Department>> getDepartmentTree();
  Future<List<DepartmentMember>> getDepartmentMembers(String departmentId);
  Future<List<Contact>> getTenantMembers();

  // 好友申请管理
  Future<List<FriendRequest>> getFriendRequests({FriendRequestStatus? status});
  Future<void> handleFriendRequest(
      String requestId, String action); // 'accept' | 'reject'

  // 好友操作
  Future<void> updateFriend(
    String friendUserId, {
    String? remark,
    String? group,
    List<String>? tags,
    String? note,
    int? remarkGenderValue,
  });
  Future<FriendProfileExtra> getFriendProfileExtra(String friendUserId);
  Future<void> deleteFriend(String friendUserId);

  // 黑名单
  Future<List<BlockedUser>> getBlocklist();
  Future<void> blockUser(String userId);
  Future<void> unblockUser(String userId);
}
