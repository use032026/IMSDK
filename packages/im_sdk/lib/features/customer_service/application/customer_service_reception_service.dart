import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/features/customer_service/data/repositories/customer_service_repository.dart';

class CustomerServiceReceptionService {
  final CustomerServiceRepository _repository;

  const CustomerServiceReceptionService(this._repository);

  Future<CsThreadDetail> claim(CsThread thread) async {
    final result = await _repository.claimThread(thread);
    return projectSuccessfulCustomerServiceReception(
      previous: thread,
      serverDetail: result.detail,
    );
  }

  Future<CsThreadDetail> takeover(CsThread thread) async {
    final result = await _repository.takeoverThread(thread);
    return projectSuccessfulCustomerServiceReception(
      previous: thread,
      serverDetail: result.detail,
    );
  }

  Future<CsThreadDetail> close(
    CsThread thread, {
    CsThreadDetail? currentDetail,
  }) async {
    await _repository.closeThread(thread);
    return projectSuccessfulCustomerServiceClosure(
      previous: thread,
      currentDetail: currentDetail,
    );
  }
}

/// A successful close command makes the thread read-only immediately while
/// keeping its messages available until the authoritative snapshot arrives.
CsThreadDetail projectSuccessfulCustomerServiceClosure({
  required CsThread previous,
  CsThreadDetail? currentDetail,
}) {
  final detail = currentDetail ??
      CsThreadDetail(
        handoffMode: previous.handoffMode,
        officialUserId: previous.officialUserId,
        threadType: previous.threadType,
        threadId: previous.threadId,
        conversationId: previous.conversationId,
        status: previous.status,
        title: previous.title,
        avatarUrl: previous.avatarUrl,
        peerUserId: previous.peerUserId,
        customerUserId: previous.customerUserId,
        visitorId: previous.visitorId,
        assignedStaffUserId: previous.assignedStaffUserId,
        assignedStaffDisplayName: previous.assignedStaffDisplayName,
        source: previous.source,
        assignedAt: previous.assignedAt,
        currentResponderType: previous.currentResponderType,
        aiStatus: previous.aiStatus,
      );
  return detail.copyWith(status: 'closed_by_staff');
}

/// Applies the business meaning of a successful reception command.
///
/// HTTP success is authoritative for leaving the queue. A sparse response
/// therefore becomes a provisional `serving` snapshot, while every explicit
/// server field still wins. The normal thread refresh remains responsible for
/// replacing this projection with the authoritative server snapshot.
CsThreadDetail projectSuccessfulCustomerServiceReception({
  required CsThread previous,
  required CsThreadDetail? serverDetail,
}) {
  final detail = serverDetail;
  return CsThreadDetail(
    handoffMode: detail?.handoffModeProvided == true
        ? detail!.handoffMode
        : previous.handoffMode,
    officialUserId: detail?.officialUserId ?? previous.officialUserId,
    lastReadSeq: detail?.lastReadSeq,
    staffLastReadAt: detail?.staffLastReadAt,
    threadType: _preferText(detail?.threadType, previous.threadType),
    threadId: _preferText(detail?.threadId, previous.threadId),
    conversationId:
        _preferText(detail?.conversationId, previous.conversationId),
    status: _preferText(detail?.status, 'serving'),
    title: _preferText(detail?.title, previous.title),
    avatarUrl: detail?.avatarUrl ?? previous.avatarUrl,
    peerUserId: detail?.peerUserId ?? previous.peerUserId,
    customerUserId: detail?.customerUserId ?? previous.customerUserId,
    visitorId: detail?.visitorId ?? previous.visitorId,
    assignedStaffUserId:
        detail?.assignedStaffUserId ?? previous.assignedStaffUserId,
    assignedStaffDisplayName:
        detail?.assignedStaffDisplayName ?? previous.assignedStaffDisplayName,
    source: detail?.source ?? previous.source,
    assignedAt: detail?.assignedAt ?? previous.assignedAt,
    currentResponderType:
        detail?.currentResponderType ?? previous.currentResponderType,
    aiStatus: detail?.aiStatus ?? previous.aiStatus,
    messages: detail?.messages ?? const [],
    readStatus: detail?.readStatus,
    customerLastReadSeq: detail?.customerLastReadSeq,
    customerLastReadAt: detail?.customerLastReadAt,
  );
}

String _preferText(String? value, String fallback) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? fallback : normalized;
}
