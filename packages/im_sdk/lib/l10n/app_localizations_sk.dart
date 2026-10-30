// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get navWorkbench => 'Pracovná plocha';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Údaje účtu sa nepodarilo načítať';

  @override
  String get startupFailureTitle => 'Spustenie zlyhalo';

  @override
  String get startupFailureMessage => 'Skontrolujte sieť a skúste to znova';

  @override
  String get privacyConsentTitle =>
      'Podmienky používania a Zásady ochrany osobných údajov';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Vitajte v aplikácii $brand. Na prihlasovanie do účtu, okamžité správy, firemnú spoluprácu, online zákaznícku podporu, oznámenia o správach a zabezpečenie potrebujeme spracúvať nevyhnutné údaje podľa Podmienok služby a Zásad ochrany osobných údajov.\n\nKým neklepnete na Súhlasím, nebudeme čítať schránku, inicializovať JPush/JCore ani SDK oznámení výrobcov zariadení ani cez tieto SDK získavať Android ID, OAID, zoznamy nainštalovaných aplikácií, MAC adresy či podobné údaje. Ak zatiaľ odmietnete, vašu voľbu uložíme; dokumenty si môžete ďalej čítať a rozhodnúť sa neskôr.\n\nPo udelení súhlasu môžu JPush/JCore a služby oznámení výrobcov zariadení na doručovanie upozornení na správy, zákaznícku podporu a prichádzajúce hovory spracúvať model zariadenia, verziu Androidu, názov balíka a verziu aplikácie, typ siete, IP adresu, Android ID, OAID, Registration ID oznámení, token oznámení výrobcu a údaje o doručení a otvorení oznámení. Vypli sme nepotrebné funkcie vrátane inteligentných oznámení, zoznamov nainštalovaných aplikácií, MAC, IMEI, IMSI, zoznamov Wi-Fi sietí, automatického prebúdzania a prepojeného spúšťania.\n\nK schránke pristupujeme len vtedy, keď použijete kopírovanie alebo prilepenie. Systémové povolenia ku kamere, mikrofónu, oznámeniam a ďalším funkciám žiadame len pri použití príslušnej funkcie. Odmietnutie jednotlivého povolenia ovplyvní len danú funkciu. Prečítajte si úplné dokumenty nižšie a sami sa rozhodnite, či súhlasíte.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Vitajte v aplikácii $brand. Na prihlasovanie do účtu, okamžité správy, firemnú spoluprácu, online zákaznícku podporu, oznámenia o správach a zabezpečenie potrebujeme spracúvať nevyhnutné údaje podľa Podmienok služby a Zásad ochrany osobných údajov.\n\nKým neklepnete na Súhlasím, nebudeme čítať schránku, inicializovať JPush/JCore, registrovať sa v službe Apple Push Notification service (APNs) ani získavať identifikátory oznámení, ako sú JPush Registration ID alebo token zariadenia APNs. Ak zatiaľ odmietnete, vašu voľbu uložíme; dokumenty si môžete ďalej čítať a rozhodnúť sa neskôr.\n\nPo udelení súhlasu môžeme na doručovanie upozornení na správy, zákaznícku podporu a prichádzajúce hovory spracúvať model iPhonu, verziu iOS, názov balíka a verziu aplikácie, typ siete, IP adresu, IDFV, JPush Registration ID, token zariadenia APNs a údaje o doručení a otvorení oznámení. JPush/JCore zabezpečuje pripojenie k službe oznámení; Apple APNs spracúva identifikátor aplikácie, token zariadenia a obsah oznámení na systémové doručovanie. Súčasná aplikácia pre iOS nepoužíva reklamné služby ani nezískava IDFA.\n\nK schránke pristupujeme len vtedy, keď použijete kopírovanie alebo prilepenie. Systémové povolenia ku kamere, mikrofónu, oznámeniam a ďalším funkciám žiadame len pri použití príslušnej funkcie. Odmietnutie jednotlivého povolenia ovplyvní len danú funkciu. Prečítajte si úplné dokumenty nižšie a sami sa rozhodnite, či súhlasíte.';
  }

  @override
  String get privacyConsentTermsLink => 'Užívateľská zmluva';

  @override
  String get privacyConsentConjunction => 'a';

  @override
  String get privacyConsentPrivacyLink => 'Zásady ochrany osobných údajov';

  @override
  String get privacyConsentDecline => 'Nesúhlasím';

  @override
  String get privacyConsentDeclinedExit =>
      'Nesúhlasili ste s Podmienkami služby a Zásadami ochrany osobných údajov. Aplikácia sa teraz zatvorí.';

  @override
  String get privacyConsentAccept => 'Súhlasím';

  @override
  String get privacyConsentRuntimeFailure =>
      'Spustenie zlyhalo. Skontrolujte sieť a skúste to znova.';

  @override
  String get privacyConsentSaveFailure =>
      'Vašu voľbu sa nepodarilo uložiť. Skúste to znova.';

  @override
  String get appUpdateRequiredTitle =>
      'Na pokračovanie je potrebná aktualizácia';

  @override
  String get appUpdateOptionalTitle => 'K dispozícii je nová verzia';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Je dostupná verzia $brand $version';
  }

  @override
  String get appUpdateLater => 'Neskôr';

  @override
  String get appUpdateNow => 'Aktualizovať teraz';

  @override
  String get appUpdateProcessing => 'Spracúva sa...';

  @override
  String get appUpdateInvalidUrl =>
      'Adresa aktualizácie je neplatná. Skúste to neskôr.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Odkaz na aktualizáciu sa nepodarilo otvoriť. Skúste to neskôr.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Sťahovanie sa prerušilo. Skontrolujte sieť a skúste to znova.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Overenie inštalačného balíka zlyhalo. Stiahnite ho znova.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'V nastaveniach systému povoľte aplikácii $brand inštalovať aktualizácie.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Systémový inštalátor sa nepodarilo otvoriť. Skontrolujte povolenia na inštaláciu.';

  @override
  String get appUpdateGenericFailure =>
      'Aktualizácia zlyhala. Skontrolujte sieť a skúste to znova.';

  @override
  String get appUpdateUnavailable =>
      'Nová verzia zatiaľ nie je na stiahnutie. Skúste to neskôr.';

  @override
  String get appUpdateCheckFailed =>
      'Aktualizácie sa nepodarilo skontrolovať. Skúste to neskôr.';

  @override
  String get appUpdateChecking => 'Kontrola';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Zrušiť';

  @override
  String get commonSave => 'Uložiť';

  @override
  String get commonEdit => 'Upraviť';

  @override
  String get commonDelete => 'Odstrániť';

  @override
  String get commonSearch => 'Hľadať';

  @override
  String get commonLoading => 'Načítava sa...';

  @override
  String get commonLoadFailed => 'Nepodarilo sa načítať';

  @override
  String get commonRetry => 'Skúsiť znova';

  @override
  String get commonEmpty => 'Žiadne údaje';

  @override
  String get commonCopy => 'Kopírovať';

  @override
  String get commonForward => 'Preposlať';

  @override
  String get commonFavorite => 'Uložiť';

  @override
  String get commonClose => 'Zavrieť';

  @override
  String get commonSend => 'Odoslať';

  @override
  String get commonDone => 'Hotovo';

  @override
  String get commonMore => 'Viac';

  @override
  String get commonSettings => 'Nastavenia';

  @override
  String get commonCopied => 'Skopírované';

  @override
  String get commonUnknown => 'Neznáme';

  @override
  String get commonNotSet => 'Nenastavené';

  @override
  String get commonUnbound => 'Nepripojené';

  @override
  String get commonViewAll => 'Zobraziť všetko';

  @override
  String get commonSubmit => 'Odoslať';

  @override
  String get commonAdd => 'Pridať';

  @override
  String get commonRemove => 'Odstrániť';

  @override
  String get commonCreate => 'Vytvoriť';

  @override
  String get commonUpdate => 'Aktualizovať';

  @override
  String get commonUpload => 'Nahrať';

  @override
  String get commonShare => 'Zdieľať';

  @override
  String get commonBlock => 'Zablokovať';

  @override
  String get commonUnblock => 'Odblokovať';

  @override
  String get commonMute => 'Stíšiť';

  @override
  String get commonUnmute => 'Zrušiť stíšenie';

  @override
  String get commonPin => 'Pripnuté';

  @override
  String get commonUnpin => 'Odopnúť';

  @override
  String get commonMarkRead => 'Označiť ako prečítané';

  @override
  String get commonMarkUnread => 'Označiť ako neprečítané';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Akcia zlyhala. Skúste to znova.';

  @override
  String get commonNetworkError => 'Chyba siete. Skontrolujte pripojenie.';

  @override
  String get navMessages => 'Správy';

  @override
  String get navContacts => 'Kontakty';

  @override
  String get navMe => 'Ja';

  @override
  String get authLoginTitle => 'Prihlásiť sa do StartLink';

  @override
  String get authTabMobile => 'Telefón';

  @override
  String get authTabEmail => 'E-mail';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Zadajte telefónne číslo';

  @override
  String get authHintEmail => 'Zadajte svoju e-mailovú adresu';

  @override
  String get authHintPassword => 'Zadajte heslo';

  @override
  String get authHintCode => 'Zadajte overovací kód';

  @override
  String get authHintLoginName => 'Zadajte StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Prihlásiť sa';

  @override
  String get authGetCode => 'Získajte kód';

  @override
  String authResendCode(int seconds) {
    return 'Znova odoslať o $seconds s';
  }

  @override
  String get authUsePassword => 'Použiť heslo';

  @override
  String get authUseCode => 'Použiť overovací kód';

  @override
  String get authAgreementPrefix => 'Prečítal som si a súhlasím s';

  @override
  String get authAgreementAnd => 'a';

  @override
  String get authTermsLink => 'Užívateľská zmluva';

  @override
  String get authPrivacyLink => 'Zásady ochrany osobných údajov';

  @override
  String get authCaptchaTitle => 'Bezpečnostné overenie';

  @override
  String get authCaptchaHint => 'Zadajte odpoveď';

  @override
  String get authCaptchaFailed =>
      'Overovaciu úlohu sa nepodarilo získať. Skúste to znova.';

  @override
  String get authErrorEmptyCode => 'Zadajte overovací kód';

  @override
  String get authErrorEmptyPassword => 'Zadajte heslo';

  @override
  String get authErrorEmptyLoginName => 'Zadajte StartLink ID';

  @override
  String get authErrorWrongCredentials => 'Nesprávny účet alebo heslo';

  @override
  String get authDeactivatingTitle => 'Zrušenie účtu';

  @override
  String get authDeactivatingContent =>
      'Váš účet je v ochrannej lehote pred zrušením (7 dní).\n\nZrušenie odvoláte klepnutím na „Odvolať zrušenie účtu”; do aplikácie vstúpite klepnutím na „Pokračovať”.';

  @override
  String get authContinueUse => 'Pokračovať';

  @override
  String get authCancelDeactivation => 'Odvolať zrušenie účtu';

  @override
  String get authDeactivationCancelled =>
      'Zrušenie bolo odvolané, účet obnovený';

  @override
  String get authDeactivationCancelFailed =>
      'Odvolanie zlyhalo. Skúste to znova.';

  @override
  String get authLogout => 'Odhlásiť sa';

  @override
  String get authLogoutConfirm => 'Naozaj sa chcete odhlásiť?';

  @override
  String get authSendingCode => 'Odosiela sa...';

  @override
  String get authCodeSent => 'Overovací kód bol úspešne odoslaný';

  @override
  String get authLoginFailed => 'Prihlásenie zlyhalo. Skúste to znova.';

  @override
  String get authRegisterFailed => 'Registrácia zlyhala. Skúste to znova.';

  @override
  String get authEnterpriseCode => 'Kód firmy';

  @override
  String get authEnterpriseCodeHint => 'Zadajte kód firmy';

  @override
  String get authPendingApproval =>
      'Registrácia bola úspešná. Vaša žiadosť o pripojenie k firme bola odoslaná a čaká na schválenie.';

  @override
  String get authNoAccount => 'Nemáte účet?';

  @override
  String get authRegisterNow => 'Zaregistrovať sa';

  @override
  String get authCountryPickerTitle => 'Vyberte krajinu/oblasť';

  @override
  String get authCountrySearchHint => 'Hľadať krajinu/oblasť';

  @override
  String get authCountryChinaMainland => 'Pevninská Čína';

  @override
  String get authCountryHongKong => 'Hongkong, Čína';

  @override
  String get authCountryMacau => 'Macao, Čína';

  @override
  String get authCountryTaiwan => 'Taiwan, Čína';

  @override
  String get authCountryUnitedStates => 'Spojené štáty';

  @override
  String get authCountryUnitedKingdom => 'Spojené kráľovstvo';

  @override
  String get authCountryJapan => 'Japonsko';

  @override
  String get authCountrySouthKorea => 'Južná Kórea';

  @override
  String get authCountrySingapore => 'Singapur';

  @override
  String get authCountryMalaysia => 'Malajzia';

  @override
  String get authCountryAustralia => 'Austrália';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Nemecko';

  @override
  String get authCountryFrance => 'Francúzsko';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Thajsko';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonézia';

  @override
  String get authCountryPhilippines => 'Filipíny';

  @override
  String get authQuickLoginTitle => 'Rýchle prihlásenie';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Prebieha prihlasovanie. Čakajte.';

  @override
  String get authRoleOwner => 'Vlastník';

  @override
  String get authRoleAdministrator => 'Správca';

  @override
  String get authRoleCustomerService => 'Zákaznícka podpora';

  @override
  String get authRoleTechnicalSupport => 'Technická podpora';

  @override
  String get authRoleEmployee => 'Zamestnanec';

  @override
  String get authRoleMember => 'Člen';

  @override
  String get authRoleEnterpriseCustomer => 'Firemný zákazník';

  @override
  String get authUnavailablePrefix => 'Nedostupné · ';

  @override
  String get authUnassignedService => 'Bez prideleného operátora';

  @override
  String authAssignedService(String staff) {
    return 'Pridelené: $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Zákazník · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Zamestnanec · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count používateľov';
  }

  @override
  String get authMetaPhone => 'Telefón';

  @override
  String get authMetaIdentity => 'Identita';

  @override
  String get authRegisterTitle => 'Zaregistrovať sa';

  @override
  String get authNickname => 'Prezývka';

  @override
  String get authNicknameHint => 'Nastavte prezývku';

  @override
  String get authPassword => 'Heslo';

  @override
  String get authPasswordSetHint => 'Nastavte heslo (aspoň 6 znakov)';

  @override
  String get authConfirmPassword => 'Potvrďte heslo';

  @override
  String get authConfirmPasswordHint => 'Zadajte heslo znova';

  @override
  String get authVerificationCode => 'Overovací kód';

  @override
  String get authRegisterAndLogin => 'Zaregistrovať sa a prihlásiť';

  @override
  String get authHaveAccount => 'Už máte účet?';

  @override
  String get authGoLogin => 'Prihlásiť sa';

  @override
  String get authEmailVerificationUnavailable =>
      'Overenie e-mailom nie je dostupné. Zaregistrujte sa mobilným číslom.';

  @override
  String get authSmsVerificationUnavailable =>
      'Overenie SMS nie je dostupné. Zaregistrujte sa e-mailom.';

  @override
  String get authSendFailed => 'Odoslanie zlyhalo. Skúste to znova.';

  @override
  String get authErrorEmptyNickname => 'Zadajte prezývku';

  @override
  String get authErrorInvalidMobile => 'Zadajte platné mobilné číslo';

  @override
  String get authErrorInvalidEmail => 'Zadajte platnú e-mailovú adresu';

  @override
  String get authErrorPasswordTooShort => 'Heslo musí obsahovať aspoň 6 znakov';

  @override
  String get authErrorPasswordMismatch => 'Heslá sa nezhodujú';

  @override
  String get authErrorVerificationRequired =>
      'Najprv si vyžiadajte a zadajte overovací kód';

  @override
  String get authRegisterErrorTitle => 'Registrácia zlyhala';

  @override
  String get authGotIt => 'Rozumiem';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Firma „$code” sa nenašla. Skontrolujte kód firmy.';
  }

  @override
  String get authTenantSearchFailed => 'Vyhľadávanie zlyhalo. Skúste to znova.';

  @override
  String get authInvitationInvalid =>
      'Kód pozvánky je neplatný. Skontrolujte ho a skúste to znova.';

  @override
  String get authCollapseJoin => 'Skryť údaje o pripojení';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Platná pozvánka: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Nájdená firma: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Vyberte organizáciu';

  @override
  String get authNoOrganization => 'Žiadne dostupné organizácie';

  @override
  String get authNoOrganizationHint =>
      'Požiadajte správcu o pozvanie do organizácie';

  @override
  String get authPersonalSpace => 'Osobný priestor';

  @override
  String get authPersonalSpaceSubtitle =>
      'Chaty s priateľmi a osobné obľúbené položky';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Identitu priestoru sa nepodarilo overiť. Skúste to znova.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Osobný priestor sa nepodarilo obnoviť. Skúste to znova.';

  @override
  String get authJoinEnterpriseFailed =>
      'K firme sa nepodarilo pripojiť. Skúste to neskôr.';

  @override
  String get homeTitle => 'Správy';

  @override
  String get homeGatewayConnectingTitle => 'Pripája sa';

  @override
  String get homePersonalSpace => 'Osobné';

  @override
  String get homeOfficialService => 'Oficiálna podpora';

  @override
  String get homeSwitchSpace => 'Prepnúť priestor';

  @override
  String get homeSpaceSubtitle => 'Osobný · Firemný';

  @override
  String get homeJoinEnterprise => 'Pripojiť sa k firme';

  @override
  String get homeCreateGroup => 'Nová skupina';

  @override
  String get homeAddFriend => 'Pridať kontakt';

  @override
  String get homeScan => 'Skenovať';

  @override
  String get homeJoinNewSpace => 'Pripojiť sa k novému priestoru';

  @override
  String get homeSearchConversation => 'Hľadať';

  @override
  String get homeNoMessages => 'Žiadne správy';

  @override
  String get homeDeleteConversation => 'Odstrániť chat';

  @override
  String get homeDeleteConversationConfirm =>
      'Odstrániť tento chat? História chatu sa vymaže.';

  @override
  String get homePersonalNote => 'Ja (osobné poznámky)';

  @override
  String get homeWorkNote => 'Ja (pracovné poznámky)';

  @override
  String homeConversationCount(int count) {
    return '$count chatov';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count neprečítaných';
  }

  @override
  String get chatInputHint => 'Napíšte správu...';

  @override
  String get chatVoiceHint => 'Podržaním hovorte';

  @override
  String get chatVoiceRelease => 'Uvoľnením odošlete';

  @override
  String get chatVoiceCancel => 'Potiahnutím nahor zrušíte';

  @override
  String get chatMenuCopy => 'Kopírovať';

  @override
  String get chatMenuForward => 'Preposlať';

  @override
  String get chatMenuRecall => 'Odvolať správu';

  @override
  String get chatMenuDelete => 'Odstrániť';

  @override
  String get chatMenuFavorite => 'Uložiť';

  @override
  String get chatMenuReply => 'Odpovedať';

  @override
  String get chatMenuMultiSelect => 'Vybrať';

  @override
  String get chatMenuTranslate => 'Preložiť';

  @override
  String get chatMenuVoiceToText => 'Previesť na text';

  @override
  String get chatMenuTextToSpeech => 'Prečítať nahlas';

  @override
  String get chatStatusRecalled => 'Správa bola odvolaná';

  @override
  String get chatRecallSuccess => 'Odvolané';

  @override
  String get chatRecallFailed => 'Odvolanie zlyhalo';

  @override
  String get chatRecallTimeout => 'Správy staršie ako 2 minúty nemožno odvolať';

  @override
  String get chatTranslateFailed => 'Preklad zlyhal. Skúste to znova.';

  @override
  String get chatTranslateNotConfigured => 'Prekladová služba nie je dostupná';

  @override
  String get chatVoiceToTextFailed => 'Prevod zlyhal. Skúste to znova.';

  @override
  String get chatTextToSpeechFailed =>
      'Čítanie nahlas zlyhalo. Skúste to znova.';

  @override
  String get chatVoiceToText => 'Previesť';

  @override
  String get chatForwardSuccess => 'Preposlané';

  @override
  String get chatForwardFailed => 'Preposlanie zlyhalo. Skúste to znova.';

  @override
  String get chatNoConversations => 'Žiadne chaty na preposlanie';

  @override
  String get chatSendFailed => 'Odoslanie zlyhalo';

  @override
  String get chatResend => 'Odoslať znova';

  @override
  String get chatNotFriend => 'Nie je v zozname kontaktov';

  @override
  String get chatNotFriendHint =>
      'Ešte nie ste kontakty. Správy nemožno odosielať.';

  @override
  String get chatMutedHint => 'Všetci členovia sú stíšení';

  @override
  String get chatFileUploadFailed =>
      'Nahratie súboru zlyhalo. Skúste to znova.';

  @override
  String get chatFileStatusNotDownloaded => 'Nestiahnuté';

  @override
  String get chatFileStatusDownloaded => 'Stiahnuté';

  @override
  String get chatFileStatusUploading => 'Nahráva sa';

  @override
  String get chatFileStatusUploadFailed => 'Nahrávanie zlyhalo';

  @override
  String get chatCardSendFailed => 'Odoslanie vizitky zlyhalo';

  @override
  String get chatFavoriteSuccess => 'Uložené';

  @override
  String get chatFavoriteFailed => 'Pridanie medzi obľúbené zlyhalo';

  @override
  String get chatLoadFailed => 'Nepodarilo sa načítať';

  @override
  String get chatImageMessage => '[Obrázok]';

  @override
  String get chatVoiceMessage => '[Hlasová správa]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Súbor]';

  @override
  String get chatLocationMessage => '[Poloha]';

  @override
  String get chatContactCardMessage => '[Kontakt]';

  @override
  String get chatCallLogMessage => '[Hovor]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Prečítalo: $count';
  }

  @override
  String get chatUnread => 'Neprečítané';

  @override
  String get chatRecalledSelf => 'Odvolali ste správu';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender odvolal(a) správu';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Preklad: $translation';
  }

  @override
  String get chatMessageDeleted => 'Správa odstránená';

  @override
  String get chatPeer => 'Iné';

  @override
  String get chatSelf => 'Ja';

  @override
  String get chatGenericMessage => '[Správa]';

  @override
  String get chatVoiceHideText => 'Skryť text';

  @override
  String get chatVoiceShowText => 'Previesť na text';

  @override
  String get chatFileDefaultName => 'Súbor';

  @override
  String get chatContactDefaultName => 'Kontakt';

  @override
  String get chatContactCardTitle => 'Vizitka';

  @override
  String get chatCallMissed => 'Zmeškaný';

  @override
  String get chatCallCancelled => 'Zrušené';

  @override
  String get chatCallRejected => 'Odmietnuté';

  @override
  String get chatCallDisconnected => 'Odpojené';

  @override
  String get chatCallEnded => 'Hovor ukončený';

  @override
  String get chatCallFailed => 'Hovor zlyhal';

  @override
  String chatCallDuration(String duration) {
    return 'Trvanie $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videohovor';

  @override
  String get chatVoiceCallTitle => 'Hlasový hovor';

  @override
  String get chatToolPhotos => 'Fotky';

  @override
  String get chatToolCamera => 'Fotoaparát';

  @override
  String get chatToolFile => 'Súbor';

  @override
  String get chatToolLocation => 'Poloha';

  @override
  String get chatToolContactCard => 'Kontakt';

  @override
  String get chatToolVoiceCall => 'Hlasový hovor';

  @override
  String get chatToolVideoCall => 'Videohovor';

  @override
  String get chatToolFavorites => 'Obľúbené';

  @override
  String get chatToolTranslate => 'Preložiť';

  @override
  String get chatTranslationChooseLanguage => 'Vyberte jazyk prekladu';

  @override
  String get chatTranslationEnterText => 'Najprv zadajte text';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Preklad nie je dostupný pre správy so zmienkami';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Preklad nie je dostupný pri úprave naplánovanej správy';

  @override
  String get chatTranslationFailed => 'Preklad zlyhal. Skúste to znova.';

  @override
  String get chatTranslationEmpty =>
      'Nebol vrátený žiadny preklad. Skúste to znova.';

  @override
  String get chatTranslationTranslating => 'Prekladá sa…';

  @override
  String get chatTranslationSend => 'Odoslať preklad';

  @override
  String get chatTranslationSending => 'Odosiela sa…';

  @override
  String get chatTranslationExpand => 'Zobraziť viac';

  @override
  String get chatTranslationCollapse => 'Zobraziť menej';

  @override
  String get chatFileTooLarge => 'Súbor prekračuje limit (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Písať môže len vlastník alebo vybraní členovia.';

  @override
  String get chatImageUploadUnsupported =>
      'Nahratie obrázka zlyhalo. Podpora servera zatiaľ nie je dostupná.';

  @override
  String get chatFavoriteLongPressHint =>
      'Podržaním správy ju pridáte medzi obľúbené';

  @override
  String chatSelectedCount(int count) {
    return 'Vybraté: $count';
  }

  @override
  String get chatLocationSheetTitle => 'Odoslať polohu';

  @override
  String get chatLocationNameLabel => 'Názov miesta';

  @override
  String get chatLocationNameHint => 'napr. kancelária, adresa zákazníka';

  @override
  String get chatLocationAddressLabel => 'Adresa';

  @override
  String get chatLocationOptionalHint => 'Nepovinné';

  @override
  String get chatLocationLatitudeLabel => 'Zemepisná šírka';

  @override
  String get chatLocationLatitudeHint => '-90 až 90';

  @override
  String get chatLocationLongitudeLabel => 'Zemepisná dĺžka';

  @override
  String get chatLocationLongitudeHint => '-180 až 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Zadajte: $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return 'Hodnota $label je mimo rozsahu';
  }

  @override
  String get chatLocationDefaultTitle => 'Poloha';

  @override
  String get chatMutedFullNotice =>
      'Táto skupina je stíšená. Písať môže len vlastník alebo vybraní členovia.';

  @override
  String get chatNotFriendSendBlocked =>
      'Už nie ste priatelia a nemôžete posielať správy';

  @override
  String get chatPersonalNotesTitle => 'Osobné poznámky';

  @override
  String get chatWorkNotesTitle => 'Pracovné poznámky';

  @override
  String get chatPersonalNotesDescription =>
      'Zapisujte si tu myšlienky a ukladajte dôležité údaje\nSynchronizácia medzi zariadeniami umožňuje prístup kedykoľvek';

  @override
  String get chatWorkNotesDescription =>
      'Zapisujte si tu pracovné úlohy a ukladajte materiály\nTímové priestory zostávajú oddelené a bezpečné';

  @override
  String get chatNoMessages => 'Žiadne správy';

  @override
  String chatReplyTo(String sender) {
    return 'Odpovedať používateľovi $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return 'Funkcia $feature bude čoskoro dostupná';
  }

  @override
  String get chatForwardSelectTitle => 'Vyberte chat';

  @override
  String get chatContactSelectTitle => 'Vyberte kontakt';

  @override
  String get chatNoContacts => 'Žiadne kontakty';

  @override
  String get contactsTitle => 'Kontakty';

  @override
  String get contactsSearch => 'Hľadať kontakty';

  @override
  String get contactsNewFriends => 'Noví priatelia';

  @override
  String get contactsGroups => 'Skupiny';

  @override
  String get contactsFavorites => 'Obľúbené';

  @override
  String get contactsRecent => 'Nedávne';

  @override
  String get contactsOrganization => 'Organizácia';

  @override
  String get contactsAnnouncement => 'Oznámenia';

  @override
  String get contactsNewApplications => 'Nové žiadosti';

  @override
  String get contactsCustomerGroups => 'Skupiny zákazníkov';

  @override
  String get contactsAllCustomers => 'Všetci zákazníci';

  @override
  String get contactsMyCustomers => 'Moji zákazníci';

  @override
  String get contactsViewAll => 'Zobraziť všetko';

  @override
  String get contactsMyContacts => 'Moje kontakty';

  @override
  String get contactsMyAdvisor => 'Môj poradca';

  @override
  String get contactsNoAdvisor => 'Poradca zatiaľ nebol pridelený';

  @override
  String get contactsAdvisorLoading => 'Načítava sa...';

  @override
  String get contactsNavigateFailed =>
      'Prechod na stránku zlyhal. Skúste to znova.';

  @override
  String get contactsEmpty => 'Žiadne kontakty';

  @override
  String get contactsNoAnnouncement => 'Žiadne oznámenia';

  @override
  String get contactsOfficialBadge => 'Oficiálne';

  @override
  String get contactsCustomerBadge => 'Zákazník';

  @override
  String get contactsEmptyCustomers => 'Žiadni zákazníci';

  @override
  String get myTitle => 'Ja';

  @override
  String get myEnterpriseInfo => 'Údaje firmy';

  @override
  String get myEnterpriseManage => 'Správa firmy';

  @override
  String get myQrCode => 'QR kód';

  @override
  String get myFavorites => 'Obľúbené';

  @override
  String get myLanguage => 'Jazyk';

  @override
  String get myTimezone => 'Časové pásmo';

  @override
  String get myAutoTranslate => 'Automatický preklad';

  @override
  String get myNetworkSwitch => 'Prepnúť linku';

  @override
  String get mySettings => 'Nastavenia';

  @override
  String get myLogout => 'Odhlásiť sa';

  @override
  String get myLogoutConfirm => 'Naozaj sa chcete odhlásiť?';

  @override
  String get myLeaveEnterprise => 'Opustiť firmu';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Naozaj chcete opustiť túto firmu? Stratíte prístup k firemným údajom.';

  @override
  String get myLeaveEnterpriseSuccess => 'Opustili ste firmu';

  @override
  String get myLeaveEnterpriseFailed => 'Opustenie zlyhalo. Skúste to znova.';

  @override
  String get myLppIdCopied => 'StartLink ID skopírované';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count kontaktov';
  }

  @override
  String get myAutoSelect => 'Automaticky';

  @override
  String get myPresenceStatus => 'Dostupnosť';

  @override
  String get myPresenceStatusTitle => 'Nastaviť dostupnosť';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Zaneprázdnený/á';

  @override
  String get myPresenceAway => 'Preč';

  @override
  String get myPresenceInvisible => 'Neviditeľný/á';

  @override
  String get profileTitle => 'Môj profil';

  @override
  String get profileName => 'Meno';

  @override
  String get profileGender => 'Pohlavie';

  @override
  String get profileBirthday => 'Narodeniny';

  @override
  String get profileRegion => 'Oblasť';

  @override
  String get profileSignature => 'O mne';

  @override
  String get profileSignatureHint => 'Napíšte niečo o sebe';

  @override
  String get profileTapTapText => 'Poklepanie';

  @override
  String get profileTapTapHint => 'Text pri poklepaní (najviac 20 znakov)';

  @override
  String get profileAccountSection => 'Účet';

  @override
  String get profileBasicSection => 'Základné údaje';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Nenastavené';

  @override
  String get profileMobile => 'Telefón';

  @override
  String get profileMobileUnbound => 'Nepripojené';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileEmailUnbound => 'Nepripojené';

  @override
  String get profileQrCode => 'Môj QR kód';

  @override
  String get profileChangePassword => 'Zmeniť heslo';

  @override
  String get profileGenderMale => 'Muž';

  @override
  String get profileGenderFemale => 'Žena';

  @override
  String get profileGenderOther => 'Iné';

  @override
  String get profileGenderUnset => 'Nenastavené';

  @override
  String get profileSaveFailed => 'Uloženie zlyhalo. Skúste to znova.';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink ID možno zmeniť len raz. Vyberajte starostlivo.';

  @override
  String get profileLppIdChangeFailed =>
      'Zmena zlyhala (StartLink ID možno zmeniť len raz)';

  @override
  String get profileChangePasswordOld => 'Aktuálne heslo';

  @override
  String get profileChangePasswordNew => 'Nové heslo';

  @override
  String get profileChangePasswordConfirm => 'Potvrdiť nové heslo';

  @override
  String get profileChangePasswordMismatch => 'Heslá sa nezhodujú';

  @override
  String get profileChangePasswordSuccess =>
      'Heslo bolo zmenené. Prihláste sa znova.';

  @override
  String get profileChangePasswordFailed =>
      'Zmena hesla zlyhala. Skúste to znova.';

  @override
  String get settingsTitle => 'Nastavenia';

  @override
  String get settingsSectionEnterprise => 'Firma';

  @override
  String get settingsSectionAccount => 'Účet';

  @override
  String get settingsSectionGeneral => 'Všeobecné';

  @override
  String get settingsSectionFeatures => 'Funkcie';

  @override
  String get settingsSectionAbout => 'O aplikácii';

  @override
  String get settingsEnterpriseInfo => 'Údaje firmy';

  @override
  String get settingsProfile => 'Môj profil';

  @override
  String get settingsAccountSecurity => 'Zabezpečenie účtu';

  @override
  String get settingsNotification => 'Oznámenia';

  @override
  String get settingsDisplay => 'Zobrazenie';

  @override
  String get settingsFriendPrivacy => 'Súkromie';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'História chatov';

  @override
  String get settingsAbout => 'O aplikácii StartLink';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsTimezone => 'Časové pásmo';

  @override
  String get settingsAutoTranslate => 'Automatický preklad';

  @override
  String get settingsNetworkSwitch => 'Prepnúť linku';

  @override
  String get enterpriseInfoTitle => 'Údaje firmy';

  @override
  String get enterpriseName => 'Meno';

  @override
  String get enterpriseDescription => 'Popis';

  @override
  String get enterpriseUpdateSuccess => 'Úspešne aktualizované';

  @override
  String get enterpriseUpdateFailed => 'Aktualizácia zlyhala. Skúste to znova.';

  @override
  String get enterpriseLeave => 'Opustiť firmu';

  @override
  String get enterpriseLeaveConfirm => 'Naozaj chcete opustiť túto firmu?';

  @override
  String get enterpriseLeaveSuccess => 'Opustili ste firmu';

  @override
  String get enterpriseLeaveFailed => 'Opustenie zlyhalo. Skúste to znova.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Vlastník nemôže firmu priamo opustiť. Najprv preveďte vlastníctvo.';

  @override
  String get enterpriseMemberCount => 'Členovia';

  @override
  String get enterpriseCreatedAt => 'Vytvorené';

  @override
  String get enterpriseCode => 'Kód firmy';

  @override
  String get enterpriseInviteMembers => 'Pozvať členov';

  @override
  String get enterpriseCopyInviteCode => 'Skopírovať kód pozvánky';

  @override
  String get enterpriseInviteCodeCopied => 'Kód pozvánky skopírovaný';

  @override
  String get groupCreateTitle => 'Nová skupina';

  @override
  String get groupNameHint => 'Zadajte názov skupiny';

  @override
  String get groupCreateSuccess => 'Skupina vytvorená';

  @override
  String get groupCreateFailed => 'Vytvorenie skupiny zlyhalo';

  @override
  String get groupSettings => 'Nastavenia skupiny';

  @override
  String get groupName => 'Názov skupiny';

  @override
  String get groupAvatar => 'Obrázok skupiny';

  @override
  String get groupAnnouncement => 'Oznámenie';

  @override
  String get groupMembers => 'Členovia';

  @override
  String get groupAddMember => 'Pridať členov';

  @override
  String get groupRemoveMember => 'Odobrať člena';

  @override
  String get groupRemoveMemberConfirm => 'Odobrať tohto člena?';

  @override
  String get groupSetAdmin => 'Vymenovať za správcu';

  @override
  String get groupRemoveAdmin => 'Odobrať oprávnenia správcu';

  @override
  String get groupTransferOwner => 'Previesť vlastníctvo';

  @override
  String get groupTransferOwnerConfirm =>
      'Previesť vlastníctvo skupiny tomuto členovi?';

  @override
  String get groupTransferOwnerSuccess => 'Vlastníctvo prevedené';

  @override
  String get groupTransferOwnerFailed => 'Prevod zlyhal. Skúste to znova.';

  @override
  String get groupLeave => 'Opustiť skupinu';

  @override
  String get groupLeaveConfirm => 'Opustiť túto skupinu?';

  @override
  String get groupLeaveSuccess => 'Opustili ste skupinu';

  @override
  String get groupLeaveFailed => 'Opustenie zlyhalo. Skúste to znova.';

  @override
  String get groupDissolve => 'Rozpustiť skupinu';

  @override
  String get groupDissolveConfirm =>
      'Rozpustiť túto skupinu? Všetci členovia budú odobratí.';

  @override
  String get groupDissolveSuccess => 'Skupina rozpustená';

  @override
  String get groupDissolveFailed => 'Rozpustenie zlyhalo. Skúste to znova.';

  @override
  String get groupQrCode => 'QR kód skupiny';

  @override
  String get groupMuteAll => 'Stíšiť všetkých';

  @override
  String get groupMuteAllOn => 'Zapnúť stíšenie všetkých';

  @override
  String get groupMuteAllOff => 'Vypnúť stíšenie všetkých';

  @override
  String get groupAllowMemberInvite => 'Povoliť členom pozývať ďalších';

  @override
  String get groupAllowMemberModifyTitle =>
      'Povoliť členom meniť názov skupiny';

  @override
  String get groupAllowMemberAtAll => 'Povoliť členom zmieniť všetkých';

  @override
  String get groupAllowMemberViewMemberList =>
      'Povoliť členom zobraziť zoznam členov';

  @override
  String get groupAllowQrCodeJoin => 'Povoliť pripojenie QR kódom';

  @override
  String get groupRequireApproval => 'Vyžadovať schválenie pripojenia';

  @override
  String get groupAllowMemberAddFriend => 'Povoliť členom vzájomné pridávanie';

  @override
  String get groupRoleOwner => 'Vlastník';

  @override
  String get groupRoleAdmin => 'Správca';

  @override
  String get groupRoleMember => 'Člen';

  @override
  String get groupNoMembers => 'Žiadni členovia';

  @override
  String get groupNoAnnouncements => 'Žiadne oznámenia';

  @override
  String get groupCreateAnnouncement => 'Zverejniť oznámenie';

  @override
  String get groupEditAnnouncement => 'Upraviť oznámenie';

  @override
  String get groupDeleteAnnouncement => 'Odstrániť oznámenie';

  @override
  String get groupDeleteAnnouncementConfirm => 'Odstrániť toto oznámenie?';

  @override
  String get groupAnnouncementTitle => 'Názov';

  @override
  String get groupAnnouncementContent => 'Obsah';

  @override
  String get groupAnnouncementPin => 'Pripnúť oznámenie';

  @override
  String groupMemberCount(int count) {
    return '$count členov';
  }

  @override
  String groupSelectedCount(int count) {
    return 'Vybraté: $count';
  }

  @override
  String get groupJoinRequestApprove => 'Súhlasím';

  @override
  String get groupJoinRequestReject => 'Odmietnuť';

  @override
  String get groupJoinRequests => 'Žiadosti o pripojenie';

  @override
  String get groupNoJoinRequests => 'Žiadne žiadosti o pripojenie';

  @override
  String get groupReadReceipts => 'Potvrdenia o prečítaní';

  @override
  String groupReadCount(int count) {
    return 'Prečítané: $count';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count neprečítaných';
  }

  @override
  String get friendAddTitle => 'Pridať kontakt';

  @override
  String get friendSearchHint => 'Telefón / e-mail / StartLink ID';

  @override
  String get friendRequestSent => 'Žiadosť o priateľstvo odoslaná';

  @override
  String get friendRequestFailed => 'Odoslanie zlyhalo. Skúste to znova.';

  @override
  String get friendAlreadyFriend => 'Už ste kontakty';

  @override
  String get friendNewFriendsTitle => 'Noví priatelia';

  @override
  String get friendNoRequests => 'Žiadne žiadosti o priateľstvo';

  @override
  String get friendAccept => 'Prijať';

  @override
  String get friendReject => 'Odmietnuť';

  @override
  String get friendAccepted => 'Prijaté';

  @override
  String get friendRejected => 'Odmietnuté';

  @override
  String get friendDeleteConfirm => 'Odobrať tento kontakt?';

  @override
  String get friendDeleteSuccess => 'Kontakt odobratý';

  @override
  String get friendDeleteFailed => 'Odobratie zlyhalo. Skúste to znova.';

  @override
  String get friendRemarkName => 'Prezývka';

  @override
  String get friendGroupName => 'Skupina';

  @override
  String get friendSendMessage => 'Správa';

  @override
  String get friendMatchTypeLppId => 'Nájdené podľa StartLink ID';

  @override
  String get friendMatchTypeMobile => 'Nájdené podľa telefónu';

  @override
  String get friendMatchTypeEmail => 'Nájdené podľa e-mailu';

  @override
  String get friendSearchEmpty => 'Žiadni používatelia sa nenašli';

  @override
  String get friendAddMessage => 'Chcem si vás pridať do kontaktov';

  @override
  String get friendBlockConfirm => 'Zablokovať tohto používateľa?';

  @override
  String get friendUnblockConfirm => 'Odblokovať tohto používateľa?';

  @override
  String get friendBlockSuccess => 'Zablokované';

  @override
  String get friendUnblockSuccess => 'Odblokované';

  @override
  String get profilePageTitle => 'Osobné údaje';

  @override
  String get profilePageSendMessage => 'Správa';

  @override
  String get profilePageAddFriend => 'Pridať priateľa';

  @override
  String get profilePageAlreadyFriend => 'Už ste priatelia';

  @override
  String get profilePageBlocked => 'Zablokované';

  @override
  String get profilePageBlock => 'Zablokovať';

  @override
  String get profilePageUnblock => 'Odblokovať';

  @override
  String get profilePageHidden => 'Tento používateľ skryl svoj profil';

  @override
  String get profilePageFriendsOnly =>
      'Tento používateľ zobrazuje profil len priateľom';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Poznámky';

  @override
  String get profilePageEditRemark => 'Upraviť prezývku';

  @override
  String get profilePageSaveRemarkSuccess => 'Prezývka uložená';

  @override
  String get profilePageSaveRemarkFailed =>
      'Uloženie zlyhalo. Skúste to znova.';

  @override
  String get searchTitle => 'Hľadať';

  @override
  String get searchHint => 'Hľadať podľa telefónu, e-mailu alebo StartLink ID';

  @override
  String get searchNoResults => 'Žiadne výsledky';

  @override
  String get searchMessages => 'Správy';

  @override
  String get searchUsers => 'Používatelia';

  @override
  String get searchFailed => 'Vyhľadávanie zlyhalo. Skúste to znova.';

  @override
  String get scanTitle => 'Skenovať';

  @override
  String get scanFailed => 'Rozpoznávanie zlyhalo. Skúste to znova.';

  @override
  String get scanInvalidQrCode => 'Neplatný QR kód';

  @override
  String get scanFlashOn => 'Zapnúť svietidlo';

  @override
  String get scanFlashOff => 'Vypnúť svietidlo';

  @override
  String get scanAlbum => 'Vybrať z albumu';

  @override
  String get favoritesTitle => 'Obľúbené';

  @override
  String get favoritesEmpty => 'Zatiaľ nič neuložené';

  @override
  String get favoritesAll => 'Všetko';

  @override
  String get favoritesText => 'Text';

  @override
  String get favoritesImage => 'Obrázky';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Hlasové správy';

  @override
  String get favoritesFile => 'Súbory';

  @override
  String get favoritesOther => 'Iné';

  @override
  String get favoritesDeleteConfirm => 'Odobrať z obľúbených?';

  @override
  String get favoritesDeleteSuccess => 'Odstránené z uložených';

  @override
  String get favoritesDeleteFailed => 'Odobratie zlyhalo';

  @override
  String get favoritesOriginalRecalled => 'Správa bola odvolaná';

  @override
  String get favoritesViewOriginal => 'Zobraziť originál';

  @override
  String get favoritesSearchHint => 'Hľadať v obľúbených';

  @override
  String get favoritesNoResults => 'Žiadne zodpovedajúce obľúbené položky';

  @override
  String get noticeTitle => 'Oznámenia';

  @override
  String get noticeEmpty => 'Žiadne oznámenia';

  @override
  String get noticeDetail => 'Podrobnosti oznámenia';

  @override
  String get noticePublishedAt => 'Zverejnené';

  @override
  String get noticePriorityNormal => 'Normálny';

  @override
  String get noticePriorityImportant => 'Dôležité';

  @override
  String get noticePriorityUrgent => 'Naliehavé';

  @override
  String get organizationTitle => 'Organizácia';

  @override
  String get organizationEmpty => 'Žiadne údaje o oddelení';

  @override
  String get organizationMembers => 'Členovia';

  @override
  String get organizationDepartment => 'Oddelenie';

  @override
  String get organizationPosition => 'Pozícia';

  @override
  String get organizationLeader => 'Vedúci';

  @override
  String get qrCodeTitle => 'Môj QR kód';

  @override
  String get qrCodeSave => 'Uložiť do alba';

  @override
  String get qrCodeShare => 'Zdieľať';

  @override
  String get qrCodeSaveSuccess => 'Uložené do albumu';

  @override
  String get qrCodeSaveFailed => 'Uloženie zlyhalo. Skúste to znova.';

  @override
  String get qrCodeRefresh => 'Obnoviť QR kód';

  @override
  String get qrCodeExpired => 'QR kód vypršal. Obnovte ho.';

  @override
  String get qrCodeScanToAdd => 'Naskenujte na pridanie do kontaktov';

  @override
  String get spacePersonal => 'Osobné';

  @override
  String get spaceEnterprise => 'Firma';

  @override
  String get spaceJoinByCode => 'Pripojiť sa kódom firmy';

  @override
  String get spaceJoinByInvite => 'Pripojiť sa kódom pozvánky';

  @override
  String get spaceEnterCode => 'Zadajte kód firmy';

  @override
  String get spaceEnterInviteCode => 'Zadajte kód pozvánky';

  @override
  String get spaceSearchEnterprise => 'Hľadať firmu';

  @override
  String get spaceJoinRequestSent => 'Žiadosť odoslaná, čaká na schválenie';

  @override
  String get spaceJoinRequestPending => 'Čaká na schválenie';

  @override
  String get spaceJoinRequestApproved => 'Žiadosť schválená';

  @override
  String get spaceJoinRequestRejected => 'Žiadosť zamietnutá';

  @override
  String get spaceAlreadyMember => 'Už ste členom';

  @override
  String get spaceAutoApproved => 'Automaticky schválené. Vitajte!';

  @override
  String get spacePendingApprovalHint =>
      'Registrácia bola úspešná. Vaša žiadosť o pripojenie bola odoslaná.';

  @override
  String get spaceNoSpaces => 'Žiadne priestory';

  @override
  String get spaceInviteExpired => 'Kód pozvánky vypršal';

  @override
  String get spaceInviteTargetMismatch =>
      'Tento kód pozvánky nie je pre váš účet';

  @override
  String get spaceAcceptInviteSuccess => 'Úspešne ste sa pripojili k firme';

  @override
  String get spaceAcceptInviteFailed => 'Pripojenie zlyhalo. Skúste to znova.';

  @override
  String get spaceTenantSelectTitle => 'Vyberte priestor';

  @override
  String get spaceTenantSelectHint =>
      'Vyberte priestor, do ktorého chcete vstúpiť';

  @override
  String get spaceEnterPersonal => 'Vstúpiť do osobného priestoru';

  @override
  String get spaceEnterEnterprise => 'Vstúpiť do firemného priestoru';

  @override
  String get aboutTitle => 'O aplikácii StartLink';

  @override
  String get aboutVersion => 'Verzia';

  @override
  String get aboutTerms => 'Užívateľská zmluva';

  @override
  String get aboutPrivacy => 'Zásady ochrany osobných údajov';

  @override
  String get aboutOpenSource => 'Licencie otvoreného softvéru';

  @override
  String get aboutCheckUpdate => 'Skontrolovať aktualizácie';

  @override
  String get aboutLatestVersion => 'Používate najnovšiu verziu.';

  @override
  String get aboutUpdateAvailable => 'K dispozícii je nová verzia';

  @override
  String get aboutUpdateNow => 'Aktualizovať teraz';

  @override
  String get aboutUpdateLater => 'Neskôr';

  @override
  String get notificationTitle => 'Oznámenia';

  @override
  String get notificationGlobalMute => 'Nerušiť';

  @override
  String get notificationSound => 'Zvuk';

  @override
  String get notificationVibration => 'Vibrácie';

  @override
  String get notificationPreview => 'Náhľad správy';

  @override
  String get notificationDndStart => 'Začiatok režimu Nerušiť';

  @override
  String get notificationDndEnd => 'Koniec režimu Nerušiť';

  @override
  String get blacklistTitle => 'Na čiernom zozname';

  @override
  String get blacklistEmpty => 'Žiadni zablokovaní používatelia';

  @override
  String get blacklistRemove => 'Odblokovať';

  @override
  String get blacklistRemoveConfirm => 'Odblokovať tohto používateľa?';

  @override
  String get feedbackTitle => 'Spätná väzba';

  @override
  String get feedbackTypeComplaint => 'Sťažnosť';

  @override
  String get feedbackTypeSuggestion => 'Návrh';

  @override
  String get feedbackTypeBug => 'Hlásenie chyby';

  @override
  String get feedbackContent => 'Popis';

  @override
  String get feedbackContentHint => 'Podrobne opíšte problém alebo návrh';

  @override
  String get feedbackContact => 'Kontakt (voliteľné)';

  @override
  String get feedbackSubmit => 'Odoslať';

  @override
  String get feedbackSuccess => 'Spätná väzba odoslaná. Ďakujeme!';

  @override
  String get feedbackFailed => 'Odoslanie zlyhalo. Skúste to znova.';

  @override
  String get networkTitle => 'Prepnúť linku';

  @override
  String get networkAutoSelect => 'Automaticky';

  @override
  String get networkManual => 'Ručne';

  @override
  String get timezoneTitle => 'Časové pásmo';

  @override
  String get timezoneAuto => 'Podľa systému';

  @override
  String get autoTranslateTitle => 'Automatický preklad';

  @override
  String get autoTranslateEnabled => 'Zapnúť automatický preklad';

  @override
  String get autoTranslateLanguage => 'Cieľový jazyk';

  @override
  String get displayTitle => 'Zobrazenie';

  @override
  String get displayFontSize => 'Veľkosť písma';

  @override
  String get displayChatBackground => 'Pozadie chatu';

  @override
  String get displayDarkMode => 'Vzhľad';

  @override
  String get displayDarkModeSystem => 'Podľa systému';

  @override
  String get displayDarkModeSystemHint =>
      'Automaticky prepínať podľa nastavenia systému';

  @override
  String get displayDarkModeOff => 'Svetlý';

  @override
  String get displayDarkModeOffHint => 'Vždy používať svetlý motív';

  @override
  String get displayDarkModeOn => 'Tmavý';

  @override
  String get displayDarkModeOnHint => 'Vždy používať tmavý motív';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'História chatov';

  @override
  String get chatHistoryClear => 'Vymazať celú históriu';

  @override
  String get chatHistoryClearConfirm =>
      'Vymazať celú históriu chatov? Túto akciu nemožno vrátiť späť.';

  @override
  String get chatHistoryClearSuccess => 'História chatov vymazaná';

  @override
  String get accountSecurityTitle => 'Zabezpečenie účtu';

  @override
  String get accountSecurityChangePassword => 'Zmeniť heslo';

  @override
  String get accountSecurityChangeMobile => 'Zmeniť telefónne číslo';

  @override
  String get accountSecurityChangeEmail => 'Zmeniť e-mail';

  @override
  String get accountSecurityLoggedDevices => 'Prihlásené zariadenia';

  @override
  String get accountSecurityDeactivate => 'Zrušiť účet';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Po 7 dňoch sa všetky údaje natrvalo odstránia. Zrušiť účet?';

  @override
  String get loggedDevicesTitle => 'Prihlásené zariadenia';

  @override
  String get loggedDevicesCurrent => 'Toto zariadenie';

  @override
  String get loggedDevicesRevoke => 'Odhlásiť sa';

  @override
  String get loggedDevicesRevokeConfirm => 'Odhlásiť sa z tohto zariadenia?';

  @override
  String get loggedDevicesRevokeSuccess => 'Zo zariadenia ste odhlásení';

  @override
  String get loggedDevicesRevokeFailed => 'Zlyhalo. Skúste to znova.';

  @override
  String get loggedDevicesLastActive => 'Posledná aktivita';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Počítač';

  @override
  String get loggedDevicesTypeUnknown => 'Neznáme zariadenie';

  @override
  String get privacySettingsTitle => 'Súkromie';

  @override
  String get privacySearchableByMobile =>
      'Povoliť hľadanie podľa telefónneho čísla';

  @override
  String get privacySearchableByLppId => 'Povoliť hľadanie podľa StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'Povoliť žiadosti o priateľstvo';

  @override
  String get privacyProfileVisibility => 'Viditeľnosť profilu';

  @override
  String get privacyEveryone => 'Všetci';

  @override
  String get privacyFriendsOfFriends => 'Priatelia priateľov';

  @override
  String get privacyNobody => 'Nikto';

  @override
  String get privacyFriendsOnly => 'Len priatelia';

  @override
  String get privacySaveSuccess => 'Nastavenia uložené';

  @override
  String get privacySaveFailed => 'Uloženie zlyhalo. Skúste to znova.';

  @override
  String get fontSizeTitle => 'Veľkosť písma';

  @override
  String get fontSizeSmall => 'Malé';

  @override
  String get fontSizeNormal => 'Štandardné';

  @override
  String get fontSizeLarge => 'Veľké';

  @override
  String get fontSizeExtraLarge => 'Extra veľké';

  @override
  String get fontSizePreview => 'Náhľad';

  @override
  String get chatBackgroundTitle => 'Pozadie chatu';

  @override
  String get chatBackgroundDefault => 'Predvolené';

  @override
  String get chatBackgroundCustom => 'Vlastné';

  @override
  String get chatBackgroundReset => 'Obnoviť prednastavenia';

  @override
  String get termsTitle => 'Užívateľská zmluva';

  @override
  String get privacyPolicyTitle => 'Zásady ochrany osobných údajov';

  @override
  String get recentContactsTitle => 'Nedávne';

  @override
  String get recentContactsEmpty => 'Žiadne nedávne kontakty';

  @override
  String get inviteFriendsTitle => 'Pozvať priateľov';

  @override
  String get inviteFriendsCopyLink => 'Skopírovať odkaz pozvánky';

  @override
  String get inviteFriendsLinkCopied => 'Odkaz pozvánky skopírovaný';

  @override
  String get imageViewerTitle => 'Fotka';

  @override
  String get imageViewerSave => 'Uložiť do alba';

  @override
  String get imageViewerSaveSuccess => 'Uložené do albumu';

  @override
  String get imageViewerSaveFailed => 'Uloženie zlyhalo. Skúste to znova.';

  @override
  String get customerServiceTitle => 'Centrum podpory';

  @override
  String get customerServiceQueue => 'Vo fronte';

  @override
  String get customerServiceActive => 'Aktívne';

  @override
  String get customerServiceClaim => 'Prijať';

  @override
  String get customerServiceTakeover => 'Prevziať';

  @override
  String get customerServiceClose => 'Ukončiť podporu';

  @override
  String get customerServiceCloseConfirm => 'Ukončiť túto reláciu podpory?';

  @override
  String get customerServiceNoQueue => 'Žiadne relácie vo fronte';

  @override
  String get customerServiceNoActive => 'Žiadne aktívne relácie';

  @override
  String get customerServiceVisitor => 'Návštevník';

  @override
  String get customerServiceCustomer => 'Zákazník';

  @override
  String get customerServiceAssignedTo => 'Pridelené';

  @override
  String get customerServiceTransferConversation => 'Odovzdať chat';

  @override
  String get marketingToolbar => 'Marketingové nástroje';

  @override
  String get callIncoming => 'Prichádzajúci hovor';

  @override
  String get callOutgoing => 'Odchádzajúci hovor';

  @override
  String get callAccept => 'Prijať';

  @override
  String get callReject => 'Odmietnuť';

  @override
  String get callHangup => 'Ukončiť';

  @override
  String get callMissed => 'Zmeškaný hovor';

  @override
  String get callDuration => 'Trvanie';

  @override
  String get callAudio => 'Hlasový hovor';

  @override
  String get callGeneric => 'Hovor';

  @override
  String get callVideo => 'Videohovor';

  @override
  String get callConnecting => 'Pripája sa...';

  @override
  String get callRinging => 'Vyzváňa...';

  @override
  String get callEnded => 'Hovor ukončený';

  @override
  String get callFailed => 'Hovor zlyhal';

  @override
  String get callRejected => 'Hovor odmietnutý';

  @override
  String get callTimeout => 'Bez odpovede';

  @override
  String get callCancelled => 'Zrušené';

  @override
  String get callUnknownPeer => 'Neznáme';

  @override
  String get callVideoInvitation => 'Pozvanie na videohovor';

  @override
  String get callAudioInvitation => 'Pozvanie na hlasový hovor';

  @override
  String get callAnswerAudio => 'Prijať hlasovo';

  @override
  String get callAnswerVideo => 'Prijať s videom';

  @override
  String get callViewProfile => 'Zobraziť profil';

  @override
  String get callOpeningCamera => 'Spúšťa sa kamera...';

  @override
  String get callWaitingRemoteVideo => 'Čaká sa na video druhej strany...';

  @override
  String get callCameraOff => 'Kamera vypnutá';

  @override
  String get callCameraOn => 'Kamera zapnutá';

  @override
  String get callMicrophoneOff => 'Mikrofón vypnutý';

  @override
  String get callMicrophoneOn => 'Mikrofón zapnutý';

  @override
  String get callSpeakerOff => 'Reproduktor vypnutý';

  @override
  String get callSpeakerOn => 'Reproduktor zapnutý';

  @override
  String get callVideoPermissionFailure =>
      'Videohovor sa nepodarilo spustiť. Skontrolujte povolenia ku kamere a mikrofónu a skúste to znova.';

  @override
  String get callAudioPermissionFailure =>
      'Hlasový hovor sa nepodarilo spustiť. Skontrolujte povolenie k mikrofónu a skúste to znova.';

  @override
  String get callIncompleteIncoming =>
      'Údaje prichádzajúceho hovoru nie sú úplné a hovor nemožno prijať.';

  @override
  String get callInProgress => 'Prebieha hovor';

  @override
  String get callCalling => 'Volá sa...';

  @override
  String callEndedMedia(String media) {
    return '$media bol ukončený';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media bol odmietnutý';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media nebol prijatý';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media bol zrušený';
  }

  @override
  String get callConnectionLost => 'Spojenie hovoru prerušené';

  @override
  String get callAdminEnded => 'Hovor ukončil správca';

  @override
  String callFailedMedia(String media) {
    return '$media zlyhal';
  }

  @override
  String get callBusy => 'Druhá strana je zaneprázdnená';

  @override
  String callDurationValue(String duration) {
    return 'Trvanie hovoru $duration';
  }

  @override
  String get callNotConnected => 'Nepripojené';

  @override
  String get callDialed => 'Odchádzajúci';

  @override
  String get callAnswered => 'Prijaté';

  @override
  String get callRejectedByPeer => 'Druhá strana odmietla';

  @override
  String get callRejectedBySelf => 'Odmietnuté';

  @override
  String get callPeerDidNotAnswer => 'Druhá strana neodpovedala';

  @override
  String get callMissedIncoming => 'Zmeškaný prichádzajúci hovor';

  @override
  String get callPeerCancelled => 'Druhá strana zrušila';

  @override
  String get notificationNewMessageTitle => 'Nová správa StartLink';

  @override
  String get notificationOnlineServiceTitle =>
      'Nová správa zákazníckej podpory';

  @override
  String get notificationNewMessageBody => 'Dostali ste novú správu';

  @override
  String get notificationImagePreview => 'Odoslaný obrázok';

  @override
  String get notificationVideoPreview => 'Odoslané video';

  @override
  String get notificationVoicePreview => 'Odoslaná hlasová správa';

  @override
  String get notificationFilePreview => 'Odoslaný súbor';

  @override
  String get notificationContactPreview => 'Odoslaná vizitka';

  @override
  String get notificationCallLogPreview => 'Odoslaný záznam hovoru';

  @override
  String get notificationLocationPreview => 'Zdieľaná poloha';

  @override
  String get notificationLinkPreview => 'Zdieľaný odkaz';

  @override
  String notificationMentionMe(String body) {
    return 'Zmienka o vás: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender vás spomenul(a): $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Zmienka o všetkých: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender spomenul(a) všetkých: $body';
  }

  @override
  String get notificationSecurityTitle => 'Bezpečnostné upozornenie účtu';

  @override
  String get notificationSecurityBody =>
      'Zabezpečenie vášho účtu StartLink sa zmenilo. Skontrolujte ho.';

  @override
  String get notificationFriendAcceptedTitle => 'Žiadosť o priateľstvo prijatá';

  @override
  String get notificationFriendRejectedTitle =>
      'Žiadosť o priateľstvo odmietnutá';

  @override
  String get notificationFriendAcceptedBody =>
      'Druhá strana prijala vašu žiadosť o priateľstvo';

  @override
  String get notificationFriendRejectedBody =>
      'Druhá strana odmietla vašu žiadosť o priateľstvo';

  @override
  String get notificationVideoCallTitle => 'Pozvanie na videohovor';

  @override
  String get notificationAudioCallTitle => 'Pozvanie na hlasový hovor';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller vás pozval(a) na videohovor';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller vás pozval(a) na hlasový hovor';
  }

  @override
  String get notificationMessageChannelName => 'Správy';

  @override
  String get notificationMessageChannelDescription =>
      'Správy chatu, záznamy hovorov a systémové upozornenia';

  @override
  String get notificationCallChannelName => 'Hovory';

  @override
  String get notificationCallChannelDescription =>
      'Upozornenia na hlasové hovory a videohovory';

  @override
  String get notificationSecurityChannelName => 'Zabezpečenie účtu';

  @override
  String get notificationSecurityChannelDescription =>
      'Upozornenia na prihlásenie a zmeny hesla a mobilného čísla';

  @override
  String get notificationUnknownCaller => 'Neznámy volajúci';

  @override
  String get pendingJoinRequestsTitle => 'Nové žiadosti';

  @override
  String get pendingJoinRequestsEmpty => 'Žiadne žiadosti';

  @override
  String get pendingJoinRequestApprove => 'Súhlasím';

  @override
  String get pendingJoinRequestReject => 'Odmietnuť';

  @override
  String get pendingJoinRequestApproveSuccess => 'Schválené';

  @override
  String get pendingJoinRequestRejectSuccess => 'Zamietnuté';

  @override
  String get pendingJoinRequestFailed => 'Akcia zlyhala. Skúste to znova.';

  @override
  String get myCustomersTitle => 'Moji zákazníci';

  @override
  String get myCustomersEmpty => 'Žiadni zákazníci';

  @override
  String get groupListTitle => 'Skupiny';

  @override
  String get groupListEmpty => 'Žiadne skupiny';

  @override
  String get addFriendTitle => 'Pridať kontakt';

  @override
  String get addFriendSearchHint => 'Telefón / e-mail / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Pridať';

  @override
  String get addFriendCannotAddSelf => 'Nemôžete pridať sami seba';

  @override
  String get addFriendUnsupportedUser =>
      'Tohto používateľa nemožno pridať. Môžete mu napísať priamo.';

  @override
  String get addFriendMessageHint => 'Zadajte správu';

  @override
  String get addFriendSendRequest => 'Odoslať žiadosť';

  @override
  String get joinCompanyTitle => 'Pripojiť sa k firme';

  @override
  String get joinCompanyCodeHint => 'Zadajte kód firmy';

  @override
  String get joinCompanySearchHint => 'Hľadať názov firmy';

  @override
  String get joinCompanyApply => 'Požiadať o pripojenie';

  @override
  String get joinCompanyApplySuccess => 'Žiadosť odoslaná';

  @override
  String get joinCompanyApplyFailed =>
      'Podanie žiadosti zlyhalo. Skúste to znova.';

  @override
  String get joinCompanyAutoApproved => 'Automaticky schválené. Vitajte!';

  @override
  String get joinCompanyPending => 'Žiadosť odoslaná, čaká na schválenie';

  @override
  String get joinCompanyInviteCodeHint => 'Zadajte kód pozvánky';

  @override
  String get joinCompanyAcceptInvite => 'Prijať pozvánku';

  @override
  String get joinCompanyNoResults => 'Žiadne firmy sa nenašli';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count členov';
  }

  @override
  String get timezoneNameHawaii => 'Havaj';

  @override
  String get timezoneNameAlaska => 'Aljaška';

  @override
  String get timezoneNamePacificTime => 'Tichomorský čas';

  @override
  String get timezoneNameMountainTime => 'Horský čas';

  @override
  String get timezoneNameCentralTime => 'Centrálny čas';

  @override
  String get timezoneNameEasternTime => 'Východný čas';

  @override
  String get timezoneNameAtlanticTime => 'Atlantický čas';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azory';

  @override
  String get timezoneNameLondonDublin => 'Londýn/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlín/Paríž/Rím';

  @override
  String get timezoneNameCairoHelsinki => 'Káhira/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskva/Rijád';

  @override
  String get timezoneNameTehran => 'Teherán';

  @override
  String get timezoneNameDubaiBaku => 'Dubaj/Baku';

  @override
  String get timezoneNameKabul => 'Kábul';

  @override
  String get timezoneNameKarachiTashkent => 'Karáči/Taškent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Bombaj/Naí Dillí';

  @override
  String get timezoneNameKathmandu => 'Káthmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dháka/Almaty';

  @override
  String get timezoneNameYangon => 'Rangún';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoj/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Peking/Šanghaj/Hongkong/Tchaj-pej';

  @override
  String get timezoneNameTokyoSeoul => 'Tokio/Soul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Šalamúnove ostrovy';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fidži';

  @override
  String get networkSmartSelectBestRoute =>
      'Inteligentne vybrať najlepšiu trasu';

  @override
  String get networkTesting => 'Testuje sa...';

  @override
  String get networkTestingShort => 'Testovanie';

  @override
  String networkLatencyMs(int ms) {
    return 'Odozva $ms ms';
  }

  @override
  String get networkConnectionMode => 'Režim pripojenia';

  @override
  String get networkDirectMode => 'Priamy režim';

  @override
  String get networkProxyMode => 'Režim proxy';

  @override
  String get networkDirectModeDesc => 'Pripojiť priamo k serveru';

  @override
  String get networkProxyModeDesc => 'Pripojiť cez proxy server';

  @override
  String get networkDirectRoutes => 'Priame trasy';

  @override
  String get networkProxyRoutes => 'Proxy trasy';

  @override
  String get networkTestAll => 'Otestovať všetko';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Uzol v Hongkongu';

  @override
  String get networkSingaporeNode => 'Uzol v Singapure';

  @override
  String get networkJapanNode => 'Uzol v Japonsku';

  @override
  String get networkUnitedStatesNode => 'Uzol v Spojených štátoch';

  @override
  String get networkHint =>
      'Tipy:\n• Priamy režim: rýchlejší a vhodný na domáce použitie\n• Režim proxy: stabilnejší pri cezhraničnej komunikácii\n• Klepnutím na ikonu obnovenia otestujete odozvu jednej trasy';

  @override
  String get teenModeTitle => 'Režim pre dospievajúcich';

  @override
  String get teenModeStatusOn => 'Zapnuté';

  @override
  String get teenModeStatusOff => 'Vypnuté';

  @override
  String get teenModeStatusLoading => 'Načítava sa';

  @override
  String get teenModeUnavailable =>
      'Stav režimu pre dospievajúcich je dočasne nedostupný';

  @override
  String get teenModeInvalidResponse =>
      'Režim pre dospievajúcich vrátil neplatnú odpoveď';

  @override
  String get teenModeEnableDescription =>
      'Pravidlá platformy obmedzia čas používania a vybrané funkcie.';

  @override
  String get teenModePasscode => 'Prístupový kód';

  @override
  String get teenModeCurrentPasscode => 'Aktuálny prístupový kód';

  @override
  String get teenModeNewPasscode => 'Nový prístupový kód';

  @override
  String get teenModePasscodeHint => 'Zadajte 4–6 číslic';

  @override
  String get teenModeEnable => 'Zapnúť režim pre dospievajúcich';

  @override
  String get teenModeDisable => 'Vypnúť režim pre dospievajúcich';

  @override
  String get teenModeChangePasscode => 'Zmeniť prístupový kód';

  @override
  String get teenModeSource => 'Zapol/zapla';

  @override
  String get teenModeDailyUsage => 'Dnešné využitie';

  @override
  String get teenModeRemaining => 'Zostávajúci čas';

  @override
  String get teenModeMinutesUnit => 'Minúty';

  @override
  String get teenModeUnlimited => 'Bez obmedzenia';

  @override
  String get teenModeRequestExtension => 'Požiadať o ďalší čas';

  @override
  String get teenModeExtensionSubmitted =>
      'Žiadosť o ďalší čas bola odoslaná opatrovníkovi';

  @override
  String get teenModeTimeLimitReached =>
      'Dnešný limit používania bol dosiahnutý';

  @override
  String get teenModeCurfewActive => 'Teraz platí obmedzenie používania';

  @override
  String get teenModeReliefHint =>
      'Stále môžete prezerať históriu, kontaktovať oficiálnu podporu a hlásiť problémy.';

  @override
  String get teenModeRestrictedNotice =>
      'Režim pre dospievajúcich teraz bráni odosielaniu správ';

  @override
  String get teenModeActionBlocked =>
      'Režim pre dospievajúcich teraz bráni tejto akcii';

  @override
  String get teenModeMyRequests => 'Moje žiadosti';

  @override
  String get guardianCenterTitle => 'Centrum opatrovníkov';

  @override
  String get guardianRelationships => 'Opatrovnícke prepojenia';

  @override
  String get guardianMinors => 'Deti pod mojím dohľadom';

  @override
  String get guardianApprovals => 'Čakajúce schválenia';

  @override
  String get guardianBind => 'Zadajte prepojovací kód';

  @override
  String get guardianCreateMinorCode => 'Som dieťa — vytvoriť kód';

  @override
  String get guardianCreateGuardianCode => 'Som opatrovník — vytvoriť kód';

  @override
  String get guardianRelation => 'Prepojenie';

  @override
  String get guardianPrimary => 'Hlavný opatrovník';

  @override
  String get guardianCode => 'Šesťmiestny prepojovací kód';

  @override
  String get guardianCodeHint => 'Zadajte kód od druhej osoby';

  @override
  String get guardianCodeCreated =>
      'Kód vytvorený. Zdieľajte ho pred vypršaním platnosti.';

  @override
  String get guardianEmpty => 'Žiadne opatrovnícke prepojenia';

  @override
  String get guardianNoMinors => 'Žiadne deti pod dohľadom';

  @override
  String get guardianUnbind => 'Odobrať prepojenie';

  @override
  String get guardianExtend => 'Pridať dieťaťu čas';

  @override
  String get guardianPolicyTitle => 'Pravidlá používania';

  @override
  String get guardianPolicyLocked => 'Uzamknuté platformou';

  @override
  String get approvalEmpty => 'Žiadne žiadosti';

  @override
  String get approvalApprove => 'Súhlasím';

  @override
  String get approvalReject => 'Odmietnuť';

  @override
  String get approvalPending => 'Čaká';

  @override
  String get approvalApproved => 'Schválené';

  @override
  String get approvalRejected => 'Odmietnuté';

  @override
  String get approvalExpired => 'Expirované';

  @override
  String get approvalCancelled => 'Zrušené';

  @override
  String get approvalReplayFailed => 'Pôvodná akcia zlyhala. Skúste ju znova.';

  @override
  String get requestCancelled => 'Žiadosť zrušená';

  @override
  String get kycTitle => 'Overenie totožnosti';

  @override
  String get kycNotRequired => 'Overenie totožnosti nie je vyžadované';

  @override
  String get kycVerified => 'Totožnosť overená';

  @override
  String get kycDeclared => 'Údaje totožnosti odoslané';

  @override
  String get kycPending => 'Prebieha kontrola';

  @override
  String get kycRejected => 'Kontrola zamietnutá';

  @override
  String get kycNone => 'Údaje totožnosti neboli odoslané';

  @override
  String get kycRealName => 'Plné meno';

  @override
  String get kycIdNumber => 'Číslo dokladu';

  @override
  String get kycIdType => 'Typ dokladu';

  @override
  String get kycApplicability =>
      'Zadajte pravdivé údaje pre vybraný doklad. Prijímané typy sú uvedené v zozname.';

  @override
  String get kycCamera => 'Odfotiť';

  @override
  String get kycGallery => 'Vybrať z galérie';

  @override
  String get kycPhotoLimit => 'Maximum na fotku';

  @override
  String get kycSelectPhoto => 'Vybrať fotografiu';

  @override
  String get kycPhotoSelected => 'Vybraté';

  @override
  String get kycViewPhoto => 'Klepnutím zobrazíte fotku';

  @override
  String get kycReplacePhoto => 'Vybrať inú fotku';

  @override
  String get kycDisclosure =>
      'Na overenie totožnosti používame vaše meno, číslo dokladu a fotografie dokladu. Bez nich nemožno žiadosť odoslať a niektoré obmedzené funkcie nemusia byť dostupné.';

  @override
  String get kycConsent =>
      'Udeľujem samostatný súhlas s týmto spracúvaním údajov totožnosti';

  @override
  String get kycConsentRequired => 'Pred odoslaním udeľte samostatný súhlas';

  @override
  String get kycResubmitTitle => 'Znova odoslať údaje totožnosti';

  @override
  String get kycResubmitWarning =>
      'Opätovné odoslanie nahradí vašu čakajúcu žiadosť. Pokračovať?';

  @override
  String get kycSubmitting => 'Odosiela sa';

  @override
  String get kycSubmitFailed => 'Odoslanie zlyhalo. Skúste to znova.';

  @override
  String get kycSubmitUnavailable => 'Údaje totožnosti teraz nemožno odoslať';

  @override
  String get kycResubmitNotAllowed =>
      'Po zamietnutí nie je opätovné odoslanie dostupné. V prípade potreby kontaktujte podporu.';

  @override
  String get kycDailyLimit =>
      'Dosiahli ste dnešný limit odoslaní. Skúste to zajtra.';

  @override
  String get kycTypeUnavailable =>
      'Žiadne typy dokladov nie sú dostupné. Skúste to neskôr.';

  @override
  String get kycNameInvalid => 'Úradné meno musí mať 2–64 znakov';

  @override
  String get kycNumberRequired => 'Zadajte číslo dokladu';

  @override
  String get kycFrontRequired => 'Nahrajte prednú stranu dokladu';

  @override
  String get kycBackRequired => 'Nahrajte zadnú stranu dokladu';

  @override
  String get kycPhotoTooLarge =>
      'Fotka prekračuje limit veľkosti. Zmenšite ju a skúste to znova.';

  @override
  String get kycAccountChanged =>
      'Účet alebo priestor sa zmenil. Otvorte stránku znova.';

  @override
  String get kycPhotoInvalid => 'Vyberte platný obrázok';

  @override
  String get kycPortraitSide => 'Predná strana ID';

  @override
  String get kycEmblemSide => 'Strana so znakom';

  @override
  String get kycPassportDataPage => 'Údajová stránka pasu';

  @override
  String get kycPassportOtherPage => 'Vízová alebo voľná stránka pasu';

  @override
  String get kycFront => 'Predná strana ID';

  @override
  String get kycBack => 'Zadná strana ID';

  @override
  String get kycRequired =>
      'Pred vytvorením skupiny je potrebné overiť totožnosť';

  @override
  String get kycGoVerify => 'Overiť teraz';

  @override
  String get kycStatusUnknown =>
      'Stav totožnosti nie je dostupný. Obnovte neskôr.';

  @override
  String get kycSuperseded =>
      'Novšie odoslanie nahradilo toto. Skontrolujte posledný stav totožnosti.';

  @override
  String get kycMediaNotFound =>
      'Fotka dokladu nie je v tomto priestore dostupná. Pred odoslaním ju vyberte znova.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Hromadné správy zákazníkom';

  @override
  String get officialAccountBadge => 'Oficiálne';

  @override
  String get officialAccountOpenConversation => 'Otvoriť konverzáciu';

  @override
  String get officialAccountJoinHint =>
      'Pridaním tohto účtu sa k firme pripojíte ako zákazník. Schválenie priateľstva nie je potrebné.';

  @override
  String get officialAccountJoinDisabled =>
      'Táto firma neprijíma nových zákazníkov. Kontaktujte podporu.';

  @override
  String get officialAccountRemoved =>
      'Boli ste odobratí z tejto firmy. Požiadajte firmu o nové pozvanie.';

  @override
  String get officialAccountBanned =>
      'Váš účet bol v tejto firme deaktivovaný.';

  @override
  String get officialAccountUnavailable =>
      'Tento oficiálny účet je teraz nedostupný.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'V aktuálnom režime nie je pripojenie k firme povolené.';

  @override
  String get officialAccountPlatformRequired =>
      'Na pridanie tohto oficiálneho účtu použite účet platformy.';

  @override
  String get officialAccountOpenFailed =>
      'Konverzáciu sa nepodarilo otvoriť. Skúste to znova.';

  @override
  String get officialAccountAccountChanged =>
      'Účet alebo priestor sa zmenil. Otvorte ho znova.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Firemný adresár nie je aktuálny. Skúste to o chvíľu.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Synchronizácia oficiálneho účtu zlyhala. Miestny obsah je stále dostupný.';

  @override
  String get officialAccountInboxSyncing =>
      'Synchronizujú sa správy oficiálneho účtu';

  @override
  String get diagnosticsTitle => 'Diagnostika';

  @override
  String get diagnosticsExplanation =>
      'Protokoly sú anonymizované a obsahujú prevádzkové a chybové informácie pre tento účet a priestor a verejné udalosti spustenia. Obsah chatov a prihlasovacie údaje nie sú zahrnuté.';

  @override
  String get diagnosticsHour => 'Posledná hodina';

  @override
  String get diagnosticsDay => 'Posledných 24 hodín';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Dostupné udalosti: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Protokoly sa ukladajú v tomto zariadení a zostanú dostupné po reštarte.';

  @override
  String get diagnosticsNotPersistent =>
      'Niektoré protokoly neboli uložené. Obnovením skúste znova.';

  @override
  String get diagnosticsExport => 'Exportovať a zdieľať';

  @override
  String get diagnosticsRefresh => 'Obnoviť';

  @override
  String get diagnosticsClear => 'Vymazať protokoly tohto priestoru';

  @override
  String get diagnosticsClearConfirm =>
      'Vymazať diagnostické protokoly tohto priestoru? História chatov sa zachová.';

  @override
  String get diagnosticsShared =>
      'Systémové zdieľanie dokončené. Overte súbor v cieľovej aplikácii.';

  @override
  String get diagnosticsCancelled =>
      'Zdieľanie zrušené. Môžete exportovať znova.';

  @override
  String get diagnosticsUnconfirmed =>
      'Zdieľanie sa nepodarilo potvrdiť. Skontrolujte cieľovú aplikáciu.';

  @override
  String get diagnosticsFailed => 'Akcia zlyhala. Skúste to znova.';
}
