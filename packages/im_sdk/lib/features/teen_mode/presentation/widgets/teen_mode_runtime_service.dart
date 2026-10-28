import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';

class TeenModeRuntimeService extends ConsumerStatefulWidget {
  const TeenModeRuntimeService({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<TeenModeRuntimeService> createState() =>
      _TeenModeRuntimeServiceState();
}

class _TeenModeRuntimeServiceState extends ConsumerState<TeenModeRuntimeService>
    with WidgetsBindingObserver {
  ProviderSubscription<AsyncValue<TeenModeState>>? _subscription;
  Timer? _heartbeatTimer;
  bool _foreground = true;
  bool _heartbeatRunning = false;
  Dio? _dio;
  Interceptor? _serverDecisionObserver;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _installServerDecisionObserver();
    _foreground = WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _subscription = ref.listenManual<AsyncValue<TeenModeState>>(
      teenModeControllerProvider,
      (_, __) => _syncTimer(),
      fireImmediately: true,
    );
  }

  void _installServerDecisionObserver() {
    final dio = ref.read(dioProvider);
    _dio = dio;
    final observer = InterceptorsWrapper(
      onError: (error, handler) {
        unawaited(
          ref
              .read(teenModeActionExecutorProvider)
              .observe(ErrorHandler.fromDioException(error)),
        );
        handler.next(error);
      },
    );
    dio.interceptors.add(observer);
    _serverDecisionObserver = observer;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (_foreground) {
      unawaited(_resume());
    } else {
      _stopTimer();
    }
  }

  Future<void> _resume() async {
    try {
      // A backgrounded device can miss WebSocket and mobile-push refresh work.
      // Reload the full natural-person projection before resuming accounting.
      await ref.read(teenModeControllerProvider.notifier).refresh();
    } catch (_) {
      // The last server projection remains visible; the next heartbeat retries.
    }
    _syncTimer(runImmediately: true);
  }

  void _syncTimer({bool runImmediately = false}) {
    final value = ref.read(teenModeControllerProvider).valueOrNull;
    final shouldRun = _foreground &&
        value?.config.enabled == true &&
        value?.profile?.active == true;
    if (!shouldRun) {
      _stopTimer();
      return;
    }
    _heartbeatTimer ??= Timer.periodic(
      const Duration(seconds: 60),
      (_) => unawaited(_heartbeat()),
    );
    if (runImmediately) unawaited(_heartbeat());
  }

  Future<void> _heartbeat() async {
    if (_heartbeatRunning || !_foreground) return;
    _heartbeatRunning = true;
    try {
      await ref.read(teenModeControllerProvider.notifier).heartbeat();
    } catch (_) {
      // Runtime retries on the next interval; server remains the usage owner.
    } finally {
      _heartbeatRunning = false;
    }
  }

  void _stopTimer() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    _subscription?.close();
    final observer = _serverDecisionObserver;
    if (observer != null) _dio?.interceptors.remove(observer);
    _dio = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
