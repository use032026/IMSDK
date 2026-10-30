// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get navWorkbench => 'Pracovní plocha';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Nepodařilo se načíst údaje účtu';

  @override
  String get startupFailureTitle => 'Spuštění se nezdařilo';

  @override
  String get startupFailureMessage => 'Zkontrolujte síť a zkuste to znovu';

  @override
  String get privacyConsentTitle =>
      'Obchodní podmínky a Zásady ochrany osobních údajů';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Vítejte v aplikaci $brand. Pro přihlašování k účtu, rychlé zprávy, firemní spolupráci, online zákaznickou podporu, upozornění na zprávy a zabezpečení potřebujeme zpracovávat nezbytné údaje v souladu s Podmínkami služby a Zásadami ochrany osobních údajů.\n\nDokud neklepnete na Souhlasím, nebudeme číst obsah schránky, inicializovat JPush/JCore ani SDK oznámení výrobců zařízení ani jejich prostřednictvím získávat Android ID, OAID, seznamy nainstalovaných aplikací, MAC adresy či podobné údaje. Pokud nyní odmítnete, vaši volbu uložíme; dokumenty si můžete dále číst a rozhodnout se později.\n\nPo udělení souhlasu mohou JPush/JCore a služby oznámení výrobců zařízení pro doručování upozornění na zprávy, zákaznickou podporu a příchozí hovory zpracovávat model zařízení, verzi Androidu, název balíčku a verzi aplikace, typ sítě, IP adresu, Android ID, OAID, Registration ID oznámení, token oznámení výrobce a údaje o doručení a otevření oznámení. Vypnuli jsme nepotřebné funkce včetně chytrých oznámení, seznamů nainstalovaných aplikací, MAC, IMEI, IMSI, seznamů Wi-Fi sítí, automatického probouzení a propojeného spouštění.\n\nKe schránce přistupujeme pouze při vašem použití kopírování nebo vložení. O systémová oprávnění ke kameře, mikrofonu, oznámením a dalším funkcím žádáme pouze při použití příslušné funkce. Odmítnutí jednotlivého oprávnění ovlivní pouze danou funkci. Přečtěte si úplné dokumenty níže a sami se rozhodněte, zda souhlasíte.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Vítejte v aplikaci $brand. Pro přihlašování k účtu, rychlé zprávy, firemní spolupráci, online zákaznickou podporu, upozornění na zprávy a zabezpečení potřebujeme zpracovávat nezbytné údaje v souladu s Podmínkami služby a Zásadami ochrany osobních údajů.\n\nDokud neklepnete na Souhlasím, nebudeme číst obsah schránky, inicializovat JPush/JCore, registrovat se u služby Apple Push Notification service (APNs) ani získávat identifikátory oznámení, jako jsou JPush Registration ID nebo token zařízení APNs. Pokud nyní odmítnete, vaši volbu uložíme; dokumenty si můžete dále číst a rozhodnout se později.\n\nPo udělení souhlasu můžeme pro doručování upozornění na zprávy, zákaznickou podporu a příchozí hovory zpracovávat model iPhonu, verzi iOS, název balíčku a verzi aplikace, typ sítě, IP adresu, IDFV, JPush Registration ID, token zařízení APNs a údaje o doručení a otevření oznámení. JPush/JCore zajišťuje připojení ke službě oznámení; Apple APNs zpracovává identifikátor aplikace, token zařízení a obsah oznámení pro systémové doručování. Současná aplikace pro iOS nepoužívá reklamní služby ani nezískává IDFA.\n\nKe schránce přistupujeme pouze při vašem použití kopírování nebo vložení. O systémová oprávnění ke kameře, mikrofonu, oznámením a dalším funkcím žádáme pouze při použití příslušné funkce. Odmítnutí jednotlivého oprávnění ovlivní pouze danou funkci. Přečtěte si úplné dokumenty níže a sami se rozhodněte, zda souhlasíte.';
  }

  @override
  String get privacyConsentTermsLink => 'Uživatelská smlouva';

  @override
  String get privacyConsentConjunction => 'a';

  @override
  String get privacyConsentPrivacyLink => 'Zásady ochrany soukromí';

  @override
  String get privacyConsentDecline => 'Nesouhlasím';

  @override
  String get privacyConsentDeclinedExit =>
      'Nesouhlasili jste s Podmínkami služby a Zásadami ochrany osobních údajů. Aplikace se nyní zavře.';

  @override
  String get privacyConsentAccept => 'Souhlasím';

  @override
  String get privacyConsentRuntimeFailure =>
      'Spuštění se nezdařilo. Zkontrolujte síť a zkuste to znovu.';

  @override
  String get privacyConsentSaveFailure =>
      'Vaši volbu se nepodařilo uložit. Zkuste to znovu.';

  @override
  String get appUpdateRequiredTitle => 'Pro pokračování je nutná aktualizace';

  @override
  String get appUpdateOptionalTitle => 'Nová verze je k dispozici';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Je dostupná verze $brand $version';
  }

  @override
  String get appUpdateLater => 'Později';

  @override
  String get appUpdateNow => 'Aktualizovat nyní';

  @override
  String get appUpdateProcessing => 'Zpracování...';

  @override
  String get appUpdateInvalidUrl =>
      'Adresa aktualizace není platná. Zkuste to později.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Odkaz na aktualizaci se nepodařilo otevřít. Zkuste to později.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Stahování bylo přerušeno. Zkontrolujte síť a zkuste to znovu.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Ověření instalačního balíčku se nezdařilo. Stáhněte jej znovu.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'V nastavení systému povolte aplikaci $brand instalovat aktualizace.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Systémový instalátor se nepodařilo otevřít. Zkontrolujte oprávnění k instalaci.';

  @override
  String get appUpdateGenericFailure =>
      'Aktualizace se nezdařila. Zkontrolujte síť a zkuste to znovu.';

  @override
  String get appUpdateUnavailable =>
      'Nová verze zatím není ke stažení. Zkuste to později.';

  @override
  String get appUpdateCheckFailed =>
      'Aktualizace se nepodařilo zkontrolovat. Zkuste to později.';

  @override
  String get appUpdateChecking => 'Kontrola';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Zrušit';

  @override
  String get commonSave => 'Uložit';

  @override
  String get commonEdit => 'Upravit';

  @override
  String get commonDelete => 'Smazat';

  @override
  String get commonSearch => 'Hledat';

  @override
  String get commonLoading => 'Načítání...';

  @override
  String get commonLoadFailed => 'Nepodařilo se načíst';

  @override
  String get commonRetry => 'Zkusit znovu';

  @override
  String get commonEmpty => 'Žádná data';

  @override
  String get commonCopy => 'Kopírovat';

  @override
  String get commonForward => 'Přeposlat';

  @override
  String get commonFavorite => 'Uložit';

  @override
  String get commonClose => 'Zavřít';

  @override
  String get commonSend => 'Odeslat';

  @override
  String get commonDone => 'Hotovo';

  @override
  String get commonMore => 'Více';

  @override
  String get commonSettings => 'Nastavení';

  @override
  String get commonCopied => 'Zkopírováno';

  @override
  String get commonUnknown => 'Neznámé';

  @override
  String get commonNotSet => 'Nenastaveno';

  @override
  String get commonUnbound => 'Nepropojeno';

  @override
  String get commonViewAll => 'Zobrazit vše';

  @override
  String get commonSubmit => 'Odeslat';

  @override
  String get commonAdd => 'Přidat';

  @override
  String get commonRemove => 'Odstranit';

  @override
  String get commonCreate => 'Vytvořit';

  @override
  String get commonUpdate => 'Aktualizovat';

  @override
  String get commonUpload => 'Nahrát';

  @override
  String get commonShare => 'Sdílet';

  @override
  String get commonBlock => 'Zablokovat';

  @override
  String get commonUnblock => 'Odblokovat';

  @override
  String get commonMute => 'Ztlumit';

  @override
  String get commonUnmute => 'Zrušit ztlumení';

  @override
  String get commonPin => 'Připnuto';

  @override
  String get commonUnpin => 'Odepnout';

  @override
  String get commonMarkRead => 'Označit jako přečtené';

  @override
  String get commonMarkUnread => 'Označit jako nepřečtené';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Akce se nezdařila. Zkuste to znovu.';

  @override
  String get commonNetworkError => 'Chyba sítě. Zkontrolujte připojení.';

  @override
  String get navMessages => 'Zprávy';

  @override
  String get navContacts => 'Kontakty';

  @override
  String get navMe => 'Já';

  @override
  String get authLoginTitle => 'Přihlásit se do StartLink';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'E-mail';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Zadejte telefonní číslo';

  @override
  String get authHintEmail => 'Zadejte svůj e-mail';

  @override
  String get authHintPassword => 'Zadejte heslo';

  @override
  String get authHintCode => 'Zadejte ověřovací kód';

  @override
  String get authHintLoginName => 'Zadejte StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Přihlásit se';

  @override
  String get authGetCode => 'Získat kód';

  @override
  String authResendCode(int seconds) {
    return 'Znovu odeslat za $seconds s';
  }

  @override
  String get authUsePassword => 'Použít heslo';

  @override
  String get authUseCode => 'Použít ověřovací kód';

  @override
  String get authAgreementPrefix => 'Přečetl jsem si a souhlasím s';

  @override
  String get authAgreementAnd => 'a';

  @override
  String get authTermsLink => 'Uživatelská smlouva';

  @override
  String get authPrivacyLink => 'Zásady ochrany soukromí';

  @override
  String get authCaptchaTitle => 'Bezpečnostní ověření';

  @override
  String get authCaptchaHint => 'Zadejte odpověď';

  @override
  String get authCaptchaFailed =>
      'Ověřovací úlohu se nepodařilo získat. Zkuste to znovu.';

  @override
  String get authErrorEmptyCode => 'Zadejte ověřovací kód';

  @override
  String get authErrorEmptyPassword => 'Zadejte heslo';

  @override
  String get authErrorEmptyLoginName => 'Zadejte StartLink ID';

  @override
  String get authErrorWrongCredentials => 'Nesprávný účet nebo heslo';

  @override
  String get authDeactivatingTitle => 'Zrušení účtu';

  @override
  String get authDeactivatingContent =>
      'Váš účet je v ochranné lhůtě před zrušením (7 dní).\n\nZrušení odvoláte klepnutím na „Odvolat zrušení účtu”; pro vstup do aplikace klepněte na „Pokračovat”.';

  @override
  String get authContinueUse => 'Pokračovat';

  @override
  String get authCancelDeactivation => 'Odvolat zrušení účtu';

  @override
  String get authDeactivationCancelled => 'Zrušení bylo odvoláno, účet obnoven';

  @override
  String get authDeactivationCancelFailed =>
      'Odvolání se nezdařilo. Zkuste to znovu.';

  @override
  String get authLogout => 'Odhlásit se';

  @override
  String get authLogoutConfirm => 'Opravdu se chcete odhlásit?';

  @override
  String get authSendingCode => 'Odesílání...';

  @override
  String get authCodeSent => 'Ověřovací kód odeslán';

  @override
  String get authLoginFailed => 'Přihlášení se nezdařilo. Zkuste to znovu.';

  @override
  String get authRegisterFailed => 'Registrace se nezdařila. Zkuste to znovu.';

  @override
  String get authEnterpriseCode => 'Kód firmy';

  @override
  String get authEnterpriseCodeHint => 'Zadejte kód firmy';

  @override
  String get authPendingApproval =>
      'Registrace byla úspěšná. Vaše žádost o připojení k firmě byla odeslána a čeká na schválení.';

  @override
  String get authNoAccount => 'Nemáte účet?';

  @override
  String get authRegisterNow => 'Zaregistrovat se';

  @override
  String get authCountryPickerTitle => 'Vyberte zemi/oblast';

  @override
  String get authCountrySearchHint => 'Hledat zemi/oblast';

  @override
  String get authCountryChinaMainland => 'Pevninská Čína';

  @override
  String get authCountryHongKong => 'Hongkong, Čína';

  @override
  String get authCountryMacau => 'Macao, Čína';

  @override
  String get authCountryTaiwan => 'Tchaj-wan, Čína';

  @override
  String get authCountryUnitedStates => 'Spojené státy';

  @override
  String get authCountryUnitedKingdom => 'Spojené království';

  @override
  String get authCountryJapan => 'Japonsko';

  @override
  String get authCountrySouthKorea => 'Jižní Korea';

  @override
  String get authCountrySingapore => 'Singapur';

  @override
  String get authCountryMalaysia => 'Malajsie';

  @override
  String get authCountryAustralia => 'Austrálie';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Německo';

  @override
  String get authCountryFrance => 'Francie';

  @override
  String get authCountryIndia => 'Indie';

  @override
  String get authCountryThailand => 'Thajsko';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonésie';

  @override
  String get authCountryPhilippines => 'Filipíny';

  @override
  String get authQuickLoginTitle => 'Rychlé přihlášení';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Přihlašování. Čekejte prosím.';

  @override
  String get authRoleOwner => 'Vlastník';

  @override
  String get authRoleAdministrator => 'Správce';

  @override
  String get authRoleCustomerService => 'Zákaznická podpora';

  @override
  String get authRoleTechnicalSupport => 'Technická podpora';

  @override
  String get authRoleEmployee => 'Zaměstnanec';

  @override
  String get authRoleMember => 'Člen';

  @override
  String get authRoleEnterpriseCustomer => 'Firemní zákazník';

  @override
  String get authUnavailablePrefix => 'Nedostupné · ';

  @override
  String get authUnassignedService => 'Bez přiděleného operátora';

  @override
  String authAssignedService(String staff) {
    return 'Přiděleno: $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Zákazník · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Zaměstnanec · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count uživatelů';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Identita';

  @override
  String get authRegisterTitle => 'Zaregistrovat se';

  @override
  String get authNickname => 'Přezdívka';

  @override
  String get authNicknameHint => 'Nastavte přezdívku';

  @override
  String get authPassword => 'Heslo';

  @override
  String get authPasswordSetHint => 'Nastavte heslo (alespoň 6 znaků)';

  @override
  String get authConfirmPassword => 'Potvrďte heslo';

  @override
  String get authConfirmPasswordHint => 'Zadejte heslo znovu';

  @override
  String get authVerificationCode => 'Ověřovací kód';

  @override
  String get authRegisterAndLogin => 'Zaregistrovat se a přihlásit';

  @override
  String get authHaveAccount => 'Už máte účet?';

  @override
  String get authGoLogin => 'Přihlásit se';

  @override
  String get authEmailVerificationUnavailable =>
      'Ověření e-mailem není dostupné. Zaregistrujte se mobilním číslem.';

  @override
  String get authSmsVerificationUnavailable =>
      'Ověření SMS není dostupné. Zaregistrujte se e-mailem.';

  @override
  String get authSendFailed => 'Odeslání se nezdařilo. Zkuste to znovu.';

  @override
  String get authErrorEmptyNickname => 'Zadejte přezdívku';

  @override
  String get authErrorInvalidMobile => 'Zadejte platné mobilní číslo';

  @override
  String get authErrorInvalidEmail => 'Zadejte platnou e-mailovou adresu';

  @override
  String get authErrorPasswordTooShort =>
      'Heslo musí obsahovat alespoň 6 znaků';

  @override
  String get authErrorPasswordMismatch => 'Hesla se neshodují';

  @override
  String get authErrorVerificationRequired =>
      'Nejprve si vyžádejte a zadejte ověřovací kód';

  @override
  String get authRegisterErrorTitle => 'Registrace se nezdařila';

  @override
  String get authGotIt => 'Rozumím';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Firma „$code” nebyla nalezena. Zkontrolujte kód firmy.';
  }

  @override
  String get authTenantSearchFailed => 'Hledání se nezdařilo. Zkuste to znovu.';

  @override
  String get authInvitationInvalid =>
      'Kód pozvánky není platný. Zkontrolujte jej a zkuste to znovu.';

  @override
  String get authCollapseJoin => 'Skrýt údaje o připojení';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Platná pozvánka: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Nalezena firma: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Vyberte organizaci';

  @override
  String get authNoOrganization => 'Žádné dostupné organizace';

  @override
  String get authNoOrganizationHint =>
      'Požádejte správce o pozvání do organizace';

  @override
  String get authPersonalSpace => 'Osobní prostor';

  @override
  String get authPersonalSpaceSubtitle =>
      'Chaty s přáteli a osobní oblíbené položky';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Identitu prostoru se nepodařilo ověřit. Zkuste to znovu.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Osobní prostor se nepodařilo obnovit. Zkuste to znovu.';

  @override
  String get authJoinEnterpriseFailed =>
      'K firmě se nepodařilo připojit. Zkuste to později.';

  @override
  String get homeTitle => 'Zprávy';

  @override
  String get homeGatewayConnectingTitle => 'Připojování';

  @override
  String get homePersonalSpace => 'Osobní';

  @override
  String get homeOfficialService => 'Oficiální podpora';

  @override
  String get homeSwitchSpace => 'Přepnout prostor';

  @override
  String get homeSpaceSubtitle => 'Osobní · Firemní';

  @override
  String get homeJoinEnterprise => 'Připojit se k firmě';

  @override
  String get homeCreateGroup => 'Nová skupina';

  @override
  String get homeAddFriend => 'Přidat kontakt';

  @override
  String get homeScan => 'Skenovat';

  @override
  String get homeJoinNewSpace => 'Připojit se k novému prostoru';

  @override
  String get homeSearchConversation => 'Hledat';

  @override
  String get homeNoMessages => 'Žádné zprávy';

  @override
  String get homeDeleteConversation => 'Smazat chat';

  @override
  String get homeDeleteConversationConfirm =>
      'Smazat tento chat? Historie chatu bude vymazána.';

  @override
  String get homePersonalNote => 'Já (osobní poznámky)';

  @override
  String get homeWorkNote => 'Já (pracovní poznámky)';

  @override
  String homeConversationCount(int count) {
    return '$count chatů';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count nepřečtených';
  }

  @override
  String get chatInputHint => 'Napište zprávu...';

  @override
  String get chatVoiceHint => 'Podržením mluvte';

  @override
  String get chatVoiceRelease => 'Uvolněním odešlete';

  @override
  String get chatVoiceCancel => 'Potažením nahoru zrušte';

  @override
  String get chatMenuCopy => 'Kopírovat';

  @override
  String get chatMenuForward => 'Přeposlat';

  @override
  String get chatMenuRecall => 'Odvolat zprávu';

  @override
  String get chatMenuDelete => 'Smazat';

  @override
  String get chatMenuFavorite => 'Uložit';

  @override
  String get chatMenuReply => 'Odpovědět';

  @override
  String get chatMenuMultiSelect => 'Vybrat';

  @override
  String get chatMenuTranslate => 'Přeložit';

  @override
  String get chatMenuVoiceToText => 'Převést na text';

  @override
  String get chatMenuTextToSpeech => 'Přečíst nahlas';

  @override
  String get chatStatusRecalled => 'Zpráva byla odvolána';

  @override
  String get chatRecallSuccess => 'Odvoláno';

  @override
  String get chatRecallFailed => 'Odvolání se nezdařilo';

  @override
  String get chatRecallTimeout => 'Zprávy starší než 2 minuty nelze odvolat';

  @override
  String get chatTranslateFailed => 'Překlad se nezdařil. Zkuste to znovu.';

  @override
  String get chatTranslateNotConfigured => 'Překladová služba není dostupná';

  @override
  String get chatVoiceToTextFailed => 'Převod se nezdařil. Zkuste to znovu.';

  @override
  String get chatTextToSpeechFailed =>
      'Čtení nahlas se nezdařilo. Zkuste to znovu.';

  @override
  String get chatVoiceToText => 'Převést';

  @override
  String get chatForwardSuccess => 'Přeposláno';

  @override
  String get chatForwardFailed => 'Přeposlání se nezdařilo. Zkuste to znovu.';

  @override
  String get chatNoConversations => 'Žádné chaty k přeposlání';

  @override
  String get chatSendFailed => 'Odeslání se nezdařilo';

  @override
  String get chatResend => 'Znovu odeslat kód';

  @override
  String get chatNotFriend => 'Není v seznamu kontaktů';

  @override
  String get chatNotFriendHint =>
      'Ještě nejste kontakty. Zprávy nelze odesílat.';

  @override
  String get chatMutedHint => 'Všichni členové jsou ztlumeni';

  @override
  String get chatFileUploadFailed =>
      'Nahrání souboru se nezdařilo. Zkuste to znovu.';

  @override
  String get chatFileStatusNotDownloaded => 'Nestaženo';

  @override
  String get chatFileStatusDownloaded => 'Staženo';

  @override
  String get chatFileStatusUploading => 'Nahrávání';

  @override
  String get chatFileStatusUploadFailed => 'Nahrávání selhalo';

  @override
  String get chatCardSendFailed => 'Odeslání vizitky se nezdařilo';

  @override
  String get chatFavoriteSuccess => 'Uloženo';

  @override
  String get chatFavoriteFailed => 'Přidání do oblíbených se nezdařilo';

  @override
  String get chatLoadFailed => 'Nepodařilo se načíst';

  @override
  String get chatImageMessage => '[Obrázek]';

  @override
  String get chatVoiceMessage => '[Hlasová zpráva]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Soubor]';

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
    return 'Přečetlo: $count';
  }

  @override
  String get chatUnread => 'Nepřečtené';

  @override
  String get chatRecalledSelf => 'Odvolali jste zprávu';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender odvolal(a) zprávu';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Překlad: $translation';
  }

  @override
  String get chatMessageDeleted => 'Zpráva smazána';

  @override
  String get chatPeer => 'Jiné';

  @override
  String get chatSelf => 'Já';

  @override
  String get chatGenericMessage => '[Zpráva]';

  @override
  String get chatVoiceHideText => 'Skrýt text';

  @override
  String get chatVoiceShowText => 'Převést na text';

  @override
  String get chatFileDefaultName => 'Soubor';

  @override
  String get chatContactDefaultName => 'Kontakt';

  @override
  String get chatContactCardTitle => 'Vizitka';

  @override
  String get chatCallMissed => 'Zmeškaný';

  @override
  String get chatCallCancelled => 'Zrušeno';

  @override
  String get chatCallRejected => 'Odmítnuto';

  @override
  String get chatCallDisconnected => 'Odpojeno';

  @override
  String get chatCallEnded => 'Hovor ukončen';

  @override
  String get chatCallFailed => 'Hovor se nezdařil';

  @override
  String chatCallDuration(String duration) {
    return 'Délka $duration';
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
  String get chatToolFile => 'Soubor';

  @override
  String get chatToolLocation => 'Poloha';

  @override
  String get chatToolContactCard => 'Kontakt';

  @override
  String get chatToolVoiceCall => 'Hlasový hovor';

  @override
  String get chatToolVideoCall => 'Videohovor';

  @override
  String get chatToolFavorites => 'Oblíbené';

  @override
  String get chatToolTranslate => 'Přeložit';

  @override
  String get chatTranslationChooseLanguage => 'Vyberte jazyk překladu';

  @override
  String get chatTranslationEnterText => 'Nejprve zadejte text';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Překlad není dostupný pro zprávy se zmínkami';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Překlad není dostupný při úpravě naplánované zprávy';

  @override
  String get chatTranslationFailed => 'Překlad se nezdařil. Zkuste to znovu.';

  @override
  String get chatTranslationEmpty =>
      'Nebyl vrácen žádný překlad. Zkuste to znovu.';

  @override
  String get chatTranslationTranslating => 'Překládání…';

  @override
  String get chatTranslationSend => 'Odeslat překlad';

  @override
  String get chatTranslationSending => 'Odesílání…';

  @override
  String get chatTranslationExpand => 'Zobrazit více';

  @override
  String get chatTranslationCollapse => 'Zobrazit méně';

  @override
  String get chatFileTooLarge => 'Soubor překračuje limit (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Psát může pouze vlastník nebo vybraní členové.';

  @override
  String get chatImageUploadUnsupported =>
      'Nahrání obrázku se nezdařilo. Podpora serveru zatím není dostupná.';

  @override
  String get chatFavoriteLongPressHint =>
      'Podržením zprávy ji přidáte do oblíbených';

  @override
  String chatSelectedCount(int count) {
    return 'Vybráno: $count';
  }

  @override
  String get chatLocationSheetTitle => 'Odeslat polohu';

  @override
  String get chatLocationNameLabel => 'Název místa';

  @override
  String get chatLocationNameHint => 'např. kancelář, adresa zákazníka';

  @override
  String get chatLocationAddressLabel => 'Adresa';

  @override
  String get chatLocationOptionalHint => 'Nepovinné';

  @override
  String get chatLocationLatitudeLabel => 'Zeměpisná šířka';

  @override
  String get chatLocationLatitudeHint => '-90 až 90';

  @override
  String get chatLocationLongitudeLabel => 'Zeměpisná délka';

  @override
  String get chatLocationLongitudeHint => '-180 až 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Zadejte: $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return 'Hodnota $label je mimo rozsah';
  }

  @override
  String get chatLocationDefaultTitle => 'Poloha';

  @override
  String get chatMutedFullNotice =>
      'Tato skupina je ztlumena. Psát může pouze vlastník nebo vybraní členové.';

  @override
  String get chatNotFriendSendBlocked =>
      'Už nejste přátelé a nemůžete posílat zprávy';

  @override
  String get chatPersonalNotesTitle => 'Osobní poznámky';

  @override
  String get chatWorkNotesTitle => 'Pracovní poznámky';

  @override
  String get chatPersonalNotesDescription =>
      'Zapisujte si zde myšlenky a ukládejte důležité údaje\nSynchronizace mezi zařízeními umožní přístup kdykoli';

  @override
  String get chatWorkNotesDescription =>
      'Zapisujte si zde pracovní úkoly a ukládejte materiály\nTýmové prostory zůstávají oddělené a bezpečné';

  @override
  String get chatNoMessages => 'Žádné zprávy';

  @override
  String chatReplyTo(String sender) {
    return 'Odpovědět uživateli $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return 'Funkce $feature bude brzy dostupná';
  }

  @override
  String get chatForwardSelectTitle => 'Vyberte chat';

  @override
  String get chatContactSelectTitle => 'Vyberte kontakt';

  @override
  String get chatNoContacts => 'Žádné kontakty';

  @override
  String get contactsTitle => 'Kontakty';

  @override
  String get contactsSearch => 'Hledat kontakty';

  @override
  String get contactsNewFriends => 'Noví přátelé';

  @override
  String get contactsGroups => 'Skupiny';

  @override
  String get contactsFavorites => 'Oblíbené';

  @override
  String get contactsRecent => 'Nedávné';

  @override
  String get contactsOrganization => 'Organizace';

  @override
  String get contactsAnnouncement => 'Oznámení';

  @override
  String get contactsNewApplications => 'Nové žádosti';

  @override
  String get contactsCustomerGroups => 'Skupiny zákazníků';

  @override
  String get contactsAllCustomers => 'Všichni zákazníci';

  @override
  String get contactsMyCustomers => 'Moji zákazníci';

  @override
  String get contactsViewAll => 'Zobrazit vše';

  @override
  String get contactsMyContacts => 'Moje kontakty';

  @override
  String get contactsMyAdvisor => 'Můj poradce';

  @override
  String get contactsNoAdvisor => 'Poradce zatím nebyl přidělen';

  @override
  String get contactsAdvisorLoading => 'Načítání...';

  @override
  String get contactsNavigateFailed =>
      'Přechod na stránku se nezdařil. Zkuste to znovu.';

  @override
  String get contactsEmpty => 'Žádné kontakty';

  @override
  String get contactsNoAnnouncement => 'Žádná oznámení';

  @override
  String get contactsOfficialBadge => 'Oficiální';

  @override
  String get contactsCustomerBadge => 'Zákazník';

  @override
  String get contactsEmptyCustomers => 'Žádní zákazníci';

  @override
  String get myTitle => 'Já';

  @override
  String get myEnterpriseInfo => 'Údaje firmy';

  @override
  String get myEnterpriseManage => 'Správa firmy';

  @override
  String get myQrCode => 'QR kód';

  @override
  String get myFavorites => 'Oblíbené';

  @override
  String get myLanguage => 'Jazyk';

  @override
  String get myTimezone => 'Časové pásmo';

  @override
  String get myAutoTranslate => 'Automatický překlad';

  @override
  String get myNetworkSwitch => 'Přepnout linku';

  @override
  String get mySettings => 'Nastavení';

  @override
  String get myLogout => 'Odhlásit se';

  @override
  String get myLogoutConfirm => 'Opravdu se chcete odhlásit?';

  @override
  String get myLeaveEnterprise => 'Opustit firmu';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Opravdu chcete opustit tuto firmu? Ztratíte přístup k firemním údajům.';

  @override
  String get myLeaveEnterpriseSuccess => 'Opustili jste firmu';

  @override
  String get myLeaveEnterpriseFailed =>
      'Opuštění se nezdařilo. Zkuste to znovu.';

  @override
  String get myLppIdCopied => 'StartLink ID zkopírováno';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count kontaktů';
  }

  @override
  String get myAutoSelect => 'Automaticky';

  @override
  String get myPresenceStatus => 'Dostupnost';

  @override
  String get myPresenceStatusTitle => 'Nastavit dostupnost';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Zaneprázdněn(a)';

  @override
  String get myPresenceAway => 'Pryč';

  @override
  String get myPresenceInvisible => 'Neviditelný(á)';

  @override
  String get profileTitle => 'Můj profil';

  @override
  String get profileName => 'Jméno';

  @override
  String get profileGender => 'Pohlaví';

  @override
  String get profileBirthday => 'Narozeniny';

  @override
  String get profileRegion => 'Oblast';

  @override
  String get profileSignature => 'O mně';

  @override
  String get profileSignatureHint => 'Napište něco o sobě';

  @override
  String get profileTapTapText => 'Poklepání';

  @override
  String get profileTapTapHint =>
      'Text zobrazený při poklepání (max. 20 znaků)';

  @override
  String get profileAccountSection => 'Účet';

  @override
  String get profileBasicSection => 'Základní údaje';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Nenastaveno';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Nepropojeno';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileEmailUnbound => 'Nepropojeno';

  @override
  String get profileQrCode => 'Můj QR kód';

  @override
  String get profileChangePassword => 'Změnit heslo';

  @override
  String get profileGenderMale => 'Muž';

  @override
  String get profileGenderFemale => 'Žena';

  @override
  String get profileGenderOther => 'Jiné';

  @override
  String get profileGenderUnset => 'Nenastaveno';

  @override
  String get profileSaveFailed => 'Uložení se nezdařilo. Zkuste to znovu.';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink ID lze změnit jen jednou. Vybírejte pečlivě.';

  @override
  String get profileLppIdChangeFailed =>
      'Změna se nezdařila (StartLink ID lze změnit jen jednou)';

  @override
  String get profileChangePasswordOld => 'Aktuální heslo';

  @override
  String get profileChangePasswordNew => 'Nové heslo';

  @override
  String get profileChangePasswordConfirm => 'Potvrzení nového hesla';

  @override
  String get profileChangePasswordMismatch => 'Hesla se neshodují';

  @override
  String get profileChangePasswordSuccess =>
      'Heslo bylo změněno. Přihlaste se znovu.';

  @override
  String get profileChangePasswordFailed =>
      'Změna hesla se nezdařila. Zkuste to znovu.';

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get settingsSectionEnterprise => 'Firma';

  @override
  String get settingsSectionAccount => 'Účet';

  @override
  String get settingsSectionGeneral => 'Obecné';

  @override
  String get settingsSectionFeatures => 'Funkce';

  @override
  String get settingsSectionAbout => 'O aplikaci';

  @override
  String get settingsEnterpriseInfo => 'Údaje firmy';

  @override
  String get settingsProfile => 'Můj profil';

  @override
  String get settingsAccountSecurity => 'Zabezpečení účtu';

  @override
  String get settingsNotification => 'Oznámení';

  @override
  String get settingsDisplay => 'Zobrazení';

  @override
  String get settingsFriendPrivacy => 'Soukromí';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Historie chatů';

  @override
  String get settingsAbout => 'O aplikaci StartLink';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsTimezone => 'Časové pásmo';

  @override
  String get settingsAutoTranslate => 'Automatický překlad';

  @override
  String get settingsNetworkSwitch => 'Přepnout linku';

  @override
  String get enterpriseInfoTitle => 'Údaje firmy';

  @override
  String get enterpriseName => 'Jméno';

  @override
  String get enterpriseDescription => 'Popis';

  @override
  String get enterpriseUpdateSuccess => 'Úspěšně aktualizováno';

  @override
  String get enterpriseUpdateFailed =>
      'Aktualizace se nezdařila. Zkuste to znovu.';

  @override
  String get enterpriseLeave => 'Opustit firmu';

  @override
  String get enterpriseLeaveConfirm => 'Opravdu chcete opustit tuto firmu?';

  @override
  String get enterpriseLeaveSuccess => 'Opustili jste firmu';

  @override
  String get enterpriseLeaveFailed => 'Opuštění se nezdařilo. Zkuste to znovu.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Vlastník nemůže firmu přímo opustit. Nejprve převeďte vlastnictví.';

  @override
  String get enterpriseMemberCount => 'Členové';

  @override
  String get enterpriseCreatedAt => 'Vytvořeno';

  @override
  String get enterpriseCode => 'Kód firmy';

  @override
  String get enterpriseInviteMembers => 'Pozvat členy';

  @override
  String get enterpriseCopyInviteCode => 'Zkopírovat kód pozvánky';

  @override
  String get enterpriseInviteCodeCopied => 'Kód pozvánky zkopírován';

  @override
  String get groupCreateTitle => 'Nová skupina';

  @override
  String get groupNameHint => 'Zadejte název skupiny';

  @override
  String get groupCreateSuccess => 'Skupina vytvořena';

  @override
  String get groupCreateFailed => 'Vytvoření skupiny se nezdařilo';

  @override
  String get groupSettings => 'Nastavení skupiny';

  @override
  String get groupName => 'Název skupiny';

  @override
  String get groupAvatar => 'Obrázek skupiny';

  @override
  String get groupAnnouncement => 'Oznámení';

  @override
  String get groupMembers => 'Členové';

  @override
  String get groupAddMember => 'Přidat členy';

  @override
  String get groupRemoveMember => 'Odebrat člena';

  @override
  String get groupRemoveMemberConfirm => 'Odebrat tohoto člena?';

  @override
  String get groupSetAdmin => 'Jmenovat správcem';

  @override
  String get groupRemoveAdmin => 'Odebrat oprávnění správce';

  @override
  String get groupTransferOwner => 'Převést vlastnictví';

  @override
  String get groupTransferOwnerConfirm =>
      'Převést vlastnictví skupiny tomuto členovi?';

  @override
  String get groupTransferOwnerSuccess => 'Vlastnictví převedeno';

  @override
  String get groupTransferOwnerFailed => 'Převod se nezdařil. Zkuste to znovu.';

  @override
  String get groupLeave => 'Opustit skupinu';

  @override
  String get groupLeaveConfirm => 'Opustit tuto skupinu?';

  @override
  String get groupLeaveSuccess => 'Opustili jste skupinu';

  @override
  String get groupLeaveFailed => 'Opuštění se nezdařilo. Zkuste to znovu.';

  @override
  String get groupDissolve => 'Rozpustit skupinu';

  @override
  String get groupDissolveConfirm =>
      'Rozpustit tuto skupinu? Všichni členové budou odebráni.';

  @override
  String get groupDissolveSuccess => 'Skupina rozpuštěna';

  @override
  String get groupDissolveFailed => 'Rozpuštění se nezdařilo. Zkuste to znovu.';

  @override
  String get groupQrCode => 'QR kód skupiny';

  @override
  String get groupMuteAll => 'Ztlumit všechny';

  @override
  String get groupMuteAllOn => 'Zapnout ztlumení všech';

  @override
  String get groupMuteAllOff => 'Vypnout ztlumení všech';

  @override
  String get groupAllowMemberInvite => 'Povolit členům zvát další';

  @override
  String get groupAllowMemberModifyTitle =>
      'Povolit členům měnit název skupiny';

  @override
  String get groupAllowMemberAtAll => 'Povolit členům zmínit všechny';

  @override
  String get groupAllowMemberViewMemberList =>
      'Povolit členům zobrazit seznam členů';

  @override
  String get groupAllowQrCodeJoin => 'Povolit připojení QR kódem';

  @override
  String get groupRequireApproval => 'Vyžadovat schválení připojení';

  @override
  String get groupAllowMemberAddFriend => 'Povolit členům vzájemné přidávání';

  @override
  String get groupRoleOwner => 'Vlastník';

  @override
  String get groupRoleAdmin => 'Správce';

  @override
  String get groupRoleMember => 'Člen';

  @override
  String get groupNoMembers => 'Žádní členové';

  @override
  String get groupNoAnnouncements => 'Žádná oznámení';

  @override
  String get groupCreateAnnouncement => 'Zveřejnit oznámení';

  @override
  String get groupEditAnnouncement => 'Upravit oznámení';

  @override
  String get groupDeleteAnnouncement => 'Smazat oznámení';

  @override
  String get groupDeleteAnnouncementConfirm => 'Smazat toto oznámení?';

  @override
  String get groupAnnouncementTitle => 'Název';

  @override
  String get groupAnnouncementContent => 'Obsah';

  @override
  String get groupAnnouncementPin => 'Připnout oznámení';

  @override
  String groupMemberCount(int count) {
    return '$count členů';
  }

  @override
  String groupSelectedCount(int count) {
    return 'Vybráno: $count';
  }

  @override
  String get groupJoinRequestApprove => 'Souhlasím';

  @override
  String get groupJoinRequestReject => 'Odmítnout';

  @override
  String get groupJoinRequests => 'Žádosti o připojení';

  @override
  String get groupNoJoinRequests => 'Žádné žádosti o připojení';

  @override
  String get groupReadReceipts => 'Potvrzení o přečtení';

  @override
  String groupReadCount(int count) {
    return 'Přečteno: $count';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count nepřečtených';
  }

  @override
  String get friendAddTitle => 'Přidat kontakt';

  @override
  String get friendSearchHint => 'Telefon / e-mail / StartLink ID';

  @override
  String get friendRequestSent => 'Žádost o přátelství odeslána';

  @override
  String get friendRequestFailed => 'Odeslání se nezdařilo. Zkuste to znovu.';

  @override
  String get friendAlreadyFriend => 'Již jste kontakty';

  @override
  String get friendNewFriendsTitle => 'Noví přátelé';

  @override
  String get friendNoRequests => 'Žádné žádosti o přátelství';

  @override
  String get friendAccept => 'Přijmout';

  @override
  String get friendReject => 'Odmítnout';

  @override
  String get friendAccepted => 'Přijato';

  @override
  String get friendRejected => 'Odmítnuto';

  @override
  String get friendDeleteConfirm => 'Odebrat tento kontakt?';

  @override
  String get friendDeleteSuccess => 'Kontakt odebrán';

  @override
  String get friendDeleteFailed => 'Odebrání se nezdařilo. Zkuste to znovu.';

  @override
  String get friendRemarkName => 'Přezdívka';

  @override
  String get friendGroupName => 'Skupina';

  @override
  String get friendSendMessage => 'Zpráva';

  @override
  String get friendMatchTypeLppId => 'Nalezeno podle StartLink ID';

  @override
  String get friendMatchTypeMobile => 'Nalezeno podle telefonu';

  @override
  String get friendMatchTypeEmail => 'Nalezeno podle e-mailu';

  @override
  String get friendSearchEmpty => 'Žádní uživatelé nenalezeni';

  @override
  String get friendAddMessage => 'Chci si vás přidat do kontaktů';

  @override
  String get friendBlockConfirm => 'Zablokovat tohoto uživatele?';

  @override
  String get friendUnblockConfirm => 'Odblokovat tohoto uživatele?';

  @override
  String get friendBlockSuccess => 'Zablokováno';

  @override
  String get friendUnblockSuccess => 'Odblokováno';

  @override
  String get profilePageTitle => 'Osobní údaje';

  @override
  String get profilePageSendMessage => 'Zpráva';

  @override
  String get profilePageAddFriend => 'Přidat přítele';

  @override
  String get profilePageAlreadyFriend => 'Již jste přátelé';

  @override
  String get profilePageBlocked => 'Zablokováno';

  @override
  String get profilePageBlock => 'Zablokovat';

  @override
  String get profilePageUnblock => 'Odblokovat';

  @override
  String get profilePageHidden => 'Tento uživatel skryl svůj profil';

  @override
  String get profilePageFriendsOnly =>
      'Tento uživatel zobrazuje profil pouze přátelům';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Poznámky';

  @override
  String get profilePageEditRemark => 'Upravit přezdívku';

  @override
  String get profilePageSaveRemarkSuccess => 'Přezdívka uložena';

  @override
  String get profilePageSaveRemarkFailed =>
      'Uložení se nezdařilo. Zkuste to znovu.';

  @override
  String get searchTitle => 'Hledat';

  @override
  String get searchHint => 'Hledat podle telefonu, e-mailu nebo StartLink ID';

  @override
  String get searchNoResults => 'Žádné výsledky';

  @override
  String get searchMessages => 'Zprávy';

  @override
  String get searchUsers => 'Uživatelé';

  @override
  String get searchFailed => 'Hledání se nezdařilo. Zkuste to znovu.';

  @override
  String get scanTitle => 'Skenovat';

  @override
  String get scanFailed => 'Rozpoznání se nezdařilo. Zkuste to znovu.';

  @override
  String get scanInvalidQrCode => 'Neplatný QR kód';

  @override
  String get scanFlashOn => 'Zapnout svítilnu';

  @override
  String get scanFlashOff => 'Vypnout svítilnu';

  @override
  String get scanAlbum => 'Vybrat z alba';

  @override
  String get favoritesTitle => 'Oblíbené';

  @override
  String get favoritesEmpty => 'Zatím nic neuloženo';

  @override
  String get favoritesAll => 'Vše';

  @override
  String get favoritesText => 'Text';

  @override
  String get favoritesImage => 'Obrázky';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Hlasové zprávy';

  @override
  String get favoritesFile => 'Soubory';

  @override
  String get favoritesOther => 'Jiné';

  @override
  String get favoritesDeleteConfirm => 'Odebrat z oblíbených?';

  @override
  String get favoritesDeleteSuccess => 'Odebráno z uložených';

  @override
  String get favoritesDeleteFailed => 'Odebrání se nezdařilo';

  @override
  String get favoritesOriginalRecalled => 'Zpráva byla odvolána';

  @override
  String get favoritesViewOriginal => 'Zobrazit originál';

  @override
  String get favoritesSearchHint => 'Hledat v oblíbených';

  @override
  String get favoritesNoResults => 'Žádné odpovídající oblíbené položky';

  @override
  String get noticeTitle => 'Oznámení';

  @override
  String get noticeEmpty => 'Žádná oznámení';

  @override
  String get noticeDetail => 'Podrobnosti oznámení';

  @override
  String get noticePublishedAt => 'Zveřejněno';

  @override
  String get noticePriorityNormal => 'Běžný';

  @override
  String get noticePriorityImportant => 'Důležité';

  @override
  String get noticePriorityUrgent => 'Naléhavé';

  @override
  String get organizationTitle => 'Organizace';

  @override
  String get organizationEmpty => 'Žádné údaje o oddělení';

  @override
  String get organizationMembers => 'Členové';

  @override
  String get organizationDepartment => 'Oddělení';

  @override
  String get organizationPosition => 'Pozice';

  @override
  String get organizationLeader => 'Vedoucí';

  @override
  String get qrCodeTitle => 'Můj QR kód';

  @override
  String get qrCodeSave => 'Uložit do alba';

  @override
  String get qrCodeShare => 'Sdílet';

  @override
  String get qrCodeSaveSuccess => 'Uloženo do alba';

  @override
  String get qrCodeSaveFailed => 'Uložení se nezdařilo. Zkuste to znovu.';

  @override
  String get qrCodeRefresh => 'Obnovit QR kód';

  @override
  String get qrCodeExpired => 'QR kód vypršel. Obnovte jej.';

  @override
  String get qrCodeScanToAdd => 'Naskenujte pro přidání do kontaktů';

  @override
  String get spacePersonal => 'Osobní';

  @override
  String get spaceEnterprise => 'Firma';

  @override
  String get spaceJoinByCode => 'Připojit se kódem firmy';

  @override
  String get spaceJoinByInvite => 'Připojit se kódem pozvánky';

  @override
  String get spaceEnterCode => 'Zadejte kód firmy';

  @override
  String get spaceEnterInviteCode => 'Zadejte kód pozvánky';

  @override
  String get spaceSearchEnterprise => 'Hledat firmu';

  @override
  String get spaceJoinRequestSent => 'Žádost odeslána, čeká na schválení';

  @override
  String get spaceJoinRequestPending => 'Čeká na schválení';

  @override
  String get spaceJoinRequestApproved => 'Žádost schválena';

  @override
  String get spaceJoinRequestRejected => 'Žádost zamítnuta';

  @override
  String get spaceAlreadyMember => 'Již jste členem';

  @override
  String get spaceAutoApproved => 'Automaticky schváleno. Vítejte!';

  @override
  String get spacePendingApprovalHint =>
      'Registrace byla úspěšná. Vaše žádost o připojení byla odeslána.';

  @override
  String get spaceNoSpaces => 'Žádné prostory';

  @override
  String get spaceInviteExpired => 'Kód pozvánky vypršel';

  @override
  String get spaceInviteTargetMismatch =>
      'Tento kód pozvánky není pro váš účet';

  @override
  String get spaceAcceptInviteSuccess => 'Úspěšně jste se připojili k firmě';

  @override
  String get spaceAcceptInviteFailed =>
      'Připojení se nezdařilo. Zkuste to znovu.';

  @override
  String get spaceTenantSelectTitle => 'Vyberte prostor';

  @override
  String get spaceTenantSelectHint =>
      'Vyberte prostor, do kterého chcete vstoupit';

  @override
  String get spaceEnterPersonal => 'Vstoupit do osobního prostoru';

  @override
  String get spaceEnterEnterprise => 'Vstoupit do firemního prostoru';

  @override
  String get aboutTitle => 'O aplikaci StartLink';

  @override
  String get aboutVersion => 'Verze';

  @override
  String get aboutTerms => 'Uživatelská smlouva';

  @override
  String get aboutPrivacy => 'Zásady ochrany osobních údajů';

  @override
  String get aboutOpenSource => 'Licence otevřeného softwaru';

  @override
  String get aboutCheckUpdate => 'Zkontrolovat aktualizace';

  @override
  String get aboutLatestVersion => 'Používáte nejnovější verzi';

  @override
  String get aboutUpdateAvailable => 'Nová verze je k dispozici';

  @override
  String get aboutUpdateNow => 'Aktualizovat nyní';

  @override
  String get aboutUpdateLater => 'Později';

  @override
  String get notificationTitle => 'Oznámení';

  @override
  String get notificationGlobalMute => 'Nerušit';

  @override
  String get notificationSound => 'Zvuk';

  @override
  String get notificationVibration => 'Vibrace';

  @override
  String get notificationPreview => 'Náhled zprávy';

  @override
  String get notificationDndStart => 'Začátek režimu Nerušit';

  @override
  String get notificationDndEnd => 'Konec režimu Nerušit';

  @override
  String get blacklistTitle => 'Na černé listině';

  @override
  String get blacklistEmpty => 'Žádní zablokovaní uživatelé';

  @override
  String get blacklistRemove => 'Odblokovat';

  @override
  String get blacklistRemoveConfirm => 'Odblokovat tohoto uživatele?';

  @override
  String get feedbackTitle => 'Zpětná vazba';

  @override
  String get feedbackTypeComplaint => 'Stížnost';

  @override
  String get feedbackTypeSuggestion => 'Návrh';

  @override
  String get feedbackTypeBug => 'Hlášení chyby';

  @override
  String get feedbackContent => 'Popis';

  @override
  String get feedbackContentHint => 'Podrobně popište problém nebo návrh';

  @override
  String get feedbackContact => 'Kontakt (nepovinné)';

  @override
  String get feedbackSubmit => 'Odeslat';

  @override
  String get feedbackSuccess => 'Zpětná vazba odeslána. Děkujeme!';

  @override
  String get feedbackFailed => 'Odeslání se nezdařilo. Zkuste to znovu.';

  @override
  String get networkTitle => 'Přepnout linku';

  @override
  String get networkAutoSelect => 'Automaticky';

  @override
  String get networkManual => 'Ručně';

  @override
  String get timezoneTitle => 'Časové pásmo';

  @override
  String get timezoneAuto => 'Podle systému';

  @override
  String get autoTranslateTitle => 'Automatický překlad';

  @override
  String get autoTranslateEnabled => 'Zapnout automatický překlad';

  @override
  String get autoTranslateLanguage => 'Cílový jazyk';

  @override
  String get displayTitle => 'Zobrazení';

  @override
  String get displayFontSize => 'Velikost písma';

  @override
  String get displayChatBackground => 'Pozadí chatu';

  @override
  String get displayDarkMode => 'Vzhled';

  @override
  String get displayDarkModeSystem => 'Podle systému';

  @override
  String get displayDarkModeSystemHint =>
      'Automaticky přepínat podle nastavení systému';

  @override
  String get displayDarkModeOff => 'Světlý';

  @override
  String get displayDarkModeOffHint => 'Vždy používat světlý motiv';

  @override
  String get displayDarkModeOn => 'Tmavý';

  @override
  String get displayDarkModeOnHint => 'Vždy používat tmavý motiv';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Historie chatů';

  @override
  String get chatHistoryClear => 'Vymazat veškerou historii';

  @override
  String get chatHistoryClearConfirm =>
      'Vymazat veškerou historii chatů? Tuto akci nelze vrátit zpět.';

  @override
  String get chatHistoryClearSuccess => 'Historie chatů vymazána';

  @override
  String get accountSecurityTitle => 'Zabezpečení účtu';

  @override
  String get accountSecurityChangePassword => 'Změnit heslo';

  @override
  String get accountSecurityChangeMobile => 'Změnit telefonní číslo';

  @override
  String get accountSecurityChangeEmail => 'Změnit e-mail';

  @override
  String get accountSecurityLoggedDevices => 'Přihlášená zařízení';

  @override
  String get accountSecurityDeactivate => 'Zrušit účet';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Po 7 dnech budou všechny údaje trvale smazány. Zrušit účet?';

  @override
  String get loggedDevicesTitle => 'Přihlášená zařízení';

  @override
  String get loggedDevicesCurrent => 'Toto zařízení';

  @override
  String get loggedDevicesRevoke => 'Odhlásit se';

  @override
  String get loggedDevicesRevokeConfirm => 'Odhlásit se z tohoto zařízení?';

  @override
  String get loggedDevicesRevokeSuccess => 'Ze zařízení jste odhlášeni';

  @override
  String get loggedDevicesRevokeFailed => 'Nezdařilo se. Zkuste to znovu.';

  @override
  String get loggedDevicesLastActive => 'Poslední aktivita';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Počítač';

  @override
  String get loggedDevicesTypeUnknown => 'Neznámé zařízení';

  @override
  String get privacySettingsTitle => 'Soukromí';

  @override
  String get privacySearchableByMobile =>
      'Povolit hledání podle telefonního čísla';

  @override
  String get privacySearchableByLppId => 'Povolit hledání podle StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'Povolit žádosti o přátelství';

  @override
  String get privacyProfileVisibility => 'Viditelnost profilu';

  @override
  String get privacyEveryone => 'Všichni';

  @override
  String get privacyFriendsOfFriends => 'Přátelé přátel';

  @override
  String get privacyNobody => 'Nikdo';

  @override
  String get privacyFriendsOnly => 'Pouze přátelé';

  @override
  String get privacySaveSuccess => 'Nastavení uloženo';

  @override
  String get privacySaveFailed => 'Uložení se nezdařilo. Zkuste to znovu.';

  @override
  String get fontSizeTitle => 'Velikost písma';

  @override
  String get fontSizeSmall => 'Malá';

  @override
  String get fontSizeNormal => 'Standardní';

  @override
  String get fontSizeLarge => 'Velké';

  @override
  String get fontSizeExtraLarge => 'Extra velké';

  @override
  String get fontSizePreview => 'Náhled';

  @override
  String get chatBackgroundTitle => 'Pozadí chatu';

  @override
  String get chatBackgroundDefault => 'Výchozí';

  @override
  String get chatBackgroundCustom => 'Vlastní';

  @override
  String get chatBackgroundReset => 'Obnovit výchozí nastavení';

  @override
  String get termsTitle => 'Uživatelská smlouva';

  @override
  String get privacyPolicyTitle => 'Zásady ochrany osobních údajů';

  @override
  String get recentContactsTitle => 'Nedávné';

  @override
  String get recentContactsEmpty => 'Žádné nedávné kontakty';

  @override
  String get inviteFriendsTitle => 'Pozvat přátele';

  @override
  String get inviteFriendsCopyLink => 'Zkopírovat odkaz pozvánky';

  @override
  String get inviteFriendsLinkCopied => 'Odkaz pozvánky zkopírován';

  @override
  String get imageViewerTitle => 'Fotka';

  @override
  String get imageViewerSave => 'Uložit do alba';

  @override
  String get imageViewerSaveSuccess => 'Uloženo do alba';

  @override
  String get imageViewerSaveFailed => 'Uložení se nezdařilo. Zkuste to znovu.';

  @override
  String get customerServiceTitle => 'Centrum podpory';

  @override
  String get customerServiceQueue => 'Ve frontě';

  @override
  String get customerServiceActive => 'Aktivní';

  @override
  String get customerServiceClaim => 'Přijmout';

  @override
  String get customerServiceTakeover => 'Převzít';

  @override
  String get customerServiceClose => 'Ukončit podporu';

  @override
  String get customerServiceCloseConfirm => 'Ukončit tuto relaci podpory?';

  @override
  String get customerServiceNoQueue => 'Žádné relace ve frontě';

  @override
  String get customerServiceNoActive => 'Žádné aktivní relace';

  @override
  String get customerServiceVisitor => 'Návštěvník';

  @override
  String get customerServiceCustomer => 'Zákazník';

  @override
  String get customerServiceAssignedTo => 'Přiděleno';

  @override
  String get customerServiceTransferConversation => 'Předat chat';

  @override
  String get marketingToolbar => 'Marketingové nástroje';

  @override
  String get callIncoming => 'Příchozí hovor';

  @override
  String get callOutgoing => 'Odchozí hovor';

  @override
  String get callAccept => 'Přijmout';

  @override
  String get callReject => 'Odmítnout';

  @override
  String get callHangup => 'Ukončit';

  @override
  String get callMissed => 'Zmeškaný hovor';

  @override
  String get callDuration => 'Délka';

  @override
  String get callAudio => 'Hlasový hovor';

  @override
  String get callGeneric => 'Hovor';

  @override
  String get callVideo => 'Videohovor';

  @override
  String get callConnecting => 'Připojování...';

  @override
  String get callRinging => 'Vyzvánění...';

  @override
  String get callEnded => 'Hovor ukončen';

  @override
  String get callFailed => 'Hovor se nezdařil';

  @override
  String get callRejected => 'Hovor odmítnut';

  @override
  String get callTimeout => 'Bez odpovědi';

  @override
  String get callCancelled => 'Zrušeno';

  @override
  String get callUnknownPeer => 'Neznámé';

  @override
  String get callVideoInvitation => 'Pozvání k videohovoru';

  @override
  String get callAudioInvitation => 'Pozvání k hlasovému hovoru';

  @override
  String get callAnswerAudio => 'Přijmout hlasově';

  @override
  String get callAnswerVideo => 'Přijmout s videem';

  @override
  String get callViewProfile => 'Zobrazit profil';

  @override
  String get callOpeningCamera => 'Spouštění kamery...';

  @override
  String get callWaitingRemoteVideo => 'Čekání na video druhé strany...';

  @override
  String get callCameraOff => 'Kamera vypnuta';

  @override
  String get callCameraOn => 'Kamera zapnuta';

  @override
  String get callMicrophoneOff => 'Mikrofon vypnut';

  @override
  String get callMicrophoneOn => 'Mikrofon zapnut';

  @override
  String get callSpeakerOff => 'Reproduktor vypnut';

  @override
  String get callSpeakerOn => 'Reproduktor zapnut';

  @override
  String get callVideoPermissionFailure =>
      'Videohovor se nepodařilo zahájit. Zkontrolujte oprávnění ke kameře a mikrofonu a zkuste to znovu.';

  @override
  String get callAudioPermissionFailure =>
      'Hlasový hovor se nepodařilo zahájit. Zkontrolujte oprávnění k mikrofonu a zkuste to znovu.';

  @override
  String get callIncompleteIncoming =>
      'Údaje příchozího hovoru nejsou úplné a hovor nelze přijmout.';

  @override
  String get callInProgress => 'Probíhá hovor';

  @override
  String get callCalling => 'Volání...';

  @override
  String callEndedMedia(String media) {
    return '$media byl ukončen';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media byl odmítnut';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media nebyl přijat';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media byl zrušen';
  }

  @override
  String get callConnectionLost => 'Spojení hovoru přerušeno';

  @override
  String get callAdminEnded => 'Hovor ukončil správce';

  @override
  String callFailedMedia(String media) {
    return '$media se nezdařil';
  }

  @override
  String get callBusy => 'Druhá strana je zaneprázdněna';

  @override
  String callDurationValue(String duration) {
    return 'Délka hovoru $duration';
  }

  @override
  String get callNotConnected => 'Nepřipojeno';

  @override
  String get callDialed => 'Odchozí';

  @override
  String get callAnswered => 'Přijato';

  @override
  String get callRejectedByPeer => 'Druhá strana odmítla';

  @override
  String get callRejectedBySelf => 'Odmítnuto';

  @override
  String get callPeerDidNotAnswer => 'Druhá strana neodpověděla';

  @override
  String get callMissedIncoming => 'Zmeškaný příchozí hovor';

  @override
  String get callPeerCancelled => 'Druhá strana zrušila';

  @override
  String get notificationNewMessageTitle => 'Nová zpráva StartLink';

  @override
  String get notificationOnlineServiceTitle => 'Nová zpráva zákaznické podpory';

  @override
  String get notificationNewMessageBody => 'Obdrželi jste novou zprávu';

  @override
  String get notificationImagePreview => 'Odeslán obrázek';

  @override
  String get notificationVideoPreview => 'Odesláno video';

  @override
  String get notificationVoicePreview => 'Odeslána hlasová zpráva';

  @override
  String get notificationFilePreview => 'Odeslán soubor';

  @override
  String get notificationContactPreview => 'Odeslána vizitka';

  @override
  String get notificationCallLogPreview => 'Odeslán záznam hovoru';

  @override
  String get notificationLocationPreview => 'Sdílena poloha';

  @override
  String get notificationLinkPreview => 'Sdílen odkaz';

  @override
  String notificationMentionMe(String body) {
    return 'Zmínka o vás: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender vás zmínil(a): $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Zmínka o všech: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender zmínil(a) všechny: $body';
  }

  @override
  String get notificationSecurityTitle => 'Bezpečnostní upozornění účtu';

  @override
  String get notificationSecurityBody =>
      'Zabezpečení vašeho účtu StartLink se změnilo. Zkontrolujte jej.';

  @override
  String get notificationFriendAcceptedTitle => 'Žádost o přátelství přijata';

  @override
  String get notificationFriendRejectedTitle => 'Žádost o přátelství odmítnuta';

  @override
  String get notificationFriendAcceptedBody =>
      'Druhá strana přijala vaši žádost o přátelství';

  @override
  String get notificationFriendRejectedBody =>
      'Druhá strana odmítla vaši žádost o přátelství';

  @override
  String get notificationVideoCallTitle => 'Pozvání k videohovoru';

  @override
  String get notificationAudioCallTitle => 'Pozvání k hlasovému hovoru';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller vás pozval(a) k videohovoru';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller vás pozval(a) k hlasovému hovoru';
  }

  @override
  String get notificationMessageChannelName => 'Zprávy';

  @override
  String get notificationMessageChannelDescription =>
      'Zprávy chatu, záznamy hovorů a systémová upozornění';

  @override
  String get notificationCallChannelName => 'Hovory';

  @override
  String get notificationCallChannelDescription =>
      'Upozornění na hlasové hovory a videohovory';

  @override
  String get notificationSecurityChannelName => 'Zabezpečení účtu';

  @override
  String get notificationSecurityChannelDescription =>
      'Upozornění na přihlášení a změny hesla a mobilního čísla';

  @override
  String get notificationUnknownCaller => 'Neznámý volající';

  @override
  String get pendingJoinRequestsTitle => 'Nové žádosti';

  @override
  String get pendingJoinRequestsEmpty => 'Žádné žádosti';

  @override
  String get pendingJoinRequestApprove => 'Souhlasím';

  @override
  String get pendingJoinRequestReject => 'Odmítnout';

  @override
  String get pendingJoinRequestApproveSuccess => 'Schváleno';

  @override
  String get pendingJoinRequestRejectSuccess => 'Zamítnuto';

  @override
  String get pendingJoinRequestFailed => 'Akce se nezdařila. Zkuste to znovu.';

  @override
  String get myCustomersTitle => 'Moji zákazníci';

  @override
  String get myCustomersEmpty => 'Žádní zákazníci';

  @override
  String get groupListTitle => 'Skupiny';

  @override
  String get groupListEmpty => 'Žádné skupiny';

  @override
  String get addFriendTitle => 'Přidat kontakt';

  @override
  String get addFriendSearchHint => 'Telefon / e-mail / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Přidat';

  @override
  String get addFriendCannotAddSelf => 'Nemůžete přidat sami sebe';

  @override
  String get addFriendUnsupportedUser =>
      'Tohoto uživatele nelze přidat. Můžete mu napsat přímo.';

  @override
  String get addFriendMessageHint => 'Zadejte zprávu';

  @override
  String get addFriendSendRequest => 'Odeslat žádost';

  @override
  String get joinCompanyTitle => 'Připojit se k firmě';

  @override
  String get joinCompanyCodeHint => 'Zadejte kód firmy';

  @override
  String get joinCompanySearchHint => 'Hledat název firmy';

  @override
  String get joinCompanyApply => 'Požádat o připojení';

  @override
  String get joinCompanyApplySuccess => 'Žádost odeslána';

  @override
  String get joinCompanyApplyFailed =>
      'Podání žádosti se nezdařilo. Zkuste to znovu.';

  @override
  String get joinCompanyAutoApproved => 'Automaticky schváleno. Vítejte!';

  @override
  String get joinCompanyPending => 'Žádost odeslána, čeká na schválení';

  @override
  String get joinCompanyInviteCodeHint => 'Zadejte kód pozvánky';

  @override
  String get joinCompanyAcceptInvite => 'Přijmout pozvánku';

  @override
  String get joinCompanyNoResults => 'Žádné firmy nenalezeny';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count členů';
  }

  @override
  String get timezoneNameHawaii => 'Havaj';

  @override
  String get timezoneNameAlaska => 'Aljaška';

  @override
  String get timezoneNamePacificTime => 'Pacifický čas';

  @override
  String get timezoneNameMountainTime => 'Horský čas';

  @override
  String get timezoneNameCentralTime => 'Centrální čas';

  @override
  String get timezoneNameEasternTime => 'Východní čas';

  @override
  String get timezoneNameAtlanticTime => 'Atlantský čas';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azory';

  @override
  String get timezoneNameLondonDublin => 'Londýn/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlín/Paříž/Řím';

  @override
  String get timezoneNameCairoHelsinki => 'Káhira/Helsinky';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskva/Rijád';

  @override
  String get timezoneNameTehran => 'Teherán';

  @override
  String get timezoneNameDubaiBaku => 'Dubaj/Baku';

  @override
  String get timezoneNameKabul => 'Kábul';

  @override
  String get timezoneNameKarachiTashkent => 'Karáčí/Taškent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Bombaj/Nové Dillí';

  @override
  String get timezoneNameKathmandu => 'Káthmándú';

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
  String get timezoneNameSolomonIslands => 'Šalomounovy ostrovy';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fidži';

  @override
  String get networkSmartSelectBestRoute => 'Chytře vybrat nejlepší trasu';

  @override
  String get networkTesting => 'Testování...';

  @override
  String get networkTestingShort => 'Testování';

  @override
  String networkLatencyMs(int ms) {
    return 'Odezva $ms ms';
  }

  @override
  String get networkConnectionMode => 'Režim připojení';

  @override
  String get networkDirectMode => 'Přímý režim';

  @override
  String get networkProxyMode => 'Režim proxy';

  @override
  String get networkDirectModeDesc => 'Připojit přímo k serveru';

  @override
  String get networkProxyModeDesc => 'Připojit přes proxy server';

  @override
  String get networkDirectRoutes => 'Přímé trasy';

  @override
  String get networkProxyRoutes => 'Proxy trasy';

  @override
  String get networkTestAll => 'Otestovat vše';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Uzel v Hongkongu';

  @override
  String get networkSingaporeNode => 'Uzel v Singapuru';

  @override
  String get networkJapanNode => 'Uzel v Japonsku';

  @override
  String get networkUnitedStatesNode => 'Uzel ve Spojených státech';

  @override
  String get networkHint =>
      'Tipy:\n• Přímý režim: rychlejší a vhodný pro domácí použití\n• Režim proxy: stabilnější pro přeshraniční komunikaci\n• Klepnutím na ikonu obnovení otestujete odezvu jedné trasy';

  @override
  String get teenModeTitle => 'Režim pro dospívající';

  @override
  String get teenModeStatusOn => 'Zapnuto';

  @override
  String get teenModeStatusOff => 'Vypnuto';

  @override
  String get teenModeStatusLoading => 'Načítání';

  @override
  String get teenModeUnavailable =>
      'Stav režimu pro dospívající je dočasně nedostupný';

  @override
  String get teenModeInvalidResponse =>
      'Režim pro dospívající vrátil neplatnou odpověď';

  @override
  String get teenModeEnableDescription =>
      'Pravidla platformy omezí dobu používání a vybrané funkce.';

  @override
  String get teenModePasscode => 'Přístupový kód';

  @override
  String get teenModeCurrentPasscode => 'Aktuální přístupový kód';

  @override
  String get teenModeNewPasscode => 'Nový přístupový kód';

  @override
  String get teenModePasscodeHint => 'Zadejte 4–6 číslic';

  @override
  String get teenModeEnable => 'Zapnout režim pro dospívající';

  @override
  String get teenModeDisable => 'Vypnout režim pro dospívající';

  @override
  String get teenModeChangePasscode => 'Změnit přístupový kód';

  @override
  String get teenModeSource => 'Zapnul(a)';

  @override
  String get teenModeDailyUsage => 'Dnešní využití';

  @override
  String get teenModeRemaining => 'Zbývající čas';

  @override
  String get teenModeMinutesUnit => 'Minuty';

  @override
  String get teenModeUnlimited => 'Bez omezení';

  @override
  String get teenModeRequestExtension => 'Požádat o další čas';

  @override
  String get teenModeExtensionSubmitted =>
      'Žádost o další čas byla odeslána opatrovníkovi';

  @override
  String get teenModeTimeLimitReached => 'Dnešní limit používání byl dosažen';

  @override
  String get teenModeCurfewActive => 'Nyní platí omezení používání';

  @override
  String get teenModeReliefHint =>
      'Stále můžete prohlížet historii, kontaktovat oficiální podporu a hlásit problémy.';

  @override
  String get teenModeRestrictedNotice =>
      'Režim pro dospívající nyní brání odesílání zpráv';

  @override
  String get teenModeActionBlocked =>
      'Režim pro dospívající nyní brání této akci';

  @override
  String get teenModeMyRequests => 'Moje žádosti';

  @override
  String get guardianCenterTitle => 'Centrum opatrovníků';

  @override
  String get guardianRelationships => 'Opatrovnická propojení';

  @override
  String get guardianMinors => 'Děti pod mým dohledem';

  @override
  String get guardianApprovals => 'Čekající schválení';

  @override
  String get guardianBind => 'Zadejte propojovací kód';

  @override
  String get guardianCreateMinorCode => 'Jsem dítě — vytvořit kód';

  @override
  String get guardianCreateGuardianCode => 'Jsem opatrovník — vytvořit kód';

  @override
  String get guardianRelation => 'Propojení';

  @override
  String get guardianPrimary => 'Hlavní opatrovník';

  @override
  String get guardianCode => 'Šestimístný propojovací kód';

  @override
  String get guardianCodeHint => 'Zadejte kód poskytnutý druhou osobou';

  @override
  String get guardianCodeCreated =>
      'Kód vytvořen. Sdílejte jej před vypršením platnosti.';

  @override
  String get guardianEmpty => 'Žádná opatrovnická propojení';

  @override
  String get guardianNoMinors => 'Žádné děti pod dohledem';

  @override
  String get guardianUnbind => 'Odebrat propojení';

  @override
  String get guardianExtend => 'Přidat dítěti čas';

  @override
  String get guardianPolicyTitle => 'Pravidla používání';

  @override
  String get guardianPolicyLocked => 'Uzamčeno platformou';

  @override
  String get approvalEmpty => 'Žádné žádosti';

  @override
  String get approvalApprove => 'Souhlasím';

  @override
  String get approvalReject => 'Odmítnout';

  @override
  String get approvalPending => 'Čeká';

  @override
  String get approvalApproved => 'Schváleno';

  @override
  String get approvalRejected => 'Odmítnuto';

  @override
  String get approvalExpired => 'Expirovaná';

  @override
  String get approvalCancelled => 'Zrušeno';

  @override
  String get approvalReplayFailed =>
      'Původní akce se nezdařila. Zkuste ji znovu.';

  @override
  String get requestCancelled => 'Žádost zrušena';

  @override
  String get kycTitle => 'Ověření totožnosti';

  @override
  String get kycNotRequired => 'Ověření totožnosti není vyžadováno';

  @override
  String get kycVerified => 'Totožnost ověřena';

  @override
  String get kycDeclared => 'Údaje totožnosti odeslány';

  @override
  String get kycPending => 'Probíhá kontrola';

  @override
  String get kycRejected => 'Kontrola zamítnuta';

  @override
  String get kycNone => 'Údaje totožnosti nebyly odeslány';

  @override
  String get kycRealName => 'Jméno a příjmení';

  @override
  String get kycIdNumber => 'Číslo dokladu';

  @override
  String get kycIdType => 'Typ dokladu';

  @override
  String get kycApplicability =>
      'Zadejte pravdivé údaje pro vybraný doklad. Přijímané typy jsou uvedeny v seznamu.';

  @override
  String get kycCamera => 'Pořídit fotku';

  @override
  String get kycGallery => 'Vybrat z alba';

  @override
  String get kycPhotoLimit => 'Maximum na fotku';

  @override
  String get kycSelectPhoto => 'Vybrat fotografii';

  @override
  String get kycPhotoSelected => 'Vybráno';

  @override
  String get kycViewPhoto => 'Klepnutím zobrazíte fotku';

  @override
  String get kycReplacePhoto => 'Vybrat jinou fotku';

  @override
  String get kycDisclosure =>
      'K ověření totožnosti používáme vaše jméno, číslo dokladu a fotografie dokladu. Bez nich nelze žádost odeslat a některé omezené funkce nemusí být dostupné.';

  @override
  String get kycConsent =>
      'Uděluji samostatný souhlas s tímto zpracováním údajů totožnosti';

  @override
  String get kycConsentRequired => 'Před odesláním udělte samostatný souhlas';

  @override
  String get kycResubmitTitle => 'Znovu odeslat údaje totožnosti';

  @override
  String get kycResubmitWarning =>
      'Opětovné odeslání nahradí vaši čekající žádost. Pokračovat?';

  @override
  String get kycSubmitting => 'Odesílání';

  @override
  String get kycSubmitFailed => 'Odeslání se nezdařilo. Zkuste to znovu.';

  @override
  String get kycSubmitUnavailable => 'Údaje totožnosti nyní nelze odeslat';

  @override
  String get kycResubmitNotAllowed =>
      'Po zamítnutí nelze údaje znovu odeslat. V případě potřeby kontaktujte podporu.';

  @override
  String get kycDailyLimit =>
      'Dosáhli jste dnešního limitu odeslání. Zkuste to zítra.';

  @override
  String get kycTypeUnavailable =>
      'Žádné typy dokladů nejsou dostupné. Zkuste to později.';

  @override
  String get kycNameInvalid => 'Úřední jméno musí mít 2–64 znaků';

  @override
  String get kycNumberRequired => 'Zadejte číslo dokladu';

  @override
  String get kycFrontRequired => 'Nahrajte přední stranu dokladu';

  @override
  String get kycBackRequired => 'Nahrajte zadní stranu dokladu';

  @override
  String get kycPhotoTooLarge =>
      'Fotka překračuje limit velikosti. Zmenšete ji a zkuste to znovu.';

  @override
  String get kycAccountChanged =>
      'Účet nebo prostor se změnil. Otevřete stránku znovu.';

  @override
  String get kycPhotoInvalid => 'Vyberte platný obrázek';

  @override
  String get kycPortraitSide => 'Strana s fotografií';

  @override
  String get kycEmblemSide => 'Strana se znakem';

  @override
  String get kycPassportDataPage => 'Datová stránka pasu';

  @override
  String get kycPassportOtherPage => 'Vízová nebo volná stránka pasu';

  @override
  String get kycFront => 'Přední strana průkazu';

  @override
  String get kycBack => 'Zadní strana průkazu';

  @override
  String get kycRequired => 'Před vytvořením skupiny je nutné ověřit totožnost';

  @override
  String get kycGoVerify => 'Ověřit nyní';

  @override
  String get kycStatusUnknown =>
      'Stav totožnosti není dostupný. Obnovte později.';

  @override
  String get kycSuperseded =>
      'Novější odeslání nahradilo toto. Zkontrolujte poslední stav totožnosti.';

  @override
  String get kycMediaNotFound =>
      'Fotka dokladu není v tomto prostoru dostupná. Před odesláním ji vyberte znovu.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Hromadné zprávy zákazníkům';

  @override
  String get officialAccountBadge => 'Oficiální';

  @override
  String get officialAccountOpenConversation => 'Otevřít konverzaci';

  @override
  String get officialAccountJoinHint =>
      'Přidáním tohoto účtu se k firmě připojíte jako zákazník. Schválení přátelství není potřeba.';

  @override
  String get officialAccountJoinDisabled =>
      'Tato firma nepřijímá nové zákazníky. Kontaktujte podporu.';

  @override
  String get officialAccountRemoved =>
      'Byli jste odebráni z této firmy. Požádejte firmu o nové pozvání.';

  @override
  String get officialAccountBanned => 'Váš účet byl v této firmě deaktivován.';

  @override
  String get officialAccountUnavailable =>
      'Tento oficiální účet je nyní nedostupný.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'V aktuálním režimu není připojení k firmě povoleno.';

  @override
  String get officialAccountPlatformRequired =>
      'Pro přidání tohoto oficiálního účtu použijte účet platformy.';

  @override
  String get officialAccountOpenFailed =>
      'Konverzaci se nepodařilo otevřít. Zkuste to znovu.';

  @override
  String get officialAccountAccountChanged =>
      'Účet nebo prostor se změnil. Otevřete jej znovu.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Firemní adresář není aktuální. Zkuste to za chvíli.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Synchronizace oficiálního účtu se nezdařila. Místní obsah je stále dostupný.';

  @override
  String get officialAccountInboxSyncing =>
      'Synchronizace zpráv oficiálního účtu';

  @override
  String get diagnosticsTitle => 'Diagnostika';

  @override
  String get diagnosticsExplanation =>
      'Protokoly jsou anonymizované a obsahují provozní a chybové informace pro tento účet a prostor a veřejné události spuštění. Obsah chatů a přihlašovací údaje nejsou zahrnuty.';

  @override
  String get diagnosticsHour => 'Poslední hodina';

  @override
  String get diagnosticsDay => 'Posledních 24 hodin';

  @override
  String get diagnosticsWeek => '7 dní';

  @override
  String diagnosticsEventCount(int count) {
    return 'Dostupné události: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Protokoly se ukládají v tomto zařízení a zůstanou dostupné po restartu.';

  @override
  String get diagnosticsNotPersistent =>
      'Některé protokoly nebyly uloženy. Obnovením zkuste znovu.';

  @override
  String get diagnosticsExport => 'Exportovat a sdílet';

  @override
  String get diagnosticsRefresh => 'Obnovit';

  @override
  String get diagnosticsClear => 'Vymazat protokoly tohoto prostoru';

  @override
  String get diagnosticsClearConfirm =>
      'Vymazat diagnostické protokoly tohoto prostoru? Historie chatů bude zachována.';

  @override
  String get diagnosticsShared =>
      'Systémové sdílení dokončeno. Ověřte soubor v cílové aplikaci.';

  @override
  String get diagnosticsCancelled =>
      'Sdílení zrušeno. Můžete exportovat znovu.';

  @override
  String get diagnosticsUnconfirmed =>
      'Sdílení se nepodařilo potvrdit. Zkontrolujte cílovou aplikaci.';

  @override
  String get diagnosticsFailed => 'Akce se nezdařila. Zkuste to znovu.';
}
