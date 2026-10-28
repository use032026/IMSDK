import 'package:im_sdk/features/app_update/data/app_update_dto.dart';
import 'package:im_sdk/features/app_update/domain/app_release_face.dart';

class AppReleaseFaceDto {
  const AppReleaseFaceDto({required this.face});

  final AppReleaseFace face;

  factory AppReleaseFaceDto.fromEnvelope(Map<String, dynamic> envelope) {
    if (envelope['code'] != 'OK') {
      throw AppUpdateDtoException(
        _optionalString(envelope['message']) ?? '发布面检查失败',
      );
    }
    final data = envelope['data'];
    if (data is! Map<String, dynamic>) {
      throw const AppUpdateDtoException('发布面服务返回缺少 data');
    }
    return AppReleaseFaceDto.fromJson(data);
  }

  factory AppReleaseFaceDto.fromJson(Map<String, dynamic> json) {
    return AppReleaseFaceDto(
      face: _optionalString(json['mode']) == 'isB'
          ? AppReleaseFace.isB
          : AppReleaseFace.isA,
    );
  }
}

String? _optionalString(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
