import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/api_response.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/settings/domain/entities/settings_entities.dart';

abstract class SettingsRemoteDataSource {
  Future<NotificationSettings> getNotificationSettings();
  Future<void> updateNotificationSettings(NotificationSettings settings);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio _dio;

  SettingsRemoteDataSourceImpl(this._dio);

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/notification-settings',
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => NotificationSettings.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/notification-settings',
        data: settings.toJson(),
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }
}
