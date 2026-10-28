import 'dart:async';

import 'package:flutter/material.dart';
import 'package:im_sdk/core/utils/validators.dart';

import 'im_sdk_client.dart';
import 'im_sdk_models.dart';

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
      final challenge = await widget.client.requestLoginCaptcha();
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
        ? Validators.validateMobile(_identifier.text)
        : Validators.validateEmail(_identifier.text);
    if (validation != null) {
      setState(() => _error = validation);
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
          .showSnackBar(const SnackBar(content: Text('验证码已发送')));
    } on ImSdkException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = '验证码发送失败，请稍后重试');
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
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _created = error.code == 'REGISTER_LOGIN_FAILED' ||
            error.code == 'REGISTER_PENDING_APPROVAL';
        if (_created) {
          _password.clear();
          _confirmation.clear();
        }
      });
    } catch (_) {
      if (mounted) setState(() => _error = '注册未完成，请稍后重试');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
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
    return Scaffold(
      appBar: AppBar(title: const Text('注册账号')),
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
                    const Text('注册后即可开始聊天，无需选择空间'),
                    if (_loading)
                      const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()))
                    else if (_settings == null)
                      TextButton(
                          onPressed: _loadSettings,
                          child: const Text('重新加载注册方式'))
                    else if (!available)
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text('当前没有可用的注册方式，请联系应用提供方')),
                    if (_settings != null &&
                        (_settings!.smsEnabled || _settings!.emailEnabled)) ...[
                      const SizedBox(height: 20),
                      SegmentedButton<String>(
                          segments: [
                            if (_settings!.smsEnabled)
                              const ButtonSegment(
                                  value: 'sms', label: Text('手机号')),
                            if (_settings!.emailEnabled)
                              const ButtonSegment(
                                  value: 'email', label: Text('邮箱')),
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
                          decoration: const InputDecoration(
                              labelText: '昵称', border: OutlineInputBorder()),
                          validator: (value) => value?.trim().isNotEmpty == true
                              ? null
                              : '请输入昵称'),
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
                              labelText: _channel == 'sms' ? '手机号' : '邮箱',
                              border: const OutlineInputBorder()),
                          validator: (value) => _channel == 'sms'
                              ? Validators.validateMobile(value ?? '')
                              : Validators.validateEmail(value ?? '')),
                      const SizedBox(height: 16),
                      TextFormField(
                          key: const ValueKey('registration.password'),
                          controller: _password,
                          enabled: enabled,
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                              labelText: '密码', border: OutlineInputBorder()),
                          validator: (value) =>
                              Validators.validatePassword(value ?? '')),
                      const SizedBox(height: 16),
                      TextFormField(
                          key: const ValueKey('registration.confirmation'),
                          controller: _confirmation,
                          enabled: enabled,
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                              labelText: '确认密码', border: OutlineInputBorder()),
                          validator: (value) =>
                              value == _password.text ? null : '两次密码不一致'),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(
                            child: TextFormField(
                                key: const ValueKey('registration.code'),
                                controller: _code,
                                enabled: enabled,
                                decoration: InputDecoration(
                                    labelText: _settings!.isRequired(_channel)
                                        ? '验证码'
                                        : '验证码（可选）',
                                    border: const OutlineInputBorder()),
                                validator: (value) =>
                                    _settings!.isRequired(_channel) &&
                                            value?.trim().isNotEmpty != true
                                        ? '请输入验证码'
                                        : null)),
                        const SizedBox(width: 8),
                        TextButton(
                            key: const ValueKey('registration.sendCode'),
                            onPressed:
                                enabled && _countdown == 0 ? _sendCode : null,
                            child: Text(
                                _countdown > 0 ? '${_countdown}s' : '发送验证码'))
                      ]),
                    ],
                    if (_error != null)
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Semantics(
                              liveRegion: true,
                              child: Text(_error!,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error)))),
                    const SizedBox(height: 20),
                    FilledButton(
                        key: const ValueKey('registration.submit'),
                        onPressed: enabled ? _register : null,
                        child: Text(_busy ? '正在处理…' : '注册并进入聊天')),
                    TextButton(
                        onPressed:
                            _busy ? null : () => Navigator.of(context).pop(),
                        child: const Text('返回登录')),
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
          title: const Text('安全验证'),
          content: TextField(
              controller: _answer,
              autofocus: true,
              decoration: InputDecoration(labelText: widget.question),
              onSubmitted: (value) => Navigator.pop(context, value.trim())),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消')),
            TextButton(
                onPressed: () => Navigator.pop(context, _answer.text.trim()),
                child: const Text('确定'))
          ]);
}
