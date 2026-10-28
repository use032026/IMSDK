import 'package:punycode/punycode.dart';

enum MessageLinkSenderKind { customer, staff, unknown }

class MessageLinkWhitelist {
  final int version;
  final List<String> domains;

  const MessageLinkWhitelist({
    required this.version,
    required this.domains,
  });

  factory MessageLinkWhitelist.fromJson(Map<String, dynamic> json) {
    final rawDomains = json['domains'];
    return MessageLinkWhitelist(
      version: _intValue(json['version']),
      domains: rawDomains is List
          ? rawDomains
              .whereType<String>()
              .map(_normalizeDomain)
              .where((domain) => domain.isNotEmpty && !_isIpHost(domain))
              .toSet()
              .toList(growable: false)
          : const [],
    );
  }

  bool allows(String url) {
    final host = _safeHttpHost(url);
    if (host == null) return false;
    return domains.any(
      (domain) => host == domain || host.endsWith('.$domain'),
    );
  }

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class MessageLinkAccessPolicy {
  const MessageLinkAccessPolicy._();

  static bool requiresWhitelist(MessageLinkSenderKind senderKind) =>
      senderKind == MessageLinkSenderKind.customer;

  static bool canOpen({
    required String url,
    required MessageLinkSenderKind senderKind,
    required MessageLinkWhitelist? whitelist,
  }) {
    switch (senderKind) {
      case MessageLinkSenderKind.staff:
        return _safeHttpHost(url, allowIp: true) != null;
      case MessageLinkSenderKind.customer:
        return whitelist?.allows(url) ?? false;
      case MessageLinkSenderKind.unknown:
        return false;
    }
  }
}

String _normalizeDomain(String value) {
  try {
    final domain = Uri.decodeComponent(
      value.trim().toLowerCase().replaceFirst(RegExp(r'^\.+'), ''),
    ).replaceAll(RegExp(r'[\u3002\uFF0E\uFF61]'), '.');
    if (domain.isEmpty) return '';
    return domain.split('.').map((label) {
      if (label.isEmpty) throw const FormatException('empty domain label');
      return label.runes.any((rune) => rune > 0x7f)
          ? 'xn--${punycodeEncode(label)}'
          : label;
    }).join('.');
  } on FormatException {
    return '';
  }
}

String? _safeHttpHost(String value, {bool allowIp = false}) {
  final uri = Uri.tryParse(value.trim());
  if (uri == null ||
      (uri.scheme != 'http' && uri.scheme != 'https') ||
      uri.userInfo.isNotEmpty) {
    return null;
  }
  final host = _normalizeDomain(uri.host);
  return host.isEmpty || (!allowIp && _isIpHost(host)) ? null : host;
}

bool _isIpHost(String host) {
  if (host.contains(':')) return true;
  final parts = host.split('.');
  if (parts.length != 4) return false;
  return parts.every((part) {
    final value = int.tryParse(part);
    return value != null && value >= 0 && value <= 255;
  });
}
