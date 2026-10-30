// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get navWorkbench => 'Arbejdsområde';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Kontodata kunne ikke indlæses';

  @override
  String get startupFailureTitle => 'Opstart mislykkedes';

  @override
  String get startupFailureMessage => 'Kontrollér netværket, og prøv igen';

  @override
  String get privacyConsentTitle => 'Brugervilkår og Fortrolighedspolitik';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Velkommen til $brand. For at levere kontologin, chatbeskeder, virksomhedssamarbejde, onlinekundeservice, beskednotifikationer og sikkerhedsbeskyttelse skal vi behandle nødvendige oplysninger i henhold til tjenestevilkårene og privatlivspolitikken.\n\nFør du trykker på »Acceptér«, læser vi ikke udklipsholderen, initialiserer ikke JPush/JCore eller enhedsproducenternes push-SDK’er og bruger ikke disse SDK’er til at få adgang til Android ID, OAID, lister over installerede apps, MAC-adresser eller lignende oplysninger. Hvis du foreløbigt afslår, gemmer vi dit valg; du kan fortsætte med at læse dokumenterne og vælge igen senere.\n\nEfter dit samtykke kan JPush/JCore og enhedsproducenternes push-tjenester behandle enhedsmodel, Android-version, apppakke og -version, netværkstype, IP-adresse, Android ID, OAID, push-registrerings-id, producentens push-token samt oplysninger om levering og klik på notifikationer for at levere besked-, kundeservice- og opkaldsnotifikationer. Vi har deaktiveret unødvendige funktioner, herunder intelligent push, lister over installerede apps, MAC, IMEI, IMSI, Wi-Fi-lister, automatisk vækning og tilknyttet opstart.\n\nUdklipsholderen tilgås kun, når du aktivt kopierer eller indsætter. Kamera-, mikrofon-, notifikations- og andre systemtilladelser anmodes kun, når du aktivt bruger den relevante funktion. Afvisning af én tilladelse påvirker kun den funktion. Læs de fulde dokumenter nedenfor, og vælg, om du accepterer.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Velkommen til $brand. For at levere kontologin, chatbeskeder, virksomhedssamarbejde, onlinekundeservice, beskednotifikationer og sikkerhedsbeskyttelse skal vi behandle nødvendige oplysninger i henhold til tjenestevilkårene og privatlivspolitikken.\n\nFør du trykker på »Acceptér«, læser vi ikke udklipsholderen, initialiserer ikke JPush/JCore, registrerer os ikke hos Apple Push Notification service (APNs) og indhenter ikke push-id’er såsom JPush-registrerings-id eller APNs-enhedstoken. Hvis du foreløbigt afslår, gemmer vi dit valg; du kan fortsætte med at læse dokumenterne og vælge igen senere.\n\nEfter dit samtykke kan vi behandle iPhone-model, iOS-version, apppakke og -version, netværkstype, IP-adresse, IDFV, JPush-registrerings-id, APNs-enhedstoken samt oplysninger om levering og klik på notifikationer for at levere besked-, kundeservice- og opkaldsnotifikationer. JPush/JCore opretter forbindelse til push-tjenesten; Apple APNs behandler app-id’et, enhedstokenet og notifikationens indhold for at levere systemnotifikationer. Den nuværende iOS-app bruger ikke reklametjenester og indhenter ikke IDFA.\n\nUdklipsholderen tilgås kun, når du aktivt kopierer eller indsætter. Kamera-, mikrofon-, notifikations- og andre systemtilladelser anmodes kun, når du aktivt bruger den relevante funktion. Afvisning af én tilladelse påvirker kun den funktion. Læs de fulde dokumenter nedenfor, og vælg, om du accepterer.';
  }

  @override
  String get privacyConsentTermsLink => 'Brugeraftale';

  @override
  String get privacyConsentConjunction => 'og';

  @override
  String get privacyConsentPrivacyLink => 'Privatlivspolitik';

  @override
  String get privacyConsentDecline => 'Afvis';

  @override
  String get privacyConsentDeclinedExit =>
      'Du accepterede ikke tjenestevilkårene og privatlivspolitikken. Appen lukkes nu.';

  @override
  String get privacyConsentAccept => 'Accepter';

  @override
  String get privacyConsentRuntimeFailure =>
      'Opstart mislykkedes. Kontrollér netværket, og prøv igen.';

  @override
  String get privacyConsentSaveFailure =>
      'Dit valg kunne ikke gemmes. Prøv igen.';

  @override
  String get appUpdateRequiredTitle => 'Opdatering kræves for at fortsætte';

  @override
  String get appUpdateOptionalTitle => 'Ny version tilgængelig';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version er tilgængelig';
  }

  @override
  String get appUpdateLater => 'Senere';

  @override
  String get appUpdateNow => 'Opdater nu';

  @override
  String get appUpdateProcessing => 'Behandler…';

  @override
  String get appUpdateInvalidUrl =>
      'Opdateringsadressen er ugyldig. Prøv igen senere.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Opdateringslinket kunne ikke åbnes. Prøv igen senere.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Download afbrudt. Kontrollér netværket, og prøv igen.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Pakkekontrol mislykkedes. Download igen.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Tillad, at $brand installerer opdateringer i systemindstillingerne.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Systemets installationsprogram kunne ikke åbnes. Kontrollér installationstilladelserne.';

  @override
  String get appUpdateGenericFailure =>
      'Opdatering mislykkedes. Kontrollér netværket, og prøv igen.';

  @override
  String get appUpdateUnavailable =>
      'Den nye version kan ikke downloades endnu. Prøv senere.';

  @override
  String get appUpdateCheckFailed =>
      'Kunne ikke søge efter opdateringer. Prøv igen senere.';

  @override
  String get appUpdateChecking => 'Kontrollerer';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Annuller';

  @override
  String get commonSave => 'Gem';

  @override
  String get commonEdit => 'Rediger';

  @override
  String get commonDelete => 'Slet';

  @override
  String get commonSearch => 'Søg';

  @override
  String get commonLoading => 'Indlæser…';

  @override
  String get commonLoadFailed => 'Indlæsning mislykkedes';

  @override
  String get commonRetry => 'Prøv igen';

  @override
  String get commonEmpty => 'Ingen data';

  @override
  String get commonCopy => 'Kopier';

  @override
  String get commonForward => 'Videresend';

  @override
  String get commonFavorite => 'Gem';

  @override
  String get commonClose => 'Luk';

  @override
  String get commonSend => 'Send';

  @override
  String get commonDone => 'Færdig';

  @override
  String get commonMore => 'Mere';

  @override
  String get commonSettings => 'Indstillinger';

  @override
  String get commonCopied => 'Kopieret';

  @override
  String get commonUnknown => 'Ukendt';

  @override
  String get commonNotSet => 'Ikke angivet';

  @override
  String get commonUnbound => 'Ikke forbundet';

  @override
  String get commonViewAll => 'Vis alle';

  @override
  String get commonSubmit => 'Indsend';

  @override
  String get commonAdd => 'Tilføj';

  @override
  String get commonRemove => 'Fjern';

  @override
  String get commonCreate => 'Opret';

  @override
  String get commonUpdate => 'Opdatér';

  @override
  String get commonUpload => 'Upload';

  @override
  String get commonShare => 'Del';

  @override
  String get commonBlock => 'Blokér';

  @override
  String get commonUnblock => 'Fjern blokering';

  @override
  String get commonMute => 'Slå lyd fra';

  @override
  String get commonUnmute => 'Slå lyd til';

  @override
  String get commonPin => 'Fastgjort';

  @override
  String get commonUnpin => 'Frigør';

  @override
  String get commonMarkRead => 'Markér som læst';

  @override
  String get commonMarkUnread => 'Markér som ulæst';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Handlingen mislykkedes. Prøv igen.';

  @override
  String get commonNetworkError => 'Netværksfejl. Kontrollér forbindelsen.';

  @override
  String get navMessages => 'Beskeder';

  @override
  String get navContacts => 'Kontakter';

  @override
  String get navMe => 'Mig';

  @override
  String get authLoginTitle => 'Log ind på StartLink';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'E-mail';

  @override
  String get authTabLoginName => 'StartLink-id';

  @override
  String get authHintMobile => 'Indtast telefonnummer';

  @override
  String get authHintEmail => 'Indtast din e-mailadresse';

  @override
  String get authHintPassword => 'Indtast adgangskode';

  @override
  String get authHintCode => 'Indtast bekræftelseskode';

  @override
  String get authHintLoginName => 'Indtast StartLink-id (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Log ind';

  @override
  String get authGetCode => 'Hent kode';

  @override
  String authResendCode(int seconds) {
    return 'Send igen om $seconds sek.';
  }

  @override
  String get authUsePassword => 'Brug adgangskode';

  @override
  String get authUseCode => 'Brug bekræftelseskode';

  @override
  String get authAgreementPrefix => 'Jeg har læst og accepterer';

  @override
  String get authAgreementAnd => 'og';

  @override
  String get authTermsLink => 'Brugeraftale';

  @override
  String get authPrivacyLink => 'Privatlivspolitik';

  @override
  String get authCaptchaTitle => 'Sikkerhedskontrol';

  @override
  String get authCaptchaHint => 'Indtast svaret';

  @override
  String get authCaptchaFailed => 'Kunne ikke hente captcha. Prøv igen.';

  @override
  String get authErrorEmptyCode => 'Indtast bekræftelseskoden';

  @override
  String get authErrorEmptyPassword => 'Indtast adgangskode';

  @override
  String get authErrorEmptyLoginName => 'Indtast dit StartLink-id';

  @override
  String get authErrorWrongCredentials => 'Forkert konto eller adgangskode';

  @override
  String get authDeactivatingTitle => 'Sletning af konto';

  @override
  String get authDeactivatingContent =>
      'Din konto er i fortrydelsesperioden for sletning (7 dage).\n\nTryk på »Annullér sletning« for at annullere, eller tryk på »Fortsæt« for at åbne appen.';

  @override
  String get authContinueUse => 'Fortsæt';

  @override
  String get authCancelDeactivation => 'Annullér sletning';

  @override
  String get authDeactivationCancelled =>
      'Sletning annulleret, konto gendannet';

  @override
  String get authDeactivationCancelFailed =>
      'Annullering mislykkedes. Prøv igen.';

  @override
  String get authLogout => 'Log ud';

  @override
  String get authLogoutConfirm => 'Vil du logge ud?';

  @override
  String get authSendingCode => 'Sender…';

  @override
  String get authCodeSent => 'Bekræftelseskode sendt';

  @override
  String get authLoginFailed => 'Login mislykkedes. Prøv igen.';

  @override
  String get authRegisterFailed => 'Registrering mislykkedes. Prøv igen.';

  @override
  String get authEnterpriseCode => 'Virksomhedskode';

  @override
  String get authEnterpriseCodeHint => 'Indtast virksomhedskode';

  @override
  String get authPendingApproval =>
      'Registrering gennemført. Din anmodning om at deltage i virksomheden er indsendt og afventer godkendelse.';

  @override
  String get authNoAccount => 'Har du ikke en konto?';

  @override
  String get authRegisterNow => 'Registrér nu';

  @override
  String get authCountryPickerTitle => 'Vælg land/område';

  @override
  String get authCountrySearchHint => 'Søg land/område';

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
  String get authCountryCanada => 'Canada';

  @override
  String get authCountryGermany => 'Tyskland';

  @override
  String get authCountryFrance => 'Frankrig';

  @override
  String get authCountryIndia => 'Indien';

  @override
  String get authCountryThailand => 'Thailand';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesien';

  @override
  String get authCountryPhilippines => 'Filippinerne';

  @override
  String get authQuickLoginTitle => 'Hurtigt login';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Logger ind. Vent venligst.';

  @override
  String get authRoleOwner => 'Ejer';

  @override
  String get authRoleAdministrator => 'Administrator';

  @override
  String get authRoleCustomerService => 'Kundeservice';

  @override
  String get authRoleTechnicalSupport => 'Teknisk support';

  @override
  String get authRoleEmployee => 'Medarbejder';

  @override
  String get authRoleMember => 'Medlem';

  @override
  String get authRoleEnterpriseCustomer => 'Virksomhedskunde';

  @override
  String get authUnavailablePrefix => 'Ikke tilgængelig ·';

  @override
  String get authUnassignedService => 'Ingen tildelt medarbejder';

  @override
  String authAssignedService(String staff) {
    return 'Tildelt $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Kunde · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Medarbejder · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count brugere';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Identitet';

  @override
  String get authRegisterTitle => 'Opret konto';

  @override
  String get authNickname => 'Kælenavn';

  @override
  String get authNicknameHint => 'Angiv et kaldenavn';

  @override
  String get authPassword => 'Adgangskode';

  @override
  String get authPasswordSetHint => 'Angiv en adgangskode (mindst 6 tegn)';

  @override
  String get authConfirmPassword => 'Bekræft adgangskode';

  @override
  String get authConfirmPasswordHint => 'Indtast adgangskoden igen';

  @override
  String get authVerificationCode => 'Bekræftelseskode';

  @override
  String get authRegisterAndLogin => 'Registrér og log ind';

  @override
  String get authHaveAccount => 'Har du allerede en konto?';

  @override
  String get authGoLogin => 'Log ind';

  @override
  String get authEmailVerificationUnavailable =>
      'E-mailbekræftelse er ikke tilgængelig. Registrér med et mobilnummer i stedet.';

  @override
  String get authSmsVerificationUnavailable =>
      'SMS-bekræftelse er ikke tilgængelig. Registrér med en e-mail i stedet.';

  @override
  String get authSendFailed => 'Kunne ikke sende. Prøv igen.';

  @override
  String get authErrorEmptyNickname => 'Indtast et kaldenavn';

  @override
  String get authErrorInvalidMobile => 'Indtast et gyldigt mobilnummer';

  @override
  String get authErrorInvalidEmail => 'Indtast en gyldig e-mailadresse';

  @override
  String get authErrorPasswordTooShort =>
      'Adgangskoden skal indeholde mindst 6 tegn';

  @override
  String get authErrorPasswordMismatch => 'Adgangskoderne stemmer ikke overens';

  @override
  String get authErrorVerificationRequired =>
      'Hent og indtast bekræftelseskoden først';

  @override
  String get authRegisterErrorTitle => 'Registrering mislykkedes';

  @override
  String get authGotIt => 'Forstået';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Virksomheden »$code« blev ikke fundet. Kontrollér virksomhedskoden.';
  }

  @override
  String get authTenantSearchFailed => 'Søgning mislykkedes. Prøv igen.';

  @override
  String get authInvitationInvalid =>
      'Invitationskoden er ugyldig. Kontrollér den, og prøv igen.';

  @override
  String get authCollapseJoin => 'Skjul oplysninger om deltagelse';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Gyldig invitation: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Virksomhed fundet: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Vælg organisation';

  @override
  String get authNoOrganization => 'Ingen organisationer tilgængelige';

  @override
  String get authNoOrganizationHint =>
      'Bed en administrator om at invitere dig til en organisation';

  @override
  String get authPersonalSpace => 'Personligt rum';

  @override
  String get authPersonalSpaceSubtitle => 'Vennechats og personlige favoritter';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Rummets identitet kunne ikke bekræftes. Prøv igen.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Det personlige rum kunne ikke gendannes. Prøv igen.';

  @override
  String get authJoinEnterpriseFailed =>
      'Kunne ikke deltage i virksomheden. Prøv igen senere.';

  @override
  String get homeTitle => 'Beskeder';

  @override
  String get homeGatewayConnectingTitle => 'Opretter forbindelse';

  @override
  String get homePersonalSpace => 'Personligt';

  @override
  String get homeOfficialService => 'Officiel service';

  @override
  String get homeSwitchSpace => 'Skift rum';

  @override
  String get homeSpaceSubtitle => 'Personligt · Virksomhed';

  @override
  String get homeJoinEnterprise => 'Deltag i virksomhed';

  @override
  String get homeCreateGroup => 'Ny gruppe';

  @override
  String get homeAddFriend => 'Tilføj kontakt';

  @override
  String get homeScan => 'Scan';

  @override
  String get homeJoinNewSpace => 'Deltag i nyt rum';

  @override
  String get homeSearchConversation => 'Søg';

  @override
  String get homeNoMessages => 'Ingen beskeder';

  @override
  String get homeDeleteConversation => 'Slet chat';

  @override
  String get homeDeleteConversationConfirm =>
      'Slet denne chat? Chathistorikken ryddes.';

  @override
  String get homePersonalNote => 'Mig (personlige noter)';

  @override
  String get homeWorkNote => 'Mig (arbejdsnoter)';

  @override
  String homeConversationCount(int count) {
    return '$count chats';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count ulæste';
  }

  @override
  String get chatInputHint => 'Skriv en besked…';

  @override
  String get chatVoiceHint => 'Hold for at tale';

  @override
  String get chatVoiceRelease => 'Slip for at sende';

  @override
  String get chatVoiceCancel => 'Stryg op for at annullere';

  @override
  String get chatMenuCopy => 'Kopier';

  @override
  String get chatMenuForward => 'Videresend';

  @override
  String get chatMenuRecall => 'Tilbagekald';

  @override
  String get chatMenuDelete => 'Slet';

  @override
  String get chatMenuFavorite => 'Gem';

  @override
  String get chatMenuReply => 'Svar';

  @override
  String get chatMenuMultiSelect => 'Vælg';

  @override
  String get chatMenuTranslate => 'Oversæt';

  @override
  String get chatMenuVoiceToText => 'Konvertér til tekst';

  @override
  String get chatMenuTextToSpeech => 'Læs højt';

  @override
  String get chatStatusRecalled => 'Besked tilbagekaldt';

  @override
  String get chatRecallSuccess => 'Tilbagekaldt';

  @override
  String get chatRecallFailed => 'Tilbagekaldelse mislykkedes';

  @override
  String get chatRecallTimeout =>
      'Beskeder ældre end 2 minutter kan ikke tilbagekaldes';

  @override
  String get chatTranslateFailed => 'Oversættelse mislykkedes. Prøv igen.';

  @override
  String get chatTranslateNotConfigured =>
      'Oversættelsestjenesten er ikke tilgængelig';

  @override
  String get chatVoiceToTextFailed => 'Konvertering mislykkedes. Prøv igen.';

  @override
  String get chatTextToSpeechFailed => 'Oplæsning mislykkedes. Prøv igen.';

  @override
  String get chatVoiceToText => 'Konvertér';

  @override
  String get chatForwardSuccess => 'Videresendt';

  @override
  String get chatForwardFailed => 'Videresendelse mislykkedes. Prøv igen.';

  @override
  String get chatNoConversations => 'Ingen chats at videresende til';

  @override
  String get chatSendFailed => 'Afsendelse mislykkedes';

  @override
  String get chatResend => 'Send igen';

  @override
  String get chatNotFriend => 'Ikke i kontaktlisten';

  @override
  String get chatNotFriendHint =>
      'I er endnu ikke kontakter. Beskeder kan ikke sendes.';

  @override
  String get chatMutedHint => 'Skrivning er begrænset for alle medlemmer';

  @override
  String get chatFileUploadFailed => 'Filupload mislykkedes. Prøv igen.';

  @override
  String get chatFileStatusNotDownloaded => 'Ikke downloadet';

  @override
  String get chatFileStatusDownloaded => 'Downloadet';

  @override
  String get chatFileStatusUploading => 'Uploader';

  @override
  String get chatFileStatusUploadFailed => 'Upload mislykkedes';

  @override
  String get chatCardSendFailed => 'Kontaktkort kunne ikke sendes';

  @override
  String get chatFavoriteSuccess => 'Gemt';

  @override
  String get chatFavoriteFailed => 'Kunne ikke tilføje til favoritter';

  @override
  String get chatLoadFailed => 'Indlæsning mislykkedes';

  @override
  String get chatImageMessage => '[Billede]';

  @override
  String get chatVoiceMessage => '[Talebesked]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Fil]';

  @override
  String get chatLocationMessage => '[Placering]';

  @override
  String get chatContactCardMessage => '[Kontakt]';

  @override
  String get chatCallLogMessage => '[Opkald]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Læst af $count';
  }

  @override
  String get chatUnread => 'Ulæst';

  @override
  String get chatRecalledSelf => 'Du tilbagekaldte en besked';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender tilbagekaldte en besked';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Oversættelse: $translation';
  }

  @override
  String get chatMessageDeleted => 'Besked slettet';

  @override
  String get chatPeer => 'Den anden';

  @override
  String get chatSelf => 'Mig';

  @override
  String get chatGenericMessage => '[Besked]';

  @override
  String get chatVoiceHideText => 'Skjul tekst';

  @override
  String get chatVoiceShowText => 'Konvertér til tekst';

  @override
  String get chatFileDefaultName => 'Fil';

  @override
  String get chatContactDefaultName => 'Kontakt';

  @override
  String get chatContactCardTitle => 'Kontaktkort';

  @override
  String get chatCallMissed => 'Ubesvaret';

  @override
  String get chatCallCancelled => 'Annulleret';

  @override
  String get chatCallRejected => 'Afvist';

  @override
  String get chatCallDisconnected => 'Forbindelse afbrudt';

  @override
  String get chatCallEnded => 'Opkald afsluttet';

  @override
  String get chatCallFailed => 'Opkald mislykkedes';

  @override
  String chatCallDuration(String duration) {
    return 'Varighed $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videoopkald';

  @override
  String get chatVoiceCallTitle => 'Taleopkald';

  @override
  String get chatToolPhotos => 'Fotos';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Fil';

  @override
  String get chatToolLocation => 'Placering';

  @override
  String get chatToolContactCard => 'Kontakt';

  @override
  String get chatToolVoiceCall => 'Taleopkald';

  @override
  String get chatToolVideoCall => 'Videoopkald';

  @override
  String get chatToolFavorites => 'Favoritter';

  @override
  String get chatToolTranslate => 'Oversæt';

  @override
  String get chatTranslationChooseLanguage => 'Vælg oversættelsessprog';

  @override
  String get chatTranslationEnterText => 'Indtast tekst først';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Oversættelse er ikke tilgængelig for beskeder med omtaler';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Oversættelse er ikke tilgængelig under redigering af en planlagt besked';

  @override
  String get chatTranslationFailed => 'Oversættelse mislykkedes. Prøv igen.';

  @override
  String get chatTranslationEmpty => 'Ingen oversættelse modtaget. Prøv igen.';

  @override
  String get chatTranslationTranslating => 'Oversætter…';

  @override
  String get chatTranslationSend => 'Send oversættelse';

  @override
  String get chatTranslationSending => 'Sender…';

  @override
  String get chatTranslationExpand => 'Vis mere';

  @override
  String get chatTranslationCollapse => 'Vis mindre';

  @override
  String get chatFileTooLarge => 'Filen overskrider grænsen på 100 MB';

  @override
  String get chatInputMutedAdminOnly =>
      'Kun ejeren eller udvalgte medlemmer må skrive.';

  @override
  String get chatImageUploadUnsupported =>
      'Billedupload mislykkedes. Serveren understøtter det ikke endnu.';

  @override
  String get chatFavoriteLongPressHint =>
      'Hold en besked nede for at tilføje den til favoritter';

  @override
  String chatSelectedCount(int count) {
    return '$count valgt';
  }

  @override
  String get chatLocationSheetTitle => 'Send placering';

  @override
  String get chatLocationNameLabel => 'Stednavn';

  @override
  String get chatLocationNameHint => 'F.eks. kontor, kundeadresse';

  @override
  String get chatLocationAddressLabel => 'Adresse';

  @override
  String get chatLocationOptionalHint => 'Valgfrit';

  @override
  String get chatLocationLatitudeLabel => 'Breddegrad';

  @override
  String get chatLocationLatitudeHint => '-90 til 90';

  @override
  String get chatLocationLongitudeLabel => 'Længdegrad';

  @override
  String get chatLocationLongitudeHint => '-180 til 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Indtast $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label er uden for intervallet';
  }

  @override
  String get chatLocationDefaultTitle => 'Placering';

  @override
  String get chatMutedFullNotice =>
      'Skrivning er begrænset i gruppen. Kun ejeren eller udvalgte medlemmer må skrive.';

  @override
  String get chatNotFriendSendBlocked =>
      'I er ikke længere venner og kan ikke sende beskeder';

  @override
  String get chatPersonalNotesTitle => 'Personlige noter';

  @override
  String get chatWorkNotesTitle => 'Arbejdsnoter';

  @override
  String get chatPersonalNotesDescription =>
      'Gem personlige tanker og vigtige oplysninger her\nSynkroniseret mellem enheder og altid tilgængelig';

  @override
  String get chatWorkNotesDescription =>
      'Gem arbejdsopgaver og arbejdsmateriale her\nTeamrum forbliver adskilte og sikre';

  @override
  String get chatNoMessages => 'Ingen beskeder';

  @override
  String chatReplyTo(String sender) {
    return 'Svar $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature kommer snart';
  }

  @override
  String get chatForwardSelectTitle => 'Vælg chat';

  @override
  String get chatContactSelectTitle => 'Vælg kontakt';

  @override
  String get chatNoContacts => 'Ingen kontakter';

  @override
  String get contactsTitle => 'Kontakter';

  @override
  String get contactsSearch => 'Søg kontakter';

  @override
  String get contactsNewFriends => 'Nye venner';

  @override
  String get contactsGroups => 'Grupper';

  @override
  String get contactsFavorites => 'Favoritter';

  @override
  String get contactsRecent => 'Seneste';

  @override
  String get contactsOrganization => 'Organisation';

  @override
  String get contactsAnnouncement => 'Meddelelser';

  @override
  String get contactsNewApplications => 'Nye ansøgninger';

  @override
  String get contactsCustomerGroups => 'Kundegrupper';

  @override
  String get contactsAllCustomers => 'Alle kunder';

  @override
  String get contactsMyCustomers => 'Mine kunder';

  @override
  String get contactsViewAll => 'Vis alle';

  @override
  String get contactsMyContacts => 'Mine kontakter';

  @override
  String get contactsMyAdvisor => 'Min rådgiver';

  @override
  String get contactsNoAdvisor => 'Ingen rådgiver tildelt endnu';

  @override
  String get contactsAdvisorLoading => 'Indlæser…';

  @override
  String get contactsNavigateFailed => 'Navigation mislykkedes. Prøv igen.';

  @override
  String get contactsEmpty => 'Ingen kontakter';

  @override
  String get contactsNoAnnouncement => 'Ingen meddelelser';

  @override
  String get contactsOfficialBadge => 'Officiel';

  @override
  String get contactsCustomerBadge => 'Kunde';

  @override
  String get contactsEmptyCustomers => 'Ingen kunder';

  @override
  String get myTitle => 'Mig';

  @override
  String get myEnterpriseInfo => 'Virksomhedsoplysninger';

  @override
  String get myEnterpriseManage => 'Virksomhedsadministration';

  @override
  String get myQrCode => 'QR-kode';

  @override
  String get myFavorites => 'Favoritter';

  @override
  String get myLanguage => 'Sprog';

  @override
  String get myTimezone => 'Tidszone';

  @override
  String get myAutoTranslate => 'Automatisk oversættelse';

  @override
  String get myNetworkSwitch => 'Skift linje';

  @override
  String get mySettings => 'Indstillinger';

  @override
  String get myLogout => 'Log ud';

  @override
  String get myLogoutConfirm => 'Vil du logge ud?';

  @override
  String get myLeaveEnterprise => 'Forlad virksomhed';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Vil du forlade denne virksomhed? Du mister adgang til virksomhedens data.';

  @override
  String get myLeaveEnterpriseSuccess => 'Virksomhed forladt';

  @override
  String get myLeaveEnterpriseFailed => 'Kunne ikke forlade. Prøv igen.';

  @override
  String get myLppIdCopied => 'StartLink-id kopieret';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink-id: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count kontakter';
  }

  @override
  String get myAutoSelect => 'Automatisk';

  @override
  String get myPresenceStatus => 'Tilstedeværelse';

  @override
  String get myPresenceStatusTitle => 'Angiv tilstedeværelse';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Optaget';

  @override
  String get myPresenceAway => 'Fraværende';

  @override
  String get myPresenceInvisible => 'Usynlig';

  @override
  String get profileTitle => 'Min profil';

  @override
  String get profileName => 'Navn';

  @override
  String get profileGender => 'Køn';

  @override
  String get profileBirthday => 'Fødselsdag';

  @override
  String get profileRegion => 'Område';

  @override
  String get profileSignature => 'Profiltekst';

  @override
  String get profileSignatureHint => 'Fortæl lidt om dig selv';

  @override
  String get profileTapTapText => 'Prik';

  @override
  String get profileTapTapHint => 'Tekst ved prik (højst 20 tegn)';

  @override
  String get profileAccountSection => 'Konto';

  @override
  String get profileBasicSection => 'Grundoplysninger';

  @override
  String get profileLppId => 'StartLink-id';

  @override
  String get profileLppIdNotSet => 'Ikke angivet';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Ikke forbundet';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileEmailUnbound => 'Ikke forbundet';

  @override
  String get profileQrCode => 'Min QR-kode';

  @override
  String get profileChangePassword => 'Skift adgangskode';

  @override
  String get profileGenderMale => 'Mand';

  @override
  String get profileGenderFemale => 'Kvinde';

  @override
  String get profileGenderOther => 'Andet';

  @override
  String get profileGenderUnset => 'Ikke angivet';

  @override
  String get profileSaveFailed => 'Kunne ikke gemme. Prøv igen.';

  @override
  String get profileLppIdTitle => 'StartLink-id';

  @override
  String get profileLppIdSetOnce =>
      'StartLink-id kan kun ændres én gang. Vælg med omhu.';

  @override
  String get profileLppIdChangeFailed =>
      'Ændring mislykkedes (StartLink-id kan kun ændres én gang)';

  @override
  String get profileChangePasswordOld => 'Nuværende adgangskode';

  @override
  String get profileChangePasswordNew => 'Ny adgangskode';

  @override
  String get profileChangePasswordConfirm => 'Bekræft ny adgangskode';

  @override
  String get profileChangePasswordMismatch =>
      'Adgangskoderne stemmer ikke overens';

  @override
  String get profileChangePasswordSuccess =>
      'Adgangskode ændret. Log ind igen.';

  @override
  String get profileChangePasswordFailed =>
      'Kunne ikke ændre adgangskoden. Prøv igen.';

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get settingsSectionEnterprise => 'Virksomhed';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsSectionGeneral => 'Generelt';

  @override
  String get settingsSectionFeatures => 'Funktioner';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsEnterpriseInfo => 'Virksomhedsoplysninger';

  @override
  String get settingsProfile => 'Min profil';

  @override
  String get settingsAccountSecurity => 'Kontosikkerhed';

  @override
  String get settingsNotification => 'Notifikationer';

  @override
  String get settingsDisplay => 'Visning';

  @override
  String get settingsFriendPrivacy => 'Privatliv';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Chathistorik';

  @override
  String get settingsAbout => 'Om StartLink';

  @override
  String get settingsLanguage => 'Sprog';

  @override
  String get settingsTimezone => 'Tidszone';

  @override
  String get settingsAutoTranslate => 'Automatisk oversættelse';

  @override
  String get settingsNetworkSwitch => 'Skift linje';

  @override
  String get enterpriseInfoTitle => 'Virksomhedsoplysninger';

  @override
  String get enterpriseName => 'Navn';

  @override
  String get enterpriseDescription => 'Beskrivelse';

  @override
  String get enterpriseUpdateSuccess => 'Opdateret med succes';

  @override
  String get enterpriseUpdateFailed => 'Opdatering mislykkedes. Prøv igen.';

  @override
  String get enterpriseLeave => 'Forlad virksomhed';

  @override
  String get enterpriseLeaveConfirm => 'Vil du forlade denne virksomhed?';

  @override
  String get enterpriseLeaveSuccess => 'Virksomhed forladt';

  @override
  String get enterpriseLeaveFailed => 'Kunne ikke forlade. Prøv igen.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Ejeren kan ikke forlade direkte. Overdrag først ejerskabet.';

  @override
  String get enterpriseMemberCount => 'Medlemmer';

  @override
  String get enterpriseCreatedAt => 'Oprettet';

  @override
  String get enterpriseCode => 'Virksomhedskode';

  @override
  String get enterpriseInviteMembers => 'Invitér medlemmer';

  @override
  String get enterpriseCopyInviteCode => 'Kopiér invitationskode';

  @override
  String get enterpriseInviteCodeCopied => 'Invitationskode kopieret';

  @override
  String get groupCreateTitle => 'Ny gruppe';

  @override
  String get groupNameHint => 'Indtast gruppenavn';

  @override
  String get groupCreateSuccess => 'Gruppe oprettet';

  @override
  String get groupCreateFailed => 'Gruppen kunne ikke oprettes';

  @override
  String get groupSettings => 'Gruppeindstillinger';

  @override
  String get groupName => 'Gruppenavn';

  @override
  String get groupAvatar => 'Gruppebillede';

  @override
  String get groupAnnouncement => 'Meddelelse';

  @override
  String get groupMembers => 'Medlemmer';

  @override
  String get groupAddMember => 'Tilføj medlemmer';

  @override
  String get groupRemoveMember => 'Fjern medlem';

  @override
  String get groupRemoveMemberConfirm => 'Fjern dette medlem?';

  @override
  String get groupSetAdmin => 'Gør til administrator';

  @override
  String get groupRemoveAdmin => 'Fjern administratorrettigheder';

  @override
  String get groupTransferOwner => 'Overdrag ejerskab';

  @override
  String get groupTransferOwnerConfirm =>
      'Overdrag gruppens ejerskab til dette medlem?';

  @override
  String get groupTransferOwnerSuccess => 'Ejerskab overdraget';

  @override
  String get groupTransferOwnerFailed => 'Overdragelse mislykkedes. Prøv igen.';

  @override
  String get groupLeave => 'Forlad gruppe';

  @override
  String get groupLeaveConfirm => 'Forlad denne gruppe?';

  @override
  String get groupLeaveSuccess => 'Gruppe forladt';

  @override
  String get groupLeaveFailed => 'Kunne ikke forlade. Prøv igen.';

  @override
  String get groupDissolve => 'Opløs gruppe';

  @override
  String get groupDissolveConfirm =>
      'Opløs denne gruppe? Alle medlemmer fjernes.';

  @override
  String get groupDissolveSuccess => 'Gruppe opløst';

  @override
  String get groupDissolveFailed => 'Opløsning mislykkedes. Prøv igen.';

  @override
  String get groupQrCode => 'Gruppens QR-kode';

  @override
  String get groupMuteAll => 'Begræns skrivning for alle';

  @override
  String get groupMuteAllOn => 'Aktivér skrivebegrænsning for alle';

  @override
  String get groupMuteAllOff => 'Ophæv skrivebegrænsning for alle';

  @override
  String get groupAllowMemberInvite => 'Tillad medlemsinvitationer';

  @override
  String get groupAllowMemberModifyTitle =>
      'Tillad medlemmer at ændre gruppenavnet';

  @override
  String get groupAllowMemberAtAll => 'Tillad medlemmer at omtale @Alle';

  @override
  String get groupAllowMemberViewMemberList =>
      'Tillad medlemmer at se medlemslisten';

  @override
  String get groupAllowQrCodeJoin => 'Tillad deltagelse via QR-kode';

  @override
  String get groupRequireApproval => 'Kræv godkendelse for deltagelse';

  @override
  String get groupAllowMemberAddFriend =>
      'Tillad medlemmer at tilføje hinanden';

  @override
  String get groupRoleOwner => 'Ejer';

  @override
  String get groupRoleAdmin => 'Administrator';

  @override
  String get groupRoleMember => 'Medlem';

  @override
  String get groupNoMembers => 'Ingen medlemmer';

  @override
  String get groupNoAnnouncements => 'Ingen meddelelser';

  @override
  String get groupCreateAnnouncement => 'Opret meddelelse';

  @override
  String get groupEditAnnouncement => 'Redigér meddelelse';

  @override
  String get groupDeleteAnnouncement => 'Slet meddelelse';

  @override
  String get groupDeleteAnnouncementConfirm => 'Slet denne meddelelse?';

  @override
  String get groupAnnouncementTitle => 'Titel';

  @override
  String get groupAnnouncementContent => 'Indhold';

  @override
  String get groupAnnouncementPin => 'Fastgør meddelelse';

  @override
  String groupMemberCount(int count) {
    return '$count medlemmer';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count valgt';
  }

  @override
  String get groupJoinRequestApprove => 'Accepter';

  @override
  String get groupJoinRequestReject => 'Afvis';

  @override
  String get groupJoinRequests => 'Deltagelsesanmodninger';

  @override
  String get groupNoJoinRequests => 'Ingen deltagelsesanmodninger';

  @override
  String get groupReadReceipts => 'Læsekvitteringer';

  @override
  String groupReadCount(int count) {
    return '$count læst';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count ulæste';
  }

  @override
  String get friendAddTitle => 'Tilføj kontakt';

  @override
  String get friendSearchHint => 'Telefon / E-mail / StartLink-id';

  @override
  String get friendRequestSent => 'Venneanmodning sendt';

  @override
  String get friendRequestFailed => 'Afsendelse mislykkedes. Prøv igen.';

  @override
  String get friendAlreadyFriend => 'Allerede kontakter';

  @override
  String get friendNewFriendsTitle => 'Nye venner';

  @override
  String get friendNoRequests => 'Ingen venneanmodninger';

  @override
  String get friendAccept => 'Acceptér';

  @override
  String get friendReject => 'Afvis';

  @override
  String get friendAccepted => 'Accepteret';

  @override
  String get friendRejected => 'Afvist';

  @override
  String get friendDeleteConfirm => 'Fjern denne kontakt?';

  @override
  String get friendDeleteSuccess => 'Kontakt fjernet';

  @override
  String get friendDeleteFailed => 'Fjernelse mislykkedes. Prøv igen.';

  @override
  String get friendRemarkName => 'Kaldenavn';

  @override
  String get friendGroupName => 'Gruppe';

  @override
  String get friendSendMessage => 'Besked';

  @override
  String get friendMatchTypeLppId => 'Fundet via StartLink-id';

  @override
  String get friendMatchTypeMobile => 'Fundet via telefon';

  @override
  String get friendMatchTypeEmail => 'Fundet via e-mail';

  @override
  String get friendSearchEmpty => 'Ingen brugere fundet';

  @override
  String get friendAddMessage => 'Jeg vil gerne tilføje dig som kontakt';

  @override
  String get friendBlockConfirm => 'Blokér denne bruger?';

  @override
  String get friendUnblockConfirm => 'Fjern blokering af denne bruger?';

  @override
  String get friendBlockSuccess => 'Blokeret';

  @override
  String get friendUnblockSuccess => 'Blokering fjernet';

  @override
  String get profilePageTitle => 'Personlige oplysninger';

  @override
  String get profilePageSendMessage => 'Besked';

  @override
  String get profilePageAddFriend => 'Tilføj ven';

  @override
  String get profilePageAlreadyFriend => 'Allerede venner';

  @override
  String get profilePageBlocked => 'Blokeret';

  @override
  String get profilePageBlock => 'Blokér';

  @override
  String get profilePageUnblock => 'Fjern blokering';

  @override
  String get profilePageHidden => 'Denne bruger har skjult sin profil';

  @override
  String get profilePageFriendsOnly =>
      'Denne bruger viser kun sin profil til venner';

  @override
  String get profilePageLppId => 'StartLink-id';

  @override
  String get profilePageRemarkName => 'Bemærkninger';

  @override
  String get profilePageEditRemark => 'Redigér kaldenavn';

  @override
  String get profilePageSaveRemarkSuccess => 'Kaldenavn gemt';

  @override
  String get profilePageSaveRemarkFailed => 'Kunne ikke gemme. Prøv igen.';

  @override
  String get searchTitle => 'Søg';

  @override
  String get searchHint => 'Søg via telefon, e-mail eller StartLink-id';

  @override
  String get searchNoResults => 'Ingen resultater fundet';

  @override
  String get searchMessages => 'Beskeder';

  @override
  String get searchUsers => 'Brugere';

  @override
  String get searchFailed => 'Søgning mislykkedes. Prøv igen.';

  @override
  String get scanTitle => 'Scan';

  @override
  String get scanFailed => 'Genkendelse mislykkedes. Prøv igen.';

  @override
  String get scanInvalidQrCode => 'Ugyldig QR-kode';

  @override
  String get scanFlashOn => 'Tænd lommelygte';

  @override
  String get scanFlashOff => 'Sluk lommelygte';

  @override
  String get scanAlbum => 'Vælg fra album';

  @override
  String get favoritesTitle => 'Favoritter';

  @override
  String get favoritesEmpty => 'Intet gemt endnu';

  @override
  String get favoritesAll => 'Alle';

  @override
  String get favoritesText => 'Tekst';

  @override
  String get favoritesImage => 'Billeder';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Tale';

  @override
  String get favoritesFile => 'Filer';

  @override
  String get favoritesOther => 'Andet';

  @override
  String get favoritesDeleteConfirm => 'Fjern fra favoritter?';

  @override
  String get favoritesDeleteSuccess => 'Fjernet fra gemt';

  @override
  String get favoritesDeleteFailed => 'Fjernelse mislykkedes';

  @override
  String get favoritesOriginalRecalled => 'Besked tilbagekaldt';

  @override
  String get favoritesViewOriginal => 'Vis original';

  @override
  String get favoritesSearchHint => 'Søg favoritter';

  @override
  String get favoritesNoResults => 'Ingen matchende favoritter';

  @override
  String get noticeTitle => 'Meddelelser';

  @override
  String get noticeEmpty => 'Ingen meddelelser';

  @override
  String get noticeDetail => 'Meddelelsesdetaljer';

  @override
  String get noticePublishedAt => 'Udgivet';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Vigtig';

  @override
  String get noticePriorityUrgent => 'Haster';

  @override
  String get organizationTitle => 'Organisation';

  @override
  String get organizationEmpty => 'Ingen afdelingsoplysninger';

  @override
  String get organizationMembers => 'Medlemmer';

  @override
  String get organizationDepartment => 'Afdeling';

  @override
  String get organizationPosition => 'Stilling';

  @override
  String get organizationLeader => 'Leder';

  @override
  String get qrCodeTitle => 'Min QR-kode';

  @override
  String get qrCodeSave => 'Gem til album';

  @override
  String get qrCodeShare => 'Del';

  @override
  String get qrCodeSaveSuccess => 'Gemt i album';

  @override
  String get qrCodeSaveFailed => 'Kunne ikke gemme. Prøv igen.';

  @override
  String get qrCodeRefresh => 'Opdatér QR-kode';

  @override
  String get qrCodeExpired => 'QR-koden er udløbet. Opdatér den.';

  @override
  String get qrCodeScanToAdd => 'Scan for at tilføje mig som kontakt';

  @override
  String get spacePersonal => 'Personligt';

  @override
  String get spaceEnterprise => 'Virksomhed';

  @override
  String get spaceJoinByCode => 'Deltag med virksomhedskode';

  @override
  String get spaceJoinByInvite => 'Deltag med invitationskode';

  @override
  String get spaceEnterCode => 'Indtast virksomhedskode';

  @override
  String get spaceEnterInviteCode => 'Indtast invitationskode';

  @override
  String get spaceSearchEnterprise => 'Søg virksomhed';

  @override
  String get spaceJoinRequestSent => 'Anmodning indsendt, afventer godkendelse';

  @override
  String get spaceJoinRequestPending => 'Afventer godkendelse';

  @override
  String get spaceJoinRequestApproved => 'Anmodning godkendt';

  @override
  String get spaceJoinRequestRejected => 'Anmodning afvist';

  @override
  String get spaceAlreadyMember => 'Du er allerede medlem';

  @override
  String get spaceAutoApproved => 'Automatisk godkendt. Velkommen!';

  @override
  String get spacePendingApprovalHint =>
      'Registrering gennemført. Din deltagelsesanmodning er indsendt.';

  @override
  String get spaceNoSpaces => 'Ingen rum';

  @override
  String get spaceInviteExpired => 'Invitationskoden er udløbet';

  @override
  String get spaceInviteTargetMismatch =>
      'Denne invitationskode er ikke til din konto';

  @override
  String get spaceAcceptInviteSuccess => 'Du deltager nu i virksomheden';

  @override
  String get spaceAcceptInviteFailed => 'Kunne ikke deltage. Prøv igen.';

  @override
  String get spaceTenantSelectTitle => 'Vælg rum';

  @override
  String get spaceTenantSelectHint => 'Vælg et rum at åbne';

  @override
  String get spaceEnterPersonal => 'Åbn personligt rum';

  @override
  String get spaceEnterEnterprise => 'Åbn virksomhedsrum';

  @override
  String get aboutTitle => 'Om StartLink';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutTerms => 'Brugeraftale';

  @override
  String get aboutPrivacy => 'Privatlivspolitik';

  @override
  String get aboutOpenSource => 'Open source-licenser';

  @override
  String get aboutCheckUpdate => 'Søg efter opdateringer';

  @override
  String get aboutLatestVersion => 'Du har den seneste version';

  @override
  String get aboutUpdateAvailable => 'Ny version tilgængelig';

  @override
  String get aboutUpdateNow => 'Opdater nu';

  @override
  String get aboutUpdateLater => 'Senere';

  @override
  String get notificationTitle => 'Notifikationer';

  @override
  String get notificationGlobalMute => 'Forstyr ikke';

  @override
  String get notificationSound => 'Lyd';

  @override
  String get notificationVibration => 'Vibration';

  @override
  String get notificationPreview => 'Forhåndsvisning af beskeder';

  @override
  String get notificationDndStart => 'Starttid for Forstyr ikke';

  @override
  String get notificationDndEnd => 'Sluttid for Forstyr ikke';

  @override
  String get blacklistTitle => 'Sortlistet';

  @override
  String get blacklistEmpty => 'Ingen blokerede brugere';

  @override
  String get blacklistRemove => 'Fjern blokering';

  @override
  String get blacklistRemoveConfirm => 'Fjern blokering af denne bruger?';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackTypeComplaint => 'Klage';

  @override
  String get feedbackTypeSuggestion => 'Forslag';

  @override
  String get feedbackTypeBug => 'Fejlrapport';

  @override
  String get feedbackContent => 'Beskrivelse';

  @override
  String get feedbackContentHint =>
      'Beskriv dit problem eller forslag i detaljer';

  @override
  String get feedbackContact => 'Kontakt (valgfrit)';

  @override
  String get feedbackSubmit => 'Indsend';

  @override
  String get feedbackSuccess => 'Feedback indsendt. Tak!';

  @override
  String get feedbackFailed => 'Indsendelse mislykkedes. Prøv igen.';

  @override
  String get networkTitle => 'Skift linje';

  @override
  String get networkAutoSelect => 'Automatisk';

  @override
  String get networkManual => 'Manuelt';

  @override
  String get timezoneTitle => 'Tidszone';

  @override
  String get timezoneAuto => 'Følg systemet';

  @override
  String get autoTranslateTitle => 'Automatisk oversættelse';

  @override
  String get autoTranslateEnabled => 'Aktivér automatisk oversættelse';

  @override
  String get autoTranslateLanguage => 'Målsprog';

  @override
  String get displayTitle => 'Visning';

  @override
  String get displayFontSize => 'Skriftstørrelse';

  @override
  String get displayChatBackground => 'Chatbaggrund';

  @override
  String get displayDarkMode => 'Udseende';

  @override
  String get displayDarkModeSystem => 'Følg systemet';

  @override
  String get displayDarkModeSystemHint =>
      'Skift automatisk efter systemindstillingen';

  @override
  String get displayDarkModeOff => 'Lys';

  @override
  String get displayDarkModeOffHint => 'Brug altid lyst tema';

  @override
  String get displayDarkModeOn => 'Mørk';

  @override
  String get displayDarkModeOnHint => 'Brug altid mørkt tema';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Chathistorik';

  @override
  String get chatHistoryClear => 'Ryd al historik';

  @override
  String get chatHistoryClearConfirm =>
      'Ryd al chathistorik? Dette kan ikke fortrydes.';

  @override
  String get chatHistoryClearSuccess => 'Chathistorik ryddet';

  @override
  String get accountSecurityTitle => 'Kontosikkerhed';

  @override
  String get accountSecurityChangePassword => 'Skift adgangskode';

  @override
  String get accountSecurityChangeMobile => 'Skift telefonnummer';

  @override
  String get accountSecurityChangeEmail => 'Skift e-mail';

  @override
  String get accountSecurityLoggedDevices => 'Enheder med login';

  @override
  String get accountSecurityDeactivate => 'Slet konto';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Alle data slettes permanent efter 7 dage. Slet konto?';

  @override
  String get loggedDevicesTitle => 'Enheder med login';

  @override
  String get loggedDevicesCurrent => 'Denne enhed';

  @override
  String get loggedDevicesRevoke => 'Log ud';

  @override
  String get loggedDevicesRevokeConfirm => 'Log ud fra denne enhed?';

  @override
  String get loggedDevicesRevokeSuccess => 'Logget ud fra enhed';

  @override
  String get loggedDevicesRevokeFailed => 'Mislykkedes. Prøv igen.';

  @override
  String get loggedDevicesLastActive => 'Senest aktiv';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Computer';

  @override
  String get loggedDevicesTypeUnknown => 'Ukendt enhed';

  @override
  String get privacySettingsTitle => 'Privatliv';

  @override
  String get privacySearchableByMobile => 'Tillad søgning via telefonnummer';

  @override
  String get privacySearchableByLppId => 'Tillad søgning via StartLink-id';

  @override
  String get privacyAllowFriendRequest => 'Tillad venneanmodninger';

  @override
  String get privacyProfileVisibility => 'Profilsynlighed';

  @override
  String get privacyEveryone => 'Alle';

  @override
  String get privacyFriendsOfFriends => 'Venners venner';

  @override
  String get privacyNobody => 'Ingen';

  @override
  String get privacyFriendsOnly => 'Kun venner';

  @override
  String get privacySaveSuccess => 'Indstillinger gemt';

  @override
  String get privacySaveFailed => 'Kunne ikke gemme. Prøv igen.';

  @override
  String get fontSizeTitle => 'Skriftstørrelse';

  @override
  String get fontSizeSmall => 'Lille';

  @override
  String get fontSizeNormal => 'Normal';

  @override
  String get fontSizeLarge => 'Stor';

  @override
  String get fontSizeExtraLarge => 'Ekstra stor';

  @override
  String get fontSizePreview => 'Forhåndsvisning';

  @override
  String get chatBackgroundTitle => 'Chatbaggrund';

  @override
  String get chatBackgroundDefault => 'Standard';

  @override
  String get chatBackgroundCustom => 'Brugerdefineret';

  @override
  String get chatBackgroundReset => 'Gendan standardindstillinger';

  @override
  String get termsTitle => 'Brugeraftale';

  @override
  String get privacyPolicyTitle => 'Privatlivspolitik';

  @override
  String get recentContactsTitle => 'Seneste';

  @override
  String get recentContactsEmpty => 'Ingen seneste kontakter';

  @override
  String get inviteFriendsTitle => 'Invitér venner';

  @override
  String get inviteFriendsCopyLink => 'Kopiér invitationslink';

  @override
  String get inviteFriendsLinkCopied => 'Invitationslink kopieret';

  @override
  String get imageViewerTitle => 'Foto';

  @override
  String get imageViewerSave => 'Gem til album';

  @override
  String get imageViewerSaveSuccess => 'Gemt i album';

  @override
  String get imageViewerSaveFailed => 'Kunne ikke gemme. Prøv igen.';

  @override
  String get customerServiceTitle => 'Servicecenter';

  @override
  String get customerServiceQueue => 'I kø';

  @override
  String get customerServiceActive => 'Aktiv';

  @override
  String get customerServiceClaim => 'Acceptér';

  @override
  String get customerServiceTakeover => 'Overtag';

  @override
  String get customerServiceClose => 'Afslut service';

  @override
  String get customerServiceCloseConfirm => 'Afslut denne servicesamtale?';

  @override
  String get customerServiceNoQueue => 'Ingen samtaler i kø';

  @override
  String get customerServiceNoActive => 'Ingen aktive samtaler';

  @override
  String get customerServiceVisitor => 'Besøgende';

  @override
  String get customerServiceCustomer => 'Kunde';

  @override
  String get customerServiceAssignedTo => 'Tildelt til';

  @override
  String get customerServiceTransferConversation => 'Overdrag chat';

  @override
  String get marketingToolbar => 'Marketingværktøjer';

  @override
  String get callIncoming => 'Indgående opkald';

  @override
  String get callOutgoing => 'Udgående opkald';

  @override
  String get callAccept => 'Acceptér';

  @override
  String get callReject => 'Afvis';

  @override
  String get callHangup => 'Afslut';

  @override
  String get callMissed => 'Ubesvaret opkald';

  @override
  String get callDuration => 'Varighed';

  @override
  String get callAudio => 'Taleopkald';

  @override
  String get callGeneric => 'Opkald';

  @override
  String get callVideo => 'Videoopkald';

  @override
  String get callConnecting => 'Opretter forbindelse…';

  @override
  String get callRinging => 'Ringer…';

  @override
  String get callEnded => 'Opkald afsluttet';

  @override
  String get callFailed => 'Opkald mislykkedes';

  @override
  String get callRejected => 'Opkald afvist';

  @override
  String get callTimeout => 'Intet svar';

  @override
  String get callCancelled => 'Annulleret';

  @override
  String get callUnknownPeer => 'Ukendt';

  @override
  String get callVideoInvitation => 'Invitation til videoopkald';

  @override
  String get callAudioInvitation => 'Invitation til taleopkald';

  @override
  String get callAnswerAudio => 'Besvar med lyd';

  @override
  String get callAnswerVideo => 'Besvar med video';

  @override
  String get callViewProfile => 'Vis profil';

  @override
  String get callOpeningCamera => 'Åbner kamera…';

  @override
  String get callWaitingRemoteVideo => 'Venter på den andens video…';

  @override
  String get callCameraOff => 'Kamera slukket';

  @override
  String get callCameraOn => 'Kamera tændt';

  @override
  String get callMicrophoneOff => 'Mikrofon slukket';

  @override
  String get callMicrophoneOn => 'Mikrofon tændt';

  @override
  String get callSpeakerOff => 'Højttaler slukket';

  @override
  String get callSpeakerOn => 'Højttaler tændt';

  @override
  String get callVideoPermissionFailure =>
      'Videoopkaldet kunne ikke startes. Kontrollér kamera- og mikrofontilladelserne, og prøv igen.';

  @override
  String get callAudioPermissionFailure =>
      'Taleopkaldet kunne ikke startes. Kontrollér mikrofontilladelsen, og prøv igen.';

  @override
  String get callIncompleteIncoming =>
      'Oplysninger om det indgående opkald er ufuldstændige, så det kan ikke besvares.';

  @override
  String get callInProgress => 'I opkald';

  @override
  String get callCalling => 'Ringer op…';

  @override
  String callEndedMedia(String media) {
    return '$media afsluttet';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media blev afvist';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media blev ikke besvaret';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media blev annulleret';
  }

  @override
  String get callConnectionLost => 'Opkaldsforbindelsen mistet';

  @override
  String get callAdminEnded => 'Opkald afsluttet af administrator';

  @override
  String callFailedMedia(String media) {
    return '$media mislykkedes';
  }

  @override
  String get callBusy => 'Den anden er optaget';

  @override
  String callDurationValue(String duration) {
    return 'Opkaldsvarighed $duration';
  }

  @override
  String get callNotConnected => 'Ikke forbundet';

  @override
  String get callDialed => 'Udgående';

  @override
  String get callAnswered => 'Besvaret';

  @override
  String get callRejectedByPeer => 'Afvist af den anden';

  @override
  String get callRejectedBySelf => 'Afvist';

  @override
  String get callPeerDidNotAnswer => 'Den anden besvarede ikke';

  @override
  String get callMissedIncoming => 'Ubesvaret indgående opkald';

  @override
  String get callPeerCancelled => 'Annulleret af den anden';

  @override
  String get notificationNewMessageTitle => 'Ny StartLink-besked';

  @override
  String get notificationOnlineServiceTitle => 'Ny kundeservicebesked';

  @override
  String get notificationNewMessageBody => 'Du har modtaget en ny besked';

  @override
  String get notificationImagePreview => 'Sendte et billede';

  @override
  String get notificationVideoPreview => 'Sendte en video';

  @override
  String get notificationVoicePreview => 'Sendte en talebesked';

  @override
  String get notificationFilePreview => 'Sendte en fil';

  @override
  String get notificationContactPreview => 'Sendte et kontaktkort';

  @override
  String get notificationCallLogPreview => 'Sendte en opkaldsregistrering';

  @override
  String get notificationLocationPreview => 'Delte en placering';

  @override
  String get notificationLinkPreview => 'Delte et link';

  @override
  String notificationMentionMe(String body) {
    return 'Omtalte dig: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender omtalte dig: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Omtalte alle: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender omtalte alle: $body';
  }

  @override
  String get notificationSecurityTitle => 'Kontosikkerhedsadvarsel';

  @override
  String get notificationSecurityBody =>
      'Sikkerhedsindstillingerne for din StartLink-konto er ændret. Kontrollér dem nu.';

  @override
  String get notificationFriendAcceptedTitle => 'Venneanmodning accepteret';

  @override
  String get notificationFriendRejectedTitle => 'Venneanmodning afvist';

  @override
  String get notificationFriendAcceptedBody =>
      'Den anden accepterede din venneanmodning';

  @override
  String get notificationFriendRejectedBody =>
      'Den anden afviste din venneanmodning';

  @override
  String get notificationVideoCallTitle => 'Invitation til videoopkald';

  @override
  String get notificationAudioCallTitle => 'Invitation til taleopkald';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller inviterede dig til et videoopkald';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller inviterede dig til et taleopkald';
  }

  @override
  String get notificationMessageChannelName => 'Beskeder';

  @override
  String get notificationMessageChannelDescription =>
      'Chatbeskeder, opkaldsregistreringer og systemadvarsler';

  @override
  String get notificationCallChannelName => 'Opkald';

  @override
  String get notificationCallChannelDescription =>
      'Advarsler om tale- og videoopkald';

  @override
  String get notificationSecurityChannelName => 'Kontosikkerhed';

  @override
  String get notificationSecurityChannelDescription =>
      'Advarsler om login, adgangskode- og mobilnummerændringer';

  @override
  String get notificationUnknownCaller => 'Ukendt opkalder';

  @override
  String get pendingJoinRequestsTitle => 'Nye ansøgninger';

  @override
  String get pendingJoinRequestsEmpty => 'Ingen ansøgninger';

  @override
  String get pendingJoinRequestApprove => 'Accepter';

  @override
  String get pendingJoinRequestReject => 'Afvis';

  @override
  String get pendingJoinRequestApproveSuccess => 'Godkendt';

  @override
  String get pendingJoinRequestRejectSuccess => 'Afvist';

  @override
  String get pendingJoinRequestFailed => 'Handlingen mislykkedes. Prøv igen.';

  @override
  String get myCustomersTitle => 'Mine kunder';

  @override
  String get myCustomersEmpty => 'Ingen kunder';

  @override
  String get groupListTitle => 'Grupper';

  @override
  String get groupListEmpty => 'Ingen grupper';

  @override
  String get addFriendTitle => 'Tilføj kontakt';

  @override
  String get addFriendSearchHint => 'Telefon / E-mail / StartLink-id';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink-id: $lppId';
  }

  @override
  String get addFriendButton => 'Tilføj';

  @override
  String get addFriendCannotAddSelf => 'Du kan ikke tilføje dig selv';

  @override
  String get addFriendUnsupportedUser =>
      'Denne bruger kan ikke tilføjes. Du kan skrive direkte.';

  @override
  String get addFriendMessageHint => 'Indtast en besked';

  @override
  String get addFriendSendRequest => 'Send anmodning';

  @override
  String get joinCompanyTitle => 'Deltag i virksomhed';

  @override
  String get joinCompanyCodeHint => 'Indtast virksomhedskode';

  @override
  String get joinCompanySearchHint => 'Søg virksomhedsnavn';

  @override
  String get joinCompanyApply => 'Ansøg om deltagelse';

  @override
  String get joinCompanyApplySuccess => 'Ansøgning indsendt';

  @override
  String get joinCompanyApplyFailed => 'Ansøgning mislykkedes. Prøv igen.';

  @override
  String get joinCompanyAutoApproved => 'Automatisk godkendt. Velkommen!';

  @override
  String get joinCompanyPending => 'Ansøgning indsendt, afventer godkendelse';

  @override
  String get joinCompanyInviteCodeHint => 'Indtast invitationskode';

  @override
  String get joinCompanyAcceptInvite => 'Acceptér invitation';

  @override
  String get joinCompanyNoResults => 'Ingen virksomheder fundet';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count medlemmer';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Stillehavstid';

  @override
  String get timezoneNameMountainTime => 'Bjergtid';

  @override
  String get timezoneNameCentralTime => 'Centraltid';

  @override
  String get timezoneNameEasternTime => 'Østlig tid';

  @override
  String get timezoneNameAtlanticTime => 'Atlantisk tid';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azorerne';

  @override
  String get timezoneNameLondonDublin => 'London/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Rom';

  @override
  String get timezoneNameCairoHelsinki => 'Kairo/Helsinki';

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
  String get timezoneNameKathmandu => 'Kathmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dhaka/Almaty';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoi/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Beijing/Shanghai/Hongkong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokyo/Seoul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Salomonøerne';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute => 'Vælg automatisk den bedste rute';

  @override
  String get networkTesting => 'Tester…';

  @override
  String get networkTestingShort => 'Tester';

  @override
  String networkLatencyMs(int ms) {
    return 'Forsinkelse $ms ms';
  }

  @override
  String get networkConnectionMode => 'Forbindelsestilstand';

  @override
  String get networkDirectMode => 'Direkte tilstand';

  @override
  String get networkProxyMode => 'Proxytilstand';

  @override
  String get networkDirectModeDesc => 'Forbind direkte til serveren';

  @override
  String get networkProxyModeDesc => 'Forbind via en proxyserver';

  @override
  String get networkDirectRoutes => 'Direkte ruter';

  @override
  String get networkProxyRoutes => 'Proxyruter';

  @override
  String get networkTestAll => 'Test alle';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Hongkong-node';

  @override
  String get networkSingaporeNode => 'Singapore-node';

  @override
  String get networkJapanNode => 'Japan-node';

  @override
  String get networkUnitedStatesNode => 'USA-node';

  @override
  String get networkHint =>
      'Tips:\n• Direkte tilstand: hurtigere og egnet til indenlandsk brug\n• Proxytilstand: mere stabil til kommunikation på tværs af grænser\n• Tryk på opdateringsikonet for at teste forsinkelsen for én rute';

  @override
  String get teenModeTitle => 'Teenagertilstand';

  @override
  String get teenModeStatusOn => 'Til';

  @override
  String get teenModeStatusOff => 'Fra';

  @override
  String get teenModeStatusLoading => 'Indlæser';

  @override
  String get teenModeUnavailable =>
      'Status for teenagertilstand er midlertidigt utilgængelig';

  @override
  String get teenModeInvalidResponse =>
      'Teenagertilstand returnerede et ugyldigt svar';

  @override
  String get teenModeEnableDescription =>
      'Platformens regler begrænser brugstid og udvalgte funktioner.';

  @override
  String get teenModePasscode => 'Adgangskode';

  @override
  String get teenModeCurrentPasscode => 'Nuværende adgangskode';

  @override
  String get teenModeNewPasscode => 'Ny adgangskode';

  @override
  String get teenModePasscodeHint => 'Indtast 4–6 cifre';

  @override
  String get teenModeEnable => 'Slå teenagertilstand til';

  @override
  String get teenModeDisable => 'Slå teenagertilstand fra';

  @override
  String get teenModeChangePasscode => 'Skift adgangskode';

  @override
  String get teenModeSource => 'Aktiveret af';

  @override
  String get teenModeDailyUsage => 'Brugt i dag';

  @override
  String get teenModeRemaining => 'Resterende tid';

  @override
  String get teenModeMinutesUnit => 'Minutter';

  @override
  String get teenModeUnlimited => 'Ubegrænset';

  @override
  String get teenModeRequestExtension => 'Anmod om mere tid';

  @override
  String get teenModeExtensionSubmitted =>
      'Tidsanmodningen blev sendt til en værge';

  @override
  String get teenModeTimeLimitReached => 'Dagens brugsgrænse er nået';

  @override
  String get teenModeCurfewActive => 'Brug er begrænset i denne periode';

  @override
  String get teenModeReliefHint =>
      'Du kan stadig se historik, kontakte officiel support og rapportere problemer.';

  @override
  String get teenModeRestrictedNotice =>
      'Teenagertilstand forhindrer i øjeblikket afsendelse af beskeder';

  @override
  String get teenModeActionBlocked =>
      'Teenagertilstand forhindrer i øjeblikket denne handling';

  @override
  String get teenModeMyRequests => 'Mine anmodninger';

  @override
  String get guardianCenterTitle => 'Værgecenter';

  @override
  String get guardianRelationships => 'Værgeforhold';

  @override
  String get guardianMinors => 'Børn under mit tilsyn';

  @override
  String get guardianApprovals => 'Afventende godkendelser';

  @override
  String get guardianBind => 'Indtast tilknytningskode';

  @override
  String get guardianCreateMinorCode => 'Jeg er barn — opret kode';

  @override
  String get guardianCreateGuardianCode => 'Jeg er værge — opret kode';

  @override
  String get guardianRelation => 'Relation';

  @override
  String get guardianPrimary => 'Primær værge';

  @override
  String get guardianCode => '6-cifret tilknytningskode';

  @override
  String get guardianCodeHint => 'Indtast koden fra den anden person';

  @override
  String get guardianCodeCreated => 'Kode oprettet. Del den, før den udløber.';

  @override
  String get guardianEmpty => 'Ingen værgeforhold';

  @override
  String get guardianNoMinors => 'Ingen børn under tilsyn';

  @override
  String get guardianUnbind => 'Fjern relation';

  @override
  String get guardianExtend => 'Tilføj tid til barnet';

  @override
  String get guardianPolicyTitle => 'Brugsregler';

  @override
  String get guardianPolicyLocked => 'Låst af platformen';

  @override
  String get approvalEmpty => 'Ingen anmodninger';

  @override
  String get approvalApprove => 'Accepter';

  @override
  String get approvalReject => 'Afvis';

  @override
  String get approvalPending => 'Afventer';

  @override
  String get approvalApproved => 'Godkendt';

  @override
  String get approvalRejected => 'Afvist';

  @override
  String get approvalExpired => 'Udløbet';

  @override
  String get approvalCancelled => 'Annulleret';

  @override
  String get approvalReplayFailed =>
      'Den oprindelige handling mislykkedes. Prøv igen.';

  @override
  String get requestCancelled => 'Anmodning annulleret';

  @override
  String get kycTitle => 'Identitetsverifikation';

  @override
  String get kycNotRequired => 'Identitetsbekræftelse kræves ikke';

  @override
  String get kycVerified => 'Identitet bekræftet';

  @override
  String get kycDeclared => 'Identitetsoplysninger indsendt';

  @override
  String get kycPending => 'Under gennemgang';

  @override
  String get kycRejected => 'Gennemgang afvist';

  @override
  String get kycNone => 'Ingen identitetsoplysninger indsendt';

  @override
  String get kycRealName => 'Fulde navn';

  @override
  String get kycIdNumber => 'ID-nummer';

  @override
  String get kycIdType => 'Dokumenttype';

  @override
  String get kycApplicability =>
      'Indtast dine rigtige oplysninger for det valgte dokument. Accepterede typer vises i listen.';

  @override
  String get kycCamera => 'Tag foto';

  @override
  String get kycGallery => 'Vælg fra album';

  @override
  String get kycPhotoLimit => 'Maksimum pr. foto';

  @override
  String get kycSelectPhoto => 'Vælg billede';

  @override
  String get kycPhotoSelected => 'Valgt';

  @override
  String get kycViewPhoto => 'Tryk for at se foto';

  @override
  String get kycReplacePhoto => 'Vælg et andet foto';

  @override
  String get kycDisclosure =>
      'Vi bruger dit navn, dokumentnummer og dokumentfotos til at kontrollere din identitet. Uden dem kan du ikke indsende, og visse begrænsede funktioner kan være utilgængelige.';

  @override
  String get kycConsent =>
      'Jeg giver særskilt samtykke til denne behandling af identitetsoplysninger';

  @override
  String get kycConsentRequired => 'Giv særskilt samtykke før indsendelse';

  @override
  String get kycResubmitTitle => 'Indsend identitetsoplysninger igen';

  @override
  String get kycResubmitWarning =>
      'Ny indsendelse erstatter din afventende ansøgning. Fortsæt?';

  @override
  String get kycSubmitting => 'Indsender';

  @override
  String get kycSubmitFailed => 'Indsendelse mislykkedes. Prøv igen.';

  @override
  String get kycSubmitUnavailable =>
      'Identitetsoplysninger kan ikke indsendes nu';

  @override
  String get kycResubmitNotAllowed =>
      'Ny indsendelse er ikke tilgængelig efter afvisning. Kontakt support om nødvendigt.';

  @override
  String get kycDailyLimit =>
      'Du har nået dagens indsendelsesgrænse. Prøv i morgen.';

  @override
  String get kycTypeUnavailable =>
      'Ingen dokumenttyper tilgængelige. Prøv igen senere.';

  @override
  String get kycNameInvalid => 'Juridisk navn skal være 2–64 tegn';

  @override
  String get kycNumberRequired => 'Indtast dokumentnummer';

  @override
  String get kycFrontRequired => 'Upload dokumentets forside';

  @override
  String get kycBackRequired => 'Upload dokumentets bagside';

  @override
  String get kycPhotoTooLarge =>
      'Fotoet overskrider størrelsesgrænsen. Komprimér det, og prøv igen.';

  @override
  String get kycAccountChanged => 'Konto eller rum er ændret. Åbn siden igen.';

  @override
  String get kycPhotoInvalid => 'Vælg et gyldigt billede';

  @override
  String get kycPortraitSide => 'Portrætside';

  @override
  String get kycEmblemSide => 'Emblemside';

  @override
  String get kycPassportDataPage => 'Passets dataside';

  @override
  String get kycPassportOtherPage => 'Passets visumside eller tomme side';

  @override
  String get kycFront => 'Forside af ID';

  @override
  String get kycBack => 'Bagside af ID';

  @override
  String get kycRequired =>
      'Identitetsbekræftelse kræves, før du opretter en gruppe';

  @override
  String get kycGoVerify => 'Bekræft nu';

  @override
  String get kycStatusUnknown =>
      'Identitetsstatus er utilgængelig. Opdatér senere.';

  @override
  String get kycSuperseded =>
      'En senere indsendelse erstattede denne. Kontrollér din seneste identitetsstatus.';

  @override
  String get kycMediaNotFound =>
      'Dokumentfotoet er utilgængeligt i dette rum. Vælg det igen før indsendelse.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Kundemassebesked';

  @override
  String get officialAccountBadge => 'Officiel';

  @override
  String get officialAccountOpenConversation => 'Åbn samtale';

  @override
  String get officialAccountJoinHint =>
      'Når du tilføjer denne konto, deltager du i virksomheden som kunde. Vennegodkendelse kræves ikke.';

  @override
  String get officialAccountJoinDisabled =>
      'Denne virksomhed accepterer ikke nye kunder. Kontakt support.';

  @override
  String get officialAccountRemoved =>
      'Du er fjernet fra virksomheden. Bed den om at invitere dig igen.';

  @override
  String get officialAccountBanned =>
      'Din konto er deaktiveret i denne virksomhed.';

  @override
  String get officialAccountUnavailable =>
      'Denne officielle konto er utilgængelig i øjeblikket.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Deltagelse i virksomhed er ikke tilladt i denne tilstand.';

  @override
  String get officialAccountPlatformRequired =>
      'Brug en platformskonto til at tilføje denne officielle konto.';

  @override
  String get officialAccountOpenFailed =>
      'Samtalen kunne ikke åbnes. Prøv igen.';

  @override
  String get officialAccountAccountChanged =>
      'Konto eller rum er ændret. Åbn igen.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Virksomhedsoversigten er ikke opdateret. Prøv om lidt.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Synkronisering af officiel konto mislykkedes. Lokalt indhold er stadig tilgængeligt.';

  @override
  String get officialAccountInboxSyncing =>
      'Synkroniserer officielle kontobeskeder';

  @override
  String get diagnosticsTitle => 'Diagnostik';

  @override
  String get diagnosticsExplanation =>
      'Loggene er anonymiserede og indeholder drifts- og fejloplysninger for denne konto og dette rum samt offentlige opstartshændelser. Chatindhold og loginoplysninger er udeladt.';

  @override
  String get diagnosticsHour => 'Seneste time';

  @override
  String get diagnosticsDay => 'Seneste 24 timer';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Tilgængelige hændelser: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Loggene gemmes på denne enhed og er tilgængelige efter genstart.';

  @override
  String get diagnosticsNotPersistent =>
      'Nogle logs er ikke gemt. Opdatér for at prøve igen.';

  @override
  String get diagnosticsExport => 'Eksportér og del';

  @override
  String get diagnosticsRefresh => 'Opdater';

  @override
  String get diagnosticsClear => 'Ryd dette rums logs';

  @override
  String get diagnosticsClearConfirm =>
      'Ryd diagnostiklogs for dette rum? Chathistorikken bevares.';

  @override
  String get diagnosticsShared =>
      'Systemdeling gennemført. Kontrollér filen i modtagerappen.';

  @override
  String get diagnosticsCancelled =>
      'Deling annulleret. Du kan eksportere igen.';

  @override
  String get diagnosticsUnconfirmed =>
      'Deling kunne ikke bekræftes. Kontrollér modtagerappen.';

  @override
  String get diagnosticsFailed => 'Handlingen mislykkedes. Prøv igen.';
}
