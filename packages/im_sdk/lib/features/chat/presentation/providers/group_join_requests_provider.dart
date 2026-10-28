import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/features/chat/data/datasources/group_join_requests_remote_data_source.dart';
import 'package:im_sdk/features/chat/domain/entities/group_join_request.dart';

enum GroupJoinRequestReviewResult {
  reviewed,
  alreadyHandled,
}

final groupJoinRequestsRemoteDataSourceProvider =
    Provider<GroupJoinRequestsRemoteDataSource>((ref) {
  return GroupJoinRequestsRemoteDataSource(ref.watch(dioProvider));
}, dependencies: [dioProvider]);

final groupJoinRequestsProvider = StateNotifierProvider.autoDispose.family<
    GroupJoinRequestsNotifier,
    AsyncValue<List<GroupJoinRequest>>,
    String>((ref, groupId) {
  return GroupJoinRequestsNotifier(
    dataSource: ref.watch(groupJoinRequestsRemoteDataSourceProvider),
    groupId: groupId,
  );
}, dependencies: [groupJoinRequestsRemoteDataSourceProvider]);

class GroupJoinRequestsNotifier
    extends StateNotifier<AsyncValue<List<GroupJoinRequest>>> {
  final GroupJoinRequestsRemoteDataSource _dataSource;
  final String _groupId;

  GroupJoinRequestsNotifier({
    required GroupJoinRequestsRemoteDataSource dataSource,
    required String groupId,
  })  : _dataSource = dataSource,
        _groupId = groupId,
        super(const AsyncValue.loading()) {
    load().catchError((_) {});
  }

  Future<void> load() async {
    final previous = state;
    if (!previous.hasValue) {
      state = const AsyncValue.loading();
    }
    try {
      state = AsyncValue.data(await _dataSource.getRequests(_groupId));
    } catch (error, stackTrace) {
      if (!previous.hasValue) {
        state = AsyncValue.error(error, stackTrace);
      }
      rethrow;
    }
  }

  Future<GroupJoinRequestReviewResult> approve(String requestId) {
    return _review(
      requestId: requestId,
      reviewedStatus: GroupJoinRequestStatus.approved,
      action: () => _dataSource.approve(
        groupId: _groupId,
        requestId: requestId,
      ),
    );
  }

  Future<GroupJoinRequestReviewResult> reject(
    String requestId, {
    String? reason,
  }) {
    return _review(
      requestId: requestId,
      reviewedStatus: GroupJoinRequestStatus.rejected,
      rejectReason: reason,
      action: () => _dataSource.reject(
        groupId: _groupId,
        requestId: requestId,
        reason: reason,
      ),
    );
  }

  Future<GroupJoinRequestReviewResult> _review({
    required String requestId,
    required GroupJoinRequestStatus reviewedStatus,
    required Future<void> Function() action,
    String? rejectReason,
  }) async {
    try {
      await action();
      _markReviewed(
        requestId,
        status: reviewedStatus,
        rejectReason: rejectReason,
      );
      return GroupJoinRequestReviewResult.reviewed;
    } on GroupJoinRequestAlreadyHandledException {
      _markReviewed(
        requestId,
        status: GroupJoinRequestStatus.handled,
      );
      return GroupJoinRequestReviewResult.alreadyHandled;
    }
  }

  void _markReviewed(
    String requestId, {
    required GroupJoinRequestStatus status,
    String? rejectReason,
  }) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data([
      for (final request in current)
        if (request.requestId == requestId)
          request.reviewed(status: status, rejectReason: rejectReason)
        else
          request,
    ]);
  }
}
