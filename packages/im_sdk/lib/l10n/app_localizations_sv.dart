// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get navWorkbench => 'Arbetsyta';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Kontouppgifter kunde inte läsas in';

  @override
  String get startupFailureTitle => 'Starten misslyckades';

  @override
  String get startupFailureMessage => 'Kontrollera nätverket och försök igen';

  @override
  String get privacyConsentTitle => 'Användarvillkor och integritetspolicy';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Välkommen till $brand. För att erbjuda kontoinloggning, direktmeddelanden, företagssamarbete, kundservice online, meddelandeaviseringar och säkerhetsskydd behöver vi behandla nödvändig information enligt användarvillkoren och integritetspolicyn.\n\nInnan du trycker på ”Godkänn” läser vi inte urklipp, initierar inte JPush/JCore eller enhetstillverkarnas push-SDK:er och använder inte dessa SDK:er för åtkomst till Android ID, OAID, listor över installerade appar, MAC-adresser eller liknande information. Om du avböjer tills vidare sparar vi ditt val; du kan fortsätta läsa dokumenten och välja igen senare.\n\nEfter ditt samtycke kan JPush/JCore och enhetstillverkarnas push-tjänster behandla enhetsmodell, Android-version, appaket och appversion, nätverkstyp, IP-adress, Android ID, OAID, push-registrerings-ID, tillverkarens push-token samt leverans- och klickuppgifter för aviseringar för att leverera meddelande-, kundservice- och samtalsaviseringar. Vi har inaktiverat onödiga funktioner, inklusive smart push, listor över installerade appar, MAC, IMEI, IMSI, Wi-Fi-listor, automatisk väckning och kopplad start.\n\nUrklipp används endast när du aktivt kopierar eller klistrar in. Kamera-, mikrofon-, aviserings- och andra systembehörigheter begärs endast när du aktivt använder motsvarande funktion. Att neka en behörighet påverkar endast den funktionen. Läs de fullständiga dokumenten nedan och välj om du godkänner.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Välkommen till $brand. För att erbjuda kontoinloggning, direktmeddelanden, företagssamarbete, kundservice online, meddelandeaviseringar och säkerhetsskydd behöver vi behandla nödvändig information enligt användarvillkoren och integritetspolicyn.\n\nInnan du trycker på ”Godkänn” läser vi inte urklipp, initierar inte JPush/JCore, registrerar oss inte hos Apple Push Notification service (APNs) och hämtar inga push-identifierare som JPush-registrerings-ID eller APNs-enhetstoken. Om du avböjer tills vidare sparar vi ditt val; du kan fortsätta läsa dokumenten och välja igen senare.\n\nEfter ditt samtycke kan vi behandla iPhone-modell, iOS-version, appaket och appversion, nätverkstyp, IP-adress, IDFV, JPush-registrerings-ID, APNs-enhetstoken samt leverans- och klickuppgifter för aviseringar för att leverera meddelande-, kundservice- och samtalsaviseringar. JPush/JCore ansluter till push-tjänsten; Apple APNs behandlar appens identifierare, enhetstoken och aviseringsinnehållet för att leverera systemaviseringar. Den nuvarande iOS-appen använder inte reklamtjänster och hämtar inte IDFA.\n\nUrklipp används endast när du aktivt kopierar eller klistrar in. Kamera-, mikrofon-, aviserings- och andra systembehörigheter begärs endast när du aktivt använder motsvarande funktion. Att neka en behörighet påverkar endast den funktionen. Läs de fullständiga dokumenten nedan och välj om du godkänner.';
  }

  @override
  String get privacyConsentTermsLink => 'Användaravtal';

  @override
  String get privacyConsentConjunction => 'och';

  @override
  String get privacyConsentPrivacyLink => 'Integritetspolicy';

  @override
  String get privacyConsentDecline => 'Avböj';

  @override
  String get privacyConsentDeclinedExit =>
      'Du godkände inte användarvillkoren och integritetspolicyn. Appen stängs nu.';

  @override
  String get privacyConsentAccept => 'Godkänn';

  @override
  String get privacyConsentRuntimeFailure =>
      'Starten misslyckades. Kontrollera nätverket och försök igen.';

  @override
  String get privacyConsentSaveFailure =>
      'Ditt val kunde inte sparas. Försök igen.';

  @override
  String get appUpdateRequiredTitle => 'Uppdatering krävs för att fortsätta';

  @override
  String get appUpdateOptionalTitle => 'Ny version tillgänglig';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version är tillgänglig';
  }

  @override
  String get appUpdateLater => 'Senare';

  @override
  String get appUpdateNow => 'Uppdatera nu';

  @override
  String get appUpdateProcessing => 'Bearbetar…';

  @override
  String get appUpdateInvalidUrl =>
      'Uppdateringsadressen är ogiltig. Försök igen senare.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Uppdateringslänken kunde inte öppnas. Försök igen senare.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Nedladdningen avbröts. Kontrollera nätverket och försök igen.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Paketkontrollen misslyckades. Ladda ned igen.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Tillåt att $brand installerar uppdateringar i systeminställningarna.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Systemets installationsprogram kunde inte öppnas. Kontrollera installationsbehörigheterna.';

  @override
  String get appUpdateGenericFailure =>
      'Uppdateringen misslyckades. Kontrollera nätverket och försök igen.';

  @override
  String get appUpdateUnavailable =>
      'Den nya versionen kan inte laddas ned ännu. Försök senare.';

  @override
  String get appUpdateCheckFailed =>
      'Kunde inte söka efter uppdateringar. Försök igen senare.';

  @override
  String get appUpdateChecking => 'Kontrollerar';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Avbryt';

  @override
  String get commonSave => 'Spara';

  @override
  String get commonEdit => 'Redigera';

  @override
  String get commonDelete => 'Ta bort';

  @override
  String get commonSearch => 'Sök';

  @override
  String get commonLoading => 'Läser in…';

  @override
  String get commonLoadFailed => 'Kunde inte ladda';

  @override
  String get commonRetry => 'Försök igen';

  @override
  String get commonEmpty => 'Inga data';

  @override
  String get commonCopy => 'Kopiera';

  @override
  String get commonForward => 'Vidarebefordra';

  @override
  String get commonFavorite => 'Spara';

  @override
  String get commonClose => 'Stäng';

  @override
  String get commonSend => 'Skicka';

  @override
  String get commonDone => 'Klart';

  @override
  String get commonMore => 'Mer';

  @override
  String get commonSettings => 'Inställningar';

  @override
  String get commonCopied => 'Kopierat';

  @override
  String get commonUnknown => 'Okänt';

  @override
  String get commonNotSet => 'Inte angivet';

  @override
  String get commonUnbound => 'Inte kopplad';

  @override
  String get commonViewAll => 'Visa alla';

  @override
  String get commonSubmit => 'Skicka in';

  @override
  String get commonAdd => 'Lägg till';

  @override
  String get commonRemove => 'Ta bort';

  @override
  String get commonCreate => 'Skapa';

  @override
  String get commonUpdate => 'Uppdatera';

  @override
  String get commonUpload => 'Ladda upp';

  @override
  String get commonShare => 'Dela';

  @override
  String get commonBlock => 'Blockera';

  @override
  String get commonUnblock => 'Avblockera';

  @override
  String get commonMute => 'Stäng av ljud';

  @override
  String get commonUnmute => 'Slå på ljud';

  @override
  String get commonPin => 'Fäst';

  @override
  String get commonUnpin => 'Lossa';

  @override
  String get commonMarkRead => 'Markera som läst';

  @override
  String get commonMarkUnread => 'Markera som oläst';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Åtgärden misslyckades. Försök igen.';

  @override
  String get commonNetworkError => 'Nätverksfel. Kontrollera anslutningen.';

  @override
  String get navMessages => 'Meddelanden';

  @override
  String get navContacts => 'Kontakter';

  @override
  String get navMe => 'Jag';

  @override
  String get authLoginTitle => 'Logga in på StartLink';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'E-post';

  @override
  String get authTabLoginName => 'StartLink-ID';

  @override
  String get authHintMobile => 'Ange telefonnummer';

  @override
  String get authHintEmail => 'Ange din e-postadress';

  @override
  String get authHintPassword => 'Ange lösenord';

  @override
  String get authHintCode => 'Ange verifieringskod';

  @override
  String get authHintLoginName => 'Ange StartLink-ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Logga in';

  @override
  String get authGetCode => 'Hämta kod';

  @override
  String authResendCode(int seconds) {
    return 'Skicka igen om $seconds s';
  }

  @override
  String get authUsePassword => 'Använd lösenord';

  @override
  String get authUseCode => 'Använd verifieringskod';

  @override
  String get authAgreementPrefix => 'Jag har läst och godkänner';

  @override
  String get authAgreementAnd => 'och';

  @override
  String get authTermsLink => 'Användaravtal';

  @override
  String get authPrivacyLink => 'Integritetspolicy';

  @override
  String get authCaptchaTitle => 'Säkerhetskontroll';

  @override
  String get authCaptchaHint => 'Ange svaret';

  @override
  String get authCaptchaFailed => 'Kunde inte hämta captcha. Försök igen.';

  @override
  String get authErrorEmptyCode => 'Ange verifieringskoden';

  @override
  String get authErrorEmptyPassword => 'Ange lösenord';

  @override
  String get authErrorEmptyLoginName => 'Ange ditt StartLink-ID';

  @override
  String get authErrorWrongCredentials => 'Fel konto eller lösenord';

  @override
  String get authDeactivatingTitle => 'Radering av konto';

  @override
  String get authDeactivatingContent =>
      'Ditt konto är i ångerfristen för radering (7 dagar).\n\nTryck på ”Avbryt radering” för att avbryta eller på ”Fortsätt” för att öppna appen.';

  @override
  String get authContinueUse => 'Fortsätt';

  @override
  String get authCancelDeactivation => 'Avbryt radering';

  @override
  String get authDeactivationCancelled => 'Radering avbruten, konto återställt';

  @override
  String get authDeactivationCancelFailed =>
      'Det gick inte att avbryta. Försök igen.';

  @override
  String get authLogout => 'Logga ut';

  @override
  String get authLogoutConfirm => 'Vill du logga ut?';

  @override
  String get authSendingCode => 'Skickar…';

  @override
  String get authCodeSent => 'Verifieringskod skickad';

  @override
  String get authLoginFailed => 'Inloggningen misslyckades. Försök igen.';

  @override
  String get authRegisterFailed => 'Registreringen misslyckades. Försök igen.';

  @override
  String get authEnterpriseCode => 'Företagskod';

  @override
  String get authEnterpriseCodeHint => 'Ange företagskod';

  @override
  String get authPendingApproval =>
      'Registreringen lyckades. Din ansökan om att gå med i företaget har skickats in och väntar på godkännande.';

  @override
  String get authNoAccount => 'Har du inte ett konto?';

  @override
  String get authRegisterNow => 'Registrera nu';

  @override
  String get authCountryPickerTitle => 'Välj land/region';

  @override
  String get authCountrySearchHint => 'Sök land/region';

  @override
  String get authCountryChinaMainland => 'Fastlandskina';

  @override
  String get authCountryHongKong => 'Hongkong, Kina';

  @override
  String get authCountryMacau => 'Macao, Kina';

  @override
  String get authCountryTaiwan => 'Taiwan, Kina';

  @override
  String get authCountryUnitedStates => 'USA';

  @override
  String get authCountryUnitedKingdom => 'Storbritannien';

  @override
  String get authCountryJapan => 'Japan';

  @override
  String get authCountrySouthKorea => 'Sydkorea';

  @override
  String get authCountrySingapore => 'Singapore';

  @override
  String get authCountryMalaysia => 'Malaysia';

  @override
  String get authCountryAustralia => 'Australien';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Tyskland';

  @override
  String get authCountryFrance => 'Frankrike';

  @override
  String get authCountryIndia => 'Indien';

  @override
  String get authCountryThailand => 'Thailand';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesien';

  @override
  String get authCountryPhilippines => 'Filippinerna';

  @override
  String get authQuickLoginTitle => 'Snabbinloggning';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Loggar in. Vänta.';

  @override
  String get authRoleOwner => 'Ägare';

  @override
  String get authRoleAdministrator => 'Administratör';

  @override
  String get authRoleCustomerService => 'Kundservice';

  @override
  String get authRoleTechnicalSupport => 'Teknisk support';

  @override
  String get authRoleEmployee => 'Anställd';

  @override
  String get authRoleMember => 'Medlem';

  @override
  String get authRoleEnterpriseCustomer => 'Företagskund';

  @override
  String get authUnavailablePrefix => 'Inte tillgänglig ·';

  @override
  String get authUnassignedService => 'Ingen tilldelad handläggare';

  @override
  String authAssignedService(String staff) {
    return 'Tilldelad till $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Kund · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Anställd · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count användare';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Identitet';

  @override
  String get authRegisterTitle => 'Registrera dig';

  @override
  String get authNickname => 'Smeknamn';

  @override
  String get authNicknameHint => 'Ange ett smeknamn';

  @override
  String get authPassword => 'Lösenord';

  @override
  String get authPasswordSetHint => 'Ange ett lösenord (minst 6 tecken)';

  @override
  String get authConfirmPassword => 'Bekräfta lösenord';

  @override
  String get authConfirmPasswordHint => 'Ange lösenordet igen';

  @override
  String get authVerificationCode => 'Verifieringskod';

  @override
  String get authRegisterAndLogin => 'Registrera och logga in';

  @override
  String get authHaveAccount => 'Har du redan ett konto?';

  @override
  String get authGoLogin => 'Logga in';

  @override
  String get authEmailVerificationUnavailable =>
      'E-postverifiering är inte tillgänglig. Registrera dig med ett mobilnummer i stället.';

  @override
  String get authSmsVerificationUnavailable =>
      'SMS-verifiering är inte tillgänglig. Registrera dig med en e-postadress i stället.';

  @override
  String get authSendFailed => 'Kunde inte skicka. Försök igen.';

  @override
  String get authErrorEmptyNickname => 'Ange ett smeknamn';

  @override
  String get authErrorInvalidMobile => 'Ange ett giltigt mobilnummer';

  @override
  String get authErrorInvalidEmail => 'Ange en giltig e-postadress';

  @override
  String get authErrorPasswordTooShort =>
      'Lösenordet måste innehålla minst 6 tecken';

  @override
  String get authErrorPasswordMismatch => 'Lösenorden matchar inte';

  @override
  String get authErrorVerificationRequired =>
      'Hämta och ange verifieringskoden först';

  @override
  String get authRegisterErrorTitle => 'Registreringen misslyckades';

  @override
  String get authGotIt => 'Förstått';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Företaget ”$code” hittades inte. Kontrollera företagskoden.';
  }

  @override
  String get authTenantSearchFailed => 'Sökningen misslyckades. Försök igen.';

  @override
  String get authInvitationInvalid =>
      'Inbjudningskoden är ogiltig. Kontrollera den och försök igen.';

  @override
  String get authCollapseJoin => 'Dölj information om anslutning';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Giltig inbjudan: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Företag hittat: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Välj organisation';

  @override
  String get authNoOrganization => 'Inga organisationer tillgängliga';

  @override
  String get authNoOrganizationHint =>
      'Be en administratör att bjuda in dig till en organisation';

  @override
  String get authPersonalSpace => 'Personligt utrymme';

  @override
  String get authPersonalSpaceSubtitle => 'Vänchattar och personliga favoriter';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Utrymmets identitet kunde inte verifieras. Försök igen.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Det personliga utrymmet kunde inte återställas. Försök igen.';

  @override
  String get authJoinEnterpriseFailed =>
      'Kunde inte gå med i företaget. Försök igen senare.';

  @override
  String get homeTitle => 'Meddelanden';

  @override
  String get homeGatewayConnectingTitle => 'Ansluter';

  @override
  String get homePersonalSpace => 'Personligt';

  @override
  String get homeOfficialService => 'Officiell service';

  @override
  String get homeSwitchSpace => 'Byt utrymme';

  @override
  String get homeSpaceSubtitle => 'Personligt · Företag';

  @override
  String get homeJoinEnterprise => 'Gå med i företag';

  @override
  String get homeCreateGroup => 'Ny grupp';

  @override
  String get homeAddFriend => 'Lägg till kontakt';

  @override
  String get homeScan => 'Skanna';

  @override
  String get homeJoinNewSpace => 'Gå med i nytt utrymme';

  @override
  String get homeSearchConversation => 'Sök';

  @override
  String get homeNoMessages => 'Inga meddelanden';

  @override
  String get homeDeleteConversation => 'Radera chatt';

  @override
  String get homeDeleteConversationConfirm =>
      'Radera denna chatt? Chatthistoriken rensas.';

  @override
  String get homePersonalNote => 'Jag (personliga anteckningar)';

  @override
  String get homeWorkNote => 'Jag (arbetsanteckningar)';

  @override
  String homeConversationCount(int count) {
    return '$count chattar';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count olästa';
  }

  @override
  String get chatInputHint => 'Skriv ett meddelande…';

  @override
  String get chatVoiceHint => 'Håll inne för att prata';

  @override
  String get chatVoiceRelease => 'Släpp för att skicka';

  @override
  String get chatVoiceCancel => 'Svep uppåt för att avbryta';

  @override
  String get chatMenuCopy => 'Kopiera';

  @override
  String get chatMenuForward => 'Vidarebefordra';

  @override
  String get chatMenuRecall => 'Återkalla';

  @override
  String get chatMenuDelete => 'Ta bort';

  @override
  String get chatMenuFavorite => 'Spara';

  @override
  String get chatMenuReply => 'Svara';

  @override
  String get chatMenuMultiSelect => 'Välj';

  @override
  String get chatMenuTranslate => 'Översätt';

  @override
  String get chatMenuVoiceToText => 'Omvandla till text';

  @override
  String get chatMenuTextToSpeech => 'Läs upp';

  @override
  String get chatStatusRecalled => 'Meddelandet återkallat';

  @override
  String get chatRecallSuccess => 'Återkallat';

  @override
  String get chatRecallFailed => 'Kunde inte återkalla';

  @override
  String get chatRecallTimeout =>
      'Meddelanden äldre än 2 minuter kan inte återkallas';

  @override
  String get chatTranslateFailed => 'Översättningen misslyckades. Försök igen.';

  @override
  String get chatTranslateNotConfigured =>
      'Översättningstjänsten är inte tillgänglig';

  @override
  String get chatVoiceToTextFailed => 'Omvandlingen misslyckades. Försök igen.';

  @override
  String get chatTextToSpeechFailed =>
      'Uppläsningen misslyckades. Försök igen.';

  @override
  String get chatVoiceToText => 'Omvandla';

  @override
  String get chatForwardSuccess => 'Vidarebefordrat';

  @override
  String get chatForwardFailed => 'Vidarebefordran misslyckades. Försök igen.';

  @override
  String get chatNoConversations => 'Inga chattar att vidarebefordra till';

  @override
  String get chatSendFailed => 'Kunde inte skicka';

  @override
  String get chatResend => 'Skicka kod igen';

  @override
  String get chatNotFriend => 'Inte i kontaktlistan';

  @override
  String get chatNotFriendHint =>
      'Ni är inte kontakter ännu. Meddelanden kan inte skickas.';

  @override
  String get chatMutedHint => 'Alla medlemmar är tystade';

  @override
  String get chatFileUploadFailed =>
      'Filuppladdningen misslyckades. Försök igen.';

  @override
  String get chatFileStatusNotDownloaded => 'Inte nedladdad';

  @override
  String get chatFileStatusDownloaded => 'Nedladdad';

  @override
  String get chatFileStatusUploading => 'Laddar upp';

  @override
  String get chatFileStatusUploadFailed => 'Uppladdning misslyckades';

  @override
  String get chatCardSendFailed => 'Kunde inte skicka kontaktkort';

  @override
  String get chatFavoriteSuccess => 'Sparad';

  @override
  String get chatFavoriteFailed => 'Kunde inte lägga till i favoriter';

  @override
  String get chatLoadFailed => 'Kunde inte ladda';

  @override
  String get chatImageMessage => '[Bild]';

  @override
  String get chatVoiceMessage => '[Röstmeddelande]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Fil]';

  @override
  String get chatLocationMessage => '[Plats]';

  @override
  String get chatContactCardMessage => '[Kontakt]';

  @override
  String get chatCallLogMessage => '[Samtal]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Läst av $count';
  }

  @override
  String get chatUnread => 'Oläst';

  @override
  String get chatRecalledSelf => 'Du återkallade ett meddelande';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender återkallade ett meddelande';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Översättning: $translation';
  }

  @override
  String get chatMessageDeleted => 'Meddelandet raderat';

  @override
  String get chatPeer => 'Den andra';

  @override
  String get chatSelf => 'Jag';

  @override
  String get chatGenericMessage => '[Meddelande]';

  @override
  String get chatVoiceHideText => 'Dölj text';

  @override
  String get chatVoiceShowText => 'Omvandla till text';

  @override
  String get chatFileDefaultName => 'Fil';

  @override
  String get chatContactDefaultName => 'Kontakt';

  @override
  String get chatContactCardTitle => 'Kontaktkort';

  @override
  String get chatCallMissed => 'Missat';

  @override
  String get chatCallCancelled => 'Avbrutet';

  @override
  String get chatCallRejected => 'Avvisat';

  @override
  String get chatCallDisconnected => 'Frånkopplat';

  @override
  String get chatCallEnded => 'Samtalet avslutat';

  @override
  String get chatCallFailed => 'Samtalet misslyckades';

  @override
  String chatCallDuration(String duration) {
    return 'Längd $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videosamtal';

  @override
  String get chatVoiceCallTitle => 'Röstsamtal';

  @override
  String get chatToolPhotos => 'Foton';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Fil';

  @override
  String get chatToolLocation => 'Plats';

  @override
  String get chatToolContactCard => 'Kontakt';

  @override
  String get chatToolVoiceCall => 'Röstsamtal';

  @override
  String get chatToolVideoCall => 'Videosamtal';

  @override
  String get chatToolFavorites => 'Favoriter';

  @override
  String get chatToolTranslate => 'Översätt';

  @override
  String get chatTranslationChooseLanguage => 'Välj översättningsspråk';

  @override
  String get chatTranslationEnterText => 'Ange text först';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Översättning är inte tillgänglig för meddelanden med omnämnanden';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Översättning är inte tillgänglig när ett schemalagt meddelande redigeras';

  @override
  String get chatTranslationFailed =>
      'Översättningen misslyckades. Försök igen.';

  @override
  String get chatTranslationEmpty =>
      'Ingen översättning mottagen. Försök igen.';

  @override
  String get chatTranslationTranslating => 'Översätter…';

  @override
  String get chatTranslationSend => 'Skicka översättning';

  @override
  String get chatTranslationSending => 'Skickar…';

  @override
  String get chatTranslationExpand => 'Visa mer';

  @override
  String get chatTranslationCollapse => 'Visa mindre';

  @override
  String get chatFileTooLarge => 'Filen överskrider gränsen på 100 MB';

  @override
  String get chatInputMutedAdminOnly =>
      'Endast ägaren eller utvalda medlemmar får skriva.';

  @override
  String get chatImageUploadUnsupported =>
      'Bilduppladdningen misslyckades. Servern stöder det inte ännu.';

  @override
  String get chatFavoriteLongPressHint =>
      'Håll inne ett meddelande för att lägga till det i favoriter';

  @override
  String chatSelectedCount(int count) {
    return '$count valda';
  }

  @override
  String get chatLocationSheetTitle => 'Skicka plats';

  @override
  String get chatLocationNameLabel => 'Platsnamn';

  @override
  String get chatLocationNameHint => 'T.ex. kontor, kundadress';

  @override
  String get chatLocationAddressLabel => 'Adress';

  @override
  String get chatLocationOptionalHint => 'Valfritt';

  @override
  String get chatLocationLatitudeLabel => 'Latitud';

  @override
  String get chatLocationLatitudeHint => '-90 till 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitud';

  @override
  String get chatLocationLongitudeHint => '-180 till 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Ange $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label är utanför intervallet';
  }

  @override
  String get chatLocationDefaultTitle => 'Plats';

  @override
  String get chatMutedFullNotice =>
      'Den här gruppen är tystad. Endast ägaren eller utvalda medlemmar får skriva.';

  @override
  String get chatNotFriendSendBlocked =>
      'Ni är inte längre vänner och kan inte skicka meddelanden';

  @override
  String get chatPersonalNotesTitle => 'Personliga anteckningar';

  @override
  String get chatWorkNotesTitle => 'Arbetsanteckningar';

  @override
  String get chatPersonalNotesDescription =>
      'Spara personliga tankar och viktig information här\nSynkroniserat mellan enheter och alltid tillgängligt';

  @override
  String get chatWorkNotesDescription =>
      'Spara arbetsuppgifter och arbetsmaterial här\nTeamutrymmen hålls separata och säkra';

  @override
  String get chatNoMessages => 'Inga meddelanden';

  @override
  String chatReplyTo(String sender) {
    return 'Svara $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature kommer snart';
  }

  @override
  String get chatForwardSelectTitle => 'Välj chatt';

  @override
  String get chatContactSelectTitle => 'Välj kontakt';

  @override
  String get chatNoContacts => 'Inga kontakter';

  @override
  String get contactsTitle => 'Kontakter';

  @override
  String get contactsSearch => 'Sök kontakter';

  @override
  String get contactsNewFriends => 'Nya vänner';

  @override
  String get contactsGroups => 'Grupper';

  @override
  String get contactsFavorites => 'Favoriter';

  @override
  String get contactsRecent => 'Senaste';

  @override
  String get contactsOrganization => 'Organisation';

  @override
  String get contactsAnnouncement => 'Anslag';

  @override
  String get contactsNewApplications => 'Nya ansökningar';

  @override
  String get contactsCustomerGroups => 'Kundgrupper';

  @override
  String get contactsAllCustomers => 'Alla kunder';

  @override
  String get contactsMyCustomers => 'Mina kunder';

  @override
  String get contactsViewAll => 'Visa alla';

  @override
  String get contactsMyContacts => 'Mina kontakter';

  @override
  String get contactsMyAdvisor => 'Min rådgivare';

  @override
  String get contactsNoAdvisor => 'Ingen rådgivare tilldelad ännu';

  @override
  String get contactsAdvisorLoading => 'Läser in…';

  @override
  String get contactsNavigateFailed =>
      'Navigeringen misslyckades. Försök igen.';

  @override
  String get contactsEmpty => 'Inga kontakter';

  @override
  String get contactsNoAnnouncement => 'Inga anslag';

  @override
  String get contactsOfficialBadge => 'Officiell';

  @override
  String get contactsCustomerBadge => 'Kund';

  @override
  String get contactsEmptyCustomers => 'Inga kunder';

  @override
  String get myTitle => 'Jag';

  @override
  String get myEnterpriseInfo => 'Företagsinformation';

  @override
  String get myEnterpriseManage => 'Företagsadministration';

  @override
  String get myQrCode => 'QR-kod';

  @override
  String get myFavorites => 'Favoriter';

  @override
  String get myLanguage => 'Språk';

  @override
  String get myTimezone => 'Tidszon';

  @override
  String get myAutoTranslate => 'Automatisk översättning';

  @override
  String get myNetworkSwitch => 'Byt linje';

  @override
  String get mySettings => 'Inställningar';

  @override
  String get myLogout => 'Logga ut';

  @override
  String get myLogoutConfirm => 'Vill du logga ut?';

  @override
  String get myLeaveEnterprise => 'Lämna företag';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Vill du lämna detta företag? Du förlorar åtkomsten till företagets data.';

  @override
  String get myLeaveEnterpriseSuccess => 'Företag lämnat';

  @override
  String get myLeaveEnterpriseFailed => 'Kunde inte lämna. Försök igen.';

  @override
  String get myLppIdCopied => 'StartLink-ID kopierat';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink-ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count kontakter';
  }

  @override
  String get myAutoSelect => 'Automatiskt';

  @override
  String get myPresenceStatus => 'Närvaro';

  @override
  String get myPresenceStatusTitle => 'Ange närvaro';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Upptagen';

  @override
  String get myPresenceAway => 'Borta';

  @override
  String get myPresenceInvisible => 'Osynlig';

  @override
  String get profileTitle => 'Min profil';

  @override
  String get profileName => 'Namn';

  @override
  String get profileGender => 'Kön';

  @override
  String get profileBirthday => 'Födelsedag';

  @override
  String get profileRegion => 'Region';

  @override
  String get profileSignature => 'Profiltext';

  @override
  String get profileSignatureHint => 'Berätta lite om dig själv';

  @override
  String get profileTapTapText => 'Knackning';

  @override
  String get profileTapTapHint => 'Text vid knackning (högst 20 tecken)';

  @override
  String get profileAccountSection => 'Konto';

  @override
  String get profileBasicSection => 'Grundinformation';

  @override
  String get profileLppId => 'StartLink-ID';

  @override
  String get profileLppIdNotSet => 'Inte angivet';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Inte kopplad';

  @override
  String get profileEmail => 'E-post';

  @override
  String get profileEmailUnbound => 'Inte kopplad';

  @override
  String get profileQrCode => 'Min QR-kod';

  @override
  String get profileChangePassword => 'Ändra lösenord';

  @override
  String get profileGenderMale => 'Man';

  @override
  String get profileGenderFemale => 'Kvinna';

  @override
  String get profileGenderOther => 'Övrigt';

  @override
  String get profileGenderUnset => 'Inte angivet';

  @override
  String get profileSaveFailed => 'Kunde inte spara. Försök igen.';

  @override
  String get profileLppIdTitle => 'StartLink-ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink-ID kan bara ändras en gång. Välj omsorgsfullt.';

  @override
  String get profileLppIdChangeFailed =>
      'Ändringen misslyckades (StartLink-ID kan bara ändras en gång)';

  @override
  String get profileChangePasswordOld => 'Nuvarande lösenord';

  @override
  String get profileChangePasswordNew => 'Nytt lösenord';

  @override
  String get profileChangePasswordConfirm => 'Bekräfta nytt lösenord';

  @override
  String get profileChangePasswordMismatch => 'Lösenorden matchar inte';

  @override
  String get profileChangePasswordSuccess =>
      'Lösenordet har ändrats. Logga in igen.';

  @override
  String get profileChangePasswordFailed =>
      'Kunde inte ändra lösenordet. Försök igen.';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsSectionEnterprise => 'Företag';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsSectionGeneral => 'Allmänt';

  @override
  String get settingsSectionFeatures => 'Funktioner';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsEnterpriseInfo => 'Företagsinformation';

  @override
  String get settingsProfile => 'Min profil';

  @override
  String get settingsAccountSecurity => 'Kontosäkerhet';

  @override
  String get settingsNotification => 'Aviseringar';

  @override
  String get settingsDisplay => 'Visning';

  @override
  String get settingsFriendPrivacy => 'Integritet';

  @override
  String get settingsChat => 'Chatt';

  @override
  String get settingsChatHistory => 'Chatthistorik';

  @override
  String get settingsAbout => 'Om StartLink';

  @override
  String get settingsLanguage => 'Språk';

  @override
  String get settingsTimezone => 'Tidszon';

  @override
  String get settingsAutoTranslate => 'Automatisk översättning';

  @override
  String get settingsNetworkSwitch => 'Byt linje';

  @override
  String get enterpriseInfoTitle => 'Företagsinformation';

  @override
  String get enterpriseName => 'Namn';

  @override
  String get enterpriseDescription => 'Beskrivning';

  @override
  String get enterpriseUpdateSuccess => 'Uppdatering lyckades';

  @override
  String get enterpriseUpdateFailed =>
      'Uppdateringen misslyckades. Försök igen.';

  @override
  String get enterpriseLeave => 'Lämna företag';

  @override
  String get enterpriseLeaveConfirm => 'Vill du lämna detta företag?';

  @override
  String get enterpriseLeaveSuccess => 'Företag lämnat';

  @override
  String get enterpriseLeaveFailed => 'Kunde inte lämna. Försök igen.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Ägaren kan inte lämna direkt. Överför ägarskapet först.';

  @override
  String get enterpriseMemberCount => 'Medlemmar';

  @override
  String get enterpriseCreatedAt => 'Skapat';

  @override
  String get enterpriseCode => 'Företagskod';

  @override
  String get enterpriseInviteMembers => 'Bjud in medlemmar';

  @override
  String get enterpriseCopyInviteCode => 'Kopiera inbjudningskod';

  @override
  String get enterpriseInviteCodeCopied => 'Inbjudningskod kopierad';

  @override
  String get groupCreateTitle => 'Ny grupp';

  @override
  String get groupNameHint => 'Ange gruppnamn';

  @override
  String get groupCreateSuccess => 'Grupp skapad';

  @override
  String get groupCreateFailed => 'Kunde inte skapa gruppen';

  @override
  String get groupSettings => 'Gruppinställningar';

  @override
  String get groupName => 'Gruppnamn';

  @override
  String get groupAvatar => 'Gruppbild';

  @override
  String get groupAnnouncement => 'Anslag';

  @override
  String get groupMembers => 'Medlemmar';

  @override
  String get groupAddMember => 'Lägg till medlemmar';

  @override
  String get groupRemoveMember => 'Ta bort medlem';

  @override
  String get groupRemoveMemberConfirm => 'Ta bort den här medlemmen?';

  @override
  String get groupSetAdmin => 'Gör till administratör';

  @override
  String get groupRemoveAdmin => 'Ta bort administratörsrättigheter';

  @override
  String get groupTransferOwner => 'Överför ägarskap';

  @override
  String get groupTransferOwnerConfirm =>
      'Överföra gruppens ägarskap till den här medlemmen?';

  @override
  String get groupTransferOwnerSuccess => 'Ägarskap överfört';

  @override
  String get groupTransferOwnerFailed =>
      'Överföringen misslyckades. Försök igen.';

  @override
  String get groupLeave => 'Lämna grupp';

  @override
  String get groupLeaveConfirm => 'Lämna den här gruppen?';

  @override
  String get groupLeaveSuccess => 'Gruppen lämnad';

  @override
  String get groupLeaveFailed => 'Kunde inte lämna. Försök igen.';

  @override
  String get groupDissolve => 'Upplös grupp';

  @override
  String get groupDissolveConfirm =>
      'Upplösa den här gruppen? Alla medlemmar tas bort.';

  @override
  String get groupDissolveSuccess => 'Gruppen upplöst';

  @override
  String get groupDissolveFailed => 'Upplösningen misslyckades. Försök igen.';

  @override
  String get groupQrCode => 'Gruppens QR-kod';

  @override
  String get groupMuteAll => 'Tysta alla';

  @override
  String get groupMuteAllOn => 'Aktivera tystning av alla';

  @override
  String get groupMuteAllOff => 'Inaktivera tystning av alla';

  @override
  String get groupAllowMemberInvite => 'Tillåt medlemsinbjudningar';

  @override
  String get groupAllowMemberModifyTitle =>
      'Tillåt medlemmar att ändra gruppnamnet';

  @override
  String get groupAllowMemberAtAll => 'Tillåt medlemmar att nämna @Alla';

  @override
  String get groupAllowMemberViewMemberList =>
      'Tillåt medlemmar att se medlemslistan';

  @override
  String get groupAllowQrCodeJoin => 'Tillåt anslutning via QR-kod';

  @override
  String get groupRequireApproval => 'Kräv godkännande för anslutning';

  @override
  String get groupAllowMemberAddFriend =>
      'Tillåt medlemmar att lägga till varandra';

  @override
  String get groupRoleOwner => 'Ägare';

  @override
  String get groupRoleAdmin => 'Administratör';

  @override
  String get groupRoleMember => 'Medlem';

  @override
  String get groupNoMembers => 'Inga medlemmar';

  @override
  String get groupNoAnnouncements => 'Inga anslag';

  @override
  String get groupCreateAnnouncement => 'Publicera anslag';

  @override
  String get groupEditAnnouncement => 'Redigera anslag';

  @override
  String get groupDeleteAnnouncement => 'Radera anslag';

  @override
  String get groupDeleteAnnouncementConfirm => 'Radera detta anslag?';

  @override
  String get groupAnnouncementTitle => 'Titel';

  @override
  String get groupAnnouncementContent => 'Innehåll';

  @override
  String get groupAnnouncementPin => 'Fäst anslag';

  @override
  String groupMemberCount(int count) {
    return '$count medlemmar';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count valda';
  }

  @override
  String get groupJoinRequestApprove => 'Godkänn';

  @override
  String get groupJoinRequestReject => 'Neka';

  @override
  String get groupJoinRequests => 'Anslutningsförfrågningar';

  @override
  String get groupNoJoinRequests => 'Inga anslutningsförfrågningar';

  @override
  String get groupReadReceipts => 'Läskvitton';

  @override
  String groupReadCount(int count) {
    return '$count lästa';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count olästa';
  }

  @override
  String get friendAddTitle => 'Lägg till kontakt';

  @override
  String get friendSearchHint => 'Telefon / E-post / StartLink-ID';

  @override
  String get friendRequestSent => 'Vänförfrågan skickad';

  @override
  String get friendRequestFailed => 'Kunde inte skicka. Försök igen.';

  @override
  String get friendAlreadyFriend => 'Redan kontakter';

  @override
  String get friendNewFriendsTitle => 'Nya vänner';

  @override
  String get friendNoRequests => 'Inga vänförfrågningar';

  @override
  String get friendAccept => 'Acceptera';

  @override
  String get friendReject => 'Neka';

  @override
  String get friendAccepted => 'Accepterad';

  @override
  String get friendRejected => 'Avvisad';

  @override
  String get friendDeleteConfirm => 'Ta bort den här kontakten?';

  @override
  String get friendDeleteSuccess => 'Kontakten borttagen';

  @override
  String get friendDeleteFailed => 'Borttagningen misslyckades. Försök igen.';

  @override
  String get friendRemarkName => 'Smeknamn';

  @override
  String get friendGroupName => 'Grupp';

  @override
  String get friendSendMessage => 'Meddelande';

  @override
  String get friendMatchTypeLppId => 'Hittad via StartLink-ID';

  @override
  String get friendMatchTypeMobile => 'Hittad via telefon';

  @override
  String get friendMatchTypeEmail => 'Hittad via e-post';

  @override
  String get friendSearchEmpty => 'Inga användare hittades';

  @override
  String get friendAddMessage => 'Jag vill lägga till dig som kontakt';

  @override
  String get friendBlockConfirm => 'Blockera den här användaren?';

  @override
  String get friendUnblockConfirm => 'Avblockera den här användaren?';

  @override
  String get friendBlockSuccess => 'Blockerad';

  @override
  String get friendUnblockSuccess => 'Avblockerad';

  @override
  String get profilePageTitle => 'Personuppgifter';

  @override
  String get profilePageSendMessage => 'Meddelande';

  @override
  String get profilePageAddFriend => 'Lägg till vän';

  @override
  String get profilePageAlreadyFriend => 'Redan vänner';

  @override
  String get profilePageBlocked => 'Blockerad';

  @override
  String get profilePageBlock => 'Blockera';

  @override
  String get profilePageUnblock => 'Avblockera';

  @override
  String get profilePageHidden => 'Den här användaren har dolt sin profil';

  @override
  String get profilePageFriendsOnly =>
      'Den här användaren visar endast profilen för vänner';

  @override
  String get profilePageLppId => 'StartLink-ID';

  @override
  String get profilePageRemarkName => 'Noteringar';

  @override
  String get profilePageEditRemark => 'Redigera smeknamn';

  @override
  String get profilePageSaveRemarkSuccess => 'Smeknamnet sparat';

  @override
  String get profilePageSaveRemarkFailed => 'Kunde inte spara. Försök igen.';

  @override
  String get searchTitle => 'Sök';

  @override
  String get searchHint => 'Sök via telefon, e-post eller StartLink-ID';

  @override
  String get searchNoResults => 'Inga resultat hittades';

  @override
  String get searchMessages => 'Meddelanden';

  @override
  String get searchUsers => 'Användare';

  @override
  String get searchFailed => 'Sökningen misslyckades. Försök igen.';

  @override
  String get scanTitle => 'Skanna';

  @override
  String get scanFailed => 'Igenkänningen misslyckades. Försök igen.';

  @override
  String get scanInvalidQrCode => 'Ogiltig QR-kod';

  @override
  String get scanFlashOn => 'Slå på ficklampan';

  @override
  String get scanFlashOff => 'Slå av ficklampan';

  @override
  String get scanAlbum => 'Välj från album';

  @override
  String get favoritesTitle => 'Favoriter';

  @override
  String get favoritesEmpty => 'Inget sparat ännu';

  @override
  String get favoritesAll => 'Alla';

  @override
  String get favoritesText => 'Text';

  @override
  String get favoritesImage => 'Bilder';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Röst';

  @override
  String get favoritesFile => 'Filer';

  @override
  String get favoritesOther => 'Övrigt';

  @override
  String get favoritesDeleteConfirm => 'Ta bort från favoriter?';

  @override
  String get favoritesDeleteSuccess => 'Borttagen från sparade';

  @override
  String get favoritesDeleteFailed => 'Kunde inte ta bort';

  @override
  String get favoritesOriginalRecalled => 'Meddelandet återkallat';

  @override
  String get favoritesViewOriginal => 'Visa original';

  @override
  String get favoritesSearchHint => 'Sök favoriter';

  @override
  String get favoritesNoResults => 'Inga matchande favoriter';

  @override
  String get noticeTitle => 'Anslag';

  @override
  String get noticeEmpty => 'Inga anslag';

  @override
  String get noticeDetail => 'Anslagsdetaljer';

  @override
  String get noticePublishedAt => 'Publicerat';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Viktigt';

  @override
  String get noticePriorityUrgent => 'Brådskande';

  @override
  String get organizationTitle => 'Organisation';

  @override
  String get organizationEmpty => 'Ingen avdelningsinformation';

  @override
  String get organizationMembers => 'Medlemmar';

  @override
  String get organizationDepartment => 'Avdelning';

  @override
  String get organizationPosition => 'Befattning';

  @override
  String get organizationLeader => 'Chef';

  @override
  String get qrCodeTitle => 'Min QR-kod';

  @override
  String get qrCodeSave => 'Spara till Album';

  @override
  String get qrCodeShare => 'Dela';

  @override
  String get qrCodeSaveSuccess => 'Sparad i album';

  @override
  String get qrCodeSaveFailed => 'Kunde inte spara. Försök igen.';

  @override
  String get qrCodeRefresh => 'Uppdatera QR-kod';

  @override
  String get qrCodeExpired => 'QR-koden har gått ut. Uppdatera den.';

  @override
  String get qrCodeScanToAdd => 'Skanna för att lägga till mig som kontakt';

  @override
  String get spacePersonal => 'Personligt';

  @override
  String get spaceEnterprise => 'Företag';

  @override
  String get spaceJoinByCode => 'Gå med via företagskod';

  @override
  String get spaceJoinByInvite => 'Gå med via inbjudningskod';

  @override
  String get spaceEnterCode => 'Ange företagskod';

  @override
  String get spaceEnterInviteCode => 'Ange inbjudningskod';

  @override
  String get spaceSearchEnterprise => 'Sök företag';

  @override
  String get spaceJoinRequestSent =>
      'Förfrågan inskickad, väntar på godkännande';

  @override
  String get spaceJoinRequestPending => 'Väntar på godkännande';

  @override
  String get spaceJoinRequestApproved => 'Förfrågan godkänd';

  @override
  String get spaceJoinRequestRejected => 'Förfrågan avvisad';

  @override
  String get spaceAlreadyMember => 'Du är redan medlem';

  @override
  String get spaceAutoApproved => 'Automatiskt godkänd. Välkommen!';

  @override
  String get spacePendingApprovalHint =>
      'Registreringen lyckades. Din ansökan om att gå med har skickats in.';

  @override
  String get spaceNoSpaces => 'Inga utrymmen';

  @override
  String get spaceInviteExpired => 'Inbjudningskoden har gått ut';

  @override
  String get spaceInviteTargetMismatch =>
      'Den här inbjudningskoden är inte för ditt konto';

  @override
  String get spaceAcceptInviteSuccess => 'Du har gått med i företaget';

  @override
  String get spaceAcceptInviteFailed => 'Kunde inte gå med. Försök igen.';

  @override
  String get spaceTenantSelectTitle => 'Välj utrymme';

  @override
  String get spaceTenantSelectHint => 'Välj ett utrymme att öppna';

  @override
  String get spaceEnterPersonal => 'Öppna personligt utrymme';

  @override
  String get spaceEnterEnterprise => 'Öppna företagsutrymme';

  @override
  String get aboutTitle => 'Om StartLink';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutTerms => 'Användaravtal';

  @override
  String get aboutPrivacy => 'Integritetspolicy';

  @override
  String get aboutOpenSource => 'Licenser för öppen källkod';

  @override
  String get aboutCheckUpdate => 'Sök efter uppdateringar';

  @override
  String get aboutLatestVersion => 'Du använder den senaste versionen';

  @override
  String get aboutUpdateAvailable => 'Ny version tillgänglig';

  @override
  String get aboutUpdateNow => 'Uppdatera nu';

  @override
  String get aboutUpdateLater => 'Senare';

  @override
  String get notificationTitle => 'Aviseringar';

  @override
  String get notificationGlobalMute => 'Stör ej';

  @override
  String get notificationSound => 'Ljud';

  @override
  String get notificationVibration => 'Vibration';

  @override
  String get notificationPreview => 'Förhandsvisning av meddelanden';

  @override
  String get notificationDndStart => 'Starttid för Stör ej';

  @override
  String get notificationDndEnd => 'Sluttid för Stör ej';

  @override
  String get blacklistTitle => 'Svartlistad';

  @override
  String get blacklistEmpty => 'Inga blockerade användare';

  @override
  String get blacklistRemove => 'Avblockera';

  @override
  String get blacklistRemoveConfirm => 'Avblockera den här användaren?';

  @override
  String get feedbackTitle => 'Återkoppling';

  @override
  String get feedbackTypeComplaint => 'Klagomål';

  @override
  String get feedbackTypeSuggestion => 'Förslag';

  @override
  String get feedbackTypeBug => 'Felrapport';

  @override
  String get feedbackContent => 'Beskrivning';

  @override
  String get feedbackContentHint =>
      'Beskriv ditt problem eller förslag i detalj';

  @override
  String get feedbackContact => 'Kontakt (valfritt)';

  @override
  String get feedbackSubmit => 'Skicka in';

  @override
  String get feedbackSuccess => 'Återkopplingen skickad. Tack!';

  @override
  String get feedbackFailed => 'Inskickningen misslyckades. Försök igen.';

  @override
  String get networkTitle => 'Byt linje';

  @override
  String get networkAutoSelect => 'Automatiskt';

  @override
  String get networkManual => 'Manuellt';

  @override
  String get timezoneTitle => 'Tidszon';

  @override
  String get timezoneAuto => 'Följ systemet';

  @override
  String get autoTranslateTitle => 'Automatisk översättning';

  @override
  String get autoTranslateEnabled => 'Aktivera automatisk översättning';

  @override
  String get autoTranslateLanguage => 'Målspråk';

  @override
  String get displayTitle => 'Visning';

  @override
  String get displayFontSize => 'Teckensnittsstorlek';

  @override
  String get displayChatBackground => 'Chattbakgrund';

  @override
  String get displayDarkMode => 'Utseende';

  @override
  String get displayDarkModeSystem => 'Följ systemet';

  @override
  String get displayDarkModeSystemHint =>
      'Växla automatiskt efter systeminställningen';

  @override
  String get displayDarkModeOff => 'Ljust';

  @override
  String get displayDarkModeOffHint => 'Använd alltid ljust tema';

  @override
  String get displayDarkModeOn => 'Mörkt';

  @override
  String get displayDarkModeOnHint => 'Använd alltid mörkt tema';

  @override
  String get chatSettingsTitle => 'Chatt';

  @override
  String get chatHistoryTitle => 'Chatthistorik';

  @override
  String get chatHistoryClear => 'Rensa all historik';

  @override
  String get chatHistoryClearConfirm =>
      'Rensa all chatthistorik? Detta kan inte ångras.';

  @override
  String get chatHistoryClearSuccess => 'Chatthistoriken rensad';

  @override
  String get accountSecurityTitle => 'Kontosäkerhet';

  @override
  String get accountSecurityChangePassword => 'Ändra lösenord';

  @override
  String get accountSecurityChangeMobile => 'Ändra telefonnummer';

  @override
  String get accountSecurityChangeEmail => 'Byt e-post';

  @override
  String get accountSecurityLoggedDevices => 'Inloggade enheter';

  @override
  String get accountSecurityDeactivate => 'Radera konto';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Alla data raderas permanent efter 7 dagar. Radera kontot?';

  @override
  String get loggedDevicesTitle => 'Inloggade enheter';

  @override
  String get loggedDevicesCurrent => 'Den här enheten';

  @override
  String get loggedDevicesRevoke => 'Logga ut';

  @override
  String get loggedDevicesRevokeConfirm => 'Logga ut från den här enheten?';

  @override
  String get loggedDevicesRevokeSuccess => 'Utloggad från enheten';

  @override
  String get loggedDevicesRevokeFailed => 'Misslyckades. Försök igen.';

  @override
  String get loggedDevicesLastActive => 'Senast aktiv';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Webb';

  @override
  String get loggedDevicesTypeDesktop => 'Dator';

  @override
  String get loggedDevicesTypeUnknown => 'Okänd enhet';

  @override
  String get privacySettingsTitle => 'Integritet';

  @override
  String get privacySearchableByMobile => 'Tillåt sökning via telefonnummer';

  @override
  String get privacySearchableByLppId => 'Tillåt sökning via StartLink-ID';

  @override
  String get privacyAllowFriendRequest => 'Tillåt vänförfrågningar';

  @override
  String get privacyProfileVisibility => 'Profilsynlighet';

  @override
  String get privacyEveryone => 'Alla';

  @override
  String get privacyFriendsOfFriends => 'Vänners vänner';

  @override
  String get privacyNobody => 'Ingen';

  @override
  String get privacyFriendsOnly => 'Endast vänner';

  @override
  String get privacySaveSuccess => 'Inställningarna sparade';

  @override
  String get privacySaveFailed => 'Kunde inte spara. Försök igen.';

  @override
  String get fontSizeTitle => 'Teckensnittsstorlek';

  @override
  String get fontSizeSmall => 'Liten';

  @override
  String get fontSizeNormal => 'Normal';

  @override
  String get fontSizeLarge => 'Stor';

  @override
  String get fontSizeExtraLarge => 'Extra stor';

  @override
  String get fontSizePreview => 'Förhandsvisning';

  @override
  String get chatBackgroundTitle => 'Chattbakgrund';

  @override
  String get chatBackgroundDefault => 'Standard';

  @override
  String get chatBackgroundCustom => 'Anpassat';

  @override
  String get chatBackgroundReset => 'Återställ standardvärden';

  @override
  String get termsTitle => 'Användaravtal';

  @override
  String get privacyPolicyTitle => 'Integritetspolicy';

  @override
  String get recentContactsTitle => 'Senaste';

  @override
  String get recentContactsEmpty => 'Inga senaste kontakter';

  @override
  String get inviteFriendsTitle => 'Bjud in vänner';

  @override
  String get inviteFriendsCopyLink => 'Kopiera inbjudningslänk';

  @override
  String get inviteFriendsLinkCopied => 'Inbjudningslänk kopierad';

  @override
  String get imageViewerTitle => 'Foto';

  @override
  String get imageViewerSave => 'Spara till Album';

  @override
  String get imageViewerSaveSuccess => 'Sparad i album';

  @override
  String get imageViewerSaveFailed => 'Kunde inte spara. Försök igen.';

  @override
  String get customerServiceTitle => 'Servicecenter';

  @override
  String get customerServiceQueue => 'I kö';

  @override
  String get customerServiceActive => 'Aktiv';

  @override
  String get customerServiceClaim => 'Acceptera';

  @override
  String get customerServiceTakeover => 'Ta över';

  @override
  String get customerServiceClose => 'Avsluta service';

  @override
  String get customerServiceCloseConfirm => 'Avsluta den här servicesessionen?';

  @override
  String get customerServiceNoQueue => 'Inga sessioner i kö';

  @override
  String get customerServiceNoActive => 'Inga aktiva sessioner';

  @override
  String get customerServiceVisitor => 'Besökare';

  @override
  String get customerServiceCustomer => 'Kund';

  @override
  String get customerServiceAssignedTo => 'Tilldelad till';

  @override
  String get customerServiceTransferConversation => 'Överför chatt';

  @override
  String get marketingToolbar => 'Marknadsföringsverktyg';

  @override
  String get callIncoming => 'Inkommande samtal';

  @override
  String get callOutgoing => 'Utgående samtal';

  @override
  String get callAccept => 'Acceptera';

  @override
  String get callReject => 'Neka';

  @override
  String get callHangup => 'Avsluta';

  @override
  String get callMissed => 'Missat samtal';

  @override
  String get callDuration => 'Längd';

  @override
  String get callAudio => 'Röstsamtal';

  @override
  String get callGeneric => 'Samtal';

  @override
  String get callVideo => 'Videosamtal';

  @override
  String get callConnecting => 'Ansluter…';

  @override
  String get callRinging => 'Ringer…';

  @override
  String get callEnded => 'Samtalet avslutat';

  @override
  String get callFailed => 'Samtalet misslyckades';

  @override
  String get callRejected => 'Samtalet avvisat';

  @override
  String get callTimeout => 'Inget svar';

  @override
  String get callCancelled => 'Avbrutet';

  @override
  String get callUnknownPeer => 'Okänt';

  @override
  String get callVideoInvitation => 'Inbjudan till videosamtal';

  @override
  String get callAudioInvitation => 'Inbjudan till röstsamtal';

  @override
  String get callAnswerAudio => 'Svara med ljud';

  @override
  String get callAnswerVideo => 'Svara med video';

  @override
  String get callViewProfile => 'Visa profil';

  @override
  String get callOpeningCamera => 'Öppnar kameran…';

  @override
  String get callWaitingRemoteVideo => 'Väntar på den andras video…';

  @override
  String get callCameraOff => 'Kamera av';

  @override
  String get callCameraOn => 'Kamera på';

  @override
  String get callMicrophoneOff => 'Mikrofon av';

  @override
  String get callMicrophoneOn => 'Mikrofon på';

  @override
  String get callSpeakerOff => 'Högtalare av';

  @override
  String get callSpeakerOn => 'Högtalare på';

  @override
  String get callVideoPermissionFailure =>
      'Videosamtalet kunde inte startas. Kontrollera kamera- och mikrofonbehörigheterna och försök igen.';

  @override
  String get callAudioPermissionFailure =>
      'Röstsamtalet kunde inte startas. Kontrollera mikrofonbehörigheten och försök igen.';

  @override
  String get callIncompleteIncoming =>
      'Informationen om det inkommande samtalet är ofullständig och det kan inte besvaras.';

  @override
  String get callInProgress => 'I samtal';

  @override
  String get callCalling => 'Ringer…';

  @override
  String callEndedMedia(String media) {
    return '$media avslutat';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media avvisades';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media besvarades inte';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media avbröts';
  }

  @override
  String get callConnectionLost => 'Samtalsanslutningen bröts';

  @override
  String get callAdminEnded => 'Samtalet avslutat av administratör';

  @override
  String callFailedMedia(String media) {
    return '$media misslyckades';
  }

  @override
  String get callBusy => 'Den andra är upptagen';

  @override
  String callDurationValue(String duration) {
    return 'Samtalslängd $duration';
  }

  @override
  String get callNotConnected => 'Inte ansluten';

  @override
  String get callDialed => 'Utgående';

  @override
  String get callAnswered => 'Besvarat';

  @override
  String get callRejectedByPeer => 'Avvisat av den andra';

  @override
  String get callRejectedBySelf => 'Avvisad';

  @override
  String get callPeerDidNotAnswer => 'Den andra svarade inte';

  @override
  String get callMissedIncoming => 'Missat inkommande samtal';

  @override
  String get callPeerCancelled => 'Avbrutet av den andra';

  @override
  String get notificationNewMessageTitle => 'Nytt StartLink-meddelande';

  @override
  String get notificationOnlineServiceTitle => 'Nytt kundservicemeddelande';

  @override
  String get notificationNewMessageBody => 'Du har fått ett nytt meddelande';

  @override
  String get notificationImagePreview => 'Skickade en bild';

  @override
  String get notificationVideoPreview => 'Skickade en video';

  @override
  String get notificationVoicePreview => 'Skickade ett röstmeddelande';

  @override
  String get notificationFilePreview => 'Skickade en fil';

  @override
  String get notificationContactPreview => 'Skickade ett kontaktkort';

  @override
  String get notificationCallLogPreview => 'Skickade en samtalspost';

  @override
  String get notificationLocationPreview => 'Delade en plats';

  @override
  String get notificationLinkPreview => 'Delade en länk';

  @override
  String notificationMentionMe(String body) {
    return 'Nämnde dig: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender nämnde dig: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Nämnde alla: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender nämnde alla: $body';
  }

  @override
  String get notificationSecurityTitle => 'Kontosäkerhetsvarning';

  @override
  String get notificationSecurityBody =>
      'Säkerhetsinställningarna för ditt StartLink-konto har ändrats. Kontrollera dem nu.';

  @override
  String get notificationFriendAcceptedTitle => 'Vänförfrågan accepterad';

  @override
  String get notificationFriendRejectedTitle => 'Vänförfrågan avvisad';

  @override
  String get notificationFriendAcceptedBody =>
      'Den andra accepterade din vänförfrågan';

  @override
  String get notificationFriendRejectedBody =>
      'Den andra avvisade din vänförfrågan';

  @override
  String get notificationVideoCallTitle => 'Inbjudan till videosamtal';

  @override
  String get notificationAudioCallTitle => 'Inbjudan till röstsamtal';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller bjöd in dig till ett videosamtal';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller bjöd in dig till ett röstsamtal';
  }

  @override
  String get notificationMessageChannelName => 'Meddelanden';

  @override
  String get notificationMessageChannelDescription =>
      'Chattmeddelanden, samtalsposter och systemvarningar';

  @override
  String get notificationCallChannelName => 'Samtal';

  @override
  String get notificationCallChannelDescription =>
      'Aviseringar om röst- och videosamtal';

  @override
  String get notificationSecurityChannelName => 'Kontosäkerhet';

  @override
  String get notificationSecurityChannelDescription =>
      'Aviseringar om inloggning samt ändringar av lösenord och mobilnummer';

  @override
  String get notificationUnknownCaller => 'Okänd uppringare';

  @override
  String get pendingJoinRequestsTitle => 'Nya ansökningar';

  @override
  String get pendingJoinRequestsEmpty => 'Inga ansökningar';

  @override
  String get pendingJoinRequestApprove => 'Godkänn';

  @override
  String get pendingJoinRequestReject => 'Neka';

  @override
  String get pendingJoinRequestApproveSuccess => 'Godkänd';

  @override
  String get pendingJoinRequestRejectSuccess => 'Avvisad';

  @override
  String get pendingJoinRequestFailed => 'Åtgärden misslyckades. Försök igen.';

  @override
  String get myCustomersTitle => 'Mina kunder';

  @override
  String get myCustomersEmpty => 'Inga kunder';

  @override
  String get groupListTitle => 'Grupper';

  @override
  String get groupListEmpty => 'Inga grupper';

  @override
  String get addFriendTitle => 'Lägg till kontakt';

  @override
  String get addFriendSearchHint => 'Telefon / E-post / StartLink-ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink-ID: $lppId';
  }

  @override
  String get addFriendButton => 'Lägg till';

  @override
  String get addFriendCannotAddSelf => 'Du kan inte lägga till dig själv';

  @override
  String get addFriendUnsupportedUser =>
      'Den här användaren kan inte läggas till. Du kan skriva direkt.';

  @override
  String get addFriendMessageHint => 'Ange ett meddelande';

  @override
  String get addFriendSendRequest => 'Skicka förfrågan';

  @override
  String get joinCompanyTitle => 'Gå med i företag';

  @override
  String get joinCompanyCodeHint => 'Ange företagskod';

  @override
  String get joinCompanySearchHint => 'Sök företagsnamn';

  @override
  String get joinCompanyApply => 'Ansök om att gå med';

  @override
  String get joinCompanyApplySuccess => 'Ansökan inskickad';

  @override
  String get joinCompanyApplyFailed => 'Ansökan misslyckades. Försök igen.';

  @override
  String get joinCompanyAutoApproved => 'Automatiskt godkänd. Välkommen!';

  @override
  String get joinCompanyPending => 'Ansökan inskickad, väntar på godkännande';

  @override
  String get joinCompanyInviteCodeHint => 'Ange inbjudningskod';

  @override
  String get joinCompanyAcceptInvite => 'Acceptera inbjudan';

  @override
  String get joinCompanyNoResults => 'Inga företag hittades';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count medlemmar';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Stillahavstid';

  @override
  String get timezoneNameMountainTime => 'Bergstid';

  @override
  String get timezoneNameCentralTime => 'Centraltid';

  @override
  String get timezoneNameEasternTime => 'Östkusttid';

  @override
  String get timezoneNameAtlanticTime => 'Atlanttid';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azorerna';

  @override
  String get timezoneNameLondonDublin => 'London/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Rom';

  @override
  String get timezoneNameCairoHelsinki => 'Kairo/Helsingfors';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskva/Riyadh';

  @override
  String get timezoneNameTehran => 'Teheran';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Baku';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karachi/Tasjkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/New Delhi';

  @override
  String get timezoneNameKathmandu => 'Katmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dhaka/Almaty';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoi/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Peking/Shanghai/Hongkong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokyo/Seoul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Salomonöarna';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute => 'Välj den bästa rutten automatiskt';

  @override
  String get networkTesting => 'Testar…';

  @override
  String get networkTestingShort => 'Testar';

  @override
  String networkLatencyMs(int ms) {
    return 'Fördröjning $ms ms';
  }

  @override
  String get networkConnectionMode => 'Anslutningsläge';

  @override
  String get networkDirectMode => 'Direktläge';

  @override
  String get networkProxyMode => 'Proxyläge';

  @override
  String get networkDirectModeDesc => 'Anslut direkt till servern';

  @override
  String get networkProxyModeDesc => 'Anslut via en proxyserver';

  @override
  String get networkDirectRoutes => 'Direkta rutter';

  @override
  String get networkProxyRoutes => 'Proxyrutter';

  @override
  String get networkTestAll => 'Testa alla';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Hongkong-nod';

  @override
  String get networkSingaporeNode => 'Singapore-nod';

  @override
  String get networkJapanNode => 'Japan-nod';

  @override
  String get networkUnitedStatesNode => 'USA-nod';

  @override
  String get networkHint =>
      'Tips:\n• Direktläge: snabbare och lämpligt för inhemsk användning\n• Proxyläge: stabilare för kommunikation över gränser\n• Tryck på uppdateringsikonen för att testa fördröjningen för en rutt';

  @override
  String get teenModeTitle => 'Tonårsläge';

  @override
  String get teenModeStatusOn => 'På';

  @override
  String get teenModeStatusOff => 'Av';

  @override
  String get teenModeStatusLoading => 'Läser in';

  @override
  String get teenModeUnavailable =>
      'Status för tonårsläge är tillfälligt otillgänglig';

  @override
  String get teenModeInvalidResponse =>
      'Tonårsläget returnerade ett ogiltigt svar';

  @override
  String get teenModeEnableDescription =>
      'Plattformens regler begränsar användningstid och utvalda funktioner.';

  @override
  String get teenModePasscode => 'Åtkomstkod';

  @override
  String get teenModeCurrentPasscode => 'Nuvarande åtkomstkod';

  @override
  String get teenModeNewPasscode => 'Ny åtkomstkod';

  @override
  String get teenModePasscodeHint => 'Ange 4–6 siffror';

  @override
  String get teenModeEnable => 'Slå på tonårsläge';

  @override
  String get teenModeDisable => 'Stäng av tonårsläge';

  @override
  String get teenModeChangePasscode => 'Ändra åtkomstkod';

  @override
  String get teenModeSource => 'Aktiverat av';

  @override
  String get teenModeDailyUsage => 'Använt i dag';

  @override
  String get teenModeRemaining => 'Återstående tid';

  @override
  String get teenModeMinutesUnit => 'Minuter';

  @override
  String get teenModeUnlimited => 'Obegränsat';

  @override
  String get teenModeRequestExtension => 'Begär mer tid';

  @override
  String get teenModeExtensionSubmitted =>
      'Tidsbegäran skickades till en vårdnadshavare';

  @override
  String get teenModeTimeLimitReached => 'Dagens användningsgräns har nåtts';

  @override
  String get teenModeCurfewActive =>
      'Användningen är begränsad under den här perioden';

  @override
  String get teenModeReliefHint =>
      'Du kan fortfarande se historik, kontakta officiell support och rapportera problem.';

  @override
  String get teenModeRestrictedNotice =>
      'Tonårsläget förhindrar för närvarande att meddelanden skickas';

  @override
  String get teenModeActionBlocked =>
      'Tonårsläget förhindrar för närvarande den här åtgärden';

  @override
  String get teenModeMyRequests => 'Mina förfrågningar';

  @override
  String get guardianCenterTitle => 'Vårdnadshavarcenter';

  @override
  String get guardianRelationships => 'Vårdnadshavarrelationer';

  @override
  String get guardianMinors => 'Barn jag övervakar';

  @override
  String get guardianApprovals => 'Väntande godkännanden';

  @override
  String get guardianBind => 'Ange kopplingskod';

  @override
  String get guardianCreateMinorCode => 'Jag är barn — skapa kod';

  @override
  String get guardianCreateGuardianCode => 'Jag är vårdnadshavare — skapa kod';

  @override
  String get guardianRelation => 'Relation';

  @override
  String get guardianPrimary => 'Primär vårdnadshavare';

  @override
  String get guardianCode => '6-siffrig kopplingskod';

  @override
  String get guardianCodeHint => 'Ange koden från den andra personen';

  @override
  String get guardianCodeCreated => 'Koden skapad. Dela den innan den går ut.';

  @override
  String get guardianEmpty => 'Inga vårdnadshavarrelationer';

  @override
  String get guardianNoMinors => 'Inga övervakade barn';

  @override
  String get guardianUnbind => 'Ta bort relation';

  @override
  String get guardianExtend => 'Lägg till tid för barnet';

  @override
  String get guardianPolicyTitle => 'Användningsregler';

  @override
  String get guardianPolicyLocked => 'Låst av plattformen';

  @override
  String get approvalEmpty => 'Inga förfrågningar';

  @override
  String get approvalApprove => 'Godkänn';

  @override
  String get approvalReject => 'Neka';

  @override
  String get approvalPending => 'Väntar';

  @override
  String get approvalApproved => 'Godkänd';

  @override
  String get approvalRejected => 'Avvisad';

  @override
  String get approvalExpired => 'Utgången';

  @override
  String get approvalCancelled => 'Avbrutet';

  @override
  String get approvalReplayFailed =>
      'Den ursprungliga åtgärden misslyckades. Försök igen.';

  @override
  String get requestCancelled => 'Förfrågan avbruten';

  @override
  String get kycTitle => 'Identitetsverifiering';

  @override
  String get kycNotRequired => 'Identitetsverifiering krävs inte';

  @override
  String get kycVerified => 'Identitet verifierad';

  @override
  String get kycDeclared => 'Identitetsuppgifter inskickade';

  @override
  String get kycPending => 'Under granskning';

  @override
  String get kycRejected => 'Granskning avvisad';

  @override
  String get kycNone => 'Inga identitetsuppgifter inskickade';

  @override
  String get kycRealName => 'Fullständigt namn';

  @override
  String get kycIdNumber => 'ID-nummer';

  @override
  String get kycIdType => 'Dokumenttyp';

  @override
  String get kycApplicability =>
      'Ange dina riktiga uppgifter för det valda dokumentet. Godkända typer visas i listan.';

  @override
  String get kycCamera => 'Ta foto';

  @override
  String get kycGallery => 'Välj från album';

  @override
  String get kycPhotoLimit => 'Maximalt per foto';

  @override
  String get kycSelectPhoto => 'Välj foto';

  @override
  String get kycPhotoSelected => 'Valt';

  @override
  String get kycViewPhoto => 'Tryck för att visa foto';

  @override
  String get kycReplacePhoto => 'Välj ett annat foto';

  @override
  String get kycDisclosure =>
      'Vi använder ditt namn, dokumentnummer och dokumentfoton för att granska din identitet. Utan dem kan du inte skicka in, och vissa begränsade funktioner kan vara otillgängliga.';

  @override
  String get kycConsent =>
      'Jag samtycker separat till denna behandling av identitetsuppgifter';

  @override
  String get kycConsentRequired => 'Ge separat samtycke innan du skickar in';

  @override
  String get kycResubmitTitle => 'Skicka in identitetsuppgifter igen';

  @override
  String get kycResubmitWarning =>
      'En ny inskickning ersätter din väntande ansökan. Fortsätta?';

  @override
  String get kycSubmitting => 'Skickar in';

  @override
  String get kycSubmitFailed => 'Inskickningen misslyckades. Försök igen.';

  @override
  String get kycSubmitUnavailable =>
      'Identitetsuppgifter kan inte skickas in nu';

  @override
  String get kycResubmitNotAllowed =>
      'Ny inskickning är inte tillgänglig efter avslag. Kontakta support vid behov.';

  @override
  String get kycDailyLimit =>
      'Du har nått dagens inskickningsgräns. Försök i morgon.';

  @override
  String get kycTypeUnavailable =>
      'Inga dokumenttyper tillgängliga. Försök igen senare.';

  @override
  String get kycNameInvalid => 'Juridiskt namn måste vara 2–64 tecken';

  @override
  String get kycNumberRequired => 'Ange ditt ID-nummer';

  @override
  String get kycFrontRequired => 'Ladda upp dokumentets framsida';

  @override
  String get kycBackRequired => 'Ladda upp dokumentets baksida';

  @override
  String get kycPhotoTooLarge =>
      'Fotot överskrider storleksgränsen. Komprimera det och försök igen.';

  @override
  String get kycAccountChanged =>
      'Kontot eller utrymmet har ändrats. Öppna sidan igen.';

  @override
  String get kycPhotoInvalid => 'Välj en giltig bild';

  @override
  String get kycPortraitSide => 'Porträttsida';

  @override
  String get kycEmblemSide => 'Emblemsida';

  @override
  String get kycPassportDataPage => 'Passets datasida';

  @override
  String get kycPassportOtherPage => 'Passets visumsida eller tomma sida';

  @override
  String get kycFront => 'ID-kortets framsida';

  @override
  String get kycBack => 'ID-kortets baksida';

  @override
  String get kycRequired =>
      'Identitetsverifiering krävs innan du skapar en grupp';

  @override
  String get kycGoVerify => 'Verifiera nu';

  @override
  String get kycStatusUnknown =>
      'Identitetsstatus är otillgänglig. Uppdatera senare.';

  @override
  String get kycSuperseded =>
      'En senare inskickning ersatte denna. Kontrollera din senaste identitetsstatus.';

  @override
  String get kycMediaNotFound =>
      'Dokumentfotot är otillgängligt i detta utrymme. Välj det igen innan du skickar in.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Kundutskick';

  @override
  String get officialAccountBadge => 'Officiell';

  @override
  String get officialAccountOpenConversation => 'Öppna konversation';

  @override
  String get officialAccountJoinHint =>
      'När du lägger till detta konto går du med i företaget som kund. Vängodkännande krävs inte.';

  @override
  String get officialAccountJoinDisabled =>
      'Detta företag tar inte emot nya kunder. Kontakta support.';

  @override
  String get officialAccountRemoved =>
      'Du har tagits bort från företaget. Be företaget bjuda in dig igen.';

  @override
  String get officialAccountBanned =>
      'Ditt konto har inaktiverats i detta företag.';

  @override
  String get officialAccountUnavailable =>
      'Detta officiella konto är inte tillgängligt för närvarande.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Det är inte tillåtet att gå med i ett företag i detta läge.';

  @override
  String get officialAccountPlatformRequired =>
      'Använd ett plattformskonto för att lägga till detta officiella konto.';

  @override
  String get officialAccountOpenFailed =>
      'Konversationen kunde inte öppnas. Försök igen.';

  @override
  String get officialAccountAccountChanged =>
      'Kontot eller utrymmet har ändrats. Öppna igen.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Företagskatalogen är inte uppdaterad. Försök strax igen.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Synkroniseringen av det officiella kontot misslyckades. Lokalt innehåll är fortfarande tillgängligt.';

  @override
  String get officialAccountInboxSyncing =>
      'Synkroniserar officiella kontomeddelanden';

  @override
  String get diagnosticsTitle => 'Diagnostik';

  @override
  String get diagnosticsExplanation =>
      'Loggarna är maskerade och innehåller drift- och felinformation för detta konto och utrymme samt offentliga starthändelser. Chattinnehåll och inloggningsuppgifter är uteslutna.';

  @override
  String get diagnosticsHour => 'Senaste timmen';

  @override
  String get diagnosticsDay => 'Senaste 24 timmarna';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Tillgängliga händelser: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Loggarna sparas på den här enheten och är tillgängliga efter omstart.';

  @override
  String get diagnosticsNotPersistent =>
      'Vissa loggar har inte sparats. Uppdatera för att försöka igen.';

  @override
  String get diagnosticsExport => 'Exportera och dela';

  @override
  String get diagnosticsRefresh => 'Uppdatera';

  @override
  String get diagnosticsClear => 'Rensa detta utrymmes loggar';

  @override
  String get diagnosticsClearConfirm =>
      'Rensa diagnostikloggar för detta utrymme? Chatthistoriken behålls.';

  @override
  String get diagnosticsShared =>
      'Systemdelningen klar. Kontrollera filen i mottagarappen.';

  @override
  String get diagnosticsCancelled =>
      'Delningen avbruten. Du kan exportera igen.';

  @override
  String get diagnosticsUnconfirmed =>
      'Delningen kunde inte bekräftas. Kontrollera mottagarappen.';

  @override
  String get diagnosticsFailed => 'Åtgärden misslyckades. Försök igen.';
}
