import 'dart:async';

import 'package:flutter/material.dart';
import 'package:im_sdk/core/utils/validators.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

import 'im_sdk_client.dart';
import 'im_sdk_models.dart';
import 'im_sdk_presentation.dart';

enum _RegistrationAction { sendCode, register, captcha, activate }

class _CaptchaLoadFailure implements Exception {
  const _CaptchaLoadFailure();
}

/// Personal registration inside the SDK's unauthenticated navigator.
class ImSdkRegistrationPage extends StatefulWidget {
  const ImSdkRegistrationPage({super.key, required this.client});
  final ImSdkClient client;
  @override
  State<ImSdkRegistrationPage> createState() => _ImSdkRegistrationPageState();
}

class _ImSdkRegistrationPageState extends State<ImSdkRegistrationPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  final _code = TextEditingController();
  ImSdkRegistrationVerificationSettings? _settings;
  String _channel = 'sms';
  String? _error;
  _RegistrationAction? _errorAction;
  bool _busy = false;
  bool _loading = true;
  bool _created = false;
  int _countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final settings =
          await widget.client.getRegistrationVerificationSettings();
      if (!mounted) return;
      setState(() {
        _settings = settings;
        if (!settings.smsEnabled && settings.emailEnabled) _channel = 'email';
      });
    } on ImSdkException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = '注册服务暂不可用，请稍后重试');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _withCaptcha(
      Future<void> Function(String?, String?) action) async {
    try {
      await action(null, null);
    } on ImSdkException catch (error) {
      if (!error.code.contains('CAPTCHA')) rethrow;
      final ImSdkCaptchaChallenge challenge;
      try {
        challenge = await widget.client.requestLoginCaptcha();
      } catch (_) {
        throw const _CaptchaLoadFailure();
      }
      if (!mounted) return;
      final answer = await showDialog<String>(
          context: context,
          builder: (_) =>
              _RegistrationCaptchaDialog(question: challenge.question));
      if (answer == null || !mounted) return;
      await action(challenge.token, answer);
    }
  }

  Future<void> _sendCode() async {
    if (_busy || _countdown > 0) return;
    final validation = _channel == 'sms'
        ? Validators.validateMobile(_identifier.text, acceptFormatted: true)
        : Validators.validateEmail(_identifier.text);
    if (validation != null) {
      setState(() {
        _error = validation;
        _errorAction = null;
      });
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      bool sent = false;
      await _withCaptcha((token, answer) async {
        await widget.client.sendRegistrationCode(
            identifier: _identifier.text.trim(),
            channel: _channel,
            captchaToken: token,
            captchaAnswer: answer);
        sent = true;
      });
      if (!mounted || !sent) return;
      setState(() => _countdown = 60);
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() => _countdown--);
        if (_countdown <= 0) timer.cancel();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(sdkText(context, '验证码已发送'))));
    } catch (error) {
      _showFailure(error, _RegistrationAction.sendCode);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _register() async {
    if (_busy || _created || !(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      bool completed = false;
      await _withCaptcha((token, answer) async {
        await widget.client.registerWithPassword(
            displayName: _name.text.trim(),
            password: _password.text,
            channel: _channel,
            identifier: _identifier.text.trim(),
            verificationCode:
                _code.text.trim().isEmpty ? null : _code.text.trim(),
            captchaToken: token,
            captchaAnswer: answer);
        completed = true;
      });
      if (completed && mounted) {
        _password.clear();
        _confirmation.clear();
      }
    } on ImSdkException catch (error) {
      if (!mounted) {
        widget.client.discardPendingRegistrationActivation();
        return;
      }
      setState(() {
        _created = error.code == 'REGISTER_LOGIN_FAILED' ||
            error.code == 'REGISTER_PENDING_APPROVAL';
        if (_created) {
          _password.clear();
          _confirmation.clear();
        }
      });
      _showFailure(
          error,
          switch (error.code) {
            'REGISTER_PENDING_APPROVAL' => null,
            'REGISTER_LOGIN_FAILED' => _RegistrationAction.activate,
            _ => _RegistrationAction.register,
          });
    } catch (error) {
      _showFailure(error, _RegistrationAction.register);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _retryActivation() async {
    if (_busy || !widget.client.canRetryRegistrationActivation) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.client.retryRegistrationActivation();
    } catch (error) {
      _showFailure(error, _RegistrationAction.activate);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showFailure(Object error, _RegistrationAction? action) {
    if (!mounted) return;
    setState(() {
      _errorAction =
          error is _CaptchaLoadFailure ? _RegistrationAction.captcha : action;
      _error = error is ImSdkException &&
              !(action == _RegistrationAction.activate &&
                  widget.client.canRetryRegistrationActivation)
          ? error.message
          : '';
    });
  }

  String _failureText(BuildContext context, String message) {
    final details = message.isEmpty ? null : sdkErrorText(context, message);
    final l10n = AppLocalizations.of(context);
    final title = switch (_errorAction) {
      _RegistrationAction.sendCode => l10n.authSendFailed,
      _RegistrationAction.register => l10n.authRegisterErrorTitle,
      _RegistrationAction.captcha => l10n.authCaptchaFailed,
      _RegistrationAction.activate => l10n.authLoginFailed,
      null => null,
    };
    if (title == null) return details ?? l10n.commonOperationFailed;
    if (details == null || details == title) return title;
    return '$title\n$details';
  }

  @override
  void dispose() {
    if (_created) widget.client.discardPendingRegistrationActivation();
    _timer?.cancel();
    for (final controller in [
      _name,
      _identifier,
      _password,
      _confirmation,
      _code
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final available = _settings?.isEnabled(_channel) == true;
    final enabled = !_busy && !_created && available;
    final canRetry = _created && widget.client.canRetryRegistrationActivation;
    return Scaffold(
      appBar: AppBar(title: Text(sdkText(context, '注册账号'))),
      body: SafeArea(
          child: Center(
              child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(sdkText(context, '注册后即可开始聊天，无需选择空间')),
                    if (_loading)
                      Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                              child: CircularProgressIndicator(
                                  semanticsLabel: sdkText(context, '正在加载…'))))
                    else if (_settings == null)
                      TextButton(
                          onPressed: _loadSettings,
                          child: Text(sdkText(context, '重新加载注册方式')))
                    else if (!available)
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child:
                              Text(sdkText(context, '当前没有可用的注册方式，请联系应用提供方'))),
                    if (_settings != null &&
                        (_settings!.smsEnabled || _settings!.emailEnabled)) ...[
                      const SizedBox(height: 20),
                      SegmentedButton<String>(
                          segments: [
                            if (_settings!.smsEnabled)
                              ButtonSegment(
                                  value: 'sms',
                                  label: Text(sdkText(context, '手机号'))),
                            if (_settings!.emailEnabled)
                              ButtonSegment(
                                  value: 'email',
                                  label: Text(sdkText(context, '邮箱'))),
                          ],
                          selected: {
                            _channel
                          },
                          onSelectionChanged: enabled
                              ? (values) => setState(() {
                                    _channel = values.single;
                                    _identifier.clear();
                                    _code.clear();
                                    _timer?.cancel();
                                    _countdown = 0;
                                    _error = null;
                                  })
                              : null),
                      const SizedBox(height: 20),
                      TextFormField(
                          key: const ValueKey('registration.name'),
                          controller: _name,
                          enabled: enabled,
                          decoration: InputDecoration(
                              labelText: sdkText(context, '昵称'),
                              border: OutlineInputBorder()),
                          validator: (value) => value?.trim().isNotEmpty == true
                              ? null
                              : sdkText(context, '请输入昵称')),
                      const SizedBox(height: 16),
                      TextFormField(
                          key: const ValueKey('registration.identifier'),
                          controller: _identifier,
                          enabled: enabled,
                          onChanged: (_) => setState(() {
                                _code.clear();
                                _timer?.cancel();
                                _countdown = 0;
                              }),
                          keyboardType: _channel == 'sms'
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: InputDecoration(
                              labelText: sdkText(
                                  context, _channel == 'sms' ? '手机号' : '邮箱'),
                              border: const OutlineInputBorder()),
                          validator: (value) => sdkValidationText(
                              context,
                              _channel == 'sms'
                                  ? Validators.validateMobile(value ?? '',
                                      acceptFormatted: true)
                                  : Validators.validateEmail(value ?? ''))),
                      const SizedBox(height: 16),
                      TextFormField(
                          key: const ValueKey('registration.password'),
                          controller: _password,
                          enabled: enabled,
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: InputDecoration(
                              labelText: sdkText(context, '密码'),
                              border: OutlineInputBorder()),
                          validator: (value) => sdkValidationText(context,
                              Validators.validatePassword(value ?? ''))),
                      const SizedBox(height: 16),
                      TextFormField(
                          key: const ValueKey('registration.confirmation'),
                          controller: _confirmation,
                          enabled: enabled,
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: InputDecoration(
                              labelText: sdkText(context, '确认密码'),
                              border: OutlineInputBorder()),
                          validator: (value) => value == _password.text
                              ? null
                              : sdkText(context, '两次密码不一致')),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(
                            child: TextFormField(
                                key: const ValueKey('registration.code'),
                                controller: _code,
                                enabled: enabled,
                                decoration: InputDecoration(
                                    labelText: sdkText(
                                        context,
                                        _settings!.isRequired(_channel)
                                            ? '验证码'
                                            : '验证码（可选）'),
                                    border: const OutlineInputBorder()),
                                validator: (value) =>
                                    _settings!.isRequired(_channel) &&
                                            value?.trim().isNotEmpty != true
                                        ? sdkText(context, '请输入验证码')
                                        : null)),
                        const SizedBox(width: 8),
                        TextButton(
                            key: const ValueKey('registration.sendCode'),
                            onPressed:
                                enabled && _countdown == 0 ? _sendCode : null,
                            child: Text(_countdown > 0
                                ? '${_countdown}s'
                                : sdkText(context, '发送验证码')))
                      ]),
                    ],
                    if (_error != null)
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Semantics(
                              liveRegion: true,
                              child: Text(_failureText(context, _error!),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error)))),
                    const SizedBox(height: 20),
                    FilledButton(
                        key: const ValueKey('registration.submit'),
                        onPressed: canRetry
                            ? (_busy ? null : _retryActivation)
                            : (enabled ? _register : null),
                        child: Text(sdkText(
                            context,
                            _busy
                                ? '正在处理…'
                                : canRetry
                                    ? '重试'
                                    : '注册并进入聊天'))),
                    TextButton(
                        onPressed:
                            _busy ? null : () => Navigator.of(context).pop(),
                        child: Text(sdkText(context, '返回登录'))),
                  ]),
            )),
      ))),
    );
  }
}

class _RegistrationCaptchaDialog extends StatefulWidget {
  const _RegistrationCaptchaDialog({required this.question});
  final String question;
  @override
  State<_RegistrationCaptchaDialog> createState() =>
      _RegistrationCaptchaDialogState();
}

class _RegistrationCaptchaDialogState
    extends State<_RegistrationCaptchaDialog> {
  final _answer = TextEditingController();
  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
          title: Text(sdkText(context, '安全验证')),
          content: TextField(
              controller: _answer,
              autofocus: true,
              decoration: InputDecoration(labelText: widget.question),
              onSubmitted: (value) => Navigator.pop(context, value.trim())),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(sdkText(context, '取消'))),
            TextButton(
                onPressed: () => Navigator.pop(context, _answer.text.trim()),
                child: Text(sdkText(context, '确定')))
          ]);
}
