import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';

abstract interface class OfficialAccountRepository {
  Future<OfficialAccount> getOfficialAccount();

  Future<OfficialAccountMenu> getMenu();

  Future<OfficialAccountMenuClickResult> clickMenuItem(String itemId);

  Future<OfficialAccountHandoff> contactService();
}
