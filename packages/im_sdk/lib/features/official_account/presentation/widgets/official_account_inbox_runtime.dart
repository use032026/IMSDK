import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/features/official_account/presentation/providers/official_account_inbox_provider.dart';

/// The personal connection cannot receive enterprise frames. This single,
/// foreground-only refresh loop owns the documented platform summary refresh.
class OfficialAccountInboxRuntime extends ConsumerStatefulWidget {
  const OfficialAccountInboxRuntime({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<OfficialAccountInboxRuntime> createState() =>
      _OfficialAccountInboxRuntimeState();
}

class _OfficialAccountInboxRuntimeState
    extends ConsumerState<OfficialAccountInboxRuntime>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _failures = 0;
  bool _personal = false;
  bool _foreground = true;
  ProviderSubscription<SpaceContext?>? _spaceSubscription;

  @override
  void initState() {
    super.initState();
    _foreground = WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    _spaceSubscription =
        ref.listenManual(accountRuntimeCurrentSpaceProvider, (_, next) {
      _personal = next?.isPersonal == true;
      _failures = 0;
      _schedule();
    }, fireImmediately: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _timer?.cancel();
    if (_foreground && _personal) unawaited(_refresh());
  }

  void _schedule() {
    _timer?.cancel();
    if (!_foreground || !_personal || !mounted) return;
    _timer =
        Timer(Duration(seconds: 30 * (1 << _failures.clamp(0, 2))), _refresh);
  }

  Future<void> _refresh() async {
    if (!_foreground || !_personal || !mounted) return;
    await ref.read(officialAccountInboxProvider.notifier).refresh();
    if (!mounted) return;
    _failures =
        ref.read(officialAccountInboxProvider).hasError ? _failures + 1 : 0;
    _schedule();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _spaceSubscription?.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personal =
        ref.watch(accountRuntimeCurrentSpaceProvider)?.isPersonal == true;
    if (personal) ref.watch(officialAccountInboxProvider);
    return widget.child;
  }
}
