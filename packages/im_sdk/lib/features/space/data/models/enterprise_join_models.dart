import 'package:flutter/foundation.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';

enum TenantLookupResolution { resolved, aliasOnly }

enum RegistrationCredentialPreviewKind {
  invitation,
  notFound,
}

@immutable
class RegistrationCredentialPreview {
  final String credential;
  final RegistrationCredentialPreviewKind kind;
  final InvitationPreview? invitation;

  const RegistrationCredentialPreview._({
    required this.credential,
    required this.kind,
    this.invitation,
  });

  const RegistrationCredentialPreview.invitation({
    required String credential,
    required InvitationPreview invitation,
  }) : this._(
          credential: credential,
          kind: RegistrationCredentialPreviewKind.invitation,
          invitation: invitation,
        );

  const RegistrationCredentialPreview.notFound(String credential)
      : this._(
          credential: credential,
          kind: RegistrationCredentialPreviewKind.notFound,
        );
}

@immutable
class JoinableTenant {
  final String tenantId;
  final String tenantCode;
  final String? matchedAlias;
  final String tenantName;
  final String? logoUrl;
  final String? industry;
  final int? memberCount;
  final String? description;
  final bool alreadyMember;
  final TenantLookupResolution resolution;

  const JoinableTenant({
    required this.tenantId,
    required this.tenantCode,
    this.matchedAlias,
    required this.tenantName,
    this.logoUrl,
    this.industry,
    this.memberCount,
    this.description,
    this.alreadyMember = false,
    this.resolution = TenantLookupResolution.resolved,
  });

  const JoinableTenant.aliasOnly(String alias)
      : tenantId = '',
        tenantCode = '',
        matchedAlias = alias,
        tenantName = '',
        logoUrl = null,
        industry = null,
        memberCount = null,
        description = null,
        alreadyMember = false,
        resolution = TenantLookupResolution.aliasOnly;

  factory JoinableTenant.fromJson(
    Map<String, dynamic> json, {
    String? lookupCode,
  }) {
    final tenantCode = json['tenantCode'] as String? ?? '';
    final normalizedLookupCode = lookupCode?.trim().toLowerCase();
    return JoinableTenant(
      tenantId: json['tenantId'] as String? ?? '',
      tenantCode: tenantCode,
      matchedAlias: normalizedLookupCode != null &&
              normalizedLookupCode.isNotEmpty &&
              normalizedLookupCode != tenantCode.trim().toLowerCase()
          ? normalizedLookupCode
          : null,
      tenantName: json['tenantName'] as String? ?? '',
      logoUrl: _nonEmpty(json['logoUrl']),
      industry: _nonEmpty(json['industry']),
      memberCount: _asInt(json['memberCount']),
      description: _nonEmpty(json['tenantDescription']) ??
          _nonEmpty(json['description']),
      alreadyMember: json['alreadyMember'] as bool? ?? false,
    );
  }

  bool get hasResolvedPreview => resolution == TenantLookupResolution.resolved;

  String get joinIdentifier =>
      hasResolvedPreview ? tenantCode : matchedAlias ?? '';

  TenantSummary toTenantSummary() {
    return TenantSummary(
      tenantId: tenantId,
      tenantName: tenantName,
      tenantCode: tenantCode.isEmpty ? null : tenantCode,
      logoUrl: logoUrl,
      membershipRole: 0,
    );
  }
}

@immutable
class InvitationPreview {
  final String tenantId;
  final String tenantCode;
  final String tenantName;
  final String? logoUrl;
  final String? industry;
  final String? description;
  final bool alreadyMember;
  final bool? identityMatched;
  final int? targetMembershipRole;
  final String? targetHint;

  const InvitationPreview({
    required this.tenantId,
    required this.tenantCode,
    required this.tenantName,
    this.logoUrl,
    this.industry,
    this.description,
    this.alreadyMember = false,
    this.identityMatched,
    this.targetMembershipRole,
    this.targetHint,
  });

  factory InvitationPreview.fromJson(Map<String, dynamic> json) {
    return InvitationPreview(
      tenantId: json['tenantId'] as String? ?? '',
      tenantCode: json['tenantCode'] as String? ?? '',
      tenantName: json['tenantName'] as String? ?? '',
      logoUrl: _nonEmpty(json['logoUrl']),
      industry: _nonEmpty(json['industry']),
      description: _nonEmpty(json['tenantDescription']) ??
          _nonEmpty(json['description']),
      alreadyMember: json['alreadyMember'] as bool? ?? false,
      identityMatched: json['identityMatched'] as bool?,
      targetMembershipRole: _asInt(json['targetMembershipRole']),
      targetHint: _nonEmpty(json['targetIdentifierHint']),
    );
  }

  TenantSummary toTenantSummary() {
    return TenantSummary(
      tenantId: tenantId,
      tenantName: tenantName,
      tenantCode: tenantCode.isEmpty ? null : tenantCode,
      logoUrl: logoUrl,
      membershipRole: targetMembershipRole ?? 0,
    );
  }
}

enum PlatformJoinStatus { pending, joined }

@immutable
class PlatformJoinResult {
  final PlatformJoinStatus status;
  final String message;
  final TenantAuthResult? tenantAuth;

  const PlatformJoinResult.pending({required this.message})
      : status = PlatformJoinStatus.pending,
        tenantAuth = null;

  const PlatformJoinResult.joined({
    required this.tenantAuth,
    required this.message,
  }) : status = PlatformJoinStatus.joined;

  bool get isJoined => status == PlatformJoinStatus.joined;
}

@immutable
class MyJoinRequest {
  final String requestId;
  final String tenantId;
  final String tenantCode;
  final String tenantName;
  final String? logoUrl;
  final String message;
  final String status;
  final String? rejectReason;
  final DateTime? createdAt;
  final DateTime? reviewedAt;

  const MyJoinRequest({
    required this.requestId,
    required this.tenantId,
    required this.tenantCode,
    required this.tenantName,
    this.logoUrl,
    required this.message,
    required this.status,
    this.rejectReason,
    this.createdAt,
    this.reviewedAt,
  });

  factory MyJoinRequest.fromJson(Map<String, dynamic> json) {
    return MyJoinRequest(
      requestId: json['requestId'] as String? ?? '',
      tenantId: json['tenantId'] as String? ?? '',
      tenantCode: json['tenantCode'] as String? ?? '',
      tenantName: json['tenantName'] as String? ?? '',
      logoUrl: _nonEmpty(json['logoUrl']),
      message: json['message'] as String? ?? '',
      status: _statusText(json['status']),
      rejectReason: _nonEmpty(json['rejectReason']),
      createdAt: _parseDate(json['createdAt']),
      reviewedAt: _parseDate(json['reviewedAt']),
    );
  }

  bool get isPending => status == 'pending';

  MyJoinRequest copyWith({
    String? tenantCode,
    String? tenantName,
    String? logoUrl,
  }) {
    return MyJoinRequest(
      requestId: requestId,
      tenantId: tenantId,
      tenantCode: tenantCode ?? this.tenantCode,
      tenantName: tenantName ?? this.tenantName,
      logoUrl: logoUrl ?? this.logoUrl,
      message: message,
      status: status,
      rejectReason: rejectReason,
      createdAt: createdAt,
      reviewedAt: reviewedAt,
    );
  }
}

String? _nonEmpty(Object? value) {
  final text = value as String?;
  if (text == null || text.trim().isEmpty) return null;
  return text;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

DateTime? _parseDate(Object? value) {
  final text = value as String?;
  return text == null ? null : DateTime.tryParse(text);
}

String _statusText(Object? value) {
  if (value is String) return value.toLowerCase();
  return switch (value) {
    0 => 'pending',
    1 => 'approved',
    2 => 'rejected',
    3 => 'cancelled',
    _ => 'pending',
  };
}
