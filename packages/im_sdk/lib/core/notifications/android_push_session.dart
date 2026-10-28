import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/notifications/mobile_push_token_provider.dart';
import 'package:im_sdk/core/platform/platform_capabilities.dart';

/// Android projection of the authenticated session. It contains no credentials;
/// Auth remains the identity owner and the native adapter owns SDK delivery.
class AndroidPushSession {
  AndroidPushSession({
    MethodChannel channel = const MethodChannel('im_sdk/mobile_push'),
  }) : _channel = channel;

  final MethodChannel _channel;
  bool _authorized = false;
  int _revision = 0;

  bool get allowsPresentation => !PlatformCapabilities.isAndroid || _authorized;

  Future<void> setAuthorized(bool authorized) async {
    if (!PlatformCapabilities.isAndroid) return;
    final revision = ++_revision;
    // Fence local notifications before waiting for the platform channel.
    _authorized = false;
    await _channel.invokeMethod<void>(
      'setSessionAuthorized',
      {
        'authorized': authorized,
        'vendorPushEnabled':
            MethodChannelMobilePushTokenProvider.fromEnvironment()
                .ownsBackgroundMessageNotifications,
      },
    );
    if (revision == _revision) _authorized = authorized;
  }
}

final androidPushSessionProvider = Provider<AndroidPushSession>((ref) {
  return AndroidPushSession();
});
