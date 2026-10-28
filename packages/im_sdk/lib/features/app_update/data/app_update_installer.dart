import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/http_client.dart';
import 'package:im_sdk/features/app_update/data/app_update_environment.dart';
import 'package:im_sdk/features/app_update/data/app_update_install_permission.dart';
import 'package:im_sdk/features/app_update/domain/app_release_update.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum AppUpdateInstallFailure {
  invalidUrl,
  openUrlFailed,
  downloadInterrupted,
  packageSizeMismatch,
  packageHashMismatch,
  installPermissionDenied,
  openInstallerFailed,
}

class AppUpdateInstallException implements Exception {
  const AppUpdateInstallException(this.failure, {this.cause});

  final AppUpdateInstallFailure failure;
  final Object? cause;

  @override
  String toString() {
    final detail = cause == null ? '' : ': $cause';
    return 'AppUpdateInstallException(${failure.name})$detail';
  }
}

class AppUpdateInstaller {
  AppUpdateInstaller({
    Dio? dio,
    String Function()? baseUrl,
    Future<Directory> Function()? temporaryDirectory,
    Future<void> Function(Duration)? retryDelay,
    AppUpdateInstallPermission installPermission =
        const AndroidAppUpdateInstallPermission(),
    bool? isAndroid,
  })  : _dio = dio ?? Dio(),
        _baseUrl = baseUrl ?? (() => HttpClient.baseUrl),
        _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory,
        _retryDelay = retryDelay ?? Future<void>.delayed,
        _installPermission = installPermission,
        _isAndroid = isAndroid ?? Platform.isAndroid;

  final Dio _dio;
  final String Function() _baseUrl;
  final Future<Directory> Function() _temporaryDirectory;
  final Future<void> Function(Duration) _retryDelay;
  final AppUpdateInstallPermission _installPermission;
  final bool _isAndroid;

  static const int _maxDownloadAttempts = 3;

  Future<void> start(AppReleaseUpdate update) async {
    final rawUrl = update.downloadUrl;
    if (rawUrl == null || rawUrl.trim().isEmpty) {
      throw const AppUpdateInstallException(
        AppUpdateInstallFailure.invalidUrl,
      );
    }
    final uri = resolveAppUpdateUrl(baseUrl: _baseUrl(), downloadUrl: rawUrl);
    if (!_isAndroid) {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        throw const AppUpdateInstallException(
          AppUpdateInstallFailure.openUrlFailed,
        );
      }
      return;
    }
    if (!await _installPermission.ensureGranted()) {
      throw const AppUpdateInstallException(
        AppUpdateInstallFailure.installPermissionDenied,
      );
    }
    final file = await downloadAndroidPackage(uri, update);
    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done) {
      throw AppUpdateInstallException(
        AppUpdateInstallFailure.openInstallerFailed,
        cause: result.message,
      );
    }
  }

  Future<File> downloadAndroidPackage(
    Uri uri,
    AppReleaseUpdate update,
  ) async {
    final tempDir = await _temporaryDirectory();
    final versionCode = update.latestVersionCode ?? update.clientVersionCode;
    final file = File('${tempDir.path}/weijie-$versionCode.apk');
    final partialFile = File('${file.path}.part');
    if (await _isValidPackage(file, update)) return file;
    if (await file.exists()) await file.delete();

    final expectedSize = update.fileSizeBytes;
    if (await partialFile.exists() &&
        expectedSize != null &&
        await partialFile.length() > expectedSize) {
      await partialFile.delete();
    }
    if (await partialFile.exists() &&
        expectedSize != null &&
        await partialFile.length() == expectedSize) {
      if (await _isValidPackage(partialFile, update)) {
        return _replaceWithPartial(file, partialFile);
      }
      await partialFile.delete();
    }

    await _downloadWithResume(uri, partialFile, expectedSize);
    if (expectedSize != null && await partialFile.length() != expectedSize) {
      throw const AppUpdateInstallException(
        AppUpdateInstallFailure.packageSizeMismatch,
      );
    }

    final expectedHash = update.fileHashSha256?.trim().toLowerCase();
    if (expectedHash != null && expectedHash.isNotEmpty) {
      final actualHash =
          (await sha256.bind(partialFile.openRead()).first).toString();
      if (actualHash != expectedHash) {
        await partialFile.delete().catchError((_) => partialFile);
        throw const AppUpdateInstallException(
          AppUpdateInstallFailure.packageHashMismatch,
        );
      }
    }

    return _replaceWithPartial(file, partialFile);
  }

  Future<void> _downloadWithResume(
    Uri uri,
    File partialFile,
    int? expectedSize,
  ) async {
    Object? lastError;
    for (var attempt = 0; attempt < _maxDownloadAttempts; attempt++) {
      try {
        await _downloadAttempt(uri, partialFile);
        if (expectedSize == null ||
            await partialFile.length() >= expectedSize) {
          return;
        }
      } catch (error) {
        lastError = error;
        if (!_isRetryable(error)) rethrow;
      }

      if (expectedSize != null &&
          await partialFile.exists() &&
          await partialFile.length() > expectedSize) {
        await partialFile.delete();
      }
      if (attempt + 1 < _maxDownloadAttempts) {
        await _retryDelay(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }

    throw AppUpdateInstallException(
      AppUpdateInstallFailure.downloadInterrupted,
      cause: lastError,
    );
  }

  Future<void> _downloadAttempt(Uri uri, File partialFile) async {
    final existingLength =
        await partialFile.exists() ? await partialFile.length() : 0;
    final response = await _dio.getUri<ResponseBody>(
      uri,
      options: Options(
        responseType: ResponseType.stream,
        headers: existingLength > 0
            ? {HttpHeaders.rangeHeader: 'bytes=$existingLength-'}
            : null,
      ),
    );
    final body = response.data;
    if (body == null) {
      throw const AppUpdateInstallException(
        AppUpdateInstallFailure.downloadInterrupted,
      );
    }

    final isPartialResponse = response.statusCode == HttpStatus.partialContent;
    final hasExpectedRange = _contentRangeStartsAt(
      response.headers.value(HttpHeaders.contentRangeHeader),
      existingLength,
    );
    if (isPartialResponse && !hasExpectedRange) {
      await body.stream.listen(null).cancel();
      if (await partialFile.exists()) await partialFile.delete();
      throw const AppUpdateInstallException(
        AppUpdateInstallFailure.downloadInterrupted,
        cause: 'invalid content-range',
      );
    }
    final isResume = existingLength > 0 && isPartialResponse;
    final mode = isResume ? FileMode.append : FileMode.writeOnly;
    final sink = partialFile.openWrite(mode: mode);
    try {
      await for (final chunk in body.stream) {
        sink.add(chunk);
      }
      await sink.flush();
    } finally {
      await sink.close();
    }
  }

  bool _contentRangeStartsAt(String? contentRange, int expectedStart) {
    if (contentRange == null) return false;
    final match = RegExp(r'^bytes (\d+)-\d+/').firstMatch(contentRange.trim());
    return match != null && int.tryParse(match.group(1)!) == expectedStart;
  }

  bool _isRetryable(Object error) {
    if (error is! DioException) return true;
    final statusCode = error.response?.statusCode;
    if (statusCode == null) return true;
    return statusCode == HttpStatus.requestTimeout ||
        statusCode == HttpStatus.tooManyRequests ||
        statusCode >= HttpStatus.internalServerError;
  }

  Future<bool> _isValidPackage(
    File file,
    AppReleaseUpdate update,
  ) async {
    if (!await file.exists()) return false;
    final expectedSize = update.fileSizeBytes;
    if (expectedSize != null && await file.length() != expectedSize) {
      return false;
    }
    final expectedHash = update.fileHashSha256?.trim().toLowerCase();
    if (expectedHash == null || expectedHash.isEmpty) return true;
    final actualHash = (await sha256.bind(file.openRead()).first).toString();
    return actualHash == expectedHash;
  }

  Future<File> _replaceWithPartial(File file, File partialFile) async {
    if (await file.exists()) await file.delete();
    return partialFile.rename(file.path);
  }
}
