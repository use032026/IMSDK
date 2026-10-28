import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/space/space_context.dart';

int cachedAuthorizationRole({
  required int? userScopedRole,
  int? tenantDisplayRole,
}) {
  final role = userScopedRole ?? 0;
  return role > 0 ? role : 0;
}

String accountScopedCacheKey(String baseKey, String userId) {
  final normalizedUserId = userId.trim();
  if (normalizedUserId.isEmpty) {
    throw StateError('账号身份尚未稳定，不能访问账号缓存');
  }
  return '${baseKey}_v2_${normalizedUserId.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')}';
}

@immutable
class AccountScope {
  final String serviceRealmId;
  final String platformUserId;
  final String spaceId;
  final String userId;

  const AccountScope._({
    required this.serviceRealmId,
    required this.platformUserId,
    required this.spaceId,
    required this.userId,
  });

  static AccountScope? tryCreate({
    required String serviceRealmId,
    required String platformUserId,
    required String spaceId,
    required String userId,
  }) {
    final realm = serviceRealmId.trim().toLowerCase();
    final platform = platformUserId.trim();
    final space = spaceId.trim();
    final user = userId.trim();
    if (realm.isEmpty || platform.isEmpty || space.isEmpty || user.isEmpty) {
      return null;
    }
    return AccountScope._(
      serviceRealmId: realm,
      platformUserId: platform,
      spaceId: space,
      userId: user,
    );
  }

  factory AccountScope.fromSpace({
    required String serviceRealmId,
    required String platformUserId,
    required SpaceContext space,
  }) {
    final scope = tryFromSpace(
      serviceRealmId: serviceRealmId,
      platformUserId: platformUserId,
      space: space,
    );
    if (scope == null) {
      throw StateError('账号身份尚未稳定，不能创建权限作用域');
    }
    return scope;
  }

  static AccountScope? tryFromSpace({
    required String serviceRealmId,
    required String platformUserId,
    required SpaceContext? space,
  }) =>
      tryCreate(
        serviceRealmId: serviceRealmId,
        platformUserId: platformUserId,
        spaceId: space?.spaceId ?? '',
        userId: space?.userId ?? '',
      );

  String get scopeKey => jsonEncode(<String>[
        'account-scope-v2',
        serviceRealmId,
        platformUserId,
        spaceId,
        userId,
      ]);

  String get storageKeyHash => sha256.convert(utf8.encode(scopeKey)).toString();

  String get platformAccountHash => sha256
      .convert(utf8.encode(jsonEncode(<String>[
        'platform-account-v2',
        serviceRealmId,
        platformUserId,
      ])))
      .toString();

  /// Whether [space] belongs to this exact account runtime.
  ///
  /// Space changes are published by the root authentication owner before the
  /// old account ProviderScope has necessarily been disposed. Runtime-owned
  /// consumers must use this check so the old database can never start work
  /// for the incoming account/space during that handoff window.
  bool ownsSpace(SpaceContext? space) =>
      space != null &&
      space.spaceId.trim() == spaceId &&
      space.userId.trim() == userId;

  static String? tryPlatformAccountHash({
    required String serviceRealmId,
    required String platformUserId,
  }) {
    final realm = serviceRealmId.trim().toLowerCase();
    final platform = platformUserId.trim();
    if (realm.isEmpty || platform.isEmpty) return null;
    return sha256
        .convert(utf8.encode(jsonEncode(<String>[
          'platform-account-v2',
          realm,
          platform,
        ])))
        .toString();
  }

  AccountScopedGroupId group(String groupId) => AccountScopedGroupId(
        accountScopeKey: scopeKey,
        storageKeyHash: storageKeyHash,
        groupId: groupId.trim(),
      );

  @override
  bool operator ==(Object other) =>
      other is AccountScope && other.scopeKey == scopeKey;

  @override
  int get hashCode => scopeKey.hashCode;
}

@immutable
class AccountScopedGroupId {
  final String accountScopeKey;
  final String storageKeyHash;
  final String groupId;

  const AccountScopedGroupId({
    required this.accountScopeKey,
    required this.storageKeyHash,
    required this.groupId,
  });

  String get memberCacheKey =>
      'group_members_v3_${storageKeyHash}_${_safe(groupId)}';

  static String _safe(String value) =>
      value.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');

  @override
  bool operator ==(Object other) =>
      other is AccountScopedGroupId &&
      other.accountScopeKey == accountScopeKey &&
      other.groupId == groupId;

  @override
  int get hashCode => Object.hash(accountScopeKey, groupId);
}
