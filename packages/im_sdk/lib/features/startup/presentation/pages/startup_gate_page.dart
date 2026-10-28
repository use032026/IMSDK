import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/app/router/router.dart';
import 'package:im_sdk/app/system_ui.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/startup/presentation/widgets/startup_brand_loading_view.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

@visibleForTesting
const minimumStartupBrandDisplay = Duration(milliseconds: 1200);

final startupNetworkBannerSuppressedProvider =
    StateProvider<bool>((ref) => true);

final _startupDestinationProvider = FutureProvider<String>((ref) async {
  return waitForMinimumStartupBrandDisplay(() async {
    final authState = await ref.watch(authProvider.future);
    if (authState.status != AuthStatus.authenticated) {
      return authStateNeedsSpaceSelection(authState)
          ? AppRoutes.tenantSelect
          : AppRoutes.login;
    }

    return AppRoutes.home;
  });
});

@visibleForTesting
Future<String> waitForMinimumStartupBrandDisplay(
  Future<String> Function() resolve, {
  DateTime Function()? now,
  Future<void> Function(Duration duration)? delay,
}) async {
  final currentTime = now ?? DateTime.now;
  final wait = delay ?? Future<void>.delayed;
  final startedAt = currentTime();
  final result = await resolve();
  if (result == AppRoutes.login) return result;
  final elapsed = currentTime().difference(startedAt);
  final remaining = minimumStartupBrandDisplay - elapsed;
  if (remaining > Duration.zero) {
    await wait(remaining);
  }
  return result;
}

VoidCallback _startupNetworkBannerReleaseCallback(WidgetRef ref) {
  final notifier = ref.read(startupNetworkBannerSuppressedProvider.notifier);
  return () {
    unawaited(Future<void>.delayed(
      const Duration(milliseconds: 2500),
      () => notifier.state = false,
    ));
  };
}

void _prepareStartupUiForDestination(
  VoidCallback releaseNetworkBanner,
  ThemeData theme,
) {
  unawaited(configureAppSystemUi(theme));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    releaseNetworkBanner();
  });
}

class StartupGatePage extends ConsumerStatefulWidget {
  const StartupGatePage({super.key});

  @override
  ConsumerState<StartupGatePage> createState() => _StartupGatePageState();
}

class _StartupGatePageState extends ConsumerState<StartupGatePage> {
  var _hasNavigated = false;
  var _hasAllowedStartupLoadingFrame = false;
  var _hasScheduledStartupUiRelease = false;
  late ThemeData _theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  @override
  void initState() {
    super.initState();
    unawaited(configureStartupSystemUi());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _allowStartupLoadingFirstFrame();
    });
  }

  @override
  void dispose() {
    if (!_hasAllowedStartupLoadingFrame) {
      _allowStartupLoadingFirstFrame();
    }
    if (!_hasScheduledStartupUiRelease) {
      unawaited(configureAppSystemUi(_theme));
    }
    super.dispose();
  }

  void _allowStartupLoadingFirstFrame() {
    if (_hasAllowedStartupLoadingFrame) return;
    _hasAllowedStartupLoadingFrame = true;
    try {
      WidgetsBinding.instance.allowFirstFrame();
    } on AssertionError {
      // Widget tests can mount App without main.dart's deferFirstFrame handoff.
    }
  }

  void _scheduleStartupUiRelease() {
    if (_hasScheduledStartupUiRelease) return;
    _hasScheduledStartupUiRelease = true;
    _prepareStartupUiForDestination(
      _startupNetworkBannerReleaseCallback(ref),
      _theme,
    );
  }

  void _retryStartup() {
    _hasNavigated = false;
    ref.invalidate(authProvider);
    ref.invalidate(_startupDestinationProvider);
  }

  @override
  Widget build(BuildContext context) {
    final destinationState = ref.watch(_startupDestinationProvider);
    final destination = destinationState.valueOrNull;
    if (destination != null && !_hasNavigated) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        _scheduleStartupUiRelease();
        context.go(destination);
      });
    }

    if (destinationState.hasError) {
      return _StartupFailureView(onRetry: _retryStartup);
    }

    return const StartupBrandLoadingView();
  }
}

class _StartupFailureView extends StatelessWidget {
  const _StartupFailureView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const StartupBrandLoadingSurface(),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.startupFailureTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.startupFailureMessage,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: onRetry,
                          child: Text(l10n.commonRetry),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
