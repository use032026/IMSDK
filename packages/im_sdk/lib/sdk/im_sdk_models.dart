/// Configuration belongs to one SDK runtime in a Flutter isolate.
class ImSdkConfig {
  const ImSdkConfig({
    required this.apiBaseUrl,
    required this.serviceRealmId,
    required this.privacyConsentGranted,
    this.gatewayBaseUrl,
    this.storageNamespace = 'default',
    this.locale = 'zh_CN',
    this.themeMode = 'system',
    this.passwordLogin,
    this.hostManagedAuth = false,
  });

  final String apiBaseUrl;
  final String? gatewayBaseUrl;
  final String serviceRealmId;
  final bool privacyConsentGranted;
  final String storageNamespace;
  final String locale;
  final String themeMode;

  String get normalizedThemeMode {
    final value = themeMode.trim().toLowerCase();
    if (!const {'system', 'light', 'dark'}.contains(value)) {
      throw const ImSdkException('INVALID_PRESENTATION', '主题配置无效');
    }
    return value;
  }

  String get normalizedLocale => normalizeImSdkLocale(locale);
  final ImSdkPasswordLoginConfig? passwordLogin;

  /// The integrating app owns identity. SDK login UI is disabled in this mode.
  final bool hostManagedAuth;

  void validate() {
    if (!privacyConsentGranted) {
      throw const ImSdkException('CONSENT_REQUIRED', '宿主需先取得用户同意');
    }
    _httpsEndpoint(apiBaseUrl, 'apiBaseUrl');
    if (gatewayBaseUrl != null) {
      final gateway = Uri.tryParse(gatewayBaseUrl!);
      if (gateway == null ||
          !const {'https', 'wss'}.contains(gateway.scheme) ||
          gateway.host.isEmpty ||
          gateway.userInfo.isNotEmpty ||
          gateway.hasQuery ||
          gateway.hasFragment) {
        throw const ImSdkException(
            'INVALID_CONFIG', 'gatewayBaseUrl需要HTTPS/WSS地址');
      }
    }
    _required(serviceRealmId, 'serviceRealmId');
    normalizedThemeMode;
    normalizedLocale;
    passwordLogin?.validate();
    if (!RegExp(r'^[a-zA-Z0-9._-]{1,64}$').hasMatch(storageNamespace)) {
      throw const ImSdkException(
          'INVALID_CONFIG', 'storageNamespace仅允许字母数字及._-');
    }
  }

  Map<String, Object?> toMap() => {
        'apiBaseUrl': apiBaseUrl,
        'gatewayBaseUrl': gatewayBaseUrl,
        'serviceRealmId': serviceRealmId,
        'privacyConsentGranted': privacyConsentGranted,
        'storageNamespace': storageNamespace,
        'locale': locale,
        'themeMode': themeMode,
        if (passwordLogin != null) 'passwordLogin': passwordLogin!.toMap(),
        'hostManagedAuth': hostManagedAuth,
      };

  factory ImSdkConfig.fromMap(Map<String, dynamic> value) => ImSdkConfig(
        apiBaseUrl: _string(value, 'apiBaseUrl'),
        gatewayBaseUrl: value['gatewayBaseUrl'] as String?,
        serviceRealmId: _string(value, 'serviceRealmId'),
        privacyConsentGranted: value['privacyConsentGranted'] == true,
        storageNamespace: value['storageNamespace'] as String? ?? 'default',
        locale: value['locale'] as String? ?? 'zh_CN',
        themeMode: value['themeMode'] as String? ?? 'system',
        passwordLogin: value['passwordLogin'] == null
            ? null
            : ImSdkPasswordLoginConfig.fromMap(value['passwordLogin']),
        hostManagedAuth: value['hostManagedAuth'] == true,
      );

  @override
  bool operator ==(Object other) =>
      other is ImSdkConfig &&
      apiBaseUrl == other.apiBaseUrl &&
      gatewayBaseUrl == other.gatewayBaseUrl &&
      serviceRealmId == other.serviceRealmId &&
      storageNamespace == other.storageNamespace &&
      privacyConsentGranted == other.privacyConsentGranted &&
      locale == other.locale &&
      themeMode == other.themeMode &&
      hostManagedAuth == other.hostManagedAuth &&
      passwordLogin == other.passwordLogin;
  @override
  int get hashCode => Object.hash(
      apiBaseUrl,
      gatewayBaseUrl,
      serviceRealmId,
      storageNamespace,
      privacyConsentGranted,
      locale,
      themeMode,
      passwordLogin,
      hostManagedAuth);

  /// Presentation changes use updatePresentation; repeated runtime setup is
  /// harmless and must never reset the host's most recent appearance choice.
  bool hasSameRuntimeConfiguration(ImSdkConfig other) =>
      apiBaseUrl == other.apiBaseUrl &&
      gatewayBaseUrl == other.gatewayBaseUrl &&
      serviceRealmId == other.serviceRealmId &&
      storageNamespace == other.storageNamespace &&
      privacyConsentGranted == other.privacyConsentGranted &&
      passwordLogin == other.passwordLogin &&
      hostManagedAuth == other.hostManagedAuth;
}

/// Canonical SDK language identifiers. Explicit unsupported languages fail
/// closed rather than silently changing the user's selected language.
String normalizeImSdkLocale(String value) {
  final tag = value.trim().replaceAll('_', '-').toLowerCase();
  if (tag == 'system') return tag;
  final parts = tag.split('-');
  if (parts.isEmpty || parts.length > 3 || parts.any((part) => part.isEmpty)) {
    throw const ImSdkException('INVALID_PRESENTATION', '语言配置无效');
  }
  final language = parts.first;
  if (!const {'zh', 'en', 'ja', 'ko', 'vi'}.contains(language)) {
    throw const ImSdkException('INVALID_PRESENTATION', '语言配置无效');
  }
  String? script;
  String? region;
  for (final part in parts.skip(1)) {
    if (RegExp(r'^[a-z]{4}$').hasMatch(part) &&
        script == null &&
        region == null) {
      script = part;
    } else if (RegExp(r'^(?:[a-z]{2}|[0-9]{3})$').hasMatch(part) &&
        region == null) {
      region = part;
    } else {
      throw const ImSdkException('INVALID_PRESENTATION', '语言配置无效');
    }
  }
  if (language == 'zh') {
    if (script != null && script != 'hans' && script != 'hant') {
      throw const ImSdkException('INVALID_PRESENTATION', '语言配置无效');
    }
    if (region != null &&
        !const {'cn', 'sg', 'tw', 'hk', 'mo'}.contains(region)) {
      throw const ImSdkException('INVALID_PRESENTATION', '语言配置无效');
    }
    if (script == 'hant' ||
        (script == null && const {'tw', 'hk', 'mo'}.contains(region)))
      return 'zh-TW';
    return 'zh-CN';
  }
  final allowedScript = switch (language) {
    'en' || 'vi' => 'latn',
    'ja' => 'jpan',
    'ko' => 'kore',
    _ => '',
  };
  if (script != null && script != allowedScript) {
    throw const ImSdkException('INVALID_PRESENTATION', '语言配置无效');
  }
  return language;
}

/// Fixed authentication routing supplied by the integrating app, never by the
/// end user. The backend owns cross-app account mapping and IM credentials.
class ImSdkPasswordLoginConfig {
  const ImSdkPasswordLoginConfig({
    this.loginType = 'login_name',
    this.tenantCode,
    this.space = 'tenant',
  });

  /// Explicit personal scope never restores or selects an enterprise.
  const ImSdkPasswordLoginConfig.personal()
      : loginType = 'lpp_id',
        tenantCode = null,
        space = 'personal';

  final String loginType;
  final String? tenantCode;
  final String space;
  bool get usePersonalSpace => space == 'personal';

  void validate() {
    if (!const {'login_name', 'lpp_id'}.contains(loginType)) {
      throw const ImSdkException('INVALID_CONFIG', '账号登录方式配置无效');
    }
    if (!const {'tenant', 'personal'}.contains(space)) {
      throw const ImSdkException('INVALID_CONFIG', '账号空间配置无效');
    }
    if (usePersonalSpace) {
      if (loginType != 'lpp_id' || tenantCode != null) {
        throw const ImSdkException('INVALID_CONFIG', '个人空间登录配置冲突');
      }
    } else if (tenantCode == null || tenantCode!.trim().isEmpty) {
      throw const ImSdkException('INVALID_CONFIG', '宿主需配置账号所属企业');
    }
  }

  Map<String, Object?> toMap() => {
        if (space != 'tenant') 'space': space,
        'loginType': loginType,
        if (tenantCode != null) 'tenantCode': tenantCode,
      };

  factory ImSdkPasswordLoginConfig.fromMap(Object? value) {
    if (value is! Map ||
        (value['loginType'] != null && value['loginType'] is! String) ||
        (value['tenantCode'] != null && value['tenantCode'] is! String) ||
        (value['space'] != null && value['space'] is! String)) {
      throw const ImSdkException('INVALID_CONFIG', '账号登录配置无效');
    }
    return ImSdkPasswordLoginConfig(
      loginType: value['loginType'] as String? ?? 'login_name',
      tenantCode: value['tenantCode'] as String?,
      space: value['space'] as String? ?? 'tenant',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ImSdkPasswordLoginConfig &&
      loginType == other.loginType &&
      tenantCode == other.tenantCode &&
      space == other.space;

  @override
  int get hashCode => Object.hash(loginType, tenantCode, space);
}

class ImSdkCaptchaChallenge {
  const ImSdkCaptchaChallenge({required this.token, required this.question});
  final String token;
  final String question;

  @override
  String toString() => 'ImSdkCaptchaChallenge(<redacted>)';
}

/// IM credentials issued by the IM server through the host's trusted backend.
/// Never pass a host login token or a server/admin secret as an access token.
class ImSdkCredentials {
  const ImSdkCredentials({
    required this.platformUserId,
    required this.userId,
    required this.spaceId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.platformToken,
    this.platformRefreshToken,
    this.deviceSessionToken,
  });
  final String platformUserId;
  final String userId;
  final String spaceId;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String? platformToken;
  final String? platformRefreshToken;
  final String? deviceSessionToken;

  void validate({DateTime? now}) {
    for (final pair in [
      (platformUserId, 'platformUserId'),
      (userId, 'userId'),
      (spaceId, 'spaceId'),
      (accessToken, 'accessToken'),
      (refreshToken, 'refreshToken')
    ]) {
      _required(pair.$1, pair.$2);
    }
    if (!expiresAt.isAfter(now ?? DateTime.now())) {
      throw const ImSdkException('CREDENTIALS_EXPIRED', '请向宿主后端获取有效IM凭证');
    }
  }

  factory ImSdkCredentials.fromMap(Map<String, dynamic> value) {
    final expiry = DateTime.tryParse(_string(value, 'expiresAt'));
    if (expiry == null) {
      throw const ImSdkException('INVALID_ARGUMENT', 'expiresAt需要ISO8601时间');
    }
    return ImSdkCredentials(
        platformUserId: _string(value, 'platformUserId'),
        userId: _string(value, 'userId'),
        spaceId: _string(value, 'spaceId'),
        accessToken: _string(value, 'accessToken'),
        refreshToken: _string(value, 'refreshToken'),
        expiresAt: expiry,
        platformToken: value['platformToken'] as String?,
        platformRefreshToken: value['platformRefreshToken'] as String?,
        deviceSessionToken: value['deviceSessionToken'] as String?);
  }

  @override
  String toString() => 'ImSdkCredentials(<redacted>)';
}

class ImSdkDirectConversation {
  const ImSdkDirectConversation(
      {required this.conversationId,
      String? title,
      this.peerUserId,
      this.avatarUrl,
      this.serviceThreadId})
      : title = title ?? '聊天',
        titleIsDefault = title == null,
        sdkDefaultTitle = title == null ? '聊天' : null;

  const ImSdkDirectConversation._customerService({
    required this.conversationId,
    required this.serviceThreadId,
  })  : title = '客服',
        titleIsDefault = true,
        sdkDefaultTitle = '客服',
        peerUserId = null,
        avatarUrl = null;
  final String conversationId;
  final String title;
  final bool titleIsDefault;

  /// Present only for titles created by the SDK itself, never from host maps.
  final String? sdkDefaultTitle;
  final String? peerUserId;
  final String? avatarUrl;

  /// Customer-service identity is kept distinct from its underlying conversation.
  final String? serviceThreadId;
  void validate() => _required(conversationId, 'conversationId');
  factory ImSdkDirectConversation.fromMap(Map<String, dynamic> value) =>
      ImSdkDirectConversation(
          conversationId: _string(value, 'conversationId'),
          title: value['title'] as String?,
          peerUserId: value['peerUserId'] as String?,
          avatarUrl: value['avatarUrl'] as String?,
          serviceThreadId: value['serviceThreadId'] as String?);
}

enum ImSdkCustomerServiceEntry { serviceAccount, currentTenant }

class ImSdkCustomerServiceRequest {
  const ImSdkCustomerServiceRequest(
      {required this.serviceAccountId,
      this.locale,
      this.category,
      this.sourceUrl})
      : entry = ImSdkCustomerServiceEntry.serviceAccount;
  const ImSdkCustomerServiceRequest.currentTenant()
      : entry = ImSdkCustomerServiceEntry.currentTenant,
        serviceAccountId = '',
        locale = null,
        category = null,
        sourceUrl = null;
  final ImSdkCustomerServiceEntry entry;
  final String serviceAccountId;
  final String? locale;
  final String? category;
  final String? sourceUrl;
  void validate() {
    if (entry == ImSdkCustomerServiceEntry.serviceAccount) {
      _required(serviceAccountId, 'serviceAccountId');
    } else if (serviceAccountId.isNotEmpty) {
      throw const ImSdkException('INVALID_ARGUMENT', '当前企业入口不能指定服务账号');
    }
  }

  Map<String, Object?> toMap() =>
      entry == ImSdkCustomerServiceEntry.currentTenant
          ? {'entry': 'currentTenant'}
          : {
              'entry': 'serviceAccount',
              'serviceAccountId': serviceAccountId,
              if (locale != null) 'locale': locale,
              if (category != null) 'category': category,
              if (sourceUrl != null) 'sourceUrl': sourceUrl,
            };

  factory ImSdkCustomerServiceRequest.fromMap(Map<String, dynamic> value) {
    final entry = value['entry'];
    if (entry == 'currentTenant') {
      if (_string(value, 'serviceAccountId').trim().isNotEmpty) {
        throw const ImSdkException('INVALID_ARGUMENT', '当前企业入口不能指定服务账号');
      }
      return const ImSdkCustomerServiceRequest.currentTenant();
    }
    if (entry != null && entry != 'serviceAccount') {
      throw const ImSdkException('INVALID_ARGUMENT', '未知客服入口');
    }
    return ImSdkCustomerServiceRequest(
        serviceAccountId: _string(value, 'serviceAccountId'),
        locale: value['locale'] as String?,
        category: value['category'] as String?,
        sourceUrl: value['sourceUrl'] as String?);
  }

  @override
  bool operator ==(Object other) =>
      other is ImSdkCustomerServiceRequest &&
      entry == other.entry &&
      serviceAccountId == other.serviceAccountId &&
      locale == other.locale &&
      category == other.category &&
      sourceUrl == other.sourceUrl;
  @override
  int get hashCode =>
      Object.hash(entry, serviceAccountId, locale, category, sourceUrl);
}

enum ImSdkCustomerServiceStatus { queued, active, unknown }

/// Authoritative handoff snapshot; queued never grants access to a chat page.
class ImSdkCustomerServiceSession {
  const ImSdkCustomerServiceSession({
    required this.threadId,
    required this.status,
    this.conversationId,
    this.staffUserId,
    this.staffDisplayName,
  });
  final String threadId;
  final ImSdkCustomerServiceStatus status;
  final String? conversationId;
  final String? staffUserId;
  final String? staffDisplayName;

  bool get canOpenConversation =>
      threadId.trim().isNotEmpty &&
      status == ImSdkCustomerServiceStatus.active &&
      (conversationId?.trim().isNotEmpty ?? false);

  ImSdkDirectConversation toConversation() {
    if (!canOpenConversation) {
      throw ImSdkException(
          status == ImSdkCustomerServiceStatus.queued
              ? 'SERVICE_QUEUED'
              : 'SERVICE_NOT_READY',
          '客服会话尚未接入');
    }
    return ImSdkDirectConversation._customerService(
        conversationId: conversationId!, serviceThreadId: threadId);
  }

  Map<String, Object?> toMap() => {
        'threadId': threadId,
        'status': status.name,
        'conversationId': conversationId,
        'staffUserId': staffUserId,
        'staffDisplayName': staffDisplayName,
        'canOpenConversation': canOpenConversation,
      };
}

class ImSdkEvent {
  ImSdkEvent(this.type, [Map<String, Object?> data = const {}])
      : data = Map.unmodifiable(data);
  final String type;
  final Map<String, Object?> data;
  Map<String, Object?> toMap() => {'type': type, ...data};
}

class ImSdkException implements Exception {
  const ImSdkException(this.code, this.message);
  final String code;
  final String message;
  @override
  String toString() => 'ImSdkException($code): $message';
}

void _required(String value, String name) {
  if (value.trim().isEmpty)
    throw ImSdkException('INVALID_ARGUMENT', '$name不能为空');
}

String _string(Map<String, dynamic> value, String key) =>
    value[key] as String? ?? '';
void _httpsEndpoint(String raw, String name) {
  final uri = Uri.tryParse(raw);
  if (uri == null ||
      uri.scheme != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment) {
    throw ImSdkException('INVALID_CONFIG', '$name需要有效HTTPS地址');
  }
}

/// Server-controlled channels for personal account registration.
class ImSdkRegistrationVerificationSettings {
  const ImSdkRegistrationVerificationSettings(
      {required this.smsEnabled,
      required this.emailEnabled,
      required this.smsRequired,
      required this.emailRequired});
  final bool smsEnabled;
  final bool emailEnabled;
  final bool smsRequired;
  final bool emailRequired;
  bool isEnabled(String channel) =>
      channel == 'sms' ? smsEnabled : channel == 'email' && emailEnabled;
  bool isRequired(String channel) =>
      channel == 'sms' ? smsRequired : channel == 'email' && emailRequired;
}
