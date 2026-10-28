enum ChatAppVisibility {
  foreground,
  background,
}

enum MessageNotificationSuppressionReason {
  silentMessage,
  selfMessage,
  mutedConversation,
  timelineEvent,
  globalMute,
  doNotDisturb,
  activeConversation,
  nativePushOwnsBackground,
}

class MessageNotificationPreferences {
  final bool globalMute;
  final String? dndStartTime;
  final String? dndEndTime;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool previewEnabled;

  const MessageNotificationPreferences({
    this.globalMute = false,
    this.dndStartTime,
    this.dndEndTime,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.previewEnabled = true,
  });
}

class MessageNotificationDecision {
  final MessageNotificationSuppressionReason? suppressionReason;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool previewEnabled;

  const MessageNotificationDecision.show({
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.previewEnabled,
  }) : suppressionReason = null;

  const MessageNotificationDecision.suppress(this.suppressionReason)
      : soundEnabled = false,
        vibrationEnabled = false,
        previewEnabled = false;

  bool get shouldShow => suppressionReason == null;
}

MessageNotificationDecision decideSystemMessageNotification({
  required ChatAppVisibility visibility,
  required String incomingConversationId,
  required String? activeConversationId,
  required bool isMuted,
  required bool isSelf,
  bool isSilentMessage = false,
  bool isTimelineEvent = false,
  bool nativePushOwnsBackground = false,
  MessageNotificationPreferences preferences =
      const MessageNotificationPreferences(),
  DateTime? now,
}) {
  if (isSilentMessage) {
    return const MessageNotificationDecision.suppress(
      MessageNotificationSuppressionReason.silentMessage,
    );
  }
  if (isSelf) {
    return const MessageNotificationDecision.suppress(
      MessageNotificationSuppressionReason.selfMessage,
    );
  }
  if (isMuted) {
    return const MessageNotificationDecision.suppress(
      MessageNotificationSuppressionReason.mutedConversation,
    );
  }
  if (isTimelineEvent) {
    return const MessageNotificationDecision.suppress(
      MessageNotificationSuppressionReason.timelineEvent,
    );
  }
  if (preferences.globalMute) {
    return const MessageNotificationDecision.suppress(
      MessageNotificationSuppressionReason.globalMute,
    );
  }
  if (_isInDoNotDisturbWindow(
    preferences.dndStartTime,
    preferences.dndEndTime,
    now ?? DateTime.now(),
  )) {
    return const MessageNotificationDecision.suppress(
      MessageNotificationSuppressionReason.doNotDisturb,
    );
  }
  if (visibility == ChatAppVisibility.foreground &&
      _sameConversation(incomingConversationId, activeConversationId)) {
    return const MessageNotificationDecision.suppress(
      MessageNotificationSuppressionReason.activeConversation,
    );
  }
  if (visibility == ChatAppVisibility.background && nativePushOwnsBackground) {
    return const MessageNotificationDecision.suppress(
      MessageNotificationSuppressionReason.nativePushOwnsBackground,
    );
  }
  return MessageNotificationDecision.show(
    soundEnabled: preferences.soundEnabled,
    vibrationEnabled: preferences.vibrationEnabled,
    previewEnabled: preferences.previewEnabled,
  );
}

bool _sameConversation(String incomingId, String? activeId) {
  final normalizedIncomingId = incomingId.trim();
  final normalizedActiveId = activeId?.trim();
  return normalizedIncomingId.isNotEmpty &&
      normalizedActiveId != null &&
      normalizedActiveId.isNotEmpty &&
      normalizedIncomingId == normalizedActiveId;
}

bool _isInDoNotDisturbWindow(
  String? start,
  String? end,
  DateTime now,
) {
  final startMinute = _parseClockMinute(start);
  final endMinute = _parseClockMinute(end);
  if (startMinute == null || endMinute == null || startMinute == endMinute) {
    return false;
  }
  final currentMinute = now.hour * 60 + now.minute;
  if (startMinute < endMinute) {
    return currentMinute >= startMinute && currentMinute < endMinute;
  }
  return currentMinute >= startMinute || currentMinute < endMinute;
}

int? _parseClockMinute(String? value) {
  if (value == null || value.isEmpty) return null;
  final parts = value.split(':');
  if (parts.length != 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null ||
      minute == null ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59) {
    return null;
  }
  return hour * 60 + minute;
}
