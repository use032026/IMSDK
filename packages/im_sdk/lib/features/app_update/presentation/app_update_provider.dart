import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/network/http_client.dart';
import 'package:im_sdk/features/app_update/data/app_update_environment.dart';
import 'package:im_sdk/features/app_update/data/app_update_installer.dart';
import 'package:im_sdk/features/app_update/data/app_release_face_native_store.dart';
import 'package:im_sdk/features/app_update/data/app_update_remote_datasource.dart';
import 'package:im_sdk/features/app_update/data/app_update_repository_impl.dart';
import 'package:im_sdk/features/app_update/domain/app_release_face.dart';
import 'package:im_sdk/features/app_update/domain/app_release_update.dart';
import 'package:im_sdk/features/app_update/domain/app_update_repository.dart';
import 'package:im_sdk/features/app_update/domain/app_version_code.dart';
import 'package:im_sdk/core/branding/app_brand.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum AppUpdateFailure {
  checkFailed,
  invalidUrl,
  openUrlFailed,
  downloadInterrupted,
  packageVerificationFailed,
  installPermissionDenied,
  openInstallerFailed,
  generic,
}

class AppUpdateState {
  const AppUpdateState({
    this.release,
    this.error,
    this.isChecking = false,
    this.isStartingUpdate = false,
    this.dismissedVersionCode,
    this.hasCheckedOnStartup = false,
    this.releaseFace = AppReleaseFace.isB,
    this.hasResolvedReleaseFace = false,
  });

  final AppReleaseUpdate? release;
  final AppUpdateFailure? error;
  final bool isChecking;
  final bool isStartingUpdate;
  final int? dismissedVersionCode;
  final bool hasCheckedOnStartup;
  final AppReleaseFace releaseFace;
  final bool hasResolvedReleaseFace;

  AppUpdateStatus get status => release?.status ?? AppUpdateStatus.none;
  bool get blocksGroupFeatures => releaseFace == AppReleaseFace.isA;

  // Kept as a compatibility alias while callers migrate from the original,
  // creation-only release-face policy.
  bool get blocksGroupCreation => blocksGroupFeatures;

  bool get shouldBlockUse =>
      status == AppUpdateStatus.required && release?.canStartUpdate == true;

  bool get shouldPromptOptional {
    final versionCode = release?.latestVersionCode;
    return status == AppUpdateStatus.optional &&
        release?.canStartUpdate == true &&
        versionCode != null &&
        versionCode != dismissedVersionCode;
  }

  AppUpdateState copyWith({
    AppReleaseUpdate? release,
    AppUpdateFailure? error,
    bool? isChecking,
    bool? isStartingUpdate,
    int? dismissedVersionCode,
    bool? hasCheckedOnStartup,
    AppReleaseFace? releaseFace,
    bool? hasResolvedReleaseFace,
    bool clearRelease = false,
    bool clearError = false,
    bool clearDismissedVersionCode = false,
  }) {
    return AppUpdateState(
      release: clearRelease ? null : release ?? this.release,
      error: clearError ? null : error ?? this.error,
      isChecking: isChecking ?? this.isChecking,
      isStartingUpdate: isStartingUpdate ?? this.isStartingUpdate,
      dismissedVersionCode: clearDismissedVersionCode
          ? null
          : dismissedVersionCode ?? this.dismissedVersionCode,
      hasCheckedOnStartup: hasCheckedOnStartup ?? this.hasCheckedOnStartup,
      releaseFace: releaseFace ?? this.releaseFace,
      hasResolvedReleaseFace:
          hasResolvedReleaseFace ?? this.hasResolvedReleaseFace,
    );
  }
}

final appUpdatePlainDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: HttpClient.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );
});

final appUpdateDownloadDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: HttpClient.baseUrl,
      connectTimeout: const Duration(seconds: 15),
    ),
  );
});

final appUpdateRepositoryProvider = Provider<AppUpdateRepository>((ref) {
  return AppUpdateRepositoryImpl(
    AppUpdateRemoteDataSource(
      dio: ref.watch(appUpdatePlainDioProvider),
      baseUrl: () => HttpClient.baseUrl,
    ),
  );
});

final appUpdateInstallerProvider = Provider<AppUpdateInstaller>((ref) {
  return AppUpdateInstaller(
    dio: ref.watch(appUpdateDownloadDioProvider),
    baseUrl: () => HttpClient.baseUrl,
  );
});

final appReleaseFaceNativeStoreProvider = Provider<AppReleaseFaceNativeStore>(
  (ref) => AppReleaseFaceNativeStore(),
);

final appUpdateGroupCreationBlockedProvider = Provider<bool>((ref) {
  return ref.watch(
    appUpdateControllerProvider.select((state) => state.blocksGroupCreation),
  );
});

final appUpdateGroupFeaturesBlockedProvider = Provider<bool>((ref) {
  return ref.watch(
    appUpdateControllerProvider.select((state) => state.blocksGroupFeatures),
  );
});

AppUpdateFailure appUpdateFailureFor(Object error) {
  if (error is AppUpdateInstallException) {
    return switch (error.failure) {
      AppUpdateInstallFailure.invalidUrl => AppUpdateFailure.invalidUrl,
      AppUpdateInstallFailure.openUrlFailed => AppUpdateFailure.openUrlFailed,
      AppUpdateInstallFailure.downloadInterrupted =>
        AppUpdateFailure.downloadInterrupted,
      AppUpdateInstallFailure.packageSizeMismatch ||
      AppUpdateInstallFailure.packageHashMismatch =>
        AppUpdateFailure.packageVerificationFailed,
      AppUpdateInstallFailure.installPermissionDenied =>
        AppUpdateFailure.installPermissionDenied,
      AppUpdateInstallFailure.openInstallerFailed =>
        AppUpdateFailure.openInstallerFailed,
    };
  }
  return AppUpdateFailure.generic;
}

String appUpdateErrorMessage(
  AppLocalizations l10n,
  AppUpdateFailure failure,
) {
  return switch (failure) {
    AppUpdateFailure.checkFailed => l10n.appUpdateCheckFailed,
    AppUpdateFailure.invalidUrl => l10n.appUpdateInvalidUrl,
    AppUpdateFailure.openUrlFailed => l10n.appUpdateOpenUrlFailed,
    AppUpdateFailure.downloadInterrupted => l10n.appUpdateDownloadInterrupted,
    AppUpdateFailure.packageVerificationFailed =>
      l10n.appUpdatePackageVerificationFailed,
    AppUpdateFailure.installPermissionDenied =>
      l10n.appUpdatePermissionDenied(AppBrand.publicName),
    AppUpdateFailure.openInstallerFailed => l10n.appUpdateOpenInstallerFailed,
    AppUpdateFailure.generic => l10n.appUpdateGenericFailure,
  };
}

final appUpdateControllerProvider =
    StateNotifierProvider<AppUpdateController, AppUpdateState>((ref) {
  final nativeStore = ref.watch(appReleaseFaceNativeStoreProvider);
  return AppUpdateController(
    repository: ref.watch(appUpdateRepositoryProvider),
    installer: ref.watch(appUpdateInstallerProvider),
    packageInfo: PackageInfo.fromPlatform,
    platform: currentMobileUpdatePlatform,
    releaseFaceSink: (face) => nativeStore.sync(
      appliesToCurrentBuild: shouldApplyMobileReleaseFace(),
      face: face,
    ),
  );
});

class AppUpdateController extends StateNotifier<AppUpdateState> {
  AppUpdateController({
    required AppUpdateRepository repository,
    required AppUpdateInstaller installer,
    required Future<PackageInfo> Function() packageInfo,
    required String Function() platform,
    bool Function(String platform)? updatesEnabledForPlatform,
    bool Function()? shouldFetchReleaseFace,
    bool Function()? shouldApplyReleaseFace,
    Future<void> Function(AppReleaseFace face)? releaseFaceSink,
  })  : _repository = repository,
        _installer = installer,
        _packageInfo = packageInfo,
        _platform = platform,
        _updatesEnabledForPlatform = updatesEnabledForPlatform ??
            ((platform) => shouldEnableMobileAppUpdatesForPlatform(
                  platform: platform,
                )),
        _shouldFetchReleaseFace =
            shouldFetchReleaseFace ?? shouldFetchMobileReleaseFace,
        _shouldApplyReleaseFace =
            shouldApplyReleaseFace ?? shouldApplyMobileReleaseFace,
        _releaseFaceSink = releaseFaceSink,
        super(
          AppUpdateState(
            releaseFace:
                (shouldApplyReleaseFace ?? shouldApplyMobileReleaseFace)()
                    ? AppReleaseFace.isA
                    : AppReleaseFace.isB,
          ),
        );

  final AppUpdateRepository _repository;
  final AppUpdateInstaller _installer;
  final Future<PackageInfo> Function() _packageInfo;
  final String Function() _platform;
  final bool Function(String platform) _updatesEnabledForPlatform;
  final bool Function() _shouldFetchReleaseFace;
  final bool Function() _shouldApplyReleaseFace;
  final Future<void> Function(AppReleaseFace face)? _releaseFaceSink;
  Future<PackageInfo>? _packageInfoFuture;
  Future<void>? _releaseFaceResolutionFuture;

  bool get updatesEnabled => _updatesEnabledForPlatform(_platform());

  /// Resolves and persists the release face before notification navigation.
  ///
  /// The initial in-memory A face remains fail-closed for the audit UI, but it
  /// must not be persisted to Android as if it were a server-confirmed result:
  /// doing so would temporarily suppress group pushes for a real B release on
  /// every process start.
  Future<void> ensureReleaseFaceResolved() {
    if (state.hasResolvedReleaseFace) return Future<void>.value();
    return _releaseFaceResolutionFuture ??= _resolveAndSyncReleaseFace();
  }

  Future<void> _resolveAndSyncReleaseFace() async {
    var releaseFace =
        _shouldApplyReleaseFace() ? AppReleaseFace.isA : AppReleaseFace.isB;
    try {
      if (_shouldFetchReleaseFace()) {
        final info = await _loadPackageInfo();
        releaseFace = await _resolveReleaseFace(info.version);
      }
    } catch (error, stackTrace) {
      debugPrint(
        '[AppUpdate] release-face bootstrap failed: $error\n$stackTrace',
      );
    }
    state = state.copyWith(
      releaseFace: releaseFace,
      hasResolvedReleaseFace: true,
    );
    await _syncReleaseFace(releaseFace);
  }

  Future<PackageInfo> _loadPackageInfo() {
    return _packageInfoFuture ??= _packageInfo();
  }

  Future<AppReleaseUpdate?> checkForUpdates({
    bool silent = false,
    bool startup = false,
    bool manual = false,
  }) async {
    if (state.isChecking) return state.release;
    state = state.copyWith(
      clearError: true,
      isChecking: true,
      hasCheckedOnStartup: startup ? true : state.hasCheckedOnStartup,
    );
    try {
      await ensureReleaseFaceResolved();
      final platform = _platform();
      if (!_updatesEnabledForPlatform(platform)) {
        state = state.copyWith(
          clearError: true,
          clearRelease: true,
          isChecking: false,
          hasCheckedOnStartup: startup ? true : state.hasCheckedOnStartup,
        );
        return null;
      }
      final info = await _loadPackageInfo();
      final update = await _repository.checkLatest(
        appKey: mobileAppUpdateAppKey,
        platform: platform,
        versionCode: parseAppVersionCode(info.buildNumber),
      );
      state = state.copyWith(
        clearError: true,
        clearRelease: update.status == AppUpdateStatus.none,
        clearDismissedVersionCode:
            manual && update.status != AppUpdateStatus.none,
        release: update.status == AppUpdateStatus.none ? null : update,
        isChecking: false,
        hasCheckedOnStartup: startup ? true : state.hasCheckedOnStartup,
      );
      return update;
    } catch (error) {
      state = state.copyWith(
        error: AppUpdateFailure.checkFailed,
        isChecking: false,
        hasCheckedOnStartup: startup ? true : state.hasCheckedOnStartup,
      );
      if (silent) return null;
      rethrow;
    }
  }

  void dismissOptional() {
    final versionCode = state.release?.latestVersionCode;
    if (versionCode == null) return;
    state = state.copyWith(dismissedVersionCode: versionCode);
  }

  Future<void> startUpdate() async {
    if (!updatesEnabled) return;
    final release = state.release;
    if (release == null || !release.canStartUpdate) return;
    state = state.copyWith(clearError: true, isStartingUpdate: true);
    try {
      await _installer.start(release);
      state = state.copyWith(clearError: true, isStartingUpdate: false);
    } catch (error, stackTrace) {
      debugPrint('[AppUpdate] install failed: $error\n$stackTrace');
      state = state.copyWith(
        error: appUpdateFailureFor(error),
        isStartingUpdate: false,
      );
    }
  }

  Future<AppReleaseFace> _resolveReleaseFace(String version) async {
    if (!_shouldFetchReleaseFace()) return AppReleaseFace.isB;
    try {
      final releaseFace = await _repository.checkReleaseFace(
        channel: mobileAppReleaseChannel,
        version: version.trim(),
      );
      // iOS is fetched for backend verification only and does not change UI.
      return _shouldApplyReleaseFace() ? releaseFace : AppReleaseFace.isB;
    } catch (error, stackTrace) {
      debugPrint('[AppUpdate] release-face check failed: $error\\n$stackTrace');
      // Android audit-channel failures preserve the audit face; other channels
      // keep their existing behavior.
      return _shouldApplyReleaseFace()
          ? AppReleaseFace.isA
          : AppReleaseFace.isB;
    }
  }

  Future<void> _syncReleaseFace(AppReleaseFace face) async {
    await _releaseFaceSink?.call(face);
  }
}
