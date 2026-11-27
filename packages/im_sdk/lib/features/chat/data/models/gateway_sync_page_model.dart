import 'package:im_sdk/features/chat/data/models/conversation_clear_watermark_model.dart';
import 'package:im_sdk/features/chat/data/models/gateway_sync_conversation_model.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation_clear_watermark.dart';

class GatewaySyncPageModel {
  GatewaySyncPageModel.fromJson(
    Object? data, {
    required String currentUserId,
    required int? sinceSeq,
  }) {
    if (data is! Map<String, dynamic> || data['conversations'] is! List) {
      throw const FormatException('Invalid sync page');
    }
    conversations = (data['conversations'] as List).map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid sync conversation record');
      }
      final conversation = GatewaySyncConversationModel.tryParse(
        item,
        currentUserId: currentUserId,
      );
      if (conversation == null) {
        throw const FormatException('Missing sync conversation identity');
      }
      return conversation;
    }).toList(growable: false);
    messageCount =
        conversations.fold(0, (count, item) => count + item.messages.length);

    final rawCursor = data['nextSinceSeq'];
    nextSinceSeq = switch (rawCursor) {
      int value => value,
      String value => int.tryParse(value, radix: 10),
      _ => null,
    };
    final next = nextSinceSeq;
    canCommitCursor = (rawCursor == null || next != null) &&
        (next == null || next >= (sinceSeq ?? 0)) &&
        (messageCount == 0 || (next != null && next > (sinceSeq ?? 0)));
    clearWatermarks = ConversationClearWatermarkModel.parseList(
      data['clearWatermarks'],
    );
  }

  late final List<GatewaySyncConversationModel> conversations;
  late final List<ConversationClearWatermark> clearWatermarks;
  late final int? nextSinceSeq;
  late final int messageCount;
  late final bool canCommitCursor;
}
