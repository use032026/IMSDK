import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import 'package:im_sdk/features/official_account/data/datasources/official_account_admin_remote_data_source.dart';
import 'package:im_sdk/features/official_account/data/repositories/official_account_admin_repository_impl.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_admin.dart';
import 'package:im_sdk/features/official_account/domain/repositories/official_account_admin_repository.dart';

final officialAccountAdminRepositoryProvider =
    Provider<OfficialAccountAdminRepository>((ref) {
  return OfficialAccountAdminRepositoryImpl(
    OfficialAccountAdminRemoteDataSource(ref.watch(adminDioProvider)),
  );
}, dependencies: [adminDioProvider]);

const officialAccountManagePermissionCode = 'service_account.manage';

class OfficialAccountManagePermissionDenied implements Exception {
  const OfficialAccountManagePermissionDenied();
}

class OfficialAccountAdminScopeChanged implements Exception {
  const OfficialAccountAdminScopeChanged();
}

final officialAccountManagePermissionProvider =
    FutureProvider.family<bool, OfficialAccountScope>((ref, scope) {
  return ref
      .watch(adminHttpClientProvider)
      .hasPermission(officialAccountManagePermissionCode);
}, dependencies: [adminHttpClientProvider]);

final officialAccountAdminProvider = AsyncNotifierProvider.family<
    OfficialAccountAdminController,
    OfficialAccountAdminOverview,
    OfficialAccountScope>(
  OfficialAccountAdminController.new,
  dependencies: [
    accountRuntimeCurrentSpaceProvider,
    officialAccountManagePermissionProvider,
    officialAccountAdminRepositoryProvider,
  ],
);

class OfficialAccountAdminController extends FamilyAsyncNotifier<
    OfficialAccountAdminOverview, OfficialAccountScope> {
  @override
  Future<OfficialAccountAdminOverview> build(OfficialAccountScope arg) async {
    _assertCurrentScope(arg);
    final allowed =
        await ref.watch(officialAccountManagePermissionProvider(arg).future);
    if (!allowed) throw const OfficialAccountManagePermissionDenied();
    _assertCurrentScope(arg);
    final overview =
        await ref.read(officialAccountAdminRepositoryProvider).getOverview(arg);
    _assertCurrentScope(arg);
    return overview;
  }

  Future<OfficialAccountAdminInviteQr?> getInviteQr(
      {bool reset = false}) async {
    _assertCurrentScope(arg);
    final allowed =
        await ref.read(officialAccountManagePermissionProvider(arg).future);
    if (!allowed) throw const OfficialAccountManagePermissionDenied();
    _assertCurrentScope(arg);
    final result = await ref
        .read(officialAccountAdminRepositoryProvider)
        .getInviteQr(arg, reset: reset);
    _assertCurrentScope(arg);
    return result;
  }

  Future<void> updateProfile(OfficialAccountProfileChange change) async {
    _assertCurrentScope(arg);
    if (change.validationError != null) {
      throw ArgumentError(change.validationError);
    }
    final allowed =
        await ref.read(officialAccountManagePermissionProvider(arg).future);
    if (!allowed) throw const OfficialAccountManagePermissionDenied();
    _assertCurrentScope(arg);
    final previous = state;
    state = const AsyncLoading<OfficialAccountAdminOverview>()
        .copyWithPrevious(state);
    try {
      final result = await ref
          .read(officialAccountAdminRepositoryProvider)
          .updateProfile(change, arg);
      _assertCurrentScope(arg);
      state = AsyncData(result);
    } catch (error, stack) {
      state = previous;
      Error.throwWithStackTrace(error, stack);
    }
  }

  Future<void> updateConfig(OfficialAccountAdminConfig config) async {
    _assertCurrentScope(arg);
    final allowed =
        await ref.read(officialAccountManagePermissionProvider(arg).future);
    if (!allowed) throw const OfficialAccountManagePermissionDenied();
    _assertCurrentScope(arg);
    final previous = state.valueOrNull;
    state = const AsyncLoading<OfficialAccountAdminOverview>()
        .copyWithPrevious(state);
    try {
      final updated = await ref
          .read(officialAccountAdminRepositoryProvider)
          .updateConfig(config, arg);
      _assertCurrentScope(arg);
      state = AsyncData(updated);
    } catch (error, stackTrace) {
      state = previous == null
          ? AsyncError(error, stackTrace)
          : AsyncData(previous);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _assertCurrentScope(OfficialAccountScope expected) {
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null ||
        SiteLineManager.instance.currentSite.id != expected.siteId ||
        space.spaceId != expected.spaceId ||
        space.userId != expected.userId) {
      throw const OfficialAccountAdminScopeChanged();
    }
  }
}
