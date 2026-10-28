import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:im_sdk/core/notifications/push_device_registration_service.dart';
import 'package:im_sdk/core/platform/platform_capabilities.dart';

const _mobilePushChannelName = 'im_sdk/mobile_push';
const _mobilePushEventsChannelName = 'im_sdk/mobile_push_events';
const _mobilePushNotificationEventsChannelName =
    'im_sdk/mobile_push_notification_events';

enum MobilePushProvider {
  disabled,
  jpush,
  oppo;

  static MobilePushProvider parse(String value) {
    return switch (value.trim().toLowerCase()) {
      'jpush' || 'jiguang' || '极光' => MobilePushProvider.jpush,
      'oppo' || 'heytap' => MobilePushProvider.oppo,
      _ => MobilePushProvider.disabled,
    };
  }
}

@immutable
class MobilePushRuntimeConfiguration {
  const MobilePushRuntimeConfiguration({
    required this.enabled,
    required this.provider,
  });

  factory MobilePushRuntimeConfiguration.resolve({
    required bool isIOS,
    bool? enabledOverride,
    String? providerOverride,
  }) {
    final configuredProvider = providerOverride?.trim() ?? '';
    final provider = configuredProvider.isEmpty && isIOS
        ? MobilePushProvider.jpush
        : MobilePushProvider.parse(configuredProvider);
    final requestedEnabled =
        enabledOverride ?? (isIOS && provider == MobilePushProvider.jpush);
    return MobilePushRuntimeConfiguration(
      enabled: requestedEnabled && provider != MobilePushProvider.disabled,
      provider: provider,
    );
  }

  final bool enabled;
  final MobilePushProvider provider;
}

class MobilePushToken {
  const MobilePushToken({
    required this.channel,
    required this.token,
    this.region,
  });

  final PushChannel channel;
  final String token;
  final String? region;
}

class MobilePushNotificationOpen {
  const MobilePushNotificationOpen(this.data);

  final Map<String, dynamic> data;
}

abstract interface class MobilePushTokenProvider {
  /// Whether this native adapter owns background and killed-process message
  /// notifications for the current build.
  bool get ownsBackgroundMessageNotifications;

  Future<MobilePushToken?> requestToken();

  Stream<MobilePushToken> get tokenChanges;
}

abstract interface class MobilePushNotificationOpenProvider {
  Future<MobilePushNotificationOpen?> takeInitialOpen();

  Stream<MobilePushNotificationOpen> get opens;
}

class DisabledMobilePushTokenProvider implements MobilePushTokenProvider {
  const DisabledMobilePushTokenProvider();

  @override
  bool get ownsBackgroundMessageNotifications => false;

  @override
  Future<MobilePushToken?> requestToken() async => null;

  @override
  Stream<MobilePushToken> get tokenChanges => const Stream.empty();
}

class DisabledMobilePushNotificationOpenProvider
    implements MobilePushNotificationOpenProvider {
  const DisabledMobilePushNotificationOpenProvider();

  @override
  Future<MobilePushNotificationOpen?> takeInitialOpen() async => null;

  @override
  Stream<MobilePushNotificationOpen> get opens => const Stream.empty();
}

class MethodChannelMobilePushTokenProvider implements MobilePushTokenProvider {
  const MethodChannelMobilePushTokenProvider({
    required this.enabled,
    this.provider = MobilePushProvider.disabled,
    this.channel = const MethodChannel(_mobilePushChannelName),
    this.events = const EventChannel(_mobilePushEventsChannelName),
  });

  factory MethodChannelMobilePushTokenProvider.fromEnvironment() {
    const hasEnabledOverride = bool.hasEnvironment(
      'MOBILE_VENDOR_PUSH_ENABLED',
    );
    const enabledOverride = bool.fromEnvironment(
      'MOBILE_VENDOR_PUSH_ENABLED',
    );
    const providerOverride = String.fromEnvironment(
      'MOBILE_VENDOR_PUSH_PROVIDER',
    );
    final configuration = MobilePushRuntimeConfiguration.resolve(
      isIOS: PlatformCapabilities.isIOS,
      enabledOverride: hasEnabledOverride ? enabledOverride : null,
      providerOverride: providerOverride,
    );
    return MethodChannelMobilePushTokenProvider(
      enabled: configuration.enabled,
      provider: configuration.provider,
    );
  }

  final bool enabled;
  final MobilePushProvider provider;
  final MethodChannel channel;
  final EventChannel events;

  @override
  bool get ownsBackgroundMessageNotifications =>
      enabled &&
      provider != MobilePushProvider.disabled &&
      PlatformCapabilities.supportsMobilePush;

  @override
  Future<MobilePushToken?> requestToken() async {
    if (!enabled || provider == MobilePushProvider.disabled) return null;
    if (!PlatformCapabilities.supportsMobilePush) return null;
    try {
      final available = await channel.invokeMethod<bool>(
            'isAvailable',
            {'provider': provider.name},
          ) ??
          false;
      if (!available) return null;
      final raw = await channel.invokeMapMethod<String, dynamic>(
        'requestToken',
        {'provider': provider.name},
      );
      if (raw == null) return null;
      final rawProvider = (raw['provider'] as String?)?.trim();
      if (rawProvider != null &&
          rawProvider.isNotEmpty &&
          MobilePushProvider.parse(rawProvider) != provider) {
        return null;
      }
      return _tokenFromRaw(raw);
    } on MissingPluginException {
      return null;
    } catch (error) {
      debugPrint('[MobilePush] token request failed: $error');
      return null;
    }
  }

  @override
  Stream<MobilePushToken> get tokenChanges {
    if (!enabled || provider == MobilePushProvider.disabled) {
      return const Stream.empty();
    }
    if (!PlatformCapabilities.supportsMobilePush) {
      return const Stream.empty();
    }
    return events
        .receiveBroadcastStream({'provider': provider.name})
        .asyncMap(
          (event) {
            final raw = event is Map
                ? Map<String, dynamic>.from(event)
                : <String, dynamic>{};
            return _tokenFromRaw(raw);
          },
        )
        .where((token) => token != null)
        .cast<MobilePushToken>();
  }

  MobilePushToken? _tokenFromRaw(Map<String, dynamic> raw) {
    final rawProvider = (raw['provider'] as String?)?.trim();
    if (rawProvider != null &&
        rawProvider.isNotEmpty &&
        MobilePushProvider.parse(rawProvider) != provider) {
      return null;
    }
    final token = (raw['token'] as String?)?.trim();
    if (token == null || token.isEmpty) return null;
    return MobilePushToken(
      channel: _channelForProvider(provider),
      token: token,
      region: (raw['region'] as String?)?.trim(),
    );
  }

  PushChannel _channelForProvider(MobilePushProvider provider) {
    return switch (provider) {
      MobilePushProvider.jpush => PushChannel.jpush,
      MobilePushProvider.oppo => PushChannel.oppo,
      MobilePushProvider.disabled => PushChannel.jpush,
    };
  }
}

class MethodChannelMobilePushNotificationOpenProvider
    implements MobilePushNotificationOpenProvider {
  const MethodChannelMobilePushNotificationOpenProvider({
    this.channel = const MethodChannel(_mobilePushChannelName),
    this.events = const EventChannel(_mobilePushNotificationEventsChannelName),
  });

  final MethodChannel channel;
  final EventChannel events;

  @override
  Future<MobilePushNotificationOpen?> takeInitialOpen() async {
    if (!PlatformCapabilities.supportsMobilePush) return null;
    try {
      final raw = await channel.invokeMapMethod<String, dynamic>(
        'consumeInitialNotificationOpen',
      );
      if (raw == null || raw.isEmpty) return null;
      return MobilePushNotificationOpen(Map<String, dynamic>.from(raw));
    } on MissingPluginException {
      return null;
    } catch (error) {
      debugPrint('[MobilePush] initial notification open failed: $error');
      return null;
    }
  }

  @override
  Stream<MobilePushNotificationOpen> get opens {
    if (!PlatformCapabilities.supportsMobilePush) {
      return const Stream.empty();
    }
    return events.receiveBroadcastStream().map((event) {
      final raw =
          event is Map ? Map<String, dynamic>.from(event) : <String, dynamic>{};
      return MobilePushNotificationOpen(raw);
    }).where((open) => open.data.isNotEmpty);
  }
}
