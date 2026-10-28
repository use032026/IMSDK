class FriendProfileExtra {
  final String friendUserId;
  final String remarkName;
  final List<String> tags;
  final String note;
  final String? mobile;
  final String? gender;
  final String? remarkGender;
  final bool remarkGenderProvided;
  final String? region;
  final String? signature;
  final String? source;
  final String? addedAt;
  final int commonGroupCount;
  final DateTime? syncedAt;

  const FriendProfileExtra({
    required this.friendUserId,
    this.remarkName = '',
    this.tags = const [],
    this.note = '',
    this.mobile,
    this.gender,
    this.remarkGender,
    this.remarkGenderProvided = false,
    this.region,
    this.signature,
    this.source,
    this.addedAt,
    this.commonGroupCount = 0,
    this.syncedAt,
  });

  FriendProfileExtra copyWith({
    String? remarkName,
    List<String>? tags,
    String? note,
    String? mobile,
    String? gender,
    String? region,
    String? signature,
    String? source,
    String? addedAt,
    int? commonGroupCount,
    DateTime? syncedAt,
  }) {
    return FriendProfileExtra(
      friendUserId: friendUserId,
      remarkName: remarkName ?? this.remarkName,
      tags: tags ?? this.tags,
      note: note ?? this.note,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      remarkGender: remarkGender,
      remarkGenderProvided: remarkGenderProvided,
      region: region ?? this.region,
      signature: signature ?? this.signature,
      source: source ?? this.source,
      addedAt: addedAt ?? this.addedAt,
      commonGroupCount: commonGroupCount ?? this.commonGroupCount,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  String? get effectiveGender => remarkGender ?? gender;

  FriendProfileExtra withRemarkGender(String? value) {
    return withRemarkGenderSnapshot(
      value,
      provided: true,
    );
  }

  FriendProfileExtra withRemarkGenderSnapshot(
    String? value, {
    required bool provided,
  }) {
    return FriendProfileExtra(
      friendUserId: friendUserId,
      remarkName: remarkName,
      tags: tags,
      note: note,
      mobile: mobile,
      gender: gender,
      remarkGender: normalizeFriendGender(value),
      remarkGenderProvided: provided,
      region: region,
      signature: signature,
      source: source,
      addedAt: addedAt,
      commonGroupCount: commonGroupCount,
      syncedAt: syncedAt,
    );
  }
}

String? normalizeFriendGender(Object? value) {
  if (value == null) return null;
  final normalized = value.toString().trim().toLowerCase();
  switch (normalized) {
    case '0':
    case 'unset':
    case 'unknown':
      return null;
    case '1':
    case 'male':
      return 'male';
    case '2':
    case 'female':
      return 'female';
    case '3':
    case 'other':
      return 'other';
    default:
      return normalized.isEmpty ? null : normalized;
  }
}

int friendGenderWireValue(String? value) {
  switch (normalizeFriendGender(value)) {
    case 'male':
      return 1;
    case 'female':
      return 2;
    case 'other':
      return 3;
    default:
      return 0;
  }
}

List<String> normalizeFriendTags(Iterable<String> values) {
  final result = <String>[];
  final seen = <String>{};
  for (final raw in values) {
    final value = raw.trim();
    if (value.isEmpty) continue;
    if (!seen.add(value)) continue;
    result.add(value);
    if (result.length == 20) break;
  }
  return List.unmodifiable(result);
}

class FriendRemarkDraft {
  final String remarkName;
  final List<String> tags;
  final String note;

  const FriendRemarkDraft({
    this.remarkName = '',
    this.tags = const [],
    this.note = '',
  });

  factory FriendRemarkDraft.fromProfile(FriendProfileExtra profile) {
    return FriendRemarkDraft(
      remarkName: profile.remarkName,
      tags: profile.tags,
      note: profile.note,
    );
  }

  FriendRemarkDraft normalized() {
    return FriendRemarkDraft(
      remarkName: remarkName.trim(),
      tags: normalizeFriendTags(tags),
      note: note.trim(),
    );
  }
}
