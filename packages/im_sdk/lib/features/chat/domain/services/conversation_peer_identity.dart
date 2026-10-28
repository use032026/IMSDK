enum ConversationPeerIdentityKind {
  customer,
  employee,
  customerService,
  admin,
  owner,
  unknown,
}

/// Resolves the peer identity from the strongest available business evidence.
///
/// Directory role data is more precise than the conversation API's
/// `peerUserType`, where `2` only means staff and must not be promoted to
/// customer service.
ConversationPeerIdentityKind resolveConversationPeerIdentity({
  int? peerUserType,
  int? directoryUserType,
  String? directoryRoleLabel,
}) {
  final role = directoryRoleLabel?.trim();
  switch (role) {
    case '所有者':
      return ConversationPeerIdentityKind.owner;
    case '管理员':
      return ConversationPeerIdentityKind.admin;
    case '客服':
      return ConversationPeerIdentityKind.customerService;
    case '客户':
      return ConversationPeerIdentityKind.customer;
    case '员工':
    case '技术支持':
      return ConversationPeerIdentityKind.employee;
  }

  if (directoryUserType == 1) {
    return ConversationPeerIdentityKind.customer;
  }
  if (directoryUserType == 2) {
    return ConversationPeerIdentityKind.employee;
  }

  return switch (peerUserType) {
    1 => ConversationPeerIdentityKind.customer,
    2 => ConversationPeerIdentityKind.employee,
    _ => ConversationPeerIdentityKind.unknown,
  };
}
