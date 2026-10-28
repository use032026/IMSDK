import 'package:im_sdk/features/chat/domain/entities/conversation.dart';

ConversationType? parseConversationType(Object? rawType) {
  final normalized = rawType is String ? rawType.trim() : '';
  return switch (normalized) {
    'direct' => ConversationType.direct,
    'group' => ConversationType.group,
    'tempSession' || 'temp_session' => ConversationType.tempSession,
    _ => null,
  };
}

/// Resolves the safest known type for a conversation navigation target.
///
/// Any source identifying the target as a group wins over a conflicting
/// `direct` hint so the release-face guard cannot fail open on stale payloads.
ConversationType? resolveConversationTypeForNavigation({
  required String conversationId,
  Object? explicitType,
  ConversationType? scopedType,
  bool knownGroup = false,
  Map<String, ConversationType> knownConversationTypes = const {},
}) {
  final explicit = parseConversationType(explicitType);
  final local = knownConversationTypes[conversationId];
  if (knownGroup ||
      explicit == ConversationType.group ||
      local == ConversationType.group ||
      scopedType == ConversationType.group) {
    return ConversationType.group;
  }
  return explicit ?? local ?? scopedType;
}

bool isConversationVisibleForReleaseFace({
  required bool groupFeaturesBlocked,
  required ConversationType? conversationType,
}) {
  if (!groupFeaturesBlocked) return true;
  return conversationType == ConversationType.direct ||
      conversationType == ConversationType.tempSession;
}

Map<String, Object> conversationRouteMetadata({
  required String conversationId,
  required ConversationType conversationType,
}) {
  return {
    'conversationId': conversationId,
    'conversationType': conversationType.name,
    'isGroup': conversationType == ConversationType.group,
  };
}
