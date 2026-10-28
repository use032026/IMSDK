import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:im_sdk_flutter_host/diagnostics.dart' as host;

/// Runs the real Flutter host and SDK argument gates on a mobile target.
/// It deliberately uses an invalid endpoint and never authenticates a user.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('host starts and guards consent, authentication and config',
      (tester) async {
    host.main();
    await tester.pumpAndSettle();
    expect(find.text('Flutter宿主接入示例'), findsOneWidget);

    Future<void> show(String name) async {
      final finder = find.byKey(ValueKey('host.$name'));
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .jumpTo(0);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(finder, 350,
          scrollable: find.byType(Scrollable).first);
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
    }

    Future<void> enter(String name, String value) async {
      await show(name);
      await tester.enterText(find.byKey(ValueKey('host.$name')), value);
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    }

    await show('authenticate');
    expect(
        tester
            .widget<FilledButton>(
                find.byKey(const ValueKey('host.authenticate')))
            .onPressed,
        isNull);
    await show('openDirect');
    expect(
        tester
            .widget<OutlinedButton>(
                find.byKey(const ValueKey('host.openDirect')))
            .onPressed,
        isNull);
    await show('openCustomerService');
    expect(
        tester
            .widget<OutlinedButton>(
                find.byKey(const ValueKey('host.openCustomerService')))
            .onPressed,
        isNull);

    await enter('apiBaseUrl', 'http://example.invalid');
    await enter('serviceRealmId', 'host-runtime-negative-check');
    await enter('expiresAt', '2099-01-01T00:00:00Z');
    await show('consent');
    await tester.tap(find.byKey(const ValueKey('host.consent')));
    await tester.pumpAndSettle();
    await show('authenticate');
    await tester.tap(find.byKey(const ValueKey('host.authenticate')));
    await tester.pumpAndSettle();
    await show('status');
    expect(find.textContaining('INVALID_CONFIG'), findsOneWidget);
    await show('openDirect');
    expect(
        tester
            .widget<OutlinedButton>(
                find.byKey(const ValueKey('host.openDirect')))
            .onPressed,
        isNull);
    await show('openCustomerService');
    expect(
        tester
            .widget<OutlinedButton>(
                find.byKey(const ValueKey('host.openCustomerService')))
            .onPressed,
        isNull);
  });
}
