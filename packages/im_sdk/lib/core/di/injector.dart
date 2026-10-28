/// 依赖注入统一入口
///
/// 集中注册全局 Riverpod Provider，并 re-export 各模块 Provider，
/// 使业务层只需 import 此文件即可获取所有核心依赖。
library injector;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/admin/admin_http_client.dart';
import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/network/http_client.dart';
import 'package:im_sdk/core/notifications/account_push_registration_service.dart';
import 'package:im_sdk/core/notifications/android_push_session.dart';
import 'package:im_sdk/core/platform/platform_capabilities.dart';
import 'package:im_sdk/core/notifications/app_icon_badge_service.dart';
import 'package:im_sdk/core/notifications/mobile_push_token_provider.dart';
import 'package:im_sdk/core/notifications/push_device_registration_service.dart';
import 'package:im_sdk/core/notifications/push_notification_service.dart';
import 'package:im_sdk/core/providers/locale_provider.dart';
import 'package:im_sdk/core/privacy/privacy_consent_service.dart';
import 'package:im_sdk/core/space/space_manager.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_logout_reason.dart';

// Re-export space providers so callers only need to import injector.dart
export 'package:im_sdk/core/space/space_manager.dart'
    show secureStorageProvider, currentSpaceProvider;

// Re-export feature providers
export 'package:im_sdk/features/profile/presentation/providers/profile_providers.dart'
    show profileProvider, currentUserProfileProvider, profileRepositoryProvider;
export 'package:im_sdk/features/settings/presentation/providers/settings_providers.dart'
    show notificationSettingsProvider, settingsRepositoryProvider;

/// HttpClient Provider
final httpClientProvider = Provider<HttpClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return HttpClient(
    storage: storage,
    tokenGetter: () => ref.read(currentSpaceProvider)?.accessToken,
    activeSpaceIdGetter: () => ref.read(currentSpaceProvider)?.spaceId,
    refreshTokenGetter: () => ref.read(currentSpaceProvider)?.refreshToken,
    platformTokenGetter: () =>
        ref.read(authProvider).valueOrNull?.platformToken,
    platformRefreshTokenGetter: () =>
        ref.read(authProvider.notifier).currentPlatformRefreshToken,
    deviceSessionTokenGetter: () =>
        ref.read(authProvider.notifier).currentDeviceSessionToken,
    allowLegacyCredentialFallback: false,
    persistLegacyCredentialMirror: false,
    onAuthFailed: (error) async {
      // AuthNotifier owns the compare-and-clear sequence for the active v2
      // Session. Clearing legacy space keys here would create a second owner.
      await ref.read(authProvider.notifier).logout(
            reason: AuthLogoutReason.httpAuthenticationFailed,
            serverCode: error.code,
          );
    },
    // platformToken 刷新成功后同步更新 authProvider state
    onPlatformTokenRefreshed: (newToken, newRefreshToken) {
      final authNotifier = ref.read(authProvider.notifier);
      return authNotifier.updatePlatformToken(
        newToken,
        newPlatformRefreshToken: newRefreshToken,
      );
    },
    // 租户 token 刷新成功后同步更新 authProvider state
    onTenantTokenRefreshed: (spaceId, newAccessToken, newRefreshToken) {
      final authNotifier = ref.read(authProvider.notifier);
      return authNotifier.updateTenantToken(
        spaceId,
        newAccessToken,
        newRefreshToken: newRefreshToken,
      );
    },
  );
});

/// Dio Provider（从 HttpClient 中取出）
final dioProvider = Provider<Dio>((ref) {
  return ref.watch(httpClientProvider).dio;
});

/// 管理后台 Dio。
///
/// 只用于管理员/所有者工作台调用 `/api/admin/v1/*`，会通过 platformToken
/// 调用 `/api/platform/v1/auth/admin-token` 换取管理端 accessToken，并和
/// 普通 client accessToken 隔离。管理数据接口部署在 admin 域名，不能复用
/// 普通业务接口的 chat 域名。
final adminHttpClientProvider = Provider<AdminHttpClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AdminHttpClient(
    storage: storage,
    spaceGetter: () => ref.read(currentSpaceProvider),
    platformTokenGetter: () =>
        ref.read(authProvider).valueOrNull?.platformToken,
    credentialOwnerGetter: () =>
        ref.read(activeAccountSessionProvider)?.scope.storageKeyHash,
  );
});

final adminDioProvider = Provider<Dio>((ref) {
  return ref.watch(adminHttpClientProvider).dio;
});

/// App launcher icon badge runtime.
///
/// Only mirrors existing unread counts to the OS launcher. It does not own or
/// compute unread state.
final appIconBadgeServiceProvider = Provider<AppIconBadgeService>((ref) {
  return AppIconBadgeService(adapter: AppBadgePlusAdapter());
});

/// Push device registration API wrapper.
///
/// Native FCM/JPush token acquisition is platform-specific; once a token is
/// available, call this provider to register it with the server.
final pushDeviceRegistrationServiceProvider =
    Provider<PushDeviceRegistrationService>((ref) {
  return PushDeviceRegistrationService(ref.watch(dioProvider));
});

/// Mobile vendor push token provider.
///
/// Disabled by default. Enable with dart defines only after vendor SDK keys and
/// server-side token registration are ready.
final mobilePushTokenProvider = Provider<MobilePushTokenProvider>((ref) {
  return MethodChannelMobilePushTokenProvider.fromEnvironment();
});

final mobilePushNotificationOpenProvider =
    Provider<MobilePushNotificationOpenProvider>((ref) {
  return const MethodChannelMobilePushNotificationOpenProvider();
});

/// Local notification and mobile notification-open coordinator.
final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  final privacyDecision = ref.watch(privacyConsentControllerProvider);
  final service = PushNotificationService(
    mobilePushNotificationOpenProvider:
        ref.watch(mobilePushNotificationOpenProvider),
    activeAccountScopeKeyGetter: () => ref.read(accountScopeProvider)?.scopeKey,
    localeGetter: () => ref.read(localeProvider),
    pushRuntimeAllowed: privacyDecision.allowsPushRuntime,
    presentationAllowed: () =>
        ref.read(androidPushSessionProvider).allowsPresentation,
    notificationRouteReadiness: () => ref
        .read(appUpdateControllerProvider.notifier)
        .ensureReleaseFaceResolved(),
  );
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
}, dependencies: [
  privacyConsentControllerProvider,
  appUpdateControllerProvider,
]);

/// Root-owned device binding for every authenticated space under the current
/// platform account. Keeping this service above account runtimes preserves one
/// token observer and one logout cleanup ledger across space switches.
final accountPushRegistrationServiceProvider =
    Provider<AccountPushRegistrationService>((ref) {
  final service = AccountPushRegistrationService(
    registrationService: ref.watch(pushDeviceRegistrationServiceProvider),
    storage: ref.watch(secureStorageProvider),
    mobilePushTokenProvider: ref.watch(mobilePushTokenProvider),
    androidPushSession: PlatformCapabilities.isAndroid &&
            PlatformCapabilities.supportsMobilePush
        ? ref.read(androidPushSessionProvider)
        : null,
    operationIsCurrent: (expectedPlatformAccount) {
      final scope = ref.read(accountScopeProvider);
      return scope != null &&
          PlatformAccountScope.fromAccountScope(scope) ==
              expectedPlatformAccount;
    },
    accountsLoader: (expectedPlatformAccount) async {
      final authState = ref.read(authProvider).valueOrNull;
      final scope = authState == null
          ? null
          : activeAccountSessionFromAuthState(authState)?.scope;
      if (scope == null ||
          PlatformAccountScope.fromAccountScope(scope) !=
              expectedPlatformAccount) {
        return const [];
      }
      final authorizedSpaceIds = <String>{
        'personal',
        ...authState!.availableTenants.map((tenant) => tenant.tenantId.trim()),
      }..remove('');
      final storedSpaces = await ref
          .read(accountSessionStoreProvider)
          .loadPlatformSpaces(platformAccount: expectedPlatformAccount);
      final latestScope = ref.read(accountScopeProvider);
      if (latestScope == null ||
          PlatformAccountScope.fromAccountScope(latestScope) !=
              expectedPlatformAccount) {
        return const [];
      }
      return storedSpaces
          .where(
            (stored) => authorizedSpaceIds.contains(stored.scope.spaceId),
          )
          .map(
            (stored) => PushRegistrationAccount(
              spaceId: stored.scope.spaceId,
              accessToken: stored.accessToken,
            ),
          )
          .toList(growable: false);
    },
  );
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
});
