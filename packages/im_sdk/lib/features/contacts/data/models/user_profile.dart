import 'package:im_sdk/features/official_account/data/official_account_card_mapper.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';

class UserProfile {
  final String userId;
  final String name;
  final String? avatarUrl;
  final String? avatarEmoji;
  final String bubbleId;
  final String? gender;
  final String? region;
  final String? signature;
  final String? mobile;
  final List<String> tags;
  final String? remarkName;
  final bool isFriend;

  /// userType: 1=客户, 2=员工（来自 API）
  final int userType;
  final bool isOfficial;
  final OfficialAccountCard? officialAccount;

  const UserProfile({
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.avatarEmoji,
    required this.bubbleId,
    this.gender,
    this.region,
    this.signature,
    this.mobile,
    this.tags = const [],
    this.remarkName,
    this.isFriend = false,
    this.userType = 2,
    this.isOfficial = false,
    this.officialAccount,
  });

  bool get isEmployee => userType == 2;
  bool get isCustomer => userType == 1;

  Map<String, Object?> toCache() => {
        'userId': userId,
        'name': name,
        'avatarUrl': avatarUrl,
        'bubbleId': bubbleId,
        'gender': gender,
        'region': region,
        'signature': signature,
        'mobile': mobile,
        'tags': tags,
        'remarkName': remarkName,
        'isFriend': isFriend,
        'userType': userType,
        'isOfficial': isOfficial,
        if (officialAccount != null)
          'officialAccount': officialAccountCardToJson(officialAccount!),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String? ?? '',
      name: json['displayName'] as String? ?? json['name'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      avatarEmoji: json['avatarEmoji'] as String?,
      bubbleId: json['ztId'] as String? ??
          json['lppId'] as String? ??
          json['bubbleId'] as String? ??
          '',
      gender: json['gender'] as String?,
      region: json['location'] as String? ?? json['region'] as String?,
      signature: json['signature'] as String?,
      mobile: json['mobile'] as String? ?? json['phone'] as String?,
      tags: parseUserProfileTags(json['tags']),
      remarkName: json['remarkName'] as String?,
      isFriend: json['isFriend'] as bool? ?? false,
      userType: json['userType'] as int? ??
          ((json['isEmployee'] as bool?) == true ? 2 : 1),
      isOfficial: json['isOfficial'] == true || json['officialAccount'] != null,
      officialAccount: optionalOfficialAccountCard(json['officialAccount']),
    );
  }
}

List<String> parseUserProfileTags(Object? raw) {
  if (raw is List) {
    return raw
        .map((e) => e?.toString().trim() ?? '')
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }
  if (raw is String && raw.trim().isNotEmpty) {
    return raw
        .split(RegExp(r'[,，、]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }
  return const [];
}
