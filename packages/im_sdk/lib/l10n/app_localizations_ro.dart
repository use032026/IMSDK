// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get navWorkbench => 'Spațiu de lucru';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Datele contului nu au putut fi încărcate';

  @override
  String get startupFailureTitle => 'Pornirea a eșuat';

  @override
  String get startupFailureMessage => 'Verificați rețeaua și încercați din nou';

  @override
  String get privacyConsentTitle =>
      'Termeni și condiții & Politica de confidențialitate';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Bun venit în $brand. Pentru autentificare, mesagerie instantanee, colaborare în cadrul companiei, asistență online pentru clienți, notificări despre mesaje și protecție de securitate, trebuie să prelucrăm informațiile necesare conform Condițiilor de utilizare și Politicii de confidențialitate.\n\nÎnainte să atingeți Accept, nu vom citi clipboardul, nu vom inițializa JPush/JCore sau SDK-urile de notificări ale producătorilor și nu vom folosi aceste SDK-uri pentru a accesa Android ID, OAID, listele aplicațiilor instalate, adrese MAC sau informații similare. Dacă refuzați momentan, vom salva alegerea; puteți continua să citiți documentele și să decideți ulterior.\n\nDupă acceptare, pentru notificări despre mesaje, asistență și apeluri primite, JPush/JCore și serviciile de notificări ale producătorilor pot prelucra modelul dispozitivului, versiunea Android, numele pachetului și versiunea aplicației, tipul rețelei, adresa IP, Android ID, OAID, Registration ID pentru notificări, tokenul producătorului și informațiile despre livrarea și deschiderea notificărilor. Am dezactivat funcțiile neesențiale, inclusiv notificările inteligente, listele aplicațiilor instalate, MAC, IMEI, IMSI, listele Wi-Fi, activarea automată și pornirea asociată.\n\nClipboardul este accesat numai când folosiți explicit copierea sau lipirea. Permisiunile pentru cameră, microfon, notificări și alte funcții de sistem sunt solicitate doar când folosiți funcția respectivă. Refuzul unei permisiuni afectează doar funcția aferentă. Citiți documentele complete de mai jos și decideți liber dacă sunteți de acord.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Bun venit în $brand. Pentru autentificare, mesagerie instantanee, colaborare în cadrul companiei, asistență online pentru clienți, notificări despre mesaje și protecție de securitate, trebuie să prelucrăm informațiile necesare conform Condițiilor de utilizare și Politicii de confidențialitate.\n\nÎnainte să atingeți Accept, nu vom citi clipboardul, nu vom inițializa JPush/JCore, nu ne vom înregistra la Apple Push Notification service (APNs) și nu vom obține identificatori precum JPush Registration ID sau tokenul APNs al dispozitivului. Dacă refuzați momentan, vom salva alegerea; puteți continua să citiți documentele și să decideți ulterior.\n\nDupă acceptare, pentru notificări despre mesaje, asistență și apeluri primite, putem prelucra modelul iPhone, versiunea iOS, numele pachetului și versiunea aplicației, tipul rețelei, adresa IP, IDFV, JPush Registration ID, tokenul APNs al dispozitivului și informațiile despre livrarea și deschiderea notificărilor. JPush/JCore conectează serviciul de notificări; Apple APNs prelucrează identificatorul aplicației, tokenul dispozitivului și conținutul notificării pentru livrarea prin sistem. Aplicația iOS actuală nu folosește servicii publicitare și nu obține IDFA.\n\nClipboardul este accesat numai când folosiți explicit copierea sau lipirea. Permisiunile pentru cameră, microfon, notificări și alte funcții de sistem sunt solicitate doar când folosiți funcția respectivă. Refuzul unei permisiuni afectează doar funcția aferentă. Citiți documentele complete de mai jos și decideți liber dacă sunteți de acord.';
  }

  @override
  String get privacyConsentTermsLink => 'Termeni de utilizare';

  @override
  String get privacyConsentConjunction => 'și';

  @override
  String get privacyConsentPrivacyLink => 'Politica de confidențialitate';

  @override
  String get privacyConsentDecline => 'Refuz';

  @override
  String get privacyConsentDeclinedExit =>
      'Nu ați acceptat Condițiile de utilizare și Politica de confidențialitate. Aplicația se va închide.';

  @override
  String get privacyConsentAccept => 'Accept';

  @override
  String get privacyConsentRuntimeFailure =>
      'Pornirea a eșuat. Verificați rețeaua și încercați din nou.';

  @override
  String get privacyConsentSaveFailure =>
      'Alegerea nu a putut fi salvată. Încercați din nou.';

  @override
  String get appUpdateRequiredTitle => 'Actualizare necesară pentru a continua';

  @override
  String get appUpdateOptionalTitle => 'Versiune nouă disponibilă';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Este disponibilă versiunea $brand $version';
  }

  @override
  String get appUpdateLater => 'Mai târziu';

  @override
  String get appUpdateNow => 'Actualizați acum';

  @override
  String get appUpdateProcessing => 'Se procesează...';

  @override
  String get appUpdateInvalidUrl =>
      'Adresa actualizării nu este validă. Încercați mai târziu.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Linkul de actualizare nu a putut fi deschis. Încercați mai târziu.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Descărcarea a fost întreruptă. Verificați rețeaua și încercați din nou.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Verificarea pachetului a eșuat. Descărcați-l din nou.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Permiteți aplicației $brand să instaleze actualizări din setările sistemului.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Programul de instalare al sistemului nu a putut fi deschis. Verificați permisiunile de instalare.';

  @override
  String get appUpdateGenericFailure =>
      'Actualizarea a eșuat. Verificați rețeaua și încercați din nou.';

  @override
  String get appUpdateUnavailable =>
      'Noua versiune nu poate fi încă descărcată. Încercați mai târziu.';

  @override
  String get appUpdateCheckFailed =>
      'Actualizările nu au putut fi verificate. Încercați mai târziu.';

  @override
  String get appUpdateChecking => 'Se verifică';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Anulează';

  @override
  String get commonSave => 'Salvează';

  @override
  String get commonEdit => 'Editează';

  @override
  String get commonDelete => 'Șterge';

  @override
  String get commonSearch => 'Caută';

  @override
  String get commonLoading => 'Se încarcă...';

  @override
  String get commonLoadFailed => 'Încărcare eșuată';

  @override
  String get commonRetry => 'Reîncearcă';

  @override
  String get commonEmpty => 'Fără date';

  @override
  String get commonCopy => 'Copiază';

  @override
  String get commonForward => 'Redirecționează';

  @override
  String get commonFavorite => 'Salvează';

  @override
  String get commonClose => 'Închide';

  @override
  String get commonSend => 'Trimite';

  @override
  String get commonDone => 'Gata';

  @override
  String get commonMore => 'Mai multe';

  @override
  String get commonSettings => 'Setări';

  @override
  String get commonCopied => 'Copiat';

  @override
  String get commonUnknown => 'Necunoscut';

  @override
  String get commonNotSet => 'Nesetat';

  @override
  String get commonUnbound => 'Neconectat';

  @override
  String get commonViewAll => 'Vezi tot';

  @override
  String get commonSubmit => 'Trimite';

  @override
  String get commonAdd => 'Adaugă';

  @override
  String get commonRemove => 'Elimină';

  @override
  String get commonCreate => 'Creează';

  @override
  String get commonUpdate => 'Actualizează';

  @override
  String get commonUpload => 'Încarcă';

  @override
  String get commonShare => 'Partajează';

  @override
  String get commonBlock => 'Blochează';

  @override
  String get commonUnblock => 'Deblochează';

  @override
  String get commonMute => 'Dezactivează sunetul';

  @override
  String get commonUnmute => 'Reactivează sunetul';

  @override
  String get commonPin => 'Fixat';

  @override
  String get commonUnpin => 'Anulează fixarea';

  @override
  String get commonMarkRead => 'Marchează ca citit';

  @override
  String get commonMarkUnread => 'Marchează ca necitit';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Operațiunea a eșuat. Încercați din nou.';

  @override
  String get commonNetworkError => 'Eroare de rețea. Verificați conexiunea.';

  @override
  String get navMessages => 'Mesaje';

  @override
  String get navContacts => 'Contacte';

  @override
  String get navMe => 'Eu';

  @override
  String get authLoginTitle => 'Autentificare în StartLink';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'Email';

  @override
  String get authTabLoginName => 'ID StartLink';

  @override
  String get authHintMobile => 'Introduceți numărul de telefon';

  @override
  String get authHintEmail => 'Introduceți adresa dvs. de email';

  @override
  String get authHintPassword => 'Introduceți parola';

  @override
  String get authHintCode => 'Introduceți codul de verificare';

  @override
  String get authHintLoginName => 'Introduceți ID-ul StartLink (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Autentificare';

  @override
  String get authGetCode => 'Obțineți codul';

  @override
  String authResendCode(int seconds) {
    return 'Retrimite în $seconds s';
  }

  @override
  String get authUsePassword => 'Folosește parola';

  @override
  String get authUseCode => 'Folosește codul de verificare';

  @override
  String get authAgreementPrefix => 'Am citit și sunt de acord cu';

  @override
  String get authAgreementAnd => 'și';

  @override
  String get authTermsLink => 'Termeni de utilizare';

  @override
  String get authPrivacyLink => 'Politica de confidențialitate';

  @override
  String get authCaptchaTitle => 'Verificare de securitate';

  @override
  String get authCaptchaHint => 'Introduceți răspunsul';

  @override
  String get authCaptchaFailed =>
      'Verificarea captcha nu a putut fi obținută. Încercați din nou.';

  @override
  String get authErrorEmptyCode => 'Introduceți codul de verificare';

  @override
  String get authErrorEmptyPassword => 'Introduceți parola';

  @override
  String get authErrorEmptyLoginName => 'Introduceți ID-ul StartLink';

  @override
  String get authErrorWrongCredentials => 'Cont sau parolă incorectă';

  @override
  String get authDeactivatingTitle => 'Dezactivarea contului';

  @override
  String get authDeactivatingContent =>
      'Contul este în perioada de așteptare înaintea dezactivării (7 zile).\n\nPentru anulare, atingeți „Anulează dezactivarea”; pentru a intra în aplicație, atingeți „Continuă”.';

  @override
  String get authContinueUse => 'Continuă';

  @override
  String get authCancelDeactivation => 'Anulează dezactivarea';

  @override
  String get authDeactivationCancelled =>
      'Dezactivarea a fost anulată, contul a fost restabilit';

  @override
  String get authDeactivationCancelFailed =>
      'Anularea a eșuat. Încercați din nou.';

  @override
  String get authLogout => 'Deconectare';

  @override
  String get authLogoutConfirm => 'Sigur doriți să vă deconectați?';

  @override
  String get authSendingCode => 'Se trimite...';

  @override
  String get authCodeSent => 'Cod de verificare trimis';

  @override
  String get authLoginFailed => 'Autentificarea a eșuat. Încercați din nou.';

  @override
  String get authRegisterFailed => 'Înregistrarea a eșuat. Încercați din nou.';

  @override
  String get authEnterpriseCode => 'Codul companiei';

  @override
  String get authEnterpriseCodeHint => 'Introduceți codul companiei';

  @override
  String get authPendingApproval =>
      'Înregistrare reușită. Cererea de alăturare la companie a fost trimisă și așteaptă aprobarea.';

  @override
  String get authNoAccount => 'Nu aveți un cont?';

  @override
  String get authRegisterNow => 'Înregistrează-te acum';

  @override
  String get authCountryPickerTitle => 'Selectați țara/regiunea';

  @override
  String get authCountrySearchHint => 'Caută țara/regiunea';

  @override
  String get authCountryChinaMainland => 'China continentală';

  @override
  String get authCountryHongKong => 'Hong Kong, China';

  @override
  String get authCountryMacau => 'Macao, China';

  @override
  String get authCountryTaiwan => 'Taiwan, China';

  @override
  String get authCountryUnitedStates => 'Statele Unite';

  @override
  String get authCountryUnitedKingdom => 'Regatul Unit';

  @override
  String get authCountryJapan => 'Japonia';

  @override
  String get authCountrySouthKorea => 'Coreea de Sud';

  @override
  String get authCountrySingapore => 'Singapore';

  @override
  String get authCountryMalaysia => 'Malaezia';

  @override
  String get authCountryAustralia => 'Australia';

  @override
  String get authCountryCanada => 'Canada';

  @override
  String get authCountryGermany => 'Germania';

  @override
  String get authCountryFrance => 'Franța';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Thailanda';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonezia';

  @override
  String get authCountryPhilippines => 'Filipine';

  @override
  String get authQuickLoginTitle => 'Autentificare rapidă';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Autentificare în curs. Așteptați.';

  @override
  String get authRoleOwner => 'Proprietar';

  @override
  String get authRoleAdministrator => 'Administrator';

  @override
  String get authRoleCustomerService => 'Asistență clienți';

  @override
  String get authRoleTechnicalSupport => 'Asistență tehnică';

  @override
  String get authRoleEmployee => 'Angajat';

  @override
  String get authRoleMember => 'Membru';

  @override
  String get authRoleEnterpriseCustomer => 'Client al companiei';

  @override
  String get authUnavailablePrefix => 'Indisponibil · ';

  @override
  String get authUnassignedService => 'Niciun agent alocat';

  @override
  String authAssignedService(String staff) {
    return 'Alocat agentului $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Client · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Angajat · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count utilizatori';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Identitate';

  @override
  String get authRegisterTitle => 'Înregistrează-te';

  @override
  String get authNickname => 'Pseudonim';

  @override
  String get authNicknameHint => 'Setați o poreclă';

  @override
  String get authPassword => 'Parolă';

  @override
  String get authPasswordSetHint => 'Setați o parolă (cel puțin 6 caractere)';

  @override
  String get authConfirmPassword => 'Confirmă parola';

  @override
  String get authConfirmPasswordHint => 'Introduceți parola din nou';

  @override
  String get authVerificationCode => 'Cod de verificare';

  @override
  String get authRegisterAndLogin => 'Înregistrează-te și autentifică-te';

  @override
  String get authHaveAccount => 'Aveți deja un cont?';

  @override
  String get authGoLogin => 'Autentificare';

  @override
  String get authEmailVerificationUnavailable =>
      'Verificarea prin e-mail nu este disponibilă. Înregistrați-vă cu numărul de mobil.';

  @override
  String get authSmsVerificationUnavailable =>
      'Verificarea prin SMS nu este disponibilă. Înregistrați-vă cu adresa de e-mail.';

  @override
  String get authSendFailed => 'Trimiterea nu a reușit. Încercați din nou.';

  @override
  String get authErrorEmptyNickname => 'Introduceți o poreclă';

  @override
  String get authErrorInvalidMobile => 'Introduceți un număr de mobil valid';

  @override
  String get authErrorInvalidEmail => 'Introduceți o adresă de e-mail validă';

  @override
  String get authErrorPasswordTooShort =>
      'Parola trebuie să conțină cel puțin 6 caractere';

  @override
  String get authErrorPasswordMismatch => 'Parolele nu corespund';

  @override
  String get authErrorVerificationRequired =>
      'Mai întâi solicitați și introduceți codul de verificare';

  @override
  String get authRegisterErrorTitle => 'Înregistrarea a eșuat';

  @override
  String get authGotIt => 'Am înțeles';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Compania „$code” nu a fost găsită. Verificați codul companiei.';
  }

  @override
  String get authTenantSearchFailed => 'Căutarea a eșuat. Încercați din nou.';

  @override
  String get authInvitationInvalid =>
      'Codul invitației nu este valid. Verificați-l și încercați din nou.';

  @override
  String get authCollapseJoin => 'Ascunde informațiile de alăturare';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Invitație validă: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Companie găsită: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Selectați organizația';

  @override
  String get authNoOrganization => 'Nicio organizație disponibilă';

  @override
  String get authNoOrganizationHint =>
      'Cereți unui administrator să vă invite într-o organizație';

  @override
  String get authPersonalSpace => 'Spațiu personal';

  @override
  String get authPersonalSpaceSubtitle =>
      'Conversații cu prietenii și favorite personale';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Identitatea spațiului nu a putut fi verificată. Încercați din nou.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Spațiul personal nu a putut fi restabilit. Încercați din nou.';

  @override
  String get authJoinEnterpriseFailed =>
      'Alăturarea la companie nu a reușit. Încercați mai târziu.';

  @override
  String get homeTitle => 'Mesaje';

  @override
  String get homeGatewayConnectingTitle => 'Se conectează';

  @override
  String get homePersonalSpace => 'Personal';

  @override
  String get homeOfficialService => 'Asistență oficială';

  @override
  String get homeSwitchSpace => 'Schimbă spațiul';

  @override
  String get homeSpaceSubtitle => 'Personal · Companie';

  @override
  String get homeJoinEnterprise => 'Alătură-te companiei';

  @override
  String get homeCreateGroup => 'Grup nou';

  @override
  String get homeAddFriend => 'Adaugă contact';

  @override
  String get homeScan => 'Scanează';

  @override
  String get homeJoinNewSpace => 'Alătură-te unui spațiu nou';

  @override
  String get homeSearchConversation => 'Caută';

  @override
  String get homeNoMessages => 'Nu există mesaje';

  @override
  String get homeDeleteConversation => 'Șterge conversația';

  @override
  String get homeDeleteConversationConfirm =>
      'Ștergeți această conversație? Istoricul va fi șters.';

  @override
  String get homePersonalNote => 'Eu (note personale)';

  @override
  String get homeWorkNote => 'Eu (note de serviciu)';

  @override
  String homeConversationCount(int count) {
    return '$count conversații';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count necitite';
  }

  @override
  String get chatInputHint => 'Scrieți un mesaj...';

  @override
  String get chatVoiceHint => 'Țineți apăsat pentru a vorbi';

  @override
  String get chatVoiceRelease => 'Eliberați pentru a trimite';

  @override
  String get chatVoiceCancel => 'Glisați în sus pentru anulare';

  @override
  String get chatMenuCopy => 'Copiază';

  @override
  String get chatMenuForward => 'Redirecționează';

  @override
  String get chatMenuRecall => 'Retrage mesajul';

  @override
  String get chatMenuDelete => 'Șterge';

  @override
  String get chatMenuFavorite => 'Salvează';

  @override
  String get chatMenuReply => 'Răspunde';

  @override
  String get chatMenuMultiSelect => 'Selectează';

  @override
  String get chatMenuTranslate => 'Tradu';

  @override
  String get chatMenuVoiceToText => 'Convertește în text';

  @override
  String get chatMenuTextToSpeech => 'Citește cu voce tare';

  @override
  String get chatStatusRecalled => 'Mesaj retras';

  @override
  String get chatRecallSuccess => 'Retras';

  @override
  String get chatRecallFailed => 'Retragerea a eșuat';

  @override
  String get chatRecallTimeout =>
      'Mesajele mai vechi de 2 minute nu pot fi retrase';

  @override
  String get chatTranslateFailed => 'Traducerea a eșuat. Încercați din nou.';

  @override
  String get chatTranslateNotConfigured =>
      'Serviciul de traducere nu este disponibil';

  @override
  String get chatVoiceToTextFailed => 'Conversia a eșuat. Încercați din nou.';

  @override
  String get chatTextToSpeechFailed =>
      'Citirea cu voce tare a eșuat. Încercați din nou.';

  @override
  String get chatVoiceToText => 'Convertește';

  @override
  String get chatForwardSuccess => 'Redirecționat';

  @override
  String get chatForwardFailed => 'Redirecționarea a eșuat. Încercați din nou.';

  @override
  String get chatNoConversations => 'Nicio conversație pentru redirecționare';

  @override
  String get chatSendFailed => 'Trimiterea a eșuat';

  @override
  String get chatResend => 'Retrimite';

  @override
  String get chatNotFriend => 'Nu este în lista de contacte';

  @override
  String get chatNotFriendHint =>
      'Încă nu sunteți contacte. Nu puteți trimite mesaje.';

  @override
  String get chatMutedHint => 'Toți membrii au restricție de scriere';

  @override
  String get chatFileUploadFailed =>
      'Încărcarea fișierului a eșuat. Încercați din nou.';

  @override
  String get chatFileStatusNotDownloaded => 'Nedescărcat';

  @override
  String get chatFileStatusDownloaded => 'Descărcat';

  @override
  String get chatFileStatusUploading => 'Se încarcă';

  @override
  String get chatFileStatusUploadFailed => 'Încărcare eșuată';

  @override
  String get chatCardSendFailed => 'Trimiterea cărții de contact a eșuat';

  @override
  String get chatFavoriteSuccess => 'Salvat';

  @override
  String get chatFavoriteFailed => 'Adăugarea la favorite a eșuat';

  @override
  String get chatLoadFailed => 'Încărcare eșuată';

  @override
  String get chatImageMessage => '[Imagine]';

  @override
  String get chatVoiceMessage => '[Mesaj vocal]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Fișier]';

  @override
  String get chatLocationMessage => '[Locație]';

  @override
  String get chatContactCardMessage => '[Contact]';

  @override
  String get chatCallLogMessage => '[Apel]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Citit de $count';
  }

  @override
  String get chatUnread => 'Necitit';

  @override
  String get chatRecalledSelf => 'Ați retras un mesaj';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender a retras un mesaj';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Traducere: $translation';
  }

  @override
  String get chatMessageDeleted => 'Mesaj șters';

  @override
  String get chatPeer => 'Altele';

  @override
  String get chatSelf => 'Eu';

  @override
  String get chatGenericMessage => '[Mesaj]';

  @override
  String get chatVoiceHideText => 'Ascunde textul';

  @override
  String get chatVoiceShowText => 'Convertește în text';

  @override
  String get chatFileDefaultName => 'Fișier';

  @override
  String get chatContactDefaultName => 'Contact';

  @override
  String get chatContactCardTitle => 'Carte de contact';

  @override
  String get chatCallMissed => 'Pierdut';

  @override
  String get chatCallCancelled => 'Anulat';

  @override
  String get chatCallRejected => 'Refuzat';

  @override
  String get chatCallDisconnected => 'Deconectat';

  @override
  String get chatCallEnded => 'Apel încheiat';

  @override
  String get chatCallFailed => 'Apel eșuat';

  @override
  String chatCallDuration(String duration) {
    return 'Durată $duration';
  }

  @override
  String get chatVideoCallTitle => 'Apel video';

  @override
  String get chatVoiceCallTitle => 'Apel vocal';

  @override
  String get chatToolPhotos => 'Fotografii';

  @override
  String get chatToolCamera => 'Cameră';

  @override
  String get chatToolFile => 'Fișier';

  @override
  String get chatToolLocation => 'Locație';

  @override
  String get chatToolContactCard => 'Contact';

  @override
  String get chatToolVoiceCall => 'Apel vocal';

  @override
  String get chatToolVideoCall => 'Apel video';

  @override
  String get chatToolFavorites => 'Favorite';

  @override
  String get chatToolTranslate => 'Tradu';

  @override
  String get chatTranslationChooseLanguage => 'Alegeți limba traducerii';

  @override
  String get chatTranslationEnterText => 'Introduceți mai întâi textul';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Traducerea nu este disponibilă pentru mesaje cu mențiuni';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Traducerea nu este disponibilă la editarea unui mesaj programat';

  @override
  String get chatTranslationFailed => 'Traducerea a eșuat. Încercați din nou.';

  @override
  String get chatTranslationEmpty =>
      'Nu s-a returnat nicio traducere. Încercați din nou.';

  @override
  String get chatTranslationTranslating => 'Se traduce…';

  @override
  String get chatTranslationSend => 'Trimite traducerea';

  @override
  String get chatTranslationSending => 'Se trimite…';

  @override
  String get chatTranslationExpand => 'Arată mai mult';

  @override
  String get chatTranslationCollapse => 'Arată mai puțin';

  @override
  String get chatFileTooLarge => 'Fișierul depășește limita (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Doar proprietarul sau membrii selectați pot scrie.';

  @override
  String get chatImageUploadUnsupported =>
      'Încărcarea imaginii a eșuat. Serverul nu oferă încă suport.';

  @override
  String get chatFavoriteLongPressHint =>
      'Țineți apăsat un mesaj pentru a-l adăuga la favorite';

  @override
  String chatSelectedCount(int count) {
    return '$count selectate';
  }

  @override
  String get chatLocationSheetTitle => 'Trimite locația';

  @override
  String get chatLocationNameLabel => 'Numele locului';

  @override
  String get chatLocationNameHint => 'de ex. birou, adresa clientului';

  @override
  String get chatLocationAddressLabel => 'Adresă';

  @override
  String get chatLocationOptionalHint => 'Opțional';

  @override
  String get chatLocationLatitudeLabel => 'Latitudine';

  @override
  String get chatLocationLatitudeHint => '-90 până la 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitudine';

  @override
  String get chatLocationLongitudeHint => '-180 până la 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Introduceți $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label este în afara intervalului';
  }

  @override
  String get chatLocationDefaultTitle => 'Locație';

  @override
  String get chatMutedFullNotice =>
      'Acest grup are restricție de scriere. Doar proprietarul sau membrii selectați pot scrie.';

  @override
  String get chatNotFriendSendBlocked =>
      'Nu mai sunteți prieteni și nu puteți trimite mesaje';

  @override
  String get chatPersonalNotesTitle => 'Note personale';

  @override
  String get chatWorkNotesTitle => 'Note de serviciu';

  @override
  String get chatPersonalNotesDescription =>
      'Notați gânduri personale și salvați informații importante aici\nSincronizate între dispozitive pentru acces oricând';

  @override
  String get chatWorkNotesDescription =>
      'Notați sarcini și salvați materiale de serviciu aici\nSpațiile echipei rămân separate și sigure';

  @override
  String get chatNoMessages => 'Nu există mesaje';

  @override
  String chatReplyTo(String sender) {
    return 'Răspunde lui $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature va fi disponibilă în curând';
  }

  @override
  String get chatForwardSelectTitle => 'Alegeți conversația';

  @override
  String get chatContactSelectTitle => 'Alegeți contactul';

  @override
  String get chatNoContacts => 'Niciun contact';

  @override
  String get contactsTitle => 'Contacte';

  @override
  String get contactsSearch => 'Caută contacte';

  @override
  String get contactsNewFriends => 'Prieteni noi';

  @override
  String get contactsGroups => 'Grupuri';

  @override
  String get contactsFavorites => 'Favorite';

  @override
  String get contactsRecent => 'Recente';

  @override
  String get contactsOrganization => 'Organizație';

  @override
  String get contactsAnnouncement => 'Anunțuri';

  @override
  String get contactsNewApplications => 'Cereri noi';

  @override
  String get contactsCustomerGroups => 'Grupuri de clienți';

  @override
  String get contactsAllCustomers => 'Toți clienții';

  @override
  String get contactsMyCustomers => 'Clienții mei';

  @override
  String get contactsViewAll => 'Vezi tot';

  @override
  String get contactsMyContacts => 'Contactele mele';

  @override
  String get contactsMyAdvisor => 'Consilierul meu';

  @override
  String get contactsNoAdvisor => 'Niciun consilier alocat încă';

  @override
  String get contactsAdvisorLoading => 'Se încarcă...';

  @override
  String get contactsNavigateFailed => 'Navigarea a eșuat. Încercați din nou.';

  @override
  String get contactsEmpty => 'Niciun contact';

  @override
  String get contactsNoAnnouncement => 'Niciun anunț';

  @override
  String get contactsOfficialBadge => 'Oficial';

  @override
  String get contactsCustomerBadge => 'Client';

  @override
  String get contactsEmptyCustomers => 'Niciun client';

  @override
  String get myTitle => 'Eu';

  @override
  String get myEnterpriseInfo => 'Informațiile companiei';

  @override
  String get myEnterpriseManage => 'Administrarea companiei';

  @override
  String get myQrCode => 'Cod QR';

  @override
  String get myFavorites => 'Favorite';

  @override
  String get myLanguage => 'Limbă';

  @override
  String get myTimezone => 'Fus orar';

  @override
  String get myAutoTranslate => 'Traducere automată';

  @override
  String get myNetworkSwitch => 'Schimbă linia';

  @override
  String get mySettings => 'Setări';

  @override
  String get myLogout => 'Deconectare';

  @override
  String get myLogoutConfirm => 'Sigur doriți să vă deconectați?';

  @override
  String get myLeaveEnterprise => 'Părăsește compania';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Sigur doriți să părăsiți această companie? Veți pierde accesul la datele companiei.';

  @override
  String get myLeaveEnterpriseSuccess => 'Ați părăsit compania';

  @override
  String get myLeaveEnterpriseFailed => 'Părăsirea a eșuat. Încercați din nou.';

  @override
  String get myLppIdCopied => 'ID-ul StartLink a fost copiat';

  @override
  String myLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count contacte';
  }

  @override
  String get myAutoSelect => 'Automat';

  @override
  String get myPresenceStatus => 'Disponibilitate';

  @override
  String get myPresenceStatusTitle => 'Setează disponibilitatea';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Ocupat';

  @override
  String get myPresenceAway => 'Plecat';

  @override
  String get myPresenceInvisible => 'Invizibil';

  @override
  String get profileTitle => 'Profilul meu';

  @override
  String get profileName => 'Nume';

  @override
  String get profileGender => 'Sex';

  @override
  String get profileBirthday => 'Zi de naștere';

  @override
  String get profileRegion => 'Regiune';

  @override
  String get profileSignature => 'Despre mine';

  @override
  String get profileSignatureHint => 'Spuneți ceva despre dvs.';

  @override
  String get profileTapTapText => 'Atingere';

  @override
  String get profileTapTapHint =>
      'Text afișat la atingere (maxim 20 de caractere)';

  @override
  String get profileAccountSection => 'Cont';

  @override
  String get profileBasicSection => 'Informații de bază';

  @override
  String get profileLppId => 'ID StartLink';

  @override
  String get profileLppIdNotSet => 'Nesetat';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Neconectat';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailUnbound => 'Neconectat';

  @override
  String get profileQrCode => 'Codul meu QR';

  @override
  String get profileChangePassword => 'Schimbă parola';

  @override
  String get profileGenderMale => 'Masculin';

  @override
  String get profileGenderFemale => 'Feminin';

  @override
  String get profileGenderOther => 'Altele';

  @override
  String get profileGenderUnset => 'Nesetat';

  @override
  String get profileSaveFailed => 'Salvarea a eșuat. Încercați din nou.';

  @override
  String get profileLppIdTitle => 'ID StartLink';

  @override
  String get profileLppIdSetOnce =>
      'ID-ul StartLink poate fi schimbat o singură dată. Alegeți cu atenție.';

  @override
  String get profileLppIdChangeFailed =>
      'Schimbarea a eșuat (ID-ul StartLink poate fi schimbat o singură dată)';

  @override
  String get profileChangePasswordOld => 'Parola actuală';

  @override
  String get profileChangePasswordNew => 'Parola nouă';

  @override
  String get profileChangePasswordConfirm => 'Confirmă parola nouă';

  @override
  String get profileChangePasswordMismatch => 'Parolele nu corespund';

  @override
  String get profileChangePasswordSuccess =>
      'Parola a fost schimbată. Autentificați-vă din nou.';

  @override
  String get profileChangePasswordFailed =>
      'Schimbarea parolei a eșuat. Încercați din nou.';

  @override
  String get settingsTitle => 'Setări';

  @override
  String get settingsSectionEnterprise => 'Companie';

  @override
  String get settingsSectionAccount => 'Cont';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionFeatures => 'Funcții';

  @override
  String get settingsSectionAbout => 'Despre';

  @override
  String get settingsEnterpriseInfo => 'Informațiile companiei';

  @override
  String get settingsProfile => 'Profilul meu';

  @override
  String get settingsAccountSecurity => 'Securitatea contului';

  @override
  String get settingsNotification => 'Notificări';

  @override
  String get settingsDisplay => 'Afișare';

  @override
  String get settingsFriendPrivacy => 'Confidențialitate';

  @override
  String get settingsChat => 'Conversație';

  @override
  String get settingsChatHistory => 'Istoricul conversațiilor';

  @override
  String get settingsAbout => 'Despre StartLink';

  @override
  String get settingsLanguage => 'Limbă';

  @override
  String get settingsTimezone => 'Fus orar';

  @override
  String get settingsAutoTranslate => 'Traducere automată';

  @override
  String get settingsNetworkSwitch => 'Schimbă linia';

  @override
  String get enterpriseInfoTitle => 'Informațiile companiei';

  @override
  String get enterpriseName => 'Nume';

  @override
  String get enterpriseDescription => 'Descriere';

  @override
  String get enterpriseUpdateSuccess => 'Actualizat cu succes';

  @override
  String get enterpriseUpdateFailed =>
      'Actualizarea a eșuat. Încercați din nou.';

  @override
  String get enterpriseLeave => 'Părăsește compania';

  @override
  String get enterpriseLeaveConfirm =>
      'Sigur doriți să părăsiți această companie?';

  @override
  String get enterpriseLeaveSuccess => 'Ați părăsit compania';

  @override
  String get enterpriseLeaveFailed => 'Părăsirea a eșuat. Încercați din nou.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Proprietarul nu poate părăsi direct compania. Transferați mai întâi proprietatea.';

  @override
  String get enterpriseMemberCount => 'Membri';

  @override
  String get enterpriseCreatedAt => 'Creat';

  @override
  String get enterpriseCode => 'Codul companiei';

  @override
  String get enterpriseInviteMembers => 'Invită membri';

  @override
  String get enterpriseCopyInviteCode => 'Copiază codul invitației';

  @override
  String get enterpriseInviteCodeCopied => 'Codul invitației a fost copiat';

  @override
  String get groupCreateTitle => 'Grup nou';

  @override
  String get groupNameHint => 'Introduceți numele grupului';

  @override
  String get groupCreateSuccess => 'Grup creat';

  @override
  String get groupCreateFailed => 'Crearea grupului a eșuat';

  @override
  String get groupSettings => 'Setările grupului';

  @override
  String get groupName => 'Numele grupului';

  @override
  String get groupAvatar => 'Avatarul grupului';

  @override
  String get groupAnnouncement => 'Anunț';

  @override
  String get groupMembers => 'Membri';

  @override
  String get groupAddMember => 'Adaugă membri';

  @override
  String get groupRemoveMember => 'Elimină membrul';

  @override
  String get groupRemoveMemberConfirm => 'Eliminați acest membru?';

  @override
  String get groupSetAdmin => 'Numește administrator';

  @override
  String get groupRemoveAdmin => 'Retrage rolul de administrator';

  @override
  String get groupTransferOwner => 'Transferă proprietatea';

  @override
  String get groupTransferOwnerConfirm =>
      'Transferați proprietatea grupului acestui membru?';

  @override
  String get groupTransferOwnerSuccess => 'Proprietate transferată';

  @override
  String get groupTransferOwnerFailed =>
      'Transferul a eșuat. Încercați din nou.';

  @override
  String get groupLeave => 'Părăsește grupul';

  @override
  String get groupLeaveConfirm => 'Părăsiți acest grup?';

  @override
  String get groupLeaveSuccess => 'Ați părăsit grupul';

  @override
  String get groupLeaveFailed => 'Părăsirea a eșuat. Încercați din nou.';

  @override
  String get groupDissolve => 'Dizolvă grupul';

  @override
  String get groupDissolveConfirm =>
      'Dizolvați acest grup? Toți membrii vor fi eliminați.';

  @override
  String get groupDissolveSuccess => 'Grup dizolvat';

  @override
  String get groupDissolveFailed => 'Dizolvarea a eșuat. Încercați din nou.';

  @override
  String get groupQrCode => 'Codul QR al grupului';

  @override
  String get groupMuteAll => 'Restricționează scrierea pentru toți';

  @override
  String get groupMuteAllOn => 'Activează restricția de scriere pentru toți';

  @override
  String get groupMuteAllOff =>
      'Dezactivează restricția de scriere pentru toți';

  @override
  String get groupAllowMemberInvite =>
      'Permite membrilor să invite alte persoane';

  @override
  String get groupAllowMemberModifyTitle =>
      'Permite membrilor să schimbe numele grupului';

  @override
  String get groupAllowMemberAtAll =>
      'Permite membrilor să menționeze pe toată lumea';

  @override
  String get groupAllowMemberViewMemberList =>
      'Permite membrilor să vadă lista membrilor';

  @override
  String get groupAllowQrCodeJoin => 'Permite alăturarea prin cod QR';

  @override
  String get groupRequireApproval => 'Solicită aprobare pentru alăturare';

  @override
  String get groupAllowMemberAddFriend =>
      'Permite membrilor să se adauge reciproc';

  @override
  String get groupRoleOwner => 'Proprietar';

  @override
  String get groupRoleAdmin => 'Administrator';

  @override
  String get groupRoleMember => 'Membru';

  @override
  String get groupNoMembers => 'Niciun membru';

  @override
  String get groupNoAnnouncements => 'Niciun anunț';

  @override
  String get groupCreateAnnouncement => 'Publică anunțul';

  @override
  String get groupEditAnnouncement => 'Editează anunțul';

  @override
  String get groupDeleteAnnouncement => 'Șterge anunțul';

  @override
  String get groupDeleteAnnouncementConfirm => 'Ștergeți acest anunț?';

  @override
  String get groupAnnouncementTitle => 'Titlu';

  @override
  String get groupAnnouncementContent => 'Conținut';

  @override
  String get groupAnnouncementPin => 'Fixează anunțul';

  @override
  String groupMemberCount(int count) {
    return '$count membri';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count selectate';
  }

  @override
  String get groupJoinRequestApprove => 'Accept';

  @override
  String get groupJoinRequestReject => 'Refuză';

  @override
  String get groupJoinRequests => 'Cereri de alăturare';

  @override
  String get groupNoJoinRequests => 'Nicio cerere de alăturare';

  @override
  String get groupReadReceipts => 'Confirmări de citire';

  @override
  String groupReadCount(int count) {
    return '$count citite';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count necitite';
  }

  @override
  String get friendAddTitle => 'Adaugă contact';

  @override
  String get friendSearchHint => 'Telefon / e-mail / ID StartLink';

  @override
  String get friendRequestSent => 'Cerere de prietenie trimisă';

  @override
  String get friendRequestFailed => 'Trimiterea a eșuat. Încercați din nou.';

  @override
  String get friendAlreadyFriend => 'Sunteți deja contacte';

  @override
  String get friendNewFriendsTitle => 'Prieteni noi';

  @override
  String get friendNoRequests => 'Nicio cerere de prietenie';

  @override
  String get friendAccept => 'Acceptă';

  @override
  String get friendReject => 'Refuză';

  @override
  String get friendAccepted => 'Acceptat';

  @override
  String get friendRejected => 'Respingat';

  @override
  String get friendDeleteConfirm => 'Eliminați acest contact?';

  @override
  String get friendDeleteSuccess => 'Contact eliminat';

  @override
  String get friendDeleteFailed => 'Eliminarea a eșuat. Încercați din nou.';

  @override
  String get friendRemarkName => 'Poreclă';

  @override
  String get friendGroupName => 'Grup';

  @override
  String get friendSendMessage => 'Mesaj';

  @override
  String get friendMatchTypeLppId => 'Găsit după ID-ul StartLink';

  @override
  String get friendMatchTypeMobile => 'Găsit după telefon';

  @override
  String get friendMatchTypeEmail => 'Găsit după e-mail';

  @override
  String get friendSearchEmpty => 'Niciun utilizator găsit';

  @override
  String get friendAddMessage => 'Aș dori să vă adaug ca persoană de contact';

  @override
  String get friendBlockConfirm => 'Blocați acest utilizator?';

  @override
  String get friendUnblockConfirm => 'Deblocați acest utilizator?';

  @override
  String get friendBlockSuccess => 'Blocat';

  @override
  String get friendUnblockSuccess => 'Deblocat';

  @override
  String get profilePageTitle => 'Informații personale';

  @override
  String get profilePageSendMessage => 'Mesaj';

  @override
  String get profilePageAddFriend => 'Adaugă prieten';

  @override
  String get profilePageAlreadyFriend => 'Sunteți deja prieteni';

  @override
  String get profilePageBlocked => 'Blocat';

  @override
  String get profilePageBlock => 'Blochează';

  @override
  String get profilePageUnblock => 'Deblochează';

  @override
  String get profilePageHidden => 'Acest utilizator și-a ascuns profilul';

  @override
  String get profilePageFriendsOnly =>
      'Acest utilizator își arată profilul doar prietenilor';

  @override
  String get profilePageLppId => 'ID StartLink';

  @override
  String get profilePageRemarkName => 'Observații';

  @override
  String get profilePageEditRemark => 'Editează porecla';

  @override
  String get profilePageSaveRemarkSuccess => 'Poreclă salvată';

  @override
  String get profilePageSaveRemarkFailed =>
      'Salvarea a eșuat. Încercați din nou.';

  @override
  String get searchTitle => 'Caută';

  @override
  String get searchHint => 'Caută după telefon, e-mail sau ID StartLink';

  @override
  String get searchNoResults => 'Niciun rezultat';

  @override
  String get searchMessages => 'Mesaje';

  @override
  String get searchUsers => 'Utilizatori';

  @override
  String get searchFailed => 'Căutarea a eșuat. Încercați din nou.';

  @override
  String get scanTitle => 'Scanează';

  @override
  String get scanFailed => 'Recunoașterea a eșuat. Încercați din nou.';

  @override
  String get scanInvalidQrCode => 'Cod QR invalid';

  @override
  String get scanFlashOn => 'Aprinde lanterna';

  @override
  String get scanFlashOff => 'Stinge lanterna';

  @override
  String get scanAlbum => 'Alege din album';

  @override
  String get favoritesTitle => 'Favorite';

  @override
  String get favoritesEmpty => 'Nimic salvat încă';

  @override
  String get favoritesAll => 'Toate';

  @override
  String get favoritesText => 'Text';

  @override
  String get favoritesImage => 'Imagini';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Mesaje vocale';

  @override
  String get favoritesFile => 'Fișiere';

  @override
  String get favoritesOther => 'Altele';

  @override
  String get favoritesDeleteConfirm => 'Eliminați din favorite?';

  @override
  String get favoritesDeleteSuccess => 'Eliminat din salvări';

  @override
  String get favoritesDeleteFailed => 'Eliminarea a eșuat';

  @override
  String get favoritesOriginalRecalled => 'Mesaj retras';

  @override
  String get favoritesViewOriginal => 'Vezi originalul';

  @override
  String get favoritesSearchHint => 'Caută în favorite';

  @override
  String get favoritesNoResults => 'Nicio favorită corespunzătoare';

  @override
  String get noticeTitle => 'Anunțuri';

  @override
  String get noticeEmpty => 'Niciun anunț';

  @override
  String get noticeDetail => 'Detaliile anunțului';

  @override
  String get noticePublishedAt => 'Publicat';

  @override
  String get noticePriorityNormal => 'normal';

  @override
  String get noticePriorityImportant => 'Important';

  @override
  String get noticePriorityUrgent => 'Urgent';

  @override
  String get organizationTitle => 'Organizație';

  @override
  String get organizationEmpty => 'Nicio informație despre departament';

  @override
  String get organizationMembers => 'Membri';

  @override
  String get organizationDepartment => 'Departament';

  @override
  String get organizationPosition => 'Funcție';

  @override
  String get organizationLeader => 'Coordonator';

  @override
  String get qrCodeTitle => 'Codul meu QR';

  @override
  String get qrCodeSave => 'Salvați în album';

  @override
  String get qrCodeShare => 'Partajează';

  @override
  String get qrCodeSaveSuccess => 'Salvat în album';

  @override
  String get qrCodeSaveFailed => 'Salvarea a eșuat. Încercați din nou.';

  @override
  String get qrCodeRefresh => 'Reîmprospătează codul QR';

  @override
  String get qrCodeExpired => 'Codul QR a expirat. Reîmprospătați-l.';

  @override
  String get qrCodeScanToAdd => 'Scanați pentru a mă adăuga în contacte';

  @override
  String get spacePersonal => 'Personal';

  @override
  String get spaceEnterprise => 'Companie';

  @override
  String get spaceJoinByCode => 'Alătură-te cu codul companiei';

  @override
  String get spaceJoinByInvite => 'Alătură-te cu codul invitației';

  @override
  String get spaceEnterCode => 'Introduceți codul companiei';

  @override
  String get spaceEnterInviteCode => 'Introduceți codul invitației';

  @override
  String get spaceSearchEnterprise => 'Caută compania';

  @override
  String get spaceJoinRequestSent => 'Cerere trimisă, în așteptarea aprobării';

  @override
  String get spaceJoinRequestPending => 'Aprobare în așteptare';

  @override
  String get spaceJoinRequestApproved => 'Cerere aprobată';

  @override
  String get spaceJoinRequestRejected => 'Cerere respinsă';

  @override
  String get spaceAlreadyMember => 'Sunteți deja membru';

  @override
  String get spaceAutoApproved => 'Aprobat automat. Bun venit!';

  @override
  String get spacePendingApprovalHint =>
      'Înregistrare reușită. Cererea de alăturare a fost trimisă.';

  @override
  String get spaceNoSpaces => 'Niciun spațiu';

  @override
  String get spaceInviteExpired => 'Codul invitației a expirat';

  @override
  String get spaceInviteTargetMismatch =>
      'Acest cod de invitație nu este pentru contul dvs.';

  @override
  String get spaceAcceptInviteSuccess => 'V-ați alăturat cu succes companiei';

  @override
  String get spaceAcceptInviteFailed =>
      'Alăturarea a eșuat. Încercați din nou.';

  @override
  String get spaceTenantSelectTitle => 'Selectați spațiul';

  @override
  String get spaceTenantSelectHint => 'Alegeți un spațiu pentru a intra';

  @override
  String get spaceEnterPersonal => 'Intră în spațiul personal';

  @override
  String get spaceEnterEnterprise => 'Intră în spațiul companiei';

  @override
  String get aboutTitle => 'Despre StartLink';

  @override
  String get aboutVersion => 'Versiune';

  @override
  String get aboutTerms => 'Acordul Utilizatorului';

  @override
  String get aboutPrivacy => 'Politica de Confidențialitate';

  @override
  String get aboutOpenSource => 'Licențe cu sursă deschisă';

  @override
  String get aboutCheckUpdate => 'Caută actualizări';

  @override
  String get aboutLatestVersion => 'Utilizați cea mai recentă versiune.';

  @override
  String get aboutUpdateAvailable => 'Versiune nouă disponibilă';

  @override
  String get aboutUpdateNow => 'Actualizați acum';

  @override
  String get aboutUpdateLater => 'Mai târziu';

  @override
  String get notificationTitle => 'Notificări';

  @override
  String get notificationGlobalMute => 'Nu deranja';

  @override
  String get notificationSound => 'Sunet';

  @override
  String get notificationVibration => 'Vibrație';

  @override
  String get notificationPreview => 'Previzualizarea mesajelor';

  @override
  String get notificationDndStart => 'Ora de început pentru Nu deranja';

  @override
  String get notificationDndEnd => 'Ora de sfârșit pentru Nu deranja';

  @override
  String get blacklistTitle => 'Pe listă neagră';

  @override
  String get blacklistEmpty => 'Niciun utilizator blocat';

  @override
  String get blacklistRemove => 'Deblochează';

  @override
  String get blacklistRemoveConfirm => 'Deblocați acest utilizator?';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackTypeComplaint => 'Reclamație';

  @override
  String get feedbackTypeSuggestion => 'Sugestie';

  @override
  String get feedbackTypeBug => 'Raport de eroare';

  @override
  String get feedbackContent => 'Descriere';

  @override
  String get feedbackContentHint =>
      'Descrieți în detaliu problema sau sugestia';

  @override
  String get feedbackContact => 'Contact (opțional)';

  @override
  String get feedbackSubmit => 'Trimite';

  @override
  String get feedbackSuccess => 'Feedback trimis. Vă mulțumim!';

  @override
  String get feedbackFailed => 'Trimiterea a eșuat. Încercați din nou.';

  @override
  String get networkTitle => 'Schimbă linia';

  @override
  String get networkAutoSelect => 'Automat';

  @override
  String get networkManual => 'Manual';

  @override
  String get timezoneTitle => 'Fus orar';

  @override
  String get timezoneAuto => 'Urmează sistemul';

  @override
  String get autoTranslateTitle => 'Traducere automată';

  @override
  String get autoTranslateEnabled => 'Activează traducerea automată';

  @override
  String get autoTranslateLanguage => 'Limba țintă';

  @override
  String get displayTitle => 'Afișare';

  @override
  String get displayFontSize => 'Dimensiunea fontului';

  @override
  String get displayChatBackground => 'Fundalul conversației';

  @override
  String get displayDarkMode => 'Aspect';

  @override
  String get displayDarkModeSystem => 'Urmează sistemul';

  @override
  String get displayDarkModeSystemHint =>
      'Schimbă automat în funcție de setarea sistemului';

  @override
  String get displayDarkModeOff => 'Luminos';

  @override
  String get displayDarkModeOffHint => 'Folosește întotdeauna tema luminoasă';

  @override
  String get displayDarkModeOn => 'Întunecat';

  @override
  String get displayDarkModeOnHint => 'Folosește întotdeauna tema întunecată';

  @override
  String get chatSettingsTitle => 'Conversație';

  @override
  String get chatHistoryTitle => 'Istoricul conversațiilor';

  @override
  String get chatHistoryClear => 'Șterge tot istoricul';

  @override
  String get chatHistoryClearConfirm =>
      'Ștergeți tot istoricul conversațiilor? Această acțiune nu poate fi anulată.';

  @override
  String get chatHistoryClearSuccess => 'Istoricul conversațiilor a fost șters';

  @override
  String get accountSecurityTitle => 'Securitatea contului';

  @override
  String get accountSecurityChangePassword => 'Schimbă parola';

  @override
  String get accountSecurityChangeMobile => 'Schimbă numărul de telefon';

  @override
  String get accountSecurityChangeEmail => 'Schimbă e-mailul';

  @override
  String get accountSecurityLoggedDevices => 'Dispozitive autentificate';

  @override
  String get accountSecurityDeactivate => 'Dezactivează contul';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Toate datele vor fi șterse definitiv după 7 zile. Dezactivați?';

  @override
  String get loggedDevicesTitle => 'Dispozitive autentificate';

  @override
  String get loggedDevicesCurrent => 'Acest dispozitiv';

  @override
  String get loggedDevicesRevoke => 'Deconectare';

  @override
  String get loggedDevicesRevokeConfirm =>
      'Vă deconectați de pe acest dispozitiv?';

  @override
  String get loggedDevicesRevokeSuccess => 'Deconectat de pe dispozitiv';

  @override
  String get loggedDevicesRevokeFailed => 'A eșuat. Încercați din nou.';

  @override
  String get loggedDevicesLastActive => 'Ultima activitate';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Calculator';

  @override
  String get loggedDevicesTypeUnknown => 'Dispozitiv necunoscut';

  @override
  String get privacySettingsTitle => 'Confidențialitate';

  @override
  String get privacySearchableByMobile =>
      'Permite căutarea după numărul de telefon';

  @override
  String get privacySearchableByLppId =>
      'Permite căutarea după ID-ul StartLink';

  @override
  String get privacyAllowFriendRequest => 'Permite cererile de prietenie';

  @override
  String get privacyProfileVisibility => 'Vizibilitatea profilului';

  @override
  String get privacyEveryone => 'Toată lumea';

  @override
  String get privacyFriendsOfFriends => 'Prietenii prietenilor';

  @override
  String get privacyNobody => 'Nimeni';

  @override
  String get privacyFriendsOnly => 'Doar prietenii';

  @override
  String get privacySaveSuccess => 'Setări salvate';

  @override
  String get privacySaveFailed => 'Salvarea a eșuat. Încercați din nou.';

  @override
  String get fontSizeTitle => 'Dimensiunea fontului';

  @override
  String get fontSizeSmall => 'Mic';

  @override
  String get fontSizeNormal => 'Standard';

  @override
  String get fontSizeLarge => 'Mare';

  @override
  String get fontSizeExtraLarge => 'Extra mare';

  @override
  String get fontSizePreview => 'Previzualizare';

  @override
  String get chatBackgroundTitle => 'Fundalul conversației';

  @override
  String get chatBackgroundDefault => 'Implicit';

  @override
  String get chatBackgroundCustom => 'Personalizat';

  @override
  String get chatBackgroundReset => 'Restaurare setări implicite';

  @override
  String get termsTitle => 'Acordul Utilizatorului';

  @override
  String get privacyPolicyTitle => 'Politica de Confidențialitate';

  @override
  String get recentContactsTitle => 'Recente';

  @override
  String get recentContactsEmpty => 'Niciun contact recent';

  @override
  String get inviteFriendsTitle => 'Invită prieteni';

  @override
  String get inviteFriendsCopyLink => 'Copiază linkul invitației';

  @override
  String get inviteFriendsLinkCopied => 'Linkul invitației a fost copiat';

  @override
  String get imageViewerTitle => 'Fotografie';

  @override
  String get imageViewerSave => 'Salvați în album';

  @override
  String get imageViewerSaveSuccess => 'Salvat în album';

  @override
  String get imageViewerSaveFailed => 'Salvarea a eșuat. Încercați din nou.';

  @override
  String get customerServiceTitle => 'Centru de asistență';

  @override
  String get customerServiceQueue => 'În coadă';

  @override
  String get customerServiceActive => 'Activ';

  @override
  String get customerServiceClaim => 'Acceptă';

  @override
  String get customerServiceTakeover => 'Preia';

  @override
  String get customerServiceClose => 'Încheie asistența';

  @override
  String get customerServiceCloseConfirm =>
      'Încheiați această sesiune de asistență?';

  @override
  String get customerServiceNoQueue => 'Nicio sesiune în coadă';

  @override
  String get customerServiceNoActive => 'Nicio sesiune activă';

  @override
  String get customerServiceVisitor => 'Vizitator';

  @override
  String get customerServiceCustomer => 'Client';

  @override
  String get customerServiceAssignedTo => 'Alocat';

  @override
  String get customerServiceTransferConversation => 'Transferă conversația';

  @override
  String get marketingToolbar => 'Instrumente de marketing';

  @override
  String get callIncoming => 'Apel primit';

  @override
  String get callOutgoing => 'Apel efectuat';

  @override
  String get callAccept => 'Acceptă';

  @override
  String get callReject => 'Refuză';

  @override
  String get callHangup => 'Încheie';

  @override
  String get callMissed => 'Apel pierdut';

  @override
  String get callDuration => 'Durată';

  @override
  String get callAudio => 'Apel vocal';

  @override
  String get callGeneric => 'Apel';

  @override
  String get callVideo => 'Apel video';

  @override
  String get callConnecting => 'Se conectează...';

  @override
  String get callRinging => 'Sună...';

  @override
  String get callEnded => 'Apel încheiat';

  @override
  String get callFailed => 'Apel eșuat';

  @override
  String get callRejected => 'Apel refuzat';

  @override
  String get callTimeout => 'Fără răspuns';

  @override
  String get callCancelled => 'Anulat';

  @override
  String get callUnknownPeer => 'Necunoscut';

  @override
  String get callVideoInvitation => 'Invitație la apel video';

  @override
  String get callAudioInvitation => 'Invitație la apel audio';

  @override
  String get callAnswerAudio => 'Răspunde audio';

  @override
  String get callAnswerVideo => 'Răspunde video';

  @override
  String get callViewProfile => 'Vezi profilul';

  @override
  String get callOpeningCamera => 'Se deschide camera...';

  @override
  String get callWaitingRemoteVideo =>
      'Se așteaptă imaginea video a interlocutorului...';

  @override
  String get callCameraOff => 'Cameră oprită';

  @override
  String get callCameraOn => 'Cameră pornită';

  @override
  String get callMicrophoneOff => 'Microfon oprit';

  @override
  String get callMicrophoneOn => 'Microfon pornit';

  @override
  String get callSpeakerOff => 'Difuzor oprit';

  @override
  String get callSpeakerOn => 'Difuzor pornit';

  @override
  String get callVideoPermissionFailure =>
      'Apelul video nu a putut fi inițiat. Verificați permisiunile pentru cameră și microfon și încercați din nou.';

  @override
  String get callAudioPermissionFailure =>
      'Apelul audio nu a putut fi inițiat. Verificați permisiunea pentru microfon și încercați din nou.';

  @override
  String get callIncompleteIncoming =>
      'Informațiile apelului primit sunt incomplete, iar apelul nu poate fi preluat.';

  @override
  String get callInProgress => 'În apel';

  @override
  String get callCalling => 'Se apelează...';

  @override
  String callEndedMedia(String media) {
    return '$media s-a încheiat';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media a fost refuzat';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media nu a primit răspuns';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media a fost anulat';
  }

  @override
  String get callConnectionLost => 'Conexiunea apelului s-a pierdut';

  @override
  String get callAdminEnded => 'Apel încheiat de un administrator';

  @override
  String callFailedMedia(String media) {
    return '$media a eșuat';
  }

  @override
  String get callBusy => 'Interlocutorul este ocupat';

  @override
  String callDurationValue(String duration) {
    return 'Durata apelului $duration';
  }

  @override
  String get callNotConnected => 'Neconectat';

  @override
  String get callDialed => 'Efectuat';

  @override
  String get callAnswered => 'Răspuns';

  @override
  String get callRejectedByPeer => 'Refuzat de interlocutor';

  @override
  String get callRejectedBySelf => 'Respingat';

  @override
  String get callPeerDidNotAnswer => 'Interlocutorul nu a răspuns';

  @override
  String get callMissedIncoming => 'Apel primit pierdut';

  @override
  String get callPeerCancelled => 'Anulat de interlocutor';

  @override
  String get notificationNewMessageTitle => 'Mesaj nou StartLink';

  @override
  String get notificationOnlineServiceTitle => 'Mesaj nou de asistență clienți';

  @override
  String get notificationNewMessageBody => 'Ați primit un mesaj nou';

  @override
  String get notificationImagePreview => 'A trimis o imagine';

  @override
  String get notificationVideoPreview => 'A trimis un videoclip';

  @override
  String get notificationVoicePreview => 'A trimis un mesaj vocal';

  @override
  String get notificationFilePreview => 'A trimis un fișier';

  @override
  String get notificationContactPreview => 'A trimis o carte de contact';

  @override
  String get notificationCallLogPreview => 'A trimis un istoric de apel';

  @override
  String get notificationLocationPreview => 'A partajat o locație';

  @override
  String get notificationLinkPreview => 'A partajat un link';

  @override
  String notificationMentionMe(String body) {
    return 'V-a menționat: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender v-a menționat: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'A menționat pe toată lumea: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender a menționat pe toată lumea: $body';
  }

  @override
  String get notificationSecurityTitle => 'Alertă de securitate a contului';

  @override
  String get notificationSecurityBody =>
      'Setările de securitate ale contului StartLink s-au schimbat. Verificați-le acum.';

  @override
  String get notificationFriendAcceptedTitle => 'Cerere de prietenie acceptată';

  @override
  String get notificationFriendRejectedTitle => 'Cerere de prietenie refuzată';

  @override
  String get notificationFriendAcceptedBody =>
      'Interlocutorul a acceptat cererea dvs. de prietenie';

  @override
  String get notificationFriendRejectedBody =>
      'Interlocutorul a refuzat cererea dvs. de prietenie';

  @override
  String get notificationVideoCallTitle => 'Invitație la apel video';

  @override
  String get notificationAudioCallTitle => 'Invitație la apel vocal';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller v-a invitat la un apel video';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller v-a invitat la un apel vocal';
  }

  @override
  String get notificationMessageChannelName => 'Mesaje';

  @override
  String get notificationMessageChannelDescription =>
      'Mesaje din conversații, înregistrări de apeluri și alerte de sistem';

  @override
  String get notificationCallChannelName => 'Apeluri';

  @override
  String get notificationCallChannelDescription =>
      'Alerte pentru apeluri vocale și video';

  @override
  String get notificationSecurityChannelName => 'Securitatea contului';

  @override
  String get notificationSecurityChannelDescription =>
      'Alerte despre autentificare și schimbarea parolei sau a numărului de mobil';

  @override
  String get notificationUnknownCaller => 'Apelant necunoscut';

  @override
  String get pendingJoinRequestsTitle => 'Cereri noi';

  @override
  String get pendingJoinRequestsEmpty => 'Nicio cerere';

  @override
  String get pendingJoinRequestApprove => 'Accept';

  @override
  String get pendingJoinRequestReject => 'Refuză';

  @override
  String get pendingJoinRequestApproveSuccess => 'Aprobat';

  @override
  String get pendingJoinRequestRejectSuccess => 'Respins';

  @override
  String get pendingJoinRequestFailed =>
      'Operațiunea a eșuat. Încercați din nou.';

  @override
  String get myCustomersTitle => 'Clienții mei';

  @override
  String get myCustomersEmpty => 'Niciun client';

  @override
  String get groupListTitle => 'Grupuri';

  @override
  String get groupListEmpty => 'Niciun grup';

  @override
  String get addFriendTitle => 'Adaugă contact';

  @override
  String get addFriendSearchHint => 'Telefon / e-mail / ID StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String get addFriendButton => 'Adaugă';

  @override
  String get addFriendCannotAddSelf => 'Nu vă puteți adăuga pe dvs.';

  @override
  String get addFriendUnsupportedUser =>
      'Acest utilizator nu poate fi adăugat. Îi puteți scrie direct.';

  @override
  String get addFriendMessageHint => 'Introduceți un mesaj';

  @override
  String get addFriendSendRequest => 'Trimite cererea';

  @override
  String get joinCompanyTitle => 'Alătură-te companiei';

  @override
  String get joinCompanyCodeHint => 'Introduceți codul companiei';

  @override
  String get joinCompanySearchHint => 'Caută numele companiei';

  @override
  String get joinCompanyApply => 'Solicită alăturarea';

  @override
  String get joinCompanyApplySuccess => 'Cerere trimisă';

  @override
  String get joinCompanyApplyFailed =>
      'Trimiterea cererii a eșuat. Încercați din nou.';

  @override
  String get joinCompanyAutoApproved => 'Aprobat automat. Bun venit!';

  @override
  String get joinCompanyPending => 'Cerere trimisă, în așteptarea aprobării';

  @override
  String get joinCompanyInviteCodeHint => 'Introduceți codul invitației';

  @override
  String get joinCompanyAcceptInvite => 'Acceptă invitația';

  @override
  String get joinCompanyNoResults => 'Nicio companie găsită';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count membri';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Ora Pacificului';

  @override
  String get timezoneNameMountainTime => 'Ora Munților';

  @override
  String get timezoneNameCentralTime => 'Ora Centrală';

  @override
  String get timezoneNameEasternTime => 'Ora de Est';

  @override
  String get timezoneNameAtlanticTime => 'Ora Atlanticului';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azore';

  @override
  String get timezoneNameLondonDublin => 'Londra/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Roma';

  @override
  String get timezoneNameCairoHelsinki => 'Cairo/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moscova/Riad';

  @override
  String get timezoneNameTehran => 'Teheran';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Baku';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karachi/Tașkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/New Delhi';

  @override
  String get timezoneNameKathmandu => 'Kathmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dhaka/Almatî';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoi/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Beijing/Shanghai/Hong Kong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokyo/Seul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Insulele Solomon';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute =>
      'Selectează inteligent cea mai bună rută';

  @override
  String get networkTesting => 'Se testează...';

  @override
  String get networkTestingShort => 'Testare';

  @override
  String networkLatencyMs(int ms) {
    return 'Latență $ms ms';
  }

  @override
  String get networkConnectionMode => 'Mod de conectare';

  @override
  String get networkDirectMode => 'Mod direct';

  @override
  String get networkProxyMode => 'Mod proxy';

  @override
  String get networkDirectModeDesc => 'Conectare directă la server';

  @override
  String get networkProxyModeDesc => 'Conectare printr-un server proxy';

  @override
  String get networkDirectRoutes => 'Rute directe';

  @override
  String get networkProxyRoutes => 'Rute proxy';

  @override
  String get networkTestAll => 'Testează tot';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Nod Hong Kong';

  @override
  String get networkSingaporeNode => 'Nod Singapore';

  @override
  String get networkJapanNode => 'Nod Japonia';

  @override
  String get networkUnitedStatesNode => 'Nod Statele Unite';

  @override
  String get networkHint =>
      'Sfaturi:\n• Mod direct: mai rapid și potrivit pentru utilizarea internă\n• Mod proxy: mai stabil pentru comunicarea internațională\n• Atingeți pictograma de reîmprospătare pentru a testa latența unei singure rute';

  @override
  String get teenModeTitle => 'Mod pentru adolescenți';

  @override
  String get teenModeStatusOn => 'Activat';

  @override
  String get teenModeStatusOff => 'Oprit';

  @override
  String get teenModeStatusLoading => 'Se încarcă';

  @override
  String get teenModeUnavailable =>
      'Starea modului pentru adolescenți este temporar indisponibilă';

  @override
  String get teenModeInvalidResponse =>
      'Modul pentru adolescenți a returnat un răspuns invalid';

  @override
  String get teenModeEnableDescription =>
      'Regulile platformei vor limita timpul de utilizare și anumite funcții.';

  @override
  String get teenModePasscode => 'Cod de acces';

  @override
  String get teenModeCurrentPasscode => 'Codul de acces actual';

  @override
  String get teenModeNewPasscode => 'Cod de acces nou';

  @override
  String get teenModePasscodeHint => 'Introduceți 4–6 cifre';

  @override
  String get teenModeEnable => 'Activează modul pentru adolescenți';

  @override
  String get teenModeDisable => 'Dezactivează modul pentru adolescenți';

  @override
  String get teenModeChangePasscode => 'Schimbă codul de acces';

  @override
  String get teenModeSource => 'Activat de';

  @override
  String get teenModeDailyUsage => 'Utilizat azi';

  @override
  String get teenModeRemaining => 'Timp rămas';

  @override
  String get teenModeMinutesUnit => 'Minute';

  @override
  String get teenModeUnlimited => 'Nelimitat';

  @override
  String get teenModeRequestExtension => 'Solicită timp suplimentar';

  @override
  String get teenModeExtensionSubmitted =>
      'Cererea de timp a fost trimisă unui tutore';

  @override
  String get teenModeTimeLimitReached =>
      'Limita de utilizare de azi a fost atinsă';

  @override
  String get teenModeCurfewActive =>
      'Aceasta este o perioadă cu utilizare restricționată';

  @override
  String get teenModeReliefHint =>
      'Puteți consulta istoricul, contacta asistența oficială și raporta probleme.';

  @override
  String get teenModeRestrictedNotice =>
      'Modul pentru adolescenți împiedică momentan trimiterea mesajelor';

  @override
  String get teenModeActionBlocked =>
      'Modul pentru adolescenți împiedică momentan această acțiune';

  @override
  String get teenModeMyRequests => 'Cererile mele';

  @override
  String get guardianCenterTitle => 'Centrul tutorilor';

  @override
  String get guardianRelationships => 'Relații de tutelă';

  @override
  String get guardianMinors => 'Copii pe care îi supraveghez';

  @override
  String get guardianApprovals => 'Aprobări în așteptare';

  @override
  String get guardianBind => 'Introduceți codul de asociere';

  @override
  String get guardianCreateMinorCode => 'Sunt copil — creează cod';

  @override
  String get guardianCreateGuardianCode => 'Sunt tutore — creează cod';

  @override
  String get guardianRelation => 'Relație';

  @override
  String get guardianPrimary => 'Tutore principal';

  @override
  String get guardianCode => 'Cod de asociere din 6 cifre';

  @override
  String get guardianCodeHint =>
      'Introduceți codul furnizat de cealaltă persoană';

  @override
  String get guardianCodeCreated =>
      'Cod creat. Distribuiți-l înainte de expirare.';

  @override
  String get guardianEmpty => 'Nicio relație de tutelă';

  @override
  String get guardianNoMinors => 'Niciun copil supravegheat';

  @override
  String get guardianUnbind => 'Elimină relația';

  @override
  String get guardianExtend => 'Adaugă timp copilului';

  @override
  String get guardianPolicyTitle => 'Reguli de utilizare';

  @override
  String get guardianPolicyLocked => 'Blocat de platformă';

  @override
  String get approvalEmpty => 'Nicio cerere';

  @override
  String get approvalApprove => 'Accept';

  @override
  String get approvalReject => 'Refuză';

  @override
  String get approvalPending => 'În așteptare';

  @override
  String get approvalApproved => 'Aprobat';

  @override
  String get approvalRejected => 'Respingat';

  @override
  String get approvalExpired => 'Expirat';

  @override
  String get approvalCancelled => 'Anulat';

  @override
  String get approvalReplayFailed =>
      'Acțiunea inițială a eșuat. Încercați-o din nou.';

  @override
  String get requestCancelled => 'Cerere anulată';

  @override
  String get kycTitle => 'Verificarea identității';

  @override
  String get kycNotRequired => 'Verificarea identității nu este necesară';

  @override
  String get kycVerified => 'Identitate verificată';

  @override
  String get kycDeclared => 'Informațiile de identitate au fost trimise';

  @override
  String get kycPending => 'În curs de verificare';

  @override
  String get kycRejected => 'Verificare respinsă';

  @override
  String get kycNone => 'Nu au fost trimise informații de identitate';

  @override
  String get kycRealName => 'Nume complet';

  @override
  String get kycIdNumber => 'Număr de identificare';

  @override
  String get kycIdType => 'Tipul documentului';

  @override
  String get kycApplicability =>
      'Introduceți datele reale pentru documentul ales. Tipurile acceptate sunt afișate în listă.';

  @override
  String get kycCamera => 'Fă o fotografie';

  @override
  String get kycGallery => 'Alege din galerie';

  @override
  String get kycPhotoLimit => 'Maxim pe fotografie';

  @override
  String get kycSelectPhoto => 'Selectează fotografie';

  @override
  String get kycPhotoSelected => 'Selectat';

  @override
  String get kycViewPhoto => 'Atingeți pentru a vedea fotografia';

  @override
  String get kycReplacePhoto => 'Alege altă fotografie';

  @override
  String get kycDisclosure =>
      'Folosim numele, numărul documentului și fotografiile acestuia pentru a vă verifica identitatea. Fără ele nu puteți trimite cererea, iar unele funcții restricționate pot fi indisponibile.';

  @override
  String get kycConsent =>
      'Îmi dau separat consimțământul pentru această prelucrare a informațiilor de identitate';

  @override
  String get kycConsentRequired =>
      'Acordați consimțământul separat înainte de trimitere';

  @override
  String get kycResubmitTitle => 'Retrimite informațiile de identitate';

  @override
  String get kycResubmitWarning =>
      'Retrimiterea va înlocui cererea în așteptare. Continuați?';

  @override
  String get kycSubmitting => 'Se trimite';

  @override
  String get kycSubmitFailed => 'Trimiterea a eșuat. Încercați din nou.';

  @override
  String get kycSubmitUnavailable =>
      'Informațiile de identitate nu pot fi trimise acum';

  @override
  String get kycResubmitNotAllowed =>
      'Retrimiterea nu este disponibilă după respingere. Contactați asistența dacă este necesar.';

  @override
  String get kycDailyLimit =>
      'Ați atins limita de trimiteri de azi. Încercați mâine.';

  @override
  String get kycTypeUnavailable =>
      'Niciun tip de document disponibil. Încercați mai târziu.';

  @override
  String get kycNameInvalid => 'Numele legal trebuie să aibă 2–64 de caractere';

  @override
  String get kycNumberRequired => 'Introduceți numărul documentului';

  @override
  String get kycFrontRequired => 'Încărcați fața documentului';

  @override
  String get kycBackRequired => 'Încărcați verso-ul documentului';

  @override
  String get kycPhotoTooLarge =>
      'Fotografia depășește limita de mărime. Comprimați-o și încercați din nou.';

  @override
  String get kycAccountChanged =>
      'Contul sau spațiul s-a schimbat. Redeschideți această pagină.';

  @override
  String get kycPhotoInvalid => 'Alegeți o imagine validă';

  @override
  String get kycPortraitSide => 'Partea cu fotografia';

  @override
  String get kycEmblemSide => 'Partea cu stema';

  @override
  String get kycPassportDataPage => 'Pagina cu datele pașaportului';

  @override
  String get kycPassportOtherPage =>
      'Pagina de vize sau o pagină liberă a pașaportului';

  @override
  String get kycFront => 'Fața actului de identitate';

  @override
  String get kycBack => 'Verso-ul actului de identitate';

  @override
  String get kycRequired =>
      'Verificarea identității este necesară înainte de crearea unui grup';

  @override
  String get kycGoVerify => 'Verifică acum';

  @override
  String get kycStatusUnknown =>
      'Starea identității este indisponibilă. Reîmprospătați mai târziu.';

  @override
  String get kycSuperseded =>
      'O trimitere ulterioară a înlocuit-o pe aceasta. Verificați cea mai recentă stare a identității.';

  @override
  String get kycMediaNotFound =>
      'Fotografia documentului este indisponibilă în acest spațiu. Selectați-o din nou înainte de trimitere.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Mesaje în masă pentru clienți';

  @override
  String get officialAccountBadge => 'Oficial';

  @override
  String get officialAccountOpenConversation => 'Deschide conversația';

  @override
  String get officialAccountJoinHint =>
      'Adăugarea acestui cont vă înscrie în companie ca client. Nu este necesară aprobarea prieteniei.';

  @override
  String get officialAccountJoinDisabled =>
      'Această companie nu acceptă clienți noi. Contactați asistența.';

  @override
  String get officialAccountRemoved =>
      'Ați fost eliminat din această companie. Cereți companiei o nouă invitație.';

  @override
  String get officialAccountBanned =>
      'Contul dvs. a fost dezactivat în această companie.';

  @override
  String get officialAccountUnavailable =>
      'Acest cont oficial este momentan indisponibil.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Alăturarea la o companie nu este permisă în modul actual.';

  @override
  String get officialAccountPlatformRequired =>
      'Folosiți un cont al platformei pentru a adăuga acest cont oficial.';

  @override
  String get officialAccountOpenFailed =>
      'Conversația nu a putut fi deschisă. Încercați din nou.';

  @override
  String get officialAccountAccountChanged =>
      'Contul sau spațiul s-a schimbat. Deschideți-l din nou.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Directorul companiilor nu este actualizat. Încercați în scurt timp.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Sincronizarea contului oficial a eșuat. Conținutul local este încă disponibil.';

  @override
  String get officialAccountInboxSyncing =>
      'Se sincronizează mesajele contului oficial';

  @override
  String get diagnosticsTitle => 'Diagnosticare';

  @override
  String get diagnosticsExplanation =>
      'Jurnalele sunt anonimizate și conțin informații operaționale și erori pentru acest cont și spațiu, plus evenimente publice de pornire. Conținutul conversațiilor și datele de autentificare sunt excluse.';

  @override
  String get diagnosticsHour => 'Ultima oră';

  @override
  String get diagnosticsDay => 'Ultimele 24 de ore';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Evenimente disponibile: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Jurnalele sunt salvate pe acest dispozitiv și rămân disponibile după repornire.';

  @override
  String get diagnosticsNotPersistent =>
      'Unele jurnale nu au fost salvate. Reîmprospătați pentru a reîncerca.';

  @override
  String get diagnosticsExport => 'Exportă și distribuie';

  @override
  String get diagnosticsRefresh => 'Reîmprospătare';

  @override
  String get diagnosticsClear => 'Șterge jurnalele acestui spațiu';

  @override
  String get diagnosticsClearConfirm =>
      'Ștergeți jurnalele de diagnosticare ale acestui spațiu? Istoricul conversațiilor va fi păstrat.';

  @override
  String get diagnosticsShared =>
      'Distribuirea prin sistem s-a încheiat. Verificați fișierul în aplicația destinatară.';

  @override
  String get diagnosticsCancelled =>
      'Distribuire anulată. Puteți exporta din nou.';

  @override
  String get diagnosticsUnconfirmed =>
      'Distribuirea nu a putut fi confirmată. Verificați aplicația destinatară.';

  @override
  String get diagnosticsFailed => 'Operațiunea a eșuat. Încercați din nou.';
}
