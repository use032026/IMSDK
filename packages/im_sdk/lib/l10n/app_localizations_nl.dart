// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get navWorkbench => 'Werkplek';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed =>
      'Accountgegevens konden niet worden geladen';

  @override
  String get startupFailureTitle => 'Opstarten mislukt';

  @override
  String get startupFailureMessage =>
      'Controleer uw verbinding en probeer het opnieuw';

  @override
  String get privacyConsentTitle => 'Algemene voorwaarden & Privacybeleid';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Welkom bij $brand. Voor accountaanmelding, chatberichten, samenwerking binnen bedrijven, online klantenservice, meldingen en beveiliging moeten wij noodzakelijke informatie verwerken volgens de Gebruiksvoorwaarden en het Privacybeleid.\n\nVoordat u op ‘Akkoord’ tikt, lezen wij geen klembordgegevens, initialiseren wij JPush/JCore en push-SDK’s van apparaatfabrikanten niet en gebruiken wij deze niet voor toegang tot Android ID, OAID, lijsten met geïnstalleerde apps, MAC-adressen of vergelijkbare informatie. Als u voorlopig weigert, bewaren wij uw keuze; u kunt de documenten blijven lezen en later opnieuw kiezen.\n\nNa uw toestemming kunnen JPush/JCore en pushdiensten van apparaatfabrikanten voor bericht-, klantenservice- en oproepmeldingen het apparaatmodel, de Android-versie, het app-pakket en de app-versie, het netwerktype, het IP-adres, Android ID, OAID, de pushregistratie-ID, het pushtoken van de fabrikant en gegevens over bezorging en klikken op meldingen verwerken. Niet-noodzakelijke functies zoals slimme push, lijsten met geïnstalleerde apps, MAC, IMEI, IMSI, wifi-lijsten, automatisch activeren en gekoppeld opstarten zijn uitgeschakeld.\n\nHet klembord wordt alleen geraadpleegd wanneer u zelf kopieert of plakt. Toegang tot camera, microfoon, meldingen en andere systeemfuncties wordt alleen gevraagd wanneer u de bijbehorende functie gebruikt. Het weigeren van één toestemming heeft alleen gevolgen voor die functie. Lees hieronder de volledige documenten en kies of u akkoord gaat.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Welkom bij $brand. Voor accountaanmelding, chatberichten, samenwerking binnen bedrijven, online klantenservice, meldingen en beveiliging moeten wij noodzakelijke informatie verwerken volgens de Gebruiksvoorwaarden en het Privacybeleid.\n\nVoordat u op ‘Akkoord’ tikt, lezen wij geen klembordgegevens, initialiseren wij JPush/JCore niet, registreren wij ons niet bij Apple Push Notification service (APNs) en verkrijgen wij geen pushkenmerken zoals de JPush-registratie-ID of het APNs-apparaattoken. Als u voorlopig weigert, bewaren wij uw keuze; u kunt de documenten blijven lezen en later opnieuw kiezen.\n\nNa uw toestemming kunnen wij voor bericht-, klantenservice- en oproepmeldingen het iPhone-model, de iOS-versie, het app-pakket en de app-versie, het netwerktype, het IP-adres, IDFV, de JPush-registratie-ID, het APNs-apparaattoken en gegevens over bezorging en klikken op meldingen verwerken. JPush/JCore maakt verbinding met de pushdienst; Apple APNs verwerkt de app-ID, het apparaattoken en de meldingsinhoud om systeemmeldingen te bezorgen. De huidige iOS-app gebruikt geen advertentiediensten en verkrijgt geen IDFA.\n\nHet klembord wordt alleen geraadpleegd wanneer u zelf kopieert of plakt. Toegang tot camera, microfoon, meldingen en andere systeemfuncties wordt alleen gevraagd wanneer u de bijbehorende functie gebruikt. Het weigeren van één toestemming heeft alleen gevolgen voor die functie. Lees hieronder de volledige documenten en kies of u akkoord gaat.';
  }

  @override
  String get privacyConsentTermsLink => 'Gebruikersovereenkomst';

  @override
  String get privacyConsentConjunction => 'en';

  @override
  String get privacyConsentPrivacyLink => 'Privacybeleid';

  @override
  String get privacyConsentDecline => 'Niet akkoord';

  @override
  String get privacyConsentDeclinedExit =>
      'U bent niet akkoord gegaan met de Gebruiksvoorwaarden en het Privacybeleid. De app wordt nu gesloten.';

  @override
  String get privacyConsentAccept => 'Akkoord';

  @override
  String get privacyConsentRuntimeFailure =>
      'Opstarten mislukt. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get privacyConsentSaveFailure =>
      'Uw keuze kon niet worden opgeslagen. Probeer het opnieuw.';

  @override
  String get appUpdateRequiredTitle => 'Update vereist om door te gaan';

  @override
  String get appUpdateOptionalTitle => 'Nieuwe versie beschikbaar';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version is beschikbaar';
  }

  @override
  String get appUpdateLater => 'Later';

  @override
  String get appUpdateNow => 'Nu updaten';

  @override
  String get appUpdateProcessing => 'Bezig met verwerken…';

  @override
  String get appUpdateInvalidUrl =>
      'Het updateadres is ongeldig. Probeer het later opnieuw.';

  @override
  String get appUpdateOpenUrlFailed =>
      'De updatelink kon niet worden geopend. Probeer het later opnieuw.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Download onderbroken. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Pakketcontrole mislukt. Download het opnieuw.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Sta in de systeeminstellingen toe dat $brand updates installeert.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Het installatieprogramma kon niet worden geopend. Controleer de installatiemachtigingen.';

  @override
  String get appUpdateGenericFailure =>
      'Update mislukt. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get appUpdateUnavailable =>
      'De nieuwe versie kan nog niet worden gedownload. Probeer het later opnieuw.';

  @override
  String get appUpdateCheckFailed =>
      'Controleren op updates mislukt. Probeer het later opnieuw.';

  @override
  String get appUpdateChecking => 'Bezig met controleren';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Annuleren';

  @override
  String get commonSave => 'Opslaan';

  @override
  String get commonEdit => 'Bewerken';

  @override
  String get commonDelete => 'Verwijderen';

  @override
  String get commonSearch => 'Zoeken';

  @override
  String get commonLoading => 'Laden…';

  @override
  String get commonLoadFailed => 'Laden mislukt';

  @override
  String get commonRetry => 'Opnieuw proberen';

  @override
  String get commonEmpty => 'Geen gegevens';

  @override
  String get commonCopy => 'Kopiëren';

  @override
  String get commonForward => 'Doorsturen';

  @override
  String get commonFavorite => 'Opslaan';

  @override
  String get commonClose => 'Sluiten';

  @override
  String get commonSend => 'Verzenden';

  @override
  String get commonDone => 'Gereed';

  @override
  String get commonMore => 'Meer';

  @override
  String get commonSettings => 'Instellingen';

  @override
  String get commonCopied => 'Gekopieerd';

  @override
  String get commonUnknown => 'Onbekend';

  @override
  String get commonNotSet => 'Niet ingesteld';

  @override
  String get commonUnbound => 'Niet gekoppeld';

  @override
  String get commonViewAll => 'Alles bekijken';

  @override
  String get commonSubmit => 'Verzenden';

  @override
  String get commonAdd => 'Toevoegen';

  @override
  String get commonRemove => 'Verwijderen';

  @override
  String get commonCreate => 'Maken';

  @override
  String get commonUpdate => 'Bijwerken';

  @override
  String get commonUpload => 'Uploaden';

  @override
  String get commonShare => 'Delen';

  @override
  String get commonBlock => 'Blokkeren';

  @override
  String get commonUnblock => 'Deblokkeren';

  @override
  String get commonMute => 'Dempen';

  @override
  String get commonUnmute => 'Dempen opheffen';

  @override
  String get commonPin => 'Gepind';

  @override
  String get commonUnpin => 'Losmaken';

  @override
  String get commonMarkRead => 'Markeren als gelezen';

  @override
  String get commonMarkUnread => 'Markeren als ongelezen';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Bewerking mislukt. Probeer het opnieuw.';

  @override
  String get commonNetworkError => 'Netwerkfout. Controleer uw verbinding.';

  @override
  String get navMessages => 'Berichten';

  @override
  String get navContacts => 'Contacten';

  @override
  String get navMe => 'Ik';

  @override
  String get authLoginTitle => 'Aanmelden bij StartLink';

  @override
  String get authTabMobile => 'Telefoon';

  @override
  String get authTabEmail => 'E-mail';

  @override
  String get authTabLoginName => 'StartLink-ID';

  @override
  String get authHintMobile => 'Voer uw telefoonnummer in';

  @override
  String get authHintEmail => 'Voer uw e-mailadres in';

  @override
  String get authHintPassword => 'Wachtwoord invoeren';

  @override
  String get authHintCode => 'Voer de verificatiecode in';

  @override
  String get authHintLoginName => 'Voer uw StartLink-ID in (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Inloggen';

  @override
  String get authGetCode => 'Verstuur code';

  @override
  String authResendCode(int seconds) {
    return 'Opnieuw verzenden over $seconds s';
  }

  @override
  String get authUsePassword => 'Wachtwoord gebruiken';

  @override
  String get authUseCode => 'Verificatiecode gebruiken';

  @override
  String get authAgreementPrefix =>
      'Ik heb het volgende gelezen en ga ermee akkoord: ';

  @override
  String get authAgreementAnd => 'en';

  @override
  String get authTermsLink => 'Gebruikersovereenkomst';

  @override
  String get authPrivacyLink => 'Privacybeleid';

  @override
  String get authCaptchaTitle => 'Beveiligingscontrole';

  @override
  String get authCaptchaHint => 'Voer het antwoord in';

  @override
  String get authCaptchaFailed =>
      'Captcha ophalen mislukt. Probeer het opnieuw.';

  @override
  String get authErrorEmptyCode => 'Voer de verificatiecode in';

  @override
  String get authErrorEmptyPassword => 'Wachtwoord invoeren';

  @override
  String get authErrorEmptyLoginName => 'Voer uw StartLink-ID in';

  @override
  String get authErrorWrongCredentials => 'Onjuist account of wachtwoord';

  @override
  String get authDeactivatingTitle => 'Account verwijderen';

  @override
  String get authDeactivatingContent =>
      'Uw account bevindt zich in de bedenktijd voor verwijdering (7 dagen).\n\nTik op ‘Verwijdering annuleren’ om de verwijdering te annuleren, of op ‘Doorgaan’ om de app te openen.';

  @override
  String get authContinueUse => 'Doorgaan';

  @override
  String get authCancelDeactivation => 'Verwijdering annuleren';

  @override
  String get authDeactivationCancelled =>
      'Verwijdering geannuleerd, account hersteld';

  @override
  String get authDeactivationCancelFailed =>
      'Annuleren mislukt. Probeer het opnieuw.';

  @override
  String get authLogout => 'Afmelden';

  @override
  String get authLogoutConfirm => 'Weet u zeker dat u wilt afmelden?';

  @override
  String get authSendingCode => 'Verzenden…';

  @override
  String get authCodeSent => 'Verificatiecode verzonden';

  @override
  String get authLoginFailed => 'Aanmelden mislukt. Probeer het opnieuw.';

  @override
  String get authRegisterFailed => 'Registreren mislukt. Probeer het opnieuw.';

  @override
  String get authEnterpriseCode => 'Bedrijfscode';

  @override
  String get authEnterpriseCodeHint => 'Voer de bedrijfscode in';

  @override
  String get authPendingApproval =>
      'Registratie geslaagd. Uw aanvraag om lid te worden van het bedrijf is verzonden en wacht op goedkeuring.';

  @override
  String get authNoAccount => 'Hebt u nog geen account?';

  @override
  String get authRegisterNow => 'Nu registreren';

  @override
  String get authCountryPickerTitle => 'Selecteer land of regio';

  @override
  String get authCountrySearchHint => 'Zoek land of regio';

  @override
  String get authCountryChinaMainland => 'Vasteland van China';

  @override
  String get authCountryHongKong => 'Hongkong, China';

  @override
  String get authCountryMacau => 'Macau, China';

  @override
  String get authCountryTaiwan => 'Taiwan, China';

  @override
  String get authCountryUnitedStates => 'Verenigde Staten';

  @override
  String get authCountryUnitedKingdom => 'Verenigd Koninkrijk';

  @override
  String get authCountryJapan => 'Japan';

  @override
  String get authCountrySouthKorea => 'Zuid-Korea';

  @override
  String get authCountrySingapore => 'Singapore';

  @override
  String get authCountryMalaysia => 'Maleisië';

  @override
  String get authCountryAustralia => 'Australië';

  @override
  String get authCountryCanada => 'Canada';

  @override
  String get authCountryGermany => 'Duitsland';

  @override
  String get authCountryFrance => 'Frankrijk';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Thailand';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesië';

  @override
  String get authCountryPhilippines => 'Filipijnen';

  @override
  String get authQuickLoginTitle => 'Snel aanmelden';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Bezig met aanmelden. Even geduld.';

  @override
  String get authRoleOwner => 'Eigenaar';

  @override
  String get authRoleAdministrator => 'Beheerder';

  @override
  String get authRoleCustomerService => 'Klantenservice';

  @override
  String get authRoleTechnicalSupport => 'Technische ondersteuning';

  @override
  String get authRoleEmployee => 'Medewerker';

  @override
  String get authRoleMember => 'Lid';

  @override
  String get authRoleEnterpriseCustomer => 'Bedrijfsklant';

  @override
  String get authUnavailablePrefix => 'Niet beschikbaar · ';

  @override
  String get authUnassignedService => 'Geen servicemedewerker toegewezen';

  @override
  String authAssignedService(String staff) {
    return 'Toegewezen aan $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Klant · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Medewerker · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count gebruikers';
  }

  @override
  String get authMetaPhone => 'Telefoon';

  @override
  String get authMetaIdentity => 'Identiteit';

  @override
  String get authRegisterTitle => 'Registreren';

  @override
  String get authNickname => 'Bijnaam';

  @override
  String get authNicknameHint => 'Stel een bijnaam in';

  @override
  String get authPassword => 'Wachtwoord';

  @override
  String get authPasswordSetHint =>
      'Stel een wachtwoord in (minimaal 6 tekens)';

  @override
  String get authConfirmPassword => 'Bevestig wachtwoord';

  @override
  String get authConfirmPasswordHint => 'Voer het wachtwoord opnieuw in';

  @override
  String get authVerificationCode => 'Verificatiecode';

  @override
  String get authRegisterAndLogin => 'Registreren en aanmelden';

  @override
  String get authHaveAccount => 'Hebt u al een account?';

  @override
  String get authGoLogin => 'Inloggen';

  @override
  String get authEmailVerificationUnavailable =>
      'Verificatie per e-mail is niet beschikbaar. Registreer met een mobiel nummer.';

  @override
  String get authSmsVerificationUnavailable =>
      'Verificatie per sms is niet beschikbaar. Registreer met een e-mailadres.';

  @override
  String get authSendFailed => 'Verzenden mislukt. Probeer het opnieuw.';

  @override
  String get authErrorEmptyNickname => 'Voer een bijnaam in';

  @override
  String get authErrorInvalidMobile => 'Voer een geldig mobiel nummer in';

  @override
  String get authErrorInvalidEmail => 'Voer een geldig e-mailadres in';

  @override
  String get authErrorPasswordTooShort =>
      'Het wachtwoord moet minimaal 6 tekens bevatten';

  @override
  String get authErrorPasswordMismatch => 'De wachtwoorden komen niet overeen';

  @override
  String get authErrorVerificationRequired =>
      'Vraag eerst de verificatiecode aan en voer deze in';

  @override
  String get authRegisterErrorTitle => 'Registratie mislukt';

  @override
  String get authGotIt => 'Begrepen';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Bedrijf ‘$code’ niet gevonden. Controleer de bedrijfscode.';
  }

  @override
  String get authTenantSearchFailed => 'Zoeken mislukt. Probeer het opnieuw.';

  @override
  String get authInvitationInvalid =>
      'De uitnodigingscode is ongeldig. Controleer deze en probeer het opnieuw.';

  @override
  String get authCollapseJoin => 'Lidmaatschapsinformatie verbergen';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Geldige uitnodiging: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Bedrijf gevonden: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Selecteer organisatie';

  @override
  String get authNoOrganization => 'Geen organisaties beschikbaar';

  @override
  String get authNoOrganizationHint =>
      'Vraag een beheerder u uit te nodigen voor een organisatie';

  @override
  String get authPersonalSpace => 'Persoonlijke ruimte';

  @override
  String get authPersonalSpaceSubtitle =>
      'Chats met vrienden en persoonlijke favorieten';

  @override
  String get authSpaceIdentityValidationFailed =>
      'De identiteit van de ruimte kon niet worden gecontroleerd. Probeer het opnieuw.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'De persoonlijke ruimte kon niet worden hersteld. Probeer het opnieuw.';

  @override
  String get authJoinEnterpriseFailed =>
      'Lid worden van het bedrijf mislukt. Probeer het later opnieuw.';

  @override
  String get homeTitle => 'Berichten';

  @override
  String get homeGatewayConnectingTitle => 'Verbinden';

  @override
  String get homePersonalSpace => 'Persoonlijk';

  @override
  String get homeOfficialService => 'Officiële service';

  @override
  String get homeSwitchSpace => 'Ruimte wisselen';

  @override
  String get homeSpaceSubtitle => 'Persoonlijk · Bedrijf';

  @override
  String get homeJoinEnterprise => 'Lid worden van bedrijf';

  @override
  String get homeCreateGroup => 'Nieuwe groep';

  @override
  String get homeAddFriend => 'Contact toevoegen';

  @override
  String get homeScan => 'Scannen';

  @override
  String get homeJoinNewSpace => 'Lid worden van nieuwe ruimte';

  @override
  String get homeSearchConversation => 'Zoeken';

  @override
  String get homeNoMessages => 'Geen berichten';

  @override
  String get homeDeleteConversation => 'Chat verwijderen';

  @override
  String get homeDeleteConversationConfirm =>
      'Deze chat verwijderen? De chatgeschiedenis wordt gewist.';

  @override
  String get homePersonalNote => 'Ik (persoonlijke notities)';

  @override
  String get homeWorkNote => 'Ik (werknotities)';

  @override
  String homeConversationCount(int count) {
    return '$count chats';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count ongelezen';
  }

  @override
  String get chatInputHint => 'Typ een bericht…';

  @override
  String get chatVoiceHint => 'Ingedrukt houden om te praten';

  @override
  String get chatVoiceRelease => 'Loslaten om te verzenden';

  @override
  String get chatVoiceCancel => 'Omhoog vegen om te annuleren';

  @override
  String get chatMenuCopy => 'Kopiëren';

  @override
  String get chatMenuForward => 'Doorsturen';

  @override
  String get chatMenuRecall => 'Intrekken';

  @override
  String get chatMenuDelete => 'Verwijderen';

  @override
  String get chatMenuFavorite => 'Opslaan';

  @override
  String get chatMenuReply => 'Beantwoorden';

  @override
  String get chatMenuMultiSelect => 'Selecteren';

  @override
  String get chatMenuTranslate => 'Vertalen';

  @override
  String get chatMenuVoiceToText => 'Omzetten naar tekst';

  @override
  String get chatMenuTextToSpeech => 'Voorlezen';

  @override
  String get chatStatusRecalled => 'Bericht ingetrokken';

  @override
  String get chatRecallSuccess => 'Ingetrokken';

  @override
  String get chatRecallFailed => 'Intrekken mislukt';

  @override
  String get chatRecallTimeout =>
      'Berichten ouder dan 2 minuten kunnen niet worden ingetrokken';

  @override
  String get chatTranslateFailed => 'Vertaling mislukt. Probeer het opnieuw.';

  @override
  String get chatTranslateNotConfigured => 'Vertaaldienst niet beschikbaar';

  @override
  String get chatVoiceToTextFailed => 'Omzetten mislukt. Probeer het opnieuw.';

  @override
  String get chatTextToSpeechFailed =>
      'Voorlezen mislukt. Probeer het opnieuw.';

  @override
  String get chatVoiceToText => 'Omzetten';

  @override
  String get chatForwardSuccess => 'Doorgestuurd';

  @override
  String get chatForwardFailed => 'Doorsturen mislukt. Probeer het opnieuw.';

  @override
  String get chatNoConversations => 'Geen chats om naar door te sturen';

  @override
  String get chatSendFailed => 'Verzenden mislukt';

  @override
  String get chatResend => 'Code opnieuw verzenden';

  @override
  String get chatNotFriend => 'Niet in contactenlijst';

  @override
  String get chatNotFriendHint =>
      'U bent nog geen contacten. Berichten verzenden is niet mogelijk.';

  @override
  String get chatMutedHint => 'Alle leden zijn gedempt';

  @override
  String get chatFileUploadFailed =>
      'Bestand uploaden mislukt. Probeer het opnieuw.';

  @override
  String get chatFileStatusNotDownloaded => 'Niet gedownload';

  @override
  String get chatFileStatusDownloaded => 'Gedownload';

  @override
  String get chatFileStatusUploading => 'Uploaden';

  @override
  String get chatFileStatusUploadFailed => 'Upload mislukt';

  @override
  String get chatCardSendFailed => 'Contactkaart verzenden mislukt';

  @override
  String get chatFavoriteSuccess => 'Opgeslagen';

  @override
  String get chatFavoriteFailed => 'Toevoegen aan favorieten mislukt';

  @override
  String get chatLoadFailed => 'Laden mislukt';

  @override
  String get chatImageMessage => '[Afbeelding]';

  @override
  String get chatVoiceMessage => '[Spraakbericht]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Bestand]';

  @override
  String get chatLocationMessage => '[Locatie]';

  @override
  String get chatContactCardMessage => '[Contact]';

  @override
  String get chatCallLogMessage => '[Oproep]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Gelezen door $count';
  }

  @override
  String get chatUnread => 'Ongelezen';

  @override
  String get chatRecalledSelf => 'U hebt een bericht ingetrokken';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender heeft een bericht ingetrokken';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Vertaling: $translation';
  }

  @override
  String get chatMessageDeleted => 'Bericht verwijderd';

  @override
  String get chatPeer => 'Andere persoon';

  @override
  String get chatSelf => 'Ik';

  @override
  String get chatGenericMessage => '[Bericht]';

  @override
  String get chatVoiceHideText => 'Tekst verbergen';

  @override
  String get chatVoiceShowText => 'Omzetten naar tekst';

  @override
  String get chatFileDefaultName => 'Bestand';

  @override
  String get chatContactDefaultName => 'Contact';

  @override
  String get chatContactCardTitle => 'Contactkaart';

  @override
  String get chatCallMissed => 'Gemist';

  @override
  String get chatCallCancelled => 'Geannuleerd';

  @override
  String get chatCallRejected => 'Geweigerd';

  @override
  String get chatCallDisconnected => 'Verbinding verbroken';

  @override
  String get chatCallEnded => 'Gesprek beëindigd';

  @override
  String get chatCallFailed => 'Oproep mislukt';

  @override
  String chatCallDuration(String duration) {
    return 'Duur $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videogesprek';

  @override
  String get chatVoiceCallTitle => 'Spraakgesprek';

  @override
  String get chatToolPhotos => 'Foto’s';

  @override
  String get chatToolCamera => 'Camera';

  @override
  String get chatToolFile => 'Bestand';

  @override
  String get chatToolLocation => 'Locatie';

  @override
  String get chatToolContactCard => 'Contact';

  @override
  String get chatToolVoiceCall => 'Spraakgesprek';

  @override
  String get chatToolVideoCall => 'Videogesprek';

  @override
  String get chatToolFavorites => 'Favorieten';

  @override
  String get chatToolTranslate => 'Vertalen';

  @override
  String get chatTranslationChooseLanguage => 'Kies vertaaltaal';

  @override
  String get chatTranslationEnterText => 'Voer eerst tekst in';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Vertalen is niet beschikbaar voor berichten met vermeldingen';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Vertalen is niet beschikbaar tijdens het bewerken van een gepland bericht';

  @override
  String get chatTranslationFailed => 'Vertaling mislukt. Probeer het opnieuw.';

  @override
  String get chatTranslationEmpty =>
      'Geen vertaling ontvangen. Probeer het opnieuw.';

  @override
  String get chatTranslationTranslating => 'Vertalen…';

  @override
  String get chatTranslationSend => 'Vertaling verzenden';

  @override
  String get chatTranslationSending => 'Verzenden…';

  @override
  String get chatTranslationExpand => 'Meer tonen';

  @override
  String get chatTranslationCollapse => 'Minder tonen';

  @override
  String get chatFileTooLarge =>
      'Het bestand overschrijdt de limiet van 100 MB';

  @override
  String get chatInputMutedAdminOnly =>
      'Alleen de eigenaar of geselecteerde leden mogen schrijven.';

  @override
  String get chatImageUploadUnsupported =>
      'Afbeelding uploaden mislukt. De server ondersteunt dit nog niet.';

  @override
  String get chatFavoriteLongPressHint =>
      'Houd een bericht ingedrukt om het aan favorieten toe te voegen';

  @override
  String chatSelectedCount(int count) {
    return '$count geselecteerd';
  }

  @override
  String get chatLocationSheetTitle => 'Locatie verzenden';

  @override
  String get chatLocationNameLabel => 'Plaatsnaam';

  @override
  String get chatLocationNameHint => 'Bijv. kantoor, klantadres';

  @override
  String get chatLocationAddressLabel => 'Adres';

  @override
  String get chatLocationOptionalHint => 'Optioneel';

  @override
  String get chatLocationLatitudeLabel => 'Breedtegraad';

  @override
  String get chatLocationLatitudeHint => '-90 tot 90';

  @override
  String get chatLocationLongitudeLabel => 'Lengtegraad';

  @override
  String get chatLocationLongitudeHint => '-180 tot 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Voer $label in';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label valt buiten het bereik';
  }

  @override
  String get chatLocationDefaultTitle => 'Locatie';

  @override
  String get chatMutedFullNotice =>
      'Deze groep is gedempt. Alleen de eigenaar of geselecteerde leden mogen schrijven.';

  @override
  String get chatNotFriendSendBlocked =>
      'U bent geen vrienden meer en kunt geen berichten verzenden';

  @override
  String get chatPersonalNotesTitle => 'Persoonlijke notities';

  @override
  String get chatWorkNotesTitle => 'Werknotities';

  @override
  String get chatPersonalNotesDescription =>
      'Bewaar hier persoonlijke gedachten en belangrijke informatie\nGesynchroniseerd tussen apparaten en altijd beschikbaar';

  @override
  String get chatWorkNotesDescription =>
      'Bewaar hier werktaken en werkmateriaal\nTeamruimtes blijven gescheiden en veilig';

  @override
  String get chatNoMessages => 'Geen berichten';

  @override
  String chatReplyTo(String sender) {
    return '$sender beantwoorden';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature is binnenkort beschikbaar';
  }

  @override
  String get chatForwardSelectTitle => 'Kies chat';

  @override
  String get chatContactSelectTitle => 'Kies contact';

  @override
  String get chatNoContacts => 'Geen contacten';

  @override
  String get contactsTitle => 'Contacten';

  @override
  String get contactsSearch => 'Contacten zoeken';

  @override
  String get contactsNewFriends => 'Nieuwe vrienden';

  @override
  String get contactsGroups => 'Groepen';

  @override
  String get contactsFavorites => 'Favorieten';

  @override
  String get contactsRecent => 'Recent';

  @override
  String get contactsOrganization => 'Organisatie';

  @override
  String get contactsAnnouncement => 'Aankondigingen';

  @override
  String get contactsNewApplications => 'Nieuwe aanvragen';

  @override
  String get contactsCustomerGroups => 'Klantgroepen';

  @override
  String get contactsAllCustomers => 'Alle klanten';

  @override
  String get contactsMyCustomers => 'Mijn klanten';

  @override
  String get contactsViewAll => 'Alles bekijken';

  @override
  String get contactsMyContacts => 'Mijn contacten';

  @override
  String get contactsMyAdvisor => 'Mijn adviseur';

  @override
  String get contactsNoAdvisor => 'Nog geen adviseur toegewezen';

  @override
  String get contactsAdvisorLoading => 'Laden…';

  @override
  String get contactsNavigateFailed =>
      'Navigatie mislukt. Probeer het opnieuw.';

  @override
  String get contactsEmpty => 'Geen contacten';

  @override
  String get contactsNoAnnouncement => 'Geen aankondigingen';

  @override
  String get contactsOfficialBadge => 'Officieel';

  @override
  String get contactsCustomerBadge => 'Klant';

  @override
  String get contactsEmptyCustomers => 'Geen klanten';

  @override
  String get myTitle => 'Ik';

  @override
  String get myEnterpriseInfo => 'Bedrijfsinformatie';

  @override
  String get myEnterpriseManage => 'Bedrijfsbeheer';

  @override
  String get myQrCode => 'QR-code';

  @override
  String get myFavorites => 'Favorieten';

  @override
  String get myLanguage => 'Taal';

  @override
  String get myTimezone => 'Tijdzone';

  @override
  String get myAutoTranslate => 'Automatisch vertalen';

  @override
  String get myNetworkSwitch => 'Lijn wisselen';

  @override
  String get mySettings => 'Instellingen';

  @override
  String get myLogout => 'Afmelden';

  @override
  String get myLogoutConfirm => 'Weet u zeker dat u wilt afmelden?';

  @override
  String get myLeaveEnterprise => 'Bedrijf verlaten';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Weet u zeker dat u dit bedrijf wilt verlaten? U verliest de toegang tot bedrijfsgegevens.';

  @override
  String get myLeaveEnterpriseSuccess => 'Bedrijf verlaten';

  @override
  String get myLeaveEnterpriseFailed =>
      'Verlaten mislukt. Probeer het opnieuw.';

  @override
  String get myLppIdCopied => 'StartLink-ID gekopieerd';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink-ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count contacten';
  }

  @override
  String get myAutoSelect => 'Automatisch';

  @override
  String get myPresenceStatus => 'Aanwezigheidsstatus';

  @override
  String get myPresenceStatusTitle => 'Aanwezigheid instellen';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Bezet';

  @override
  String get myPresenceAway => 'Afwezig';

  @override
  String get myPresenceInvisible => 'Onzichtbaar';

  @override
  String get profileTitle => 'Mijn profiel';

  @override
  String get profileName => 'Naam';

  @override
  String get profileGender => 'Geslacht';

  @override
  String get profileBirthday => 'Verjaardag';

  @override
  String get profileRegion => 'Regio';

  @override
  String get profileSignature => 'Profieltekst';

  @override
  String get profileSignatureHint => 'Vertel iets over uzelf';

  @override
  String get profileTapTapText => 'Tikje';

  @override
  String get profileTapTapHint => 'Tekst bij een tikje (max. 20 tekens)';

  @override
  String get profileAccountSection => 'Account';

  @override
  String get profileBasicSection => 'Basisinformatie';

  @override
  String get profileLppId => 'StartLink-ID';

  @override
  String get profileLppIdNotSet => 'Niet ingesteld';

  @override
  String get profileMobile => 'Telefoon';

  @override
  String get profileMobileUnbound => 'Niet gekoppeld';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileEmailUnbound => 'Niet gekoppeld';

  @override
  String get profileQrCode => 'Mijn QR-code';

  @override
  String get profileChangePassword => 'Wachtwoord wijzigen';

  @override
  String get profileGenderMale => 'Man';

  @override
  String get profileGenderFemale => 'Vrouw';

  @override
  String get profileGenderOther => 'Overig';

  @override
  String get profileGenderUnset => 'Niet ingesteld';

  @override
  String get profileSaveFailed => 'Opslaan mislukt. Probeer het opnieuw.';

  @override
  String get profileLppIdTitle => 'StartLink-ID';

  @override
  String get profileLppIdSetOnce =>
      'De StartLink-ID kan slechts één keer worden gewijzigd. Kies zorgvuldig.';

  @override
  String get profileLppIdChangeFailed =>
      'Wijzigen mislukt (de StartLink-ID kan slechts één keer worden gewijzigd)';

  @override
  String get profileChangePasswordOld => 'Huidig wachtwoord';

  @override
  String get profileChangePasswordNew => 'Nieuw wachtwoord';

  @override
  String get profileChangePasswordConfirm => 'Bevestig nieuw wachtwoord';

  @override
  String get profileChangePasswordMismatch =>
      'De wachtwoorden komen niet overeen';

  @override
  String get profileChangePasswordSuccess =>
      'Wachtwoord gewijzigd. Meld u opnieuw aan.';

  @override
  String get profileChangePasswordFailed =>
      'Wachtwoord wijzigen mislukt. Probeer het opnieuw.';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingsSectionEnterprise => 'Bedrijf';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsSectionGeneral => 'Algemeen';

  @override
  String get settingsSectionFeatures => 'Functies';

  @override
  String get settingsSectionAbout => 'Over';

  @override
  String get settingsEnterpriseInfo => 'Bedrijfsinformatie';

  @override
  String get settingsProfile => 'Mijn profiel';

  @override
  String get settingsAccountSecurity => 'Accountbeveiliging';

  @override
  String get settingsNotification => 'Meldingen';

  @override
  String get settingsDisplay => 'Weergave';

  @override
  String get settingsFriendPrivacy => 'Privacy';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Chatgeschiedenis';

  @override
  String get settingsAbout => 'Over StartLink';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get settingsTimezone => 'Tijdzone';

  @override
  String get settingsAutoTranslate => 'Automatisch vertalen';

  @override
  String get settingsNetworkSwitch => 'Lijn wisselen';

  @override
  String get enterpriseInfoTitle => 'Bedrijfsinformatie';

  @override
  String get enterpriseName => 'Naam';

  @override
  String get enterpriseDescription => 'Beschrijving';

  @override
  String get enterpriseUpdateSuccess => 'Succesvol bijgewerkt';

  @override
  String get enterpriseUpdateFailed =>
      'Bijwerken mislukt. Probeer het opnieuw.';

  @override
  String get enterpriseLeave => 'Bedrijf verlaten';

  @override
  String get enterpriseLeaveConfirm =>
      'Weet u zeker dat u dit bedrijf wilt verlaten?';

  @override
  String get enterpriseLeaveSuccess => 'Bedrijf verlaten';

  @override
  String get enterpriseLeaveFailed => 'Verlaten mislukt. Probeer het opnieuw.';

  @override
  String get enterpriseLeaveOwnerError =>
      'De eigenaar kan niet rechtstreeks vertrekken. Draag eerst het eigenaarschap over.';

  @override
  String get enterpriseMemberCount => 'Leden';

  @override
  String get enterpriseCreatedAt => 'Aangemaakt';

  @override
  String get enterpriseCode => 'Bedrijfscode';

  @override
  String get enterpriseInviteMembers => 'Leden uitnodigen';

  @override
  String get enterpriseCopyInviteCode => 'Uitnodigingscode kopiëren';

  @override
  String get enterpriseInviteCodeCopied => 'Uitnodigingscode gekopieerd';

  @override
  String get groupCreateTitle => 'Nieuwe groep';

  @override
  String get groupNameHint => 'Voer groepsnaam in';

  @override
  String get groupCreateSuccess => 'Groep aangemaakt';

  @override
  String get groupCreateFailed => 'Groep aanmaken mislukt';

  @override
  String get groupSettings => 'Groepsinstellingen';

  @override
  String get groupName => 'Groepsnaam';

  @override
  String get groupAvatar => 'Groepsafbeelding';

  @override
  String get groupAnnouncement => 'Aankondiging';

  @override
  String get groupMembers => 'Leden';

  @override
  String get groupAddMember => 'Leden toevoegen';

  @override
  String get groupRemoveMember => 'Lid verwijderen';

  @override
  String get groupRemoveMemberConfirm => 'Dit lid verwijderen?';

  @override
  String get groupSetAdmin => 'Beheerder maken';

  @override
  String get groupRemoveAdmin => 'Beheerdersrechten intrekken';

  @override
  String get groupTransferOwner => 'Eigenaarschap overdragen';

  @override
  String get groupTransferOwnerConfirm =>
      'Groepseigenaarschap overdragen aan dit lid?';

  @override
  String get groupTransferOwnerSuccess => 'Eigenaarschap overgedragen';

  @override
  String get groupTransferOwnerFailed =>
      'Overdracht mislukt. Probeer het opnieuw.';

  @override
  String get groupLeave => 'Groep verlaten';

  @override
  String get groupLeaveConfirm => 'Deze groep verlaten?';

  @override
  String get groupLeaveSuccess => 'Groep verlaten';

  @override
  String get groupLeaveFailed => 'Verlaten mislukt. Probeer het opnieuw.';

  @override
  String get groupDissolve => 'Groep ontbinden';

  @override
  String get groupDissolveConfirm =>
      'Deze groep ontbinden? Alle leden worden verwijderd.';

  @override
  String get groupDissolveSuccess => 'Groep ontbonden';

  @override
  String get groupDissolveFailed => 'Ontbinden mislukt. Probeer het opnieuw.';

  @override
  String get groupQrCode => 'Groeps-QR-code';

  @override
  String get groupMuteAll => 'Iedereen dempen';

  @override
  String get groupMuteAllOn => 'Iedereen dempen inschakelen';

  @override
  String get groupMuteAllOff => 'Iedereen dempen uitschakelen';

  @override
  String get groupAllowMemberInvite => 'Uitnodigingen door leden toestaan';

  @override
  String get groupAllowMemberModifyTitle =>
      'Leden toestaan de groepsnaam te wijzigen';

  @override
  String get groupAllowMemberAtAll => 'Leden toestaan @Iedereen te vermelden';

  @override
  String get groupAllowMemberViewMemberList =>
      'Leden toestaan de ledenlijst te bekijken';

  @override
  String get groupAllowQrCodeJoin => 'Lid worden via QR-code toestaan';

  @override
  String get groupRequireApproval => 'Goedkeuring vereisen om lid te worden';

  @override
  String get groupAllowMemberAddFriend =>
      'Leden toestaan elkaar als vriend toe te voegen';

  @override
  String get groupRoleOwner => 'Eigenaar';

  @override
  String get groupRoleAdmin => 'Beheerder';

  @override
  String get groupRoleMember => 'Lid';

  @override
  String get groupNoMembers => 'Geen leden';

  @override
  String get groupNoAnnouncements => 'Geen aankondigingen';

  @override
  String get groupCreateAnnouncement => 'Aankondiging plaatsen';

  @override
  String get groupEditAnnouncement => 'Aankondiging bewerken';

  @override
  String get groupDeleteAnnouncement => 'Aankondiging verwijderen';

  @override
  String get groupDeleteAnnouncementConfirm => 'Deze aankondiging verwijderen?';

  @override
  String get groupAnnouncementTitle => 'Titel';

  @override
  String get groupAnnouncementContent => 'Inhoud';

  @override
  String get groupAnnouncementPin => 'Aankondiging vastmaken';

  @override
  String groupMemberCount(int count) {
    return '$count leden';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count geselecteerd';
  }

  @override
  String get groupJoinRequestApprove => 'Akkoord';

  @override
  String get groupJoinRequestReject => 'Weigeren';

  @override
  String get groupJoinRequests => 'Lidmaatschapsaanvragen';

  @override
  String get groupNoJoinRequests => 'Geen lidmaatschapsaanvragen';

  @override
  String get groupReadReceipts => 'Leesbevestigingen';

  @override
  String groupReadCount(int count) {
    return '$count gelezen';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count ongelezen';
  }

  @override
  String get friendAddTitle => 'Contact toevoegen';

  @override
  String get friendSearchHint => 'Telefoon / E-mail / StartLink-ID';

  @override
  String get friendRequestSent => 'Vriendschapsverzoek verzonden';

  @override
  String get friendRequestFailed => 'Verzenden mislukt. Probeer het opnieuw.';

  @override
  String get friendAlreadyFriend => 'Al contacten';

  @override
  String get friendNewFriendsTitle => 'Nieuwe vrienden';

  @override
  String get friendNoRequests => 'Geen vriendschapsverzoeken';

  @override
  String get friendAccept => 'Accepteren';

  @override
  String get friendReject => 'Weigeren';

  @override
  String get friendAccepted => 'Geaccepteerd';

  @override
  String get friendRejected => 'Afgewezen';

  @override
  String get friendDeleteConfirm => 'Dit contact verwijderen?';

  @override
  String get friendDeleteSuccess => 'Contact verwijderd';

  @override
  String get friendDeleteFailed => 'Verwijderen mislukt. Probeer het opnieuw.';

  @override
  String get friendRemarkName => 'Contactnaam';

  @override
  String get friendGroupName => 'Groep';

  @override
  String get friendSendMessage => 'Bericht';

  @override
  String get friendMatchTypeLppId => 'Gevonden via StartLink-ID';

  @override
  String get friendMatchTypeMobile => 'Gevonden via telefoon';

  @override
  String get friendMatchTypeEmail => 'Gevonden via e-mail';

  @override
  String get friendSearchEmpty => 'Geen gebruikers gevonden';

  @override
  String get friendAddMessage => 'Ik wil u graag als contact toevoegen';

  @override
  String get friendBlockConfirm => 'Deze gebruiker blokkeren?';

  @override
  String get friendUnblockConfirm => 'Deze gebruiker deblokkeren?';

  @override
  String get friendBlockSuccess => 'Geblokkeerd';

  @override
  String get friendUnblockSuccess => 'Gedeblokkeerd';

  @override
  String get profilePageTitle => 'Persoonlijke gegevens';

  @override
  String get profilePageSendMessage => 'Bericht';

  @override
  String get profilePageAddFriend => 'Vriend toevoegen';

  @override
  String get profilePageAlreadyFriend => 'Al vrienden';

  @override
  String get profilePageBlocked => 'Geblokkeerd';

  @override
  String get profilePageBlock => 'Blokkeren';

  @override
  String get profilePageUnblock => 'Deblokkeren';

  @override
  String get profilePageHidden => 'Deze gebruiker heeft het profiel verborgen';

  @override
  String get profilePageFriendsOnly =>
      'Deze gebruiker toont het profiel alleen aan vrienden';

  @override
  String get profilePageLppId => 'StartLink-ID';

  @override
  String get profilePageRemarkName => 'Opmerkingen';

  @override
  String get profilePageEditRemark => 'Contactnaam bewerken';

  @override
  String get profilePageSaveRemarkSuccess => 'Contactnaam opgeslagen';

  @override
  String get profilePageSaveRemarkFailed =>
      'Opslaan mislukt. Probeer het opnieuw.';

  @override
  String get searchTitle => 'Zoeken';

  @override
  String get searchHint => 'Zoek op telefoon, e-mail of StartLink-ID';

  @override
  String get searchNoResults => 'Geen resultaten gevonden';

  @override
  String get searchMessages => 'Berichten';

  @override
  String get searchUsers => 'Gebruikers';

  @override
  String get searchFailed => 'Zoeken mislukt. Probeer het opnieuw.';

  @override
  String get scanTitle => 'Scannen';

  @override
  String get scanFailed => 'Herkenning mislukt. Probeer het opnieuw.';

  @override
  String get scanInvalidQrCode => 'Ongeldige QR-code';

  @override
  String get scanFlashOn => 'Zaklamp inschakelen';

  @override
  String get scanFlashOff => 'Zaklamp uitschakelen';

  @override
  String get scanAlbum => 'Kies uit album';

  @override
  String get favoritesTitle => 'Favorieten';

  @override
  String get favoritesEmpty => 'Nog niets opgeslagen';

  @override
  String get favoritesAll => 'Alle';

  @override
  String get favoritesText => 'Tekst';

  @override
  String get favoritesImage => 'Afbeeldingen';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Spraakberichten';

  @override
  String get favoritesFile => 'Bestanden';

  @override
  String get favoritesOther => 'Overig';

  @override
  String get favoritesDeleteConfirm => 'Uit favorieten verwijderen?';

  @override
  String get favoritesDeleteSuccess => 'Verwijderd uit opgeslagen';

  @override
  String get favoritesDeleteFailed => 'Verwijderen mislukt';

  @override
  String get favoritesOriginalRecalled => 'Bericht ingetrokken';

  @override
  String get favoritesViewOriginal => 'Origineel bekijken';

  @override
  String get favoritesSearchHint => 'Favorieten zoeken';

  @override
  String get favoritesNoResults => 'Geen overeenkomende favorieten';

  @override
  String get noticeTitle => 'Aankondigingen';

  @override
  String get noticeEmpty => 'Geen aankondigingen';

  @override
  String get noticeDetail => 'Details van aankondiging';

  @override
  String get noticePublishedAt => 'Gepubliceerd';

  @override
  String get noticePriorityNormal => 'normaal';

  @override
  String get noticePriorityImportant => 'Belangrijk';

  @override
  String get noticePriorityUrgent => 'Dringend';

  @override
  String get organizationTitle => 'Organisatie';

  @override
  String get organizationEmpty => 'Geen afdelingsinformatie';

  @override
  String get organizationMembers => 'Leden';

  @override
  String get organizationDepartment => 'Afdeling';

  @override
  String get organizationPosition => 'Functie';

  @override
  String get organizationLeader => 'Leidinggevende';

  @override
  String get qrCodeTitle => 'Mijn QR-code';

  @override
  String get qrCodeSave => 'Opslaan in Album';

  @override
  String get qrCodeShare => 'Delen';

  @override
  String get qrCodeSaveSuccess => 'Opgeslagen in album';

  @override
  String get qrCodeSaveFailed => 'Opslaan mislukt. Probeer het opnieuw.';

  @override
  String get qrCodeRefresh => 'QR-code vernieuwen';

  @override
  String get qrCodeExpired => 'QR-code verlopen. Vernieuw deze.';

  @override
  String get qrCodeScanToAdd => 'Scan om mij als contact toe te voegen';

  @override
  String get spacePersonal => 'Persoonlijk';

  @override
  String get spaceEnterprise => 'Bedrijf';

  @override
  String get spaceJoinByCode => 'Lid worden met bedrijfscode';

  @override
  String get spaceJoinByInvite => 'Lid worden met uitnodigingscode';

  @override
  String get spaceEnterCode => 'Voer bedrijfscode in';

  @override
  String get spaceEnterInviteCode => 'Voer uitnodigingscode in';

  @override
  String get spaceSearchEnterprise => 'Bedrijf zoeken';

  @override
  String get spaceJoinRequestSent => 'Aanvraag verzonden, wacht op goedkeuring';

  @override
  String get spaceJoinRequestPending => 'Goedkeuring in behandeling';

  @override
  String get spaceJoinRequestApproved => 'Aanvraag goedgekeurd';

  @override
  String get spaceJoinRequestRejected => 'Aanvraag afgewezen';

  @override
  String get spaceAlreadyMember => 'U bent al lid';

  @override
  String get spaceAutoApproved => 'Automatisch goedgekeurd. Welkom!';

  @override
  String get spacePendingApprovalHint =>
      'Registratie geslaagd. Uw lidmaatschapsaanvraag is verzonden.';

  @override
  String get spaceNoSpaces => 'Geen ruimtes';

  @override
  String get spaceInviteExpired => 'Uitnodigingscode verlopen';

  @override
  String get spaceInviteTargetMismatch =>
      'Deze uitnodigingscode is niet voor uw account';

  @override
  String get spaceAcceptInviteSuccess => 'Succesvol lid geworden van bedrijf';

  @override
  String get spaceAcceptInviteFailed =>
      'Lid worden mislukt. Probeer het opnieuw.';

  @override
  String get spaceTenantSelectTitle => 'Selecteer ruimte';

  @override
  String get spaceTenantSelectHint => 'Kies een ruimte om te openen';

  @override
  String get spaceEnterPersonal => 'Persoonlijke ruimte openen';

  @override
  String get spaceEnterEnterprise => 'Bedrijfsruimte openen';

  @override
  String get aboutTitle => 'Over StartLink';

  @override
  String get aboutVersion => 'Versie';

  @override
  String get aboutTerms => 'Gebruiksvoorwaarden';

  @override
  String get aboutPrivacy => 'Privacybeleid';

  @override
  String get aboutOpenSource => 'Opensourcelicenties';

  @override
  String get aboutCheckUpdate => 'Controleren op updates';

  @override
  String get aboutLatestVersion => 'U gebruikt de nieuwste versie';

  @override
  String get aboutUpdateAvailable => 'Nieuwe versie beschikbaar';

  @override
  String get aboutUpdateNow => 'Nu updaten';

  @override
  String get aboutUpdateLater => 'Later';

  @override
  String get notificationTitle => 'Meldingen';

  @override
  String get notificationGlobalMute => 'Niet storen';

  @override
  String get notificationSound => 'Geluid';

  @override
  String get notificationVibration => 'Trillen';

  @override
  String get notificationPreview => 'Berichtvoorbeeld';

  @override
  String get notificationDndStart => 'Begintijd Niet storen';

  @override
  String get notificationDndEnd => 'Eindtijd Niet storen';

  @override
  String get blacklistTitle => 'Geblokkeerd';

  @override
  String get blacklistEmpty => 'Geen geblokkeerde gebruikers';

  @override
  String get blacklistRemove => 'Deblokkeren';

  @override
  String get blacklistRemoveConfirm => 'Deze gebruiker deblokkeren?';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackTypeComplaint => 'Klacht';

  @override
  String get feedbackTypeSuggestion => 'Suggestie';

  @override
  String get feedbackTypeBug => 'Bugmelding';

  @override
  String get feedbackContent => 'Beschrijving';

  @override
  String get feedbackContentHint =>
      'Beschrijf uw probleem of suggestie uitgebreid';

  @override
  String get feedbackContact => 'Contactgegevens (optioneel)';

  @override
  String get feedbackSubmit => 'Verzenden';

  @override
  String get feedbackSuccess => 'Feedback verzonden. Bedankt!';

  @override
  String get feedbackFailed => 'Verzenden mislukt. Probeer het opnieuw.';

  @override
  String get networkTitle => 'Lijn wisselen';

  @override
  String get networkAutoSelect => 'Automatisch';

  @override
  String get networkManual => 'Handmatig';

  @override
  String get timezoneTitle => 'Tijdzone';

  @override
  String get timezoneAuto => 'Systeem volgen';

  @override
  String get autoTranslateTitle => 'Automatisch vertalen';

  @override
  String get autoTranslateEnabled => 'Automatisch vertalen inschakelen';

  @override
  String get autoTranslateLanguage => 'Doeltaal';

  @override
  String get displayTitle => 'Weergave';

  @override
  String get displayFontSize => 'Lettergrootte';

  @override
  String get displayChatBackground => 'Chatachtergrond';

  @override
  String get displayDarkMode => 'Vormgeving';

  @override
  String get displayDarkModeSystem => 'Systeem volgen';

  @override
  String get displayDarkModeSystemHint =>
      'Automatisch wisselen volgens de systeeminstelling';

  @override
  String get displayDarkModeOff => 'Licht';

  @override
  String get displayDarkModeOffHint => 'Altijd licht thema gebruiken';

  @override
  String get displayDarkModeOn => 'Donker';

  @override
  String get displayDarkModeOnHint => 'Altijd donker thema gebruiken';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Chatgeschiedenis';

  @override
  String get chatHistoryClear => 'Volledige geschiedenis wissen';

  @override
  String get chatHistoryClearConfirm =>
      'Volledige chatgeschiedenis wissen? Dit kan niet ongedaan worden gemaakt.';

  @override
  String get chatHistoryClearSuccess => 'Chatgeschiedenis gewist';

  @override
  String get accountSecurityTitle => 'Accountbeveiliging';

  @override
  String get accountSecurityChangePassword => 'Wachtwoord wijzigen';

  @override
  String get accountSecurityChangeMobile => 'Telefoonnummer wijzigen';

  @override
  String get accountSecurityChangeEmail => 'E-mailadres wijzigen';

  @override
  String get accountSecurityLoggedDevices => 'Aangemelde apparaten';

  @override
  String get accountSecurityDeactivate => 'Account verwijderen';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Alle gegevens worden na 7 dagen definitief verwijderd. Account verwijderen?';

  @override
  String get loggedDevicesTitle => 'Aangemelde apparaten';

  @override
  String get loggedDevicesCurrent => 'Dit apparaat';

  @override
  String get loggedDevicesRevoke => 'Afmelden';

  @override
  String get loggedDevicesRevokeConfirm => 'Afmelden op dit apparaat?';

  @override
  String get loggedDevicesRevokeSuccess => 'Afgemeld op apparaat';

  @override
  String get loggedDevicesRevokeFailed => 'Mislukt. Probeer het opnieuw.';

  @override
  String get loggedDevicesLastActive => 'Laatst actief';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Desktop';

  @override
  String get loggedDevicesTypeUnknown => 'Onbekend apparaat';

  @override
  String get privacySettingsTitle => 'Privacy';

  @override
  String get privacySearchableByMobile => 'Zoeken op telefoonnummer toestaan';

  @override
  String get privacySearchableByLppId => 'Zoeken op StartLink-ID toestaan';

  @override
  String get privacyAllowFriendRequest => 'Vriendschapsverzoeken toestaan';

  @override
  String get privacyProfileVisibility => 'Profielzichtbaarheid';

  @override
  String get privacyEveryone => 'Iedereen';

  @override
  String get privacyFriendsOfFriends => 'Vrienden van vrienden';

  @override
  String get privacyNobody => 'Niemand';

  @override
  String get privacyFriendsOnly => 'Alleen vrienden';

  @override
  String get privacySaveSuccess => 'Instellingen opgeslagen';

  @override
  String get privacySaveFailed => 'Opslaan mislukt. Probeer het opnieuw.';

  @override
  String get fontSizeTitle => 'Lettergrootte';

  @override
  String get fontSizeSmall => 'Klein';

  @override
  String get fontSizeNormal => 'Standaard';

  @override
  String get fontSizeLarge => 'Groot';

  @override
  String get fontSizeExtraLarge => 'Extra groot';

  @override
  String get fontSizePreview => 'Voorbeeld';

  @override
  String get chatBackgroundTitle => 'Chatachtergrond';

  @override
  String get chatBackgroundDefault => 'Standaard';

  @override
  String get chatBackgroundCustom => 'Aangepast';

  @override
  String get chatBackgroundReset => 'Standaardinstellingen herstellen';

  @override
  String get termsTitle => 'Gebruiksvoorwaarden';

  @override
  String get privacyPolicyTitle => 'Privacybeleid';

  @override
  String get recentContactsTitle => 'Recent';

  @override
  String get recentContactsEmpty => 'Geen recente contacten';

  @override
  String get inviteFriendsTitle => 'Vrienden uitnodigen';

  @override
  String get inviteFriendsCopyLink => 'Uitnodigingslink kopiëren';

  @override
  String get inviteFriendsLinkCopied => 'Uitnodigingslink gekopieerd';

  @override
  String get imageViewerTitle => 'Foto';

  @override
  String get imageViewerSave => 'Opslaan in Album';

  @override
  String get imageViewerSaveSuccess => 'Opgeslagen in album';

  @override
  String get imageViewerSaveFailed => 'Opslaan mislukt. Probeer het opnieuw.';

  @override
  String get customerServiceTitle => 'Servicedesk';

  @override
  String get customerServiceQueue => 'In wachtrij';

  @override
  String get customerServiceActive => 'Actief';

  @override
  String get customerServiceClaim => 'Accepteren';

  @override
  String get customerServiceTakeover => 'Overnemen';

  @override
  String get customerServiceClose => 'Service beëindigen';

  @override
  String get customerServiceCloseConfirm => 'Deze servicesessie beëindigen?';

  @override
  String get customerServiceNoQueue => 'Geen sessies in wachtrij';

  @override
  String get customerServiceNoActive => 'Geen actieve sessies';

  @override
  String get customerServiceVisitor => 'Bezoeker';

  @override
  String get customerServiceCustomer => 'Klant';

  @override
  String get customerServiceAssignedTo => 'Toegewezen aan';

  @override
  String get customerServiceTransferConversation => 'Chat overdragen';

  @override
  String get marketingToolbar => 'Marketingtools';

  @override
  String get callIncoming => 'Inkomende oproep';

  @override
  String get callOutgoing => 'Uitgaande oproep';

  @override
  String get callAccept => 'Accepteren';

  @override
  String get callReject => 'Weigeren';

  @override
  String get callHangup => 'Beëindigen';

  @override
  String get callMissed => 'Gemiste oproep';

  @override
  String get callDuration => 'Duur';

  @override
  String get callAudio => 'Spraakgesprek';

  @override
  String get callGeneric => 'Oproep';

  @override
  String get callVideo => 'Videogesprek';

  @override
  String get callConnecting => 'Verbinden…';

  @override
  String get callRinging => 'Gaat over…';

  @override
  String get callEnded => 'Gesprek beëindigd';

  @override
  String get callFailed => 'Oproep mislukt';

  @override
  String get callRejected => 'Oproep geweigerd';

  @override
  String get callTimeout => 'Geen antwoord';

  @override
  String get callCancelled => 'Geannuleerd';

  @override
  String get callUnknownPeer => 'Onbekend';

  @override
  String get callVideoInvitation => 'Uitnodiging voor videogesprek';

  @override
  String get callAudioInvitation => 'Uitnodiging voor spraakgesprek';

  @override
  String get callAnswerAudio => 'Met audio beantwoorden';

  @override
  String get callAnswerVideo => 'Met video beantwoorden';

  @override
  String get callViewProfile => 'Profiel bekijken';

  @override
  String get callOpeningCamera => 'Camera openen…';

  @override
  String get callWaitingRemoteVideo =>
      'Wachten op video van de andere persoon…';

  @override
  String get callCameraOff => 'Camera uit';

  @override
  String get callCameraOn => 'Camera aan';

  @override
  String get callMicrophoneOff => 'Microfoon uit';

  @override
  String get callMicrophoneOn => 'Microfoon aan';

  @override
  String get callSpeakerOff => 'Luidspreker uit';

  @override
  String get callSpeakerOn => 'Luidspreker aan';

  @override
  String get callVideoPermissionFailure =>
      'Het videogesprek kon niet worden gestart. Controleer de camera- en microfoonmachtigingen en probeer het opnieuw.';

  @override
  String get callAudioPermissionFailure =>
      'Het spraakgesprek kon niet worden gestart. Controleer de microfoonmachtiging en probeer het opnieuw.';

  @override
  String get callIncompleteIncoming =>
      'De gegevens van de inkomende oproep zijn onvolledig. De oproep kan niet worden beantwoord.';

  @override
  String get callInProgress => 'In gesprek';

  @override
  String get callCalling => 'Bellen…';

  @override
  String callEndedMedia(String media) {
    return '$media beëindigd';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media geweigerd';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media niet beantwoord';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media geannuleerd';
  }

  @override
  String get callConnectionLost => 'Oproepverbinding verbroken';

  @override
  String get callAdminEnded => 'Gesprek beëindigd door een beheerder';

  @override
  String callFailedMedia(String media) {
    return '$media mislukt';
  }

  @override
  String get callBusy => 'De andere persoon is bezet';

  @override
  String callDurationValue(String duration) {
    return 'Gespreksduur $duration';
  }

  @override
  String get callNotConnected => 'Niet verbonden';

  @override
  String get callDialed => 'Uitgaand';

  @override
  String get callAnswered => 'Beantwoord';

  @override
  String get callRejectedByPeer => 'Geweigerd door de andere persoon';

  @override
  String get callRejectedBySelf => 'Afgewezen';

  @override
  String get callPeerDidNotAnswer => 'De andere persoon heeft niet geantwoord';

  @override
  String get callMissedIncoming => 'Gemiste inkomende oproep';

  @override
  String get callPeerCancelled => 'Geannuleerd door de andere persoon';

  @override
  String get notificationNewMessageTitle => 'Nieuw StartLink-bericht';

  @override
  String get notificationOnlineServiceTitle => 'Nieuw klantenservicebericht';

  @override
  String get notificationNewMessageBody => 'U hebt een nieuw bericht ontvangen';

  @override
  String get notificationImagePreview => 'Heeft een afbeelding verzonden';

  @override
  String get notificationVideoPreview => 'Heeft een video verzonden';

  @override
  String get notificationVoicePreview => 'Heeft een spraakbericht verzonden';

  @override
  String get notificationFilePreview => 'Heeft een bestand verzonden';

  @override
  String get notificationContactPreview => 'Heeft een contactkaart verzonden';

  @override
  String get notificationCallLogPreview =>
      'Heeft een oproepvermelding verzonden';

  @override
  String get notificationLocationPreview => 'Heeft een locatie gedeeld';

  @override
  String get notificationLinkPreview => 'Heeft een link gedeeld';

  @override
  String notificationMentionMe(String body) {
    return 'Heeft u vermeld: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender heeft u vermeld: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Heeft iedereen vermeld: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender heeft iedereen vermeld: $body';
  }

  @override
  String get notificationSecurityTitle =>
      'Waarschuwing voor accountbeveiliging';

  @override
  String get notificationSecurityBody =>
      'De beveiligingsinstellingen van uw StartLink-account zijn gewijzigd. Controleer deze nu.';

  @override
  String get notificationFriendAcceptedTitle =>
      'Vriendschapsverzoek geaccepteerd';

  @override
  String get notificationFriendRejectedTitle => 'Vriendschapsverzoek afgewezen';

  @override
  String get notificationFriendAcceptedBody =>
      'De andere persoon heeft uw vriendschapsverzoek geaccepteerd';

  @override
  String get notificationFriendRejectedBody =>
      'De andere persoon heeft uw vriendschapsverzoek afgewezen';

  @override
  String get notificationVideoCallTitle => 'Uitnodiging voor videogesprek';

  @override
  String get notificationAudioCallTitle => 'Uitnodiging voor spraakgesprek';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller heeft u uitgenodigd voor een videogesprek';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller heeft u uitgenodigd voor een spraakgesprek';
  }

  @override
  String get notificationMessageChannelName => 'Berichten';

  @override
  String get notificationMessageChannelDescription =>
      'Chatberichten, oproepvermeldingen en systeemwaarschuwingen';

  @override
  String get notificationCallChannelName => 'Oproepen';

  @override
  String get notificationCallChannelDescription =>
      'Waarschuwingen voor spraak- en video-oproepen';

  @override
  String get notificationSecurityChannelName => 'Accountbeveiliging';

  @override
  String get notificationSecurityChannelDescription =>
      'Waarschuwingen voor aanmeldingen en wijzigingen van wachtwoord of mobiel nummer';

  @override
  String get notificationUnknownCaller => 'Onbekende beller';

  @override
  String get pendingJoinRequestsTitle => 'Nieuwe aanvragen';

  @override
  String get pendingJoinRequestsEmpty => 'Geen aanvragen';

  @override
  String get pendingJoinRequestApprove => 'Akkoord';

  @override
  String get pendingJoinRequestReject => 'Weigeren';

  @override
  String get pendingJoinRequestApproveSuccess => 'Goedgekeurd';

  @override
  String get pendingJoinRequestRejectSuccess => 'Afgewezen';

  @override
  String get pendingJoinRequestFailed =>
      'Bewerking mislukt. Probeer het opnieuw.';

  @override
  String get myCustomersTitle => 'Mijn klanten';

  @override
  String get myCustomersEmpty => 'Geen klanten';

  @override
  String get groupListTitle => 'Groepen';

  @override
  String get groupListEmpty => 'Geen groepen';

  @override
  String get addFriendTitle => 'Contact toevoegen';

  @override
  String get addFriendSearchHint => 'Telefoon / E-mail / StartLink-ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink-ID: $lppId';
  }

  @override
  String get addFriendButton => 'Toevoegen';

  @override
  String get addFriendCannotAddSelf => 'U kunt uzelf niet toevoegen';

  @override
  String get addFriendUnsupportedUser =>
      'Deze gebruiker kan niet worden toegevoegd. U kunt rechtstreeks een bericht sturen.';

  @override
  String get addFriendMessageHint => 'Voer een bericht in';

  @override
  String get addFriendSendRequest => 'Verzoek verzenden';

  @override
  String get joinCompanyTitle => 'Lid worden van bedrijf';

  @override
  String get joinCompanyCodeHint => 'Voer bedrijfscode in';

  @override
  String get joinCompanySearchHint => 'Zoek bedrijfsnaam';

  @override
  String get joinCompanyApply => 'Lidmaatschap aanvragen';

  @override
  String get joinCompanyApplySuccess => 'Aanvraag verzonden';

  @override
  String get joinCompanyApplyFailed =>
      'Aanvragen mislukt. Probeer het opnieuw.';

  @override
  String get joinCompanyAutoApproved => 'Automatisch goedgekeurd. Welkom!';

  @override
  String get joinCompanyPending => 'Aanvraag verzonden, wacht op goedkeuring';

  @override
  String get joinCompanyInviteCodeHint => 'Voer uitnodigingscode in';

  @override
  String get joinCompanyAcceptInvite => 'Uitnodiging accepteren';

  @override
  String get joinCompanyNoResults => 'Geen bedrijven gevonden';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count leden';
  }

  @override
  String get timezoneNameHawaii => 'Hawaï';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Pacific-tijd';

  @override
  String get timezoneNameMountainTime => 'Mountain-tijd';

  @override
  String get timezoneNameCentralTime => 'Central-tijd';

  @override
  String get timezoneNameEasternTime => 'Eastern-tijd';

  @override
  String get timezoneNameAtlanticTime => 'Atlantische tijd';

  @override
  String get timezoneNameBrasilia => 'Brasilia';

  @override
  String get timezoneNameAzores => 'Azoren';

  @override
  String get timezoneNameLondonDublin => 'Londen/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlijn/Parijs/Rome';

  @override
  String get timezoneNameCairoHelsinki => 'Caïro/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskou/Riyad';

  @override
  String get timezoneNameTehran => 'Teheran';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Bakoe';

  @override
  String get timezoneNameKabul => 'Kaboel';

  @override
  String get timezoneNameKarachiTashkent => 'Karachi/Tasjkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/New Delhi';

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
      'Peking/Shanghai/Hongkong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokio/Seoel';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Salomonseilanden';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute => 'Slim de beste route selecteren';

  @override
  String get networkTesting => 'Testen…';

  @override
  String get networkTestingShort => 'Testen';

  @override
  String networkLatencyMs(int ms) {
    return 'Latentie $ms ms';
  }

  @override
  String get networkConnectionMode => 'Verbindingsmodus';

  @override
  String get networkDirectMode => 'Directe modus';

  @override
  String get networkProxyMode => 'Proxymodus';

  @override
  String get networkDirectModeDesc => 'Rechtstreeks met de server verbinden';

  @override
  String get networkProxyModeDesc => 'Via een proxyserver verbinden';

  @override
  String get networkDirectRoutes => 'Directe routes';

  @override
  String get networkProxyRoutes => 'Proxyroutes';

  @override
  String get networkTestAll => 'Alles testen';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Knooppunt Hongkong';

  @override
  String get networkSingaporeNode => 'Knooppunt Singapore';

  @override
  String get networkJapanNode => 'Knooppunt Japan';

  @override
  String get networkUnitedStatesNode => 'Knooppunt Verenigde Staten';

  @override
  String get networkHint =>
      'Tips:\n• Directe modus: sneller en geschikt voor binnenlands gebruik\n• Proxymodus: stabieler voor grensoverschrijdende communicatie\n• Tik op het vernieuwingspictogram om de latentie van één route te testen';

  @override
  String get teenModeTitle => 'Tienermodus';

  @override
  String get teenModeStatusOn => 'Aan';

  @override
  String get teenModeStatusOff => 'Uit';

  @override
  String get teenModeStatusLoading => 'Laden';

  @override
  String get teenModeUnavailable =>
      'De status van de tienermodus is tijdelijk niet beschikbaar';

  @override
  String get teenModeInvalidResponse =>
      'De tienermodus gaf een ongeldig antwoord';

  @override
  String get teenModeEnableDescription =>
      'Platformregels beperken de gebruiksduur en bepaalde functies.';

  @override
  String get teenModePasscode => 'Toegangscode';

  @override
  String get teenModeCurrentPasscode => 'Huidige toegangscode';

  @override
  String get teenModeNewPasscode => 'Nieuwe toegangscode';

  @override
  String get teenModePasscodeHint => 'Voer 4–6 cijfers in';

  @override
  String get teenModeEnable => 'Tienermodus inschakelen';

  @override
  String get teenModeDisable => 'Tienermodus uitschakelen';

  @override
  String get teenModeChangePasscode => 'Toegangscode wijzigen';

  @override
  String get teenModeSource => 'Ingeschakeld door';

  @override
  String get teenModeDailyUsage => 'Vandaag gebruikt';

  @override
  String get teenModeRemaining => 'Resterende tijd';

  @override
  String get teenModeMinutesUnit => 'Minuten';

  @override
  String get teenModeUnlimited => 'Onbeperkt';

  @override
  String get teenModeRequestExtension => 'Meer tijd aanvragen';

  @override
  String get teenModeExtensionSubmitted =>
      'De tijdaanvraag is naar een ouder of voogd verzonden';

  @override
  String get teenModeTimeLimitReached =>
      'De gebruikslimiet voor vandaag is bereikt';

  @override
  String get teenModeCurfewActive => 'Het gebruik is in deze periode beperkt';

  @override
  String get teenModeReliefHint =>
      'U kunt nog steeds de geschiedenis bekijken, officiële ondersteuning benaderen en problemen melden.';

  @override
  String get teenModeRestrictedNotice =>
      'De tienermodus verhindert momenteel het verzenden van berichten';

  @override
  String get teenModeActionBlocked =>
      'De tienermodus verhindert momenteel deze actie';

  @override
  String get teenModeMyRequests => 'Mijn aanvragen';

  @override
  String get guardianCenterTitle => 'Ouder- en voogdcentrum';

  @override
  String get guardianRelationships => 'Voogdijrelaties';

  @override
  String get guardianMinors => 'Kinderen onder mijn toezicht';

  @override
  String get guardianApprovals => 'Wacht op goedkeuring';

  @override
  String get guardianBind => 'Voer koppelcode in';

  @override
  String get guardianCreateMinorCode => 'Ik ben een kind — code maken';

  @override
  String get guardianCreateGuardianCode => 'Ik ben ouder of voogd — code maken';

  @override
  String get guardianRelation => 'Relatie';

  @override
  String get guardianPrimary => 'Primaire ouder of voogd';

  @override
  String get guardianCode => '6-cijferige koppelcode';

  @override
  String get guardianCodeHint => 'Voer de code van de andere persoon in';

  @override
  String get guardianCodeCreated =>
      'Code aangemaakt. Deel deze voordat deze verloopt.';

  @override
  String get guardianEmpty => 'Geen voogdijrelaties';

  @override
  String get guardianNoMinors => 'Geen kinderen onder toezicht';

  @override
  String get guardianUnbind => 'Relatie verwijderen';

  @override
  String get guardianExtend => 'Tijd voor kind toevoegen';

  @override
  String get guardianPolicyTitle => 'Gebruiksregels';

  @override
  String get guardianPolicyLocked => 'Vergrendeld door het platform';

  @override
  String get approvalEmpty => 'Geen aanvragen';

  @override
  String get approvalApprove => 'Akkoord';

  @override
  String get approvalReject => 'Weigeren';

  @override
  String get approvalPending => 'In behandeling';

  @override
  String get approvalApproved => 'Goedgekeurd';

  @override
  String get approvalRejected => 'Afgewezen';

  @override
  String get approvalExpired => 'Verlopen';

  @override
  String get approvalCancelled => 'Geannuleerd';

  @override
  String get approvalReplayFailed =>
      'De oorspronkelijke actie is mislukt. Probeer deze opnieuw.';

  @override
  String get requestCancelled => 'Aanvraag geannuleerd';

  @override
  String get kycTitle => 'Identiteitsverificatie';

  @override
  String get kycNotRequired => 'Identiteitscontrole niet vereist';

  @override
  String get kycVerified => 'Identiteit geverifieerd';

  @override
  String get kycDeclared => 'Identiteitsgegevens ingediend';

  @override
  String get kycPending => 'Wordt beoordeeld';

  @override
  String get kycRejected => 'Beoordeling afgewezen';

  @override
  String get kycNone => 'Geen identiteitsgegevens ingediend';

  @override
  String get kycRealName => 'Volledige naam';

  @override
  String get kycIdNumber => 'ID-nummer';

  @override
  String get kycIdType => 'Documenttype';

  @override
  String get kycApplicability =>
      'Voer uw echte gegevens in voor het geselecteerde document. Geaccepteerde typen staan in de lijst.';

  @override
  String get kycCamera => 'Foto maken';

  @override
  String get kycGallery => 'Kies uit album';

  @override
  String get kycPhotoLimit => 'Maximum per foto';

  @override
  String get kycSelectPhoto => 'Foto selecteren';

  @override
  String get kycPhotoSelected => 'Geselecteerd';

  @override
  String get kycViewPhoto => 'Tik om foto te bekijken';

  @override
  String get kycReplacePhoto => 'Andere foto kiezen';

  @override
  String get kycDisclosure =>
      'Wij gebruiken uw naam, documentnummer en documentfoto’s om uw identiteit te controleren. Zonder deze gegevens kunt u niets indienen en zijn sommige beperkte functies mogelijk niet beschikbaar.';

  @override
  String get kycConsent =>
      'Ik geef afzonderlijk toestemming voor deze verwerking van identiteitsgegevens';

  @override
  String get kycConsentRequired =>
      'Geef vóór het indienen afzonderlijk toestemming';

  @override
  String get kycResubmitTitle => 'Identiteitsgegevens opnieuw indienen';

  @override
  String get kycResubmitWarning =>
      'Opnieuw indienen vervangt uw openstaande aanvraag. Doorgaan?';

  @override
  String get kycSubmitting => 'Indienen';

  @override
  String get kycSubmitFailed => 'Indienen mislukt. Probeer het opnieuw.';

  @override
  String get kycSubmitUnavailable =>
      'Identiteitsgegevens kunnen nu niet worden ingediend';

  @override
  String get kycResubmitNotAllowed =>
      'Na afwijzing is opnieuw indienen niet beschikbaar. Neem zo nodig contact op met ondersteuning.';

  @override
  String get kycDailyLimit =>
      'U hebt de indieningslimiet van vandaag bereikt. Probeer het morgen opnieuw.';

  @override
  String get kycTypeUnavailable =>
      'Geen documenttypen beschikbaar. Probeer het later opnieuw.';

  @override
  String get kycNameInvalid => 'De officiële naam moet 2–64 tekens bevatten';

  @override
  String get kycNumberRequired => 'Voer uw documentnummer in';

  @override
  String get kycFrontRequired => 'Upload de voorkant van uw document';

  @override
  String get kycBackRequired => 'Upload de achterkant van uw document';

  @override
  String get kycPhotoTooLarge =>
      'De foto overschrijdt de maximale grootte. Comprimeer deze en probeer het opnieuw.';

  @override
  String get kycAccountChanged =>
      'Het account of de ruimte is gewijzigd. Open deze pagina opnieuw.';

  @override
  String get kycPhotoInvalid => 'Kies een geldige afbeelding';

  @override
  String get kycPortraitSide => 'Zijde met portret';

  @override
  String get kycEmblemSide => 'Zijde met embleem';

  @override
  String get kycPassportDataPage => 'Paspoortpagina met persoonsgegevens';

  @override
  String get kycPassportOtherPage => 'Visumpagina of lege paspoortpagina';

  @override
  String get kycFront => 'Voorkant van identiteitsbewijs';

  @override
  String get kycBack => 'Achterkant van identiteitsbewijs';

  @override
  String get kycRequired =>
      'Identiteitscontrole is vereist voordat u een groep maakt';

  @override
  String get kycGoVerify => 'Nu verifiëren';

  @override
  String get kycStatusUnknown =>
      'Identiteitsstatus niet beschikbaar. Vernieuw later.';

  @override
  String get kycSuperseded =>
      'Een latere indiening heeft deze vervangen. Controleer uw nieuwste identiteitsstatus.';

  @override
  String get kycMediaNotFound =>
      'De documentfoto is niet beschikbaar in deze ruimte. Selecteer deze opnieuw voordat u indient.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Massabericht aan klanten';

  @override
  String get officialAccountBadge => 'Officieel';

  @override
  String get officialAccountOpenConversation => 'Gesprek openen';

  @override
  String get officialAccountJoinHint =>
      'Door dit account toe te voegen wordt u klant van het bedrijf. Goedkeuring als vriend is niet nodig.';

  @override
  String get officialAccountJoinDisabled =>
      'Dit bedrijf accepteert momenteel geen nieuwe klanten. Neem contact op met ondersteuning.';

  @override
  String get officialAccountRemoved =>
      'U bent uit dit bedrijf verwijderd. Vraag het bedrijf u opnieuw uit te nodigen.';

  @override
  String get officialAccountBanned =>
      'Uw account is in dit bedrijf uitgeschakeld.';

  @override
  String get officialAccountUnavailable =>
      'Dit officiële account is momenteel niet beschikbaar.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'In de huidige modus is lid worden van een bedrijf niet toegestaan.';

  @override
  String get officialAccountPlatformRequired =>
      'Gebruik een platformaccount om dit officiële account toe te voegen.';

  @override
  String get officialAccountOpenFailed =>
      'Het gesprek kon niet worden geopend. Probeer het opnieuw.';

  @override
  String get officialAccountAccountChanged =>
      'Het account of de ruimte is gewijzigd. Open het opnieuw.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'De bedrijfsgids is niet actueel. Probeer het binnenkort opnieuw.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Synchroniseren van officieel account mislukt. Lokale inhoud blijft beschikbaar.';

  @override
  String get officialAccountInboxSyncing =>
      'Berichten van officieel account synchroniseren';

  @override
  String get diagnosticsTitle => 'Diagnose';

  @override
  String get diagnosticsExplanation =>
      'De logboeken zijn ontdaan van gevoelige gegevens en bevatten operationele en foutinformatie voor dit account en deze ruimte, plus openbare opstartgebeurtenissen. Chatinhoud en aanmeldgegevens zijn uitgesloten.';

  @override
  String get diagnosticsHour => 'Afgelopen uur';

  @override
  String get diagnosticsDay => 'Afgelopen 24 uur';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Beschikbare gebeurtenissen: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Logboeken worden op dit apparaat opgeslagen en blijven na herstart beschikbaar.';

  @override
  String get diagnosticsNotPersistent =>
      'Sommige logboeken zijn niet opgeslagen. Vernieuw om het opnieuw te proberen.';

  @override
  String get diagnosticsExport => 'Exporteren en delen';

  @override
  String get diagnosticsRefresh => 'Vernieuwen';

  @override
  String get diagnosticsClear => 'Logboeken van deze ruimte wissen';

  @override
  String get diagnosticsClearConfirm =>
      'Diagnoselogboeken van deze ruimte wissen? De chatgeschiedenis blijft behouden.';

  @override
  String get diagnosticsShared =>
      'Delen via het systeem voltooid. Controleer het bestand in de ontvangende app.';

  @override
  String get diagnosticsCancelled =>
      'Delen geannuleerd. U kunt opnieuw exporteren.';

  @override
  String get diagnosticsUnconfirmed =>
      'Delen kon niet worden bevestigd. Controleer de ontvangende app.';

  @override
  String get diagnosticsFailed =>
      'De bewerking is mislukt. Probeer het opnieuw.';
}
