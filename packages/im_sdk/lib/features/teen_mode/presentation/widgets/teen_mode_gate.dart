import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class TeenModeGate extends ConsumerStatefulWidget {
  const TeenModeGate({super.key, required this.router});

  final GoRouter router;

  @override
  ConsumerState<TeenModeGate> createState() => _TeenModeGateState();
}

class _TeenModeGateState extends ConsumerState<TeenModeGate> {
  @override
  void initState() {
    super.initState();
    widget.router.routeInformationProvider.addListener(_routeChanged);
  }

  @override
  void didUpdateWidget(covariant TeenModeGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.router == widget.router) return;
    oldWidget.router.routeInformationProvider.removeListener(_routeChanged);
    widget.router.routeInformationProvider.addListener(_routeChanged);
  }

  @override
  void dispose() {
    widget.router.routeInformationProvider.removeListener(_routeChanged);
    super.dispose();
  }

  void _routeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teenModeControllerProvider).valueOrNull;
    final session = state?.profile?.session;
    final path = widget.router.routeInformationProvider.value.uri.path;
    if (session?.isRestricted != true || _isReliefPath(path)) {
      return const SizedBox.shrink();
    }
    return Positioned.fill(child: _RestrictedSurface(session: session!));
  }

  bool _isReliefPath(String path) {
    if (path == '/') return true;
    if (path == '/settings/teen-mode' ||
        path.startsWith('/settings/teen-mode/')) {
      return true;
    }
    if (path.startsWith('/chat/')) return true;
    if (path.startsWith('/customer-service')) return true;
    if (path == '/feedback' || path.endsWith('/complaint')) return true;
    return false;
  }
}

class _RestrictedSurface extends StatefulWidget {
  const _RestrictedSurface({required this.session});

  final TeenModeSession session;

  @override
  State<_RestrictedSurface> createState() => _RestrictedSurfaceState();
}

class _RestrictedSurfaceState extends State<_RestrictedSurface> {
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _syncCountdown();
  }

  @override
  void didUpdateWidget(covariant _RestrictedSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.curfewUntil != widget.session.curfewUntil ||
        oldWidget.session.reason != widget.session.reason) {
      _syncCountdown();
    }
  }

  void _syncCountdown() {
    _countdownTimer?.cancel();
    if (widget.session.reason != TeenSessionReason.curfew ||
        widget.session.curfewUntil == null) {
      _countdownTimer = null;
      return;
    }
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final session = widget.session;
    final title = session.reason == TeenSessionReason.curfew
        ? l10n.teenModeCurfewActive
        : l10n.teenModeTimeLimitReached;
    return Material(
      color: colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined, size: 64, color: colorScheme.primary),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.teenModeReliefHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              if (session.reason == TeenSessionReason.curfew &&
                  session.curfewUntil != null) ...[
                const SizedBox(height: 10),
                Text(
                  '${l10n.teenModeRemaining}: ${_remainingText(session.curfewUntil!)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () => context.go('/settings/teen-mode'),
                child: Text(l10n.teenModeRequestExtension),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text(l10n.navMessages),
              ),
              TextButton(
                onPressed: () => context.go('/customer-service'),
                child: Text(l10n.customerServiceTitle),
              ),
              TextButton(
                onPressed: () => context.go('/feedback'),
                child: Text(l10n.feedbackTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _remainingText(DateTime until) {
    final seconds =
        until.difference(DateTime.now()).inSeconds.clamp(0, 1 << 30);
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainder = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainder.toString().padLeft(2, '0')}';
  }
}
