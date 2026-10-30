// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get navWorkbench => 'Radni prostor';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Podaci računa nisu učitani';

  @override
  String get startupFailureTitle => 'Pokretanje nije uspjelo';

  @override
  String get startupFailureMessage => 'Provjerite mrežu i pokušajte ponovno';

  @override
  String get privacyConsentTitle => 'Uvjeti korištenja i Politika privatnosti';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Dobro došli u $brand. Za prijavu na račun, razmjenu izravnih poruka, poslovnu suradnju, mrežnu korisničku podršku, obavijesti o porukama i sigurnosnu zaštitu trebamo obrađivati nužne podatke u skladu s Uvjetima korištenja i Pravilima privatnosti.\n\nPrije nego što dodirnete Prihvaćam, nećemo čitati međuspremnik, pokretati JPush/JCore ni SDK-ove za obavijesti proizvođača uređaja niti njima pristupati Android ID-u, OAID-u, popisima instaliranih aplikacija, MAC adresama ili sličnim podacima. Ako zasad odbijete, spremit ćemo vaš izbor; dokumente možete nastaviti čitati i odlučiti kasnije.\n\nNakon prihvaćanja, radi dostave obavijesti o porukama, korisničkoj podršci i dolaznim pozivima, JPush/JCore i usluge obavijesti proizvođača uređaja mogu obrađivati model uređaja, verziju Androida, naziv paketa i verziju aplikacije, vrstu mreže, IP adresu, Android ID, OAID, Registration ID za obavijesti, token proizvođača te podatke o dostavi i otvaranju obavijesti. Isključili smo neobvezne mogućnosti, uključujući pametne obavijesti, popise instaliranih aplikacija, MAC, IMEI, IMSI, popise Wi-Fi mreža, automatsko buđenje i povezano pokretanje.\n\nMeđuspremniku pristupamo samo kada sami koristite kopiranje ili lijepljenje. Dopuštenja za kameru, mikrofon, obavijesti i druge sustavne funkcije tražimo samo kada koristite odgovarajuću funkciju. Odbijanje pojedinog dopuštenja utječe samo na tu funkciju. Pročitajte potpune dokumente u nastavku i sami odlučite prihvaćate li ih.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Dobro došli u $brand. Za prijavu na račun, razmjenu izravnih poruka, poslovnu suradnju, mrežnu korisničku podršku, obavijesti o porukama i sigurnosnu zaštitu trebamo obrađivati nužne podatke u skladu s Uvjetima korištenja i Pravilima privatnosti.\n\nPrije nego što dodirnete Prihvaćam, nećemo čitati međuspremnik, pokretati JPush/JCore, registrirati se u Appleovoj usluzi obavijesti (APNs) niti pribavljati identifikatore obavijesti kao što su JPush Registration ID ili APNs token uređaja. Ako zasad odbijete, spremit ćemo vaš izbor; dokumente možete nastaviti čitati i odlučiti kasnije.\n\nNakon prihvaćanja, radi dostave obavijesti o porukama, korisničkoj podršci i dolaznim pozivima možemo obrađivati model iPhonea, verziju iOS-a, naziv paketa i verziju aplikacije, vrstu mreže, IP adresu, IDFV, JPush Registration ID, APNs token uređaja te podatke o dostavi i otvaranju obavijesti. JPush/JCore povezuje se s uslugom obavijesti; Apple APNs obrađuje identifikator aplikacije, token uređaja i sadržaj obavijesti radi sustavne dostave. Trenutačna aplikacija za iOS ne koristi oglasne usluge i ne pribavlja IDFA.\n\nMeđuspremniku pristupamo samo kada sami koristite kopiranje ili lijepljenje. Dopuštenja za kameru, mikrofon, obavijesti i druge sustavne funkcije tražimo samo kada koristite odgovarajuću funkciju. Odbijanje pojedinog dopuštenja utječe samo na tu funkciju. Pročitajte potpune dokumente u nastavku i sami odlučite prihvaćate li ih.';
  }

  @override
  String get privacyConsentTermsLink => 'Korisnički ugovor';

  @override
  String get privacyConsentConjunction => 'i';

  @override
  String get privacyConsentPrivacyLink => 'Politika privatnosti';

  @override
  String get privacyConsentDecline => 'Odbijam';

  @override
  String get privacyConsentDeclinedExit =>
      'Niste prihvatili Uvjete korištenja i Pravila privatnosti. Aplikacija će se zatvoriti.';

  @override
  String get privacyConsentAccept => 'Prihvaćam';

  @override
  String get privacyConsentRuntimeFailure =>
      'Pokretanje nije uspjelo. Provjerite mrežu i pokušajte ponovno.';

  @override
  String get privacyConsentSaveFailure =>
      'Vaš izbor nije spremljen. Pokušajte ponovno.';

  @override
  String get appUpdateRequiredTitle => 'Za nastavak je potrebno ažuriranje';

  @override
  String get appUpdateOptionalTitle => 'Dostupna je nova verzija';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Dostupna je verzija $brand $version';
  }

  @override
  String get appUpdateLater => 'Kasnije';

  @override
  String get appUpdateNow => 'Ažurirajte sada';

  @override
  String get appUpdateProcessing => 'Obrada...';

  @override
  String get appUpdateInvalidUrl =>
      'Adresa za ažuriranje nije valjana. Pokušajte kasnije.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Poveznica za ažuriranje nije otvorena. Pokušajte kasnije.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Preuzimanje je prekinuto. Provjerite mrežu i pokušajte ponovno.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Provjera instalacijskog paketa nije uspjela. Preuzmite ga ponovno.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'U postavkama sustava dopustite aplikaciji $brand instaliranje ažuriranja.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Instalacijski program sustava nije otvoren. Provjerite dopuštenja za instalaciju.';

  @override
  String get appUpdateGenericFailure =>
      'Ažuriranje nije uspjelo. Provjerite mrežu i pokušajte ponovno.';

  @override
  String get appUpdateUnavailable =>
      'Nova verzija još nije dostupna za preuzimanje. Pokušajte kasnije.';

  @override
  String get appUpdateCheckFailed =>
      'Provjera ažuriranja nije uspjela. Pokušajte kasnije.';

  @override
  String get appUpdateChecking => 'Provjera';

  @override
  String get commonConfirm => 'U redu';

  @override
  String get commonCancel => 'Odustani';

  @override
  String get commonSave => 'Spremi';

  @override
  String get commonEdit => 'Uredi';

  @override
  String get commonDelete => 'Izbriši';

  @override
  String get commonSearch => 'Pretraži';

  @override
  String get commonLoading => 'Učitavanje...';

  @override
  String get commonLoadFailed => 'Učitavanje nije uspjelo';

  @override
  String get commonRetry => 'Ponovi';

  @override
  String get commonEmpty => 'Nema podataka';

  @override
  String get commonCopy => 'Kopiraj';

  @override
  String get commonForward => 'Proslijedi';

  @override
  String get commonFavorite => 'Spremi';

  @override
  String get commonClose => 'Zatvori';

  @override
  String get commonSend => 'Pošalji';

  @override
  String get commonDone => 'Gotovo';

  @override
  String get commonMore => 'Više';

  @override
  String get commonSettings => 'Postavke';

  @override
  String get commonCopied => 'Kopirano';

  @override
  String get commonUnknown => 'Nepoznato';

  @override
  String get commonNotSet => 'Nije postavljeno';

  @override
  String get commonUnbound => 'Nije povezano';

  @override
  String get commonViewAll => 'Prikaži sve';

  @override
  String get commonSubmit => 'Pošalji';

  @override
  String get commonAdd => 'Dodaj';

  @override
  String get commonRemove => 'Ukloni';

  @override
  String get commonCreate => 'Stvori';

  @override
  String get commonUpdate => 'Ažuriraj';

  @override
  String get commonUpload => 'Prenesi';

  @override
  String get commonShare => 'Podijeli';

  @override
  String get commonBlock => 'Blokiraj';

  @override
  String get commonUnblock => 'Deblokiraj';

  @override
  String get commonMute => 'Utišaj';

  @override
  String get commonUnmute => 'Uključi obavijesti';

  @override
  String get commonPin => 'Prikvačeno';

  @override
  String get commonUnpin => 'Otkvači';

  @override
  String get commonMarkRead => 'Označi kao pročitano';

  @override
  String get commonMarkUnread => 'Označi kao nepročitano';

  @override
  String get commonOnline => 'Na mreži';

  @override
  String get commonOffline => 'Izvan mreže';

  @override
  String get commonOperationFailed => 'Radnja nije uspjela. Pokušajte ponovno.';

  @override
  String get commonNetworkError => 'Mrežna pogreška. Provjerite vezu.';

  @override
  String get navMessages => 'Poruke';

  @override
  String get navContacts => 'Kontakti';

  @override
  String get navMe => 'Ja';

  @override
  String get authLoginTitle => 'Prijavite se u StartLink';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'E-pošta';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Unesite telefonski broj';

  @override
  String get authHintEmail => 'Unesite svoju e-mail adresu';

  @override
  String get authHintPassword => 'Unesite lozinku';

  @override
  String get authHintCode => 'Unesite kod za potvrdu';

  @override
  String get authHintLoginName => 'Unesite StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Prijava';

  @override
  String get authGetCode => 'Dohvati kod';

  @override
  String authResendCode(int seconds) {
    return 'Ponovno slanje za $seconds s';
  }

  @override
  String get authUsePassword => 'Koristi lozinku';

  @override
  String get authUseCode => 'Koristi kod za potvrdu';

  @override
  String get authAgreementPrefix => 'Pročitao sam i slažem se s';

  @override
  String get authAgreementAnd => 'i';

  @override
  String get authTermsLink => 'Korisnički ugovor';

  @override
  String get authPrivacyLink => 'Politika privatnosti';

  @override
  String get authCaptchaTitle => 'Sigurnosna provjera';

  @override
  String get authCaptchaHint => 'Unesite odgovor';

  @override
  String get authCaptchaFailed =>
      'Sigurnosna provjera nije dohvaćena. Pokušajte ponovno.';

  @override
  String get authErrorEmptyCode => 'Unesite kod za potvrdu';

  @override
  String get authErrorEmptyPassword => 'Unesite lozinku';

  @override
  String get authErrorEmptyLoginName => 'Unesite StartLink ID';

  @override
  String get authErrorWrongCredentials => 'Netočan račun ili lozinka';

  @override
  String get authDeactivatingTitle => 'Deaktivacija računa';

  @override
  String get authDeactivatingContent =>
      'Vaš je račun u razdoblju čekanja na deaktivaciju (7 dana).\n\nZa otkazivanje deaktivacije dodirnite „Otkaži deaktivaciju”; za ulazak u aplikaciju dodirnite „Nastavi”.';

  @override
  String get authContinueUse => 'Nastavi';

  @override
  String get authCancelDeactivation => 'Otkaži deaktivaciju';

  @override
  String get authDeactivationCancelled =>
      'Deaktivacija je otkazana, račun je vraćen';

  @override
  String get authDeactivationCancelFailed =>
      'Otkazivanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get authLogout => 'Odjava';

  @override
  String get authLogoutConfirm => 'Želite li se odjaviti?';

  @override
  String get authSendingCode => 'Slanje...';

  @override
  String get authCodeSent => 'Verifikacijski kod poslan';

  @override
  String get authLoginFailed => 'Prijava nije uspjela. Pokušajte ponovno.';

  @override
  String get authRegisterFailed =>
      'Registracija nije uspjela. Pokušajte ponovno.';

  @override
  String get authEnterpriseCode => 'Kod tvrtke';

  @override
  String get authEnterpriseCodeHint => 'Unesite kod tvrtke';

  @override
  String get authPendingApproval =>
      'Registracija je uspjela. Zahtjev za pridruživanje tvrtki poslan je i čeka odobrenje.';

  @override
  String get authNoAccount => 'Nemate račun?';

  @override
  String get authRegisterNow => 'Registriraj se';

  @override
  String get authCountryPickerTitle => 'Odaberite državu/regiju';

  @override
  String get authCountrySearchHint => 'Pretraži države/regije';

  @override
  String get authCountryChinaMainland => 'Kontinentalna Kina';

  @override
  String get authCountryHongKong => 'Hong Kong, Kina';

  @override
  String get authCountryMacau => 'Makao, Kina';

  @override
  String get authCountryTaiwan => 'Tajvan, Kina';

  @override
  String get authCountryUnitedStates => 'Sjedinjene Američke Države';

  @override
  String get authCountryUnitedKingdom => 'Ujedinjena Kraljevina';

  @override
  String get authCountryJapan => 'Japan';

  @override
  String get authCountrySouthKorea => 'Južna Koreja';

  @override
  String get authCountrySingapore => 'Singapur';

  @override
  String get authCountryMalaysia => 'Malezija';

  @override
  String get authCountryAustralia => 'Australija';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Njemačka';

  @override
  String get authCountryFrance => 'Francuska';

  @override
  String get authCountryIndia => 'Indija';

  @override
  String get authCountryThailand => 'Tajland';

  @override
  String get authCountryVietnam => 'Vijetnam';

  @override
  String get authCountryIndonesia => 'Indonezija';

  @override
  String get authCountryPhilippines => 'Filipini';

  @override
  String get authQuickLoginTitle => 'Brza prijava';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Prijava je u tijeku. Pričekajte.';

  @override
  String get authRoleOwner => 'Vlasnik';

  @override
  String get authRoleAdministrator => 'Administrator';

  @override
  String get authRoleCustomerService => 'Korisnička podrška';

  @override
  String get authRoleTechnicalSupport => 'Tehnička podrška';

  @override
  String get authRoleEmployee => 'Zaposlenik';

  @override
  String get authRoleMember => 'Član';

  @override
  String get authRoleEnterpriseCustomer => 'Poslovni klijent';

  @override
  String get authUnavailablePrefix => 'Nedostupno · ';

  @override
  String get authUnassignedService => 'Nema dodijeljenog agenta';

  @override
  String authAssignedService(String staff) {
    return 'Dodijeljeno: $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Klijent · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Zaposlenik · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count korisnika';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Identitet';

  @override
  String get authRegisterTitle => 'Registrirajte se';

  @override
  String get authNickname => 'Nadimak';

  @override
  String get authNicknameHint => 'Postavite nadimak';

  @override
  String get authPassword => 'Lozinka';

  @override
  String get authPasswordSetHint => 'Postavite lozinku (najmanje 6 znakova)';

  @override
  String get authConfirmPassword => 'Potvrdite lozinku';

  @override
  String get authConfirmPasswordHint => 'Ponovno unesite lozinku';

  @override
  String get authVerificationCode => 'Verifikacijski kod';

  @override
  String get authRegisterAndLogin => 'Registriraj se i prijavi';

  @override
  String get authHaveAccount => 'Već imate račun?';

  @override
  String get authGoLogin => 'Prijava';

  @override
  String get authEmailVerificationUnavailable =>
      'Potvrda e-poštom nije dostupna. Registrirajte se brojem mobitela.';

  @override
  String get authSmsVerificationUnavailable =>
      'Potvrda SMS-om nije dostupna. Registrirajte se e-poštom.';

  @override
  String get authSendFailed => 'Slanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get authErrorEmptyNickname => 'Unesite nadimak';

  @override
  String get authErrorInvalidMobile => 'Unesite valjan broj mobitela';

  @override
  String get authErrorInvalidEmail => 'Unesite valjanu adresu e-pošte';

  @override
  String get authErrorPasswordTooShort =>
      'Lozinka mora sadržavati najmanje 6 znakova';

  @override
  String get authErrorPasswordMismatch => 'Lozinke se ne podudaraju';

  @override
  String get authErrorVerificationRequired =>
      'Najprije zatražite i unesite kod za potvrdu';

  @override
  String get authRegisterErrorTitle => 'Registracija nije uspjela';

  @override
  String get authGotIt => 'Razumijem';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Tvrtka „$code” nije pronađena. Provjerite kod tvrtke.';
  }

  @override
  String get authTenantSearchFailed =>
      'Pretraživanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get authInvitationInvalid =>
      'Kod pozivnice nije valjan. Provjerite ga i pokušajte ponovno.';

  @override
  String get authCollapseJoin => 'Sakrij podatke o pridruživanju';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Valjana pozivnica: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Pronađena tvrtka: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Odaberite organizaciju';

  @override
  String get authNoOrganization => 'Nema dostupnih organizacija';

  @override
  String get authNoOrganizationHint =>
      'Zatražite od administratora pozivnicu za organizaciju';

  @override
  String get authPersonalSpace => 'Osobni prostor';

  @override
  String get authPersonalSpaceSubtitle =>
      'Razgovori s prijateljima i osobne spremljene stavke';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Identitet prostora nije potvrđen. Pokušajte ponovno.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Osobni prostor nije vraćen. Pokušajte ponovno.';

  @override
  String get authJoinEnterpriseFailed =>
      'Pridruživanje tvrtki nije uspjelo. Pokušajte kasnije.';

  @override
  String get homeTitle => 'Poruke';

  @override
  String get homeGatewayConnectingTitle => 'Povezivanje';

  @override
  String get homePersonalSpace => 'Osobno';

  @override
  String get homeOfficialService => 'Službena podrška';

  @override
  String get homeSwitchSpace => 'Promijeni prostor';

  @override
  String get homeSpaceSubtitle => 'Osobno · Tvrtka';

  @override
  String get homeJoinEnterprise => 'Pridruži se tvrtki';

  @override
  String get homeCreateGroup => 'Nova grupa';

  @override
  String get homeAddFriend => 'Dodaj kontakt';

  @override
  String get homeScan => 'Skeniraj';

  @override
  String get homeJoinNewSpace => 'Pridruži se novom prostoru';

  @override
  String get homeSearchConversation => 'Pretraži';

  @override
  String get homeNoMessages => 'Nema poruka';

  @override
  String get homeDeleteConversation => 'Izbriši razgovor';

  @override
  String get homeDeleteConversationConfirm =>
      'Izbrisati ovaj razgovor? Povijest razgovora bit će obrisana.';

  @override
  String get homePersonalNote => 'Ja (osobne bilješke)';

  @override
  String get homeWorkNote => 'Ja (poslovne bilješke)';

  @override
  String homeConversationCount(int count) {
    return '$count razgovora';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count nepročitanih';
  }

  @override
  String get chatInputHint => 'Upišite poruku...';

  @override
  String get chatVoiceHint => 'Držite za govor';

  @override
  String get chatVoiceRelease => 'Otpustite za slanje';

  @override
  String get chatVoiceCancel => 'Povucite gore za odustajanje';

  @override
  String get chatMenuCopy => 'Kopiraj';

  @override
  String get chatMenuForward => 'Proslijedi';

  @override
  String get chatMenuRecall => 'Povuci poruku';

  @override
  String get chatMenuDelete => 'Izbriši';

  @override
  String get chatMenuFavorite => 'Spremi';

  @override
  String get chatMenuReply => 'Odgovori';

  @override
  String get chatMenuMultiSelect => 'Odaberi';

  @override
  String get chatMenuTranslate => 'Prevedi';

  @override
  String get chatMenuVoiceToText => 'Pretvori u tekst';

  @override
  String get chatMenuTextToSpeech => 'Pročitaj naglas';

  @override
  String get chatStatusRecalled => 'Poruka je povučena';

  @override
  String get chatRecallSuccess => 'Povučeno';

  @override
  String get chatRecallFailed => 'Povlačenje nije uspjelo';

  @override
  String get chatRecallTimeout =>
      'Poruke starije od 2 minute nije moguće povući';

  @override
  String get chatTranslateFailed => 'Prijevod nije uspio. Pokušajte ponovno.';

  @override
  String get chatTranslateNotConfigured => 'Usluga prevođenja nije dostupna';

  @override
  String get chatVoiceToTextFailed =>
      'Pretvaranje nije uspjelo. Pokušajte ponovno.';

  @override
  String get chatTextToSpeechFailed =>
      'Čitanje naglas nije uspjelo. Pokušajte ponovno.';

  @override
  String get chatVoiceToText => 'Pretvori';

  @override
  String get chatForwardSuccess => 'Proslijeđeno';

  @override
  String get chatForwardFailed =>
      'Prosljeđivanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get chatNoConversations => 'Nema razgovora za prosljeđivanje';

  @override
  String get chatSendFailed => 'Slanje nije uspjelo';

  @override
  String get chatResend => 'Ponovno pošalji kod';

  @override
  String get chatNotFriend => 'Nije na popisu kontakata';

  @override
  String get chatNotFriendHint =>
      'Još niste kontakti. Slanje poruka nije moguće.';

  @override
  String get chatMutedHint => 'Svi članovi su utišani';

  @override
  String get chatFileUploadFailed =>
      'Prijenos datoteke nije uspio. Pokušajte ponovno.';

  @override
  String get chatFileStatusNotDownloaded => 'Nije preuzeto';

  @override
  String get chatFileStatusDownloaded => 'Preuzeto';

  @override
  String get chatFileStatusUploading => 'Prijenos';

  @override
  String get chatFileStatusUploadFailed => 'Učitavanje nije uspjelo';

  @override
  String get chatCardSendFailed => 'Slanje kartice kontakta nije uspjelo';

  @override
  String get chatFavoriteSuccess => 'Spremljeno';

  @override
  String get chatFavoriteFailed => 'Spremanje u favorite nije uspjelo';

  @override
  String get chatLoadFailed => 'Učitavanje nije uspjelo';

  @override
  String get chatImageMessage => '[Slika]';

  @override
  String get chatVoiceMessage => '[Glasovna poruka]';

  @override
  String get chatVideoMessage => '[Videozapis]';

  @override
  String get chatFileMessage => '[Datoteka]';

  @override
  String get chatLocationMessage => '[Lokacija]';

  @override
  String get chatContactCardMessage => '[Kontakt]';

  @override
  String get chatCallLogMessage => '[Poziv]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Pročitalo: $count';
  }

  @override
  String get chatUnread => 'Nepročitano';

  @override
  String get chatRecalledSelf => 'Povukli ste poruku';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender je povukao/la poruku';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Prijevod: $translation';
  }

  @override
  String get chatMessageDeleted => 'Poruka je izbrisana';

  @override
  String get chatPeer => 'Ostalo';

  @override
  String get chatSelf => 'Ja';

  @override
  String get chatGenericMessage => '[Poruka]';

  @override
  String get chatVoiceHideText => 'Sakrij tekst';

  @override
  String get chatVoiceShowText => 'Pretvori u tekst';

  @override
  String get chatFileDefaultName => 'Datoteka';

  @override
  String get chatContactDefaultName => 'Kontakt';

  @override
  String get chatContactCardTitle => 'Kartica kontakta';

  @override
  String get chatCallMissed => 'Propušteno';

  @override
  String get chatCallCancelled => 'Otkazano';

  @override
  String get chatCallRejected => 'Odbijeno';

  @override
  String get chatCallDisconnected => 'Veza prekinuta';

  @override
  String get chatCallEnded => 'Poziv je završen';

  @override
  String get chatCallFailed => 'Poziv nije uspio';

  @override
  String chatCallDuration(String duration) {
    return 'Trajanje $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videopoziv';

  @override
  String get chatVoiceCallTitle => 'Glasovni poziv';

  @override
  String get chatToolPhotos => 'Fotografije';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Datoteka';

  @override
  String get chatToolLocation => 'Lokacija';

  @override
  String get chatToolContactCard => 'Kontakt';

  @override
  String get chatToolVoiceCall => 'Glasovni poziv';

  @override
  String get chatToolVideoCall => 'Videopoziv';

  @override
  String get chatToolFavorites => 'Favoriti';

  @override
  String get chatToolTranslate => 'Prevedi';

  @override
  String get chatTranslationChooseLanguage => 'Odaberite jezik prijevoda';

  @override
  String get chatTranslationEnterText => 'Najprije unesite tekst';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Prijevod nije dostupan za poruke sa spominjanjima';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Prijevod nije dostupan pri uređivanju zakazane poruke';

  @override
  String get chatTranslationFailed => 'Prijevod nije uspio. Pokušajte ponovno.';

  @override
  String get chatTranslationEmpty => 'Prijevod nije vraćen. Pokušajte ponovno.';

  @override
  String get chatTranslationTranslating => 'Prevođenje…';

  @override
  String get chatTranslationSend => 'Pošalji prijevod';

  @override
  String get chatTranslationSending => 'Slanje…';

  @override
  String get chatTranslationExpand => 'Prikaži više';

  @override
  String get chatTranslationCollapse => 'Prikaži manje';

  @override
  String get chatFileTooLarge => 'Datoteka prelazi ograničenje (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Samo vlasnik ili odabrani članovi mogu pisati.';

  @override
  String get chatImageUploadUnsupported =>
      'Prijenos slike nije uspio. Poslužitelj još ne podržava tu mogućnost.';

  @override
  String get chatFavoriteLongPressHint =>
      'Dugo pritisnite poruku za spremanje u favorite';

  @override
  String chatSelectedCount(int count) {
    return 'Odabrano: $count';
  }

  @override
  String get chatLocationSheetTitle => 'Pošalji lokaciju';

  @override
  String get chatLocationNameLabel => 'Naziv mjesta';

  @override
  String get chatLocationNameHint => 'npr. ured, adresa klijenta';

  @override
  String get chatLocationAddressLabel => 'Adresa';

  @override
  String get chatLocationOptionalHint => 'Neobavezno';

  @override
  String get chatLocationLatitudeLabel => 'Zemljopisna širina';

  @override
  String get chatLocationLatitudeHint => '-90 do 90';

  @override
  String get chatLocationLongitudeLabel => 'Zemljopisna dužina';

  @override
  String get chatLocationLongitudeHint => '-180 do 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Unesite: $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return 'Vrijednost $label je izvan raspona';
  }

  @override
  String get chatLocationDefaultTitle => 'Lokacija';

  @override
  String get chatMutedFullNotice =>
      'Ova je grupa utišana. Samo vlasnik ili odabrani članovi mogu pisati.';

  @override
  String get chatNotFriendSendBlocked =>
      'Više niste prijatelji i ne možete slati poruke';

  @override
  String get chatPersonalNotesTitle => 'Osobne bilješke';

  @override
  String get chatWorkNotesTitle => 'Poslovne bilješke';

  @override
  String get chatPersonalNotesDescription =>
      'Ovdje bilježite osobne misli i spremite važne podatke\nSinkronizirano na uređajima za pristup u svakom trenutku';

  @override
  String get chatWorkNotesDescription =>
      'Ovdje bilježite poslovne zadatke i spremite poslovne materijale\nTimski prostori ostaju odvojeni i sigurni';

  @override
  String get chatNoMessages => 'Nema poruka';

  @override
  String chatReplyTo(String sender) {
    return 'Odgovori korisniku $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return 'Funkcija $feature uskoro dolazi';
  }

  @override
  String get chatForwardSelectTitle => 'Odaberite razgovor';

  @override
  String get chatContactSelectTitle => 'Odaberite kontakt';

  @override
  String get chatNoContacts => 'Nema kontakata';

  @override
  String get contactsTitle => 'Kontakti';

  @override
  String get contactsSearch => 'Pretraži kontakte';

  @override
  String get contactsNewFriends => 'Novi prijatelji';

  @override
  String get contactsGroups => 'Grupe';

  @override
  String get contactsFavorites => 'Favoriti';

  @override
  String get contactsRecent => 'Nedavno';

  @override
  String get contactsOrganization => 'Organizacija';

  @override
  String get contactsAnnouncement => 'Obavijesti';

  @override
  String get contactsNewApplications => 'Novi zahtjevi';

  @override
  String get contactsCustomerGroups => 'Grupe klijenata';

  @override
  String get contactsAllCustomers => 'Svi klijenti';

  @override
  String get contactsMyCustomers => 'Moji klijenti';

  @override
  String get contactsViewAll => 'Prikaži sve';

  @override
  String get contactsMyContacts => 'Moji kontakti';

  @override
  String get contactsMyAdvisor => 'Moj savjetnik';

  @override
  String get contactsNoAdvisor => 'Savjetnik još nije dodijeljen';

  @override
  String get contactsAdvisorLoading => 'Učitavanje...';

  @override
  String get contactsNavigateFailed =>
      'Otvaranje stranice nije uspjelo. Pokušajte ponovno.';

  @override
  String get contactsEmpty => 'Nema kontakata';

  @override
  String get contactsNoAnnouncement => 'Nema obavijesti';

  @override
  String get contactsOfficialBadge => 'Službeno';

  @override
  String get contactsCustomerBadge => 'Klijent';

  @override
  String get contactsEmptyCustomers => 'Nema klijenata';

  @override
  String get myTitle => 'Ja';

  @override
  String get myEnterpriseInfo => 'Podaci o tvrtki';

  @override
  String get myEnterpriseManage => 'Upravljanje tvrtkom';

  @override
  String get myQrCode => 'QR kod';

  @override
  String get myFavorites => 'Favoriti';

  @override
  String get myLanguage => 'Jezik';

  @override
  String get myTimezone => 'Vremenska zona';

  @override
  String get myAutoTranslate => 'Automatski prijevod';

  @override
  String get myNetworkSwitch => 'Promijeni liniju';

  @override
  String get mySettings => 'Postavke';

  @override
  String get myLogout => 'Odjava';

  @override
  String get myLogoutConfirm => 'Želite li se odjaviti?';

  @override
  String get myLeaveEnterprise => 'Napusti tvrtku';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Želite li napustiti ovu tvrtku? Izgubit ćete pristup podacima tvrtke.';

  @override
  String get myLeaveEnterpriseSuccess => 'Napustili ste tvrtku';

  @override
  String get myLeaveEnterpriseFailed =>
      'Napuštanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get myLppIdCopied => 'StartLink ID je kopiran';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count kontakata';
  }

  @override
  String get myAutoSelect => 'Automatski';

  @override
  String get myPresenceStatus => 'Status dostupnosti';

  @override
  String get myPresenceStatusTitle => 'Postavi status dostupnosti';

  @override
  String get myPresenceOnline => 'Na mreži';

  @override
  String get myPresenceBusy => 'Zauzet/a';

  @override
  String get myPresenceAway => 'Odsutan/na';

  @override
  String get myPresenceInvisible => 'Nevidljiv/a';

  @override
  String get profileTitle => 'Moj profil';

  @override
  String get profileName => 'Ime';

  @override
  String get profileGender => 'Spol';

  @override
  String get profileBirthday => 'Rođendan';

  @override
  String get profileRegion => 'Regija';

  @override
  String get profileSignature => 'O meni';

  @override
  String get profileSignatureHint => 'Napišite nešto o sebi';

  @override
  String get profileTapTapText => 'Tapkanje';

  @override
  String get profileTapTapHint =>
      'Tekst prikazan pri tapkanju (najviše 20 znakova)';

  @override
  String get profileAccountSection => 'Račun';

  @override
  String get profileBasicSection => 'Osnovni podaci';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Nije postavljeno';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Nije povezano';

  @override
  String get profileEmail => 'E-pošta';

  @override
  String get profileEmailUnbound => 'Nije povezano';

  @override
  String get profileQrCode => 'Moj QR kod';

  @override
  String get profileChangePassword => 'Promijeni lozinku';

  @override
  String get profileGenderMale => 'Muško';

  @override
  String get profileGenderFemale => 'Ženski';

  @override
  String get profileGenderOther => 'Ostalo';

  @override
  String get profileGenderUnset => 'Nije postavljeno';

  @override
  String get profileSaveFailed => 'Spremanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink ID možete promijeniti samo jednom. Pažljivo ga odaberite.';

  @override
  String get profileLppIdChangeFailed =>
      'Promjena nije uspjela (StartLink ID može se promijeniti samo jednom)';

  @override
  String get profileChangePasswordOld => 'Trenutačna lozinka';

  @override
  String get profileChangePasswordNew => 'Nova lozinka';

  @override
  String get profileChangePasswordConfirm => 'Potvrda nove lozinke';

  @override
  String get profileChangePasswordMismatch => 'Lozinke se ne podudaraju';

  @override
  String get profileChangePasswordSuccess =>
      'Lozinka je promijenjena. Ponovno se prijavite.';

  @override
  String get profileChangePasswordFailed =>
      'Promjena lozinke nije uspjela. Pokušajte ponovno.';

  @override
  String get settingsTitle => 'Postavke';

  @override
  String get settingsSectionEnterprise => 'Tvrtka';

  @override
  String get settingsSectionAccount => 'Račun';

  @override
  String get settingsSectionGeneral => 'Općenito';

  @override
  String get settingsSectionFeatures => 'Funkcije';

  @override
  String get settingsSectionAbout => 'O aplikaciji';

  @override
  String get settingsEnterpriseInfo => 'Podaci o tvrtki';

  @override
  String get settingsProfile => 'Moj profil';

  @override
  String get settingsAccountSecurity => 'Sigurnost računa';

  @override
  String get settingsNotification => 'Obavijesti';

  @override
  String get settingsDisplay => 'Prikaz';

  @override
  String get settingsFriendPrivacy => 'Privatnost';

  @override
  String get settingsChat => 'Razgovor';

  @override
  String get settingsChatHistory => 'Povijest razgovora';

  @override
  String get settingsAbout => 'O aplikaciji StartLink';

  @override
  String get settingsLanguage => 'Jezik';

  @override
  String get settingsTimezone => 'Vremenska zona';

  @override
  String get settingsAutoTranslate => 'Automatski prijevod';

  @override
  String get settingsNetworkSwitch => 'Promijeni liniju';

  @override
  String get enterpriseInfoTitle => 'Podaci o tvrtki';

  @override
  String get enterpriseName => 'Ime';

  @override
  String get enterpriseDescription => 'Opis';

  @override
  String get enterpriseUpdateSuccess => 'Uspješno ažurirano.';

  @override
  String get enterpriseUpdateFailed =>
      'Ažuriranje nije uspjelo. Pokušajte ponovno.';

  @override
  String get enterpriseLeave => 'Napusti tvrtku';

  @override
  String get enterpriseLeaveConfirm => 'Želite li napustiti ovu tvrtku?';

  @override
  String get enterpriseLeaveSuccess => 'Napustili ste tvrtku';

  @override
  String get enterpriseLeaveFailed =>
      'Napuštanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Vlasnik ne može izravno napustiti tvrtku. Najprije prenesite vlasništvo.';

  @override
  String get enterpriseMemberCount => 'Članovi';

  @override
  String get enterpriseCreatedAt => 'Stvoreno';

  @override
  String get enterpriseCode => 'Kod tvrtke';

  @override
  String get enterpriseInviteMembers => 'Pozovi članove';

  @override
  String get enterpriseCopyInviteCode => 'Kopiraj kod pozivnice';

  @override
  String get enterpriseInviteCodeCopied => 'Kod pozivnice je kopiran';

  @override
  String get groupCreateTitle => 'Nova grupa';

  @override
  String get groupNameHint => 'Unesite naziv grupe';

  @override
  String get groupCreateSuccess => 'Grupa je stvorena';

  @override
  String get groupCreateFailed => 'Stvaranje grupe nije uspjelo';

  @override
  String get groupSettings => 'Postavke grupe';

  @override
  String get groupName => 'Naziv grupe';

  @override
  String get groupAvatar => 'Slika grupe';

  @override
  String get groupAnnouncement => 'Obavijest';

  @override
  String get groupMembers => 'Članovi';

  @override
  String get groupAddMember => 'Dodaj članove';

  @override
  String get groupRemoveMember => 'Ukloni člana';

  @override
  String get groupRemoveMemberConfirm => 'Ukloniti ovog člana?';

  @override
  String get groupSetAdmin => 'Postavi za administratora';

  @override
  String get groupRemoveAdmin => 'Ukloni administratorsku ulogu';

  @override
  String get groupTransferOwner => 'Prenesi vlasništvo';

  @override
  String get groupTransferOwnerConfirm =>
      'Prenijeti vlasništvo grupe ovom članu?';

  @override
  String get groupTransferOwnerSuccess => 'Vlasništvo je preneseno';

  @override
  String get groupTransferOwnerFailed =>
      'Prijenos nije uspio. Pokušajte ponovno.';

  @override
  String get groupLeave => 'Napusti grupu';

  @override
  String get groupLeaveConfirm => 'Napustiti ovu grupu?';

  @override
  String get groupLeaveSuccess => 'Napustili ste grupu';

  @override
  String get groupLeaveFailed => 'Napuštanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get groupDissolve => 'Raspusti grupu';

  @override
  String get groupDissolveConfirm =>
      'Raspustiti ovu grupu? Svi članovi bit će uklonjeni.';

  @override
  String get groupDissolveSuccess => 'Grupa je raspuštena';

  @override
  String get groupDissolveFailed =>
      'Raspuštanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get groupQrCode => 'QR kod grupe';

  @override
  String get groupMuteAll => 'Utišaj sve';

  @override
  String get groupMuteAllOn => 'Uključi utišavanje svih';

  @override
  String get groupMuteAllOff => 'Isključi utišavanje svih';

  @override
  String get groupAllowMemberInvite => 'Dopusti članovima pozivanje drugih';

  @override
  String get groupAllowMemberModifyTitle =>
      'Dopusti članovima promjenu naziva grupe';

  @override
  String get groupAllowMemberAtAll => 'Dopusti članovima spominjanje svih';

  @override
  String get groupAllowMemberViewMemberList =>
      'Dopusti članovima prikaz popisa članova';

  @override
  String get groupAllowQrCodeJoin => 'Dopusti pridruživanje QR kodom';

  @override
  String get groupRequireApproval => 'Za pridruživanje je potrebno odobrenje';

  @override
  String get groupAllowMemberAddFriend =>
      'Dopusti članovima međusobno dodavanje';

  @override
  String get groupRoleOwner => 'Vlasnik';

  @override
  String get groupRoleAdmin => 'Administrator';

  @override
  String get groupRoleMember => 'Član';

  @override
  String get groupNoMembers => 'Nema članova';

  @override
  String get groupNoAnnouncements => 'Nema obavijesti';

  @override
  String get groupCreateAnnouncement => 'Objavi obavijest';

  @override
  String get groupEditAnnouncement => 'Uredi obavijest';

  @override
  String get groupDeleteAnnouncement => 'Izbriši obavijest';

  @override
  String get groupDeleteAnnouncementConfirm => 'Izbrisati ovu obavijest?';

  @override
  String get groupAnnouncementTitle => 'Naslov';

  @override
  String get groupAnnouncementContent => 'Sadržaj';

  @override
  String get groupAnnouncementPin => 'Prikvači obavijest';

  @override
  String groupMemberCount(int count) {
    return '$count članova';
  }

  @override
  String groupSelectedCount(int count) {
    return 'Odabrano: $count';
  }

  @override
  String get groupJoinRequestApprove => 'Prihvaćam';

  @override
  String get groupJoinRequestReject => 'Odbij';

  @override
  String get groupJoinRequests => 'Zahtjevi za pridruživanje';

  @override
  String get groupNoJoinRequests => 'Nema zahtjeva za pridruživanje';

  @override
  String get groupReadReceipts => 'Potvrde čitanja';

  @override
  String groupReadCount(int count) {
    return 'Pročitano: $count';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count nepročitanih';
  }

  @override
  String get friendAddTitle => 'Dodaj kontakt';

  @override
  String get friendSearchHint => 'Telefon / e-pošta / StartLink ID';

  @override
  String get friendRequestSent => 'Zahtjev za prijateljstvo je poslan';

  @override
  String get friendRequestFailed => 'Slanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get friendAlreadyFriend => 'Već ste kontakti';

  @override
  String get friendNewFriendsTitle => 'Novi prijatelji';

  @override
  String get friendNoRequests => 'Nema zahtjeva za prijateljstvo';

  @override
  String get friendAccept => 'Prihvati';

  @override
  String get friendReject => 'Odbij';

  @override
  String get friendAccepted => 'Prihvaćeno';

  @override
  String get friendRejected => 'Odbijeno';

  @override
  String get friendDeleteConfirm => 'Ukloniti ovaj kontakt?';

  @override
  String get friendDeleteSuccess => 'Kontakt je uklonjen';

  @override
  String get friendDeleteFailed =>
      'Uklanjanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get friendRemarkName => 'Nadimak';

  @override
  String get friendGroupName => 'Grupa';

  @override
  String get friendSendMessage => 'Poruka';

  @override
  String get friendMatchTypeLppId => 'Pronađeno prema StartLink ID-u';

  @override
  String get friendMatchTypeMobile => 'Pronađeno prema telefonu';

  @override
  String get friendMatchTypeEmail => 'Pronađeno prema e-pošti';

  @override
  String get friendSearchEmpty => 'Nema pronađenih korisnika';

  @override
  String get friendAddMessage => 'Želim vas dodati u kontakte';

  @override
  String get friendBlockConfirm => 'Blokirati ovog korisnika?';

  @override
  String get friendUnblockConfirm => 'Deblokirati ovog korisnika?';

  @override
  String get friendBlockSuccess => 'Blokirano';

  @override
  String get friendUnblockSuccess => 'Deblokirano';

  @override
  String get profilePageTitle => 'Osobni podaci';

  @override
  String get profilePageSendMessage => 'Poruka';

  @override
  String get profilePageAddFriend => 'Dodaj prijatelja';

  @override
  String get profilePageAlreadyFriend => 'Već ste prijatelji';

  @override
  String get profilePageBlocked => 'Blokirano';

  @override
  String get profilePageBlock => 'Blokiraj';

  @override
  String get profilePageUnblock => 'Deblokiraj';

  @override
  String get profilePageHidden => 'Ovaj je korisnik sakrio profil';

  @override
  String get profilePageFriendsOnly =>
      'Ovaj korisnik prikazuje profil samo prijateljima';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Napomene';

  @override
  String get profilePageEditRemark => 'Uredi nadimak';

  @override
  String get profilePageSaveRemarkSuccess => 'Nadimak je spremljen';

  @override
  String get profilePageSaveRemarkFailed =>
      'Spremanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get searchTitle => 'Pretraži';

  @override
  String get searchHint => 'Pretraži po telefonu, e-pošti ili StartLink ID-u';

  @override
  String get searchNoResults => 'Nema rezultata';

  @override
  String get searchMessages => 'Poruke';

  @override
  String get searchUsers => 'Korisnici';

  @override
  String get searchFailed => 'Pretraživanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get scanTitle => 'Skeniraj';

  @override
  String get scanFailed => 'Prepoznavanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get scanInvalidQrCode => 'Nevaljan QR kod';

  @override
  String get scanFlashOn => 'Uključi svjetiljku';

  @override
  String get scanFlashOff => 'Isključi svjetiljku';

  @override
  String get scanAlbum => 'Odaberi iz albuma';

  @override
  String get favoritesTitle => 'Favoriti';

  @override
  String get favoritesEmpty => 'Još ništa nije spremljeno';

  @override
  String get favoritesAll => 'Sve';

  @override
  String get favoritesText => 'Tekst';

  @override
  String get favoritesImage => 'Slike';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Glasovne poruke';

  @override
  String get favoritesFile => 'Datoteke';

  @override
  String get favoritesOther => 'Ostalo';

  @override
  String get favoritesDeleteConfirm => 'Ukloniti iz favorita?';

  @override
  String get favoritesDeleteSuccess => 'Uklonjeno iz spremljenog';

  @override
  String get favoritesDeleteFailed => 'Uklanjanje nije uspjelo';

  @override
  String get favoritesOriginalRecalled => 'Poruka je povučena';

  @override
  String get favoritesViewOriginal => 'Prikaži izvornik';

  @override
  String get favoritesSearchHint => 'Pretraži favorite';

  @override
  String get favoritesNoResults => 'Nema odgovarajućih favorita';

  @override
  String get noticeTitle => 'Obavijesti';

  @override
  String get noticeEmpty => 'Nema obavijesti';

  @override
  String get noticeDetail => 'Pojedinosti obavijesti';

  @override
  String get noticePublishedAt => 'Objavljeno';

  @override
  String get noticePriorityNormal => 'normalan';

  @override
  String get noticePriorityImportant => 'Važno';

  @override
  String get noticePriorityUrgent => 'Hitno';

  @override
  String get organizationTitle => 'Organizacija';

  @override
  String get organizationEmpty => 'Nema podataka o odjelu';

  @override
  String get organizationMembers => 'Članovi';

  @override
  String get organizationDepartment => 'Odjel';

  @override
  String get organizationPosition => 'Radno mjesto';

  @override
  String get organizationLeader => 'Voditelj';

  @override
  String get qrCodeTitle => 'Moj QR kod';

  @override
  String get qrCodeSave => 'Spremi u album';

  @override
  String get qrCodeShare => 'Podijeli';

  @override
  String get qrCodeSaveSuccess => 'Spremljeno u album';

  @override
  String get qrCodeSaveFailed => 'Spremanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get qrCodeRefresh => 'Osvježi QR kod';

  @override
  String get qrCodeExpired => 'QR kod je istekao. Osvježite ga.';

  @override
  String get qrCodeScanToAdd => 'Skenirajte da biste me dodali u kontakte';

  @override
  String get spacePersonal => 'Osobno';

  @override
  String get spaceEnterprise => 'Tvrtka';

  @override
  String get spaceJoinByCode => 'Pridruži se kodom tvrtke';

  @override
  String get spaceJoinByInvite => 'Pridruži se kodom pozivnice';

  @override
  String get spaceEnterCode => 'Unesite kod tvrtke';

  @override
  String get spaceEnterInviteCode => 'Unesite kod pozivnice';

  @override
  String get spaceSearchEnterprise => 'Pretraži tvrtke';

  @override
  String get spaceJoinRequestSent => 'Zahtjev je poslan i čeka odobrenje';

  @override
  String get spaceJoinRequestPending => 'Čeka se odobrenje';

  @override
  String get spaceJoinRequestApproved => 'Zahtjev je odobren';

  @override
  String get spaceJoinRequestRejected => 'Zahtjev je odbijen';

  @override
  String get spaceAlreadyMember => 'Već ste član';

  @override
  String get spaceAutoApproved => 'Automatski odobreno. Dobro došli!';

  @override
  String get spacePendingApprovalHint =>
      'Registracija je uspjela. Vaš zahtjev za pridruživanje je poslan.';

  @override
  String get spaceNoSpaces => 'Nema prostora';

  @override
  String get spaceInviteExpired => 'Kod pozivnice je istekao';

  @override
  String get spaceInviteTargetMismatch =>
      'Ovaj kod pozivnice nije namijenjen vašem računu';

  @override
  String get spaceAcceptInviteSuccess => 'Uspješno ste se pridružili tvrtki';

  @override
  String get spaceAcceptInviteFailed =>
      'Pridruživanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get spaceTenantSelectTitle => 'Odaberite prostor';

  @override
  String get spaceTenantSelectHint => 'Odaberite prostor u koji želite ući';

  @override
  String get spaceEnterPersonal => 'Uđi u osobni prostor';

  @override
  String get spaceEnterEnterprise => 'Uđi u prostor tvrtke';

  @override
  String get aboutTitle => 'O aplikaciji StartLink';

  @override
  String get aboutVersion => 'Verzija';

  @override
  String get aboutTerms => 'Korisnički ugovor';

  @override
  String get aboutPrivacy => 'Politika privatnosti';

  @override
  String get aboutOpenSource => 'Licence otvorenog koda';

  @override
  String get aboutCheckUpdate => 'Provjeri ažuriranja';

  @override
  String get aboutLatestVersion => 'Koristite najnoviju verziju.';

  @override
  String get aboutUpdateAvailable => 'Dostupna je nova verzija';

  @override
  String get aboutUpdateNow => 'Ažurirajte sada';

  @override
  String get aboutUpdateLater => 'Kasnije';

  @override
  String get notificationTitle => 'Obavijesti';

  @override
  String get notificationGlobalMute => 'Ne ometaj';

  @override
  String get notificationSound => 'Zvuk';

  @override
  String get notificationVibration => 'Vibracija';

  @override
  String get notificationPreview => 'Pregled poruke';

  @override
  String get notificationDndStart => 'Početak načina Ne ometaj';

  @override
  String get notificationDndEnd => 'Završetak načina Ne ometaj';

  @override
  String get blacklistTitle => 'Na crnoj listi';

  @override
  String get blacklistEmpty => 'Nema blokiranih korisnika';

  @override
  String get blacklistRemove => 'Deblokiraj';

  @override
  String get blacklistRemoveConfirm => 'Deblokirati ovog korisnika?';

  @override
  String get feedbackTitle => 'Povratne informacije';

  @override
  String get feedbackTypeComplaint => 'Pritužba';

  @override
  String get feedbackTypeSuggestion => 'Prijedlog';

  @override
  String get feedbackTypeBug => 'Prijava pogreške';

  @override
  String get feedbackContent => 'Opis';

  @override
  String get feedbackContentHint => 'Detaljno opišite problem ili prijedlog';

  @override
  String get feedbackContact => 'Kontakt (neobvezno)';

  @override
  String get feedbackSubmit => 'Pošalji';

  @override
  String get feedbackSuccess => 'Povratna informacija je poslana. Hvala!';

  @override
  String get feedbackFailed => 'Slanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get networkTitle => 'Promijeni liniju';

  @override
  String get networkAutoSelect => 'Automatski';

  @override
  String get networkManual => 'Ručno';

  @override
  String get timezoneTitle => 'Vremenska zona';

  @override
  String get timezoneAuto => 'Prati sustav';

  @override
  String get autoTranslateTitle => 'Automatski prijevod';

  @override
  String get autoTranslateEnabled => 'Uključi automatski prijevod';

  @override
  String get autoTranslateLanguage => 'Ciljni jezik';

  @override
  String get displayTitle => 'Prikaz';

  @override
  String get displayFontSize => 'Veličina fonta';

  @override
  String get displayChatBackground => 'Pozadina razgovora';

  @override
  String get displayDarkMode => 'Izgled';

  @override
  String get displayDarkModeSystem => 'Prati sustav';

  @override
  String get displayDarkModeSystemHint =>
      'Automatski mijenjaj prema postavkama sustava';

  @override
  String get displayDarkModeOff => 'Svijetlo';

  @override
  String get displayDarkModeOffHint => 'Uvijek koristi svijetlu temu';

  @override
  String get displayDarkModeOn => 'Tamno';

  @override
  String get displayDarkModeOnHint => 'Uvijek koristi tamnu temu';

  @override
  String get chatSettingsTitle => 'Razgovor';

  @override
  String get chatHistoryTitle => 'Povijest razgovora';

  @override
  String get chatHistoryClear => 'Obriši svu povijest';

  @override
  String get chatHistoryClearConfirm =>
      'Obrisati svu povijest razgovora? Ovu radnju nije moguće poništiti.';

  @override
  String get chatHistoryClearSuccess => 'Povijest razgovora je obrisana';

  @override
  String get accountSecurityTitle => 'Sigurnost računa';

  @override
  String get accountSecurityChangePassword => 'Promijeni lozinku';

  @override
  String get accountSecurityChangeMobile => 'Promijeni telefon';

  @override
  String get accountSecurityChangeEmail => 'Promijeni e-poštu';

  @override
  String get accountSecurityLoggedDevices => 'Prijavljeni uređaji';

  @override
  String get accountSecurityDeactivate => 'Deaktiviraj račun';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Svi će podaci biti trajno izbrisani nakon 7 dana. Deaktivirati račun?';

  @override
  String get loggedDevicesTitle => 'Prijavljeni uređaji';

  @override
  String get loggedDevicesCurrent => 'Ovaj uređaj';

  @override
  String get loggedDevicesRevoke => 'Odjavi se';

  @override
  String get loggedDevicesRevokeConfirm => 'Odjaviti se s ovog uređaja?';

  @override
  String get loggedDevicesRevokeSuccess => 'Odjavljeni ste s uređaja';

  @override
  String get loggedDevicesRevokeFailed => 'Nije uspjelo. Pokušajte ponovno.';

  @override
  String get loggedDevicesLastActive => 'Posljednja aktivnost';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Računalo';

  @override
  String get loggedDevicesTypeUnknown => 'Nepoznat uređaj';

  @override
  String get privacySettingsTitle => 'Privatnost';

  @override
  String get privacySearchableByMobile =>
      'Dopusti pretraživanje po telefonskom broju';

  @override
  String get privacySearchableByLppId =>
      'Dopusti pretraživanje po StartLink ID-u';

  @override
  String get privacyAllowFriendRequest => 'Dopusti zahtjeve za prijateljstvo';

  @override
  String get privacyProfileVisibility => 'Vidljivost profila';

  @override
  String get privacyEveryone => 'Svi';

  @override
  String get privacyFriendsOfFriends => 'Prijatelji prijatelja';

  @override
  String get privacyNobody => 'Nitko';

  @override
  String get privacyFriendsOnly => 'Samo prijatelji';

  @override
  String get privacySaveSuccess => 'Postavke su spremljene';

  @override
  String get privacySaveFailed => 'Spremanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get fontSizeTitle => 'Veličina fonta';

  @override
  String get fontSizeSmall => 'Malo';

  @override
  String get fontSizeNormal => 'Standardno';

  @override
  String get fontSizeLarge => 'Veliki';

  @override
  String get fontSizeExtraLarge => 'Extra veliki';

  @override
  String get fontSizePreview => 'Pregled';

  @override
  String get chatBackgroundTitle => 'Pozadina razgovora';

  @override
  String get chatBackgroundDefault => 'Zadano';

  @override
  String get chatBackgroundCustom => 'Prilagođeno';

  @override
  String get chatBackgroundReset => 'Vrati zadane postavke';

  @override
  String get termsTitle => 'Korisnički ugovor';

  @override
  String get privacyPolicyTitle => 'Politika privatnosti';

  @override
  String get recentContactsTitle => 'Nedavno';

  @override
  String get recentContactsEmpty => 'Nema nedavnih kontakata';

  @override
  String get inviteFriendsTitle => 'Pozovi prijatelje';

  @override
  String get inviteFriendsCopyLink => 'Kopiraj poveznicu pozivnice';

  @override
  String get inviteFriendsLinkCopied => 'Poveznica pozivnice je kopirana';

  @override
  String get imageViewerTitle => 'Fotografija';

  @override
  String get imageViewerSave => 'Spremi u album';

  @override
  String get imageViewerSaveSuccess => 'Spremljeno u album';

  @override
  String get imageViewerSaveFailed =>
      'Spremanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get customerServiceTitle => 'Centar za podršku';

  @override
  String get customerServiceQueue => 'U redu čekanja';

  @override
  String get customerServiceActive => 'Aktivno';

  @override
  String get customerServiceClaim => 'Prihvati';

  @override
  String get customerServiceTakeover => 'Preuzmi';

  @override
  String get customerServiceClose => 'Završi podršku';

  @override
  String get customerServiceCloseConfirm => 'Završiti ovu sesiju podrške?';

  @override
  String get customerServiceNoQueue => 'Nema sesija na čekanju';

  @override
  String get customerServiceNoActive => 'Nema aktivnih sesija';

  @override
  String get customerServiceVisitor => 'Posjetitelj';

  @override
  String get customerServiceCustomer => 'Klijent';

  @override
  String get customerServiceAssignedTo => 'Dodijeljeno';

  @override
  String get customerServiceTransferConversation => 'Prenesi razgovor';

  @override
  String get marketingToolbar => 'Marketinški alati';

  @override
  String get callIncoming => 'Dolazni poziv';

  @override
  String get callOutgoing => 'Odlazni poziv';

  @override
  String get callAccept => 'Prihvati';

  @override
  String get callReject => 'Odbij';

  @override
  String get callHangup => 'Završi';

  @override
  String get callMissed => 'Propušteni poziv';

  @override
  String get callDuration => 'Trajanje';

  @override
  String get callAudio => 'Glasovni poziv';

  @override
  String get callGeneric => 'Poziv';

  @override
  String get callVideo => 'Videopoziv';

  @override
  String get callConnecting => 'Povezivanje...';

  @override
  String get callRinging => 'Zvoni...';

  @override
  String get callEnded => 'Poziv je završen';

  @override
  String get callFailed => 'Poziv nije uspio';

  @override
  String get callRejected => 'Poziv je odbijen';

  @override
  String get callTimeout => 'Nema odgovora';

  @override
  String get callCancelled => 'Otkazano';

  @override
  String get callUnknownPeer => 'Nepoznato';

  @override
  String get callVideoInvitation => 'Poziv na videorazgovor';

  @override
  String get callAudioInvitation => 'Poziv na glasovni razgovor';

  @override
  String get callAnswerAudio => 'Odgovori glasom';

  @override
  String get callAnswerVideo => 'Odgovori videom';

  @override
  String get callViewProfile => 'Prikaži profil';

  @override
  String get callOpeningCamera => 'Pokretanje kamere...';

  @override
  String get callWaitingRemoteVideo => 'Čekanje videozapisa sugovornika...';

  @override
  String get callCameraOff => 'Kamera je isključena';

  @override
  String get callCameraOn => 'Kamera je uključena';

  @override
  String get callMicrophoneOff => 'Mikrofon je isključen';

  @override
  String get callMicrophoneOn => 'Mikrofon je uključen';

  @override
  String get callSpeakerOff => 'Zvučnik je isključen';

  @override
  String get callSpeakerOn => 'Zvučnik je uključen';

  @override
  String get callVideoPermissionFailure =>
      'Videopoziv nije pokrenut. Provjerite dopuštenja za kameru i mikrofon pa pokušajte ponovno.';

  @override
  String get callAudioPermissionFailure =>
      'Glasovni poziv nije pokrenut. Provjerite dopuštenje za mikrofon pa pokušajte ponovno.';

  @override
  String get callIncompleteIncoming =>
      'Podaci o dolaznom pozivu nisu potpuni i na poziv nije moguće odgovoriti.';

  @override
  String get callInProgress => 'Poziv je u tijeku';

  @override
  String get callCalling => 'Pozivanje...';

  @override
  String callEndedMedia(String media) {
    return '$media je završen';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media je odbijen';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media nije odgovoren';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media je otkazan';
  }

  @override
  String get callConnectionLost => 'Veza poziva je prekinuta';

  @override
  String get callAdminEnded => 'Administrator je završio poziv';

  @override
  String callFailedMedia(String media) {
    return '$media nije uspio';
  }

  @override
  String get callBusy => 'Sugovornik je zauzet';

  @override
  String callDurationValue(String duration) {
    return 'Trajanje poziva $duration';
  }

  @override
  String get callNotConnected => 'Nije povezano';

  @override
  String get callDialed => 'Odlazno';

  @override
  String get callAnswered => 'Odgovoreno';

  @override
  String get callRejectedByPeer => 'Sugovornik je odbio poziv';

  @override
  String get callRejectedBySelf => 'Odbijeno';

  @override
  String get callPeerDidNotAnswer => 'Sugovornik nije odgovorio';

  @override
  String get callMissedIncoming => 'Propušteni dolazni poziv';

  @override
  String get callPeerCancelled => 'Sugovornik je otkazao poziv';

  @override
  String get notificationNewMessageTitle => 'Nova StartLink poruka';

  @override
  String get notificationOnlineServiceTitle => 'Nova poruka korisničke podrške';

  @override
  String get notificationNewMessageBody => 'Primili ste novu poruku';

  @override
  String get notificationImagePreview => 'Poslana je slika';

  @override
  String get notificationVideoPreview => 'Poslan je videozapis';

  @override
  String get notificationVoicePreview => 'Poslana je glasovna poruka';

  @override
  String get notificationFilePreview => 'Poslana je datoteka';

  @override
  String get notificationContactPreview => 'Poslana je kartica kontakta';

  @override
  String get notificationCallLogPreview => 'Poslan je zapis poziva';

  @override
  String get notificationLocationPreview => 'Podijeljena je lokacija';

  @override
  String get notificationLinkPreview => 'Podijeljena je poveznica';

  @override
  String notificationMentionMe(String body) {
    return 'Spomenuti ste: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender vas je spomenuo/la: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Spomenuti su svi: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender je spomenuo/la sve: $body';
  }

  @override
  String get notificationSecurityTitle => 'Sigurnosno upozorenje za račun';

  @override
  String get notificationSecurityBody =>
      'Sigurnosne postavke vašeg StartLink računa su promijenjene. Provjerite ih sada.';

  @override
  String get notificationFriendAcceptedTitle =>
      'Zahtjev za prijateljstvo je prihvaćen';

  @override
  String get notificationFriendRejectedTitle =>
      'Zahtjev za prijateljstvo je odbijen';

  @override
  String get notificationFriendAcceptedBody =>
      'Druga je osoba prihvatila vaš zahtjev za prijateljstvo';

  @override
  String get notificationFriendRejectedBody =>
      'Druga je osoba odbila vaš zahtjev za prijateljstvo';

  @override
  String get notificationVideoCallTitle => 'Poziv na videorazgovor';

  @override
  String get notificationAudioCallTitle => 'Poziv na glasovni razgovor';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller vas poziva na videopoziv';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller vas poziva na glasovni poziv';
  }

  @override
  String get notificationMessageChannelName => 'Poruke';

  @override
  String get notificationMessageChannelDescription =>
      'Poruke razgovora, zapisi poziva i sustavna upozorenja';

  @override
  String get notificationCallChannelName => 'Pozivi';

  @override
  String get notificationCallChannelDescription =>
      'Obavijesti o glasovnim i videopozivima';

  @override
  String get notificationSecurityChannelName => 'Sigurnost računa';

  @override
  String get notificationSecurityChannelDescription =>
      'Upozorenja o prijavi te promjeni lozinke i broja mobitela';

  @override
  String get notificationUnknownCaller => 'Nepoznat pozivatelj';

  @override
  String get pendingJoinRequestsTitle => 'Novi zahtjevi';

  @override
  String get pendingJoinRequestsEmpty => 'Nema zahtjeva';

  @override
  String get pendingJoinRequestApprove => 'Prihvaćam';

  @override
  String get pendingJoinRequestReject => 'Odbij';

  @override
  String get pendingJoinRequestApproveSuccess => 'Odobreno';

  @override
  String get pendingJoinRequestRejectSuccess => 'Odbijeno';

  @override
  String get pendingJoinRequestFailed =>
      'Radnja nije uspjela. Pokušajte ponovno.';

  @override
  String get myCustomersTitle => 'Moji klijenti';

  @override
  String get myCustomersEmpty => 'Nema klijenata';

  @override
  String get groupListTitle => 'Grupe';

  @override
  String get groupListEmpty => 'Nema grupa';

  @override
  String get addFriendTitle => 'Dodaj kontakt';

  @override
  String get addFriendSearchHint => 'Telefon / e-pošta / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Dodaj';

  @override
  String get addFriendCannotAddSelf => 'Ne možete dodati sebe';

  @override
  String get addFriendUnsupportedUser =>
      'Ovog korisnika nije moguće dodati. Možete mu izravno poslati poruku.';

  @override
  String get addFriendMessageHint => 'Unesite poruku';

  @override
  String get addFriendSendRequest => 'Pošalji zahtjev';

  @override
  String get joinCompanyTitle => 'Pridruži se tvrtki';

  @override
  String get joinCompanyCodeHint => 'Unesite kod tvrtke';

  @override
  String get joinCompanySearchHint => 'Pretraži naziv tvrtke';

  @override
  String get joinCompanyApply => 'Zatraži pridruživanje';

  @override
  String get joinCompanyApplySuccess => 'Zahtjev je poslan';

  @override
  String get joinCompanyApplyFailed =>
      'Slanje zahtjeva nije uspjelo. Pokušajte ponovno.';

  @override
  String get joinCompanyAutoApproved => 'Automatski odobreno. Dobro došli!';

  @override
  String get joinCompanyPending => 'Zahtjev je poslan i čeka odobrenje';

  @override
  String get joinCompanyInviteCodeHint => 'Unesite kod pozivnice';

  @override
  String get joinCompanyAcceptInvite => 'Prihvati pozivnicu';

  @override
  String get joinCompanyNoResults => 'Nema pronađenih tvrtki';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count članova';
  }

  @override
  String get timezoneNameHawaii => 'Havaji';

  @override
  String get timezoneNameAlaska => 'Aljaska';

  @override
  String get timezoneNamePacificTime => 'Pacifičko vrijeme';

  @override
  String get timezoneNameMountainTime => 'Planinsko vrijeme';

  @override
  String get timezoneNameCentralTime => 'Središnje vrijeme';

  @override
  String get timezoneNameEasternTime => 'Istočno vrijeme';

  @override
  String get timezoneNameAtlanticTime => 'Atlantsko vrijeme';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azori';

  @override
  String get timezoneNameLondonDublin => 'London/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Pariz/Rim';

  @override
  String get timezoneNameCairoHelsinki => 'Kairo/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskva/Rijad';

  @override
  String get timezoneNameTehran => 'Teheran';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Baku';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karači/Taškent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/New Delhi';

  @override
  String get timezoneNameKathmandu => 'Katmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dhaka/Almati';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoj/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Peking/Šangaj/Hong Kong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokio/Seul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Salomonski Otoci';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fidži';

  @override
  String get networkSmartSelectBestRoute => 'Pametan odabir najbolje veze';

  @override
  String get networkTesting => 'Testiranje...';

  @override
  String get networkTestingShort => 'Testiranje';

  @override
  String networkLatencyMs(int ms) {
    return 'Odziv $ms ms';
  }

  @override
  String get networkConnectionMode => 'Način povezivanja';

  @override
  String get networkDirectMode => 'Izravno povezivanje';

  @override
  String get networkProxyMode => 'Povezivanje putem proxyja';

  @override
  String get networkDirectModeDesc => 'Izravno se povežite s poslužiteljem';

  @override
  String get networkProxyModeDesc => 'Povežite se putem proxy poslužitelja';

  @override
  String get networkDirectRoutes => 'Izravne veze';

  @override
  String get networkProxyRoutes => 'Proxy veze';

  @override
  String get networkTestAll => 'Testiraj sve';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Čvor u Hong Kongu';

  @override
  String get networkSingaporeNode => 'Čvor u Singapuru';

  @override
  String get networkJapanNode => 'Čvor u Japanu';

  @override
  String get networkUnitedStatesNode => 'Čvor u Sjedinjenim Državama';

  @override
  String get networkHint =>
      'Savjeti:\n• Izravno povezivanje: brže i pogodno za domaću upotrebu\n• Proxy povezivanje: stabilnije za međunarodnu komunikaciju\n• Dodirnite ikonu osvježavanja za provjeru odziva pojedine veze';

  @override
  String get teenModeTitle => 'Način za tinejdžere';

  @override
  String get teenModeStatusOn => 'Uključeno';

  @override
  String get teenModeStatusOff => 'Isključeno';

  @override
  String get teenModeStatusLoading => 'Učitavanje';

  @override
  String get teenModeUnavailable =>
      'Status načina za tinejdžere trenutačno nije dostupan';

  @override
  String get teenModeInvalidResponse =>
      'Način za tinejdžere vratio je nevaljan odgovor';

  @override
  String get teenModeEnableDescription =>
      'Pravila platforme ograničit će vrijeme korištenja i odabrane funkcije.';

  @override
  String get teenModePasscode => 'Pristupni kod';

  @override
  String get teenModeCurrentPasscode => 'Trenutačni pristupni kod';

  @override
  String get teenModeNewPasscode => 'Novi pristupni kod';

  @override
  String get teenModePasscodeHint => 'Unesite 4–6 znamenki';

  @override
  String get teenModeEnable => 'Uključi način za tinejdžere';

  @override
  String get teenModeDisable => 'Isključi način za tinejdžere';

  @override
  String get teenModeChangePasscode => 'Promijeni pristupni kod';

  @override
  String get teenModeSource => 'Uključio/la';

  @override
  String get teenModeDailyUsage => 'Današnje korištenje';

  @override
  String get teenModeRemaining => 'Preostalo vrijeme';

  @override
  String get teenModeMinutesUnit => 'Minute';

  @override
  String get teenModeUnlimited => 'Neograničeno';

  @override
  String get teenModeRequestExtension => 'Zatraži dodatno vrijeme';

  @override
  String get teenModeExtensionSubmitted =>
      'Zahtjev za dodatno vrijeme poslan je skrbniku';

  @override
  String get teenModeTimeLimitReached =>
      'Dosegnuto je današnje ograničenje korištenja';

  @override
  String get teenModeCurfewActive => 'Ovo je razdoblje ograničenog korištenja';

  @override
  String get teenModeReliefHint =>
      'I dalje možete pregledavati povijest, kontaktirati službenu podršku i prijavljivati probleme.';

  @override
  String get teenModeRestrictedNotice =>
      'Način za tinejdžere trenutačno sprječava slanje poruka';

  @override
  String get teenModeActionBlocked =>
      'Način za tinejdžere trenutačno sprječava ovu radnju';

  @override
  String get teenModeMyRequests => 'Moji zahtjevi';

  @override
  String get guardianCenterTitle => 'Centar za skrbnike';

  @override
  String get guardianRelationships => 'Skrbničke veze';

  @override
  String get guardianMinors => 'Djeca pod mojim nadzorom';

  @override
  String get guardianApprovals => 'Odobrenja na čekanju';

  @override
  String get guardianBind => 'Unesite kod za povezivanje';

  @override
  String get guardianCreateMinorCode => 'Ja sam dijete — stvori kod';

  @override
  String get guardianCreateGuardianCode => 'Ja sam skrbnik — stvori kod';

  @override
  String get guardianRelation => 'Veza';

  @override
  String get guardianPrimary => 'Glavni skrbnik';

  @override
  String get guardianCode => 'Šesteroznamenkasti kod za povezivanje';

  @override
  String get guardianCodeHint => 'Unesite kod koji je dostavila druga osoba';

  @override
  String get guardianCodeCreated =>
      'Kod je stvoren. Podijelite ga prije isteka.';

  @override
  String get guardianEmpty => 'Nema skrbničkih veza';

  @override
  String get guardianNoMinors => 'Nema djece pod nadzorom';

  @override
  String get guardianUnbind => 'Ukloni vezu';

  @override
  String get guardianExtend => 'Dodaj vrijeme djetetu';

  @override
  String get guardianPolicyTitle => 'Pravila korištenja';

  @override
  String get guardianPolicyLocked => 'Zaključano na platformi';

  @override
  String get approvalEmpty => 'Nema zahtjeva';

  @override
  String get approvalApprove => 'Prihvaćam';

  @override
  String get approvalReject => 'Odbij';

  @override
  String get approvalPending => 'Na čekanju';

  @override
  String get approvalApproved => 'Odobreno';

  @override
  String get approvalRejected => 'Odbijeno';

  @override
  String get approvalExpired => 'Istekao';

  @override
  String get approvalCancelled => 'Otkazano';

  @override
  String get approvalReplayFailed =>
      'Izvorna radnja nije uspjela. Pokušajte ponovno.';

  @override
  String get requestCancelled => 'Zahtjev je otkazan';

  @override
  String get kycTitle => 'Provjera identiteta';

  @override
  String get kycNotRequired => 'Provjera identiteta nije potrebna';

  @override
  String get kycVerified => 'Identitet je potvrđen';

  @override
  String get kycDeclared => 'Podaci za provjeru identiteta su poslani';

  @override
  String get kycPending => 'U pregledu';

  @override
  String get kycRejected => 'Provjera je odbijena';

  @override
  String get kycNone => 'Podaci za provjeru identiteta nisu poslani';

  @override
  String get kycRealName => 'Puno ime';

  @override
  String get kycIdNumber => 'Broj dokumenta';

  @override
  String get kycIdType => 'Vrsta dokumenta';

  @override
  String get kycApplicability =>
      'Unesite stvarne podatke za odabrani dokument. Prihvaćene vrste prikazane su na popisu.';

  @override
  String get kycCamera => 'Snimi fotografiju';

  @override
  String get kycGallery => 'Odaberi iz galerije';

  @override
  String get kycPhotoLimit => 'Najviše po fotografiji';

  @override
  String get kycSelectPhoto => 'Odaberite sliku';

  @override
  String get kycPhotoSelected => 'Odabrano';

  @override
  String get kycViewPhoto => 'Dodirnite za prikaz fotografije';

  @override
  String get kycReplacePhoto => 'Odaberite drugu fotografiju';

  @override
  String get kycDisclosure =>
      'Ime, broj dokumenta i fotografije dokumenta koristimo za provjeru vašeg identiteta. Bez tih podataka zahtjev nije moguće poslati, a neke ograničene funkcije mogu biti nedostupne.';

  @override
  String get kycConsent =>
      'Dajem zasebnu privolu za ovu obradu podataka o identitetu';

  @override
  String get kycConsentRequired => 'Prije slanja dajte zasebnu privolu';

  @override
  String get kycResubmitTitle => 'Ponovno pošalji podatke o identitetu';

  @override
  String get kycResubmitWarning =>
      'Ponovno slanje zamijenit će vaš zahtjev na čekanju. Nastaviti?';

  @override
  String get kycSubmitting => 'Slanje';

  @override
  String get kycSubmitFailed => 'Slanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get kycSubmitUnavailable =>
      'Podatke o identitetu trenutačno nije moguće poslati';

  @override
  String get kycResubmitNotAllowed =>
      'Ponovno slanje nakon odbijanja nije dostupno. Po potrebi kontaktirajte podršku.';

  @override
  String get kycDailyLimit =>
      'Dosegnuli ste današnje ograničenje slanja. Pokušajte sutra.';

  @override
  String get kycTypeUnavailable =>
      'Nema dostupnih vrsta dokumenata. Pokušajte kasnije.';

  @override
  String get kycNameInvalid => 'Puno ime mora imati 2–64 znaka';

  @override
  String get kycNumberRequired => 'Unesite broj dokumenta';

  @override
  String get kycFrontRequired => 'Prenesite prednju stranu dokumenta';

  @override
  String get kycBackRequired => 'Prenesite stražnju stranu dokumenta';

  @override
  String get kycPhotoTooLarge =>
      'Fotografija prelazi dopuštenu veličinu. Smanjite je i pokušajte ponovno.';

  @override
  String get kycAccountChanged =>
      'Račun ili prostor je promijenjen. Ponovno otvorite ovu stranicu.';

  @override
  String get kycPhotoInvalid => 'Odaberite valjanu sliku';

  @override
  String get kycPortraitSide => 'Strana s fotografijom';

  @override
  String get kycEmblemSide => 'Strana s grbom';

  @override
  String get kycPassportDataPage => 'Stranica putovnice s podacima';

  @override
  String get kycPassportOtherPage =>
      'Stranica putovnice za vize ili prazna stranica';

  @override
  String get kycFront => 'Prednja strana ID-a';

  @override
  String get kycBack => 'Stražnja strana ID-a';

  @override
  String get kycRequired =>
      'Prije stvaranja grupe potrebna je provjera identiteta';

  @override
  String get kycGoVerify => 'Provjeri sada';

  @override
  String get kycStatusUnknown =>
      'Status identiteta nije dostupan. Osvježite kasnije.';

  @override
  String get kycSuperseded =>
      'Noviji zahtjev zamijenio je ovaj. Provjerite najnoviji status identiteta.';

  @override
  String get kycMediaNotFound =>
      'Fotografija dokumenta nije dostupna u ovom prostoru. Prije slanja ponovno je odaberite.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Skupno slanje klijentima';

  @override
  String get officialAccountBadge => 'Službeno';

  @override
  String get officialAccountOpenConversation => 'Otvori razgovor';

  @override
  String get officialAccountJoinHint =>
      'Dodavanjem ovog računa pridružujete se tvrtki kao klijent. Odobrenje prijateljstva nije potrebno.';

  @override
  String get officialAccountJoinDisabled =>
      'Ova tvrtka ne prihvaća nove klijente. Kontaktirajte podršku.';

  @override
  String get officialAccountRemoved =>
      'Uklonjeni ste iz ove tvrtke. Zatražite novu pozivnicu od tvrtke.';

  @override
  String get officialAccountBanned => 'Vaš je račun onemogućen u ovoj tvrtki.';

  @override
  String get officialAccountUnavailable =>
      'Ovaj službeni račun trenutačno nije dostupan.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Pridruživanje tvrtki nije dopušteno u trenutačnom načinu.';

  @override
  String get officialAccountPlatformRequired =>
      'Za dodavanje ovog službenog računa koristite račun platforme.';

  @override
  String get officialAccountOpenFailed =>
      'Razgovor nije otvoren. Pokušajte ponovno.';

  @override
  String get officialAccountAccountChanged =>
      'Račun ili prostor je promijenjen. Ponovno ga otvorite.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Imenik tvrtki nije ažuran. Pokušajte uskoro ponovno.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Sinkronizacija službenog računa nije uspjela. Lokalni sadržaj i dalje je dostupan.';

  @override
  String get officialAccountInboxSyncing =>
      'Sinkronizacija poruka službenog računa';

  @override
  String get diagnosticsTitle => 'Dijagnostika';

  @override
  String get diagnosticsExplanation =>
      'Zapisi su anonimizirani i sadrže podatke o radnjama i pogreškama za ovaj račun i prostor te javne događaje pokretanja. Sadržaj razgovora i vjerodajnice nisu uključeni.';

  @override
  String get diagnosticsHour => 'Posljednji sat';

  @override
  String get diagnosticsDay => 'Posljednja 24 sata';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Dostupni događaji: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Zapisi se spremaju na ovom uređaju i dostupni su nakon ponovnog pokretanja.';

  @override
  String get diagnosticsNotPersistent =>
      'Neki zapisi nisu spremljeni. Osvježite za ponovni pokušaj.';

  @override
  String get diagnosticsExport => 'Izvezi i podijeli';

  @override
  String get diagnosticsRefresh => 'Osvježi';

  @override
  String get diagnosticsClear => 'Obriši zapise ovog prostora';

  @override
  String get diagnosticsClearConfirm =>
      'Obrisati dijagnostičke zapise ovog prostora? Povijest razgovora bit će zadržana.';

  @override
  String get diagnosticsShared =>
      'Sustavno dijeljenje je dovršeno. Provjerite datoteku u odredišnoj aplikaciji.';

  @override
  String get diagnosticsCancelled =>
      'Dijeljenje je otkazano. Možete ponovno izvesti.';

  @override
  String get diagnosticsUnconfirmed =>
      'Dijeljenje nije potvrđeno. Provjerite odredišnu aplikaciju.';

  @override
  String get diagnosticsFailed => 'Radnja nije uspjela. Pokušajte ponovno.';
}
