import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

class SiteLineConfigException implements Exception {
  final String code;
  const SiteLineConfigException(this.code);
  @override
  String toString() => 'SiteLineConfigException($code)';
}

class VerifiedSiteLine {
  final String id;
  final String type;
  final double weight;
  final String displayName;
  final String displayNameEn;
  final String chat;
  final String ws;
  final String admin;
  final String configfile;

  const VerifiedSiteLine({
    required this.id,
    required this.type,
    required this.weight,
    required this.displayName,
    required this.displayNameEn,
    required this.chat,
    required this.ws,
    required this.admin,
    required this.configfile,
  });
}

class VerifiedSiteLineConfig {
  final String encryptedBody;
  final int? version;
  final List<VerifiedSiteLine> lines;

  const VerifiedSiteLineConfig({
    required this.encryptedBody,
    required this.version,
    required this.lines,
  });
}

/// Converts the official encrypted and signed wire format into trusted lines.
/// No UI or account state is interpreted in this infrastructure adapter.
class SiteLineConfigCodec {
  final String aesKey;
  final String publicKeyPem;
  final String requiredAlgorithm;

  const SiteLineConfigCodec({
    required this.aesKey,
    required this.publicKeyPem,
    required this.requiredAlgorithm,
  });

  VerifiedSiteLineConfig decode(String encryptedBody) {
    final plaintext = _decrypt(encryptedBody);
    const marker = '"ext":"';
    final markerIndex = plaintext.lastIndexOf(marker);
    if (markerIndex < 0) {
      throw const SiteLineConfigException('signature_format');
    }

    Map<String, dynamic> envelope;
    Map<String, dynamic> metadata;
    try {
      envelope = _object(jsonDecode(plaintext));
      metadata = _object(jsonDecode(envelope['ext']));
    } catch (_) {
      throw const SiteLineConfigException('signature_format');
    }
    if (metadata['alg'] != requiredAlgorithm) {
      throw const SiteLineConfigException('signature_algorithm');
    }
    final signatureValue = metadata['sig'];
    if (signatureValue is! String || signatureValue.isEmpty) {
      throw const SiteLineConfigException('signature_missing');
    }
    final signatureBytes = _strictBase64(signatureValue, 'signature_format');
    final baseline = '${plaintext.substring(0, markerIndex + marker.length)}"}';
    if (!_verify(utf8.encode(baseline), signatureBytes)) {
      throw const SiteLineConfigException('signature_invalid');
    }
    if (envelope['ret'] != 200 || envelope['data'] is! List) {
      throw const SiteLineConfigException('invalid_manifest');
    }
    final version = metadata['version'];
    if (version != null && (version is! int || version <= 0)) {
      throw const SiteLineConfigException('invalid_manifest');
    }
    final seen = <String>{};
    final lines = <VerifiedSiteLine>[];
    for (final item in envelope['data'] as List) {
      if (item is! Map) continue;
      final entry = _project(Map<String, dynamic>.from(item));
      if (entry != null && seen.add(entry.id)) lines.add(entry);
    }
    if (lines.isEmpty) throw const SiteLineConfigException('invalid_manifest');
    return VerifiedSiteLineConfig(
      encryptedBody: encryptedBody,
      version: version as int?,
      lines: List.unmodifiable(lines),
    );
  }

  String _decrypt(String body) {
    final normalized = body.replaceAll(RegExp(r'\s'), '');
    final encrypted = _strictBase64(normalized, 'invalid_base64');
    final rawKey = Uint8List.fromList(utf8.encode(aesKey));
    final key = const [16, 24, 32].contains(rawKey.length)
        ? rawKey
        : Uint8List.fromList(
            crypto.sha256.convert(rawKey).bytes.sublist(0, 16));
    try {
      final cipher = PaddedBlockCipher('AES/ECB/PKCS7')
        ..init(false, PaddedBlockCipherParameters(KeyParameter(key), null));
      return utf8.decode(cipher.process(encrypted));
    } catch (_) {
      throw const SiteLineConfigException('decrypt_failed');
    }
  }

  bool _verify(List<int> message, Uint8List signatureBytes) {
    try {
      final keyDer = base64Decode(publicKeyPem
          .replaceAll(RegExp(r'-----[^-]+-----'), '')
          .replaceAll(RegExp(r'\s'), ''));
      final keyParser = ASN1Parser(keyDer);
      final spki = ASN1SubjectPublicKeyInfo.fromSequence(
        keyParser.nextObject() as ASN1Sequence,
      );
      if (keyParser.hasNext() ||
          spki.algorithm.algorithm.objectIdentifierAsString !=
              '1.2.840.10045.2.1' ||
          (spki.algorithm.parameters as ASN1ObjectIdentifier?)
                  ?.objectIdentifierAsString !=
              '1.2.840.10045.3.1.7' ||
          spki.subjectPublicKey.unusedbits != 0) {
        throw const FormatException('unsupported_public_key');
      }
      final curve = ECDomainParameters('prime256v1');
      final point =
          curve.curve.decodePoint(spki.subjectPublicKey.stringValues!);
      if (point == null) throw const FormatException('invalid_public_key');

      final signatureParser = ASN1Parser(signatureBytes);
      final signature = signatureParser.nextObject() as ASN1Sequence;
      final parts = signature.elements;
      if (signatureParser.hasNext() ||
          parts == null ||
          parts.length != 2 ||
          parts[0] is! ASN1Integer ||
          parts[1] is! ASN1Integer ||
          !_sameBytes(signature.encode(), signatureBytes)) {
        throw const FormatException('invalid_signature_der');
      }
      final r = (parts[0] as ASN1Integer).integer!;
      final s = (parts[1] as ASN1Integer).integer!;
      if (r <= BigInt.zero || s <= BigInt.zero) return false;
      final signer = Signer('SHA-256/ECDSA')
        ..init(false, PublicKeyParameter(ECPublicKey(point, curve)));
      return signer.verifySignature(
          Uint8List.fromList(message), ECSignature(r, s));
    } on SiteLineConfigException {
      rethrow;
    } catch (_) {
      throw const SiteLineConfigException('signature_format');
    }
  }

  static VerifiedSiteLine? _project(Map<String, dynamic> item) {
    final id = _nonempty(item['id']);
    final list = item['list'];
    if (id == null || list is! Map) {
      return null;
    }
    final addresses = Map<String, dynamic>.from(list);
    final chat = _endpoint(addresses['chat'], 'https');
    final ws = _endpoint(addresses['ws'], 'wss');
    final admin = _endpoint(addresses['admin'], 'https');
    final configfile = _endpoint(addresses['configfile'], 'https');
    if (chat == null || ws == null || admin == null || configfile == null) {
      return null;
    }
    final rawWeight = item['weigh'];
    final parsedWeight = rawWeight is num
        ? rawWeight.toDouble()
        : double.tryParse(rawWeight is String ? rawWeight : '');
    final weight =
        parsedWeight != null && parsedWeight.isFinite && parsedWeight > 0
            ? parsedWeight
            : 1.0;
    final name = _nonempty(item['info']) ?? id;
    return VerifiedSiteLine(
      id: id,
      type: _nonempty(item['type']) ?? '',
      weight: weight,
      displayName: name,
      displayNameEn: _nonempty(item['info_en']) ?? name,
      chat: chat,
      ws: ws,
      admin: admin,
      configfile: configfile,
    );
  }

  static String? _endpoint(Object? value, String scheme) {
    if (value is! String) {
      return null;
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        uri.scheme != scheme ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      return null;
    }
    return uri.toString().replaceFirst(RegExp(r'/$'), '');
  }

  static String? _nonempty(Object? value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;

  static Map<String, dynamic> _object(Object? value) {
    if (value is! Map) throw const FormatException('not_an_object');
    return Map<String, dynamic>.from(value);
  }

  static Uint8List _strictBase64(String value, String code) {
    if (value.isEmpty ||
        value.length % 4 != 0 ||
        !RegExp(r'^[A-Za-z0-9+/]+={0,2}$').hasMatch(value)) {
      throw SiteLineConfigException(code);
    }
    try {
      final bytes = base64Decode(value);
      if (bytes.isEmpty || base64Encode(bytes) != value) {
        throw const FormatException('noncanonical_base64');
      }
      return bytes;
    } catch (_) {
      throw SiteLineConfigException(code);
    }
  }

  static bool _sameBytes(List<int> left, List<int> right) {
    if (left.length != right.length) return false;
    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) return false;
    }
    return true;
  }
}
