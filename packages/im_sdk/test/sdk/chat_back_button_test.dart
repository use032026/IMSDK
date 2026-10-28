import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/features/chat/presentation/widgets/chat_back_button.dart';

class _NavigationObserver extends NavigatorObserver {
  int pops = 0;
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pops++;
    super.didPop(route, previousRoute);
  }
}

Widget _application(Locale locale, {NavigatorObserver? observer}) =>
    MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('zh', 'CN')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      navigatorObservers: [if (observer != null) observer],
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push<void>(MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(
                  leadingWidth: 80,
                  leading: const Row(children: [ChatBackButton()]),
                ),
                body: const Text('Navigation fixture'),
              ),
            )),
            child: const Text('Open navigation fixture'),
          ),
        ),
      ),
    );

void main() {
  for (final example in [
    (const Locale('en'), 'Back'),
    (const Locale('zh', 'CN'), '返回')
  ]) {
    testWidgets(
        'real chat return button exposes localized semantics: ${example.$2}',
        (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(_application(example.$1));
        await tester.tap(find.text('Open navigation fixture'));
        await tester.pumpAndSettle();
        final button = find.byType(ChatBackButton);
        expect(tester.getSize(button), const Size(48, 48));
        expect(find.byTooltip(example.$2), findsOneWidget);
        final data =
            tester.getSemantics(find.byType(IconButton)).getSemanticsData();
        expect(data.flagsCollection.isButton, isTrue);
        expect(data.hasAction(SemanticsAction.tap), isTrue);
        expect(data.label.isNotEmpty ? data.label : data.tooltip, example.$2);
      } finally {
        semantics.dispose();
      }
    });
  }

  testWidgets(
      'touching the enlarged return target pops the actual navigator once',
      (tester) async {
    final observer = _NavigationObserver();
    await tester
        .pumpWidget(_application(const Locale('en'), observer: observer));
    await tester.tap(find.text('Open navigation fixture'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ChatBackButton));
    await tester.pumpAndSettle();
    expect(observer.pops, 1);
    expect(find.byType(ChatBackButton), findsNothing);
    expect(find.text('Open navigation fixture'), findsOneWidget);
  });

  testWidgets('the real accessibility tap performs one navigator pop',
      (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      final observer = _NavigationObserver();
      await tester
          .pumpWidget(_application(const Locale('en'), observer: observer));
      await tester.tap(find.text('Open navigation fixture'));
      await tester.pumpAndSettle();
      final node = tester.getSemantics(find.byType(IconButton));
      tester
          .renderObject(find.byType(ChatBackButton))
          .owner!
          .semanticsOwner!
          .performAction(node.id, SemanticsAction.tap);
      await tester.pumpAndSettle();
      expect(observer.pops, 1);
      expect(find.byType(ChatBackButton), findsNothing);
    } finally {
      semantics.dispose();
    }
  });
}
