import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/diagnostics/media_diagnostics.dart';
import 'package:im_sdk/core/media/image_resource.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';

/// Downloads through the existing credential owner, never stores tokens.
class ImageDownloadTransport {
  ImageDownloadTransport({
    required this.publicDio,
    required this.apiBaseUrl,
    required this.isCurrent,
    required this.namespace,
    this.diagnosticScope = DiagnosticScope.unattributed,
    this.accountDio,
    this.adminDio,
    this.adminBaseUrl,
  });

  final Dio publicDio;
  final Dio? accountDio;
  final Dio Function()? adminDio;
  final String Function()? adminBaseUrl;
  final String Function() apiBaseUrl;
  final bool Function() isCurrent;
  final String namespace;
  final DiagnosticScope diagnosticScope;

  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers}) async {
    final diagnostic = MediaDiagnosticOperation(
      scope: diagnosticScope,
      kind: DiagnosticMediaKind.image,
      resource: url,
    );
    var resource =
        ImageResource(url, apiBaseUrl(), adminBaseUrl: adminBaseUrl?.call());
    // Only conditional cache headers cross this boundary. Credentials always
    // come from HttpClient, and never follow a redirect to another origin.
    final conditionalHeaders = <String, String>{
      for (final entry in (headers ?? <String, String>{}).entries)
        if (entry.key.toLowerCase() == 'if-none-match' ||
            entry.key.toLowerCase() == 'if-modified-since')
          entry.key: entry.value,
    };
    try {
      for (var redirects = 0; redirects <= 3; redirects++) {
        _verifyCurrent();
        final access = resource.access;
        final dio = switch (access) {
          ImageRequestAccess.public => publicDio,
          ImageRequestAccess.admin => adminDio?.call(),
          _ => accountDio,
        };
        if (dio == null) throw StateError('Image requires an active account');
        final response = await dio.get<List<int>>(
          access == ImageRequestAccess.public
              ? resource.url
              : resource.requestPath,
          options: Options(
            responseType: ResponseType.bytes,
            extra: const {'skipDiagnosticsLog': true},
            headers: conditionalHeaders,
            followRedirects: false,
            validateStatus: (status) =>
                status == 200 ||
                status == 202 ||
                (status != null && status >= 300 && status < 400),
          ),
        );
        _verifyCurrent();
        final status = response.statusCode!;
        final location = response.headers.value('location');
        if (status != 304 &&
            status >= 300 &&
            status < 400 &&
            location != null) {
          resource = ImageResource(
              resource.uri.resolve(location).toString(), apiBaseUrl(),
              adminBaseUrl: adminBaseUrl?.call());
          continue;
        }
        final bytes = response.data ?? const <int>[];
        return HttpGetResponse(http.StreamedResponse(
          Stream.value(bytes),
          status,
          contentLength: bytes.length,
          headers: response.headers.map.map(
              (key, values) => MapEntry(key.toLowerCase(), values.join(','))),
        ));
      }
      throw StateError('Too many image redirects');
    } catch (error, stack) {
      diagnostic.failed(MediaFailureStage.download, error, stack);
      rethrow;
    }
  }

  void _verifyCurrent() {
    if (!isCurrent()) throw AccountOperationSuperseded();
  }
}

/// The disk owner outlives a space activation; its network lease does not.
class ImageFileService extends FileService {
  ImageDownloadTransport? _transport;
  int _generation = 0;

  void Function() attach(ImageDownloadTransport transport) {
    final generation = ++_generation;
    _transport = transport;
    return () {
      if (generation == _generation) {
        _generation++;
        _transport = null;
      }
    };
  }

  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers}) async {
    final transport = _transport;
    final generation = _generation;
    if (transport == null) throw AccountOperationSuperseded();
    final response = await transport.get(url, headers: headers);
    if (generation != _generation) throw AccountOperationSuperseded();
    return response;
  }
}
