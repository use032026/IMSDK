import 'package:im_sdk/features/space/domain/entities/space_entity.dart';

abstract class SpaceRepository {
  /// 获取当前账号可用的空间列表。
  Future<List<Space>> getSpaces();
}
