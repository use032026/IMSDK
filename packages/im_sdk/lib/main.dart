import 'package:im_sdk/core/diagnostics/diagnostic_runtime.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'app/privacy_consent_bootstrap.dart';
import 'app/system_ui.dart';
import 'core/diagnostics/app_diagnostics.dart';
import 'core/diagnostics/app_error_reporter.dart';
import 'core/network/site_line_manager.dart';
import 'core/notifications/push_notification_service.dart';
import 'core/privacy/privacy_consent_service.dart';
import 'core/providers/locale_provider.dart';
import 'core/storage/hive_storage.dart';
import 'core/storage/secure_storage.dart';
import 'features/startup/presentation/widgets/startup_brand_loading_view.dart';

void main() {
  var authorizedRuntimeStarted = false;
  runZonedGuarded(() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.deferFirstFrame();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (authorizedRuntimeStarted) {
        AppErrorReporter.instance.reportFlutterError(details);
      }
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      if (authorizedRuntimeStarted) {
        AppErrorReporter.instance.reportUnhandled(
          error,
          stack,
          source: 'platform',
        );
      }
      return true;
    };

    if (Platform.isAndroid) {
      // MainActivity has already hidden the system bars before Flutter starts.
      // Do not block runApp on an OEM platform-channel response: if that
      // response is lost during a cold launch, Flutter never draws a window
      // and Android eventually reports an input/no-focused-window ANR.
      unawaited(configureStartupSystemUi());
    } else {
      await configureStartupSystemUi();
    }
    final initialLocale = supportedLocaleOrFallback(
      binding.platformDispatcher.locale,
    );
    const consentStore = PlatformPrivacyConsentStore();
    runApp(
      ProviderScope(
        child: PrivacyConsentBootstrap(
          locale: initialLocale,
          allowDeclinedRuntime: !Platform.isAndroid,
          exitAfterDecline: Platform.isAndroid
              ? consentStore.finishAndRemoveAndroidTask
              : null,
          startupLoadingBuilder: (_) => const StartupBrandLoadingView(),
          consentStore: consentStore,
          startAuthorizedRuntime: () async {
            authorizedRuntimeStarted = true;
            PushNotificationService.registerBackgroundHandler();
            await HiveStorage.init();
            final siteLineManager = SiteLineManager.instance;
            final secureStorage = SecureStorageServiceImpl();
            unawaited(DiagnosticRuntime.instance.initialize().then((_) {
              AppDiagnostics.instance.info('startup.diagnostics', 'Diagnostics ready', scope: DiagnosticScope.public);
            }).catchError((Object _) {}));
            try {
              await siteLineManager
                  .restoreCachedRoute(secureStorage)
                  .timeout(const Duration(seconds: 2));
            } catch (error) {
              AppDiagnostics.instance.warning(
                'startup.site_line_cache_restore_failed',
                'Local site line restore did not finish; using primary route',
                context: {'errorType': error.runtimeType.toString()},
              );
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              unawaited(siteLineManager.bootstrap(secureStorage).then<void>(
                (_) {},
                onError: (Object error, StackTrace stack) {
                  AppDiagnostics.instance.warning(
                    'startup.site_line_refresh_failed',
                    'Background site line refresh failed',
                    context: {'errorType': error.runtimeType.toString()},
                  );
                },
              ));
            });
          },
          authorizedAppBuilder: (_) => const App(),
        ),
      ),
    );
  }, (error, stack) {
    if (authorizedRuntimeStarted) {
      AppErrorReporter.instance.reportUnhandled(
        error,
        stack,
        source: 'zone',
      );
    } else {
      debugPrint('[PrivacyBootstrap] pre-consent error: $error');
    }
  });
}
