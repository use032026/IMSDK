import 'package:dio/dio.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/network/api_response.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/kyc/domain/kyc_models.dart';
import 'package:im_sdk/features/kyc/domain/kyc_repository.dart';

class KycRepositoryImpl implements KycRepository {
  const KycRepositoryImpl(this._dio);

  final Dio _dio;

  static const _base = '/api/client/v1/kyc';
  static const _invalidResponse = ServerError(
    code: 'KYC_INVALID_RESPONSE',
    message: 'Invalid KYC response',
  );
  Options get _privateRequest =>
      Options(extra: const {'skipDiagnosticsLog': true});

  @override
  Future<KycConfig> getConfig() => _request(() async {
        try {
          final response = await _dio.get<Map<String, dynamic>>(
            '$_base/config',
            options: _privateRequest,
          );
          final envelope = response.data;
          final data = envelope?['data'];
          AppDiagnostics.instance
              .info('kyc.config', 'response received', context: {
            'uri': response.requestOptions.uri.toString(),
            'statusCode': response.statusCode,
            'code': envelope?['code'] is String ? envelope!['code'] : null,
            'requestId': envelope?['requestId'] is String
                ? envelope!['requestId']
                : null,
            'enabled': data is Map<String, dynamic> && data['enabled'] is bool
                ? data['enabled']
                : null,
          });
          return _data(response, _config);
        } on DioException catch (error) {
          final envelope = error.response?.data;
          AppDiagnostics.instance
              .warning('kyc.config', 'request failed', context: {
            'uri': error.requestOptions.uri.toString(),
            'statusCode': error.response?.statusCode,
            'code':
                envelope is Map<String, dynamic> && envelope['code'] is String
                    ? envelope['code']
                    : null,
            'requestId': envelope is Map<String, dynamic> &&
                    envelope['requestId'] is String
                ? envelope['requestId']
                : null,
            'errorType': error.type.name,
          });
          rethrow;
        }
      });

  @override
  Future<KycProfile> getMe() => _request(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          '$_base/me',
          options: _privateRequest,
        );
        return _data(response, _profile);
      });

  @override
  Future<String> uploadEvidence({
    required String path,
    required String mediaType,
    required String fileExtension,
  }) =>
      _request(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          '/api/client/v1/media/upload',
          data: FormData.fromMap({
            'file': await MultipartFile.fromFile(
              path,
              filename: 'kyc-evidence.$fileExtension',
              contentType: DioMediaType.parse(mediaType),
            ),
          }),
          options: _privateRequest,
        );
        return _data(response, (data) => _requiredString(data, 'mediaId'));
      });

  @override
  Future<KycSubmissionResult> submit({
    required String realName,
    required String idNumber,
    required int idType,
    required String clientRequestId,
    String? frontMediaId,
    String? backMediaId,
  }) =>
      _request(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          '$_base/submit',
          data: {
            'realName': realName,
            'idNumber': idNumber,
            'idType': idType,
            'clientRequestId': clientRequestId,
            if (frontMediaId != null) 'frontMediaId': frontMediaId,
            if (backMediaId != null) 'backMediaId': backMediaId,
          },
          options: _privateRequest,
        );
        return _data(
          response,
          (data) => KycSubmissionResult(
            verificationId: _requiredString(data, 'verificationId'),
            status: _requiredString(data, 'status'),
            decisionSource: _requiredString(data, 'decisionSource'),
            assuranceLevel: _requiredString(data, 'assuranceLevel'),
            reviewNote: _string(data['reviewNote']),
          ),
        );
      });

  Future<T> _request<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  T _data<T>(
    Response<Map<String, dynamic>> response,
    T Function(Map<String, dynamic>) parse,
  ) {
    return ApiResponse<T>.fromJson(response.data ?? const {}, (json) {
      if (json is! Map<String, dynamic>) {
        throw _invalidResponse;
      }
      return parse(json);
    }).getDataOrThrow();
  }

  KycConfig _config(Map<String, dynamic> data) {
    final types = data['supportedIdTypes'];
    final actions = data['gatedActions'];
    if (types is! List || actions is! List) {
      throw _invalidResponse;
    }
    return KycConfig(
      enabled: _requiredBool(data, 'enabled'),
      reviewMode: _requiredString(data, 'reviewMode'),
      requireFrontImage: _requiredBool(data, 'requireFrontImage'),
      requireBackImage: _requiredBool(data, 'requireBackImage'),
      allowResubmit: _requiredBool(data, 'allowResubmit'),
      assuranceLevel: _requiredString(data, 'assuranceLevel'),
      maxImageBytes: _requiredInt(data, 'maxImageBytes'),
      supportedIdTypes: types.map((item) {
        if (item is! Map<String, dynamic>) {
          throw _invalidResponse;
        }
        return KycIdType(
          idType: _requiredInt(item, 'idType'),
          code: _requiredString(item, 'code'),
          name: _requiredString(item, 'name'),
          placeholder: _requiredString(item, 'placeholder'),
          stronglyVerifiable: _requiredBool(item, 'stronglyVerifiable'),
        );
      }).toList(growable: false),
      gatedActions: actions.whereType<String>().toSet(),
    );
  }

  KycProfile _profile(Map<String, dynamic> data) => KycProfile(
        status: _requiredString(data, 'status'),
        notRequired: _requiredBool(data, 'notRequired'),
        assuranceLevel: _requiredString(data, 'assuranceLevel'),
        canSubmit: _requiredBool(data, 'canSubmit'),
        realNameMasked: _string(data['realNameMasked']),
        idNumberMasked: _string(data['idNumberMasked']),
        decisionSource: _string(data['decisionSource']),
        idType: data['idType'] is int ? data['idType'] as int : null,
        idTypeName: _string(data['idTypeName']),
        reviewNote: _string(data['reviewNote']),
        submittedAt: _date(data['submittedAt']),
        reviewedAt: _date(data['reviewedAt']),
        cannotSubmitReason: _string(data['cannotSubmitReason']),
      );

  String _requiredString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String && value.isNotEmpty) return value;
    throw _invalidResponse;
  }

  bool _requiredBool(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is bool) return value;
    throw _invalidResponse;
  }

  int _requiredInt(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) return value;
    throw _invalidResponse;
  }

  String? _string(Object? value) =>
      value is String && value.isNotEmpty ? value : null;
  DateTime? _date(Object? value) => DateTime.tryParse(_string(value) ?? '');
}
