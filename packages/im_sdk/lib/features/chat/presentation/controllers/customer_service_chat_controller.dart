import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/customer_service/domain/official_reception_policy.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/gateway_event_handler.dart';
import 'package:im_sdk/features/chat/data/datasources/pending_message_queue.dart';
import 'package:im_sdk/features/chat/data/mappers/message_send_failure_mapper.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_policy.dart';
import 'package:im_sdk/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:im_sdk/features/chat/presentation/models/customer_service_chat_state_model.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/features/customer_service/application/customer_service_reception_service.dart';
import 'package:im_sdk/features/customer_service/data/repositories/customer_service_chat_repository_adapter.dart';
import 'package:im_sdk/features/customer_service/data/repositories/customer_service_repository.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';

final customerServiceChatControllerProvider =
    Provider<CustomerServiceChatController>((ref) {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  return CustomerServiceChatController(
    ref.watch(customerServiceRepositoryProvider),
    receptionService: ref.watch(customerServiceReceptionServiceProvider),
    mediaRemote: ChatRemoteDataSourceImpl(ref.watch(dioProvider)),
    localWriter: CustomerServiceSqliteLocalMessageWriter(
      ref.watch(chatLocalDataSourceProvider),
    ),
    pendingStore: CustomerServiceHivePendingMessageStore(
      ref.watch(pendingMessageQueueProvider),
    ),
    currentUserIdResolver: () => space?.userId ?? '',
    spaceIdResolver: () => space?.spaceId ?? '',
  );
}, dependencies: [
  customerServiceRepositoryProvider,
  customerServiceReceptionServiceProvider,
  dioProvider,
  chatLocalDataSourceProvider,
  pendingMessageQueueProvider,
  accountRuntimeCurrentSpaceProvider,
]);

abstract class CustomerServiceLocalMessageWriter {
  Future<void> upsertMessage(
    String spaceId,
    String conversationId,
    Message message,
  );
}

class CustomerServiceSqliteLocalMessageWriter
    implements CustomerServiceLocalMessageWriter {
  final ChatLocalDataSource _local;

  const CustomerServiceSqliteLocalMessageWriter(this._local);

  @override
  Future<void> upsertMessage(
    String spaceId,
    String conversationId,
    Message message,
  ) {
    return _local.upsertMessage(spaceId, conversationId, message);
  }
}

abstract class CustomerServicePendingMessageStore {
  Future<void> enqueue(PendingMessage message);
}

class CustomerServiceHivePendingMessageStore
    implements CustomerServicePendingMessageStore {
  final PendingMessageQueue _queue;

  const CustomerServiceHivePendingMessageStore(this._queue);

  @override
  Future<void> enqueue(PendingMessage message) {
    return _queue.enqueue(message);
  }
}

class CustomerServiceChatController {
  final CustomerServiceRepository _repository;
  final CustomerServiceReceptionService _receptionService;
  final ChatRemoteDataSource _mediaRemote;
  final CustomerServiceLocalMessageWriter _localWriter;
  final CustomerServicePendingMessageStore _pendingStore;
  final String Function()? _currentUserIdResolver;
  final String Function()? _spaceIdResolver;

  const CustomerServiceChatController(
    this._repository, {
    required CustomerServiceReceptionService receptionService,
    required ChatRemoteDataSource mediaRemote,
    required CustomerServiceLocalMessageWriter localWriter,
    required CustomerServicePendingMessageStore pendingStore,
    String Function()? currentUserIdResolver,
    String Function()? spaceIdResolver,
  })  : _receptionService = receptionService,
        _mediaRemote = mediaRemote,
        _localWriter = localWriter,
        _pendingStore = pendingStore,
        _currentUserIdResolver = currentUserIdResolver,
        _spaceIdResolver = spaceIdResolver;

  Future<CsThreadDetail> fetchThread(CsThread thread) {
    return _repository.getThread(thread);
  }

  Future<CsThreadDetail> takeoverThread(CsThread thread) {
    return _receptionService.takeover(thread);
  }

  Future<CsThreadDetail> claimThread(CsThread thread) {
    return _receptionService.claim(thread);
  }

  Future<CsThreadDetail> closeThread(
    CsThread thread, {
    CsThreadDetail? currentDetail,
  }) {
    return _receptionService.close(thread, currentDetail: currentDetail);
  }

  Future<Message> sendMessage({
    String? spaceId,
    String? currentUserId,
    required CsThreadDetail thread,
    required String conversationId,
    required MessageType type,
    required MessageBody body,
    String? clientMsgId,
    String? replyToMessageId,
    bool readOnly = false,
    OnOptimisticInsert? onOptimisticInsert,
    OnMessageUpdate? onMessageUpdate,
  }) async {
    final state = CustomerServiceChatState.fromDetail(
      thread,
      isCustomerServiceThread: true,
      readOnly: readOnly,
    );
    if (state.ended) {
      throw const ServerError(
        code: 'TEMP_SESSION_CLOSED',
        message: '会话已结束，不能继续发送消息',
      );
    }
    if (state.requiresManualEntry) {
      throw const ServerError(
        code: 'TEMP_SESSION_NOT_CLAIMED',
        message: '请先接入或人工接管后再回复',
      );
    }

    final effectiveCurrentUserId =
        currentUserId ?? _currentUserIdResolver?.call() ?? '';
    if (!canOperateOfficialReception(
        inOfficial: thread.isOfficialReception,
        assignedStaffUserId: thread.assignedStaffUserId,
        userId: effectiveCurrentUserId)) {
      throw const ServerError(
          code: 'CUSTOMER_SERVICE_DIRECT_NOT_ASSIGNED',
          message: '当前会话未分配给你',
          statusCode: 403);
    }
    final effectiveSpaceId = spaceId ?? _spaceIdResolver?.call() ?? '';
    final repository = CustomerServiceChatRepositoryAdapter(
      customerServiceRepository: _repository,
      mediaRemote: _mediaRemote,
      threadType: thread.threadType,
      threadId: thread.threadId,
      senderUserId: effectiveCurrentUserId,
      receptionThread: CsThread(
          threadType: thread.threadType,
          threadId: thread.threadId,
          conversationId: thread.conversationId,
          status: thread.status,
          title: thread.title,
          handoffMode: thread.handoffMode,
          officialUserId: thread.officialUserId,
          assignedStaffUserId: thread.assignedStaffUserId),
    );
    final useCase = SendMessageUseCase(
      repository: repository,
      currentUserId: effectiveCurrentUserId,
      failureMapper: mapAppErrorToMessageSendFailure,
      sendPolicy: const MessageSendPolicy(
        context: MessageSendPolicyContext.enterpriseEmployee,
      ),
      onPendingEnqueue: ({
        required clientMsgId,
        required conversationId,
        required isGroup,
        required type,
        required body,
        mentions,
      }) {
        return _pendingStore.enqueue(PendingMessage(
          spaceId: effectiveSpaceId,
          userId: effectiveCurrentUserId,
          clientMsgId: clientMsgId,
          conversationId: conversationId,
          isGroup: false,
          messageType: GatewayEventHandler.messageTypeToApiString(type),
          body: body.toLocalJson(),
          mentions: mentions,
          threadType: thread.threadType,
          threadId: thread.threadId,
          createdAt: DateTime.now(),
        ));
      },
    );

    final sent = await useCase.execute(
      conversationId: conversationId,
      isGroup: false,
      type: type,
      body: body,
      clientMsgId: clientMsgId,
      replyToMessageId: replyToMessageId,
      onOptimisticInsert: onOptimisticInsert,
      onMessageUpdate: onMessageUpdate,
    );
    await _localWriter.upsertMessage(
      effectiveSpaceId,
      conversationId,
      sent,
    );
    return sent;
  }
}
