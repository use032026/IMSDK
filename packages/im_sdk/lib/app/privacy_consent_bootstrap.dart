import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/app/system_ui.dart';
import 'package:im_sdk/app/theme/app_theme_extension.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/branding/app_brand.dart';
import 'package:im_sdk/core/privacy/privacy_consent_service.dart';
import 'package:im_sdk/core/providers/locale_provider.dart';
import 'package:im_sdk/features/settings/presentation/pages/privacy_page.dart';
import 'package:im_sdk/features/settings/presentation/pages/terms_page.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

typedef AuthorizedRuntimeStarter = Future<void> Function();
typedef DeclinedAppExit = Future<void> Function();

const _authorizedRuntimeStartupTimeout = Duration(seconds: 12);
const _declinedAppExitDelay = Duration(milliseconds: 1000);

enum _PrivacyBootstrapError { runtimeStartup, saveChoice }

/// Resolves the native policy decision before the app runtime starts.
/// Push remains fail-closed unless the decision is explicitly accepted.
class PrivacyConsentBootstrap extends StatefulWidget {
  const PrivacyConsentBootstrap({
    required this.consentStore,
    required this.startAuthorizedRuntime,
    required this.authorizedAppBuilder,
    required this.locale,
    this.allowDeclinedRuntime = false,
    this.exitAfterDecline,
    this.startupLoadingBuilder,
    super.key,
  });

  final PrivacyConsentStore consentStore;
  final AuthorizedRuntimeStarter startAuthorizedRuntime;
  final WidgetBuilder authorizedAppBuilder;
  final Locale locale;

  /// Non-Android clients may retain their existing push-free basic runtime.
  /// Android store privacy checks require an accepted decision before the
  /// generated plugin registry or any business runtime is started.
  final bool allowDeclinedRuntime;
  final DeclinedAppExit? exitAfterDecline;
  final WidgetBuilder? startupLoadingBuilder;

  @override
  State<PrivacyConsentBootstrap> createState() =>
      _PrivacyConsentBootstrapState();
}

class _PrivacyConsentBootstrapState extends State<PrivacyConsentBootstrap> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final PrivacyConsentController _consentController;
  bool _checking = true;
  bool _starting = false;
  bool _authorized = false;
  bool _showDeclineNotice = false;
  _PrivacyBootstrapError? _startupError;
  Future<void>? _authorizedRuntimeFuture;
  Brightness? _configuredSystemUiBrightness;

  @override
  void initState() {
    super.initState();
    _consentController = PrivacyConsentController(widget.consentStore);
    unawaited(_resolveConsent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // main.dart defers the first frame to avoid a native-to-Flutter flash.
      // The privacy gate is now a valid first frame and must be visible.
      try {
        WidgetsBinding.instance.allowFirstFrame();
      } on AssertionError {
        // Widget tests mount this owner without main.dart's defer handoff.
      }
    });
  }

  @override
  void dispose() {
    // Once authorized, the inner StateNotifierProvider owns disposal. Before
    // that scope exists, the bootstrap still owns the controller.
    if (!_authorized) _consentController.dispose();
    super.dispose();
  }

  Future<void> _resolveConsent() async {
    PrivacyConsentDecision decision;
    try {
      decision = await _consentController.load();
    } catch (_) {
      // Privacy state is fail-closed. A broken native bridge must never let
      // networked runtime owners start before an explicit choice.
      decision = PrivacyConsentDecision.undecided;
    }
    if (!mounted) return;
    if (decision == PrivacyConsentDecision.accepted ||
        (decision == PrivacyConsentDecision.declined &&
            widget.allowDeclinedRuntime)) {
      await _startAuthorizedRuntime();
      return;
    }
    setState(() => _checking = false);
  }

  Future<void> _accept() async {
    if (_starting) return;
    var decisionPersisted = false;
    setState(() {
      _starting = true;
      _startupError = null;
    });
    try {
      await _consentController.accept();
      decisionPersisted = true;
      await _startAuthorizedRuntimeWithTimeout();
      if (!mounted) return;
      setState(() {
        _authorized = true;
        _checking = false;
        _starting = false;
      });
    } catch (error) {
      _releaseFailedRuntimeAttempt(error);
      if (!mounted) return;
      setState(() {
        _checking = false;
        _starting = false;
        _startupError = decisionPersisted
            ? _PrivacyBootstrapError.runtimeStartup
            : _PrivacyBootstrapError.saveChoice;
      });
    }
  }

  Future<void> _startAuthorizedRuntime() async {
    if (_starting || _authorized) return;
    setState(() {
      _starting = true;
      _startupError = null;
    });
    try {
      await _startAuthorizedRuntimeWithTimeout();
      if (!mounted) return;
      setState(() {
        _authorized = true;
        _checking = false;
        _starting = false;
      });
    } catch (error) {
      _releaseFailedRuntimeAttempt(error);
      if (!mounted) return;
      setState(() {
        _checking = false;
        _starting = false;
        _startupError = _PrivacyBootstrapError.runtimeStartup;
      });
    }
  }

  Future<void> _startAuthorizedRuntimeWithTimeout() {
    final runtimeFuture =
        _authorizedRuntimeFuture ??= widget.startAuthorizedRuntime();
    return runtimeFuture.timeout(_authorizedRuntimeStartupTimeout);
  }

  void _releaseFailedRuntimeAttempt(Object error) {
    // A timeout does not stop the underlying initialization. Keep sharing that
    // in-flight Future so retry cannot start a second database/runtime owner.
    // A completed failure is safe to discard and must be retryable.
    if (error is! TimeoutException) {
      _authorizedRuntimeFuture = null;
    }
  }

  Future<void> _decline() async {
    if (_starting) return;
    final exitsAfterDecline = !widget.allowDeclinedRuntime;
    var decisionPersisted = false;
    setState(() {
      _starting = true;
      _startupError = null;
      _showDeclineNotice = exitsAfterDecline;
    });
    try {
      await _consentController.decline();
      decisionPersisted = true;
      if (widget.allowDeclinedRuntime) {
        await _startAuthorizedRuntimeWithTimeout();
        if (!mounted) return;
        setState(() {
          _authorized = true;
          _checking = false;
          _starting = false;
        });
      } else {
        await Future<void>.delayed(_declinedAppExitDelay);
        if (!mounted) return;
        await widget.exitAfterDecline?.call();
        if (!mounted) return;
        setState(() {
          _checking = false;
          _starting = false;
          _showDeclineNotice = false;
        });
      }
    } catch (error) {
      if (widget.allowDeclinedRuntime) {
        _releaseFailedRuntimeAttempt(error);
      }
      if (!mounted) return;
      setState(() {
        _checking = false;
        _starting = false;
        _showDeclineNotice = false;
        _startupError = decisionPersisted
            ? _PrivacyBootstrapError.runtimeStartup
            : _PrivacyBootstrapError.saveChoice;
      });
    }
  }

  void _openTerms() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const TermsPage(showOfficialLink: false),
      ),
    );
  }

  void _openPrivacy() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const PrivacyPage(showOfficialLink: false),
      ),
    );
  }

  void _syncSystemUi(ThemeData theme, {required bool startupLoading}) {
    final brightness = startupLoading ? null : theme.brightness;
    if (_configuredSystemUiBrightness == brightness) return;
    _configuredSystemUiBrightness = brightness;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(startupLoading
          ? configureStartupSystemUi()
          : configureAppSystemUi(theme));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authorized) {
      return ProviderScope(
        overrides: [
          privacyConsentControllerProvider.overrideWith(
            (ref) => _consentController,
          ),
        ],
        child: Builder(builder: widget.authorizedAppBuilder),
      );
    }

    final startupLoadingBuilder = widget.startupLoadingBuilder;
    final showStartupLoading = startupLoadingBuilder != null &&
        !_showDeclineNotice &&
        (_checking || _starting);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      locale: widget.locale,
      title: AppBrand.publicName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      supportedLocales: kSupportedLocales.map((e) => e.$1).toList(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          _syncSystemUi(theme, startupLoading: showStartupLoading);
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: appSystemUiOverlayStyleFor(theme),
            child: PopScope(
              canPop: false,
              child: showStartupLoading
                  ? Builder(builder: startupLoadingBuilder)
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(color: context.colors.background),
                        ModalBarrier(
                          dismissible: false,
                          color: context.colors.modalBarrier,
                        ),
                        SafeArea(
                          child: Center(
                            child: _showDeclineNotice
                                ? const SizedBox.shrink()
                                : _checking
                                    ? CircularProgressIndicator(
                                        color: context.colors.primary,
                                      )
                                    : _PrivacyConsentDialog(
                                        busy: _starting,
                                        showBusyIndicator:
                                            _starting && !_showDeclineNotice,
                                        error: _startupError,
                                        onAccept: _accept,
                                        onDecline: _decline,
                                        onTerms: _openTerms,
                                        onPrivacy: _openPrivacy,
                                      ),
                          ),
                        ),
                        if (_showDeclineNotice) const _PrivacyDeclineNotice(),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _PrivacyDeclineNotice extends StatelessWidget {
  const _PrivacyDeclineNotice();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: IgnorePointer(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            key: const Key('privacy-decline-exit-notice'),
            margin: const EdgeInsets.fromLTRB(32, 24, 32, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: colors.inverseSurface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              AppLocalizations.of(context).privacyConsentDeclinedExit,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onInverseSurface,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivacyConsentDialog extends StatelessWidget {
  const _PrivacyConsentDialog({
    required this.busy,
    required this.showBusyIndicator,
    required this.onAccept,
    required this.onDecline,
    required this.onTerms,
    required this.onPrivacy,
    this.error,
  });

  final bool busy;
  final bool showBusyIndicator;
  final _PrivacyBootstrapError? error;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final consentBody = Theme.of(context).platform == TargetPlatform.iOS
        ? l10n.privacyConsentBodyIos(AppBrand.publicName)
        : l10n.privacyConsentBodyAndroid(AppBrand.publicName);
    final errorText = switch (error) {
      _PrivacyBootstrapError.runtimeStartup =>
        l10n.privacyConsentRuntimeFailure,
      _PrivacyBootstrapError.saveChoice => l10n.privacyConsentSaveFailure,
      null => null,
    };
    final screenSize = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(280.0, screenSize.width - 48.0);
    final bodyMaxHeight = math.min(176.0, screenSize.height * 0.27);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        key: const Key('privacy-consent-window'),
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      size: 19,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      l10n.privacyConsentTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: bodyMaxHeight),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                    child: Scrollbar(
                      thumbVisibility: true,
                      radius: const Radius.circular(3),
                      thickness: 3,
                      child: SingleChildScrollView(
                        primary: true,
                        padding: const EdgeInsets.only(right: 7),
                        child: Text(
                          consentBody,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.55,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton(
                    onPressed: busy ? null : onTerms,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    child: Text(
                      l10n.privacyConsentTermsLink,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    l10n.privacyConsentConjunction,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: busy ? null : onPrivacy,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    child: Text(
                      l10n.privacyConsentPrivacyLink,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (errorText != null) ...[
                const SizedBox(height: 2),
                Text(
                  errorText,
                  style: TextStyle(fontSize: 13, color: context.colors.danger),
                ),
              ],
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: busy ? null : onDecline,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.colors.textSecondary,
                          side: BorderSide(color: context.colors.divider),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          l10n.privacyConsentDecline,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: FilledButton(
                        onPressed: busy ? null : onAccept,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: showBusyIndicator
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: context.colors.onPrimary,
                                ),
                              )
                            : Text(
                                l10n.privacyConsentAccept,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(fontSize: 13),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
