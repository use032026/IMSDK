import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/app/router/router.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/utils/validators.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/features/auth/presentation/auth_localization.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/settings/presentation/pages/privacy_page.dart';
import 'package:im_sdk/features/settings/presentation/pages/terms_page.dart';
import 'package:im_sdk/features/space/data/models/enterprise_join_models.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// 颜色常量
// ---------------------------------------------------------------------------
const _primary = AppColors.primary;
const _smsVerificationType = 'sms';
const _emailVerificationType = 'email';
const _registerVerificationType = 'register';
const _verificationRequiredCode = 'AUTH_VERIFICATION_REQUIRED';
const _mobileLoginType = 'mobile';
const _emailLoginType = 'email';

// ---------------------------------------------------------------------------
// 注册页
// ---------------------------------------------------------------------------

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

enum _IdMode { mobile, email }

enum _RegisterField { displayName, identifier, password, confirm, code, join }

enum _CaptchaProtectedAction { sendCode, register }

class _RegisterPageState extends ConsumerState<RegisterPage> {
  ColorScheme get _colors => Theme.of(context).colorScheme;
  Color get _card => _colors.surface;
  Color get _divider => _colors.outlineVariant;
  Color get _txtMain => _colors.onSurface;
  Color get _txtGray => _colors.onSurfaceVariant;

  _IdMode _idMode = _IdMode.mobile;

  final _displayNameCtrl = TextEditingController();
  final _identifierCtrl = TextEditingController(); // 手机号或邮箱
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _codeCtrl = TextEditingController(); // 短信/邮件验证码
  final _enterpriseCtrl = TextEditingController(); // 邀请码（可选）
  final _displayNameFocusNode = FocusNode();
  final _identifierFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();
  final _enterpriseFocusNode = FocusNode(); // 邀请码输入框焦点
  final _captchaAnswerCtrl = TextEditingController();
  final _captchaAnswerFocusNode = FocusNode();

  bool _showEnterpriseField = false; // 是否展开企业字段
  bool _searchingEnterprise = false; // 搜索中
  String? _foundEnterpriseName; // 搜索到的企业名
  RegistrationCredentialPreview? _joinPreview;
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _errorDialogVisible = false;
  bool _showCaptcha = false;
  bool _captchaSubmitting = false;
  String? _captchaToken;
  String? _captchaQuestion;
  String? _captchaError;
  _CaptchaProtectedAction? _captchaAction;

  // 验证码设置
  bool _smsEnabled = true;
  bool _emailEnabled = true;

  // 发送倒计时
  int _countdown = 0;
  bool _isSendingCode = false;
  Timer? _countdownTimer;
  final Map<_RegisterField, String> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    _loadVerificationSettings();
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _codeCtrl.dispose();
    _enterpriseCtrl.dispose();
    _displayNameFocusNode.dispose();
    _identifierFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    _codeFocusNode.dispose();
    _enterpriseFocusNode.dispose();
    _captchaAnswerCtrl.dispose();
    _captchaAnswerFocusNode.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // ── 加载验证码设置 ─────────────────────────────────────────────────────────

  Future<void> _loadVerificationSettings() async {
    try {
      final settings =
          await ref.read(authProvider.notifier).getVerificationSettings();
      if (!mounted) return;
      final smsEnabled = settings.smsEnabled;
      final emailEnabled = settings.emailEnabled;
      _IdMode mode = _idMode;
      if (_idMode == _IdMode.mobile && !smsEnabled && emailEnabled) {
        mode = _IdMode.email;
      } else if (_idMode == _IdMode.email && !emailEnabled && smsEnabled) {
        mode = _IdMode.mobile;
      }
      setState(() {
        _smsEnabled = smsEnabled;
        _emailEnabled = emailEnabled;
        _idMode = mode;
      });
    } catch (_) {}
  }

  /// 客户端注册流程始终校验所选联系方式，服务端继续负责验证码真伪与频控。
  bool get _shouldRequireVerificationCode => true;

  // ── 发送验证码 ─────────────────────────────────────────────────────────────

  Future<void> _sendCode({
    String? captchaToken,
    String? captchaAnswer,
  }) async {
    final l10n = AppLocalizations.of(context);
    if (_isSendingCode || _countdown > 0) return;
    final channelEnabled =
        _idMode == _IdMode.email ? _emailEnabled : _smsEnabled;
    if (!channelEnabled) {
      _showError(_idMode == _IdMode.email
          ? l10n.authEmailVerificationUnavailable
          : l10n.authSmsVerificationUnavailable);
      return;
    }
    final identifier = _identifierCtrl.text.trim();
    if (_idMode == _IdMode.mobile) {
      final err = identifier.isEmpty
          ? l10n.authHintMobile
          : (!Validators.isMobile(identifier)
              ? l10n.authErrorInvalidMobile
              : null);
      if (err != null) {
        _showFieldError(_RegisterField.identifier, err, _identifierFocusNode);
        return;
      }
    } else {
      final err = identifier.isEmpty
          ? l10n.authHintEmail
          : (!Validators.isEmail(identifier)
              ? l10n.authErrorInvalidEmail
              : null);
      if (err != null) {
        _showFieldError(_RegisterField.identifier, err, _identifierFocusNode);
        return;
      }
    }
    setState(() => _isSendingCode = true);
    try {
      await ref.read(authProvider.notifier).sendVerificationCode(
            identifier,
            _idMode == _IdMode.mobile
                ? _smsVerificationType
                : _emailVerificationType,
            purpose: _registerVerificationType,
            captchaToken: captchaToken,
            captchaAnswer: captchaAnswer,
          );
      if (captchaToken != null) _clearCaptcha();
      _startCountdown();
    } catch (err) {
      if (_isCaptchaError(err)) {
        await _requestCaptcha(_CaptchaProtectedAction.sendCode);
        return;
      }
      if (captchaToken != null) _clearCaptcha();
      _showError(err is ServerError
          ? authExceptionMessage(l10n, err, fallback: l10n.authSendFailed)
          : l10n.authSendFailed);
    } finally {
      if (mounted) setState(() => _isSendingCode = false);
    }
  }

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

  // ── 注册逻辑 ───────────────────────────────────────────────────────────────

  Future<void> _register({
    String? captchaToken,
    String? captchaAnswer,
  }) async {
    final l10n = AppLocalizations.of(context);
    if (!_agreedToTerms || _isLoading) return;
    _clearAllFieldErrors();

    final displayName = _displayNameCtrl.text.trim();
    final identifier = _identifierCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;
    final invitationCode = _enterpriseCtrl.text.trim();
    final channelEnabled =
        _idMode == _IdMode.email ? _emailEnabled : _smsEnabled;

    // 基础校验
    if (displayName.isEmpty) {
      _showFieldError(
        _RegisterField.displayName,
        l10n.authErrorEmptyNickname,
        _displayNameFocusNode,
      );
      return;
    }
    if (!channelEnabled) {
      _showError(_idMode == _IdMode.email
          ? l10n.authEmailVerificationUnavailable
          : l10n.authSmsVerificationUnavailable);
      return;
    }

    if (identifier.isEmpty) {
      _showFieldError(
        _RegisterField.identifier,
        switch (_idMode) {
          _IdMode.mobile => l10n.authHintMobile,
          _IdMode.email => l10n.authHintEmail,
        },
        _identifierFocusNode,
      );
      return;
    }
    final identifierError = switch (_idMode) {
      _IdMode.mobile =>
        Validators.isMobile(identifier) ? null : l10n.authErrorInvalidMobile,
      _IdMode.email =>
        Validators.isEmail(identifier) ? null : l10n.authErrorInvalidEmail,
    };
    if (identifierError != null) {
      _showFieldError(
        _RegisterField.identifier,
        identifierError,
        _identifierFocusNode,
      );
      return;
    }
    if (password.length < 6) {
      _showFieldError(
        _RegisterField.password,
        l10n.authErrorPasswordTooShort,
        _passwordFocusNode,
      );
      return;
    }
    if (password != confirm) {
      _showFieldError(
        _RegisterField.confirm,
        l10n.authErrorPasswordMismatch,
        _confirmFocusNode,
      );
      return;
    }
    if (_shouldRequireVerificationCode && _codeCtrl.text.trim().isEmpty) {
      _showFieldError(
        _RegisterField.code,
        l10n.authErrorVerificationRequired,
        _codeFocusNode,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final notifier = ref.read(authProvider.notifier);

      await notifier.registerPlatform(
        displayName: displayName,
        password: password,
        loginType: _currentLoginType(),
        mobile: _idMode == _IdMode.mobile ? identifier : null,
        email: _idMode == _IdMode.email ? identifier : null,
        verificationCode:
            _shouldRequireVerificationCode ? _codeCtrl.text.trim() : null,
        invitationCode: invitationCode.isEmpty ? null : invitationCode,
        captchaToken: captchaToken,
        captchaAnswer: captchaAnswer,
      );
      // 注册+登录成功，router 自动跳转
    } catch (e) {
      if (!mounted) return;
      if (_isCaptchaError(e)) {
        await _requestCaptcha(_CaptchaProtectedAction.register);
        return;
      }
      if (captchaToken != null) _clearCaptcha();
      String msg = l10n.authRegisterFailed;
      if (e is DioException) {
        final err = ErrorHandler.fromDioException(e);
        if (err is ServerError) {
          if (err.code == _verificationRequiredCode) {
            _showFieldError(
              _RegisterField.code,
              l10n.authErrorVerificationRequired,
              _codeFocusNode,
            );
            return;
          } else {
            msg = authExceptionMessage(
              l10n,
              err,
              fallback: l10n.authRegisterFailed,
            );
          }
        }
      } else if (e is ServerError) {
        if (e.code == _verificationRequiredCode) {
          _showFieldError(
            _RegisterField.code,
            l10n.authErrorVerificationRequired,
            _codeFocusNode,
          );
          return;
        }
        msg = authExceptionMessage(
          l10n,
          e,
          fallback: l10n.authRegisterFailed,
        );
      }
      _showError(msg);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isCaptchaError(Object error) {
    if (error is! ServerError) return false;
    final code = error.code.toUpperCase();
    return code == 'AUTH_CAPTCHA_REQUIRED' || code == 'AUTH_CAPTCHA_INVALID';
  }

  Future<void> _requestCaptcha(_CaptchaProtectedAction action) async {
    final l10n = AppLocalizations.of(context);
    try {
      final challenge = await ref.read(authProvider.notifier).generateCaptcha();
      if (!mounted) return;
      setState(() {
        _captchaAction = action;
        _captchaToken = challenge.token;
        _captchaQuestion = challenge.question;
        _captchaAnswerCtrl.clear();
        _captchaError = null;
        _captchaSubmitting = false;
        _showCaptcha = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _showCaptcha) {
          _captchaAnswerFocusNode.requestFocus();
        }
      });
    } catch (_) {
      if (!mounted) return;
      _clearCaptcha();
      _showError(l10n.authCaptchaFailed);
    }
  }

  Future<void> _submitCaptcha() async {
    if (_captchaSubmitting) return;
    final token = _captchaToken;
    final action = _captchaAction;
    final answer = _captchaAnswerCtrl.text.trim();
    if (token == null || action == null) return;
    if (answer.isEmpty) {
      setState(
          () => _captchaError = AppLocalizations.of(context).authCaptchaHint);
      _captchaAnswerFocusNode.requestFocus();
      return;
    }
    setState(() {
      _captchaSubmitting = true;
      _captchaError = null;
    });
    _captchaAnswerFocusNode.unfocus();
    try {
      switch (action) {
        case _CaptchaProtectedAction.sendCode:
          await _sendCode(captchaToken: token, captchaAnswer: answer);
          break;
        case _CaptchaProtectedAction.register:
          await _register(captchaToken: token, captchaAnswer: answer);
          break;
      }
    } finally {
      if (mounted) setState(() => _captchaSubmitting = false);
    }
  }

  void _clearCaptcha() {
    if (!mounted) return;
    _captchaAnswerFocusNode.unfocus();
    setState(() {
      _showCaptcha = false;
      _captchaSubmitting = false;
      _captchaToken = null;
      _captchaQuestion = null;
      _captchaError = null;
      _captchaAction = null;
      _captchaAnswerCtrl.clear();
    });
  }

  void _showError(String msg) {
    if (!mounted || _errorDialogVisible) return;
    _errorDialogVisible = true;
    ScaffoldMessenger.of(context).clearSnackBars();
    showDialog<void>(
      context: context,
      builder: (ctx) => AppAlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppLocalizations.of(ctx).authRegisterErrorTitle,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        content: Text(
          msg,
          style: TextStyle(fontSize: 15, color: _txtMain, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(ctx).authGotIt,
                style: const TextStyle(color: _primary)),
          ),
        ],
      ),
    ).whenComplete(() => _errorDialogVisible = false);
  }

  void _showFieldError(
    _RegisterField field,
    String message,
    FocusNode focusNode,
  ) {
    setState(() => _fieldErrors[field] = message);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) focusNode.requestFocus();
    });
  }

  void _clearFieldError(_RegisterField field) {
    if (!_fieldErrors.containsKey(field)) return;
    setState(() => _fieldErrors.remove(field));
  }

  void _clearAllFieldErrors() {
    if (_fieldErrors.isEmpty) return;
    setState(_fieldErrors.clear);
  }

  String _currentLoginType() {
    return switch (_idMode) {
      _IdMode.mobile => _mobileLoginType,
      _IdMode.email => _emailLoginType,
    };
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen<AsyncValue<AuthState>>(authProvider, (_, next) {
      next.whenOrNull(
        data: (s) {
          if (s.status == AuthStatus.authenticated) {
            context.go(AppRoutes.home);
            return;
          }
          if (authStateNeedsSpaceSelection(s)) {
            context.go(AppRoutes.tenantSelect);
          }
        },
        error: (e, _) {
          if (_isCaptchaError(e)) return;
          final l10n = AppLocalizations.of(context);
          if (e is ServerError) {
            _showError(authExceptionMessage(
              l10n,
              e,
              fallback: l10n.authRegisterFailed,
            ));
          } else if (e is AuthError) {
            _showError(authExceptionMessage(
              l10n,
              e,
              fallback: l10n.authRegisterFailed,
            ));
          } else if (e is NetworkError) {
            _showError(authExceptionMessage(
              l10n,
              e,
              fallback: l10n.authRegisterFailed,
            ));
          } else {
            _showError(l10n.authRegisterFailed);
          }
        },
      );
    });

    return Stack(children: [
      Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: _txtMain),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(l10n.authRegisterTitle,
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w600, color: _txtMain)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // 手机/邮箱切换（始终显示）
                _buildIdModeTabs(),
                const SizedBox(height: 8),

                // 手机号或邮箱输入
                if (_idMode == _IdMode.mobile) ...[
                  _buildLabel(l10n.authTabMobile),
                  _buildPhoneInput(),
                ] else ...[
                  _buildLabel(l10n.authTabEmail),
                  _buildInput(
                    controller: _identifierCtrl,
                    focusNode: _identifierFocusNode,
                    hint: l10n.authHintEmail,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _fieldErrors[_RegisterField.identifier],
                    onChanged: (_) =>
                        _clearFieldError(_RegisterField.identifier),
                  ),
                ],
                const SizedBox(height: 16),

                // 昵称
                _buildLabel(l10n.authNickname),
                _buildInput(
                  controller: _displayNameCtrl,
                  focusNode: _displayNameFocusNode,
                  hint: l10n.authNicknameHint,
                  errorText: _fieldErrors[_RegisterField.displayName],
                  onChanged: (_) =>
                      _clearFieldError(_RegisterField.displayName),
                ),
                const SizedBox(height: 16),

                // 密码
                _buildLabel(l10n.authPassword),
                _buildInput(
                  controller: _passwordCtrl,
                  focusNode: _passwordFocusNode,
                  hint: l10n.authPasswordSetHint,
                  obscure: _obscurePassword,
                  errorText: _fieldErrors[_RegisterField.password],
                  onChanged: (_) => _clearFieldError(_RegisterField.password),
                  suffix: _eyeBtn(
                      _obscurePassword,
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword)),
                ),
                const SizedBox(height: 16),
                _buildLabel(l10n.authConfirmPassword),
                _buildInput(
                  controller: _confirmCtrl,
                  focusNode: _confirmFocusNode,
                  hint: l10n.authConfirmPasswordHint,
                  obscure: _obscureConfirm,
                  errorText: _fieldErrors[_RegisterField.confirm],
                  onChanged: (_) => _clearFieldError(_RegisterField.confirm),
                  suffix: _eyeBtn(_obscureConfirm,
                      () => setState(() => _obscureConfirm = !_obscureConfirm)),
                ),
                const SizedBox(height: 20),

                // 邀请码（可选，折叠）
                _buildEnterpriseSection(),
                const SizedBox(height: 20),

                // 先填写完整注册信息，最后获取并填写验证码。
                if (_shouldRequireVerificationCode) ...[
                  _buildLabel(l10n.authVerificationCode),
                  _buildCodeRow(),
                  const SizedBox(height: 20),
                ],

                // 协议
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                      activeColor: _primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: l10n.authAgreementPrefix,
                        style: TextStyle(fontSize: 13, color: _txtGray),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const TermsPage(),
                                ),
                              ),
                              child: Text(
                                l10n.authTermsLink,
                                style: const TextStyle(
                                    fontSize: 13, color: _primary),
                              ),
                            ),
                          ),
                          TextSpan(text: l10n.authAgreementAnd),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const PrivacyPage(),
                                ),
                              ),
                              child: Text(
                                l10n.authPrivacyLink,
                                style: const TextStyle(
                                    fontSize: 13, color: _primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                // 注册按钮
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        (_agreedToTerms && !_isLoading) ? _register : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _agreedToTerms
                          ? _primary
                          : _colors.surfaceContainerHighest,
                      foregroundColor: _colors.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.surface))
                        : Text(l10n.authRegisterAndLogin,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 16),

                // 去登录
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text.rich(TextSpan(
                      text: l10n.authHaveAccount,
                      style: TextStyle(fontSize: 14, color: _txtGray),
                      children: [
                        TextSpan(
                            text: l10n.authGoLogin,
                            style: const TextStyle(
                                color: _primary, fontWeight: FontWeight.w500)),
                      ],
                    )),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      if (_showCaptcha) _buildCaptchaOverlay(),
    ]);
  }

  Widget _buildCaptchaOverlay() {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: _colors.scrim.withValues(alpha: 0.54),
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
                child: Text(
                  l10n.authCaptchaTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: _txtMain,
                  ),
                ),
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
                    child: Text(
                      _captchaQuestion!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _txtMain,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  controller: _captchaAnswerCtrl,
                  focusNode: _captchaAnswerFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  autofocus: true,
                  enabled: !_captchaSubmitting,
                  onChanged: (_) {
                    if (_captchaError != null) {
                      setState(() => _captchaError = null);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: l10n.authCaptchaHint,
                    errorText: _captchaError,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: _divider),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _captchaSubmitting ? null : _clearCaptcha,
                      child: Text(
                        l10n.commonCancel,
                        style: TextStyle(color: _txtGray),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 1,
                    height: 44,
                    child: VerticalDivider(width: 1),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: _captchaSubmitting ? null : _submitCaptcha,
                      child: _captchaSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _primary,
                              ),
                            )
                          : Text(
                              l10n.commonConfirm,
                              style: const TextStyle(color: _primary),
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

  // ── 手机/邮箱切换 Tab ─────────────────────────────────────────────────────

  Widget _buildIdModeTabs() {
    final l10n = AppLocalizations.of(context);
    return Row(children: [
      if (_emailEnabled) ...[
        _idTab(l10n.authTabEmail, _IdMode.email),
        const SizedBox(width: 16),
      ],
      if (_smsEnabled) ...[
        _idTab(l10n.authTabMobile, _IdMode.mobile),
        const SizedBox(width: 16),
      ],
    ]);
  }

  Widget _idTab(String label, _IdMode mode) {
    final selected = _idMode == mode;
    return GestureDetector(
      onTap: () {
        if (_idMode == mode) return;
        setState(() {
          _idMode = mode;
          _identifierCtrl.clear();
          _codeCtrl.clear();
          _fieldErrors.remove(_RegisterField.identifier);
          _fieldErrors.remove(_RegisterField.code);
          _countdown = 0;
          _countdownTimer?.cancel();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: selected ? _primary : Colors.transparent,
                    width: 2))),
        child: Text(label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? _primary : _txtGray,
            )),
      ),
    );
  }

  // ── 手机号输入（带区号） ───────────────────────────────────────────────────

  Widget _buildPhoneInput() {
    final l10n = AppLocalizations.of(context);
    final errorText = _fieldErrors[_RegisterField.identifier];
    final hasError = errorText != null && errorText.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasError ? _colors.error : _divider,
          ),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
                border: Border(right: BorderSide(color: _divider))),
            child: const Text('+86',
                style: TextStyle(
                    color: _primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: TextField(
              controller: _identifierCtrl,
              focusNode: _identifierFocusNode,
              keyboardType: TextInputType.phone,
              onChanged: (_) => _clearFieldError(_RegisterField.identifier),
              decoration: InputDecoration(
                hintText: l10n.authHintMobile,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
        ]),
      ),
      if (hasError) _buildFieldError(errorText),
    ]);
  }

  // ── 验证码行 ───────────────────────────────────────────────────────────────

  Widget _buildCodeRow() {
    final l10n = AppLocalizations.of(context);
    return Row(children: [
      Expanded(
        child: _buildInput(
          controller: _codeCtrl,
          focusNode: _codeFocusNode,
          hint: l10n.authHintCode,
          keyboardType: TextInputType.number,
          errorText: _fieldErrors[_RegisterField.code],
          onChanged: (_) => _clearFieldError(_RegisterField.code),
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
        width: 112,
        height: 48,
        child: OutlinedButton(
          onPressed: (_countdown > 0 || _isSendingCode) ? null : _sendCode,
          style: OutlinedButton.styleFrom(
            side:
                BorderSide(color: _countdown > 0 ? _colors.outline : _primary),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            _countdown > 0
                ? l10n.authResendCode(_countdown)
                : (_isSendingCode ? l10n.authSendingCode : l10n.authGetCode),
            style: TextStyle(
                fontSize: 13,
                color: _countdown > 0 ? _colors.onSurfaceVariant : _primary),
          ),
        ),
      ),
    ]);
  }

  // ── 邀请码（可选，折叠区，带搜索） ──────────────────────────────────────────

  Future<void> _searchEnterprise() async {
    final l10n = AppLocalizations.of(context);
    final code = _enterpriseCtrl.text.trim();
    if (code.isEmpty) {
      _showFieldError(
        _RegisterField.join,
        l10n.authJoinCredentialHint,
        _enterpriseFocusNode,
      );
      return;
    }
    setState(() {
      _searchingEnterprise = true;
      _foundEnterpriseName = null;
      _joinPreview = null;
    });
    try {
      final preview = await ref
          .read(authProvider.notifier)
          .previewRegistrationInvitation(code);
      if (!mounted || _enterpriseCtrl.text.trim() != code) return;
      setState(() {
        _joinPreview = preview;
        switch (preview.kind) {
          case RegistrationCredentialPreviewKind.invitation:
            _foundEnterpriseName = preview.invitation?.tenantName;
          case RegistrationCredentialPreviewKind.notFound:
            _foundEnterpriseName = '';
        }
      });
    } catch (_) {
      _showError(l10n.authTenantSearchFailed);
    } finally {
      if (mounted) setState(() => _searchingEnterprise = false);
    }
  }

  Widget _buildEnterpriseSection() {
    final l10n = AppLocalizations.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () {
          setState(() {
            _showEnterpriseField = !_showEnterpriseField;
            if (!_showEnterpriseField) {
              _enterpriseCtrl.clear();
              _foundEnterpriseName = null;
              _joinPreview = null;
            }
          });
          // 展开时自动聚焦邀请码输入框
          if (_showEnterpriseField) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showEnterpriseKeyboard();
            });
          }
        },
        child: Row(children: [
          Icon(
            _showEnterpriseField
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: _txtGray,
          ),
          const SizedBox(width: 4),
          Text(
            _showEnterpriseField ? l10n.authCollapseJoin : l10n.authExpandJoin,
            style: TextStyle(fontSize: 13, color: _txtGray),
          ),
        ]),
      ),
      if (_showEnterpriseField) ...[
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: _buildInput(
              controller: _enterpriseCtrl,
              focusNode: _enterpriseFocusNode,
              hint: l10n.authJoinCredentialHint,
              errorText: _fieldErrors[_RegisterField.join],
              onTap: _showEnterpriseKeyboard,
              onChanged: (_) {
                _clearFieldError(_RegisterField.join);
                _clearJoinLookup();
              },
              suffix: _joinPreview?.kind ==
                      RegistrationCredentialPreviewKind.invitation
                  ? const Icon(Icons.check_circle, color: _primary, size: 20)
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: _searchingEnterprise ? null : _searchEnterprise,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: _searchingEnterprise
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _primary))
                  : Text(l10n.commonSearch,
                      style: const TextStyle(color: _primary, fontSize: 14)),
            ),
          ),
        ]),
        if (_foundEnterpriseName != null &&
            _foundEnterpriseName!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.business_outlined, size: 14, color: _primary),
            const SizedBox(width: 4),
            Text(l10n.authInvitationValid(_foundEnterpriseName!),
                style: const TextStyle(fontSize: 12, color: _primary)),
          ]),
          if (_joinPreview?.invitation?.targetMembershipRole != null) ...[
            const SizedBox(height: 4),
            Text(
              _invitationRoleLabel(
                l10n,
                _joinPreview!.invitation!.targetMembershipRole,
              ),
              style: TextStyle(fontSize: 12, color: _txtGray),
            ),
          ],
        ] else if (_foundEnterpriseName == '') ...[
          const SizedBox(height: 6),
          Text(l10n.authJoinNotFound,
              style: TextStyle(fontSize: 12, color: _colors.error)),
        ] else ...[
          const SizedBox(height: 4),
          Text(l10n.authJoinHelp,
              style: TextStyle(fontSize: 12, color: _txtGray)),
        ],
      ],
    ]);
  }

  void _clearJoinLookup() {
    if (_foundEnterpriseName == null && _joinPreview == null) {
      return;
    }
    setState(() {
      _foundEnterpriseName = null;
      _joinPreview = null;
    });
  }

  void _showEnterpriseKeyboard() {
    if (!mounted) return;
    _enterpriseFocusNode.requestFocus();
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }

  String _invitationRoleLabel(AppLocalizations l10n, int? role) {
    return switch (role) {
      3 => l10n.authRoleAdministrator,
      2 => l10n.authRoleCustomerService,
      1 => l10n.authRoleTechnicalSupport,
      _ => l10n.authRoleMember,
    };
  }

  // ── 通用输入框 ─────────────────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: TextStyle(
              fontSize: 14, color: _txtGray, fontWeight: FontWeight.w400)),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffix,
    FocusNode? focusNode,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      keyboardType: keyboardType,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: _colors.onSurface.withValues(alpha: 0.35),
          fontSize: 15,
        ),
        errorText: errorText,
        errorMaxLines: 2,
        errorStyle: TextStyle(fontSize: 12, color: _colors.error),
        suffixIcon: suffix,
        filled: true,
        fillColor: _card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _divider)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _divider)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _primary, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _colors.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _colors.error, width: 1.5)),
      ),
    );
  }

  Widget _buildFieldError(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: _colors.error),
      ),
    );
  }

  Widget _eyeBtn(bool obscure, VoidCallback onTap) {
    return IconButton(
      icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: _txtGray,
          size: 20),
      onPressed: onTap,
    );
  }
}
