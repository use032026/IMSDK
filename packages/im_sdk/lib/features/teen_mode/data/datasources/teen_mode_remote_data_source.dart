import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';

class TeenModeRemoteDataSource {
  const TeenModeRemoteDataSource(this._dio);

  final Dio _dio;

  static const _base = '/api/client/v1';

  Future<TeenModeConfig> getConfig() => _request(
      () async => _config(_dataMap((await _dio.get<Map<String, dynamic>>(
            '$_base/teen-mode/config',
          ))
              .data)));

  Future<TeenModeProfile> getMe() => _request(
      () async => _profile(_dataMap((await _dio.get<Map<String, dynamic>>(
            '$_base/teen-mode/me',
          ))
              .data)));

  Future<TeenModeProfile> enable({
    required String passcode,
    required String timeZoneId,
  }) =>
      _request(
          () async => _profile(_dataMap((await _dio.post<Map<String, dynamic>>(
                '$_base/teen-mode/enable',
                data: {'passcode': passcode, 'timeZoneId': timeZoneId},
              ))
                  .data)));

  Future<TeenModeDisableResult> disable(String passcode) => _request(() async {
        final data = _dataMap((await _dio.post<Map<String, dynamic>>(
          '$_base/teen-mode/disable',
          data: {'passcode': passcode},
        ))
            .data);
        return TeenModeDisableResult(
          disabled: data['disabled'] == true,
          pendingApproval: data['pendingApproval'] == true,
          approvalRequestId: _string(data['approvalRequestId']),
          message: _string(data['message']) ?? '',
        );
      });

  Future<void> updatePasscode({
    String? currentPasscode,
    required String newPasscode,
  }) =>
      _request(() async {
        final response = await _dio.put<Map<String, dynamic>>(
          '$_base/teen-mode/passcode',
          data: {
            if (currentPasscode?.isNotEmpty == true)
              'currentPasscode': currentPasscode,
            'newPasscode': newPasscode,
          },
        );
        _data(response.data);
      });

  Future<TeenModeSession> heartbeat(String timeZoneId) => _request(
      () async => _session(_dataMap((await _dio.post<Map<String, dynamic>>(
            '$_base/teen-mode/heartbeat',
            data: {'timeZoneId': timeZoneId},
          ))
              .data)));

  Future<TeenModeSession> getSessionStatus() => _request(
      () async => _session(_dataMap((await _dio.get<Map<String, dynamic>>(
            '$_base/teen-mode/session-status',
          ))
              .data)));

  Future<TeenModeExtendRequestResult> requestExtension(int minutes) =>
      _request(() async {
        final data = _dataMap((await _dio.post<Map<String, dynamic>>(
          '$_base/teen-mode/extend-request',
          data: {'minutes': minutes},
        ))
            .data);
        return TeenModeExtendRequestResult(
          submitted: data['submitted'] == true,
          requestId: _string(data['requestId']),
          code: _string(data['code']) ?? '',
          message: _string(data['message']) ?? '',
        );
      });

  Future<GuardianApprovalPage> getMyRequests({
    required String status,
    String? cursor,
    required int limit,
  }) =>
      _approvalPageRequest(
        '$_base/teen-mode/my-requests',
        status: status,
        cursor: cursor,
        limit: limit,
      );

  Future<void> cancelMyRequest(String requestId) => _request(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          '$_base/teen-mode/my-requests/${_path(requestId)}/cancel',
        );
        _data(response.data);
      });

  Future<GuardianBindCode> createBindCode({
    required GuardianRole role,
    required String relation,
  }) =>
      _request(() async {
        final data = _dataMap((await _dio.post<Map<String, dynamic>>(
          '$_base/guardian/bind-codes',
          data: {'role': _guardianRoleWire(role), 'relation': relation},
        ))
            .data);
        return GuardianBindCode(
          tokenId: _requiredString(data['tokenId'], 'tokenId'),
          code: _requiredString(data['code'], 'code'),
          issuerRole: _guardianRole(data['issuerRole']),
          expiresAt: _date(data['expiresAt']),
        );
      });

  Future<void> cancelBindCode(String tokenId) => _request(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          '$_base/guardian/bind-codes/${_path(tokenId)}/cancel',
        );
        _data(response.data);
      });

  Future<GuardianLink> bind({
    required String code,
    required String relation,
  }) =>
      _request(
          () async => _link(_dataMap((await _dio.post<Map<String, dynamic>>(
                '$_base/guardian/bind',
                data: {'code': code, 'relation': relation},
              ))
                  .data)));

  Future<List<GuardianLink>> getLinks() => _request(() async {
        final data = _data((await _dio.get<Map<String, dynamic>>(
          '$_base/guardian/links',
        ))
            .data);
        return _list(data).map(_link).toList(growable: false);
      });

  Future<GuardianLink> updateLink({
    required String linkId,
    String? relation,
    bool? isPrimary,
    bool? canApprove,
    bool? canManagePolicy,
  }) =>
      _request(() async => _link(_dataMap((await _dio.put<Map<String, dynamic>>(
            '$_base/guardian/links/${_path(linkId)}',
            data: {
              if (relation != null) 'relation': relation,
              if (isPrimary != null) 'isPrimary': isPrimary,
              if (canApprove != null) 'canApprove': canApprove,
              if (canManagePolicy != null) 'canManagePolicy': canManagePolicy,
            },
          ))
              .data)));

  Future<GuardianUnbindResult> deleteLink(String linkId) => _request(() async {
        final data = _dataMap((await _dio.delete<Map<String, dynamic>>(
          '$_base/guardian/links/${_path(linkId)}',
        ))
            .data);
        return GuardianUnbindResult(
          unbound: data['unbound'] == true,
          pendingApproval: data['pendingApproval'] == true,
          approvalRequestId: _string(data['approvalRequestId']),
          message: _string(data['message']) ?? '',
        );
      });

  Future<List<GuardianMinor>> getMinors() => _request(() async {
        final data = _data((await _dio.get<Map<String, dynamic>>(
          '$_base/guardian/minors',
        ))
            .data);
        return _list(data).map(_minor).toList(growable: false);
      });

  Future<GuardianMinor> getMinor(String minorPlatformUserId) => _request(
      () async => _minor(_dataMap((await _dio.get<Map<String, dynamic>>(
            '$_base/guardian/minors/${_path(minorPlatformUserId)}',
          ))
              .data)));

  Future<GuardianMinor> updateMinorPolicy({
    required String minorPlatformUserId,
    required TeenPolicy policy,
  }) =>
      _request(
          () async => _minor(_dataMap((await _dio.put<Map<String, dynamic>>(
                '$_base/guardian/minors/${_path(minorPlatformUserId)}/policy',
                data: {'policy': policy},
              ))
                  .data)));

  Future<GuardianMinor> extendMinor({
    required String minorPlatformUserId,
    required int minutes,
  }) =>
      _request(
          () async => _minor(_dataMap((await _dio.post<Map<String, dynamic>>(
                '$_base/guardian/minors/${_path(minorPlatformUserId)}/extend',
                data: {'minutes': minutes},
              ))
                  .data)));

  Future<GuardianApprovalPage> getApprovals({
    required String status,
    String? cursor,
    required int limit,
  }) =>
      _approvalPageRequest(
        '$_base/guardian/approvals',
        status: status,
        cursor: cursor,
        limit: limit,
      );

  Future<GuardianApproval> decideApproval({
    required String requestId,
    required bool approve,
    String? note,
  }) =>
      _request(
          () async => _approval(_dataMap((await _dio.post<Map<String, dynamic>>(
                '$_base/guardian/approvals/${_path(requestId)}/decide',
                data: {
                  'approve': approve,
                  if (note?.trim().isNotEmpty == true) 'note': note!.trim(),
                },
              ))
                  .data)));

  Future<GuardianApprovalPage> _approvalPageRequest(
    String path, {
    required String status,
    String? cursor,
    required int limit,
  }) =>
      _request(() async {
        final data = _dataMap((await _dio.get<Map<String, dynamic>>(
          path,
          queryParameters: {
            'status': status,
            if (cursor?.isNotEmpty == true) 'cursor': cursor,
            'limit': limit,
          },
        ))
            .data);
        return GuardianApprovalPage(
          items: _list(data['items']).map(_approval).toList(growable: false),
          nextCursor: _string(data['nextCursor']),
          pendingCount: _int(data['pendingCount']),
        );
      });

  Future<T> _request<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  TeenModeConfig _config(Map<String, dynamic> data) => TeenModeConfig(
        enabled: data['enabled'] == true,
        selfEnrollmentEnabled: data['selfEnrollmentEnabled'] == true,
        guardianEnabled: data['guardianEnabled'] == true,
        minorAgeThreshold: _int(data['minorAgeThreshold']),
        maxGuardiansPerMinor: _int(data['maxGuardiansPerMinor']),
        bindTokenTtlMinutes: _int(data['bindTokenTtlMinutes']),
        approvalTtlHours: _int(data['approvalTtlHours']),
        unboundMinorBehavior: _string(data['unboundMinorBehavior']) ?? '',
        policyCatalog: _list(data['policyCatalog'])
            .map(_catalogItem)
            .where((item) => item.key.isNotEmpty)
            .toList(growable: false),
      );

  TeenPolicyCatalogItem _catalogItem(Map<String, dynamic> data) =>
      TeenPolicyCatalogItem(
        key: _string(data['key']) ?? '',
        label: _string(data['label']) ?? '',
        description: _string(data['description']) ?? '',
        group: _string(data['group']) ?? '',
        kind: _policyKind(data['kind']),
        defaultValue: _policyValue(data['defaultValue']),
        options: _options(data['options']),
        min: _nullableInt(data['min']),
        max: _nullableInt(data['max']),
        locked: data['locked'] == true,
      );

  List<TeenPolicyOption> _options(Object? value) {
    if (value is Map) {
      return value.entries
          .map((entry) => TeenPolicyOption(
                value: _policyValue(entry.key) ?? entry.key.toString(),
                label: entry.value?.toString() ?? entry.key.toString(),
              ))
          .toList(growable: false);
    }
    return _list(value)
        .map((option) {
          final optionValue = _policyValue(option['value']);
          if (optionValue == null) return null;
          return TeenPolicyOption(
            value: optionValue,
            label: _string(option['label']) ?? optionValue.toString(),
          );
        })
        .whereType<TeenPolicyOption>()
        .toList(growable: false);
  }

  TeenModeProfile _profile(Map<String, dynamic> data) {
    final active = data['active'] == true;
    return TeenModeProfile(
      active: active,
      source: _source(data['source']),
      sourceLabel: _string(data['sourceLabel']) ?? '',
      lockLevel: _int(data['lockLevel']),
      canSelfDisable: data['canSelfDisable'] == true,
      hasPasscode: data['hasPasscode'] == true,
      timeZoneId: _string(data['timeZoneId']) ?? 'Asia/Shanghai',
      activatedAt: _date(data['activatedAt']),
      autoReleaseAt: _date(data['autoReleaseAt']),
      policy: _policy(data['policy']),
      guardians: _list(data['guardians'])
          .map(_guardianSummary)
          .toList(growable: false),
      pendingApprovalCount: _int(data['pendingApprovalCount']),
      session: _session(_map(data['session']), profileActive: active),
    );
  }

  TeenModeSession _session(
    Map<String, dynamic> data, {
    bool? profileActive,
  }) {
    final rawActive = data['active'];
    final rawAllowed = data['allowed'];
    final reason = _sessionReason(data['reason']);
    final active = rawActive is bool ? rawActive : profileActive ?? false;
    final allowed = rawAllowed is bool ? rawAllowed : false;
    final projectionValid = rawActive is bool &&
        rawAllowed is bool &&
        reason != TeenSessionReason.unknown &&
        (!active || allowed == (reason == TeenSessionReason.ok));
    return TeenModeSession(
      active: active,
      allowed: projectionValid ? allowed : false,
      reason: reason,
      usedSeconds: _int(data['usedSeconds']),
      limitSeconds: _int(data['limitSeconds']),
      remainingSeconds: _int(data['remainingSeconds']),
      resetAt: _date(data['resetAt']),
      curfewUntil: _date(data['curfewUntil']),
      timeZoneId: _string(data['timeZoneId']) ?? 'Asia/Shanghai',
      projectionValid: projectionValid,
    );
  }

  TeenGuardianSummary _guardianSummary(Map<String, dynamic> data) =>
      TeenGuardianSummary(
        linkId: _requiredString(data['linkId'], 'linkId'),
        platformUserId:
            _requiredString(data['platformUserId'], 'platformUserId'),
        displayName: _string(data['displayName']) ?? '',
        avatarUrl: _string(data['avatarUrl']),
        lppId: _string(data['lppId']),
        relation: _string(data['relation']) ?? '',
        isPrimary: data['isPrimary'] == true,
        canApprove: data['canApprove'] == true,
        canManagePolicy: data['canManagePolicy'] == true,
      );

  GuardianLink _link(Map<String, dynamic> data) => GuardianLink(
        linkId: _requiredString(data['linkId'], 'linkId'),
        counterpartPlatformUserId: _requiredString(
          data['counterpartPlatformUserId'],
          'counterpartPlatformUserId',
        ),
        counterpartDisplayName: _string(data['counterpartDisplayName']) ?? '',
        counterpartAvatarUrl: _string(data['counterpartAvatarUrl']),
        counterpartLppId: _string(data['counterpartLppId']),
        myRole: _guardianRole(data['myRole']),
        status: _string(data['status']) ?? '',
        relation: _string(data['relation']) ?? '',
        isPrimary: data['isPrimary'] == true,
        canApprove: data['canApprove'] == true,
        canManagePolicy: data['canManagePolicy'] == true,
        createdAt: _date(data['createdAt']),
        activatedAt: _date(data['activatedAt']),
      );

  GuardianMinor _minor(Map<String, dynamic> data) {
    final active = data['teenModeActive'] == true;
    return GuardianMinor(
      linkId: _requiredString(data['linkId'], 'linkId'),
      minorPlatformUserId: _requiredString(
        data['minorPlatformUserId'],
        'minorPlatformUserId',
      ),
      displayName: _string(data['displayName']) ?? '',
      avatarUrl: _string(data['avatarUrl']),
      lppId: _string(data['lppId']),
      relation: _string(data['relation']) ?? '',
      teenModeActive: active,
      source: _source(data['source']),
      lockLevel: _int(data['lockLevel']),
      canManagePolicy: data['canManagePolicy'] == true,
      policy: _policy(data['policy']),
      editablePolicyKeys: _stringList(data['editablePolicyKeys']).toSet(),
      session: _session(_map(data['session']), profileActive: active),
      pendingApprovalCount: _int(data['pendingApprovalCount']),
      lastActiveAt: _date(data['lastActiveAt']),
    );
  }

  GuardianApproval _approval(Map<String, dynamic> data) => GuardianApproval(
        requestId: _requiredString(data['requestId'], 'requestId'),
        minorPlatformUserId: _string(data['minorPlatformUserId']) ?? '',
        minorDisplayName: _string(data['minorDisplayName']) ?? '',
        minorAvatarUrl: _string(data['minorAvatarUrl']),
        actionCode: _string(data['actionCode']) ?? '',
        actionLabel: _string(data['actionLabel']) ?? '',
        summary: _string(data['summary']) ?? '',
        status: _approvalStatus(data['status']),
        tenantId: _string(data['tenantId']),
        createdAt: _date(data['createdAt']),
        expiresAt: _date(data['expiresAt']),
        decidedAt: _date(data['decidedAt']),
        decisionNote: _string(data['decisionNote']),
        replayStatus: _replayStatus(data['replayStatus']),
        replayError: _string(data['replayError']),
      );

  TeenPolicy _policy(Object? value) {
    final source = _map(value);
    final result = <String, Object>{};
    for (final entry in source.entries) {
      final policyValue = _policyValue(entry.value);
      if (policyValue != null) result[entry.key] = policyValue;
    }
    return Map.unmodifiable(result);
  }

  Object? _policyValue(Object? value) =>
      value is bool || value is num || value is String ? value : null;

  TeenModeSource _source(Object? value) => switch (_string(value)) {
        'kyc_age' => TeenModeSource.kycAge,
        'guardian' => TeenModeSource.guardian,
        'tenant_admin' => TeenModeSource.tenantAdmin,
        'platform_admin' => TeenModeSource.platformAdmin,
        'self' => TeenModeSource.self,
        _ => TeenModeSource.unknown,
      };

  TeenSessionReason _sessionReason(Object? value) => switch (_string(value)) {
        'ok' => TeenSessionReason.ok,
        'daily_limit' => TeenSessionReason.dailyLimit,
        'curfew' => TeenSessionReason.curfew,
        _ => TeenSessionReason.unknown,
      };

  TeenPolicyKind _policyKind(Object? value) => switch (_string(value)) {
        'bool' => TeenPolicyKind.boolValue,
        'int' => TeenPolicyKind.intValue,
        'enum' => TeenPolicyKind.enumValue,
        _ => TeenPolicyKind.unknown,
      };

  GuardianRole _guardianRole(Object? value) => switch (_string(value)) {
        'guardian' => GuardianRole.guardian,
        'minor' => GuardianRole.minor,
        _ => GuardianRole.unknown,
      };

  String _guardianRoleWire(GuardianRole role) => switch (role) {
        GuardianRole.guardian => 'guardian',
        GuardianRole.minor => 'minor',
        GuardianRole.unknown => throw ArgumentError('guardian role required'),
      };

  GuardianApprovalStatus _approvalStatus(Object? value) =>
      switch (_string(value)) {
        'pending' => GuardianApprovalStatus.pending,
        'approved' => GuardianApprovalStatus.approved,
        'rejected' => GuardianApprovalStatus.rejected,
        'expired' => GuardianApprovalStatus.expired,
        'cancelled' => GuardianApprovalStatus.cancelled,
        _ => GuardianApprovalStatus.unknown,
      };

  GuardianReplayStatus _replayStatus(Object? value) => switch (_string(value)) {
        'none' => GuardianReplayStatus.none,
        'succeeded' => GuardianReplayStatus.succeeded,
        'failed' => GuardianReplayStatus.failed,
        _ => GuardianReplayStatus.unknown,
      };

  Object? _data(Map<String, dynamic>? envelope) {
    final code = _string(envelope?['code']);
    if (code == null) {
      throw ServerError(
        code: 'TEEN_INVALID_RESPONSE',
        message: '',
        requestId: _string(envelope?['requestId']),
      );
    }
    if (code != 'OK') {
      throw ErrorHandler.fromServerCode(
        code,
        _string(envelope?['message']) ?? '',
        requestId: _string(envelope?['requestId']),
      );
    }
    return envelope?['data'];
  }

  Map<String, dynamic> _dataMap(Map<String, dynamic>? envelope) =>
      _map(_data(envelope));

  Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, entry) => MapEntry(key.toString(), entry));
    }
    return const {};
  }

  List<Map<String, dynamic>> _list(Object? value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map(_map).toList(growable: false);
  }

  List<String> _stringList(Object? value) {
    if (value is! List) return const [];
    return value.map(_string).whereType<String>().toList(growable: false);
  }

  String? _string(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  String _requiredString(Object? value, String field) {
    final result = _string(value);
    if (result == null) {
      throw StateError('Teen mode response is missing $field');
    }
    return result;
  }

  int _int(Object? value) => _nullableInt(value) ?? 0;
  int? _nullableInt(Object? value) => int.tryParse(value?.toString() ?? '');
  DateTime? _date(Object? value) => DateTime.tryParse(value?.toString() ?? '');
  String _path(String value) => Uri.encodeComponent(value.trim());
}
