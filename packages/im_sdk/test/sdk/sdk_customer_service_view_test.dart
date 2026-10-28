import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/im_sdk.dart';

class _Client extends ImSdkClient {
  final changed = ValueNotifier(0);
  int generation = 1;
  bool authenticated = true;
  int requests = 0;
  ImSdkException? failure;
  ImSdkCustomerServiceSession next = const ImSdkCustomerServiceSession(
      threadId: 'fixture-thread',
      status: ImSdkCustomerServiceStatus.queued,
      conversationId: 'fixture-conversation');
  @override
  ValueListenable<int> get revision => changed;
  @override
  int get sessionRevision => generation;
  @override
  bool get isAuthenticated => authenticated;
  @override
  Future<ImSdkCustomerServiceSession> requestCustomerService(
      ImSdkCustomerServiceRequest request) async {
    requests++;
    if (failure != null) throw failure!;
    return next;
  }
}

void main() {
  const request = ImSdkCustomerServiceRequest.currentTenant();
  const session = ImSdkCustomerServiceSession(
      threadId: 'fixture-thread',
      status: ImSdkCustomerServiceStatus.queued,
      conversationId: 'fixture-conversation');
  testWidgets('queued allocated conversation shows queue, never a chat page',
      (tester) async {
    final client = _Client();
    await tester.pumpWidget(ImSdkCustomerServiceView(
        client: client,
        request: request,
        initialSession: session,
        onClose: () {}));
    expect(find.byKey(const ValueKey('im_sdk.customerService.queued')),
        findsOneWidget);
    expect(find.text('正在排队'), findsOneWidget);
    expect(find.byType(ImSdkChatView), findsNothing);
    expect(client.requests, 0);
    await tester.pump(const Duration(minutes: 2));
    expect(client.requests, 0);
  });
  testWidgets('status checks occur only on explicit button action',
      (tester) async {
    final client = _Client();
    await tester.pumpWidget(ImSdkCustomerServiceView(
        client: client,
        request: request,
        initialSession: session,
        onClose: () {}));
    await tester
        .tap(find.byKey(const ValueKey('im_sdk.customerService.refresh')));
    await tester.pumpAndSettle();
    expect(client.requests, 1);
    expect(find.text('正在排队'), findsOneWidget);
    await tester.pump(const Duration(minutes: 2));
    expect(client.requests, 1);
  });
  testWidgets('refresh failure preserves authoritative queue state',
      (tester) async {
    final client = _Client()
      ..failure = const ImSdkException('SERVICE_NETWORK_ERROR', 'fixture');
    await tester.pumpWidget(ImSdkCustomerServiceView(
        client: client,
        request: request,
        initialSession: session,
        onClose: () {}));
    await tester
        .tap(find.byKey(const ValueKey('im_sdk.customerService.refresh')));
    await tester.pumpAndSettle();
    expect(find.text('正在排队'), findsOneWidget);
    expect(find.byKey(const ValueKey('im_sdk.customerService.error')),
        findsOneWidget);
    expect(find.byType(ImSdkChatView), findsNothing);
  });
  testWidgets('account revision retires the queue page once', (tester) async {
    final client = _Client();
    int closed = 0;
    await tester.pumpWidget(ImSdkCustomerServiceView(
        client: client,
        request: request,
        initialSession: session,
        onClose: () => closed++));
    client.generation++;
    client.changed.value++;
    await tester.pumpAndSettle();
    client.changed.value++;
    await tester.pumpAndSettle();
    expect(closed, 1);
  });
  testWidgets('logout retires the queue page without a new service request',
      (tester) async {
    final client = _Client();
    int closed = 0;
    await tester.pumpWidget(ImSdkCustomerServiceView(
        client: client,
        request: request,
        initialSession: session,
        onClose: () => closed++));
    client.authenticated = false;
    client.changed.value++;
    await tester.pumpAndSettle();
    expect(closed, 1);
    expect(client.requests, 0);
  });
}
