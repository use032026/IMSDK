import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';

const String _explicitServiceRealmId = String.fromEnvironment(
  'LPP_SERVICE_REALM_ID',
  defaultValue: '',
);

@immutable
class ServiceRealmConfig {
  final String realmId;
  final Set<String> trustedOrigins;

  const ServiceRealmConfig._({
    required this.realmId,
    required this.trustedOrigins,
  });

  factory ServiceRealmConfig.resolve({
    required String explicitRealmId,
    required String primaryOrigin,
    required Iterable<String> trustedEndpointOrigins,
  }) {
    final normalizedPrimary = _normalizeHttpOrigin(primaryOrigin);
    final explicit = explicitRealmId.trim().toLowerCase();
    final realmId = explicit.isNotEmpty
        ? explicit
        : 'origin-${sha256.convert(utf8.encode(normalizedPrimary)).toString().substring(0, 32)}';
    final trustedOrigins = <String>{normalizedPrimary};
    for (final endpoint in trustedEndpointOrigins) {
      trustedOrigins.add(_normalizeHttpOrigin(endpoint));
    }
    return ServiceRealmConfig._(
      realmId: realmId,
      trustedOrigins: Set<String>.unmodifiable(trustedOrigins),
    );
  }

  static ServiceRealmConfig _current = ServiceRealmConfig.resolve(
    explicitRealmId: _explicitServiceRealmId,
    primaryOrigin: kPrimarySiteBaseUrl,
    trustedEndpointOrigins: const [kPrimarySiteBaseUrl],
  );

  static ServiceRealmConfig get current => _current;

  static void configureForSdk(
      {required String realmId,
      required String apiBaseUrl,
      String? gatewayBaseUrl}) {
    _current = ServiceRealmConfig.resolve(
        explicitRealmId: realmId,
        primaryOrigin: apiBaseUrl,
        trustedEndpointOrigins: [
          apiBaseUrl,
          if (gatewayBaseUrl != null)
            gatewayBaseUrl.replaceFirst(RegExp(r'^wss:'), 'https:'),
        ]);
  }

  bool trusts(String endpoint) {
    try {
      return trustedOrigins.contains(_normalizeHttpOrigin(endpoint));
    } on ArgumentError {
      return false;
    }
  }
}

String _normalizeHttpOrigin(String raw) {
  final uri = Uri.tryParse(raw.trim());
  if (uri == null ||
      !uri.hasScheme ||
      !uri.hasAuthority ||
      uri.host.isEmpty ||
      (uri.scheme.toLowerCase() != 'http' &&
          uri.scheme.toLowerCase() != 'https')) {
    throw ArgumentError.value(raw, 'origin', '必须是有效的 HTTP(S) Origin');
  }
  final scheme = uri.scheme.toLowerCase();
  final host = uri.host.toLowerCase();
  final isDefaultPort = (scheme == 'https' && uri.port == 443) ||
      (scheme == 'http' && uri.port == 80);
  final port = uri.hasPort && !isDefaultPort ? ':${uri.port}' : '';
  return '$scheme://$host$port';
}
