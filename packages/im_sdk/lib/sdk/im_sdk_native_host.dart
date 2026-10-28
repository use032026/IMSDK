import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'im_sdk_client.dart';
import 'im_sdk_models.dart';
import 'im_sdk_chat_view.dart';
import 'im_sdk_customer_service_view.dart';
import 'im_sdk_messaging_view.dart';

const _control = MethodChannel('im_sdk/control');

/// Entry point used by the independently compiled add-to-app module.
@pragma('vm:entry-point')
void runImSdkNativeHost() {
  WidgetsFlutterBinding.ensureInitialized();
  final host = _NativeSdkHost();
  _control.setMethodCallHandler(host.handle);
  runApp(_NativeSdkApp(host: host));
  unawaited(_control.invokeMethod<void>('event', {'type': 'ready'}));
}

sealed class _SdkPresentation {
  const _SdkPresentation();
}

class _MessagingPresentation extends _SdkPresentation {
  const _MessagingPresentation();
}

class _DirectPresentation extends _SdkPresentation {
  const _DirectPresentation(this.target);
  final ImSdkDirectConversation target;
}

class _ServicePresentation extends _SdkPresentation {
  const _ServicePresentation(this.request, this.session);
  final ImSdkCustomerServiceRequest request;
  final ImSdkCustomerServiceSession session;
}

class _NativeSdkHost {
  final client = ImSdkClient();
  final presentation = ValueNotifier<_SdkPresentation?>(null);
  int presentationRevision = 0;
  StreamSubscription<ImSdkEvent>? _subscription;
  void _present(_SdkPresentation next) {
    // A detached engine can skip the intermediate null frame on page close.
    // Every open therefore owns a fresh navigator, including the same chat.
    presentationRevision++;
    presentation.value = next;
  }

  void closePresentation() {
    presentation.value = null;
    unawaited(_control.invokeMethod<void>('close'));
  }

  Future<Object?> handle(MethodCall call) async {
    try {
      final args = call.arguments is Map
          ? Map<String, dynamic>.from(call.arguments as Map)
          : <String, dynamic>{};
      switch (call.method) {
        case 'initialize':
          _subscription ??= client.events.listen((event) {
            unawaited(_control.invokeMethod<void>('event', event.toMap()));
            if (event.type == 'authenticationRequired' ||
                event.type == 'loggedOut') {
              if (presentation.value != null &&
                  presentation.value is! _MessagingPresentation)
                closePresentation();
            }
          });
          await client.initialize(ImSdkConfig.fromMap(args));
          return null;
        case 'authenticate':
          presentation.value = null;
          await client.authenticate(ImSdkCredentials.fromMap(args));
          return null;
        case 'openDirectConversation':
          if (!client.isAuthenticated) {
            throw const ImSdkException('NOT_AUTHENTICATED', '请先通过宿主登录');
          }
          final next = ImSdkDirectConversation.fromMap(args);
          next.validate();
          _present(_DirectPresentation(next));
          return null;
        case 'openMessenger':
          if (!client.isInitialized) {
            throw const ImSdkException('NOT_INITIALIZED', '请先初始化SDK');
          }
          _present(const _MessagingPresentation());
          return null;
        case 'openCustomerService':
          final request = ImSdkCustomerServiceRequest.fromMap(args);
          final revision = client.sessionRevision;
          final session = await client.requestCustomerService(request);
          if (revision != client.sessionRevision || !client.isAuthenticated) {
            throw const ImSdkException('SESSION_CHANGED', '客服请求所属账号已变化');
          }
          _present(_ServicePresentation(request, session));
          return session.toMap();
        case 'logout':
          presentation.value = null;
          await client.logout();
          return null;
        case 'shutdown':
          presentation.value = null;
          await client.dispose();
          await _subscription?.cancel();
          return null;
        default:
          throw const ImSdkException('UNKNOWN_METHOD', 'SDK方法不存在');
      }
    } on ImSdkException catch (error) {
      throw PlatformException(code: error.code, message: error.message);
    } catch (_) {
      // Avoid exposing HTTP bodies, URLs or credentials through platform errors.
      throw PlatformException(
          code: 'SDK_OPERATION_FAILED', message: 'SDK操作失败，请检查脱敏诊断');
    }
  }
}

class _NativeSdkApp extends StatelessWidget {
  const _NativeSdkApp({required this.host});
  final _NativeSdkHost host;
  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<_SdkPresentation?>(
        valueListenable: host.presentation,
        builder: (context, presentation, _) => presentation == null
            ? const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(body: SizedBox.shrink()))
            : switch (presentation) {
                _MessagingPresentation() => ImSdkMessagingView(
                    key: ValueKey(host.presentationRevision),
                    client: host.client,
                    onClose: host.closePresentation),
                _DirectPresentation(:final target) => ImSdkChatView(
                    key: ValueKey(
                        '${host.client.sessionRevision}:${host.presentationRevision}'),
                    client: host.client,
                    target: target,
                    onClose: host.closePresentation),
                _ServicePresentation(:final request, :final session) =>
                  ImSdkCustomerServiceView(
                      key: ValueKey(
                          '${host.client.sessionRevision}:${host.presentationRevision}'),
                      client: host.client,
                      request: request,
                      initialSession: session,
                      onClose: host.closePresentation),
              },
      );
}
