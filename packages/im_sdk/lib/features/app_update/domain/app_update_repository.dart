import 'package:im_sdk/features/app_update/domain/app_release_face.dart';
import 'package:im_sdk/features/app_update/domain/app_release_update.dart';

abstract class AppUpdateRepository {
  Future<AppReleaseUpdate> checkLatest({
    required String appKey,
    required String platform,
    required int versionCode,
  });

  Future<AppReleaseFace> checkReleaseFace({
    required String channel,
    required String version,
  });
}
