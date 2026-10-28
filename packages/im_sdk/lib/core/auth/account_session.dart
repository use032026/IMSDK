import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/space/account_scope.dart';
import 'package:uuid/uuid.dart';

@immutable
class PlatformAccountScope {
  PlatformAccountScope({
    required String serviceRealmId,
    required String platformUserId,
  })  : serviceRealmId = serviceRealmId.trim().toLowerCase(),
        platformUserId = platformUserId.trim() {
    if (this.serviceRealmId.isEmpty || this.platformUserId.isEmpty) {
      throw ArgumentError('platform account identity must be complete');
    }
  }

  factory PlatformAccountScope.fromAccountScope(AccountScope scope) =>
      PlatformAccountScope(
        serviceRealmId: scope.serviceRealmId,
        platformUserId: scope.platformUserId,
      );

  final String serviceRealmId;
  final String platformUserId;

  String get storageKeyHash => AccountScope.tryPlatformAccountHash(
        serviceRealmId: serviceRealmId,
        platformUserId: platformUserId,
      )!;

  @override
  bool operator ==(Object other) =>
      other is PlatformAccountScope &&
      other.serviceRealmId == serviceRealmId &&
      other.platformUserId == platformUserId;

  @override
  int get hashCode => Object.hash(serviceRealmId, platformUserId);
}

@immutable
class StoredSpaceSession {
  const StoredSpaceSession({
    required this.spaceSessionId,
    required this.scope,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenIssuedAt,
    required this.accessTokenExpiresAt,
  });

  final String spaceSessionId;
  final AccountScope scope;
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenIssuedAt;
  final DateTime accessTokenExpiresAt;

  bool isReusableAt(
    DateTime now, {
    Duration minimumValidity = const Duration(minutes: 2),
  }) =>
      accessTokenExpiresAt.toUtc().isAfter(now.toUtc().add(minimumValidity));

  Map<String, Object> toJson() => <String, Object>{
        'spaceSessionId': spaceSessionId,
        'serviceRealmId': scope.serviceRealmId,
        'platformUserId': scope.platformUserId,
        'spaceId': scope.spaceId,
        'userId': scope.userId,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'accessTokenIssuedAt': accessTokenIssuedAt.toUtc().toIso8601String(),
        'accessTokenExpiresAt': accessTokenExpiresAt.toUtc().toIso8601String(),
      };

  static StoredSpaceSession? tryFromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final scope = AccountScope.tryCreate(
      serviceRealmId: value['serviceRealmId'] as String? ?? '',
      platformUserId: value['platformUserId'] as String? ?? '',
      spaceId: value['spaceId'] as String? ?? '',
      userId: value['userId'] as String? ?? '',
    );
    final id = value['spaceSessionId'];
    final access = value['accessToken'];
    final refresh = value['refreshToken'];
    final issuedAt =
        DateTime.tryParse(value['accessTokenIssuedAt'] as String? ?? '');
    final expiresAt =
        DateTime.tryParse(value['accessTokenExpiresAt'] as String? ?? '');
    if (scope == null ||
        id is! String ||
        id.trim().isEmpty ||
        access is! String ||
        access.trim().isEmpty ||
        refresh is! String ||
        refresh.trim().isEmpty ||
        issuedAt == null ||
        expiresAt == null) {
      return null;
    }
    return StoredSpaceSession(
      spaceSessionId: id,
      scope: scope,
      accessToken: access,
      refreshToken: refresh,
      accessTokenIssuedAt: issuedAt.toUtc(),
      accessTokenExpiresAt: expiresAt.toUtc(),
    );
  }
}

@immutable
class AccountActivation {
  AccountActivation({
    required this.spaceSessionId,
    required this.scope,
    required this.identityRevision,
    this.restorePersonalOnRestart = false,
    String? activationId,
  }) : activationId = activationId ?? const Uuid().v4();

  final String activationId;
  final String spaceSessionId;
  final AccountScope scope;
  final int identityRevision;

  /// An official conversation may use a tenant runtime without changing the
  /// personal workspace to restore after the process exits.
  final bool restorePersonalOnRestart;

  Map<String, Object> toJson() => <String, Object>{
        'activationId': activationId,
        'spaceSessionId': spaceSessionId,
        'serviceRealmId': scope.serviceRealmId,
        'platformUserId': scope.platformUserId,
        'spaceId': scope.spaceId,
        'userId': scope.userId,
        'identityRevision': identityRevision,
        if (restorePersonalOnRestart) 'restorePersonalOnRestart': true,
      };

  static AccountActivation? tryFromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final scope = AccountScope.tryCreate(
      serviceRealmId: value['serviceRealmId'] as String? ?? '',
      platformUserId: value['platformUserId'] as String? ?? '',
      spaceId: value['spaceId'] as String? ?? '',
      userId: value['userId'] as String? ?? '',
    );
    final activationId = value['activationId'];
    final spaceSessionId = value['spaceSessionId'];
    final revision = value['identityRevision'];
    if (scope == null ||
        activationId is! String ||
        activationId.trim().isEmpty ||
        spaceSessionId is! String ||
        spaceSessionId.trim().isEmpty ||
        revision is! int ||
        revision < 0) {
      return null;
    }
    return AccountActivation(
      activationId: activationId,
      spaceSessionId: spaceSessionId,
      scope: scope,
      identityRevision: revision,
      restorePersonalOnRestart: value['restorePersonalOnRestart'] == true,
    );
  }
}

@immutable
class AccountSession {
  AccountSession({
    required this.scope,
    required this.identityRevision,
    String? sessionId,
    this.hasPlatformCredential = false,
    this.hasAdminCredential = false,
  }) : sessionId = sessionId ?? const Uuid().v4();

  final AccountScope scope;
  final int identityRevision;
  final String sessionId;
  final bool hasPlatformCredential;
  final bool hasAdminCredential;

  static String hashSessionId(String sessionId) =>
      sha256.convert(utf8.encode(sessionId)).toString();

  String get sessionIdHash => hashSessionId(sessionId);
  String get descriptorKey =>
      'session_descriptor_v2_${scope.storageKeyHash}_$sessionIdHash';
  String get tenantCredentialKey =>
      'tenant_credential_v2_${scope.storageKeyHash}_$sessionIdHash';
  String? get platformCredentialKey => hasPlatformCredential
      ? 'platform_credential_v2_${scope.platformAccountHash}_$sessionIdHash'
      : null;
  String? get adminCredentialKey => hasAdminCredential
      ? 'admin_credential_v2_${scope.storageKeyHash}_$sessionIdHash'
      : null;

  Map<String, Object> toJson() => <String, Object>{
        'serviceRealmId': scope.serviceRealmId,
        'platformUserId': scope.platformUserId,
        'spaceId': scope.spaceId,
        'userId': scope.userId,
        'identityRevision': identityRevision,
        'sessionId': sessionId,
        'hasPlatformCredential': hasPlatformCredential,
        'hasAdminCredential': hasAdminCredential,
      };

  static AccountSession? tryFromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final scope = AccountScope.tryCreate(
      serviceRealmId: value['serviceRealmId'] as String? ?? '',
      platformUserId: value['platformUserId'] as String? ?? '',
      spaceId: value['spaceId'] as String? ?? '',
      userId: value['userId'] as String? ?? '',
    );
    final revision = value['identityRevision'];
    final sessionId = value['sessionId'];
    if (scope == null || revision is! int || revision < 0) return null;
    if (sessionId is! String || sessionId.trim().isEmpty) return null;
    return AccountSession(
      scope: scope,
      identityRevision: revision,
      sessionId: sessionId,
      hasPlatformCredential: value['hasPlatformCredential'] == true,
      hasAdminCredential: value['hasAdminCredential'] == true,
    );
  }
}

@immutable
class SessionCredentials {
  const SessionCredentials({
    required this.tenantAccessToken,
    required this.tenantRefreshToken,
    this.platformAccessToken,
    this.platformRefreshToken,
    this.deviceSessionToken,
    this.adminToken,
  });

  final String tenantAccessToken;
  final String tenantRefreshToken;
  final String? platformAccessToken;
  final String? platformRefreshToken;
  final String? deviceSessionToken;
  final String? adminToken;

  Map<String, Object?> toJson() => <String, Object?>{
        'tenantAccessToken': tenantAccessToken,
        'tenantRefreshToken': tenantRefreshToken,
        'platformAccessToken': platformAccessToken,
        'platformRefreshToken': platformRefreshToken,
        'deviceSessionToken': deviceSessionToken,
        'adminToken': adminToken,
      };

  static SessionCredentials? tryFromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final tenantAccessToken = value['tenantAccessToken'];
    final tenantRefreshToken = value['tenantRefreshToken'];
    if (tenantAccessToken is! String || tenantAccessToken.trim().isEmpty) {
      return null;
    }
    if (tenantRefreshToken is! String || tenantRefreshToken.trim().isEmpty) {
      return null;
    }
    String? optionalString(String key) {
      final raw = value[key];
      return raw is String && raw.trim().isNotEmpty ? raw : null;
    }

    return SessionCredentials(
      tenantAccessToken: tenantAccessToken,
      tenantRefreshToken: tenantRefreshToken,
      platformAccessToken: optionalString('platformAccessToken'),
      platformRefreshToken: optionalString('platformRefreshToken'),
      deviceSessionToken: optionalString('deviceSessionToken'),
      adminToken: optionalString('adminToken'),
    );
  }
}

@immutable
class ActiveAccountSession {
  const ActiveAccountSession({
    required this.session,
    required this.credentials,
    this.spaceSessionId,
    this.accessTokenIssuedAt,
    this.accessTokenExpiresAt,
  });

  final AccountSession session;
  final SessionCredentials credentials;
  final String? spaceSessionId;
  final DateTime? accessTokenIssuedAt;
  final DateTime? accessTokenExpiresAt;

  String get activationId => session.sessionId;
}
