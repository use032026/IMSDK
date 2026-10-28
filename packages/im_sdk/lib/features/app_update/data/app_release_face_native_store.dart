import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:im_sdk/features/app_update/domain/app_release_face.dart';

class AppReleaseFaceNativeStore {
  AppReleaseFaceNativeStore({
    MethodChannel channel = const MethodChannel('im_sdk/mobile_push'),
    bool Function()? isAndroid,
  })  : _channel = channel,
        _isAndroid = isAndroid ?? (() => Platform.isAndroid);

  final MethodChannel _channel;
  final bool Function() _isAndroid;

  Future<void> sync({
    required bool appliesToCurrentBuild,
    required AppReleaseFace face,
  }) async {
    if (!_isAndroid()) return;
    try {
      await _channel.invokeMethod<void>('setReleaseFace', {
        'appliesToCurrentBuild': appliesToCurrentBuild,
        'hideGroupFeatures': face == AppReleaseFace.isA,
      });
    } on MissingPluginException {
      // Unit tests and non-mobile runners do not install the native bridge.
    } on PlatformException {
      // Push presentation must never block update checks or application start.
    }
  }
}
