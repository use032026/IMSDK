import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:im_sdk/core/diagnostics/media_diagnostics.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<bool> localFileExists(String path) async => File(path).exists();

Future<int> localFileLength(String path) async => File(path).length();

Future<List<int>> readLocalFileBytes(String path) async =>
    File(path).readAsBytes();

Future<String> cacheBytesToLocalFile({
  required List<int> bytes,
  required String directoryName,
  required String fileName,
}) async {
  final root = await getTemporaryDirectory();
  final directory = Directory(p.join(root.path, directoryName));
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  final file = File(p.join(directory.path, fileName));
  if (await file.exists() && await file.length() > 0) return file.path;
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

String localPathFromUriOrPath(String path) {
  final uri = Uri.tryParse(path);
  return uri != null && uri.scheme == 'file' ? uri.toFilePath() : path;
}

Widget localImageWidget(
  String path, {
  BoxFit? fit,
  double? width,
  double? height,
  ValueChanged<Size>? onImageSize,
  ValueChanged<ImageProvider>? onImageProviderResolved,
  MediaDiagnosticOperation? diagnostic,
}) {
  return _ObservedLocalFileImage(
    path: path,
    diagnostic: diagnostic,
    fit: fit,
    width: width,
    height: height,
    onImageSize: onImageSize,
    onImageProviderResolved: onImageProviderResolved,
  );
}

class _ObservedLocalFileImage extends StatefulWidget {
  final String path;
  final MediaDiagnosticOperation? diagnostic;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final ValueChanged<Size>? onImageSize;
  final ValueChanged<ImageProvider>? onImageProviderResolved;

  const _ObservedLocalFileImage({
    required this.path,
    this.diagnostic,
    this.fit,
    this.width,
    this.height,
    this.onImageSize,
    this.onImageProviderResolved,
  });

  @override
  State<_ObservedLocalFileImage> createState() =>
      _ObservedLocalFileImageState();
}

class _ObservedLocalFileImageState extends State<_ObservedLocalFileImage> {
  ImageStream? _stream;
  ImageStreamListener? _listener;
  Size? _reportedSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(_ObservedLocalFileImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _reportedSize = null;
      _resolveImage();
    }
  }

  void _resolveImage() {
    _removeListener();
    final diagnostic = widget.diagnostic;
    final provider = FileImage(File(widget.path));
    widget.onImageProviderResolved?.call(provider);
    final stream = provider.resolve(createLocalImageConfiguration(context));
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        stream.removeListener(listener);
        final size = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        if (size == _reportedSize) return;
        _reportedSize = size;
        widget.onImageSize?.call(size);
      },
      onError: (error, stack) {
        diagnostic?.failed(MediaFailureStage.decode, error, stack);
        stream.removeListener(listener);
      },
    );
    _stream = stream;
    _listener = listener;
    stream.addListener(listener);
  }

  void _removeListener() {
    final stream = _stream;
    final listener = _listener;
    if (stream != null && listener != null) stream.removeListener(listener);
    _stream = null;
    _listener = null;
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Image.file(
        File(widget.path),
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        gaplessPlayback: true,
      );
}
