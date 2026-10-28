import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/localization/notification_text_resolver.dart';
import 'package:im_sdk/core/notifications/mobile_push_token_provider.dart';
import 'package:im_sdk/core/notifications/push_notification_payload.dart';
import 'package:im_sdk/core/platform/platform_capabilities.dart';

const _startupRoutePath = '/startup';
const _messageScenarioType = 'message';
const _callScenarioType = 'call';
const _friendRequestResultScenarioType = 'friend_request_result';
const _groupConversationType = 'group';
const _directConversationType = 'direct';
const _audioMediaType = 'audio';
const _mentionMeType = 'me';
const _mentionAllType = 'all';
const _disabledPreviewCode = <String>{'false', '0', 'no'};

typedef CallFullScreenPermissionRequester = Future<bool?> Function();

/// Activates a push notification's target space before navigation.
///
/// Returns `false` when the target is not part of the current authenticated
/// account or cannot be safely restored.
typedef PushSpaceActivator = Future<bool> Function(String spaceId);
typedef ActiveAccountScopeKeyGetter = String? Function();
typedef NotificationLocaleGetter = Locale Function();
typedef NotificationRouteReadiness = Future<void> Function();

enum LocalNotificationAuthorizationStatus {
  enabled,
  disabled,
  unknown,
  unsupported,
}

class ResolvedNotificationPresentation {
  const ResolvedNotificationPresentation({
    required this.title,
    required this.body,
    required this.channel,
  });

  final String title;
  final String body;
  final NotificationChannelText channel;
}

/// Cross-platform notification coordinator.
///
/// Desktop builds must not import Firebase/JPush Flutter plugins. While the app
/// process is alive, Gateway events surface important messages through system
/// local notifications. Offline/killed-process delivery stays behind a
/// mobile-only native push adapter.
class PushNotificationService {
  static const String messageChannelId = 'lpp_messages';
  static const String callChannelId = 'lpp_calls';
  static const String securityChannelId = 'lpp_security';
  static const Duration _localNotificationDedupeWindow = Duration(seconds: 5);

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final Map<int, DateTime> _recentLocalNotificationIds = {};
  static bool _localNotificationsReady = false;

  final MobilePushNotificationOpenProvider _mobilePushNotificationOpenProvider;
  final ActiveAccountScopeKeyGetter? _activeAccountScopeKeyGetter;
  final NotificationLocaleGetter _localeGetter;
  final NotificationTextResolver _textResolver;
  final bool _pushRuntimeAllowed;
  final bool Function()? _presentationAllowed;
  final NotificationRouteReadiness? _notificationRouteReadiness;

  bool _initialized = false;
  bool _handledInitialLocalNotification = false;
  bool _handledInitialMobilePushOpen = false;
  StreamSubscription<MobilePushNotificationOpen>? _notificationOpenSubscription;
  GoRouter? _router;
  PushSpaceActivator? _spaceActivator;

  PushNotificationService({
    MobilePushNotificationOpenProvider mobilePushNotificationOpenProvider =
        const DisabledMobilePushNotificationOpenProvider(),
    ActiveAccountScopeKeyGetter? activeAccountScopeKeyGetter,
    NotificationLocaleGetter? localeGetter,
    NotificationTextResolver textResolver = const NotificationTextResolver(),
    bool pushRuntimeAllowed = true,
    bool Function()? presentationAllowed,
    NotificationRouteReadiness? notificationRouteReadiness,
  })  : _mobilePushNotificationOpenProvider =
            mobilePushNotificationOpenProvider,
        _activeAccountScopeKeyGetter = activeAccountScopeKeyGetter,
        _localeGetter = localeGetter ?? _platformLocale,
        _textResolver = textResolver,
        _pushRuntimeAllowed = pushRuntimeAllowed,
        _presentationAllowed = presentationAllowed,
        _notificationRouteReadiness = notificationRouteReadiness;

  static Locale _platformLocale() =>
      WidgetsBinding.instance.platformDispatcher.locale;

  NotificationText get _text => _textResolver.resolve(_localeGetter());

  static void registerBackgroundHandler() {
    if (PlatformCapabilities.supportsMobilePush) {
      debugPrint(
        '[PushNotification] mobile native push adapter is not bundled in this '
        'desktop-safe build',
      );
    }
  }

  static Future<bool> ensureFirebaseReady() async {
    return false;
  }

  Future<void> initialize({GoRouter? router}) async {
    if (!_pushRuntimeAllowed) return;
    _router = router ?? _router;
    if (_initialized) return;
    _initialized = true;

    try {
      await _ensureLocalNotificationsInitialized(
        _handleNotificationTap,
        text: _text,
      );
      final permission = await requestLocalNotificationPermission();
      AppDiagnostics.instance.info(
        'notification.authorization',
        'initialized',
        context: {'status': permission.name},
      );
    } catch (error) {
      // Local-notification setup must not prevent the native push token,
      // notification-open observers, or device registration from starting.
      AppDiagnostics.instance.warning(
        'notification.authorization',
        'initialization_failed',
        context: {'error': error.toString()},
      );
    }
    await _handleInitialLocalNotification();
    startMobilePushNotificationOpenObserver();
    await _handleInitialMobilePushNotificationOpen();
  }

  void startMobilePushNotificationOpenObserver() {
    _notificationOpenSubscription ??=
        _mobilePushNotificationOpenProvider.opens.listen(
      (open) => unawaited(handleMobilePushNotificationOpen(open)),
    );
  }

  /// Registers the application-layer owner responsible for authenticated space
  /// switching. Push parsing stays in this runtime service; token exchange and
  /// context activation remain owned by the space feature.
  void setSpaceActivator(PushSpaceActivator spaceActivator) {
    _spaceActivator = spaceActivator;
  }

  Future<void> dispose() async {
    await _notificationOpenSubscription?.cancel();
    _notificationOpenSubscription = null;
  }

  @visibleForTesting
  void setRouterForTesting(GoRouter router) {
    _router = router;
  }

  @visibleForTesting
  bool get initializedForTesting => _initialized;

  @visibleForTesting
  ResolvedNotificationPresentation resolvePresentationForTesting(
    Map<String, dynamic> data,
  ) {
    return _resolvePresentation(PushNotificationPayload.fromVendorData(data));
  }

  Future<void> handleMobilePushNotificationOpen(
    MobilePushNotificationOpen open, {
    bool initialLaunch = false,
  }) async {
    if (initialLaunch) {
      await _waitForStartupRouteToSettle();
    }
    final payload = PushNotificationPayload.fromVendorData(open.data);
    await _routePayload(
      payload,
      requireTargetSpace: payload.requiresTargetSpace,
      requireAccountScope: false,
    );
  }

  Future<void> _handleInitialMobilePushNotificationOpen() async {
    if (_handledInitialMobilePushOpen) return;
    _handledInitialMobilePushOpen = true;
    try {
      final open = await _mobilePushNotificationOpenProvider.takeInitialOpen();
      if (open == null) return;
      Future<void>.delayed(
        const Duration(milliseconds: 300),
        () => unawaited(
          handleMobilePushNotificationOpen(open, initialLaunch: true),
        ),
      );
    } catch (e) {
      debugPrint(
        '[PushNotification] get initial mobile push open failed: $e',
      );
    }
  }

  Future<void> _waitForStartupRouteToSettle() async {
    final router = _router;
    if (router == null) return;
    final deadline = DateTime.now().add(const Duration(milliseconds: 3500));
    while (
        router.routeInformationProvider.value.uri.path == _startupRoutePath &&
            DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }

  static bool get supportsGatewayLocalMessageNotification =>
      PlatformCapabilities.isMobile || PlatformCapabilities.isDesktop;

  Future<void> showGatewayMessageNotification({
    required String accountScopeKey,
    required String conversationId,
    required bool isGroup,
    required String messageId,
    required String messageType,
    String? title,
    String? body,
    String? peerUserId,
    String? mentionKind,
    String? senderDisplayName,
    bool previewEnabled = true,
    bool playSound = true,
    bool enableVibration = true,
    String? customerServiceThreadType,
    String? customerServiceThreadId,
  }) async {
    if (!supportsGatewayLocalMessageNotification) return;
    await _showDataNotification({
      'accountScopeKey': accountScopeKey,
      'scenario': _messageScenarioType,
      'conversationId': conversationId,
      'conversationType':
          isGroup ? _groupConversationType : _directConversationType,
      'messageId': messageId,
      'messageType': messageType,
      if (title != null && title.isNotEmpty) 'title': title,
      if (body != null && body.isNotEmpty) 'body': body,
      if (peerUserId != null && peerUserId.isNotEmpty) 'peerUserId': peerUserId,
      if (mentionKind != null && mentionKind.isNotEmpty)
        'mentionKind': mentionKind,
      if (senderDisplayName != null && senderDisplayName.isNotEmpty)
        'senderDisplayName': senderDisplayName,
      'previewEnabled': previewEnabled,
      if (customerServiceThreadType != null &&
          customerServiceThreadType.isNotEmpty)
        'threadType': customerServiceThreadType,
      if (customerServiceThreadId != null && customerServiceThreadId.isNotEmpty)
        'threadId': customerServiceThreadId,
    }, playSound: playSound, enableVibration: enableVibration);
  }

  Future<void> showIncomingCallNotification({
    required String accountScopeKey,
    required String callId,
    required String callerUserId,
    required String callerDisplayName,
    required String relayUrl,
    required String mediaMode,
    String? callerAvatarUrl,
  }) async {
    final isVideo = _isVideoMediaMode(mediaMode);
    await _showDataNotification({
      'accountScopeKey': accountScopeKey,
      'scenario': _callScenarioType,
      'callId': callId,
      'callerUserId': callerUserId,
      'callerDisplayName': callerDisplayName,
      'callerAvatarUrl': callerAvatarUrl,
      'relayUrl': relayUrl,
      'mediaMode': mediaMode,
      'title': _text.callTitle(isVideo: isVideo),
      'body': _text.callBody(isVideo: isVideo, caller: callerDisplayName),
    });
  }

  Future<void> showGatewayPushNotice(
    Map<String, dynamic> data, {
    required String accountScopeKey,
  }) async {
    final payload = PushNotificationPayload.fromPushNotice({
      ...data,
      'accountScopeKey': accountScopeKey,
    });
    // Chat messages are owned by msg.new, which has conversation mute,
    // active-conversation and user-preference context. push.notice only owns
    // non-chat alerts such as account security notices.
    if (payload.isMessage) return;
    await _showPayloadNotification(payload);
  }

  Map<String, dynamic> friendRequestResultData({
    required String requestId,
    required String status,
    required String spaceId,
    String? accountScopeKey,
  }) {
    final normalizedStatus = status.trim().toLowerCase();
    final accepted = normalizedStatus == 'accepted';
    return <String, dynamic>{
      'scenario': _friendRequestResultScenarioType,
      if (accountScopeKey != null && accountScopeKey.isNotEmpty)
        'accountScopeKey': accountScopeKey,
      'requestId': requestId,
      'status': normalizedStatus,
      if (spaceId.trim().isNotEmpty) 'tenantId': spaceId.trim(),
      'route': '/new-friends',
      'title': _text.friendRequestTitle(accepted: accepted),
      'body': _text.friendRequestBody(accepted: accepted),
    };
  }

  Future<void> showFriendRequestResultNotification({
    required String accountScopeKey,
    required String requestId,
    required String status,
    required String spaceId,
  }) {
    return _showDataNotification(
      friendRequestResultData(
        requestId: requestId,
        status: status,
        spaceId: spaceId,
        accountScopeKey: accountScopeKey,
      ),
    );
  }

  Future<void> _showDataNotification(
    Map<String, dynamic> data, {
    bool playSound = true,
    bool enableVibration = true,
  }) async {
    await _showPayloadNotification(
      PushNotificationPayload.fromVendorData(data),
      playSound: playSound,
      enableVibration: enableVibration,
    );
  }

  Future<void> _showPayloadNotification(
    PushNotificationPayload payload, {
    bool playSound = true,
    bool enableVibration = true,
  }) async {
    if (!_canPresent(payload)) return;
    await _ensureLocalNotificationsInitialized(null, text: _text);
    if (!_canPresent(payload)) return;
    final presentation = _resolvePresentation(payload);
    final androidChannelId = payload.isCall
        ? callChannelId
        : payload.isSecurity
            ? securityChannelId
            : messageChannelId;
    final channel = presentation.channel;
    final importance =
        payload.isCall || payload.isSecurity ? Importance.max : Importance.high;
    final priority =
        payload.isCall || payload.isSecurity ? Priority.max : Priority.high;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        androidChannelId,
        channel.name,
        channelDescription: channel.description,
        importance: importance,
        priority: priority,
        category: payload.isCall
            ? AndroidNotificationCategory.call
            : payload.isSecurity
                ? AndroidNotificationCategory.status
                : AndroidNotificationCategory.message,
        fullScreenIntent: payload.isCall,
        autoCancel: !payload.isCall,
        ongoing: false,
        visibility: NotificationVisibility.public,
        playSound: playSound,
        enableVibration: enableVibration,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: playSound,
        interruptionLevel: payload.isCall || payload.isSecurity
            ? InterruptionLevel.timeSensitive
            : InterruptionLevel.active,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: playSound,
        interruptionLevel: payload.isCall || payload.isSecurity
            ? InterruptionLevel.timeSensitive
            : InterruptionLevel.active,
      ),
    );

    final notificationId = payload.stableNotificationId();
    if (!_claimLocalNotificationId(notificationId)) return;

    await _localNotifications.show(
      id: notificationId,
      title: presentation.title,
      body: presentation.body,
      notificationDetails: details,
      payload: jsonEncode(payload.data),
    );
    AppDiagnostics.instance.info(
      'notification.local',
      'show_succeeded',
      context: {
        'scenario': payload.scenario.name,
        'notificationId': notificationId,
      },
    );
  }

  bool _canPresent(PushNotificationPayload payload) {
    if (!_pushRuntimeAllowed || _presentationAllowed?.call() == false) {
      return false;
    }
    if (!PlatformCapabilities.isAndroid ||
        _activeAccountScopeKeyGetter == null) {
      return true;
    }
    final activeScope = _activeAccountScopeKeyGetter();
    return activeScope != null &&
        activeScope.isNotEmpty &&
        payload.stringValue(const ['accountScopeKey']) == activeScope;
  }

  ResolvedNotificationPresentation _resolvePresentation(
    PushNotificationPayload payload,
  ) {
    final previewValue = payload.stringValue(const ['previewEnabled']);
    final previewDisabled = payload.isMessage &&
        _disabledPreviewCode.contains(previewValue?.toLowerCase());
    final rawBody = previewDisabled
        ? _text.newMessageBody
        : payload.body ?? _fallbackBody(payload);
    return ResolvedNotificationPresentation(
      title: payload.title ?? _fallbackTitle(payload),
      body: payload.isCall || payload.isSecurity || previewDisabled
          ? rawBody
          : _mentionAwareBody(payload, rawBody),
      channel: payload.isCall
          ? _text.callChannel
          : payload.isSecurity
              ? _text.securityChannel
              : _text.messageChannel,
    );
  }

  static bool _claimLocalNotificationId(int notificationId) {
    final now = DateTime.now();
    _recentLocalNotificationIds.removeWhere(
      (_, shownAt) => now.difference(shownAt) > _localNotificationDedupeWindow,
    );
    final recent = _recentLocalNotificationIds[notificationId];
    if (recent != null &&
        now.difference(recent) <= _localNotificationDedupeWindow) {
      return false;
    }
    _recentLocalNotificationIds[notificationId] = now;
    return true;
  }

  static Future<void> _ensureLocalNotificationsInitialized(
      DidReceiveNotificationResponseCallback? onTap,
      {NotificationText? text}) async {
    if (_localNotificationsReady) return;
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );
    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTap,
    );

    await _createAndroidChannels(
      text ?? const NotificationTextResolver().resolve(_platformLocale()),
    );
    _localNotificationsReady = true;
  }

  static Future<void> _createAndroidChannels(NotificationText text) async {
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final messageChannel = text.messageChannel;
    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        messageChannelId,
        messageChannel.name,
        description: messageChannel.description,
        importance: Importance.high,
      ),
    );
    final callChannel = text.callChannel;
    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        callChannelId,
        callChannel.name,
        description: callChannel.description,
        importance: Importance.max,
        audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
      ),
    );
    final securityChannel = text.securityChannel;
    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        securityChannelId,
        securityChannel.name,
        description: securityChannel.description,
        importance: Importance.max,
      ),
    );
  }

  Future<void> refreshLocalizedChannels() async {
    if (!_pushRuntimeAllowed) return;
    await _ensureLocalNotificationsInitialized(null, text: _text);
    await _createAndroidChannels(_text);
  }

  static Future<LocalNotificationAuthorizationStatus>
      requestLocalNotificationPermission() async {
    try {
      await _ensureLocalNotificationsInitialized(null);
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        return granted == true
            ? LocalNotificationAuthorizationStatus.enabled
            : granted == false
                ? LocalNotificationAuthorizationStatus.disabled
                : await localNotificationAuthorizationStatus();
      }

      final iosPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
            alert: true, badge: true, sound: true);
        return granted == true
            ? LocalNotificationAuthorizationStatus.enabled
            : granted == false
                ? LocalNotificationAuthorizationStatus.disabled
                : await localNotificationAuthorizationStatus();
      }

      final macPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>();
      if (macPlugin != null) {
        final granted = await macPlugin.requestPermissions(
            alert: true, badge: true, sound: true);
        return granted == true
            ? LocalNotificationAuthorizationStatus.enabled
            : granted == false
                ? LocalNotificationAuthorizationStatus.disabled
                : await localNotificationAuthorizationStatus();
      }
      return LocalNotificationAuthorizationStatus.unsupported;
    } catch (error) {
      AppDiagnostics.instance.warning(
        'notification.authorization',
        'request_failed',
        context: {'error': error.toString()},
      );
      return LocalNotificationAuthorizationStatus.unknown;
    }
  }

  static Future<bool?> requestCallFullScreenPermission({
    CallFullScreenPermissionRequester? requester,
  }) async {
    if (!PlatformCapabilities.isAndroid) return null;
    final request = requester ??
        () async {
          await _ensureLocalNotificationsInitialized(null);
          final plugin =
              _localNotifications.resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
          return plugin?.requestFullScreenIntentPermission();
        };
    try {
      return await request();
    } catch (error) {
      AppDiagnostics.instance.warning(
        'notification.call_full_screen_authorization',
        'request_failed',
        context: {'error': error.toString()},
      );
      return false;
    }
  }

  static Future<LocalNotificationAuthorizationStatus>
      localNotificationAuthorizationStatus() async {
    try {
      await _ensureLocalNotificationsInitialized(null);
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final enabled = await androidPlugin.areNotificationsEnabled();
        if (enabled == false) {
          return LocalNotificationAuthorizationStatus.disabled;
        }
        final channels = await androidPlugin.getNotificationChannels();
        final messageChannel = channels
            ?.where((channel) => channel.id == messageChannelId)
            .firstOrNull;
        if (messageChannel?.importance == Importance.none) {
          return LocalNotificationAuthorizationStatus.disabled;
        }
        return enabled == true
            ? LocalNotificationAuthorizationStatus.enabled
            : LocalNotificationAuthorizationStatus.unknown;
      }

      final iosPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final iosPermissions = await iosPlugin?.checkPermissions();
      if (iosPermissions != null) {
        return iosPermissions.isEnabled || iosPermissions.isProvisionalEnabled
            ? LocalNotificationAuthorizationStatus.enabled
            : LocalNotificationAuthorizationStatus.disabled;
      }

      final macPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>();
      final macPermissions = await macPlugin?.checkPermissions();
      if (macPermissions != null) {
        return macPermissions.isEnabled || macPermissions.isProvisionalEnabled
            ? LocalNotificationAuthorizationStatus.enabled
            : LocalNotificationAuthorizationStatus.disabled;
      }
      return LocalNotificationAuthorizationStatus.unsupported;
    } catch (error) {
      AppDiagnostics.instance.warning(
        'notification.authorization',
        'status_check_failed',
        context: {'error': error.toString()},
      );
      return LocalNotificationAuthorizationStatus.unknown;
    }
  }

  void _handleNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = Map<String, dynamic>.from(jsonDecode(payload) as Map);
      unawaited(_routeData(data));
    } catch (e) {
      debugPrint('[PushNotification] parse notification payload failed: $e');
    }
  }

  Future<void> _handleInitialLocalNotification() async {
    if (_handledInitialLocalNotification) return;
    _handledInitialLocalNotification = true;
    try {
      final launchDetails =
          await _localNotifications.getNotificationAppLaunchDetails();
      final response = launchDetails?.notificationResponse;
      if (launchDetails?.didNotificationLaunchApp == true && response != null) {
        Future<void>.delayed(
          const Duration(milliseconds: 300),
          () => _handleNotificationTap(response),
        );
      }
    } catch (e) {
      debugPrint(
          '[PushNotification] get initial local notification failed: $e');
    }
  }

  Future<void> _routeData(
    Map<String, dynamic> data, {
    bool requireTargetSpace = false,
  }) async {
    await _routePayload(
      PushNotificationPayload.fromVendorData(data),
      requireTargetSpace: requireTargetSpace,
      requireAccountScope: true,
    );
  }

  Future<void> _routePayload(
    PushNotificationPayload payload, {
    bool requireTargetSpace = false,
    required bool requireAccountScope,
  }) async {
    await _notificationRouteReadiness?.call();
    final activeScopeGetter = _activeAccountScopeKeyGetter;
    if (activeScopeGetter != null) {
      final activeScopeKey = activeScopeGetter()?.trim();
      final payloadScopeKey =
          payload.stringValue(const ['accountScopeKey'])?.trim();
      if (activeScopeKey == null ||
          activeScopeKey.isEmpty ||
          (requireAccountScope &&
              (payloadScopeKey == null || payloadScopeKey.isEmpty)) ||
          (payloadScopeKey != null &&
              payloadScopeKey.isNotEmpty &&
              payloadScopeKey != activeScopeKey)) {
        debugPrint(
          '[PushNotification] skip notification navigation: '
          'account scope is missing or stale',
        );
        return;
      }
    }
    final router = _router;
    if (router == null) return;
    final targetSpaceId = payload.targetSpaceId;
    if (requireTargetSpace &&
        (targetSpaceId == null || targetSpaceId.isEmpty)) {
      debugPrint(
        '[PushNotification] skip notification navigation: '
        'target space is missing',
      );
      return;
    }
    if (targetSpaceId != null && targetSpaceId.isNotEmpty) {
      final spaceActivator = _spaceActivator;
      if (spaceActivator == null) {
        debugPrint(
          '[PushNotification] skip notification navigation: '
          'no space activator configured for $targetSpaceId',
        );
        return;
      }
      final activated = await spaceActivator(targetSpaceId);
      if (!activated) {
        debugPrint(
          '[PushNotification] skip notification navigation: '
          'target space is unavailable',
        );
        return;
      }
    }
    if (payload.isSecurity) {
      const securityPath = '/settings/account';
      if (router.routeInformationProvider.value.uri.path == securityPath) {
        return;
      }
      router.push(securityPath);
      return;
    }
    if (payload.scenario == PushNotificationScenario.friendRequest) {
      const friendRequestsPath = '/new-friends';
      if (router.routeInformationProvider.value.uri.path ==
          friendRequestsPath) {
        return;
      }
      router.push(friendRequestsPath);
      return;
    }
    if (payload.isCall) {
      final callId = payload.callId;
      if (callId == null || callId.isEmpty) return;
      unawaited(_cancelLocalNotification(payload.stableNotificationId()));
      final mediaMode = payload.mediaMode ?? _audioMediaType;
      final callPath = '/call/$callId';
      if (router.routeInformationProvider.value.uri.path == callPath) {
        return;
      }
      router.push('/call/$callId', extra: {
        'incomingPush': true,
        'isVideo': _isVideoMediaMode(mediaMode),
        'title': payload.stringValue(const [
              'callerDisplayName',
              'callerName',
              'displayName',
            ]) ??
            _text.unknownCaller,
        'targetUserId':
            payload.stringValue(const ['callerUserId', 'callerId']) ?? '',
        'avatarUrl':
            payload.stringValue(const ['callerAvatarUrl', 'avatarUrl']),
        'relayUrl': payload.stringValue(const ['relayUrl', 'RelayUrl']) ?? '',
        'mediaMode': mediaMode,
      });
      return;
    }

    final conversationId = payload.conversationId;
    final chatRoute = _safeChatRoute(payload.data, conversationId);
    if (chatRoute == null) return;
    final conversationType =
        payload.stringValue(const ['conversationType', 'type']);
    final hasKnownConversationType = const {
      'direct',
      'group',
      'tempSession',
      'temp_session',
    }.contains(conversationType);
    final hasExplicitGroupFlag = payload.data.containsKey('isGroup');
    final isGroup =
        payload.boolValue(const ['isGroup']) || conversationType == 'group';
    final customerServiceThreadType = payload.stringValue(const [
      'threadType',
      'customerServiceThreadType',
    ]);
    final customerServiceThreadId = payload.stringValue(const [
      'threadId',
      'sessionId',
      'customerServiceThreadId',
    ]);
    final hasCustomerServiceRouteIdentity = customerServiceThreadType != null &&
        customerServiceThreadType.isNotEmpty &&
        customerServiceThreadId != null &&
        customerServiceThreadId.isNotEmpty;
    router.push(chatRoute, extra: {
      if (hasKnownConversationType || hasExplicitGroupFlag) 'isGroup': isGroup,
      if (hasKnownConversationType) 'conversationType': conversationType,
      'title': payload.stringValue(const ['conversationTitle', 'title']) ?? '',
      'scrollToMessageId': payload.stringValue(const ['messageId']),
      'peerUserId': payload.stringValue(const ['peerUserId', 'senderUserId']),
      if (hasCustomerServiceRouteIdentity)
        'customerServiceThreadType': customerServiceThreadType,
      if (hasCustomerServiceRouteIdentity)
        'customerServiceThreadId': customerServiceThreadId,
    });
  }

  @visibleForTesting
  Future<void> handleLocalNotificationDataForTesting(
    Map<String, dynamic> data,
  ) =>
      _routeData(data);

  static Future<void> _cancelLocalNotification(int id) async {
    try {
      await _localNotifications.cancel(id: id);
    } catch (error) {
      debugPrint('[PushNotification] cancel local notification failed: $error');
    }
  }

  /// Accept only the app's chat route from a server payload. Arbitrary route
  /// strings are never used as navigation commands.
  static String? _safeChatRoute(
    Map<String, dynamic> data,
    String? fallbackConversationId,
  ) {
    final route = _stringValue(data, const ['route']);
    if (route != null && route.isNotEmpty) {
      final uri = Uri.tryParse(route);
      final segments = uri?.pathSegments;
      if (uri != null &&
          !uri.hasScheme &&
          !uri.hasAuthority &&
          segments != null &&
          segments.length == 2 &&
          segments.first == 'chat' &&
          segments.last.isNotEmpty) {
        return '/chat/${segments.last}';
      }
    }
    if (fallbackConversationId == null || fallbackConversationId.isEmpty) {
      return null;
    }
    return '/chat/$fallbackConversationId';
  }

  String _fallbackTitle(PushNotificationPayload payload) {
    if (payload.isCall) {
      return _text.callTitle(
        isVideo: _isVideoMediaMode(payload.mediaMode ?? _audioMediaType),
      );
    }
    if (payload.isSecurity) return _text.securityTitle;
    return payload.stringValue(const ['threadType']) != null
        ? _text.onlineServiceTitle
        : _text.newMessageTitle;
  }

  String _fallbackBody(PushNotificationPayload payload) {
    if (payload.isCall) {
      final mediaMode = payload.mediaMode ?? _audioMediaType;
      return _text.callBody(
        isVideo: _isVideoMediaMode(mediaMode),
        caller: payload.stringValue(const ['callerDisplayName']) ?? '',
      );
    }
    if (payload.isSecurity) return _text.securityBody;
    return _text.messagePreview(payload.messageType ?? '');
  }

  String _mentionAwareBody(
    PushNotificationPayload payload,
    String body,
  ) {
    final kind = (payload.stringValue(const [
              'mentionType',
              'mentionReminder',
              'mentionKind',
            ]) ??
            '')
        .trim()
        .toLowerCase();
    final sender = payload.stringValue(const [
          'senderDisplayName',
          'senderName',
          'fromDisplayName',
        ]) ??
        '';
    if (kind == 'me' ||
        kind == 'user' ||
        payload.boolValue(const ['isMentioned'])) {
      return _text.mentionBody(
        kind: _mentionMeType,
        sender: sender,
        body: body,
      );
    }
    if (kind == 'all' || payload.boolValue(const ['isMentionAll'])) {
      return _text.mentionBody(
        kind: _mentionAllType,
        sender: sender,
        body: body,
      );
    }
    return body;
  }

  static String? _stringValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) continue;
      final text = value.toString();
      if (text.isNotEmpty) return text;
    }
    final lower = {
      for (final entry in data.entries) entry.key.toLowerCase(): entry.value,
    };
    for (final key in keys) {
      final value = lower[key.toLowerCase()];
      if (value == null) continue;
      final text = value.toString();
      if (text.isNotEmpty) return text;
    }
    return null;
  }

  static bool _isVideoMediaMode(String mediaMode) {
    final normalized =
        mediaMode.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    return normalized == 'audiovideo' || normalized == 'video';
  }
}
