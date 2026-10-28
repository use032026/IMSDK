import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/runtime/account_runtime.dart';

/// Installs the active account-space container without recreating the app
/// shell. Runtime-scoped service listeners are mounted separately with a
/// session key; ordinary consumers rebind through [UncontrolledProviderScope].
class AuthenticatedRuntimeHost extends StatefulWidget {
  const AuthenticatedRuntimeHost({
    super.key,
    required this.runtime,
    required this.authenticatedChild,
    required this.restrictedChild,
  });

  final AccountRuntime? runtime;
  final Widget authenticatedChild;
  final Widget restrictedChild;

  @override
  State<AuthenticatedRuntimeHost> createState() =>
      _AuthenticatedRuntimeHostState();
}

class _AuthenticatedRuntimeHostState extends State<AuthenticatedRuntimeHost> {
  ProviderContainer? _container;
  AccountRuntime? _installedRuntime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _installRuntime(widget.runtime);
  }

  @override
  void didUpdateWidget(covariant AuthenticatedRuntimeHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _installRuntime(widget.runtime);
  }

  void _installRuntime(AccountRuntime? runtime) {
    final isActive =
        runtime != null && runtime.lifecycle == AccountRuntimeLifecycle.active;
    final nextRuntime = isActive ? runtime : null;
    if (identical(_installedRuntime, nextRuntime)) return;

    final previous = _container;
    _installedRuntime = nextRuntime;
    _container = isActive
        ? ProviderContainer(
            parent: ProviderScope.containerOf(context),
            overrides: runtime.providerOverrides,
          )
        : null;

    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
    }
  }

  @override
  void dispose() {
    _container?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final container = _container;
    if (container == null) return widget.restrictedChild;
    return UncontrolledProviderScope(
      container: container,
      child: widget.authenticatedChild,
    );
  }
}
