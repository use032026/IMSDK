import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<SystemUiOverlay> startupSystemUiOverlaysFor(TargetPlatform platform) =>
    platform == TargetPlatform.iOS
        ? const [SystemUiOverlay.top, SystemUiOverlay.bottom]
        : const [];

SystemUiOverlayStyle appSystemUiOverlayStyleFor(ThemeData theme) {
  final isDark = theme.brightness == Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: theme.colorScheme.surface,
    systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
    systemNavigationBarContrastEnforced: !isDark,
  );
}

const SystemUiOverlayStyle startupFullScreenOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarContrastEnforced: false,
);

Future<void> configureStartupSystemUi() async {
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: startupSystemUiOverlaysFor(defaultTargetPlatform),
  );
  SystemChrome.setSystemUIOverlayStyle(startupFullScreenOverlayStyle);
}

Future<void> configureAppSystemUi(ThemeData theme) async {
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: const [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );
  SystemChrome.setSystemUIOverlayStyle(appSystemUiOverlayStyleFor(theme));
}
