bool isLocalMediaReference(String? raw) {
  final value = raw?.trim();
  if (value == null || value.isEmpty) return false;
  if (value.startsWith('/media') ||
      value.startsWith('/api') ||
      value.startsWith('/uploads') ||
      value.startsWith('/files')) {
    return false;
  }
  final uri = Uri.tryParse(value);
  if (uri == null) return true;
  if (uri.scheme == 'file') return true;
  if (uri.scheme.isNotEmpty) return false;
  return true;
}

String? localMediaPath(String? raw) {
  if (!isLocalMediaReference(raw)) return null;
  final value = raw!.trim();
  final uri = Uri.tryParse(value);
  return uri?.scheme == 'file' ? uri!.toFilePath() : value;
}

bool isRemoteMediaReference(String? raw) {
  final value = raw?.trim();
  return value != null && value.isNotEmpty && !isLocalMediaReference(value);
}
