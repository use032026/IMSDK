import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/providers/locale_provider.dart';
import 'package:im_sdk/core/providers/theme_provider.dart';
import 'package:im_sdk/features/chat/presentation/pages/chat_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/chat_settings_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/favorites_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/complaint_page.dart';
import 'package:im_sdk/features/contacts/presentation/pages/profile_page.dart';
import 'package:im_sdk/features/teen_mode/presentation/widgets/teen_mode_gate.dart';
import 'package:im_sdk/features/teen_mode/presentation/widgets/teen_mode_runtime_service.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'im_sdk_client.dart';
import 'im_sdk_models.dart';
import 'im_sdk_presentation.dart';

/// A self-contained navigator. Closing this view never logs the SDK out.
class ImSdkChatView extends StatefulWidget {
  const ImSdkChatView(
      {super.key,
      required this.client,
      required this.target,
      required this.onClose});
  final ImSdkClient client;
  final ImSdkDirectConversation target;
  final VoidCallback onClose;
  @override
  State<ImSdkChatView> createState() => _ImSdkChatViewState();
}

class _ImSdkChatViewState extends State<ImSdkChatView>
    with WidgetsBindingObserver {
  late GoRouter _router;
  bool _closing = false;
  late int _boundSessionRevision;
  bool _hostChecked = false;
  bool _hostCheckFailed = false;
  bool _hostChecking = false;

  @override
  void initState() {
    super.initState();
    widget.target.validate();
    _boundSessionRevision = widget.client.sessionRevision;
    _router = _createRouter();
    _router.routerDelegate.addListener(_onRoute);
    _hostChecked = widget.client.config?.hostManagedAuth != true;
    if (!_hostChecked) {
      WidgetsBinding.instance.addObserver(this);
      unawaited(_verifyHostEntry());
    }
  }

  Future<void> _verifyHostEntry() async {
    if (_hostChecking || _closing) return;
    _hostChecking = true;
    final wasChecked = _hostChecked;
    setState(() {
      _hostChecked = false;
      _hostCheckFailed = false;
    });
    try {
      final ready = await widget.client.synchronizeHostSession();
      if (!mounted || _closing) return;
      if (!ready ||
          (wasChecked &&
              _boundSessionRevision != widget.client.sessionRevision)) {
        _close();
        return;
      }
      setState(() {
        _boundSessionRevision = widget.client.sessionRevision;
        _hostChecked = true;
        _hostCheckFailed = false;
      });
    } catch (_) {
      if (mounted) setState(() => _hostCheckFailed = true);
    } finally {
      _hostChecking = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_verifyHostEntry());
  }

  @override
  void didUpdateWidget(covariant ImSdkChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.client, widget.client) ||
        _boundSessionRevision != widget.client.sessionRevision) {
      _close();
      return;
    }
    if (oldWidget.target.conversationId != widget.target.conversationId ||
        oldWidget.target.titleIsDefault != widget.target.titleIsDefault ||
        oldWidget.target.sdkDefaultTitle != widget.target.sdkDefaultTitle ||
        oldWidget.target.title != widget.target.title ||
        oldWidget.target.peerUserId != widget.target.peerUserId ||
        oldWidget.target.serviceThreadId != widget.target.serviceThreadId) {
      widget.target.validate();
      _router.routerDelegate.removeListener(_onRoute);
      _router.dispose();
      _router = _createRouter();
      _router.routerDelegate.addListener(_onRoute);
    }
  }

  GoRouter _createRouter() => GoRouter(
        initialLocation:
            '/chat/${Uri.encodeComponent(widget.target.conversationId)}',
        initialExtra: widget.target,
        routes: [
          GoRoute(
              path: '/',
              builder: (_, __) => const SizedBox.shrink(),
              routes: [
                GoRoute(
                    path: 'chat/:id',
                    builder: (context, state) {
                      final extra = state.extra;
                      final target = extra is ImSdkDirectConversation
                          ? extra
                          : extra is Map<String, dynamic>
                              ? ImSdkDirectConversation.fromMap({
                                  ...extra,
                                  'conversationId': state.pathParameters['id']!
                                })
                              : widget.target;
                      return ChatPage(
                          conversationId: state.pathParameters['id']!,
                          title: sdkConversationTitle(context, target),
                          peerUserId: target.peerUserId,
                          avatarUrl: target.avatarUrl);
                    }),
                GoRoute(
                    path: 'chat-settings/:id',
                    builder: (_, s) =>
                        ChatSettingsPage(chatId: s.pathParameters['id']!)),
                GoRoute(
                    path: 'profile/:id',
                    builder: (_, s) =>
                        ProfilePage(userId: s.pathParameters['id']!)),
                GoRoute(
                    path: 'favorites',
                    builder: (_, __) => const FavoritesPage()),
                GoRoute(
                    path: 'complaint',
                    builder: (_, s) {
                      final extra = s.extra is Map ? s.extra as Map : const {};
                      return ComplaintPage(
                          subjectType:
                              extra['subjectType'] as String? ?? 'user',
                          subjectId: extra['subjectId'] as String? ??
                              widget.target.peerUserId ??
                              widget.target.conversationId);
                    }),
              ]),
        ],
        errorBuilder: (context, state) => Scaffold(
            appBar: AppBar(title: Text(sdkText(context, '聊天'))),
            body: Center(
                child: TextButton(
                    onPressed: _close,
                    child: Text(sdkText(context, '此入口未纳入SDK，返回宿主'))))),
      );
  void _onRoute() {
    if (_router.routerDelegate.currentConfiguration.uri.path == '/') _close();
  }

  void _close() {
    if (_closing || !mounted) return;
    _closing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onClose();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router.routerDelegate.removeListener(_onRoute);
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: widget.client.revision,
        builder: (context, _, __) {
          if (!_hostChecked || _hostCheckFailed) {
            return SdkPresentationApp(
                client: widget.client,
                homeBuilder: (context) => Scaffold(
                    appBar: AppBar(title: Text(sdkText(context, '聊天'))),
                    body: _hostCheckFailed
                        ? Center(
                            child: TextButton(
                                onPressed: _verifyHostEntry,
                                child: Text(sdkText(context, '聊天服务暂不可用，重试'))))
                        : const SizedBox.expand()));
          }
          final container = widget.client.accountContainer;
          if (_boundSessionRevision != widget.client.sessionRevision) _close();
          if (!widget.client.isAuthenticated ||
              container == null ||
              _boundSessionRevision != widget.client.sessionRevision) {
            return SdkPresentationApp(
                client: widget.client,
                homeBuilder: (context) => Scaffold(
                    appBar: AppBar(title: Text(sdkText(context, '聊天'))),
                    body: Center(
                        child: TextButton(
                            onPressed: _close,
                            child: Text(sdkText(context, '请先通过宿主登录'))))));
          }
          return UncontrolledProviderScope(
              container: container, child: _ChatMaterialApp(router: _router));
        },
      );
}

class _ChatMaterialApp extends ConsumerWidget {
  const _ChatMaterialApp({required this.router});
  final GoRouter router;
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ref.watch(themeModeProvider),
        locale: ref.watch(localeProvider),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) => TeenModeRuntimeService(
            child: Stack(children: [
          child ?? const SizedBox.shrink(),
          TeenModeGate(router: router),
        ])),
      );
}
