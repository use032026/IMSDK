import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:im_sdk/app/account_runtime_provider.dart';
import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/auth/token_refresh_service.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/service_realm_config.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';
import 'package:im_sdk/core/privacy/privacy_consent_service.dart';
import 'package:im_sdk/core/providers/locale_provider.dart';
import 'package:im_sdk/core/providers/theme_provider.dart';
import 'package:im_sdk/core/runtime/account_runtime.dart';
import 'package:im_sdk/core/space/account_scope.dart';
import 'package:im_sdk/core/space/space_transition.dart';
import 'package:im_sdk/core/storage/account_storage_registry.dart';
import 'package:im_sdk/core/storage/hive_storage.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'package:im_sdk/core/utils/validators.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/chat/domain/services/chat_startup_recovery.dart';
import 'package:im_sdk/features/chat/domain/usecases/message_badge_count.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/gateway_provider.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_open_controller.dart';
import 'data/sdk_customer_service_repository.dart';
import 'im_sdk_models.dart';
import 'im_sdk_host_session.dart';

/// Owns one authenticated runtime independently of all chat pages.
class ImSdkClient with WidgetsBindingObserver {
  ImSdkClient() : _providerOverrides = const [];

  /// A test-only dependency seam; never accepted from native configuration.
  @visibleForTesting
  ImSdkClient.withProviderOverrides(List<Override> overrides)
      : _providerOverrides = List.unmodifiable(overrides);

  final List<Override> _providerOverrides;
  static ImSdkClient? _owner;
  final _events = StreamController<ImSdkEvent>.broadcast();
  final ValueNotifier<int> _revision = ValueNotifier(0);
  Future<void> _tail = Future<void>.value();
  ImSdkConfig? _config;
  ProviderContainer? _root;
  ProviderContainer? _account;
  AccountRuntime? _installed;
  ProviderSubscription<AccountRuntime?>? _runtimeSubscription;
  ProviderSubscription<AsyncValue<AuthState>>? _authSubscription;
  ProviderSubscription<int?>? _badgeSubscription;
  StreamSubscription<Object?>? _gatewayStatus;
  bool _disposed = false;
  bool _authenticated = false;
  int _generation = 0;
  Future<void>? _disposeFuture;
  ImSdkHostSessionProvider? _hostSessionProvider;
  StreamSubscription<void>? _hostSessionChanges;
  ImSdkHostSession? _authenticatedHostSession;
  DateTime? _hostCredentialExpiry;
  int _hostEpoch = 0;
  Future<bool>? _hostSynchronization;
  bool _hostForceRefreshRequested = false;
  int _hostCredentialRevision = 0;
  Future<void>? _hostRetirement;
  bool _hostClosed = false;
  int _presentationRevision = 0;
  static const _hostCallTimeout = Duration(seconds: 15);

  Stream<ImSdkEvent> get events => _events.stream;
  bool get isInitialized => _root != null && !_disposed;
  bool get isAuthenticated => _authenticated && _account != null;
  ImSdkConfig? get config => _config;
  ValueListenable<int> get revision => _revision;
  ProviderContainer? get accountContainer => _account;

  /// The root presentation scope also exists while no account is active.
  ProviderContainer? get presentationContainer => _root;
  int get sessionRevision => _generation;

  /// Applies the host's appearance choice without replacing account state or
  /// navigation. Validate the entire update before changing either provider.
  Future<void> updatePresentation({String? themeMode, String? locale}) async {
    final root = _requireRoot();
    if (_disposed || _hostClosed) {
      throw const ImSdkException('DISPOSED', 'SDK已释放');
    }
    final next = ImSdkConfig.fromMap({
      ..._config!.toMap(),
      if (themeMode != null) 'themeMode': themeMode,
      if (locale != null) 'locale': locale,
    });
    next.validate();
    final revision = ++_presentationRevision;
    _config = next;
    final writes = _applyPresentation(root, next);
    _changed();
    await writes;
    if (revision == _presentationRevision && !_disposed && !_hostClosed) {
      _emit('presentationChanged', {
        'themeMode': _config!.normalizedThemeMode,
        'locale': _config!.normalizedLocale,
      });
    }
  }

  Future<void> _applyPresentation(ProviderContainer root, ImSdkConfig config) {
    final mode = switch (config.normalizedThemeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final selected = config.normalizedLocale;
    final locale = selected == 'system'
        ? _systemLocale()
        : supportedLocaleFromTag(selected)!;
    return Future.wait<void>([
      root.read(themeModeProvider.notifier).setThemeMode(mode),
      root.read(localeProvider.notifier).setLocale(locale),
    ]).then<void>((_) {});
  }

  Locale _systemLocale() {
    for (final locale in WidgetsBinding.instance.platformDispatcher.locales) {
      final supported = normalizedSupportedLocale(locale);
      if (supported != null) return supported;
    }
    return const Locale('zh', 'CN');
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (_root != null &&
        !_hostClosed &&
        !_disposed &&
        _config?.normalizedLocale == 'system') {
      unawaited(
          _root!.read(localeProvider.notifier).setLocale(_systemLocale()));
      _changed();
    }
  }

  /// Bind once, either before or after initialize. Host callbacks never run in
  /// the operation queue, so logout can invalidate a slow credential request.
  void bindHostSessionProvider(ImSdkHostSessionProvider provider) {
    if (_disposed || _hostClosed) {
      throw const ImSdkException('DISPOSED', 'SDK已释放');
    }
    if (identical(_hostSessionProvider, provider)) return;
    if (_hostSessionProvider != null) {
      throw const ImSdkException('HOST_PROVIDER_CONFLICT', '宿主登录状态提供方已绑定');
    }
    _hostSessionProvider = provider;
    _hostSessionChanges = provider.changes.listen((_) {
      unawaited(notifyHostSessionChanged().catchError((Object _) => false));
    }, onError: (Object _) {
      _emit('hostAuthenticationFailed', {'code': 'HOST_AUTH_UNAVAILABLE'});
    });
  }

  /// Rechecks the host on every entry/resume. Cached SDK credentials are used
  /// only after the host confirms the same login incarnation.
  Future<bool> synchronizeHostSession({bool forceRefresh = false}) {
    if (_disposed || _hostClosed) {
      return Future.error(const ImSdkException('DISPOSED', 'SDK已释放'));
    }
    _requireRoot();
    if (_config?.hostManagedAuth != true) return Future.value(isAuthenticated);
    if (_hostSessionProvider == null) {
      return Future.error(
          const ImSdkException('HOST_AUTH_PROVIDER_MISSING', '应用尚未连接登录状态'));
    }
    final inFlight = _hostSynchronization;
    if (inFlight != null) {
      if (!forceRefresh) return inFlight;
      _hostForceRefreshRequested = true;
      final revision = _hostCredentialRevision;
      final epoch = _hostEpoch;
      return inFlight.then((ready) {
        _ensureHostEpoch(epoch);
        // An arriving forced request must not be lost if the cached check
        // already finished but its completion is still queued as a microtask.
        if (ready && revision == _hostCredentialRevision) {
          return synchronizeHostSession(forceRefresh: true);
        }
        return ready;
      });
    }
    final epoch = _hostEpoch;
    _hostForceRefreshRequested = forceRefresh;
    late final Future<bool> operation;
    operation = _synchronizeHostSession(epoch, forceRefresh).whenComplete(() {
      if (identical(_hostSynchronization, operation)) {
        _hostSynchronization = null;
      }
    });
    _hostSynchronization = operation;
    return operation;
  }

  /// Call immediately after the host changes login state. Invalidating the
  /// previous operation is synchronous, including while profile verification
  /// or a platform callback is still pending.
  Future<bool> notifyHostSessionChanged() {
    if (_disposed || _hostClosed) return Future.value(false);
    _invalidateHostOperation();
    if (_root == null || _config?.hostManagedAuth != true) {
      return Future.value(false);
    }
    _startHostRetirement();
    return synchronizeHostSession();
  }

  void _invalidateHostOperation({bool forgetSession = false}) {
    ++_hostEpoch;
    _hostSynchronization = null;
    if (forgetSession) _authenticatedHostSession = null;
    _hostCredentialExpiry = null;
    if (_config?.hostManagedAuth == true) {
      _root?.read(authProvider.notifier).invalidateExternalSessionOperation();
      ++_generation;
      _authenticated = false;
      _changed();
    }
  }

  void _ensureHostEpoch(int epoch) {
    if (_disposed || _hostClosed || epoch != _hostEpoch) {
      throw const ImSdkException('HOST_SESSION_CHANGED', '应用登录状态已变化');
    }
  }

  Future<ImSdkHostSession?> _readHostSession(int epoch) async {
    _ensureHostEpoch(epoch);
    final session =
        await _hostSessionProvider!.readSession().timeout(_hostCallTimeout);
    _ensureHostEpoch(epoch);
    session?.validate();
    return session;
  }

  Future<void> _verifyHostSession(int epoch, ImSdkHostSession expected) async {
    final latest = await _readHostSession(epoch);
    if (latest != expected) {
      _invalidateHostOperation(forgetSession: true);
      _startHostRetirement();
      throw const ImSdkException('HOST_SESSION_CHANGED', '应用登录状态已变化');
    }
  }

  Future<void> _startHostRetirement() {
    final inFlight = _hostRetirement;
    if (inFlight != null) return inFlight;
    final root = _root;
    if (root == null) return Future.value();
    late final Future<void> operation;
    operation = (() async {
      final auth = root.read(authProvider.notifier);
      await auth.logout();
      await auth.waitForLogoutCleanup();
      _installRuntime(null);
    })()
        .whenComplete(() {
      if (identical(_hostRetirement, operation)) _hostRetirement = null;
    });
    _hostRetirement = operation;
    unawaited(operation.catchError((Object _) {
      _emit('hostAuthenticationFailed', {'code': 'HOST_AUTH_UNAVAILABLE'});
    }));
    return operation;
  }

  Future<bool> _synchronizeHostSession(int epoch, bool forceRefresh) async {
    try {
      final session = await _readHostSession(epoch);
      if (session == null) {
        _authenticatedHostSession = null;
        _hostCredentialExpiry = null;
        _authenticated = false;
        _changed();
        await _startHostRetirement();
        _ensureHostEpoch(epoch);
        _emit('loggedOut');
        return false;
      }
      final retirement = _hostRetirement;
      if (retirement != null) {
        await retirement;
        await _verifyHostSession(epoch, session);
      }
      if (_authenticatedHostSession != null &&
          _authenticatedHostSession != session) {
        _authenticated = false;
        ++_generation;
        _changed();
        _root!.read(authProvider.notifier).invalidateExternalSessionOperation();
        await _startHostRetirement();
        await _verifyHostSession(epoch, session);
      }
      if (!forceRefresh &&
          !_hostForceRefreshRequested &&
          session == _authenticatedHostSession &&
          isAuthenticated &&
          _hostCredentialExpiry
                  ?.isAfter(DateTime.now().add(const Duration(seconds: 30))) ==
              true) {
        return true;
      }
      final credentials = await _hostSessionProvider!
          .fetchCredentials(session)
          .timeout(_hostCallTimeout);
      await _verifyHostSession(epoch, session);
      await _serial(() async {
        await _verifyHostSession(epoch, session);
        await _authenticateCredentials(credentials,
            publishAuthentication: false,
            externalOperationIsCurrent: () =>
                epoch == _hostEpoch && !_hostClosed && !_disposed,
            verifyExternalSession: () => _verifyHostSession(epoch, session));
        await _verifyHostSession(epoch, session);
        _authenticatedHostSession = session;
        _hostCredentialExpiry = credentials.expiresAt;
        ++_hostCredentialRevision;
        _authenticated = true;
        _changed();
        _emit('authenticated', {'spaceId': credentials.spaceId});
      });
      _ensureHostEpoch(epoch);
      return isAuthenticated;
    } catch (error) {
      if (epoch != _hostEpoch || _hostClosed || _disposed) {
        throw const ImSdkException('HOST_SESSION_CHANGED', '应用登录状态已变化');
      }
      // A failed host query is not proof of logout. Keep a confirmed current
      // session on network failure; a new entry presents an inline retry.
      const publicCodes = {
        'HOST_CREDENTIALS_UNAVAILABLE',
        'HOST_SESSION_CHANGED',
        'HOST_SESSION_UNAVAILABLE',
        'HOST_SESSION_TIMEOUT',
      };
      final code = error is ImSdkException && publicCodes.contains(error.code)
          ? error.code
          : error is TimeoutException
              ? 'HOST_SESSION_TIMEOUT'
              : 'HOST_AUTH_UNAVAILABLE';
      _emit('hostAuthenticationFailed', {'code': code});
      throw ImSdkException(code, '聊天服务暂不可用，请重试');
    }
  }

  Future<T> _serial<T>(Future<T> Function() action) {
    if (_disposed)
      return Future.error(const ImSdkException('DISPOSED', 'SDK已释放'));
    final next = _tail.then((_) {
      if (_disposed) throw const ImSdkException('DISPOSED', 'SDK已释放');
      return action();
    });
    _tail = next.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return next;
  }

  Future<void> initialize(ImSdkConfig config) => _serial(() async {
        config.validate();
        if (_root != null) {
          if (_config!.hasSameRuntimeConfiguration(config)) return;
          throw const ImSdkException('CONFIG_CONFLICT', '已初始化SDK不能切换配置');
        }
        if (_owner != null && !identical(_owner, this)) {
          throw const ImSdkException(
              'INSTANCE_CONFLICT', '每个Flutter isolate仅支持一个SDK实例');
        }
        _owner = this;
        try {
          WidgetsFlutterBinding.ensureInitialized();
          final hash = sha256
              .convert(utf8.encode(
                  '${config.storageNamespace}|${config.serviceRealmId}'))
              .toString();
          final support = await getApplicationSupportDirectory();
          final directory = Directory(p.join(support.path, 'im_sdk', hash));
          await directory.create(recursive: true);
          await HiveStorage.initForSdk(
              directory: directory.path, namespace: hash);
          ServiceRealmConfig.configureForSdk(
              realmId: config.serviceRealmId,
              apiBaseUrl: config.apiBaseUrl,
              gatewayBaseUrl: config.gatewayBaseUrl);
          SiteLineManager.instance.configureForSdk(
              apiBaseUrl: config.apiBaseUrl,
              gatewayBaseUrl: config.gatewayBaseUrl);
          final consent = PrivacyConsentController(_HostConsentStore());
          await consent.load();
          final root = ProviderContainer(overrides: [
            externalSessionOnlyProvider.overrideWithValue(true),
            secureStorageProvider.overrideWithValue(
                SecureStorageServiceImpl(namespace: 'im_sdk_$hash')),
            accountStorageRegistryProvider.overrideWith((ref) async =>
                AccountStorageRegistry(documentsRoot: directory)),
            privacyConsentControllerProvider.overrideWith((ref) => consent),
            ..._providerOverrides,
          ]);
          _root = root;
          _config = config;
          await root.read(authProvider.future);
          await _applyPresentation(root, config);
          WidgetsBinding.instance.addObserver(this);
          _runtimeSubscription = root.listen(activeAccountRuntimeProvider,
              (_, runtime) => _installRuntime(runtime),
              fireImmediately: true);
          _authSubscription = root.listen(authProvider, (_, next) {
            if (next.valueOrNull?.status == AuthStatus.unauthenticated &&
                _authenticated) {
              _authenticated = false;
              _emit('authenticationRequired');
              _changed();
              if (_config?.hostManagedAuth == true &&
                  _authenticatedHostSession != null) {
                unawaited(synchronizeHostSession(forceRefresh: true)
                    .catchError((Object _) => false));
              }
            }
          });
          _emit('initialized');
        } catch (error, stack) {
          try {
            _root?.dispose();
          } catch (_) {}
          try {
            await HiveStorage.closeForSdk();
          } catch (_) {}
          _root = null;
          _config = null;
          if (identical(_owner, this)) _owner = null;
          Error.throwWithStackTrace(error, stack);
        }
      });

  Future<void> authenticate(ImSdkCredentials credentials) => _serial(() async {
        if (_config?.hostManagedAuth == true) {
          throw const ImSdkException('HOST_AUTH_MANAGED', '请通过应用登录状态同步聊天');
        }
        await _authenticateCredentials(credentials);
      });

  Future<void> _authenticateCredentials(ImSdkCredentials credentials,
      {bool publishAuthentication = true,
      bool Function()? externalOperationIsCurrent,
      Future<void> Function()? verifyExternalSession}) async {
    final root = _requireRoot();
    _authenticated = false;
    _generation++;
    _changed();
    credentials.validate();
    final scope = AccountScope.tryCreate(
        serviceRealmId: _config!.serviceRealmId,
        platformUserId: credentials.platformUserId,
        spaceId: credentials.spaceId,
        userId: credentials.userId)!;
    await root.read(authProvider.notifier).acceptExternalSession(
        scope: scope,
        credentials: SessionCredentials(
            tenantAccessToken: credentials.accessToken,
            tenantRefreshToken: credentials.refreshToken,
            platformAccessToken: credentials.platformToken,
            platformRefreshToken: credentials.platformRefreshToken,
            deviceSessionToken: credentials.deviceSessionToken),
        issuedAt: DateTime.now().toUtc(),
        expiresAt: credentials.expiresAt.toUtc(),
        externalOperationIsCurrent: externalOperationIsCurrent,
        verifyExternalSession: verifyExternalSession);
    await _waitForRuntime(scope,
        operationIsCurrent: externalOperationIsCurrent);
    await verifyExternalSession?.call();
    if (externalOperationIsCurrent?.call() == false) {
      throw const ImSdkException('HOST_SESSION_CHANGED', '应用登录状态已变化');
    }
    if (publishAuthentication) {
      _authenticated = true;
      _changed();
      _emit('authenticated', {'spaceId': scope.spaceId});
    }
  }

  /// Uses the existing IM authentication service. Other-app account integration
  /// must be implemented by that service; passwords are never stored by this API.
  Future<void> loginWithPassword({
    required String account,
    required String password,
    String? captchaToken,
    String? captchaAnswer,
  }) =>
      _serial(() async {
        final root = _requireRoot();
        final login = _requirePasswordLogin();
        if (account.trim().isEmpty || password.isEmpty) {
          throw const ImSdkException('INVALID_ARGUMENT', '请输入账号和密码');
        }
        if ((captchaToken != null || captchaAnswer != null) &&
            (captchaToken?.trim().isNotEmpty != true ||
                captchaAnswer?.trim().isNotEmpty != true)) {
          throw const ImSdkException('INVALID_ARGUMENT', '请完成安全验证');
        }
        _authenticated = false;
        _generation++;
        _changed();
        try {
          await root.read(authProvider.notifier).loginByPassword(
                account.trim(),
                password,
                login.usePersonalSpace
                    ? (Validators.isEmail(account)
                        ? 'email'
                        : Validators.isMobile(account)
                            ? 'mobile'
                            : 'lpp_id')
                    : login.loginType,
                tenantCode: login.tenantCode?.trim(),
                usePersonalSpace: login.usePersonalSpace,
                captchaToken: captchaToken?.trim(),
                captchaAnswer: captchaAnswer?.trim(),
              );
          // The auth owner publishes most failures as AsyncError rather than
          // throwing. A completed request therefore is not proof of login.
          final result = root.read(authProvider);
          if (result.hasError) throw result.error!;
          final auth = result.valueOrNull;
          if (auth != null && authStateNeedsSpaceSelection(auth)) {
            throw const ImSdkException(
                'AUTH_CONTEXT_REQUIRED', '请联系应用提供方配置账号所属企业');
          }
          final session =
              auth == null ? null : activeAccountSessionFromAuthState(auth);
          if (session == null) {
            throw const ImSdkException('LOGIN_FAILED', '登录未完成，请重试');
          }
          await _waitForRuntime(session.scope);
          final current = root.read(authProvider).valueOrNull;
          if (current == null ||
              activeAccountSessionFromAuthState(current)?.sessionId !=
                  session.sessionId) {
            throw const ImSdkException('SESSION_CHANGED', '登录状态已变化，请重新登录');
          }
          _authenticated = true;
          _changed();
          _emit('authenticated', {'spaceId': session.scope.spaceId});
        } catch (error) {
          final failure = imSdkPasswordLoginFailure(error);
          _authenticated = false;
          // Retire an incomplete login, including an unresolved platform-only
          // session, through the existing credential/session owner.
          try {
            await root.read(authProvider.notifier).logout();
          } catch (_) {}
          _installRuntime(null);
          _changed();
          _emit('authenticationFailed', {'code': failure.code});
          throw failure;
        }
      });

  Future<ImSdkRegistrationVerificationSettings>
      getRegistrationVerificationSettings() => _serial(() async {
            try {
              final settings = await _requireRoot()
                  .read(authProvider.notifier)
                  .getVerificationSettings();
              return ImSdkRegistrationVerificationSettings(
                  smsEnabled: settings.smsEnabled,
                  emailEnabled: settings.emailEnabled,
                  smsRequired: settings.smsRequired,
                  emailRequired: settings.emailRequired);
            } catch (error) {
              throw _registrationFailure(error);
            }
          });

  Future<void> sendRegistrationCode(
          {required String identifier,
          required String channel,
          String? captchaToken,
          String? captchaAnswer}) =>
      _serial(() async {
        final root = _requireRoot();
        _validateRegistrationIdentifier(identifier, channel);
        _validateCaptcha(captchaToken, captchaAnswer);
        try {
          final settings =
              await root.read(authProvider.notifier).getVerificationSettings();
          if ((channel == 'sms' && !settings.smsEnabled) ||
              (channel == 'email' && !settings.emailEnabled)) {
            throw const ImSdkException(
                'REGISTER_CHANNEL_DISABLED', '当前注册方式不可用');
          }
          await root.read(authProvider.notifier).sendVerificationCode(
              identifier.trim(), channel,
              purpose: 'register',
              captchaToken: captchaToken,
              captchaAnswer: captchaAnswer);
        } catch (error) {
          throw _registrationFailure(error);
        }
      });

  /// Creates an IM account and enters one authenticated space directly.
  /// Defaults to personal; a server-assigned enterprise session is preserved.
  Future<void> registerWithPassword(
          {required String displayName,
          required String password,
          required String channel,
          required String identifier,
          String? verificationCode,
          String? captchaToken,
          String? captchaAnswer}) =>
      _serial(() async {
        final root = _requireRoot();
        if (_config?.hostManagedAuth == true) {
          throw const ImSdkException('HOST_AUTH_MANAGED', '请通过应用登录状态同步聊天');
        }
        _validateRegistrationIdentifier(identifier, channel);
        _validateCaptcha(captchaToken, captchaAnswer);
        if (displayName.trim().isEmpty || password.length < 6) {
          throw const ImSdkException('INVALID_ARGUMENT', '请输入昵称和至少6位密码');
        }
        bool created = false;
        try {
          final settings =
              await root.read(authProvider.notifier).getVerificationSettings();
          final enabled =
              channel == 'sms' ? settings.smsEnabled : settings.emailEnabled;
          final required =
              channel == 'sms' ? settings.smsRequired : settings.emailRequired;
          if (!enabled) {
            throw const ImSdkException(
                'REGISTER_CHANNEL_DISABLED', '当前注册方式不可用');
          }
          if (required && verificationCode?.trim().isNotEmpty != true) {
            throw const ImSdkException('AUTH_VERIFICATION_REQUIRED', '请输入验证码');
          }
          _authenticated = false;
          _generation++;
          _changed();
          await root.read(authProvider.notifier).registerPlatform(
              displayName: displayName.trim(),
              password: password,
              loginType: channel == 'sms' ? 'mobile' : 'email',
              mobile: channel == 'sms' ? identifier.trim() : null,
              email: channel == 'email' ? identifier.trim() : null,
              verificationCode: verificationCode?.trim(),
              captchaToken: captchaToken,
              captchaAnswer: captchaAnswer,
              useDefaultRegistrationSpace: true);
          created = true;
          final auth = root.read(authProvider).valueOrNull;
          final session =
              auth == null ? null : activeAccountSessionFromAuthState(auth);
          if (session == null) {
            throw const ImSdkException('REGISTER_LOGIN_FAILED', '账号已创建，请稍后登录');
          }
          await _waitForRuntime(session.scope);
          if (root.read(authProvider).valueOrNull?.accountSession?.sessionId !=
              session.sessionId) {
            throw const ImSdkException('REGISTER_LOGIN_FAILED', '账号已创建，请稍后登录');
          }
          _authenticated = true;
          _changed();
          _emit('authenticated', {'spaceId': session.scope.spaceId});
        } catch (error) {
          final failure = created
              ? const ImSdkException(
                  'REGISTER_LOGIN_FAILED', '账号已创建，暂时无法进入聊天，请稍后登录')
              : _registrationFailure(error);
          _authenticated = false;
          try {
            await root.read(authProvider.notifier).logout();
          } catch (_) {}
          _installRuntime(null);
          _changed();
          _emit('authenticationFailed', {'code': failure.code});
          throw failure;
        }
      });

  Future<ImSdkCaptchaChallenge> requestLoginCaptcha() => _serial(() async {
        final root = _requireRoot();
        try {
          final challenge =
              await root.read(authProvider.notifier).generateCaptcha();
          return ImSdkCaptchaChallenge(
              token: challenge.token, question: challenge.question);
        } catch (error) {
          throw imSdkPasswordLoginFailure(error);
        }
      });

  ImSdkPasswordLoginConfig _requirePasswordLogin() {
    if (_config?.hostManagedAuth == true) {
      throw const ImSdkException('HOST_AUTH_MANAGED', '请通过应用登录状态同步聊天');
    }
    final login = _config?.passwordLogin;
    if (login == null) {
      throw const ImSdkException(
          'PASSWORD_LOGIN_NOT_CONFIGURED', '应用尚未配置账号登录服务');
    }
    login.validate();
    return login;
  }

  Future<ImSdkCustomerServiceSession> requestCustomerService(
      ImSdkCustomerServiceRequest request) async {
    final epoch = await _synchronizeProtectedEntry();
    return _serial(() async {
      if (epoch != null) _ensureHostEpoch(epoch);
      _requireAuthenticated();
      final generation = _generation;
      final result =
          await SdkCustomerServiceRepository(_account!.read(dioProvider))
              .request(request);
      if (generation != _generation || !isAuthenticated) {
        throw const ImSdkException('SESSION_CHANGED', '客服请求所属账号已变化');
      }
      _emit('customerServiceChanged', result.toMap());
      return result;
    });
  }

  /// Target-only API. Use requestCustomerService + the service view to retain
  /// queued/unknown states instead of receiving SERVICE_QUEUED/NOT_READY.
  Future<ImSdkDirectConversation> contactCustomerService(
      ImSdkCustomerServiceRequest request) async {
    final epoch = await _synchronizeProtectedEntry();
    return _serial(() async {
      if (epoch != null) _ensureHostEpoch(epoch);
      _requireAuthenticated();
      final generation = _generation;
      final result =
          await SdkCustomerServiceRepository(_account!.read(dioProvider))
              .contact(request);
      if (generation != _generation || !isAuthenticated) {
        throw const ImSdkException('SESSION_CHANGED', '客服请求所属账号已变化');
      }
      return result;
    });
  }

  Future<int?> _synchronizeProtectedEntry() async {
    if (_config?.hostManagedAuth != true) return null;
    if (!await synchronizeHostSession()) {
      throw const ImSdkException('HOST_NOT_AUTHENTICATED', '请先登录当前应用');
    }
    return _hostEpoch;
  }

  /// Deactivates this SDK session locally using the existing auth owner.
  Future<void> logout() {
    _invalidateHostOperation(forgetSession: true);
    final retirement =
        _config?.hostManagedAuth == true ? _startHostRetirement() : null;
    return _serial(() async {
      await retirement;
      await _logout();
    });
  }

  Future<void> _logout() async {
    final root = _requireRoot();
    _generation++;
    _authenticated = false;
    _changed();
    await root.read(authProvider.notifier).logout();
    _installRuntime(null);
    _emit('loggedOut');
  }

  Future<void> dispose() {
    if (_disposeFuture != null) return _disposeFuture!;
    _invalidateHostOperation(forgetSession: true);
    _hostClosed = true;
    WidgetsBinding.instance.removeObserver(this);
    final retirement =
        _config?.hostManagedAuth == true ? _startHostRetirement() : null;
    return _disposeFuture = _serial(() async {
      Object? failure;
      Future<void> attempt(FutureOr<void> Function() action) async {
        try {
          await action();
        } catch (error) {
          failure ??= error;
        }
      }

      _generation++;
      _authenticated = false;
      await attempt(() => _hostSessionChanges?.cancel());
      await attempt(() => retirement);
      await attempt(() => _installRuntime(null));
      _authSubscription?.close();
      _runtimeSubscription?.close();
      final root = _root;
      final runtime = root?.read(accountRuntimeProvider).valueOrNull;
      // Logout publishes its foreground state before credential deletion
      // finishes. Its owner must remain alive until that work has drained.
      await attempt(
          () => root?.read(authProvider.notifier).waitForLogoutCleanup());
      _root = null;
      TokenRefreshService.instance.stop();
      if (runtime != null) await attempt(runtime.retire);
      await attempt(() => root?.read(httpClientProvider).close());
      await attempt(() => root?.dispose());
      await attempt(HiveStorage.closeForSdk);
      _config = null;
      if (identical(_owner, this)) _owner = null;
      _disposed = true;
      _changed();
      await _events.close();
      if (failure != null)
        throw const ImSdkException('CLEANUP_FAILED', 'SDK已停止，部分本地资源清理失败');
    });
  }

  ProviderContainer _requireRoot() =>
      _root ?? (throw const ImSdkException('NOT_INITIALIZED', '请先初始化SDK'));
  void _requireAuthenticated() {
    _requireRoot();
    if (!isAuthenticated)
      throw const ImSdkException('NOT_AUTHENTICATED', '请先提交有效IM凭证');
  }

  void _changed() {
    _revision.value++;
  }

  void _emit(String type, [Map<String, Object?> data = const {}]) {
    if (!_events.isClosed) _events.add(ImSdkEvent(type, data));
  }

  void _installRuntime(AccountRuntime? runtime) {
    if (identical(runtime, _installed)) return;
    _badgeSubscription?.close();
    _badgeSubscription = null;
    unawaited(_gatewayStatus?.cancel());
    _gatewayStatus = null;
    _account?.dispose();
    _account = null;
    _installed = runtime;
    if (runtime == null ||
        runtime.lifecycle != AccountRuntimeLifecycle.active ||
        _root == null) {
      _changed();
      return;
    }
    final child =
        ProviderContainer(parent: _root, overrides: runtime.providerOverrides);
    _account = child;
    final generation = _generation;
    final gateway = child.read(gatewayProvider);
    _gatewayStatus = gateway.statusStream.listen((status) {
      if (generation == _generation)
        _emit('connectionChanged', {'status': status.name});
    });
    _badgeSubscription = child.listen<int?>(
        _sdkUnreadCountProvider(runtime.session.scope.spaceId), (_, count) {
      if (count != null && generation == _generation)
        _emit('unreadChanged',
            {'count': count, 'spaceId': runtime.session.scope.spaceId});
    }, fireImmediately: true);
    unawaited(ChatStartupRecovery(
            store: child.read(mediaLocalStoreProvider),
            runtime: child.read(mediaFileRuntimeProvider))
        .recoverSpace(runtime.session.scope.spaceId)
        .catchError((Object _) {
      if (generation == _generation)
        _emit('runtimeError', {'code': 'RECOVERY_FAILED'});
    }));
    final transition = _root!.read(spaceTransitionProvider);
    if (transition.isInProgress &&
        transition.targetSpaceId == runtime.session.scope.spaceId) {
      _root!
          .read(authProvider.notifier)
          .completeSpaceTransition(transition.revision);
      unawaited(_root!
          .read(accountRuntimeProvider.notifier)
          .retireCommittedSource(runtime));
    }
    _changed();
  }

  Future<void> _waitForRuntime(AccountScope scope,
      {bool Function()? operationIsCurrent}) async {
    final root = _requireRoot();
    final complete = Completer<void>();
    void checkOperation() {
      if (operationIsCurrent?.call() == false && !complete.isCompleted) {
        complete.completeError(
            const ImSdkException('HOST_SESSION_CHANGED', '应用登录状态已变化'));
      }
    }

    if (operationIsCurrent?.call() == false) {
      throw const ImSdkException('HOST_SESSION_CHANGED', '应用登录状态已变化');
    }
    bool matches(AccountRuntime? runtime) =>
        runtime?.session.scope == scope &&
        runtime?.lifecycle == AccountRuntimeLifecycle.active;
    if (matches(root.read(activeAccountRuntimeProvider))) return;
    final subscription = root.listen(activeAccountRuntimeProvider, (_, next) {
      checkOperation();
      if (matches(next) && !complete.isCompleted) complete.complete();
    }, fireImmediately: true);
    _revision.addListener(checkOperation);
    final errors = root.listen(accountRuntimeProvider, (_, next) {
      if (next.hasError && !complete.isCompleted)
        complete.completeError(
            const ImSdkException('RUNTIME_UNAVAILABLE', '账号运行时启动失败'));
    }, fireImmediately: true);
    try {
      await complete.future.timeout(const Duration(seconds: 20));
    } finally {
      subscription.close();
      errors.close();
      _revision.removeListener(checkOperation);
    }
  }
}

final _sdkUnreadCountProvider = Provider.family<int?, String>((ref, spaceId) {
  final conversations =
      ref.watch(releaseVisibleConversationsProvider(spaceId)).valueOrNull;
  return conversations == null
      ? null
      : calculateMessageBadgeCount(conversations);
}, dependencies: [releaseVisibleConversationsProvider]);

class _HostConsentStore implements PrivacyConsentStore {
  @override
  Future<PrivacyConsentDecision> currentPolicyDecision() async =>
      PrivacyConsentDecision.accepted;
  @override
  Future<void> acceptCurrentPolicy() async {}
  @override
  Future<void> declineCurrentPolicy() async {}
}

/// Internal error boundary, exposed to local tests without exporting it from
/// im_sdk.dart. Never forward backend messages, bodies or unknown error codes.
@visibleForTesting
ImSdkException imSdkPasswordLoginFailure(Object error) {
  if (error is NetworkError) {
    return const ImSdkException('LOGIN_NETWORK_ERROR', '连接失败，请检查网络后重试');
  }
  if (error is TimeoutException) {
    return const ImSdkException('LOGIN_TIMEOUT', '登录超时，请重试');
  }
  final code = switch (error) {
    ServerError e => e.code,
    AuthError e => e.code,
    ImSdkException e => e.code,
    _ => '',
  };
  const messages = {
    'AUTH_INVALID_CREDENTIALS': '账号或密码错误',
    'AUTH_INVALID_TOKEN': '登录已失效，请重新登录',
    'AUTH_CAPTCHA_REQUIRED': '请完成安全验证',
    'AUTH_CAPTCHA_INVALID': '安全验证有误，请重试',
    'AUTH_CAPTCHA_CHALLENGE_INVALID': '安全验证暂不可用，请重试',
    'AUTH_VERIFICATION_REQUIRED': '账号需要额外验证，请联系应用提供方',
    'AUTH_CONTEXT_REQUIRED': '请联系应用提供方配置账号所属企业',
    'TENANT_NOT_FOUND': '账号所属企业不可用，请联系应用提供方',
    'TENANT_NOT_MEMBER': '当前账号无法进入此应用',
    'TENANT_SUSPENDED': '账号所属企业暂不可用',
    'AUTH_STABLE_IDENTITY_MISSING': '账号身份不完整，请联系应用提供方',
    'RATE_LIMITED': '操作频繁，请稍后重试',
    'RUNTIME_UNAVAILABLE': '聊天服务启动失败，请重新登录',
    'SESSION_CHANGED': '登录状态已变化，请重新登录',
    'LOGIN_FAILED': '登录未完成，请重试',
  };
  final message = messages[code];
  return message == null
      ? const ImSdkException('LOGIN_FAILED', '登录未完成，请重试')
      : ImSdkException(code, message);
}

void _validateRegistrationIdentifier(String identifier, String channel) {
  if ((channel != 'sms' && channel != 'email') ||
      (channel == 'sms'
          ? !Validators.isMobile(identifier)
          : !Validators.isEmail(identifier))) {
    throw const ImSdkException('INVALID_ARGUMENT', '请输入有效的手机号或邮箱');
  }
}

void _validateCaptcha(String? token, String? answer) {
  if ((token != null || answer != null) &&
      (token?.trim().isNotEmpty != true || answer?.trim().isNotEmpty != true)) {
    throw const ImSdkException('INVALID_ARGUMENT', '请完成安全验证');
  }
}

ImSdkException _registrationFailure(Object error) {
  final code = switch (error) {
    ServerError e => e.code,
    AuthError e => e.code,
    ImSdkException e => e.code,
    _ => '',
  };
  const messages = {
    'REGISTER_PENDING_APPROVAL': '账号已创建，等待审批后请登录',
    'REGISTER_LOGIN_FAILED': '账号已创建，暂时无法进入聊天，请稍后登录',
    'REGISTER_CHANNEL_DISABLED': '当前注册方式不可用',
    'AUTH_CAPTCHA_REQUIRED': '请完成安全验证',
    'AUTH_CAPTCHA_INVALID': '安全验证有误，请重试',
    'AUTH_CAPTCHA_CHALLENGE_INVALID': '安全验证暂不可用，请重试',
    'AUTH_VERIFICATION_REQUIRED': '请输入验证码',
    'AUTH_VERIFICATION_INVALID': '验证码有误，请重试',
    'AUTH_VERIFICATION_EXPIRED': '验证码已过期，请重新获取',
    'VERIFICATION_SEND_FAILED': '验证码发送失败，请稍后重试',
    'RATE_LIMITED': '操作频繁，请稍后重试',
    'INVALID_ARGUMENT': '请检查注册信息',
    'AUTH_ACCOUNT_EXISTS': '账号已存在，请登录',
  };
  return ImSdkException(messages.containsKey(code) ? code : 'REGISTER_FAILED',
      messages[code] ?? '注册未完成，请检查信息或稍后重试');
}
