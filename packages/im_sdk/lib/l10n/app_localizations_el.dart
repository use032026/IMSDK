// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get navWorkbench => 'Χώρος εργασίας';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Αποτυχία φόρτωσης δεδομένων λογαριασμού';

  @override
  String get startupFailureTitle => 'Αποτυχία εκκίνησης';

  @override
  String get startupFailureMessage => 'Ελέγξτε το δίκτυο και δοκιμάστε ξανά';

  @override
  String get privacyConsentTitle => 'Όροι Χρήσης & Πολιτική Απορρήτου';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Καλώς ήρθατε στο $brand. Για να παρέχουμε σύνδεση λογαριασμού, άμεσα μηνύματα, εταιρική συνεργασία, ηλεκτρονική εξυπηρέτηση πελατών, ειδοποιήσεις μηνυμάτων και προστασία ασφάλειας, πρέπει να επεξεργαζόμαστε τις απαραίτητες πληροφορίες σύμφωνα με τους Όρους χρήσης και την Πολιτική απορρήτου.\n\nΠριν πατήσετε Αποδοχή, δεν διαβάζουμε το πρόχειρο, δεν αρχικοποιούμε το JPush/JCore ή τα SDK ειδοποιήσεων των κατασκευαστών συσκευών και δεν χρησιμοποιούμε αυτά τα SDK για πρόσβαση σε Android ID, OAID, λίστες εγκατεστημένων εφαρμογών, διευθύνσεις MAC ή παρόμοιες πληροφορίες. Αν προς το παρόν αρνηθείτε, θα αποθηκεύσουμε την επιλογή σας· μπορείτε να συνεχίσετε να διαβάζετε τα έγγραφα και να αποφασίσετε ξανά αργότερα.\n\nΜετά τη συγκατάθεσή σας, για την παράδοση ειδοποιήσεων μηνυμάτων, εξυπηρέτησης πελατών και εισερχόμενων κλήσεων, το JPush/JCore και οι υπηρεσίες push των κατασκευαστών μπορεί να επεξεργάζονται μοντέλο συσκευής, έκδοση Android, όνομα πακέτου και έκδοση εφαρμογής, τύπο δικτύου, διεύθυνση IP, Android ID, OAID, Registration ID, διακριτικό push του κατασκευαστή και στοιχεία παράδοσης και πατήματος ειδοποιήσεων. Έχουμε απενεργοποιήσει μη απαραίτητες δυνατότητες, όπως έξυπνες ειδοποιήσεις, λίστες εγκατεστημένων εφαρμογών, MAC, IMEI, IMSI, λίστες Wi-Fi, αυτόματη αφύπνιση και συνδεδεμένη εκκίνηση.\n\nΤο πρόχειρο προσπελαύνεται μόνο όταν χρησιμοποιείτε αντιγραφή ή επικόλληση. Δικαιώματα κάμερας, μικροφώνου, ειδοποιήσεων και άλλα δικαιώματα συστήματος ζητούνται μόνο όταν χρησιμοποιείτε τη σχετική λειτουργία. Η άρνηση ενός δικαιώματος επηρεάζει μόνο εκείνη τη λειτουργία. Διαβάστε τα πλήρη έγγραφα παρακάτω και επιλέξτε αν συμφωνείτε.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Καλώς ήρθατε στο $brand. Για να παρέχουμε σύνδεση λογαριασμού, άμεσα μηνύματα, εταιρική συνεργασία, ηλεκτρονική εξυπηρέτηση πελατών, ειδοποιήσεις μηνυμάτων και προστασία ασφάλειας, πρέπει να επεξεργαζόμαστε τις απαραίτητες πληροφορίες σύμφωνα με τους Όρους χρήσης και την Πολιτική απορρήτου.\n\nΠριν πατήσετε Αποδοχή, δεν διαβάζουμε το πρόχειρο, δεν αρχικοποιούμε το JPush/JCore, δεν εγγραφόμαστε στην υπηρεσία Apple Push Notification service (APNs) και δεν λαμβάνουμε αναγνωριστικά push όπως JPush Registration ID ή διακριτικό συσκευής APNs. Αν προς το παρόν αρνηθείτε, θα αποθηκεύσουμε την επιλογή σας· μπορείτε να συνεχίσετε να διαβάζετε τα έγγραφα και να αποφασίσετε ξανά αργότερα.\n\nΜετά τη συγκατάθεσή σας, για την παράδοση ειδοποιήσεων μηνυμάτων, εξυπηρέτησης πελατών και εισερχόμενων κλήσεων, μπορεί να επεξεργαζόμαστε μοντέλο iPhone, έκδοση iOS, όνομα πακέτου και έκδοση εφαρμογής, τύπο δικτύου, διεύθυνση IP, IDFV, JPush Registration ID, διακριτικό συσκευής APNs και στοιχεία παράδοσης και πατήματος ειδοποιήσεων. Το JPush/JCore συνδέεται με την υπηρεσία push· το Apple APNs επεξεργάζεται το αναγνωριστικό εφαρμογής, το διακριτικό συσκευής και το περιεχόμενο ειδοποίησης για την παράδοση ειδοποιήσεων συστήματος. Η τρέχουσα εφαρμογή iOS δεν χρησιμοποιεί διαφημιστικές υπηρεσίες ούτε λαμβάνει IDFA.\n\nΤο πρόχειρο προσπελαύνεται μόνο όταν χρησιμοποιείτε αντιγραφή ή επικόλληση. Δικαιώματα κάμερας, μικροφώνου, ειδοποιήσεων και άλλα δικαιώματα συστήματος ζητούνται μόνο όταν χρησιμοποιείτε τη σχετική λειτουργία. Η άρνηση ενός δικαιώματος επηρεάζει μόνο εκείνη τη λειτουργία. Διαβάστε τα πλήρη έγγραφα παρακάτω και επιλέξτε αν συμφωνείτε.';
  }

  @override
  String get privacyConsentTermsLink => 'Συμφωνία Χρήσης';

  @override
  String get privacyConsentConjunction => 'και';

  @override
  String get privacyConsentPrivacyLink => 'Πολιτική Απορρήτου';

  @override
  String get privacyConsentDecline => 'Διαφωνώ';

  @override
  String get privacyConsentDeclinedExit =>
      'Δεν αποδεχτήκατε τους Όρους χρήσης και την Πολιτική απορρήτου. Η εφαρμογή θα κλείσει.';

  @override
  String get privacyConsentAccept => 'Συμφωνώ';

  @override
  String get privacyConsentRuntimeFailure =>
      'Αποτυχία εκκίνησης. Ελέγξτε το δίκτυο και δοκιμάστε ξανά.';

  @override
  String get privacyConsentSaveFailure =>
      'Δεν αποθηκεύτηκε η επιλογή σας. Δοκιμάστε ξανά.';

  @override
  String get appUpdateRequiredTitle => 'Απαιτείται ενημέρωση για συνέχεια';

  @override
  String get appUpdateOptionalTitle => 'Νέα έκδοση διαθέσιμη';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Το $brand $version είναι διαθέσιμο';
  }

  @override
  String get appUpdateLater => 'Αργότερα';

  @override
  String get appUpdateNow => 'Ενημέρωση Τώρα';

  @override
  String get appUpdateProcessing => 'Επεξεργασία...';

  @override
  String get appUpdateInvalidUrl =>
      'Η διεύθυνση ενημέρωσης δεν είναι έγκυρη. Δοκιμάστε αργότερα.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Δεν άνοιξε ο σύνδεσμος ενημέρωσης. Δοκιμάστε αργότερα.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Η λήψη διακόπηκε. Ελέγξτε το δίκτυο και δοκιμάστε ξανά.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Απέτυχε η επαλήθευση πακέτου. Κάντε ξανά λήψη.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Επιτρέψτε στο $brand να εγκαθιστά ενημερώσεις στις ρυθμίσεις συστήματος.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Δεν άνοιξε το πρόγραμμα εγκατάστασης συστήματος. Ελέγξτε τα δικαιώματα εγκατάστασης.';

  @override
  String get appUpdateGenericFailure =>
      'Αποτυχία ενημέρωσης. Ελέγξτε το δίκτυο και δοκιμάστε ξανά.';

  @override
  String get appUpdateUnavailable =>
      'Η νέα έκδοση δεν είναι ακόμη διαθέσιμη για λήψη. Δοκιμάστε αργότερα.';

  @override
  String get appUpdateCheckFailed =>
      'Δεν έγινε έλεγχος ενημερώσεων. Δοκιμάστε αργότερα.';

  @override
  String get appUpdateChecking => 'Έλεγχος';

  @override
  String get commonConfirm => 'Εντάξει';

  @override
  String get commonCancel => 'Ακύρωση';

  @override
  String get commonSave => 'Αποθήκευση';

  @override
  String get commonEdit => 'Επεξεργασία';

  @override
  String get commonDelete => 'Διαγραφή';

  @override
  String get commonSearch => 'Αναζήτηση';

  @override
  String get commonLoading => 'Φόρτωση...';

  @override
  String get commonLoadFailed => 'Αποτυχία φόρτωσης';

  @override
  String get commonRetry => 'Επανάληψη';

  @override
  String get commonEmpty => 'Δεν υπάρχουν δεδομένα';

  @override
  String get commonCopy => 'Αντιγραφή';

  @override
  String get commonForward => 'Προώθηση';

  @override
  String get commonFavorite => 'Αποθήκευση';

  @override
  String get commonClose => 'Κλείσιμο';

  @override
  String get commonSend => 'Αποστολή';

  @override
  String get commonDone => 'Τέλος';

  @override
  String get commonMore => 'Περισσότερα';

  @override
  String get commonSettings => 'Ρυθμίσεις';

  @override
  String get commonCopied => 'Αντιγράφηκε';

  @override
  String get commonUnknown => 'Άγνωστο';

  @override
  String get commonNotSet => 'Δεν έχει οριστεί';

  @override
  String get commonUnbound => 'Μη συνδεδεμένο';

  @override
  String get commonViewAll => 'Προβολή όλων';

  @override
  String get commonSubmit => 'Υποβολή';

  @override
  String get commonAdd => 'Προσθήκη';

  @override
  String get commonRemove => 'Αφαίρεση';

  @override
  String get commonCreate => 'Δημιουργία';

  @override
  String get commonUpdate => 'Ενημέρωση';

  @override
  String get commonUpload => 'Μεταφόρτωση';

  @override
  String get commonShare => 'Κοινοποίηση';

  @override
  String get commonBlock => 'Αποκλεισμός';

  @override
  String get commonUnblock => 'Άρση αποκλεισμού';

  @override
  String get commonMute => 'Σίγαση';

  @override
  String get commonUnmute => 'Κατάργηση σίγασης';

  @override
  String get commonPin => 'Καρφιτσωμένα';

  @override
  String get commonUnpin => 'Ξεκαρφίτσωμα';

  @override
  String get commonMarkRead => 'Σήμανση ως αναγνωσμένο';

  @override
  String get commonMarkUnread => 'Σήμανση ως μη αναγνωσμένο';

  @override
  String get commonOnline => 'Σε σύνδεση';

  @override
  String get commonOffline => 'Εκτός σύνδεσης';

  @override
  String get commonOperationFailed => 'Η ενέργεια απέτυχε, δοκιμάστε ξανά';

  @override
  String get commonNetworkError => 'Σφάλμα δικτύου, ελέγξτε τη σύνδεσή σας';

  @override
  String get navMessages => 'Μηνύματα';

  @override
  String get navContacts => 'Επαφές';

  @override
  String get navMe => 'Εγώ';

  @override
  String get authLoginTitle => 'Σύνδεση στο StartLink';

  @override
  String get authTabMobile => 'Τηλέφωνο';

  @override
  String get authTabEmail => 'Ηλεκτρονικό Ταχυδρομείο';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Εισαγάγετε αριθμό τηλεφώνου';

  @override
  String get authHintEmail => 'Εισαγάγετε τη διεύθυνση email σας';

  @override
  String get authHintPassword => 'Εισαγάγετε κωδικό πρόσβασης';

  @override
  String get authHintCode => 'Εισαγάγετε κωδικό επαλήθευσης';

  @override
  String get authHintLoginName => 'Εισαγάγετε StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Σύνδεση';

  @override
  String get authGetCode => 'Λήψη κωδικού';

  @override
  String authResendCode(int seconds) {
    return 'Επανάληψη αποστολής σε $seconds δευτ.';
  }

  @override
  String get authUsePassword => 'Χρήση κωδικού πρόσβασης';

  @override
  String get authUseCode => 'Χρήση κωδικού επαλήθευσης';

  @override
  String get authAgreementPrefix => 'Έχω διαβάσει και αποδέχομαι τους';

  @override
  String get authAgreementAnd => 'και';

  @override
  String get authTermsLink => 'Συμφωνία Χρήσης';

  @override
  String get authPrivacyLink => 'Πολιτική Απορρήτου';

  @override
  String get authCaptchaTitle => 'Επαλήθευση ασφάλειας';

  @override
  String get authCaptchaHint => 'Εισαγάγετε την απάντηση';

  @override
  String get authCaptchaFailed => 'Δεν ελήφθη το captcha, δοκιμάστε ξανά';

  @override
  String get authErrorEmptyCode => 'Εισαγάγετε κωδικό επαλήθευσης';

  @override
  String get authErrorEmptyPassword => 'Εισαγάγετε κωδικό πρόσβασης';

  @override
  String get authErrorEmptyLoginName => 'Εισαγάγετε StartLink ID';

  @override
  String get authErrorWrongCredentials =>
      'Λάθος λογαριασμός ή κωδικός πρόσβασης';

  @override
  String get authDeactivatingTitle => 'Απενεργοποίηση λογαριασμού';

  @override
  String get authDeactivatingContent =>
      'Ο λογαριασμός σας βρίσκεται στην περίοδο αναμονής απενεργοποίησης (7 ημέρες).\n\nΓια να ακυρώσετε την απενεργοποίηση, πατήστε «Ακύρωση απενεργοποίησης». Διαφορετικά, πατήστε «Συνέχεια» για είσοδο στην εφαρμογή.';

  @override
  String get authContinueUse => 'Συνέχεια';

  @override
  String get authCancelDeactivation => 'Ακύρωση απενεργοποίησης';

  @override
  String get authDeactivationCancelled =>
      'Η απενεργοποίηση ακυρώθηκε, ο λογαριασμός αποκαταστάθηκε';

  @override
  String get authDeactivationCancelFailed =>
      'Αποτυχία ακύρωσης, δοκιμάστε ξανά';

  @override
  String get authLogout => 'Αποσύνδεση';

  @override
  String get authLogoutConfirm => 'Θέλετε σίγουρα να αποσυνδεθείτε;';

  @override
  String get authSendingCode => 'Αποστολή...';

  @override
  String get authCodeSent => 'Κωδικός επαλήθευσης στάλθηκε';

  @override
  String get authLoginFailed => 'Αποτυχία σύνδεσης, δοκιμάστε ξανά';

  @override
  String get authRegisterFailed => 'Αποτυχία εγγραφής, δοκιμάστε ξανά';

  @override
  String get authEnterpriseCode => 'Κωδικός εταιρείας';

  @override
  String get authEnterpriseCodeHint => 'Εισαγάγετε κωδικό εταιρείας';

  @override
  String get authPendingApproval =>
      'Η εγγραφή ολοκληρώθηκε. Το αίτημα συμμετοχής στην εταιρεία υποβλήθηκε και περιμένει έγκριση.';

  @override
  String get authNoAccount => 'Δεν έχετε λογαριασμό;';

  @override
  String get authRegisterNow => 'Εγγραφή τώρα';

  @override
  String get authCountryPickerTitle => 'Επιλέξτε χώρα/περιοχή';

  @override
  String get authCountrySearchHint => 'Αναζήτηση χώρας/περιοχής';

  @override
  String get authCountryChinaMainland => 'Ηπειρωτική Κίνα';

  @override
  String get authCountryHongKong => 'Χονγκ Κονγκ, Κίνα';

  @override
  String get authCountryMacau => 'Μακάο, Κίνα';

  @override
  String get authCountryTaiwan => 'Ταϊβάν, Κίνα';

  @override
  String get authCountryUnitedStates => 'Ηνωμένες Πολιτείες';

  @override
  String get authCountryUnitedKingdom => 'Ηνωμένο Βασίλειο';

  @override
  String get authCountryJapan => 'Ιαπωνία';

  @override
  String get authCountrySouthKorea => 'Νότια Κορέα';

  @override
  String get authCountrySingapore => 'Σιγκαπούρη';

  @override
  String get authCountryMalaysia => 'Μαλαισία';

  @override
  String get authCountryAustralia => 'Αυστραλία';

  @override
  String get authCountryCanada => 'Καναδάς';

  @override
  String get authCountryGermany => 'Γερμανία';

  @override
  String get authCountryFrance => 'Γαλλία';

  @override
  String get authCountryIndia => 'Ινδία';

  @override
  String get authCountryThailand => 'Ταϊλάνδη';

  @override
  String get authCountryVietnam => 'Βιετνάμ';

  @override
  String get authCountryIndonesia => 'Ινδονησία';

  @override
  String get authCountryPhilippines => 'Φιλιππίνες';

  @override
  String get authQuickLoginTitle => 'Γρήγορη σύνδεση';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Σύνδεση. Περιμένετε.';

  @override
  String get authRoleOwner => 'Ιδιοκτήτης';

  @override
  String get authRoleAdministrator => 'Διαχειριστής';

  @override
  String get authRoleCustomerService => 'Εξυπηρέτηση πελατών';

  @override
  String get authRoleTechnicalSupport => 'Τεχνική υποστήριξη';

  @override
  String get authRoleEmployee => 'Εργαζόμενος';

  @override
  String get authRoleMember => 'Μέλος';

  @override
  String get authRoleEnterpriseCustomer => 'Εταιρικός πελάτης';

  @override
  String get authUnavailablePrefix => 'Μη διαθέσιμο · ';

  @override
  String get authUnassignedService => 'Δεν έχει ανατεθεί εκπρόσωπος';

  @override
  String authAssignedService(String staff) {
    return 'Ανατέθηκε στον/στην $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Πελάτης · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Εργαζόμενος · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count χρήστες';
  }

  @override
  String get authMetaPhone => 'Τηλέφωνο';

  @override
  String get authMetaIdentity => 'Ταυτότητα';

  @override
  String get authRegisterTitle => 'Εγγραφή';

  @override
  String get authNickname => 'Ψευδώνυμο';

  @override
  String get authNicknameHint => 'Ορίστε ψευδώνυμο';

  @override
  String get authPassword => 'Κωδικός πρόσβασης';

  @override
  String get authPasswordSetHint =>
      'Ορίστε κωδικό πρόσβασης (τουλάχιστον 6 χαρακτήρες)';

  @override
  String get authConfirmPassword => 'Επιβεβαίωση κωδικού';

  @override
  String get authConfirmPasswordHint => 'Πληκτρολογήστε ξανά τον κωδικό';

  @override
  String get authVerificationCode => 'Κωδικός Επαλήθευσης';

  @override
  String get authRegisterAndLogin => 'Εγγραφή και σύνδεση';

  @override
  String get authHaveAccount => 'Έχετε ήδη λογαριασμό;';

  @override
  String get authGoLogin => 'Σύνδεση';

  @override
  String get authEmailVerificationUnavailable =>
      'Η επαλήθευση email δεν είναι διαθέσιμη. Εγγραφείτε με αριθμό κινητού.';

  @override
  String get authSmsVerificationUnavailable =>
      'Η επαλήθευση SMS δεν είναι διαθέσιμη. Εγγραφείτε με email.';

  @override
  String get authSendFailed => 'Δεν έγινε αποστολή. Δοκιμάστε ξανά.';

  @override
  String get authErrorEmptyNickname => 'Εισαγάγετε ψευδώνυμο';

  @override
  String get authErrorInvalidMobile => 'Εισαγάγετε έγκυρο αριθμό κινητού';

  @override
  String get authErrorInvalidEmail => 'Εισαγάγετε έγκυρη διεύθυνση email';

  @override
  String get authErrorPasswordTooShort =>
      'Ο κωδικός πρέπει να έχει τουλάχιστον 6 χαρακτήρες';

  @override
  String get authErrorPasswordMismatch => 'Οι κωδικοί δεν ταιριάζουν';

  @override
  String get authErrorVerificationRequired =>
      'Λάβετε και εισαγάγετε πρώτα τον κωδικό επαλήθευσης';

  @override
  String get authRegisterErrorTitle => 'Αποτυχία εγγραφής';

  @override
  String get authGotIt => 'Εντάξει';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Η εταιρεία «$code» δεν βρέθηκε. Ελέγξτε τον κωδικό εταιρείας.';
  }

  @override
  String get authTenantSearchFailed => 'Αποτυχία αναζήτησης. Δοκιμάστε ξανά.';

  @override
  String get authInvitationInvalid =>
      'Ο κωδικός πρόσκλησης δεν είναι έγκυρος. Ελέγξτε τον και δοκιμάστε ξανά.';

  @override
  String get authCollapseJoin => 'Απόκρυψη πληροφοριών συμμετοχής';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Έγκυρη πρόσκληση: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Βρέθηκε εταιρεία: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Επιλέξτε οργανισμό';

  @override
  String get authNoOrganization => 'Δεν υπάρχουν διαθέσιμοι οργανισμοί';

  @override
  String get authNoOrganizationHint =>
      'Ζητήστε από διαχειριστή να σας προσκαλέσει σε οργανισμό';

  @override
  String get authPersonalSpace => 'Προσωπικός χώρος';

  @override
  String get authPersonalSpaceSubtitle =>
      'Συνομιλίες φίλων και προσωπικά αγαπημένα';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Δεν επαληθεύτηκε η ταυτότητα χώρου. Δοκιμάστε ξανά.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Δεν αποκαταστάθηκε ο προσωπικός χώρος. Δοκιμάστε ξανά.';

  @override
  String get authJoinEnterpriseFailed =>
      'Δεν έγινε συμμετοχή στην εταιρεία. Δοκιμάστε αργότερα.';

  @override
  String get homeTitle => 'Μηνύματα';

  @override
  String get homeGatewayConnectingTitle => 'Σύνδεση';

  @override
  String get homePersonalSpace => 'Προσωπικός';

  @override
  String get homeOfficialService => 'Επίσημη υπηρεσία';

  @override
  String get homeSwitchSpace => 'Αλλαγή χώρου';

  @override
  String get homeSpaceSubtitle => 'Προσωπικός · Εταιρεία';

  @override
  String get homeJoinEnterprise => 'Συμμετοχή σε εταιρεία';

  @override
  String get homeCreateGroup => 'Νέα ομάδα';

  @override
  String get homeAddFriend => 'Προσθήκη επαφής';

  @override
  String get homeScan => 'Σάρωση';

  @override
  String get homeJoinNewSpace => 'Συμμετοχή σε νέο χώρο';

  @override
  String get homeSearchConversation => 'Αναζήτηση';

  @override
  String get homeNoMessages => 'Δεν υπάρχουν μηνύματα';

  @override
  String get homeDeleteConversation => 'Διαγραφή συνομιλίας';

  @override
  String get homeDeleteConversationConfirm =>
      'Διαγραφή αυτής της συνομιλίας; Το ιστορικό θα διαγραφεί.';

  @override
  String get homePersonalNote => 'Εγώ (Προσωπικές σημειώσεις)';

  @override
  String get homeWorkNote => 'Εγώ (Σημειώσεις εργασίας)';

  @override
  String homeConversationCount(int count) {
    return '$count συνομιλίες';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count μη αναγνωσμένα';
  }

  @override
  String get chatInputHint => 'Γράψτε ένα μήνυμα...';

  @override
  String get chatVoiceHint => 'Κρατήστε πατημένο για ομιλία';

  @override
  String get chatVoiceRelease => 'Αφήστε για αποστολή';

  @override
  String get chatVoiceCancel => 'Σύρετε επάνω για ακύρωση';

  @override
  String get chatMenuCopy => 'Αντιγραφή';

  @override
  String get chatMenuForward => 'Προώθηση';

  @override
  String get chatMenuRecall => 'Ανάκληση';

  @override
  String get chatMenuDelete => 'Διαγραφή';

  @override
  String get chatMenuFavorite => 'Αποθήκευση';

  @override
  String get chatMenuReply => 'Απάντηση';

  @override
  String get chatMenuMultiSelect => 'Επιλογή';

  @override
  String get chatMenuTranslate => 'Μετάφραση';

  @override
  String get chatMenuVoiceToText => 'Μετατροπή σε κείμενο';

  @override
  String get chatMenuTextToSpeech => 'Εκφώνηση';

  @override
  String get chatStatusRecalled => 'Το μήνυμα ανακλήθηκε';

  @override
  String get chatRecallSuccess => 'Ανακλήθηκε';

  @override
  String get chatRecallFailed => 'Αποτυχία ανάκλησης';

  @override
  String get chatRecallTimeout =>
      'Μηνύματα παλαιότερα των 2 λεπτών δεν ανακαλούνται';

  @override
  String get chatTranslateFailed => 'Αποτυχία μετάφρασης, δοκιμάστε ξανά';

  @override
  String get chatTranslateNotConfigured =>
      'Η υπηρεσία μετάφρασης δεν είναι διαθέσιμη';

  @override
  String get chatVoiceToTextFailed => 'Αποτυχία μετατροπής, δοκιμάστε ξανά';

  @override
  String get chatTextToSpeechFailed => 'Αποτυχία εκφώνησης, δοκιμάστε ξανά';

  @override
  String get chatVoiceToText => 'Μετατροπή';

  @override
  String get chatForwardSuccess => 'Προωθήθηκε';

  @override
  String get chatForwardFailed => 'Αποτυχία προώθησης, δοκιμάστε ξανά';

  @override
  String get chatNoConversations => 'Δεν υπάρχουν συνομιλίες για προώθηση';

  @override
  String get chatSendFailed => 'Αποτυχία αποστολής';

  @override
  String get chatResend => 'Επαναποστολή κωδικού';

  @override
  String get chatNotFriend => 'Δεν είναι στη λίστα επαφών';

  @override
  String get chatNotFriendHint =>
      'Δεν είστε ακόμη επαφές. Δεν μπορείτε να στείλετε μηνύματα.';

  @override
  String get chatMutedHint => 'Έχει απαγορευτεί η αποστολή σε όλα τα μέλη';

  @override
  String get chatFileUploadFailed =>
      'Αποτυχία μεταφόρτωσης αρχείου, δοκιμάστε ξανά';

  @override
  String get chatFileStatusNotDownloaded => 'Δεν έχει ληφθεί';

  @override
  String get chatFileStatusDownloaded => 'Έγινε λήψη';

  @override
  String get chatFileStatusUploading => 'Μεταφόρτωση';

  @override
  String get chatFileStatusUploadFailed => 'Αποτυχία Μεταφόρτωσης';

  @override
  String get chatCardSendFailed => 'Αποτυχία αποστολής κάρτας επαφής';

  @override
  String get chatFavoriteSuccess => 'Αποθηκευμένο';

  @override
  String get chatFavoriteFailed => 'Αποτυχία προσθήκης στα αγαπημένα';

  @override
  String get chatLoadFailed => 'Αποτυχία φόρτωσης';

  @override
  String get chatImageMessage => '[Εικόνα]';

  @override
  String get chatVoiceMessage => '[Φωνητικό]';

  @override
  String get chatVideoMessage => '[Βίντεο]';

  @override
  String get chatFileMessage => '[Αρχείο]';

  @override
  String get chatLocationMessage => '[Τοποθεσία]';

  @override
  String get chatContactCardMessage => '[Επαφή]';

  @override
  String get chatCallLogMessage => '[Κλήση]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Διαβάστηκε από $count';
  }

  @override
  String get chatUnread => 'Μη αναγνωσμένο';

  @override
  String get chatRecalledSelf => 'Ανακαλέσατε ένα μήνυμα';

  @override
  String chatRecalledPeer(String sender) {
    return 'Ο/Η $sender ανακάλεσε ένα μήνυμα';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Μετάφραση: $translation';
  }

  @override
  String get chatMessageDeleted => 'Το μήνυμα διαγράφηκε';

  @override
  String get chatPeer => 'Άλλα';

  @override
  String get chatSelf => 'Εγώ';

  @override
  String get chatGenericMessage => '[Μήνυμα]';

  @override
  String get chatVoiceHideText => 'Απόκρυψη κειμένου';

  @override
  String get chatVoiceShowText => 'Μετατροπή σε κείμενο';

  @override
  String get chatFileDefaultName => 'Αρχείο';

  @override
  String get chatContactDefaultName => 'Επαφή';

  @override
  String get chatContactCardTitle => 'Κάρτα επαφής';

  @override
  String get chatCallMissed => 'Αναπάντητη';

  @override
  String get chatCallCancelled => 'Ακυρώθηκε';

  @override
  String get chatCallRejected => 'Απορρίφθηκε';

  @override
  String get chatCallDisconnected => 'Αποσυνδέθηκε';

  @override
  String get chatCallEnded => 'Η κλήση τελείωσε';

  @override
  String get chatCallFailed => 'Αποτυχία κλήσης';

  @override
  String chatCallDuration(String duration) {
    return 'Διάρκεια $duration';
  }

  @override
  String get chatVideoCallTitle => 'Βιντεοκλήση';

  @override
  String get chatVoiceCallTitle => 'Φωνητική κλήση';

  @override
  String get chatToolPhotos => 'Φωτογραφίες';

  @override
  String get chatToolCamera => 'Κάμερα';

  @override
  String get chatToolFile => 'Αρχείο';

  @override
  String get chatToolLocation => 'Τοποθεσία';

  @override
  String get chatToolContactCard => 'Επαφή';

  @override
  String get chatToolVoiceCall => 'Φωνητική κλήση';

  @override
  String get chatToolVideoCall => 'Βιντεοκλήση';

  @override
  String get chatToolFavorites => 'Αγαπημένα';

  @override
  String get chatToolTranslate => 'Μετάφραση';

  @override
  String get chatTranslationChooseLanguage => 'Επιλέξτε γλώσσα μετάφρασης';

  @override
  String get chatTranslationEnterText => 'Εισαγάγετε πρώτα κείμενο';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Η μετάφραση δεν είναι διαθέσιμη για μηνύματα με αναφορές';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Η μετάφραση δεν είναι διαθέσιμη κατά την επεξεργασία προγραμματισμένου μηνύματος';

  @override
  String get chatTranslationFailed => 'Αποτυχία μετάφρασης. Δοκιμάστε ξανά';

  @override
  String get chatTranslationEmpty =>
      'Δεν επιστράφηκε μετάφραση. Δοκιμάστε ξανά';

  @override
  String get chatTranslationTranslating => 'Μετάφραση…';

  @override
  String get chatTranslationSend => 'Αποστολή μετάφρασης';

  @override
  String get chatTranslationSending => 'Αποστολή…';

  @override
  String get chatTranslationExpand => 'Εμφάνιση περισσότερων';

  @override
  String get chatTranslationCollapse => 'Εμφάνιση λιγότερων';

  @override
  String get chatFileTooLarge => 'Το αρχείο υπερβαίνει το όριο (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Μόνο ο ιδιοκτήτης ή επιλεγμένα μέλη μπορούν να γράψουν.';

  @override
  String get chatImageUploadUnsupported =>
      'Αποτυχία μεταφόρτωσης εικόνας. Δεν υπάρχει ακόμη υποστήριξη διακομιστή.';

  @override
  String get chatFavoriteLongPressHint =>
      'Πατήστε παρατεταμένα ένα μήνυμα για προσθήκη στα αγαπημένα';

  @override
  String chatSelectedCount(int count) {
    return '$count επιλεγμένα';
  }

  @override
  String get chatLocationSheetTitle => 'Αποστολή τοποθεσίας';

  @override
  String get chatLocationNameLabel => 'Όνομα τοποθεσίας';

  @override
  String get chatLocationNameHint => 'π.χ. Γραφείο, διεύθυνση πελάτη';

  @override
  String get chatLocationAddressLabel => 'Διεύθυνση';

  @override
  String get chatLocationOptionalHint => 'Προαιρετικό';

  @override
  String get chatLocationLatitudeLabel => 'Γεωγραφικό πλάτος';

  @override
  String get chatLocationLatitudeHint => '-90 έως 90';

  @override
  String get chatLocationLongitudeLabel => 'Γεωγραφικό μήκος';

  @override
  String get chatLocationLongitudeHint => '-180 έως 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Εισαγάγετε $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return 'Το $label είναι εκτός εύρους';
  }

  @override
  String get chatLocationDefaultTitle => 'Τοποθεσία';

  @override
  String get chatMutedFullNotice =>
      'Η ομάδα έχει περιορισμό αποστολής. Μόνο ο ιδιοκτήτης ή επιλεγμένα μέλη μπορούν να γράψουν.';

  @override
  String get chatNotFriendSendBlocked =>
      'Δεν είστε πλέον φίλοι και δεν μπορείτε να στείλετε μηνύματα';

  @override
  String get chatPersonalNotesTitle => 'Προσωπικές σημειώσεις';

  @override
  String get chatWorkNotesTitle => 'Σημειώσεις εργασίας';

  @override
  String get chatPersonalNotesDescription =>
      'Καταγράψτε προσωπικές σκέψεις και αποθηκεύστε σημαντικές πληροφορίες εδώ\nΣυγχρονίζονται μεταξύ συσκευών για πρόσβαση ανά πάσα στιγμή';

  @override
  String get chatWorkNotesDescription =>
      'Καταγράψτε εργασίες και αποθηκεύστε υλικό εργασίας εδώ\nΟι χώροι ομάδων παραμένουν ξεχωριστοί και ασφαλείς';

  @override
  String get chatNoMessages => 'Δεν υπάρχουν μηνύματα';

  @override
  String chatReplyTo(String sender) {
    return 'Απάντηση στον/στην $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return 'Το $feature έρχεται σύντομα';
  }

  @override
  String get chatForwardSelectTitle => 'Επιλέξτε συνομιλία';

  @override
  String get chatContactSelectTitle => 'Επιλέξτε επαφή';

  @override
  String get chatNoContacts => 'Δεν υπάρχουν επαφές';

  @override
  String get contactsTitle => 'Επαφές';

  @override
  String get contactsSearch => 'Αναζήτηση επαφών';

  @override
  String get contactsNewFriends => 'Νέοι φίλοι';

  @override
  String get contactsGroups => 'Ομάδες';

  @override
  String get contactsFavorites => 'Αγαπημένα';

  @override
  String get contactsRecent => 'Πρόσφατα';

  @override
  String get contactsOrganization => 'Οργανισμός';

  @override
  String get contactsAnnouncement => 'Ανακοινώσεις';

  @override
  String get contactsNewApplications => 'Νέες αιτήσεις';

  @override
  String get contactsCustomerGroups => 'Ομάδες πελατών';

  @override
  String get contactsAllCustomers => 'Όλοι οι πελάτες';

  @override
  String get contactsMyCustomers => 'Οι πελάτες μου';

  @override
  String get contactsViewAll => 'Προβολή όλων';

  @override
  String get contactsMyContacts => 'Οι επαφές μου';

  @override
  String get contactsMyAdvisor => 'Ο σύμβουλός μου';

  @override
  String get contactsNoAdvisor => 'Δεν έχει ανατεθεί σύμβουλος';

  @override
  String get contactsAdvisorLoading => 'Φόρτωση...';

  @override
  String get contactsNavigateFailed => 'Αποτυχία πλοήγησης, δοκιμάστε ξανά';

  @override
  String get contactsEmpty => 'Δεν υπάρχουν επαφές';

  @override
  String get contactsNoAnnouncement => 'Δεν υπάρχουν ανακοινώσεις';

  @override
  String get contactsOfficialBadge => 'Επίσημος';

  @override
  String get contactsCustomerBadge => 'Πελάτης';

  @override
  String get contactsEmptyCustomers => 'Δεν υπάρχουν πελάτες';

  @override
  String get myTitle => 'Εγώ';

  @override
  String get myEnterpriseInfo => 'Στοιχεία εταιρείας';

  @override
  String get myEnterpriseManage => 'Διαχείριση εταιρείας';

  @override
  String get myQrCode => 'Κωδικός QR';

  @override
  String get myFavorites => 'Αγαπημένα';

  @override
  String get myLanguage => 'Γλώσσα';

  @override
  String get myTimezone => 'Ζώνη ώρας';

  @override
  String get myAutoTranslate => 'Αυτόματη μετάφραση';

  @override
  String get myNetworkSwitch => 'Αλλαγή γραμμής';

  @override
  String get mySettings => 'Ρυθμίσεις';

  @override
  String get myLogout => 'Αποσύνδεση';

  @override
  String get myLogoutConfirm => 'Θέλετε σίγουρα να αποσυνδεθείτε;';

  @override
  String get myLeaveEnterprise => 'Αποχώρηση από εταιρεία';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Θέλετε σίγουρα να αποχωρήσετε από την εταιρεία; Θα χάσετε πρόσβαση στα δεδομένα της.';

  @override
  String get myLeaveEnterpriseSuccess => 'Αποχωρήσατε από την εταιρεία';

  @override
  String get myLeaveEnterpriseFailed => 'Αποτυχία αποχώρησης, δοκιμάστε ξανά';

  @override
  String get myLppIdCopied => 'Το StartLink ID αντιγράφηκε';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count επαφές';
  }

  @override
  String get myAutoSelect => 'Αυτόματα';

  @override
  String get myPresenceStatus => 'Κατάσταση παρουσίας';

  @override
  String get myPresenceStatusTitle => 'Ορισμός παρουσίας';

  @override
  String get myPresenceOnline => 'Σε σύνδεση';

  @override
  String get myPresenceBusy => 'Απασχολημένος';

  @override
  String get myPresenceAway => 'Απουσιάζω';

  @override
  String get myPresenceInvisible => 'Αόρατος';

  @override
  String get profileTitle => 'Το Προφίλ Μου';

  @override
  String get profileName => 'Όνομα';

  @override
  String get profileGender => 'Φύλο';

  @override
  String get profileBirthday => 'Γενέθλια';

  @override
  String get profileRegion => 'Περιοχή';

  @override
  String get profileSignature => 'Βιογραφικό';

  @override
  String get profileSignatureHint => 'Πείτε κάτι για εσάς';

  @override
  String get profileTapTapText => 'Χτύπημα';

  @override
  String get profileTapTapHint =>
      'Κείμενο όταν σας χτυπούν (έως 20 χαρακτήρες)';

  @override
  String get profileAccountSection => 'Λογαριασμός';

  @override
  String get profileBasicSection => 'Βασικά στοιχεία';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Δεν έχει οριστεί';

  @override
  String get profileMobile => 'Τηλέφωνο';

  @override
  String get profileMobileUnbound => 'Μη συνδεδεμένο';

  @override
  String get profileEmail => 'Ηλεκτρονικό Ταχυδρομείο';

  @override
  String get profileEmailUnbound => 'Μη συνδεδεμένο';

  @override
  String get profileQrCode => 'Ο κωδικός QR μου';

  @override
  String get profileChangePassword => 'Αλλαγή κωδικού πρόσβασης';

  @override
  String get profileGenderMale => 'Άνδρας';

  @override
  String get profileGenderFemale => 'Γυναίκα';

  @override
  String get profileGenderOther => 'Άλλο';

  @override
  String get profileGenderUnset => 'Δεν έχει οριστεί';

  @override
  String get profileSaveFailed => 'Αποτυχία αποθήκευσης, δοκιμάστε ξανά';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'Το StartLink ID αλλάζει μόνο μία φορά. Επιλέξτε προσεκτικά.';

  @override
  String get profileLppIdChangeFailed =>
      'Αποτυχία αλλαγής (το StartLink ID αλλάζει μόνο μία φορά)';

  @override
  String get profileChangePasswordOld => 'Τρέχων κωδικός πρόσβασης';

  @override
  String get profileChangePasswordNew => 'Νέος Κωδικός Πρόσβασης';

  @override
  String get profileChangePasswordConfirm =>
      'Επιβεβαίωση Νέου Κωδικού Πρόσβασης';

  @override
  String get profileChangePasswordMismatch => 'Οι κωδικοί δεν ταιριάζουν';

  @override
  String get profileChangePasswordSuccess =>
      'Ο κωδικός άλλαξε. Συνδεθείτε ξανά.';

  @override
  String get profileChangePasswordFailed =>
      'Αποτυχία αλλαγής κωδικού, δοκιμάστε ξανά';

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get settingsSectionEnterprise => 'Εταιρεία';

  @override
  String get settingsSectionAccount => 'Λογαριασμός';

  @override
  String get settingsSectionGeneral => 'Γενικά';

  @override
  String get settingsSectionFeatures => 'Δυνατότητες';

  @override
  String get settingsSectionAbout => 'Σχετικά';

  @override
  String get settingsEnterpriseInfo => 'Στοιχεία εταιρείας';

  @override
  String get settingsProfile => 'Το Προφίλ Μου';

  @override
  String get settingsAccountSecurity => 'Ασφάλεια λογαριασμού';

  @override
  String get settingsNotification => 'Ειδοποιήσεις';

  @override
  String get settingsDisplay => 'Εμφάνιση';

  @override
  String get settingsFriendPrivacy => 'Απόρρητο';

  @override
  String get settingsChat => 'Συνομιλία';

  @override
  String get settingsChatHistory => 'Ιστορικό συνομιλίας';

  @override
  String get settingsAbout => 'Σχετικά με το StartLink';

  @override
  String get settingsLanguage => 'Γλώσσα';

  @override
  String get settingsTimezone => 'Ζώνη ώρας';

  @override
  String get settingsAutoTranslate => 'Αυτόματη μετάφραση';

  @override
  String get settingsNetworkSwitch => 'Αλλαγή γραμμής';

  @override
  String get enterpriseInfoTitle => 'Στοιχεία εταιρείας';

  @override
  String get enterpriseName => 'Όνομα';

  @override
  String get enterpriseDescription => 'Περιγραφή';

  @override
  String get enterpriseUpdateSuccess => 'Ενημερώθηκε επιτυχώς';

  @override
  String get enterpriseUpdateFailed => 'Αποτυχία ενημέρωσης, δοκιμάστε ξανά';

  @override
  String get enterpriseLeave => 'Αποχώρηση από εταιρεία';

  @override
  String get enterpriseLeaveConfirm =>
      'Θέλετε σίγουρα να αποχωρήσετε από αυτή την εταιρεία;';

  @override
  String get enterpriseLeaveSuccess => 'Αποχωρήσατε από την εταιρεία';

  @override
  String get enterpriseLeaveFailed => 'Αποτυχία αποχώρησης, δοκιμάστε ξανά';

  @override
  String get enterpriseLeaveOwnerError =>
      'Ο ιδιοκτήτης δεν μπορεί να αποχωρήσει απευθείας. Μεταβιβάστε πρώτα την ιδιοκτησία.';

  @override
  String get enterpriseMemberCount => 'Μέλη';

  @override
  String get enterpriseCreatedAt => 'Δημιουργήθηκε';

  @override
  String get enterpriseCode => 'Κωδικός εταιρείας';

  @override
  String get enterpriseInviteMembers => 'Πρόσκληση μελών';

  @override
  String get enterpriseCopyInviteCode => 'Αντιγραφή κωδικού πρόσκλησης';

  @override
  String get enterpriseInviteCodeCopied => 'Ο κωδικός πρόσκλησης αντιγράφηκε';

  @override
  String get groupCreateTitle => 'Νέα ομάδα';

  @override
  String get groupNameHint => 'Εισαγάγετε όνομα ομάδας';

  @override
  String get groupCreateSuccess => 'Η ομάδα δημιουργήθηκε';

  @override
  String get groupCreateFailed => 'Αποτυχία δημιουργίας ομάδας';

  @override
  String get groupSettings => 'Ρυθμίσεις ομάδας';

  @override
  String get groupName => 'Όνομα ομάδας';

  @override
  String get groupAvatar => 'Εικόνα ομάδας';

  @override
  String get groupAnnouncement => 'Ανακοίνωση';

  @override
  String get groupMembers => 'Μέλη';

  @override
  String get groupAddMember => 'Προσθήκη μελών';

  @override
  String get groupRemoveMember => 'Αφαίρεση μέλους';

  @override
  String get groupRemoveMemberConfirm => 'Αφαίρεση αυτού του μέλους;';

  @override
  String get groupSetAdmin => 'Ορισμός ως διαχειριστή';

  @override
  String get groupRemoveAdmin => 'Αφαίρεση διαχειριστή';

  @override
  String get groupTransferOwner => 'Μεταβίβαση ιδιοκτησίας';

  @override
  String get groupTransferOwnerConfirm =>
      'Μεταβίβαση της ιδιοκτησίας ομάδας σε αυτό το μέλος;';

  @override
  String get groupTransferOwnerSuccess => 'Η ιδιοκτησία μεταβιβάστηκε';

  @override
  String get groupTransferOwnerFailed => 'Αποτυχία μεταβίβασης, δοκιμάστε ξανά';

  @override
  String get groupLeave => 'Αποχώρηση από ομάδα';

  @override
  String get groupLeaveConfirm => 'Αποχώρηση από αυτή την ομάδα;';

  @override
  String get groupLeaveSuccess => 'Αποχωρήσατε από την ομάδα';

  @override
  String get groupLeaveFailed => 'Αποτυχία αποχώρησης, δοκιμάστε ξανά';

  @override
  String get groupDissolve => 'Διάλυση ομάδας';

  @override
  String get groupDissolveConfirm =>
      'Διάλυση αυτής της ομάδας; Θα αφαιρεθούν όλα τα μέλη.';

  @override
  String get groupDissolveSuccess => 'Η ομάδα διαλύθηκε';

  @override
  String get groupDissolveFailed => 'Αποτυχία διάλυσης, δοκιμάστε ξανά';

  @override
  String get groupQrCode => 'Κωδικός QR ομάδας';

  @override
  String get groupMuteAll => 'Απαγόρευση αποστολής σε όλους';

  @override
  String get groupMuteAllOn => 'Ενεργοποίηση απαγόρευσης για όλους';

  @override
  String get groupMuteAllOff => 'Απενεργοποίηση απαγόρευσης για όλους';

  @override
  String get groupAllowMemberInvite => 'Να επιτρέπονται προσκλήσεις από μέλη';

  @override
  String get groupAllowMemberModifyTitle =>
      'Να επιτρέπεται στα μέλη αλλαγή ονόματος ομάδας';

  @override
  String get groupAllowMemberAtAll =>
      'Να επιτρέπεται στα μέλη αναφορά σε @Όλους';

  @override
  String get groupAllowMemberViewMemberList =>
      'Να επιτρέπεται στα μέλη προβολή λίστας μελών';

  @override
  String get groupAllowQrCodeJoin => 'Να επιτρέπεται συμμετοχή με QR';

  @override
  String get groupRequireApproval => 'Απαίτηση έγκρισης για συμμετοχή';

  @override
  String get groupAllowMemberAddFriend =>
      'Να επιτρέπεται στα μέλη να προσθέτουν το ένα το άλλο';

  @override
  String get groupRoleOwner => 'Ιδιοκτήτης';

  @override
  String get groupRoleAdmin => 'Διαχειριστής';

  @override
  String get groupRoleMember => 'Μέλος';

  @override
  String get groupNoMembers => 'Δεν υπάρχουν μέλη';

  @override
  String get groupNoAnnouncements => 'Δεν υπάρχουν ανακοινώσεις';

  @override
  String get groupCreateAnnouncement => 'Δημοσίευση ανακοίνωσης';

  @override
  String get groupEditAnnouncement => 'Επεξεργασία ανακοίνωσης';

  @override
  String get groupDeleteAnnouncement => 'Διαγραφή ανακοίνωσης';

  @override
  String get groupDeleteAnnouncementConfirm =>
      'Διαγραφή αυτής της ανακοίνωσης;';

  @override
  String get groupAnnouncementTitle => 'Τίτλος';

  @override
  String get groupAnnouncementContent => 'Περιεχόμενο';

  @override
  String get groupAnnouncementPin => 'Καρφίτσωμα ανακοίνωσης';

  @override
  String groupMemberCount(int count) {
    return '$count μέλη';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count επιλεγμένα';
  }

  @override
  String get groupJoinRequestApprove => 'Συμφωνώ';

  @override
  String get groupJoinRequestReject => 'Άρνηση';

  @override
  String get groupJoinRequests => 'Αιτήματα συμμετοχής';

  @override
  String get groupNoJoinRequests => 'Δεν υπάρχουν αιτήματα συμμετοχής';

  @override
  String get groupReadReceipts => 'Αποδείξεις ανάγνωσης';

  @override
  String groupReadCount(int count) {
    return '$count διαβάστηκαν';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count μη αναγνωσμένα';
  }

  @override
  String get friendAddTitle => 'Προσθήκη επαφής';

  @override
  String get friendSearchHint => 'Τηλέφωνο / Email / StartLink ID';

  @override
  String get friendRequestSent => 'Το αίτημα φιλίας στάλθηκε';

  @override
  String get friendRequestFailed => 'Αποτυχία αποστολής, δοκιμάστε ξανά';

  @override
  String get friendAlreadyFriend => 'Είστε ήδη επαφές';

  @override
  String get friendNewFriendsTitle => 'Νέοι φίλοι';

  @override
  String get friendNoRequests => 'Δεν υπάρχουν αιτήματα φιλίας';

  @override
  String get friendAccept => 'Αποδοχή';

  @override
  String get friendReject => 'Άρνηση';

  @override
  String get friendAccepted => 'Έγινε αποδοχή';

  @override
  String get friendRejected => 'Απορρίφθηκε';

  @override
  String get friendDeleteConfirm => 'Αφαίρεση αυτής της επαφής;';

  @override
  String get friendDeleteSuccess => 'Η επαφή αφαιρέθηκε';

  @override
  String get friendDeleteFailed => 'Αποτυχία αφαίρεσης, δοκιμάστε ξανά';

  @override
  String get friendRemarkName => 'Ψευδώνυμο';

  @override
  String get friendGroupName => 'Ομάδα';

  @override
  String get friendSendMessage => 'Μήνυμα';

  @override
  String get friendMatchTypeLppId => 'Αντιστοίχιση μέσω StartLink ID';

  @override
  String get friendMatchTypeMobile => 'Αντιστοίχιση μέσω τηλεφώνου';

  @override
  String get friendMatchTypeEmail => 'Αντιστοίχιση μέσω email';

  @override
  String get friendSearchEmpty => 'Δεν βρέθηκαν χρήστες';

  @override
  String get friendAddMessage => 'Θα ήθελα να σας προσθέσω ως επαφή';

  @override
  String get friendBlockConfirm => 'Αποκλεισμός αυτού του χρήστη;';

  @override
  String get friendUnblockConfirm => 'Άρση αποκλεισμού αυτού του χρήστη;';

  @override
  String get friendBlockSuccess => 'Αποκλείστηκε';

  @override
  String get friendUnblockSuccess => 'Ο αποκλεισμός άρθηκε';

  @override
  String get profilePageTitle => 'Προσωπικά Στοιχεία';

  @override
  String get profilePageSendMessage => 'Μήνυμα';

  @override
  String get profilePageAddFriend => 'Προσθήκη φίλου';

  @override
  String get profilePageAlreadyFriend => 'Είστε ήδη φίλοι';

  @override
  String get profilePageBlocked => 'Αποκλείστηκε';

  @override
  String get profilePageBlock => 'Αποκλεισμός';

  @override
  String get profilePageUnblock => 'Άρση αποκλεισμού';

  @override
  String get profilePageHidden => 'Αυτός ο χρήστης έχει κρύψει το προφίλ του';

  @override
  String get profilePageFriendsOnly =>
      'Αυτός ο χρήστης δείχνει το προφίλ μόνο σε φίλους';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Σημειώσεις';

  @override
  String get profilePageEditRemark => 'Επεξεργασία ψευδωνύμου';

  @override
  String get profilePageSaveRemarkSuccess => 'Το ψευδώνυμο αποθηκεύτηκε';

  @override
  String get profilePageSaveRemarkFailed =>
      'Αποτυχία αποθήκευσης, δοκιμάστε ξανά';

  @override
  String get searchTitle => 'Αναζήτηση';

  @override
  String get searchHint => 'Αναζήτηση με τηλέφωνο, email ή StartLink ID';

  @override
  String get searchNoResults => 'Δεν βρέθηκαν αποτελέσματα';

  @override
  String get searchMessages => 'Μηνύματα';

  @override
  String get searchUsers => 'Χρήστες';

  @override
  String get searchFailed => 'Αποτυχία αναζήτησης, δοκιμάστε ξανά';

  @override
  String get scanTitle => 'Σάρωση';

  @override
  String get scanFailed => 'Αποτυχία αναγνώρισης, δοκιμάστε ξανά';

  @override
  String get scanInvalidQrCode => 'Μη έγκυρος κωδικός QR';

  @override
  String get scanFlashOn => 'Ενεργοποίηση φακού';

  @override
  String get scanFlashOff => 'Απενεργοποίηση φακού';

  @override
  String get scanAlbum => 'Επιλογή από άλμπουμ';

  @override
  String get favoritesTitle => 'Αγαπημένα';

  @override
  String get favoritesEmpty => 'Δεν έχετε αποθηκεύσει ακόμη τίποτα';

  @override
  String get favoritesAll => 'Όλα';

  @override
  String get favoritesText => 'Κείμενο';

  @override
  String get favoritesImage => 'Εικόνες';

  @override
  String get favoritesVideo => 'Βίντεο';

  @override
  String get favoritesVoice => 'Φωνητικά';

  @override
  String get favoritesFile => 'Αρχεία';

  @override
  String get favoritesOther => 'Άλλο';

  @override
  String get favoritesDeleteConfirm => 'Αφαίρεση από τα αγαπημένα;';

  @override
  String get favoritesDeleteSuccess => 'Αφαιρέθηκε από τα αποθηκευμένα';

  @override
  String get favoritesDeleteFailed => 'Αποτυχία αφαίρεσης';

  @override
  String get favoritesOriginalRecalled => 'Το μήνυμα ανακλήθηκε';

  @override
  String get favoritesViewOriginal => 'Προβολή πρωτοτύπου';

  @override
  String get favoritesSearchHint => 'Αναζήτηση αγαπημένων';

  @override
  String get favoritesNoResults => 'Δεν υπάρχουν αντίστοιχα αγαπημένα';

  @override
  String get noticeTitle => 'Ανακοινώσεις';

  @override
  String get noticeEmpty => 'Δεν υπάρχουν ανακοινώσεις';

  @override
  String get noticeDetail => 'Λεπτομέρειες ανακοίνωσης';

  @override
  String get noticePublishedAt => 'Δημοσιεύτηκε';

  @override
  String get noticePriorityNormal => 'Κανονικό';

  @override
  String get noticePriorityImportant => 'Σημαντικό';

  @override
  String get noticePriorityUrgent => 'Επείγον';

  @override
  String get organizationTitle => 'Οργανισμός';

  @override
  String get organizationEmpty => 'Δεν υπάρχουν στοιχεία τμήματος';

  @override
  String get organizationMembers => 'Μέλη';

  @override
  String get organizationDepartment => 'Τμήμα';

  @override
  String get organizationPosition => 'Θέση';

  @override
  String get organizationLeader => 'Προϊστάμενος';

  @override
  String get qrCodeTitle => 'Ο κωδικός QR μου';

  @override
  String get qrCodeSave => 'Αποθήκευση στο Άλμπουμ';

  @override
  String get qrCodeShare => 'Κοινοποίηση';

  @override
  String get qrCodeSaveSuccess => 'Αποθηκεύτηκε στο άλμπουμ';

  @override
  String get qrCodeSaveFailed => 'Αποτυχία αποθήκευσης, δοκιμάστε ξανά';

  @override
  String get qrCodeRefresh => 'Ανανέωση κωδικού QR';

  @override
  String get qrCodeExpired => 'Ο κωδικός QR έληξε, ανανεώστε τον';

  @override
  String get qrCodeScanToAdd => 'Σαρώστε για να με προσθέσετε ως επαφή';

  @override
  String get spacePersonal => 'Προσωπικός';

  @override
  String get spaceEnterprise => 'Εταιρεία';

  @override
  String get spaceJoinByCode => 'Συμμετοχή με κωδικό εταιρείας';

  @override
  String get spaceJoinByInvite => 'Συμμετοχή με κωδικό πρόσκλησης';

  @override
  String get spaceEnterCode => 'Εισαγάγετε κωδικό εταιρείας';

  @override
  String get spaceEnterInviteCode => 'Εισαγάγετε κωδικό πρόσκλησης';

  @override
  String get spaceSearchEnterprise => 'Αναζήτηση εταιρείας';

  @override
  String get spaceJoinRequestSent => 'Το αίτημα υποβλήθηκε, αναμένεται έγκριση';

  @override
  String get spaceJoinRequestPending => 'Αναμονή έγκρισης';

  @override
  String get spaceJoinRequestApproved => 'Το αίτημα εγκρίθηκε';

  @override
  String get spaceJoinRequestRejected => 'Το αίτημα απορρίφθηκε';

  @override
  String get spaceAlreadyMember => 'Είστε ήδη μέλος';

  @override
  String get spaceAutoApproved => 'Εγκρίθηκε αυτόματα. Καλώς ήρθατε!';

  @override
  String get spacePendingApprovalHint =>
      'Η εγγραφή ολοκληρώθηκε. Το αίτημα συμμετοχής υποβλήθηκε.';

  @override
  String get spaceNoSpaces => 'Δεν υπάρχουν χώροι';

  @override
  String get spaceInviteExpired => 'Ο κωδικός πρόσκλησης έληξε';

  @override
  String get spaceInviteTargetMismatch =>
      'Αυτός ο κωδικός πρόσκλησης δεν είναι για τον λογαριασμό σας';

  @override
  String get spaceAcceptInviteSuccess => 'Συμμετείχατε επιτυχώς στην εταιρεία';

  @override
  String get spaceAcceptInviteFailed => 'Αποτυχία συμμετοχής, δοκιμάστε ξανά';

  @override
  String get spaceTenantSelectTitle => 'Επιλέξτε χώρο';

  @override
  String get spaceTenantSelectHint => 'Επιλέξτε χώρο για είσοδο';

  @override
  String get spaceEnterPersonal => 'Είσοδος σε προσωπικό χώρο';

  @override
  String get spaceEnterEnterprise => 'Είσοδος σε εταιρικό χώρο';

  @override
  String get aboutTitle => 'Σχετικά με το StartLink';

  @override
  String get aboutVersion => 'Έκδοση';

  @override
  String get aboutTerms => 'Όροι χρήσης';

  @override
  String get aboutPrivacy => 'Πολιτική Απορρήτου';

  @override
  String get aboutOpenSource => 'Άδειες ανοιχτού κώδικα';

  @override
  String get aboutCheckUpdate => 'Έλεγχος ενημερώσεων';

  @override
  String get aboutLatestVersion => 'Είστε στην πιο πρόσφατη έκδοση';

  @override
  String get aboutUpdateAvailable => 'Νέα έκδοση διαθέσιμη';

  @override
  String get aboutUpdateNow => 'Ενημέρωση Τώρα';

  @override
  String get aboutUpdateLater => 'Αργότερα';

  @override
  String get notificationTitle => 'Ειδοποιήσεις';

  @override
  String get notificationGlobalMute => 'Μην ενοχλείτε';

  @override
  String get notificationSound => 'Ήχος';

  @override
  String get notificationVibration => 'Δόνηση';

  @override
  String get notificationPreview => 'Προεπισκόπηση μηνυμάτων';

  @override
  String get notificationDndStart => 'Έναρξη λειτουργίας Μην ενοχλείτε';

  @override
  String get notificationDndEnd => 'Λήξη λειτουργίας Μην ενοχλείτε';

  @override
  String get blacklistTitle => 'Σε μαύρη λίστα';

  @override
  String get blacklistEmpty => 'Δεν υπάρχουν αποκλεισμένοι χρήστες';

  @override
  String get blacklistRemove => 'Άρση αποκλεισμού';

  @override
  String get blacklistRemoveConfirm => 'Άρση αποκλεισμού αυτού του χρήστη;';

  @override
  String get feedbackTitle => 'Σχόλια';

  @override
  String get feedbackTypeComplaint => 'Καταγγελία';

  @override
  String get feedbackTypeSuggestion => 'Πρόταση';

  @override
  String get feedbackTypeBug => 'Αναφορά σφάλματος';

  @override
  String get feedbackContent => 'Περιγραφή';

  @override
  String get feedbackContentHint =>
      'Περιγράψτε αναλυτικά το πρόβλημα ή την πρότασή σας';

  @override
  String get feedbackContact => 'Στοιχεία επικοινωνίας (προαιρετικό)';

  @override
  String get feedbackSubmit => 'Υποβολή';

  @override
  String get feedbackSuccess => 'Τα σχόλια υποβλήθηκαν. Ευχαριστούμε!';

  @override
  String get feedbackFailed => 'Αποτυχία υποβολής, δοκιμάστε ξανά';

  @override
  String get networkTitle => 'Αλλαγή γραμμής';

  @override
  String get networkAutoSelect => 'Αυτόματα';

  @override
  String get networkManual => 'Χειροκίνητα';

  @override
  String get timezoneTitle => 'Ζώνη ώρας';

  @override
  String get timezoneAuto => 'Ακολουθήστε το σύστημα';

  @override
  String get autoTranslateTitle => 'Αυτόματη μετάφραση';

  @override
  String get autoTranslateEnabled => 'Ενεργοποίηση αυτόματης μετάφρασης';

  @override
  String get autoTranslateLanguage => 'Γλώσσα προορισμού';

  @override
  String get displayTitle => 'Εμφάνιση';

  @override
  String get displayFontSize => 'Μέγεθος γραμματοσειράς';

  @override
  String get displayChatBackground => 'Φόντο συνομιλίας';

  @override
  String get displayDarkMode => 'Εμφάνιση';

  @override
  String get displayDarkModeSystem => 'Ακολουθήστε το σύστημα';

  @override
  String get displayDarkModeSystemHint =>
      'Αυτόματη αλλαγή βάσει ρύθμισης συστήματος';

  @override
  String get displayDarkModeOff => 'Φωτεινό';

  @override
  String get displayDarkModeOffHint => 'Πάντα φωτεινό θέμα';

  @override
  String get displayDarkModeOn => 'Σκοτεινό';

  @override
  String get displayDarkModeOnHint => 'Πάντα σκοτεινό θέμα';

  @override
  String get chatSettingsTitle => 'Συνομιλία';

  @override
  String get chatHistoryTitle => 'Ιστορικό συνομιλίας';

  @override
  String get chatHistoryClear => 'Εκκαθάριση όλου του ιστορικού';

  @override
  String get chatHistoryClearConfirm =>
      'Εκκαθάριση όλου του ιστορικού συνομιλιών; Αυτή η ενέργεια δεν αναιρείται.';

  @override
  String get chatHistoryClearSuccess => 'Το ιστορικό συνομιλιών εκκαθαρίστηκε';

  @override
  String get accountSecurityTitle => 'Ασφάλεια λογαριασμού';

  @override
  String get accountSecurityChangePassword => 'Αλλαγή κωδικού πρόσβασης';

  @override
  String get accountSecurityChangeMobile => 'Αλλαγή Τηλεφώνου';

  @override
  String get accountSecurityChangeEmail => 'Αλλαγή email';

  @override
  String get accountSecurityLoggedDevices => 'Συνδεδεμένες συσκευές';

  @override
  String get accountSecurityDeactivate => 'Απενεργοποίηση λογαριασμού';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Όλα τα δεδομένα θα διαγραφούν οριστικά μετά από 7 ημέρες. Απενεργοποίηση;';

  @override
  String get loggedDevicesTitle => 'Συνδεδεμένες συσκευές';

  @override
  String get loggedDevicesCurrent => 'Αυτή η συσκευή';

  @override
  String get loggedDevicesRevoke => 'Αποσύνδεση';

  @override
  String get loggedDevicesRevokeConfirm => 'Αποσύνδεση από αυτή τη συσκευή;';

  @override
  String get loggedDevicesRevokeSuccess => 'Έγινε αποσύνδεση από τη συσκευή';

  @override
  String get loggedDevicesRevokeFailed => 'Αποτυχία, δοκιμάστε ξανά';

  @override
  String get loggedDevicesLastActive => 'Τελευταία δραστηριότητα';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Ιστός';

  @override
  String get loggedDevicesTypeDesktop => 'Υπολογιστής';

  @override
  String get loggedDevicesTypeUnknown => 'Άγνωστη συσκευή';

  @override
  String get privacySettingsTitle => 'Απόρρητο';

  @override
  String get privacySearchableByMobile =>
      'Να επιτρέπεται αναζήτηση με αριθμό τηλεφώνου';

  @override
  String get privacySearchableByLppId =>
      'Να επιτρέπεται αναζήτηση με StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'Να επιτρέπονται αιτήματα φιλίας';

  @override
  String get privacyProfileVisibility => 'Ορατότητα προφίλ';

  @override
  String get privacyEveryone => 'Όλοι';

  @override
  String get privacyFriendsOfFriends => 'Φίλοι φίλων';

  @override
  String get privacyNobody => 'Κανείς';

  @override
  String get privacyFriendsOnly => 'Μόνο φίλοι';

  @override
  String get privacySaveSuccess => 'Οι ρυθμίσεις αποθηκεύτηκαν';

  @override
  String get privacySaveFailed => 'Αποτυχία αποθήκευσης, δοκιμάστε ξανά';

  @override
  String get fontSizeTitle => 'Μέγεθος γραμματοσειράς';

  @override
  String get fontSizeSmall => 'Μικρό';

  @override
  String get fontSizeNormal => 'Τυπικό';

  @override
  String get fontSizeLarge => 'Μεγάλο';

  @override
  String get fontSizeExtraLarge => 'Εξτρα Μεγάλο';

  @override
  String get fontSizePreview => 'Προεπισκόπηση';

  @override
  String get chatBackgroundTitle => 'Φόντο συνομιλίας';

  @override
  String get chatBackgroundDefault => 'Προεπιλογή';

  @override
  String get chatBackgroundCustom => 'Προσαρμοσμένο';

  @override
  String get chatBackgroundReset => 'Επαναφορά Προεπιλογών';

  @override
  String get termsTitle => 'Όροι χρήσης';

  @override
  String get privacyPolicyTitle => 'Πολιτική Απορρήτου';

  @override
  String get recentContactsTitle => 'Πρόσφατα';

  @override
  String get recentContactsEmpty => 'Δεν υπάρχουν πρόσφατες επαφές';

  @override
  String get inviteFriendsTitle => 'Πρόσκληση φίλων';

  @override
  String get inviteFriendsCopyLink => 'Αντιγραφή συνδέσμου πρόσκλησης';

  @override
  String get inviteFriendsLinkCopied => 'Ο σύνδεσμος πρόσκλησης αντιγράφηκε';

  @override
  String get imageViewerTitle => 'Φωτογραφία';

  @override
  String get imageViewerSave => 'Αποθήκευση στο Άλμπουμ';

  @override
  String get imageViewerSaveSuccess => 'Αποθηκεύτηκε στο άλμπουμ';

  @override
  String get imageViewerSaveFailed => 'Αποτυχία αποθήκευσης, δοκιμάστε ξανά';

  @override
  String get customerServiceTitle => 'Γραφείο εξυπηρέτησης';

  @override
  String get customerServiceQueue => 'Σε αναμονή';

  @override
  String get customerServiceActive => 'Ενεργές';

  @override
  String get customerServiceClaim => 'Αποδοχή';

  @override
  String get customerServiceTakeover => 'Ανάληψη';

  @override
  String get customerServiceClose => 'Τερματισμός εξυπηρέτησης';

  @override
  String get customerServiceCloseConfirm =>
      'Τερματισμός αυτής της συνεδρίας εξυπηρέτησης;';

  @override
  String get customerServiceNoQueue => 'Δεν υπάρχουν συνεδρίες σε αναμονή';

  @override
  String get customerServiceNoActive => 'Δεν υπάρχουν ενεργές συνεδρίες';

  @override
  String get customerServiceVisitor => 'Επισκέπτης';

  @override
  String get customerServiceCustomer => 'Πελάτης';

  @override
  String get customerServiceAssignedTo => 'Ανατέθηκε σε';

  @override
  String get customerServiceTransferConversation => 'Μεταβίβαση συνομιλίας';

  @override
  String get marketingToolbar => 'Εργαλεία μάρκετινγκ';

  @override
  String get callIncoming => 'Εισερχόμενη κλήση';

  @override
  String get callOutgoing => 'Εξερχόμενη κλήση';

  @override
  String get callAccept => 'Αποδοχή';

  @override
  String get callReject => 'Άρνηση';

  @override
  String get callHangup => 'Τέλος';

  @override
  String get callMissed => 'Αναπάντητη κλήση';

  @override
  String get callDuration => 'Διάρκεια';

  @override
  String get callAudio => 'Φωνητική κλήση';

  @override
  String get callGeneric => 'Κλήση';

  @override
  String get callVideo => 'Βιντεοκλήση';

  @override
  String get callConnecting => 'Σύνδεση...';

  @override
  String get callRinging => 'Κουδουνίζει...';

  @override
  String get callEnded => 'Η κλήση τελείωσε';

  @override
  String get callFailed => 'Αποτυχία κλήσης';

  @override
  String get callRejected => 'Η κλήση απορρίφθηκε';

  @override
  String get callTimeout => 'Δεν απαντά';

  @override
  String get callCancelled => 'Ακυρώθηκε';

  @override
  String get callUnknownPeer => 'Άγνωστο';

  @override
  String get callVideoInvitation => 'Πρόσκληση βιντεοκλήσης';

  @override
  String get callAudioInvitation => 'Πρόσκληση φωνητικής κλήσης';

  @override
  String get callAnswerAudio => 'Απάντηση με ήχο';

  @override
  String get callAnswerVideo => 'Απάντηση με βίντεο';

  @override
  String get callViewProfile => 'Προβολή προφίλ';

  @override
  String get callOpeningCamera => 'Άνοιγμα κάμερας...';

  @override
  String get callWaitingRemoteVideo => 'Αναμονή βίντεο συνομιλητή...';

  @override
  String get callCameraOff => 'Κάμερα κλειστή';

  @override
  String get callCameraOn => 'Κάμερα ανοιχτή';

  @override
  String get callMicrophoneOff => 'Μικρόφωνο κλειστό';

  @override
  String get callMicrophoneOn => 'Μικρόφωνο ανοιχτό';

  @override
  String get callSpeakerOff => 'Ηχείο κλειστό';

  @override
  String get callSpeakerOn => 'Ηχείο ανοιχτό';

  @override
  String get callVideoPermissionFailure =>
      'Δεν ξεκίνησε η βιντεοκλήση. Ελέγξτε τα δικαιώματα κάμερας και μικροφώνου και δοκιμάστε ξανά.';

  @override
  String get callAudioPermissionFailure =>
      'Δεν ξεκίνησε η φωνητική κλήση. Ελέγξτε το δικαίωμα μικροφώνου και δοκιμάστε ξανά.';

  @override
  String get callIncompleteIncoming =>
      'Τα στοιχεία εισερχόμενης κλήσης είναι ελλιπή και δεν μπορεί να απαντηθεί.';

  @override
  String get callInProgress => 'Σε κλήση';

  @override
  String get callCalling => 'Κλήση...';

  @override
  String callEndedMedia(String media) {
    return 'Η $media τελείωσε';
  }

  @override
  String callRejectedMedia(String media) {
    return 'Η $media απορρίφθηκε';
  }

  @override
  String callUnansweredMedia(String media) {
    return 'Η $media δεν απαντήθηκε';
  }

  @override
  String callCancelledMedia(String media) {
    return 'Η $media ακυρώθηκε';
  }

  @override
  String get callConnectionLost => 'Η σύνδεση κλήσης χάθηκε';

  @override
  String get callAdminEnded => 'Η κλήση τερματίστηκε από διαχειριστή';

  @override
  String callFailedMedia(String media) {
    return 'Η $media απέτυχε';
  }

  @override
  String get callBusy => 'Ο συνομιλητής είναι απασχολημένος';

  @override
  String callDurationValue(String duration) {
    return 'Διάρκεια κλήσης $duration';
  }

  @override
  String get callNotConnected => 'Δεν συνδέθηκε';

  @override
  String get callDialed => 'Εξερχόμενη';

  @override
  String get callAnswered => 'Απαντήθηκε';

  @override
  String get callRejectedByPeer => 'Απορρίφθηκε από τον συνομιλητή';

  @override
  String get callRejectedBySelf => 'Απορρίφθηκε';

  @override
  String get callPeerDidNotAnswer => 'Ο συνομιλητής δεν απάντησε';

  @override
  String get callMissedIncoming => 'Αναπάντητη εισερχόμενη κλήση';

  @override
  String get callPeerCancelled => 'Ακυρώθηκε από τον συνομιλητή';

  @override
  String get notificationNewMessageTitle => 'Νέο μήνυμα StartLink';

  @override
  String get notificationOnlineServiceTitle =>
      'Νέο μήνυμα εξυπηρέτησης πελατών';

  @override
  String get notificationNewMessageBody => 'Λάβατε νέο μήνυμα';

  @override
  String get notificationImagePreview => 'Έστειλε εικόνα';

  @override
  String get notificationVideoPreview => 'Έστειλε βίντεο';

  @override
  String get notificationVoicePreview => 'Έστειλε φωνητικό μήνυμα';

  @override
  String get notificationFilePreview => 'Έστειλε αρχείο';

  @override
  String get notificationContactPreview => 'Έστειλε κάρτα επαφής';

  @override
  String get notificationCallLogPreview => 'Έστειλε εγγραφή κλήσης';

  @override
  String get notificationLocationPreview => 'Κοινοποίησε τοποθεσία';

  @override
  String get notificationLinkPreview => 'Κοινοποίησε σύνδεσμο';

  @override
  String notificationMentionMe(String body) {
    return 'Σας ανέφερε: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return 'Ο/Η $sender σας ανέφερε: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Ανέφερε όλους: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return 'Ο/Η $sender ανέφερε όλους: $body';
  }

  @override
  String get notificationSecurityTitle => 'Ειδοποίηση ασφάλειας λογαριασμού';

  @override
  String get notificationSecurityBody =>
      'Οι ρυθμίσεις ασφάλειας του λογαριασμού StartLink άλλαξαν. Ελέγξτε τις τώρα.';

  @override
  String get notificationFriendAcceptedTitle => 'Το αίτημα φιλίας έγινε δεκτό';

  @override
  String get notificationFriendRejectedTitle => 'Το αίτημα φιλίας απορρίφθηκε';

  @override
  String get notificationFriendAcceptedBody =>
      'Ο συνομιλητής αποδέχτηκε το αίτημα φιλίας σας';

  @override
  String get notificationFriendRejectedBody =>
      'Ο συνομιλητής απέρριψε το αίτημα φιλίας σας';

  @override
  String get notificationVideoCallTitle => 'Πρόσκληση βιντεοκλήσης';

  @override
  String get notificationAudioCallTitle => 'Πρόσκληση φωνητικής κλήσης';

  @override
  String notificationVideoCallBody(String caller) {
    return 'Ο/Η $caller σας προσκάλεσε σε βιντεοκλήση';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return 'Ο/Η $caller σας προσκάλεσε σε φωνητική κλήση';
  }

  @override
  String get notificationMessageChannelName => 'Μηνύματα';

  @override
  String get notificationMessageChannelDescription =>
      'Μηνύματα συνομιλιών, εγγραφές κλήσεων και ειδοποιήσεις συστήματος';

  @override
  String get notificationCallChannelName => 'Κλήσεις';

  @override
  String get notificationCallChannelDescription =>
      'Ειδοποιήσεις φωνητικών κλήσεων και βιντεοκλήσεων';

  @override
  String get notificationSecurityChannelName => 'Ασφάλεια λογαριασμού';

  @override
  String get notificationSecurityChannelDescription =>
      'Ειδοποιήσεις σύνδεσης και αλλαγής κωδικού ή αριθμού κινητού';

  @override
  String get notificationUnknownCaller => 'Άγνωστος καλών';

  @override
  String get pendingJoinRequestsTitle => 'Νέες αιτήσεις';

  @override
  String get pendingJoinRequestsEmpty => 'Δεν υπάρχουν αιτήσεις';

  @override
  String get pendingJoinRequestApprove => 'Συμφωνώ';

  @override
  String get pendingJoinRequestReject => 'Άρνηση';

  @override
  String get pendingJoinRequestApproveSuccess => 'Εγκρίθηκε';

  @override
  String get pendingJoinRequestRejectSuccess => 'Απορρίφθηκε';

  @override
  String get pendingJoinRequestFailed => 'Η ενέργεια απέτυχε, δοκιμάστε ξανά';

  @override
  String get myCustomersTitle => 'Οι πελάτες μου';

  @override
  String get myCustomersEmpty => 'Δεν υπάρχουν πελάτες';

  @override
  String get groupListTitle => 'Ομάδες';

  @override
  String get groupListEmpty => 'Δεν υπάρχουν ομάδες';

  @override
  String get addFriendTitle => 'Προσθήκη επαφής';

  @override
  String get addFriendSearchHint => 'Τηλέφωνο / Email / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Προσθήκη';

  @override
  String get addFriendCannotAddSelf =>
      'Δεν μπορείτε να προσθέσετε τον εαυτό σας';

  @override
  String get addFriendUnsupportedUser =>
      'Αυτός ο χρήστης δεν μπορεί να προστεθεί. Μπορείτε να του στείλετε μήνυμα απευθείας.';

  @override
  String get addFriendMessageHint => 'Εισαγάγετε μήνυμα';

  @override
  String get addFriendSendRequest => 'Αποστολή αιτήματος';

  @override
  String get joinCompanyTitle => 'Συμμετοχή σε εταιρεία';

  @override
  String get joinCompanyCodeHint => 'Εισαγάγετε κωδικό εταιρείας';

  @override
  String get joinCompanySearchHint => 'Αναζήτηση ονόματος εταιρείας';

  @override
  String get joinCompanyApply => 'Αίτηση συμμετοχής';

  @override
  String get joinCompanyApplySuccess => 'Η αίτηση υποβλήθηκε';

  @override
  String get joinCompanyApplyFailed => 'Αποτυχία αίτησης, δοκιμάστε ξανά';

  @override
  String get joinCompanyAutoApproved => 'Εγκρίθηκε αυτόματα. Καλώς ήρθατε!';

  @override
  String get joinCompanyPending => 'Η αίτηση υποβλήθηκε, αναμένεται έγκριση';

  @override
  String get joinCompanyInviteCodeHint => 'Εισαγάγετε κωδικό πρόσκλησης';

  @override
  String get joinCompanyAcceptInvite => 'Αποδοχή πρόσκλησης';

  @override
  String get joinCompanyNoResults => 'Δεν βρέθηκαν εταιρείες';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count μέλη';
  }

  @override
  String get timezoneNameHawaii => 'Χαβάη';

  @override
  String get timezoneNameAlaska => 'Αλάσκα';

  @override
  String get timezoneNamePacificTime => 'Ώρα Ειρηνικού';

  @override
  String get timezoneNameMountainTime => 'Ορεινή ώρα';

  @override
  String get timezoneNameCentralTime => 'Κεντρική ώρα';

  @override
  String get timezoneNameEasternTime => 'Ανατολική ώρα';

  @override
  String get timezoneNameAtlanticTime => 'Ώρα Ατλαντικού';

  @override
  String get timezoneNameBrasilia => 'Μπραζίλια';

  @override
  String get timezoneNameAzores => 'Αζόρες';

  @override
  String get timezoneNameLondonDublin => 'Λονδίνο/Δουβλίνο';

  @override
  String get timezoneNameBerlinParisRome => 'Βερολίνο/Παρίσι/Ρώμη';

  @override
  String get timezoneNameCairoHelsinki => 'Κάιρο/Ελσίνκι';

  @override
  String get timezoneNameMoscowRiyadh => 'Μόσχα/Ριάντ';

  @override
  String get timezoneNameTehran => 'Τεχεράνη';

  @override
  String get timezoneNameDubaiBaku => 'Ντουμπάι/Μπακού';

  @override
  String get timezoneNameKabul => 'Καμπούλ';

  @override
  String get timezoneNameKarachiTashkent => 'Καράτσι/Τασκένδη';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Μουμπάι/Νέο Δελχί';

  @override
  String get timezoneNameKathmandu => 'Κατμαντού';

  @override
  String get timezoneNameDhakaAlmaty => 'Ντάκα/Αλμάτι';

  @override
  String get timezoneNameYangon => 'Γιανγκόν';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Μπανγκόκ/Ανόι/Τζακάρτα';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Πεκίνο/Σαγκάη/Χονγκ Κονγκ/Ταϊπέι';

  @override
  String get timezoneNameTokyoSeoul => 'Τόκιο/Σεούλ';

  @override
  String get timezoneNameAdelaide => 'Αδελαΐδα';

  @override
  String get timezoneNameSydneyMelbourne => 'Σίδνεϊ/Μελβούρνη';

  @override
  String get timezoneNameSolomonIslands => 'Νήσοι Σολομώντα';

  @override
  String get timezoneNameAucklandFiji => 'Όκλαντ/Φίτζι';

  @override
  String get networkSmartSelectBestRoute =>
      'Έξυπνη επιλογή καλύτερης διαδρομής';

  @override
  String get networkTesting => 'Δοκιμή...';

  @override
  String get networkTestingShort => 'Δοκιμή';

  @override
  String networkLatencyMs(int ms) {
    return 'Καθυστέρηση $ms ms';
  }

  @override
  String get networkConnectionMode => 'Τρόπος σύνδεσης';

  @override
  String get networkDirectMode => 'Απευθείας σύνδεση';

  @override
  String get networkProxyMode => 'Σύνδεση μέσω proxy';

  @override
  String get networkDirectModeDesc => 'Απευθείας σύνδεση στον διακομιστή';

  @override
  String get networkProxyModeDesc => 'Σύνδεση μέσω διακομιστή proxy';

  @override
  String get networkDirectRoutes => 'Απευθείας διαδρομές';

  @override
  String get networkProxyRoutes => 'Διαδρομές proxy';

  @override
  String get networkTestAll => 'Δοκιμή όλων';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Κόμβος Χονγκ Κονγκ';

  @override
  String get networkSingaporeNode => 'Κόμβος Σιγκαπούρης';

  @override
  String get networkJapanNode => 'Κόμβος Ιαπωνίας';

  @override
  String get networkUnitedStatesNode => 'Κόμβος ΗΠΑ';

  @override
  String get networkHint =>
      'Συμβουλές:\n• Απευθείας σύνδεση: ταχύτερη και κατάλληλη για εγχώρια χρήση\n• Μέσω proxy: πιο σταθερή για διεθνή επικοινωνία\n• Πατήστε το εικονίδιο ανανέωσης για μέτρηση της καθυστέρησης μίας διαδρομής';

  @override
  String get teenModeTitle => 'Λειτουργία εφήβων';

  @override
  String get teenModeStatusOn => 'Ενεργό';

  @override
  String get teenModeStatusOff => 'Ανενεργή';

  @override
  String get teenModeStatusLoading => 'Φόρτωση';

  @override
  String get teenModeUnavailable =>
      'Η κατάσταση λειτουργίας εφήβων δεν είναι προσωρινά διαθέσιμη';

  @override
  String get teenModeInvalidResponse =>
      'Η λειτουργία εφήβων επέστρεψε μη έγκυρη απάντηση';

  @override
  String get teenModeEnableDescription =>
      'Οι κανόνες της πλατφόρμας περιορίζουν τον χρόνο χρήσης και ορισμένες λειτουργίες.';

  @override
  String get teenModePasscode => 'Κωδικός PIN';

  @override
  String get teenModeCurrentPasscode => 'Τρέχων κωδικός PIN';

  @override
  String get teenModeNewPasscode => 'Νέος κωδικός PIN';

  @override
  String get teenModePasscodeHint => 'Εισαγάγετε 4–6 ψηφία';

  @override
  String get teenModeEnable => 'Ενεργοποίηση λειτουργίας εφήβων';

  @override
  String get teenModeDisable => 'Απενεργοποίηση λειτουργίας εφήβων';

  @override
  String get teenModeChangePasscode => 'Αλλαγή κωδικού PIN';

  @override
  String get teenModeSource => 'Ενεργοποιήθηκε από';

  @override
  String get teenModeDailyUsage => 'Χρήση σήμερα';

  @override
  String get teenModeRemaining => 'Χρόνος που απομένει';

  @override
  String get teenModeMinutesUnit => 'Λεπτά';

  @override
  String get teenModeUnlimited => 'Απεριόριστος';

  @override
  String get teenModeRequestExtension => 'Αίτημα για περισσότερο χρόνο';

  @override
  String get teenModeExtensionSubmitted =>
      'Το αίτημα χρόνου στάλθηκε στον κηδεμόνα';

  @override
  String get teenModeTimeLimitReached => 'Εξαντλήθηκε το σημερινό όριο χρήσης';

  @override
  String get teenModeCurfewActive => 'Αυτή είναι περίοδος περιορισμένης χρήσης';

  @override
  String get teenModeReliefHint =>
      'Μπορείτε ακόμη να δείτε το ιστορικό, να επικοινωνήσετε με επίσημη υποστήριξη και να αναφέρετε προβλήματα.';

  @override
  String get teenModeRestrictedNotice =>
      'Η λειτουργία εφήβων εμποδίζει την αποστολή μηνυμάτων τώρα';

  @override
  String get teenModeActionBlocked =>
      'Η λειτουργία εφήβων εμποδίζει αυτή την ενέργεια τώρα';

  @override
  String get teenModeMyRequests => 'Τα αιτήματά μου';

  @override
  String get guardianCenterTitle => 'Κέντρο κηδεμόνα';

  @override
  String get guardianRelationships => 'Σχέσεις κηδεμονίας';

  @override
  String get guardianMinors => 'Παιδιά που επιβλέπω';

  @override
  String get guardianApprovals => 'Εκκρεμείς εγκρίσεις';

  @override
  String get guardianBind => 'Εισαγάγετε κωδικό σύνδεσης';

  @override
  String get guardianCreateMinorCode => 'Είμαι παιδί — δημιουργία κωδικού';

  @override
  String get guardianCreateGuardianCode =>
      'Είμαι κηδεμόνας — δημιουργία κωδικού';

  @override
  String get guardianRelation => 'Σχέση';

  @override
  String get guardianPrimary => 'Κύριος κηδεμόνας';

  @override
  String get guardianCode => '6ψήφιος κωδικός σύνδεσης';

  @override
  String get guardianCodeHint =>
      'Εισαγάγετε τον κωδικό που έδωσε το άλλο άτομο';

  @override
  String get guardianCodeCreated =>
      'Ο κωδικός δημιουργήθηκε. Κοινοποιήστε τον πριν λήξει.';

  @override
  String get guardianEmpty => 'Δεν υπάρχουν σχέσεις κηδεμονίας';

  @override
  String get guardianNoMinors => 'Δεν υπάρχουν επιβλεπόμενα παιδιά';

  @override
  String get guardianUnbind => 'Αφαίρεση σχέσης';

  @override
  String get guardianExtend => 'Προσθήκη χρόνου για παιδί';

  @override
  String get guardianPolicyTitle => 'Κανόνες χρήσης';

  @override
  String get guardianPolicyLocked => 'Κλειδωμένο από την πλατφόρμα';

  @override
  String get approvalEmpty => 'Δεν υπάρχουν αιτήματα';

  @override
  String get approvalApprove => 'Συμφωνώ';

  @override
  String get approvalReject => 'Άρνηση';

  @override
  String get approvalPending => 'Σε εκκρεμότητα';

  @override
  String get approvalApproved => 'Εγκρίθηκε';

  @override
  String get approvalRejected => 'Απορρίφθηκε';

  @override
  String get approvalExpired => 'Ληγμένο';

  @override
  String get approvalCancelled => 'Ακυρώθηκε';

  @override
  String get approvalReplayFailed =>
      'Η αρχική ενέργεια απέτυχε. Δοκιμάστε την ξανά.';

  @override
  String get requestCancelled => 'Το αίτημα ακυρώθηκε';

  @override
  String get kycTitle => 'Επαλήθευση Ταυτότητας';

  @override
  String get kycNotRequired => 'Δεν απαιτείται επαλήθευση ταυτότητας';

  @override
  String get kycVerified => 'Η ταυτότητα επαληθεύτηκε';

  @override
  String get kycDeclared => 'Υποβλήθηκαν στοιχεία ταυτότητας';

  @override
  String get kycPending => 'Υπό έλεγχο';

  @override
  String get kycRejected => 'Ο έλεγχος απορρίφθηκε';

  @override
  String get kycNone => 'Δεν υποβλήθηκαν στοιχεία ταυτότητας';

  @override
  String get kycRealName => 'Πλήρες Όνομα';

  @override
  String get kycIdNumber => 'Αριθμός ταυτότητας';

  @override
  String get kycIdType => 'Τύπος εγγράφου';

  @override
  String get kycApplicability =>
      'Εισαγάγετε τα πραγματικά στοιχεία για το επιλεγμένο έγγραφο. Οι αποδεκτοί τύποι φαίνονται στη λίστα.';

  @override
  String get kycCamera => 'Τραβήξτε φωτογραφία';

  @override
  String get kycGallery => 'Επιλογή από συλλογή';

  @override
  String get kycPhotoLimit => 'Μέγιστο ανά φωτογραφία';

  @override
  String get kycSelectPhoto => 'Επιλέξτε φωτογραφία';

  @override
  String get kycPhotoSelected => 'Επιλέχθηκε';

  @override
  String get kycViewPhoto => 'Πατήστε για προβολή φωτογραφίας';

  @override
  String get kycReplacePhoto => 'Επιλογή άλλης φωτογραφίας';

  @override
  String get kycDisclosure =>
      'Χρησιμοποιούμε το όνομα, τον αριθμό εγγράφου και τις φωτογραφίες του για τον έλεγχο της ταυτότητάς σας. Χωρίς αυτά δεν μπορείτε να υποβάλετε αίτηση και ορισμένες περιορισμένες λειτουργίες ενδέχεται να μην είναι διαθέσιμες.';

  @override
  String get kycConsent =>
      'Συναινώ χωριστά στην επεξεργασία αυτών των στοιχείων ταυτότητας';

  @override
  String get kycConsentRequired => 'Δώστε χωριστή συγκατάθεση πριν την υποβολή';

  @override
  String get kycResubmitTitle => 'Εκ νέου υποβολή στοιχείων ταυτότητας';

  @override
  String get kycResubmitWarning =>
      'Η νέα υποβολή θα αντικαταστήσει την εκκρεμή αίτησή σας. Συνέχεια;';

  @override
  String get kycSubmitting => 'Υποβολή';

  @override
  String get kycSubmitFailed => 'Αποτυχία υποβολής. Δοκιμάστε ξανά.';

  @override
  String get kycSubmitUnavailable =>
      'Δεν μπορούν να υποβληθούν στοιχεία ταυτότητας τώρα';

  @override
  String get kycResubmitNotAllowed =>
      'Η επανυποβολή δεν είναι διαθέσιμη μετά από απόρριψη. Επικοινωνήστε με υποστήριξη αν χρειάζεται.';

  @override
  String get kycDailyLimit =>
      'Φτάσατε το ημερήσιο όριο υποβολών. Δοκιμάστε αύριο.';

  @override
  String get kycTypeUnavailable =>
      'Δεν υπάρχουν διαθέσιμοι τύποι εγγράφων. Δοκιμάστε αργότερα.';

  @override
  String get kycNameInvalid => 'Το νόμιμο όνομα πρέπει να έχει 2–64 χαρακτήρες';

  @override
  String get kycNumberRequired => 'Εισαγάγετε τον αριθμό εγγράφου';

  @override
  String get kycFrontRequired => 'Ανεβάστε την μπροστινή όψη του εγγράφου';

  @override
  String get kycBackRequired => 'Ανεβάστε την πίσω όψη του εγγράφου';

  @override
  String get kycPhotoTooLarge =>
      'Η φωτογραφία υπερβαίνει το όριο μεγέθους. Συμπιέστε την και δοκιμάστε ξανά.';

  @override
  String get kycAccountChanged =>
      'Ο λογαριασμός ή ο χώρος άλλαξε. Ανοίξτε ξανά τη σελίδα.';

  @override
  String get kycPhotoInvalid => 'Επιλέξτε έγκυρη εικόνα';

  @override
  String get kycPortraitSide => 'Όψη πορτρέτου';

  @override
  String get kycEmblemSide => 'Όψη εμβλήματος';

  @override
  String get kycPassportDataPage => 'Σελίδα στοιχείων διαβατηρίου';

  @override
  String get kycPassportOtherPage =>
      'Σελίδα θεώρησης ή κενή σελίδα διαβατηρίου';

  @override
  String get kycFront => 'Μπροστινή όψη ταυτότητας';

  @override
  String get kycBack => 'Πίσω όψη ταυτότητας';

  @override
  String get kycRequired =>
      'Απαιτείται επαλήθευση ταυτότητας πριν τη δημιουργία ομάδας';

  @override
  String get kycGoVerify => 'Επαλήθευση τώρα';

  @override
  String get kycStatusUnknown =>
      'Η κατάσταση ταυτότητας δεν είναι διαθέσιμη. Ανανεώστε αργότερα.';

  @override
  String get kycSuperseded =>
      'Μια νεότερη υποβολή αντικατέστησε αυτή. Ελέγξτε την τελευταία κατάσταση ταυτότητας.';

  @override
  String get kycMediaNotFound =>
      'Η φωτογραφία εγγράφου δεν είναι διαθέσιμη σε αυτόν τον χώρο. Επιλέξτε την ξανά πριν την υποβολή.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Μαζική αποστολή σε πελάτες';

  @override
  String get officialAccountBadge => 'Επίσημος';

  @override
  String get officialAccountOpenConversation => 'Άνοιγμα συνομιλίας';

  @override
  String get officialAccountJoinHint =>
      'Η προσθήκη αυτού του λογαριασμού σάς εντάσσει στην εταιρεία ως πελάτη. Δεν απαιτείται έγκριση φιλίας.';

  @override
  String get officialAccountJoinDisabled =>
      'Η εταιρεία δεν δέχεται νέους πελάτες. Επικοινωνήστε με υποστήριξη.';

  @override
  String get officialAccountRemoved =>
      'Αφαιρεθήκατε από την εταιρεία. Ζητήστε να σας προσκαλέσουν ξανά.';

  @override
  String get officialAccountBanned =>
      'Ο λογαριασμός σας έχει απενεργοποιηθεί σε αυτή την εταιρεία.';

  @override
  String get officialAccountUnavailable =>
      'Αυτός ο επίσημος λογαριασμός δεν είναι διαθέσιμος τώρα.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Η συμμετοχή σε εταιρεία δεν επιτρέπεται στην τρέχουσα λειτουργία.';

  @override
  String get officialAccountPlatformRequired =>
      'Χρησιμοποιήστε λογαριασμό πλατφόρμας για να προσθέσετε αυτόν τον επίσημο λογαριασμό.';

  @override
  String get officialAccountOpenFailed =>
      'Δεν άνοιξε η συνομιλία. Δοκιμάστε ξανά.';

  @override
  String get officialAccountAccountChanged =>
      'Ο λογαριασμός ή ο χώρος άλλαξε. Ανοίξτε το ξανά.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Ο κατάλογος εταιρείας δεν είναι ενημερωμένος. Δοκιμάστε σε λίγο.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Απέτυχε ο συγχρονισμός επίσημου λογαριασμού. Το τοπικό περιεχόμενο παραμένει διαθέσιμο.';

  @override
  String get officialAccountInboxSyncing =>
      'Συγχρονισμός μηνυμάτων επίσημου λογαριασμού';

  @override
  String get diagnosticsTitle => 'Διαγνωστικά';

  @override
  String get diagnosticsExplanation =>
      'Στα αρχεία καταγραφής αποκρύπτονται ευαίσθητα δεδομένα. Περιέχουν λειτουργικές πληροφορίες και σφάλματα για αυτόν τον λογαριασμό και χώρο, καθώς και δημόσια συμβάντα εκκίνησης. Δεν περιλαμβάνονται περιεχόμενο συνομιλιών και διαπιστευτήρια.';

  @override
  String get diagnosticsHour => 'Τελευταία ώρα';

  @override
  String get diagnosticsDay => 'Τελευταίες 24 ώρες';

  @override
  String get diagnosticsWeek => '7Η';

  @override
  String diagnosticsEventCount(int count) {
    return 'Διαθέσιμα συμβάντα: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Τα αρχεία καταγραφής αποθηκεύονται σε αυτή τη συσκευή και παραμένουν διαθέσιμα μετά την επανεκκίνηση.';

  @override
  String get diagnosticsNotPersistent =>
      'Ορισμένα αρχεία δεν αποθηκεύτηκαν. Ανανεώστε για νέα προσπάθεια.';

  @override
  String get diagnosticsExport => 'Εξαγωγή και κοινοποίηση';

  @override
  String get diagnosticsRefresh => 'Ανανέωση';

  @override
  String get diagnosticsClear => 'Εκκαθάριση αρχείων αυτού του χώρου';

  @override
  String get diagnosticsClearConfirm =>
      'Εκκαθάριση διαγνωστικών αρχείων αυτού του χώρου; Το ιστορικό συνομιλιών θα διατηρηθεί.';

  @override
  String get diagnosticsShared =>
      'Η κοινοποίηση συστήματος ολοκληρώθηκε. Επιβεβαιώστε το αρχείο στην εφαρμογή παραλήπτη.';

  @override
  String get diagnosticsCancelled =>
      'Η κοινοποίηση ακυρώθηκε. Μπορείτε να εξαγάγετε ξανά.';

  @override
  String get diagnosticsUnconfirmed =>
      'Δεν επιβεβαιώθηκε η κοινοποίηση. Ελέγξτε την εφαρμογή παραλήπτη.';

  @override
  String get diagnosticsFailed => 'Η ενέργεια απέτυχε. Δοκιμάστε ξανά.';
}
