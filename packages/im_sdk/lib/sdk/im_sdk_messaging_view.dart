import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/providers/locale_provider.dart';
import 'package:im_sdk/core/providers/theme_provider.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/presentation/controllers/direct_chat_entry_controller.dart';
import 'package:im_sdk/features/chat/presentation/pages/chat_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/add_friend_page.dart';
import 'package:im_sdk/features/contacts/presentation/pages/new_friends_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/chat_settings_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/complaint_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/create_group_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/favorites_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_admin_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_announcement_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_join_requests_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_manage_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_member_mute_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_qr_code_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_read_receipts_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_remark_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_settings_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/scheduled_messages_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/search_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/select_group_member_page.dart';
import 'package:im_sdk/features/chat/presentation/pages/transfer_owner_page.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/chat/presentation/widgets/conversation_list_item.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/presentation/pages/profile_page.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/settings/presentation/pages/chat_background_page.dart';
import 'package:im_sdk/features/teen_mode/presentation/widgets/teen_mode_gate.dart';
import 'package:im_sdk/features/teen_mode/presentation/widgets/teen_mode_runtime_service.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

import 'im_sdk_client.dart';
import 'im_sdk_models.dart';
import 'im_sdk_presentation.dart';
import 'im_sdk_registration_page.dart';

/// The primary SDK UI: password login, conversations, and direct/group chats.
/// The host supplies service/account context once, never through user fields.
/// Closing this widget does not sign out or dispose the host-owned client.
class ImSdkMessagingView extends StatelessWidget {
  const ImSdkMessagingView({
    super.key,
    required this.client,
    this.configuration,
    this.onClose,
  });

  final ImSdkClient client;
  final ImSdkConfig? configuration;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: client.revision,
        builder: (context, _, __) {
          if ((client.config ?? configuration)?.hostManagedAuth == true) {
            return _HostManagedMessagingView(
                key: ValueKey(client),
                client: client,
                configuration: configuration,
                onClose: onClose);
          }
          final account = client.accountContainer;
          if (client.isAuthenticated && account != null) {
            return UncontrolledProviderScope(
              container: account,
              child: _MessagingNavigator(
                key: ValueKey((client, client.sessionRevision)),
                onClose: onClose,
              ),
            );
          }
          return SdkPresentationApp(
            client: client,
            configuration: configuration,
            homeBuilder: (_) => _PasswordLoginPage(
              client: client,
              configuration: configuration,
              onClose: onClose,
            ),
          );
        },
      );
}

/// Host authentication never falls through to the SDK's password UI. The
/// first frame is a stable conversation shell while the local host snapshot
/// is checked; credential exchange runs without a modal or progress overlay.
class _HostManagedMessagingView extends StatefulWidget {
  const _HostManagedMessagingView(
      {super.key, required this.client, this.configuration, this.onClose});
  final ImSdkClient client;
  final ImSdkConfig? configuration;
  final VoidCallback? onClose;

  @override
  State<_HostManagedMessagingView> createState() =>
      _HostManagedMessagingViewState();
}

class _HostManagedMessagingViewState extends State<_HostManagedMessagingView>
    with WidgetsBindingObserver {
  bool _entryChecked = false;
  int _checkRevision = 0;
  bool _failed = false;
  bool _signedOut = false;
  StreamSubscription<ImSdkEvent>? _events;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _events = widget.client.events.listen((event) {
      if (!mounted) return;
      if (event.type == 'hostAuthenticationFailed') {
        ++_checkRevision;
        setState(() {
          _entryChecked = false;
          _failed = true;
        });
      } else if (event.type == 'authenticated') {
        ++_checkRevision;
        setState(() {
          _entryChecked = true;
          _failed = false;
          _signedOut = false;
        });
      } else if (event.type == 'loggedOut') {
        ++_checkRevision;
        setState(() {
          _entryChecked = false;
          _signedOut = true;
          _failed = false;
        });
      }
    });
    unawaited(_synchronize());
  }

  Future<void> _synchronize() async {
    final revision = ++_checkRevision;
    setState(() {
      _entryChecked = false;
      _failed = false;
      _signedOut = false;
    });
    try {
      if (!widget.client.isInitialized) {
        final configuration = widget.configuration;
        if (configuration == null) {
          throw const ImSdkException('NOT_INITIALIZED', '聊天服务暂不可用');
        }
        await widget.client.initialize(configuration);
      }
      final authenticated = await widget.client.synchronizeHostSession();
      if (mounted && revision == _checkRevision) {
        setState(() {
          _entryChecked = true;
          _signedOut = !authenticated;
          _failed = false;
        });
      }
    } catch (_) {
      if (mounted && revision == _checkRevision) {
        setState(() => _failed = true);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_synchronize());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_events?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.client.accountContainer;
    if (_entryChecked &&
        !_failed &&
        widget.client.isAuthenticated &&
        account != null) {
      return UncontrolledProviderScope(
        container: account,
        child: _MessagingNavigator(
          key: ValueKey((widget.client, widget.client.sessionRevision)),
          onClose: widget.onClose,
          silentLoading: true,
        ),
      );
    }
    return SdkPresentationApp(
      client: widget.client,
      configuration: widget.configuration,
      homeBuilder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(sdkText(context, '会话')),
          leading: widget.onClose == null
              ? null
              : IconButton(
                  tooltip: sdkText(context, '关闭'),
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close)),
        ),
        body: _failed
            ? _RetryView(message: '聊天服务暂不可用', retry: _synchronize)
            : _signedOut
                ? Center(child: Text(sdkText(context, '请先登录当前应用')))
                : const SizedBox.expand(),
      ),
    );
  }
}

class _PasswordLoginPage extends StatefulWidget {
  const _PasswordLoginPage({
    required this.client,
    this.configuration,
    this.onClose,
  });
  final ImSdkClient client;
  final ImSdkConfig? configuration;
  final VoidCallback? onClose;

  @override
  State<_PasswordLoginPage> createState() => _PasswordLoginPageState();
}

class _PasswordLoginPageState extends State<_PasswordLoginPage> {
  final _form = GlobalKey<FormState>();
  final _account = TextEditingController();
  final _password = TextEditingController();
  bool _consent = false;
  bool _busy = false;
  String? _error;

  Future<void> _login() async {
    if (_busy || !(_form.currentState?.validate() ?? false)) return;
    if (!widget.client.isInitialized && !_consent) {
      setState(() => _error = '请先同意使用聊天服务');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (!widget.client.isInitialized) {
        final config = widget.configuration;
        if (config == null) {
          throw const ImSdkException('INVALID_CONFIG', '接入方尚未配置聊天服务');
        }
        await widget.client.initialize(ImSdkConfig.fromMap({
          ...config.toMap(),
          'privacyConsentGranted': _consent,
        }));
      }
      if (!mounted) return;
      try {
        await _authenticate();
      } on ImSdkException catch (error) {
        if (!error.code.contains('CAPTCHA')) rethrow;
        final challenge = await widget.client.requestLoginCaptcha();
        if (!mounted) return;
        final answer = await _captchaAnswer(challenge.question);
        if (answer == null || !mounted) return;
        await _authenticate(token: challenge.token, answer: answer);
      }
      if (mounted) _password.clear();
    } on ImSdkException catch (error) {
      if (mounted) setState(() => _error = _loginMessage(error.code));
    } catch (_) {
      if (mounted) setState(() => _error = '暂时无法登录，请稍后重试');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _register() async {
    if (_busy) return;
    if (!widget.client.isInitialized && !_consent) {
      setState(() => _error = '请先同意使用聊天服务');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (!widget.client.isInitialized) {
        final configuration = widget.configuration;
        if (configuration == null) {
          throw const ImSdkException('INVALID_CONFIG', '接入方尚未配置聊天服务');
        }
        await widget.client.initialize(ImSdkConfig.fromMap({
          ...configuration.toMap(),
          'privacyConsentGranted': _consent,
        }));
      }
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => ImSdkRegistrationPage(client: widget.client)));
    } on ImSdkException catch (error) {
      if (mounted) setState(() => _error = _loginMessage(error.code));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _authenticate({String? token, String? answer}) =>
      widget.client.loginWithPassword(
        account: _account.text.trim(),
        password: _password.text,
        captchaToken: token,
        captchaAnswer: answer,
      );

  Future<String?> _captchaAnswer(String question) => showDialog<String>(
        context: context,
        builder: (_) => _LoginCaptchaDialog(question: question),
      );

  @override
  void dispose() {
    _account.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configured =
        (widget.client.config ?? widget.configuration)?.passwordLogin != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(sdkText(context, '聊天')),
        leading: widget.onClose == null
            ? null
            : IconButton(
                tooltip: sdkText(context, '关闭'),
                icon: const Icon(Icons.close),
                onPressed: widget.onClose),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.forum_outlined, size: 52),
                    const SizedBox(height: 24),
                    Text(sdkText(context, '登录聊天'),
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(sdkText(context, '登录后即可查看会话，与好友和群成员聊天')),
                    const SizedBox(height: 28),
                    if (!configured)
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(sdkText(context, '接入方尚未配置聊天服务，请联系应用提供方')),
                      ),
                    TextFormField(
                      key: const ValueKey('messaging.account'),
                      controller: _account,
                      enabled: !_busy && configured,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: sdkText(context, '账号'),
                          border: OutlineInputBorder()),
                      validator: (value) => value?.trim().isEmpty != false
                          ? sdkText(context, '请输入账号')
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('messaging.password'),
                      controller: _password,
                      enabled: !_busy && configured,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                          labelText: sdkText(context, '密码'),
                          border: OutlineInputBorder()),
                      validator: (value) => value?.isEmpty != false
                          ? sdkText(context, '请输入密码')
                          : null,
                    ),
                    if (!widget.client.isInitialized) ...[
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        key: const ValueKey('messaging.consent'),
                        contentPadding: EdgeInsets.zero,
                        value: _consent,
                        onChanged: _busy
                            ? null
                            : (value) =>
                                setState(() => _consent = value == true),
                        title: Text(sdkText(context, '我已了解并同意使用聊天服务')),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Semantics(
                            liveRegion: true,
                            child: Text(sdkErrorText(context, _error!),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.error))),
                      ),
                    const SizedBox(height: 20),
                    FilledButton(
                      key: const ValueKey('messaging.login'),
                      onPressed: _busy || !configured ? null : _login,
                      child: Text(sdkText(context, _busy ? '正在登录…' : '登录')),
                    ),
                    TextButton(
                      key: const ValueKey('messaging.register'),
                      onPressed: _busy || !configured ? null : _register,
                      child: Text(sdkText(context, '注册账号')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _loginMessage(String code) {
  if (code.contains('CAPTCHA')) return '登录验证未通过，请重试';
  if (code == 'LOGIN_NETWORK_ERROR' || code == 'LOGIN_TIMEOUT') {
    return '连接失败，请检查网络后重试';
  }
  if (code == 'PASSWORD_LOGIN_NOT_CONFIGURED' ||
      code == 'INVALID_CONFIG' ||
      code == 'TENANT_SELECTION_REQUIRED' ||
      code == 'AUTH_CONTEXT_REQUIRED') {
    return '聊天服务的账号接入尚未配置完成，请联系应用提供方';
  }
  if (code.contains('PASSWORD') ||
      code.contains('CREDENTIAL') ||
      code.contains('LOGIN') ||
      code == 'AUTH_FAILED') {
    return '账号或密码不正确，或当前账号暂时无法登录';
  }
  return '登录未完成，请检查网络后重试';
}

class _LoginCaptchaDialog extends StatefulWidget {
  const _LoginCaptchaDialog({required this.question});
  final String question;
  @override
  State<_LoginCaptchaDialog> createState() => _LoginCaptchaDialogState();
}

class _LoginCaptchaDialogState extends State<_LoginCaptchaDialog> {
  final _answer = TextEditingController();
  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(sdkText(context, '登录验证')),
        content: TextField(
          controller: _answer,
          autofocus: true,
          decoration: InputDecoration(labelText: widget.question),
          onSubmitted: (value) => Navigator.pop(context, value.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(sdkText(context, '取消'))),
          TextButton(
              onPressed: () => Navigator.pop(context, _answer.text.trim()),
              child: Text(sdkText(context, '确定'))),
        ],
      );
}

class _MessagingNavigator extends ConsumerStatefulWidget {
  const _MessagingNavigator(
      {super.key, this.onClose, this.silentLoading = false});
  final VoidCallback? onClose;
  final bool silentLoading;

  @override
  ConsumerState<_MessagingNavigator> createState() =>
      _MessagingNavigatorState();
}

class _MessagingNavigatorState extends ConsumerState<_MessagingNavigator> {
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (_, __) => _ConversationsPage(
              onClose: widget.onClose, silentLoading: widget.silentLoading)),
      GoRoute(path: '/new-chat', builder: (_, __) => const _NewChatPage()),
      GoRoute(
          path: '/add-friend',
          builder: (_, __) => const AddFriendPage(messagingOnly: true)),
      GoRoute(path: '/new-friends', builder: (_, __) => const NewFriendsPage()),
      GoRoute(
          path: '/create-group',
          builder: (_, s) => CreateGroupPage(
              messagingOnly: true,
              existingGroupId: s.extra is String ? s.extra as String : null)),
      GoRoute(
          path: '/chat/:id',
          builder: (context, s) {
            final extra = _extra(s);
            return ChatPage(
              conversationId: s.pathParameters['id']!,
              isGroup: extra['isGroup'] == true ||
                  extra['conversationType'] == 'group',
              title: extra['title'] as String? ?? sdkText(context, '聊天'),
              peerUserId: extra['peerUserId'] as String?,
              avatarUrl: extra['avatarUrl'] as String?,
              memberCount: extra['memberCount'] as int?,
              scrollToMessageId: extra['scrollToMessageId'] as String?,
              scrollBeforeSeq: extra['beforeSeq'] as int? ??
                  extra['scrollBeforeSeq'] as int?,
              messagingOnly: true,
            );
          }),
      GoRoute(
          path: '/chat-settings/:id',
          builder: (_, s) => ChatSettingsPage(chatId: s.pathParameters['id']!)),
      GoRoute(
          path: '/profile/:id',
          builder: (_, s) => ProfilePage(userId: s.pathParameters['id']!)),
      GoRoute(
          path: '/group-settings/:id',
          builder: (_, s) => GroupSettingsPage(
              groupId: s.pathParameters['id']!,
              fallbackTitle: _extra(s)['title'] as String?,
              fallbackAvatarUrl: _extra(s)['avatarUrl'] as String?,
              fallbackMemberCount: _extra(s)['memberCount'] as int?),
          routes: [
            GoRoute(
                path: 'remark',
                builder: (_, s) => GroupRemarkPage(
                    groupId: s.pathParameters['id']!,
                    groupName: _extra(s)['groupName'] as String? ?? '',
                    groupAvatarUrl: _extra(s)['groupAvatarUrl'] as String?)),
            GoRoute(
                path: 'qrcode',
                builder: (_, s) =>
                    GroupQrCodePage(groupId: s.pathParameters['id']!)),
            GoRoute(
                path: 'announcement',
                builder: (_, s) => GroupAnnouncementPage(
                    groupId: s.pathParameters['id']!,
                    isAdminOrAbove: _extra(s)['isAdminOrAbove'] == true)),
            GoRoute(
                path: 'complaint',
                builder: (_, s) => ComplaintPage(
                    subjectType: 'group', subjectId: s.pathParameters['id']!)),
          ]),
      GoRoute(
          path: '/group-manage/:id',
          builder: (_, s) => GroupManagePage(groupId: s.pathParameters['id']!),
          routes: [
            GoRoute(
                path: 'transfer-owner',
                builder: (_, s) =>
                    TransferOwnerPage(groupId: s.pathParameters['id']!)),
            GoRoute(
                path: 'admins',
                builder: (_, s) =>
                    GroupAdminPage(groupId: s.pathParameters['id']!),
                routes: [
                  GoRoute(
                      path: 'select',
                      builder: (_, s) => SelectGroupMemberPage(
                          groupId: s.pathParameters['id']!)),
                ]),
            GoRoute(
                path: 'join-requests',
                builder: (_, s) =>
                    GroupJoinRequestsPage(groupId: s.pathParameters['id']!)),
            GoRoute(
                path: 'member-mute',
                builder: (_, s) =>
                    GroupMemberMutePage(groupId: s.pathParameters['id']!)),
          ]),
      GoRoute(
          path: '/group-read-receipts/:groupId/:messageId',
          builder: (_, s) => GroupReadReceiptsPage(
              groupId: s.pathParameters['groupId']!,
              messageId: s.pathParameters['messageId']!,
              messageSeq:
                  int.tryParse(s.uri.queryParameters['seq'] ?? '') ?? 0)),
      GoRoute(
          path: '/chat/:id/scheduled-messages',
          builder: (_, s) =>
              ScheduledMessagesPage(conversationId: s.pathParameters['id']!)),
      GoRoute(
          path: '/search',
          builder: (_, s) => SearchPage(
              conversationId: _extra(s)['conversationId'] as String?,
              isGroup: _extra(s)['isGroup'] == true,
              conversationTitle: _extra(s)['conversationTitle'] as String?)),
      GoRoute(
          path: '/chat-background',
          builder: (_, s) => ChatBackgroundPage(
              conversationId: s.uri.queryParameters['conversationId'] ??
                  _extra(s)['conversationId'] as String?)),
      GoRoute(path: '/favorites', builder: (_, __) => const FavoritesPage()),
      GoRoute(
          path: '/complaint',
          builder: (_, s) => ComplaintPage(
              subjectType: _extra(s)['subjectType'] as String? ?? 'user',
              subjectId: _extra(s)['subjectId'] as String? ?? '')),
    ],
    errorBuilder: (context, _) => Scaffold(
      appBar: AppBar(title: Text(sdkText(context, '聊天'))),
      body: Center(
          child: TextButton(
              onPressed: () => _router.go('/'),
              child: Text(sdkText(context, '返回会话列表')))),
    ),
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ref.watch(themeModeProvider),
        locale: ref.watch(localeProvider),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
        builder: (_, child) => TeenModeRuntimeService(
            child: Stack(children: [
          child ?? const SizedBox.shrink(),
          TeenModeGate(router: _router),
        ])),
      );
}

Map<dynamic, dynamic> _extra(GoRouterState state) =>
    state.extra is Map ? state.extra as Map : const {};

class _ConversationsPage extends ConsumerStatefulWidget {
  const _ConversationsPage({this.onClose, this.silentLoading = false});
  final VoidCallback? onClose;
  final bool silentLoading;
  @override
  ConsumerState<_ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends ConsumerState<_ConversationsPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final spaceId = ref.watch(currentSpaceProvider)?.spaceId ?? '';
    final conversations = ref.watch(conversationsProvider(spaceId));
    Future<void> refresh() =>
        ref.read(conversationsProvider(spaceId).notifier).refresh();
    return Scaffold(
      appBar: AppBar(
        title: Text(sdkText(context, '会话')),
        leading: widget.onClose == null
            ? null
            : IconButton(
                tooltip: sdkText(context, '关闭'),
                onPressed: widget.onClose,
                icon: const Icon(Icons.close)),
        actions: [
          IconButton(
              tooltip: sdkText(context, '添加好友'),
              onPressed: () => context.push('/add-friend'),
              icon: const Icon(Icons.person_add_outlined)),
          IconButton(
              tooltip: sdkText(context, '好友申请'),
              onPressed: () => context.push('/new-friends'),
              icon: const Icon(Icons.mark_email_unread_outlined)),
          IconButton(
              tooltip: sdkText(context, '发起聊天'),
              onPressed: () => context.push('/new-chat'),
              icon: const Icon(Icons.add_comment_outlined)),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: TextField(
            decoration: InputDecoration(
                hintText: sdkText(context, '搜索会话'),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder()),
            onChanged: (value) =>
                setState(() => _search = value.trim().toLowerCase()),
          ),
        ),
        Expanded(
            child: conversations.when(
          loading: () => widget.silentLoading
              ? const SizedBox.expand()
              : Center(
                  child: CircularProgressIndicator(
                      semanticsLabel: sdkText(context, '正在加载…'))),
          error: (_, __) => _RetryView(message: '会话加载失败', retry: refresh),
          data: (items) {
            final hasMore =
                ref.read(conversationsProvider(spaceId).notifier).nextCursor !=
                    null;
            final visible = items
                .where((item) =>
                    (item.type == ConversationType.direct ||
                        item.type == ConversationType.group) &&
                    !item.isOfficialServiceUser &&
                    item.title.toLowerCase().contains(_search))
                .toList()
              ..sort((a, b) {
                if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
                final epoch = DateTime.fromMillisecondsSinceEpoch(0);
                return (b.lastActivityAt ?? b.lastMessage?.sentAt ?? epoch)
                    .compareTo(
                        a.lastActivityAt ?? a.lastMessage?.sentAt ?? epoch);
              });
            return RefreshIndicator(
              onRefresh: refresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.extentAfter < 240) {
                    unawaited(ref
                        .read(conversationsProvider(spaceId).notifier)
                        .loadMore());
                  }
                  return false;
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      visible.isEmpty ? 1 : visible.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (visible.isEmpty) {
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: Text(
                              sdkText(
                                  context,
                                  _search.isEmpty
                                      ? '暂无会话，点击右上角发起聊天'
                                      : '没有匹配的会话'),
                              textAlign: TextAlign.center),
                        ),
                        if (hasMore)
                          TextButton(
                              onPressed: () => ref
                                  .read(conversationsProvider(spaceId).notifier)
                                  .loadMore(),
                              child: Text(sdkText(context, '加载更多')))
                      ]);
                    }
                    if (index == visible.length) {
                      return TextButton(
                        onPressed: () => ref
                            .read(conversationsProvider(spaceId).notifier)
                            .loadMore(),
                        child: Text(sdkText(context, '加载更多')),
                      );
                    }
                    final item = visible[index];
                    return ConversationListItem(
                      key: ValueKey(item.conversationId),
                      conversation: item,
                      onTap: () => context.push(
                          '/chat/${Uri.encodeComponent(item.conversationId)}',
                          extra: {
                            'isGroup': item.type == ConversationType.group,
                            'title': item.title,
                            'peerUserId': item.peerUserId,
                            'avatarUrl': item.avatarUrl,
                            'memberCount': item.memberCount,
                          }),
                    );
                  },
                ),
              ),
            );
          },
        )),
      ]),
    );
  }
}

class _NewChatPage extends ConsumerStatefulWidget {
  const _NewChatPage();
  @override
  ConsumerState<_NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends ConsumerState<_NewChatPage> {
  String _search = '';
  bool _opening = false;

  Future<void> _open(Contact contact) async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      final id = await DirectChatEntryController(ref.read(dioProvider))
          .ensureConversationId(
              isPendingDirectChat: true,
              activeConversationId: '',
              peerUserId: contact.userId);
      if (!mounted) return;
      final spaceId = ref.read(currentSpaceProvider)?.spaceId;
      if (spaceId != null) ref.invalidate(conversationsProvider(spaceId));
      context.pushReplacement('/chat/${Uri.encodeComponent(id)}', extra: {
        'title': contact.displayName,
        'peerUserId': contact.userId,
        'avatarUrl': contact.avatarUrl,
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(sdkText(context, '暂时无法发起聊天，请稍后重试'))));
      }
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final space = ref.watch(currentSpaceProvider);
    final contacts = ref.watch(friendsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(sdkText(context, '发起聊天'))),
      body: Column(children: [
        ListTile(
            leading: const Icon(Icons.person_add_outlined),
            title: Text(sdkText(context, '添加好友')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/add-friend')),
        ListTile(
            leading: const Icon(Icons.mark_email_unread_outlined),
            title: Text(sdkText(context, '好友申请')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/new-friends')),
        ListTile(
          leading: const Icon(Icons.group_add_outlined),
          title: Text(sdkText(context, '新建群聊')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/create-group'),
        ),
        Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                  hintText: sdkText(context, '搜索联系人'),
                  prefixIcon: Icon(Icons.search)),
              onChanged: (value) =>
                  setState(() => _search = value.trim().toLowerCase()),
            )),
        if (_opening) const LinearProgressIndicator(),
        Expanded(
            child: contacts.when(
          loading: () => Center(
              child: CircularProgressIndicator(
                  semanticsLabel: sdkText(context, '正在加载…'))),
          error: (_, __) => _RetryView(
              message: '联系人加载失败',
              retry: () async {
                ref.invalidate(friendsProvider);
              }),
          data: (items) {
            final visible = items
                .where((c) =>
                    c.userId != space?.userId &&
                    c.officialAccount == null &&
                    c.displayName.toLowerCase().contains(_search))
                .toList();
            if (visible.isEmpty)
              return Center(child: Text(sdkText(context, '暂无可聊天的联系人')));
            return ListView.builder(
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final contact = visible[index];
                  return ListTile(
                    leading: UserAvatar(
                        name: contact.displayName,
                        avatarUrl: contact.avatarUrl,
                        size: 40),
                    title: Text(contact.displayName),
                    enabled: !_opening,
                    onTap: () => _open(contact),
                  );
                });
          },
        )),
      ]),
    );
  }
}

class _RetryView extends StatelessWidget {
  const _RetryView({required this.message, required this.retry});
  final String message;
  final Future<void> Function() retry;
  @override
  Widget build(BuildContext context) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(sdkText(context, message)),
        TextButton(onPressed: retry, child: Text(sdkText(context, '重试'))),
      ]));
}
