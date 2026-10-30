// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get navWorkbench => 'Munkafelület';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'A fiókadatok betöltése sikertelen';

  @override
  String get startupFailureTitle => 'Az indítás sikertelen';

  @override
  String get startupFailureMessage =>
      'Ellenőrizze a hálózatot, és próbálja újra';

  @override
  String get privacyConsentTitle =>
      'Felhasználási feltételek és Adatvédelmi tájékoztató';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Üdvözli a $brand! A bejelentkezés, az azonnali üzenetküldés, a vállalati együttműködés, az online ügyfélszolgálat, az üzenetértesítések és a biztonsági védelem biztosításához szükséges adatokat a Felhasználási feltételek és az Adatvédelmi szabályzat szerint kezeljük.\n\nAmíg nem koppint az Elfogadom gombra, nem olvassuk a vágólapot, nem inicializáljuk a JPush/JCore vagy az eszközgyártók értesítési SDK-it, és ezekkel nem szerezzük meg az Android ID-t, OAID-t, a telepített alkalmazások listáját, MAC-címeket vagy hasonló adatokat. Ha egyelőre elutasítja, mentjük a választását; tovább olvashatja a dokumentumokat, és később újra dönthet.\n\nAz elfogadás után az üzenet-, ügyfélszolgálati és bejövőhívás-értesítések kézbesítéséhez a JPush/JCore és a gyártók értesítési szolgáltatásai kezelhetik az eszközmodellt, az Android verzióját, az alkalmazás csomagnevét és verzióját, a hálózattípust, az IP-címet, az Android ID-t, OAID-t, az értesítési Registration ID-t, a gyártói értesítési tokent, valamint a kézbesítési és megnyitási adatokat. Kikapcsoltuk a nem szükséges funkciókat, így az intelligens értesítéseket, a telepített alkalmazások listáját, a MAC-, IMEI- és IMSI-adatokat, a Wi-Fi-listákat, az automatikus ébresztést és az összekapcsolt indítást.\n\nA vágólapot csak akkor érjük el, amikor Ön másolást vagy beillesztést használ. A kamera, mikrofon, értesítések és más rendszerfunkciók engedélyét csak az adott funkció használatakor kérjük. Egy engedély megtagadása csak az adott funkciót érinti. Olvassa el az alábbi teljes dokumentumokat, majd önállóan döntse el, hogy elfogadja-e őket.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Üdvözli a $brand! A bejelentkezés, az azonnali üzenetküldés, a vállalati együttműködés, az online ügyfélszolgálat, az üzenetértesítések és a biztonsági védelem biztosításához szükséges adatokat a Felhasználási feltételek és az Adatvédelmi szabályzat szerint kezeljük.\n\nAmíg nem koppint az Elfogadom gombra, nem olvassuk a vágólapot, nem inicializáljuk a JPush/JCore-t, nem regisztrálunk az Apple Push Notification service (APNs) szolgáltatásban, és nem szerzünk értesítési azonosítókat, például JPush Registration ID-t vagy APNs-eszköztokent. Ha egyelőre elutasítja, mentjük a választását; tovább olvashatja a dokumentumokat, és később újra dönthet.\n\nAz elfogadás után az üzenet-, ügyfélszolgálati és bejövőhívás-értesítések kézbesítéséhez kezelhetjük az iPhone modelljét, az iOS verzióját, az alkalmazás csomagnevét és verzióját, a hálózattípust, az IP-címet, az IDFV-t, a JPush Registration ID-t, az APNs-eszköztokent, valamint a kézbesítési és megnyitási adatokat. A JPush/JCore kapcsolódik az értesítési szolgáltatáshoz; az Apple APNs az alkalmazásazonosítót, az eszköztokent és az értesítés tartalmát kezeli a rendszerértesítések kézbesítéséhez. A jelenlegi iOS-alkalmazás nem használ hirdetési szolgáltatásokat, és nem szerez IDFA-t.\n\nA vágólapot csak akkor érjük el, amikor Ön másolást vagy beillesztést használ. A kamera, mikrofon, értesítések és más rendszerfunkciók engedélyét csak az adott funkció használatakor kérjük. Egy engedély megtagadása csak az adott funkciót érinti. Olvassa el az alábbi teljes dokumentumokat, majd önállóan döntse el, hogy elfogadja-e őket.';
  }

  @override
  String get privacyConsentTermsLink => 'Felhasználói Szerződés';

  @override
  String get privacyConsentConjunction => 'és';

  @override
  String get privacyConsentPrivacyLink => 'Adatvédelmi Szabályzat';

  @override
  String get privacyConsentDecline => 'Elutasítom';

  @override
  String get privacyConsentDeclinedExit =>
      'Nem fogadta el a Felhasználási feltételeket és az Adatvédelmi szabályzatot. Az alkalmazás bezárul.';

  @override
  String get privacyConsentAccept => 'Elfogadom';

  @override
  String get privacyConsentRuntimeFailure =>
      'Az indítás sikertelen. Ellenőrizze a hálózatot, és próbálja újra.';

  @override
  String get privacyConsentSaveFailure =>
      'Nem sikerült menteni a választását. Próbálja újra.';

  @override
  String get appUpdateRequiredTitle => 'A folytatáshoz frissítés szükséges';

  @override
  String get appUpdateOptionalTitle => 'Új verzió elérhető';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Elérhető a $brand $version';
  }

  @override
  String get appUpdateLater => 'Később';

  @override
  String get appUpdateNow => 'Frissítés most';

  @override
  String get appUpdateProcessing => 'Feldolgozás...';

  @override
  String get appUpdateInvalidUrl =>
      'A frissítés címe érvénytelen. Próbálja később újra.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Nem sikerült megnyitni a frissítési hivatkozást. Próbálja később újra.';

  @override
  String get appUpdateDownloadInterrupted =>
      'A letöltés megszakadt. Ellenőrizze a hálózatot, és próbálja újra.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'A csomag ellenőrzése sikertelen. Töltse le újra.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Engedélyezze a $brand frissítéseinek telepítését a rendszerbeállításokban.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Nem sikerült megnyitni a rendszer telepítőjét. Ellenőrizze a telepítési engedélyeket.';

  @override
  String get appUpdateGenericFailure =>
      'A frissítés sikertelen. Ellenőrizze a hálózatot, és próbálja újra.';

  @override
  String get appUpdateUnavailable =>
      'Az új verzió még nem tölthető le. Próbálja később újra.';

  @override
  String get appUpdateCheckFailed =>
      'Nem sikerült ellenőrizni a frissítéseket. Próbálja később újra.';

  @override
  String get appUpdateChecking => 'Ellenőrzés';

  @override
  String get commonConfirm => 'Rendben';

  @override
  String get commonCancel => 'Mégse';

  @override
  String get commonSave => 'Mentés';

  @override
  String get commonEdit => 'Szerkesztés';

  @override
  String get commonDelete => 'Törlés';

  @override
  String get commonSearch => 'Keresés';

  @override
  String get commonLoading => 'Betöltés...';

  @override
  String get commonLoadFailed => 'Betöltés sikertelen';

  @override
  String get commonRetry => 'Újra';

  @override
  String get commonEmpty => 'Nincs adat';

  @override
  String get commonCopy => 'Másolás';

  @override
  String get commonForward => 'Továbbítás';

  @override
  String get commonFavorite => 'Mentés';

  @override
  String get commonClose => 'Bezárás';

  @override
  String get commonSend => 'Küldés';

  @override
  String get commonDone => 'Kész';

  @override
  String get commonMore => 'Továbbiak';

  @override
  String get commonSettings => 'Beállítások';

  @override
  String get commonCopied => 'Másolva';

  @override
  String get commonUnknown => 'Ismeretlen';

  @override
  String get commonNotSet => 'Nincs beállítva';

  @override
  String get commonUnbound => 'Nincs csatolva';

  @override
  String get commonViewAll => 'Összes megtekintése';

  @override
  String get commonSubmit => 'Beküldés';

  @override
  String get commonAdd => 'Hozzáadás';

  @override
  String get commonRemove => 'Eltávolítás';

  @override
  String get commonCreate => 'Létrehozás';

  @override
  String get commonUpdate => 'Frissítés';

  @override
  String get commonUpload => 'Feltöltés';

  @override
  String get commonShare => 'Megosztás';

  @override
  String get commonBlock => 'Letiltás';

  @override
  String get commonUnblock => 'Tiltás feloldása';

  @override
  String get commonMute => 'Némítás';

  @override
  String get commonUnmute => 'Némítás feloldása';

  @override
  String get commonPin => 'Kitűzött';

  @override
  String get commonUnpin => 'Rögzítés feloldása';

  @override
  String get commonMarkRead => 'Megjelölés olvasottként';

  @override
  String get commonMarkUnread => 'Megjelölés olvasatlanként';

  @override
  String get commonOnline => 'Elérhető';

  @override
  String get commonOffline => 'Nem elérhető';

  @override
  String get commonOperationFailed => 'A művelet sikertelen. Próbálja újra.';

  @override
  String get commonNetworkError => 'Hálózati hiba. Ellenőrizze a kapcsolatot.';

  @override
  String get navMessages => 'Üzenetek';

  @override
  String get navContacts => 'Névjegyek';

  @override
  String get navMe => 'Én';

  @override
  String get authLoginTitle => 'Bejelentkezés a StartLinkbe';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'E-mail';

  @override
  String get authTabLoginName => 'StartLink-azonosító';

  @override
  String get authHintMobile => 'Adja meg a telefonszámot';

  @override
  String get authHintEmail => 'Adja meg az e-mail címét';

  @override
  String get authHintPassword => 'Írja be a jelszavát';

  @override
  String get authHintCode => 'Adja meg az ellenőrző kódot';

  @override
  String get authHintLoginName =>
      'Adja meg a StartLink-azonosítót (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Bejelentkezés';

  @override
  String get authGetCode => 'Kód kérése';

  @override
  String authResendCode(int seconds) {
    return 'Újraküldés $seconds mp múlva';
  }

  @override
  String get authUsePassword => 'Jelszó használata';

  @override
  String get authUseCode => 'Ellenőrző kód használata';

  @override
  String get authAgreementPrefix => 'Elolvastam és elfogadom a';

  @override
  String get authAgreementAnd => 'és';

  @override
  String get authTermsLink => 'Felhasználói Szerződés';

  @override
  String get authPrivacyLink => 'Adatvédelmi Szabályzat';

  @override
  String get authCaptchaTitle => 'Biztonsági ellenőrzés';

  @override
  String get authCaptchaHint => 'Adja meg a választ';

  @override
  String get authCaptchaFailed =>
      'Nem sikerült lekérni a CAPTCHA-feladatot. Próbálja újra.';

  @override
  String get authErrorEmptyCode => 'Adja meg az ellenőrző kódot';

  @override
  String get authErrorEmptyPassword => 'Írja be a jelszavát';

  @override
  String get authErrorEmptyLoginName => 'Adja meg a StartLink-azonosítót';

  @override
  String get authErrorWrongCredentials => 'Hibás fiók vagy jelszó';

  @override
  String get authDeactivatingTitle => 'Fiók megszüntetése';

  @override
  String get authDeactivatingContent =>
      'Fiókja a megszüntetés előtti várakozási időszakban van (7 nap).\n\nA megszüntetés visszavonásához koppintson a „Megszüntetés visszavonása” gombra; az alkalmazás megnyitásához a „Folytatás” gombra.';

  @override
  String get authContinueUse => 'Folytatás';

  @override
  String get authCancelDeactivation => 'Megszüntetés visszavonása';

  @override
  String get authDeactivationCancelled =>
      'A megszüntetés visszavonva, a fiók helyreállítva';

  @override
  String get authDeactivationCancelFailed =>
      'A visszavonás sikertelen. Próbálja újra.';

  @override
  String get authLogout => 'Kijelentkezés';

  @override
  String get authLogoutConfirm => 'Biztosan kijelentkezik?';

  @override
  String get authSendingCode => 'Küldés...';

  @override
  String get authCodeSent => 'Ellenőrző kód elküldve';

  @override
  String get authLoginFailed => 'A bejelentkezés sikertelen. Próbálja újra.';

  @override
  String get authRegisterFailed => 'A regisztráció sikertelen. Próbálja újra.';

  @override
  String get authEnterpriseCode => 'Vállalati kód';

  @override
  String get authEnterpriseCodeHint => 'Adja meg a vállalati kódot';

  @override
  String get authPendingApproval =>
      'Sikeres regisztráció. A vállalathoz csatlakozási kérelme elküldve, jóváhagyásra vár.';

  @override
  String get authNoAccount => 'Nincs fiókja?';

  @override
  String get authRegisterNow => 'Regisztráció most';

  @override
  String get authCountryPickerTitle => 'Ország/régió kiválasztása';

  @override
  String get authCountrySearchHint => 'Ország/régió keresése';

  @override
  String get authCountryChinaMainland => 'Kínai szárazföld';

  @override
  String get authCountryHongKong => 'Hongkong, Kína';

  @override
  String get authCountryMacau => 'Makaó, Kína';

  @override
  String get authCountryTaiwan => 'Tajvan, Kína';

  @override
  String get authCountryUnitedStates => 'Egyesült Államok';

  @override
  String get authCountryUnitedKingdom => 'Egyesült Királyság';

  @override
  String get authCountryJapan => 'Japán';

  @override
  String get authCountrySouthKorea => 'Dél-Korea';

  @override
  String get authCountrySingapore => 'Szingapúr';

  @override
  String get authCountryMalaysia => 'Malajzia';

  @override
  String get authCountryAustralia => 'Ausztrália';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Németország';

  @override
  String get authCountryFrance => 'Franciaország';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Thaiföld';

  @override
  String get authCountryVietnam => 'Vietnám';

  @override
  String get authCountryIndonesia => 'Indonézia';

  @override
  String get authCountryPhilippines => 'Fülöp-szigetek';

  @override
  String get authQuickLoginTitle => 'Gyors bejelentkezés';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Bejelentkezés folyamatban. Várjon.';

  @override
  String get authRoleOwner => 'Tulajdonos';

  @override
  String get authRoleAdministrator => 'Rendszergazda';

  @override
  String get authRoleCustomerService => 'Ügyfélszolgálat';

  @override
  String get authRoleTechnicalSupport => 'Műszaki támogatás';

  @override
  String get authRoleEmployee => 'Alkalmazott';

  @override
  String get authRoleMember => 'Tag';

  @override
  String get authRoleEnterpriseCustomer => 'Vállalati ügyfél';

  @override
  String get authUnavailablePrefix => 'Nem elérhető · ';

  @override
  String get authUnassignedService => 'Nincs kijelölt ügyintéző';

  @override
  String authAssignedService(String staff) {
    return 'Kijelölve: $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Ügyfél · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Alkalmazott · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count felhasználó';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Személyazonosság';

  @override
  String get authRegisterTitle => 'Regisztráció';

  @override
  String get authNickname => 'Becenév';

  @override
  String get authNicknameHint => 'Állítson be becenevet';

  @override
  String get authPassword => 'Jelszó';

  @override
  String get authPasswordSetHint => 'Állítson be jelszót (legalább 6 karakter)';

  @override
  String get authConfirmPassword => 'Jelszó megerősítése';

  @override
  String get authConfirmPasswordHint => 'Adja meg újra a jelszót';

  @override
  String get authVerificationCode => 'Ellenőrző kód';

  @override
  String get authRegisterAndLogin => 'Regisztráció és bejelentkezés';

  @override
  String get authHaveAccount => 'Már van fiókja?';

  @override
  String get authGoLogin => 'Bejelentkezés';

  @override
  String get authEmailVerificationUnavailable =>
      'Az e-mailes ellenőrzés nem elérhető. Regisztráljon mobiltelefonszámmal.';

  @override
  String get authSmsVerificationUnavailable =>
      'Az SMS-ellenőrzés nem elérhető. Regisztráljon e-mail-címmel.';

  @override
  String get authSendFailed => 'Nem sikerült elküldeni. Próbálja újra.';

  @override
  String get authErrorEmptyNickname => 'Adjon meg becenevet';

  @override
  String get authErrorInvalidMobile => 'Adjon meg érvényes mobiltelefonszámot';

  @override
  String get authErrorInvalidEmail => 'Adjon meg érvényes e-mail-címet';

  @override
  String get authErrorPasswordTooShort =>
      'A jelszónak legalább 6 karakterből kell állnia';

  @override
  String get authErrorPasswordMismatch => 'A jelszavak nem egyeznek';

  @override
  String get authErrorVerificationRequired =>
      'Először kérje le és adja meg az ellenőrző kódot';

  @override
  String get authRegisterErrorTitle => 'A regisztráció sikertelen';

  @override
  String get authGotIt => 'Rendben';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'A(z) „$code” vállalat nem található. Ellenőrizze a vállalati kódot.';
  }

  @override
  String get authTenantSearchFailed => 'A keresés sikertelen. Próbálja újra.';

  @override
  String get authInvitationInvalid =>
      'A meghívókód érvénytelen. Ellenőrizze, és próbálja újra.';

  @override
  String get authCollapseJoin => 'Csatlakozási adatok elrejtése';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Érvényes meghívó: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Megtalált vállalat: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Szervezet kiválasztása';

  @override
  String get authNoOrganization => 'Nincs elérhető szervezet';

  @override
  String get authNoOrganizationHint =>
      'Kérje meg a rendszergazdát, hogy hívja meg egy szervezetbe';

  @override
  String get authPersonalSpace => 'Személyes tér';

  @override
  String get authPersonalSpaceSubtitle =>
      'Baráti beszélgetések és személyes kedvencek';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Nem sikerült ellenőrizni a tér azonosságát. Próbálja újra.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Nem sikerült helyreállítani a személyes teret. Próbálja újra.';

  @override
  String get authJoinEnterpriseFailed =>
      'Nem sikerült csatlakozni a vállalathoz. Próbálja később újra.';

  @override
  String get homeTitle => 'Üzenetek';

  @override
  String get homeGatewayConnectingTitle => 'Kapcsolódás';

  @override
  String get homePersonalSpace => 'Személyes';

  @override
  String get homeOfficialService => 'Hivatalos ügyfélszolgálat';

  @override
  String get homeSwitchSpace => 'Tér váltása';

  @override
  String get homeSpaceSubtitle => 'Személyes · Vállalati';

  @override
  String get homeJoinEnterprise => 'Csatlakozás vállalathoz';

  @override
  String get homeCreateGroup => 'Új csoport';

  @override
  String get homeAddFriend => 'Névjegy hozzáadása';

  @override
  String get homeScan => 'Beolvasás';

  @override
  String get homeJoinNewSpace => 'Csatlakozás új térhez';

  @override
  String get homeSearchConversation => 'Keresés';

  @override
  String get homeNoMessages => 'Nincs üzenet';

  @override
  String get homeDeleteConversation => 'Beszélgetés törlése';

  @override
  String get homeDeleteConversationConfirm =>
      'Törli ezt a beszélgetést? Az előzmények törlődnek.';

  @override
  String get homePersonalNote => 'Én (személyes jegyzetek)';

  @override
  String get homeWorkNote => 'Én (munkajegyzetek)';

  @override
  String homeConversationCount(int count) {
    return '$count beszélgetés';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count olvasatlan';
  }

  @override
  String get chatInputHint => 'Írjon üzenetet...';

  @override
  String get chatVoiceHint => 'Tartsa nyomva a beszédhez';

  @override
  String get chatVoiceRelease => 'Engedje fel a küldéshez';

  @override
  String get chatVoiceCancel => 'Húzza felfelé a megszakításhoz';

  @override
  String get chatMenuCopy => 'Másolás';

  @override
  String get chatMenuForward => 'Továbbítás';

  @override
  String get chatMenuRecall => 'Üzenet visszavonása';

  @override
  String get chatMenuDelete => 'Törlés';

  @override
  String get chatMenuFavorite => 'Mentés';

  @override
  String get chatMenuReply => 'Válasz';

  @override
  String get chatMenuMultiSelect => 'Kiválasztás';

  @override
  String get chatMenuTranslate => 'Fordítás';

  @override
  String get chatMenuVoiceToText => 'Szöveggé alakítás';

  @override
  String get chatMenuTextToSpeech => 'Felolvasás';

  @override
  String get chatStatusRecalled => 'Üzenet visszavonva';

  @override
  String get chatRecallSuccess => 'Visszavonva';

  @override
  String get chatRecallFailed => 'A visszavonás sikertelen';

  @override
  String get chatRecallTimeout =>
      'A 2 percnél régebbi üzenetek nem vonhatók vissza';

  @override
  String get chatTranslateFailed => 'A fordítás sikertelen. Próbálja újra.';

  @override
  String get chatTranslateNotConfigured =>
      'A fordítási szolgáltatás nem elérhető';

  @override
  String get chatVoiceToTextFailed =>
      'Az átalakítás sikertelen. Próbálja újra.';

  @override
  String get chatTextToSpeechFailed =>
      'A felolvasás sikertelen. Próbálja újra.';

  @override
  String get chatVoiceToText => 'Átalakítás';

  @override
  String get chatForwardSuccess => 'Továbbítva';

  @override
  String get chatForwardFailed => 'A továbbítás sikertelen. Próbálja újra.';

  @override
  String get chatNoConversations => 'Nincs beszélgetés a továbbításhoz';

  @override
  String get chatSendFailed => 'A küldés sikertelen';

  @override
  String get chatResend => 'Kód újraküldése';

  @override
  String get chatNotFriend => 'Nincs a névjegyek között';

  @override
  String get chatNotFriendHint => 'Még nem névjegyek. Nem küldhetők üzenetek.';

  @override
  String get chatMutedHint => 'Minden tag némítva';

  @override
  String get chatFileUploadFailed =>
      'A fájl feltöltése sikertelen. Próbálja újra.';

  @override
  String get chatFileStatusNotDownloaded => 'Nincs letöltve';

  @override
  String get chatFileStatusDownloaded => 'Letöltve';

  @override
  String get chatFileStatusUploading => 'Feltöltés';

  @override
  String get chatFileStatusUploadFailed => 'Feltöltés sikertelen';

  @override
  String get chatCardSendFailed => 'A névjegykártya küldése sikertelen';

  @override
  String get chatFavoriteSuccess => 'Mentve';

  @override
  String get chatFavoriteFailed => 'A kedvencekhez adás sikertelen';

  @override
  String get chatLoadFailed => 'Betöltés sikertelen';

  @override
  String get chatImageMessage => '[Kép]';

  @override
  String get chatVoiceMessage => '[Hangüzenet]';

  @override
  String get chatVideoMessage => '[Videó]';

  @override
  String get chatFileMessage => '[Fájl]';

  @override
  String get chatLocationMessage => '[Hely]';

  @override
  String get chatContactCardMessage => '[Névjegy]';

  @override
  String get chatCallLogMessage => '[Hívás]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return '$count olvasó';
  }

  @override
  String get chatUnread => 'Olvasatlan';

  @override
  String get chatRecalledSelf => 'Visszavont egy üzenetet';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender visszavont egy üzenetet';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Fordítás: $translation';
  }

  @override
  String get chatMessageDeleted => 'Üzenet törölve';

  @override
  String get chatPeer => 'Egyéb';

  @override
  String get chatSelf => 'Én';

  @override
  String get chatGenericMessage => '[Üzenet]';

  @override
  String get chatVoiceHideText => 'Szöveg elrejtése';

  @override
  String get chatVoiceShowText => 'Szöveggé alakítás';

  @override
  String get chatFileDefaultName => 'Fájl';

  @override
  String get chatContactDefaultName => 'Névjegy';

  @override
  String get chatContactCardTitle => 'Névjegykártya';

  @override
  String get chatCallMissed => 'Nem fogadott';

  @override
  String get chatCallCancelled => 'Megszakítva';

  @override
  String get chatCallRejected => 'Elutasítva';

  @override
  String get chatCallDisconnected => 'Kapcsolat megszakadt';

  @override
  String get chatCallEnded => 'Hívás véget ért';

  @override
  String get chatCallFailed => 'A hívás sikertelen';

  @override
  String chatCallDuration(String duration) {
    return 'Időtartam: $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videóhívás';

  @override
  String get chatVoiceCallTitle => 'Hanghívás';

  @override
  String get chatToolPhotos => 'Fotók';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Fájl';

  @override
  String get chatToolLocation => 'Helyszín';

  @override
  String get chatToolContactCard => 'Névjegy';

  @override
  String get chatToolVoiceCall => 'Hanghívás';

  @override
  String get chatToolVideoCall => 'Videóhívás';

  @override
  String get chatToolFavorites => 'Kedvencek';

  @override
  String get chatToolTranslate => 'Fordítás';

  @override
  String get chatTranslationChooseLanguage => 'Fordítás nyelvének kiválasztása';

  @override
  String get chatTranslationEnterText => 'Először írjon be szöveget';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Az említést tartalmazó üzenetek nem fordíthatók';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Ütemezett üzenet szerkesztésekor a fordítás nem elérhető';

  @override
  String get chatTranslationFailed => 'A fordítás sikertelen. Próbálja újra.';

  @override
  String get chatTranslationEmpty => 'Nem érkezett fordítás. Próbálja újra.';

  @override
  String get chatTranslationTranslating => 'Fordítás…';

  @override
  String get chatTranslationSend => 'Fordítás küldése';

  @override
  String get chatTranslationSending => 'Küldés…';

  @override
  String get chatTranslationExpand => 'Több megjelenítése';

  @override
  String get chatTranslationCollapse => 'Kevesebb megjelenítése';

  @override
  String get chatFileTooLarge => 'A fájl meghaladja a korlátot (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Csak a tulajdonos vagy a kijelölt tagok írhatnak.';

  @override
  String get chatImageUploadUnsupported =>
      'A kép feltöltése sikertelen. A kiszolgálói támogatás még nem elérhető.';

  @override
  String get chatFavoriteLongPressHint =>
      'Tartsa nyomva az üzenetet a kedvencekhez adáshoz';

  @override
  String chatSelectedCount(int count) {
    return '$count kiválasztva';
  }

  @override
  String get chatLocationSheetTitle => 'Hely küldése';

  @override
  String get chatLocationNameLabel => 'Hely neve';

  @override
  String get chatLocationNameHint => 'pl. iroda, ügyfél címe';

  @override
  String get chatLocationAddressLabel => 'Cím';

  @override
  String get chatLocationOptionalHint => 'Nem kötelező';

  @override
  String get chatLocationLatitudeLabel => 'Földrajzi szélesség';

  @override
  String get chatLocationLatitudeHint => '-90 és 90 között';

  @override
  String get chatLocationLongitudeLabel => 'Földrajzi hosszúság';

  @override
  String get chatLocationLongitudeHint => '-180 és 180 között';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Adja meg: $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return 'A(z) $label a megengedett tartományon kívül van';
  }

  @override
  String get chatLocationDefaultTitle => 'Helyszín';

  @override
  String get chatMutedFullNotice =>
      'Ez a csoport némítva van. Csak a tulajdonos vagy a kijelölt tagok írhatnak.';

  @override
  String get chatNotFriendSendBlocked =>
      'Már nem barátok, ezért nem küldhet üzenetet';

  @override
  String get chatPersonalNotesTitle => 'Személyes jegyzetek';

  @override
  String get chatWorkNotesTitle => 'Munkajegyzetek';

  @override
  String get chatPersonalNotesDescription =>
      'Jegyezze fel személyes gondolatait és mentse fontos adatait ide\nEszközök között szinkronizálva bármikor elérhető';

  @override
  String get chatWorkNotesDescription =>
      'Jegyezze fel munkafeladatait és mentse munkaanyagait ide\nA csapatterek elkülönítve és biztonságban maradnak';

  @override
  String get chatNoMessages => 'Nincs üzenet';

  @override
  String chatReplyTo(String sender) {
    return 'Válasz neki: $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return 'A(z) $feature hamarosan elérhető';
  }

  @override
  String get chatForwardSelectTitle => 'Beszélgetés kiválasztása';

  @override
  String get chatContactSelectTitle => 'Névjegy kiválasztása';

  @override
  String get chatNoContacts => 'Nincsenek névjegyek';

  @override
  String get contactsTitle => 'Névjegyek';

  @override
  String get contactsSearch => 'Névjegyek keresése';

  @override
  String get contactsNewFriends => 'Új barátok';

  @override
  String get contactsGroups => 'Csoportok';

  @override
  String get contactsFavorites => 'Kedvencek';

  @override
  String get contactsRecent => 'Legutóbbiak';

  @override
  String get contactsOrganization => 'Szervezet';

  @override
  String get contactsAnnouncement => 'Közlemények';

  @override
  String get contactsNewApplications => 'Új kérelmek';

  @override
  String get contactsCustomerGroups => 'Ügyfélcsoportok';

  @override
  String get contactsAllCustomers => 'Összes ügyfél';

  @override
  String get contactsMyCustomers => 'Saját ügyfelek';

  @override
  String get contactsViewAll => 'Összes megtekintése';

  @override
  String get contactsMyContacts => 'Saját névjegyek';

  @override
  String get contactsMyAdvisor => 'Saját tanácsadó';

  @override
  String get contactsNoAdvisor => 'Még nincs kijelölt tanácsadó';

  @override
  String get contactsAdvisorLoading => 'Betöltés...';

  @override
  String get contactsNavigateFailed => 'A navigáció sikertelen. Próbálja újra.';

  @override
  String get contactsEmpty => 'Nincsenek névjegyek';

  @override
  String get contactsNoAnnouncement => 'Nincsenek közlemények';

  @override
  String get contactsOfficialBadge => 'Hivatalos';

  @override
  String get contactsCustomerBadge => 'Ügyfél';

  @override
  String get contactsEmptyCustomers => 'Nincsenek ügyfelek';

  @override
  String get myTitle => 'Én';

  @override
  String get myEnterpriseInfo => 'Vállalati adatok';

  @override
  String get myEnterpriseManage => 'Vállalatkezelés';

  @override
  String get myQrCode => 'QR-kód';

  @override
  String get myFavorites => 'Kedvencek';

  @override
  String get myLanguage => 'Nyelv';

  @override
  String get myTimezone => 'Időzóna';

  @override
  String get myAutoTranslate => 'Automatikus fordítás';

  @override
  String get myNetworkSwitch => 'Vonal váltása';

  @override
  String get mySettings => 'Beállítások';

  @override
  String get myLogout => 'Kijelentkezés';

  @override
  String get myLogoutConfirm => 'Biztosan kijelentkezik?';

  @override
  String get myLeaveEnterprise => 'Kilépés a vállalatból';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Biztosan kilép ebből a vállalatból? Elveszíti a hozzáférést a vállalati adatokhoz.';

  @override
  String get myLeaveEnterpriseSuccess => 'Kilépett a vállalatból';

  @override
  String get myLeaveEnterpriseFailed => 'A kilépés sikertelen. Próbálja újra.';

  @override
  String get myLppIdCopied => 'StartLink-azonosító másolva';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink-azonosító: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count névjegy';
  }

  @override
  String get myAutoSelect => 'Automatikus';

  @override
  String get myPresenceStatus => 'Elérhetőség';

  @override
  String get myPresenceStatusTitle => 'Elérhetőség beállítása';

  @override
  String get myPresenceOnline => 'Elérhető';

  @override
  String get myPresenceBusy => 'Elfoglalt';

  @override
  String get myPresenceAway => 'Távol';

  @override
  String get myPresenceInvisible => 'Láthatatlan';

  @override
  String get profileTitle => 'Profilom';

  @override
  String get profileName => 'Név';

  @override
  String get profileGender => 'Nem';

  @override
  String get profileBirthday => 'Születésnap';

  @override
  String get profileRegion => 'Régió';

  @override
  String get profileSignature => 'Bemutatkozás';

  @override
  String get profileSignatureHint => 'Írjon magáról néhány szót';

  @override
  String get profileTapTapText => 'Koppintás';

  @override
  String get profileTapTapHint =>
      'Koppintáskor megjelenő szöveg (legfeljebb 20 karakter)';

  @override
  String get profileAccountSection => 'Fiók';

  @override
  String get profileBasicSection => 'Alapadatok';

  @override
  String get profileLppId => 'StartLink-azonosító';

  @override
  String get profileLppIdNotSet => 'Nincs beállítva';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Nincs csatolva';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileEmailUnbound => 'Nincs csatolva';

  @override
  String get profileQrCode => 'Saját QR-kód';

  @override
  String get profileChangePassword => 'Jelszó módosítása';

  @override
  String get profileGenderMale => 'Férfi';

  @override
  String get profileGenderFemale => 'Nő';

  @override
  String get profileGenderOther => 'Egyéb';

  @override
  String get profileGenderUnset => 'Nincs beállítva';

  @override
  String get profileSaveFailed => 'A mentés sikertelen. Próbálja újra.';

  @override
  String get profileLppIdTitle => 'StartLink-azonosító';

  @override
  String get profileLppIdSetOnce =>
      'A StartLink-azonosító csak egyszer módosítható. Válasszon körültekintően.';

  @override
  String get profileLppIdChangeFailed =>
      'A módosítás sikertelen (a StartLink-azonosító csak egyszer módosítható)';

  @override
  String get profileChangePasswordOld => 'Jelenlegi jelszó';

  @override
  String get profileChangePasswordNew => 'Új jelszó';

  @override
  String get profileChangePasswordConfirm => 'Új jelszó megerősítése';

  @override
  String get profileChangePasswordMismatch => 'A jelszavak nem egyeznek';

  @override
  String get profileChangePasswordSuccess =>
      'A jelszó módosult. Jelentkezzen be újra.';

  @override
  String get profileChangePasswordFailed =>
      'A jelszó módosítása sikertelen. Próbálja újra.';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get settingsSectionEnterprise => 'Vállalat';

  @override
  String get settingsSectionAccount => 'Fiók';

  @override
  String get settingsSectionGeneral => 'Általános';

  @override
  String get settingsSectionFeatures => 'Funkciók';

  @override
  String get settingsSectionAbout => 'Névjegy';

  @override
  String get settingsEnterpriseInfo => 'Vállalati adatok';

  @override
  String get settingsProfile => 'Profilom';

  @override
  String get settingsAccountSecurity => 'Fiókbiztonság';

  @override
  String get settingsNotification => 'Értesítések';

  @override
  String get settingsDisplay => 'Megjelenítés';

  @override
  String get settingsFriendPrivacy => 'Adatvédelem';

  @override
  String get settingsChat => 'Beszélgetés';

  @override
  String get settingsChatHistory => 'Beszélgetési előzmények';

  @override
  String get settingsAbout => 'A StartLink névjegye';

  @override
  String get settingsLanguage => 'Nyelv';

  @override
  String get settingsTimezone => 'Időzóna';

  @override
  String get settingsAutoTranslate => 'Automatikus fordítás';

  @override
  String get settingsNetworkSwitch => 'Vonal váltása';

  @override
  String get enterpriseInfoTitle => 'Vállalati adatok';

  @override
  String get enterpriseName => 'Név';

  @override
  String get enterpriseDescription => 'Leírás';

  @override
  String get enterpriseUpdateSuccess => 'Sikeresen frissítve';

  @override
  String get enterpriseUpdateFailed => 'A frissítés sikertelen. Próbálja újra.';

  @override
  String get enterpriseLeave => 'Kilépés a vállalatból';

  @override
  String get enterpriseLeaveConfirm => 'Biztosan kilép ebből a vállalatból?';

  @override
  String get enterpriseLeaveSuccess => 'Kilépett a vállalatból';

  @override
  String get enterpriseLeaveFailed => 'A kilépés sikertelen. Próbálja újra.';

  @override
  String get enterpriseLeaveOwnerError =>
      'A tulajdonos nem léphet ki közvetlenül. Először adja át a tulajdonjogot.';

  @override
  String get enterpriseMemberCount => 'Tagok';

  @override
  String get enterpriseCreatedAt => 'Létrehozva';

  @override
  String get enterpriseCode => 'Vállalati kód';

  @override
  String get enterpriseInviteMembers => 'Tagok meghívása';

  @override
  String get enterpriseCopyInviteCode => 'Meghívókód másolása';

  @override
  String get enterpriseInviteCodeCopied => 'Meghívókód másolva';

  @override
  String get groupCreateTitle => 'Új csoport';

  @override
  String get groupNameHint => 'Adja meg a csoport nevét';

  @override
  String get groupCreateSuccess => 'Csoport létrehozva';

  @override
  String get groupCreateFailed => 'A csoport létrehozása sikertelen';

  @override
  String get groupSettings => 'Csoportbeállítások';

  @override
  String get groupName => 'Csoport neve';

  @override
  String get groupAvatar => 'Csoportképe';

  @override
  String get groupAnnouncement => 'Közlemény';

  @override
  String get groupMembers => 'Tagok';

  @override
  String get groupAddMember => 'Tagok hozzáadása';

  @override
  String get groupRemoveMember => 'Tag eltávolítása';

  @override
  String get groupRemoveMemberConfirm => 'Eltávolítja ezt a tagot?';

  @override
  String get groupSetAdmin => 'Kinevezés rendszergazdának';

  @override
  String get groupRemoveAdmin => 'Rendszergazdai jog visszavonása';

  @override
  String get groupTransferOwner => 'Tulajdonjog átadása';

  @override
  String get groupTransferOwnerConfirm =>
      'Átadja a csoport tulajdonjogát ennek a tagnak?';

  @override
  String get groupTransferOwnerSuccess => 'Tulajdonjog átadva';

  @override
  String get groupTransferOwnerFailed => 'Az átadás sikertelen. Próbálja újra.';

  @override
  String get groupLeave => 'Kilépés a csoportból';

  @override
  String get groupLeaveConfirm => 'Kilép ebből a csoportból?';

  @override
  String get groupLeaveSuccess => 'Kilépett a csoportból';

  @override
  String get groupLeaveFailed => 'A kilépés sikertelen. Próbálja újra.';

  @override
  String get groupDissolve => 'Csoport feloszlatása';

  @override
  String get groupDissolveConfirm =>
      'Feloszlatja ezt a csoportot? Minden tag eltávolításra kerül.';

  @override
  String get groupDissolveSuccess => 'Csoport feloszlatva';

  @override
  String get groupDissolveFailed => 'A feloszlatás sikertelen. Próbálja újra.';

  @override
  String get groupQrCode => 'Csoport QR-kódja';

  @override
  String get groupMuteAll => 'Mindenki némítása';

  @override
  String get groupMuteAllOn => 'Mindenki némításának bekapcsolása';

  @override
  String get groupMuteAllOff => 'Mindenki némításának kikapcsolása';

  @override
  String get groupAllowMemberInvite => 'Tagok meghívásának engedélyezése';

  @override
  String get groupAllowMemberModifyTitle =>
      'A tagok módosíthatják a csoport nevét';

  @override
  String get groupAllowMemberAtAll => 'A tagok mindenkit megemlíthetnek';

  @override
  String get groupAllowMemberViewMemberList => 'A tagok láthatják a taglistát';

  @override
  String get groupAllowQrCodeJoin => 'Csatlakozás engedélyezése QR-kóddal';

  @override
  String get groupRequireApproval => 'Csatlakozási jóváhagyás megkövetelése';

  @override
  String get groupAllowMemberAddFriend => 'A tagok hozzáadhatják egymást';

  @override
  String get groupRoleOwner => 'Tulajdonos';

  @override
  String get groupRoleAdmin => 'Rendszergazda';

  @override
  String get groupRoleMember => 'Tag';

  @override
  String get groupNoMembers => 'Nincsenek tagok';

  @override
  String get groupNoAnnouncements => 'Nincsenek közlemények';

  @override
  String get groupCreateAnnouncement => 'Közlemény közzététele';

  @override
  String get groupEditAnnouncement => 'Közlemény szerkesztése';

  @override
  String get groupDeleteAnnouncement => 'Közlemény törlése';

  @override
  String get groupDeleteAnnouncementConfirm => 'Törli ezt a közleményt?';

  @override
  String get groupAnnouncementTitle => 'Cím';

  @override
  String get groupAnnouncementContent => 'Tartalom';

  @override
  String get groupAnnouncementPin => 'Közlemény rögzítése';

  @override
  String groupMemberCount(int count) {
    return '$count tag';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count kiválasztva';
  }

  @override
  String get groupJoinRequestApprove => 'Elfogadom';

  @override
  String get groupJoinRequestReject => 'Elutasítás';

  @override
  String get groupJoinRequests => 'Csatlakozási kérelmek';

  @override
  String get groupNoJoinRequests => 'Nincsenek csatlakozási kérelmek';

  @override
  String get groupReadReceipts => 'Olvasási visszaigazolások';

  @override
  String groupReadCount(int count) {
    return '$count elolvasta';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count olvasatlan';
  }

  @override
  String get friendAddTitle => 'Névjegy hozzáadása';

  @override
  String get friendSearchHint => 'Telefon / e-mail / StartLink-azonosító';

  @override
  String get friendRequestSent => 'Barátkérelem elküldve';

  @override
  String get friendRequestFailed => 'A küldés sikertelen. Próbálja újra.';

  @override
  String get friendAlreadyFriend => 'Már névjegyek';

  @override
  String get friendNewFriendsTitle => 'Új barátok';

  @override
  String get friendNoRequests => 'Nincsenek barátkérelmek';

  @override
  String get friendAccept => 'Elfogadás';

  @override
  String get friendReject => 'Elutasítás';

  @override
  String get friendAccepted => 'Elfogadva';

  @override
  String get friendRejected => 'Elutasítva';

  @override
  String get friendDeleteConfirm => 'Eltávolítja ezt a névjegyet?';

  @override
  String get friendDeleteSuccess => 'Névjegy eltávolítva';

  @override
  String get friendDeleteFailed => 'Az eltávolítás sikertelen. Próbálja újra.';

  @override
  String get friendRemarkName => 'Becenév';

  @override
  String get friendGroupName => 'Csoport';

  @override
  String get friendSendMessage => 'Üzenet';

  @override
  String get friendMatchTypeLppId => 'Találat StartLink-azonosító alapján';

  @override
  String get friendMatchTypeMobile => 'Találat telefonszám alapján';

  @override
  String get friendMatchTypeEmail => 'Találat e-mail alapján';

  @override
  String get friendSearchEmpty => 'Nem található felhasználó';

  @override
  String get friendAddMessage => 'Szeretném hozzáadni Önt a névjegyeimhez';

  @override
  String get friendBlockConfirm => 'Letiltja ezt a felhasználót?';

  @override
  String get friendUnblockConfirm => 'Feloldja a felhasználó tiltását?';

  @override
  String get friendBlockSuccess => 'Letiltva';

  @override
  String get friendUnblockSuccess => 'Tiltás feloldva';

  @override
  String get profilePageTitle => 'Személyes adatok';

  @override
  String get profilePageSendMessage => 'Üzenet';

  @override
  String get profilePageAddFriend => 'Barát hozzáadása';

  @override
  String get profilePageAlreadyFriend => 'Már barátok';

  @override
  String get profilePageBlocked => 'Letiltva';

  @override
  String get profilePageBlock => 'Letiltás';

  @override
  String get profilePageUnblock => 'Tiltás feloldása';

  @override
  String get profilePageHidden => 'Ez a felhasználó elrejtette a profilját';

  @override
  String get profilePageFriendsOnly =>
      'Ez a felhasználó csak barátoknak mutatja a profilját';

  @override
  String get profilePageLppId => 'StartLink-azonosító';

  @override
  String get profilePageRemarkName => 'Megjegyzések';

  @override
  String get profilePageEditRemark => 'Becenév szerkesztése';

  @override
  String get profilePageSaveRemarkSuccess => 'Becenév mentve';

  @override
  String get profilePageSaveRemarkFailed =>
      'A mentés sikertelen. Próbálja újra.';

  @override
  String get searchTitle => 'Keresés';

  @override
  String get searchHint =>
      'Keresés telefonszám, e-mail vagy StartLink-azonosító alapján';

  @override
  String get searchNoResults => 'Nincs találat';

  @override
  String get searchMessages => 'Üzenetek';

  @override
  String get searchUsers => 'Felhasználók';

  @override
  String get searchFailed => 'A keresés sikertelen. Próbálja újra.';

  @override
  String get scanTitle => 'Beolvasás';

  @override
  String get scanFailed => 'A felismerés sikertelen. Próbálja újra.';

  @override
  String get scanInvalidQrCode => 'Érvénytelen QR-kód';

  @override
  String get scanFlashOn => 'Zseblámpa bekapcsolása';

  @override
  String get scanFlashOff => 'Zseblámpa kikapcsolása';

  @override
  String get scanAlbum => 'Kiválasztás az albumból';

  @override
  String get favoritesTitle => 'Kedvencek';

  @override
  String get favoritesEmpty => 'Még nincs mentve semmi';

  @override
  String get favoritesAll => 'Összes';

  @override
  String get favoritesText => 'Szöveg';

  @override
  String get favoritesImage => 'Képek';

  @override
  String get favoritesVideo => 'Videó';

  @override
  String get favoritesVoice => 'Hangüzenetek';

  @override
  String get favoritesFile => 'Fájlok';

  @override
  String get favoritesOther => 'Egyéb';

  @override
  String get favoritesDeleteConfirm => 'Eltávolítja a kedvencek közül?';

  @override
  String get favoritesDeleteSuccess => 'Eltávolítva a mentettekből';

  @override
  String get favoritesDeleteFailed => 'Az eltávolítás sikertelen';

  @override
  String get favoritesOriginalRecalled => 'Üzenet visszavonva';

  @override
  String get favoritesViewOriginal => 'Eredeti megtekintése';

  @override
  String get favoritesSearchHint => 'Kedvencek keresése';

  @override
  String get favoritesNoResults => 'Nincs megfelelő kedvenc';

  @override
  String get noticeTitle => 'Közlemények';

  @override
  String get noticeEmpty => 'Nincsenek közlemények';

  @override
  String get noticeDetail => 'Közlemény részletei';

  @override
  String get noticePublishedAt => 'Közzétéve';

  @override
  String get noticePriorityNormal => 'Normál';

  @override
  String get noticePriorityImportant => 'Fontos';

  @override
  String get noticePriorityUrgent => 'Sürgős';

  @override
  String get organizationTitle => 'Szervezet';

  @override
  String get organizationEmpty => 'Nincsenek részlegadatok';

  @override
  String get organizationMembers => 'Tagok';

  @override
  String get organizationDepartment => 'Részleg';

  @override
  String get organizationPosition => 'Beosztás';

  @override
  String get organizationLeader => 'Vezető';

  @override
  String get qrCodeTitle => 'Saját QR-kód';

  @override
  String get qrCodeSave => 'Mentés albumba';

  @override
  String get qrCodeShare => 'Megosztás';

  @override
  String get qrCodeSaveSuccess => 'Mentve az albumba';

  @override
  String get qrCodeSaveFailed => 'A mentés sikertelen. Próbálja újra.';

  @override
  String get qrCodeRefresh => 'QR-kód frissítése';

  @override
  String get qrCodeExpired => 'A QR-kód lejárt. Frissítse.';

  @override
  String get qrCodeScanToAdd => 'Olvassa be a névjegyként hozzáadáshoz';

  @override
  String get spacePersonal => 'Személyes';

  @override
  String get spaceEnterprise => 'Vállalat';

  @override
  String get spaceJoinByCode => 'Csatlakozás vállalati kóddal';

  @override
  String get spaceJoinByInvite => 'Csatlakozás meghívókóddal';

  @override
  String get spaceEnterCode => 'Adja meg a vállalati kódot';

  @override
  String get spaceEnterInviteCode => 'Adja meg a meghívókódot';

  @override
  String get spaceSearchEnterprise => 'Vállalat keresése';

  @override
  String get spaceJoinRequestSent => 'Kérelem elküldve, jóváhagyásra vár';

  @override
  String get spaceJoinRequestPending => 'Jóváhagyásra vár';

  @override
  String get spaceJoinRequestApproved => 'Kérelem jóváhagyva';

  @override
  String get spaceJoinRequestRejected => 'Kérelem elutasítva';

  @override
  String get spaceAlreadyMember => 'Ön már tag';

  @override
  String get spaceAutoApproved => 'Automatikusan jóváhagyva. Üdvözöljük!';

  @override
  String get spacePendingApprovalHint =>
      'Sikeres regisztráció. Csatlakozási kérelme elküldve.';

  @override
  String get spaceNoSpaces => 'Nincsenek terek';

  @override
  String get spaceInviteExpired => 'A meghívókód lejárt';

  @override
  String get spaceInviteTargetMismatch =>
      'Ez a meghívókód nem az Ön fiókjának szól';

  @override
  String get spaceAcceptInviteSuccess => 'Sikeresen csatlakozott a vállalathoz';

  @override
  String get spaceAcceptInviteFailed =>
      'A csatlakozás sikertelen. Próbálja újra.';

  @override
  String get spaceTenantSelectTitle => 'Tér kiválasztása';

  @override
  String get spaceTenantSelectHint => 'Válasszon teret a belépéshez';

  @override
  String get spaceEnterPersonal => 'Belépés a személyes térbe';

  @override
  String get spaceEnterEnterprise => 'Belépés a vállalati térbe';

  @override
  String get aboutTitle => 'A StartLink névjegye';

  @override
  String get aboutVersion => 'Verzió';

  @override
  String get aboutTerms => 'Felhasználási feltételek';

  @override
  String get aboutPrivacy => 'Adatvédelmi szabályzat';

  @override
  String get aboutOpenSource => 'Nyílt forráskódú licencek';

  @override
  String get aboutCheckUpdate => 'Frissítések keresése';

  @override
  String get aboutLatestVersion => 'A legújabb verziót használja.';

  @override
  String get aboutUpdateAvailable => 'Új verzió elérhető';

  @override
  String get aboutUpdateNow => 'Frissítés most';

  @override
  String get aboutUpdateLater => 'Később';

  @override
  String get notificationTitle => 'Értesítések';

  @override
  String get notificationGlobalMute => 'Ne zavarjanak';

  @override
  String get notificationSound => 'Hang';

  @override
  String get notificationVibration => 'Rezgés';

  @override
  String get notificationPreview => 'Üzenet-előnézet';

  @override
  String get notificationDndStart => 'Ne zavarjanak kezdete';

  @override
  String get notificationDndEnd => 'Ne zavarjanak vége';

  @override
  String get blacklistTitle => 'Letiltva';

  @override
  String get blacklistEmpty => 'Nincsenek letiltott felhasználók';

  @override
  String get blacklistRemove => 'Tiltás feloldása';

  @override
  String get blacklistRemoveConfirm => 'Feloldja a felhasználó tiltását?';

  @override
  String get feedbackTitle => 'Visszajelzés';

  @override
  String get feedbackTypeComplaint => 'Panasz';

  @override
  String get feedbackTypeSuggestion => 'Javaslat';

  @override
  String get feedbackTypeBug => 'Hibajelentés';

  @override
  String get feedbackContent => 'Leírás';

  @override
  String get feedbackContentHint =>
      'Írja le részletesen a problémát vagy javaslatot';

  @override
  String get feedbackContact => 'Elérhetőség (opcionális)';

  @override
  String get feedbackSubmit => 'Beküldés';

  @override
  String get feedbackSuccess => 'Visszajelzés elküldve. Köszönjük!';

  @override
  String get feedbackFailed => 'A beküldés sikertelen. Próbálja újra.';

  @override
  String get networkTitle => 'Vonal váltása';

  @override
  String get networkAutoSelect => 'Automatikus';

  @override
  String get networkManual => 'Kézi';

  @override
  String get timezoneTitle => 'Időzóna';

  @override
  String get timezoneAuto => 'Rendszer követése';

  @override
  String get autoTranslateTitle => 'Automatikus fordítás';

  @override
  String get autoTranslateEnabled => 'Automatikus fordítás bekapcsolása';

  @override
  String get autoTranslateLanguage => 'Célnyelv';

  @override
  String get displayTitle => 'Megjelenítés';

  @override
  String get displayFontSize => 'Betűméret';

  @override
  String get displayChatBackground => 'Beszélgetés háttere';

  @override
  String get displayDarkMode => 'Megjelenés';

  @override
  String get displayDarkModeSystem => 'Rendszer követése';

  @override
  String get displayDarkModeSystemHint =>
      'Automatikus váltás a rendszerbeállítás szerint';

  @override
  String get displayDarkModeOff => 'Világos';

  @override
  String get displayDarkModeOffHint => 'Mindig világos téma használata';

  @override
  String get displayDarkModeOn => 'Sötét';

  @override
  String get displayDarkModeOnHint => 'Mindig sötét téma használata';

  @override
  String get chatSettingsTitle => 'Beszélgetés';

  @override
  String get chatHistoryTitle => 'Beszélgetési előzmények';

  @override
  String get chatHistoryClear => 'Összes előzmény törlése';

  @override
  String get chatHistoryClearConfirm =>
      'Törli az összes beszélgetési előzményt? Ez nem vonható vissza.';

  @override
  String get chatHistoryClearSuccess => 'Beszélgetési előzmények törölve';

  @override
  String get accountSecurityTitle => 'Fiókbiztonság';

  @override
  String get accountSecurityChangePassword => 'Jelszó módosítása';

  @override
  String get accountSecurityChangeMobile => 'Telefonszám módosítása';

  @override
  String get accountSecurityChangeEmail => 'E-mail módosítása';

  @override
  String get accountSecurityLoggedDevices => 'Bejelentkezett eszközök';

  @override
  String get accountSecurityDeactivate => 'Fiók megszüntetése';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Minden adat véglegesen törlődik 7 nap múlva. Megszünteti?';

  @override
  String get loggedDevicesTitle => 'Bejelentkezett eszközök';

  @override
  String get loggedDevicesCurrent => 'Ez az eszköz';

  @override
  String get loggedDevicesRevoke => 'Kijelentkezés';

  @override
  String get loggedDevicesRevokeConfirm => 'Kijelentkezik erről az eszközről?';

  @override
  String get loggedDevicesRevokeSuccess => 'Kijelentkezett az eszközről';

  @override
  String get loggedDevicesRevokeFailed => 'Sikertelen. Próbálja újra.';

  @override
  String get loggedDevicesLastActive => 'Utolsó aktivitás';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Számítógép';

  @override
  String get loggedDevicesTypeUnknown => 'Ismeretlen eszköz';

  @override
  String get privacySettingsTitle => 'Adatvédelem';

  @override
  String get privacySearchableByMobile =>
      'Telefonszám szerinti keresés engedélyezése';

  @override
  String get privacySearchableByLppId =>
      'StartLink-azonosító szerinti keresés engedélyezése';

  @override
  String get privacyAllowFriendRequest => 'Barátkérelmek engedélyezése';

  @override
  String get privacyProfileVisibility => 'Profil láthatósága';

  @override
  String get privacyEveryone => 'Mindenki';

  @override
  String get privacyFriendsOfFriends => 'Barátok barátai';

  @override
  String get privacyNobody => 'Senki';

  @override
  String get privacyFriendsOnly => 'Csak barátok';

  @override
  String get privacySaveSuccess => 'Beállítások mentve';

  @override
  String get privacySaveFailed => 'A mentés sikertelen. Próbálja újra.';

  @override
  String get fontSizeTitle => 'Betűméret';

  @override
  String get fontSizeSmall => 'Kicsi';

  @override
  String get fontSizeNormal => 'Normál';

  @override
  String get fontSizeLarge => 'Nagy';

  @override
  String get fontSizeExtraLarge => 'Extránagy';

  @override
  String get fontSizePreview => 'Előnézet';

  @override
  String get chatBackgroundTitle => 'Beszélgetés háttere';

  @override
  String get chatBackgroundDefault => 'Alapértelmezett';

  @override
  String get chatBackgroundCustom => 'Egyéni';

  @override
  String get chatBackgroundReset => 'Alapértelmezések visszaállítása';

  @override
  String get termsTitle => 'Felhasználási feltételek';

  @override
  String get privacyPolicyTitle => 'Adatvédelmi szabályzat';

  @override
  String get recentContactsTitle => 'Legutóbbiak';

  @override
  String get recentContactsEmpty => 'Nincsenek legutóbbi névjegyek';

  @override
  String get inviteFriendsTitle => 'Barátok meghívása';

  @override
  String get inviteFriendsCopyLink => 'Meghívóhivatkozás másolása';

  @override
  String get inviteFriendsLinkCopied => 'Meghívóhivatkozás másolva';

  @override
  String get imageViewerTitle => 'Fotó';

  @override
  String get imageViewerSave => 'Mentés albumba';

  @override
  String get imageViewerSaveSuccess => 'Mentve az albumba';

  @override
  String get imageViewerSaveFailed => 'A mentés sikertelen. Próbálja újra.';

  @override
  String get customerServiceTitle => 'Ügyfélszolgálati központ';

  @override
  String get customerServiceQueue => 'Várólistán';

  @override
  String get customerServiceActive => 'Aktív';

  @override
  String get customerServiceClaim => 'Elfogadás';

  @override
  String get customerServiceTakeover => 'Átvétel';

  @override
  String get customerServiceClose => 'Kiszolgálás befejezése';

  @override
  String get customerServiceCloseConfirm =>
      'Befejezi ezt a kiszolgálási munkamenetet?';

  @override
  String get customerServiceNoQueue => 'Nincs várakozó munkamenet';

  @override
  String get customerServiceNoActive => 'Nincs aktív munkamenet';

  @override
  String get customerServiceVisitor => 'Látogató';

  @override
  String get customerServiceCustomer => 'Ügyfél';

  @override
  String get customerServiceAssignedTo => 'Kijelölve';

  @override
  String get customerServiceTransferConversation => 'Beszélgetés átadása';

  @override
  String get marketingToolbar => 'Marketingeszközök';

  @override
  String get callIncoming => 'Bejövő hívás';

  @override
  String get callOutgoing => 'Kimenő hívás';

  @override
  String get callAccept => 'Elfogadás';

  @override
  String get callReject => 'Elutasítás';

  @override
  String get callHangup => 'Befejezés';

  @override
  String get callMissed => 'Nem fogadott hívás';

  @override
  String get callDuration => 'Időtartam';

  @override
  String get callAudio => 'Hanghívás';

  @override
  String get callGeneric => 'Hívás';

  @override
  String get callVideo => 'Videóhívás';

  @override
  String get callConnecting => 'Kapcsolódás...';

  @override
  String get callRinging => 'Kicsengés...';

  @override
  String get callEnded => 'Hívás véget ért';

  @override
  String get callFailed => 'A hívás sikertelen';

  @override
  String get callRejected => 'Hívás elutasítva';

  @override
  String get callTimeout => 'Nincs válasz';

  @override
  String get callCancelled => 'Megszakítva';

  @override
  String get callUnknownPeer => 'Ismeretlen';

  @override
  String get callVideoInvitation => 'Videóhívás-meghívás';

  @override
  String get callAudioInvitation => 'Hanghívás-meghívás';

  @override
  String get callAnswerAudio => 'Fogadás hanggal';

  @override
  String get callAnswerVideo => 'Fogadás videóval';

  @override
  String get callViewProfile => 'Profil megtekintése';

  @override
  String get callOpeningCamera => 'Kamera indítása...';

  @override
  String get callWaitingRemoteVideo => 'Várakozás a másik fél videójára...';

  @override
  String get callCameraOff => 'Kamera kikapcsolva';

  @override
  String get callCameraOn => 'Kamera bekapcsolva';

  @override
  String get callMicrophoneOff => 'Mikrofon kikapcsolva';

  @override
  String get callMicrophoneOn => 'Mikrofon bekapcsolva';

  @override
  String get callSpeakerOff => 'Hangszóró kikapcsolva';

  @override
  String get callSpeakerOn => 'Hangszóró bekapcsolva';

  @override
  String get callVideoPermissionFailure =>
      'Nem sikerült elindítani a videóhívást. Ellenőrizze a kamera és mikrofon engedélyeit, és próbálja újra.';

  @override
  String get callAudioPermissionFailure =>
      'Nem sikerült elindítani a hanghívást. Ellenőrizze a mikrofon engedélyét, és próbálja újra.';

  @override
  String get callIncompleteIncoming =>
      'A bejövő hívás adatai hiányosak, ezért nem fogadható.';

  @override
  String get callInProgress => 'Hívásban';

  @override
  String get callCalling => 'Hívás...';

  @override
  String callEndedMedia(String media) {
    return '$media befejeződött';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media elutasítva';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media nem fogadott';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media megszakítva';
  }

  @override
  String get callConnectionLost => 'A hívás kapcsolata megszakadt';

  @override
  String get callAdminEnded => 'A hívást egy rendszergazda befejezte';

  @override
  String callFailedMedia(String media) {
    return '$media sikertelen';
  }

  @override
  String get callBusy => 'A másik fél foglalt';

  @override
  String callDurationValue(String duration) {
    return 'Hívás időtartama: $duration';
  }

  @override
  String get callNotConnected => 'Nincs kapcsolat';

  @override
  String get callDialed => 'Kimenő';

  @override
  String get callAnswered => 'Fogadva';

  @override
  String get callRejectedByPeer => 'A másik fél elutasította';

  @override
  String get callRejectedBySelf => 'Elutasítva';

  @override
  String get callPeerDidNotAnswer => 'A másik fél nem válaszolt';

  @override
  String get callMissedIncoming => 'Nem fogadott bejövő hívás';

  @override
  String get callPeerCancelled => 'A másik fél megszakította';

  @override
  String get notificationNewMessageTitle => 'Új StartLink-üzenet';

  @override
  String get notificationOnlineServiceTitle => 'Új ügyfélszolgálati üzenet';

  @override
  String get notificationNewMessageBody => 'Új üzenete érkezett';

  @override
  String get notificationImagePreview => 'Képet küldött';

  @override
  String get notificationVideoPreview => 'Videót küldött';

  @override
  String get notificationVoicePreview => 'Hangüzenetet küldött';

  @override
  String get notificationFilePreview => 'Fájlt küldött';

  @override
  String get notificationContactPreview => 'Névjegykártyát küldött';

  @override
  String get notificationCallLogPreview => 'Hívásrekordot küldött';

  @override
  String get notificationLocationPreview => 'Helyet osztott meg';

  @override
  String get notificationLinkPreview => 'Hivatkozást osztott meg';

  @override
  String notificationMentionMe(String body) {
    return 'Megemlítette Önt: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender megemlítette Önt: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Mindenkit megemlített: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender mindenkit megemlített: $body';
  }

  @override
  String get notificationSecurityTitle => 'Fiókbiztonsági riasztás';

  @override
  String get notificationSecurityBody =>
      'StartLink-fiókja biztonsági beállításai megváltoztak. Ellenőrizze őket most.';

  @override
  String get notificationFriendAcceptedTitle => 'Barátkérelem elfogadva';

  @override
  String get notificationFriendRejectedTitle => 'Barátkérelem elutasítva';

  @override
  String get notificationFriendAcceptedBody =>
      'A másik fél elfogadta a barátkérelmét';

  @override
  String get notificationFriendRejectedBody =>
      'A másik fél elutasította a barátkérelmét';

  @override
  String get notificationVideoCallTitle => 'Videóhívás-meghívás';

  @override
  String get notificationAudioCallTitle => 'Hanghívás-meghívás';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller videóhívásra hívta Önt';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller hanghívásra hívta Önt';
  }

  @override
  String get notificationMessageChannelName => 'Üzenetek';

  @override
  String get notificationMessageChannelDescription =>
      'Beszélgetési üzenetek, hívásrekordok és rendszerriasztások';

  @override
  String get notificationCallChannelName => 'Hívások';

  @override
  String get notificationCallChannelDescription =>
      'Hang- és videóhívás-riasztások';

  @override
  String get notificationSecurityChannelName => 'Fiókbiztonság';

  @override
  String get notificationSecurityChannelDescription =>
      'Bejelentkezési, jelszó- és mobiltelefonszám-változási riasztások';

  @override
  String get notificationUnknownCaller => 'Ismeretlen hívó';

  @override
  String get pendingJoinRequestsTitle => 'Új kérelmek';

  @override
  String get pendingJoinRequestsEmpty => 'Nincsenek kérelmek';

  @override
  String get pendingJoinRequestApprove => 'Elfogadom';

  @override
  String get pendingJoinRequestReject => 'Elutasítás';

  @override
  String get pendingJoinRequestApproveSuccess => 'Jóváhagyva';

  @override
  String get pendingJoinRequestRejectSuccess => 'Elutasítva';

  @override
  String get pendingJoinRequestFailed => 'A művelet sikertelen. Próbálja újra.';

  @override
  String get myCustomersTitle => 'Saját ügyfelek';

  @override
  String get myCustomersEmpty => 'Nincsenek ügyfelek';

  @override
  String get groupListTitle => 'Csoportok';

  @override
  String get groupListEmpty => 'Nincsenek csoportok';

  @override
  String get addFriendTitle => 'Névjegy hozzáadása';

  @override
  String get addFriendSearchHint => 'Telefon / e-mail / StartLink-azonosító';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink-azonosító: $lppId';
  }

  @override
  String get addFriendButton => 'Hozzáadás';

  @override
  String get addFriendCannotAddSelf => 'Nem adhatja hozzá saját magát';

  @override
  String get addFriendUnsupportedUser =>
      'Ez a felhasználó nem adható hozzá. Közvetlenül üzenhet neki.';

  @override
  String get addFriendMessageHint => 'Írjon be üzenetet';

  @override
  String get addFriendSendRequest => 'Kérelem küldése';

  @override
  String get joinCompanyTitle => 'Csatlakozás vállalathoz';

  @override
  String get joinCompanyCodeHint => 'Adja meg a vállalati kódot';

  @override
  String get joinCompanySearchHint => 'Vállalat nevének keresése';

  @override
  String get joinCompanyApply => 'Csatlakozás kérelmezése';

  @override
  String get joinCompanyApplySuccess => 'Kérelem elküldve';

  @override
  String get joinCompanyApplyFailed => 'A kérelem sikertelen. Próbálja újra.';

  @override
  String get joinCompanyAutoApproved => 'Automatikusan jóváhagyva. Üdvözöljük!';

  @override
  String get joinCompanyPending => 'Kérelem elküldve, jóváhagyásra vár';

  @override
  String get joinCompanyInviteCodeHint => 'Adja meg a meghívókódot';

  @override
  String get joinCompanyAcceptInvite => 'Meghívó elfogadása';

  @override
  String get joinCompanyNoResults => 'Nem található vállalat';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count tag';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaszka';

  @override
  String get timezoneNamePacificTime => 'Csendes-óceáni idő';

  @override
  String get timezoneNameMountainTime => 'Hegyvidéki idő';

  @override
  String get timezoneNameCentralTime => 'Középső idő';

  @override
  String get timezoneNameEasternTime => 'Keleti idő';

  @override
  String get timezoneNameAtlanticTime => 'Atlanti idő';

  @override
  String get timezoneNameBrasilia => 'Brazíliaváros';

  @override
  String get timezoneNameAzores => 'Azori-szigetek';

  @override
  String get timezoneNameLondonDublin => 'London/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Párizs/Róma';

  @override
  String get timezoneNameCairoHelsinki => 'Kairó/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moszkva/Rijád';

  @override
  String get timezoneNameTehran => 'Teherán';

  @override
  String get timezoneNameDubaiBaku => 'Dubaj/Baku';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karacsi/Taskent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/Újdelhi';

  @override
  String get timezoneNameKathmandu => 'Katmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dakka/Almati';

  @override
  String get timezoneNameYangon => 'Rangun';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoi/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Peking/Sanghaj/Hongkong/Tajpej';

  @override
  String get timezoneNameTokyoSeoul => 'Tokió/Szöul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Salamon-szigetek';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fidzsi';

  @override
  String get networkSmartSelectBestRoute =>
      'Legjobb útvonal intelligens kiválasztása';

  @override
  String get networkTesting => 'Tesztelés...';

  @override
  String get networkTestingShort => 'Tesztelés';

  @override
  String networkLatencyMs(int ms) {
    return 'Késleltetés: $ms ms';
  }

  @override
  String get networkConnectionMode => 'Kapcsolódási mód';

  @override
  String get networkDirectMode => 'Közvetlen mód';

  @override
  String get networkProxyMode => 'Proxymód';

  @override
  String get networkDirectModeDesc => 'Közvetlen kapcsolódás a kiszolgálóhoz';

  @override
  String get networkProxyModeDesc => 'Kapcsolódás proxykiszolgálón keresztül';

  @override
  String get networkDirectRoutes => 'Közvetlen útvonalak';

  @override
  String get networkProxyRoutes => 'Proxyútvonalak';

  @override
  String get networkTestAll => 'Összes tesztelése';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Hongkongi csomópont';

  @override
  String get networkSingaporeNode => 'Szingapúri csomópont';

  @override
  String get networkJapanNode => 'Japán csomópont';

  @override
  String get networkUnitedStatesNode => 'Egyesült államokbeli csomópont';

  @override
  String get networkHint =>
      'Tippek:\n• Közvetlen mód: gyorsabb, belföldi használatra alkalmas\n• Proxymód: stabilabb nemzetközi kommunikációhoz\n• Egy útvonal késleltetésének teszteléséhez koppintson a frissítés ikonra';

  @override
  String get teenModeTitle => 'Fiatalkorúak módja';

  @override
  String get teenModeStatusOn => 'Be';

  @override
  String get teenModeStatusOff => 'Kikapcsolva';

  @override
  String get teenModeStatusLoading => 'Betöltés';

  @override
  String get teenModeUnavailable =>
      'A fiatalkorúak módjának állapota átmenetileg nem elérhető';

  @override
  String get teenModeInvalidResponse =>
      'A fiatalkorúak módja érvénytelen választ adott';

  @override
  String get teenModeEnableDescription =>
      'A platform szabályai korlátozzák a használati időt és a kiválasztott funkciókat.';

  @override
  String get teenModePasscode => 'Hozzáférési kód';

  @override
  String get teenModeCurrentPasscode => 'Jelenlegi hozzáférési kód';

  @override
  String get teenModeNewPasscode => 'Új hozzáférési kód';

  @override
  String get teenModePasscodeHint => 'Adjon meg 4–6 számjegyet';

  @override
  String get teenModeEnable => 'Fiatalkorúak módjának bekapcsolása';

  @override
  String get teenModeDisable => 'Fiatalkorúak módjának kikapcsolása';

  @override
  String get teenModeChangePasscode => 'Hozzáférési kód módosítása';

  @override
  String get teenModeSource => 'Bekapcsolta';

  @override
  String get teenModeDailyUsage => 'Mai használat';

  @override
  String get teenModeRemaining => 'Hátralévő idő';

  @override
  String get teenModeMinutesUnit => 'Perc';

  @override
  String get teenModeUnlimited => 'Korlátlan';

  @override
  String get teenModeRequestExtension => 'További idő kérése';

  @override
  String get teenModeExtensionSubmitted =>
      'Az időkérés elküldve a gondviselőnek';

  @override
  String get teenModeTimeLimitReached => 'Elérte a mai használati korlátot';

  @override
  String get teenModeCurfewActive => 'Ez egy korlátozott használati időszak';

  @override
  String get teenModeReliefHint =>
      'Továbbra is megtekintheti az előzményeket, kapcsolatba léphet a hivatalos ügyfélszolgálattal és problémát jelenthet.';

  @override
  String get teenModeRestrictedNotice =>
      'A fiatalkorúak módja jelenleg megakadályozza az üzenetküldést';

  @override
  String get teenModeActionBlocked =>
      'A fiatalkorúak módja jelenleg megakadályozza ezt a műveletet';

  @override
  String get teenModeMyRequests => 'Saját kérések';

  @override
  String get guardianCenterTitle => 'Gondviselői központ';

  @override
  String get guardianRelationships => 'Gondviselői kapcsolatok';

  @override
  String get guardianMinors => 'Felügyelt gyermekek';

  @override
  String get guardianApprovals => 'Függő jóváhagyások';

  @override
  String get guardianBind => 'Adja meg az összekapcsolási kódot';

  @override
  String get guardianCreateMinorCode => 'Gyermek vagyok — kód létrehozása';

  @override
  String get guardianCreateGuardianCode =>
      'Gondviselő vagyok — kód létrehozása';

  @override
  String get guardianRelation => 'Kapcsolat';

  @override
  String get guardianPrimary => 'Elsődleges gondviselő';

  @override
  String get guardianCode => '6 számjegyű összekapcsolási kód';

  @override
  String get guardianCodeHint => 'Adja meg a másik féltől kapott kódot';

  @override
  String get guardianCodeCreated => 'Kód létrehozva. Ossza meg lejárat előtt.';

  @override
  String get guardianEmpty => 'Nincs gondviselői kapcsolat';

  @override
  String get guardianNoMinors => 'Nincs felügyelt gyermek';

  @override
  String get guardianUnbind => 'Kapcsolat eltávolítása';

  @override
  String get guardianExtend => 'Idő hozzáadása a gyermeknek';

  @override
  String get guardianPolicyTitle => 'Használati szabályok';

  @override
  String get guardianPolicyLocked => 'Platform által zárolva';

  @override
  String get approvalEmpty => 'Nincsenek kérések';

  @override
  String get approvalApprove => 'Elfogadom';

  @override
  String get approvalReject => 'Elutasítás';

  @override
  String get approvalPending => 'Függőben';

  @override
  String get approvalApproved => 'Jóváhagyva';

  @override
  String get approvalRejected => 'Elutasítva';

  @override
  String get approvalExpired => 'Lejárt';

  @override
  String get approvalCancelled => 'Megszakítva';

  @override
  String get approvalReplayFailed =>
      'Az eredeti művelet sikertelen. Próbálja újra.';

  @override
  String get requestCancelled => 'Kérés visszavonva';

  @override
  String get kycTitle => 'Személyazonosság-ellenőrzés';

  @override
  String get kycNotRequired => 'Személyazonosság-ellenőrzés nem szükséges';

  @override
  String get kycVerified => 'Személyazonosság ellenőrizve';

  @override
  String get kycDeclared => 'Személyazonossági adatok elküldve';

  @override
  String get kycPending => 'Ellenőrzés alatt';

  @override
  String get kycRejected => 'Ellenőrzés elutasítva';

  @override
  String get kycNone => 'Nincs beküldött személyazonossági adat';

  @override
  String get kycRealName => 'Teljes név';

  @override
  String get kycIdNumber => 'Azonosító szám';

  @override
  String get kycIdType => 'Okmány típusa';

  @override
  String get kycApplicability =>
      'Adja meg a kiválasztott okmány valós adatait. Az elfogadott típusok a listán láthatók.';

  @override
  String get kycCamera => 'Fénykép készítése';

  @override
  String get kycGallery => 'Kiválasztás a galériából';

  @override
  String get kycPhotoLimit => 'Maximum képenként';

  @override
  String get kycSelectPhoto => 'Kép kiválasztása';

  @override
  String get kycPhotoSelected => 'Kiválasztva';

  @override
  String get kycViewPhoto => 'Koppintson a kép megtekintéséhez';

  @override
  String get kycReplacePhoto => 'Másik kép választása';

  @override
  String get kycDisclosure =>
      'Nevét, okmányszámát és okmányfotóit a személyazonosság ellenőrzésére használjuk. Ezek nélkül a kérelem nem küldhető be, és egyes korlátozott funkciók nem lesznek elérhetők.';

  @override
  String get kycConsent =>
      'Külön hozzájárulok a személyazonossági adatok ezen kezeléséhez';

  @override
  String get kycConsentRequired => 'Beküldés előtt adjon külön hozzájárulást';

  @override
  String get kycResubmitTitle => 'Személyazonossági adatok újbóli beküldése';

  @override
  String get kycResubmitWarning =>
      'Az újbóli beküldés felülírja a függő kérelmet. Folytatja?';

  @override
  String get kycSubmitting => 'Beküldés';

  @override
  String get kycSubmitFailed => 'A beküldés sikertelen. Próbálja újra.';

  @override
  String get kycSubmitUnavailable =>
      'Személyazonossági adatok most nem küldhetők be';

  @override
  String get kycResubmitNotAllowed =>
      'Elutasítás után az újbóli beküldés nem elérhető. Szükség esetén forduljon az ügyfélszolgálathoz.';

  @override
  String get kycDailyLimit =>
      'Elérte a mai beküldési korlátot. Próbálja holnap.';

  @override
  String get kycTypeUnavailable =>
      'Nincs elérhető okmánytípus. Próbálja később újra.';

  @override
  String get kycNameInvalid =>
      'A hivatalos névnek 2–64 karakterből kell állnia';

  @override
  String get kycNumberRequired => 'Adja meg az okmányszámot';

  @override
  String get kycFrontRequired => 'Töltse fel az okmány előlapját';

  @override
  String get kycBackRequired => 'Töltse fel az okmány hátlapját';

  @override
  String get kycPhotoTooLarge =>
      'A fotó meghaladja a méretkorlátot. Tömörítse, és próbálja újra.';

  @override
  String get kycAccountChanged =>
      'A fiók vagy tér megváltozott. Nyissa meg újra ezt az oldalt.';

  @override
  String get kycPhotoInvalid => 'Válasszon érvényes képet';

  @override
  String get kycPortraitSide => 'Személyi igazolvány elülső oldala';

  @override
  String get kycEmblemSide => 'Személyi igazolvány hátoldala';

  @override
  String get kycPassportDataPage => 'Útlevél adatoldala';

  @override
  String get kycPassportOtherPage => 'Útlevél vízumoldala vagy üres oldala';

  @override
  String get kycFront => 'Igazolvány eleje';

  @override
  String get kycBack => 'Igazolvány hátulja';

  @override
  String get kycRequired =>
      'Csoport létrehozása előtt személyazonosság-ellenőrzés szükséges';

  @override
  String get kycGoVerify => 'Ellenőrzés most';

  @override
  String get kycStatusUnknown =>
      'A személyazonosság állapota nem elérhető. Frissítse később.';

  @override
  String get kycSuperseded =>
      'Egy későbbi beküldés felülírta ezt. Ellenőrizze a legújabb személyazonossági állapotot.';

  @override
  String get kycMediaNotFound =>
      'Az okmányfotó nem elérhető ebben a térben. Beküldés előtt válassza ki újra.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Tömeges üzenet ügyfeleknek';

  @override
  String get officialAccountBadge => 'Hivatalos';

  @override
  String get officialAccountOpenConversation => 'Beszélgetés megnyitása';

  @override
  String get officialAccountJoinHint =>
      'A fiók hozzáadásával ügyfélként csatlakozik a vállalathoz. Barátkérelem-jóváhagyás nem szükséges.';

  @override
  String get officialAccountJoinDisabled =>
      'Ez a vállalat nem fogad új ügyfeleket. Forduljon az ügyfélszolgálathoz.';

  @override
  String get officialAccountRemoved =>
      'Eltávolították ebből a vállalatból. Kérje meg a vállalatot, hogy hívja meg újra.';

  @override
  String get officialAccountBanned =>
      'Fiókját letiltották ebben a vállalatban.';

  @override
  String get officialAccountUnavailable =>
      'Ez a hivatalos fiók jelenleg nem elérhető.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'A jelenlegi módban nem engedélyezett a vállalathoz csatlakozás.';

  @override
  String get officialAccountPlatformRequired =>
      'Platformfiókkal adja hozzá ezt a hivatalos fiókot.';

  @override
  String get officialAccountOpenFailed =>
      'Nem sikerült megnyitni a beszélgetést. Próbálja újra.';

  @override
  String get officialAccountAccountChanged =>
      'A fiók vagy tér megváltozott. Nyissa meg újra.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'A vállalati címtár nem naprakész. Próbálja rövidesen újra.';

  @override
  String get officialAccountInboxSyncFailed =>
      'A hivatalos fiók szinkronizálása sikertelen. A helyi tartalom továbbra is elérhető.';

  @override
  String get officialAccountInboxSyncing =>
      'Hivatalos fiók üzeneteinek szinkronizálása';

  @override
  String get diagnosticsTitle => 'Diagnosztika';

  @override
  String get diagnosticsExplanation =>
      'A naplók anonimizáltak, és e fiók és tér működési és hibaadatait, valamint nyilvános indítási eseményeket tartalmaznak. A beszélgetések tartalma és a hitelesítő adatok nem szerepelnek bennük.';

  @override
  String get diagnosticsHour => 'Utolsó óra';

  @override
  String get diagnosticsDay => 'Utolsó 24 óra';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Elérhető események: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'A naplók ezen az eszközön tárolódnak, és újraindítás után is elérhetők.';

  @override
  String get diagnosticsNotPersistent =>
      'Néhány napló nem lett mentve. Frissítsen az újrapróbálkozáshoz.';

  @override
  String get diagnosticsExport => 'Exportálás és megosztás';

  @override
  String get diagnosticsRefresh => 'Frissítés';

  @override
  String get diagnosticsClear => 'A tér naplóinak törlése';

  @override
  String get diagnosticsClearConfirm =>
      'Törli e tér diagnosztikai naplóit? A beszélgetési előzmények megmaradnak.';

  @override
  String get diagnosticsShared =>
      'A rendszermegosztás befejeződött. Ellenőrizze a fájlt a fogadó alkalmazásban.';

  @override
  String get diagnosticsCancelled =>
      'A megosztás megszakítva. Újra exportálhat.';

  @override
  String get diagnosticsUnconfirmed =>
      'A megosztás nem volt megerősíthető. Ellenőrizze a fogadó alkalmazást.';

  @override
  String get diagnosticsFailed => 'A művelet sikertelen. Próbálja újra.';
}
