import 'package:im_sdk/features/teen_mode/data/datasources/teen_mode_remote_data_source.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/domain/repositories/teen_mode_repository.dart';

class TeenModeRepositoryImpl implements TeenModeRepository {
  const TeenModeRepositoryImpl(this.remote);

  final TeenModeRemoteDataSource remote;

  @override
  Future<void> cancelBindCode(String tokenId) => remote.cancelBindCode(tokenId);
  @override
  Future<void> cancelMyRequest(String requestId) =>
      remote.cancelMyRequest(requestId);
  @override
  Future<GuardianLink> bind({required String code, required String relation}) =>
      remote.bind(code: code, relation: relation);
  @override
  Future<GuardianBindCode> createBindCode({
    required GuardianRole role,
    required String relation,
  }) =>
      remote.createBindCode(role: role, relation: relation);
  @override
  Future<GuardianApproval> decideApproval({
    required String requestId,
    required bool approve,
    String? note,
  }) =>
      remote.decideApproval(
        requestId: requestId,
        approve: approve,
        note: note,
      );
  @override
  Future<GuardianUnbindResult> deleteLink(String linkId) =>
      remote.deleteLink(linkId);
  @override
  Future<TeenModeDisableResult> disable(String passcode) =>
      remote.disable(passcode);
  @override
  Future<TeenModeProfile> enable({
    required String passcode,
    required String timeZoneId,
  }) =>
      remote.enable(passcode: passcode, timeZoneId: timeZoneId);
  @override
  Future<GuardianMinor> extendMinor({
    required String minorPlatformUserId,
    required int minutes,
  }) =>
      remote.extendMinor(
        minorPlatformUserId: minorPlatformUserId,
        minutes: minutes,
      );
  @override
  Future<GuardianApprovalPage> getApprovals({
    String status = 'all',
    String? cursor,
    int limit = 100,
  }) =>
      remote.getApprovals(status: status, cursor: cursor, limit: limit);
  @override
  Future<TeenModeConfig> getConfig() => remote.getConfig();
  @override
  Future<List<GuardianLink>> getLinks() => remote.getLinks();
  @override
  Future<TeenModeProfile> getMe() => remote.getMe();
  @override
  Future<GuardianMinor> getMinor(String minorPlatformUserId) =>
      remote.getMinor(minorPlatformUserId);
  @override
  Future<List<GuardianMinor>> getMinors() => remote.getMinors();
  @override
  Future<GuardianApprovalPage> getMyRequests({
    String status = 'all',
    String? cursor,
    int limit = 100,
  }) =>
      remote.getMyRequests(status: status, cursor: cursor, limit: limit);
  @override
  Future<TeenModeSession> getSessionStatus() => remote.getSessionStatus();
  @override
  Future<TeenModeSession> heartbeat(String timeZoneId) =>
      remote.heartbeat(timeZoneId);
  @override
  Future<TeenModeExtendRequestResult> requestExtension(int minutes) =>
      remote.requestExtension(minutes);
  @override
  Future<GuardianLink> updateLink({
    required String linkId,
    String? relation,
    bool? isPrimary,
    bool? canApprove,
    bool? canManagePolicy,
  }) =>
      remote.updateLink(
        linkId: linkId,
        relation: relation,
        isPrimary: isPrimary,
        canApprove: canApprove,
        canManagePolicy: canManagePolicy,
      );
  @override
  Future<GuardianMinor> updateMinorPolicy({
    required String minorPlatformUserId,
    required TeenPolicy policy,
  }) =>
      remote.updateMinorPolicy(
        minorPlatformUserId: minorPlatformUserId,
        policy: policy,
      );
  @override
  Future<void> updatePasscode({
    String? currentPasscode,
    required String newPasscode,
  }) =>
      remote.updatePasscode(
        currentPasscode: currentPasscode,
        newPasscode: newPasscode,
      );
}
