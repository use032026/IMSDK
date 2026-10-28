import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/api_response.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/features/profile/data/models/profile_models.dart';
import 'package:im_sdk/features/profile/domain/entities/profile_entities.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile> getMyProfile();
  Future<void> updateProfile(UpdateProfileRequest request);
  Future<void> updateZtId(String newZtId);
  Future<UserProfile> getUserProfile(String userId);
  Future<void> changePassword(
      {required String oldPassword, required String newPassword});
  Future<ProfilePrivacySettings> getPrivacySettings();
  Future<ProfilePrivacySettings> updatePrivacySettings(
      ProfilePrivacySettings settings);
  Future<List<UserAddress>> getAddresses();
  Future<UserAddress> createAddress(AddressRequest request);
  Future<void> updateAddress(String addressId, AddressRequest request);
  Future<void> deleteAddress(String addressId);
  Future<FeedbackResult> submitFeedback(FeedbackRequest request);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<UserProfile> getMyProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/profile/me',
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => UserProfileModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> updateProfile(UpdateProfileRequest request) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/profile/me',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> updateZtId(String newZtId) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/profile/me/lpp-id',
        data: {'lppId': newZtId},
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/users/$userId/profile',
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => UserProfileModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/auth/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<ProfilePrivacySettings> getPrivacySettings() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/profile/me/privacy',
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => ProfilePrivacySettings.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<ProfilePrivacySettings> updatePrivacySettings(
      ProfilePrivacySettings settings) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/profile/me/privacy',
        data: settings.toJson(),
      );
      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return ProfilePrivacySettings.fromJson(data);
      }
      return settings;
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<List<UserAddress>> getAddresses() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/profile/me/addresses',
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => (json as List<dynamic>)
            .map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<UserAddress> createAddress(AddressRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/profile/me/addresses',
        data: request.toJson(),
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => UserAddress.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> updateAddress(String addressId, AddressRequest request) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/profile/me/addresses/$addressId',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      await _dio.delete<Map<String, dynamic>>(
        '/api/client/v1/profile/me/addresses/$addressId',
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<FeedbackResult> submitFeedback(FeedbackRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/feedback',
        data: request.toJson(),
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => FeedbackResult.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }
}

abstract class ProfileLocalDataSource {
  Future<UserProfile?> getMyProfile({
    required String spaceId,
    required String userId,
  });

  Future<void> saveMyProfile({
    required String spaceId,
    required String userId,
    required UserProfile profile,
  });
}

class HiveProfileLocalDataSource implements ProfileLocalDataSource {
  static const _legacyKey = 'my_profile';
  static const _keyPrefix = 'my_profile_v2_';

  const HiveProfileLocalDataSource({
    required AccountProfileBoxResolver profileBoxResolver,
  }) : _profileBoxResolver = profileBoxResolver;

  final AccountProfileBoxResolver _profileBoxResolver;

  @override
  Future<UserProfile?> getMyProfile({
    required String spaceId,
    required String userId,
  }) async {
    if (spaceId.isEmpty || userId.isEmpty) return null;
    final box = await _profileBoxResolver(spaceId);
    final scopedKey = '$_keyPrefix$userId';
    final scoped = _decode(box.get(scopedKey));
    if (scoped != null && scoped.userId == userId) return scoped;

    // 旧缓存只按 spaceId 隔离。仅在内部 userId 精确匹配时迁移，避免同企业
    // 多账号复用设备时串资料。
    final legacy = _decode(box.get(_legacyKey));
    if (legacy == null || legacy.userId != userId) return null;
    await box.put(scopedKey, _encode(legacy));
    await box.delete(_legacyKey);
    return legacy;
  }

  @override
  Future<void> saveMyProfile({
    required String spaceId,
    required String userId,
    required UserProfile profile,
  }) async {
    if (spaceId.isEmpty || userId.isEmpty || profile.userId != userId) return;
    final box = await _profileBoxResolver(spaceId);
    await box.put('$_keyPrefix$userId', _encode(profile));
  }

  UserProfile? _decode(Object? raw) {
    if (raw is! Map) return null;
    try {
      return UserProfileModel.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  Map<String, Object?> _encode(UserProfile profile) => {
        'userId': profile.userId,
        'platformUserId': profile.platformUserId,
        'lppId': profile.lppId,
        'displayName': profile.displayName,
        'avatarUrl': profile.avatarUrl,
        'signature': profile.signature,
        'gender': profile.gender,
        'birthday': profile.birthday,
        'location': profile.location,
        'bio': profile.bio,
        'tapTapText': profile.tapTapText,
        'mobile': profile.mobile,
        'email': profile.email,
      };
}
