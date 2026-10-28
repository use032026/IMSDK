import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/sdk/data/sdk_customer_service_repository.dart';
import 'package:im_sdk/sdk/im_sdk_models.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.envelope);
  final Object envelope;
  RequestOptions? lastRequest;
  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? stream,
      Future<void>? cancelFuture) async {
    lastRequest = options;
    return ResponseBody.fromString(jsonEncode(envelope), 200, headers: {
      Headers.contentTypeHeader: ['application/json']
    });
  }

  @override
  void close({bool force = false}) {}
}

SdkCustomerServiceRepository _repository(_Adapter adapter) =>
    SdkCustomerServiceRepository(
        Dio(BaseOptions(baseUrl: 'https://im.example.test'))
          ..httpClientAdapter = adapter);

void main() {
  const current = ImSdkCustomerServiceRequest.currentTenant();
  test('current-tenant entry is explicit and round trips without a brand ID',
      () {
    expect(current.toMap(), {'entry': 'currentTenant'});
    expect(ImSdkCustomerServiceRequest.fromMap({'entry': 'currentTenant'}),
        current);
    expect(current.validate, returnsNormally);
    final brand = ImSdkCustomerServiceRequest.fromMap(
        {'serviceAccountId': 'fixture-brand'});
    expect(brand.entry, ImSdkCustomerServiceEntry.serviceAccount);
    expect(brand.serviceAccountId, 'fixture-brand');
  });
  test('rejects mixed or unknown entries instead of falling back', () {
    for (final map in [
      {'entry': 'currentTenant', 'serviceAccountId': 'fixture-brand'},
      {'entry': 'implicitFallback', 'serviceAccountId': 'fixture-brand'},
    ]) {
      expect(() => ImSdkCustomerServiceRequest.fromMap(map),
          throwsA(isA<ImSdkException>()));
    }
    expect(const ImSdkCustomerServiceRequest(serviceAccountId: '').validate,
        throwsA(isA<ImSdkException>()));
  });
  test('current-tenant request reuses the official endpoint with no body',
      () async {
    final adapter = _Adapter({
      'code': 'OK',
      'data': {
        'threadId': 'fixture-thread',
        'status': 'queued',
        'conversationId': null,
        'staffUserId': 'fixture-staff',
        'staffDisplayName': '接待人员',
      }
    });
    final session = await _repository(adapter).request(current);
    expect(adapter.lastRequest!.path,
        '/api/client/v1/official-account/contact-service');
    expect(adapter.lastRequest!.data, isNull);
    expect(session.status, ImSdkCustomerServiceStatus.queued);
    expect(session.threadId, 'fixture-thread');
    expect(session.conversationId, isNull);
    expect(session.staffUserId, 'fixture-staff');
    expect(session.staffDisplayName, '接待人员');
    expect(session.canOpenConversation, isFalse);
  });
  test('queued with an allocated conversation remains queued and cannot open',
      () async {
    final adapter = _Adapter({
      'code': 'OK',
      'data': {
        'threadId': 'fixture-thread',
        'status': 'queued',
        'conversationId': 'fixture-conversation',
      }
    });
    final repo = _repository(adapter);
    final session = await repo.request(current);
    expect(session.canOpenConversation, isFalse);
    expect(session.toMap()['status'], 'queued');
    expect(session.toMap()['canOpenConversation'], false);
    await expectLater(
        repo.contact(current),
        throwsA(isA<ImSdkException>()
            .having((e) => e.code, 'code', 'SERVICE_QUEUED')));
  });
  test('unknown state with a conversation cannot use target-only API',
      () async {
    final adapter = _Adapter({
      'code': 'OK',
      'data': {
        'threadId': 'fixture-thread',
        'conversationId': 'fixture-conversation',
      }
    });
    final repo = _repository(adapter);
    final session = await repo.request(current);
    expect(session.status, ImSdkCustomerServiceStatus.unknown);
    expect(session.canOpenConversation, isFalse);
    await expectLater(
        repo.contact(current),
        throwsA(isA<ImSdkException>()
            .having((e) => e.code, 'code', 'SERVICE_NOT_READY')));
  });
  test('only active with real thread and conversation can become chat target',
      () {
    for (final session in [
      const ImSdkCustomerServiceSession(
          threadId: '',
          status: ImSdkCustomerServiceStatus.active,
          conversationId: 'fixture-conversation'),
      const ImSdkCustomerServiceSession(
          threadId: 'fixture-thread',
          status: ImSdkCustomerServiceStatus.active),
    ]) {
      expect(session.canOpenConversation, isFalse);
      expect(session.toConversation, throwsA(isA<ImSdkException>()));
    }
    const session = ImSdkCustomerServiceSession(
        threadId: 'fixture-thread',
        status: ImSdkCustomerServiceStatus.active,
        conversationId: 'fixture-conversation');
    expect(session.canOpenConversation, isTrue);
    expect(session.toConversation().conversationId, 'fixture-conversation');
    expect(session.toConversation().serviceThreadId, 'fixture-thread');
    expect(session.toConversation().peerUserId, isNull);
  });
  test(
      'business rejection remains a rejection even with plausible handoff data',
      () async {
    final adapter = _Adapter({
      'code': 'SERVICE_UNAVAILABLE',
      'data': {
        'threadId': 'fixture-thread',
        'status': 'active',
        'conversationId': 'fixture-conversation',
      }
    });
    await expectLater(
        _repository(adapter).request(current),
        throwsA(isA<ImSdkException>()
            .having((e) => e.code, 'code', 'SERVICE_UNAVAILABLE')));
  });
  test('missing official thread is an invalid response, never fabricated',
      () async {
    final adapter = _Adapter({
      'code': 'OK',
      'data': {
        'status': 'queued',
        'conversationId': 'fixture-conversation',
      }
    });
    await expectLater(
        _repository(adapter).request(current),
        throwsA(isA<ImSdkException>()
            .having((e) => e.code, 'code', 'INVALID_SERVICE_RESPONSE')));
  });
  test('explicit brand entry does not silently use the current-tenant endpoint',
      () async {
    final adapter = _Adapter({
      'code': 'OK',
      'data': {
        'threadId': 'fixture-thread',
        'threadStatus': 'queued',
        'conversationId': 'fixture-conversation',
      }
    });
    const request =
        ImSdkCustomerServiceRequest(serviceAccountId: 'fixture-brand');
    final session = await _repository(adapter).request(request);
    expect(adapter.lastRequest!.path,
        '/api/client/v1/customer-service/im-direct/contact-brand');
    expect(adapter.lastRequest!.data['serviceAccountId'], 'fixture-brand');
    expect(session.status, ImSdkCustomerServiceStatus.queued);
    expect(session.canOpenConversation, isFalse);
  });
}
