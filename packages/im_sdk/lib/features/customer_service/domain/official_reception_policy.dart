import 'package:im_sdk/features/chat/domain/entities/message.dart';

bool canOperateOfficialReception(
        {required bool inOfficial,
        required String? assignedStaffUserId,
        required String userId}) =>
    !inOfficial || (userId.isNotEmpty && assignedStaffUserId == userId);

bool isOfficialReceptionStaffMessage(Message message, String? officialUserId) =>
    officialUserId != null &&
    officialUserId.isNotEmpty &&
    message.senderUserId == officialUserId;

bool canRecallReceptionMessage(Message message, String userId) =>
    message.operatorUserId != null
        ? message.operatorUserId == userId
        : message.isSelf || message.senderUserId == userId;
