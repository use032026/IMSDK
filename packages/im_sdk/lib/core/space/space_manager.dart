import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';

/// SecureStorageService Provider（供其他 Provider 使用）
final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageServiceImpl(),
);

/// 当前激活空间的 Provider
final currentSpaceProvider = NotifierProvider<SpaceManager, SpaceContext?>(
  SpaceManager.new,
);

class SpaceManager extends Notifier<SpaceContext?> {
  @override
  SpaceContext? build() => null; // 初始为 null，登录后设置

  /// 设置当前空间（登录成功后调用，或启动时恢复）
  /// 注意：此方法不持久化 active_space_id，避免覆盖用户的空间选择
  void setSpace(SpaceContext context) {
    state = context;
  }

  /// 清除空间（退出登录时调用）
  void clearSpace() {
    state = null;
  }
}
