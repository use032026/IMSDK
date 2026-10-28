import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/utils/validators.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

enum _PasswordMode { currentPassword, verificationCode }

/// Shared account-security password flow for every mobile entry point.
class PasswordSettingsPage extends ConsumerStatefulWidget {
  const PasswordSettingsPage({
    super.key,
    this.initialMobile,
    this.initialEmail,
  });

  final String? initialMobile;
  final String? initialEmail;

  @override
  ConsumerState<PasswordSettingsPage> createState() =>
      _PasswordSettingsPageState();
}

class _PasswordSettingsPageState extends ConsumerState<PasswordSettingsPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _identifierController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  var _mode = _PasswordMode.currentPassword;
  late AuthVerificationChannel _verificationChannel;
  Timer? _countdownTimer;
  var _countdown = 0;
  var _sendingCode = false;
  var _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final email = widget.initialEmail?.trim() ?? '';
    final mobile = widget.initialMobile?.trim() ?? '';
    _verificationChannel = email.isNotEmpty
        ? AuthVerificationChannel.email
        : AuthVerificationChannel.sms;
    _identifierController.text = email.isNotEmpty ? email : mobile;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _identifierController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  String? _validateIdentifier() {
    final identifier = _identifierController.text.trim();
    return switch (_verificationChannel) {
      AuthVerificationChannel.email => Validators.validateEmail(identifier),
      AuthVerificationChannel.sms => Validators.validateMobile(identifier),
    };
  }

  Future<void> _sendVerificationCode(AppLocalizations l10n) async {
    if (_sendingCode || _countdown > 0) return;
    final identifierError = _validateIdentifier();
    if (identifierError != null) {
      setState(() => _error = identifierError);
      return;
    }
    setState(() {
      _sendingCode = true;
      _error = null;
    });
    try {
      await ref.read(authProvider.notifier).sendVerificationCode(
            _identifierController.text.trim(),
            _verificationChannel.apiValue,
            purpose: 'reset_password',
          );
      _startCountdown();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.authCodeSent)),
        );
      }
    } catch (error) {
      if (mounted) setState(() => _error = _errorMessage(error, l10n));
    } finally {
      if (mounted) setState(() => _sendingCode = false);
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _countdown = 60);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _countdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _countdown = 0);
        return;
      }
      setState(() => _countdown--);
    });
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (newPassword.length < 6 || newPassword != confirmPassword) {
      setState(() => _error = l10n.profileChangePasswordMismatch);
      return;
    }
    if (_mode == _PasswordMode.currentPassword &&
        _oldPasswordController.text.isEmpty) {
      setState(() => _error = l10n.profileChangePasswordOld);
      return;
    }
    if (_mode == _PasswordMode.verificationCode) {
      final identifierError = _validateIdentifier();
      if (identifierError != null) {
        setState(() => _error = identifierError);
        return;
      }
      if (_verificationCodeController.text.trim().isEmpty) {
        setState(() => _error = l10n.authErrorEmptyCode);
        return;
      }
    }

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final notifier = ref.read(authProvider.notifier);
      if (_mode == _PasswordMode.currentPassword) {
        await notifier.changePassword(
          oldPassword: _oldPasswordController.text,
          newPassword: newPassword,
        );
      } else {
        await notifier.resetPasswordByCode(
          identifier: _identifierController.text.trim(),
          verificationCode: _verificationCodeController.text.trim(),
          newPassword: newPassword,
          channel: _verificationChannel,
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileChangePasswordSuccess)),
      );
    } catch (error) {
      if (mounted) setState(() => _error = _errorMessage(error, l10n));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _errorMessage(Object error, AppLocalizations l10n) {
    return error is ServerError
        ? error.message
        : l10n.profileChangePasswordFailed;
  }

  void _selectVerificationChannel(AuthVerificationChannel channel) {
    if (_verificationChannel == channel) return;
    _countdownTimer?.cancel();
    setState(() {
      _verificationChannel = channel;
      _identifierController.text = switch (channel) {
        AuthVerificationChannel.email => widget.initialEmail ?? '',
        AuthVerificationChannel.sms => widget.initialMobile ?? '',
      };
      _verificationCodeController.clear();
      _countdown = 0;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileChangePassword)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<_PasswordMode>(
            segments: [
              ButtonSegment(
                value: _PasswordMode.currentPassword,
                label: Text(l10n.authUsePassword),
              ),
              ButtonSegment(
                value: _PasswordMode.verificationCode,
                label: Text(l10n.authUseCode),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (selection) {
              setState(() {
                _mode = selection.first;
                _error = null;
              });
            },
          ),
          const SizedBox(height: 20),
          if (_mode == _PasswordMode.currentPassword)
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l10n.profileChangePasswordOld,
                border: const OutlineInputBorder(),
              ),
            )
          else ...[
            SegmentedButton<AuthVerificationChannel>(
              segments: [
                ButtonSegment(
                  value: AuthVerificationChannel.email,
                  label: Text(l10n.authTabEmail),
                ),
                ButtonSegment(
                  value: AuthVerificationChannel.sms,
                  label: Text(l10n.authTabMobile),
                ),
              ],
              selected: {_verificationChannel},
              onSelectionChanged: (selection) =>
                  _selectVerificationChannel(selection.first),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _identifierController,
              keyboardType:
                  _verificationChannel == AuthVerificationChannel.email
                      ? TextInputType.emailAddress
                      : TextInputType.phone,
              autocorrect: false,
              autofillHints:
                  _verificationChannel == AuthVerificationChannel.email
                      ? const [AutofillHints.email]
                      : const [AutofillHints.telephoneNumber],
              decoration: InputDecoration(
                labelText: _verificationChannel == AuthVerificationChannel.email
                    ? l10n.authHintEmail
                    : l10n.authHintMobile,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _verificationCodeController,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    decoration: InputDecoration(
                      labelText: l10n.authHintCode,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: (_sendingCode || _countdown > 0)
                      ? null
                      : () => _sendVerificationCode(l10n),
                  child: Text(
                    _countdown > 0
                        ? '${_countdown}s'
                        : (_sendingCode
                            ? l10n.authSendingCode
                            : l10n.authGetCode),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: l10n.profileChangePasswordNew,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: l10n.profileChangePasswordConfirm,
              border: const OutlineInputBorder(),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Color(0xFFFF3B30))),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _submitting ? null : () => _submit(l10n),
            child: Text(_submitting
                ? l10n.authSendingCode
                : l10n.profileChangePassword),
          ),
        ],
      ),
    );
  }
}
