import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/sdk/im_sdk_models.dart';

void main() {
  group('host configuration boundary', () {
    ImSdkConfig configuration(
            {String api = 'https://im.example.test',
            bool consent = true,
            String namespace = 'host-a',
            String? gateway}) =>
        ImSdkConfig(
            apiBaseUrl: api,
            serviceRealmId: 'test-realm',
            privacyConsentGranted: consent,
            storageNamespace: namespace,
            gatewayBaseUrl: gateway);
    test('requires consent before any runtime can start', () {
      expect(
          () => configuration(consent: false).validate(),
          throwsA(isA<ImSdkException>()
              .having((e) => e.code, 'code', 'CONSENT_REQUIRED')));
    });
    test('rejects insecure or credential-bearing API endpoints', () {
      for (final api in [
        'http://im.example.test',
        'https://user:secret@im.example.test',
        'https://im.example.test?token=secret',
        'https://im.example.test#secret',
        'not-a-url'
      ]) {
        expect(() => configuration(api: api).validate(),
            throwsA(isA<ImSdkException>()));
      }
    });
    test('limits gateway endpoints and local namespace', () {
      expect(
          () => configuration(gateway: 'wss://gateway.example.test').validate(),
          returnsNormally);
      expect(
          () => configuration(gateway: 'ws://gateway.example.test').validate(),
          throwsA(isA<ImSdkException>()));
      for (final ns in ['../host', 'a/b', '', 'a' * 65]) {
        expect(() => configuration(namespace: ns).validate(),
            throwsA(isA<ImSdkException>()));
      }
    });
    test('compares all initialization inputs', () {
      final first = configuration();
      expect(
          ImSdkConfig.fromMap(Map<String, dynamic>.from(first.toMap())), first);
      expect(configuration(namespace: 'other'), isNot(first));
      expect(
          configuration(gateway: 'https://gateway.example.test'), isNot(first));
    });
  });
  group('credential boundary', () {
    final now = DateTime.utc(2026, 10, 27);
    ImSdkCredentials credentials(DateTime expiry,
            {String refresh = 'refresh-fixture'}) =>
        ImSdkCredentials(
            platformUserId: 'fixture-platform',
            userId: 'fixture-user',
            spaceId: 'fixture-space',
            accessToken: 'access-fixture',
            refreshToken: refresh,
            expiresAt: expiry);
    test('expiry boundary never accepts expired credentials', () {
      expect(() => credentials(now).validate(now: now),
          throwsA(isA<ImSdkException>()));
      expect(
          () => credentials(now.subtract(const Duration(seconds: 1)))
              .validate(now: now),
          throwsA(isA<ImSdkException>()));
      expect(
          () => credentials(now.add(const Duration(seconds: 1)))
              .validate(now: now),
          returnsNormally);
    });
    test('requires refresh credential used by existing auth owner', () {
      expect(
          () => credentials(now.add(const Duration(days: 1)), refresh: '')
              .validate(now: now),
          throwsA(isA<ImSdkException>()));
    });
    test('credential diagnostics do not reveal secrets or identity', () {
      final text = credentials(now).toString();
      for (final sensitive in [
        'access-fixture',
        'refresh-fixture',
        'fixture-user',
        'fixture-space'
      ]) {
        expect(text, isNot(contains(sensitive)));
      }
    });
    test('malformed native expiry fails explicitly', () {
      expect(() => ImSdkCredentials.fromMap({'expiresAt': 'invalid'}),
          throwsA(isA<ImSdkException>()));
    });
  });
  test('customer service thread remains distinct from conversation', () {
    final target = ImSdkDirectConversation.fromMap({
      'conversationId': 'fixture-conversation',
      'serviceThreadId': 'fixture-thread'
    });
    expect(target.conversationId, 'fixture-conversation');
    expect(target.serviceThreadId, 'fixture-thread');
  });
}
