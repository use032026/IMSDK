import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';

enum OfficialAccountMenuTapKind {
  click,
  expand,
  customerOnly,
  unsupported,
}

class OfficialAccountMenuTapDecision {
  final OfficialAccountMenuTapKind kind;
  final String? itemId;
  final List<OfficialAccountMenuItem> children;

  const OfficialAccountMenuTapDecision._(
    this.kind, {
    this.itemId,
    this.children = const [],
  });

  const OfficialAccountMenuTapDecision.click(String itemId)
      : this._(OfficialAccountMenuTapKind.click, itemId: itemId);

  const OfficialAccountMenuTapDecision.expand(
    List<OfficialAccountMenuItem> children,
  ) : this._(OfficialAccountMenuTapKind.expand, children: children);

  const OfficialAccountMenuTapDecision.customerOnly()
      : this._(OfficialAccountMenuTapKind.customerOnly);

  const OfficialAccountMenuTapDecision.unsupported()
      : this._(OfficialAccountMenuTapKind.unsupported);
}

enum OfficialAccountClickKind {
  openUrl,
  openRoute,
  openHandoff,
  queued,
  replied,
  ignore,
}

class OfficialAccountClickDecision {
  final OfficialAccountClickKind kind;
  final String? value;
  final OfficialAccountHandoff? handoff;

  const OfficialAccountClickDecision._(
    this.kind, {
    this.value,
    this.handoff,
  });

  const OfficialAccountClickDecision.openUrl(String url)
      : this._(OfficialAccountClickKind.openUrl, value: url);

  const OfficialAccountClickDecision.openRoute(String route)
      : this._(OfficialAccountClickKind.openRoute, value: route);

  const OfficialAccountClickDecision.openHandoff(
    OfficialAccountHandoff handoff,
  ) : this._(OfficialAccountClickKind.openHandoff, handoff: handoff);

  const OfficialAccountClickDecision.queued()
      : this._(OfficialAccountClickKind.queued);

  const OfficialAccountClickDecision.replied()
      : this._(OfficialAccountClickKind.replied);

  const OfficialAccountClickDecision.ignore()
      : this._(OfficialAccountClickKind.ignore);
}

class OfficialAccountMenuPolicy {
  static const supportedRoutes = {'ztchat://profile'};

  const OfficialAccountMenuPolicy();

  OfficialAccountMenu? visibleMenu({
    required int accountStatus,
    required OfficialAccountMenu menu,
  }) {
    if (accountStatus != 1 || !menu.enabled) return null;
    final items = _enabledItems(menu.items);
    if (items.isEmpty) return null;
    return OfficialAccountMenu(
      enabled: menu.enabled,
      version: menu.version,
      items: items,
    );
  }

  OfficialAccountMenuTapDecision resolveTap(
    OfficialAccountMenuItem item, {
    required bool isCustomer,
  }) {
    if (item.type == OfficialAccountMenuItemType.group ||
        item.children.isNotEmpty) {
      return OfficialAccountMenuTapDecision.expand(item.children);
    }
    if (item.type == OfficialAccountMenuItemType.action) {
      if (item.actionCode != 'contact_service') {
        return const OfficialAccountMenuTapDecision.unsupported();
      }
      if (!isCustomer) {
        return const OfficialAccountMenuTapDecision.customerOnly();
      }
    }
    if (!{
      OfficialAccountMenuItemType.url,
      OfficialAccountMenuItemType.appRoute,
      OfficialAccountMenuItemType.text,
      OfficialAccountMenuItemType.action,
    }.contains(item.type)) {
      return const OfficialAccountMenuTapDecision.unsupported();
    }
    return OfficialAccountMenuTapDecision.click(item.id);
  }

  OfficialAccountClickDecision resolveClick(
    OfficialAccountMenuClickResult result,
  ) {
    switch (result.type) {
      case OfficialAccountMenuItemType.url:
        return _safeHttpUrl(result.url)
            ? OfficialAccountClickDecision.openUrl(result.url!)
            : const OfficialAccountClickDecision.ignore();
      case OfficialAccountMenuItemType.appRoute:
        return supportedRoutes.contains(result.appRoute)
            ? OfficialAccountClickDecision.openRoute(result.appRoute!)
            : const OfficialAccountClickDecision.ignore();
      case OfficialAccountMenuItemType.text:
        return result.replied
            ? const OfficialAccountClickDecision.replied()
            : const OfficialAccountClickDecision.ignore();
      case OfficialAccountMenuItemType.action:
        final handoff = result.handoff;
        if (result.actionCode != 'contact_service' || handoff == null) {
          return const OfficialAccountClickDecision.ignore();
        }
        if (handoff.status == OfficialAccountHandoffStatus.active &&
            handoff.conversationId?.isNotEmpty == true) {
          return OfficialAccountClickDecision.openHandoff(handoff);
        }
        if (handoff.status == OfficialAccountHandoffStatus.queued) {
          return const OfficialAccountClickDecision.queued();
        }
        return const OfficialAccountClickDecision.ignore();
      case OfficialAccountMenuItemType.group:
      case OfficialAccountMenuItemType.unknown:
        return const OfficialAccountClickDecision.ignore();
    }
  }

  List<OfficialAccountMenuItem> _enabledItems(
    List<OfficialAccountMenuItem> items,
  ) {
    return items
        .where((item) => item.enabled)
        .map(
          (item) => item.copyWith(children: _enabledItems(item.children)),
        )
        .toList()
      ..sort((left, right) => left.sortOrder.compareTo(right.sortOrder));
  }

  bool _safeHttpUrl(String? value) {
    if (value == null || value.isEmpty) return false;
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }
}
