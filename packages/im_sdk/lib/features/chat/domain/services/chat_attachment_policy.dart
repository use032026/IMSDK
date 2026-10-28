import 'package:path/path.dart' as p;

const chatFileAttachmentMaxSizeBytes = 100 * 1024 * 1024;

const chatFileAttachmentAllowedExtensions = <String>[
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'csv',
  'txt',
  'zip',
  'rar',
  '7z',
  'mp3',
];

const chatFileAttachmentAllowedMimeTypes = <String>[
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.ms-excel',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'application/vnd.ms-powerpoint',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'text/csv',
  'text/plain',
  'application/zip',
  'application/vnd.rar',
  'application/x-rar-compressed',
  'application/x-7z-compressed',
  'audio/mpeg',
];

const chatFileAttachmentBlockedMimeTypes = <String>[
  'application/json',
  'application/xml',
  'text/xml',
  'text/markdown',
  'text/x-markdown',
  'application/rtf',
  'text/rtf',
  'application/x-msdownload',
  'application/x-executable',
  'application/vnd.microsoft.portable-executable',
  'application/x-dosexec',
];

enum ChatFileAttachmentRejection {
  mediaUsePhotos,
  unsupportedType,
  unrecognizedType,
  typeMismatch,
  tooLarge,
}

class ChatFileAttachmentValidation {
  final String extension;
  final ChatFileAttachmentRejection? rejection;

  const ChatFileAttachmentValidation._({
    required this.extension,
    required this.rejection,
  });

  const ChatFileAttachmentValidation.accepted(String extension)
      : this._(extension: extension, rejection: null);

  const ChatFileAttachmentValidation.rejected(
    ChatFileAttachmentRejection rejection, {
    String extension = '',
  }) : this._(extension: extension, rejection: rejection);

  bool get isAccepted => rejection == null;
}

ChatFileAttachmentValidation validateChatFileAttachment({
  required String fileName,
  required String? mimeType,
  required int sizeBytes,
  int maxSizeBytes = chatFileAttachmentMaxSizeBytes,
}) {
  final normalizedName = fileName.trim();
  var extension = _normalizeExtension(p.extension(normalizedName));

  if (isChatMediaMimeType(mimeType) || _isChatMediaExtension(extension)) {
    return ChatFileAttachmentValidation.rejected(
      ChatFileAttachmentRejection.mediaUsePhotos,
      extension: extension,
    );
  }

  if (extension.isEmpty) {
    extension = _allowedExtensionForMimeType(mimeType) ?? '';
  }
  if (normalizedName.isEmpty || extension.isEmpty) {
    return const ChatFileAttachmentValidation.rejected(
      ChatFileAttachmentRejection.unrecognizedType,
    );
  }
  if (!isChatFileAttachmentExtension(extension)) {
    return ChatFileAttachmentValidation.rejected(
      ChatFileAttachmentRejection.unsupportedType,
      extension: extension,
    );
  }
  if (_isBlockedChatFileMimeType(mimeType)) {
    return ChatFileAttachmentValidation.rejected(
      ChatFileAttachmentRejection.typeMismatch,
      extension: extension,
    );
  }
  if (sizeBytes > maxSizeBytes) {
    return ChatFileAttachmentValidation.rejected(
      ChatFileAttachmentRejection.tooLarge,
      extension: extension,
    );
  }
  return ChatFileAttachmentValidation.accepted(extension);
}

bool isChatFileAttachmentExtension(String extension) {
  final normalized = _normalizeExtension(extension);
  if (normalized.isEmpty) return false;
  return chatFileAttachmentAllowedExtensions.contains(normalized);
}

bool isChatFileAttachmentUploadSupported(String fileNameOrExtension) {
  final extension = p.extension(fileNameOrExtension).isNotEmpty
      ? p.extension(fileNameOrExtension)
      : fileNameOrExtension;
  return isChatFileAttachmentExtension(extension);
}

bool isChatFileAttachmentCandidate({
  required String fileName,
  required String? mimeType,
}) {
  final extension = p.extension(fileName);
  if (!isChatFileAttachmentExtension(extension)) return false;
  return !isChatMediaMimeType(mimeType);
}

bool isChatMediaMimeType(String? mimeType) {
  final normalized = mimeType?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return false;
  return normalized.startsWith('image/') || normalized.startsWith('video/');
}

String chatFileAttachmentMimeType(String extension) {
  switch (_normalizeExtension(extension)) {
    case 'pdf':
      return 'application/pdf';
    case 'doc':
      return 'application/msword';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    case 'xls':
      return 'application/vnd.ms-excel';
    case 'xlsx':
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    case 'ppt':
      return 'application/vnd.ms-powerpoint';
    case 'pptx':
      return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    case 'csv':
      return 'text/csv';
    case 'txt':
    case 'log':
      return 'text/plain';
    case 'xml':
      return 'application/xml';
    case 'json':
      return 'application/json';
    case 'md':
      return 'text/markdown';
    case 'rtf':
      return 'application/rtf';
    case 'zip':
      return 'application/zip';
    case 'rar':
      return 'application/vnd.rar';
    case '7z':
      return 'application/x-7z-compressed';
    case 'mp3':
      return 'audio/mpeg';
    default:
      return 'application/octet-stream';
  }
}

String _normalizeExtension(String extension) {
  final value = extension.trim().toLowerCase();
  return value.startsWith('.') ? value.substring(1) : value;
}

String? _allowedExtensionForMimeType(String? mimeType) {
  switch (mimeType?.trim().toLowerCase()) {
    case 'application/pdf':
      return 'pdf';
    case 'application/msword':
      return 'doc';
    case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      return 'docx';
    case 'application/vnd.ms-excel':
      return 'xls';
    case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
      return 'xlsx';
    case 'application/vnd.ms-powerpoint':
      return 'ppt';
    case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
      return 'pptx';
    case 'text/csv':
      return 'csv';
    case 'text/plain':
      return 'txt';
    case 'application/zip':
      return 'zip';
    case 'application/vnd.rar':
    case 'application/x-rar-compressed':
      return 'rar';
    case 'application/x-7z-compressed':
      return '7z';
    case 'audio/mpeg':
      return 'mp3';
    default:
      return null;
  }
}

bool _isChatMediaExtension(String extension) {
  switch (extension) {
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'webp':
    case 'gif':
    case 'heic':
    case 'heif':
    case 'mp4':
    case 'mov':
    case 'm4v':
    case 'webm':
    case 'avi':
    case 'mkv':
      return true;
    default:
      return false;
  }
}

bool _isBlockedChatFileMimeType(String? mimeType) {
  final normalized = mimeType?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return false;
  return chatFileAttachmentBlockedMimeTypes.contains(normalized);
}
