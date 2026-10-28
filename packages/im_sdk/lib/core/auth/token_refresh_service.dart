import 'dart:async';

import 'package:flutter/foundation.dart';

// ---------------------------------------------------------------------------
// TokenRefreshService — 前台定时刷新
//
// 策略：
// - 前台：Timer.periodic 每 45 分钟刷新一次（token 1小时过期，提前 15 分钟）
// - 后台恢复：app.dart 的 didChangeAppLifecycleState 触发立即刷新
// - 不依赖 workmanager，避免平台兼容问题
// ---------------------------------------------------------------------------

class TokenRefreshService {
  static final TokenRefreshService _instance = TokenRefreshService._();
  static TokenRefreshService get instance => _instance;
  TokenRefreshService._();

  Timer? _timer;

  @visibleForTesting
  bool get isRunning => _timer != null;

  /// 前台刷新间隔：45 分钟
  static const _interval = Duration(minutes: 45);

  /// 启动定时刷新
  /// [onRefresh] 由 AuthNotifier 提供，负责刷新 token 并更新 state
  void start({required Future<void> Function() onRefresh}) {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) async {
      debugPrint('[TokenRefresh] timer triggered');
      try {
        await onRefresh();
      } catch (e) {
        debugPrint('[TokenRefresh] refresh error: $e');
      }
    });
    debugPrint('[TokenRefresh] started, interval=${_interval.inMinutes}min');
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    debugPrint('[TokenRefresh] stopped');
  }
}
