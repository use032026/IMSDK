import 'package:im_sdk/features/profile/domain/entities/profile_entities.dart';

abstract class ProfileRepository {
  /// 读取当前账号在指定空间的本地资料快照。
  Future<UserProfile?> getCachedMyProfile({
    required String spaceId,
    required String userId,
  });

  /// GET /api/client/v1/profile/me
  ///
  /// 拉取成功后同步写入当前账号的本地快照。
  Future<UserProfile> refreshMyProfile({
    required String spaceId,
    required String userId,
  });

  /// PUT /api/client/v1/profile/me
  ///
  /// 服务端确认成功后将变更归约到当前资料，并同步本地快照。
  Future<UserProfile> updateMyProfile(
    UpdateProfileRequest request, {
    required String spaceId,
    required String userId,
    UserProfile? currentProfile,
  });

  /// PUT /api/client/v1/profile/me/lpp-id
  Future<UserProfile> updateMyLppId(
    String newLppId, {
    required String spaceId,
    required String userId,
  });

  /// GET /api/client/v1/users/{userId}/profile
  Future<UserProfile> getUserProfile(String userId);

  /// POST /api/client/v1/auth/change-password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<ProfilePrivacySettings> getPrivacySettings();
  Future<ProfilePrivacySettings> updatePrivacySettings(
      ProfilePrivacySettings settings);
  Future<List<UserAddress>> getAddresses();
  Future<UserAddress> createAddress(AddressRequest request);
  Future<void> updateAddress(String addressId, AddressRequest request);
  Future<void> deleteAddress(String addressId);
  Future<FeedbackResult> submitFeedback(FeedbackRequest request);
}
