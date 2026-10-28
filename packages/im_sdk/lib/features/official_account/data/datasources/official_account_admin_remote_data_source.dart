import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_admin.dart';

class OfficialAccountAdminRemoteDataSource {
  final Dio _dio;

  const OfficialAccountAdminRemoteDataSource(this._dio);

  Future<OfficialAccountAdminOverview> updateProfile(
      OfficialAccountProfileChange change, OfficialAccountScope scope) async {
    if (change.validationError != null) {
      throw ArgumentError(change.validationError);
    }
    try {
      final response = await _dio.put<Map<String, dynamic>>(
          '/api/admin/v1/official-account/profile',
          data: change.toJson(),
          options: Options(extra: _scopeExtra(scope)));
      return _overview(_dataMap(response.data));
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  Future<OfficialAccountAdminInviteQr?> getInviteQr(OfficialAccountScope scope,
      {bool reset = false}) async {
    try {
      final response = await _dio.request<Map<String, dynamic>>(
          '/api/admin/v1/official-account/invite-qr',
          options: Options(
              method: reset ? 'POST' : 'GET', extra: _scopeExtra(scope)));
      if (response.data?['data'] == null) return null;
      final data = _dataMap(response.data);
      return OfficialAccountAdminInviteQr(
          tokenId: _requiredString(data['tokenId'], 'tokenId'),
          token: _requiredString(data['token'], 'token'),
          qrPayload: _requiredString(data['qrPayload'], 'qrPayload'),
          usedCount: _integer(data['usedCount']),
          createdAt:
              DateTime.parse(_requiredString(data['createdAt'], 'createdAt')));
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  Future<OfficialAccountAdminOverview> getOverview(
    OfficialAccountScope scope,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/admin/v1/official-account',
        options: Options(extra: _scopeExtra(scope)),
      );
      return _overview(_dataMap(response.data));
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  Future<OfficialAccountAdminOverview> updateConfig(
    OfficialAccountAdminConfig config,
    OfficialAccountScope scope,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/admin/v1/official-account/config',
        data: {
          'handoffMode': config.handoffMode,
          'servingNoticeEnabled': config.servingNoticeEnabled,
          'servingNoticeText': config.servingNoticeText,
          'friendAutoJoin': config.friendAutoJoin,
          if (config.mirrorStaffReplyToOfficial != null)
            'mirrorStaffReplyToOfficial': config.mirrorStaffReplyToOfficial,
          'inboundHandoffEnabled': config.inboundHandoffEnabled,
          'handoffNoticeCooldownMinutes':
              config.handoffNoticeCooldownMinutes.clamp(0, 1440).toInt(),
          'handoffAssignedText': config.handoffAssignedText,
          'handoffQueuedText': config.handoffQueuedText,
          'relayCustomerMessageToStaff': config.relayCustomerMessageToStaff,
          'welcomeEnabled': config.welcomeEnabled,
          'welcomeText': config.welcomeText,
          'menuEnabled': config.menuEnabled,
        },
        options: Options(extra: _scopeExtra(scope)),
      );
      return _overview(_dataMap(response.data));
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  OfficialAccountAdminOverview _overview(Map<String, dynamic> data) {
    return OfficialAccountAdminOverview(
      lppId: _nullableString(data['lppId']),
      serviceAccountId:
          _requiredString(data['serviceAccountId'], 'serviceAccountId'),
      accountCode: _requiredString(data['accountCode'], 'accountCode'),
      displayName: _requiredString(data['displayName'], 'displayName'),
      avatarUrl: _nullableString(data['avatarUrl']),
      status: _integer(data['status']) == 1
          ? OfficialAccountAdminStatus.active
          : OfficialAccountAdminStatus.disabled,
      officialUserId: _requiredString(data['officialUserId'], 'officialUserId'),
      loginName: _requiredString(data['loginName'], 'loginName'),
      hasPassword: data['hasPassword'] == true,
      linkedCustomerCount: _integer(data['linkedCustomerCount']),
      groupCount: _integer(data['groupCount']),
      menuVersion: _integer(data['menuVersion']),
      menuItemCount: _integer(data['menuItemCount']),
      config: _config(_map(data['config'])),
    );
  }

  OfficialAccountAdminConfig _config(Map<String, dynamic> data) {
    return OfficialAccountAdminConfig(
      handoffMode:
          data['handoffMode'] == 'in_official' ? 'in_official' : 'separate_dm',
      servingNoticeEnabled: data['servingNoticeEnabled'] != false,
      servingNoticeText:
          data['servingNoticeText'] as String? ?? '客服「{staff}」为您服务。',
      friendAutoJoin: data['friendAutoJoin'] != false,
      mirrorStaffReplyToOfficial: data['mirrorStaffReplyToOfficial'] as bool?,
      inboundHandoffEnabled: data['inboundHandoffEnabled'] == true,
      handoffNoticeCooldownMinutes:
          _integer(data['handoffNoticeCooldownMinutes']).clamp(0, 1440).toInt(),
      handoffAssignedText:
          _requiredString(data['handoffAssignedText'], 'handoffAssignedText'),
      handoffQueuedText:
          _requiredString(data['handoffQueuedText'], 'handoffQueuedText'),
      relayCustomerMessageToStaff: data['relayCustomerMessageToStaff'] == true,
      welcomeEnabled: data['welcomeEnabled'] == true,
      welcomeText: _requiredString(data['welcomeText'], 'welcomeText'),
      menuEnabled: data['menuEnabled'] == true,
    );
  }

  Map<String, dynamic> _dataMap(Map<String, dynamic>? envelope) {
    return _map(envelope?['data']);
  }

  Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, entry) => MapEntry(key.toString(), entry));
    }
    return const {};
  }

  String? _nullableString(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  String _requiredString(Object? value, String field) {
    final text = _nullableString(value);
    if (text == null) {
      throw StateError('Official account admin response is missing $field');
    }
    return text;
  }

  int _integer(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

  Map<String, Object?> _scopeExtra(OfficialAccountScope scope) => {
        'expectedAdminSiteId': scope.siteId,
        'expectedAdminSpaceId': scope.spaceId,
        'expectedAdminUserId': scope.userId,
      };
}
