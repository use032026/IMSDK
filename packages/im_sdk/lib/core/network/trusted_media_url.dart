Uri? trustedServerMediaUrl(String? raw, String apiBaseUrl) {
  if (raw == null || raw.trim().isEmpty) return null;
  final base = Uri.tryParse(apiBaseUrl);
  final candidate = Uri.tryParse(raw.trim());
  if (base == null || candidate == null || base.host.isEmpty) return null;
  final resolved = base.resolveUri(candidate);
  if ((resolved.scheme != 'http' && resolved.scheme != 'https') ||
      resolved.userInfo.isNotEmpty ||
      resolved.scheme != base.scheme ||
      resolved.host != base.host ||
      resolved.port != base.port) {
    return null;
  }
  return resolved;
}
