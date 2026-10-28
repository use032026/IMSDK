import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/diagnostics/diagnostic_runtime.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_sdk/features/teen_mode/presentation/widgets/teen_mode_gate.dart';
import 'package:im_sdk/app/system_ui.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/app/router/router.dart';
import 'package:im_sdk/app/authenticated_runtime_host.dart';
import 'package:im_sdk/app/authenticated_runtime_services.dart';
import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/diagnostics/app_error_reporter.dart';
import 'package:im_sdk/core/branding/app_brand.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/providers/font_size_provider.dart';
import 'package:im_sdk/core/privacy/privacy_consent_service.dart';
import 'package:im_sdk/core/platform/platform_capabilities.dart';
import 'package:im_sdk/core/runtime/account_runtime.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/providers/locale_provider.dart';
import 'package:im_sdk/core/providers/theme_provider.dart';
import 'package:im_sdk/app/account_runtime_provider.dart';
import 'package:im_sdk/core/space/space_transition.dart';
import 'package:im_sdk/core/widgets/network_status_banner.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_gate.dart';
import 'package:im_sdk/features/call/presentation/widgets/incoming_call_overlay.dart';
import 'package:im_sdk/features/space/presentation/providers/spaces_provider.dart';
import 'package:im_sdk/features/startup/presentation/pages/startup_gate_page.dart';
import 'package:im_sdk/features/startup/presentation/widgets/startup_brand_loading_view.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  late final AppRouter _appRouter;
  ProviderSubscription<AsyncValue<AuthState>>? _authSubscription;
  ProviderSubscription<Locale>? _localeSubscription;
  ProviderSubscription<PrivacyConsentDecision>? _privacySubscription;
  ProviderSubscription<AsyncValue<AccountRuntime?>>? _runtimeSubscription;
  ProviderSubscription<SpaceTransitionState>? _transitionSubscription;
  int? _rollingBackSpaceTransitionRevision;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(ref);
    AppErrorReporter.instance.start(dio: ref.read(dioProvider));
    WidgetsBinding.instance.addObserver(this);
    _authSubscription = ref.listenManual(authProvider, (previous, next) {
      final previousState = previous?.valueOrNull;
      final nextState = next.valueOrNull;
      final diagnosticSession = nextState == null ? null : activeAccountSessionFromAuthState(nextState);
      AppDiagnostics.instance.activeScope = diagnosticSession == null
          ? DiagnosticScope.public : DiagnosticScope.account(diagnosticSession.scope);
      final wasAuthenticated =
          previousState?.status == AuthStatus.authenticated;
      final isAuthenticated = nextState?.status == AuthStatus.authenticated;
      if (!isAuthenticated) {
        if (wasAuthenticated) {
          final previousSession =
              activeAccountSessionFromAuthState(previousState!);
          final previousScope = previousSession?.scope;
          if (previousScope != null) {
            unawaited(
              ref
                  .read(accountPushRegistrationServiceProvider)
                  .unregisterPlatformAccount(
                    platformAccount:
                        PlatformAccountScope.fromAccountScope(previousScope),
                    currentSpaceId: previousState.currentSpace?.spaceId,
                    currentAccessToken: previousState.currentSpace?.accessToken,
                  )
                  .catchError(_reportPushLifecycleFailure),
            );
          }
        } else if (nextState?.status == AuthStatus.unauthenticated ||
            next.hasError) {
          unawaited(ref
              .read(accountPushRegistrationServiceProvider)
              .suspendNotifications()
              .catchError(_reportPushLifecycleFailure));
        }
        unawaited(ref.read(appIconBadgeServiceProvider).clear());
        return;
      }
      _startPushRuntimeIfAllowed();
    }, fireImmediately: true);
    _privacySubscription = ref.listenManual<PrivacyConsentDecision>(
      privacyConsentControllerProvider,
      (_, next) {
        if (next.allowsPushRuntime) _startPushRuntimeIfAllowed();
      },
      fireImmediately: true,
    );
    _localeSubscription = ref.listenManual<Locale>(localeProvider, (_, __) {
      final authenticated = ref.read(authProvider).valueOrNull?.status ==
          AuthStatus.authenticated;
      final pushAllowed =
          ref.read(privacyConsentControllerProvider).allowsPushRuntime;
      if (authenticated && pushAllowed) {
        unawaited(
          ref.read(pushNotificationServiceProvider).refreshLocalizedChannels(),
        );
      }
    });
    _runtimeSubscription = ref.listenManual<AsyncValue<AccountRuntime?>>(
      accountRuntimeProvider,
      (_, next) => _handleRuntimeTransition(next),
      fireImmediately: true,
    );
    _transitionSubscription = ref.listenManual<SpaceTransitionState>(
      spaceTransitionProvider,
      (_, next) {
        if (next.phase != SpaceTransitionPhase.preparing) return;
        final location =
            _appRouter.router.routeInformationProvider.value.uri.path;
        const shellLocations = <String>{
          AppRoutes.home,
          AppRoutes.contacts,
          '/me',
          AppRoutes.customerService,
          AppRoutes.ownerWorkbench,
        };
        if (!shellLocations.contains(location)) {
          _appRouter.router.go(AppRoutes.home);
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription?.close();
    _localeSubscription?.close();
    _privacySubscription?.close();
    _runtimeSubscription?.close();
    _transitionSubscription?.close();
    unawaited(DiagnosticRuntime.instance.flush());
    _appRouter.dispose();
    AppErrorReporter.instance.stop();
    super.dispose();
  }

  void _handleRuntimeTransition(AsyncValue<AccountRuntime?> runtimeState) {
    final transition = ref.read(spaceTransitionProvider);
    if (!transition.isInProgress) return;
    final runtime = runtimeState.valueOrNull;
    final targetInstalled = runtime != null &&
        runtime.lifecycle == AccountRuntimeLifecycle.active &&
        runtime.session.scope.spaceId == transition.targetSpaceId &&
        ref.read(authProvider).valueOrNull?.currentSpace?.spaceId ==
            transition.targetSpaceId;
    if (targetInstalled) {
      ref
          .read(authProvider.notifier)
          .completeSpaceTransition(transition.revision);
      // One frame installs the target ProviderContainer and disposes the
      // source container. Retire its storage on the following frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(
            ref
                .read(accountRuntimeProvider.notifier)
                .retireCommittedSource(runtime),
          );
        });
      });
      return;
    }
    if (!runtimeState.hasError ||
        _rollingBackSpaceTransitionRevision == transition.revision) {
      return;
    }
    _rollingBackSpaceTransitionRevision = transition.revision;
    unawaited(
      ref
          .read(authProvider.notifier)
          .rollbackSpaceTransition(runtimeState.error!)
          .whenComplete(() {
        if (_rollingBackSpaceTransitionRevision == transition.revision) {
          _rollingBackSpaceTransitionRevision = null;
        }
      }),
    );
  }

  void _startPushRuntimeIfAllowed() {
    final authenticated =
        ref.read(authProvider).valueOrNull?.status == AuthStatus.authenticated;
    final consent = ref.read(privacyConsentControllerProvider);
    if (!authenticated || !consent.allowsPushRuntime) return;
    final pushService = ref.read(pushNotificationServiceProvider);
    pushService.setSpaceActivator(_activatePushTargetSpace);
    unawaited(pushService.initialize(router: _appRouter.router));
    final accountScope = ref.read(accountScopeProvider);
    if (accountScope != null) {
      unawaited(
        ref.read(accountPushRegistrationServiceProvider).start(
              platformAccount:
                  PlatformAccountScope.fromAccountScope(accountScope),
            ),
      );
    }
  }

  void _reportPushLifecycleFailure(Object error) {
    debugPrint(
        '[PushRegistration] lifecycle operation failed: ${error.runtimeType}');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      unawaited(DiagnosticRuntime.instance.flush());
    }
    if (state == AppLifecycleState.resumed) {
      // 当前 Session 仍有效时刷新平台凭证。账号 token 由 AuthState 与同一
      // AccountRuntime 持有，禁止从 space-only legacy key 猜测恢复身份。
      _refreshPlatformTokenIfNeeded();
      if (PlatformCapabilities.isAndroid) {
        final auth = ref.read(authProvider).valueOrNull;
        if (auth?.status == AuthStatus.authenticated) {
          _startPushRuntimeIfAllowed();
        } else if (auth?.status == AuthStatus.unauthenticated) {
          unawaited(ref
              .read(accountPushRegistrationServiceProvider)
              .suspendNotifications()
              .catchError(_reportPushLifecycleFailure));
        }
      }
    }
  }

  Future<void> _refreshPlatformTokenIfNeeded() async {
    // 异步刷新，不阻塞 UI
    try {
      await ref.read(authProvider.notifier).refreshPlatformToken();
    } catch (_) {}
  }

  /// Only a logged-in, known space may become active from a push click.
  /// This prevents a tenant ID supplied by a notification payload from being
  /// treated as an arbitrary navigation or token-switch command.
  Future<bool> _activatePushTargetSpace(String spaceId) async {
    final targetSpaceId = spaceId.trim();
    if (targetSpaceId.isEmpty) return false;

    final currentSpace = ref.read(currentSpaceProvider);
    if (currentSpace?.spaceId == targetSpaceId) return true;

    final authState = ref.read(authProvider).valueOrNull;
    if (authState?.status != AuthStatus.authenticated) return false;
    final isKnownSpace = targetSpaceId == 'personal' ||
        authState!.availableTenants.any(
          (tenant) => tenant.tenantId == targetSpaceId,
        );
    if (!isKnownSpace) return false;

    try {
      await ref.read(spacesProvider.notifier).switchSpace(targetSpaceId);
      return ref.read(currentSpaceProvider)?.spaceId == targetSpaceId;
    } catch (error) {
      debugPrint(
        '[PushNotification] activate target space failed: $error',
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final fontSizeScale = ref.watch(fontSizeScaleProvider);
    final isAuthenticated =
        ref.watch(authProvider).valueOrNull?.status == AuthStatus.authenticated;
    final runtimeState = ref.watch(accountRuntimeProvider);
    final activeRuntime = ref.watch(activeAccountRuntimeProvider);
    final suppressStartupNetworkBanner =
        ref.watch(startupNetworkBannerSuppressedProvider);
    return MaterialApp.router(
      title: AppBrand.publicName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _appRouter.router,
      locale: locale,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final isStartupRoute =
            _appRouter.router.routeInformationProvider.value.uri.path ==
                AppRoutes.startup;
        final application = Stack(
          children: [
            MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(fontSizeScale),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
            IncomingCallOverlay(router: _appRouter.router),
            ActiveCallMiniOverlay(router: _appRouter.router),
            if (isAuthenticated) TeenModeGate(router: _appRouter.router),
            const AppUpdateGate(),
            if (!suppressStartupNetworkBanner) const NetworkStatusBanner(),
            const _SpaceTransitionFailureBanner(),
          ],
        );
        final routedApplication = !isAuthenticated
            ? application
            : AuthenticatedRuntimeHost(
                runtime: activeRuntime,
                authenticatedChild: Stack(
                  fit: StackFit.expand,
                  children: [
                    application,
                    AuthenticatedRuntimeServices(
                      key: ObjectKey(activeRuntime),
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
                restrictedChild: runtimeState.hasError
                    ? AccountRuntimeErrorView(
                        onRetry: () =>
                            ref.read(accountRuntimeProvider.notifier).retry(),
                      )
                    : isStartupRoute
                        ? const StartupBrandLoadingView()
                        : ColoredBox(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
              );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: appSystemUiOverlayStyleFor(Theme.of(context)),
          child: routedApplication,
        );
      },
      supportedLocales: kSupportedLocales.map((e) => e.$1).toList(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class AccountRuntimeErrorView extends StatelessWidget {
  const AccountRuntimeErrorView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.appRuntimeLoadFailed),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
          ],
        ),
      ),
    );
  }
}

class _SpaceTransitionFailureBanner extends ConsumerWidget {
  const _SpaceTransitionFailureBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transition = ref.watch(spaceTransitionProvider);
    if (transition.phase != SpaceTransitionPhase.failed) {
      return const SizedBox.shrink();
    }
    return Positioned(
      left: 16,
      right: 16,
      top: MediaQuery.paddingOf(context).top + 8,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(AppLocalizations.of(context).appRuntimeLoadFailed),
              ),
              TextButton(
                onPressed: () {
                  final target = transition.targetSpaceId;
                  if (target == null) return;
                  ref.read(spaceTransitionProvider.notifier).clearFailure();
                  final auth = ref.read(authProvider.notifier);
                  unawaited(target == 'personal'
                      ? auth.selectPersonalSpace()
                      : auth.selectTenant(target));
                },
                child: Text(AppLocalizations.of(context).commonRetry),
              ),
              IconButton(
                onPressed: () =>
                    ref.read(spaceTransitionProvider.notifier).clearFailure(),
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
