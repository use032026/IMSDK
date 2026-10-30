// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navWorkbench => 'Arbeitsbereich';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Kontodaten konnten nicht geladen werden';

  @override
  String get startupFailureTitle => 'Start fehlgeschlagen';

  @override
  String get startupFailureMessage => 'Netzwerk prüfen und erneut versuchen';

  @override
  String get privacyConsentTitle =>
      'Allgemeine Geschäftsbedingungen & Datenschutzerklärung';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Willkommen bei $brand. Für die Kontoanmeldung, Sofortnachrichten, die Zusammenarbeit im Unternehmen, den Online-Kundendienst, Nachrichtenbenachrichtigungen und den Sicherheitsschutz müssen wir gemäß den Nutzungsbedingungen und der Datenschutzerklärung erforderliche Informationen verarbeiten.\n\nBevor Sie auf „Zustimmen“ tippen, lesen wir keine Zwischenablagedaten, initialisieren weder JPush/JCore noch Push-SDKs der Gerätehersteller und greifen damit nicht auf Android ID, OAID, Listen installierter Apps, MAC-Adressen oder ähnliche Informationen zu. Wenn Sie vorerst ablehnen, speichern wir Ihre Entscheidung; Sie können die Dokumente weiterhin lesen und später erneut entscheiden.\n\nNach Ihrer Zustimmung können JPush/JCore und Push-Dienste der Gerätehersteller zur Zustellung von Nachrichten-, Kundendienst- und Anrufbenachrichtigungen Gerätemodell, Android-Version, App-Paket und -Version, Netzwerktyp, IP-Adresse, Android ID, OAID, Push-Registrierungs-ID, Hersteller-Push-Token sowie Zustellungs- und Klickdaten von Benachrichtigungen verarbeiten. Nicht erforderliche Funktionen wie intelligenter Push, Listen installierter Apps, MAC, IMEI, IMSI, WLAN-Listen, automatisches Aufwecken und verknüpfter Start sind deaktiviert.\n\nAuf die Zwischenablage wird nur zugegriffen, wenn Sie selbst kopieren oder einfügen. Kamera-, Mikrofon-, Benachrichtigungs- und andere Systemberechtigungen werden nur angefragt, wenn Sie die jeweilige Funktion aktiv nutzen. Die Verweigerung einer Berechtigung betrifft nur diese Funktion. Bitte lesen Sie die vollständigen Dokumente unten und entscheiden Sie, ob Sie zustimmen.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Willkommen bei $brand. Für die Kontoanmeldung, Sofortnachrichten, die Zusammenarbeit im Unternehmen, den Online-Kundendienst, Nachrichtenbenachrichtigungen und den Sicherheitsschutz müssen wir gemäß den Nutzungsbedingungen und der Datenschutzerklärung erforderliche Informationen verarbeiten.\n\nBevor Sie auf „Zustimmen“ tippen, lesen wir keine Zwischenablagedaten, initialisieren JPush/JCore nicht, registrieren uns nicht beim Apple Push Notification service (APNs) und beziehen keine Push-Kennungen wie die JPush-Registrierungs-ID oder das APNs-Gerätetoken. Wenn Sie vorerst ablehnen, speichern wir Ihre Entscheidung; Sie können die Dokumente weiterhin lesen und später erneut entscheiden.\n\nNach Ihrer Zustimmung können wir zur Zustellung von Nachrichten-, Kundendienst- und Anrufbenachrichtigungen iPhone-Modell, iOS-Version, App-Paket und -Version, Netzwerktyp, IP-Adresse, IDFV, JPush-Registrierungs-ID, APNs-Gerätetoken sowie Zustellungs- und Klickdaten von Benachrichtigungen verarbeiten. JPush/JCore stellt die Verbindung zum Push-Dienst her; Apple APNs verarbeitet die App-Kennung, das Gerätetoken und den Benachrichtigungsinhalt zur Zustellung von Systembenachrichtigungen. Die aktuelle iOS-App nutzt keine Werbedienste und bezieht keine IDFA.\n\nAuf die Zwischenablage wird nur zugegriffen, wenn Sie selbst kopieren oder einfügen. Kamera-, Mikrofon-, Benachrichtigungs- und andere Systemberechtigungen werden nur angefragt, wenn Sie die jeweilige Funktion aktiv nutzen. Die Verweigerung einer Berechtigung betrifft nur diese Funktion. Bitte lesen Sie die vollständigen Dokumente unten und entscheiden Sie, ob Sie zustimmen.';
  }

  @override
  String get privacyConsentTermsLink => 'Nutzungsbedingungen';

  @override
  String get privacyConsentConjunction => 'und';

  @override
  String get privacyConsentPrivacyLink => 'Datenschutzerklärung';

  @override
  String get privacyConsentDecline => 'Ablehnen';

  @override
  String get privacyConsentDeclinedExit =>
      'Sie haben den Nutzungsbedingungen und der Datenschutzerklärung nicht zugestimmt. Die App wird jetzt geschlossen.';

  @override
  String get privacyConsentAccept => 'Zustimmen';

  @override
  String get privacyConsentRuntimeFailure =>
      'Start fehlgeschlagen. Netzwerk prüfen und erneut versuchen.';

  @override
  String get privacyConsentSaveFailure =>
      'Ihre Entscheidung konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get appUpdateRequiredTitle =>
      'Zum Fortfahren ist ein Update erforderlich';

  @override
  String get appUpdateOptionalTitle => 'Neue Version verfügbar';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version ist verfügbar';
  }

  @override
  String get appUpdateLater => 'Später';

  @override
  String get appUpdateNow => 'Jetzt aktualisieren';

  @override
  String get appUpdateProcessing => 'Wird verarbeitet …';

  @override
  String get appUpdateInvalidUrl =>
      'Die Update-Adresse ist ungültig. Bitte später erneut versuchen.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Der Update-Link konnte nicht geöffnet werden. Bitte später erneut versuchen.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Download unterbrochen. Netzwerk prüfen und erneut versuchen.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Paketprüfung fehlgeschlagen. Bitte erneut herunterladen.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Erlauben Sie $brand in den Systemeinstellungen, Updates zu installieren.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Das Installationsprogramm konnte nicht geöffnet werden. Installationsberechtigungen prüfen.';

  @override
  String get appUpdateGenericFailure =>
      'Update fehlgeschlagen. Netzwerk prüfen und erneut versuchen.';

  @override
  String get appUpdateUnavailable =>
      'Die neue Version kann noch nicht heruntergeladen werden. Bitte später erneut versuchen.';

  @override
  String get appUpdateCheckFailed =>
      'Die Suche nach Updates ist fehlgeschlagen. Bitte später erneut versuchen.';

  @override
  String get appUpdateChecking => 'Wird geprüft';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonSearch => 'Suche';

  @override
  String get commonLoading => 'Wird geladen …';

  @override
  String get commonLoadFailed => 'Laden fehlgeschlagen';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonEmpty => 'Keine Daten';

  @override
  String get commonCopy => 'Kopieren';

  @override
  String get commonForward => 'Weiterleiten';

  @override
  String get commonFavorite => 'Speichern';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonSend => 'Senden';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonMore => 'Mehr';

  @override
  String get commonSettings => 'Einstellungen';

  @override
  String get commonCopied => 'Kopiert';

  @override
  String get commonUnknown => 'Unbekannt';

  @override
  String get commonNotSet => 'Nicht festgelegt';

  @override
  String get commonUnbound => 'Nicht verknüpft';

  @override
  String get commonViewAll => 'Alle anzeigen';

  @override
  String get commonSubmit => 'Absenden';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonRemove => 'Entfernen';

  @override
  String get commonCreate => 'Erstellen';

  @override
  String get commonUpdate => 'Aktualisieren';

  @override
  String get commonUpload => 'Hochladen';

  @override
  String get commonShare => 'Teilen';

  @override
  String get commonBlock => 'Blockieren';

  @override
  String get commonUnblock => 'Blockierung aufheben';

  @override
  String get commonMute => 'Stummschalten';

  @override
  String get commonUnmute => 'Stummschaltung aufheben';

  @override
  String get commonPin => 'Angeheftet';

  @override
  String get commonUnpin => 'Fixierung lösen';

  @override
  String get commonMarkRead => 'Als gelesen markieren';

  @override
  String get commonMarkUnread => 'Als ungelesen markieren';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed =>
      'Vorgang fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get commonNetworkError => 'Netzwerkfehler. Bitte Verbindung prüfen.';

  @override
  String get navMessages => 'Nachrichten';

  @override
  String get navContacts => 'Kontakte';

  @override
  String get navMe => 'Ich';

  @override
  String get authLoginTitle => 'Bei StartLink anmelden';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'E-Mail';

  @override
  String get authTabLoginName => 'StartLink-ID';

  @override
  String get authHintMobile => 'Telefonnummer eingeben';

  @override
  String get authHintEmail => 'Geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get authHintPassword => 'Passwort eingeben';

  @override
  String get authHintCode => 'Bestätigungscode eingeben';

  @override
  String get authHintLoginName => 'StartLink-ID eingeben (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Anmelden';

  @override
  String get authGetCode => 'Code anfordern';

  @override
  String authResendCode(int seconds) {
    return 'In $seconds s erneut senden';
  }

  @override
  String get authUsePassword => 'Passwort verwenden';

  @override
  String get authUseCode => 'Bestätigungscode verwenden';

  @override
  String get authAgreementPrefix =>
      'Ich habe Folgendes gelesen und stimme zu: ';

  @override
  String get authAgreementAnd => 'und';

  @override
  String get authTermsLink => 'Nutzungsbedingungen';

  @override
  String get authPrivacyLink => 'Datenschutzerklärung';

  @override
  String get authCaptchaTitle => 'Sicherheitsprüfung';

  @override
  String get authCaptchaHint => 'Antwort eingeben';

  @override
  String get authCaptchaFailed =>
      'Captcha konnte nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get authErrorEmptyCode => 'Bitte Bestätigungscode eingeben';

  @override
  String get authErrorEmptyPassword => 'Passwort eingeben';

  @override
  String get authErrorEmptyLoginName => 'Bitte StartLink-ID eingeben';

  @override
  String get authErrorWrongCredentials => 'Konto oder Passwort ist falsch';

  @override
  String get authDeactivatingTitle => 'Kontolöschung';

  @override
  String get authDeactivatingContent =>
      'Ihr Konto befindet sich in der Wartefrist für die Löschung (7 Tage).\n\nTippen Sie auf „Löschung abbrechen“, um die Löschung abzubrechen, oder auf „Weiter“, um die App zu öffnen.';

  @override
  String get authContinueUse => 'Weiter';

  @override
  String get authCancelDeactivation => 'Löschung abbrechen';

  @override
  String get authDeactivationCancelled =>
      'Löschung abgebrochen, Konto wiederhergestellt';

  @override
  String get authDeactivationCancelFailed =>
      'Abbrechen fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get authLogout => 'Abmelden';

  @override
  String get authLogoutConfirm => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get authSendingCode => 'Wird gesendet …';

  @override
  String get authCodeSent => 'Bestätigungscode gesendet';

  @override
  String get authLoginFailed =>
      'Anmeldung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get authRegisterFailed =>
      'Registrierung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get authEnterpriseCode => 'Unternehmenscode';

  @override
  String get authEnterpriseCodeHint => 'Unternehmenscode eingeben';

  @override
  String get authPendingApproval =>
      'Registrierung erfolgreich. Ihr Antrag auf Beitritt zum Unternehmen wurde eingereicht und wartet auf Genehmigung.';

  @override
  String get authNoAccount => 'Noch kein Konto?';

  @override
  String get authRegisterNow => 'Jetzt registrieren';

  @override
  String get authCountryPickerTitle => 'Land/Region auswählen';

  @override
  String get authCountrySearchHint => 'Land/Region suchen';

  @override
  String get authCountryChinaMainland => 'Festlandchina';

  @override
  String get authCountryHongKong => 'Hongkong, China';

  @override
  String get authCountryMacau => 'Macau, China';

  @override
  String get authCountryTaiwan => 'Taiwan, China';

  @override
  String get authCountryUnitedStates => 'Vereinigte Staaten';

  @override
  String get authCountryUnitedKingdom => 'Vereinigtes Königreich';

  @override
  String get authCountryJapan => 'Japan';

  @override
  String get authCountrySouthKorea => 'Südkorea';

  @override
  String get authCountrySingapore => 'Singapur';

  @override
  String get authCountryMalaysia => 'Malaysia';

  @override
  String get authCountryAustralia => 'Australien';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Deutschland';

  @override
  String get authCountryFrance => 'Frankreich';

  @override
  String get authCountryIndia => 'Indien';

  @override
  String get authCountryThailand => 'Thailand';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesien';

  @override
  String get authCountryPhilippines => 'Philippinen';

  @override
  String get authQuickLoginTitle => 'Schnellanmeldung';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Anmeldung läuft. Bitte warten.';

  @override
  String get authRoleOwner => 'Inhaber';

  @override
  String get authRoleAdministrator => 'Administrator';

  @override
  String get authRoleCustomerService => 'Kundendienst';

  @override
  String get authRoleTechnicalSupport => 'Technischer Support';

  @override
  String get authRoleEmployee => 'Mitarbeiter';

  @override
  String get authRoleMember => 'Mitglied';

  @override
  String get authRoleEnterpriseCustomer => 'Unternehmenskunde';

  @override
  String get authUnavailablePrefix => 'Nicht verfügbar · ';

  @override
  String get authUnassignedService => 'Kein Kundenberater zugewiesen';

  @override
  String authAssignedService(String staff) {
    return '$staff zugewiesen';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Kunde · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Mitarbeiter · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count Benutzer';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Identität';

  @override
  String get authRegisterTitle => 'Registrieren';

  @override
  String get authNickname => 'Spitzname';

  @override
  String get authNicknameHint => 'Spitznamen festlegen';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authPasswordSetHint => 'Passwort festlegen (mindestens 6 Zeichen)';

  @override
  String get authConfirmPassword => 'Passwort bestätigen';

  @override
  String get authConfirmPasswordHint => 'Passwort erneut eingeben';

  @override
  String get authVerificationCode => 'Bestätigungscode';

  @override
  String get authRegisterAndLogin => 'Registrieren und anmelden';

  @override
  String get authHaveAccount => 'Bereits ein Konto?';

  @override
  String get authGoLogin => 'Anmelden';

  @override
  String get authEmailVerificationUnavailable =>
      'E-Mail-Bestätigung ist nicht verfügbar. Registrieren Sie sich stattdessen mit einer Mobilnummer.';

  @override
  String get authSmsVerificationUnavailable =>
      'SMS-Bestätigung ist nicht verfügbar. Registrieren Sie sich stattdessen mit einer E-Mail-Adresse.';

  @override
  String get authSendFailed => 'Senden fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get authErrorEmptyNickname => 'Spitznamen eingeben';

  @override
  String get authErrorInvalidMobile => 'Gültige Mobilnummer eingeben';

  @override
  String get authErrorInvalidEmail => 'Gültige E-Mail-Adresse eingeben';

  @override
  String get authErrorPasswordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen enthalten';

  @override
  String get authErrorPasswordMismatch =>
      'Die Passwörter stimmen nicht überein';

  @override
  String get authErrorVerificationRequired =>
      'Bitte zuerst den Bestätigungscode anfordern und eingeben';

  @override
  String get authRegisterErrorTitle => 'Registrierung fehlgeschlagen';

  @override
  String get authGotIt => 'Verstanden';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Unternehmen „$code“ nicht gefunden. Bitte Unternehmenscode prüfen.';
  }

  @override
  String get authTenantSearchFailed =>
      'Suche fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get authInvitationInvalid =>
      'Der Einladungscode ist ungültig. Bitte prüfen und erneut versuchen.';

  @override
  String get authCollapseJoin => 'Beitrittsinformationen ausblenden';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Gültige Einladung: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Unternehmen gefunden: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Organisation auswählen';

  @override
  String get authNoOrganization => 'Keine Organisationen verfügbar';

  @override
  String get authNoOrganizationHint =>
      'Bitten Sie einen Administrator um eine Einladung in eine Organisation';

  @override
  String get authPersonalSpace => 'Persönlicher Bereich';

  @override
  String get authPersonalSpaceSubtitle =>
      'Chats mit Freunden und persönliche Favoriten';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Die Bereichsidentität konnte nicht geprüft werden. Bitte erneut versuchen.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Der persönliche Bereich konnte nicht wiederhergestellt werden. Bitte erneut versuchen.';

  @override
  String get authJoinEnterpriseFailed =>
      'Beitritt zum Unternehmen fehlgeschlagen. Bitte später erneut versuchen.';

  @override
  String get homeTitle => 'Nachrichten';

  @override
  String get homeGatewayConnectingTitle => 'Verbindung wird hergestellt';

  @override
  String get homePersonalSpace => 'Persönlich';

  @override
  String get homeOfficialService => 'Offizieller Service';

  @override
  String get homeSwitchSpace => 'Bereich wechseln';

  @override
  String get homeSpaceSubtitle => 'Persönlich · Unternehmen';

  @override
  String get homeJoinEnterprise => 'Unternehmen beitreten';

  @override
  String get homeCreateGroup => 'Neue Gruppe';

  @override
  String get homeAddFriend => 'Kontakt hinzufügen';

  @override
  String get homeScan => 'Scannen';

  @override
  String get homeJoinNewSpace => 'Neuem Bereich beitreten';

  @override
  String get homeSearchConversation => 'Suchen';

  @override
  String get homeNoMessages => 'Keine Nachrichten';

  @override
  String get homeDeleteConversation => 'Chat löschen';

  @override
  String get homeDeleteConversationConfirm =>
      'Diesen Chat löschen? Der Chatverlauf wird geleert.';

  @override
  String get homePersonalNote => 'Ich (persönliche Notizen)';

  @override
  String get homeWorkNote => 'Ich (Arbeitsnotizen)';

  @override
  String homeConversationCount(int count) {
    return '$count Chats';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count ungelesen';
  }

  @override
  String get chatInputHint => 'Nachricht eingeben …';

  @override
  String get chatVoiceHint => 'Zum Sprechen gedrückt halten';

  @override
  String get chatVoiceRelease => 'Zum Senden loslassen';

  @override
  String get chatVoiceCancel => 'Zum Abbrechen nach oben wischen';

  @override
  String get chatMenuCopy => 'Kopieren';

  @override
  String get chatMenuForward => 'Weiterleiten';

  @override
  String get chatMenuRecall => 'Zurückrufen';

  @override
  String get chatMenuDelete => 'Löschen';

  @override
  String get chatMenuFavorite => 'Speichern';

  @override
  String get chatMenuReply => 'Antworten';

  @override
  String get chatMenuMultiSelect => 'Auswählen';

  @override
  String get chatMenuTranslate => 'Übersetzen';

  @override
  String get chatMenuVoiceToText => 'In Text umwandeln';

  @override
  String get chatMenuTextToSpeech => 'Vorlesen';

  @override
  String get chatStatusRecalled => 'Nachricht zurückgerufen';

  @override
  String get chatRecallSuccess => 'Zurückgerufen';

  @override
  String get chatRecallFailed => 'Zurückrufen fehlgeschlagen';

  @override
  String get chatRecallTimeout =>
      'Nachrichten können nach 2 Minuten nicht mehr zurückgerufen werden';

  @override
  String get chatTranslateFailed =>
      'Übersetzung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get chatTranslateNotConfigured => 'Übersetzungsdienst nicht verfügbar';

  @override
  String get chatVoiceToTextFailed =>
      'Umwandlung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get chatTextToSpeechFailed =>
      'Vorlesen fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get chatVoiceToText => 'Umwandeln';

  @override
  String get chatForwardSuccess => 'Weitergeleitet';

  @override
  String get chatForwardFailed =>
      'Weiterleiten fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get chatNoConversations => 'Keine Chats zum Weiterleiten';

  @override
  String get chatSendFailed => 'Senden fehlgeschlagen';

  @override
  String get chatResend => 'Code erneut senden';

  @override
  String get chatNotFriend => 'Nicht in der Kontaktliste';

  @override
  String get chatNotFriendHint =>
      'Sie sind noch keine Kontakte. Nachrichten können nicht gesendet werden.';

  @override
  String get chatMutedHint => 'Alle Mitglieder sind stummgeschaltet';

  @override
  String get chatFileUploadFailed =>
      'Datei-Upload fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get chatFileStatusNotDownloaded => 'Nicht heruntergeladen';

  @override
  String get chatFileStatusDownloaded => 'Heruntergeladen';

  @override
  String get chatFileStatusUploading => 'Wird hochgeladen';

  @override
  String get chatFileStatusUploadFailed => 'Upload fehlgeschlagen';

  @override
  String get chatCardSendFailed => 'Kontaktkarte konnte nicht gesendet werden';

  @override
  String get chatFavoriteSuccess => 'Gespeichert';

  @override
  String get chatFavoriteFailed => 'Hinzufügen zu Favoriten fehlgeschlagen';

  @override
  String get chatLoadFailed => 'Laden fehlgeschlagen';

  @override
  String get chatImageMessage => '[Bild]';

  @override
  String get chatVoiceMessage => '[Sprachnachricht]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Datei]';

  @override
  String get chatLocationMessage => '[Standort]';

  @override
  String get chatContactCardMessage => '[Kontakt]';

  @override
  String get chatCallLogMessage => '[Anruf]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Von $count gelesen';
  }

  @override
  String get chatUnread => 'Ungelesen';

  @override
  String get chatRecalledSelf => 'Sie haben eine Nachricht zurückgerufen';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender hat eine Nachricht zurückgerufen';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Übersetzung: $translation';
  }

  @override
  String get chatMessageDeleted => 'Nachricht gelöscht';

  @override
  String get chatPeer => 'Gegenüber';

  @override
  String get chatSelf => 'Ich';

  @override
  String get chatGenericMessage => '[Nachricht]';

  @override
  String get chatVoiceHideText => 'Text ausblenden';

  @override
  String get chatVoiceShowText => 'In Text umwandeln';

  @override
  String get chatFileDefaultName => 'Datei';

  @override
  String get chatContactDefaultName => 'Kontakt';

  @override
  String get chatContactCardTitle => 'Kontaktkarte';

  @override
  String get chatCallMissed => 'Verpasst';

  @override
  String get chatCallCancelled => 'Abgebrochen';

  @override
  String get chatCallRejected => 'Abgelehnt';

  @override
  String get chatCallDisconnected => 'Verbindung getrennt';

  @override
  String get chatCallEnded => 'Anruf beendet';

  @override
  String get chatCallFailed => 'Anruf fehlgeschlagen';

  @override
  String chatCallDuration(String duration) {
    return 'Dauer $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videoanruf';

  @override
  String get chatVoiceCallTitle => 'Sprachanruf';

  @override
  String get chatToolPhotos => 'Fotos';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Datei';

  @override
  String get chatToolLocation => 'Standort';

  @override
  String get chatToolContactCard => 'Kontakt';

  @override
  String get chatToolVoiceCall => 'Sprachanruf';

  @override
  String get chatToolVideoCall => 'Videoanruf';

  @override
  String get chatToolFavorites => 'Favoriten';

  @override
  String get chatToolTranslate => 'Übersetzen';

  @override
  String get chatTranslationChooseLanguage => 'Übersetzungssprache auswählen';

  @override
  String get chatTranslationEnterText => 'Bitte zuerst Text eingeben';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Nachrichten mit Erwähnungen können nicht übersetzt werden';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Beim Bearbeiten einer geplanten Nachricht ist keine Übersetzung möglich';

  @override
  String get chatTranslationFailed =>
      'Übersetzung fehlgeschlagen. Erneut versuchen.';

  @override
  String get chatTranslationEmpty =>
      'Keine Übersetzung erhalten. Erneut versuchen.';

  @override
  String get chatTranslationTranslating => 'Wird übersetzt …';

  @override
  String get chatTranslationSend => 'Übersetzung senden';

  @override
  String get chatTranslationSending => 'Wird gesendet …';

  @override
  String get chatTranslationExpand => 'Mehr anzeigen';

  @override
  String get chatTranslationCollapse => 'Weniger anzeigen';

  @override
  String get chatFileTooLarge =>
      'Die Datei überschreitet die Grenze von 100 MB';

  @override
  String get chatInputMutedAdminOnly =>
      'Nur der Inhaber oder ausgewählte Mitglieder dürfen schreiben.';

  @override
  String get chatImageUploadUnsupported =>
      'Bild-Upload fehlgeschlagen. Der Server unterstützt diese Funktion noch nicht.';

  @override
  String get chatFavoriteLongPressHint =>
      'Nachricht gedrückt halten, um sie zu den Favoriten hinzuzufügen';

  @override
  String chatSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get chatLocationSheetTitle => 'Standort senden';

  @override
  String get chatLocationNameLabel => 'Ortsname';

  @override
  String get chatLocationNameHint => 'z. B. Büro, Kundenadresse';

  @override
  String get chatLocationAddressLabel => 'Adresse';

  @override
  String get chatLocationOptionalHint => 'Optional';

  @override
  String get chatLocationLatitudeLabel => 'Breitengrad';

  @override
  String get chatLocationLatitudeHint => '-90 bis 90';

  @override
  String get chatLocationLongitudeLabel => 'Längengrad';

  @override
  String get chatLocationLongitudeHint => '-180 bis 180';

  @override
  String chatLocationValidationRequired(String label) {
    return '$label eingeben';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label liegt außerhalb des zulässigen Bereichs';
  }

  @override
  String get chatLocationDefaultTitle => 'Standort';

  @override
  String get chatMutedFullNotice =>
      'Diese Gruppe ist stummgeschaltet. Nur der Inhaber oder ausgewählte Mitglieder dürfen schreiben.';

  @override
  String get chatNotFriendSendBlocked =>
      'Sie sind nicht mehr befreundet und können keine Nachrichten senden';

  @override
  String get chatPersonalNotesTitle => 'Persönliche Notizen';

  @override
  String get chatWorkNotesTitle => 'Arbeitsnotizen';

  @override
  String get chatPersonalNotesDescription =>
      'Halten Sie hier persönliche Gedanken und wichtige Informationen fest\nGeräteübergreifend synchronisiert und jederzeit verfügbar';

  @override
  String get chatWorkNotesDescription =>
      'Halten Sie hier Aufgaben und Arbeitsunterlagen fest\nTeambereiche bleiben getrennt und sicher';

  @override
  String get chatNoMessages => 'Keine Nachrichten';

  @override
  String chatReplyTo(String sender) {
    return '$sender antworten';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature ist demnächst verfügbar';
  }

  @override
  String get chatForwardSelectTitle => 'Chat auswählen';

  @override
  String get chatContactSelectTitle => 'Kontakt auswählen';

  @override
  String get chatNoContacts => 'Keine Kontakte';

  @override
  String get contactsTitle => 'Kontakte';

  @override
  String get contactsSearch => 'Kontakte suchen';

  @override
  String get contactsNewFriends => 'Neue Freunde';

  @override
  String get contactsGroups => 'Gruppen';

  @override
  String get contactsFavorites => 'Favoriten';

  @override
  String get contactsRecent => 'Zuletzt';

  @override
  String get contactsOrganization => 'Organisation';

  @override
  String get contactsAnnouncement => 'Ankündigungen';

  @override
  String get contactsNewApplications => 'Neue Anfragen';

  @override
  String get contactsCustomerGroups => 'Kundengruppen';

  @override
  String get contactsAllCustomers => 'Alle Kunden';

  @override
  String get contactsMyCustomers => 'Meine Kunden';

  @override
  String get contactsViewAll => 'Alle anzeigen';

  @override
  String get contactsMyContacts => 'Meine Kontakte';

  @override
  String get contactsMyAdvisor => 'Mein Berater';

  @override
  String get contactsNoAdvisor => 'Noch kein Berater zugewiesen';

  @override
  String get contactsAdvisorLoading => 'Wird geladen …';

  @override
  String get contactsNavigateFailed =>
      'Navigation fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get contactsEmpty => 'Keine Kontakte';

  @override
  String get contactsNoAnnouncement => 'Keine Ankündigungen';

  @override
  String get contactsOfficialBadge => 'Offiziell';

  @override
  String get contactsCustomerBadge => 'Kunde';

  @override
  String get contactsEmptyCustomers => 'Keine Kunden';

  @override
  String get myTitle => 'Ich';

  @override
  String get myEnterpriseInfo => 'Unternehmensinformationen';

  @override
  String get myEnterpriseManage => 'Unternehmensverwaltung';

  @override
  String get myQrCode => 'QR-Code';

  @override
  String get myFavorites => 'Favoriten';

  @override
  String get myLanguage => 'Sprache';

  @override
  String get myTimezone => 'Zeitzone';

  @override
  String get myAutoTranslate => 'Automatische Übersetzung';

  @override
  String get myNetworkSwitch => 'Leitung wechseln';

  @override
  String get mySettings => 'Einstellungen';

  @override
  String get myLogout => 'Abmelden';

  @override
  String get myLogoutConfirm => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get myLeaveEnterprise => 'Unternehmen verlassen';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Möchten Sie dieses Unternehmen wirklich verlassen? Sie verlieren den Zugriff auf die Unternehmensdaten.';

  @override
  String get myLeaveEnterpriseSuccess => 'Unternehmen verlassen';

  @override
  String get myLeaveEnterpriseFailed =>
      'Verlassen fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get myLppIdCopied => 'StartLink-ID kopiert';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink-ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count Kontakte';
  }

  @override
  String get myAutoSelect => 'Automatisch';

  @override
  String get myPresenceStatus => 'Anwesenheitsstatus';

  @override
  String get myPresenceStatusTitle => 'Anwesenheitsstatus festlegen';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Beschäftigt';

  @override
  String get myPresenceAway => 'Abwesend';

  @override
  String get myPresenceInvisible => 'Unsichtbar';

  @override
  String get profileTitle => 'Mein Profil';

  @override
  String get profileName => 'Name';

  @override
  String get profileGender => 'Geschlecht';

  @override
  String get profileBirthday => 'Geburtstag';

  @override
  String get profileRegion => 'Region';

  @override
  String get profileSignature => 'Profiltext';

  @override
  String get profileSignatureHint => 'Erzählen Sie etwas über sich';

  @override
  String get profileTapTapText => 'Antippen';

  @override
  String get profileTapTapHint => 'Text beim Antippen (max. 20 Zeichen)';

  @override
  String get profileAccountSection => 'Konto';

  @override
  String get profileBasicSection => 'Allgemeine Informationen';

  @override
  String get profileLppId => 'StartLink-ID';

  @override
  String get profileLppIdNotSet => 'Nicht festgelegt';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Nicht verknüpft';

  @override
  String get profileEmail => 'E-Mail';

  @override
  String get profileEmailUnbound => 'Nicht verknüpft';

  @override
  String get profileQrCode => 'Mein QR-Code';

  @override
  String get profileChangePassword => 'Passwort ändern';

  @override
  String get profileGenderMale => 'Männlich';

  @override
  String get profileGenderFemale => 'Weiblich';

  @override
  String get profileGenderOther => 'Sonstiges';

  @override
  String get profileGenderUnset => 'Nicht festgelegt';

  @override
  String get profileSaveFailed =>
      'Speichern fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get profileLppIdTitle => 'StartLink-ID';

  @override
  String get profileLppIdSetOnce =>
      'Die StartLink-ID kann nur einmal geändert werden. Bitte sorgfältig wählen.';

  @override
  String get profileLppIdChangeFailed =>
      'Änderung fehlgeschlagen (StartLink-ID kann nur einmal geändert werden)';

  @override
  String get profileChangePasswordOld => 'Aktuelles Passwort';

  @override
  String get profileChangePasswordNew => 'Neues Passwort';

  @override
  String get profileChangePasswordConfirm => 'Neues Passwort bestätigen';

  @override
  String get profileChangePasswordMismatch =>
      'Die Passwörter stimmen nicht überein';

  @override
  String get profileChangePasswordSuccess =>
      'Passwort geändert. Bitte erneut anmelden.';

  @override
  String get profileChangePasswordFailed =>
      'Passwortänderung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionEnterprise => 'Unternehmen';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsSectionGeneral => 'Allgemein';

  @override
  String get settingsSectionFeatures => 'Funktionen';

  @override
  String get settingsSectionAbout => 'Über';

  @override
  String get settingsEnterpriseInfo => 'Unternehmensinformationen';

  @override
  String get settingsProfile => 'Mein Profil';

  @override
  String get settingsAccountSecurity => 'Kontosicherheit';

  @override
  String get settingsNotification => 'Benachrichtigungen';

  @override
  String get settingsDisplay => 'Anzeige';

  @override
  String get settingsFriendPrivacy => 'Datenschutz';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Chatverlauf';

  @override
  String get settingsAbout => 'Über StartLink';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsTimezone => 'Zeitzone';

  @override
  String get settingsAutoTranslate => 'Automatische Übersetzung';

  @override
  String get settingsNetworkSwitch => 'Leitung wechseln';

  @override
  String get enterpriseInfoTitle => 'Unternehmensinformationen';

  @override
  String get enterpriseName => 'Name';

  @override
  String get enterpriseDescription => 'Beschreibung';

  @override
  String get enterpriseUpdateSuccess => 'Erfolgreich aktualisiert';

  @override
  String get enterpriseUpdateFailed =>
      'Aktualisierung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get enterpriseLeave => 'Unternehmen verlassen';

  @override
  String get enterpriseLeaveConfirm =>
      'Möchten Sie dieses Unternehmen wirklich verlassen?';

  @override
  String get enterpriseLeaveSuccess => 'Unternehmen verlassen';

  @override
  String get enterpriseLeaveFailed =>
      'Verlassen fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Der Inhaber kann nicht direkt austreten. Bitte zuerst die Inhaberschaft übertragen.';

  @override
  String get enterpriseMemberCount => 'Mitglieder';

  @override
  String get enterpriseCreatedAt => 'Erstellt';

  @override
  String get enterpriseCode => 'Unternehmenscode';

  @override
  String get enterpriseInviteMembers => 'Mitglieder einladen';

  @override
  String get enterpriseCopyInviteCode => 'Einladungscode kopieren';

  @override
  String get enterpriseInviteCodeCopied => 'Einladungscode kopiert';

  @override
  String get groupCreateTitle => 'Neue Gruppe';

  @override
  String get groupNameHint => 'Gruppennamen eingeben';

  @override
  String get groupCreateSuccess => 'Gruppe erstellt';

  @override
  String get groupCreateFailed => 'Gruppe konnte nicht erstellt werden';

  @override
  String get groupSettings => 'Gruppeneinstellungen';

  @override
  String get groupName => 'Gruppenname';

  @override
  String get groupAvatar => 'Gruppenbild';

  @override
  String get groupAnnouncement => 'Ankündigung';

  @override
  String get groupMembers => 'Mitglieder';

  @override
  String get groupAddMember => 'Mitglieder hinzufügen';

  @override
  String get groupRemoveMember => 'Mitglied entfernen';

  @override
  String get groupRemoveMemberConfirm => 'Dieses Mitglied entfernen?';

  @override
  String get groupSetAdmin => 'Zum Administrator ernennen';

  @override
  String get groupRemoveAdmin => 'Administratorrechte entziehen';

  @override
  String get groupTransferOwner => 'Inhaberschaft übertragen';

  @override
  String get groupTransferOwnerConfirm =>
      'Die Gruppeninhaberschaft auf dieses Mitglied übertragen?';

  @override
  String get groupTransferOwnerSuccess => 'Inhaberschaft übertragen';

  @override
  String get groupTransferOwnerFailed =>
      'Übertragung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get groupLeave => 'Gruppe verlassen';

  @override
  String get groupLeaveConfirm => 'Diese Gruppe verlassen?';

  @override
  String get groupLeaveSuccess => 'Gruppe verlassen';

  @override
  String get groupLeaveFailed =>
      'Verlassen fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get groupDissolve => 'Gruppe auflösen';

  @override
  String get groupDissolveConfirm =>
      'Diese Gruppe auflösen? Alle Mitglieder werden entfernt.';

  @override
  String get groupDissolveSuccess => 'Gruppe aufgelöst';

  @override
  String get groupDissolveFailed =>
      'Auflösen fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get groupQrCode => 'Gruppen-QR-Code';

  @override
  String get groupMuteAll => 'Alle stummschalten';

  @override
  String get groupMuteAllOn => 'Stummschaltung aller aktivieren';

  @override
  String get groupMuteAllOff => 'Stummschaltung aller aufheben';

  @override
  String get groupAllowMemberInvite => 'Einladungen durch Mitglieder erlauben';

  @override
  String get groupAllowMemberModifyTitle =>
      'Mitgliedern erlauben, den Gruppennamen zu ändern';

  @override
  String get groupAllowMemberAtAll => 'Mitgliedern @Alle erlauben';

  @override
  String get groupAllowMemberViewMemberList =>
      'Mitgliedern die Mitgliederliste anzeigen';

  @override
  String get groupAllowQrCodeJoin => 'Beitritt per QR-Code erlauben';

  @override
  String get groupRequireApproval => 'Beitritt genehmigungspflichtig';

  @override
  String get groupAllowMemberAddFriend =>
      'Mitglieder dürfen einander als Freunde hinzufügen';

  @override
  String get groupRoleOwner => 'Inhaber';

  @override
  String get groupRoleAdmin => 'Administrator';

  @override
  String get groupRoleMember => 'Mitglied';

  @override
  String get groupNoMembers => 'Keine Mitglieder';

  @override
  String get groupNoAnnouncements => 'Keine Ankündigungen';

  @override
  String get groupCreateAnnouncement => 'Ankündigung veröffentlichen';

  @override
  String get groupEditAnnouncement => 'Ankündigung bearbeiten';

  @override
  String get groupDeleteAnnouncement => 'Ankündigung löschen';

  @override
  String get groupDeleteAnnouncementConfirm => 'Diese Ankündigung löschen?';

  @override
  String get groupAnnouncementTitle => 'Titel';

  @override
  String get groupAnnouncementContent => 'Inhalt';

  @override
  String get groupAnnouncementPin => 'Ankündigung fixieren';

  @override
  String groupMemberCount(int count) {
    return '$count Mitglieder';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get groupJoinRequestApprove => 'Zustimmen';

  @override
  String get groupJoinRequestReject => 'Ablehnen';

  @override
  String get groupJoinRequests => 'Beitrittsanfragen';

  @override
  String get groupNoJoinRequests => 'Keine Beitrittsanfragen';

  @override
  String get groupReadReceipts => 'Lesebestätigungen';

  @override
  String groupReadCount(int count) {
    return '$count gelesen';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count ungelesen';
  }

  @override
  String get friendAddTitle => 'Kontakt hinzufügen';

  @override
  String get friendSearchHint => 'Telefon / E-Mail / StartLink-ID';

  @override
  String get friendRequestSent => 'Freundschaftsanfrage gesendet';

  @override
  String get friendRequestFailed =>
      'Senden fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get friendAlreadyFriend => 'Bereits Kontakte';

  @override
  String get friendNewFriendsTitle => 'Neue Freunde';

  @override
  String get friendNoRequests => 'Keine Freundschaftsanfragen';

  @override
  String get friendAccept => 'Annehmen';

  @override
  String get friendReject => 'Ablehnen';

  @override
  String get friendAccepted => 'Angenommen';

  @override
  String get friendRejected => 'Abgelehnt';

  @override
  String get friendDeleteConfirm => 'Diesen Kontakt entfernen?';

  @override
  String get friendDeleteSuccess => 'Kontakt entfernt';

  @override
  String get friendDeleteFailed =>
      'Entfernen fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get friendRemarkName => 'Kontaktname';

  @override
  String get friendGroupName => 'Gruppe';

  @override
  String get friendSendMessage => 'Nachricht';

  @override
  String get friendMatchTypeLppId => 'Über StartLink-ID gefunden';

  @override
  String get friendMatchTypeMobile => 'Über Telefonnummer gefunden';

  @override
  String get friendMatchTypeEmail => 'Über E-Mail gefunden';

  @override
  String get friendSearchEmpty => 'Keine Benutzer gefunden';

  @override
  String get friendAddMessage => 'Ich möchte Sie als Kontakt hinzufügen';

  @override
  String get friendBlockConfirm => 'Diesen Benutzer blockieren?';

  @override
  String get friendUnblockConfirm => 'Blockierung dieses Benutzers aufheben?';

  @override
  String get friendBlockSuccess => 'Blockiert';

  @override
  String get friendUnblockSuccess => 'Blockierung aufgehoben';

  @override
  String get profilePageTitle => 'Persönliche Daten';

  @override
  String get profilePageSendMessage => 'Nachricht';

  @override
  String get profilePageAddFriend => 'Freund hinzufügen';

  @override
  String get profilePageAlreadyFriend => 'Bereits befreundet';

  @override
  String get profilePageBlocked => 'Blockiert';

  @override
  String get profilePageBlock => 'Blockieren';

  @override
  String get profilePageUnblock => 'Blockierung aufheben';

  @override
  String get profilePageHidden => 'Dieser Benutzer hat sein Profil verborgen';

  @override
  String get profilePageFriendsOnly =>
      'Dieser Benutzer zeigt sein Profil nur Freunden';

  @override
  String get profilePageLppId => 'StartLink-ID';

  @override
  String get profilePageRemarkName => 'Bemerkungen';

  @override
  String get profilePageEditRemark => 'Kontaktnamen bearbeiten';

  @override
  String get profilePageSaveRemarkSuccess => 'Kontaktname gespeichert';

  @override
  String get profilePageSaveRemarkFailed =>
      'Speichern fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get searchTitle => 'Suche';

  @override
  String get searchHint => 'Nach Telefon, E-Mail oder StartLink-ID suchen';

  @override
  String get searchNoResults => 'Keine Ergebnisse gefunden';

  @override
  String get searchMessages => 'Nachrichten';

  @override
  String get searchUsers => 'Benutzer';

  @override
  String get searchFailed => 'Suche fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get scanTitle => 'Scannen';

  @override
  String get scanFailed => 'Erkennung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get scanInvalidQrCode => 'Ungültiger QR-Code';

  @override
  String get scanFlashOn => 'Taschenlampe einschalten';

  @override
  String get scanFlashOff => 'Taschenlampe ausschalten';

  @override
  String get scanAlbum => 'Aus Album auswählen';

  @override
  String get favoritesTitle => 'Favoriten';

  @override
  String get favoritesEmpty => 'Noch nichts gespeichert';

  @override
  String get favoritesAll => 'Alle';

  @override
  String get favoritesText => 'Text';

  @override
  String get favoritesImage => 'Bilder';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Sprachnachrichten';

  @override
  String get favoritesFile => 'Dateien';

  @override
  String get favoritesOther => 'Sonstiges';

  @override
  String get favoritesDeleteConfirm => 'Aus den Favoriten entfernen?';

  @override
  String get favoritesDeleteSuccess => 'Aus den Gespeicherten entfernt';

  @override
  String get favoritesDeleteFailed => 'Entfernen fehlgeschlagen';

  @override
  String get favoritesOriginalRecalled => 'Nachricht zurückgerufen';

  @override
  String get favoritesViewOriginal => 'Original anzeigen';

  @override
  String get favoritesSearchHint => 'Favoriten durchsuchen';

  @override
  String get favoritesNoResults => 'Keine passenden Favoriten';

  @override
  String get noticeTitle => 'Ankündigungen';

  @override
  String get noticeEmpty => 'Keine Ankündigungen';

  @override
  String get noticeDetail => 'Details der Ankündigung';

  @override
  String get noticePublishedAt => 'Veröffentlicht';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Wichtig';

  @override
  String get noticePriorityUrgent => 'Dringend';

  @override
  String get organizationTitle => 'Organisation';

  @override
  String get organizationEmpty => 'Keine Abteilungsinformationen';

  @override
  String get organizationMembers => 'Mitglieder';

  @override
  String get organizationDepartment => 'Abteilung';

  @override
  String get organizationPosition => 'Position';

  @override
  String get organizationLeader => 'Leitung';

  @override
  String get qrCodeTitle => 'Mein QR-Code';

  @override
  String get qrCodeSave => 'In Album speichern';

  @override
  String get qrCodeShare => 'Teilen';

  @override
  String get qrCodeSaveSuccess => 'Im Album gespeichert';

  @override
  String get qrCodeSaveFailed =>
      'Speichern fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get qrCodeRefresh => 'QR-Code aktualisieren';

  @override
  String get qrCodeExpired => 'QR-Code abgelaufen. Bitte aktualisieren.';

  @override
  String get qrCodeScanToAdd => 'Scannen, um mich als Kontakt hinzuzufügen';

  @override
  String get spacePersonal => 'Persönlich';

  @override
  String get spaceEnterprise => 'Unternehmen';

  @override
  String get spaceJoinByCode => 'Mit Unternehmenscode beitreten';

  @override
  String get spaceJoinByInvite => 'Mit Einladungscode beitreten';

  @override
  String get spaceEnterCode => 'Unternehmenscode eingeben';

  @override
  String get spaceEnterInviteCode => 'Einladungscode eingeben';

  @override
  String get spaceSearchEnterprise => 'Unternehmen suchen';

  @override
  String get spaceJoinRequestSent =>
      'Anfrage eingereicht, Genehmigung ausstehend';

  @override
  String get spaceJoinRequestPending => 'Genehmigung ausstehend';

  @override
  String get spaceJoinRequestApproved => 'Anfrage genehmigt';

  @override
  String get spaceJoinRequestRejected => 'Anfrage abgelehnt';

  @override
  String get spaceAlreadyMember => 'Sie sind bereits Mitglied';

  @override
  String get spaceAutoApproved => 'Automatisch genehmigt. Willkommen!';

  @override
  String get spacePendingApprovalHint =>
      'Registrierung erfolgreich. Ihr Beitrittsantrag wurde eingereicht.';

  @override
  String get spaceNoSpaces => 'Keine Bereiche';

  @override
  String get spaceInviteExpired => 'Einladungscode abgelaufen';

  @override
  String get spaceInviteTargetMismatch =>
      'Dieser Einladungscode ist nicht für Ihr Konto bestimmt';

  @override
  String get spaceAcceptInviteSuccess => 'Unternehmen erfolgreich beigetreten';

  @override
  String get spaceAcceptInviteFailed =>
      'Beitritt fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get spaceTenantSelectTitle => 'Bereich auswählen';

  @override
  String get spaceTenantSelectHint => 'Wählen Sie einen Bereich zum Öffnen';

  @override
  String get spaceEnterPersonal => 'Persönlichen Bereich öffnen';

  @override
  String get spaceEnterEnterprise => 'Unternehmensbereich öffnen';

  @override
  String get aboutTitle => 'Über StartLink';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutTerms => 'Nutzungsbedingungen';

  @override
  String get aboutPrivacy => 'Datenschutzrichtlinie';

  @override
  String get aboutOpenSource => 'Open-Source-Lizenzen';

  @override
  String get aboutCheckUpdate => 'Nach Updates suchen';

  @override
  String get aboutLatestVersion => 'Sie verwenden die neueste Version.';

  @override
  String get aboutUpdateAvailable => 'Neue Version verfügbar';

  @override
  String get aboutUpdateNow => 'Jetzt aktualisieren';

  @override
  String get aboutUpdateLater => 'Später';

  @override
  String get notificationTitle => 'Benachrichtigungen';

  @override
  String get notificationGlobalMute => 'Nicht stören';

  @override
  String get notificationSound => 'Ton';

  @override
  String get notificationVibration => 'Vibration';

  @override
  String get notificationPreview => 'Nachrichtenvorschau';

  @override
  String get notificationDndStart => 'Beginn von „Nicht stören“';

  @override
  String get notificationDndEnd => 'Ende von „Nicht stören“';

  @override
  String get blacklistTitle => 'Gesperrt';

  @override
  String get blacklistEmpty => 'Keine blockierten Benutzer';

  @override
  String get blacklistRemove => 'Blockierung aufheben';

  @override
  String get blacklistRemoveConfirm => 'Blockierung dieses Benutzers aufheben?';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackTypeComplaint => 'Beschwerde';

  @override
  String get feedbackTypeSuggestion => 'Vorschlag';

  @override
  String get feedbackTypeBug => 'Fehlerbericht';

  @override
  String get feedbackContent => 'Beschreibung';

  @override
  String get feedbackContentHint =>
      'Bitte beschreiben Sie Ihr Problem oder Ihren Vorschlag ausführlich';

  @override
  String get feedbackContact => 'Kontakt (optional)';

  @override
  String get feedbackSubmit => 'Absenden';

  @override
  String get feedbackSuccess => 'Feedback gesendet. Vielen Dank!';

  @override
  String get feedbackFailed => 'Senden fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get networkTitle => 'Leitung wechseln';

  @override
  String get networkAutoSelect => 'Automatisch';

  @override
  String get networkManual => 'Manuell';

  @override
  String get timezoneTitle => 'Zeitzone';

  @override
  String get timezoneAuto => 'Systemeinstellung verwenden';

  @override
  String get autoTranslateTitle => 'Automatische Übersetzung';

  @override
  String get autoTranslateEnabled => 'Automatische Übersetzung aktivieren';

  @override
  String get autoTranslateLanguage => 'Zielsprache';

  @override
  String get displayTitle => 'Anzeige';

  @override
  String get displayFontSize => 'Schriftgröße';

  @override
  String get displayChatBackground => 'Chat-Hintergrund';

  @override
  String get displayDarkMode => 'Erscheinungsbild';

  @override
  String get displayDarkModeSystem => 'Systemeinstellung verwenden';

  @override
  String get displayDarkModeSystemHint =>
      'Automatisch entsprechend der Systemeinstellung wechseln';

  @override
  String get displayDarkModeOff => 'Hell';

  @override
  String get displayDarkModeOffHint => 'Immer das helle Design verwenden';

  @override
  String get displayDarkModeOn => 'Dunkel';

  @override
  String get displayDarkModeOnHint => 'Immer das dunkle Design verwenden';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Chatverlauf';

  @override
  String get chatHistoryClear => 'Gesamten Verlauf löschen';

  @override
  String get chatHistoryClearConfirm =>
      'Gesamten Chatverlauf löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get chatHistoryClearSuccess => 'Chatverlauf gelöscht';

  @override
  String get accountSecurityTitle => 'Kontosicherheit';

  @override
  String get accountSecurityChangePassword => 'Passwort ändern';

  @override
  String get accountSecurityChangeMobile => 'Telefonnummer ändern';

  @override
  String get accountSecurityChangeEmail => 'E-Mail ändern';

  @override
  String get accountSecurityLoggedDevices => 'Angemeldete Geräte';

  @override
  String get accountSecurityDeactivate => 'Konto löschen';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Alle Daten werden nach 7 Tagen dauerhaft gelöscht. Konto löschen?';

  @override
  String get loggedDevicesTitle => 'Angemeldete Geräte';

  @override
  String get loggedDevicesCurrent => 'Dieses Gerät';

  @override
  String get loggedDevicesRevoke => 'Abmelden';

  @override
  String get loggedDevicesRevokeConfirm => 'Von diesem Gerät abmelden?';

  @override
  String get loggedDevicesRevokeSuccess => 'Vom Gerät abgemeldet';

  @override
  String get loggedDevicesRevokeFailed =>
      'Fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get loggedDevicesLastActive => 'Zuletzt aktiv';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Desktop';

  @override
  String get loggedDevicesTypeUnknown => 'Unbekanntes Gerät';

  @override
  String get privacySettingsTitle => 'Datenschutz';

  @override
  String get privacySearchableByMobile => 'Suche über Telefonnummer erlauben';

  @override
  String get privacySearchableByLppId => 'Suche über StartLink-ID erlauben';

  @override
  String get privacyAllowFriendRequest => 'Freundschaftsanfragen erlauben';

  @override
  String get privacyProfileVisibility => 'Profilsichtbarkeit';

  @override
  String get privacyEveryone => 'Alle';

  @override
  String get privacyFriendsOfFriends => 'Freunde von Freunden';

  @override
  String get privacyNobody => 'Niemand';

  @override
  String get privacyFriendsOnly => 'Nur Freunde';

  @override
  String get privacySaveSuccess => 'Einstellungen gespeichert';

  @override
  String get privacySaveFailed =>
      'Speichern fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get fontSizeTitle => 'Schriftgröße';

  @override
  String get fontSizeSmall => 'Klein';

  @override
  String get fontSizeNormal => 'Normal';

  @override
  String get fontSizeLarge => 'Groß';

  @override
  String get fontSizeExtraLarge => 'Extra groß';

  @override
  String get fontSizePreview => 'Vorschau';

  @override
  String get chatBackgroundTitle => 'Chat-Hintergrund';

  @override
  String get chatBackgroundDefault => 'Standard';

  @override
  String get chatBackgroundCustom => 'Benutzerdefiniert';

  @override
  String get chatBackgroundReset => 'Standardwerte wiederherstellen';

  @override
  String get termsTitle => 'Nutzungsbedingungen';

  @override
  String get privacyPolicyTitle => 'Datenschutzrichtlinie';

  @override
  String get recentContactsTitle => 'Zuletzt';

  @override
  String get recentContactsEmpty => 'Keine kürzlichen Kontakte';

  @override
  String get inviteFriendsTitle => 'Freunde einladen';

  @override
  String get inviteFriendsCopyLink => 'Einladungslink kopieren';

  @override
  String get inviteFriendsLinkCopied => 'Einladungslink kopiert';

  @override
  String get imageViewerTitle => 'Foto';

  @override
  String get imageViewerSave => 'In Album speichern';

  @override
  String get imageViewerSaveSuccess => 'Im Album gespeichert';

  @override
  String get imageViewerSaveFailed =>
      'Speichern fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get customerServiceTitle => 'Service-Arbeitsplatz';

  @override
  String get customerServiceQueue => 'Warteschlange';

  @override
  String get customerServiceActive => 'Aktiv';

  @override
  String get customerServiceClaim => 'Annehmen';

  @override
  String get customerServiceTakeover => 'Übernehmen';

  @override
  String get customerServiceClose => 'Betreuung beenden';

  @override
  String get customerServiceCloseConfirm => 'Diese Betreuung beenden?';

  @override
  String get customerServiceNoQueue => 'Keine wartenden Gespräche';

  @override
  String get customerServiceNoActive => 'Keine aktiven Gespräche';

  @override
  String get customerServiceVisitor => 'Besucher';

  @override
  String get customerServiceCustomer => 'Kunde';

  @override
  String get customerServiceAssignedTo => 'Zugewiesen an';

  @override
  String get customerServiceTransferConversation => 'Chat übertragen';

  @override
  String get marketingToolbar => 'Marketing-Werkzeuge';

  @override
  String get callIncoming => 'Eingehender Anruf';

  @override
  String get callOutgoing => 'Ausgehender Anruf';

  @override
  String get callAccept => 'Annehmen';

  @override
  String get callReject => 'Ablehnen';

  @override
  String get callHangup => 'Beenden';

  @override
  String get callMissed => 'Verpasster Anruf';

  @override
  String get callDuration => 'Dauer';

  @override
  String get callAudio => 'Sprachanruf';

  @override
  String get callGeneric => 'Anruf';

  @override
  String get callVideo => 'Videoanruf';

  @override
  String get callConnecting => 'Verbindung wird hergestellt …';

  @override
  String get callRinging => 'Es klingelt …';

  @override
  String get callEnded => 'Anruf beendet';

  @override
  String get callFailed => 'Anruf fehlgeschlagen';

  @override
  String get callRejected => 'Anruf abgelehnt';

  @override
  String get callTimeout => 'Keine Antwort';

  @override
  String get callCancelled => 'Abgebrochen';

  @override
  String get callUnknownPeer => 'Unbekannt';

  @override
  String get callVideoInvitation => 'Einladung zum Videoanruf';

  @override
  String get callAudioInvitation => 'Einladung zum Sprachanruf';

  @override
  String get callAnswerAudio => 'Mit Audio annehmen';

  @override
  String get callAnswerVideo => 'Mit Video annehmen';

  @override
  String get callViewProfile => 'Profil anzeigen';

  @override
  String get callOpeningCamera => 'Kamera wird geöffnet …';

  @override
  String get callWaitingRemoteVideo =>
      'Warten auf das Video der anderen Person …';

  @override
  String get callCameraOff => 'Kamera aus';

  @override
  String get callCameraOn => 'Kamera an';

  @override
  String get callMicrophoneOff => 'Mikrofon aus';

  @override
  String get callMicrophoneOn => 'Mikrofon an';

  @override
  String get callSpeakerOff => 'Lautsprecher aus';

  @override
  String get callSpeakerOn => 'Lautsprecher an';

  @override
  String get callVideoPermissionFailure =>
      'Der Videoanruf konnte nicht gestartet werden. Kamera- und Mikrofonberechtigungen prüfen und erneut versuchen.';

  @override
  String get callAudioPermissionFailure =>
      'Der Sprachanruf konnte nicht gestartet werden. Mikrofonberechtigung prüfen und erneut versuchen.';

  @override
  String get callIncompleteIncoming =>
      'Die Angaben zum eingehenden Anruf sind unvollständig. Der Anruf kann nicht angenommen werden.';

  @override
  String get callInProgress => 'Im Gespräch';

  @override
  String get callCalling => 'Anruf läuft …';

  @override
  String callEndedMedia(String media) {
    return '$media beendet';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media wurde abgelehnt';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media wurde nicht angenommen';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media wurde abgebrochen';
  }

  @override
  String get callConnectionLost => 'Anrufverbindung unterbrochen';

  @override
  String get callAdminEnded => 'Anruf von einem Administrator beendet';

  @override
  String callFailedMedia(String media) {
    return '$media fehlgeschlagen';
  }

  @override
  String get callBusy => 'Die andere Person ist beschäftigt';

  @override
  String callDurationValue(String duration) {
    return 'Anrufdauer $duration';
  }

  @override
  String get callNotConnected => 'Nicht verbunden';

  @override
  String get callDialed => 'Ausgehend';

  @override
  String get callAnswered => 'Angenommen';

  @override
  String get callRejectedByPeer => 'Von der anderen Person abgelehnt';

  @override
  String get callRejectedBySelf => 'Abgelehnt';

  @override
  String get callPeerDidNotAnswer => 'Die andere Person hat nicht geantwortet';

  @override
  String get callMissedIncoming => 'Verpasster eingehender Anruf';

  @override
  String get callPeerCancelled => 'Von der anderen Person abgebrochen';

  @override
  String get notificationNewMessageTitle => 'Neue StartLink-Nachricht';

  @override
  String get notificationOnlineServiceTitle => 'Neue Kundendienstnachricht';

  @override
  String get notificationNewMessageBody =>
      'Sie haben eine neue Nachricht erhalten';

  @override
  String get notificationImagePreview => 'Hat ein Bild gesendet';

  @override
  String get notificationVideoPreview => 'Hat ein Video gesendet';

  @override
  String get notificationVoicePreview => 'Hat eine Sprachnachricht gesendet';

  @override
  String get notificationFilePreview => 'Hat eine Datei gesendet';

  @override
  String get notificationContactPreview => 'Hat eine Kontaktkarte gesendet';

  @override
  String get notificationCallLogPreview => 'Hat einen Anrufeintrag gesendet';

  @override
  String get notificationLocationPreview => 'Hat einen Standort geteilt';

  @override
  String get notificationLinkPreview => 'Hat einen Link geteilt';

  @override
  String notificationMentionMe(String body) {
    return 'Hat Sie erwähnt: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender hat Sie erwähnt: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Hat alle erwähnt: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender hat alle erwähnt: $body';
  }

  @override
  String get notificationSecurityTitle => 'Warnung zur Kontosicherheit';

  @override
  String get notificationSecurityBody =>
      'Die Sicherheitseinstellungen Ihres StartLink-Kontos wurden geändert. Bitte jetzt prüfen.';

  @override
  String get notificationFriendAcceptedTitle =>
      'Freundschaftsanfrage angenommen';

  @override
  String get notificationFriendRejectedTitle =>
      'Freundschaftsanfrage abgelehnt';

  @override
  String get notificationFriendAcceptedBody =>
      'Die andere Person hat Ihre Freundschaftsanfrage angenommen';

  @override
  String get notificationFriendRejectedBody =>
      'Die andere Person hat Ihre Freundschaftsanfrage abgelehnt';

  @override
  String get notificationVideoCallTitle => 'Einladung zum Videoanruf';

  @override
  String get notificationAudioCallTitle => 'Einladung zum Sprachanruf';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller hat Sie zu einem Videoanruf eingeladen';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller hat Sie zu einem Sprachanruf eingeladen';
  }

  @override
  String get notificationMessageChannelName => 'Nachrichten';

  @override
  String get notificationMessageChannelDescription =>
      'Chatnachrichten, Anrufeinträge und Systemhinweise';

  @override
  String get notificationCallChannelName => 'Anrufe';

  @override
  String get notificationCallChannelDescription =>
      'Benachrichtigungen zu Sprach- und Videoanrufen';

  @override
  String get notificationSecurityChannelName => 'Kontosicherheit';

  @override
  String get notificationSecurityChannelDescription =>
      'Hinweise zu Anmeldungen sowie Passwort- und Mobilnummeränderungen';

  @override
  String get notificationUnknownCaller => 'Unbekannter Anrufer';

  @override
  String get pendingJoinRequestsTitle => 'Neue Anfragen';

  @override
  String get pendingJoinRequestsEmpty => 'Keine Anfragen';

  @override
  String get pendingJoinRequestApprove => 'Zustimmen';

  @override
  String get pendingJoinRequestReject => 'Ablehnen';

  @override
  String get pendingJoinRequestApproveSuccess => 'Genehmigt';

  @override
  String get pendingJoinRequestRejectSuccess => 'Abgelehnt';

  @override
  String get pendingJoinRequestFailed =>
      'Vorgang fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get myCustomersTitle => 'Meine Kunden';

  @override
  String get myCustomersEmpty => 'Keine Kunden';

  @override
  String get groupListTitle => 'Gruppen';

  @override
  String get groupListEmpty => 'Keine Gruppen';

  @override
  String get addFriendTitle => 'Kontakt hinzufügen';

  @override
  String get addFriendSearchHint => 'Telefon / E-Mail / StartLink-ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink-ID: $lppId';
  }

  @override
  String get addFriendButton => 'Hinzufügen';

  @override
  String get addFriendCannotAddSelf =>
      'Sie können sich nicht selbst hinzufügen';

  @override
  String get addFriendUnsupportedUser =>
      'Dieser Benutzer kann nicht hinzugefügt werden. Sie können ihm direkt schreiben.';

  @override
  String get addFriendMessageHint => 'Nachricht eingeben';

  @override
  String get addFriendSendRequest => 'Anfrage senden';

  @override
  String get joinCompanyTitle => 'Unternehmen beitreten';

  @override
  String get joinCompanyCodeHint => 'Unternehmenscode eingeben';

  @override
  String get joinCompanySearchHint => 'Unternehmensnamen suchen';

  @override
  String get joinCompanyApply => 'Beitritt beantragen';

  @override
  String get joinCompanyApplySuccess => 'Antrag eingereicht';

  @override
  String get joinCompanyApplyFailed =>
      'Antrag fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get joinCompanyAutoApproved => 'Automatisch genehmigt. Willkommen!';

  @override
  String get joinCompanyPending => 'Antrag eingereicht, Genehmigung ausstehend';

  @override
  String get joinCompanyInviteCodeHint => 'Einladungscode eingeben';

  @override
  String get joinCompanyAcceptInvite => 'Einladung annehmen';

  @override
  String get joinCompanyNoResults => 'Keine Unternehmen gefunden';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count Mitglieder';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Pazifische Zeit';

  @override
  String get timezoneNameMountainTime => 'Gebirgszeit';

  @override
  String get timezoneNameCentralTime => 'Zentralzeit';

  @override
  String get timezoneNameEasternTime => 'Ostküstenzeit';

  @override
  String get timezoneNameAtlanticTime => 'Atlantische Zeit';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azoren';

  @override
  String get timezoneNameLondonDublin => 'London/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Rom';

  @override
  String get timezoneNameCairoHelsinki => 'Kairo/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskau/Riad';

  @override
  String get timezoneNameTehran => 'Teheran';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Baku';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karatschi/Taschkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/Neu-Delhi';

  @override
  String get timezoneNameKathmandu => 'Kathmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dhaka/Almaty';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoi/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Peking/Shanghai/Hongkong/Taipeh';

  @override
  String get timezoneNameTokyoSeoul => 'Tokio/Seoul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Salomonen';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fidschi';

  @override
  String get networkSmartSelectBestRoute => 'Beste Route automatisch auswählen';

  @override
  String get networkTesting => 'Wird getestet …';

  @override
  String get networkTestingShort => 'Test läuft';

  @override
  String networkLatencyMs(int ms) {
    return 'Latenz $ms ms';
  }

  @override
  String get networkConnectionMode => 'Verbindungsmodus';

  @override
  String get networkDirectMode => 'Direktverbindung';

  @override
  String get networkProxyMode => 'Proxy-Verbindung';

  @override
  String get networkDirectModeDesc => 'Direkt mit dem Server verbinden';

  @override
  String get networkProxyModeDesc => 'Über einen Proxy-Server verbinden';

  @override
  String get networkDirectRoutes => 'Direkte Routen';

  @override
  String get networkProxyRoutes => 'Proxy-Routen';

  @override
  String get networkTestAll => 'Alle testen';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Knoten Hongkong';

  @override
  String get networkSingaporeNode => 'Knoten Singapur';

  @override
  String get networkJapanNode => 'Knoten Japan';

  @override
  String get networkUnitedStatesNode => 'Knoten Vereinigte Staaten';

  @override
  String get networkHint =>
      'Hinweise:\n• Direktmodus: schneller und für die Nutzung im Inland geeignet\n• Proxy-Modus: stabiler bei grenzüberschreitender Kommunikation\n• Tippen Sie auf das Aktualisierungssymbol, um die Latenz einer einzelnen Route zu testen';

  @override
  String get teenModeTitle => 'Jugendmodus';

  @override
  String get teenModeStatusOn => 'Ein';

  @override
  String get teenModeStatusOff => 'Aus';

  @override
  String get teenModeStatusLoading => 'Wird geladen';

  @override
  String get teenModeUnavailable =>
      'Der Status des Jugendmodus ist vorübergehend nicht verfügbar';

  @override
  String get teenModeInvalidResponse =>
      'Der Jugendmodus hat eine ungültige Antwort geliefert';

  @override
  String get teenModeEnableDescription =>
      'Die Plattformregeln begrenzen die Nutzungszeit und bestimmte Funktionen.';

  @override
  String get teenModePasscode => 'Zugangscode';

  @override
  String get teenModeCurrentPasscode => 'Aktueller Zugangscode';

  @override
  String get teenModeNewPasscode => 'Neuer Zugangscode';

  @override
  String get teenModePasscodeHint => '4–6 Ziffern eingeben';

  @override
  String get teenModeEnable => 'Jugendmodus einschalten';

  @override
  String get teenModeDisable => 'Jugendmodus ausschalten';

  @override
  String get teenModeChangePasscode => 'Zugangscode ändern';

  @override
  String get teenModeSource => 'Aktiviert durch';

  @override
  String get teenModeDailyUsage => 'Heute genutzt';

  @override
  String get teenModeRemaining => 'Verbleibende Zeit';

  @override
  String get teenModeMinutesUnit => 'Minuten';

  @override
  String get teenModeUnlimited => 'Unbegrenzt';

  @override
  String get teenModeRequestExtension => 'Mehr Zeit anfordern';

  @override
  String get teenModeExtensionSubmitted =>
      'Die Zeitanfrage wurde an eine erziehungsberechtigte Person gesendet';

  @override
  String get teenModeTimeLimitReached =>
      'Das heutige Nutzungslimit wurde erreicht';

  @override
  String get teenModeCurfewActive =>
      'Die Nutzung ist in diesem Zeitraum eingeschränkt';

  @override
  String get teenModeReliefHint =>
      'Sie können weiterhin den Verlauf ansehen, den offiziellen Support kontaktieren und Probleme melden.';

  @override
  String get teenModeRestrictedNotice =>
      'Der Jugendmodus verhindert derzeit das Senden von Nachrichten';

  @override
  String get teenModeActionBlocked =>
      'Der Jugendmodus verhindert derzeit diese Aktion';

  @override
  String get teenModeMyRequests => 'Meine Anfragen';

  @override
  String get guardianCenterTitle => 'Bereich für Erziehungsberechtigte';

  @override
  String get guardianRelationships => 'Betreuungsverhältnisse';

  @override
  String get guardianMinors => 'Von mir betreute Kinder';

  @override
  String get guardianApprovals => 'Ausstehende Genehmigungen';

  @override
  String get guardianBind => 'Verknüpfungscode eingeben';

  @override
  String get guardianCreateMinorCode => 'Ich bin ein Kind – Code erstellen';

  @override
  String get guardianCreateGuardianCode =>
      'Ich bin erziehungsberechtigt – Code erstellen';

  @override
  String get guardianRelation => 'Beziehung';

  @override
  String get guardianPrimary => 'Hauptverantwortliche Person';

  @override
  String get guardianCode => '6-stelliger Verknüpfungscode';

  @override
  String get guardianCodeHint =>
      'Den von der anderen Person erhaltenen Code eingeben';

  @override
  String get guardianCodeCreated =>
      'Code erstellt. Bitte vor Ablauf weitergeben.';

  @override
  String get guardianEmpty => 'Keine Betreuungsverhältnisse';

  @override
  String get guardianNoMinors => 'Keine betreuten Kinder';

  @override
  String get guardianUnbind => 'Verknüpfung entfernen';

  @override
  String get guardianExtend => 'Zusätzliche Zeit für das Kind';

  @override
  String get guardianPolicyTitle => 'Nutzungsregeln';

  @override
  String get guardianPolicyLocked => 'Von der Plattform gesperrt';

  @override
  String get approvalEmpty => 'Keine Anfragen';

  @override
  String get approvalApprove => 'Zustimmen';

  @override
  String get approvalReject => 'Ablehnen';

  @override
  String get approvalPending => 'Ausstehend';

  @override
  String get approvalApproved => 'Genehmigt';

  @override
  String get approvalRejected => 'Abgelehnt';

  @override
  String get approvalExpired => 'Abgelaufen';

  @override
  String get approvalCancelled => 'Storniert';

  @override
  String get approvalReplayFailed =>
      'Die ursprüngliche Aktion ist fehlgeschlagen. Bitte erneut ausführen.';

  @override
  String get requestCancelled => 'Anfrage abgebrochen';

  @override
  String get kycTitle => 'Identitätsprüfung';

  @override
  String get kycNotRequired => 'Identitätsprüfung nicht erforderlich';

  @override
  String get kycVerified => 'Identität bestätigt';

  @override
  String get kycDeclared => 'Identitätsdaten eingereicht';

  @override
  String get kycPending => 'Wird geprüft';

  @override
  String get kycRejected => 'Prüfung abgelehnt';

  @override
  String get kycNone => 'Keine Identitätsdaten eingereicht';

  @override
  String get kycRealName => 'Vollständiger Name';

  @override
  String get kycIdNumber => 'Ausweisnummer';

  @override
  String get kycIdType => 'Dokumenttyp';

  @override
  String get kycApplicability =>
      'Geben Sie Ihre tatsächlichen Daten für das ausgewählte Dokument ein. Zulässige Typen stehen in der Liste.';

  @override
  String get kycCamera => 'Foto aufnehmen';

  @override
  String get kycGallery => 'Aus Album auswählen';

  @override
  String get kycPhotoLimit => 'Höchstgröße je Foto';

  @override
  String get kycSelectPhoto => 'Foto auswählen';

  @override
  String get kycPhotoSelected => 'Ausgewählt';

  @override
  String get kycViewPhoto => 'Tippen, um das Foto anzuzeigen';

  @override
  String get kycReplacePhoto => 'Anderes Foto auswählen';

  @override
  String get kycDisclosure =>
      'Wir verwenden Ihren Namen, Ihre Dokumentnummer und Dokumentfotos zur Identitätsprüfung. Ohne diese Angaben ist keine Einreichung möglich; bestimmte eingeschränkte Funktionen sind möglicherweise nicht verfügbar.';

  @override
  String get kycConsent =>
      'Ich willige gesondert in die Verarbeitung dieser Identitätsdaten ein';

  @override
  String get kycConsentRequired =>
      'Bitte vor dem Einreichen gesondert einwilligen';

  @override
  String get kycResubmitTitle => 'Identitätsdaten erneut einreichen';

  @override
  String get kycResubmitWarning =>
      'Die erneute Einreichung ersetzt Ihren ausstehenden Antrag. Fortfahren?';

  @override
  String get kycSubmitting => 'Wird eingereicht';

  @override
  String get kycSubmitFailed => 'Einreichen fehlgeschlagen. Erneut versuchen.';

  @override
  String get kycSubmitUnavailable =>
      'Identitätsdaten können derzeit nicht eingereicht werden';

  @override
  String get kycResubmitNotAllowed =>
      'Nach einer Ablehnung ist keine erneute Einreichung möglich. Bei Bedarf den Support kontaktieren.';

  @override
  String get kycDailyLimit =>
      'Das heutige Einreichungslimit wurde erreicht. Bitte morgen erneut versuchen.';

  @override
  String get kycTypeUnavailable =>
      'Keine Dokumenttypen verfügbar. Bitte später erneut versuchen.';

  @override
  String get kycNameInvalid => 'Der amtliche Name muss 2–64 Zeichen lang sein';

  @override
  String get kycNumberRequired => 'Dokumentnummer eingeben';

  @override
  String get kycFrontRequired => 'Vorderseite Ihres Dokuments hochladen';

  @override
  String get kycBackRequired => 'Rückseite Ihres Dokuments hochladen';

  @override
  String get kycPhotoTooLarge =>
      'Das Foto überschreitet die Größenbegrenzung. Bitte komprimieren und erneut versuchen.';

  @override
  String get kycAccountChanged =>
      'Konto oder Bereich wurde gewechselt. Bitte diese Seite erneut öffnen.';

  @override
  String get kycPhotoInvalid => 'Gültiges Bild auswählen';

  @override
  String get kycPortraitSide => 'Vorderseite des Ausweises';

  @override
  String get kycEmblemSide => 'Rückseite des Ausweises';

  @override
  String get kycPassportDataPage => 'Datenseite des Reisepasses';

  @override
  String get kycPassportOtherPage => 'Visa- oder freie Seite des Reisepasses';

  @override
  String get kycFront => 'Vorderseite des Ausweises';

  @override
  String get kycBack => 'Rückseite des Ausweises';

  @override
  String get kycRequired =>
      'Vor dem Erstellen einer Gruppe ist eine Identitätsprüfung erforderlich';

  @override
  String get kycGoVerify => 'Jetzt verifizieren';

  @override
  String get kycStatusUnknown =>
      'Identitätsstatus nicht verfügbar. Bitte später aktualisieren.';

  @override
  String get kycSuperseded =>
      'Diese Einreichung wurde durch eine spätere ersetzt. Bitte aktuellen Identitätsstatus prüfen.';

  @override
  String get kycMediaNotFound =>
      'Das Dokumentfoto ist in diesem Bereich nicht verfügbar. Vor dem Einreichen erneut auswählen.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Kunden-Rundnachricht';

  @override
  String get officialAccountBadge => 'Offiziell';

  @override
  String get officialAccountOpenConversation => 'Gespräch öffnen';

  @override
  String get officialAccountJoinHint =>
      'Durch Hinzufügen dieses Kontos treten Sie dem Unternehmen als Kunde bei. Eine Freundschaftsbestätigung ist nicht erforderlich.';

  @override
  String get officialAccountJoinDisabled =>
      'Dieses Unternehmen nimmt derzeit keine neuen Kunden auf. Bitte Support kontaktieren.';

  @override
  String get officialAccountRemoved =>
      'Sie wurden aus diesem Unternehmen entfernt. Bitten Sie das Unternehmen um eine erneute Einladung.';

  @override
  String get officialAccountBanned =>
      'Ihr Konto wurde in diesem Unternehmen deaktiviert.';

  @override
  String get officialAccountUnavailable =>
      'Dieses offizielle Konto ist derzeit nicht verfügbar.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Im aktuellen Modus ist der Beitritt zu einem Unternehmen nicht erlaubt.';

  @override
  String get officialAccountPlatformRequired =>
      'Verwenden Sie ein Plattformkonto, um dieses offizielle Konto hinzuzufügen.';

  @override
  String get officialAccountOpenFailed =>
      'Das Gespräch konnte nicht geöffnet werden. Bitte erneut versuchen.';

  @override
  String get officialAccountAccountChanged =>
      'Konto oder Bereich wurde gewechselt. Bitte erneut öffnen.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Das Unternehmensverzeichnis ist nicht aktuell. Bitte in Kürze erneut versuchen.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Synchronisierung des offiziellen Kontos fehlgeschlagen. Lokale Inhalte sind weiterhin verfügbar.';

  @override
  String get officialAccountInboxSyncing =>
      'Nachrichten des offiziellen Kontos werden synchronisiert';

  @override
  String get diagnosticsTitle => 'Diagnose';

  @override
  String get diagnosticsExplanation =>
      'Die Protokolle sind bereinigt und enthalten Betriebs- und Fehlerinformationen für dieses Konto und diesen Bereich sowie öffentliche Startereignisse. Chatinhalte und Zugangsdaten sind ausgeschlossen.';

  @override
  String get diagnosticsHour => 'Letzte Stunde';

  @override
  String get diagnosticsDay => 'Letzte 24 Stunden';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Verfügbare Ereignisse: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Protokolle werden auf diesem Gerät gespeichert und bleiben nach einem Neustart verfügbar.';

  @override
  String get diagnosticsNotPersistent =>
      'Einige Protokolle wurden nicht gespeichert. Zum erneuten Versuch aktualisieren.';

  @override
  String get diagnosticsExport => 'Exportieren und teilen';

  @override
  String get diagnosticsRefresh => 'Aktualisieren';

  @override
  String get diagnosticsClear => 'Protokolle dieses Bereichs löschen';

  @override
  String get diagnosticsClearConfirm =>
      'Diagnoseprotokolle dieses Bereichs löschen? Der Chatverlauf bleibt erhalten.';

  @override
  String get diagnosticsShared =>
      'Systemfreigabe abgeschlossen. Bitte die Datei in der empfangenden App prüfen.';

  @override
  String get diagnosticsCancelled =>
      'Teilen abgebrochen. Sie können erneut exportieren.';

  @override
  String get diagnosticsUnconfirmed =>
      'Das Teilen konnte nicht bestätigt werden. Bitte empfangende App prüfen.';

  @override
  String get diagnosticsFailed =>
      'Vorgang fehlgeschlagen. Bitte erneut versuchen.';
}
