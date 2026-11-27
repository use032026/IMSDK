bool showsOfficialVerification({
  required bool verified,
  Object? officialAccountKind,
  bool isOfficialAccount = false,
}) =>
    verified &&
    !isOfficialAccount &&
    !(officialAccountKind is String && officialAccountKind.trim().isNotEmpty);
