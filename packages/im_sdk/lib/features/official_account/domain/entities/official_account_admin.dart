enum OfficialAccountAdminStatus { active, disabled }

class OfficialAccountAdminOverview {
  final String? lppId;
  final String serviceAccountId;
  final String accountCode;
  final String displayName;
  final String? avatarUrl;
  final OfficialAccountAdminStatus status;
  final String officialUserId;
  final String loginName;
  final bool hasPassword;
  final int linkedCustomerCount;
  final int groupCount;
  final int menuVersion;
  final int menuItemCount;
  final OfficialAccountAdminConfig config;

  const OfficialAccountAdminOverview({
    this.lppId,
    required this.serviceAccountId,
    required this.accountCode,
    required this.displayName,
    this.avatarUrl,
    required this.status,
    required this.officialUserId,
    required this.loginName,
    required this.hasPassword,
    required this.linkedCustomerCount,
    required this.groupCount,
    required this.menuVersion,
    required this.menuItemCount,
    required this.config,
  });
}

class OfficialAccountAdminConfig {
  final String handoffMode;
  final bool servingNoticeEnabled;
  final String servingNoticeText;
  final bool friendAutoJoin;
  final bool? mirrorStaffReplyToOfficial;
  final bool inboundHandoffEnabled;
  final int handoffNoticeCooldownMinutes;
  final String handoffAssignedText;
  final String handoffQueuedText;
  final bool relayCustomerMessageToStaff;
  final bool welcomeEnabled;
  final String welcomeText;
  final bool menuEnabled;

  const OfficialAccountAdminConfig({
    this.handoffMode = 'separate_dm',
    this.servingNoticeEnabled = true,
    this.servingNoticeText = '客服「{staff}」为您服务。',
    this.friendAutoJoin = true,
    this.mirrorStaffReplyToOfficial,
    required this.inboundHandoffEnabled,
    required this.handoffNoticeCooldownMinutes,
    required this.handoffAssignedText,
    required this.handoffQueuedText,
    required this.relayCustomerMessageToStaff,
    required this.welcomeEnabled,
    required this.welcomeText,
    required this.menuEnabled,
  });

  OfficialAccountAdminConfig copyWith({
    String? handoffMode,
    bool? servingNoticeEnabled,
    String? servingNoticeText,
    bool? friendAutoJoin,
    bool? mirrorStaffReplyToOfficial,
    bool? inboundHandoffEnabled,
    int? handoffNoticeCooldownMinutes,
    String? handoffAssignedText,
    String? handoffQueuedText,
    bool? relayCustomerMessageToStaff,
    bool? welcomeEnabled,
    String? welcomeText,
    bool? menuEnabled,
  }) {
    return OfficialAccountAdminConfig(
      handoffMode: handoffMode ?? this.handoffMode,
      servingNoticeEnabled: servingNoticeEnabled ?? this.servingNoticeEnabled,
      servingNoticeText: servingNoticeText ?? this.servingNoticeText,
      friendAutoJoin: friendAutoJoin ?? this.friendAutoJoin,
      mirrorStaffReplyToOfficial:
          mirrorStaffReplyToOfficial ?? this.mirrorStaffReplyToOfficial,
      inboundHandoffEnabled:
          inboundHandoffEnabled ?? this.inboundHandoffEnabled,
      handoffNoticeCooldownMinutes:
          handoffNoticeCooldownMinutes ?? this.handoffNoticeCooldownMinutes,
      handoffAssignedText: handoffAssignedText ?? this.handoffAssignedText,
      handoffQueuedText: handoffQueuedText ?? this.handoffQueuedText,
      relayCustomerMessageToStaff:
          relayCustomerMessageToStaff ?? this.relayCustomerMessageToStaff,
      welcomeEnabled: welcomeEnabled ?? this.welcomeEnabled,
      welcomeText: welcomeText ?? this.welcomeText,
      menuEnabled: menuEnabled ?? this.menuEnabled,
    );
  }
}

class OfficialAccountProfileChange {
  final String? displayName;
  final String? avatarUrl;
  final String? lppId;
  const OfficialAccountProfileChange(
      {this.displayName, this.avatarUrl, this.lppId});
  String? get validationError {
    if (displayName != null &&
        (displayName!.trim().isEmpty ||
            displayName!.trim().runes.length > 64)) {
      return '名称须为 1–64 个字符';
    }
    if (lppId != null &&
        lppId!.isNotEmpty &&
        !RegExp(r'^\d{6,10}$').hasMatch(lppId!)) {
      return '官方号须为 6–10 位数字';
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        if (displayName != null) 'displayName': displayName!.trim(),
        if (avatarUrl != null) 'avatarUrl': avatarUrl!.trim(),
        if (lppId != null) 'lppId': lppId!.trim(),
      };
}

class OfficialAccountAdminInviteQr {
  final String tokenId;
  final String token;
  final String qrPayload;
  final int usedCount;
  final DateTime createdAt;
  const OfficialAccountAdminInviteQr(
      {required this.tokenId,
      required this.token,
      required this.qrPayload,
      required this.usedCount,
      required this.createdAt});
}
