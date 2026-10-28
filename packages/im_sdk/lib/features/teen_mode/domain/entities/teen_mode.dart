typedef TeenPolicy = Map<String, Object>;

enum TeenModeSource {
  kycAge,
  guardian,
  tenantAdmin,
  platformAdmin,
  self,
  unknown
}

enum TeenSessionReason { ok, dailyLimit, curfew, unknown }

enum TeenPolicyKind { boolValue, intValue, enumValue, unknown }

enum GuardianRole { guardian, minor, unknown }

enum GuardianApprovalStatus {
  pending,
  approved,
  rejected,
  expired,
  cancelled,
  unknown
}

enum GuardianReplayStatus { none, succeeded, failed, unknown }

class TeenPolicyOption {
  const TeenPolicyOption({required this.value, required this.label});

  final Object value;
  final String label;
}

class TeenPolicyCatalogItem {
  const TeenPolicyCatalogItem({
    required this.key,
    required this.label,
    required this.description,
    required this.group,
    required this.kind,
    required this.defaultValue,
    required this.options,
    required this.min,
    required this.max,
    required this.locked,
  });

  final String key;
  final String label;
  final String description;
  final String group;
  final TeenPolicyKind kind;
  final Object? defaultValue;
  final List<TeenPolicyOption> options;
  final int? min;
  final int? max;
  final bool locked;

  bool get isRenderable => key.isNotEmpty && kind != TeenPolicyKind.unknown;
}

class TeenModeConfig {
  const TeenModeConfig({
    required this.enabled,
    required this.selfEnrollmentEnabled,
    required this.guardianEnabled,
    required this.minorAgeThreshold,
    required this.maxGuardiansPerMinor,
    required this.bindTokenTtlMinutes,
    required this.approvalTtlHours,
    required this.unboundMinorBehavior,
    required this.policyCatalog,
  });

  final bool enabled;
  final bool selfEnrollmentEnabled;
  final bool guardianEnabled;
  final int minorAgeThreshold;
  final int maxGuardiansPerMinor;
  final int bindTokenTtlMinutes;
  final int approvalTtlHours;
  final String unboundMinorBehavior;
  final List<TeenPolicyCatalogItem> policyCatalog;
}

class TeenModeSession {
  const TeenModeSession({
    required this.active,
    required this.allowed,
    required this.reason,
    required this.usedSeconds,
    required this.limitSeconds,
    required this.remainingSeconds,
    required this.resetAt,
    required this.curfewUntil,
    required this.timeZoneId,
    this.projectionValid = true,
  });

  final bool active;
  final bool allowed;
  final TeenSessionReason reason;
  final int usedSeconds;
  final int limitSeconds;
  final int remainingSeconds;
  final DateTime? resetAt;
  final DateTime? curfewUntil;
  final String timeZoneId;
  final bool projectionValid;

  bool get isRestricted => active && (!projectionValid || !allowed);

  bool get hasUnlimitedTime => limitSeconds == 0 || remainingSeconds == -1;
}

class TeenGuardianSummary {
  const TeenGuardianSummary({
    required this.linkId,
    required this.platformUserId,
    required this.displayName,
    required this.avatarUrl,
    required this.lppId,
    required this.relation,
    required this.isPrimary,
    required this.canApprove,
    required this.canManagePolicy,
  });

  final String linkId;
  final String platformUserId;
  final String displayName;
  final String? avatarUrl;
  final String? lppId;
  final String relation;
  final bool isPrimary;
  final bool canApprove;
  final bool canManagePolicy;
}

class TeenModeProfile {
  const TeenModeProfile({
    required this.active,
    required this.source,
    required this.sourceLabel,
    required this.lockLevel,
    required this.canSelfDisable,
    required this.hasPasscode,
    required this.timeZoneId,
    required this.activatedAt,
    required this.autoReleaseAt,
    required this.policy,
    required this.guardians,
    required this.pendingApprovalCount,
    required this.session,
  });

  final bool active;
  final TeenModeSource source;
  final String sourceLabel;
  final int lockLevel;
  final bool canSelfDisable;
  final bool hasPasscode;
  final String timeZoneId;
  final DateTime? activatedAt;
  final DateTime? autoReleaseAt;
  final TeenPolicy policy;
  final List<TeenGuardianSummary> guardians;
  final int pendingApprovalCount;
  final TeenModeSession session;

  TeenModeProfile copyWith({TeenModeSession? session}) => TeenModeProfile(
        active: active,
        source: source,
        sourceLabel: sourceLabel,
        lockLevel: lockLevel,
        canSelfDisable: canSelfDisable,
        hasPasscode: hasPasscode,
        timeZoneId: timeZoneId,
        activatedAt: activatedAt,
        autoReleaseAt: autoReleaseAt,
        policy: policy,
        guardians: guardians,
        pendingApprovalCount: pendingApprovalCount,
        session: session ?? this.session,
      );
}

class TeenModeState {
  const TeenModeState({required this.config, required this.profile});

  final TeenModeConfig config;
  final TeenModeProfile? profile;

  bool get entryVisible => config.enabled;
  bool get active => profile?.active == true;
  bool get restricted => profile?.session.isRestricted == true;
}

class TeenModeDisableResult {
  const TeenModeDisableResult({
    required this.disabled,
    required this.pendingApproval,
    required this.approvalRequestId,
    required this.message,
  });

  final bool disabled;
  final bool pendingApproval;
  final String? approvalRequestId;
  final String message;
}

class TeenModeExtendRequestResult {
  const TeenModeExtendRequestResult({
    required this.submitted,
    required this.requestId,
    required this.code,
    required this.message,
  });

  final bool submitted;
  final String? requestId;
  final String code;
  final String message;
}

class GuardianBindCode {
  const GuardianBindCode({
    required this.tokenId,
    required this.code,
    required this.issuerRole,
    required this.expiresAt,
  });

  final String tokenId;
  final String code;
  final GuardianRole issuerRole;
  final DateTime? expiresAt;
}

class GuardianLink {
  const GuardianLink({
    required this.linkId,
    required this.counterpartPlatformUserId,
    required this.counterpartDisplayName,
    required this.counterpartAvatarUrl,
    required this.counterpartLppId,
    required this.myRole,
    required this.status,
    required this.relation,
    required this.isPrimary,
    required this.canApprove,
    required this.canManagePolicy,
    required this.createdAt,
    required this.activatedAt,
  });

  final String linkId;
  final String counterpartPlatformUserId;
  final String counterpartDisplayName;
  final String? counterpartAvatarUrl;
  final String? counterpartLppId;
  final GuardianRole myRole;
  final String status;
  final String relation;
  final bool isPrimary;
  final bool canApprove;
  final bool canManagePolicy;
  final DateTime? createdAt;
  final DateTime? activatedAt;
}

class GuardianUnbindResult {
  const GuardianUnbindResult({
    required this.unbound,
    required this.pendingApproval,
    required this.approvalRequestId,
    required this.message,
  });

  final bool unbound;
  final bool pendingApproval;
  final String? approvalRequestId;
  final String message;
}

class GuardianMinor {
  const GuardianMinor({
    required this.linkId,
    required this.minorPlatformUserId,
    required this.displayName,
    required this.avatarUrl,
    required this.lppId,
    required this.relation,
    required this.teenModeActive,
    required this.source,
    required this.lockLevel,
    required this.canManagePolicy,
    required this.policy,
    required this.editablePolicyKeys,
    required this.session,
    required this.pendingApprovalCount,
    required this.lastActiveAt,
  });

  final String linkId;
  final String minorPlatformUserId;
  final String displayName;
  final String? avatarUrl;
  final String? lppId;
  final String relation;
  final bool teenModeActive;
  final TeenModeSource source;
  final int lockLevel;
  final bool canManagePolicy;
  final TeenPolicy policy;
  final Set<String> editablePolicyKeys;
  final TeenModeSession session;
  final int pendingApprovalCount;
  final DateTime? lastActiveAt;
}

class GuardianApproval {
  const GuardianApproval({
    required this.requestId,
    required this.minorPlatformUserId,
    required this.minorDisplayName,
    required this.minorAvatarUrl,
    required this.actionCode,
    required this.actionLabel,
    required this.summary,
    required this.status,
    required this.tenantId,
    required this.createdAt,
    required this.expiresAt,
    required this.decidedAt,
    required this.decisionNote,
    required this.replayStatus,
    required this.replayError,
  });

  final String requestId;
  final String minorPlatformUserId;
  final String minorDisplayName;
  final String? minorAvatarUrl;
  final String actionCode;
  final String actionLabel;
  final String summary;
  final GuardianApprovalStatus status;
  final String? tenantId;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final DateTime? decidedAt;
  final String? decisionNote;
  final GuardianReplayStatus replayStatus;
  final String? replayError;
}

class GuardianApprovalPage {
  const GuardianApprovalPage({
    required this.items,
    required this.nextCursor,
    required this.pendingCount,
  });

  final List<GuardianApproval> items;
  final String? nextCursor;
  final int pendingCount;
}
