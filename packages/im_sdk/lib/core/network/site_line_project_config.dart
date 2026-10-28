/// Matches the production site-line contract used by the PC client.
///
/// The AES material is shipped with the client and must not be treated as a
/// secret. The ECDSA signature is the authenticity boundary.
abstract final class SiteLineProjectConfig {
  static const aesKey = 'B2UQ4DWD2BPLL3Q9';
  static const signatureAlgorithm = 'ECDSA-P256-SHA256-DER';
  static const publicKeyPem = '''-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEMBHij2asOeYUWEHTkZmcVLqaLG0P
TiFKgZ5Hb49B6eDvg64pGFiHxx8mwHdCbS6MXowQdCfgwYnvo1BgsX1pww==
-----END PUBLIC KEY-----''';

  static const seedUrls = <String>[
    'https://64.118.144.107/react-vue.s3/css/weijie.css',
    'https://64.118.158.149/react-vue.s3/css/weijie.css',
  ];
  static const globalUrls = <String>[
    'https://react-vue.s3.ap-northeast-1.amazonaws.com/css/weijie.css',
    'https://pub-c9fa688aa6874e0eb1414a0a7d830c08.r2.dev/css/weijie.css',
  ];
}
