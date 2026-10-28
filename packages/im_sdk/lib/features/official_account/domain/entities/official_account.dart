enum OfficialAccountMenuItemType {
  url,
  appRoute,
  text,
  action,
  group,
  unknown,
}

enum OfficialAccountHandoffStatus { active, queued, unknown }

typedef OfficialAccountScope = ({
  String siteId,
  String spaceId,
  String userId,
});

class OfficialAccount {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int status;
  final String? conversationId;
  final OfficialAccountMenu menu;

  const OfficialAccount({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.status,
    this.conversationId,
    required this.menu,
  });

  OfficialAccount copyWith({OfficialAccountMenu? menu}) {
    return OfficialAccount(
      userId: userId,
      displayName: displayName,
      avatarUrl: avatarUrl,
      status: status,
      conversationId: conversationId,
      menu: menu ?? this.menu,
    );
  }
}

class OfficialAccountMenu {
  final bool enabled;
  final int version;
  final List<OfficialAccountMenuItem> items;

  const OfficialAccountMenu({
    required this.enabled,
    required this.version,
    required this.items,
  });
}

class OfficialAccountMenuItem {
  final String id;
  final String title;
  final OfficialAccountMenuItemType type;
  final String? url;
  final String? appRoute;
  final String? replyText;
  final String? actionCode;
  final String? iconUrl;
  final bool enabled;
  final int sortOrder;
  final List<OfficialAccountMenuItem> children;

  const OfficialAccountMenuItem({
    required this.id,
    required this.title,
    required this.type,
    this.url,
    this.appRoute,
    this.replyText,
    this.actionCode,
    this.iconUrl,
    required this.enabled,
    required this.sortOrder,
    required this.children,
  });

  OfficialAccountMenuItem copyWith({
    List<OfficialAccountMenuItem>? children,
  }) {
    return OfficialAccountMenuItem(
      id: id,
      title: title,
      type: type,
      url: url,
      appRoute: appRoute,
      replyText: replyText,
      actionCode: actionCode,
      iconUrl: iconUrl,
      enabled: enabled,
      sortOrder: sortOrder,
      children: children ?? this.children,
    );
  }
}

class OfficialAccountHandoff {
  final String threadId;
  final OfficialAccountHandoffStatus status;
  final String? staffUserId;
  final String? staffDisplayName;
  final String? conversationId;

  const OfficialAccountHandoff({
    required this.threadId,
    required this.status,
    this.staffUserId,
    this.staffDisplayName,
    this.conversationId,
  });
}

class OfficialAccountMenuClickResult {
  final String itemId;
  final OfficialAccountMenuItemType type;
  final String? url;
  final String? appRoute;
  final String? actionCode;
  final bool replied;
  final OfficialAccountHandoff? handoff;

  const OfficialAccountMenuClickResult({
    required this.itemId,
    required this.type,
    this.url,
    this.appRoute,
    this.actionCode,
    required this.replied,
    this.handoff,
  });
}
