import 'package:flutter/services.dart';

abstract interface class AppUpdateInstallPermission {
  Future<bool> ensureGranted();
}

class AndroidAppUpdateInstallPermission implements AppUpdateInstallPermission {
  static const _channel = MethodChannel(
    'im_sdk/app_update_permission',
  );

  const AndroidAppUpdateInstallPermission();

  @override
  Future<bool> ensureGranted() async {
    return await _channel.invokeMethod<bool>('requestInstallPermission') ??
        false;
  }
}
