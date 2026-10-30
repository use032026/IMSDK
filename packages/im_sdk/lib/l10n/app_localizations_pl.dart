// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get navWorkbench => 'Panel pracy';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Nie udało się wczytać danych konta';

  @override
  String get startupFailureTitle => 'Uruchomienie nie powiodło się';

  @override
  String get startupFailureMessage => 'Sprawdź sieć i spróbuj ponownie';

  @override
  String get privacyConsentTitle => 'Regulamin i Polityka Prywatności';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Witamy w $brand. Aby zapewniać logowanie do konta, komunikację błyskawiczną, współpracę firmową, obsługę klienta online, powiadomienia o wiadomościach i ochronę bezpieczeństwa, musimy przetwarzać niezbędne informacje zgodnie z Regulaminem i Polityką prywatności.\n\nZanim naciśniesz Zgadzam się, nie będziemy odczytywać schowka, uruchamiać JPush/JCore ani zestawów SDK powiadomień producentów urządzeń ani używać ich do uzyskiwania Android ID, OAID, list zainstalowanych aplikacji, adresów MAC lub podobnych danych. Jeśli na razie odmówisz, zapiszemy ten wybór; możesz dalej czytać dokumenty i zdecydować później.\n\nPo wyrażeniu zgody JPush/JCore i usługi powiadomień producentów mogą przetwarzać model urządzenia, wersję Androida, nazwę pakietu i wersję aplikacji, typ sieci, adres IP, Android ID, OAID, Registration ID powiadomień, token producenta oraz dane o dostarczeniu i otwarciu powiadomień, aby dostarczać powiadomienia o wiadomościach, obsłudze klienta i połączeniach przychodzących. Wyłączyliśmy zbędne funkcje, w tym inteligentne powiadomienia, listy zainstalowanych aplikacji, MAC, IMEI, IMSI, listy sieci Wi-Fi, automatyczne wybudzanie i powiązane uruchamianie.\n\nDostęp do schowka następuje tylko wtedy, gdy samodzielnie używasz kopiowania lub wklejania. O uprawnienia do aparatu, mikrofonu, powiadomień i innych funkcji systemowych prosimy tylko podczas używania danej funkcji. Odmowa pojedynczego uprawnienia wpływa tylko na tę funkcję. Przeczytaj pełne dokumenty poniżej i samodzielnie zdecyduj, czy wyrażasz zgodę.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Witamy w $brand. Aby zapewniać logowanie do konta, komunikację błyskawiczną, współpracę firmową, obsługę klienta online, powiadomienia o wiadomościach i ochronę bezpieczeństwa, musimy przetwarzać niezbędne informacje zgodnie z Regulaminem i Polityką prywatności.\n\nZanim naciśniesz Zgadzam się, nie będziemy odczytywać schowka, uruchamiać JPush/JCore, rejestrować się w usłudze Apple Push Notification service (APNs) ani uzyskiwać identyfikatorów powiadomień, takich jak JPush Registration ID lub token urządzenia APNs. Jeśli na razie odmówisz, zapiszemy ten wybór; możesz dalej czytać dokumenty i zdecydować później.\n\nPo wyrażeniu zgody możemy przetwarzać model iPhone’a, wersję iOS, nazwę pakietu i wersję aplikacji, typ sieci, adres IP, IDFV, JPush Registration ID, token urządzenia APNs oraz dane o dostarczeniu i otwarciu powiadomień, aby dostarczać powiadomienia o wiadomościach, obsłudze klienta i połączeniach przychodzących. JPush/JCore łączy z usługą powiadomień; Apple APNs przetwarza identyfikator aplikacji, token urządzenia i treść powiadomienia w celu dostarczenia go przez system. Aktualna aplikacja na iOS nie korzysta z usług reklamowych i nie uzyskuje IDFA.\n\nDostęp do schowka następuje tylko wtedy, gdy samodzielnie używasz kopiowania lub wklejania. O uprawnienia do aparatu, mikrofonu, powiadomień i innych funkcji systemowych prosimy tylko podczas używania danej funkcji. Odmowa pojedynczego uprawnienia wpływa tylko na tę funkcję. Przeczytaj pełne dokumenty poniżej i samodzielnie zdecyduj, czy wyrażasz zgodę.';
  }

  @override
  String get privacyConsentTermsLink => 'Regulamin';

  @override
  String get privacyConsentConjunction => 'i';

  @override
  String get privacyConsentPrivacyLink => 'Polityka prywatności';

  @override
  String get privacyConsentDecline => 'Nie zgadzam się';

  @override
  String get privacyConsentDeclinedExit =>
      'Nie zaakceptowano Regulaminu i Polityki prywatności. Aplikacja zostanie zamknięta.';

  @override
  String get privacyConsentAccept => 'Zgadzam się';

  @override
  String get privacyConsentRuntimeFailure =>
      'Uruchomienie nie powiodło się. Sprawdź sieć i spróbuj ponownie.';

  @override
  String get privacyConsentSaveFailure =>
      'Nie udało się zapisać wyboru. Spróbuj ponownie.';

  @override
  String get appUpdateRequiredTitle =>
      'Aby kontynuować, wymagana jest aktualizacja';

  @override
  String get appUpdateOptionalTitle => 'Dostępna nowa wersja';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Dostępna jest wersja $brand $version';
  }

  @override
  String get appUpdateLater => 'Później';

  @override
  String get appUpdateNow => 'Zaktualizuj teraz';

  @override
  String get appUpdateProcessing => 'Przetwarzanie...';

  @override
  String get appUpdateInvalidUrl =>
      'Adres aktualizacji jest nieprawidłowy. Spróbuj później.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Nie udało się otworzyć łącza aktualizacji. Spróbuj później.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Pobieranie zostało przerwane. Sprawdź sieć i spróbuj ponownie.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Weryfikacja pakietu nie powiodła się. Pobierz go ponownie.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Zezwól aplikacji $brand na instalowanie aktualizacji w ustawieniach systemu.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Nie udało się otworzyć instalatora systemowego. Sprawdź uprawnienia do instalacji.';

  @override
  String get appUpdateGenericFailure =>
      'Aktualizacja nie powiodła się. Sprawdź sieć i spróbuj ponownie.';

  @override
  String get appUpdateUnavailable =>
      'Nowa wersja nie jest jeszcze dostępna do pobrania. Spróbuj później.';

  @override
  String get appUpdateCheckFailed =>
      'Nie udało się sprawdzić aktualizacji. Spróbuj później.';

  @override
  String get appUpdateChecking => 'Sprawdzanie';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonSave => 'Zapisz';

  @override
  String get commonEdit => 'Edytuj';

  @override
  String get commonDelete => 'Usuń';

  @override
  String get commonSearch => 'Szukaj';

  @override
  String get commonLoading => 'Wczytywanie...';

  @override
  String get commonLoadFailed => 'Nie udało się załadować';

  @override
  String get commonRetry => 'Ponów';

  @override
  String get commonEmpty => 'Brak danych';

  @override
  String get commonCopy => 'Kopiuj';

  @override
  String get commonForward => 'Przekaż dalej';

  @override
  String get commonFavorite => 'Zapisz';

  @override
  String get commonClose => 'Zamknij';

  @override
  String get commonSend => 'Wyślij';

  @override
  String get commonDone => 'Gotowe';

  @override
  String get commonMore => 'Więcej';

  @override
  String get commonSettings => 'Ustawienia';

  @override
  String get commonCopied => 'Skopiowano';

  @override
  String get commonUnknown => 'Nieznany';

  @override
  String get commonNotSet => 'Nie ustawiono';

  @override
  String get commonUnbound => 'Niepołączone';

  @override
  String get commonViewAll => 'Zobacz wszystko';

  @override
  String get commonSubmit => 'Wyślij';

  @override
  String get commonAdd => 'Dodaj';

  @override
  String get commonRemove => 'Usuń';

  @override
  String get commonCreate => 'Utwórz';

  @override
  String get commonUpdate => 'Aktualizuj';

  @override
  String get commonUpload => 'Prześlij';

  @override
  String get commonShare => 'Udostępnij';

  @override
  String get commonBlock => 'Zablokuj';

  @override
  String get commonUnblock => 'Odblokuj';

  @override
  String get commonMute => 'Wycisz';

  @override
  String get commonUnmute => 'Wyłącz wyciszenie';

  @override
  String get commonPin => 'Przypięte';

  @override
  String get commonUnpin => 'Odepnij';

  @override
  String get commonMarkRead => 'Oznacz jako przeczytane';

  @override
  String get commonMarkUnread => 'Oznacz jako nieprzeczytane';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed =>
      'Operacja nie powiodła się. Spróbuj ponownie.';

  @override
  String get commonNetworkError => 'Błąd sieci. Sprawdź połączenie.';

  @override
  String get navMessages => 'Wiadomości';

  @override
  String get navContacts => 'Kontakty';

  @override
  String get navMe => 'Ja';

  @override
  String get authLoginTitle => 'Zaloguj się do StartLink';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'Adres e-mail';

  @override
  String get authTabLoginName => 'Identyfikator StartLink';

  @override
  String get authHintMobile => 'Wpisz numer telefonu';

  @override
  String get authHintEmail => 'Wprowadź swój adres e-mail';

  @override
  String get authHintPassword => 'Wprowadź hasło';

  @override
  String get authHintCode => 'Wpisz kod weryfikacyjny';

  @override
  String get authHintLoginName =>
      'Wpisz identyfikator StartLink (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Zaloguj się';

  @override
  String get authGetCode => 'Uzyskaj kod';

  @override
  String authResendCode(int seconds) {
    return 'Wyślij ponownie za $seconds s';
  }

  @override
  String get authUsePassword => 'Użyj hasła';

  @override
  String get authUseCode => 'Użyj kodu weryfikacyjnego';

  @override
  String get authAgreementPrefix => 'Zapoznałem się i akceptuję';

  @override
  String get authAgreementAnd => 'i';

  @override
  String get authTermsLink => 'Regulamin';

  @override
  String get authPrivacyLink => 'Polityka prywatności';

  @override
  String get authCaptchaTitle => 'Weryfikacja bezpieczeństwa';

  @override
  String get authCaptchaHint => 'Wpisz odpowiedź';

  @override
  String get authCaptchaFailed =>
      'Nie udało się pobrać zadania captcha. Spróbuj ponownie.';

  @override
  String get authErrorEmptyCode => 'Wpisz kod weryfikacyjny';

  @override
  String get authErrorEmptyPassword => 'Wprowadź hasło';

  @override
  String get authErrorEmptyLoginName => 'Wpisz identyfikator StartLink';

  @override
  String get authErrorWrongCredentials => 'Nieprawidłowe konto lub hasło';

  @override
  String get authDeactivatingTitle => 'Dezaktywacja konta';

  @override
  String get authDeactivatingContent =>
      'Twoje konto jest w okresie oczekiwania na dezaktywację (7 dni).\n\nAby ją anulować, naciśnij „Anuluj dezaktywację”; aby wejść do aplikacji, naciśnij „Kontynuuj”.';

  @override
  String get authContinueUse => 'Kontynuuj';

  @override
  String get authCancelDeactivation => 'Anuluj dezaktywację';

  @override
  String get authDeactivationCancelled =>
      'Dezaktywacja anulowana, konto przywrócone';

  @override
  String get authDeactivationCancelFailed =>
      'Anulowanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get authLogout => 'Wyloguj się';

  @override
  String get authLogoutConfirm => 'Czy na pewno chcesz się wylogować?';

  @override
  String get authSendingCode => 'Wysyłanie...';

  @override
  String get authCodeSent => 'Kod weryfikacyjny wysłany';

  @override
  String get authLoginFailed => 'Logowanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get authRegisterFailed =>
      'Rejestracja nie powiodła się. Spróbuj ponownie.';

  @override
  String get authEnterpriseCode => 'Kod firmy';

  @override
  String get authEnterpriseCodeHint => 'Wpisz kod firmy';

  @override
  String get authPendingApproval =>
      'Rejestracja zakończona. Prośba o dołączenie do firmy została wysłana i oczekuje na zatwierdzenie.';

  @override
  String get authNoAccount => 'Nie masz konta?';

  @override
  String get authRegisterNow => 'Zarejestruj się';

  @override
  String get authCountryPickerTitle => 'Wybierz kraj/region';

  @override
  String get authCountrySearchHint => 'Szukaj kraju/regionu';

  @override
  String get authCountryChinaMainland => 'Chiny kontynentalne';

  @override
  String get authCountryHongKong => 'Hongkong, Chiny';

  @override
  String get authCountryMacau => 'Makau, Chiny';

  @override
  String get authCountryTaiwan => 'Tajwan, Chiny';

  @override
  String get authCountryUnitedStates => 'Stany Zjednoczone';

  @override
  String get authCountryUnitedKingdom => 'Wielka Brytania';

  @override
  String get authCountryJapan => 'Japonia';

  @override
  String get authCountrySouthKorea => 'Korea Południowa';

  @override
  String get authCountrySingapore => 'Singapur';

  @override
  String get authCountryMalaysia => 'Malezja';

  @override
  String get authCountryAustralia => 'Australia';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Niemcy';

  @override
  String get authCountryFrance => 'Francja';

  @override
  String get authCountryIndia => 'Indie';

  @override
  String get authCountryThailand => 'Tajlandia';

  @override
  String get authCountryVietnam => 'Wietnam';

  @override
  String get authCountryIndonesia => 'Indonezja';

  @override
  String get authCountryPhilippines => 'Filipiny';

  @override
  String get authQuickLoginTitle => 'Szybkie logowanie';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Logowanie. Czekaj.';

  @override
  String get authRoleOwner => 'Właściciel';

  @override
  String get authRoleAdministrator => 'Administrator';

  @override
  String get authRoleCustomerService => 'Obsługa klienta';

  @override
  String get authRoleTechnicalSupport => 'Pomoc techniczna';

  @override
  String get authRoleEmployee => 'Pracownik';

  @override
  String get authRoleMember => 'Członek';

  @override
  String get authRoleEnterpriseCustomer => 'Klient firmy';

  @override
  String get authUnavailablePrefix => 'Niedostępne · ';

  @override
  String get authUnassignedService => 'Brak przypisanego konsultanta';

  @override
  String authAssignedService(String staff) {
    return 'Przypisano do $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Klient · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Pracownik · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count użytkowników';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Tożsamość';

  @override
  String get authRegisterTitle => 'Zarejestruj się';

  @override
  String get authNickname => 'Pseudonim';

  @override
  String get authNicknameHint => 'Ustaw pseudonim';

  @override
  String get authPassword => 'Hasło';

  @override
  String get authPasswordSetHint => 'Ustaw hasło (co najmniej 6 znaków)';

  @override
  String get authConfirmPassword => 'Potwierdź hasło';

  @override
  String get authConfirmPasswordHint => 'Wpisz hasło ponownie';

  @override
  String get authVerificationCode => 'Kod weryfikacyjny';

  @override
  String get authRegisterAndLogin => 'Zarejestruj się i zaloguj';

  @override
  String get authHaveAccount => 'Masz już konto?';

  @override
  String get authGoLogin => 'Zaloguj się';

  @override
  String get authEmailVerificationUnavailable =>
      'Weryfikacja e-mail jest niedostępna. Zarejestruj się numerem telefonu.';

  @override
  String get authSmsVerificationUnavailable =>
      'Weryfikacja SMS jest niedostępna. Zarejestruj się adresem e-mail.';

  @override
  String get authSendFailed => 'Nie udało się wysłać. Spróbuj ponownie.';

  @override
  String get authErrorEmptyNickname => 'Wpisz pseudonim';

  @override
  String get authErrorInvalidMobile =>
      'Wpisz prawidłowy numer telefonu komórkowego';

  @override
  String get authErrorInvalidEmail => 'Wpisz prawidłowy adres e-mail';

  @override
  String get authErrorPasswordTooShort =>
      'Hasło musi zawierać co najmniej 6 znaków';

  @override
  String get authErrorPasswordMismatch => 'Hasła nie są zgodne';

  @override
  String get authErrorVerificationRequired =>
      'Najpierw pobierz i wpisz kod weryfikacyjny';

  @override
  String get authRegisterErrorTitle => 'Rejestracja nie powiodła się';

  @override
  String get authGotIt => 'Rozumiem';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Nie znaleziono firmy „$code”. Sprawdź kod firmy.';
  }

  @override
  String get authTenantSearchFailed =>
      'Wyszukiwanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get authInvitationInvalid =>
      'Kod zaproszenia jest nieprawidłowy. Sprawdź go i spróbuj ponownie.';

  @override
  String get authCollapseJoin => 'Ukryj informacje o dołączeniu';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Prawidłowe zaproszenie: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Znaleziono firmę: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Wybierz organizację';

  @override
  String get authNoOrganization => 'Brak dostępnych organizacji';

  @override
  String get authNoOrganizationHint =>
      'Poproś administratora o zaproszenie do organizacji';

  @override
  String get authPersonalSpace => 'Przestrzeń osobista';

  @override
  String get authPersonalSpaceSubtitle =>
      'Czaty ze znajomymi i osobiste ulubione';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Nie udało się zweryfikować tożsamości przestrzeni. Spróbuj ponownie.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Nie udało się przywrócić przestrzeni osobistej. Spróbuj ponownie.';

  @override
  String get authJoinEnterpriseFailed =>
      'Nie udało się dołączyć do firmy. Spróbuj później.';

  @override
  String get homeTitle => 'Wiadomości';

  @override
  String get homeGatewayConnectingTitle => 'Łączenie';

  @override
  String get homePersonalSpace => 'Osobiste';

  @override
  String get homeOfficialService => 'Oficjalna obsługa';

  @override
  String get homeSwitchSpace => 'Zmień przestrzeń';

  @override
  String get homeSpaceSubtitle => 'Osobista · Firmowa';

  @override
  String get homeJoinEnterprise => 'Dołącz do firmy';

  @override
  String get homeCreateGroup => 'Nowa grupa';

  @override
  String get homeAddFriend => 'Dodaj kontakt';

  @override
  String get homeScan => 'Skanuj';

  @override
  String get homeJoinNewSpace => 'Dołącz do nowej przestrzeni';

  @override
  String get homeSearchConversation => 'Szukaj';

  @override
  String get homeNoMessages => 'Brak wiadomości';

  @override
  String get homeDeleteConversation => 'Usuń czat';

  @override
  String get homeDeleteConversationConfirm =>
      'Usunąć ten czat? Historia czatu zostanie wyczyszczona.';

  @override
  String get homePersonalNote => 'Ja (notatki osobiste)';

  @override
  String get homeWorkNote => 'Ja (notatki służbowe)';

  @override
  String homeConversationCount(int count) {
    return '$count czatów';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count nieprzeczytanych';
  }

  @override
  String get chatInputHint => 'Napisz wiadomość...';

  @override
  String get chatVoiceHint => 'Przytrzymaj, aby mówić';

  @override
  String get chatVoiceRelease => 'Puść, aby wysłać';

  @override
  String get chatVoiceCancel => 'Przesuń w górę, aby anulować';

  @override
  String get chatMenuCopy => 'Kopiuj';

  @override
  String get chatMenuForward => 'Przekaż dalej';

  @override
  String get chatMenuRecall => 'Cofnij wiadomość';

  @override
  String get chatMenuDelete => 'Usuń';

  @override
  String get chatMenuFavorite => 'Zapisz';

  @override
  String get chatMenuReply => 'Odpowiedz';

  @override
  String get chatMenuMultiSelect => 'Wybierz';

  @override
  String get chatMenuTranslate => 'Przetłumacz';

  @override
  String get chatMenuVoiceToText => 'Zamień na tekst';

  @override
  String get chatMenuTextToSpeech => 'Czytaj na głos';

  @override
  String get chatStatusRecalled => 'Wiadomość cofnięta';

  @override
  String get chatRecallSuccess => 'Cofnięto';

  @override
  String get chatRecallFailed => 'Cofnięcie nie powiodło się';

  @override
  String get chatRecallTimeout =>
      'Nie można cofnąć wiadomości starszych niż 2 minuty';

  @override
  String get chatTranslateFailed =>
      'Tłumaczenie nie powiodło się. Spróbuj ponownie.';

  @override
  String get chatTranslateNotConfigured =>
      'Usługa tłumaczenia jest niedostępna';

  @override
  String get chatVoiceToTextFailed =>
      'Konwersja nie powiodła się. Spróbuj ponownie.';

  @override
  String get chatTextToSpeechFailed =>
      'Odczyt na głos nie powiódł się. Spróbuj ponownie.';

  @override
  String get chatVoiceToText => 'Zamień';

  @override
  String get chatForwardSuccess => 'Przekazano dalej';

  @override
  String get chatForwardFailed =>
      'Przekazanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get chatNoConversations => 'Brak czatów do przekazania';

  @override
  String get chatSendFailed => 'Wysyłanie nie powiodło się';

  @override
  String get chatResend => 'Wyślij kod ponownie';

  @override
  String get chatNotFriend => 'Nie ma na liście kontaktów';

  @override
  String get chatNotFriendHint =>
      'Nie jesteście jeszcze kontaktami. Nie można wysyłać wiadomości.';

  @override
  String get chatMutedHint => 'Wszyscy członkowie są wyciszeni';

  @override
  String get chatFileUploadFailed =>
      'Przesyłanie pliku nie powiodło się. Spróbuj ponownie.';

  @override
  String get chatFileStatusNotDownloaded => 'Nie pobrano';

  @override
  String get chatFileStatusDownloaded => 'Pobrano';

  @override
  String get chatFileStatusUploading => 'Przesyłanie';

  @override
  String get chatFileStatusUploadFailed => 'Przesyłanie nieudane';

  @override
  String get chatCardSendFailed => 'Wysyłanie wizytówki nie powiodło się';

  @override
  String get chatFavoriteSuccess => 'Zapisano';

  @override
  String get chatFavoriteFailed => 'Dodanie do ulubionych nie powiodło się';

  @override
  String get chatLoadFailed => 'Nie udało się załadować';

  @override
  String get chatImageMessage => '[Obraz]';

  @override
  String get chatVoiceMessage => '[Wiadomość głosowa]';

  @override
  String get chatVideoMessage => '[Wideo]';

  @override
  String get chatFileMessage => '[Plik]';

  @override
  String get chatLocationMessage => '[Lokalizacja]';

  @override
  String get chatContactCardMessage => '[Kontakt]';

  @override
  String get chatCallLogMessage => '[Połączenie]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Przeczytane przez $count';
  }

  @override
  String get chatUnread => 'Nieprzeczytane';

  @override
  String get chatRecalledSelf => 'Cofnięto twoją wiadomość';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender cofnął/cofnęła wiadomość';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Tłumaczenie: $translation';
  }

  @override
  String get chatMessageDeleted => 'Wiadomość usunięta';

  @override
  String get chatPeer => 'Inne';

  @override
  String get chatSelf => 'Ja';

  @override
  String get chatGenericMessage => '[Wiadomość]';

  @override
  String get chatVoiceHideText => 'Ukryj tekst';

  @override
  String get chatVoiceShowText => 'Zamień na tekst';

  @override
  String get chatFileDefaultName => 'Plik';

  @override
  String get chatContactDefaultName => 'Kontakt';

  @override
  String get chatContactCardTitle => 'Wizytówka';

  @override
  String get chatCallMissed => 'Nieodebrane';

  @override
  String get chatCallCancelled => 'Anulowano';

  @override
  String get chatCallRejected => 'Odrzucono';

  @override
  String get chatCallDisconnected => 'Rozłączono';

  @override
  String get chatCallEnded => 'Połączenie zakończone';

  @override
  String get chatCallFailed => 'Połączenie nie powiodło się';

  @override
  String chatCallDuration(String duration) {
    return 'Czas trwania $duration';
  }

  @override
  String get chatVideoCallTitle => 'Połączenie wideo';

  @override
  String get chatVoiceCallTitle => 'Połączenie głosowe';

  @override
  String get chatToolPhotos => 'Zdjęcia';

  @override
  String get chatToolCamera => 'Aparat';

  @override
  String get chatToolFile => 'Plik';

  @override
  String get chatToolLocation => 'Lokalizacja';

  @override
  String get chatToolContactCard => 'Kontakt';

  @override
  String get chatToolVoiceCall => 'Połączenie głosowe';

  @override
  String get chatToolVideoCall => 'Połączenie wideo';

  @override
  String get chatToolFavorites => 'Ulubione';

  @override
  String get chatToolTranslate => 'Przetłumacz';

  @override
  String get chatTranslationChooseLanguage => 'Wybierz język tłumaczenia';

  @override
  String get chatTranslationEnterText => 'Najpierw wpisz tekst';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Tłumaczenie jest niedostępne dla wiadomości ze wzmiankami';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Tłumaczenie jest niedostępne podczas edycji zaplanowanej wiadomości';

  @override
  String get chatTranslationFailed =>
      'Tłumaczenie nie powiodło się. Spróbuj ponownie.';

  @override
  String get chatTranslationEmpty =>
      'Nie zwrócono tłumaczenia. Spróbuj ponownie.';

  @override
  String get chatTranslationTranslating => 'Tłumaczenie…';

  @override
  String get chatTranslationSend => 'Wyślij tłumaczenie';

  @override
  String get chatTranslationSending => 'Wysyłanie…';

  @override
  String get chatTranslationExpand => 'Pokaż więcej';

  @override
  String get chatTranslationCollapse => 'Pokaż mniej';

  @override
  String get chatFileTooLarge => 'Plik przekracza limit (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Pisać może tylko właściciel lub wybrani członkowie.';

  @override
  String get chatImageUploadUnsupported =>
      'Przesłanie obrazu nie powiodło się. Serwer jeszcze nie obsługuje tej funkcji.';

  @override
  String get chatFavoriteLongPressHint =>
      'Przytrzymaj wiadomość, aby dodać ją do ulubionych';

  @override
  String chatSelectedCount(int count) {
    return 'Wybrano: $count';
  }

  @override
  String get chatLocationSheetTitle => 'Wyślij lokalizację';

  @override
  String get chatLocationNameLabel => 'Nazwa miejsca';

  @override
  String get chatLocationNameHint => 'np. biuro, adres klienta';

  @override
  String get chatLocationAddressLabel => 'Adres';

  @override
  String get chatLocationOptionalHint => 'Opcjonalnie';

  @override
  String get chatLocationLatitudeLabel => 'Szerokość geograficzna';

  @override
  String get chatLocationLatitudeHint => 'Od -90 do 90';

  @override
  String get chatLocationLongitudeLabel => 'Długość geograficzna';

  @override
  String get chatLocationLongitudeHint => 'Od -180 do 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Wpisz: $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return 'Wartość $label jest poza zakresem';
  }

  @override
  String get chatLocationDefaultTitle => 'Lokalizacja';

  @override
  String get chatMutedFullNotice =>
      'Ta grupa jest wyciszona. Pisać może tylko właściciel lub wybrani członkowie.';

  @override
  String get chatNotFriendSendBlocked =>
      'Nie jesteście już znajomymi i nie można wysyłać wiadomości';

  @override
  String get chatPersonalNotesTitle => 'Notatki osobiste';

  @override
  String get chatWorkNotesTitle => 'Notatki służbowe';

  @override
  String get chatPersonalNotesDescription =>
      'Zapisuj tu osobiste przemyślenia i ważne informacje\nSynchronizacja między urządzeniami zapewnia dostęp w dowolnej chwili';

  @override
  String get chatWorkNotesDescription =>
      'Zapisuj tu zadania i materiały służbowe\nPrzestrzenie zespołu pozostają oddzielne i bezpieczne';

  @override
  String get chatNoMessages => 'Brak wiadomości';

  @override
  String chatReplyTo(String sender) {
    return 'Odpowiedz użytkownikowi $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return 'Funkcja $feature będzie dostępna wkrótce';
  }

  @override
  String get chatForwardSelectTitle => 'Wybierz czat';

  @override
  String get chatContactSelectTitle => 'Wybierz kontakt';

  @override
  String get chatNoContacts => 'Brak kontaktów';

  @override
  String get contactsTitle => 'Kontakty';

  @override
  String get contactsSearch => 'Szukaj kontaktów';

  @override
  String get contactsNewFriends => 'Nowi znajomi';

  @override
  String get contactsGroups => 'Grupy';

  @override
  String get contactsFavorites => 'Ulubione';

  @override
  String get contactsRecent => 'Ostatnie';

  @override
  String get contactsOrganization => 'Organizacja';

  @override
  String get contactsAnnouncement => 'Ogłoszenia';

  @override
  String get contactsNewApplications => 'Nowe wnioski';

  @override
  String get contactsCustomerGroups => 'Grupy klientów';

  @override
  String get contactsAllCustomers => 'Wszyscy klienci';

  @override
  String get contactsMyCustomers => 'Moi klienci';

  @override
  String get contactsViewAll => 'Zobacz wszystko';

  @override
  String get contactsMyContacts => 'Moje kontakty';

  @override
  String get contactsMyAdvisor => 'Mój doradca';

  @override
  String get contactsNoAdvisor => 'Nie przypisano jeszcze doradcy';

  @override
  String get contactsAdvisorLoading => 'Wczytywanie...';

  @override
  String get contactsNavigateFailed =>
      'Przejście do strony nie powiodło się. Spróbuj ponownie.';

  @override
  String get contactsEmpty => 'Brak kontaktów';

  @override
  String get contactsNoAnnouncement => 'Brak ogłoszeń';

  @override
  String get contactsOfficialBadge => 'Oficjalne';

  @override
  String get contactsCustomerBadge => 'Klient';

  @override
  String get contactsEmptyCustomers => 'Brak klientów';

  @override
  String get myTitle => 'Ja';

  @override
  String get myEnterpriseInfo => 'Informacje o firmie';

  @override
  String get myEnterpriseManage => 'Zarządzanie firmą';

  @override
  String get myQrCode => 'Kod QR';

  @override
  String get myFavorites => 'Ulubione';

  @override
  String get myLanguage => 'Język';

  @override
  String get myTimezone => 'Strefa czasowa';

  @override
  String get myAutoTranslate => 'Automatyczne tłumaczenie';

  @override
  String get myNetworkSwitch => 'Zmień linię';

  @override
  String get mySettings => 'Ustawienia';

  @override
  String get myLogout => 'Wyloguj się';

  @override
  String get myLogoutConfirm => 'Czy na pewno chcesz się wylogować?';

  @override
  String get myLeaveEnterprise => 'Opuść firmę';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Czy na pewno chcesz opuścić tę firmę? Utracisz dostęp do danych firmy.';

  @override
  String get myLeaveEnterpriseSuccess => 'Opuszczono firmę';

  @override
  String get myLeaveEnterpriseFailed =>
      'Opuszczenie nie powiodło się. Spróbuj ponownie.';

  @override
  String get myLppIdCopied => 'Identyfikator StartLink skopiowany';

  @override
  String myLppIdLabel(String lppId) {
    return 'Identyfikator StartLink: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count kontaktów';
  }

  @override
  String get myAutoSelect => 'Automatycznie';

  @override
  String get myPresenceStatus => 'Dostępność';

  @override
  String get myPresenceStatusTitle => 'Ustaw dostępność';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Zajęty';

  @override
  String get myPresenceAway => 'Zaraz wracam';

  @override
  String get myPresenceInvisible => 'Niewidoczny';

  @override
  String get profileTitle => 'Mój profil';

  @override
  String get profileName => 'Imię';

  @override
  String get profileGender => 'Płeć';

  @override
  String get profileBirthday => 'Urodziny';

  @override
  String get profileRegion => 'Region';

  @override
  String get profileSignature => 'O mnie';

  @override
  String get profileSignatureHint => 'Napisz coś o sobie';

  @override
  String get profileTapTapText => 'Puknięcie';

  @override
  String get profileTapTapHint =>
      'Tekst wyświetlany po puknięciu (maks. 20 znaków)';

  @override
  String get profileAccountSection => 'Konto';

  @override
  String get profileBasicSection => 'Podstawowe informacje';

  @override
  String get profileLppId => 'Identyfikator StartLink';

  @override
  String get profileLppIdNotSet => 'Nie ustawiono';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Niepołączone';

  @override
  String get profileEmail => 'Adres e-mail';

  @override
  String get profileEmailUnbound => 'Niepołączone';

  @override
  String get profileQrCode => 'Mój kod QR';

  @override
  String get profileChangePassword => 'Zmień hasło';

  @override
  String get profileGenderMale => 'Mężczyzna';

  @override
  String get profileGenderFemale => 'Kobieta';

  @override
  String get profileGenderOther => 'Inne';

  @override
  String get profileGenderUnset => 'Nie ustawiono';

  @override
  String get profileSaveFailed =>
      'Zapisanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get profileLppIdTitle => 'Identyfikator StartLink';

  @override
  String get profileLppIdSetOnce =>
      'Identyfikator StartLink można zmienić tylko raz. Wybierz go uważnie.';

  @override
  String get profileLppIdChangeFailed =>
      'Zmiana nie powiodła się (identyfikator StartLink można zmienić tylko raz)';

  @override
  String get profileChangePasswordOld => 'Aktualne hasło';

  @override
  String get profileChangePasswordNew => 'Nowe hasło';

  @override
  String get profileChangePasswordConfirm => 'Powtórz nowe hasło';

  @override
  String get profileChangePasswordMismatch => 'Hasła nie są zgodne';

  @override
  String get profileChangePasswordSuccess =>
      'Hasło zmienione. Zaloguj się ponownie.';

  @override
  String get profileChangePasswordFailed =>
      'Zmiana hasła nie powiodła się. Spróbuj ponownie.';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsSectionEnterprise => 'Firma';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsSectionGeneral => 'Ogólne';

  @override
  String get settingsSectionFeatures => 'Funkcje';

  @override
  String get settingsSectionAbout => 'Informacje';

  @override
  String get settingsEnterpriseInfo => 'Informacje o firmie';

  @override
  String get settingsProfile => 'Mój profil';

  @override
  String get settingsAccountSecurity => 'Bezpieczeństwo konta';

  @override
  String get settingsNotification => 'Powiadomienia';

  @override
  String get settingsDisplay => 'Wyświetlanie';

  @override
  String get settingsFriendPrivacy => 'Prywatność';

  @override
  String get settingsChat => 'Czat';

  @override
  String get settingsChatHistory => 'Historia czatów';

  @override
  String get settingsAbout => 'O aplikacji StartLink';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get settingsTimezone => 'Strefa czasowa';

  @override
  String get settingsAutoTranslate => 'Automatyczne tłumaczenie';

  @override
  String get settingsNetworkSwitch => 'Zmień linię';

  @override
  String get enterpriseInfoTitle => 'Informacje o firmie';

  @override
  String get enterpriseName => 'Imię';

  @override
  String get enterpriseDescription => 'Opis';

  @override
  String get enterpriseUpdateSuccess => 'Zaktualizowano pomyślnie.';

  @override
  String get enterpriseUpdateFailed =>
      'Aktualizacja nie powiodła się. Spróbuj ponownie.';

  @override
  String get enterpriseLeave => 'Opuść firmę';

  @override
  String get enterpriseLeaveConfirm => 'Czy na pewno chcesz opuścić tę firmę?';

  @override
  String get enterpriseLeaveSuccess => 'Opuszczono firmę';

  @override
  String get enterpriseLeaveFailed =>
      'Opuszczenie nie powiodło się. Spróbuj ponownie.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Właściciel nie może opuścić firmy bezpośrednio. Najpierw przekaż własność.';

  @override
  String get enterpriseMemberCount => 'Członkowie';

  @override
  String get enterpriseCreatedAt => 'Utworzono';

  @override
  String get enterpriseCode => 'Kod firmy';

  @override
  String get enterpriseInviteMembers => 'Zaproś członków';

  @override
  String get enterpriseCopyInviteCode => 'Skopiuj kod zaproszenia';

  @override
  String get enterpriseInviteCodeCopied => 'Kod zaproszenia skopiowany';

  @override
  String get groupCreateTitle => 'Nowa grupa';

  @override
  String get groupNameHint => 'Wpisz nazwę grupy';

  @override
  String get groupCreateSuccess => 'Grupa utworzona';

  @override
  String get groupCreateFailed => 'Utworzenie grupy nie powiodło się';

  @override
  String get groupSettings => 'Ustawienia grupy';

  @override
  String get groupName => 'Nazwa grupy';

  @override
  String get groupAvatar => 'Obraz grupy';

  @override
  String get groupAnnouncement => 'Ogłoszenie';

  @override
  String get groupMembers => 'Członkowie';

  @override
  String get groupAddMember => 'Dodaj członków';

  @override
  String get groupRemoveMember => 'Usuń członka';

  @override
  String get groupRemoveMemberConfirm => 'Usunąć tego członka?';

  @override
  String get groupSetAdmin => 'Ustaw jako administratora';

  @override
  String get groupRemoveAdmin => 'Odbierz rolę administratora';

  @override
  String get groupTransferOwner => 'Przekaż własność';

  @override
  String get groupTransferOwnerConfirm =>
      'Przekazać własność grupy temu członkowi?';

  @override
  String get groupTransferOwnerSuccess => 'Własność przekazana';

  @override
  String get groupTransferOwnerFailed =>
      'Przekazanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get groupLeave => 'Opuść grupę';

  @override
  String get groupLeaveConfirm => 'Opuścić tę grupę?';

  @override
  String get groupLeaveSuccess => 'Opuszczono grupę';

  @override
  String get groupLeaveFailed =>
      'Opuszczenie nie powiodło się. Spróbuj ponownie.';

  @override
  String get groupDissolve => 'Rozwiąż grupę';

  @override
  String get groupDissolveConfirm =>
      'Rozwiązać tę grupę? Wszyscy członkowie zostaną usunięci.';

  @override
  String get groupDissolveSuccess => 'Grupa rozwiązana';

  @override
  String get groupDissolveFailed =>
      'Rozwiązanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get groupQrCode => 'Kod QR grupy';

  @override
  String get groupMuteAll => 'Wycisz wszystkich';

  @override
  String get groupMuteAllOn => 'Włącz wyciszenie wszystkich';

  @override
  String get groupMuteAllOff => 'Wyłącz wyciszenie wszystkich';

  @override
  String get groupAllowMemberInvite => 'Zezwól członkom zapraszać innych';

  @override
  String get groupAllowMemberModifyTitle =>
      'Zezwól członkom zmieniać nazwę grupy';

  @override
  String get groupAllowMemberAtAll => 'Zezwól członkom wspominać wszystkich';

  @override
  String get groupAllowMemberViewMemberList =>
      'Zezwól członkom przeglądać listę członków';

  @override
  String get groupAllowQrCodeJoin => 'Zezwól na dołączanie kodem QR';

  @override
  String get groupRequireApproval => 'Wymagaj zatwierdzenia dołączenia';

  @override
  String get groupAllowMemberAddFriend =>
      'Zezwól członkom dodawać się wzajemnie';

  @override
  String get groupRoleOwner => 'Właściciel';

  @override
  String get groupRoleAdmin => 'Administrator';

  @override
  String get groupRoleMember => 'Członek';

  @override
  String get groupNoMembers => 'Brak członków';

  @override
  String get groupNoAnnouncements => 'Brak ogłoszeń';

  @override
  String get groupCreateAnnouncement => 'Opublikuj ogłoszenie';

  @override
  String get groupEditAnnouncement => 'Edytuj ogłoszenie';

  @override
  String get groupDeleteAnnouncement => 'Usuń ogłoszenie';

  @override
  String get groupDeleteAnnouncementConfirm => 'Usunąć to ogłoszenie?';

  @override
  String get groupAnnouncementTitle => 'Tytuł';

  @override
  String get groupAnnouncementContent => 'Treść';

  @override
  String get groupAnnouncementPin => 'Przypnij ogłoszenie';

  @override
  String groupMemberCount(int count) {
    return '$count członków';
  }

  @override
  String groupSelectedCount(int count) {
    return 'Wybrano: $count';
  }

  @override
  String get groupJoinRequestApprove => 'Zgadzam się';

  @override
  String get groupJoinRequestReject => 'Odmów';

  @override
  String get groupJoinRequests => 'Prośby o dołączenie';

  @override
  String get groupNoJoinRequests => 'Brak próśb o dołączenie';

  @override
  String get groupReadReceipts => 'Potwierdzenia przeczytania';

  @override
  String groupReadCount(int count) {
    return 'Przeczytane: $count';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count nieprzeczytanych';
  }

  @override
  String get friendAddTitle => 'Dodaj kontakt';

  @override
  String get friendSearchHint => 'Telefon / e-mail / identyfikator StartLink';

  @override
  String get friendRequestSent => 'Zaproszenie do znajomych wysłane';

  @override
  String get friendRequestFailed =>
      'Wysłanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get friendAlreadyFriend => 'Jesteście już kontaktami';

  @override
  String get friendNewFriendsTitle => 'Nowi znajomi';

  @override
  String get friendNoRequests => 'Brak zaproszeń do znajomych';

  @override
  String get friendAccept => 'Zaakceptuj';

  @override
  String get friendReject => 'Odmów';

  @override
  String get friendAccepted => 'Zaakceptowano';

  @override
  String get friendRejected => 'Odrzucone';

  @override
  String get friendDeleteConfirm => 'Usunąć ten kontakt?';

  @override
  String get friendDeleteSuccess => 'Kontakt usunięty';

  @override
  String get friendDeleteFailed =>
      'Usunięcie nie powiodło się. Spróbuj ponownie.';

  @override
  String get friendRemarkName => 'Pseudonim';

  @override
  String get friendGroupName => 'Grupa';

  @override
  String get friendSendMessage => 'Wiadomość';

  @override
  String get friendMatchTypeLppId =>
      'Znaleziono według identyfikatora StartLink';

  @override
  String get friendMatchTypeMobile => 'Znaleziono według telefonu';

  @override
  String get friendMatchTypeEmail => 'Znaleziono według e-maila';

  @override
  String get friendSearchEmpty => 'Nie znaleziono użytkowników';

  @override
  String get friendAddMessage => 'Chcę dodać cię do kontaktów';

  @override
  String get friendBlockConfirm => 'Zablokować tego użytkownika?';

  @override
  String get friendUnblockConfirm => 'Odblokować tego użytkownika?';

  @override
  String get friendBlockSuccess => 'Zablokowano';

  @override
  String get friendUnblockSuccess => 'Odblokowano';

  @override
  String get profilePageTitle => 'Dane osobowe';

  @override
  String get profilePageSendMessage => 'Wiadomość';

  @override
  String get profilePageAddFriend => 'Dodaj znajomego';

  @override
  String get profilePageAlreadyFriend => 'Jesteście już znajomymi';

  @override
  String get profilePageBlocked => 'Zablokowano';

  @override
  String get profilePageBlock => 'Zablokuj';

  @override
  String get profilePageUnblock => 'Odblokuj';

  @override
  String get profilePageHidden => 'Ten użytkownik ukrył profil';

  @override
  String get profilePageFriendsOnly =>
      'Ten użytkownik pokazuje profil tylko znajomym';

  @override
  String get profilePageLppId => 'Identyfikator StartLink';

  @override
  String get profilePageRemarkName => 'Uwagi';

  @override
  String get profilePageEditRemark => 'Edytuj pseudonim';

  @override
  String get profilePageSaveRemarkSuccess => 'Pseudonim zapisany';

  @override
  String get profilePageSaveRemarkFailed =>
      'Zapisanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get searchTitle => 'Szukaj';

  @override
  String get searchHint =>
      'Szukaj według telefonu, e-maila lub identyfikatora StartLink';

  @override
  String get searchNoResults => 'Brak wyników';

  @override
  String get searchMessages => 'Wiadomości';

  @override
  String get searchUsers => 'Użytkownicy';

  @override
  String get searchFailed => 'Wyszukiwanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get scanTitle => 'Skanuj';

  @override
  String get scanFailed => 'Rozpoznawanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get scanInvalidQrCode => 'Nieprawidłowy kod QR';

  @override
  String get scanFlashOn => 'Włącz latarkę';

  @override
  String get scanFlashOff => 'Wyłącz latarkę';

  @override
  String get scanAlbum => 'Wybierz z albumu';

  @override
  String get favoritesTitle => 'Ulubione';

  @override
  String get favoritesEmpty => 'Nic jeszcze nie zapisano';

  @override
  String get favoritesAll => 'Wszystkie';

  @override
  String get favoritesText => 'Tekst';

  @override
  String get favoritesImage => 'Obrazy';

  @override
  String get favoritesVideo => 'Wideo';

  @override
  String get favoritesVoice => 'Wiadomości głosowe';

  @override
  String get favoritesFile => 'Pliki';

  @override
  String get favoritesOther => 'Inne';

  @override
  String get favoritesDeleteConfirm => 'Usunąć z ulubionych?';

  @override
  String get favoritesDeleteSuccess => 'Usunięto z zapisanych';

  @override
  String get favoritesDeleteFailed => 'Usunięcie nie powiodło się';

  @override
  String get favoritesOriginalRecalled => 'Wiadomość cofnięta';

  @override
  String get favoritesViewOriginal => 'Pokaż oryginał';

  @override
  String get favoritesSearchHint => 'Szukaj w ulubionych';

  @override
  String get favoritesNoResults => 'Brak pasujących ulubionych';

  @override
  String get noticeTitle => 'Ogłoszenia';

  @override
  String get noticeEmpty => 'Brak ogłoszeń';

  @override
  String get noticeDetail => 'Szczegóły ogłoszenia';

  @override
  String get noticePublishedAt => 'Opublikowano';

  @override
  String get noticePriorityNormal => 'Normalny';

  @override
  String get noticePriorityImportant => 'Ważne';

  @override
  String get noticePriorityUrgent => 'Pilne';

  @override
  String get organizationTitle => 'Organizacja';

  @override
  String get organizationEmpty => 'Brak informacji o dziale';

  @override
  String get organizationMembers => 'Członkowie';

  @override
  String get organizationDepartment => 'Dział';

  @override
  String get organizationPosition => 'Stanowisko';

  @override
  String get organizationLeader => 'Przełożony';

  @override
  String get qrCodeTitle => 'Mój kod QR';

  @override
  String get qrCodeSave => 'Zapisz do albumu';

  @override
  String get qrCodeShare => 'Udostępnij';

  @override
  String get qrCodeSaveSuccess => 'Zapisano do albumu';

  @override
  String get qrCodeSaveFailed =>
      'Zapisanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get qrCodeRefresh => 'Odśwież kod QR';

  @override
  String get qrCodeExpired => 'Kod QR wygasł. Odśwież go.';

  @override
  String get qrCodeScanToAdd => 'Zeskanuj, aby dodać mnie do kontaktów';

  @override
  String get spacePersonal => 'Osobiste';

  @override
  String get spaceEnterprise => 'Firma';

  @override
  String get spaceJoinByCode => 'Dołącz kodem firmy';

  @override
  String get spaceJoinByInvite => 'Dołącz kodem zaproszenia';

  @override
  String get spaceEnterCode => 'Wpisz kod firmy';

  @override
  String get spaceEnterInviteCode => 'Wpisz kod zaproszenia';

  @override
  String get spaceSearchEnterprise => 'Szukaj firmy';

  @override
  String get spaceJoinRequestSent =>
      'Prośba wysłana, oczekuje na zatwierdzenie';

  @override
  String get spaceJoinRequestPending => 'Oczekuje na zatwierdzenie';

  @override
  String get spaceJoinRequestApproved => 'Prośba zatwierdzona';

  @override
  String get spaceJoinRequestRejected => 'Prośba odrzucona';

  @override
  String get spaceAlreadyMember => 'Jesteś już członkiem';

  @override
  String get spaceAutoApproved => 'Zatwierdzono automatycznie. Witaj!';

  @override
  String get spacePendingApprovalHint =>
      'Rejestracja zakończona. Prośba o dołączenie została wysłana.';

  @override
  String get spaceNoSpaces => 'Brak przestrzeni';

  @override
  String get spaceInviteExpired => 'Kod zaproszenia wygasł';

  @override
  String get spaceInviteTargetMismatch =>
      'Ten kod zaproszenia nie jest przeznaczony dla twojego konta';

  @override
  String get spaceAcceptInviteSuccess => 'Dołączono do firmy';

  @override
  String get spaceAcceptInviteFailed =>
      'Dołączenie nie powiodło się. Spróbuj ponownie.';

  @override
  String get spaceTenantSelectTitle => 'Wybierz przestrzeń';

  @override
  String get spaceTenantSelectHint =>
      'Wybierz przestrzeń, do której chcesz wejść';

  @override
  String get spaceEnterPersonal => 'Wejdź do przestrzeni osobistej';

  @override
  String get spaceEnterEnterprise => 'Wejdź do przestrzeni firmowej';

  @override
  String get aboutTitle => 'O aplikacji StartLink';

  @override
  String get aboutVersion => 'Wersja';

  @override
  String get aboutTerms => 'Regulamin';

  @override
  String get aboutPrivacy => 'Polityka prywatności';

  @override
  String get aboutOpenSource => 'Licencje otwartego oprogramowania';

  @override
  String get aboutCheckUpdate => 'Sprawdź aktualizacje';

  @override
  String get aboutLatestVersion => 'Korzystasz z najnowszej wersji';

  @override
  String get aboutUpdateAvailable => 'Dostępna nowa wersja';

  @override
  String get aboutUpdateNow => 'Zaktualizuj teraz';

  @override
  String get aboutUpdateLater => 'Później';

  @override
  String get notificationTitle => 'Powiadomienia';

  @override
  String get notificationGlobalMute => 'Nie przeszkadzać';

  @override
  String get notificationSound => 'Dźwięk';

  @override
  String get notificationVibration => 'Wibracje';

  @override
  String get notificationPreview => 'Podgląd wiadomości';

  @override
  String get notificationDndStart => 'Początek trybu Nie przeszkadzać';

  @override
  String get notificationDndEnd => 'Koniec trybu Nie przeszkadzać';

  @override
  String get blacklistTitle => 'Na czarnej liście';

  @override
  String get blacklistEmpty => 'Brak zablokowanych użytkowników';

  @override
  String get blacklistRemove => 'Odblokuj';

  @override
  String get blacklistRemoveConfirm => 'Odblokować tego użytkownika?';

  @override
  String get feedbackTitle => 'Opinia';

  @override
  String get feedbackTypeComplaint => 'Skarga';

  @override
  String get feedbackTypeSuggestion => 'Sugestia';

  @override
  String get feedbackTypeBug => 'Zgłoszenie błędu';

  @override
  String get feedbackContent => 'Opis';

  @override
  String get feedbackContentHint => 'Opisz szczegółowo problem lub sugestię';

  @override
  String get feedbackContact => 'Kontakt (opcjonalnie)';

  @override
  String get feedbackSubmit => 'Wyślij';

  @override
  String get feedbackSuccess => 'Opinia wysłana. Dziękujemy!';

  @override
  String get feedbackFailed => 'Wysłanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get networkTitle => 'Zmień linię';

  @override
  String get networkAutoSelect => 'Automatycznie';

  @override
  String get networkManual => 'Ręcznie';

  @override
  String get timezoneTitle => 'Strefa czasowa';

  @override
  String get timezoneAuto => 'Zgodnie z systemem';

  @override
  String get autoTranslateTitle => 'Automatyczne tłumaczenie';

  @override
  String get autoTranslateEnabled => 'Włącz automatyczne tłumaczenie';

  @override
  String get autoTranslateLanguage => 'Język docelowy';

  @override
  String get displayTitle => 'Wyświetlanie';

  @override
  String get displayFontSize => 'Rozmiar czcionki';

  @override
  String get displayChatBackground => 'Tło czatu';

  @override
  String get displayDarkMode => 'Wygląd';

  @override
  String get displayDarkModeSystem => 'Zgodnie z systemem';

  @override
  String get displayDarkModeSystemHint =>
      'Automatycznie zmieniaj według ustawień systemu';

  @override
  String get displayDarkModeOff => 'Jasny';

  @override
  String get displayDarkModeOffHint => 'Zawsze używaj jasnego motywu';

  @override
  String get displayDarkModeOn => 'Ciemny';

  @override
  String get displayDarkModeOnHint => 'Zawsze używaj ciemnego motywu';

  @override
  String get chatSettingsTitle => 'Czat';

  @override
  String get chatHistoryTitle => 'Historia czatów';

  @override
  String get chatHistoryClear => 'Wyczyść całą historię';

  @override
  String get chatHistoryClearConfirm =>
      'Wyczyścić całą historię czatów? Tej czynności nie można cofnąć.';

  @override
  String get chatHistoryClearSuccess => 'Historia czatów wyczyszczona';

  @override
  String get accountSecurityTitle => 'Bezpieczeństwo konta';

  @override
  String get accountSecurityChangePassword => 'Zmień hasło';

  @override
  String get accountSecurityChangeMobile => 'Zmień numer telefonu';

  @override
  String get accountSecurityChangeEmail => 'Zmień e-mail';

  @override
  String get accountSecurityLoggedDevices => 'Zalogowane urządzenia';

  @override
  String get accountSecurityDeactivate => 'Dezaktywuj konto';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Po 7 dniach wszystkie dane zostaną trwale usunięte. Dezaktywować?';

  @override
  String get loggedDevicesTitle => 'Zalogowane urządzenia';

  @override
  String get loggedDevicesCurrent => 'To urządzenie';

  @override
  String get loggedDevicesRevoke => 'Wyloguj się';

  @override
  String get loggedDevicesRevokeConfirm => 'Wylogować się z tego urządzenia?';

  @override
  String get loggedDevicesRevokeSuccess => 'Wylogowano z urządzenia';

  @override
  String get loggedDevicesRevokeFailed => 'Nie powiodło się. Spróbuj ponownie.';

  @override
  String get loggedDevicesLastActive => 'Ostatnia aktywność';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Komputer';

  @override
  String get loggedDevicesTypeUnknown => 'Nieznane urządzenie';

  @override
  String get privacySettingsTitle => 'Prywatność';

  @override
  String get privacySearchableByMobile =>
      'Zezwól na wyszukiwanie według numeru telefonu';

  @override
  String get privacySearchableByLppId =>
      'Zezwól na wyszukiwanie według identyfikatora StartLink';

  @override
  String get privacyAllowFriendRequest => 'Zezwól na zaproszenia do znajomych';

  @override
  String get privacyProfileVisibility => 'Widoczność profilu';

  @override
  String get privacyEveryone => 'Wszyscy';

  @override
  String get privacyFriendsOfFriends => 'Znajomi znajomych';

  @override
  String get privacyNobody => 'Nikt';

  @override
  String get privacyFriendsOnly => 'Tylko znajomi';

  @override
  String get privacySaveSuccess => 'Ustawienia zapisane';

  @override
  String get privacySaveFailed =>
      'Zapisanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get fontSizeTitle => 'Rozmiar czcionki';

  @override
  String get fontSizeSmall => 'Mały';

  @override
  String get fontSizeNormal => 'Standardowy';

  @override
  String get fontSizeLarge => 'Duży';

  @override
  String get fontSizeExtraLarge => 'Ekstra duży';

  @override
  String get fontSizePreview => 'Podgląd';

  @override
  String get chatBackgroundTitle => 'Tło czatu';

  @override
  String get chatBackgroundDefault => 'Domyślne';

  @override
  String get chatBackgroundCustom => 'Własne';

  @override
  String get chatBackgroundReset => 'Przywróć domyślne';

  @override
  String get termsTitle => 'Regulamin';

  @override
  String get privacyPolicyTitle => 'Polityka prywatności';

  @override
  String get recentContactsTitle => 'Ostatnie';

  @override
  String get recentContactsEmpty => 'Brak ostatnich kontaktów';

  @override
  String get inviteFriendsTitle => 'Zaproś znajomych';

  @override
  String get inviteFriendsCopyLink => 'Skopiuj łącze zaproszenia';

  @override
  String get inviteFriendsLinkCopied => 'Łącze zaproszenia skopiowane';

  @override
  String get imageViewerTitle => 'Zdjęcie';

  @override
  String get imageViewerSave => 'Zapisz do albumu';

  @override
  String get imageViewerSaveSuccess => 'Zapisano do albumu';

  @override
  String get imageViewerSaveFailed =>
      'Zapisanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get customerServiceTitle => 'Centrum obsługi';

  @override
  String get customerServiceQueue => 'W kolejce';

  @override
  String get customerServiceActive => 'Aktywne';

  @override
  String get customerServiceClaim => 'Zaakceptuj';

  @override
  String get customerServiceTakeover => 'Przejmij';

  @override
  String get customerServiceClose => 'Zakończ obsługę';

  @override
  String get customerServiceCloseConfirm => 'Zakończyć tę sesję obsługi?';

  @override
  String get customerServiceNoQueue => 'Brak sesji w kolejce';

  @override
  String get customerServiceNoActive => 'Brak aktywnych sesji';

  @override
  String get customerServiceVisitor => 'Gość';

  @override
  String get customerServiceCustomer => 'Klient';

  @override
  String get customerServiceAssignedTo => 'Przypisano do';

  @override
  String get customerServiceTransferConversation => 'Przekaż czat';

  @override
  String get marketingToolbar => 'Narzędzia marketingowe';

  @override
  String get callIncoming => 'Połączenie przychodzące';

  @override
  String get callOutgoing => 'Połączenie wychodzące';

  @override
  String get callAccept => 'Zaakceptuj';

  @override
  String get callReject => 'Odmów';

  @override
  String get callHangup => 'Zakończ';

  @override
  String get callMissed => 'Połączenie nieodebrane';

  @override
  String get callDuration => 'Czas trwania';

  @override
  String get callAudio => 'Połączenie głosowe';

  @override
  String get callGeneric => 'Połączenie';

  @override
  String get callVideo => 'Połączenie wideo';

  @override
  String get callConnecting => 'Łączenie...';

  @override
  String get callRinging => 'Dzwoni...';

  @override
  String get callEnded => 'Połączenie zakończone';

  @override
  String get callFailed => 'Połączenie nie powiodło się';

  @override
  String get callRejected => 'Połączenie odrzucone';

  @override
  String get callTimeout => 'Brak odpowiedzi';

  @override
  String get callCancelled => 'Anulowano';

  @override
  String get callUnknownPeer => 'Nieznany';

  @override
  String get callVideoInvitation => 'Zaproszenie do rozmowy wideo';

  @override
  String get callAudioInvitation => 'Zaproszenie do rozmowy głosowej';

  @override
  String get callAnswerAudio => 'Odbierz głosowo';

  @override
  String get callAnswerVideo => 'Odbierz z wideo';

  @override
  String get callViewProfile => 'Zobacz profil';

  @override
  String get callOpeningCamera => 'Uruchamianie kamery...';

  @override
  String get callWaitingRemoteVideo => 'Oczekiwanie na wideo rozmówcy...';

  @override
  String get callCameraOff => 'Kamera wyłączona';

  @override
  String get callCameraOn => 'Kamera włączona';

  @override
  String get callMicrophoneOff => 'Mikrofon wyłączony';

  @override
  String get callMicrophoneOn => 'Mikrofon włączony';

  @override
  String get callSpeakerOff => 'Głośnik wyłączony';

  @override
  String get callSpeakerOn => 'Głośnik włączony';

  @override
  String get callVideoPermissionFailure =>
      'Nie udało się rozpocząć połączenia wideo. Sprawdź uprawnienia do kamery i mikrofonu i spróbuj ponownie.';

  @override
  String get callAudioPermissionFailure =>
      'Nie udało się rozpocząć połączenia głosowego. Sprawdź uprawnienie do mikrofonu i spróbuj ponownie.';

  @override
  String get callIncompleteIncoming =>
      'Dane połączenia przychodzącego są niepełne i nie można go odebrać.';

  @override
  String get callInProgress => 'W trakcie rozmowy';

  @override
  String get callCalling => 'Wybieranie numeru...';

  @override
  String callEndedMedia(String media) {
    return '$media zakończone';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media odrzucone';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media nieodebrane';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media anulowane';
  }

  @override
  String get callConnectionLost => 'Utracono połączenie';

  @override
  String get callAdminEnded => 'Połączenie zakończone przez administratora';

  @override
  String callFailedMedia(String media) {
    return '$media nie powiodło się';
  }

  @override
  String get callBusy => 'Rozmówca jest zajęty';

  @override
  String callDurationValue(String duration) {
    return 'Czas połączenia $duration';
  }

  @override
  String get callNotConnected => 'Nie połączono';

  @override
  String get callDialed => 'Wychodzące';

  @override
  String get callAnswered => 'Odebrano';

  @override
  String get callRejectedByPeer => 'Odrzucone przez rozmówcę';

  @override
  String get callRejectedBySelf => 'Odrzucone';

  @override
  String get callPeerDidNotAnswer => 'Rozmówca nie odpowiedział';

  @override
  String get callMissedIncoming => 'Nieodebrane połączenie przychodzące';

  @override
  String get callPeerCancelled => 'Anulowane przez rozmówcę';

  @override
  String get notificationNewMessageTitle => 'Nowa wiadomość StartLink';

  @override
  String get notificationOnlineServiceTitle => 'Nowa wiadomość obsługi klienta';

  @override
  String get notificationNewMessageBody => 'Otrzymano nową wiadomość';

  @override
  String get notificationImagePreview => 'Wysłano obraz';

  @override
  String get notificationVideoPreview => 'Wysłano wideo';

  @override
  String get notificationVoicePreview => 'Wysłano wiadomość głosową';

  @override
  String get notificationFilePreview => 'Wysłano plik';

  @override
  String get notificationContactPreview => 'Wysłano wizytówkę';

  @override
  String get notificationCallLogPreview => 'Wysłano zapis połączenia';

  @override
  String get notificationLocationPreview => 'Udostępniono lokalizację';

  @override
  String get notificationLinkPreview => 'Udostępniono łącze';

  @override
  String notificationMentionMe(String body) {
    return 'Wspomniano o tobie: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender wspomina o tobie: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Wspomniano wszystkich: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender wspomina wszystkich: $body';
  }

  @override
  String get notificationSecurityTitle => 'Alert bezpieczeństwa konta';

  @override
  String get notificationSecurityBody =>
      'Ustawienia bezpieczeństwa konta StartLink zmieniły się. Sprawdź je teraz.';

  @override
  String get notificationFriendAcceptedTitle =>
      'Zaproszenie do znajomych przyjęte';

  @override
  String get notificationFriendRejectedTitle =>
      'Zaproszenie do znajomych odrzucone';

  @override
  String get notificationFriendAcceptedBody =>
      'Rozmówca przyjął twoje zaproszenie do znajomych';

  @override
  String get notificationFriendRejectedBody =>
      'Rozmówca odrzucił twoje zaproszenie do znajomych';

  @override
  String get notificationVideoCallTitle => 'Zaproszenie do rozmowy wideo';

  @override
  String get notificationAudioCallTitle =>
      'Zaproszenie do połączenia głosowego';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller zaprasza cię do połączenia wideo';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller zaprasza cię do połączenia głosowego';
  }

  @override
  String get notificationMessageChannelName => 'Wiadomości';

  @override
  String get notificationMessageChannelDescription =>
      'Wiadomości czatu, zapisy połączeń i alerty systemowe';

  @override
  String get notificationCallChannelName => 'Połączenia';

  @override
  String get notificationCallChannelDescription =>
      'Alerty połączeń głosowych i wideo';

  @override
  String get notificationSecurityChannelName => 'Bezpieczeństwo konta';

  @override
  String get notificationSecurityChannelDescription =>
      'Alerty logowania oraz zmian hasła i numeru telefonu';

  @override
  String get notificationUnknownCaller => 'Nieznany rozmówca';

  @override
  String get pendingJoinRequestsTitle => 'Nowe wnioski';

  @override
  String get pendingJoinRequestsEmpty => 'Brak wniosków';

  @override
  String get pendingJoinRequestApprove => 'Zgadzam się';

  @override
  String get pendingJoinRequestReject => 'Odmów';

  @override
  String get pendingJoinRequestApproveSuccess => 'Zatwierdzono';

  @override
  String get pendingJoinRequestRejectSuccess => 'Odrzucono';

  @override
  String get pendingJoinRequestFailed =>
      'Operacja nie powiodła się. Spróbuj ponownie.';

  @override
  String get myCustomersTitle => 'Moi klienci';

  @override
  String get myCustomersEmpty => 'Brak klientów';

  @override
  String get groupListTitle => 'Grupy';

  @override
  String get groupListEmpty => 'Brak grup';

  @override
  String get addFriendTitle => 'Dodaj kontakt';

  @override
  String get addFriendSearchHint =>
      'Telefon / e-mail / identyfikator StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'Identyfikator StartLink: $lppId';
  }

  @override
  String get addFriendButton => 'Dodaj';

  @override
  String get addFriendCannotAddSelf => 'Nie możesz dodać siebie';

  @override
  String get addFriendUnsupportedUser =>
      'Nie można dodać tego użytkownika. Możesz napisać do niego bezpośrednio.';

  @override
  String get addFriendMessageHint => 'Wpisz wiadomość';

  @override
  String get addFriendSendRequest => 'Wyślij prośbę';

  @override
  String get joinCompanyTitle => 'Dołącz do firmy';

  @override
  String get joinCompanyCodeHint => 'Wpisz kod firmy';

  @override
  String get joinCompanySearchHint => 'Szukaj nazwy firmy';

  @override
  String get joinCompanyApply => 'Poproś o dołączenie';

  @override
  String get joinCompanyApplySuccess => 'Wniosek wysłany';

  @override
  String get joinCompanyApplyFailed =>
      'Wysłanie wniosku nie powiodło się. Spróbuj ponownie.';

  @override
  String get joinCompanyAutoApproved => 'Zatwierdzono automatycznie. Witaj!';

  @override
  String get joinCompanyPending => 'Wniosek wysłany, oczekuje na zatwierdzenie';

  @override
  String get joinCompanyInviteCodeHint => 'Wpisz kod zaproszenia';

  @override
  String get joinCompanyAcceptInvite => 'Przyjmij zaproszenie';

  @override
  String get joinCompanyNoResults => 'Nie znaleziono firm';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count członków';
  }

  @override
  String get timezoneNameHawaii => 'Hawaje';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Czas pacyficzny';

  @override
  String get timezoneNameMountainTime => 'Czas górski';

  @override
  String get timezoneNameCentralTime => 'Czas centralny';

  @override
  String get timezoneNameEasternTime => 'Czas wschodni';

  @override
  String get timezoneNameAtlanticTime => 'Czas atlantycki';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Azory';

  @override
  String get timezoneNameLondonDublin => 'Londyn/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paryż/Rzym';

  @override
  String get timezoneNameCairoHelsinki => 'Kair/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskwa/Rijad';

  @override
  String get timezoneNameTehran => 'Teheran';

  @override
  String get timezoneNameDubaiBaku => 'Dubaj/Baku';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karaczi/Taszkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbaj/Nowe Delhi';

  @override
  String get timezoneNameKathmandu => 'Katmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dhaka/Ałmaty';

  @override
  String get timezoneNameYangon => 'Rangun';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoi/Dżakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Pekin/Szanghaj/Hongkong/Tajpej';

  @override
  String get timezoneNameTokyoSeoul => 'Tokio/Seul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Wyspy Salomona';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fidżi';

  @override
  String get networkSmartSelectBestRoute =>
      'Inteligentny wybór najlepszej trasy';

  @override
  String get networkTesting => 'Testowanie...';

  @override
  String get networkTestingShort => 'Testowanie';

  @override
  String networkLatencyMs(int ms) {
    return 'Opóźnienie $ms ms';
  }

  @override
  String get networkConnectionMode => 'Tryb połączenia';

  @override
  String get networkDirectMode => 'Tryb bezpośredni';

  @override
  String get networkProxyMode => 'Tryb proxy';

  @override
  String get networkDirectModeDesc => 'Połącz bezpośrednio z serwerem';

  @override
  String get networkProxyModeDesc => 'Połącz przez serwer proxy';

  @override
  String get networkDirectRoutes => 'Trasy bezpośrednie';

  @override
  String get networkProxyRoutes => 'Trasy proxy';

  @override
  String get networkTestAll => 'Przetestuj wszystkie';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Węzeł w Hongkongu';

  @override
  String get networkSingaporeNode => 'Węzeł w Singapurze';

  @override
  String get networkJapanNode => 'Węzeł w Japonii';

  @override
  String get networkUnitedStatesNode => 'Węzeł w Stanach Zjednoczonych';

  @override
  String get networkHint =>
      'Wskazówki:\n• Tryb bezpośredni: szybszy i odpowiedni do użytku krajowego\n• Tryb proxy: stabilniejszy w komunikacji międzynarodowej\n• Naciśnij ikonę odświeżania, aby sprawdzić opóźnienie jednej trasy';

  @override
  String get teenModeTitle => 'Tryb dla nastolatków';

  @override
  String get teenModeStatusOn => 'Włączone';

  @override
  String get teenModeStatusOff => 'Wyłączone';

  @override
  String get teenModeStatusLoading => 'Wczytywanie';

  @override
  String get teenModeUnavailable =>
      'Status trybu dla nastolatków jest tymczasowo niedostępny';

  @override
  String get teenModeInvalidResponse =>
      'Tryb dla nastolatków zwrócił nieprawidłową odpowiedź';

  @override
  String get teenModeEnableDescription =>
      'Reguły platformy ograniczą czas używania i wybrane funkcje.';

  @override
  String get teenModePasscode => 'Kod dostępu';

  @override
  String get teenModeCurrentPasscode => 'Aktualny kod dostępu';

  @override
  String get teenModeNewPasscode => 'Nowy kod dostępu';

  @override
  String get teenModePasscodeHint => 'Wpisz 4–6 cyfr';

  @override
  String get teenModeEnable => 'Włącz tryb dla nastolatków';

  @override
  String get teenModeDisable => 'Wyłącz tryb dla nastolatków';

  @override
  String get teenModeChangePasscode => 'Zmień kod dostępu';

  @override
  String get teenModeSource => 'Włączone przez';

  @override
  String get teenModeDailyUsage => 'Dzisiejsze użycie';

  @override
  String get teenModeRemaining => 'Pozostały czas';

  @override
  String get teenModeMinutesUnit => 'Minuty';

  @override
  String get teenModeUnlimited => 'Bez limitu';

  @override
  String get teenModeRequestExtension => 'Poproś o dodatkowy czas';

  @override
  String get teenModeExtensionSubmitted =>
      'Prośba o czas została wysłana do opiekuna';

  @override
  String get teenModeTimeLimitReached => 'Osiągnięto dzisiejszy limit używania';

  @override
  String get teenModeCurfewActive =>
      'Teraz obowiązuje ograniczenie czasu używania';

  @override
  String get teenModeReliefHint =>
      'Nadal możesz przeglądać historię, kontaktować się z oficjalną obsługą i zgłaszać problemy.';

  @override
  String get teenModeRestrictedNotice =>
      'Tryb dla nastolatków blokuje teraz wysyłanie wiadomości';

  @override
  String get teenModeActionBlocked =>
      'Tryb dla nastolatków blokuje teraz tę czynność';

  @override
  String get teenModeMyRequests => 'Moje prośby';

  @override
  String get guardianCenterTitle => 'Centrum opiekuna';

  @override
  String get guardianRelationships => 'Powiązania opiekuńcze';

  @override
  String get guardianMinors => 'Dzieci pod moją opieką';

  @override
  String get guardianApprovals => 'Oczekujące zatwierdzenia';

  @override
  String get guardianBind => 'Wpisz kod powiązania';

  @override
  String get guardianCreateMinorCode => 'Jestem dzieckiem — utwórz kod';

  @override
  String get guardianCreateGuardianCode => 'Jestem opiekunem — utwórz kod';

  @override
  String get guardianRelation => 'Powiązanie';

  @override
  String get guardianPrimary => 'Główny opiekun';

  @override
  String get guardianCode => 'Sześciocyfrowy kod powiązania';

  @override
  String get guardianCodeHint => 'Wpisz kod od drugiej osoby';

  @override
  String get guardianCodeCreated =>
      'Kod utworzony. Udostępnij go przed wygaśnięciem.';

  @override
  String get guardianEmpty => 'Brak powiązań opiekuńczych';

  @override
  String get guardianNoMinors => 'Brak dzieci pod opieką';

  @override
  String get guardianUnbind => 'Usuń powiązanie';

  @override
  String get guardianExtend => 'Dodaj dziecku czas';

  @override
  String get guardianPolicyTitle => 'Zasady używania';

  @override
  String get guardianPolicyLocked => 'Zablokowane przez platformę';

  @override
  String get approvalEmpty => 'Brak próśb';

  @override
  String get approvalApprove => 'Zgadzam się';

  @override
  String get approvalReject => 'Odmów';

  @override
  String get approvalPending => 'Oczekujące';

  @override
  String get approvalApproved => 'Zatwierdzono';

  @override
  String get approvalRejected => 'Odrzucone';

  @override
  String get approvalExpired => 'Wygasłe';

  @override
  String get approvalCancelled => 'Anulowane';

  @override
  String get approvalReplayFailed =>
      'Pierwotna czynność nie powiodła się. Spróbuj ponownie.';

  @override
  String get requestCancelled => 'Prośba anulowana';

  @override
  String get kycTitle => 'Weryfikacja tożsamości';

  @override
  String get kycNotRequired => 'Weryfikacja tożsamości nie jest wymagana';

  @override
  String get kycVerified => 'Tożsamość zweryfikowana';

  @override
  String get kycDeclared => 'Dane tożsamości wysłane';

  @override
  String get kycPending => 'W trakcie weryfikacji';

  @override
  String get kycRejected => 'Weryfikacja odrzucona';

  @override
  String get kycNone => 'Nie przesłano danych tożsamości';

  @override
  String get kycRealName => 'Imię i nazwisko';

  @override
  String get kycIdNumber => 'Numer dokumentu';

  @override
  String get kycIdType => 'Typ dokumentu';

  @override
  String get kycApplicability =>
      'Wpisz prawdziwe dane wybranego dokumentu. Akceptowane typy są na liście.';

  @override
  String get kycCamera => 'Zrób zdjęcie';

  @override
  String get kycGallery => 'Wybierz z albumu';

  @override
  String get kycPhotoLimit => 'Maksimum na zdjęcie';

  @override
  String get kycSelectPhoto => 'Wybierz zdjęcie';

  @override
  String get kycPhotoSelected => 'Wybrano';

  @override
  String get kycViewPhoto => 'Naciśnij, aby zobaczyć zdjęcie';

  @override
  String get kycReplacePhoto => 'Wybierz inne zdjęcie';

  @override
  String get kycDisclosure =>
      'Używamy imienia i nazwiska, numeru dokumentu oraz jego zdjęć do weryfikacji tożsamości. Bez nich nie można wysłać wniosku, a niektóre ograniczone funkcje mogą być niedostępne.';

  @override
  String get kycConsent =>
      'Wyrażam osobną zgodę na to przetwarzanie danych tożsamości';

  @override
  String get kycConsentRequired => 'Przed wysłaniem wyraź osobną zgodę';

  @override
  String get kycResubmitTitle => 'Prześlij ponownie dane tożsamości';

  @override
  String get kycResubmitWarning =>
      'Ponowne przesłanie zastąpi oczekujący wniosek. Kontynuować?';

  @override
  String get kycSubmitting => 'Wysyłanie';

  @override
  String get kycSubmitFailed => 'Wysłanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get kycSubmitUnavailable => 'Nie można teraz wysłać danych tożsamości';

  @override
  String get kycResubmitNotAllowed =>
      'Po odrzuceniu ponowne przesłanie jest niedostępne. W razie potrzeby skontaktuj się z obsługą.';

  @override
  String get kycDailyLimit =>
      'Osiągnięto dzisiejszy limit zgłoszeń. Spróbuj jutro.';

  @override
  String get kycTypeUnavailable =>
      'Brak dostępnych typów dokumentów. Spróbuj później.';

  @override
  String get kycNameInvalid => 'Imię i nazwisko musi mieć 2–64 znaki';

  @override
  String get kycNumberRequired => 'Wpisz numer dokumentu';

  @override
  String get kycFrontRequired => 'Prześlij przód dokumentu';

  @override
  String get kycBackRequired => 'Prześlij tył dokumentu';

  @override
  String get kycPhotoTooLarge =>
      'Zdjęcie przekracza limit rozmiaru. Zmniejsz je i spróbuj ponownie.';

  @override
  String get kycAccountChanged =>
      'Konto lub przestrzeń zmieniły się. Otwórz tę stronę ponownie.';

  @override
  String get kycPhotoInvalid => 'Wybierz prawidłowy obraz';

  @override
  String get kycPortraitSide => 'Strona ze zdjęciem';

  @override
  String get kycEmblemSide => 'Tył dowodu';

  @override
  String get kycPassportDataPage => 'Strona danych paszportu';

  @override
  String get kycPassportOtherPage => 'Strona wizowa lub wolna strona paszportu';

  @override
  String get kycFront => 'Przód dowodu';

  @override
  String get kycBack => 'Tył dowodu';

  @override
  String get kycRequired =>
      'Przed utworzeniem grupy wymagana jest weryfikacja tożsamości';

  @override
  String get kycGoVerify => 'Zweryfikuj teraz';

  @override
  String get kycStatusUnknown =>
      'Status tożsamości jest niedostępny. Odśwież później.';

  @override
  String get kycSuperseded =>
      'Późniejsze zgłoszenie zastąpiło to. Sprawdź najnowszy status tożsamości.';

  @override
  String get kycMediaNotFound =>
      'Zdjęcie dokumentu jest niedostępne w tej przestrzeni. Przed wysłaniem wybierz je ponownie.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Wiadomości masowe do klientów';

  @override
  String get officialAccountBadge => 'Oficjalne';

  @override
  String get officialAccountOpenConversation => 'Otwórz konwersację';

  @override
  String get officialAccountJoinHint =>
      'Dodanie tego konta dołącza cię do firmy jako klienta. Zatwierdzenie znajomości nie jest potrzebne.';

  @override
  String get officialAccountJoinDisabled =>
      'Ta firma nie przyjmuje nowych klientów. Skontaktuj się z obsługą.';

  @override
  String get officialAccountRemoved =>
      'Usunięto cię z tej firmy. Poproś firmę o ponowne zaproszenie.';

  @override
  String get officialAccountBanned =>
      'Twoje konto zostało wyłączone w tej firmie.';

  @override
  String get officialAccountUnavailable =>
      'To konto oficjalne jest teraz niedostępne.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'W aktualnym trybie nie można dołączać do firmy.';

  @override
  String get officialAccountPlatformRequired =>
      'Użyj konta platformy, aby dodać to konto oficjalne.';

  @override
  String get officialAccountOpenFailed =>
      'Nie udało się otworzyć konwersacji. Spróbuj ponownie.';

  @override
  String get officialAccountAccountChanged =>
      'Konto lub przestrzeń zmieniły się. Otwórz ponownie.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Katalog firm jest nieaktualny. Spróbuj za chwilę.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Synchronizacja konta oficjalnego nie powiodła się. Dane lokalne są nadal dostępne.';

  @override
  String get officialAccountInboxSyncing =>
      'Synchronizowanie wiadomości konta oficjalnego';

  @override
  String get diagnosticsTitle => 'Diagnostyka';

  @override
  String get diagnosticsExplanation =>
      'Dzienniki są zanonimizowane i zawierają informacje operacyjne i o błędach tego konta i przestrzeni oraz publiczne zdarzenia uruchomienia. Treść czatów i dane logowania są wykluczone.';

  @override
  String get diagnosticsHour => 'Ostatnia godzina';

  @override
  String get diagnosticsDay => 'Ostatnie 24 godziny';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Dostępne zdarzenia: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Dzienniki są zapisywane na tym urządzeniu i pozostają dostępne po ponownym uruchomieniu.';

  @override
  String get diagnosticsNotPersistent =>
      'Niektórych dzienników nie zapisano. Odśwież, aby ponowić próbę.';

  @override
  String get diagnosticsExport => 'Eksportuj i udostępnij';

  @override
  String get diagnosticsRefresh => 'Odśwież';

  @override
  String get diagnosticsClear => 'Wyczyść dzienniki tej przestrzeni';

  @override
  String get diagnosticsClearConfirm =>
      'Wyczyścić dzienniki diagnostyczne tej przestrzeni? Historia czatów zostanie zachowana.';

  @override
  String get diagnosticsShared =>
      'Udostępnianie systemowe zakończone. Sprawdź plik w aplikacji odbiorczej.';

  @override
  String get diagnosticsCancelled =>
      'Udostępnianie anulowane. Możesz eksportować ponownie.';

  @override
  String get diagnosticsUnconfirmed =>
      'Nie udało się potwierdzić udostępnienia. Sprawdź aplikację odbiorczą.';

  @override
  String get diagnosticsFailed =>
      'Operacja nie powiodła się. Spróbuj ponownie.';
}
