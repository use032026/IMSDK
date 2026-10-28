/// 企业空间中的联系方式不进入普通朋友资料；个人空间展示服务端允许
/// 当前用户查看的公开资料。
bool canShowFriendContactChannels({
  required bool isEnterpriseSpace,
}) {
  return !isEnterpriseSpace;
}

String? friendProfileVisiblePhone({
  required bool isEnterpriseSpace,
  String? phone,
}) {
  if (!canShowFriendContactChannels(
    isEnterpriseSpace: isEnterpriseSpace,
  )) {
    return null;
  }
  final normalized = phone?.trim();
  if (normalized?.isNotEmpty != true) return null;
  return normalized;
}
