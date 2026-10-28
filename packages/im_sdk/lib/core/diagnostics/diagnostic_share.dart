import 'dart:io';
import 'dart:ui';

import 'package:share_plus/share_plus.dart';

enum DiagnosticShareOutcome { completed, cancelled, unconfirmed }

abstract interface class DiagnosticFileShare {
  Future<DiagnosticShareOutcome> share(File file, Rect origin);
}

/// Keeps platform plugin DTOs out of the settings application layer.
class SystemDiagnosticFileShare implements DiagnosticFileShare {
  const SystemDiagnosticFileShare();

  @override
  Future<DiagnosticShareOutcome> share(File file, Rect origin) async {
    final result = await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path, mimeType: 'application/json')],
      sharePositionOrigin: origin,
    ));
    return switch (result.status) {
      ShareResultStatus.success => DiagnosticShareOutcome.completed,
      ShareResultStatus.dismissed => DiagnosticShareOutcome.cancelled,
      ShareResultStatus.unavailable => DiagnosticShareOutcome.unconfirmed,
    };
  }
}
