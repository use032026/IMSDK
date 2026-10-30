// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get navWorkbench => 'Arbeidsområde';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Kontodata kunne ikke lastes';

  @override
  String get startupFailureTitle => 'Oppstart mislyktes';

  @override
  String get startupFailureMessage => 'Kontroller nettverket og prøv igjen';

  @override
  String get privacyConsentTitle => 'Brukervilkår og personvernerklæring';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Velkommen til $brand. For å tilby kontoinnlogging, direktemeldinger, bedriftssamarbeid, kundeservice på nett, meldingsvarsler og sikkerhetsbeskyttelse må vi behandle nødvendige opplysninger i henhold til tjenestevilkårene og personvernerklæringen.\n\nFør du trykker på «Godta», leser vi ikke utklippstavlen, initialiserer ikke JPush/JCore eller enhetsprodusentenes push-SDK-er og bruker ikke disse SDK-ene til å få tilgang til Android ID, OAID, lister over installerte apper, MAC-adresser eller lignende informasjon. Hvis du avslår foreløpig, lagrer vi valget ditt; du kan fortsette å lese dokumentene og velge på nytt senere.\n\nEtter samtykket ditt kan JPush/JCore og enhetsprodusentenes push-tjenester behandle enhetsmodell, Android-versjon, app-pakke og -versjon, nettverkstype, IP-adresse, Android ID, OAID, push-registrerings-ID, produsentens push-token og opplysninger om levering og klikk på varsler for å levere meldings-, kundeservice- og anropsvarsler. Vi har deaktivert unødvendige funksjoner, inkludert smart push, lister over installerte apper, MAC, IMEI, IMSI, Wi-Fi-lister, automatisk vekking og koblet oppstart.\n\nUtklippstavlen åpnes bare når du aktivt kopierer eller limer inn. Kamera-, mikrofon-, varslings- og andre systemtillatelser forespørres bare når du aktivt bruker den aktuelle funksjonen. Avslag på én tillatelse påvirker bare den funksjonen. Les de fullstendige dokumentene nedenfor og velg om du godtar.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Velkommen til $brand. For å tilby kontoinnlogging, direktemeldinger, bedriftssamarbeid, kundeservice på nett, meldingsvarsler og sikkerhetsbeskyttelse må vi behandle nødvendige opplysninger i henhold til tjenestevilkårene og personvernerklæringen.\n\nFør du trykker på «Godta», leser vi ikke utklippstavlen, initialiserer ikke JPush/JCore, registrerer oss ikke hos Apple Push Notification service (APNs) og innhenter ikke push-identifikatorer som JPush-registrerings-ID eller APNs-enhetstoken. Hvis du avslår foreløpig, lagrer vi valget ditt; du kan fortsette å lese dokumentene og velge på nytt senere.\n\nEtter samtykket ditt kan vi behandle iPhone-modell, iOS-versjon, app-pakke og -versjon, nettverkstype, IP-adresse, IDFV, JPush-registrerings-ID, APNs-enhetstoken og opplysninger om levering og klikk på varsler for å levere meldings-, kundeservice- og anropsvarsler. JPush/JCore kobler til push-tjenesten; Apple APNs behandler app-identifikatoren, enhetstokenet og varslingsinnholdet for å levere systemvarsler. Den nåværende iOS-appen bruker ikke annonsetjenester og innhenter ikke IDFA.\n\nUtklippstavlen åpnes bare når du aktivt kopierer eller limer inn. Kamera-, mikrofon-, varslings- og andre systemtillatelser forespørres bare når du aktivt bruker den aktuelle funksjonen. Avslag på én tillatelse påvirker bare den funksjonen. Les de fullstendige dokumentene nedenfor og velg om du godtar.';
  }

  @override
  String get privacyConsentTermsLink => 'Brukervilkår';

  @override
  String get privacyConsentConjunction => 'og';

  @override
  String get privacyConsentPrivacyLink => 'Personvernerklæring';

  @override
  String get privacyConsentDecline => 'Uenig';

  @override
  String get privacyConsentDeclinedExit =>
      'Du godtok ikke tjenestevilkårene og personvernerklæringen. Appen lukkes nå.';

  @override
  String get privacyConsentAccept => 'Enig';

  @override
  String get privacyConsentRuntimeFailure =>
      'Oppstart mislyktes. Kontroller nettverket og prøv igjen.';

  @override
  String get privacyConsentSaveFailure =>
      'Valget ditt kunne ikke lagres. Prøv igjen.';

  @override
  String get appUpdateRequiredTitle => 'Oppdatering kreves for å fortsette';

  @override
  String get appUpdateOptionalTitle => 'Ny versjon tilgjengelig';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version er tilgjengelig';
  }

  @override
  String get appUpdateLater => 'Senere';

  @override
  String get appUpdateNow => 'Oppdater nå';

  @override
  String get appUpdateProcessing => 'Behandler…';

  @override
  String get appUpdateInvalidUrl =>
      'Oppdateringsadressen er ugyldig. Prøv igjen senere.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Oppdateringslenken kunne ikke åpnes. Prøv igjen senere.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Nedlasting avbrutt. Kontroller nettverket og prøv igjen.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Pakkekontrollen mislyktes. Last ned på nytt.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Tillat at $brand installerer oppdateringer i systeminnstillingene.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Systemets installasjonsprogram kunne ikke åpnes. Kontroller installasjonstillatelsene.';

  @override
  String get appUpdateGenericFailure =>
      'Oppdateringen mislyktes. Kontroller nettverket og prøv igjen.';

  @override
  String get appUpdateUnavailable =>
      'Den nye versjonen kan ikke lastes ned ennå. Prøv senere.';

  @override
  String get appUpdateCheckFailed =>
      'Kunne ikke se etter oppdateringer. Prøv igjen senere.';

  @override
  String get appUpdateChecking => 'Kontrollerer';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Avbryt';

  @override
  String get commonSave => 'Lagre';

  @override
  String get commonEdit => 'Rediger';

  @override
  String get commonDelete => 'Slett';

  @override
  String get commonSearch => 'Søk';

  @override
  String get commonLoading => 'Laster…';

  @override
  String get commonLoadFailed => 'Kunne ikke laste';

  @override
  String get commonRetry => 'Prøv igjen';

  @override
  String get commonEmpty => 'Ingen data';

  @override
  String get commonCopy => 'Kopier';

  @override
  String get commonForward => 'Videresend';

  @override
  String get commonFavorite => 'Lagre';

  @override
  String get commonClose => 'Lukk';

  @override
  String get commonSend => 'Send';

  @override
  String get commonDone => 'Ferdig';

  @override
  String get commonMore => 'Mer';

  @override
  String get commonSettings => 'Innstillinger';

  @override
  String get commonCopied => 'Kopiert';

  @override
  String get commonUnknown => 'Ukjent';

  @override
  String get commonNotSet => 'Ikke angitt';

  @override
  String get commonUnbound => 'Ikke tilknyttet';

  @override
  String get commonViewAll => 'Vis alle';

  @override
  String get commonSubmit => 'Send inn';

  @override
  String get commonAdd => 'Legg til';

  @override
  String get commonRemove => 'Fjern';

  @override
  String get commonCreate => 'Opprett';

  @override
  String get commonUpdate => 'Oppdater';

  @override
  String get commonUpload => 'Last opp';

  @override
  String get commonShare => 'Del';

  @override
  String get commonBlock => 'Blokker';

  @override
  String get commonUnblock => 'Opphev blokkering';

  @override
  String get commonMute => 'Demp';

  @override
  String get commonUnmute => 'Opphev demping';

  @override
  String get commonPin => 'Festet';

  @override
  String get commonUnpin => 'Løsne';

  @override
  String get commonMarkRead => 'Merk som lest';

  @override
  String get commonMarkUnread => 'Merk som ulest';

  @override
  String get commonOnline => 'Pålogget';

  @override
  String get commonOffline => 'Frakoblet';

  @override
  String get commonOperationFailed => 'Handlingen mislyktes. Prøv igjen.';

  @override
  String get commonNetworkError => 'Nettverksfeil. Kontroller forbindelsen.';

  @override
  String get navMessages => 'Meldinger';

  @override
  String get navContacts => 'Kontakter';

  @override
  String get navMe => 'Meg';

  @override
  String get authLoginTitle => 'Logg inn på StartLink';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'E-post';

  @override
  String get authTabLoginName => 'StartLink-ID';

  @override
  String get authHintMobile => 'Skriv inn telefonnummer';

  @override
  String get authHintEmail => 'Skriv inn e-postadressen din';

  @override
  String get authHintPassword => 'Skriv inn passord';

  @override
  String get authHintCode => 'Skriv inn bekreftelseskode';

  @override
  String get authHintLoginName => 'Skriv inn StartLink-ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Logg inn';

  @override
  String get authGetCode => 'Hent kode';

  @override
  String authResendCode(int seconds) {
    return 'Send på nytt om $seconds sek.';
  }

  @override
  String get authUsePassword => 'Bruk passord';

  @override
  String get authUseCode => 'Bruk bekreftelseskode';

  @override
  String get authAgreementPrefix => 'Jeg har lest og godtar';

  @override
  String get authAgreementAnd => 'og';

  @override
  String get authTermsLink => 'Brukervilkår';

  @override
  String get authPrivacyLink => 'Personvernerklæring';

  @override
  String get authCaptchaTitle => 'Sikkerhetskontroll';

  @override
  String get authCaptchaHint => 'Skriv inn svaret';

  @override
  String get authCaptchaFailed => 'Kunne ikke hente captcha. Prøv igjen.';

  @override
  String get authErrorEmptyCode => 'Skriv inn bekreftelseskoden';

  @override
  String get authErrorEmptyPassword => 'Skriv inn passord';

  @override
  String get authErrorEmptyLoginName => 'Skriv inn StartLink-ID-en din';

  @override
  String get authErrorWrongCredentials => 'Feil konto eller passord';

  @override
  String get authDeactivatingTitle => 'Sletting av konto';

  @override
  String get authDeactivatingContent =>
      'Kontoen din er i angreperioden for sletting (7 dager).\n\nTrykk på «Avbryt sletting» for å avbryte, eller trykk på «Fortsett» for å åpne appen.';

  @override
  String get authContinueUse => 'Fortsett';

  @override
  String get authCancelDeactivation => 'Avbryt sletting';

  @override
  String get authDeactivationCancelled =>
      'Sletting avbrutt, konto gjenopprettet';

  @override
  String get authDeactivationCancelFailed => 'Avbryting mislyktes. Prøv igjen.';

  @override
  String get authLogout => 'Logg ut';

  @override
  String get authLogoutConfirm => 'Er du sikker på at du vil logge ut?';

  @override
  String get authSendingCode => 'Sender…';

  @override
  String get authCodeSent => 'Verifiseringskode sendt';

  @override
  String get authLoginFailed => 'Innlogging mislyktes. Prøv igjen.';

  @override
  String get authRegisterFailed => 'Registrering mislyktes. Prøv igjen.';

  @override
  String get authEnterpriseCode => 'Bedriftskode';

  @override
  String get authEnterpriseCodeHint => 'Skriv inn bedriftskode';

  @override
  String get authPendingApproval =>
      'Registrering fullført. Forespørselen om å bli med i bedriften er sendt inn og venter på godkjenning.';

  @override
  String get authNoAccount => 'Har du ikke en konto?';

  @override
  String get authRegisterNow => 'Registrer nå';

  @override
  String get authCountryPickerTitle => 'Velg land/region';

  @override
  String get authCountrySearchHint => 'Søk etter land/region';

  @override
  String get authCountryChinaMainland => 'Fastlands-Kina';

  @override
  String get authCountryHongKong => 'Hongkong, Kina';

  @override
  String get authCountryMacau => 'Macao, Kina';

  @override
  String get authCountryTaiwan => 'Taiwan, Kina';

  @override
  String get authCountryUnitedStates => 'USA';

  @override
  String get authCountryUnitedKingdom => 'Storbritannia';

  @override
  String get authCountryJapan => 'Japan';

  @override
  String get authCountrySouthKorea => 'Sør-Korea';

  @override
  String get authCountrySingapore => 'Singapore';

  @override
  String get authCountryMalaysia => 'Malaysia';

  @override
  String get authCountryAustralia => 'Australia';

  @override
  String get authCountryCanada => 'Canada';

  @override
  String get authCountryGermany => 'Tyskland';

  @override
  String get authCountryFrance => 'Frankrike';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Thailand';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesia';

  @override
  String get authCountryPhilippines => 'Filippinene';

  @override
  String get authQuickLoginTitle => 'Hurtiginnlogging';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Logger inn. Vennligst vent.';

  @override
  String get authRoleOwner => 'Eier';

  @override
  String get authRoleAdministrator => 'Administrator';

  @override
  String get authRoleCustomerService => 'Kundeservice';

  @override
  String get authRoleTechnicalSupport => 'Teknisk støtte';

  @override
  String get authRoleEmployee => 'Ansatt';

  @override
  String get authRoleMember => 'Medlem';

  @override
  String get authRoleEnterpriseCustomer => 'Bedriftskunde';

  @override
  String get authUnavailablePrefix => 'Utilgjengelig ·';

  @override
  String get authUnassignedService => 'Ingen tildelt kundebehandler';

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
    return 'Ansatt · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count brukere';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Identitet';

  @override
  String get authRegisterTitle => 'Registrer deg';

  @override
  String get authNickname => 'Kallenavn';

  @override
  String get authNicknameHint => 'Angi et kallenavn';

  @override
  String get authPassword => 'Passord';

  @override
  String get authPasswordSetHint => 'Angi et passord (minst 6 tegn)';

  @override
  String get authConfirmPassword => 'Bekreft passord';

  @override
  String get authConfirmPasswordHint => 'Skriv inn passordet på nytt';

  @override
  String get authVerificationCode => 'Bekreftelseskode';

  @override
  String get authRegisterAndLogin => 'Registrer og logg inn';

  @override
  String get authHaveAccount => 'Har du allerede en konto?';

  @override
  String get authGoLogin => 'Logg inn';

  @override
  String get authEmailVerificationUnavailable =>
      'E-postbekreftelse er utilgjengelig. Registrer deg med et mobilnummer i stedet.';

  @override
  String get authSmsVerificationUnavailable =>
      'SMS-bekreftelse er utilgjengelig. Registrer deg med en e-postadresse i stedet.';

  @override
  String get authSendFailed => 'Kunne ikke sende. Prøv igjen.';

  @override
  String get authErrorEmptyNickname => 'Skriv inn et kallenavn';

  @override
  String get authErrorInvalidMobile => 'Skriv inn et gyldig mobilnummer';

  @override
  String get authErrorInvalidEmail => 'Skriv inn en gyldig e-postadresse';

  @override
  String get authErrorPasswordTooShort => 'Passordet må inneholde minst 6 tegn';

  @override
  String get authErrorPasswordMismatch => 'Passordene er ikke like';

  @override
  String get authErrorVerificationRequired =>
      'Hent og skriv inn bekreftelseskoden først';

  @override
  String get authRegisterErrorTitle => 'Registrering mislyktes';

  @override
  String get authGotIt => 'Forstått';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Bedriften «$code» ble ikke funnet. Kontroller bedriftskoden.';
  }

  @override
  String get authTenantSearchFailed => 'Søket mislyktes. Prøv igjen.';

  @override
  String get authInvitationInvalid =>
      'Invitasjonskoden er ugyldig. Kontroller den og prøv igjen.';

  @override
  String get authCollapseJoin => 'Skjul informasjon om medlemskap';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Gyldig invitasjon: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Bedrift funnet: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Velg organisasjon';

  @override
  String get authNoOrganization => 'Ingen organisasjoner tilgjengelige';

  @override
  String get authNoOrganizationHint =>
      'Be en administrator invitere deg til en organisasjon';

  @override
  String get authPersonalSpace => 'Personlig område';

  @override
  String get authPersonalSpaceSubtitle =>
      'Vennechatter og personlige favoritter';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Områdets identitet kunne ikke bekreftes. Prøv igjen.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Det personlige området kunne ikke gjenopprettes. Prøv igjen.';

  @override
  String get authJoinEnterpriseFailed =>
      'Kunne ikke bli med i bedriften. Prøv igjen senere.';

  @override
  String get homeTitle => 'Meldinger';

  @override
  String get homeGatewayConnectingTitle => 'Kobler til';

  @override
  String get homePersonalSpace => 'Personlig';

  @override
  String get homeOfficialService => 'Offisiell tjeneste';

  @override
  String get homeSwitchSpace => 'Bytt område';

  @override
  String get homeSpaceSubtitle => 'Personlig · Bedrift';

  @override
  String get homeJoinEnterprise => 'Bli med i bedrift';

  @override
  String get homeCreateGroup => 'Ny gruppe';

  @override
  String get homeAddFriend => 'Legg til kontakt';

  @override
  String get homeScan => 'Skann';

  @override
  String get homeJoinNewSpace => 'Bli med i nytt område';

  @override
  String get homeSearchConversation => 'Søk';

  @override
  String get homeNoMessages => 'Ingen meldinger';

  @override
  String get homeDeleteConversation => 'Slett chat';

  @override
  String get homeDeleteConversationConfirm =>
      'Slett denne chatten? Chatloggen tømmes.';

  @override
  String get homePersonalNote => 'Meg (personlige notater)';

  @override
  String get homeWorkNote => 'Meg (arbeidsnotater)';

  @override
  String homeConversationCount(int count) {
    return '$count chatter';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count uleste';
  }

  @override
  String get chatInputHint => 'Skriv en melding…';

  @override
  String get chatVoiceHint => 'Hold inne for å snakke';

  @override
  String get chatVoiceRelease => 'Slipp for å sende';

  @override
  String get chatVoiceCancel => 'Sveip opp for å avbryte';

  @override
  String get chatMenuCopy => 'Kopier';

  @override
  String get chatMenuForward => 'Videresend';

  @override
  String get chatMenuRecall => 'Trekk tilbake';

  @override
  String get chatMenuDelete => 'Slett';

  @override
  String get chatMenuFavorite => 'Lagre';

  @override
  String get chatMenuReply => 'Svar';

  @override
  String get chatMenuMultiSelect => 'Velg';

  @override
  String get chatMenuTranslate => 'Oversett';

  @override
  String get chatMenuVoiceToText => 'Konverter til tekst';

  @override
  String get chatMenuTextToSpeech => 'Les høyt';

  @override
  String get chatStatusRecalled => 'Melding trukket tilbake';

  @override
  String get chatRecallSuccess => 'Trukket tilbake';

  @override
  String get chatRecallFailed => 'Kunne ikke trekke tilbake';

  @override
  String get chatRecallTimeout =>
      'Meldinger eldre enn 2 minutter kan ikke trekkes tilbake';

  @override
  String get chatTranslateFailed => 'Oversettelse mislyktes. Prøv igjen.';

  @override
  String get chatTranslateNotConfigured =>
      'Oversettelsestjenesten er utilgjengelig';

  @override
  String get chatVoiceToTextFailed => 'Konvertering mislyktes. Prøv igjen.';

  @override
  String get chatTextToSpeechFailed => 'Opplesing mislyktes. Prøv igjen.';

  @override
  String get chatVoiceToText => 'Konverter';

  @override
  String get chatForwardSuccess => 'Videresendt';

  @override
  String get chatForwardFailed => 'Videresending mislyktes. Prøv igjen.';

  @override
  String get chatNoConversations => 'Ingen chatter å videresende til';

  @override
  String get chatSendFailed => 'Sending mislyktes';

  @override
  String get chatResend => 'Send kode på nytt';

  @override
  String get chatNotFriend => 'Ikke i kontaktlisten';

  @override
  String get chatNotFriendHint =>
      'Dere er ikke kontakter ennå. Meldinger kan ikke sendes.';

  @override
  String get chatMutedHint => 'Alle medlemmer er dempet';

  @override
  String get chatFileUploadFailed => 'Filopplasting mislyktes. Prøv igjen.';

  @override
  String get chatFileStatusNotDownloaded => 'Ikke lastet ned';

  @override
  String get chatFileStatusDownloaded => 'Lastet ned';

  @override
  String get chatFileStatusUploading => 'Laster opp';

  @override
  String get chatFileStatusUploadFailed => 'Opplasting feilet';

  @override
  String get chatCardSendFailed => 'Kunne ikke sende kontaktkort';

  @override
  String get chatFavoriteSuccess => 'Lagret';

  @override
  String get chatFavoriteFailed => 'Kunne ikke legge til i favoritter';

  @override
  String get chatLoadFailed => 'Kunne ikke laste';

  @override
  String get chatImageMessage => '[Bilde]';

  @override
  String get chatVoiceMessage => '[Talemelding]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Fil]';

  @override
  String get chatLocationMessage => '[Posisjon]';

  @override
  String get chatContactCardMessage => '[Kontakt]';

  @override
  String get chatCallLogMessage => '[Anrop]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Lest av $count';
  }

  @override
  String get chatUnread => 'Ulest';

  @override
  String get chatRecalledSelf => 'Du trakk tilbake en melding';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender trakk tilbake en melding';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Oversettelse: $translation';
  }

  @override
  String get chatMessageDeleted => 'Melding slettet';

  @override
  String get chatPeer => 'Den andre';

  @override
  String get chatSelf => 'Meg';

  @override
  String get chatGenericMessage => '[Melding]';

  @override
  String get chatVoiceHideText => 'Skjul tekst';

  @override
  String get chatVoiceShowText => 'Konverter til tekst';

  @override
  String get chatFileDefaultName => 'Fil';

  @override
  String get chatContactDefaultName => 'Kontakt';

  @override
  String get chatContactCardTitle => 'Kontaktkort';

  @override
  String get chatCallMissed => 'Tapt';

  @override
  String get chatCallCancelled => 'Avbrutt';

  @override
  String get chatCallRejected => 'Avvist';

  @override
  String get chatCallDisconnected => 'Frakoblet';

  @override
  String get chatCallEnded => 'Samtale avsluttet';

  @override
  String get chatCallFailed => 'Anrop mislyktes';

  @override
  String chatCallDuration(String duration) {
    return 'Varighet $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videosamtale';

  @override
  String get chatVoiceCallTitle => 'Talesamtale';

  @override
  String get chatToolPhotos => 'Bilder';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Fil';

  @override
  String get chatToolLocation => 'Lokasjon';

  @override
  String get chatToolContactCard => 'Kontakt';

  @override
  String get chatToolVoiceCall => 'Talesamtale';

  @override
  String get chatToolVideoCall => 'Videosamtale';

  @override
  String get chatToolFavorites => 'Favoritter';

  @override
  String get chatToolTranslate => 'Oversett';

  @override
  String get chatTranslationChooseLanguage => 'Velg oversettelsesspråk';

  @override
  String get chatTranslationEnterText => 'Skriv inn tekst først';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Oversettelse er utilgjengelig for meldinger med omtaler';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Oversettelse er utilgjengelig ved redigering av en planlagt melding';

  @override
  String get chatTranslationFailed => 'Oversettelsen mislyktes. Prøv igjen.';

  @override
  String get chatTranslationEmpty => 'Ingen oversettelse mottatt. Prøv igjen.';

  @override
  String get chatTranslationTranslating => 'Oversetter…';

  @override
  String get chatTranslationSend => 'Send oversettelse';

  @override
  String get chatTranslationSending => 'Sender…';

  @override
  String get chatTranslationExpand => 'Vis mer';

  @override
  String get chatTranslationCollapse => 'Vis mindre';

  @override
  String get chatFileTooLarge => 'Filen overskrider grensen på 100 MB';

  @override
  String get chatInputMutedAdminOnly =>
      'Bare eieren eller utvalgte medlemmer kan skrive.';

  @override
  String get chatImageUploadUnsupported =>
      'Bildeopplasting mislyktes. Serveren støtter det ikke ennå.';

  @override
  String get chatFavoriteLongPressHint =>
      'Hold inne en melding for å legge den til i favoritter';

  @override
  String chatSelectedCount(int count) {
    return '$count valgt';
  }

  @override
  String get chatLocationSheetTitle => 'Send posisjon';

  @override
  String get chatLocationNameLabel => 'Stedsnavn';

  @override
  String get chatLocationNameHint => 'F.eks. kontor, kundeadresse';

  @override
  String get chatLocationAddressLabel => 'Adresse';

  @override
  String get chatLocationOptionalHint => 'Valgfritt';

  @override
  String get chatLocationLatitudeLabel => 'Breddegrad';

  @override
  String get chatLocationLatitudeHint => '-90 til 90';

  @override
  String get chatLocationLongitudeLabel => 'Lengdegrad';

  @override
  String get chatLocationLongitudeHint => '-180 til 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Skriv inn $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label er utenfor området';
  }

  @override
  String get chatLocationDefaultTitle => 'Lokasjon';

  @override
  String get chatMutedFullNotice =>
      'Denne gruppen er dempet. Bare eieren eller utvalgte medlemmer kan skrive.';

  @override
  String get chatNotFriendSendBlocked =>
      'Dere er ikke lenger venner og kan ikke sende meldinger';

  @override
  String get chatPersonalNotesTitle => 'Personlige notater';

  @override
  String get chatWorkNotesTitle => 'Arbeidsnotater';

  @override
  String get chatPersonalNotesDescription =>
      'Lagre personlige tanker og viktig informasjon her\nSynkronisert mellom enheter og alltid tilgjengelig';

  @override
  String get chatWorkNotesDescription =>
      'Lagre arbeidsoppgaver og arbeidsmateriell her\nTeamområder holdes atskilt og sikre';

  @override
  String get chatNoMessages => 'Ingen meldinger';

  @override
  String chatReplyTo(String sender) {
    return 'Svar $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature kommer snart';
  }

  @override
  String get chatForwardSelectTitle => 'Velg chat';

  @override
  String get chatContactSelectTitle => 'Velg kontakt';

  @override
  String get chatNoContacts => 'Ingen kontakter';

  @override
  String get contactsTitle => 'Kontakter';

  @override
  String get contactsSearch => 'Søk etter kontakter';

  @override
  String get contactsNewFriends => 'Nye venner';

  @override
  String get contactsGroups => 'Grupper';

  @override
  String get contactsFavorites => 'Favoritter';

  @override
  String get contactsRecent => 'Nylige';

  @override
  String get contactsOrganization => 'Organisasjon';

  @override
  String get contactsAnnouncement => 'Kunngjøringer';

  @override
  String get contactsNewApplications => 'Nye søknader';

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
  String get contactsNoAdvisor => 'Ingen rådgiver tildelt ennå';

  @override
  String get contactsAdvisorLoading => 'Laster…';

  @override
  String get contactsNavigateFailed => 'Navigering mislyktes. Prøv igjen.';

  @override
  String get contactsEmpty => 'Ingen kontakter';

  @override
  String get contactsNoAnnouncement => 'Ingen kunngjøringer';

  @override
  String get contactsOfficialBadge => 'Offisiell';

  @override
  String get contactsCustomerBadge => 'Kunde';

  @override
  String get contactsEmptyCustomers => 'Ingen kunder';

  @override
  String get myTitle => 'Meg';

  @override
  String get myEnterpriseInfo => 'Bedriftsinformasjon';

  @override
  String get myEnterpriseManage => 'Bedriftsadministrasjon';

  @override
  String get myQrCode => 'QR-kode';

  @override
  String get myFavorites => 'Favoritter';

  @override
  String get myLanguage => 'Språk';

  @override
  String get myTimezone => 'Tidssone';

  @override
  String get myAutoTranslate => 'Automatisk oversettelse';

  @override
  String get myNetworkSwitch => 'Bytt linje';

  @override
  String get mySettings => 'Innstillinger';

  @override
  String get myLogout => 'Logg ut';

  @override
  String get myLogoutConfirm => 'Er du sikker på at du vil logge ut?';

  @override
  String get myLeaveEnterprise => 'Forlat bedrift';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Vil du forlate denne bedriften? Du mister tilgangen til bedriftens data.';

  @override
  String get myLeaveEnterpriseSuccess => 'Bedrift forlatt';

  @override
  String get myLeaveEnterpriseFailed => 'Kunne ikke forlate. Prøv igjen.';

  @override
  String get myLppIdCopied => 'StartLink-ID kopiert';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink-ID: $lppId';
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
  String get myPresenceStatusTitle => 'Angi tilstedeværelse';

  @override
  String get myPresenceOnline => 'Pålogget';

  @override
  String get myPresenceBusy => 'Opptatt';

  @override
  String get myPresenceAway => 'Borte';

  @override
  String get myPresenceInvisible => 'Usynlig';

  @override
  String get profileTitle => 'Min profil';

  @override
  String get profileName => 'Navn';

  @override
  String get profileGender => 'Kjønn';

  @override
  String get profileBirthday => 'Fødselsdag';

  @override
  String get profileRegion => 'Region';

  @override
  String get profileSignature => 'Profiltekst';

  @override
  String get profileSignatureHint => 'Fortell litt om deg selv';

  @override
  String get profileTapTapText => 'Lite vink';

  @override
  String get profileTapTapHint => 'Tekst ved lite vink (maks. 20 tegn)';

  @override
  String get profileAccountSection => 'Konto';

  @override
  String get profileBasicSection => 'Grunnleggende informasjon';

  @override
  String get profileLppId => 'StartLink-ID';

  @override
  String get profileLppIdNotSet => 'Ikke angitt';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Ikke tilknyttet';

  @override
  String get profileEmail => 'E-post';

  @override
  String get profileEmailUnbound => 'Ikke tilknyttet';

  @override
  String get profileQrCode => 'Min QR-kode';

  @override
  String get profileChangePassword => 'Endre passord';

  @override
  String get profileGenderMale => 'Mann';

  @override
  String get profileGenderFemale => 'Kvinne';

  @override
  String get profileGenderOther => 'Annet';

  @override
  String get profileGenderUnset => 'Ikke angitt';

  @override
  String get profileSaveFailed => 'Kunne ikke lagre. Prøv igjen.';

  @override
  String get profileLppIdTitle => 'StartLink-ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink-ID kan bare endres én gang. Velg med omhu.';

  @override
  String get profileLppIdChangeFailed =>
      'Endring mislyktes (StartLink-ID kan bare endres én gang)';

  @override
  String get profileChangePasswordOld => 'Nåværende passord';

  @override
  String get profileChangePasswordNew => 'Nytt passord';

  @override
  String get profileChangePasswordConfirm => 'Bekreft nytt passord';

  @override
  String get profileChangePasswordMismatch => 'Passordene er ikke like';

  @override
  String get profileChangePasswordSuccess =>
      'Passord endret. Logg inn på nytt.';

  @override
  String get profileChangePasswordFailed =>
      'Kunne ikke endre passordet. Prøv igjen.';

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get settingsSectionEnterprise => 'Bedrift';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsSectionGeneral => 'Generelt';

  @override
  String get settingsSectionFeatures => 'Funksjoner';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsEnterpriseInfo => 'Bedriftsinformasjon';

  @override
  String get settingsProfile => 'Min profil';

  @override
  String get settingsAccountSecurity => 'Kontosikkerhet';

  @override
  String get settingsNotification => 'Varsler';

  @override
  String get settingsDisplay => 'Visning';

  @override
  String get settingsFriendPrivacy => 'Personvern';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Chatlogg';

  @override
  String get settingsAbout => 'Om StartLink';

  @override
  String get settingsLanguage => 'Språk';

  @override
  String get settingsTimezone => 'Tidssone';

  @override
  String get settingsAutoTranslate => 'Automatisk oversettelse';

  @override
  String get settingsNetworkSwitch => 'Bytt linje';

  @override
  String get enterpriseInfoTitle => 'Bedriftsinformasjon';

  @override
  String get enterpriseName => 'Navn';

  @override
  String get enterpriseDescription => 'Beskrivelse';

  @override
  String get enterpriseUpdateSuccess => 'Oppdatert vellykket';

  @override
  String get enterpriseUpdateFailed => 'Oppdatering mislyktes. Prøv igjen.';

  @override
  String get enterpriseLeave => 'Forlat bedrift';

  @override
  String get enterpriseLeaveConfirm => 'Vil du forlate denne bedriften?';

  @override
  String get enterpriseLeaveSuccess => 'Bedrift forlatt';

  @override
  String get enterpriseLeaveFailed => 'Kunne ikke forlate. Prøv igjen.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Eieren kan ikke forlate direkte. Overfør eierskapet først.';

  @override
  String get enterpriseMemberCount => 'Medlemmer';

  @override
  String get enterpriseCreatedAt => 'Opprettet';

  @override
  String get enterpriseCode => 'Bedriftskode';

  @override
  String get enterpriseInviteMembers => 'Inviter medlemmer';

  @override
  String get enterpriseCopyInviteCode => 'Kopier invitasjonskode';

  @override
  String get enterpriseInviteCodeCopied => 'Invitasjonskode kopiert';

  @override
  String get groupCreateTitle => 'Ny gruppe';

  @override
  String get groupNameHint => 'Skriv inn gruppenavn';

  @override
  String get groupCreateSuccess => 'Gruppe opprettet';

  @override
  String get groupCreateFailed => 'Kunne ikke opprette gruppen';

  @override
  String get groupSettings => 'Gruppeinnstillinger';

  @override
  String get groupName => 'Gruppenavn';

  @override
  String get groupAvatar => 'Gruppebilde';

  @override
  String get groupAnnouncement => 'Kunngjøring';

  @override
  String get groupMembers => 'Medlemmer';

  @override
  String get groupAddMember => 'Legg til medlemmer';

  @override
  String get groupRemoveMember => 'Fjern medlem';

  @override
  String get groupRemoveMemberConfirm => 'Fjerne dette medlemmet?';

  @override
  String get groupSetAdmin => 'Gjør til administrator';

  @override
  String get groupRemoveAdmin => 'Fjern administratorrettigheter';

  @override
  String get groupTransferOwner => 'Overfør eierskap';

  @override
  String get groupTransferOwnerConfirm =>
      'Overføre gruppens eierskap til dette medlemmet?';

  @override
  String get groupTransferOwnerSuccess => 'Eierskap overført';

  @override
  String get groupTransferOwnerFailed => 'Overføring mislyktes. Prøv igjen.';

  @override
  String get groupLeave => 'Forlat gruppe';

  @override
  String get groupLeaveConfirm => 'Forlate denne gruppen?';

  @override
  String get groupLeaveSuccess => 'Gruppe forlatt';

  @override
  String get groupLeaveFailed => 'Kunne ikke forlate. Prøv igjen.';

  @override
  String get groupDissolve => 'Oppløs gruppe';

  @override
  String get groupDissolveConfirm =>
      'Oppløse denne gruppen? Alle medlemmer fjernes.';

  @override
  String get groupDissolveSuccess => 'Gruppe oppløst';

  @override
  String get groupDissolveFailed => 'Oppløsning mislyktes. Prøv igjen.';

  @override
  String get groupQrCode => 'Gruppens QR-kode';

  @override
  String get groupMuteAll => 'Demp alle';

  @override
  String get groupMuteAllOn => 'Aktiver demping av alle';

  @override
  String get groupMuteAllOff => 'Deaktiver demping av alle';

  @override
  String get groupAllowMemberInvite => 'Tillat medlemsinvitasjoner';

  @override
  String get groupAllowMemberModifyTitle =>
      'Tillat medlemmer å endre gruppenavnet';

  @override
  String get groupAllowMemberAtAll => 'Tillat medlemmer å omtale @Alle';

  @override
  String get groupAllowMemberViewMemberList =>
      'Tillat medlemmer å se medlemslisten';

  @override
  String get groupAllowQrCodeJoin => 'Tillat å bli med via QR-kode';

  @override
  String get groupRequireApproval => 'Krev godkjenning for å bli med';

  @override
  String get groupAllowMemberAddFriend =>
      'Tillat medlemmer å legge til hverandre';

  @override
  String get groupRoleOwner => 'Eier';

  @override
  String get groupRoleAdmin => 'Administrator';

  @override
  String get groupRoleMember => 'Medlem';

  @override
  String get groupNoMembers => 'Ingen medlemmer';

  @override
  String get groupNoAnnouncements => 'Ingen kunngjøringer';

  @override
  String get groupCreateAnnouncement => 'Publiser kunngjøring';

  @override
  String get groupEditAnnouncement => 'Rediger kunngjøring';

  @override
  String get groupDeleteAnnouncement => 'Slett kunngjøring';

  @override
  String get groupDeleteAnnouncementConfirm => 'Slette denne kunngjøringen?';

  @override
  String get groupAnnouncementTitle => 'Tittel';

  @override
  String get groupAnnouncementContent => 'Innhold';

  @override
  String get groupAnnouncementPin => 'Fest kunngjøring';

  @override
  String groupMemberCount(int count) {
    return '$count medlemmer';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count valgt';
  }

  @override
  String get groupJoinRequestApprove => 'Enig';

  @override
  String get groupJoinRequestReject => 'Avvis';

  @override
  String get groupJoinRequests => 'Forespørsler om medlemskap';

  @override
  String get groupNoJoinRequests => 'Ingen forespørsler om medlemskap';

  @override
  String get groupReadReceipts => 'Lesebekreftelser';

  @override
  String groupReadCount(int count) {
    return '$count lest';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count uleste';
  }

  @override
  String get friendAddTitle => 'Legg til kontakt';

  @override
  String get friendSearchHint => 'Telefon / E-post / StartLink-ID';

  @override
  String get friendRequestSent => 'Venneforespørsel sendt';

  @override
  String get friendRequestFailed => 'Sending mislyktes. Prøv igjen.';

  @override
  String get friendAlreadyFriend => 'Allerede kontakter';

  @override
  String get friendNewFriendsTitle => 'Nye venner';

  @override
  String get friendNoRequests => 'Ingen venneforespørsler';

  @override
  String get friendAccept => 'Godta';

  @override
  String get friendReject => 'Avvis';

  @override
  String get friendAccepted => 'Godtatt';

  @override
  String get friendRejected => 'Avvist';

  @override
  String get friendDeleteConfirm => 'Fjerne denne kontakten?';

  @override
  String get friendDeleteSuccess => 'Kontakt fjernet';

  @override
  String get friendDeleteFailed => 'Fjerning mislyktes. Prøv igjen.';

  @override
  String get friendRemarkName => 'Kallenavn';

  @override
  String get friendGroupName => 'Gruppe';

  @override
  String get friendSendMessage => 'Melding';

  @override
  String get friendMatchTypeLppId => 'Funnet via StartLink-ID';

  @override
  String get friendMatchTypeMobile => 'Funnet via telefon';

  @override
  String get friendMatchTypeEmail => 'Funnet via e-post';

  @override
  String get friendSearchEmpty => 'Ingen brukere funnet';

  @override
  String get friendAddMessage => 'Jeg vil gjerne legge deg til som kontakt';

  @override
  String get friendBlockConfirm => 'Blokkere denne brukeren?';

  @override
  String get friendUnblockConfirm => 'Oppheve blokkeringen av denne brukeren?';

  @override
  String get friendBlockSuccess => 'Blokkert';

  @override
  String get friendUnblockSuccess => 'Blokkering opphevet';

  @override
  String get profilePageTitle => 'Personopplysninger';

  @override
  String get profilePageSendMessage => 'Melding';

  @override
  String get profilePageAddFriend => 'Legg til venn';

  @override
  String get profilePageAlreadyFriend => 'Allerede venner';

  @override
  String get profilePageBlocked => 'Blokkert';

  @override
  String get profilePageBlock => 'Blokker';

  @override
  String get profilePageUnblock => 'Opphev blokkering';

  @override
  String get profilePageHidden => 'Denne brukeren har skjult profilen sin';

  @override
  String get profilePageFriendsOnly =>
      'Denne brukeren viser bare profilen til venner';

  @override
  String get profilePageLppId => 'StartLink-ID';

  @override
  String get profilePageRemarkName => 'Merknader';

  @override
  String get profilePageEditRemark => 'Rediger kallenavn';

  @override
  String get profilePageSaveRemarkSuccess => 'Kallenavn lagret';

  @override
  String get profilePageSaveRemarkFailed => 'Kunne ikke lagre. Prøv igjen.';

  @override
  String get searchTitle => 'Søk';

  @override
  String get searchHint => 'Søk via telefon, e-post eller StartLink-ID';

  @override
  String get searchNoResults => 'Ingen resultater funnet';

  @override
  String get searchMessages => 'Meldinger';

  @override
  String get searchUsers => 'Brukere';

  @override
  String get searchFailed => 'Søket mislyktes. Prøv igjen.';

  @override
  String get scanTitle => 'Skann';

  @override
  String get scanFailed => 'Gjenkjenning mislyktes. Prøv igjen.';

  @override
  String get scanInvalidQrCode => 'Ugyldig QR-kode';

  @override
  String get scanFlashOn => 'Slå på lommelykt';

  @override
  String get scanFlashOff => 'Slå av lommelykt';

  @override
  String get scanAlbum => 'Velg fra album';

  @override
  String get favoritesTitle => 'Favoritter';

  @override
  String get favoritesEmpty => 'Ingenting lagret ennå';

  @override
  String get favoritesAll => 'Alle';

  @override
  String get favoritesText => 'Tekst';

  @override
  String get favoritesImage => 'Bilder';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Tale';

  @override
  String get favoritesFile => 'Filer';

  @override
  String get favoritesOther => 'Annet';

  @override
  String get favoritesDeleteConfirm => 'Fjerne fra favoritter?';

  @override
  String get favoritesDeleteSuccess => 'Fjernet fra lagret';

  @override
  String get favoritesDeleteFailed => 'Fjerning mislyktes';

  @override
  String get favoritesOriginalRecalled => 'Melding trukket tilbake';

  @override
  String get favoritesViewOriginal => 'Vis original';

  @override
  String get favoritesSearchHint => 'Søk i favoritter';

  @override
  String get favoritesNoResults => 'Ingen samsvarende favoritter';

  @override
  String get noticeTitle => 'Kunngjøringer';

  @override
  String get noticeEmpty => 'Ingen kunngjøringer';

  @override
  String get noticeDetail => 'Kunngjøringsdetaljer';

  @override
  String get noticePublishedAt => 'Publisert';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Viktig';

  @override
  String get noticePriorityUrgent => 'Haster';

  @override
  String get organizationTitle => 'Organisasjon';

  @override
  String get organizationEmpty => 'Ingen avdelingsinformasjon';

  @override
  String get organizationMembers => 'Medlemmer';

  @override
  String get organizationDepartment => 'Avdeling';

  @override
  String get organizationPosition => 'Stilling';

  @override
  String get organizationLeader => 'Leder';

  @override
  String get qrCodeTitle => 'Min QR-kode';

  @override
  String get qrCodeSave => 'Lagre til album';

  @override
  String get qrCodeShare => 'Del';

  @override
  String get qrCodeSaveSuccess => 'Lagret i albumet';

  @override
  String get qrCodeSaveFailed => 'Kunne ikke lagre. Prøv igjen.';

  @override
  String get qrCodeRefresh => 'Oppdater QR-kode';

  @override
  String get qrCodeExpired => 'QR-koden er utløpt. Oppdater den.';

  @override
  String get qrCodeScanToAdd => 'Skann for å legge meg til som kontakt';

  @override
  String get spacePersonal => 'Personlig';

  @override
  String get spaceEnterprise => 'Bedrift';

  @override
  String get spaceJoinByCode => 'Bli med med bedriftskode';

  @override
  String get spaceJoinByInvite => 'Bli med med invitasjonskode';

  @override
  String get spaceEnterCode => 'Skriv inn bedriftskode';

  @override
  String get spaceEnterInviteCode => 'Skriv inn invitasjonskode';

  @override
  String get spaceSearchEnterprise => 'Søk etter bedrift';

  @override
  String get spaceJoinRequestSent =>
      'Forespørsel sendt inn, venter på godkjenning';

  @override
  String get spaceJoinRequestPending => 'Venter på godkjenning';

  @override
  String get spaceJoinRequestApproved => 'Forespørsel godkjent';

  @override
  String get spaceJoinRequestRejected => 'Forespørsel avvist';

  @override
  String get spaceAlreadyMember => 'Du er allerede medlem';

  @override
  String get spaceAutoApproved => 'Automatisk godkjent. Velkommen!';

  @override
  String get spacePendingApprovalHint =>
      'Registrering fullført. Forespørselen om å bli med er sendt inn.';

  @override
  String get spaceNoSpaces => 'Ingen områder';

  @override
  String get spaceInviteExpired => 'Invitasjonskoden er utløpt';

  @override
  String get spaceInviteTargetMismatch =>
      'Denne invitasjonskoden er ikke for kontoen din';

  @override
  String get spaceAcceptInviteSuccess => 'Du er nå med i bedriften';

  @override
  String get spaceAcceptInviteFailed => 'Kunne ikke bli med. Prøv igjen.';

  @override
  String get spaceTenantSelectTitle => 'Velg område';

  @override
  String get spaceTenantSelectHint => 'Velg et område å åpne';

  @override
  String get spaceEnterPersonal => 'Åpne personlig område';

  @override
  String get spaceEnterEnterprise => 'Åpne bedriftsområde';

  @override
  String get aboutTitle => 'Om StartLink';

  @override
  String get aboutVersion => 'Versjon';

  @override
  String get aboutTerms => 'Brukervilkår';

  @override
  String get aboutPrivacy => 'Personvernerklæring';

  @override
  String get aboutOpenSource => 'Åpen kildekode-lisenser';

  @override
  String get aboutCheckUpdate => 'Se etter oppdateringer';

  @override
  String get aboutLatestVersion => 'Du har den nyeste versjonen';

  @override
  String get aboutUpdateAvailable => 'Ny versjon tilgjengelig';

  @override
  String get aboutUpdateNow => 'Oppdater nå';

  @override
  String get aboutUpdateLater => 'Senere';

  @override
  String get notificationTitle => 'Varsler';

  @override
  String get notificationGlobalMute => 'Ikke forstyrr';

  @override
  String get notificationSound => 'Lyd';

  @override
  String get notificationVibration => 'Vibrasjon';

  @override
  String get notificationPreview => 'Forhåndsvisning av meldinger';

  @override
  String get notificationDndStart => 'Starttid for Ikke forstyrr';

  @override
  String get notificationDndEnd => 'Sluttid for Ikke forstyrr';

  @override
  String get blacklistTitle => 'Svartelistet';

  @override
  String get blacklistEmpty => 'Ingen blokkerte brukere';

  @override
  String get blacklistRemove => 'Opphev blokkering';

  @override
  String get blacklistRemoveConfirm =>
      'Oppheve blokkeringen av denne brukeren?';

  @override
  String get feedbackTitle => 'Tilbakemelding';

  @override
  String get feedbackTypeComplaint => 'Klage';

  @override
  String get feedbackTypeSuggestion => 'Forslag';

  @override
  String get feedbackTypeBug => 'Feilrapport';

  @override
  String get feedbackContent => 'Beskrivelse';

  @override
  String get feedbackContentHint =>
      'Beskriv problemet eller forslaget i detalj';

  @override
  String get feedbackContact => 'Kontakt (valgfritt)';

  @override
  String get feedbackSubmit => 'Send inn';

  @override
  String get feedbackSuccess => 'Tilbakemelding sendt. Takk!';

  @override
  String get feedbackFailed => 'Innsending mislyktes. Prøv igjen.';

  @override
  String get networkTitle => 'Bytt linje';

  @override
  String get networkAutoSelect => 'Automatisk';

  @override
  String get networkManual => 'Manuelt';

  @override
  String get timezoneTitle => 'Tidssone';

  @override
  String get timezoneAuto => 'Følg systemet';

  @override
  String get autoTranslateTitle => 'Automatisk oversettelse';

  @override
  String get autoTranslateEnabled => 'Aktiver automatisk oversettelse';

  @override
  String get autoTranslateLanguage => 'Målspråk';

  @override
  String get displayTitle => 'Visning';

  @override
  String get displayFontSize => 'Skriftstørrelse';

  @override
  String get displayChatBackground => 'Chatbakgrunn';

  @override
  String get displayDarkMode => 'Utseende';

  @override
  String get displayDarkModeSystem => 'Følg systemet';

  @override
  String get displayDarkModeSystemHint =>
      'Bytt automatisk etter systeminnstillingen';

  @override
  String get displayDarkModeOff => 'Lys';

  @override
  String get displayDarkModeOffHint => 'Bruk alltid lyst tema';

  @override
  String get displayDarkModeOn => 'Mørk';

  @override
  String get displayDarkModeOnHint => 'Bruk alltid mørkt tema';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Chatlogg';

  @override
  String get chatHistoryClear => 'Tøm all historikk';

  @override
  String get chatHistoryClearConfirm =>
      'Tømme all chatlogg? Dette kan ikke angres.';

  @override
  String get chatHistoryClearSuccess => 'Chatlogg tømt';

  @override
  String get accountSecurityTitle => 'Kontosikkerhet';

  @override
  String get accountSecurityChangePassword => 'Endre passord';

  @override
  String get accountSecurityChangeMobile => 'Endre telefonnummer';

  @override
  String get accountSecurityChangeEmail => 'Endre e-post';

  @override
  String get accountSecurityLoggedDevices => 'Innloggede enheter';

  @override
  String get accountSecurityDeactivate => 'Slett konto';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Alle data slettes permanent etter 7 dager. Slette kontoen?';

  @override
  String get loggedDevicesTitle => 'Innloggede enheter';

  @override
  String get loggedDevicesCurrent => 'Denne enheten';

  @override
  String get loggedDevicesRevoke => 'Logg ut';

  @override
  String get loggedDevicesRevokeConfirm => 'Logge ut fra denne enheten?';

  @override
  String get loggedDevicesRevokeSuccess => 'Logget ut fra enheten';

  @override
  String get loggedDevicesRevokeFailed => 'Mislyktes. Prøv igjen.';

  @override
  String get loggedDevicesLastActive => 'Sist aktiv';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Nett';

  @override
  String get loggedDevicesTypeDesktop => 'Datamaskin';

  @override
  String get loggedDevicesTypeUnknown => 'Ukjent enhet';

  @override
  String get privacySettingsTitle => 'Personvern';

  @override
  String get privacySearchableByMobile => 'Tillat søk via telefonnummer';

  @override
  String get privacySearchableByLppId => 'Tillat søk via StartLink-ID';

  @override
  String get privacyAllowFriendRequest => 'Tillat venneforespørsler';

  @override
  String get privacyProfileVisibility => 'Profilsynlighet';

  @override
  String get privacyEveryone => 'Alle';

  @override
  String get privacyFriendsOfFriends => 'Venners venner';

  @override
  String get privacyNobody => 'Ingen';

  @override
  String get privacyFriendsOnly => 'Bare venner';

  @override
  String get privacySaveSuccess => 'Innstillinger lagret';

  @override
  String get privacySaveFailed => 'Kunne ikke lagre. Prøv igjen.';

  @override
  String get fontSizeTitle => 'Skriftstørrelse';

  @override
  String get fontSizeSmall => 'Liten';

  @override
  String get fontSizeNormal => 'Normal';

  @override
  String get fontSizeLarge => 'Stor';

  @override
  String get fontSizeExtraLarge => 'Ekstra Stor';

  @override
  String get fontSizePreview => 'Forhåndsvisning';

  @override
  String get chatBackgroundTitle => 'Chatbakgrunn';

  @override
  String get chatBackgroundDefault => 'Standard';

  @override
  String get chatBackgroundCustom => 'Egendefinert';

  @override
  String get chatBackgroundReset => 'Tilbakestill standardinnstillinger';

  @override
  String get termsTitle => 'Brukervilkår';

  @override
  String get privacyPolicyTitle => 'Personvernerklæring';

  @override
  String get recentContactsTitle => 'Nylige';

  @override
  String get recentContactsEmpty => 'Ingen nylige kontakter';

  @override
  String get inviteFriendsTitle => 'Inviter venner';

  @override
  String get inviteFriendsCopyLink => 'Kopier invitasjonslenke';

  @override
  String get inviteFriendsLinkCopied => 'Invitasjonslenke kopiert';

  @override
  String get imageViewerTitle => 'Bilde';

  @override
  String get imageViewerSave => 'Lagre til album';

  @override
  String get imageViewerSaveSuccess => 'Lagret i albumet';

  @override
  String get imageViewerSaveFailed => 'Kunne ikke lagre. Prøv igjen.';

  @override
  String get customerServiceTitle => 'Kundeservicesenter';

  @override
  String get customerServiceQueue => 'I kø';

  @override
  String get customerServiceActive => 'Aktiv';

  @override
  String get customerServiceClaim => 'Godta';

  @override
  String get customerServiceTakeover => 'Overta';

  @override
  String get customerServiceClose => 'Avslutt tjeneste';

  @override
  String get customerServiceCloseConfirm => 'Avslutte denne kundesamtalen?';

  @override
  String get customerServiceNoQueue => 'Ingen samtaler i kø';

  @override
  String get customerServiceNoActive => 'Ingen aktive samtaler';

  @override
  String get customerServiceVisitor => 'Besøkende';

  @override
  String get customerServiceCustomer => 'Kunde';

  @override
  String get customerServiceAssignedTo => 'Tildelt til';

  @override
  String get customerServiceTransferConversation => 'Overfør chat';

  @override
  String get marketingToolbar => 'Markedsføringsverktøy';

  @override
  String get callIncoming => 'Innkommende anrop';

  @override
  String get callOutgoing => 'Utgående anrop';

  @override
  String get callAccept => 'Godta';

  @override
  String get callReject => 'Avvis';

  @override
  String get callHangup => 'Avslutt';

  @override
  String get callMissed => 'Tapt anrop';

  @override
  String get callDuration => 'Varighet';

  @override
  String get callAudio => 'Talesamtale';

  @override
  String get callGeneric => 'Anrop';

  @override
  String get callVideo => 'Videosamtale';

  @override
  String get callConnecting => 'Kobler til…';

  @override
  String get callRinging => 'Ringer…';

  @override
  String get callEnded => 'Samtale avsluttet';

  @override
  String get callFailed => 'Anrop mislyktes';

  @override
  String get callRejected => 'Anrop avvist';

  @override
  String get callTimeout => 'Ikke svar';

  @override
  String get callCancelled => 'Avbrutt';

  @override
  String get callUnknownPeer => 'Ukjent';

  @override
  String get callVideoInvitation => 'Invitasjon til videosamtale';

  @override
  String get callAudioInvitation => 'Invitasjon til talesamtale';

  @override
  String get callAnswerAudio => 'Svar med lyd';

  @override
  String get callAnswerVideo => 'Svar med video';

  @override
  String get callViewProfile => 'Vis profil';

  @override
  String get callOpeningCamera => 'Åpner kamera…';

  @override
  String get callWaitingRemoteVideo => 'Venter på den andres video…';

  @override
  String get callCameraOff => 'Kamera av';

  @override
  String get callCameraOn => 'Kamera på';

  @override
  String get callMicrophoneOff => 'Mikrofon av';

  @override
  String get callMicrophoneOn => 'Mikrofon på';

  @override
  String get callSpeakerOff => 'Høyttaler av';

  @override
  String get callSpeakerOn => 'Høyttaler på';

  @override
  String get callVideoPermissionFailure =>
      'Videosamtalen kunne ikke startes. Kontroller kamera- og mikrofontillatelsene og prøv igjen.';

  @override
  String get callAudioPermissionFailure =>
      'Talesamtalen kunne ikke startes. Kontroller mikrofontillatelsen og prøv igjen.';

  @override
  String get callIncompleteIncoming =>
      'Informasjonen om det innkommende anropet er ufullstendig, så det kan ikke besvares.';

  @override
  String get callInProgress => 'I samtale';

  @override
  String get callCalling => 'Ringer…';

  @override
  String callEndedMedia(String media) {
    return '$media avsluttet';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media ble avvist';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media ble ikke besvart';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media ble avbrutt';
  }

  @override
  String get callConnectionLost => 'Samtaleforbindelsen brutt';

  @override
  String get callAdminEnded => 'Samtalen avsluttet av administrator';

  @override
  String callFailedMedia(String media) {
    return '$media mislyktes';
  }

  @override
  String get callBusy => 'Den andre er opptatt';

  @override
  String callDurationValue(String duration) {
    return 'Samtalevarighet $duration';
  }

  @override
  String get callNotConnected => 'Ikke tilkoblet';

  @override
  String get callDialed => 'Utgående';

  @override
  String get callAnswered => 'Besvart';

  @override
  String get callRejectedByPeer => 'Avvist av den andre';

  @override
  String get callRejectedBySelf => 'Avvist';

  @override
  String get callPeerDidNotAnswer => 'Den andre svarte ikke';

  @override
  String get callMissedIncoming => 'Tapt innkommende anrop';

  @override
  String get callPeerCancelled => 'Avbrutt av den andre';

  @override
  String get notificationNewMessageTitle => 'Ny StartLink-melding';

  @override
  String get notificationOnlineServiceTitle => 'Ny kundeservicemelding';

  @override
  String get notificationNewMessageBody => 'Du har mottatt en ny melding';

  @override
  String get notificationImagePreview => 'Sendte et bilde';

  @override
  String get notificationVideoPreview => 'Sendte en video';

  @override
  String get notificationVoicePreview => 'Sendte en talemelding';

  @override
  String get notificationFilePreview => 'Sendte en fil';

  @override
  String get notificationContactPreview => 'Sendte et kontaktkort';

  @override
  String get notificationCallLogPreview => 'Sendte en anropslogg';

  @override
  String get notificationLocationPreview => 'Delte en posisjon';

  @override
  String get notificationLinkPreview => 'Delte en lenke';

  @override
  String notificationMentionMe(String body) {
    return 'Omtalte deg: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender omtalte deg: $body';
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
  String get notificationSecurityTitle => 'Varsel om kontosikkerhet';

  @override
  String get notificationSecurityBody =>
      'Sikkerhetsinnstillingene for StartLink-kontoen din er endret. Kontroller dem nå.';

  @override
  String get notificationFriendAcceptedTitle => 'Venneforespørsel godtatt';

  @override
  String get notificationFriendRejectedTitle => 'Venneforespørsel avvist';

  @override
  String get notificationFriendAcceptedBody =>
      'Den andre godtok venneforespørselen din';

  @override
  String get notificationFriendRejectedBody =>
      'Den andre avviste venneforespørselen din';

  @override
  String get notificationVideoCallTitle => 'Invitasjon til videosamtale';

  @override
  String get notificationAudioCallTitle => 'Invitasjon til talesamtale';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller inviterte deg til en videosamtale';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller inviterte deg til en talesamtale';
  }

  @override
  String get notificationMessageChannelName => 'Meldinger';

  @override
  String get notificationMessageChannelDescription =>
      'Chatmeldinger, anropslogger og systemvarsler';

  @override
  String get notificationCallChannelName => 'Anrop';

  @override
  String get notificationCallChannelDescription =>
      'Varsler om tale- og videosamtaler';

  @override
  String get notificationSecurityChannelName => 'Kontosikkerhet';

  @override
  String get notificationSecurityChannelDescription =>
      'Varsler om innlogging og endringer av passord eller mobilnummer';

  @override
  String get notificationUnknownCaller => 'Ukjent innringer';

  @override
  String get pendingJoinRequestsTitle => 'Nye søknader';

  @override
  String get pendingJoinRequestsEmpty => 'Ingen søknader';

  @override
  String get pendingJoinRequestApprove => 'Enig';

  @override
  String get pendingJoinRequestReject => 'Avvis';

  @override
  String get pendingJoinRequestApproveSuccess => 'Godkjent';

  @override
  String get pendingJoinRequestRejectSuccess => 'Avvist';

  @override
  String get pendingJoinRequestFailed => 'Handlingen mislyktes. Prøv igjen.';

  @override
  String get myCustomersTitle => 'Mine kunder';

  @override
  String get myCustomersEmpty => 'Ingen kunder';

  @override
  String get groupListTitle => 'Grupper';

  @override
  String get groupListEmpty => 'Ingen grupper';

  @override
  String get addFriendTitle => 'Legg til kontakt';

  @override
  String get addFriendSearchHint => 'Telefon / E-post / StartLink-ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink-ID: $lppId';
  }

  @override
  String get addFriendButton => 'Legg til';

  @override
  String get addFriendCannotAddSelf => 'Du kan ikke legge til deg selv';

  @override
  String get addFriendUnsupportedUser =>
      'Denne brukeren kan ikke legges til. Du kan sende melding direkte.';

  @override
  String get addFriendMessageHint => 'Skriv inn en melding';

  @override
  String get addFriendSendRequest => 'Send forespørsel';

  @override
  String get joinCompanyTitle => 'Bli med i bedrift';

  @override
  String get joinCompanyCodeHint => 'Skriv inn bedriftskode';

  @override
  String get joinCompanySearchHint => 'Søk etter bedriftsnavn';

  @override
  String get joinCompanyApply => 'Søk om medlemskap';

  @override
  String get joinCompanyApplySuccess => 'Søknad sendt inn';

  @override
  String get joinCompanyApplyFailed => 'Søknaden mislyktes. Prøv igjen.';

  @override
  String get joinCompanyAutoApproved => 'Automatisk godkjent. Velkommen!';

  @override
  String get joinCompanyPending => 'Søknad sendt inn, venter på godkjenning';

  @override
  String get joinCompanyInviteCodeHint => 'Skriv inn invitasjonskode';

  @override
  String get joinCompanyAcceptInvite => 'Godta invitasjon';

  @override
  String get joinCompanyNoResults => 'Ingen bedrifter funnet';

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
  String get timezoneNameMountainTime => 'Fjelltid';

  @override
  String get timezoneNameCentralTime => 'Sentraltid';

  @override
  String get timezoneNameEasternTime => 'Østkysttid';

  @override
  String get timezoneNameAtlanticTime => 'Atlantisk tid';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azorene';

  @override
  String get timezoneNameLondonDublin => 'London/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Roma';

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
      'Beijing/Shanghai/Hongkong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokyo/Seoul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Salomonøyene';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute => 'Velg den beste ruten automatisk';

  @override
  String get networkTesting => 'Tester…';

  @override
  String get networkTestingShort => 'Tester';

  @override
  String networkLatencyMs(int ms) {
    return 'Forsinkelse $ms ms';
  }

  @override
  String get networkConnectionMode => 'Tilkoblingsmodus';

  @override
  String get networkDirectMode => 'Direkte modus';

  @override
  String get networkProxyMode => 'Proxymodus';

  @override
  String get networkDirectModeDesc => 'Koble direkte til serveren';

  @override
  String get networkProxyModeDesc => 'Koble til via en proxyserver';

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
      'Tips:\n• Direkte modus: raskere og egnet for innenlands bruk\n• Proxymodus: mer stabil for kommunikasjon over landegrenser\n• Trykk på oppdateringsikonet for å teste forsinkelsen for én rute';

  @override
  String get teenModeTitle => 'Ungdomsmodus';

  @override
  String get teenModeStatusOn => 'På';

  @override
  String get teenModeStatusOff => 'Av';

  @override
  String get teenModeStatusLoading => 'Laster';

  @override
  String get teenModeUnavailable =>
      'Status for ungdomsmodus er midlertidig utilgjengelig';

  @override
  String get teenModeInvalidResponse =>
      'Ungdomsmodus returnerte et ugyldig svar';

  @override
  String get teenModeEnableDescription =>
      'Plattformens regler begrenser brukstid og utvalgte funksjoner.';

  @override
  String get teenModePasscode => 'Tilgangskode';

  @override
  String get teenModeCurrentPasscode => 'Nåværende tilgangskode';

  @override
  String get teenModeNewPasscode => 'Ny tilgangskode';

  @override
  String get teenModePasscodeHint => 'Skriv inn 4–6 sifre';

  @override
  String get teenModeEnable => 'Slå på ungdomsmodus';

  @override
  String get teenModeDisable => 'Slå av ungdomsmodus';

  @override
  String get teenModeChangePasscode => 'Endre tilgangskode';

  @override
  String get teenModeSource => 'Aktivert av';

  @override
  String get teenModeDailyUsage => 'Brukt i dag';

  @override
  String get teenModeRemaining => 'Gjenstående tid';

  @override
  String get teenModeMinutesUnit => 'Minutter';

  @override
  String get teenModeUnlimited => 'Ubegrenset';

  @override
  String get teenModeRequestExtension => 'Be om mer tid';

  @override
  String get teenModeExtensionSubmitted =>
      'Tidsforespørselen ble sendt til en foresatt';

  @override
  String get teenModeTimeLimitReached => 'Dagens bruksgrense er nådd';

  @override
  String get teenModeCurfewActive => 'Bruk er begrenset i denne perioden';

  @override
  String get teenModeReliefHint =>
      'Du kan fortsatt se historikk, kontakte offisiell støtte og rapportere problemer.';

  @override
  String get teenModeRestrictedNotice =>
      'Ungdomsmodus hindrer sending av meldinger akkurat nå';

  @override
  String get teenModeActionBlocked =>
      'Ungdomsmodus hindrer denne handlingen akkurat nå';

  @override
  String get teenModeMyRequests => 'Mine forespørsler';

  @override
  String get guardianCenterTitle => 'Foresattsenter';

  @override
  String get guardianRelationships => 'Foresattforhold';

  @override
  String get guardianMinors => 'Barn under mitt tilsyn';

  @override
  String get guardianApprovals => 'Ventende godkjenninger';

  @override
  String get guardianBind => 'Skriv inn tilknytningskode';

  @override
  String get guardianCreateMinorCode => 'Jeg er barn — opprett kode';

  @override
  String get guardianCreateGuardianCode => 'Jeg er foresatt — opprett kode';

  @override
  String get guardianRelation => 'Relasjon';

  @override
  String get guardianPrimary => 'Primær foresatt';

  @override
  String get guardianCode => '6-sifret tilknytningskode';

  @override
  String get guardianCodeHint => 'Skriv inn koden fra den andre personen';

  @override
  String get guardianCodeCreated => 'Kode opprettet. Del den før den utløper.';

  @override
  String get guardianEmpty => 'Ingen foresattforhold';

  @override
  String get guardianNoMinors => 'Ingen barn under tilsyn';

  @override
  String get guardianUnbind => 'Fjern relasjon';

  @override
  String get guardianExtend => 'Legg til tid for barnet';

  @override
  String get guardianPolicyTitle => 'Bruksregler';

  @override
  String get guardianPolicyLocked => 'Låst av plattformen';

  @override
  String get approvalEmpty => 'Ingen forespørsler';

  @override
  String get approvalApprove => 'Enig';

  @override
  String get approvalReject => 'Avvis';

  @override
  String get approvalPending => 'Venter';

  @override
  String get approvalApproved => 'Godkjent';

  @override
  String get approvalRejected => 'Avvist';

  @override
  String get approvalExpired => 'Utløpt';

  @override
  String get approvalCancelled => 'Kansellert';

  @override
  String get approvalReplayFailed =>
      'Den opprinnelige handlingen mislyktes. Prøv igjen.';

  @override
  String get requestCancelled => 'Forespørsel avbrutt';

  @override
  String get kycTitle => 'Identitetsbekreftelse';

  @override
  String get kycNotRequired => 'Identitetsbekreftelse kreves ikke';

  @override
  String get kycVerified => 'Identitet bekreftet';

  @override
  String get kycDeclared => 'Identitetsopplysninger sendt inn';

  @override
  String get kycPending => 'Under vurdering';

  @override
  String get kycRejected => 'Vurdering avvist';

  @override
  String get kycNone => 'Ingen identitetsopplysninger sendt inn';

  @override
  String get kycRealName => 'Fullt navn';

  @override
  String get kycIdNumber => 'ID-nummer';

  @override
  String get kycIdType => 'Dokumenttype';

  @override
  String get kycApplicability =>
      'Skriv inn de virkelige opplysningene dine for det valgte dokumentet. Godtatte typer vises i listen.';

  @override
  String get kycCamera => 'Ta bilde';

  @override
  String get kycGallery => 'Velg fra album';

  @override
  String get kycPhotoLimit => 'Maksimum per bilde';

  @override
  String get kycSelectPhoto => 'Velg bilde';

  @override
  String get kycPhotoSelected => 'Valgt';

  @override
  String get kycViewPhoto => 'Trykk for å se bilde';

  @override
  String get kycReplacePhoto => 'Velg et annet bilde';

  @override
  String get kycDisclosure =>
      'Vi bruker navnet ditt, dokumentnummeret og dokumentbildene til å kontrollere identiteten din. Uten dem kan du ikke sende inn, og enkelte begrensede funksjoner kan være utilgjengelige.';

  @override
  String get kycConsent =>
      'Jeg gir særskilt samtykke til denne behandlingen av identitetsopplysninger';

  @override
  String get kycConsentRequired => 'Gi særskilt samtykke før innsending';

  @override
  String get kycResubmitTitle => 'Send inn identitetsopplysninger på nytt';

  @override
  String get kycResubmitWarning =>
      'Ny innsending erstatter den ventende søknaden din. Fortsette?';

  @override
  String get kycSubmitting => 'Sender inn';

  @override
  String get kycSubmitFailed => 'Innsending mislyktes. Prøv igjen.';

  @override
  String get kycSubmitUnavailable =>
      'Identitetsopplysninger kan ikke sendes inn nå';

  @override
  String get kycResubmitNotAllowed =>
      'Ny innsending er utilgjengelig etter avvisning. Kontakt støtte ved behov.';

  @override
  String get kycDailyLimit =>
      'Du har nådd dagens innsendingsgrense. Prøv i morgen.';

  @override
  String get kycTypeUnavailable =>
      'Ingen dokumenttyper tilgjengelige. Prøv igjen senere.';

  @override
  String get kycNameInvalid => 'Juridisk navn må være 2–64 tegn';

  @override
  String get kycNumberRequired => 'Skriv inn dokumentnummer';

  @override
  String get kycFrontRequired => 'Last opp dokumentets forside';

  @override
  String get kycBackRequired => 'Last opp dokumentets bakside';

  @override
  String get kycPhotoTooLarge =>
      'Bildet overskrider størrelsesgrensen. Komprimer det og prøv igjen.';

  @override
  String get kycAccountChanged =>
      'Kontoen eller området er endret. Åpne siden på nytt.';

  @override
  String get kycPhotoInvalid => 'Velg et gyldig bilde';

  @override
  String get kycPortraitSide => 'Portrettside';

  @override
  String get kycEmblemSide => 'Emblemside';

  @override
  String get kycPassportDataPage => 'Passets dataside';

  @override
  String get kycPassportOtherPage => 'Passets visumside eller tomme side';

  @override
  String get kycFront => 'Forsiden av ID-kortet';

  @override
  String get kycBack => 'Baksiden av ID-kortet';

  @override
  String get kycRequired =>
      'Identitetsbekreftelse kreves før du oppretter en gruppe';

  @override
  String get kycGoVerify => 'Bekreft nå';

  @override
  String get kycStatusUnknown =>
      'Identitetsstatus er utilgjengelig. Oppdater senere.';

  @override
  String get kycSuperseded =>
      'En senere innsending erstattet denne. Kontroller den nyeste identitetsstatusen din.';

  @override
  String get kycMediaNotFound =>
      'Dokumentbildet er utilgjengelig i dette området. Velg det på nytt før innsending.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Kundemassemelding';

  @override
  String get officialAccountBadge => 'Offisiell';

  @override
  String get officialAccountOpenConversation => 'Åpne samtale';

  @override
  String get officialAccountJoinHint =>
      'Når du legger til denne kontoen, blir du med i bedriften som kunde. Vennegodkjenning kreves ikke.';

  @override
  String get officialAccountJoinDisabled =>
      'Denne bedriften tar ikke imot nye kunder. Kontakt støtte.';

  @override
  String get officialAccountRemoved =>
      'Du er fjernet fra bedriften. Be den invitere deg på nytt.';

  @override
  String get officialAccountBanned =>
      'Kontoen din er deaktivert i denne bedriften.';

  @override
  String get officialAccountUnavailable =>
      'Denne offisielle kontoen er utilgjengelig akkurat nå.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Det er ikke tillatt å bli med i en bedrift i denne modusen.';

  @override
  String get officialAccountPlatformRequired =>
      'Bruk en plattformkonto for å legge til denne offisielle kontoen.';

  @override
  String get officialAccountOpenFailed =>
      'Samtalen kunne ikke åpnes. Prøv igjen.';

  @override
  String get officialAccountAccountChanged =>
      'Kontoen eller området er endret. Åpne på nytt.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Bedriftskatalogen er ikke oppdatert. Prøv om litt.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Synkronisering av offisiell konto mislyktes. Lokalt innhold er fortsatt tilgjengelig.';

  @override
  String get officialAccountInboxSyncing =>
      'Synkroniserer meldinger fra offisiell konto';

  @override
  String get diagnosticsTitle => 'Diagnostikk';

  @override
  String get diagnosticsExplanation =>
      'Loggene er sladdet og inneholder drifts- og feilinformasjon for denne kontoen og dette området, samt offentlige oppstartshendelser. Chatinnhold og påloggingsopplysninger er utelatt.';

  @override
  String get diagnosticsHour => 'Siste time';

  @override
  String get diagnosticsDay => 'Siste 24 timer';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Tilgjengelige hendelser: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Loggene lagres på denne enheten og er tilgjengelige etter omstart.';

  @override
  String get diagnosticsNotPersistent =>
      'Noen logger er ikke lagret. Oppdater for å prøve igjen.';

  @override
  String get diagnosticsExport => 'Eksporter og del';

  @override
  String get diagnosticsRefresh => 'Oppdater';

  @override
  String get diagnosticsClear => 'Tøm loggene for dette området';

  @override
  String get diagnosticsClearConfirm =>
      'Tømme diagnostikkloggene for dette området? Chatloggen beholdes.';

  @override
  String get diagnosticsShared =>
      'Systemdeling fullført. Kontroller filen i mottakerappen.';

  @override
  String get diagnosticsCancelled =>
      'Deling avbrutt. Du kan eksportere på nytt.';

  @override
  String get diagnosticsUnconfirmed =>
      'Deling kunne ikke bekreftes. Kontroller mottakerappen.';

  @override
  String get diagnosticsFailed => 'Handlingen mislyktes. Prøv igjen.';
}
