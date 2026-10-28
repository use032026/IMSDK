enum BulkSendTargetType { friend, group }

enum BulkSendStatus { sending, success, failed }

class BulkSendTarget {
  final String id;
  final String title;
  final String? subtitle;
  final String? avatarUrl;
  final BulkSendTargetType type;
  final String? userId;
  final String? conversationId;
  final List<String?> memberAvatarUrls;
  final List<String> memberNames;

  const BulkSendTarget._({
    required this.id,
    required this.title,
    required this.type,
    this.subtitle,
    this.avatarUrl,
    this.userId,
    this.conversationId,
    this.memberAvatarUrls = const [],
    this.memberNames = const [],
  });

  const BulkSendTarget.friend({
    required String id,
    required String userId,
    required String title,
    String? subtitle,
    String? avatarUrl,
  }) : this._(
          id: id,
          userId: userId,
          title: title,
          subtitle: subtitle,
          avatarUrl: avatarUrl,
          type: BulkSendTargetType.friend,
        );

  const BulkSendTarget.group({
    required String id,
    required String conversationId,
    required String title,
    String? subtitle,
    String? avatarUrl,
    List<String?> memberAvatarUrls = const [],
    List<String> memberNames = const [],
  }) : this._(
          id: id,
          conversationId: conversationId,
          title: title,
          subtitle: subtitle,
          avatarUrl: avatarUrl,
          type: BulkSendTargetType.group,
          memberAvatarUrls: memberAvatarUrls,
          memberNames: memberNames,
        );

  bool get isGroup => type == BulkSendTargetType.group;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BulkSendTarget && other.id == id && other.type == type;

  @override
  int get hashCode => Object.hash(id, type);
}

class BulkSendItemResult {
  final String targetId;
  final BulkSendStatus status;
  final String? message;

  const BulkSendItemResult({
    required this.targetId,
    required this.status,
    this.message,
  });
}

class BulkSendSummary {
  final int successCount;
  final int failedCount;

  const BulkSendSummary({
    required this.successCount,
    required this.failedCount,
  });
}
