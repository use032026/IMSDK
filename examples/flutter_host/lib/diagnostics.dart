import 'dart:async';

import 'package:flutter/material.dart';
import 'package:im_sdk/im_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterHostExample());
}

class FlutterHostExample extends StatelessWidget {
  const FlutterHostExample({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'IM SDK Flutter Host',
        theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
        home: const HostConnectionPage(),
      );
}

/// The host supplies real IM credentials. This sample owns only form state;
/// the SDK owns authentication, persistence, messages and runtime lifecycle.
class HostConnectionPage extends StatefulWidget {
  const HostConnectionPage({super.key});

  @override
  State<HostConnectionPage> createState() => _HostConnectionPageState();
}

class _HostConnectionPageState extends State<HostConnectionPage> {
  final ImSdkClient _client = ImSdkClient();
  final Map<String, TextEditingController> _fields = {
    for (final name in [
      'apiBaseUrl',
      'gatewayBaseUrl',
      'serviceRealmId',
      'platformUserId',
      'userId',
      'spaceId',
      'accessToken',
      'refreshToken',
      'expiresAt',
      'platformToken',
      'platformRefreshToken',
      'deviceSessionToken',
      'conversationId',
      'peerUserId',
      'serviceAccountId',
    ])
      name: TextEditingController(),
  };
  StreamSubscription<ImSdkEvent>? _subscription;
  bool _consentGranted = false;
  bool _serviceCurrentTenant = true;
  bool _busy = false;
  String _status = '请由宿主提供真实配置和IM凭证。';
  String _lastEvent = '';

  @override
  void initState() {
    super.initState();
    _subscription = _client.events.listen((event) {
      if (mounted) setState(() => _lastEvent = 'SDK事件：${event.type}');
    });
  }

  String _value(String name) => _fields[name]!.text.trim();
  String? _optional(String name) {
    final value = _value(name);
    return value.isEmpty ? null : value;
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on ImSdkException catch (error) {
      if (mounted)
        setState(() => _status = 'SDK操作失败：${error.code}。请检查配置、身份与服务端环境。');
    } on FormatException {
      if (mounted) setState(() => _status = '请输入有效的ISO8601凭证过期时间（包含时区）。');
    } catch (error, stackTrace) {
      debugPrint(
          'Host SDK operation failed (${error.runtimeType})\n$stackTrace');
      if (mounted) setState(() => _status = '操作未完成，请检查宿主配置与服务端连接。');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _authenticate() async {
    final expiry = DateTime.parse(_value('expiresAt'));
    await _client.initialize(
      ImSdkConfig(
        apiBaseUrl: _value('apiBaseUrl'),
        gatewayBaseUrl: _optional('gatewayBaseUrl'),
        serviceRealmId: _value('serviceRealmId'),
        privacyConsentGranted: _consentGranted,
        storageNamespace: 'flutter_host_example',
      ),
    );
    await _client.authenticate(
      ImSdkCredentials(
        platformUserId: _value('platformUserId'),
        userId: _value('userId'),
        spaceId: _value('spaceId'),
        accessToken: _value('accessToken'),
        refreshToken: _value('refreshToken'),
        expiresAt: expiry,
        platformToken: _optional('platformToken'),
        platformRefreshToken: _optional('platformRefreshToken'),
        deviceSessionToken: _optional('deviceSessionToken'),
      ),
    );
    // Do not keep credential copies in host presentation state after handoff.
    for (final key in [
      'accessToken',
      'refreshToken',
      'platformToken',
      'platformRefreshToken',
      'deviceSessionToken',
    ]) {
      _fields[key]!.clear();
    }
    if (mounted) setState(() => _status = 'SDK已认证，可以打开已授权私聊或联系企业客服。');
  }

  Future<void> _open(ImSdkDirectConversation target) async {
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (routeContext) => ImSdkChatView(
          client: _client,
          target: target,
          onClose: () => Navigator.of(routeContext).pop(),
        ),
      ),
    );
  }

  Future<void> _openCustomerService() async {
    final revision = _client.sessionRevision;
    final request = _serviceCurrentTenant
        ? const ImSdkCustomerServiceRequest.currentTenant()
        : ImSdkCustomerServiceRequest(
            serviceAccountId: _value('serviceAccountId'));
    final session = await _client.requestCustomerService(request);
    if (!mounted ||
        !_client.isAuthenticated ||
        revision != _client.sessionRevision) {
      return;
    }
    await Navigator.of(context).push<void>(MaterialPageRoute(
      builder: (routeContext) => ImSdkCustomerServiceView(
        client: _client,
        request: request,
        initialSession: session,
        onClose: () => Navigator.of(routeContext).pop(),
      ),
    ));
  }

  Widget _input(
    String name,
    String label, {
    bool secret = false,
    String? hint,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          key: ValueKey('host.$name'),
          controller: _fields[name],
          obscureText: secret,
          autocorrect: !secret,
          enableSuggestions: !secret,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Flutter宿主接入示例')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('仅连接你有权限使用的真实测试环境。凭证由宿主后端获取；此示例不提供账号注册、模拟会话或假消息。'),
            const SizedBox(height: 16),
            _input('apiBaseUrl', 'IM API基础地址（HTTPS）'),
            _input('gatewayBaseUrl', 'Gateway地址（可选，HTTPS/WSS）'),
            _input('serviceRealmId', '服务环境标识'),
            CheckboxListTile(
              key: const ValueKey('host.consent'),
              contentPadding: EdgeInsets.zero,
              title: const Text('宿主已取得本次功能所需的用户同意'),
              value: _consentGranted,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _consentGranted = value ?? false),
            ),
            const SizedBox(height: 16),
            _input('platformUserId', 'IM平台用户ID'),
            _input('userId', 'IM空间内用户ID'),
            _input('spaceId', '当前空间ID'),
            _input('accessToken', 'IM租户/空间accessToken', secret: true),
            _input('refreshToken', 'IM空间refreshToken', secret: true),
            _input('expiresAt', 'accessToken过期时间', hint: 'ISO8601，包含Z或时区偏移'),
            _input('platformToken', 'platformToken（需要跨空间时提供）', secret: true),
            _input(
              'platformRefreshToken',
              'platformRefreshToken（可选）',
              secret: true,
            ),
            _input('deviceSessionToken', 'deviceSessionToken（可选）',
                secret: true),
            FilledButton(
              key: const ValueKey('host.authenticate'),
              onPressed:
                  _busy || !_consentGranted ? null : () => _run(_authenticate),
              child: const Text('初始化并认证SDK'),
            ),
            const Divider(height: 32),
            _input('conversationId', '已授权的私聊conversationId'),
            _input('peerUserId', '对方IM用户ID（可选）'),
            OutlinedButton(
              key: const ValueKey('host.openDirect'),
              onPressed: _busy || !_client.isAuthenticated
                  ? null
                  : () => _run(
                        () => _open(
                          ImSdkDirectConversation(
                            conversationId: _value('conversationId'),
                            peerUserId: _optional('peerUserId'),
                          ),
                        ),
                      ),
              child: const Text('打开普通私聊'),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              key: const ValueKey('host.serviceCurrentTenant'),
              contentPadding: EdgeInsets.zero,
              title: const Text('当前企业客服'),
              subtitle: const Text('关闭后使用明确指定的企业服务账号入口'),
              value: _serviceCurrentTenant,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _serviceCurrentTenant = value),
            ),
            if (!_serviceCurrentTenant)
              _input('serviceAccountId', '企业服务账号ID（不是公众号用户ID）'),
            OutlinedButton(
              key: const ValueKey('host.openCustomerService'),
              onPressed: _busy || !_client.isAuthenticated
                  ? null
                  : () => _run(_openCustomerService),
              child: const Text('联系企业客服'),
            ),
            const SizedBox(height: 16),
            TextButton(
              key: const ValueKey('host.logout'),
              onPressed: _busy || !_client.isInitialized
                  ? null
                  : () => _run(() async {
                        await _client.logout();
                        if (mounted) setState(() => _status = 'SDK已退出登录。');
                      }),
              child: const Text('退出SDK登录'),
            ),
            const SizedBox(height: 16),
            Semantics(
              liveRegion: true,
              child: Text(_busy ? '操作进行中…' : _status,
                  key: const ValueKey('host.status')),
            ),
            if (_lastEvent.isNotEmpty) Text(_lastEvent),
          ],
        ),
      );

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_client.dispose());
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
