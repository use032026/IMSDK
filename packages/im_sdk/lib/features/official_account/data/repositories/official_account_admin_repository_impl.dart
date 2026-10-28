import 'package:im_sdk/features/official_account/data/datasources/official_account_admin_remote_data_source.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_admin.dart';
import 'package:im_sdk/features/official_account/domain/repositories/official_account_admin_repository.dart';

class OfficialAccountAdminRepositoryImpl
    implements OfficialAccountAdminRepository {
  final OfficialAccountAdminRemoteDataSource remote;

  const OfficialAccountAdminRepositoryImpl(this.remote);

  @override
  Future<OfficialAccountAdminOverview> updateProfile(
          OfficialAccountProfileChange change, OfficialAccountScope scope) =>
      remote.updateProfile(change, scope);

  @override
  Future<OfficialAccountAdminInviteQr?> getInviteQr(OfficialAccountScope scope,
          {bool reset = false}) =>
      remote.getInviteQr(scope, reset: reset);

  @override
  Future<OfficialAccountAdminOverview> getOverview(
    OfficialAccountScope scope,
  ) =>
      remote.getOverview(scope);

  @override
  Future<OfficialAccountAdminOverview> updateConfig(
    OfficialAccountAdminConfig config,
    OfficialAccountScope scope,
  ) {
    return remote.updateConfig(config, scope);
  }
}
