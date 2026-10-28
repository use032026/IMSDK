import 'dart:math' as math;

class CustomerServiceThreadIdentity {
  final String? handoffMode;
  final String? officialUserId;
  final String? assignedStaffUserId;
  final String threadType;
  final String threadId;
  final String conversationId;

  const CustomerServiceThreadIdentity({
    this.handoffMode,
    this.officialUserId,
    this.assignedStaffUserId,
    required this.threadType,
    required this.threadId,
    required this.conversationId,
  });

  bool matches({
    required String threadId,
    required String conversationId,
  }) {
    final ids = {
      this.threadId.trim(),
      this.conversationId.trim(),
    }..remove('');
    return ids.contains(threadId.trim()) || ids.contains(conversationId.trim());
  }
}

class CustomerServiceThreadIdentityIndex {
  final List<CustomerServiceThreadIdentity> identities;

  const CustomerServiceThreadIdentityIndex({this.identities = const []});

  CustomerServiceThreadIdentityIndex remember(
    CustomerServiceThreadIdentity identity,
  ) {
    final previous = match(
        threadId: identity.threadId, conversationId: identity.conversationId);
    final normalized = CustomerServiceThreadIdentity(
      handoffMode: identity.handoffMode ?? previous?.handoffMode,
      officialUserId: identity.officialUserId ?? previous?.officialUserId,
      assignedStaffUserId:
          identity.assignedStaffUserId ?? previous?.assignedStaffUserId,
      threadType: _normalizeThreadType(identity.threadType),
      threadId: identity.threadId.trim(),
      conversationId: identity.conversationId.trim(),
    );
    if (normalized.threadId.isEmpty && normalized.conversationId.isEmpty) {
      return this;
    }
    final next = [
      for (final existing in identities)
        if (!existing.matches(
          threadId: normalized.threadId,
          conversationId: normalized.conversationId,
        ))
          existing,
      normalized,
    ];
    return CustomerServiceThreadIdentityIndex(identities: next);
  }

  CustomerServiceThreadIdentityIndex rememberAll(
    Iterable<CustomerServiceThreadIdentity> values,
  ) {
    var next = this;
    for (final value in values) {
      next = next.remember(value);
    }
    return next;
  }

  CustomerServiceThreadIdentity? match({
    required String threadId,
    required String conversationId,
  }) {
    for (final identity in identities.reversed) {
      if (identity.matches(
        threadId: threadId,
        conversationId: conversationId,
      )) {
        return identity;
      }
    }
    return null;
  }
}

class CustomerServiceIncomingMessage {
  final CustomerServiceIncomingItemKind kind;
  final String threadType;
  final String threadId;
  final String conversationId;
  final String messageId;
  final int conversationSeq;
  final DateTime sentAt;
  final bool isSelf;
  final String? preview;

  const CustomerServiceIncomingMessage({
    this.kind = CustomerServiceIncomingItemKind.message,
    required this.threadType,
    required this.threadId,
    required this.conversationId,
    required this.messageId,
    required this.conversationSeq,
    required this.sentAt,
    required this.isSelf,
    this.preview,
  });

  bool get createsUnread => kind == CustomerServiceIncomingItemKind.message;

  String get messageKey {
    final id = messageId.trim();
    if (id.isNotEmpty) return id;
    final conversation = conversationId.trim();
    if (conversation.isEmpty || conversationSeq <= 0) return '';
    return '$conversation:$conversationSeq';
  }
}

class CustomerServiceUnreadEntry {
  final String threadType;
  final String threadId;
  final String conversationId;
  final int unreadCount;
  final Set<String> messageKeys;
  final DateTime lastMessageAt;
  final String? latestPreview;

  const CustomerServiceUnreadEntry({
    required this.threadType,
    required this.threadId,
    required this.conversationId,
    required this.unreadCount,
    required this.messageKeys,
    required this.lastMessageAt,
    this.latestPreview,
  });

  bool matches(CustomerServiceThreadIdentity identity) => identity.matches(
        threadId: threadId,
        conversationId: conversationId,
      );
}

class CustomerServiceUnreadLedger {
  final List<CustomerServiceUnreadEntry> entries;
  final List<CustomerServiceReadClear> readClears;

  const CustomerServiceUnreadLedger({
    this.entries = const [],
    this.readClears = const [],
  });

  CustomerServiceUnreadLedger record(CustomerServiceIncomingMessage message) {
    if (!message.createsUnread ||
        message.isSelf ||
        message.messageKey.isEmpty) {
      return this;
    }
    if (entries
        .any((entry) => entry.messageKeys.contains(message.messageKey))) {
      return this;
    }

    final identity = CustomerServiceThreadIdentity(
      threadType: message.threadType,
      threadId: message.threadId,
      conversationId: message.conversationId,
    );
    final nextReadClears = readClears;
    final index = entries.indexWhere((entry) => entry.matches(identity));
    if (index < 0) {
      return CustomerServiceUnreadLedger(
        entries: [
          ...entries,
          CustomerServiceUnreadEntry(
            threadType: _normalizeThreadType(message.threadType),
            threadId: message.threadId.trim(),
            conversationId: message.conversationId.trim(),
            unreadCount: 1,
            messageKeys: {message.messageKey},
            lastMessageAt: message.sentAt,
            latestPreview: _nonBlank(message.preview),
          ),
        ],
        readClears: nextReadClears,
      );
    }

    final previous = entries[index];
    final next = [...entries];
    next[index] = CustomerServiceUnreadEntry(
      threadType: previous.threadType,
      threadId: previous.threadId.isNotEmpty
          ? previous.threadId
          : message.threadId.trim(),
      conversationId: previous.conversationId.isNotEmpty
          ? previous.conversationId
          : message.conversationId.trim(),
      unreadCount: previous.unreadCount + 1,
      messageKeys: {...previous.messageKeys, message.messageKey},
      lastMessageAt: message.sentAt.isAfter(previous.lastMessageAt)
          ? message.sentAt
          : previous.lastMessageAt,
      latestPreview: message.sentAt.isAfter(previous.lastMessageAt)
          ? _nonBlank(message.preview) ?? previous.latestPreview
          : previous.latestPreview,
    );
    return CustomerServiceUnreadLedger(
      entries: next,
      readClears: nextReadClears,
    );
  }

  CustomerServiceUnreadLedger clear({
    required String threadId,
    required String conversationId,
    required DateTime clearedAt,
  }) {
    final identity = CustomerServiceThreadIdentity(
      threadType: '',
      threadId: threadId,
      conversationId: conversationId,
    );
    final next = entries
        .where((entry) => !entry.matches(identity))
        .toList(growable: false);
    final nextReadClears = [
      ...readClears.where((clear) => !clear.matches(identity)),
      CustomerServiceReadClear(
        threadId: threadId.trim(),
        conversationId: conversationId.trim(),
        clearedAt: clearedAt,
      ),
    ];
    return CustomerServiceUnreadLedger(
      entries: next,
      readClears: nextReadClears,
    );
  }

  int unreadFor(CustomerServiceThreadIdentity identity) {
    return entries
        .where((entry) => entry.matches(identity))
        .fold(0, (sum, entry) => sum + entry.unreadCount);
  }

  CustomerServiceUnreadEntry? latestFor(
    CustomerServiceThreadIdentity identity,
  ) {
    CustomerServiceUnreadEntry? latest;
    for (final entry in entries.where((entry) => entry.matches(identity))) {
      if (latest == null || entry.lastMessageAt.isAfter(latest.lastMessageAt)) {
        latest = entry;
      }
    }
    return latest;
  }

  int resolveUnread({
    required CustomerServiceThreadIdentity identity,
    required int serverUnreadCount,
    DateTime? serverLastMessageAt,
  }) {
    final overlayUnread = unreadFor(identity);
    CustomerServiceReadClear? readClear;
    for (final clear in readClears) {
      if (clear.matches(identity)) {
        readClear = clear;
        break;
      }
    }
    if (readClear == null) {
      return math.max(math.max(0, serverUnreadCount), overlayUnread);
    }
    final serverHasNewerMessage = serverLastMessageAt != null &&
        serverLastMessageAt.isAfter(readClear.clearedAt);
    if (!serverHasNewerMessage) return overlayUnread;
    return math.max(math.max(0, serverUnreadCount), overlayUnread);
  }
}

class CustomerServiceReadClear {
  final String threadId;
  final String conversationId;
  final DateTime clearedAt;

  const CustomerServiceReadClear({
    required this.threadId,
    required this.conversationId,
    required this.clearedAt,
  });

  bool matches(CustomerServiceThreadIdentity identity) => identity.matches(
        threadId: threadId,
        conversationId: conversationId,
      );
}

class CustomerServiceThreadReminderSnapshot {
  final CustomerServiceThreadIdentity identity;
  final bool isQueued;
  final int serverUnreadCount;
  final DateTime? lastMessageAt;

  const CustomerServiceThreadReminderSnapshot({
    required this.identity,
    required this.isQueued,
    required this.serverUnreadCount,
    this.lastMessageAt,
  });
}

class CustomerServiceReminderProjection {
  final int totalCount;
  final int onlineCount;
  final int totalMessageCount;
  final int onlineMessageCount;

  const CustomerServiceReminderProjection({
    required this.totalCount,
    required this.onlineCount,
    required this.totalMessageCount,
    required this.onlineMessageCount,
  });
}

CustomerServiceReminderProjection projectCustomerServiceReminders({
  required Iterable<CustomerServiceThreadReminderSnapshot> threads,
  required CustomerServiceUnreadLedger realtimeLedger,
}) {
  var totalCount = 0;
  var onlineCount = 0;
  var totalMessageCount = 0;
  var onlineMessageCount = 0;
  final matchedEntries = <CustomerServiceUnreadEntry>{};

  for (final thread in threads) {
    final matchingEntries =
        realtimeLedger.entries.where((entry) => entry.matches(thread.identity));
    matchedEntries.addAll(matchingEntries);
    final effectiveUnread = realtimeLedger.resolveUnread(
      identity: thread.identity,
      serverUnreadCount: thread.serverUnreadCount,
      serverLastMessageAt: thread.lastMessageAt,
    );
    final reminderCount = thread.isQueued ? 1 : effectiveUnread;
    final effectiveMessageCount = effectiveUnread;
    totalCount += reminderCount;
    totalMessageCount += effectiveMessageCount;
    if (_normalizeThreadType(thread.identity.threadType) == 'temp_session' ||
        thread.identity.handoffMode == 'in_official') {
      onlineCount += reminderCount;
      onlineMessageCount += effectiveMessageCount;
    }
  }

  for (final entry in realtimeLedger.entries) {
    if (matchedEntries.contains(entry)) continue;
    totalCount += entry.unreadCount;
    totalMessageCount += entry.unreadCount;
    if (_normalizeThreadType(entry.threadType) == 'temp_session') {
      onlineCount += entry.unreadCount;
      onlineMessageCount += entry.unreadCount;
    }
  }

  return CustomerServiceReminderProjection(
    totalCount: totalCount,
    onlineCount: onlineCount,
    totalMessageCount: totalMessageCount,
    onlineMessageCount: onlineMessageCount,
  );
}

enum CustomerServiceIncomingItemKind {
  message,
  timelineEvent,
}

String _normalizeThreadType(String value) {
  final normalized = value.trim().toLowerCase().replaceAll('-', '_');
  if (normalized == 'direct_customer') return 'im_direct';
  return normalized;
}

String? _nonBlank(String? value) {
  final text = value?.trim();
  return text == null || text.isEmpty ? null : text;
}
