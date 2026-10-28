import 'package:path/path.dart' as p;

enum ChatPickedMediaKind { image, video }

Future<void> sendChatPickedMediaBatch<T>(
  Iterable<T> items,
  Future<void> Function(T item) sendOne, {
  int maxConcurrent = 2,
}) async {
  final pending = items.toList(growable: false);
  if (pending.isEmpty) return;
  if (maxConcurrent <= 0) {
    throw ArgumentError.value(maxConcurrent, 'maxConcurrent', 'must be > 0');
  }

  var nextIndex = 0;
  Object? firstError;
  StackTrace? firstStackTrace;

  Future<void> worker() async {
    while (nextIndex < pending.length) {
      final index = nextIndex++;
      try {
        await sendOne(pending[index]);
      } catch (error, stackTrace) {
        firstError ??= error;
        firstStackTrace ??= stackTrace;
      }
    }
  }

  final workerCount =
      pending.length < maxConcurrent ? pending.length : maxConcurrent;
  await Future.wait(List.generate(workerCount, (_) => worker()));
  if (firstError != null) {
    Error.throwWithStackTrace(firstError!, firstStackTrace!);
  }
}

class ChatPickedMedia {
  final String path;
  final ChatPickedMediaKind kind;
  final String fileName;
  final String mimeType;
  final int? sizeBytes;

  const ChatPickedMedia({
    required this.path,
    required this.kind,
    required this.fileName,
    required this.mimeType,
    this.sizeBytes,
  });

  bool get isImage => kind == ChatPickedMediaKind.image;
  bool get isVideo => kind == ChatPickedMediaKind.video;

  factory ChatPickedMedia.image({
    required String path,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
  }) {
    return ChatPickedMedia(
      path: path,
      kind: ChatPickedMediaKind.image,
      fileName: _fallbackFileName(path, fileName),
      mimeType: mimeType ?? _imageMimeTypeFromPath(path),
      sizeBytes: sizeBytes,
    );
  }

  factory ChatPickedMedia.video({
    required String path,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
  }) {
    return ChatPickedMedia(
      path: path,
      kind: ChatPickedMediaKind.video,
      fileName: _fallbackFileName(path, fileName),
      mimeType: mimeType ?? _videoMimeTypeFromPath(path),
      sizeBytes: sizeBytes,
    );
  }

  factory ChatPickedMedia.fromPickedFile({
    required String path,
    String? name,
    String? mimeType,
    int? sizeBytes,
  }) {
    return tryFromPickedFile(
          path: path,
          name: name,
          mimeType: mimeType,
          sizeBytes: sizeBytes,
        ) ??
        ChatPickedMedia.image(
          path: path,
          fileName: name,
          sizeBytes: sizeBytes,
        );
  }

  static ChatPickedMedia? tryFromPickedFile({
    required String path,
    String? name,
    String? mimeType,
    int? sizeBytes,
  }) {
    final normalizedMime = mimeType?.trim().toLowerCase();
    if (normalizedMime != null && normalizedMime.startsWith('video/')) {
      return ChatPickedMedia.video(
        path: path,
        fileName: name,
        mimeType: normalizedMime,
        sizeBytes: sizeBytes,
      );
    }
    if (normalizedMime != null && normalizedMime.startsWith('image/')) {
      return ChatPickedMedia.image(
        path: path,
        fileName: name,
        mimeType: normalizedMime,
        sizeBytes: sizeBytes,
      );
    }

    if (_isImagePath(path)) {
      return ChatPickedMedia.image(
        path: path,
        fileName: name,
        sizeBytes: sizeBytes,
      );
    }
    if (_isVideoPath(path)) {
      return ChatPickedMedia.video(
        path: path,
        fileName: name,
        sizeBytes: sizeBytes,
      );
    }
    return null;
  }
}

String _fallbackFileName(String path, String? fileName) {
  final trimmed = fileName?.trim();
  if (trimmed != null && trimmed.isNotEmpty) return trimmed;
  final basename = p.basename(path);
  return basename.isEmpty ? 'media' : basename;
}

bool _isVideoPath(String path) {
  switch (p.extension(path).toLowerCase()) {
    case '.mp4':
    case '.mov':
    case '.m4v':
    case '.webm':
    case '.avi':
    case '.mkv':
      return true;
    default:
      return false;
  }
}

bool _isImagePath(String path) {
  switch (p.extension(path).toLowerCase()) {
    case '.jpg':
    case '.jpeg':
    case '.png':
    case '.webp':
    case '.gif':
    case '.heic':
    case '.heif':
      return true;
    default:
      return false;
  }
}

String _imageMimeTypeFromPath(String path) {
  switch (p.extension(path).toLowerCase()) {
    case '.png':
      return 'image/png';
    case '.webp':
      return 'image/webp';
    case '.gif':
      return 'image/gif';
    case '.heic':
      return 'image/heic';
    case '.heif':
      return 'image/heif';
    case '.jpg':
    case '.jpeg':
    default:
      return 'image/jpeg';
  }
}

String _videoMimeTypeFromPath(String path) {
  switch (p.extension(path).toLowerCase()) {
    case '.mov':
      return 'video/quicktime';
    case '.m4v':
      return 'video/x-m4v';
    case '.webm':
      return 'video/webm';
    case '.avi':
      return 'video/x-msvideo';
    case '.mkv':
      return 'video/x-matroska';
    case '.mp4':
    default:
      return 'video/mp4';
  }
}
