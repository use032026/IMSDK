import 'package:im_sdk/core/network/error_handler.dart';

enum TeenModeServerActionKind {
  blocked,
  guardianApprovalRequired,
  guardianRequired,
  dailyLimit,
  curfew,
  passcodeRequired,
  passcodeInvalid,
  passcodeLocked,
  modeDisabled,
  selfEnrollmentDisabled,
  guardianDisabled,
  modeNotActive,
}

enum TeenModeServerInteraction {
  notice,
  openRequests,
  openGuardianBinding,
  promptPasscode,
  showRestriction,
}

class TeenModeServerAction {
  const TeenModeServerAction({
    required this.kind,
    required this.code,
    required this.message,
    required this.requestId,
  });

  final TeenModeServerActionKind kind;
  final String code;
  final String message;
  final String? requestId;

  bool get awaitsServerReplay =>
      kind == TeenModeServerActionKind.guardianApprovalRequired;

  bool get refreshesSession =>
      kind == TeenModeServerActionKind.dailyLimit ||
      kind == TeenModeServerActionKind.curfew;

  bool get refreshesProfile => switch (kind) {
        TeenModeServerActionKind.guardianApprovalRequired ||
        TeenModeServerActionKind.guardianRequired ||
        TeenModeServerActionKind.modeDisabled ||
        TeenModeServerActionKind.selfEnrollmentDisabled ||
        TeenModeServerActionKind.guardianDisabled ||
        TeenModeServerActionKind.modeNotActive =>
          true,
        _ => false,
      };

  bool get refreshesRequests => awaitsServerReplay;

  TeenModeServerInteraction get interaction => switch (kind) {
        TeenModeServerActionKind.guardianApprovalRequired =>
          TeenModeServerInteraction.openRequests,
        TeenModeServerActionKind.guardianRequired =>
          TeenModeServerInteraction.openGuardianBinding,
        TeenModeServerActionKind.dailyLimit ||
        TeenModeServerActionKind.curfew =>
          TeenModeServerInteraction.showRestriction,
        TeenModeServerActionKind.passcodeRequired =>
          TeenModeServerInteraction.promptPasscode,
        _ => TeenModeServerInteraction.notice,
      };
}

class TeenModeServerActionClassifier {
  const TeenModeServerActionClassifier();

  TeenModeServerAction? classify(Object error) {
    if (error is! ServerError) return null;
    final kind = switch (error.code) {
      'TEEN_MODE_BLOCKED' => TeenModeServerActionKind.blocked,
      'TEEN_GUARDIAN_APPROVAL_REQUIRED' =>
        TeenModeServerActionKind.guardianApprovalRequired,
      'TEEN_GUARDIAN_REQUIRED' => TeenModeServerActionKind.guardianRequired,
      'TEEN_DAILY_LIMIT' => TeenModeServerActionKind.dailyLimit,
      'TEEN_CURFEW' => TeenModeServerActionKind.curfew,
      'TEEN_PASSCODE_REQUIRED' => TeenModeServerActionKind.passcodeRequired,
      'TEEN_PASSCODE_INVALID' => TeenModeServerActionKind.passcodeInvalid,
      'TEEN_PASSCODE_LOCKED' => TeenModeServerActionKind.passcodeLocked,
      'TEEN_MODE_DISABLED' => TeenModeServerActionKind.modeDisabled,
      'TEEN_SELF_ENROLL_DISABLED' =>
        TeenModeServerActionKind.selfEnrollmentDisabled,
      'TEEN_GUARDIAN_DISABLED' => TeenModeServerActionKind.guardianDisabled,
      'TEEN_MODE_NOT_ACTIVE' => TeenModeServerActionKind.modeNotActive,
      _ => null,
    };
    if (kind == null) return null;
    return TeenModeServerAction(
      kind: kind,
      code: error.code,
      message: error.message,
      requestId: error.requestId,
    );
  }
}

class TeenModeActionExecutor {
  const TeenModeActionExecutor({
    required Future<void> Function() refreshProfile,
    required Future<void> Function() refreshSession,
    required void Function() invalidateRequests,
    required void Function() invalidateGuardian,
  })  : _refreshProfile = refreshProfile,
        _refreshSession = refreshSession,
        _invalidateRequests = invalidateRequests,
        _invalidateGuardian = invalidateGuardian;

  final Future<void> Function() _refreshProfile;
  final Future<void> Function() _refreshSession;
  final void Function() _invalidateRequests;
  final void Function() _invalidateGuardian;
  static const _classifier = TeenModeServerActionClassifier();

  TeenModeServerAction? classify(Object error) => _classifier.classify(error);

  Future<TeenModeServerAction?> observe(Object error) async {
    final action = classify(error);
    if (action == null) return null;
    if (action.refreshesRequests) {
      _invalidateRequests();
      _invalidateGuardian();
    }
    if (action.refreshesSession) {
      await _ignoreRefreshFailure(_refreshSession);
    } else if (action.refreshesProfile) {
      await _ignoreRefreshFailure(_refreshProfile);
    }
    return action;
  }

  Future<void> _ignoreRefreshFailure(Future<void> Function() refresh) async {
    try {
      await refresh();
    } catch (_) {
      // The rejected action remains authoritative. A refresh failure must not
      // replace it or turn an approval result into a client retry.
    }
  }
}
