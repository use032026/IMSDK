import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/sdk/data/sdk_customer_service_repository.dart';
import 'package:im_sdk/sdk/im_sdk_models.dart';

class _ResponseAdapter implements HttpClientAdapter {
  _ResponseAdapter(this.body);
  final Object body;
  RequestOptions? lastRequest;
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    lastRequest = options;
    return ResponseBody.fromString(jsonEncode(body), 200, headers: {
      Headers.contentTypeHeader: ['application/json']
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const request =
      ImSdkCustomerServiceRequest(serviceAccountId: 'fixture-service');
  Future<ImSdkDirectConversation> contact(Object envelope) {
    final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
      ..httpClientAdapter = _ResponseAdapter(envelope);
    return SdkCustomerServiceRepository(dio).contact(request);
  }

  test('uses only logged-in customer endpoint and keeps authoritative IDs',
      () async {
    final adapter = _ResponseAdapter({
      'code': 'OK',
      'data': {
        'threadId': 'fixture-thread',
        'conversationId': 'fixture-conversation',
        'threadStatus': 'active',
      }
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
      ..httpClientAdapter = adapter;
    final target = await SdkCustomerServiceRepository(dio).contact(request);
    expect(adapter.lastRequest!.path,
        '/api/client/v1/customer-service/im-direct/contact-brand');
    expect(adapter.lastRequest!.data['serviceAccountId'], 'fixture-service');
    expect(target.serviceThreadId, 'fixture-thread');
    expect(target.conversationId, 'fixture-conversation');
  });
  test('HTTP 200 with business rejection is not a successful contact',
      () async {
    await expectLater(contact({'code': 'FORBIDDEN', 'data': {}}),
        throwsA(isA<ImSdkException>()));
  });
  test('brand active threadStatus opens only its real conversation', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
      ..httpClientAdapter = _ResponseAdapter({
        'code': 'OK',
        'data': {
          'threadId': 'fixture-thread',
          'conversationId': 'fixture-conversation',
          'threadStatus': 'active',
        }
      });
    final session = await SdkCustomerServiceRepository(dio).request(request);
    expect(session.status, ImSdkCustomerServiceStatus.active);
    expect(session.canOpenConversation, isTrue);
    expect(session.toConversation().serviceThreadId, 'fixture-thread');
    expect(session.toConversation().conversationId, 'fixture-conversation');
  });
  test('brand pending and queued stay queued even when status says active',
      () async {
    for (final status in ['pending', 'queued']) {
      final envelope = {
        'code': 'OK',
        'data': {
          'threadId': 'fixture-thread',
          'conversationId': 'fixture-conversation',
          'threadStatus': status,
          'status': 'active',
        }
      };
      final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
        ..httpClientAdapter = _ResponseAdapter(envelope);
      final session = await SdkCustomerServiceRepository(dio).request(request);
      expect(session.status, ImSdkCustomerServiceStatus.queued);
      expect(session.canOpenConversation, isFalse);
      await expectLater(
          contact(envelope),
          throwsA(isA<ImSdkException>()
              .having((e) => e.code, 'code', 'SERVICE_QUEUED')));
    }
  });
  test('brand unknown or missing threadStatus never grants active from status',
      () async {
    for (final status in [null, 'future_status', 99]) {
      final envelope = {
        'code': 'OK',
        'data': {
          'threadId': 'fixture-thread',
          'conversationId': 'fixture-conversation',
          if (status != null) 'threadStatus': status,
          'status': 'active',
        }
      };
      final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
        ..httpClientAdapter = _ResponseAdapter(envelope);
      final session = await SdkCustomerServiceRepository(dio).request(request);
      expect(session.status, ImSdkCustomerServiceStatus.unknown);
      expect(session.canOpenConversation, isFalse);
      await expectLater(
          contact(envelope),
          throwsA(isA<ImSdkException>()
              .having((e) => e.code, 'code', 'SERVICE_NOT_READY')));
    }
  });
  test('brand active without conversation remains unopenable', () async {
    for (final conversationId in [null, '']) {
      final envelope = {
        'code': 'OK',
        'data': {
          'threadId': 'fixture-thread',
          'threadStatus': 'active',
          'conversationId': conversationId,
        }
      };
      final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
        ..httpClientAdapter = _ResponseAdapter(envelope);
      final session = await SdkCustomerServiceRepository(dio).request(request);
      expect(session.canOpenConversation, isFalse);
      expect(session.conversationId, isNull);
      await expectLater(
          contact(envelope),
          throwsA(isA<ImSdkException>()
              .having((e) => e.code, 'code', 'SERVICE_NOT_READY')));
    }
  });
  test(
      'brand thread ID is required even when status and conversation are valid',
      () async {
    for (final threadId in [null, '']) {
      final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
        ..httpClientAdapter = _ResponseAdapter({
          'code': 'OK',
          'data': {
            'threadId': threadId,
            'threadStatus': 'active',
            'conversationId': 'fixture-conversation',
          }
        });
      await expectLater(
          SdkCustomerServiceRepository(dio).request(request),
          throwsA(isA<ImSdkException>()
              .having((e) => e.code, 'code', 'INVALID_SERVICE_RESPONSE')));
    }
  });
  test('does not fabricate a conversation from a thread or empty response',
      () async {
    for (final data in [
      null,
      {'threadId': 'fixture-thread'},
      {'threadId': '', 'conversationId': 'fixture-conversation'},
      {'threadId': 'fixture-thread', 'conversationId': ''}
    ]) {
      await expectLater(contact({'code': 'OK', 'data': data}),
          throwsA(isA<ImSdkException>()));
    }
  });
}
