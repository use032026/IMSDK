import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/im_sdk.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

/// Incremental real-service check on an already registered dedicated QA account.
/// It deliberately disposes immediately after foreground logout returns.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('real password login, immediate logout and runtime disposal',
      (tester) async {
    final directory = await getApplicationSupportDirectory();
    final input = File('${directory.path}/unification-live-input.json');
    final status = File('${directory.path}/unification-mobile-status.json');
    debugPrint('IMSDK_UNIFICATION_WAITING_FOR_PRIVATE_INPUT');
    await tester.runAsync(() async {
      final deadline = DateTime.now().add(const Duration(seconds: 90));
      while (!await input.exists() && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    });
    if (!await input.exists()) throw StateError('Private input was not staged');
    final fixture =
        jsonDecode(await input.readAsString()) as Map<String, dynamic>;
    await input.delete();
    final source = (fixture['accounts'] as Map)['mobile'] as Map;
    final steps = <Map<String, Object?>>[];
    Future<void> record(String step,
        [Map<String, Object?> data = const {}]) async {
      steps.add({'step': step, ...data});
      await status.writeAsString(
          jsonEncode(
              {'runId': fixture['runId'], 'phase': step, 'steps': steps}),
          flush: true);
      debugPrint('IMSDK_UNIFICATION_EVIDENCE ${jsonEncode(steps.last)}');
    }

    final client = ImSdkClient();
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Text('SDK lifecycle validation'))));
    try {
      await client.initialize(ImSdkConfig.fromMap(
          Map<String, dynamic>.from(fixture['configuration'] as Map)));
      await client.loginWithPassword(
          account: source['identifier'] as String,
          password: source['password'] as String);
      if (!client.isAuthenticated || client.accountContainer == null)
        throw StateError('Dedicated account was not authenticated');
      await record('authenticatedExistingAccount',
          {'registrationRepeated': false, 'realService': true});
      await client.logout();
      await record('logoutForegroundReturned', {
        'activeRuntimeCleared':
            !client.isAuthenticated && client.accountContainer == null
      });
      await client.dispose();
      if (client.isInitialized ||
          client.isAuthenticated ||
          client.accountContainer != null)
        throw StateError('Disposed SDK retained an active runtime');
      await record('disposeCompleted', {
        'initialized': false,
        'authenticated': false,
        'activeRuntime': false
      });
      await tester.pump(const Duration(milliseconds: 400));
      await record('completed', {'passed': true, 'existingAccountOnly': true});
    } finally {
      await client.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
    }
  }, timeout: const Timeout(Duration(minutes: 5)));
}
