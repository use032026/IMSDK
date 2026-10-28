import 'dart:convert';

import 'package:crypto/crypto.dart';

/// An allowlist, not a best-effort scrub of arbitrary business payloads.
class DiagnosticRedactor {
  static const version = 1;
  static final _identifier = RegExp(r'^[a-zA-Z0-9_.:-]{1,128}$');
  static final _category = RegExp(r'^[a-zA-Z0-9_.-]{1,80}$');
  static const _identifiers = {
    'method',
    'requestId',
    'traceId',
    'clientTraceId',
    'serverCode',
    'code',
    'errorType',
    'networkErrorType',
    'credentialDomain',
    'reason',
    'source',
    'phase',
    'stage',
    'decision',
    'event',
    'state',
    'platform',
    'library',
  };
  static const _numbers = {
    'statusCode',
    'elapsedMs',
    'durationMs',
    'totalMs',
    'count',
    'attempt',
    'retryCount',
    'sequence',
    'bytes',
    'port',
    'osErrorCode',
    'version',
    'omittedFields',
  };
  static const _fingerprints = {
    'scopeFingerprint',
    'activationFingerprint',
    'scopeHash',
    'resourceHash',
    'messageHash',
    'accountHash',
    'storageHash',
  };
  static const _privateIds = {
    'userId',
    'platformUserId',
    'tenantId',
    'spaceId',
    'conversationId',
    'messageId',
    'clientMsgId',
    'groupId',
  };

  String category(String value) =>
      _category.hasMatch(value) ? value : 'diagnostics.unknown';

  // Callers' exception messages and interpolated DTOs are deliberately excluded.
  String message(String category, String original) => this.category(category);

  String? identifier(Object? value) {
    final text = value?.toString() ?? '';
    return _identifier.hasMatch(text) ? text : null;
  }

  Map<String, Object?> context(Map<String, Object?> source, [int depth = 0]) {
    if (depth > 3) return const {};
    final result = <String, Object?>{};
    var omitted = 0;
    for (final entry in source.entries.take(40)) {
      final key = entry.key;
      final value = entry.value;
      if (RegExp(
              r'^(authorization|cookie|set-cookie|password|accessToken|refreshToken|platformToken|deviceSessionToken|verificationCode|verifyCode|captcha|secret)$',
              caseSensitive: false)
          .hasMatch(key)) {
        result[key] = '[redacted]';
      } else if (_identifiers.contains(key)) {
        result[key] = identifier(value) ?? '[omitted]';
      } else if (_numbers.contains(key) && value is num && value.isFinite) {
        result[key] = value;
      } else if (_fingerprints.contains(key) &&
          value is String &&
          RegExp(r'^[a-f0-9]{8,64}$').hasMatch(value)) {
        result[key] = value;
      } else if (_privateIds.contains(key)) {
        result[key] = sha256.convert(utf8.encode(value.toString())).toString();
      } else if ((key == 'endpoint' || key == 'uri') && value is String) {
        result['endpoint'] = endpoint(value);
      } else if (key == 'stack' && value is String) {
        // Preserve only code locations, never arbitrary exception text/paths.
        result[key] = RegExp(
                r'(?:package:im_sdk/[a-zA-Z0-9_/.-]+\.dart|dart:[a-zA-Z0-9_/.-]+):[0-9]+(?::[0-9]+)?')
            .allMatches(value)
            .take(20)
            .map((match) => match.group(0))
            .join('\n');
      } else if ((key == 'context' || key == 'payload') && value is Map) {
        result[key] = context(
            Map<String, Object?>.fromEntries(value.entries
                .where((e) => e.key is String)
                .map((e) => MapEntry(e.key as String, e.value))),
            depth + 1);
      } else {
        // Unknown keys can themselves contain user input.
        omitted++;
      }
    }
    if (omitted > 0) result['omittedFields'] = omitted;
    return Map.unmodifiable(result);
  }

  String endpoint(String raw) {
    final path = Uri.tryParse(raw)?.path ?? '';
    // Preserve only known static route vocabulary; IDs and user input disappear.
    const vocabulary = {
      'api',
      'platform',
      'client',
      'admin',
      'v1',
      'v2',
      'auth',
      'login',
      'logout',
      'refresh',
      'renew',
      'session',
      'sessions',
      'my',
      'tenants',
      'tenant',
      'personal',
      'select-personal-space',
      'select-tenant',
      'users',
      'messages',
      'direct-chats',
      'groups',
      'media',
      'upload',
      'download',
      'sync',
      'conversations',
      'settings',
      'client-errors',
      'devices',
      'notifications',
      'push',
      'configfile',
      'config',
      'version',
      'members',
    };
    return path
        .split('/')
        .where((part) => part.isNotEmpty)
        .map((part) => vocabulary.contains(part) ? part : ':id')
        .take(12)
        .fold('', (value, part) => '$value/$part');
  }
}
