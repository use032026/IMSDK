import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_admin.dart';

abstract interface class OfficialAccountAdminRepository {
  Future<OfficialAccountAdminOverview> updateProfile(
      OfficialAccountProfileChange change, OfficialAccountScope scope);
  Future<OfficialAccountAdminInviteQr?> getInviteQr(OfficialAccountScope scope,
      {bool reset = false});
  Future<OfficialAccountAdminOverview> getOverview(
    OfficialAccountScope scope,
  );

  Future<OfficialAccountAdminOverview> updateConfig(
    OfficialAccountAdminConfig config,
    OfficialAccountScope scope,
  );
}
