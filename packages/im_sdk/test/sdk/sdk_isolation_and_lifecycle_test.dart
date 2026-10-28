import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:im_sdk/core/storage/hive_storage.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/features/auth/application/logout_guard.dart';
import 'package:im_sdk/sdk/im_sdk_client.dart';
import 'package:im_sdk/sdk/im_sdk_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const config = ImSdkConfig(
      apiBaseUrl: 'https://im.example.test',
      serviceRealmId: 'fixture',
      privacyConsentGranted: true);
  test('queued calls cannot restart a disposed client; dispose is idempotent',
      () async {
    final client = ImSdkClient();
    final dispose = client.dispose();
    final initialize = client.initialize(config);
    await dispose;
    await expectLater(
        initialize,
        throwsA(
            isA<ImSdkException>().having((e) => e.code, 'code', 'DISPOSED')));
    await client.dispose();
    expect(client.isInitialized, false);
  });
  test('consent rejection occurs before filesystem, storage or network startup',
      () async {
    final client = ImSdkClient();
    await expectLater(
        client.initialize(const ImSdkConfig(
            apiBaseUrl: 'https://im.example.test',
            serviceRealmId: 'fixture',
            privacyConsentGranted: false)),
        throwsA(isA<ImSdkException>()
            .having((e) => e.code, 'code', 'CONSENT_REQUIRED')));
    expect(client.isInitialized, false);
    await client.dispose();
  });
  test('one failed queued operation does not poison later cleanup', () async {
    final client = ImSdkClient();
    await expectLater(client.logout(), throwsA(isA<ImSdkException>()));
    await client.dispose();
  });
  test('disabled SDK push never invokes the App-only Android logout gate',
      () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    const channel = MethodChannel('im_sdk/mobile_push');
    var nativeCalls = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      nativeCalls++;
      throw MissingPluginException('The SDK does not own vendor push.');
    });
    FlutterSecureStorage.setMockInitialValues({});
    final dio = Dio();
    final container = ProviderContainer(overrides: [
      dioProvider.overrideWithValue(dio),
      secureStorageProvider.overrideWithValue(
          SecureStorageServiceImpl(namespace: 'sdk-push-disabled-test')),
    ]);
    try {
      await container
          .read(accountPushRegistrationServiceProvider)
          .stopDelivery();
      expect(nativeCalls, 0);
    } finally {
      container.dispose();
      dio.close(force: true);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
      debugDefaultTargetPlatformOverride = null;
    }
  });
  test('SDK settings and crash-safe logout never touch host Hive settings',
      () async {
    final directory =
        await Directory.systemTemp.createTemp('im-sdk-isolation-');
    final host = Directory('${directory.path}/host')..createSync();
    final sdk = Directory('${directory.path}/sdk')..createSync();
    Hive.init(host.path);
    final settings = await Hive.openBox<String>('app_settings');
    await settings.put('host_value', 'preserve');
    try {
      await HiveStorage.initForSdk(directory: sdk.path, namespace: 'fixture');
      await LogoutGuard.arm('fixture-space');
      expect(LogoutGuard.isPending, true);
      expect(LogoutGuard.pendingSpaceId, 'fixture-space');
      expect(settings.get('host_value'), 'preserve');
      expect(settings.containsKey('auth_logout_pending_v1'), false);
      final later = await Hive.openBox<String>('host_later');
      expect(File('${host.path}/host_later.hive').existsSync(), true);
      await later.close();
      await HiveStorage.closeForSdk();
      expect(settings.isOpen, true);
      expect(settings.get('host_value'), 'preserve');
    } finally {
      await HiveStorage.closeForSdk();
      await settings.close();
      await directory.delete(recursive: true);
    }
  });
  test('SDK encrypted credential deletion preserves host and other namespaces',
      () async {
    FlutterSecureStorage.setMockInitialValues(
        {'host_token': 'preserve', 'other::token': 'preserve-other'});
    final storage = SecureStorageServiceImpl(namespace: 'sdk-test');
    await storage.write('token', 'sdk-fixture');
    expect(await storage.read('token'), 'sdk-fixture');
    await storage.deleteAll();
    const native = FlutterSecureStorage();
    expect(await native.read(key: 'host_token'), 'preserve');
    expect(await native.read(key: 'other::token'), 'preserve-other');
    expect(await storage.read('token'), null);
  });
}
