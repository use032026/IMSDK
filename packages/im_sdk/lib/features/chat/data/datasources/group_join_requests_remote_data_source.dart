import 'package:dio/dio.dart';
import 'package:im_sdk/features/chat/domain/entities/group_join_request.dart';

class GroupJoinRequestAlreadyHandledException implements Exception {
  const GroupJoinRequestAlreadyHandledException();
}

class GroupJoinRequestsRemoteDataSource {
  final Dio _dio;

  const GroupJoinRequestsRemoteDataSource(this._dio);

  Future<List<GroupJoinRequest>> getRequests(String groupId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/client/v1/groups/$groupId/join-requests',
    );
    final rawData = response.data?['data'];
    final items = rawData is Map ? rawData['items'] : rawData;
    if (items is! List) return const [];
    return items
        .whereType<Map>()
        .map((item) => mapGroupJoinRequest(
              Map<String, dynamic>.from(item),
              fallbackGroupId: groupId,
            ))
        .toList(growable: false);
  }

  Future<void> approve({
    required String groupId,
    required String requestId,
  }) async {
    await _review(
      '/api/client/v1/groups/$groupId/join-requests/$requestId/approve',
    );
  }

  Future<void> reject({
    required String groupId,
    required String requestId,
    String? reason,
  }) async {
    await _review(
      '/api/client/v1/groups/$groupId/join-requests/$requestId/reject',
      data: {'rejectReason': reason},
    );
  }

  Future<void> _review(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      await _dio.post<void>(path, data: data);
    } on DioException catch (error) {
      if (_isAlreadyHandled(error)) {
        throw const GroupJoinRequestAlreadyHandledException();
      }
      rethrow;
    }
  }

  bool _isAlreadyHandled(DioException error) {
    final data = error.response?.data;
    if (error.response?.statusCode != 409 || data is! Map) return false;
    final code = data['code']?.toString().toUpperCase() ?? '';
    final message = data['message']?.toString().toLowerCase() ?? '';
    return code == 'GROUP_JOIN_REQUEST_HANDLED' ||
        code == 'JOIN_REQUEST_HANDLED' ||
        message.contains('already handled') ||
        message.contains('已处理');
  }
}

GroupJoinRequest mapGroupJoinRequest(
  Map<String, dynamic> json, {
  required String fallbackGroupId,
}) {
  return GroupJoinRequest(
    requestId: json['requestId'] as String? ?? '',
    groupId: json['groupId'] as String? ?? fallbackGroupId,
    conversationId: json['conversationId'] as String? ?? '',
    userId:
        json['userId'] as String? ?? json['applicantUserId'] as String? ?? '',
    displayName: json['userDisplayName'] as String? ??
        json['applicantDisplayName'] as String? ??
        json['displayName'] as String? ??
        '申请人',
    avatarUrl: json['userAvatarUrl'] as String? ??
        json['applicantAvatarUrl'] as String? ??
        json['avatarUrl'] as String?,
    message: json['message'] as String?,
    status: _parseStatus(json['status']),
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    reviewedAt: DateTime.tryParse(json['reviewedAt'] as String? ?? ''),
    reviewerUserId: json['reviewerUserId'] as String?,
    rejectReason: json['rejectReason'] as String?,
  );
}

GroupJoinRequestStatus _parseStatus(Object? value) {
  return switch (value?.toString().trim().toLowerCase()) {
    'approved' => GroupJoinRequestStatus.approved,
    'rejected' => GroupJoinRequestStatus.rejected,
    'handled' => GroupJoinRequestStatus.handled,
    _ => GroupJoinRequestStatus.pending,
  };
}
