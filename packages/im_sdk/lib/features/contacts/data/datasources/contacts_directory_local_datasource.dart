import 'dart:convert';

import 'package:im_sdk/core/space/account_scope.dart';
import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';

class ContactsDirectoryLocalDataSource {
  ContactsDirectoryLocalDataSource({
    required AccountProfileBoxResolver profileBoxResolver,
  }) : _profileBoxResolver = profileBoxResolver;

  static const _friendsKey = 'friends_cache';
  static const _tenantMembersKey = 'tenant_members_cache';
  static const _departmentTreeKey = 'dept_tree_cache';

  final AccountProfileBoxResolver _profileBoxResolver;

  Future<List<Contact>?> loadFriends(String spaceId, String ownerUserId) =>
      _loadContacts(spaceId, ownerUserId, _friendsKey);

  Future<void> saveFriends(
    String spaceId,
    String ownerUserId,
    List<Contact> contacts,
  ) =>
      _saveContacts(spaceId, ownerUserId, _friendsKey, contacts);

  Future<List<Contact>?> loadTenantMembers(
    String spaceId,
    String ownerUserId,
  ) =>
      _loadContacts(spaceId, ownerUserId, _tenantMembersKey);

  Future<void> saveTenantMembers(
    String spaceId,
    String ownerUserId,
    List<Contact> contacts,
  ) =>
      _saveContacts(spaceId, ownerUserId, _tenantMembersKey, contacts);

  Future<List<Department>?> loadDepartmentTree(
    String spaceId,
    String ownerUserId,
  ) async {
    final box = await _profileBoxResolver(spaceId);
    if (box.containsKey(_departmentTreeKey)) {
      await box.delete(_departmentTreeKey);
    }
    final raw = box.get(accountScopedCacheKey(_departmentTreeKey, ownerUserId));
    if (raw is! String) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => _departmentFromMap(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> saveDepartmentTree(
    String spaceId,
    String ownerUserId,
    List<Department> departments,
  ) async {
    final box = await _profileBoxResolver(spaceId);
    await box.put(
      accountScopedCacheKey(_departmentTreeKey, ownerUserId),
      jsonEncode(departments.map(_departmentToMap).toList()),
    );
  }

  Future<List<Contact>?> _loadContacts(
    String spaceId,
    String ownerUserId,
    String cacheKey,
  ) async {
    final box = await _profileBoxResolver(spaceId);
    if (box.containsKey(cacheKey)) {
      await box.delete(cacheKey);
    }
    final raw = box.get(accountScopedCacheKey(cacheKey, ownerUserId));
    if (raw is! String) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => _contactFromMap(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> _saveContacts(
    String spaceId,
    String ownerUserId,
    String cacheKey,
    List<Contact> contacts,
  ) async {
    final box = await _profileBoxResolver(spaceId);
    await box.put(
      accountScopedCacheKey(cacheKey, ownerUserId),
      jsonEncode(contacts.map(_contactToMap).toList()),
    );
  }

  static Contact _contactFromMap(Map<String, dynamic> map) => Contact(
        userId: map['userId'] as String? ?? '',
        name: map['name'] as String? ?? '',
        avatarUrl: map['avatarUrl'] as String?,
        remark: map['remark'] as String?,
        isOnline: map['isOnline'] as bool? ?? false,
        customerTag: map['customerTag'] as String?,
        userType: map['userType'] as int?,
      );

  static Map<String, Object?> _contactToMap(Contact contact) => {
        'userId': contact.userId,
        'name': contact.name,
        'avatarUrl': contact.avatarUrl,
        'remark': contact.remark,
        'isOnline': contact.isOnline,
        'customerTag': contact.customerTag,
        'userType': contact.userType,
      };

  static Department _departmentFromMap(Map<String, dynamic> map) => Department(
        departmentId: map['departmentId'] as String? ?? '',
        departmentName: map['departmentName'] as String? ?? '',
        parentId: map['parentId'] as String?,
        leaderUserId: map['leaderUserId'] as String?,
        memberCount: map['memberCount'] as int? ?? 0,
        children: ((map['children'] as List<dynamic>?) ?? const [])
            .map(
              (item) => _departmentFromMap(item as Map<String, dynamic>),
            )
            .toList(growable: false),
      );

  static Map<String, Object?> _departmentToMap(Department department) => {
        'departmentId': department.departmentId,
        'departmentName': department.departmentName,
        'parentId': department.parentId,
        'leaderUserId': department.leaderUserId,
        'memberCount': department.memberCount,
        'children': department.children.map(_departmentToMap).toList(),
      };
}
