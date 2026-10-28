import 'package:im_sdk/features/chat/domain/entities/message.dart';

enum CallLogMediaKind { audio, video, unknown }

enum CallLogOutcome { completed, canceled, rejected, missed, failed, unknown }

/// Current-user perspective over a server-projected call log.
class CallLogSemantic {
  final CallLogMediaKind mediaKind;
  final CallLogOutcome outcome;
  final bool isCaller;
  final int durationSeconds;

  const CallLogSemantic({
    required this.mediaKind,
    required this.outcome,
    required this.isCaller,
    required this.durationSeconds,
  });
}

/// Owns the v1/v2 compatibility rules from the call-log API contract.
class CallLogPolicy {
  const CallLogPolicy._();

  static CallLogSemantic resolve(
    Message message, {
    required String currentUserId,
  }) {
    return resolveLog(
      message.body.callLog,
      senderUserId: message.senderUserId,
      currentUserId: currentUserId,
    );
  }

  static CallLogSemantic resolveLog(
    CallLogDto? log, {
    required String senderUserId,
    required String currentUserId,
  }) {
    return CallLogSemantic(
      mediaKind: mediaKind(log),
      outcome: outcome(log),
      isCaller: _isCaller(
        log,
        senderUserId: senderUserId,
        currentUserId: currentUserId,
      ),
      durationSeconds: _duration(log),
    );
  }

  static CallLogMediaKind mediaKind(CallLogDto? log) {
    final raw = log?.mediaMode?.trim();
    if (log?.isV2 == true) {
      return switch (raw) {
        'audio' => CallLogMediaKind.audio,
        'audioVideo' => CallLogMediaKind.video,
        _ => CallLogMediaKind.unknown,
      };
    }

    final normalized = raw?.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    return switch (normalized) {
      'audio' => CallLogMediaKind.audio,
      'audiovideo' || 'video' => CallLogMediaKind.video,
      _ => CallLogMediaKind.unknown,
    };
  }

  static CallLogOutcome outcome(CallLogDto? log) {
    final raw = log?.endReason?.trim().toLowerCase() ?? '';
    if (log?.isV2 == true) {
      return switch (raw) {
        'completed' => CallLogOutcome.completed,
        'canceled' => CallLogOutcome.canceled,
        'rejected' => CallLogOutcome.rejected,
        'missed' => CallLogOutcome.missed,
        'failed' => CallLogOutcome.failed,
        _ => CallLogOutcome.unknown,
      };
    }

    if (raw.contains('did not') && raw.contains('within')) {
      return CallLogOutcome.missed;
    }
    return switch (raw) {
      'completed' ||
      'hangup' ||
      'caller_hangup' ||
      'callee_hangup' ||
      'normal' ||
      'ended' =>
        CallLogOutcome.completed,
      'canceled' || 'cancelled' || 'cancel' => CallLogOutcome.canceled,
      'rejected' => CallLogOutcome.rejected,
      'missed' || 'timeout' => CallLogOutcome.missed,
      'failed' ||
      'busy' ||
      'node_offline' ||
      'nodeoffline' ||
      'connection_lost' ||
      'connectionlost' ||
      'admin_force_end' ||
      'adminforceend' =>
        CallLogOutcome.failed,
      _ when _duration(log) > 0 => CallLogOutcome.completed,
      _ => CallLogOutcome.unknown,
    };
  }

  static bool _isCaller(
    CallLogDto? log, {
    required String senderUserId,
    required String currentUserId,
  }) {
    final normalizedCurrentUserId = currentUserId.trim();
    if (log?.isV2 == true) {
      return normalizedCurrentUserId.isNotEmpty &&
          log?.callerUserId?.trim() == normalizedCurrentUserId;
    }
    return normalizedCurrentUserId.isNotEmpty &&
        senderUserId.trim() == normalizedCurrentUserId;
  }

  static int _duration(CallLogDto? log) {
    final duration = log?.durationSeconds ?? 0;
    return duration < 0 ? 0 : duration;
  }
}
