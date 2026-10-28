import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/space/account_scope.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';

@immutable
class PlatformTenantDirectorySnapshot {
  const PlatformTenantDirectorySnapshot({
    required this.platformAccountHash,
    required this.tenants,
    required this.validatedAt,
  });

  final String platformAccountHash;
  final List<TenantSummary> tenants;
  final DateTime validatedAt;
}

/// Platform-account-scoped persistence adapter for the last authoritative
/// `/my/tenants` projection. It never grants permissions; cached roles are
/// deliberately restored as zero until the server confirms them again.
class PlatformTenantDirectoryStore {
  PlatformTenantDirectoryStore(this._storage);

  static const _version = 2;
  static const _legacyRetiredKey = 'legacy_space_directory_retired_v1';
  final SecureStorageService _storage;

  Future<PlatformTenantDirectorySnapshot?> load({
    required String serviceRealmId,
    required String platformUserId,
  }) async {
    final hash = AccountScope.tryPlatformAccountHash(
      serviceRealmId: serviceRealmId,
      platformUserId: platformUserId,
    );
    if (hash == null) return null;
    final raw = await _storage.read(_directoryKey(hash));
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic> ||
          json['version'] != _version ||
          json['platformAccountHash'] != hash) {
        return null;
      }
      final validatedAt =
          DateTime.tryParse(json['validatedAt'] as String? ?? '');
      final rawTenants = json['tenants'];
      if (validatedAt == null || rawTenants is! List) return null;
      final tenants = <TenantSummary>[];
      final ids = <String>{};
      for (final item in rawTenants) {
        if (item is! Map<String, dynamic>) return null;
        final tenantId = (item['tenantId'] as String? ?? '').trim();
        final tenantName = (item['tenantName'] as String? ?? '').trim();
        if (tenantId.isEmpty || tenantName.isEmpty || !ids.add(tenantId)) {
          return null;
        }
        tenants.add(TenantSummary(
          tenantId: tenantId,
          tenantName: tenantName,
          tenantCode: _optionalString(item['tenantCode']),
          logoUrl: _optionalString(item['logoUrl']),
          membershipRole: 0,
        ));
      }
      return PlatformTenantDirectorySnapshot(
        platformAccountHash: hash,
        tenants: List.unmodifiable(tenants),
        validatedAt: validatedAt.toUtc(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> replace({
    required String serviceRealmId,
    required String platformUserId,
    required List<TenantSummary> tenants,
    DateTime? validatedAt,
  }) async {
    final hash = AccountScope.tryPlatformAccountHash(
      serviceRealmId: serviceRealmId,
      platformUserId: platformUserId,
    );
    if (hash == null) {
      throw StateError('平台账号身份尚未稳定，不能写入租户目录');
    }
    final ids = <String>{};
    final payload = <Map<String, Object?>>[];
    for (final tenant in tenants) {
      final tenantId = tenant.tenantId.trim();
      final tenantName = tenant.tenantName.trim();
      if (tenantId.isEmpty || tenantName.isEmpty || !ids.add(tenantId)) {
        throw StateError('租户目录包含无效或重复条目');
      }
      payload.add(<String, Object?>{
        'tenantId': tenantId,
        'tenantName': tenantName,
        'tenantCode': tenant.tenantCode,
        'logoUrl': tenant.logoUrl,
      });
    }
    await _storage.write(
      _directoryKey(hash),
      jsonEncode(<String, Object?>{
        'version': _version,
        'platformAccountHash': hash,
        'validatedAt':
            (validatedAt ?? DateTime.now()).toUtc().toIso8601String(),
        'tenants': payload,
      }),
    );
  }

  Future<String?> readLastActiveSpace({
    required String serviceRealmId,
    required String platformUserId,
  }) async {
    final hash = AccountScope.tryPlatformAccountHash(
      serviceRealmId: serviceRealmId,
      platformUserId: platformUserId,
    );
    if (hash == null) return null;
    final value = (await _storage.read(_lastActiveKey(hash)))?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  Future<void> writeLastActiveSpace({
    required String serviceRealmId,
    required String platformUserId,
    required String spaceId,
  }) async {
    final hash = AccountScope.tryPlatformAccountHash(
      serviceRealmId: serviceRealmId,
      platformUserId: platformUserId,
    );
    final normalizedSpaceId = spaceId.trim();
    if (hash == null || normalizedSpaceId.isEmpty) {
      throw StateError('平台账号或空间身份尚未稳定');
    }
    await _storage.write(_lastActiveKey(hash), normalizedSpaceId);
  }

  /// Legacy space-only metadata cannot be attributed to an account. Remove it
  /// once and never migrate it into a v2 platform-account directory.
  Future<void> retireLegacyGlobalDirectory() async {
    if (await _storage.read(_legacyRetiredKey) == '1') return;
    final tenantIds = await _storage.readKnownTenantIds();
    for (final tenantId in tenantIds.toSet()) {
      await _storage.delete(SecureStorageService.tenantNameKey(tenantId));
      await _storage.delete(SecureStorageService.tenantLogoKey(tenantId));
      await _storage.delete(
        SecureStorageService.tenantMembershipRoleKey(tenantId),
      );
    }
    await _storage.delete(SecureStorageService.knownTenantIdsKey);
    await _storage.delete(SecureStorageService.lastActiveSpaceIdKey);
    await _storage.write(_legacyRetiredKey, '1');
  }

  static String _directoryKey(String hash) =>
      'platform_tenant_directory_v2_$hash';
  static String _lastActiveKey(String hash) =>
      'platform_last_active_space_v2_$hash';

  static String? _optionalString(Object? value) {
    final text = value is String ? value.trim() : '';
    return text.isEmpty ? null : text;
  }
}
