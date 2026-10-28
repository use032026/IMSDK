import 'package:path/path.dart' as p;

import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_failure.dart';

enum MessageSendPolicyContext {
  personal,
  enterpriseEmployee,
  enterpriseCustomer,
}

class MessageSendPolicy {
  final MessageSendPolicyContext context;
  final MessageSendRestrictions restrictions;

  static const callLogReadOnlyFailure = MessageSendFailure.serverRejected(
    code: 'LOCAL_POLICY_CALL_LOG_READ_ONLY',
    message: 'call log is a server-owned read-only projection',
  );

  const MessageSendPolicy({
    required this.context,
    this.restrictions = const MessageSendRestrictions(),
  });

  static const allowAll = MessageSendPolicy(
    context: MessageSendPolicyContext.personal,
  );

  MessageSendFailure? validate({
    required MessageType type,
    required MessageBody body,
  }) {
    if (!restrictions.allowed) {
      return MessageSendFailure.serverRejected(
        code: restrictions.blockedCode,
        message: 'message blocked by teen mode',
      );
    }
    if (_isMedia(type) && !restrictions.mediaAllowed) {
      return const MessageSendFailure.serverRejected(
        code: 'LOCAL_POLICY_TEEN_MEDIA_BLOCKED',
        message: 'media blocked by teen mode',
      );
    }
    if (type == MessageType.location && !restrictions.locationAllowed) {
      return const MessageSendFailure.serverRejected(
        code: 'LOCAL_POLICY_TEEN_LOCATION_BLOCKED',
        message: 'location blocked by teen mode',
      );
    }
    if (type == MessageType.contactCard && !restrictions.contactCardAllowed) {
      return const MessageSendFailure.serverRejected(
        code: 'LOCAL_POLICY_TEEN_CONTACT_CARD_BLOCKED',
        message: 'contact card blocked by teen mode',
      );
    }
    if (type == MessageType.callLog) {
      return callLogReadOnlyFailure;
    }
    if (type == MessageType.file && _isExecutableFile(body.file)) {
      return const MessageSendFailure.serverRejected(
        code: 'LOCAL_POLICY_EXECUTABLE_FILE_BLOCKED',
        message: 'message blocked by local send policy',
      );
    }
    if ((type == MessageType.text || type == MessageType.link) &&
        context == MessageSendPolicyContext.enterpriseCustomer &&
        (type == MessageType.link || _containsLink(body.text))) {
      return const MessageSendFailure.serverRejected(
        code: 'LOCAL_POLICY_ENTERPRISE_LINK_BLOCKED',
        message: 'message blocked by local send policy',
      );
    }
    return null;
  }

  bool _isMedia(MessageType type) =>
      type == MessageType.image ||
      type == MessageType.video ||
      type == MessageType.voice ||
      type == MessageType.file;

  bool _isExecutableFile(MediaResource? file) {
    if (file == null) return false;
    if (_hasExeExtension(file.fileName) || _hasExeExtension(file.url)) {
      return true;
    }
    final mimeType = file.mimeType?.trim().toLowerCase();
    return const {
      'application/x-msdownload',
      'application/x-msdos-program',
      'application/x-exe',
      'application/exe',
      'application/dos-exe',
      'application/x-winexe',
      'application/vnd.microsoft.portable-executable',
      'vms/exe',
    }.contains(mimeType);
  }

  bool _hasExeExtension(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return false;
    final parsed = Uri.tryParse(trimmed);
    final path = parsed?.path.isNotEmpty == true ? parsed!.path : trimmed;
    return p.extension(path).toLowerCase() == '.exe';
  }

  bool _containsLink(String? text) {
    final value = text?.trim();
    if (value == null || value.isEmpty) return false;
    if (RegExp(r'(?:https?:\/\/|www\.)\S+', caseSensitive: false)
        .hasMatch(value)) {
      return true;
    }

    final bareDomain = RegExp(
      r'\b(?:[a-z0-9-]+\.)+'
      r'(?:com|cn|net|org|io|co|app|dev|ai|xyz|top|me|info|biz|edu|gov|us|uk|jp|kr|hk|tw|de|fr|ru|in|shop|site|online|vip|club|cc)'
      r'(?:[/:?#][^\s]*)?',
      caseSensitive: false,
    );
    for (final match in bareDomain.allMatches(value)) {
      final start = match.start;
      if (start > 0 && value[start - 1] == '@') continue;
      return true;
    }
    return false;
  }
}

class MessageSendRestrictions {
  const MessageSendRestrictions({
    this.allowed = true,
    this.blockedCode,
    this.mediaAllowed = true,
    this.locationAllowed = true,
    this.contactCardAllowed = true,
  });

  final bool allowed;
  final String? blockedCode;
  final bool mediaAllowed;
  final bool locationAllowed;
  final bool contactCardAllowed;
}
