import 'dart:async';

import 'package:flutter/material.dart';
import 'package:im_sdk/im_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterHostExample());
}

/// Service/account context is provided by the integrating app at build time.
class FlutterHostExample extends StatefulWidget {
  const FlutterHostExample({super.key});
  @override
  State<FlutterHostExample> createState() => _FlutterHostExampleState();
}

class _FlutterHostExampleState extends State<FlutterHostExample> {
  final _client = ImSdkClient();
  static const _api = String.fromEnvironment('IMSDK_API_BASE_URL');
  static const _realm = String.fromEnvironment('IMSDK_SERVICE_REALM_ID');
  static const _tenant = String.fromEnvironment('IMSDK_TENANT_CODE');
  static const _gateway = String.fromEnvironment('IMSDK_GATEWAY_BASE_URL');
  static const _loginSpace =
      String.fromEnvironment('IMSDK_LOGIN_SPACE', defaultValue: 'personal');
  static const _loginType =
      String.fromEnvironment('IMSDK_LOGIN_TYPE', defaultValue: 'lpp_id');

  @override
  Widget build(BuildContext context) => ImSdkMessagingView(
        client: _client,
        configuration: _api.isEmpty ||
                _realm.isEmpty ||
                (_loginSpace != 'personal' && _tenant.isEmpty)
            ? null
            : const ImSdkConfig(
                apiBaseUrl: _api,
                serviceRealmId: _realm,
                gatewayBaseUrl: _gateway == '' ? null : _gateway,
                privacyConsentGranted: false,
                storageNamespace: 'flutter_host_example',
                passwordLogin: _loginSpace == 'personal'
                    ? ImSdkPasswordLoginConfig.personal()
                    : ImSdkPasswordLoginConfig(
                        loginType: _loginType, tenantCode: _tenant),
              ),
      );

  @override
  void dispose() {
    unawaited(_client.dispose());
    super.dispose();
  }
}
