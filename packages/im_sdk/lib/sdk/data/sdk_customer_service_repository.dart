import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/official_account/data/datasources/official_account_remote_data_source.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import '../im_sdk_models.dart';

/// Adapts customer entry points without changing reception or workbench state.
class SdkCustomerServiceRepository {
  SdkCustomerServiceRepository(this._dio);
  final Dio _dio;

  Future<ImSdkCustomerServiceSession> request(
      ImSdkCustomerServiceRequest request) async {
    request.validate();
    try {
      if (request.entry == ImSdkCustomerServiceEntry.currentTenant) {
        final handoff =
            await OfficialAccountRemoteDataSource(_dio).contactService();
        return _session(handoff);
      }
      return _session(await _contactBrand(request));
    } on ImSdkException {
      rethrow;
    } on ServerError catch (error) {
      throw ImSdkException(error.code, '客服请求未完成');
    } on AuthError catch (error) {
      throw ImSdkException(error.code, '请重新通过宿主认证');
    } on NetworkError {
      throw const ImSdkException('SERVICE_NETWORK_ERROR', '暂时无法连接客服服务');
    } on DioException catch (error) {
      final mapped = ErrorHandler.fromDioException(error);
      throw ImSdkException(
          mapped is ServerError ? mapped.code : 'SERVICE_CONTACT_FAILED',
          '客服请求未完成');
    } on StateError {
      throw const ImSdkException('INVALID_SERVICE_RESPONSE', '客服入口缺少真实线程标识');
    }
  }

  Future<ImSdkDirectConversation> contact(
      ImSdkCustomerServiceRequest request) async {
    final session = await this.request(request);
    return session.toConversation();
  }

  Future<OfficialAccountHandoff> _contactBrand(
      ImSdkCustomerServiceRequest request) async {
    final response = await _dio.post<Object?>(
        '/api/client/v1/customer-service/im-direct/contact-brand',
        data: {
          'serviceAccountId': request.serviceAccountId,
          'priority': 0,
          if (request.locale != null) 'locale': request.locale,
          if (request.category != null) 'category': request.category,
          if (request.sourceUrl != null) 'sourceUrl': request.sourceUrl,
        });
    final envelope = response.data;
    if (envelope is! Map ||
        (envelope['code'] != null && envelope['code'] != 'OK')) {
      throw const ImSdkException('SERVICE_CONTACT_FAILED', '客服入口未返回成功结果');
    }
    final data = envelope['data'];
    if (data is! Map ||
        data['threadId'] is! String ||
        (data['threadId'] as String).trim().isEmpty) {
      throw const ImSdkException('INVALID_SERVICE_RESPONSE', '客服入口缺少真实线程标识');
    }
    String? optionalString(String key) {
      final value = data[key];
      return value is String && value.trim().isNotEmpty ? value : null;
    }

    return OfficialAccountHandoff(
      threadId: data['threadId'] as String,
      status: _brandThreadStatus(data['threadStatus']),
      conversationId: optionalString('conversationId'),
      staffUserId: optionalString('staffUserId'),
      staffDisplayName: optionalString('staffDisplayName'),
    );
  }

  // ImCustomerServiceThreadDto uses threadStatus; the official-account handoff
  // has a different DTO and keeps its existing status mapping in its owner.
  OfficialAccountHandoffStatus _brandThreadStatus(Object? value) =>
      switch (value is String ? value.trim().toLowerCase() : null) {
        'active' => OfficialAccountHandoffStatus.active,
        'pending' || 'queued' => OfficialAccountHandoffStatus.queued,
        _ => OfficialAccountHandoffStatus.unknown,
      };

  ImSdkCustomerServiceSession _session(OfficialAccountHandoff handoff) =>
      ImSdkCustomerServiceSession(
        threadId: handoff.threadId,
        status: switch (handoff.status) {
          OfficialAccountHandoffStatus.active =>
            ImSdkCustomerServiceStatus.active,
          OfficialAccountHandoffStatus.queued =>
            ImSdkCustomerServiceStatus.queued,
          OfficialAccountHandoffStatus.unknown =>
            ImSdkCustomerServiceStatus.unknown,
        },
        conversationId: handoff.conversationId,
        staffUserId: handoff.staffUserId,
        staffDisplayName: handoff.staffDisplayName,
      );
}
