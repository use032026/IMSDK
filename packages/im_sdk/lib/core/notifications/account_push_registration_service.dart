import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/notifications/android_push_session.dart';
import 'package:im_sdk/core/notifications/mobile_push_token_provider.dart';
import 'package:im_sdk/core/notifications/push_device_registration_service.dart';
import 'package:im_sdk/core/platform/platform_capabilities.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

const _pushDeviceIdKey = 'push_device_id';
const _pushCleanupLedgerKey = 'push_registration_cleanup_v1';

typedef PushRegistrationOperationIsCurrent = bool Function(
  PlatformAccountScope platformAccount,
);
typedef PushRegistrationAccountsLoader = Future<List<PushRegistrationAccount>>
    Function(
  PlatformAccountScope platformAccount,
);
typedef PushAppVersionProvider = Future<String?> Function();

@immutable
class PushRegistrationAccount {
  const PushRegistrationAccount({
    required this.spaceId,
    required this.accessToken,
  });

  final String spaceId;
  final String accessToken;
}

/// Platform-account owner for binding one native device token to every locally
/// authenticated space. It stays above account runtimes so a space switch does
/// not retire token-change observation or lose the logout cleanup ledger.
class AccountPushRegistrationService {
  AccountPushRegistrationService({
    required PushDeviceRegistrar registrationService,
    required SecureStorageService storage,
    required MobilePushTokenProvider mobilePushTokenProvider,
    required PushRegistrationOperationIsCurrent operationIsCurrent,
    required PushRegistrationAccountsLoader accountsLoader,
    PushAppVersionProvider appVersionProvider = _defaultAppVersionProvider,
    AndroidPushSession? androidPushSession,
  })  : _registrationService = registrationService,
        _storage = storage,
        _mobilePushTokenProvider = mobilePushTokenProvider,
        _operationIsCurrent = operationIsCurrent,
        _accountsLoader = accountsLoader,
        _appVersionProvider = appVersionProvider,
        _androidPushSession = androidPushSession;

  final PushDeviceRegistrar _registrationService;
  final SecureStorageService _storage;
  final MobilePushTokenProvider _mobilePushTokenProvider;
  final PushRegistrationOperationIsCurrent _operationIsCurrent;
  final PushRegistrationAccountsLoader _accountsLoader;
  final PushAppVersionProvider _appVersionProvider;
  final AndroidPushSession? _androidPushSession;

  StreamSubscription<MobilePushToken>? _tokenSubscription;
  Future<void> _operationTail = Future<void>.value();
  final Map<String, PushRegistrationAccount> _attemptedAccounts = {};
  final Set<String> _pendingCleanup = {};
  bool _ledgerLoaded = false;
  PlatformAccountScope? _activePlatformAccount;
  PlatformAccountScope? _startingPlatformAccount;
  Future<void>? _startFuture;
  String? _knownDeviceId;
  int _generation = 0;
  bool _disposed = false;

  bool _isCurrent(PlatformAccountScope platformAccount, int generation) =>
      !_disposed &&
      generation == _generation &&
      _activePlatformAccount == platformAccount &&
      _operationIsCurrent(platformAccount);

  Future<void> start({
    required PlatformAccountScope platformAccount,
  }) {
    final inFlight = _startFuture;
    if (inFlight != null && _startingPlatformAccount == platformAccount) {
      return inFlight;
    }
    late final Future<void> startFuture;
    startFuture = _start(
      platformAccount,
    ).whenComplete(() {
      if (identical(_startFuture, startFuture)) {
        _startFuture = null;
        _startingPlatformAccount = null;
      }
    });
    _startingPlatformAccount = platformAccount;
    _startFuture = startFuture;
    return startFuture;
  }

  Future<void> _start(PlatformAccountScope platformAccount) async {
    if (_disposed ||
        !PlatformCapabilities.supportsMobilePush ||
        !_operationIsCurrent(platformAccount)) {
      return;
    }
    if (_activePlatformAccount != platformAccount) {
      _activePlatformAccount = platformAccount;
      _generation += 1;
    }
    final generation = _generation;
    _tokenSubscription ??=
        _mobilePushTokenProvider.tokenChanges.listen((token) {
      final currentAccount = _activePlatformAccount;
      if (currentAccount == null) return;
      final currentGeneration = _generation;
      unawaited(
        _enqueue(
          () => _registerAll(
            token,
            currentAccount,
            currentGeneration,
          ),
        ),
      );
    });
    if (_androidPushSession != null) {
      var ready = false;
      try {
        await _enqueue(() async {
          await _loadLedger();
          if (!_isCurrent(platformAccount, generation)) return;
          // A new login may supply fresh tokens for a previously failed logout.
          final accounts = await _accountsLoader(platformAccount);
          if (!_isCurrent(platformAccount, generation)) return;
          for (final account in accounts) {
            final key = _accountKey(platformAccount, account.spaceId);
            if (_pendingCleanup.contains(key)) {
              _attemptedAccounts[key] = account;
            }
          }
          await _retryCleanup();
          if (!_isCurrent(platformAccount, generation)) return;
          if (_pendingCleanup.any(
              (key) => !key.startsWith('${platformAccount.storageKeyHash}:'))) {
            debugPrint(
                '[PushRegistration] push remains stopped: another account cleanup pending');
            return;
          }
          await _androidPushSession.setAuthorized(true);
          ready = _isCurrent(platformAccount, generation);
        });
      } catch (error) {
        debugPrint(
            '[PushRegistration] session preparation failed: ${error.runtimeType}');
      }
      if (!ready) return;
    }
    final token = await _mobilePushTokenProvider.requestToken();
    if (token == null || !_isCurrent(platformAccount, generation)) return;
    await _enqueue(
      () => _registerAll(token, platformAccount, generation),
    );
  }

  Future<void> _registerAll(
    MobilePushToken token,
    PlatformAccountScope platformAccount,
    int generation,
  ) async {
    if (!_isCurrent(platformAccount, generation)) return;
    if (_androidPushSession?.allowsPresentation == false) return;
    final platform = PushDeviceRegistrationService.currentMobilePlatform();
    if (platform == null) return;
    try {
      final accounts = await _accountsLoader(platformAccount);
      if (!_isCurrent(platformAccount, generation)) return;
      final normalizedAccounts = <String, PushRegistrationAccount>{};
      for (final account in accounts) {
        final spaceId = account.spaceId.trim();
        final accessToken = account.accessToken.trim();
        if (spaceId.isEmpty || accessToken.isEmpty) continue;
        normalizedAccounts[spaceId] = PushRegistrationAccount(
          spaceId: spaceId,
          accessToken: accessToken,
        );
      }
      if (normalizedAccounts.isEmpty) return;
      final deviceId = await _storage.stableDeviceId();
      _knownDeviceId = deviceId;
      if (!_isCurrent(platformAccount, generation)) return;
      final appVersion = await _appVersionProvider();
      if (!_isCurrent(platformAccount, generation)) return;
      final registration = PushDeviceRegistration(
        deviceId: deviceId,
        platform: platform,
        channel: token.channel,
        token: token.token,
        region: token.region,
        appVersion: appVersion,
      );
      var succeeded = false;
      for (final account in normalizedAccounts.values) {
        _attemptedAccounts[_accountKey(platformAccount, account.spaceId)] =
            account;
      }
      // Persist before sending: a crash after server acceptance must not lose
      // the spaces that still need to be unbound on logout.
      await _persistLedger();
      await Future.wait(
        normalizedAccounts.values.map((account) async {
          if (!_isCurrent(platformAccount, generation)) return;
          try {
            await _registrationService.registerOrUpdate(
              registration,
              accessToken: account.accessToken,
            );
            succeeded = true;
            _pendingCleanup
                .remove(_accountKey(platformAccount, account.spaceId));
          } catch (error) {
            if (_isCurrent(platformAccount, generation)) {
              debugPrint(
                '[PushRegistration] space registration failed: '
                '${account.spaceId}: $error',
              );
            }
          }
        }),
      );
      await _persistLedger();
      if (succeeded && _isCurrent(platformAccount, generation)) {
        await _storage.write(_pushDeviceIdKey, deviceId);
      }
    } catch (error) {
      if (_isCurrent(platformAccount, generation)) {
        debugPrint(
          '[PushRegistration] platform account registration failed: $error',
        );
      }
    }
  }

  /// Retires registration work for [platformAccount], then unregisters the
  /// stable device under every attempted space, including Android's persisted ledger.
  /// The active-space fallback covers an immediate logout before startup token
  /// acquisition finishes.
  Future<void> unregisterPlatformAccount({
    required PlatformAccountScope platformAccount,
    String? currentSpaceId,
    String? currentAccessToken,
  }) {
    final fallbackSpaceId = currentSpaceId?.trim() ?? '';
    final fallbackAccessToken = currentAccessToken?.trim() ?? '';
    if (fallbackSpaceId.isNotEmpty && fallbackAccessToken.isNotEmpty) {
      _attemptedAccounts[_accountKey(platformAccount, fallbackSpaceId)] =
          PushRegistrationAccount(
        spaceId: fallbackSpaceId,
        accessToken: fallbackAccessToken,
      );
    }
    if (_activePlatformAccount == platformAccount) {
      _activePlatformAccount = null;
      _generation += 1;
      _startFuture = null;
      _startingPlatformAccount = null;
    }
    final suspension = _suspendNative();
    return _enqueue(() async {
      await suspension;
      await _loadLedger();
      _pendingCleanup.addAll(_attemptedAccounts.keys.where(
        (key) => key.startsWith('${platformAccount.storageKeyHash}:'),
      ));
      await _persistLedger();
      await _retryCleanup();
    });
  }

  /// Also covers unauthenticated cold starts without an in-memory Auth transition.
  Future<void> suspendNotifications() {
    if (_androidPushSession == null) return Future<void>.value();
    final suspension = _suspendNative();
    return _enqueue(() async {
      await suspension;
      await _loadLedger();
      _pendingCleanup.addAll(_attemptedAccounts.keys);
      await _persistLedger();
      await _retryCleanup();
    });
  }

  /// Auth awaits only the local gate, never server cleanup. Fence pending starts
  /// at the same time so a delayed login task cannot resume push during logout.
  Future<void> stopDelivery() {
    if (_androidPushSession == null) return Future<void>.value();
    _activePlatformAccount = null;
    _generation += 1;
    _startFuture = null;
    _startingPlatformAccount = null;
    return _androidPushSession.setAuthorized(false);
  }

  Future<void> _suspendNative() async {
    try {
      await stopDelivery();
    } catch (error) {
      debugPrint('[PushRegistration] stop push failed: ${error.runtimeType}');
    }
  }

  Future<void> _retryCleanup() async {
    if (_pendingCleanup.isEmpty) return;
    final deviceId = _knownDeviceId ??
        (_androidPushSession != null
            ? await _storage.stableDeviceId()
            : await _storage.read(_pushDeviceIdKey));
    if (deviceId == null || deviceId.isEmpty) {
      // Preserve the existing non-Android best-effort cleanup behavior.
      for (final key in _pendingCleanup) {
        _attemptedAccounts.remove(key);
      }
      _pendingCleanup.clear();
      return;
    }
    for (final key in _pendingCleanup.toList(growable: false)) {
      final account = _attemptedAccounts[key];
      if (account == null) continue;
      try {
        await _registrationService.unregister(deviceId,
            accessToken: account.accessToken);
        _attemptedAccounts.remove(key);
        _pendingCleanup.remove(key);
      } catch (error) {
        debugPrint(
            '[PushRegistration] space unregister failed: ${error.runtimeType}');
        if (_androidPushSession == null) {
          _attemptedAccounts.remove(key);
          _pendingCleanup.remove(key);
        }
      }
    }
    await _persistLedger();
  }

  Future<void> _loadLedger() async {
    if (_androidPushSession == null || _ledgerLoaded) return;
    final raw = await _storage.read(_pushCleanupLedgerKey);
    if (raw != null) {
      final entries = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in entries.entries) {
        final data = entry.value as Map<String, dynamic>;
        _attemptedAccounts.putIfAbsent(
            entry.key,
            () => PushRegistrationAccount(
                  spaceId: data['spaceId'] as String,
                  accessToken: data['accessToken'] as String,
                ));
        if (data['pending'] == true) _pendingCleanup.add(entry.key);
      }
    }
    _ledgerLoaded = true;
  }

  Future<void> _persistLedger() async {
    if (_androidPushSession == null) return;
    if (_attemptedAccounts.isEmpty) {
      await _storage.delete(_pushCleanupLedgerKey);
      return;
    }
    // SecureStorage is encrypted. These credentials are only used for DELETE;
    // they are removed as soon as the corresponding cleanup succeeds.
    await _storage.write(
        _pushCleanupLedgerKey,
        jsonEncode({
          for (final entry in _attemptedAccounts.entries)
            entry.key: {
              'spaceId': entry.value.spaceId,
              'accessToken': entry.value.accessToken,
              'pending': _pendingCleanup.contains(entry.key),
            },
        }));
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    final next = _operationTail.then(
      (_) => operation(),
      onError: (_) => operation(),
    );
    _operationTail = next.catchError((Object _) {});
    return next;
  }

  static String _accountKey(
    PlatformAccountScope platformAccount,
    String spaceId,
  ) =>
      '${platformAccount.storageKeyHash}:${spaceId.trim()}';

  @visibleForTesting
  Future<void> get pendingOperationsForTesting => _operationTail;

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _activePlatformAccount = null;
    _generation += 1;
    await _tokenSubscription?.cancel();
    _tokenSubscription = null;
  }

  static Future<String?> _defaultAppVersionProvider() async {
    final info = await PackageInfo.fromPlatform();
    return info.version.isEmpty ? null : info.version;
  }
}
