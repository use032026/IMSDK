import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _privacyConsentChannelName = 'im_sdk/privacy_consent';

enum PrivacyConsentDecision {
  undecided,
  accepted,
  declined;

  bool get allowsPushRuntime => this == PrivacyConsentDecision.accepted;
}

/// Native persistence boundary for the current privacy-policy decision.
abstract interface class PrivacyConsentStore {
  Future<PrivacyConsentDecision> currentPolicyDecision();

  Future<void> acceptCurrentPolicy();

  Future<void> declineCurrentPolicy();
}

class PlatformPrivacyConsentStore implements PrivacyConsentStore {
  const PlatformPrivacyConsentStore({
    MethodChannel channel = const MethodChannel(_privacyConsentChannelName),
  }) : _channel = channel;

  final MethodChannel _channel;

  @override
  Future<PrivacyConsentDecision> currentPolicyDecision() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return PrivacyConsentDecision.accepted;
    }
    try {
      final value = await _channel.invokeMethod<String>(
        'currentPolicyDecision',
      );
      return PrivacyConsentDecision.values.firstWhere(
        (decision) => decision.name == value,
        orElse: () => PrivacyConsentDecision.undecided,
      );
    } on MissingPluginException {
      return PrivacyConsentDecision.undecided;
    } on PlatformException {
      return PrivacyConsentDecision.undecided;
    }
  }

  @override
  Future<void> acceptCurrentPolicy() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    await _channel.invokeMethod<void>('acceptCurrentPolicy');
  }

  @override
  Future<void> declineCurrentPolicy() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    await _channel.invokeMethod<void>('declineCurrentPolicy');
  }

  /// Finishes and removes the Android task after a declined decision has
  /// already been persisted. Other platforms retain their existing behavior.
  Future<void> finishAndRemoveAndroidTask() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod<void>('finishAndRemoveTask');
  }
}

/// Runtime owner for privacy consent. The bootstrap creates exactly one
/// instance and overrides this provider for the authorized application tree.
class PrivacyConsentController extends StateNotifier<PrivacyConsentDecision> {
  PrivacyConsentController(this._store)
      : super(PrivacyConsentDecision.undecided);

  final PrivacyConsentStore _store;

  Future<PrivacyConsentDecision> load() async {
    final decision = await _store.currentPolicyDecision();
    state = decision;
    return decision;
  }

  Future<void> accept() async {
    await _store.acceptCurrentPolicy();
    state = PrivacyConsentDecision.accepted;
  }

  Future<void> decline() async {
    await _store.declineCurrentPolicy();
    state = PrivacyConsentDecision.declined;
  }
}

final privacyConsentControllerProvider =
    StateNotifierProvider<PrivacyConsentController, PrivacyConsentDecision>(
  (ref) => throw StateError(
    'privacyConsentControllerProvider must be overridden by bootstrap',
  ),
);
