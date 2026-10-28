import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// SecureStorageService 抽象接口
///
/// HttpClient / TokenInterceptor 依赖此接口，不依赖具体实现。
abstract class SecureStorageService {
  /// 读取指定 key 的值，不存在时返回 null
  Future<String?> read(String key);

  /// 写入 key-value
  Future<void> write(String key, String value);

  /// 删除指定 key
  Future<void> delete(String key);

  /// 清除所有存储
  Future<void> deleteAll();

  // ---------------------------------------------------------------------------
  // 便捷方法：Token 相关 key 约定
  // ---------------------------------------------------------------------------

  /// 平台级 Token key
  static const String platformTokenKey = 'platform_token';

  /// 平台级轮换 Refresh Token key
  static const String platformRefreshTokenKey = 'platform_refresh_token';

  /// 可信设备会话 Token key
  static const String deviceSessionTokenKey = 'device_session_token';

  /// 当前激活空间 ID key
  static const String activeSpaceIdKey = 'active_space_id';

  /// 上次用户主动选择的空间 ID（退出登录时保留，用于下次登录恢复）
  static const String lastActiveSpaceIdKey = 'last_active_space_id';

  /// 已知租户 ID 列表 key（逗号分隔，用于 app 重启后恢复空间列表）
  static const String knownTenantIdsKey = 'known_tenant_ids';

  /// 是否已完成首次安装后的启动保护页
  static const String startupGateCompletedKey = 'startup_gate_completed_v1';

  /// 读取已知租户 ID 列表
  Future<List<String>> readKnownTenantIds() async {
    final raw = await read(knownTenantIdsKey);
    if (raw == null || raw.isEmpty) return [];
    return raw.split(',').where((s) => s.isNotEmpty).toList();
  }

  /// 写入已知租户 ID 列表
  Future<void> writeKnownTenantIds(List<String> ids) async {
    await write(knownTenantIdsKey, ids.join(','));
  }

  /// 租户级 accessToken key（按 spaceId 隔离）
  static String accessTokenKey(String spaceId) => 'access_token_$spaceId';

  /// 租户级 refreshToken key（按 spaceId 隔离）
  static String refreshTokenKey(String spaceId) => 'refresh_token_$spaceId';

  /// 租户名称 key（按 spaceId 隔离，用于空间列表显示）
  static String tenantNameKey(String spaceId) => 'tenant_name_$spaceId';

  /// 租户 Logo key（按 spaceId 隔离，用于空间列表显示）
  static String tenantLogoKey(String spaceId) => 'tenant_logo_$spaceId';

  /// 租户内成员角色 key。
  ///
  /// 新版本按 spaceId + userId 隔离，避免同一台设备在同一企业切换账号时，
  /// 复用上一个用户的所有者/管理员/客服角色。
  /// userId 为空时保留旧 key，仅用于租户列表展示等非授权场景；权限判定
  /// 只能读取带 userId 的账号级 key，不能跨账号复用旧角色。
  static String tenantMembershipRoleKey(String spaceId, [String? userId]) =>
      userId != null && userId.isNotEmpty
          ? 'tenant_membership_role_${spaceId}_$userId'
          : 'tenant_membership_role_$spaceId';

  /// 管理后台 accessToken key（按租户隔离）
  static String adminAccessTokenKey(String spaceId) =>
      'admin_access_token_$spaceId';

  /// 管理后台 refreshToken key（按租户隔离）
  static String adminRefreshTokenKey(String spaceId) =>
      'admin_refresh_token_$spaceId';

  /// 管理后台会话归属（站点 + 租户内用户）。
  ///
  /// admin token 绑定登录账号和服务站点，不能仅凭 spaceId 复用。旧版本没有
  /// 该元数据时按不可信缓存处理，由 AdminHttpClient 重新签发。
  static String adminTokenScopeKey(String spaceId) =>
      'admin_token_scope_v2_$spaceId';

  /// 管理后台角色码 key（按租户隔离）
  static String adminRoleCodesKey(String spaceId) =>
      'admin_role_codes_$spaceId';

  /// 管理后台权限码 key（按租户隔离）
  static String adminPermissionCodesKey(String spaceId) =>
      'admin_permission_codes_$spaceId';

  /// 管理后台平台超管标记 key（按租户隔离）
  static String adminIsPlatformAdministratorKey(String spaceId) =>
      'admin_is_platform_administrator_$spaceId';

  /// APP 稳定设备 ID。用于管理后台审计、风控和同设备 admin session 隔离。
  static const String deviceIdKey = 'device_id';

  Future<String> stableDeviceId() async {
    final existing = await read(deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final generated = const Uuid().v4();
    await write(deviceIdKey, generated);
    return generated;
  }

  /// 管理后台 token 对写入
  Future<void> writeAdminTokenPair({
    required String spaceId,
    required String accessToken,
    required String refreshToken,
  }) async {
    await write(adminAccessTokenKey(spaceId), accessToken);
    await write(adminRefreshTokenKey(spaceId), refreshToken);
  }

  Future<String?> readAdminAccessToken(String spaceId) =>
      read(adminAccessTokenKey(spaceId));

  Future<String?> readAdminRefreshToken(String spaceId) =>
      read(adminRefreshTokenKey(spaceId));

  Future<String?> readAdminTokenScope(String spaceId) =>
      read(adminTokenScopeKey(spaceId));

  Future<void> writeAdminTokenScope(String spaceId, String scope) =>
      write(adminTokenScopeKey(spaceId), scope);

  Future<void> clearAdminTokens(String spaceId) async {
    await Future.wait([
      delete(adminAccessTokenKey(spaceId)),
      delete(adminRefreshTokenKey(spaceId)),
      delete(adminTokenScopeKey(spaceId)),
      delete(adminRoleCodesKey(spaceId)),
      delete(adminPermissionCodesKey(spaceId)),
      delete(adminIsPlatformAdministratorKey(spaceId)),
    ]);
  }

  /// Clears admin credentials owned by a complete account-scope key.
  ///
  /// New account runtime code must pass [AccountScope.storageKeyHash]. The
  /// legacy [clearAdminTokens] name remains for older call sites whose owner
  /// was historically only a space id.
  Future<void> clearAdminCredentialsForOwner(String credentialOwner) =>
      clearAdminTokens(credentialOwner);

  /// 空间类型 key（按 spaceId + userId 隔离，避免同一租户不同用户类型串用缓存）
  static String spaceTypeKey(String spaceId, [String? userId]) =>
      userId != null ? 'space_type_${spaceId}_$userId' : 'space_type_$spaceId';

  /// 读取当前激活空间的 accessToken
  Future<String?> readAccessToken(String spaceId) =>
      read(accessTokenKey(spaceId));

  /// 读取当前激活空间的 refreshToken
  Future<String?> readRefreshToken(String spaceId) =>
      read(refreshTokenKey(spaceId));

  /// 写入租户级 Token 对
  Future<void> writeTokenPair({
    required String spaceId,
    required String accessToken,
    required String refreshToken,
  }) async {
    await write(accessTokenKey(spaceId), accessToken);
    await write(refreshTokenKey(spaceId), refreshToken);
  }

  /// 清除指定空间的 Token
  Future<void> clearTokens(String spaceId) async {
    await Future.wait([
      delete(accessTokenKey(spaceId)),
      delete(refreshTokenKey(spaceId)),
    ]);
  }

  /// 用一次新的登录结果完整替换平台凭证集合。
  ///
  /// 缺失的长期凭证必须删除，避免验证码登录或账号切换后复用上一个账号的
  /// refresh/device token。
  Future<void> replacePlatformCredentials({
    required String platformToken,
    String? platformRefreshToken,
    String? deviceSessionToken,
  }) async {
    await Future.wait([
      write(platformTokenKey, platformToken),
      if (platformRefreshToken != null && platformRefreshToken.isNotEmpty)
        write(platformRefreshTokenKey, platformRefreshToken)
      else
        delete(platformRefreshTokenKey),
      if (deviceSessionToken != null && deviceSessionToken.isNotEmpty)
        write(deviceSessionTokenKey, deviceSessionToken)
      else
        delete(deviceSessionTokenKey),
    ]);
  }

  /// 写入一次成功的长期平台续期结果。设备会话不轮换，必须原样保留。
  Future<void> writePlatformRenewal({
    required String platformToken,
    required String platformRefreshToken,
  }) async {
    await Future.wait([
      write(platformTokenKey, platformToken),
      write(platformRefreshTokenKey, platformRefreshToken),
    ]);
  }

  Future<void> clearPlatformCredentials() async {
    await Future.wait([
      delete(platformTokenKey),
      delete(platformRefreshTokenKey),
      delete(deviceSessionTokenKey),
    ]);
  }
}

/// flutter_secure_storage 具体实现
class SecureStorageServiceImpl extends SecureStorageService {
  final FlutterSecureStorage _storage;
  final String _prefix;

  SecureStorageServiceImpl({String namespace = 'im_sdk_default'})
      : _prefix = '${namespace}::',
        _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions:
              IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        ) {
    if (namespace.trim().isEmpty)
      throw ArgumentError.value(namespace, 'namespace');
  }

  @override
  Future<String?> read(String key) => _storage.read(key: '$_prefix$key');

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: '$_prefix$key', value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: '$_prefix$key');

  @override
  Future<void> deleteAll() async {
    final keys = (await _storage.readAll())
        .keys
        .where((key) => key.startsWith(_prefix))
        .toList(growable: false);
    for (final key in keys) {
      await _storage.delete(key: key);
    }
  }
}
