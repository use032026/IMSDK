import 'package:im_sdk/features/official_account/data/datasources/official_account_remote_data_source.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import 'package:im_sdk/features/official_account/domain/repositories/official_account_repository.dart';

class OfficialAccountRepositoryImpl implements OfficialAccountRepository {
  final OfficialAccountRemoteDataSource remote;

  const OfficialAccountRepositoryImpl(this.remote);

  @override
  Future<OfficialAccountMenuClickResult> clickMenuItem(String itemId) {
    return remote.clickMenuItem(itemId);
  }

  @override
  Future<OfficialAccountHandoff> contactService() {
    return remote.contactService();
  }

  @override
  Future<OfficialAccount> getOfficialAccount() {
    return remote.getOfficialAccount();
  }

  @override
  Future<OfficialAccountMenu> getMenu() {
    return remote.getMenu();
  }
}
