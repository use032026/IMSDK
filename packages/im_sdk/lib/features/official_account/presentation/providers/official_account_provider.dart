import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/official_account/data/datasources/official_account_remote_data_source.dart';
import 'package:im_sdk/features/official_account/data/repositories/official_account_repository_impl.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import 'package:im_sdk/features/official_account/domain/repositories/official_account_repository.dart';

final officialAccountRepositoryProvider =
    Provider<OfficialAccountRepository>((ref) {
  return OfficialAccountRepositoryImpl(
    OfficialAccountRemoteDataSource(ref.watch(dioProvider)),
  );
}, dependencies: [dioProvider]);

final officialAccountProvider = AsyncNotifierProvider.family<
    OfficialAccountController, OfficialAccount, OfficialAccountScope>(
  OfficialAccountController.new,
  dependencies: [officialAccountRepositoryProvider],
);

class OfficialAccountController
    extends FamilyAsyncNotifier<OfficialAccount, OfficialAccountScope> {
  @override
  Future<OfficialAccount> build(OfficialAccountScope arg) {
    return ref.watch(officialAccountRepositoryProvider).getOfficialAccount();
  }

  Future<void> refreshMenuIfChanged() async {
    final current = state.valueOrNull;
    if (current == null) return;
    try {
      final menu = await ref.read(officialAccountRepositoryProvider).getMenu();
      if (menu.version != current.menu.version) {
        state = AsyncData(current.copyWith(menu: menu));
      } else if (menu.enabled != current.menu.enabled) {
        state = AsyncData(
          current.copyWith(
            menu: OfficialAccountMenu(
              enabled: menu.enabled,
              version: current.menu.version,
              items: current.menu.items,
            ),
          ),
        );
      }
    } catch (error, stackTrace) {
      if (error is ServerError &&
          error.code == 'OFFICIAL_ACCOUNT_MENU_DISABLED') {
        state = AsyncData(
          current.copyWith(
            menu: OfficialAccountMenu(
              enabled: false,
              version: current.menu.version,
              items: current.menu.items,
            ),
          ),
        );
        return;
      }
      state = AsyncError<OfficialAccount>(error, stackTrace)
          .copyWithPrevious(AsyncData(current));
    }
  }
}
