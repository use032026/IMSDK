// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get navWorkbench => 'Työpöytä';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Tilin tietojen lataaminen epäonnistui';

  @override
  String get startupFailureTitle => 'Käynnistys epäonnistui';

  @override
  String get startupFailureMessage =>
      'Tarkista verkkoyhteys ja yritä uudelleen';

  @override
  String get privacyConsentTitle => 'Käyttöehdot ja tietosuojakäytäntö';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Tervetuloa käyttämään sovellusta $brand. Tilille kirjautumista, pikaviestintää, yritysyhteistyötä, verkkoasiakaspalvelua, viesti-ilmoituksia ja tietoturvaa varten meidän on käsiteltävä tarpeellisia tietoja käyttöehtojen ja tietosuojakäytännön mukaisesti.\n\nEnnen kuin napautat Hyväksyn, emme lue leikepöydän sisältöä, alusta JPush/JCorea tai laitevalmistajien ilmoitus-SDK:ita emmekä käytä niitä Android ID:n, OAID:n, asennettujen sovellusten luetteloiden, MAC-osoitteiden tai vastaavien tietojen hakemiseen. Jos kieltäydyt toistaiseksi, tallennamme valintasi. Voit jatkaa asiakirjojen lukemista ja valita myöhemmin uudelleen.\n\nHyväksynnän jälkeen JPush/JCore ja laitevalmistajien ilmoituspalvelut voivat käsitellä laitteen mallia, Android-versiota, sovelluspaketin nimeä ja versiota, verkkotyyppiä, IP-osoitetta, Android ID:tä, OAID:tä, ilmoitusten Registration ID:tä, valmistajan ilmoitustunnistetta sekä ilmoitusten toimitus- ja avaustietoja viesti-, asiakaspalvelu- ja puheluilmoitusten toimittamiseksi. Olemme poistaneet käytöstä tarpeettomat toiminnot, kuten älykkäät ilmoitukset, asennettujen sovellusten luettelot, MAC-, IMEI- ja IMSI-tiedot, Wi-Fi-luettelot, automaattisen herätyksen ja yhdistetyn käynnistyksen.\n\nLeikepöytää käytetään vain, kun itse kopioit tai liität. Kameran, mikrofonin, ilmoitusten ja muiden järjestelmätoimintojen lupia pyydetään vain käyttäessäsi kyseistä toimintoa. Yksittäisen luvan epääminen vaikuttaa vain kyseiseen toimintoon. Lue täydelliset asiakirjat alta ja päätä itse, hyväksytkö ne.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Tervetuloa käyttämään sovellusta $brand. Tilille kirjautumista, pikaviestintää, yritysyhteistyötä, verkkoasiakaspalvelua, viesti-ilmoituksia ja tietoturvaa varten meidän on käsiteltävä tarpeellisia tietoja käyttöehtojen ja tietosuojakäytännön mukaisesti.\n\nEnnen kuin napautat Hyväksyn, emme lue leikepöydän sisältöä, alusta JPush/JCorea, rekisteröidy Apple Push Notification serviceen (APNs) emmekä hanki ilmoitustunnisteita, kuten JPush Registration ID:tä tai APNs-laitetunnistetta. Jos kieltäydyt toistaiseksi, tallennamme valintasi. Voit jatkaa asiakirjojen lukemista ja valita myöhemmin uudelleen.\n\nHyväksynnän jälkeen voimme käsitellä iPhonen mallia, iOS-versiota, sovelluspaketin nimeä ja versiota, verkkotyyppiä, IP-osoitetta, IDFV:tä, JPush Registration ID:tä, APNs-laitetunnistetta sekä ilmoitusten toimitus- ja avaustietoja viesti-, asiakaspalvelu- ja puheluilmoitusten toimittamiseksi. JPush/JCore yhdistää ilmoituspalveluun. Apple APNs käsittelee sovelluksen tunnistetta, laitetunnistetta ja ilmoituksen sisältöä järjestelmäilmoitusten toimittamiseksi. Nykyinen iOS-sovellus ei käytä mainospalveluja eikä hanki IDFA-tunnistetta.\n\nLeikepöytää käytetään vain, kun itse kopioit tai liität. Kameran, mikrofonin, ilmoitusten ja muiden järjestelmätoimintojen lupia pyydetään vain käyttäessäsi kyseistä toimintoa. Yksittäisen luvan epääminen vaikuttaa vain kyseiseen toimintoon. Lue täydelliset asiakirjat alta ja päätä itse, hyväksytkö ne.';
  }

  @override
  String get privacyConsentTermsLink => 'Käyttäjäsopimus';

  @override
  String get privacyConsentConjunction => 'ja';

  @override
  String get privacyConsentPrivacyLink => 'Tietosuojakäytäntö';

  @override
  String get privacyConsentDecline => 'En hyväksy';

  @override
  String get privacyConsentDeclinedExit =>
      'Et hyväksynyt käyttöehtoja ja tietosuojakäytäntöä. Sovellus suljetaan nyt.';

  @override
  String get privacyConsentAccept => 'Hyväksyn';

  @override
  String get privacyConsentRuntimeFailure =>
      'Käynnistys epäonnistui. Tarkista verkkoyhteys ja yritä uudelleen.';

  @override
  String get privacyConsentSaveFailure =>
      'Valintasi tallentaminen epäonnistui. Yritä uudelleen.';

  @override
  String get appUpdateRequiredTitle => 'Jatkaminen edellyttää päivitystä';

  @override
  String get appUpdateOptionalTitle => 'Uusi versio saatavilla';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version on saatavilla';
  }

  @override
  String get appUpdateLater => 'Myöhemmin';

  @override
  String get appUpdateNow => 'Päivitä nyt';

  @override
  String get appUpdateProcessing => 'Käsitellään...';

  @override
  String get appUpdateInvalidUrl =>
      'Päivityksen osoite ei kelpaa. Yritä myöhemmin uudelleen.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Päivityslinkin avaaminen epäonnistui. Yritä myöhemmin uudelleen.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Lataus keskeytyi. Tarkista verkkoyhteys ja yritä uudelleen.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Asennuspaketin tarkistus epäonnistui. Lataa se uudelleen.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Salli sovelluksen $brand asentaa päivityksiä järjestelmäasetuksissa.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Järjestelmän asennusohjelman avaaminen epäonnistui. Tarkista asennusluvat.';

  @override
  String get appUpdateGenericFailure =>
      'Päivitys epäonnistui. Tarkista verkkoyhteys ja yritä uudelleen.';

  @override
  String get appUpdateUnavailable =>
      'Uusi versio ei ole vielä ladattavissa. Yritä myöhemmin uudelleen.';

  @override
  String get appUpdateCheckFailed =>
      'Päivitysten tarkistus epäonnistui. Yritä myöhemmin uudelleen.';

  @override
  String get appUpdateChecking => 'Tarkistetaan';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Peruuta';

  @override
  String get commonSave => 'Tallenna';

  @override
  String get commonEdit => 'Muokkaa';

  @override
  String get commonDelete => 'Poista';

  @override
  String get commonSearch => 'Etsi';

  @override
  String get commonLoading => 'Ladataan...';

  @override
  String get commonLoadFailed => 'Lataus epäonnistui';

  @override
  String get commonRetry => 'Yritä uudelleen';

  @override
  String get commonEmpty => 'Ei tietoja';

  @override
  String get commonCopy => 'Kopioi';

  @override
  String get commonForward => 'Välitä';

  @override
  String get commonFavorite => 'Tallenna';

  @override
  String get commonClose => 'Sulje';

  @override
  String get commonSend => 'Lähetä';

  @override
  String get commonDone => 'Valmis';

  @override
  String get commonMore => 'Lisää';

  @override
  String get commonSettings => 'Asetukset';

  @override
  String get commonCopied => 'Kopioitu';

  @override
  String get commonUnknown => 'Tuntematon';

  @override
  String get commonNotSet => 'Ei asetettu';

  @override
  String get commonUnbound => 'Ei liitetty';

  @override
  String get commonViewAll => 'Näytä kaikki';

  @override
  String get commonSubmit => 'Lähetä';

  @override
  String get commonAdd => 'Lisää';

  @override
  String get commonRemove => 'Poista';

  @override
  String get commonCreate => 'Luo';

  @override
  String get commonUpdate => 'Päivitä';

  @override
  String get commonUpload => 'Lähetä tiedosto';

  @override
  String get commonShare => 'Jaa';

  @override
  String get commonBlock => 'Estä';

  @override
  String get commonUnblock => 'Poista esto';

  @override
  String get commonMute => 'Mykistä';

  @override
  String get commonUnmute => 'Poista mykistys';

  @override
  String get commonPin => 'Kiinnitetyt';

  @override
  String get commonUnpin => 'Poista kiinnitys';

  @override
  String get commonMarkRead => 'Merkitse luetuksi';

  @override
  String get commonMarkUnread => 'Merkitse lukemattomaksi';

  @override
  String get commonOnline => 'Paikalla';

  @override
  String get commonOffline => 'Poissa verkosta';

  @override
  String get commonOperationFailed => 'Toiminto epäonnistui. Yritä uudelleen.';

  @override
  String get commonNetworkError => 'Verkkovirhe. Tarkista yhteys.';

  @override
  String get navMessages => 'Viestit';

  @override
  String get navContacts => 'Yhteystiedot';

  @override
  String get navMe => 'Minä';

  @override
  String get authLoginTitle => 'Kirjaudu StartLinkiin';

  @override
  String get authTabMobile => 'Puhelin';

  @override
  String get authTabEmail => 'Sähköposti';

  @override
  String get authTabLoginName => 'StartLink-tunnus';

  @override
  String get authHintMobile => 'Anna puhelinnumero';

  @override
  String get authHintEmail => 'Syötä sähköpostiosoitteesi';

  @override
  String get authHintPassword => 'Syötä salasana';

  @override
  String get authHintCode => 'Anna vahvistuskoodi';

  @override
  String get authHintLoginName => 'Anna StartLink-tunnus (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Kirjaudu sisään';

  @override
  String get authGetCode => 'Pyydä koodia';

  @override
  String authResendCode(int seconds) {
    return 'Lähetä uudelleen $seconds s kuluttua';
  }

  @override
  String get authUsePassword => 'Käytä salasanaa';

  @override
  String get authUseCode => 'Käytä vahvistuskoodia';

  @override
  String get authAgreementPrefix => 'Olen lukenut ja hyväksyn';

  @override
  String get authAgreementAnd => 'ja';

  @override
  String get authTermsLink => 'Käyttäjäsopimus';

  @override
  String get authPrivacyLink => 'Tietosuojakäytäntö';

  @override
  String get authCaptchaTitle => 'Turvatarkistus';

  @override
  String get authCaptchaHint => 'Anna vastaus';

  @override
  String get authCaptchaFailed =>
      'CAPTCHA-tarkistuksen hakeminen epäonnistui. Yritä uudelleen.';

  @override
  String get authErrorEmptyCode => 'Anna vahvistuskoodi';

  @override
  String get authErrorEmptyPassword => 'Syötä salasana';

  @override
  String get authErrorEmptyLoginName => 'Anna StartLink-tunnus';

  @override
  String get authErrorWrongCredentials => 'Virheellinen tili tai salasana';

  @override
  String get authDeactivatingTitle => 'Tilin poistaminen käytöstä';

  @override
  String get authDeactivatingContent =>
      'Tilisi on käytöstä poistamisen harkinta-ajalla (7 päivää).\n\nPeruuta poistaminen napauttamalla ”Peruuta käytöstä poistaminen” tai siirry sovellukseen napauttamalla ”Jatka”.';

  @override
  String get authContinueUse => 'Jatka';

  @override
  String get authCancelDeactivation => 'Peruuta käytöstä poistaminen';

  @override
  String get authDeactivationCancelled =>
      'Käytöstä poistaminen peruutettu, tili palautettu';

  @override
  String get authDeactivationCancelFailed =>
      'Peruuttaminen epäonnistui. Yritä uudelleen.';

  @override
  String get authLogout => 'Kirjaudu ulos';

  @override
  String get authLogoutConfirm => 'Haluatko varmasti kirjautua ulos?';

  @override
  String get authSendingCode => 'Lähetetään...';

  @override
  String get authCodeSent => 'Vahvistuskoodi lähetetty';

  @override
  String get authLoginFailed => 'Kirjautuminen epäonnistui. Yritä uudelleen.';

  @override
  String get authRegisterFailed =>
      'Rekisteröityminen epäonnistui. Yritä uudelleen.';

  @override
  String get authEnterpriseCode => 'Yrityskoodi';

  @override
  String get authEnterpriseCodeHint => 'Anna yrityskoodi';

  @override
  String get authPendingApproval =>
      'Rekisteröityminen onnistui. Yritykseen liittymistä koskeva pyyntösi on lähetetty ja odottaa hyväksyntää.';

  @override
  String get authNoAccount => 'Eikö sinulla ole tiliä?';

  @override
  String get authRegisterNow => 'Rekisteröidy nyt';

  @override
  String get authCountryPickerTitle => 'Valitse maa tai alue';

  @override
  String get authCountrySearchHint => 'Hae maata tai aluetta';

  @override
  String get authCountryChinaMainland => 'Manner-Kiina';

  @override
  String get authCountryHongKong => 'Hongkong, Kiina';

  @override
  String get authCountryMacau => 'Macao, Kiina';

  @override
  String get authCountryTaiwan => 'Taiwan, Kiina';

  @override
  String get authCountryUnitedStates => 'Yhdysvallat';

  @override
  String get authCountryUnitedKingdom => 'Yhdistynyt kuningaskunta';

  @override
  String get authCountryJapan => 'Japani';

  @override
  String get authCountrySouthKorea => 'Etelä-Korea';

  @override
  String get authCountrySingapore => 'Singapore';

  @override
  String get authCountryMalaysia => 'Malesia';

  @override
  String get authCountryAustralia => 'Australia';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Saksa';

  @override
  String get authCountryFrance => 'Ranska';

  @override
  String get authCountryIndia => 'Intia';

  @override
  String get authCountryThailand => 'Thaimaa';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesia';

  @override
  String get authCountryPhilippines => 'Filippiinit';

  @override
  String get authQuickLoginTitle => 'Pikakirjautuminen';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Kirjaudutaan. Odota.';

  @override
  String get authRoleOwner => 'Omistaja';

  @override
  String get authRoleAdministrator => 'Ylläpitäjä';

  @override
  String get authRoleCustomerService => 'Asiakaspalvelu';

  @override
  String get authRoleTechnicalSupport => 'Tekninen tuki';

  @override
  String get authRoleEmployee => 'Työntekijä';

  @override
  String get authRoleMember => 'Jäsen';

  @override
  String get authRoleEnterpriseCustomer => 'Yrityksen asiakas';

  @override
  String get authUnavailablePrefix => 'Ei saatavilla · ';

  @override
  String get authUnassignedService => 'Ei nimettyä asiakaspalvelijaa';

  @override
  String authAssignedService(String staff) {
    return 'Nimetty: $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Asiakas · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Työntekijä · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count käyttäjää';
  }

  @override
  String get authMetaPhone => 'Puhelin';

  @override
  String get authMetaIdentity => 'Henkilöllisyys';

  @override
  String get authRegisterTitle => 'Rekisteröidy';

  @override
  String get authNickname => 'Lempinimi';

  @override
  String get authNicknameHint => 'Aseta nimimerkki';

  @override
  String get authPassword => 'Salasana';

  @override
  String get authPasswordSetHint => 'Aseta salasana (vähintään 6 merkkiä)';

  @override
  String get authConfirmPassword => 'Vahvista salasana';

  @override
  String get authConfirmPasswordHint => 'Anna salasana uudelleen';

  @override
  String get authVerificationCode => 'Vahvistuskoodi';

  @override
  String get authRegisterAndLogin => 'Rekisteröidy ja kirjaudu';

  @override
  String get authHaveAccount => 'Onko sinulla jo tili?';

  @override
  String get authGoLogin => 'Kirjaudu sisään';

  @override
  String get authEmailVerificationUnavailable =>
      'Sähköpostivahvistus ei ole käytettävissä. Rekisteröidy matkapuhelinnumerolla.';

  @override
  String get authSmsVerificationUnavailable =>
      'Tekstiviestivahvistus ei ole käytettävissä. Rekisteröidy sähköpostilla.';

  @override
  String get authSendFailed => 'Lähettäminen epäonnistui. Yritä uudelleen.';

  @override
  String get authErrorEmptyNickname => 'Anna nimimerkki';

  @override
  String get authErrorInvalidMobile => 'Anna kelvollinen matkapuhelinnumero';

  @override
  String get authErrorInvalidEmail => 'Anna kelvollinen sähköpostiosoite';

  @override
  String get authErrorPasswordTooShort =>
      'Salasanassa on oltava vähintään 6 merkkiä';

  @override
  String get authErrorPasswordMismatch => 'Salasanat eivät täsmää';

  @override
  String get authErrorVerificationRequired =>
      'Hae ja anna ensin vahvistuskoodi';

  @override
  String get authRegisterErrorTitle => 'Rekisteröityminen epäonnistui';

  @override
  String get authGotIt => 'Selvä';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Yritystä ”$code” ei löytynyt. Tarkista yrityskoodi.';
  }

  @override
  String get authTenantSearchFailed => 'Haku epäonnistui. Yritä uudelleen.';

  @override
  String get authInvitationInvalid =>
      'Kutsukoodi ei kelpaa. Tarkista se ja yritä uudelleen.';

  @override
  String get authCollapseJoin => 'Piilota liittymistiedot';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Kelvollinen kutsu: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Yritys löytyi: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Valitse organisaatio';

  @override
  String get authNoOrganization => 'Ei käytettävissä olevia organisaatioita';

  @override
  String get authNoOrganizationHint =>
      'Pyydä ylläpitäjää kutsumaan sinut organisaatioon';

  @override
  String get authPersonalSpace => 'Henkilökohtainen tila';

  @override
  String get authPersonalSpaceSubtitle =>
      'Keskustelut ystävien kanssa ja henkilökohtaiset suosikit';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Tilan tunnistaminen epäonnistui. Yritä uudelleen.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Henkilökohtaisen tilan palauttaminen epäonnistui. Yritä uudelleen.';

  @override
  String get authJoinEnterpriseFailed =>
      'Yritykseen liittyminen epäonnistui. Yritä myöhemmin uudelleen.';

  @override
  String get homeTitle => 'Viestit';

  @override
  String get homeGatewayConnectingTitle => 'Yhdistetään';

  @override
  String get homePersonalSpace => 'Henkilökohtainen';

  @override
  String get homeOfficialService => 'Virallinen palvelu';

  @override
  String get homeSwitchSpace => 'Vaihda tilaa';

  @override
  String get homeSpaceSubtitle => 'Henkilökohtainen · Yritys';

  @override
  String get homeJoinEnterprise => 'Liity yritykseen';

  @override
  String get homeCreateGroup => 'Uusi ryhmä';

  @override
  String get homeAddFriend => 'Lisää yhteystieto';

  @override
  String get homeScan => 'Skannaa';

  @override
  String get homeJoinNewSpace => 'Liity uuteen tilaan';

  @override
  String get homeSearchConversation => 'Hae';

  @override
  String get homeNoMessages => 'Ei viestejä';

  @override
  String get homeDeleteConversation => 'Poista keskustelu';

  @override
  String get homeDeleteConversationConfirm =>
      'Poistetaanko tämä keskustelu? Keskusteluhistoria tyhjennetään.';

  @override
  String get homePersonalNote => 'Minä (omat muistiinpanot)';

  @override
  String get homeWorkNote => 'Minä (työmuistiinpanot)';

  @override
  String homeConversationCount(int count) {
    return '$count keskustelua';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count lukematonta';
  }

  @override
  String get chatInputHint => 'Kirjoita viesti...';

  @override
  String get chatVoiceHint => 'Puhu pitämällä painettuna';

  @override
  String get chatVoiceRelease => 'Lähetä vapauttamalla';

  @override
  String get chatVoiceCancel => 'Peruuta pyyhkäisemällä ylös';

  @override
  String get chatMenuCopy => 'Kopioi';

  @override
  String get chatMenuForward => 'Välitä';

  @override
  String get chatMenuRecall => 'Peruuta viesti';

  @override
  String get chatMenuDelete => 'Poista';

  @override
  String get chatMenuFavorite => 'Tallenna';

  @override
  String get chatMenuReply => 'Vastaa';

  @override
  String get chatMenuMultiSelect => 'Valitse';

  @override
  String get chatMenuTranslate => 'Käännä';

  @override
  String get chatMenuVoiceToText => 'Muunna tekstiksi';

  @override
  String get chatMenuTextToSpeech => 'Lue ääneen';

  @override
  String get chatStatusRecalled => 'Viesti peruutettu';

  @override
  String get chatRecallSuccess => 'Peruutettu';

  @override
  String get chatRecallFailed => 'Peruuttaminen epäonnistui';

  @override
  String get chatRecallTimeout =>
      'Yli 2 minuuttia vanhoja viestejä ei voi peruuttaa';

  @override
  String get chatTranslateFailed => 'Käännös epäonnistui. Yritä uudelleen.';

  @override
  String get chatTranslateNotConfigured =>
      'Käännöspalvelu ei ole käytettävissä';

  @override
  String get chatVoiceToTextFailed =>
      'Muuntaminen epäonnistui. Yritä uudelleen.';

  @override
  String get chatTextToSpeechFailed =>
      'Ääneen lukeminen epäonnistui. Yritä uudelleen.';

  @override
  String get chatVoiceToText => 'Muunna';

  @override
  String get chatForwardSuccess => 'Välitetty';

  @override
  String get chatForwardFailed => 'Välittäminen epäonnistui. Yritä uudelleen.';

  @override
  String get chatNoConversations => 'Ei keskusteluja välittämistä varten';

  @override
  String get chatSendFailed => 'Lähetys epäonnistui';

  @override
  String get chatResend => 'Lähetä koodi uudelleen';

  @override
  String get chatNotFriend => 'Ei yhteystiedoissa';

  @override
  String get chatNotFriendHint =>
      'Ette ole vielä yhteystietoja. Viestejä ei voi lähettää.';

  @override
  String get chatMutedHint => 'Kaikki jäsenet on mykistetty';

  @override
  String get chatFileUploadFailed =>
      'Tiedoston lähetys epäonnistui. Yritä uudelleen.';

  @override
  String get chatFileStatusNotDownloaded => 'Ei ladattu';

  @override
  String get chatFileStatusDownloaded => 'Ladattu';

  @override
  String get chatFileStatusUploading => 'Lähetetään tiedostoa';

  @override
  String get chatFileStatusUploadFailed => 'Lataus epäonnistui';

  @override
  String get chatCardSendFailed => 'Yhteystietokortin lähetys epäonnistui';

  @override
  String get chatFavoriteSuccess => 'Tallennettu';

  @override
  String get chatFavoriteFailed => 'Suosikkeihin lisääminen epäonnistui';

  @override
  String get chatLoadFailed => 'Lataus epäonnistui';

  @override
  String get chatImageMessage => '[Kuva]';

  @override
  String get chatVoiceMessage => '[Ääniviesti]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Tiedosto]';

  @override
  String get chatLocationMessage => '[Sijainti]';

  @override
  String get chatContactCardMessage => '[Yhteystieto]';

  @override
  String get chatCallLogMessage => '[Puhelu]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Lukenut $count';
  }

  @override
  String get chatUnread => 'Lukematon';

  @override
  String get chatRecalledSelf => 'Peruutit viestin';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender peruutti viestin';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Käännös: $translation';
  }

  @override
  String get chatMessageDeleted => 'Viesti poistettu';

  @override
  String get chatPeer => 'Muu';

  @override
  String get chatSelf => 'Minä';

  @override
  String get chatGenericMessage => '[Viesti]';

  @override
  String get chatVoiceHideText => 'Piilota teksti';

  @override
  String get chatVoiceShowText => 'Muunna tekstiksi';

  @override
  String get chatFileDefaultName => 'Tiedosto';

  @override
  String get chatContactDefaultName => 'Yhteystieto';

  @override
  String get chatContactCardTitle => 'Yhteystietokortti';

  @override
  String get chatCallMissed => 'Vastaamaton';

  @override
  String get chatCallCancelled => 'Peruutettu';

  @override
  String get chatCallRejected => 'Hylätty';

  @override
  String get chatCallDisconnected => 'Yhteys katkennut';

  @override
  String get chatCallEnded => 'Puhelu päättynyt';

  @override
  String get chatCallFailed => 'Puhelu epäonnistui';

  @override
  String chatCallDuration(String duration) {
    return 'Kesto $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videopuhelu';

  @override
  String get chatVoiceCallTitle => 'Äänipuhelu';

  @override
  String get chatToolPhotos => 'Kuvat';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Tiedosto';

  @override
  String get chatToolLocation => 'Sijainti';

  @override
  String get chatToolContactCard => 'Yhteystieto';

  @override
  String get chatToolVoiceCall => 'Äänipuhelu';

  @override
  String get chatToolVideoCall => 'Videopuhelu';

  @override
  String get chatToolFavorites => 'Suosikit';

  @override
  String get chatToolTranslate => 'Käännä';

  @override
  String get chatTranslationChooseLanguage => 'Valitse käännöskieli';

  @override
  String get chatTranslationEnterText => 'Kirjoita ensin teksti';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Mainintoja sisältäviä viestejä ei voi kääntää';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Käännös ei ole käytettävissä ajastettua viestiä muokattaessa';

  @override
  String get chatTranslationFailed => 'Käännös epäonnistui. Yritä uudelleen.';

  @override
  String get chatTranslationEmpty =>
      'Käännöstä ei palautettu. Yritä uudelleen.';

  @override
  String get chatTranslationTranslating => 'Käännetään…';

  @override
  String get chatTranslationSend => 'Lähetä käännös';

  @override
  String get chatTranslationSending => 'Lähetetään…';

  @override
  String get chatTranslationExpand => 'Näytä lisää';

  @override
  String get chatTranslationCollapse => 'Näytä vähemmän';

  @override
  String get chatFileTooLarge => 'Tiedosto ylittää rajan (100 Mt)';

  @override
  String get chatInputMutedAdminOnly =>
      'Vain omistaja tai valitut jäsenet voivat kirjoittaa.';

  @override
  String get chatImageUploadUnsupported =>
      'Kuvan lähetys epäonnistui. Palvelintukea ei ole vielä saatavilla.';

  @override
  String get chatFavoriteLongPressHint =>
      'Lisää viesti suosikkeihin painamalla sitä pitkään';

  @override
  String chatSelectedCount(int count) {
    return '$count valittu';
  }

  @override
  String get chatLocationSheetTitle => 'Lähetä sijainti';

  @override
  String get chatLocationNameLabel => 'Paikan nimi';

  @override
  String get chatLocationNameHint => 'esim. toimisto, asiakkaan osoite';

  @override
  String get chatLocationAddressLabel => 'Osoite';

  @override
  String get chatLocationOptionalHint => 'Valinnainen';

  @override
  String get chatLocationLatitudeLabel => 'Leveysaste';

  @override
  String get chatLocationLatitudeHint => '-90–90';

  @override
  String get chatLocationLongitudeLabel => 'Pituusaste';

  @override
  String get chatLocationLongitudeHint => '-180–180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Anna $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label on sallitun alueen ulkopuolella';
  }

  @override
  String get chatLocationDefaultTitle => 'Sijainti';

  @override
  String get chatMutedFullNotice =>
      'Tämä ryhmä on mykistetty. Vain omistaja tai valitut jäsenet voivat kirjoittaa.';

  @override
  String get chatNotFriendSendBlocked =>
      'Ette ole enää ystäviä, etkä voi lähettää viestejä';

  @override
  String get chatPersonalNotesTitle => 'Omat muistiinpanot';

  @override
  String get chatWorkNotesTitle => 'Työmuistiinpanot';

  @override
  String get chatPersonalNotesDescription =>
      'Kirjaa omia ajatuksiasi ja tallenna tärkeät tiedot tänne\nSynkronointi laitteiden välillä mahdollistaa käytön milloin tahansa';

  @override
  String get chatWorkNotesDescription =>
      'Kirjaa työtehtävät ja tallenna työmateriaalit tänne\nTiimitilat pysyvät erillisinä ja turvallisina';

  @override
  String get chatNoMessages => 'Ei viestejä';

  @override
  String chatReplyTo(String sender) {
    return 'Vastaa käyttäjälle $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature on tulossa pian';
  }

  @override
  String get chatForwardSelectTitle => 'Valitse keskustelu';

  @override
  String get chatContactSelectTitle => 'Valitse yhteystieto';

  @override
  String get chatNoContacts => 'Ei yhteystietoja';

  @override
  String get contactsTitle => 'Yhteystiedot';

  @override
  String get contactsSearch => 'Hae yhteystietoja';

  @override
  String get contactsNewFriends => 'Uudet ystävät';

  @override
  String get contactsGroups => 'Ryhmät';

  @override
  String get contactsFavorites => 'Suosikit';

  @override
  String get contactsRecent => 'Viimeisimmät';

  @override
  String get contactsOrganization => 'Organisaatio';

  @override
  String get contactsAnnouncement => 'Tiedotteet';

  @override
  String get contactsNewApplications => 'Uudet hakemukset';

  @override
  String get contactsCustomerGroups => 'Asiakasryhmät';

  @override
  String get contactsAllCustomers => 'Kaikki asiakkaat';

  @override
  String get contactsMyCustomers => 'Omat asiakkaat';

  @override
  String get contactsViewAll => 'Näytä kaikki';

  @override
  String get contactsMyContacts => 'Omat yhteystiedot';

  @override
  String get contactsMyAdvisor => 'Oma neuvonantaja';

  @override
  String get contactsNoAdvisor => 'Neuvonantajaa ei ole vielä nimetty';

  @override
  String get contactsAdvisorLoading => 'Ladataan...';

  @override
  String get contactsNavigateFailed =>
      'Sivun avaaminen epäonnistui. Yritä uudelleen.';

  @override
  String get contactsEmpty => 'Ei yhteystietoja';

  @override
  String get contactsNoAnnouncement => 'Ei tiedotteita';

  @override
  String get contactsOfficialBadge => 'Virallinen';

  @override
  String get contactsCustomerBadge => 'Asiakas';

  @override
  String get contactsEmptyCustomers => 'Ei asiakkaita';

  @override
  String get myTitle => 'Minä';

  @override
  String get myEnterpriseInfo => 'Yrityksen tiedot';

  @override
  String get myEnterpriseManage => 'Yrityksen hallinta';

  @override
  String get myQrCode => 'QR-koodi';

  @override
  String get myFavorites => 'Suosikit';

  @override
  String get myLanguage => 'Kieli';

  @override
  String get myTimezone => 'Aikavyöhyke';

  @override
  String get myAutoTranslate => 'Automaattinen käännös';

  @override
  String get myNetworkSwitch => 'Vaihda linjaa';

  @override
  String get mySettings => 'Asetukset';

  @override
  String get myLogout => 'Kirjaudu ulos';

  @override
  String get myLogoutConfirm => 'Haluatko varmasti kirjautua ulos?';

  @override
  String get myLeaveEnterprise => 'Eroa yrityksestä';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Haluatko varmasti erota tästä yrityksestä? Menetät pääsyn yrityksen tietoihin.';

  @override
  String get myLeaveEnterpriseSuccess => 'Erosit yrityksestä';

  @override
  String get myLeaveEnterpriseFailed =>
      'Eroaminen epäonnistui. Yritä uudelleen.';

  @override
  String get myLppIdCopied => 'StartLink-tunnus kopioitu';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink-tunnus: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count yhteystietoa';
  }

  @override
  String get myAutoSelect => 'Automaattinen';

  @override
  String get myPresenceStatus => 'Tavoitettavuus';

  @override
  String get myPresenceStatusTitle => 'Aseta tavoitettavuus';

  @override
  String get myPresenceOnline => 'Paikalla';

  @override
  String get myPresenceBusy => 'Varattu';

  @override
  String get myPresenceAway => 'Poissa';

  @override
  String get myPresenceInvisible => 'Näkymätön';

  @override
  String get profileTitle => 'Oma profiili';

  @override
  String get profileName => 'Nimi';

  @override
  String get profileGender => 'Sukupuoli';

  @override
  String get profileBirthday => 'Syntymäpäivä';

  @override
  String get profileRegion => 'Alue';

  @override
  String get profileSignature => 'Esittely';

  @override
  String get profileSignatureHint => 'Kerro jotain itsestäsi';

  @override
  String get profileTapTapText => 'Napautus';

  @override
  String get profileTapTapHint =>
      'Napautettaessa näytettävä teksti (enintään 20 merkkiä)';

  @override
  String get profileAccountSection => 'Tili';

  @override
  String get profileBasicSection => 'Perustiedot';

  @override
  String get profileLppId => 'StartLink-tunnus';

  @override
  String get profileLppIdNotSet => 'Ei asetettu';

  @override
  String get profileMobile => 'Puhelin';

  @override
  String get profileMobileUnbound => 'Ei liitetty';

  @override
  String get profileEmail => 'Sähköposti';

  @override
  String get profileEmailUnbound => 'Ei liitetty';

  @override
  String get profileQrCode => 'Oma QR-koodi';

  @override
  String get profileChangePassword => 'Vaihda salasana';

  @override
  String get profileGenderMale => 'Mies';

  @override
  String get profileGenderFemale => 'Nainen';

  @override
  String get profileGenderOther => 'Muu';

  @override
  String get profileGenderUnset => 'Ei asetettu';

  @override
  String get profileSaveFailed => 'Tallennus epäonnistui. Yritä uudelleen.';

  @override
  String get profileLppIdTitle => 'StartLink-tunnus';

  @override
  String get profileLppIdSetOnce =>
      'StartLink-tunnuksen voi vaihtaa vain kerran. Valitse huolellisesti.';

  @override
  String get profileLppIdChangeFailed =>
      'Vaihto epäonnistui (StartLink-tunnuksen voi vaihtaa vain kerran)';

  @override
  String get profileChangePasswordOld => 'Nykyinen salasana';

  @override
  String get profileChangePasswordNew => 'Uusi salasana';

  @override
  String get profileChangePasswordConfirm => 'Vahvista uusi salasana';

  @override
  String get profileChangePasswordMismatch => 'Salasanat eivät täsmää';

  @override
  String get profileChangePasswordSuccess =>
      'Salasana vaihdettu. Kirjaudu uudelleen.';

  @override
  String get profileChangePasswordFailed =>
      'Salasanan vaihto epäonnistui. Yritä uudelleen.';

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get settingsSectionEnterprise => 'Yritys';

  @override
  String get settingsSectionAccount => 'Tili';

  @override
  String get settingsSectionGeneral => 'Yleiset';

  @override
  String get settingsSectionFeatures => 'Toiminnot';

  @override
  String get settingsSectionAbout => 'Tietoja';

  @override
  String get settingsEnterpriseInfo => 'Yrityksen tiedot';

  @override
  String get settingsProfile => 'Oma profiili';

  @override
  String get settingsAccountSecurity => 'Tilin turvallisuus';

  @override
  String get settingsNotification => 'Ilmoitukset';

  @override
  String get settingsDisplay => 'Näyttö';

  @override
  String get settingsFriendPrivacy => 'Tietosuoja';

  @override
  String get settingsChat => 'Keskustelu';

  @override
  String get settingsChatHistory => 'Keskusteluhistoria';

  @override
  String get settingsAbout => 'Tietoja StartLinkistä';

  @override
  String get settingsLanguage => 'Kieli';

  @override
  String get settingsTimezone => 'Aikavyöhyke';

  @override
  String get settingsAutoTranslate => 'Automaattinen käännös';

  @override
  String get settingsNetworkSwitch => 'Vaihda linjaa';

  @override
  String get enterpriseInfoTitle => 'Yrityksen tiedot';

  @override
  String get enterpriseName => 'Nimi';

  @override
  String get enterpriseDescription => 'Kuvaus';

  @override
  String get enterpriseUpdateSuccess => 'Päivitetty onnistuneesti';

  @override
  String get enterpriseUpdateFailed => 'Päivitys epäonnistui. Yritä uudelleen.';

  @override
  String get enterpriseLeave => 'Eroa yrityksestä';

  @override
  String get enterpriseLeaveConfirm =>
      'Haluatko varmasti erota tästä yrityksestä?';

  @override
  String get enterpriseLeaveSuccess => 'Erosit yrityksestä';

  @override
  String get enterpriseLeaveFailed => 'Eroaminen epäonnistui. Yritä uudelleen.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Omistaja ei voi erota suoraan. Siirrä ensin omistajuus.';

  @override
  String get enterpriseMemberCount => 'Jäsenet';

  @override
  String get enterpriseCreatedAt => 'Luotu';

  @override
  String get enterpriseCode => 'Yrityskoodi';

  @override
  String get enterpriseInviteMembers => 'Kutsu jäseniä';

  @override
  String get enterpriseCopyInviteCode => 'Kopioi kutsukoodi';

  @override
  String get enterpriseInviteCodeCopied => 'Kutsukoodi kopioitu';

  @override
  String get groupCreateTitle => 'Uusi ryhmä';

  @override
  String get groupNameHint => 'Anna ryhmän nimi';

  @override
  String get groupCreateSuccess => 'Ryhmä luotu';

  @override
  String get groupCreateFailed => 'Ryhmän luominen epäonnistui';

  @override
  String get groupSettings => 'Ryhmän asetukset';

  @override
  String get groupName => 'Ryhmän nimi';

  @override
  String get groupAvatar => 'Ryhmän kuva';

  @override
  String get groupAnnouncement => 'Tiedote';

  @override
  String get groupMembers => 'Jäsenet';

  @override
  String get groupAddMember => 'Lisää jäseniä';

  @override
  String get groupRemoveMember => 'Poista jäsen';

  @override
  String get groupRemoveMemberConfirm => 'Poistetaanko tämä jäsen?';

  @override
  String get groupSetAdmin => 'Nimeä ylläpitäjäksi';

  @override
  String get groupRemoveAdmin => 'Poista ylläpitäjän oikeudet';

  @override
  String get groupTransferOwner => 'Siirrä omistajuus';

  @override
  String get groupTransferOwnerConfirm =>
      'Siirretäänkö ryhmän omistajuus tälle jäsenelle?';

  @override
  String get groupTransferOwnerSuccess => 'Omistajuus siirretty';

  @override
  String get groupTransferOwnerFailed => 'Siirto epäonnistui. Yritä uudelleen.';

  @override
  String get groupLeave => 'Poistu ryhmästä';

  @override
  String get groupLeaveConfirm => 'Poistutaanko tästä ryhmästä?';

  @override
  String get groupLeaveSuccess => 'Poistuit ryhmästä';

  @override
  String get groupLeaveFailed => 'Eroaminen epäonnistui. Yritä uudelleen.';

  @override
  String get groupDissolve => 'Lopeta ryhmä';

  @override
  String get groupDissolveConfirm =>
      'Lopetetaanko tämä ryhmä? Kaikki jäsenet poistetaan.';

  @override
  String get groupDissolveSuccess => 'Ryhmä lopetettu';

  @override
  String get groupDissolveFailed =>
      'Ryhmän lopettaminen epäonnistui. Yritä uudelleen.';

  @override
  String get groupQrCode => 'Ryhmän QR-koodi';

  @override
  String get groupMuteAll => 'Mykistä kaikki';

  @override
  String get groupMuteAllOn => 'Ota kaikkien mykistys käyttöön';

  @override
  String get groupMuteAllOff => 'Poista kaikkien mykistys käytöstä';

  @override
  String get groupAllowMemberInvite => 'Salli jäsenten kutsua muita';

  @override
  String get groupAllowMemberModifyTitle =>
      'Salli jäsenten muuttaa ryhmän nimeä';

  @override
  String get groupAllowMemberAtAll => 'Salli jäsenten mainita kaikki';

  @override
  String get groupAllowMemberViewMemberList =>
      'Salli jäsenten tarkastella jäsenluetteloa';

  @override
  String get groupAllowQrCodeJoin => 'Salli liittyminen QR-koodilla';

  @override
  String get groupRequireApproval => 'Vaadi liittymisen hyväksyntä';

  @override
  String get groupAllowMemberAddFriend => 'Salli jäsenten lisätä toisensa';

  @override
  String get groupRoleOwner => 'Omistaja';

  @override
  String get groupRoleAdmin => 'Ylläpitäjä';

  @override
  String get groupRoleMember => 'Jäsen';

  @override
  String get groupNoMembers => 'Ei jäseniä';

  @override
  String get groupNoAnnouncements => 'Ei tiedotteita';

  @override
  String get groupCreateAnnouncement => 'Julkaise tiedote';

  @override
  String get groupEditAnnouncement => 'Muokkaa tiedotetta';

  @override
  String get groupDeleteAnnouncement => 'Poista tiedote';

  @override
  String get groupDeleteAnnouncementConfirm => 'Poistetaanko tämä tiedote?';

  @override
  String get groupAnnouncementTitle => 'Otsikko';

  @override
  String get groupAnnouncementContent => 'Sisältö';

  @override
  String get groupAnnouncementPin => 'Kiinnitä tiedote';

  @override
  String groupMemberCount(int count) {
    return '$count jäsentä';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count valittu';
  }

  @override
  String get groupJoinRequestApprove => 'Hyväksyn';

  @override
  String get groupJoinRequestReject => 'Kieltäydy';

  @override
  String get groupJoinRequests => 'Liittymispyynnöt';

  @override
  String get groupNoJoinRequests => 'Ei liittymispyyntöjä';

  @override
  String get groupReadReceipts => 'Lukukuittaukset';

  @override
  String groupReadCount(int count) {
    return '$count lukenut';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count lukematonta';
  }

  @override
  String get friendAddTitle => 'Lisää yhteystieto';

  @override
  String get friendSearchHint => 'Puhelin / sähköposti / StartLink-tunnus';

  @override
  String get friendRequestSent => 'Ystäväpyyntö lähetetty';

  @override
  String get friendRequestFailed => 'Lähetys epäonnistui. Yritä uudelleen.';

  @override
  String get friendAlreadyFriend => 'Olette jo yhteystietoja';

  @override
  String get friendNewFriendsTitle => 'Uudet ystävät';

  @override
  String get friendNoRequests => 'Ei ystäväpyyntöjä';

  @override
  String get friendAccept => 'Hyväksy';

  @override
  String get friendReject => 'Kieltäydy';

  @override
  String get friendAccepted => 'Hyväksytty';

  @override
  String get friendRejected => 'hylätty';

  @override
  String get friendDeleteConfirm => 'Poistetaanko tämä yhteystieto?';

  @override
  String get friendDeleteSuccess => 'Yhteystieto poistettu';

  @override
  String get friendDeleteFailed => 'Poistaminen epäonnistui. Yritä uudelleen.';

  @override
  String get friendRemarkName => 'Nimimerkki';

  @override
  String get friendGroupName => 'Ryhmä';

  @override
  String get friendSendMessage => 'Viesti';

  @override
  String get friendMatchTypeLppId => 'Löytyi StartLink-tunnuksella';

  @override
  String get friendMatchTypeMobile => 'Löytyi puhelinnumerolla';

  @override
  String get friendMatchTypeEmail => 'Löytyi sähköpostilla';

  @override
  String get friendSearchEmpty => 'Käyttäjiä ei löytynyt';

  @override
  String get friendAddMessage => 'Haluaisin lisätä sinut yhteystietoihin';

  @override
  String get friendBlockConfirm => 'Estetäänkö tämä käyttäjä?';

  @override
  String get friendUnblockConfirm => 'Poistetaanko tämän käyttäjän esto?';

  @override
  String get friendBlockSuccess => 'Estetty';

  @override
  String get friendUnblockSuccess => 'Esto poistettu';

  @override
  String get profilePageTitle => 'Henkilökohtaiset tiedot';

  @override
  String get profilePageSendMessage => 'Viesti';

  @override
  String get profilePageAddFriend => 'Lisää ystävä';

  @override
  String get profilePageAlreadyFriend => 'Olette jo ystäviä';

  @override
  String get profilePageBlocked => 'Estetty';

  @override
  String get profilePageBlock => 'Estä';

  @override
  String get profilePageUnblock => 'Poista esto';

  @override
  String get profilePageHidden => 'Tämä käyttäjä on piilottanut profiilinsa';

  @override
  String get profilePageFriendsOnly =>
      'Tämä käyttäjä näyttää profiilinsa vain ystäville';

  @override
  String get profilePageLppId => 'StartLink-tunnus';

  @override
  String get profilePageRemarkName => 'Huomiot';

  @override
  String get profilePageEditRemark => 'Muokkaa nimimerkkiä';

  @override
  String get profilePageSaveRemarkSuccess => 'Nimimerkki tallennettu';

  @override
  String get profilePageSaveRemarkFailed =>
      'Tallennus epäonnistui. Yritä uudelleen.';

  @override
  String get searchTitle => 'Etsi';

  @override
  String get searchHint =>
      'Hae puhelinnumerolla, sähköpostilla tai StartLink-tunnuksella';

  @override
  String get searchNoResults => 'Ei tuloksia';

  @override
  String get searchMessages => 'Viestit';

  @override
  String get searchUsers => 'Käyttäjät';

  @override
  String get searchFailed => 'Haku epäonnistui. Yritä uudelleen.';

  @override
  String get scanTitle => 'Skannaa';

  @override
  String get scanFailed => 'Tunnistus epäonnistui. Yritä uudelleen.';

  @override
  String get scanInvalidQrCode => 'Virheellinen QR-koodi';

  @override
  String get scanFlashOn => 'Sytytä taskulamppu';

  @override
  String get scanFlashOff => 'Sammuta taskulamppu';

  @override
  String get scanAlbum => 'Valitse albumista';

  @override
  String get favoritesTitle => 'Suosikit';

  @override
  String get favoritesEmpty => 'Ei vielä tallennettuja kohteita';

  @override
  String get favoritesAll => 'Kaikki';

  @override
  String get favoritesText => 'Teksti';

  @override
  String get favoritesImage => 'Kuvat';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Ääniviestit';

  @override
  String get favoritesFile => 'Tiedostot';

  @override
  String get favoritesOther => 'Muu';

  @override
  String get favoritesDeleteConfirm => 'Poistetaanko suosikeista?';

  @override
  String get favoritesDeleteSuccess => 'Poistettu tallennetuista';

  @override
  String get favoritesDeleteFailed => 'Poistaminen epäonnistui';

  @override
  String get favoritesOriginalRecalled => 'Viesti peruutettu';

  @override
  String get favoritesViewOriginal => 'Näytä alkuperäinen';

  @override
  String get favoritesSearchHint => 'Hae suosikeista';

  @override
  String get favoritesNoResults => 'Ei vastaavia suosikkeja';

  @override
  String get noticeTitle => 'Tiedotteet';

  @override
  String get noticeEmpty => 'Ei tiedotteita';

  @override
  String get noticeDetail => 'Tiedotteen tiedot';

  @override
  String get noticePublishedAt => 'Julkaistu';

  @override
  String get noticePriorityNormal => 'Normaali';

  @override
  String get noticePriorityImportant => 'Tärkeä';

  @override
  String get noticePriorityUrgent => 'Kiireellinen';

  @override
  String get organizationTitle => 'Organisaatio';

  @override
  String get organizationEmpty => 'Ei osastotietoja';

  @override
  String get organizationMembers => 'Jäsenet';

  @override
  String get organizationDepartment => 'Osasto';

  @override
  String get organizationPosition => 'Tehtävä';

  @override
  String get organizationLeader => 'Esihenkilö';

  @override
  String get qrCodeTitle => 'Oma QR-koodi';

  @override
  String get qrCodeSave => 'Tallenna albumiin';

  @override
  String get qrCodeShare => 'Jaa';

  @override
  String get qrCodeSaveSuccess => 'Tallennettu albumiin';

  @override
  String get qrCodeSaveFailed => 'Tallennus epäonnistui. Yritä uudelleen.';

  @override
  String get qrCodeRefresh => 'Päivitä QR-koodi';

  @override
  String get qrCodeExpired => 'QR-koodi on vanhentunut. Päivitä se.';

  @override
  String get qrCodeScanToAdd => 'Lisää minut yhteystiedoksi skannaamalla';

  @override
  String get spacePersonal => 'Henkilökohtainen';

  @override
  String get spaceEnterprise => 'Yritys';

  @override
  String get spaceJoinByCode => 'Liity yrityskoodilla';

  @override
  String get spaceJoinByInvite => 'Liity kutsukoodilla';

  @override
  String get spaceEnterCode => 'Anna yrityskoodi';

  @override
  String get spaceEnterInviteCode => 'Anna kutsukoodi';

  @override
  String get spaceSearchEnterprise => 'Hae yritystä';

  @override
  String get spaceJoinRequestSent => 'Pyyntö lähetetty, odottaa hyväksyntää';

  @override
  String get spaceJoinRequestPending => 'Hyväksyntä odottaa';

  @override
  String get spaceJoinRequestApproved => 'Pyyntö hyväksytty';

  @override
  String get spaceJoinRequestRejected => 'Pyyntö hylätty';

  @override
  String get spaceAlreadyMember => 'Olet jo jäsen';

  @override
  String get spaceAutoApproved => 'Hyväksytty automaattisesti. Tervetuloa!';

  @override
  String get spacePendingApprovalHint =>
      'Rekisteröityminen onnistui. Liittymispyyntösi on lähetetty.';

  @override
  String get spaceNoSpaces => 'Ei tiloja';

  @override
  String get spaceInviteExpired => 'Kutsukoodi on vanhentunut';

  @override
  String get spaceInviteTargetMismatch => 'Tämä kutsukoodi ei ole tilillesi';

  @override
  String get spaceAcceptInviteSuccess => 'Liityit yritykseen';

  @override
  String get spaceAcceptInviteFailed =>
      'Liittyminen epäonnistui. Yritä uudelleen.';

  @override
  String get spaceTenantSelectTitle => 'Valitse tila';

  @override
  String get spaceTenantSelectHint => 'Valitse tila, johon siirryt';

  @override
  String get spaceEnterPersonal => 'Siirry henkilökohtaiseen tilaan';

  @override
  String get spaceEnterEnterprise => 'Siirry yritystilaan';

  @override
  String get aboutTitle => 'Tietoja StartLinkistä';

  @override
  String get aboutVersion => 'Versio';

  @override
  String get aboutTerms => 'Käyttäjäsopimus';

  @override
  String get aboutPrivacy => 'Tietosuojakäytäntö';

  @override
  String get aboutOpenSource => 'Avoimen lähdekoodin lisenssit';

  @override
  String get aboutCheckUpdate => 'Tarkista päivitykset';

  @override
  String get aboutLatestVersion => 'Olet viimeisimmällä versiolla';

  @override
  String get aboutUpdateAvailable => 'Uusi versio saatavilla';

  @override
  String get aboutUpdateNow => 'Päivitä nyt';

  @override
  String get aboutUpdateLater => 'Myöhemmin';

  @override
  String get notificationTitle => 'Ilmoitukset';

  @override
  String get notificationGlobalMute => 'Älä häiritse';

  @override
  String get notificationSound => 'Ääni';

  @override
  String get notificationVibration => 'Värinä';

  @override
  String get notificationPreview => 'Viestin esikatselu';

  @override
  String get notificationDndStart => 'Älä häiritse -tilan alkamisaika';

  @override
  String get notificationDndEnd => 'Älä häiritse -tilan päättymisaika';

  @override
  String get blacklistTitle => 'Estetty';

  @override
  String get blacklistEmpty => 'Ei estettyjä käyttäjiä';

  @override
  String get blacklistRemove => 'Poista esto';

  @override
  String get blacklistRemoveConfirm => 'Poistetaanko tämän käyttäjän esto?';

  @override
  String get feedbackTitle => 'Palaute';

  @override
  String get feedbackTypeComplaint => 'Valitus';

  @override
  String get feedbackTypeSuggestion => 'Ehdotus';

  @override
  String get feedbackTypeBug => 'Virheraportti';

  @override
  String get feedbackContent => 'Kuvaus';

  @override
  String get feedbackContentHint =>
      'Kuvaile ongelmasi tai ehdotuksesi yksityiskohtaisesti';

  @override
  String get feedbackContact => 'Yhteystiedot (valinnainen)';

  @override
  String get feedbackSubmit => 'Lähetä';

  @override
  String get feedbackSuccess => 'Palaute lähetetty. Kiitos!';

  @override
  String get feedbackFailed => 'Lähetys epäonnistui. Yritä uudelleen.';

  @override
  String get networkTitle => 'Vaihda linjaa';

  @override
  String get networkAutoSelect => 'Automaattinen';

  @override
  String get networkManual => 'Manuaalinen';

  @override
  String get timezoneTitle => 'Aikavyöhyke';

  @override
  String get timezoneAuto => 'Järjestelmän mukaan';

  @override
  String get autoTranslateTitle => 'Automaattinen käännös';

  @override
  String get autoTranslateEnabled => 'Ota automaattinen käännös käyttöön';

  @override
  String get autoTranslateLanguage => 'Kohdekieli';

  @override
  String get displayTitle => 'Näyttö';

  @override
  String get displayFontSize => 'Fontin koko';

  @override
  String get displayChatBackground => 'Keskustelun tausta';

  @override
  String get displayDarkMode => 'Ulkoasu';

  @override
  String get displayDarkModeSystem => 'Järjestelmän mukaan';

  @override
  String get displayDarkModeSystemHint =>
      'Vaihda automaattisesti järjestelmäasetuksen mukaan';

  @override
  String get displayDarkModeOff => 'Vaalea';

  @override
  String get displayDarkModeOffHint => 'Käytä aina vaaleaa teemaa';

  @override
  String get displayDarkModeOn => 'Tumma';

  @override
  String get displayDarkModeOnHint => 'Käytä aina tummaa teemaa';

  @override
  String get chatSettingsTitle => 'Keskustelu';

  @override
  String get chatHistoryTitle => 'Keskusteluhistoria';

  @override
  String get chatHistoryClear => 'Tyhjennä koko historia';

  @override
  String get chatHistoryClearConfirm =>
      'Tyhjennetäänkö koko keskusteluhistoria? Tätä ei voi perua.';

  @override
  String get chatHistoryClearSuccess => 'Keskusteluhistoria tyhjennetty';

  @override
  String get accountSecurityTitle => 'Tilin turvallisuus';

  @override
  String get accountSecurityChangePassword => 'Vaihda salasana';

  @override
  String get accountSecurityChangeMobile => 'Vaihda puhelinnumero';

  @override
  String get accountSecurityChangeEmail => 'Vaihda sähköposti';

  @override
  String get accountSecurityLoggedDevices => 'Kirjautuneet laitteet';

  @override
  String get accountSecurityDeactivate => 'Poista tili käytöstä';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Kaikki tiedot poistetaan pysyvästi 7 päivän kuluttua. Poistetaanko tili käytöstä?';

  @override
  String get loggedDevicesTitle => 'Kirjautuneet laitteet';

  @override
  String get loggedDevicesCurrent => 'Tämä laite';

  @override
  String get loggedDevicesRevoke => 'Kirjaudu ulos';

  @override
  String get loggedDevicesRevokeConfirm =>
      'Kirjaudutaanko ulos tästä laitteesta?';

  @override
  String get loggedDevicesRevokeSuccess => 'Kirjauduttu ulos laitteesta';

  @override
  String get loggedDevicesRevokeFailed => 'Epäonnistui. Yritä uudelleen.';

  @override
  String get loggedDevicesLastActive => 'Viimeksi aktiivinen';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Verkko';

  @override
  String get loggedDevicesTypeDesktop => 'Tietokone';

  @override
  String get loggedDevicesTypeUnknown => 'Tuntematon laite';

  @override
  String get privacySettingsTitle => 'Tietosuoja';

  @override
  String get privacySearchableByMobile => 'Salli haku puhelinnumerolla';

  @override
  String get privacySearchableByLppId => 'Salli haku StartLink-tunnuksella';

  @override
  String get privacyAllowFriendRequest => 'Salli ystäväpyynnöt';

  @override
  String get privacyProfileVisibility => 'Profiilin näkyvyys';

  @override
  String get privacyEveryone => 'Kaikki';

  @override
  String get privacyFriendsOfFriends => 'Ystävien ystävät';

  @override
  String get privacyNobody => 'Ei kukaan';

  @override
  String get privacyFriendsOnly => 'Vain ystävät';

  @override
  String get privacySaveSuccess => 'Asetukset tallennettu';

  @override
  String get privacySaveFailed => 'Tallennus epäonnistui. Yritä uudelleen.';

  @override
  String get fontSizeTitle => 'Fontin koko';

  @override
  String get fontSizeSmall => 'Pieni';

  @override
  String get fontSizeNormal => 'Normaali';

  @override
  String get fontSizeLarge => 'Suuri';

  @override
  String get fontSizeExtraLarge => 'Erittäin suuri';

  @override
  String get fontSizePreview => 'Esikatselu';

  @override
  String get chatBackgroundTitle => 'Keskustelun tausta';

  @override
  String get chatBackgroundDefault => 'Oletus';

  @override
  String get chatBackgroundCustom => 'Mukautettu';

  @override
  String get chatBackgroundReset => 'Palauta oletusarvot';

  @override
  String get termsTitle => 'Käyttäjäsopimus';

  @override
  String get privacyPolicyTitle => 'Tietosuojakäytäntö';

  @override
  String get recentContactsTitle => 'Viimeisimmät';

  @override
  String get recentContactsEmpty => 'Ei viimeaikaisia yhteystietoja';

  @override
  String get inviteFriendsTitle => 'Kutsu ystäviä';

  @override
  String get inviteFriendsCopyLink => 'Kopioi kutsulinkki';

  @override
  String get inviteFriendsLinkCopied => 'Kutsulinkki kopioitu';

  @override
  String get imageViewerTitle => 'Valokuva';

  @override
  String get imageViewerSave => 'Tallenna albumiin';

  @override
  String get imageViewerSaveSuccess => 'Tallennettu albumiin';

  @override
  String get imageViewerSaveFailed => 'Tallennus epäonnistui. Yritä uudelleen.';

  @override
  String get customerServiceTitle => 'Asiakaspalvelupiste';

  @override
  String get customerServiceQueue => 'Jonossa';

  @override
  String get customerServiceActive => 'Aktiivinen';

  @override
  String get customerServiceClaim => 'Hyväksy';

  @override
  String get customerServiceTakeover => 'Ota haltuun';

  @override
  String get customerServiceClose => 'Päätä palvelu';

  @override
  String get customerServiceCloseConfirm => 'Päätetäänkö tämä palveluistunto?';

  @override
  String get customerServiceNoQueue => 'Ei jonossa olevia istuntoja';

  @override
  String get customerServiceNoActive => 'Ei aktiivisia istuntoja';

  @override
  String get customerServiceVisitor => 'Vierailija';

  @override
  String get customerServiceCustomer => 'Asiakas';

  @override
  String get customerServiceAssignedTo => 'Nimetty';

  @override
  String get customerServiceTransferConversation => 'Siirrä keskustelu';

  @override
  String get marketingToolbar => 'Markkinointityökalut';

  @override
  String get callIncoming => 'Saapuva puhelu';

  @override
  String get callOutgoing => 'Lähtevä puhelu';

  @override
  String get callAccept => 'Hyväksy';

  @override
  String get callReject => 'Kieltäydy';

  @override
  String get callHangup => 'Lopeta';

  @override
  String get callMissed => 'Vastaamaton puhelu';

  @override
  String get callDuration => 'Kesto';

  @override
  String get callAudio => 'Äänipuhelu';

  @override
  String get callGeneric => 'Puhelu';

  @override
  String get callVideo => 'Videopuhelu';

  @override
  String get callConnecting => 'Yhdistetään...';

  @override
  String get callRinging => 'Hälyttää...';

  @override
  String get callEnded => 'Puhelu päättynyt';

  @override
  String get callFailed => 'Puhelu epäonnistui';

  @override
  String get callRejected => 'Puhelu hylätty';

  @override
  String get callTimeout => 'Ei vastausta';

  @override
  String get callCancelled => 'Peruutettu';

  @override
  String get callUnknownPeer => 'Tuntematon';

  @override
  String get callVideoInvitation => 'Kutsu videopuheluun';

  @override
  String get callAudioInvitation => 'Kutsu äänipuheluun';

  @override
  String get callAnswerAudio => 'Vastaa äänellä';

  @override
  String get callAnswerVideo => 'Vastaa videolla';

  @override
  String get callViewProfile => 'Näytä profiili';

  @override
  String get callOpeningCamera => 'Avataan kameraa...';

  @override
  String get callWaitingRemoteVideo => 'Odotetaan toisen osapuolen videota...';

  @override
  String get callCameraOff => 'Kamera pois päältä';

  @override
  String get callCameraOn => 'Kamera päällä';

  @override
  String get callMicrophoneOff => 'Mikrofoni pois päältä';

  @override
  String get callMicrophoneOn => 'Mikrofoni päällä';

  @override
  String get callSpeakerOff => 'Kaiutin pois päältä';

  @override
  String get callSpeakerOn => 'Kaiutin päällä';

  @override
  String get callVideoPermissionFailure =>
      'Videopuhelun aloittaminen epäonnistui. Tarkista kameran ja mikrofonin käyttöluvat ja yritä uudelleen.';

  @override
  String get callAudioPermissionFailure =>
      'Äänipuhelun aloittaminen epäonnistui. Tarkista mikrofonin käyttölupa ja yritä uudelleen.';

  @override
  String get callIncompleteIncoming =>
      'Saapuvan puhelun tiedot ovat puutteelliset, eikä puheluun voi vastata.';

  @override
  String get callInProgress => 'Puhelussa';

  @override
  String get callCalling => 'Soitetaan...';

  @override
  String callEndedMedia(String media) {
    return '$media päättyi';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media hylättiin';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media jäi vastaamatta';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media peruutettiin';
  }

  @override
  String get callConnectionLost => 'Puheluyhteys katkesi';

  @override
  String get callAdminEnded => 'Ylläpitäjä päätti puhelun';

  @override
  String callFailedMedia(String media) {
    return '$media epäonnistui';
  }

  @override
  String get callBusy => 'Toinen osapuoli on varattu';

  @override
  String callDurationValue(String duration) {
    return 'Puhelun kesto $duration';
  }

  @override
  String get callNotConnected => 'Ei yhdistetty';

  @override
  String get callDialed => 'Lähtevä';

  @override
  String get callAnswered => 'Vastattu';

  @override
  String get callRejectedByPeer => 'Toinen osapuoli hylkäsi';

  @override
  String get callRejectedBySelf => 'hylätty';

  @override
  String get callPeerDidNotAnswer => 'Toinen osapuoli ei vastannut';

  @override
  String get callMissedIncoming => 'Vastaamaton saapuva puhelu';

  @override
  String get callPeerCancelled => 'Toinen osapuoli peruutti';

  @override
  String get notificationNewMessageTitle => 'Uusi StartLink-viesti';

  @override
  String get notificationOnlineServiceTitle => 'Uusi asiakaspalveluviesti';

  @override
  String get notificationNewMessageBody => 'Sait uuden viestin';

  @override
  String get notificationImagePreview => 'Lähetti kuvan';

  @override
  String get notificationVideoPreview => 'Lähetti videon';

  @override
  String get notificationVoicePreview => 'Lähetti ääniviestin';

  @override
  String get notificationFilePreview => 'Lähetti tiedoston';

  @override
  String get notificationContactPreview => 'Lähetti yhteystietokortin';

  @override
  String get notificationCallLogPreview => 'Lähetti puhelutietueen';

  @override
  String get notificationLocationPreview => 'Jakoi sijainnin';

  @override
  String get notificationLinkPreview => 'Jakoi linkin';

  @override
  String notificationMentionMe(String body) {
    return 'Mainitsi sinut: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender mainitsi sinut: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Mainitsi kaikki: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender mainitsi kaikki: $body';
  }

  @override
  String get notificationSecurityTitle => 'Tilin turvallisuushälytys';

  @override
  String get notificationSecurityBody =>
      'StartLink-tilisi turvallisuusasetukset muuttuivat. Tarkista ne nyt.';

  @override
  String get notificationFriendAcceptedTitle => 'Ystäväpyyntö hyväksytty';

  @override
  String get notificationFriendRejectedTitle => 'Ystäväpyyntö hylätty';

  @override
  String get notificationFriendAcceptedBody =>
      'Toinen osapuoli hyväksyi ystäväpyyntösi';

  @override
  String get notificationFriendRejectedBody =>
      'Toinen osapuoli hylkäsi ystäväpyyntösi';

  @override
  String get notificationVideoCallTitle => 'Kutsu videopuheluun';

  @override
  String get notificationAudioCallTitle => 'Kutsu äänipuheluun';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller kutsui sinut videopuheluun';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller kutsui sinut äänipuheluun';
  }

  @override
  String get notificationMessageChannelName => 'Viestit';

  @override
  String get notificationMessageChannelDescription =>
      'Keskusteluviestit, puhelutietueet ja järjestelmähälytykset';

  @override
  String get notificationCallChannelName => 'Puhelut';

  @override
  String get notificationCallChannelDescription =>
      'Ääni- ja videopuhelujen hälytykset';

  @override
  String get notificationSecurityChannelName => 'Tilin turvallisuus';

  @override
  String get notificationSecurityChannelDescription =>
      'Kirjautumisen sekä salasanan ja matkapuhelinnumeron muutosten hälytykset';

  @override
  String get notificationUnknownCaller => 'Tuntematon soittaja';

  @override
  String get pendingJoinRequestsTitle => 'Uudet hakemukset';

  @override
  String get pendingJoinRequestsEmpty => 'Ei hakemuksia';

  @override
  String get pendingJoinRequestApprove => 'Hyväksyn';

  @override
  String get pendingJoinRequestReject => 'Kieltäydy';

  @override
  String get pendingJoinRequestApproveSuccess => 'Hyväksytty';

  @override
  String get pendingJoinRequestRejectSuccess => 'Hylätty';

  @override
  String get pendingJoinRequestFailed =>
      'Toiminto epäonnistui. Yritä uudelleen.';

  @override
  String get myCustomersTitle => 'Omat asiakkaat';

  @override
  String get myCustomersEmpty => 'Ei asiakkaita';

  @override
  String get groupListTitle => 'Ryhmät';

  @override
  String get groupListEmpty => 'Ei ryhmiä';

  @override
  String get addFriendTitle => 'Lisää yhteystieto';

  @override
  String get addFriendSearchHint => 'Puhelin / sähköposti / StartLink-tunnus';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink-tunnus: $lppId';
  }

  @override
  String get addFriendButton => 'Lisää';

  @override
  String get addFriendCannotAddSelf => 'Et voi lisätä itseäsi';

  @override
  String get addFriendUnsupportedUser =>
      'Tätä käyttäjää ei voi lisätä. Voit lähettää hänelle viestin suoraan.';

  @override
  String get addFriendMessageHint => 'Kirjoita viesti';

  @override
  String get addFriendSendRequest => 'Lähetä pyyntö';

  @override
  String get joinCompanyTitle => 'Liity yritykseen';

  @override
  String get joinCompanyCodeHint => 'Anna yrityskoodi';

  @override
  String get joinCompanySearchHint => 'Hae yrityksen nimeä';

  @override
  String get joinCompanyApply => 'Hae jäsenyyttä';

  @override
  String get joinCompanyApplySuccess => 'Hakemus lähetetty';

  @override
  String get joinCompanyApplyFailed =>
      'Hakeminen epäonnistui. Yritä uudelleen.';

  @override
  String get joinCompanyAutoApproved =>
      'Hyväksytty automaattisesti. Tervetuloa!';

  @override
  String get joinCompanyPending => 'Hakemus lähetetty, odottaa hyväksyntää';

  @override
  String get joinCompanyInviteCodeHint => 'Anna kutsukoodi';

  @override
  String get joinCompanyAcceptInvite => 'Hyväksy kutsu';

  @override
  String get joinCompanyNoResults => 'Yrityksiä ei löytynyt';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count jäsentä';
  }

  @override
  String get timezoneNameHawaii => 'Havaiji';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Tyynenmeren aika';

  @override
  String get timezoneNameMountainTime => 'Vuoristoaika';

  @override
  String get timezoneNameCentralTime => 'Keskinen aika';

  @override
  String get timezoneNameEasternTime => 'Itäinen aika';

  @override
  String get timezoneNameAtlanticTime => 'Atlantin aika';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azorit';

  @override
  String get timezoneNameLondonDublin => 'Lontoo/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berliini/Pariisi/Rooma';

  @override
  String get timezoneNameCairoHelsinki => 'Kairo/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskova/Riad';

  @override
  String get timezoneNameTehran => 'Teheran';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Baku';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karachi/Taškent';

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
  String get timezoneNameTokyoSeoul => 'Tokio/Soul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Salomonsaaret';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fidži';

  @override
  String get networkSmartSelectBestRoute => 'Valitse paras reitti älykkäästi';

  @override
  String get networkTesting => 'Testataan...';

  @override
  String get networkTestingShort => 'Testataan';

  @override
  String networkLatencyMs(int ms) {
    return 'Viive $ms ms';
  }

  @override
  String get networkConnectionMode => 'Yhteystila';

  @override
  String get networkDirectMode => 'Suora tila';

  @override
  String get networkProxyMode => 'Välityspalvelintila';

  @override
  String get networkDirectModeDesc => 'Yhdistä suoraan palvelimeen';

  @override
  String get networkProxyModeDesc => 'Yhdistä välityspalvelimen kautta';

  @override
  String get networkDirectRoutes => 'Suorat reitit';

  @override
  String get networkProxyRoutes => 'Välityspalvelinreitit';

  @override
  String get networkTestAll => 'Testaa kaikki';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Hongkongin solmu';

  @override
  String get networkSingaporeNode => 'Singaporen solmu';

  @override
  String get networkJapanNode => 'Japanin solmu';

  @override
  String get networkUnitedStatesNode => 'Yhdysvaltojen solmu';

  @override
  String get networkHint =>
      'Vinkkejä:\n• Suora tila: nopeampi ja sopii kotimaan käyttöön\n• Välityspalvelintila: vakaampi kansainvälisessä viestinnässä\n• Napauta päivityskuvaketta testataksesi yksittäisen reitin viiveen';

  @override
  String get teenModeTitle => 'Nuorisotila';

  @override
  String get teenModeStatusOn => 'Päällä';

  @override
  String get teenModeStatusOff => 'Pois käytöstä';

  @override
  String get teenModeStatusLoading => 'Ladataan';

  @override
  String get teenModeUnavailable =>
      'Nuorisotilan tila ei ole tilapäisesti saatavilla';

  @override
  String get teenModeInvalidResponse =>
      'Nuorisotila palautti virheellisen vastauksen';

  @override
  String get teenModeEnableDescription =>
      'Alustan säännöt rajoittavat käyttöaikaa ja valittuja toimintoja.';

  @override
  String get teenModePasscode => 'Pääsykoodi';

  @override
  String get teenModeCurrentPasscode => 'Nykyinen pääsykoodi';

  @override
  String get teenModeNewPasscode => 'Uusi pääsykoodi';

  @override
  String get teenModePasscodeHint => 'Anna 4–6 numeroa';

  @override
  String get teenModeEnable => 'Ota nuorisotila käyttöön';

  @override
  String get teenModeDisable => 'Poista nuorisotila käytöstä';

  @override
  String get teenModeChangePasscode => 'Vaihda pääsykoodi';

  @override
  String get teenModeSource => 'Käyttöön ottanut';

  @override
  String get teenModeDailyUsage => 'Käytetty tänään';

  @override
  String get teenModeRemaining => 'Aikaa jäljellä';

  @override
  String get teenModeMinutesUnit => 'Minuutit';

  @override
  String get teenModeUnlimited => 'Rajoittamaton';

  @override
  String get teenModeRequestExtension => 'Pyydä lisäaikaa';

  @override
  String get teenModeExtensionSubmitted =>
      'Lisäaikapyyntö lähetettiin huoltajalle';

  @override
  String get teenModeTimeLimitReached => 'Tämän päivän käyttöraja on täyttynyt';

  @override
  String get teenModeCurfewActive => 'Käyttöä on rajoitettu tänä ajanjaksona';

  @override
  String get teenModeReliefHint =>
      'Voit silti tarkastella historiaa, ottaa yhteyttä viralliseen tukeen ja ilmoittaa ongelmista.';

  @override
  String get teenModeRestrictedNotice =>
      'Nuorisotila estää tällä hetkellä viestien lähettämisen';

  @override
  String get teenModeActionBlocked =>
      'Nuorisotila estää tällä hetkellä tämän toiminnon';

  @override
  String get teenModeMyRequests => 'Omat pyynnöt';

  @override
  String get guardianCenterTitle => 'Huoltajakeskus';

  @override
  String get guardianRelationships => 'Huoltajasuhteet';

  @override
  String get guardianMinors => 'Valvomani lapset';

  @override
  String get guardianApprovals => 'Odottavat hyväksynnät';

  @override
  String get guardianBind => 'Anna yhdistämiskoodi';

  @override
  String get guardianCreateMinorCode => 'Olen lapsi — luo koodi';

  @override
  String get guardianCreateGuardianCode => 'Olen huoltaja — luo koodi';

  @override
  String get guardianRelation => 'Suhde';

  @override
  String get guardianPrimary => 'Ensisijainen huoltaja';

  @override
  String get guardianCode => 'Kuusinumeroinen yhdistämiskoodi';

  @override
  String get guardianCodeHint => 'Anna toisen osapuolen toimittama koodi';

  @override
  String get guardianCodeCreated => 'Koodi luotu. Jaa se ennen vanhenemista.';

  @override
  String get guardianEmpty => 'Ei huoltajasuhteita';

  @override
  String get guardianNoMinors => 'Ei valvottavia lapsia';

  @override
  String get guardianUnbind => 'Poista suhde';

  @override
  String get guardianExtend => 'Lisää lapselle aikaa';

  @override
  String get guardianPolicyTitle => 'Käyttösäännöt';

  @override
  String get guardianPolicyLocked => 'Alustan lukitsema';

  @override
  String get approvalEmpty => 'Ei pyyntöjä';

  @override
  String get approvalApprove => 'Hyväksyn';

  @override
  String get approvalReject => 'Kieltäydy';

  @override
  String get approvalPending => 'Odottaa';

  @override
  String get approvalApproved => 'Hyväksytty';

  @override
  String get approvalRejected => 'hylätty';

  @override
  String get approvalExpired => 'vanhentunut';

  @override
  String get approvalCancelled => 'Peruttu';

  @override
  String get approvalReplayFailed =>
      'Alkuperäinen toiminto epäonnistui. Yritä sitä uudelleen.';

  @override
  String get requestCancelled => 'Pyyntö peruutettu';

  @override
  String get kycTitle => 'Henkilöllisyyden vahvistus';

  @override
  String get kycNotRequired => 'Henkilöllisyyden vahvistusta ei vaadita';

  @override
  String get kycVerified => 'Henkilöllisyys vahvistettu';

  @override
  String get kycDeclared => 'Henkilöllisyystiedot lähetetty';

  @override
  String get kycPending => 'Tarkistettavana';

  @override
  String get kycRejected => 'Tarkistus hylätty';

  @override
  String get kycNone => 'Henkilöllisyystietoja ei ole lähetetty';

  @override
  String get kycRealName => 'Koko nimi';

  @override
  String get kycIdNumber => 'Tunnistenumero';

  @override
  String get kycIdType => 'Asiakirjan tyyppi';

  @override
  String get kycApplicability =>
      'Anna valitun asiakirjan todelliset tiedot. Hyväksytyt tyypit näkyvät luettelossa.';

  @override
  String get kycCamera => 'Ota kuva';

  @override
  String get kycGallery => 'Valitse albumista';

  @override
  String get kycPhotoLimit => 'Enimmäiskoko kuvaa kohden';

  @override
  String get kycSelectPhoto => 'Valitse kuva';

  @override
  String get kycPhotoSelected => 'Valittu';

  @override
  String get kycViewPhoto => 'Näytä kuva napauttamalla';

  @override
  String get kycReplacePhoto => 'Valitse toinen kuva';

  @override
  String get kycDisclosure =>
      'Käytämme nimeäsi, asiakirjan numeroa ja asiakirjakuvia henkilöllisyytesi tarkistamiseen. Ilman niitä et voi lähettää hakemusta, eivätkä jotkin rajoitetut toiminnot välttämättä ole käytettävissä.';

  @override
  String get kycConsent =>
      'Annan erillisen suostumuksen tähän henkilöllisyystietojen käsittelyyn';

  @override
  String get kycConsentRequired =>
      'Anna erillinen suostumus ennen lähettämistä';

  @override
  String get kycResubmitTitle => 'Lähetä henkilöllisyystiedot uudelleen';

  @override
  String get kycResubmitWarning =>
      'Uusi lähetys korvaa odottavan hakemuksesi. Jatketaanko?';

  @override
  String get kycSubmitting => 'Lähetetään';

  @override
  String get kycSubmitFailed => 'Lähettäminen epäonnistui. Yritä uudelleen.';

  @override
  String get kycSubmitUnavailable =>
      'Henkilöllisyystietoja ei voi lähettää nyt';

  @override
  String get kycResubmitNotAllowed =>
      'Uudelleenlähetys ei ole käytettävissä hylkäyksen jälkeen. Ota tarvittaessa yhteyttä tukeen.';

  @override
  String get kycDailyLimit =>
      'Tämän päivän lähetysraja on täyttynyt. Yritä huomenna.';

  @override
  String get kycTypeUnavailable =>
      'Asiakirjatyyppejä ei ole saatavilla. Yritä myöhemmin uudelleen.';

  @override
  String get kycNameInvalid => 'Virallisessa nimessä on oltava 2–64 merkkiä';

  @override
  String get kycNumberRequired => 'Syötä tunnistenumerosi';

  @override
  String get kycFrontRequired => 'Lähetä asiakirjan etupuoli';

  @override
  String get kycBackRequired => 'Lähetä asiakirjan kääntöpuoli';

  @override
  String get kycPhotoTooLarge =>
      'Kuva ylittää kokorajan. Pakkaa se ja yritä uudelleen.';

  @override
  String get kycAccountChanged =>
      'Tili tai tila vaihtui. Avaa tämä sivu uudelleen.';

  @override
  String get kycPhotoInvalid => 'Valitse kelvollinen kuva';

  @override
  String get kycPortraitSide => 'Kuvapuoli';

  @override
  String get kycEmblemSide => 'Tunnuspuoli';

  @override
  String get kycPassportDataPage => 'Passin tietosivu';

  @override
  String get kycPassportOtherPage => 'Passin viisumi- tai tyhjä sivu';

  @override
  String get kycFront => 'ID:n etupuoli';

  @override
  String get kycBack => 'ID:n takapuoli';

  @override
  String get kycRequired =>
      'Henkilöllisyys on vahvistettava ennen ryhmän luomista';

  @override
  String get kycGoVerify => 'Vahvista nyt';

  @override
  String get kycStatusUnknown =>
      'Henkilöllisyyden tila ei ole saatavilla. Päivitä myöhemmin.';

  @override
  String get kycSuperseded =>
      'Myöhempi lähetys korvasi tämän. Tarkista henkilöllisyytesi uusin tila.';

  @override
  String get kycMediaNotFound =>
      'Asiakirjakuva ei ole käytettävissä tässä tilassa. Valitse se uudelleen ennen lähettämistä.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Asiakkaiden joukkoviestit';

  @override
  String get officialAccountBadge => 'Virallinen';

  @override
  String get officialAccountOpenConversation => 'Avaa keskustelu';

  @override
  String get officialAccountJoinHint =>
      'Tämän tilin lisääminen liittää sinut yritykseen asiakkaana. Ystäväpyynnön hyväksyntää ei tarvita.';

  @override
  String get officialAccountJoinDisabled =>
      'Tämä yritys ei ota uusia asiakkaita. Ota yhteyttä tukeen.';

  @override
  String get officialAccountRemoved =>
      'Sinut poistettiin tästä yrityksestä. Pyydä yritystä kutsumaan sinut uudelleen.';

  @override
  String get officialAccountBanned =>
      'Tilisi on poistettu käytöstä tässä yrityksessä.';

  @override
  String get officialAccountUnavailable =>
      'Tämä virallinen tili ei ole tällä hetkellä käytettävissä.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Yritykseen liittyminen ei ole sallittua nykyisessä tilassa.';

  @override
  String get officialAccountPlatformRequired =>
      'Lisää tämä virallinen tili alustan tilillä.';

  @override
  String get officialAccountOpenFailed =>
      'Keskustelun avaaminen epäonnistui. Yritä uudelleen.';

  @override
  String get officialAccountAccountChanged =>
      'Tili tai tila vaihtui. Avaa uudelleen.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Yrityshakemisto ei ole ajan tasalla. Yritä hetken kuluttua uudelleen.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Virallisen tilin synkronointi epäonnistui. Paikallinen sisältö on edelleen käytettävissä.';

  @override
  String get officialAccountInboxSyncing =>
      'Synkronoidaan virallisen tilin viestejä';

  @override
  String get diagnosticsTitle => 'Diagnostiikka';

  @override
  String get diagnosticsExplanation =>
      'Lokit on anonymisoitu, ja ne sisältävät tämän tilin ja tilan toiminta- ja virhetietoja sekä julkisia käynnistystapahtumia. Keskustelusisältö ja kirjautumistiedot eivät sisälly niihin.';

  @override
  String get diagnosticsHour => 'Viimeinen tunti';

  @override
  String get diagnosticsDay => 'Viimeiset 24 tuntia';

  @override
  String get diagnosticsWeek => '7 pv';

  @override
  String diagnosticsEventCount(int count) {
    return 'Saatavilla olevat tapahtumat: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Lokit tallennetaan tähän laitteeseen, ja ne ovat saatavilla uudelleenkäynnistyksen jälkeen.';

  @override
  String get diagnosticsNotPersistent =>
      'Joitakin lokeja ei tallennettu. Yritä uudelleen päivittämällä.';

  @override
  String get diagnosticsExport => 'Vie ja jaa';

  @override
  String get diagnosticsRefresh => 'Päivitä';

  @override
  String get diagnosticsClear => 'Tyhjennä tämän tilan lokit';

  @override
  String get diagnosticsClearConfirm =>
      'Tyhjennetäänkö tämän tilan diagnostiikkalokit? Keskusteluhistoria säilytetään.';

  @override
  String get diagnosticsShared =>
      'Järjestelmäjako valmis. Tarkista tiedosto vastaanottavassa sovelluksessa.';

  @override
  String get diagnosticsCancelled =>
      'Jakaminen peruutettu. Voit viedä uudelleen.';

  @override
  String get diagnosticsUnconfirmed =>
      'Jakamista ei voitu vahvistaa. Tarkista vastaanottava sovellus.';

  @override
  String get diagnosticsFailed => 'Toiminto epäonnistui. Yritä uudelleen.';
}
