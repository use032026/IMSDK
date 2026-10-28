import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/app/router/router.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/branding/startlink_brand_logo.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/utils/validators.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/auth/application/login_identifier_cache.dart';
import 'package:im_sdk/features/auth/presentation/auth_localization.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/settings/presentation/pages/privacy_page.dart';
import 'package:im_sdk/features/settings/presentation/pages/terms_page.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

part 'login_page_quick_accounts.dart';

// ---------------------------------------------------------------------------
// 登录 Tab 枚举（3 个）
// ---------------------------------------------------------------------------

enum _LoginTab {
  mobile,
  email,
  loginName;
}

const _visibleLoginTabs = <_LoginTab>[
  _LoginTab.email,
  _LoginTab.mobile,
  _LoginTab.loginName,
];

const _enableQuickLogin =
    !kReleaseMode || bool.fromEnvironment('ENABLE_QUICK_LOGIN');

const _quickLoginTenantCode = 'mouse-corp';
const _mobileLoginType = 'mobile';
const _emailLoginType = 'email';
const _lppIdLoginType = 'lpp_id';
const _legacyLoginNameType = 'login_name';
const _captchaErrorSignature = 'captcha';
const _captchaRequiredErrorSignature = 'captcha verification is required';
const _captchaChineseErrorSignature = '图形验证码';
const _securityVerificationErrorSignature = '安全验证';
const _captchaRequiredCodeErrorSignature = 'auth_captcha_required';
const _captchaInvalidCodeErrorSignature = 'auth_captcha_invalid';

class _QuickLoginAccount {
  final String name;
  final String identifier;
  final String password;
  final _LoginTab tab;
  final String? email;
  final String? mobile;
  final String? lppId;
  final String? assignedServiceStaff;
  final String? tenantCode;
  final String? avatarUrl;
  final String? avatarAssetPath;
  final int membershipRole;
  final int userType;
  final String status;

  const _QuickLoginAccount({
    required this.name,
    required this.identifier,
    required this.password,
    required this.tab,
    this.email,
    this.mobile,
    this.lppId,
    this.assignedServiceStaff,
    this.tenantCode,
    this.avatarUrl,
    this.avatarAssetPath,
    required this.membershipRole,
    required this.userType,
    required this.status,
  });
}

// ---------------------------------------------------------------------------
// LoginPage
// ---------------------------------------------------------------------------

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    this.visualOnly = false,
    super.key,
  });

  /// Renders the real login presentation without starting auth, storage,
  /// captcha, focus, or network work. Used only behind the pre-consent modal.
  final bool visualOnly;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  _LoginTab _tab = _LoginTab.mobile;

  // 手机/邮箱 Tab 内部：true=验证码，false=密码
  bool _mobileUseCode = false;
  bool _emailUseCode = false;

  // 国家/地区码
  _CountryCode _countryCode = _CountryCode.codes.first;

  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _identifierFocusNode = FocusNode(); // 主输入框焦点

  bool _agreedToTerms = false;
  bool _obscurePassword = true;

  int _countdown = 0;
  Timer? _countdownTimer;

  // 图形验证码
  String? _captchaToken;
  String? _captchaQuestion;
  bool _showCaptcha = false;
  final _captchaAnswerCtrl = TextEditingController();
  final _captchaAnswerFocusNode = FocusNode();
  final Map<_LoginTab, String> _rememberedIdentifiers = {};
  final Map<_LoginTab, String> _identifierDrafts = {};
  bool _syncingIdentifier = false;
  bool _restoringLastLoginAccount = true;
  bool _loginTabSelectedByUser = false;
  int _logoTapCount = 0;
  Timer? _logoTapResetTimer;

  @override
  void initState() {
    super.initState();
    _identifierCtrl.addListener(_onIdentifierChanged);
    if (widget.visualOnly) {
      _restoringLastLoginAccount = false;
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreLastLoginAccount();
      _checkCaptchaRequired();
      // 页面打开时自动聚焦主输入框（Mac 键盘需要）
      _identifierFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _identifierCtrl.removeListener(_onIdentifierChanged);
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    _codeCtrl.dispose();
    _identifierFocusNode.dispose();
    _captchaAnswerCtrl.dispose();
    _captchaAnswerFocusNode.dispose();
    _countdownTimer?.cancel();
    _logoTapResetTimer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // 进入页面时检查是否需要验证码
  // ---------------------------------------------------------------------------

  Future<void> _checkCaptchaRequired() async {
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio
          .get<Map<String, dynamic>>('/api/client/v1/auth/captcha/check');
      final required = resp.data?['data']?['captchaRequired'] as bool? ?? false;
      if (required && mounted) {
        await _fetchCaptcha(showOverlayWhenUnsolved: true);
      }
    } catch (_) {}
  }

  Future<void> _restoreLastLoginAccount() async {
    try {
      final storage = ref.read(secureStorageProvider);
      final type = await storage.read(LoginIdentifierCache.lastLoginTypeKey);
      final mobile =
          await storage.read(LoginIdentifierCache.lastLoginIdentifierMobileKey);
      final email =
          await storage.read(LoginIdentifierCache.lastLoginIdentifierEmailKey);
      final lppId =
          await storage.read(LoginIdentifierCache.lastLoginIdentifierLppIdKey);
      final legacyIdentifier =
          await storage.read(LoginIdentifierCache.lastLoginIdentifierKey);
      if (!mounted) return;

      _rememberedIdentifiers
        ..clear()
        ..addAll({
          if (mobile != null && mobile.isNotEmpty) _LoginTab.mobile: mobile,
          if (email != null && email.isNotEmpty) _LoginTab.email: email,
          if (lppId != null && lppId.isNotEmpty) _LoginTab.loginName: lppId,
        });

      final tab = _tabFromLoginType(type);
      if (tab != null &&
          !_rememberedIdentifiers.containsKey(tab) &&
          legacyIdentifier != null &&
          legacyIdentifier.isNotEmpty) {
        _rememberedIdentifiers[tab] = legacyIdentifier;
      }

      if (_loginTabSelectedByUser) return;

      final targetTab = _tab;
      final identifier = _rememberedIdentifiers[targetTab];

      setState(() {
        _tab = targetTab;
        _restoringLastLoginAccount = false;
        _setIdentifierText(identifier ?? '');
        _passwordCtrl.clear();
        _codeCtrl.clear();
      });
    } catch (_) {
      if (mounted) {
        setState(() => _restoringLastLoginAccount = false);
      }
    }
  }

  Future<void> _rememberLastLoginAccount(_LoginTab tab, String id) async {
    try {
      final storage = ref.read(secureStorageProvider);
      _rememberedIdentifiers[tab] = id;
      _identifierDrafts[tab] = id;
      await storage.write(
        LoginIdentifierCache.lastLoginTypeKey,
        _loginTypeForTab(tab),
      );
      await storage.write(LoginIdentifierCache.lastLoginIdentifierKey, id);
      await storage.write(_identifierStorageKeyForTab(tab), id);
    } catch (_) {}
  }

  String _identifierStorageKeyForTab(_LoginTab tab) {
    switch (tab) {
      case _LoginTab.mobile:
        return LoginIdentifierCache.lastLoginIdentifierMobileKey;
      case _LoginTab.email:
        return LoginIdentifierCache.lastLoginIdentifierEmailKey;
      case _LoginTab.loginName:
        return LoginIdentifierCache.lastLoginIdentifierLppIdKey;
    }
  }

  void _onIdentifierChanged() {
    if (_syncingIdentifier || _restoringLastLoginAccount) return;
    _identifierDrafts[_tab] = _identifierCtrl.text;
  }

  void _setIdentifierText(String value) {
    _syncingIdentifier = true;
    _identifierCtrl.text = value;
    _identifierCtrl.selection = TextSelection.collapsed(offset: value.length);
    _syncingIdentifier = false;
  }

  String _identifierForTab(_LoginTab tab) {
    if (_identifierDrafts.containsKey(tab)) {
      return _identifierDrafts[tab] ?? '';
    }
    return _rememberedIdentifiers[tab] ?? '';
  }

  void _switchLoginTab(_LoginTab tab) {
    if (!_visibleLoginTabs.contains(tab)) return;
    if (!_restoringLastLoginAccount && tab == _tab) return;
    final wasRestoringLastLoginAccount = _restoringLastLoginAccount;
    if (wasRestoringLastLoginAccount) {
      _loginTabSelectedByUser = true;
    } else {
      _identifierDrafts[_tab] = _identifierCtrl.text;
    }
    setState(() {
      _tab = tab;
      _restoringLastLoginAccount = false;
      _setIdentifierText(_identifierForTab(tab));
      _passwordCtrl.clear();
      _codeCtrl.clear();
      _countdown = 0;
      _countdownTimer?.cancel();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _identifierFocusNode.requestFocus();
    });
  }

  String _loginTypeForTab(_LoginTab tab) {
    switch (tab) {
      case _LoginTab.mobile:
        return _mobileLoginType;
      case _LoginTab.email:
        return _emailLoginType;
      case _LoginTab.loginName:
        return _lppIdLoginType;
    }
  }

  _LoginTab? _tabFromLoginType(String? type) {
    switch (type) {
      case _mobileLoginType:
        return _LoginTab.mobile;
      case _emailLoginType:
        return _LoginTab.email;
      case _lppIdLoginType:
        return _LoginTab.loginName;
      case _legacyLoginNameType:
        return null;
      default:
        return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 倒计时
  // ---------------------------------------------------------------------------

  void _startCountdown() {
    setState(() => _countdown = 60);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        if (mounted) setState(() => _countdown = 0);
      } else {
        if (mounted) setState(() => _countdown--);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // 发送验证码
  // ---------------------------------------------------------------------------

  String _tabLabel(_LoginTab tab) {
    final l10n = AppLocalizations.of(context);
    switch (tab) {
      case _LoginTab.mobile:
        return l10n.authTabMobile;
      case _LoginTab.email:
        return l10n.authTabEmail;
      case _LoginTab.loginName:
        return l10n.authTabLoginName;
    }
  }

  Future<void> _sendCode() async {
    final id = _identifierCtrl.text.trim();
    if (_tab == _LoginTab.mobile) {
      final err = Validators.validateMobile(id);
      if (err != null) {
        _showError(err);
        return;
      }
    } else {
      final err = Validators.validateEmail(id);
      if (err != null) {
        _showError(err);
        return;
      }
    }
    final channel = _tab == _LoginTab.email ? 'email' : 'sms';
    try {
      await ref.read(authProvider.notifier).sendVerificationCode(id, channel);
      _startCountdown();
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // 登录
  // ---------------------------------------------------------------------------

  Future<void> _login({
    String? captchaToken,
    String? captchaAnswer,
    bool allowAutoCaptcha = true,
  }) async {
    if (!_agreedToTerms) return;

    final id = _identifierCtrl.text.trim();
    final notifier = ref.read(authProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final effectiveCaptchaToken = captchaToken ?? _captchaToken;
    final effectiveCaptchaAnswer = captchaAnswer ??
        (_captchaAnswerCtrl.text.trim().isEmpty
            ? null
            : _captchaAnswerCtrl.text.trim());

    try {
      switch (_tab) {
        case _LoginTab.mobile:
          final mErr = Validators.validateMobile(id);
          if (mErr != null) {
            _showError(mErr);
            return;
          }
          if (_mobileUseCode) {
            final code = _codeCtrl.text.trim();
            if (code.isEmpty) {
              _showError(l10n.authErrorEmptyCode);
              return;
            }
            await notifier.loginByCode(id, code, _mobileLoginType,
                captchaToken: effectiveCaptchaToken,
                captchaAnswer: effectiveCaptchaAnswer);
          } else {
            final pw = _passwordCtrl.text;
            if (pw.isEmpty) {
              _showError(l10n.authErrorEmptyPassword);
              return;
            }
            await notifier.loginByPassword(id, pw, _mobileLoginType,
                captchaToken: effectiveCaptchaToken,
                captchaAnswer: effectiveCaptchaAnswer);
          }

        case _LoginTab.email:
          final eErr = Validators.validateEmail(id);
          if (eErr != null) {
            _showError(eErr);
            return;
          }
          if (_emailUseCode) {
            final code = _codeCtrl.text.trim();
            if (code.isEmpty) {
              _showError(l10n.authErrorEmptyCode);
              return;
            }
            await notifier.loginByCode(id, code, _emailLoginType,
                captchaToken: effectiveCaptchaToken,
                captchaAnswer: effectiveCaptchaAnswer);
          } else {
            final pw = _passwordCtrl.text;
            if (pw.isEmpty) {
              _showError(l10n.authErrorEmptyPassword);
              return;
            }
            await notifier.loginByPassword(id, pw, _emailLoginType,
                captchaToken: effectiveCaptchaToken,
                captchaAnswer: effectiveCaptchaAnswer);
          }

        case _LoginTab.loginName:
          if (id.isEmpty) {
            _showError(l10n.authErrorEmptyLoginName);
            return;
          }
          final pw = _passwordCtrl.text;
          if (pw.isEmpty) {
            _showError(l10n.authErrorEmptyPassword);
            return;
          }
          await notifier.loginByPassword(id, pw, _lppIdLoginType,
              captchaToken: effectiveCaptchaToken,
              captchaAnswer: effectiveCaptchaAnswer);
      }
      await _rememberLastLoginAccount(_tab, id);
      _clearCaptcha();
      _passwordCtrl.clear();
    } catch (e) {
      if (_isCaptchaError(e) && allowAutoCaptcha) {
        final solved = await _fetchCaptcha(showOverlayWhenUnsolved: true);
        if (solved) {
          await _login(
            captchaToken: _captchaToken,
            captchaAnswer: _captchaAnswerCtrl.text.trim(),
            allowAutoCaptcha: false,
          );
        }
        return;
      }
      if (_isCaptchaError(e)) {
        await _fetchCaptcha(showOverlayWhenUnsolved: true);
        if (mounted) {
          _showError(l10n.authCaptchaHint);
        }
        return;
      }
      if (e is ServerError) {
        _showError(
            authExceptionMessage(l10n, e, fallback: l10n.authLoginFailed));
      } else if (e is AuthError) {
        _showError(
            authExceptionMessage(l10n, e, fallback: l10n.authLoginFailed));
      } else if (e is NetworkError) {
        _showError(
          authExceptionMessage(l10n, e, fallback: l10n.authLoginFailed),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // 图形验证码
  // ---------------------------------------------------------------------------

  Future<bool> _fetchCaptcha({required bool showOverlayWhenUnsolved}) async {
    final l10n = AppLocalizations.of(context);
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio
          .post<Map<String, dynamic>>('/api/client/v1/auth/captcha/generate');
      final data = resp.data?['data'] as Map<String, dynamic>?;
      if (data != null && mounted) {
        final question = (data['question'] as String?) ??
            (data['captchaQuestion'] as String?) ??
            l10n.authCaptchaHint;
        final autoAnswer = _solveCaptchaQuestion(question);
        setState(() {
          _captchaToken = data['token'] as String?;
          _captchaQuestion = question;
          _captchaAnswerCtrl.text = autoAnswer?.toString() ?? '';
          _showCaptcha = autoAnswer == null && showOverlayWhenUnsolved;
        });
        if (autoAnswer == null && showOverlayWhenUnsolved) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _showCaptcha) {
              _captchaAnswerFocusNode.requestFocus();
            }
          });
        }
        return autoAnswer != null && _captchaToken != null;
      }
    } catch (_) {
      _showError(l10n.authCaptchaFailed);
    }
    return false;
  }

  bool _isCaptchaError(Object e) {
    if (e is ServerError) {
      final code = e.code.toUpperCase();
      final message = e.message.toLowerCase();
      return code == 'AUTH_CAPTCHA_REQUIRED' ||
          code == 'AUTH_CAPTCHA_INVALID' ||
          message.contains(_captchaErrorSignature) ||
          message.contains(_captchaChineseErrorSignature) ||
          message.contains(_securityVerificationErrorSignature);
    }
    final text = e.toString().toLowerCase();
    return text.contains(_captchaRequiredCodeErrorSignature) ||
        text.contains(_captchaInvalidCodeErrorSignature) ||
        text.contains(_captchaRequiredErrorSignature) ||
        text.contains(_captchaErrorSignature) ||
        text.contains(_captchaChineseErrorSignature) ||
        text.contains(_securityVerificationErrorSignature);
  }

  void _clearCaptcha() {
    if (!mounted) return;
    setState(() {
      _captchaToken = null;
      _captchaQuestion = null;
      _showCaptcha = false;
      _captchaAnswerCtrl.clear();
    });
  }

  int? _solveCaptchaQuestion(String? question) {
    if (question == null) return null;
    final normalized = question
        .replaceAll('＋', '+')
        .replaceAll('加', '+')
        .replaceAll('－', '-')
        .replaceAll('减', '-')
        .replaceAll('×', '*')
        .replaceAll('x', '*')
        .replaceAll('X', '*')
        .replaceAll('乘', '*')
        .replaceAll('÷', '/')
        .replaceAll('除以', '/')
        .replaceAll('除', '/');
    final match =
        RegExp(r'(-?\d+)\s*([+\-*/])\s*(-?\d+)').firstMatch(normalized);
    if (match == null) return null;
    final left = int.tryParse(match.group(1)!);
    final op = match.group(2);
    final right = int.tryParse(match.group(3)!);
    if (left == null || op == null || right == null) return null;
    switch (op) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '*':
        return left * right;
      case '/':
        if (right == 0 || left % right != 0) return null;
        return left ~/ right;
    }
    return null;
  }

  Future<void> _submitWithCaptcha() async {
    final l10n = AppLocalizations.of(context);
    var answer = _captchaAnswerCtrl.text.trim();
    if (answer.isEmpty) {
      _showError(l10n.authCaptchaHint);
      return;
    }
    if (_captchaToken == null) {
      final solved = await _fetchCaptcha(showOverlayWhenUnsolved: true);
      if (!solved) return;
      answer = _captchaAnswerCtrl.text.trim();
    }
    _captchaAnswerFocusNode.unfocus();
    setState(() => _showCaptcha = false);
    await _login(
      captchaToken: _captchaToken,
      captchaAnswer: answer,
      allowAutoCaptcha: false,
    );
  }

  void _closeCaptchaOverlay() {
    _captchaAnswerFocusNode.unfocus();
    setState(() => _showCaptcha = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _handleLogoTap() {
    if (!_enableQuickLogin) return;
    _logoTapResetTimer?.cancel();
    _logoTapResetTimer = Timer(const Duration(seconds: 2), () {
      _logoTapCount = 0;
    });
    _logoTapCount += 1;
    if (_logoTapCount < 3) return;
    _logoTapCount = 0;
    _logoTapResetTimer?.cancel();
    FocusScope.of(context).unfocus();
    _openQuickLoginPage();
  }

  Future<void> _quickLogin(_QuickLoginAccount account) async {
    if (!_enableQuickLogin || !_visibleLoginTabs.contains(account.tab)) return;
    final tab = account.tab;
    FocusScope.of(context).unfocus();
    setState(() {
      _tab = tab;
      _setIdentifierText(account.identifier);
      _passwordCtrl.text = account.password;
      _codeCtrl.clear();
      _mobileUseCode = false;
      _emailUseCode = false;
      _agreedToTerms = true;
      _showCaptcha = false;
    });
    await _login();
  }

  void _openQuickLoginPage() {
    if (!_enableQuickLogin) return;
    final visibleAccounts = _quickLoginAccounts
        .where(
          (account) =>
              _visibleLoginTabs.contains(account.tab) &&
              account.tenantCode == _quickLoginTenantCode &&
              (account.tab != _LoginTab.loginName || account.lppId != null),
        )
        .toList(growable: false);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _QuickLoginPage(
          accounts: visibleAccounts,
          onLogin: _quickLogin,
        ),
      ),
    );
  }

  /// 账号注销冷静期弹窗：提示用户撤销注销
  void _showCancelDeactivationDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppAlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.authDeactivatingTitle,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colorScheme.error)),
        content: Text(
          l10n.authDeactivatingContent,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go(AppRoutes.home);
            },
            child: Text(l10n.authContinueUse,
                style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                final dio = ref.read(dioProvider);
                await dio.post<Map<String, dynamic>>(
                  '/api/platform/v1/account/deactivate/cancel',
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.authDeactivationCancelled)));
                  context.go(AppRoutes.home);
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(l10n.authDeactivationCancelFailed)));
                  context.go(AppRoutes.home);
                }
              }
            },
            child: Text(l10n.authCancelDeactivation,
                style: TextStyle(color: colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    if (!widget.visualOnly) {
      ref.listen<AsyncValue<AuthState>>(authProvider, (_, next) {
        next.whenOrNull(
          data: (s) {
            if (s.status == AuthStatus.authenticated) {
              if (s.isPendingDeactivation) {
                // 账号处于注销冷静期，提示撤销
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  _showCancelDeactivationDialog(context, ref);
                });
              } else {
                context.go(AppRoutes.home);
              }
            } else if (s.availableTenants.length > 1) {
              context.go(AppRoutes.tenantSelect);
            } else if (s.error != null) {
              _showError(authPresentationFailureMessage(l10n, s.error!));
            }
          },
          error: (e, _) {
            if (_isCaptchaError(e)) return;
            final l10n = AppLocalizations.of(context);
            if (e is ServerError) {
              _showError(authExceptionMessage(
                l10n,
                e,
                fallback: l10n.authLoginFailed,
              ));
            } else if (e is AuthError) {
              _showError(authExceptionMessage(
                l10n,
                e,
                fallback: l10n.authLoginFailed,
              ));
            } else if (e is NetworkError) {
              _showError(authExceptionMessage(
                l10n,
                e,
                fallback: l10n.authLoginFailed,
              ));
            } else {
              _showError(l10n.authLoginFailed);
            }
          },
        );
      });
    }

    final isLoading =
        widget.visualOnly ? false : ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 56),
                  _buildLogo(),
                  const SizedBox(height: 32),
                  _buildTabBar(),
                  const SizedBox(height: 24),
                  _buildForm(),
                  const SizedBox(height: 16),
                  _buildAgreementRow(),
                  const SizedBox(height: 24),
                  _buildLoginButton(isLoading),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.authNoAccount,
                        style: AppTextStyles.caption.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          minimumSize: const Size(64, 44),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          l10n.authRegisterNow,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          if (_showCaptcha) _buildCaptchaOverlay(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Logo
  // ---------------------------------------------------------------------------

  Widget _buildLogo() {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleLogoTap,
      child: Column(
        children: [
          const LoginBrandLogo(),
          const SizedBox(height: 12),
          Text(
            l10n.authLoginTitle,
            style: AppTextStyles.headline2.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 栏
  // ---------------------------------------------------------------------------

  Widget _buildTabBar() {
    return Row(
      children: _visibleLoginTabs.map((tab) {
        final selected = !_restoringLastLoginAccount && tab == _tab;
        return Expanded(
          child: GestureDetector(
            onTap: () => _switchLoginTab(tab),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                _tabLabel(tab),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? AppColors.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // 表单
  // ---------------------------------------------------------------------------

  Widget _buildForm() {
    switch (_tab) {
      case _LoginTab.mobile:
        return _buildMobileForm();
      case _LoginTab.email:
        return _buildEmailForm();
      case _LoginTab.loginName:
        return _buildLoginNameForm();
    }
  }

  // 手机号表单：验证码 / 密码 切换
  Widget _buildMobileForm() {
    return Column(
      children: [
        _buildPhoneField(),
        const SizedBox(height: 8),
        _buildSubToggle(
          useCode: _mobileUseCode,
          onToggle: () => setState(() {
            _mobileUseCode = !_mobileUseCode;
            _codeCtrl.clear();
            _passwordCtrl.clear();
          }),
        ),
        const SizedBox(height: 8),
        if (_mobileUseCode) _buildCodeField() else _buildPasswordField(),
      ],
    );
  }

  // 邮箱表单：验证码 / 密码 切换
  Widget _buildEmailForm() {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _buildInputField(
          controller: _identifierCtrl,
          hint: l10n.authHintEmail,
          keyboardType: TextInputType.emailAddress,
          focusNode: _identifierFocusNode,
        ),
        const SizedBox(height: 8),
        _buildSubToggle(
          useCode: _emailUseCode,
          onToggle: () => setState(() {
            _emailUseCode = !_emailUseCode;
            _codeCtrl.clear();
            _passwordCtrl.clear();
          }),
        ),
        const SizedBox(height: 8),
        if (_emailUseCode) _buildCodeField() else _buildPasswordField(),
      ],
    );
  }

  // 微界号表单：微界号 + 密码。登录不需要企业码；企业选择由平台登录结果决定。
  Widget _buildLoginNameForm() {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _buildInputField(
          controller: _identifierCtrl,
          hint: l10n.authHintLoginName,
          focusNode: _identifierFocusNode,
        ),
        const SizedBox(height: 12),
        _buildPasswordField(),
      ],
    );
  }

  // 验证码/密码 切换小按钮
  Widget _buildSubToggle(
      {required bool useCode, required VoidCallback onToggle}) {
    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onToggle,
        child: Text(
          useCode ? l10n.authUsePassword : l10n.authUseCode,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 手机号输入框（带国家码前缀，可点击切换）
  Widget _buildPhoneField() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showCountryPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_countryCode.dial,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down,
                      size: 18, color: AppColors.primary),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _identifierCtrl,
              focusNode: _identifierFocusNode,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: colorScheme.onSurface),
              cursorColor: AppColors.primary,
              enableInteractiveSelection: true,
              contextMenuBuilder: (context, editableTextState) =>
                  AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).authHintMobile,
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountryPickerSheet(
        selected: _countryCode,
        onSelect: (code) {
          setState(() => _countryCode = code);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  // 验证码输入框 + 发送按钮
  Widget _buildCodeField() {
    final l10n = AppLocalizations.of(context);
    final disabledColor = Theme.of(context).disabledColor;
    return Row(
      children: [
        Expanded(
          child: _buildInputField(
            controller: _codeCtrl,
            hint: l10n.authHintCode,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 112,
          height: 48,
          child: OutlinedButton(
            onPressed: _countdown > 0 ? null : _sendCode,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color: _countdown > 0 ? disabledColor : AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              _countdown > 0
                  ? l10n.authResendCode(_countdown)
                  : l10n.authGetCode,
              style: TextStyle(
                  fontSize: 13,
                  color: _countdown > 0 ? disabledColor : AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  // 密码输入框
  Widget _buildPasswordField() {
    final l10n = AppLocalizations.of(context);
    return _buildInputField(
      controller: _passwordCtrl,
      hint: l10n.authHintPassword,
      obscureText: _obscurePassword,
      suffix: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 20,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
    );
  }

  // 通用输入框
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffix,
    List<String>? autofillHints,
    FocusNode? focusNode,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      style: TextStyle(color: colorScheme.onSurface),
      cursorColor: AppColors.primary,
      enableInteractiveSelection: true,
      contextMenuBuilder: (context, editableTextState) =>
          AdaptiveTextSelectionToolbar.editableText(
        editableTextState: editableTextState,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        suffixIcon: suffix,
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 用户协议
  // ---------------------------------------------------------------------------

  Widget _buildAgreementRow() {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
            activeColor: AppColors.primary,
            side: BorderSide(color: colorScheme.onSurfaceVariant, width: 1.5),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: l10n.authAgreementPrefix,
              style: AppTextStyles.caption.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              children: [
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TermsPage())),
                    child: Text(l10n.authTermsLink,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primary)),
                  ),
                ),
                TextSpan(text: l10n.authAgreementAnd),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PrivacyPage())),
                    child: Text(l10n.authPrivacyLink,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 登录按钮
  // ---------------------------------------------------------------------------

  Widget _buildLoginButton(bool isLoading) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final disabledColor = Theme.of(context).disabledColor;
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: (_agreedToTerms && !isLoading) ? _login : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _agreedToTerms ? AppColors.primary : disabledColor,
          disabledBackgroundColor: disabledColor,
          disabledForegroundColor: colorScheme.onPrimary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.surface))
            : Text(l10n.authLoginButton, style: AppTextStyles.button),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 图形验证码遮罩
  // ---------------------------------------------------------------------------

  Widget _buildCaptchaOverlay() {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.scrim.withValues(alpha: 0.54),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(l10n.authCaptchaTitle,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface)),
              ),
              if (_captchaQuestion != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_captchaQuestion!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface)),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  controller: _captchaAnswerCtrl,
                  focusNode: _captchaAnswerFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  autofocus: true,
                  style: TextStyle(color: colorScheme.onSurface),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: l10n.authCaptchaHint,
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _closeCaptchaOverlay,
                      child: Text(l10n.commonCancel,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          )),
                    ),
                  ),
                  const SizedBox(
                      width: 1, height: 44, child: VerticalDivider(width: 1)),
                  Expanded(
                    child: TextButton(
                      onPressed: _submitWithCaptcha,
                      child: Text(l10n.commonConfirm,
                          style: const TextStyle(color: AppColors.primary)),
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

class LoginBrandLogo extends StatelessWidget {
  const LoginBrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartlinkBrandLogo(
      dimension: 72,
      containerKey: ValueKey('login-brand-logo'),
      clipKey: ValueKey('login-brand-logo-clip'),
      markKey: ValueKey('login-brand-logo-mark'),
    );
  }
}

// ---------------------------------------------------------------------------
// 国家/地区码数据
// ---------------------------------------------------------------------------

enum _CountryRegion {
  chinaMainland,
  hongKong,
  macau,
  taiwan,
  unitedStates,
  unitedKingdom,
  japan,
  southKorea,
  singapore,
  malaysia,
  australia,
  canada,
  germany,
  france,
  india,
  thailand,
  vietnam,
  indonesia,
  philippines,
}

class _CountryCode {
  final _CountryRegion region;
  final String dial;
  final String flag;

  const _CountryCode({
    required this.region,
    required this.dial,
    required this.flag,
  });

  static const List<_CountryCode> codes = [
    _CountryCode(
        region: _CountryRegion.chinaMainland, dial: '+86', flag: '🇨🇳'),
    _CountryCode(region: _CountryRegion.hongKong, dial: '+852', flag: '🇭🇰'),
    _CountryCode(region: _CountryRegion.macau, dial: '+853', flag: '🇲🇴'),
    _CountryCode(region: _CountryRegion.taiwan, dial: '+886', flag: '🇨🇳'),
    _CountryCode(region: _CountryRegion.unitedStates, dial: '+1', flag: '🇺🇸'),
    _CountryCode(
        region: _CountryRegion.unitedKingdom, dial: '+44', flag: '🇬🇧'),
    _CountryCode(region: _CountryRegion.japan, dial: '+81', flag: '🇯🇵'),
    _CountryCode(region: _CountryRegion.southKorea, dial: '+82', flag: '🇰🇷'),
    _CountryCode(region: _CountryRegion.singapore, dial: '+65', flag: '🇸🇬'),
    _CountryCode(region: _CountryRegion.malaysia, dial: '+60', flag: '🇲🇾'),
    _CountryCode(region: _CountryRegion.australia, dial: '+61', flag: '🇦🇺'),
    _CountryCode(region: _CountryRegion.canada, dial: '+1', flag: '🇨🇦'),
    _CountryCode(region: _CountryRegion.germany, dial: '+49', flag: '🇩🇪'),
    _CountryCode(region: _CountryRegion.france, dial: '+33', flag: '🇫🇷'),
    _CountryCode(region: _CountryRegion.india, dial: '+91', flag: '🇮🇳'),
    _CountryCode(region: _CountryRegion.thailand, dial: '+66', flag: '🇹🇭'),
    _CountryCode(region: _CountryRegion.vietnam, dial: '+84', flag: '🇻🇳'),
    _CountryCode(region: _CountryRegion.indonesia, dial: '+62', flag: '🇮🇩'),
    _CountryCode(region: _CountryRegion.philippines, dial: '+63', flag: '🇵🇭'),
  ];
}

String _countryName(AppLocalizations l10n, _CountryRegion region) =>
    switch (region) {
      _CountryRegion.chinaMainland => l10n.authCountryChinaMainland,
      _CountryRegion.hongKong => l10n.authCountryHongKong,
      _CountryRegion.macau => l10n.authCountryMacau,
      _CountryRegion.taiwan => l10n.authCountryTaiwan,
      _CountryRegion.unitedStates => l10n.authCountryUnitedStates,
      _CountryRegion.unitedKingdom => l10n.authCountryUnitedKingdom,
      _CountryRegion.japan => l10n.authCountryJapan,
      _CountryRegion.southKorea => l10n.authCountrySouthKorea,
      _CountryRegion.singapore => l10n.authCountrySingapore,
      _CountryRegion.malaysia => l10n.authCountryMalaysia,
      _CountryRegion.australia => l10n.authCountryAustralia,
      _CountryRegion.canada => l10n.authCountryCanada,
      _CountryRegion.germany => l10n.authCountryGermany,
      _CountryRegion.france => l10n.authCountryFrance,
      _CountryRegion.india => l10n.authCountryIndia,
      _CountryRegion.thailand => l10n.authCountryThailand,
      _CountryRegion.vietnam => l10n.authCountryVietnam,
      _CountryRegion.indonesia => l10n.authCountryIndonesia,
      _CountryRegion.philippines => l10n.authCountryPhilippines,
    };

// ---------------------------------------------------------------------------
// 国家/地区选择底部弹窗
// ---------------------------------------------------------------------------

class _CountryPickerSheet extends StatefulWidget {
  final _CountryCode selected;
  final ValueChanged<_CountryCode> onSelect;

  const _CountryPickerSheet({required this.selected, required this.onSelect});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _query = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = _CountryCode.codes
        .where((c) =>
            _countryName(l10n, c.region).contains(_query) ||
            c.dial.contains(_query))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 拖动条
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(l10n.authCountryPickerTitle,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          // 搜索框
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l10n.authCountrySearchHint,
                prefixIcon: Icon(Icons.search,
                    size: 20, color: colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final code = filtered[i];
                final isSelected = code.dial == widget.selected.dial &&
                    code.region == widget.selected.region;
                return InkWell(
                  onTap: () => widget.onSelect(code),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        Text(code.flag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(_countryName(l10n, code.region),
                              style: const TextStyle(fontSize: 15)),
                        ),
                        Text(code.dial,
                            style: TextStyle(
                                fontSize: 15,
                                color: isSelected
                                    ? AppColors.primary
                                    : colorScheme.onSurfaceVariant)),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.check,
                              size: 18, color: AppColors.primary),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLoginPage extends StatefulWidget {
  final List<_QuickLoginAccount> accounts;
  final Future<void> Function(_QuickLoginAccount account) onLogin;

  const _QuickLoginPage({
    required this.accounts,
    required this.onLogin,
  });

  @override
  State<_QuickLoginPage> createState() => _QuickLoginPageState();
}

class _QuickLoginPageState extends State<_QuickLoginPage> {
  String? _loadingIdentifier;

  Future<void> _handleLogin(_QuickLoginAccount account) async {
    if (_loadingIdentifier != null) return;
    FocusScope.of(context).unfocus();
    setState(() => _loadingIdentifier = account.identifier);
    try {
      await widget.onLogin(account);
    } finally {
      if (mounted) {
        setState(() => _loadingIdentifier = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final loadingIdentifier = _loadingIdentifier;
    final accountGroups = _groupAccounts(widget.accounts, l10n);
    final rows = <({
      String? groupTitle,
      int groupCount,
      _QuickLoginAccount? account,
    })>[
      for (final group in accountGroups.entries) ...[
        (
          groupTitle: group.key,
          groupCount: group.value.length,
          account: null,
        ),
        for (final account in group.value)
          (
            groupTitle: null,
            groupCount: 0,
            account: account,
          ),
      ],
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.authQuickLoginTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: rows.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  loadingIdentifier == null
                      ? l10n.authQuickLoginSummary(widget.accounts.length)
                      : l10n.authQuickLoginProgress,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            final row = rows[index - 1];
            final account = row.account;
            if (account == null) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _QuickLoginGroupHeader(
                  title: row.groupTitle!,
                  count: row.groupCount,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _QuickLoginAccountButton(
                account: account,
                enabled: loadingIdentifier == null,
                loading: loadingIdentifier == account.identifier,
                onTap: () => _handleLogin(account),
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, List<_QuickLoginAccount>> _groupAccounts(
    List<_QuickLoginAccount> accounts,
    AppLocalizations l10n,
  ) {
    final groupOrder = [
      l10n.authRoleOwner,
      l10n.authRoleAdministrator,
      l10n.authRoleCustomerService,
      l10n.authRoleTechnicalSupport,
      l10n.authRoleEmployee,
      l10n.authRoleEnterpriseCustomer,
    ];
    final groups = {
      for (final group in groupOrder) group: <_QuickLoginAccount>[],
    };

    for (final account in accounts) {
      groups[_quickLoginRoleText(account, l10n)]!.add(account);
    }
    groups.removeWhere((_, accounts) => accounts.isEmpty);
    return groups;
  }
}

String _quickLoginRoleText(
  _QuickLoginAccount account,
  AppLocalizations l10n,
) {
  return switch (account.membershipRole) {
    4 => l10n.authRoleOwner,
    3 => l10n.authRoleAdministrator,
    2 => l10n.authRoleCustomerService,
    1 => l10n.authRoleTechnicalSupport,
    _ => account.userType == 1
        ? l10n.authRoleEnterpriseCustomer
        : l10n.authRoleEmployee,
  };
}

String _quickLoginIdentityText(
  _QuickLoginAccount account,
  AppLocalizations l10n,
) {
  final tenantCode = account.tenantCode ?? _quickLoginTenantCode;
  final statusPrefix = account.status.trim().toLowerCase() == 'active'
      ? ''
      : l10n.authUnavailablePrefix;
  if (account.userType == 1) {
    final staffName = account.assignedServiceStaff?.trim();
    final assignment = staffName == null || staffName.isEmpty
        ? l10n.authUnassignedService
        : l10n.authAssignedService(staffName);
    return '$statusPrefix${l10n.authCustomerIdentity(assignment)}';
  }
  return '$statusPrefix${l10n.authEmployeeIdentity(tenantCode)}';
}

class _QuickLoginGroupHeader extends StatelessWidget {
  final String title;
  final int count;

  const _QuickLoginGroupHeader({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.authUserCount(count),
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLoginAccountButton extends StatelessWidget {
  final _QuickLoginAccount account;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  const _QuickLoginAccountButton({
    required this.account,
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final role = _quickLoginRoleText(account, l10n);
    final identity = _quickLoginIdentityText(account, l10n);
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _QuickLoginAvatar(account: account),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            account.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _QuickLoginRoleChip(text: role),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      runSpacing: 3,
                      children: [
                        _QuickLoginMetaText(
                          label: l10n.authTabEmail,
                          value: account.email,
                        ),
                        _QuickLoginMetaText(
                          label: l10n.authMetaPhone,
                          value: account.mobile,
                        ),
                        _QuickLoginMetaText(
                          label: l10n.authTabLoginName,
                          value: account.lppId,
                        ),
                        _QuickLoginMetaText(
                          label: l10n.authMetaIdentity,
                          value: identity,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (loading)
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: AppColors.primary,
                  ),
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLoginRoleChip extends StatelessWidget {
  final String text;

  const _QuickLoginRoleChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _QuickLoginMetaText extends StatelessWidget {
  final String label;
  final String? value;

  const _QuickLoginMetaText({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value == null || value!.trim().isEmpty ? '-' : value!;
    return Text(
      '$label：$displayValue',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 11,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _QuickLoginAvatar extends StatelessWidget {
  final _QuickLoginAccount account;

  const _QuickLoginAvatar({required this.account});

  @override
  Widget build(BuildContext context) {
    const size = 44.0;
    const borderRadius = 12.0;
    final assetPath = account.avatarAssetPath;
    if (assetPath == null || assetPath.isEmpty) {
      return UserAvatar(
        name: account.name,
        size: size,
        borderRadius: borderRadius,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => UserAvatar(
          name: account.name,
          size: size,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
