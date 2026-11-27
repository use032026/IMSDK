import 'package:dio/dio.dart';
import 'package:im_sdk/core/media/media_access_retry.dart';
import 'package:im_sdk/core/media/media_request_context.dart';
import 'package:im_sdk/core/network/chat_media_url.dart';
import 'package:im_sdk/core/network/http_client.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';

class MediaDownloadService {
  final Dio _dio;
  final Dio _publicDio;
  final bool _ownsPublicDio;
  final String Function() _apiBaseUrl;
  final bool Function()? _isCurrent;
  final MediaAccessRetry _retry;

  MediaDownloadService(this._dio,
      {Dio? publicDio,
      String Function()? apiBaseUrl,
      MediaUrlRefresh? refresh,
      bool Function()? isCurrent})
      : _publicDio = publicDio ??
            Dio(BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 30))),
        _ownsPublicDio = publicDio == null,
        _apiBaseUrl = apiBaseUrl ?? (() => HttpClient.baseUrl),
        _isCurrent = isCurrent,
        _retry = MediaAccessRetry(refresh: refresh, isCurrent: isCurrent);

  void dispose() {
    if (_ownsPublicDio) _publicDio.close(force: true);
  }

  Future<void> download({
    required String remoteUrl,
    required String partPath,
    ProgressCallback? onReceiveProgress,
    MediaRequestContext? context,
  }) async {
    await _retry.run<void>(
      url: remoteUrl,
      context: context,
      canFallback: _canFallback,
      load: (url) async {
        await _request(url,
            partPath: partPath, onReceiveProgress: onReceiveProgress);
      },
    );
  }

  Future<List<int>> fetchBytes(String remoteUrl,
      {MediaRequestContext? context}) {
    return _retry.run<List<int>>(
      url: remoteUrl,
      context: context,
      canFallback: _canFallback,
      load: (url) async {
        final response = await _request(url);
        final data = response.data as List<int>?;
        if (data == null || data.isEmpty) {
          throw StateError('Media response is empty');
        }
        return data;
      },
    );
  }

  String failureReason(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) return 'unauthorized';
      if (status == 404) return 'not_found';
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'network';
      }
      return status == null ? error.type.name : 'http_$status';
    }
    return error.runtimeType.toString();
  }

  Future<Response<dynamic>> _request(String url,
      {String? partPath, ProgressCallback? onReceiveProgress}) async {
    var request = ChatMediaRequest.resolve(url, _apiBaseUrl());
    for (var redirects = 0; redirects <= 3; redirects++) {
      _verifyCurrent();
      final dio = request.accountPath == null ? _publicDio : _dio;
      final path = request.accountPath ?? request.url;
      final options = Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) =>
            status != null && status >= 200 && status < 400,
      );
      final response = partPath == null
          ? await dio.get<List<int>>(path, options: options)
          : await dio.download(path, partPath,
              options: options, onReceiveProgress: onReceiveProgress);
      _verifyCurrent();
      final status = response.statusCode!;
      final location = response.headers.value('location');
      if (status < 300) return response;
      if (location == null || location.trim().isEmpty) {
        throw DioException.badResponse(
          statusCode: status,
          requestOptions: response.requestOptions,
          response: response,
        );
      }
      request = ChatMediaRequest.resolve(
          request.uri.resolve(location).toString(), _apiBaseUrl());
    }
    throw StateError('Too many media redirects');
  }

  bool _canFallback(String url) =>
      ChatMediaRequest.resolve(url, _apiBaseUrl()).accountPath != null;

  void _verifyCurrent() {
    if (_isCurrent?.call() == false) throw AccountOperationSuperseded();
  }
}
