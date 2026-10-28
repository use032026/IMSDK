import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/services/link_message_policy.dart';

class LinkMessageDraft {
  final MessageType type;
  final MessageBody body;

  const LinkMessageDraft({required this.type, required this.body});
}

class LinkMessageDraftResolver {
  const LinkMessageDraftResolver();

  LinkMessageDraft resolve(String input) {
    final text = input.trim();
    final uri = LinkMessagePolicy.tryParseStandaloneUrl(text);
    if (uri == null) {
      return LinkMessageDraft(
        type: MessageType.text,
        body: MessageBody(text: text),
      );
    }

    return LinkMessageDraft(
      type: MessageType.link,
      body: MessageBody(text: text, link: LinkMessageBody.fallback(uri)),
    );
  }
}
