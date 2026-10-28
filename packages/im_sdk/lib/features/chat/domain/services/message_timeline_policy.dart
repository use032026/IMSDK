import 'package:im_sdk/features/chat/domain/entities/message.dart';

/// Owns ordering, deduplication and pagination cursor rules for a chat timeline.
/// Server-confirmed messages are ordered by sequence; local optimistic or
/// failed messages remain after them. Local historical events are inserted by
/// creation time without changing the relative order of server messages.
class MessageTimelinePolicy {
  const MessageTimelinePolicy();

  List<Message> sort(Iterable<Message> messages) {
    final serverMessages = messages
        .where((message) => message.conversationSeq > 0)
        .toList(growable: false)
      ..sort((a, b) => a.conversationSeq.compareTo(b.conversationSeq));
    final localEvents = messages.where(_isLocalHistoricalEvent).toList()
      ..sort(_compareCreationTime);
    final localMessages = messages
        .where((message) =>
            message.conversationSeq <= 0 && !_isLocalHistoricalEvent(message))
        .toList(growable: false)
      ..sort(_compareCreationTime);

    final history = <Message>[];
    var eventIndex = 0;
    for (final message in serverMessages) {
      while (eventIndex < localEvents.length &&
          !localEvents[eventIndex].sentAt.isAfter(message.sentAt)) {
        history.add(localEvents[eventIndex++]);
      }
      history.add(message);
    }
    return [...history, ...localEvents.skip(eventIndex), ...localMessages];
  }

  bool _isLocalHistoricalEvent(Message message) =>
      message.conversationSeq <= 0 &&
      message.type == MessageType.event &&
      message.status.isServerUsable;

  int _compareCreationTime(Message a, Message b) {
    final sentAtOrder = a.sentAt.compareTo(b.sentAt);
    return sentAtOrder != 0 ? sentAtOrder : a.messageId.compareTo(b.messageId);
  }

  /// Reconciles two snapshots whose message/client identity already matches.
  /// A late local attempt cannot undo a server-confirmed send.
  Message reconcileUpdate(Message previous, Message incoming) {
    if ((previous.status.isServerUsable && !incoming.status.isServerUsable) ||
        (previous.conversationSeq > 0 && incoming.conversationSeq <= 0)) {
      return previous;
    }
    return previous.isSelf && !incoming.isSelf
        ? incoming.copyWith(isSelf: true)
        : incoming;
  }

  List<Message> merge(
    Iterable<Message> existing,
    Iterable<Message> incoming,
  ) {
    final byMessageId = <String, Message>{};
    final messageIdByClientId = <String, String>{};

    void add(Message message) {
      var previousForOwnership = byMessageId[message.messageId];
      final clientMsgId = message.clientMsgId;
      if (clientMsgId != null && clientMsgId.isNotEmpty) {
        final previousMessageId = messageIdByClientId[clientMsgId];
        if (previousMessageId != null) {
          final previous = byMessageId[previousMessageId];
          previousForOwnership ??= previous;
        }
        if (message.operatorUserId != null &&
            previousForOwnership != null &&
            (previousForOwnership.operatorUserId ??
                    previousForOwnership.senderUserId) !=
                message.operatorUserId) {
          byMessageId[message.messageId] = message;
          return;
        }
        if (previousMessageId != null &&
            previousMessageId != message.messageId) {
          final previous = byMessageId[previousMessageId];
          if (previous != null &&
              identical(reconcileUpdate(previous, message), previous)) {
            return;
          }
          byMessageId.remove(previousMessageId);
        }
        messageIdByClientId[clientMsgId] = message.messageId;
      }
      // Missing self metadata in a replay must not undo known ownership of
      // the same message. All server content, sequence and receipt facts win.
      byMessageId[message.messageId] = previousForOwnership == null
          ? message
          : reconcileUpdate(previousForOwnership, message);
    }

    for (final message in existing) {
      add(message);
    }
    for (final message in incoming) {
      add(message);
    }
    return projectCallLogs(byMessageId.values);
  }

  /// Returns a reversible display projection for cached v1 call-log
  /// duplicates. Raw rows stay in SQLite and continue to drive pagination.
  List<Message> projectCallLogs(Iterable<Message> messages) {
    final projected = <Message>[];
    final indexByCallId = <String, int>{};

    for (final message in messages) {
      final callId = message.type == MessageType.callLog
          ? message.body.callLog?.callId.trim().toLowerCase() ?? ''
          : '';
      if (callId.isEmpty) {
        projected.add(message);
        continue;
      }

      final currentIndex = indexByCallId[callId];
      if (currentIndex == null) {
        indexByCallId[callId] = projected.length;
        projected.add(message);
        continue;
      }

      final current = projected[currentIndex];
      if (_preferCallLog(message, current)) {
        projected[currentIndex] = message;
      }
    }

    return sort(projected);
  }

  int? oldestServerSequence(Iterable<Message> messages) {
    int? oldest;
    for (final message in messages) {
      final sequence = message.conversationSeq;
      if (sequence <= 0) continue;
      if (oldest == null || sequence < oldest) oldest = sequence;
    }
    return oldest;
  }

  bool hasFullServerPage(Iterable<Message> messages, int pageSize) {
    if (pageSize <= 0) return false;
    var serverCount = 0;
    for (final message in messages) {
      if (message.conversationSeq <= 0) continue;
      serverCount++;
      if (serverCount >= pageSize) return true;
    }
    return false;
  }

  bool _preferCallLog(Message candidate, Message current) {
    final candidateIsV2 = candidate.body.callLog?.isV2 == true;
    final currentIsV2 = current.body.callLog?.isV2 == true;
    if (candidateIsV2 != currentIsV2) return candidateIsV2;

    final candidateSeq = candidate.conversationSeq;
    final currentSeq = current.conversationSeq;
    final candidateHasServerSeq = candidateSeq > 0;
    final currentHasServerSeq = currentSeq > 0;
    if (candidateHasServerSeq != currentHasServerSeq) {
      return candidateHasServerSeq;
    }
    if (candidateHasServerSeq && candidateSeq != currentSeq) {
      return candidateSeq < currentSeq;
    }

    final sentAtOrder = candidate.sentAt.compareTo(current.sentAt);
    if (sentAtOrder != 0) return sentAtOrder < 0;
    return candidate.messageId.compareTo(current.messageId) < 0;
  }
}
