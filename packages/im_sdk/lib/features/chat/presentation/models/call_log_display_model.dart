import 'package:im_sdk/features/chat/domain/services/call_log_policy.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class CallLogDisplayModel {
  final String mediaTitle;
  final String status;
  final String? detail;

  const CallLogDisplayModel({
    required this.mediaTitle,
    required this.status,
    this.detail,
  });

  String get statusWithDetail => detail == null ? status : '$status · $detail';
}

CallLogDisplayModel localizedCallLogDisplay(
  AppLocalizations l10n,
  CallLogSemantic semantic,
) {
  final mediaTitle = switch (semantic.mediaKind) {
    CallLogMediaKind.audio => l10n.callAudio,
    CallLogMediaKind.video => l10n.callVideo,
    CallLogMediaKind.unknown => l10n.callGeneric,
  };

  return switch (semantic.outcome) {
    CallLogOutcome.completed => CallLogDisplayModel(
        mediaTitle: mediaTitle,
        status: semantic.isCaller ? l10n.callDialed : l10n.callAnswered,
        detail: l10n.callDurationValue(
          _formatSeconds(semantic.durationSeconds),
        ),
      ),
    CallLogOutcome.canceled => CallLogDisplayModel(
        mediaTitle: mediaTitle,
        status: semantic.isCaller ? l10n.callCancelled : l10n.callPeerCancelled,
      ),
    CallLogOutcome.rejected => CallLogDisplayModel(
        mediaTitle: mediaTitle,
        status: semantic.isCaller
            ? l10n.callRejectedByPeer
            : l10n.callRejectedBySelf,
      ),
    CallLogOutcome.missed => CallLogDisplayModel(
        mediaTitle: mediaTitle,
        status: semantic.isCaller
            ? l10n.callPeerDidNotAnswer
            : l10n.callMissedIncoming,
      ),
    CallLogOutcome.failed => CallLogDisplayModel(
        mediaTitle: mediaTitle,
        status: l10n.callFailed,
      ),
    CallLogOutcome.unknown => CallLogDisplayModel(
        mediaTitle: mediaTitle,
        status: l10n.callEnded,
      ),
  };
}

String _formatSeconds(int seconds) {
  final safeSeconds = seconds < 0 ? 0 : seconds;
  final hours = safeSeconds ~/ 3600;
  final minutes = (safeSeconds ~/ 60).remainder(60);
  final secs = safeSeconds.remainder(60);
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:'
      '${secs.toString().padLeft(2, '0')}';
}
