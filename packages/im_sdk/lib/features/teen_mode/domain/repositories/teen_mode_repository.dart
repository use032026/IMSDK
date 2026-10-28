import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';

abstract interface class TeenModeRepository {
  Future<TeenModeConfig> getConfig();
  Future<TeenModeProfile> getMe();
  Future<TeenModeProfile> enable({
    required String passcode,
    required String timeZoneId,
  });
  Future<TeenModeDisableResult> disable(String passcode);
  Future<void> updatePasscode({
    String? currentPasscode,
    required String newPasscode,
  });
  Future<TeenModeSession> heartbeat(String timeZoneId);
  Future<TeenModeSession> getSessionStatus();
  Future<TeenModeExtendRequestResult> requestExtension(int minutes);
  Future<GuardianApprovalPage> getMyRequests({
    String status = 'all',
    String? cursor,
    int limit = 100,
  });
  Future<void> cancelMyRequest(String requestId);

  Future<GuardianBindCode> createBindCode({
    required GuardianRole role,
    required String relation,
  });
  Future<void> cancelBindCode(String tokenId);
  Future<GuardianLink> bind({
    required String code,
    required String relation,
  });
  Future<List<GuardianLink>> getLinks();
  Future<GuardianLink> updateLink({
    required String linkId,
    String? relation,
    bool? isPrimary,
    bool? canApprove,
    bool? canManagePolicy,
  });
  Future<GuardianUnbindResult> deleteLink(String linkId);
  Future<List<GuardianMinor>> getMinors();
  Future<GuardianMinor> getMinor(String minorPlatformUserId);
  Future<GuardianMinor> updateMinorPolicy({
    required String minorPlatformUserId,
    required TeenPolicy policy,
  });
  Future<GuardianMinor> extendMinor({
    required String minorPlatformUserId,
    required int minutes,
  });
  Future<GuardianApprovalPage> getApprovals({
    String status = 'all',
    String? cursor,
    int limit = 100,
  });
  Future<GuardianApproval> decideApproval({
    required String requestId,
    required bool approve,
    String? note,
  });
}
