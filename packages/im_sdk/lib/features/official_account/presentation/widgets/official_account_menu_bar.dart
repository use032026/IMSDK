import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/app/theme/app_theme_extension.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import 'package:im_sdk/features/official_account/domain/services/official_account_menu_policy.dart';
import 'package:im_sdk/features/official_account/presentation/providers/official_account_provider.dart';

class OfficialAccountMenuBar extends ConsumerStatefulWidget {
  final OfficialAccount account;
  final bool isCustomer;
  final OfficialAccountScope scope;
  final Future<void> Function(OfficialAccountClickDecision decision) onDecision;

  const OfficialAccountMenuBar({
    super.key,
    required this.account,
    required this.isCustomer,
    required this.scope,
    required this.onDecision,
  });

  @override
  ConsumerState<OfficialAccountMenuBar> createState() =>
      _OfficialAccountMenuBarState();
}

class _OfficialAccountMenuBarState
    extends ConsumerState<OfficialAccountMenuBar> {
  static const _policy = OfficialAccountMenuPolicy();
  String? _expandedItemId;
  bool _pending = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final menu = _policy.visibleMenu(
      accountStatus: widget.account.status,
      menu: widget.account.menu,
    );
    if (menu == null) return const SizedBox.shrink();
    final expanded =
        menu.items.where((item) => item.id == _expandedItemId).firstOrNull;

    return Material(
      color: colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (expanded != null && expanded.children.isNotEmpty)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(color: colorScheme.outlineVariant),
                  bottom: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Wrap(
                alignment: WrapAlignment.end,
                children: expanded.children
                    .map(
                      (child) => TextButton(
                        onPressed: _pending ? null : () => _handleTap(child),
                        child: Text(
                          child.title,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          SizedBox(
            height: 44,
            child: Row(
              children: [
                for (var index = 0; index < menu.items.length; index++) ...[
                  if (index > 0)
                    VerticalDivider(
                      width: 1,
                      indent: 9,
                      endIndent: 9,
                      color: colorScheme.outlineVariant,
                    ),
                  Expanded(
                    child: TextButton(
                      onPressed:
                          _pending ? null : () => _handleTap(menu.items[index]),
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        foregroundColor: colorScheme.onSurface,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (menu.items[index].children.isNotEmpty)
                            Icon(
                              _expandedItemId == menu.items[index].id
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              size: 17,
                            ),
                          Flexible(
                            child: Text(
                              menu.items[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTap(OfficialAccountMenuItem item) async {
    final tap = _policy.resolveTap(item, isCustomer: widget.isCustomer);
    switch (tap.kind) {
      case OfficialAccountMenuTapKind.expand:
        setState(() {
          _expandedItemId = _expandedItemId == item.id ? null : item.id;
        });
        return;
      case OfficialAccountMenuTapKind.customerOnly:
        _showNotice('联系客服仅对客户开放');
        return;
      case OfficialAccountMenuTapKind.unsupported:
        _showNotice('此菜单暂不可用');
        return;
      case OfficialAccountMenuTapKind.click:
        break;
    }

    setState(() => _pending = true);
    try {
      final result = await ref
          .read(officialAccountRepositoryProvider)
          .clickMenuItem(tap.itemId!);
      if (!mounted) return;
      await widget.onDecision(_policy.resolveClick(result));
    } catch (error) {
      if (!mounted) return;
      if (error is ServerError &&
          {
            'OFFICIAL_ACCOUNT_MENU_ITEM_NOT_FOUND',
            'OFFICIAL_ACCOUNT_MENU_ITEM_DISABLED',
          }.contains(error.code)) {
        ref.invalidate(officialAccountProvider(widget.scope));
        _showNotice('菜单已更新，请重试');
      } else if (error is ServerError &&
          error.code == 'OFFICIAL_ACCOUNT_MENU_DISABLED') {
        ref.invalidate(officialAccountProvider(widget.scope));
      } else {
        _showNotice('操作失败，请检查网络后重试');
      }
    } finally {
      if (mounted) setState(() => _pending = false);
    }
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class OfficialAccountMenuSlot extends ConsumerStatefulWidget {
  final OfficialAccountScope scope;
  final String? peerUserId;
  final bool isCustomer;
  final bool isKnownOfficialConversation;
  final Future<void> Function(OfficialAccountClickDecision decision) onDecision;

  const OfficialAccountMenuSlot({
    super.key,
    required this.scope,
    required this.peerUserId,
    required this.isCustomer,
    required this.isKnownOfficialConversation,
    required this.onDecision,
  });

  @override
  ConsumerState<OfficialAccountMenuSlot> createState() =>
      _OfficialAccountMenuSlotState();
}

class _OfficialAccountMenuSlotState
    extends ConsumerState<OfficialAccountMenuSlot> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_refreshMenuOnEntry);
  }

  @override
  void didUpdateWidget(covariant OfficialAccountMenuSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scope != widget.scope ||
        oldWidget.peerUserId != widget.peerUserId) {
      Future<void>.microtask(_refreshMenuOnEntry);
    }
  }

  Future<void> _refreshMenuOnEntry() async {
    try {
      final provider = officialAccountProvider(widget.scope);
      final OfficialAccount account =
          ref.read(provider).valueOrNull ?? await ref.read(provider.future);
      if (!mounted ||
          (widget.peerUserId != account.userId &&
              !widget.isKnownOfficialConversation)) {
        return;
      }
      await ref.read(provider.notifier).refreshMenuIfChanged();
    } catch (_) {
      // Initial and refresh errors are represented by provider state.
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(officialAccountProvider(widget.scope));
    final account = accountAsync.valueOrNull;
    final matchesOfficialAccount =
        account != null && widget.peerUserId == account.userId;

    if (account == null) {
      if (!accountAsync.hasError || !widget.isKnownOfficialConversation) {
        return const SizedBox.shrink();
      }
      return _OfficialAccountMenuLoadError(
        message: '服务菜单加载失败',
        onRetry: () => ref.invalidate(officialAccountProvider(widget.scope)),
      );
    }
    if (!matchesOfficialAccount) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (accountAsync.hasError)
          _OfficialAccountMenuLoadError(
            message: '服务菜单刷新失败',
            onRetry: _refreshMenuOnEntry,
          ),
        OfficialAccountMenuBar(
          account: account,
          isCustomer: widget.isCustomer,
          scope: widget.scope,
          onDecision: widget.onDecision,
        ),
      ],
    );
  }
}

class _OfficialAccountMenuLoadError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _OfficialAccountMenuLoadError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.warningContainer,
      child: SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                color: colors.onWarningContainer,
                fontSize: 13,
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
}
