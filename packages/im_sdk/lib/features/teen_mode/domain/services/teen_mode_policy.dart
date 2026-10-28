import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';

class TeenPolicyResolver {
  const TeenPolicyResolver({
    required this.policy,
    required this.catalog,
  });

  final TeenPolicy policy;
  final Iterable<TeenPolicyCatalogItem> catalog;

  Object? value(String key) {
    TeenPolicyCatalogItem? matchedItem;
    for (final item in catalog) {
      if (item.key == key) {
        matchedItem = item;
        break;
      }
    }
    if (matchedItem == null) return null;
    if (policy.containsKey(key)) {
      final explicitValue = _validatedValue(matchedItem, policy[key]);
      if (explicitValue != null) return explicitValue;
    }
    return _validatedValue(matchedItem, matchedItem.defaultValue);
  }

  Object? _validatedValue(TeenPolicyCatalogItem item, Object? value) {
    switch (item.kind) {
      case TeenPolicyKind.boolValue:
        return value is bool ? value : null;
      case TeenPolicyKind.intValue:
        if (value is! num ||
            !value.isFinite ||
            value != value.roundToDouble()) {
          return null;
        }
        final normalized = value.toInt();
        if (item.min != null && normalized < item.min!) return null;
        if (item.max != null && normalized > item.max!) return null;
        return normalized;
      case TeenPolicyKind.enumValue:
        return item.options.any((option) => option.value == value)
            ? value
            : null;
      case TeenPolicyKind.unknown:
        return null;
    }
  }
}

class GuardianMinorPolicy {
  GuardianMinorPolicy(
      GuardianMinor minor, Iterable<TeenPolicyCatalogItem> catalog)
      : _resolver = TeenPolicyResolver(
          policy: minor.policy,
          catalog: catalog,
        );

  final TeenPolicyResolver _resolver;

  bool get canExtend => _resolver.value('guardian_can_extend') != false;

  int? get maxExtensionMinutes {
    final value = _resolver.value('extend_max_minutes');
    return value is num && value > 0 ? value.toInt() : null;
  }
}

class TeenModePolicy {
  const TeenModePolicy(this.state);

  final TeenModeState? state;

  TeenModeProfile? get _activeProfile {
    final profile = state?.profile;
    return profile?.active == true ? profile : null;
  }

  bool get linkAccessResolved => state != null;

  bool canUseConversation({required bool isReliefConversation}) =>
      isReliefConversation || _activeProfile?.session.isRestricted != true;

  Object? _policyValue(String key) {
    final profile = _activeProfile;
    if (profile == null) return null;
    return TeenPolicyResolver(
      policy: profile.policy,
      catalog: state!.config.policyCatalog,
    ).value(key);
  }

  bool get sendMediaAllowed =>
      _activeProfile == null || _policyValue('send_media') != false;

  bool get sendLocationAllowed =>
      _activeProfile == null || _policyValue('send_location') == true;

  bool get sendContactCardAllowed =>
      _activeProfile == null || _policyValue('send_contact_card') == true;

  bool get blocksAllLinks => _policyValue('link_policy') == 'none';

  bool get requiresLinkWhitelist => _policyValue('link_policy') == 'whitelist';

  bool canAttemptStartCall({required bool isFriend}) {
    final profile = _activeProfile;
    if (profile == null) return true;
    if (profile.session.isRestricted) return false;
    final value = _policyValue('call_policy');
    if (value == 'block') return false;
    if (value == 'friends_only' && !isFriend) return false;
    return true;
  }

  bool get canAttemptCreateGroup {
    final profile = _activeProfile;
    if (profile == null) return true;
    return !profile.session.isRestricted &&
        _policyValue('group_create') != 'block';
  }

  bool get canAttemptAddFriend {
    final profile = _activeProfile;
    if (profile == null) return true;
    return !profile.session.isRestricted &&
        _policyValue('friend_add_approval') != 'block';
  }

  bool get canAttemptAcceptFriend {
    final profile = _activeProfile;
    if (profile == null) return true;
    return !profile.session.isRestricted &&
        _policyValue('friend_accept_approval') != 'block';
  }

  bool get canAttemptJoinGroup {
    final profile = _activeProfile;
    if (profile == null) return true;
    return !profile.session.isRestricted &&
        _policyValue('group_join') != 'block';
  }

  bool get canAttemptCreateTenant {
    final profile = _activeProfile;
    if (profile == null) return true;
    return !profile.session.isRestricted &&
        _policyValue('tenant_create') != 'block';
  }
}
