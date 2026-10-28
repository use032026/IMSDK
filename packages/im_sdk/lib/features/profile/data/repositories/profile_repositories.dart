import 'package:im_sdk/features/profile/data/datasources/profile_datasources.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/features/profile/domain/entities/profile_entities.dart';
import 'package:im_sdk/features/profile/domain/repositories/profile_repositories.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;
  final ProfileLocalDataSource _local;

  ProfileRepositoryImpl(this._remote, this._local);

  @override
  Future<UserProfile?> getCachedMyProfile({
    required String spaceId,
    required String userId,
  }) =>
      _local.getMyProfile(spaceId: spaceId, userId: userId);

  @override
  Future<UserProfile> refreshMyProfile({
    required String spaceId,
    required String userId,
  }) async {
    final profile = await _remote.getMyProfile();
    if (profile.userId != userId) {
      throw StateError('PROFILE_SCOPE_MISMATCH');
    }
    try {
      await _local.saveMyProfile(
        spaceId: spaceId,
        userId: userId,
        profile: profile,
      );
    } catch (error) {
      AppDiagnostics.instance.warning(
        'profile.cache.write_failed',
        'Current profile cache write failed',
        context: {
          'scopeHash': Object.hash(spaceId, userId).toRadixString(16),
          'errorType': error.runtimeType.toString(),
        },
      );
    }
    return profile;
  }

  @override
  Future<UserProfile> updateMyProfile(
    UpdateProfileRequest request, {
    required String spaceId,
    required String userId,
    UserProfile? currentProfile,
  }) async {
    if (currentProfile != null && currentProfile.userId != userId) {
      throw StateError('PROFILE_SCOPE_MISMATCH');
    }
    await _remote.updateProfile(request);

    UserProfile? base = currentProfile;
    if (base == null) {
      try {
        base = await _local.getMyProfile(spaceId: spaceId, userId: userId);
      } catch (error) {
        AppDiagnostics.instance.warning(
          'profile.cache.read_failed',
          'Current profile cache read failed after update',
          context: {
            'scopeHash': Object.hash(spaceId, userId).toRadixString(16),
            'errorType': error.runtimeType.toString(),
          },
        );
      }
    }
    if (base == null || base.userId != userId) {
      return refreshMyProfile(spaceId: spaceId, userId: userId);
    }

    final updated = base.apply(request);
    try {
      await _local.saveMyProfile(
        spaceId: spaceId,
        userId: userId,
        profile: updated,
      );
    } catch (error) {
      AppDiagnostics.instance.warning(
        'profile.cache.write_failed',
        'Current profile cache write failed after update',
        context: {
          'scopeHash': Object.hash(spaceId, userId).toRadixString(16),
          'errorType': error.runtimeType.toString(),
        },
      );
    }
    return updated;
  }

  @override
  Future<UserProfile> updateMyLppId(
    String newLppId, {
    required String spaceId,
    required String userId,
  }) async {
    await _remote.updateZtId(newLppId);
    return refreshMyProfile(spaceId: spaceId, userId: userId);
  }

  @override
  Future<UserProfile> getUserProfile(String userId) =>
      _remote.getUserProfile(userId);

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) =>
      _remote.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

  @override
  Future<ProfilePrivacySettings> getPrivacySettings() =>
      _remote.getPrivacySettings();

  @override
  Future<ProfilePrivacySettings> updatePrivacySettings(
          ProfilePrivacySettings settings) =>
      _remote.updatePrivacySettings(settings);

  @override
  Future<List<UserAddress>> getAddresses() => _remote.getAddresses();

  @override
  Future<UserAddress> createAddress(AddressRequest request) =>
      _remote.createAddress(request);

  @override
  Future<void> updateAddress(String addressId, AddressRequest request) =>
      _remote.updateAddress(addressId, request);

  @override
  Future<void> deleteAddress(String addressId) =>
      _remote.deleteAddress(addressId);

  @override
  Future<FeedbackResult> submitFeedback(FeedbackRequest request) =>
      _remote.submitFeedback(request);
}
