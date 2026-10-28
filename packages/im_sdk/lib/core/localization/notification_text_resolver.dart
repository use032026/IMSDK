import 'package:flutter/widgets.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class NotificationTextResolver {
  const NotificationTextResolver();

  NotificationText resolve(Locale locale) {
    return NotificationText(lookupAppLocalizations(locale));
  }
}

class NotificationChannelText {
  const NotificationChannelText({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

class NotificationText {
  const NotificationText(this._l10n);

  final AppLocalizations _l10n;

  String get newMessageTitle => _l10n.notificationNewMessageTitle;
  String get onlineServiceTitle => _l10n.notificationOnlineServiceTitle;
  String get newMessageBody => _l10n.notificationNewMessageBody;
  String get securityTitle => _l10n.notificationSecurityTitle;
  String get securityBody => _l10n.notificationSecurityBody;
  String get unknownCaller => _l10n.notificationUnknownCaller;

  NotificationChannelText get messageChannel => NotificationChannelText(
        name: _l10n.notificationMessageChannelName,
        description: _l10n.notificationMessageChannelDescription,
      );

  NotificationChannelText get callChannel => NotificationChannelText(
        name: _l10n.notificationCallChannelName,
        description: _l10n.notificationCallChannelDescription,
      );

  NotificationChannelText get securityChannel => NotificationChannelText(
        name: _l10n.notificationSecurityChannelName,
        description: _l10n.notificationSecurityChannelDescription,
      );

  String messagePreview(String messageType) {
    return switch (messageType) {
      'image' => _l10n.notificationImagePreview,
      'video' => _l10n.notificationVideoPreview,
      'voice' => _l10n.notificationVoicePreview,
      'file' => _l10n.notificationFilePreview,
      'contact_card' => _l10n.notificationContactPreview,
      'call_log' => _l10n.notificationCallLogPreview,
      'location' => _l10n.notificationLocationPreview,
      'link' => _l10n.notificationLinkPreview,
      _ => newMessageBody,
    };
  }

  String mentionBody({
    required String kind,
    required String sender,
    required String body,
  }) {
    if (kind == 'me' || kind == 'user') {
      return sender.isEmpty
          ? _l10n.notificationMentionMe(body)
          : _l10n.notificationMentionMeBy(sender, body);
    }
    if (kind == 'all') {
      return sender.isEmpty
          ? _l10n.notificationMentionAll(body)
          : _l10n.notificationMentionAllBy(sender, body);
    }
    return body;
  }

  String friendRequestTitle({required bool accepted}) => accepted
      ? _l10n.notificationFriendAcceptedTitle
      : _l10n.notificationFriendRejectedTitle;

  String friendRequestBody({required bool accepted}) => accepted
      ? _l10n.notificationFriendAcceptedBody
      : _l10n.notificationFriendRejectedBody;

  String callTitle({required bool isVideo}) => isVideo
      ? _l10n.notificationVideoCallTitle
      : _l10n.notificationAudioCallTitle;

  String callBody({required bool isVideo, required String caller}) => isVideo
      ? _l10n.notificationVideoCallBody(caller)
      : _l10n.notificationAudioCallBody(caller);
}
