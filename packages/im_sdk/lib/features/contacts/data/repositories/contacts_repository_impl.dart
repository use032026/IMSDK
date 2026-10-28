import 'package:im_sdk/features/contacts/data/datasources/contacts_remote_datasource.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/domain/entities/friend_profile_extra.dart';
import 'package:im_sdk/features/contacts/domain/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsRemoteDataSource _remote;

  ContactsRepositoryImpl(this._remote);

  @override
  Future<List<Contact>> getFriends() => _remote.getFriends();

  @override
  Future<FriendRequestSubmission> sendFriendRequest(String toUserId,
          {String? message}) =>
      _remote.sendFriendRequest(toUserId, message: message);

  @override
  Future<FriendRequestSubmission> acceptFriendInviteQr(String token) =>
      _remote.acceptFriendInviteQr(token);

  @override
  Future<List<Contact>> searchUsers(String keyword) =>
      _remote.searchUsers(keyword);

  @override
  Future<List<Department>> getDepartmentTree() => _remote.getDepartmentTree();

  @override
  Future<List<DepartmentMember>> getDepartmentMembers(String departmentId) =>
      _remote.getDepartmentMembers(departmentId);

  @override
  Future<List<Contact>> getTenantMembers() => _remote.getTenantMembers();

  @override
  Future<List<FriendRequest>> getFriendRequests(
          {FriendRequestStatus? status}) =>
      _remote.getFriendRequests(status: status);

  @override
  Future<void> handleFriendRequest(String requestId, String action) =>
      _remote.handleFriendRequest(requestId, action);

  @override
  Future<void> updateFriend(
    String friendUserId, {
    String? remark,
    String? group,
    List<String>? tags,
    String? note,
    int? remarkGenderValue,
  }) =>
      _remote.updateFriend(
        friendUserId,
        remark: remark,
        group: group,
        tags: tags,
        note: note,
        remarkGenderValue: remarkGenderValue,
      );

  @override
  Future<FriendProfileExtra> getFriendProfileExtra(String friendUserId) =>
      _remote.getFriendProfileExtra(friendUserId);

  @override
  Future<void> deleteFriend(String friendUserId) =>
      _remote.deleteFriend(friendUserId);

  @override
  Future<List<BlockedUser>> getBlocklist() => _remote.getBlocklist();

  @override
  Future<void> blockUser(String userId) => _remote.blockUser(userId);

  @override
  Future<void> unblockUser(String userId) => _remote.unblockUser(userId);
}
