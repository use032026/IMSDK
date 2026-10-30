// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get navWorkbench => 'Area di lavoro';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Impossibile caricare i dati dell’account';

  @override
  String get startupFailureTitle => 'Avvio non riuscito';

  @override
  String get startupFailureMessage => 'Controlla la connessione e riprova';

  @override
  String get privacyConsentTitle =>
      'Termini di servizio e Informativa sulla privacy';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Benvenuto in $brand. Per offrire accesso all’account, messaggistica istantanea, collaborazione aziendale, assistenza clienti online, notifiche e protezione della sicurezza, dobbiamo trattare le informazioni necessarie secondo i Termini di servizio e l’Informativa sulla privacy.\n\nPrima che tocchi «Accetta», non leggiamo gli appunti, non inizializziamo JPush/JCore né gli SDK di notifiche dei produttori e non li usiamo per accedere ad Android ID, OAID, elenchi di app installate, indirizzi MAC o informazioni simili. Se rifiuti per ora, salviamo la tua scelta; puoi continuare a leggere i documenti e decidere nuovamente in seguito.\n\nDopo il consenso, per recapitare notifiche di messaggi, assistenza clienti e chiamate in arrivo, JPush/JCore e i servizi di notifiche dei produttori possono trattare modello del dispositivo, versione Android, pacchetto e versione dell’app, tipo di rete, indirizzo IP, Android ID, OAID, ID di registrazione push, token push del produttore e dati di consegna e clic delle notifiche. Abbiamo disattivato le funzioni non essenziali, tra cui notifiche intelligenti, elenchi di app installate, MAC, IMEI, IMSI, elenchi Wi-Fi, riattivazione automatica e avvio collegato.\n\nGli appunti sono consultati solo quando copi o incolli attivamente. Le autorizzazioni per fotocamera, microfono, notifiche e altre funzioni di sistema sono richieste solo quando usi la relativa funzione. Il rifiuto di una autorizzazione influisce solo su quella funzione. Leggi i documenti completi qui sotto e scegli se accettare.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Benvenuto in $brand. Per offrire accesso all’account, messaggistica istantanea, collaborazione aziendale, assistenza clienti online, notifiche e protezione della sicurezza, dobbiamo trattare le informazioni necessarie secondo i Termini di servizio e l’Informativa sulla privacy.\n\nPrima che tocchi «Accetta», non leggiamo gli appunti, non inizializziamo JPush/JCore, non ci registriamo al servizio Apple Push Notification (APNs) e non otteniamo identificativi push come l’ID di registrazione JPush o il token del dispositivo APNs. Se rifiuti per ora, salviamo la tua scelta; puoi continuare a leggere i documenti e decidere nuovamente in seguito.\n\nDopo il consenso, per recapitare notifiche di messaggi, assistenza clienti e chiamate in arrivo, possiamo trattare modello di iPhone, versione iOS, pacchetto e versione dell’app, tipo di rete, indirizzo IP, IDFV, ID di registrazione JPush, token del dispositivo APNs e dati di consegna e clic delle notifiche. JPush/JCore si collega al servizio push; Apple APNs tratta l’identificativo dell’app, il token del dispositivo e il contenuto delle notifiche per recapitare le notifiche di sistema. L’app iOS attuale non utilizza servizi pubblicitari e non ottiene IDFA.\n\nGli appunti sono consultati solo quando copi o incolli attivamente. Le autorizzazioni per fotocamera, microfono, notifiche e altre funzioni di sistema sono richieste solo quando usi la relativa funzione. Il rifiuto di una autorizzazione influisce solo su quella funzione. Leggi i documenti completi qui sotto e scegli se accettare.';
  }

  @override
  String get privacyConsentTermsLink => 'Condizioni d\'Uso';

  @override
  String get privacyConsentConjunction => 'e';

  @override
  String get privacyConsentPrivacyLink => 'Informativa sulla Privacy';

  @override
  String get privacyConsentDecline => 'Non accetto';

  @override
  String get privacyConsentDeclinedExit =>
      'Non hai accettato i Termini di servizio e l’Informativa sulla privacy. L’app verrà chiusa.';

  @override
  String get privacyConsentAccept => 'Accetto';

  @override
  String get privacyConsentRuntimeFailure =>
      'Avvio non riuscito. Controlla la connessione e riprova.';

  @override
  String get privacyConsentSaveFailure =>
      'Impossibile salvare la scelta. Riprova.';

  @override
  String get appUpdateRequiredTitle =>
      'Aggiornamento necessario per continuare';

  @override
  String get appUpdateOptionalTitle => 'Nuova versione disponibile';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version è disponibile';
  }

  @override
  String get appUpdateLater => 'Più tardi';

  @override
  String get appUpdateNow => 'Aggiorna ora';

  @override
  String get appUpdateProcessing => 'Elaborazione…';

  @override
  String get appUpdateInvalidUrl =>
      'L’indirizzo di aggiornamento non è valido. Riprova più tardi.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Impossibile aprire il collegamento di aggiornamento. Riprova più tardi.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Download interrotto. Controlla la connessione e riprova.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Verifica del pacchetto non riuscita. Scaricalo di nuovo.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Consenti a $brand di installare aggiornamenti nelle impostazioni di sistema.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Impossibile aprire il programma di installazione. Controlla le autorizzazioni di installazione.';

  @override
  String get appUpdateGenericFailure =>
      'Aggiornamento non riuscito. Controlla la connessione e riprova.';

  @override
  String get appUpdateUnavailable =>
      'La nuova versione non è ancora disponibile per il download. Riprova più tardi.';

  @override
  String get appUpdateCheckFailed =>
      'Impossibile cercare aggiornamenti. Riprova più tardi.';

  @override
  String get appUpdateChecking => 'Verifica in corso';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonEdit => 'Modifica';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonSearch => 'Cerca';

  @override
  String get commonLoading => 'Caricamento…';

  @override
  String get commonLoadFailed => 'Caricamento non riuscito';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonEmpty => 'Nessun dato';

  @override
  String get commonCopy => 'Copia';

  @override
  String get commonForward => 'Inoltra';

  @override
  String get commonFavorite => 'Salva';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonSend => 'Invia';

  @override
  String get commonDone => 'Fine';

  @override
  String get commonMore => 'Altro';

  @override
  String get commonSettings => 'Impostazioni';

  @override
  String get commonCopied => 'Copiato';

  @override
  String get commonUnknown => 'Sconosciuto';

  @override
  String get commonNotSet => 'Non impostato';

  @override
  String get commonUnbound => 'Non collegata';

  @override
  String get commonViewAll => 'Mostra tutto';

  @override
  String get commonSubmit => 'Invia';

  @override
  String get commonAdd => 'Aggiungi';

  @override
  String get commonRemove => 'Rimuovi';

  @override
  String get commonCreate => 'Crea';

  @override
  String get commonUpdate => 'Aggiorna';

  @override
  String get commonUpload => 'Carica';

  @override
  String get commonShare => 'Condividi';

  @override
  String get commonBlock => 'Blocca';

  @override
  String get commonUnblock => 'Sblocca';

  @override
  String get commonMute => 'Silenzia';

  @override
  String get commonUnmute => 'Riattiva audio';

  @override
  String get commonPin => 'In cima';

  @override
  String get commonUnpin => 'Rimuovi fissaggio';

  @override
  String get commonMarkRead => 'Segna come letto';

  @override
  String get commonMarkUnread => 'Segna come non letto';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Operazione non riuscita. Riprova.';

  @override
  String get commonNetworkError => 'Errore di rete. Controlla la connessione.';

  @override
  String get navMessages => 'Messaggi';

  @override
  String get navContacts => 'Contatti';

  @override
  String get navMe => 'Io';

  @override
  String get authLoginTitle => 'Accedi a StartLink';

  @override
  String get authTabMobile => 'Telefono';

  @override
  String get authTabEmail => 'Email';

  @override
  String get authTabLoginName => 'ID StartLink';

  @override
  String get authHintMobile => 'Inserisci il numero di telefono';

  @override
  String get authHintEmail => 'Inserisci il tuo indirizzo email';

  @override
  String get authHintPassword => 'Inserisci password';

  @override
  String get authHintCode => 'Inserisci il codice di verifica';

  @override
  String get authHintLoginName => 'Inserisci l’ID StartLink (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Accedi';

  @override
  String get authGetCode => 'Richiedi codice';

  @override
  String authResendCode(int seconds) {
    return 'Invia di nuovo tra $seconds s';
  }

  @override
  String get authUsePassword => 'Usa la password';

  @override
  String get authUseCode => 'Usa il codice di verifica';

  @override
  String get authAgreementPrefix => 'Ho letto e accetto i';

  @override
  String get authAgreementAnd => 'e';

  @override
  String get authTermsLink => 'Condizioni d\'Uso';

  @override
  String get authPrivacyLink => 'Informativa sulla Privacy';

  @override
  String get authCaptchaTitle => 'Verifica di sicurezza';

  @override
  String get authCaptchaHint => 'Inserisci la risposta';

  @override
  String get authCaptchaFailed => 'Impossibile ottenere il captcha. Riprova.';

  @override
  String get authErrorEmptyCode => 'Inserisci il codice di verifica';

  @override
  String get authErrorEmptyPassword => 'Inserisci password';

  @override
  String get authErrorEmptyLoginName => 'Inserisci l’ID StartLink';

  @override
  String get authErrorWrongCredentials => 'Account o password errati';

  @override
  String get authDeactivatingTitle => 'Eliminazione dell’account';

  @override
  String get authDeactivatingContent =>
      'Il tuo account è nel periodo di ripensamento per l’eliminazione (7 giorni).\n\nPer annullare l’eliminazione, tocca «Annulla eliminazione»; altrimenti tocca «Continua» per accedere all’app.';

  @override
  String get authContinueUse => 'Continua';

  @override
  String get authCancelDeactivation => 'Annulla eliminazione';

  @override
  String get authDeactivationCancelled =>
      'Eliminazione annullata, account ripristinato';

  @override
  String get authDeactivationCancelFailed =>
      'Annullamento non riuscito. Riprova.';

  @override
  String get authLogout => 'Esci';

  @override
  String get authLogoutConfirm => 'Vuoi davvero uscire?';

  @override
  String get authSendingCode => 'Invio…';

  @override
  String get authCodeSent => 'Codice di verifica inviato';

  @override
  String get authLoginFailed => 'Accesso non riuscito. Riprova.';

  @override
  String get authRegisterFailed => 'Registrazione non riuscita. Riprova.';

  @override
  String get authEnterpriseCode => 'Codice aziendale';

  @override
  String get authEnterpriseCodeHint => 'Inserisci il codice aziendale';

  @override
  String get authPendingApproval =>
      'Registrazione riuscita. La tua richiesta di adesione all’azienda è stata inviata ed è in attesa di approvazione.';

  @override
  String get authNoAccount => 'Non hai un account?';

  @override
  String get authRegisterNow => 'Registrati ora';

  @override
  String get authCountryPickerTitle => 'Seleziona paese o regione';

  @override
  String get authCountrySearchHint => 'Cerca paese o regione';

  @override
  String get authCountryChinaMainland => 'Cina continentale';

  @override
  String get authCountryHongKong => 'Hong Kong, Cina';

  @override
  String get authCountryMacau => 'Macao, Cina';

  @override
  String get authCountryTaiwan => 'Taiwan, Cina';

  @override
  String get authCountryUnitedStates => 'Stati Uniti';

  @override
  String get authCountryUnitedKingdom => 'Regno Unito';

  @override
  String get authCountryJapan => 'Giappone';

  @override
  String get authCountrySouthKorea => 'Corea del Sud';

  @override
  String get authCountrySingapore => 'Singapore';

  @override
  String get authCountryMalaysia => 'Malesia';

  @override
  String get authCountryAustralia => 'Australia';

  @override
  String get authCountryCanada => 'Canada';

  @override
  String get authCountryGermany => 'Germania';

  @override
  String get authCountryFrance => 'Francia';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Thailandia';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesia';

  @override
  String get authCountryPhilippines => 'Filippine';

  @override
  String get authQuickLoginTitle => 'Accesso rapido';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Accesso in corso. Attendi.';

  @override
  String get authRoleOwner => 'Proprietario';

  @override
  String get authRoleAdministrator => 'Amministratore';

  @override
  String get authRoleCustomerService => 'Assistenza clienti';

  @override
  String get authRoleTechnicalSupport => 'Supporto tecnico';

  @override
  String get authRoleEmployee => 'Dipendente';

  @override
  String get authRoleMember => 'Membro';

  @override
  String get authRoleEnterpriseCustomer => 'Cliente aziendale';

  @override
  String get authUnavailablePrefix => 'Non disponibile · ';

  @override
  String get authUnassignedService => 'Nessun operatore assegnato';

  @override
  String authAssignedService(String staff) {
    return 'Assegnato a $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Cliente · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Dipendente · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count utenti';
  }

  @override
  String get authMetaPhone => 'Telefono';

  @override
  String get authMetaIdentity => 'Identità';

  @override
  String get authRegisterTitle => 'Registrati';

  @override
  String get authNickname => 'Nickname';

  @override
  String get authNicknameHint => 'Imposta un soprannome';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordSetHint => 'Imposta una password (almeno 6 caratteri)';

  @override
  String get authConfirmPassword => 'Conferma password';

  @override
  String get authConfirmPasswordHint => 'Inserisci di nuovo la password';

  @override
  String get authVerificationCode => 'Codice di verifica';

  @override
  String get authRegisterAndLogin => 'Registrati e accedi';

  @override
  String get authHaveAccount => 'Hai già un account?';

  @override
  String get authGoLogin => 'Accedi';

  @override
  String get authEmailVerificationUnavailable =>
      'La verifica e-mail non è disponibile. Registrati con un numero di cellulare.';

  @override
  String get authSmsVerificationUnavailable =>
      'La verifica SMS non è disponibile. Registrati con un indirizzo e-mail.';

  @override
  String get authSendFailed => 'Invio non riuscito. Riprova.';

  @override
  String get authErrorEmptyNickname => 'Inserisci un soprannome';

  @override
  String get authErrorInvalidMobile =>
      'Inserisci un numero di cellulare valido';

  @override
  String get authErrorInvalidEmail => 'Inserisci un indirizzo e-mail valido';

  @override
  String get authErrorPasswordTooShort =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get authErrorPasswordMismatch => 'Le password non coincidono';

  @override
  String get authErrorVerificationRequired =>
      'Richiedi e inserisci prima il codice di verifica';

  @override
  String get authRegisterErrorTitle => 'Registrazione non riuscita';

  @override
  String get authGotIt => 'Capito';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Azienda «$code» non trovata. Controlla il codice aziendale.';
  }

  @override
  String get authTenantSearchFailed => 'Ricerca non riuscita. Riprova.';

  @override
  String get authInvitationInvalid =>
      'Il codice di invito non è valido. Controllalo e riprova.';

  @override
  String get authCollapseJoin => 'Nascondi le informazioni di adesione';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Invito valido: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Azienda trovata: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Seleziona un’organizzazione';

  @override
  String get authNoOrganization => 'Nessuna organizzazione disponibile';

  @override
  String get authNoOrganizationHint =>
      'Chiedi a un amministratore di invitarti in un’organizzazione';

  @override
  String get authPersonalSpace => 'Spazio personale';

  @override
  String get authPersonalSpaceSubtitle =>
      'Chat con amici e preferiti personali';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Impossibile verificare l’identità dello spazio. Riprova.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Impossibile ripristinare lo spazio personale. Riprova.';

  @override
  String get authJoinEnterpriseFailed =>
      'Impossibile aderire all’azienda. Riprova più tardi.';

  @override
  String get homeTitle => 'Messaggi';

  @override
  String get homeGatewayConnectingTitle => 'Connessione in corso';

  @override
  String get homePersonalSpace => 'Personale';

  @override
  String get homeOfficialService => 'Servizio ufficiale';

  @override
  String get homeSwitchSpace => 'Cambia spazio';

  @override
  String get homeSpaceSubtitle => 'Personale · Azienda';

  @override
  String get homeJoinEnterprise => 'Unisciti a un’azienda';

  @override
  String get homeCreateGroup => 'Nuovo gruppo';

  @override
  String get homeAddFriend => 'Aggiungi contatto';

  @override
  String get homeScan => 'Scansiona';

  @override
  String get homeJoinNewSpace => 'Unisciti a un nuovo spazio';

  @override
  String get homeSearchConversation => 'Cerca';

  @override
  String get homeNoMessages => 'Nessun messaggio disponibile';

  @override
  String get homeDeleteConversation => 'Elimina chat';

  @override
  String get homeDeleteConversationConfirm =>
      'Eliminare questa chat? La cronologia verrà cancellata.';

  @override
  String get homePersonalNote => 'Io (note personali)';

  @override
  String get homeWorkNote => 'Io (note di lavoro)';

  @override
  String homeConversationCount(int count) {
    return '$count chat';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count non letti';
  }

  @override
  String get chatInputHint => 'Scrivi un messaggio…';

  @override
  String get chatVoiceHint => 'Tieni premuto per parlare';

  @override
  String get chatVoiceRelease => 'Rilascia per inviare';

  @override
  String get chatVoiceCancel => 'Scorri verso l’alto per annullare';

  @override
  String get chatMenuCopy => 'Copia';

  @override
  String get chatMenuForward => 'Inoltra';

  @override
  String get chatMenuRecall => 'Ritira';

  @override
  String get chatMenuDelete => 'Elimina';

  @override
  String get chatMenuFavorite => 'Salva';

  @override
  String get chatMenuReply => 'Rispondi';

  @override
  String get chatMenuMultiSelect => 'Seleziona';

  @override
  String get chatMenuTranslate => 'Traduci';

  @override
  String get chatMenuVoiceToText => 'Converti in testo';

  @override
  String get chatMenuTextToSpeech => 'Leggi ad alta voce';

  @override
  String get chatStatusRecalled => 'Messaggio ritirato';

  @override
  String get chatRecallSuccess => 'Ritirato';

  @override
  String get chatRecallFailed => 'Impossibile ritirare';

  @override
  String get chatRecallTimeout =>
      'I messaggi più vecchi di 2 minuti non possono essere ritirati';

  @override
  String get chatTranslateFailed => 'Traduzione non riuscita. Riprova.';

  @override
  String get chatTranslateNotConfigured =>
      'Servizio di traduzione non disponibile';

  @override
  String get chatVoiceToTextFailed => 'Conversione non riuscita. Riprova.';

  @override
  String get chatTextToSpeechFailed =>
      'Lettura ad alta voce non riuscita. Riprova.';

  @override
  String get chatVoiceToText => 'Converti';

  @override
  String get chatForwardSuccess => 'Inoltrato';

  @override
  String get chatForwardFailed => 'Inoltro non riuscito. Riprova.';

  @override
  String get chatNoConversations => 'Nessuna chat a cui inoltrare';

  @override
  String get chatSendFailed => 'Invio non riuscito';

  @override
  String get chatResend => 'Invia di nuovo';

  @override
  String get chatNotFriend => 'Non presente nei contatti';

  @override
  String get chatNotFriendHint =>
      'Non siete ancora contatti. Impossibile inviare messaggi.';

  @override
  String get chatMutedHint => 'Tutti i membri sono silenziati';

  @override
  String get chatFileUploadFailed =>
      'Caricamento del file non riuscito. Riprova.';

  @override
  String get chatFileStatusNotDownloaded => 'Non scaricato';

  @override
  String get chatFileStatusDownloaded => 'Scaricato';

  @override
  String get chatFileStatusUploading => 'Caricamento in corso';

  @override
  String get chatFileStatusUploadFailed => 'Caricamento non riuscito';

  @override
  String get chatCardSendFailed => 'Impossibile inviare la scheda contatto';

  @override
  String get chatFavoriteSuccess => 'Salvato';

  @override
  String get chatFavoriteFailed => 'Impossibile aggiungere ai preferiti';

  @override
  String get chatLoadFailed => 'Caricamento non riuscito';

  @override
  String get chatImageMessage => '[Immagine]';

  @override
  String get chatVoiceMessage => '[Messaggio vocale]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[File]';

  @override
  String get chatLocationMessage => '[Posizione]';

  @override
  String get chatContactCardMessage => '[Contatto]';

  @override
  String get chatCallLogMessage => '[Chiamata]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Letto da $count';
  }

  @override
  String get chatUnread => 'Non letto';

  @override
  String get chatRecalledSelf => 'Hai ritirato un messaggio';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender ha ritirato un messaggio';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Traduzione: $translation';
  }

  @override
  String get chatMessageDeleted => 'Messaggio eliminato';

  @override
  String get chatPeer => 'Altra persona';

  @override
  String get chatSelf => 'Io';

  @override
  String get chatGenericMessage => '[Messaggio]';

  @override
  String get chatVoiceHideText => 'Nascondi testo';

  @override
  String get chatVoiceShowText => 'Converti in testo';

  @override
  String get chatFileDefaultName => 'File';

  @override
  String get chatContactDefaultName => 'Contatto';

  @override
  String get chatContactCardTitle => 'Scheda contatto';

  @override
  String get chatCallMissed => 'Persa';

  @override
  String get chatCallCancelled => 'Annullata';

  @override
  String get chatCallRejected => 'Rifiutata';

  @override
  String get chatCallDisconnected => 'Disconnessa';

  @override
  String get chatCallEnded => 'Chiamata terminata';

  @override
  String get chatCallFailed => 'Chiamata non riuscita';

  @override
  String chatCallDuration(String duration) {
    return 'Durata $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videochiamata';

  @override
  String get chatVoiceCallTitle => 'Chiamata vocale';

  @override
  String get chatToolPhotos => 'Foto';

  @override
  String get chatToolCamera => 'Fotocamera';

  @override
  String get chatToolFile => 'File';

  @override
  String get chatToolLocation => 'Posizione';

  @override
  String get chatToolContactCard => 'Contatto';

  @override
  String get chatToolVoiceCall => 'Chiamata vocale';

  @override
  String get chatToolVideoCall => 'Videochiamata';

  @override
  String get chatToolFavorites => 'Preferiti';

  @override
  String get chatToolTranslate => 'Traduci';

  @override
  String get chatTranslationChooseLanguage => 'Scegli la lingua di traduzione';

  @override
  String get chatTranslationEnterText => 'Inserisci prima il testo';

  @override
  String get chatTranslationMentionsUnsupported =>
      'La traduzione non è disponibile per i messaggi con menzioni';

  @override
  String get chatTranslationScheduledUnsupported =>
      'La traduzione non è disponibile durante la modifica di un messaggio programmato';

  @override
  String get chatTranslationFailed => 'Traduzione non riuscita. Riprova.';

  @override
  String get chatTranslationEmpty => 'Nessuna traduzione ricevuta. Riprova.';

  @override
  String get chatTranslationTranslating => 'Traduzione…';

  @override
  String get chatTranslationSend => 'Invia traduzione';

  @override
  String get chatTranslationSending => 'Invio…';

  @override
  String get chatTranslationExpand => 'Mostra di più';

  @override
  String get chatTranslationCollapse => 'Mostra di meno';

  @override
  String get chatFileTooLarge => 'Il file supera il limite di 100 MB';

  @override
  String get chatInputMutedAdminOnly =>
      'Solo il proprietario o i membri selezionati possono scrivere.';

  @override
  String get chatImageUploadUnsupported =>
      'Caricamento dell’immagine non riuscito. Il supporto del server non è ancora disponibile.';

  @override
  String get chatFavoriteLongPressHint =>
      'Tieni premuto un messaggio per aggiungerlo ai preferiti';

  @override
  String chatSelectedCount(int count) {
    return '$count selezionati';
  }

  @override
  String get chatLocationSheetTitle => 'Invia posizione';

  @override
  String get chatLocationNameLabel => 'Nome del luogo';

  @override
  String get chatLocationNameHint => 'Ad es. ufficio, indirizzo del cliente';

  @override
  String get chatLocationAddressLabel => 'Indirizzo';

  @override
  String get chatLocationOptionalHint => 'Facoltativo';

  @override
  String get chatLocationLatitudeLabel => 'Latitudine';

  @override
  String get chatLocationLatitudeHint => 'Da -90 a 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitudine';

  @override
  String get chatLocationLongitudeHint => 'Da -180 a 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Inserisci $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label è fuori intervallo';
  }

  @override
  String get chatLocationDefaultTitle => 'Posizione';

  @override
  String get chatMutedFullNotice =>
      'Questo gruppo è silenziato. Solo il proprietario o i membri selezionati possono scrivere.';

  @override
  String get chatNotFriendSendBlocked =>
      'Non siete più amici e non puoi inviare messaggi';

  @override
  String get chatPersonalNotesTitle => 'Note personali';

  @override
  String get chatWorkNotesTitle => 'Note di lavoro';

  @override
  String get chatPersonalNotesDescription =>
      'Annota pensieri personali e informazioni importanti qui\nSincronizzati tra dispositivi, sempre disponibili';

  @override
  String get chatWorkNotesDescription =>
      'Annota attività e conserva materiali di lavoro qui\nGli spazi del team restano separati e sicuri';

  @override
  String get chatNoMessages => 'Nessun messaggio disponibile';

  @override
  String chatReplyTo(String sender) {
    return 'Rispondi a $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature sarà disponibile a breve';
  }

  @override
  String get chatForwardSelectTitle => 'Scegli la chat';

  @override
  String get chatContactSelectTitle => 'Scegli il contatto';

  @override
  String get chatNoContacts => 'Nessun contatto';

  @override
  String get contactsTitle => 'Contatti';

  @override
  String get contactsSearch => 'Cerca contatti';

  @override
  String get contactsNewFriends => 'Nuovi amici';

  @override
  String get contactsGroups => 'Gruppi';

  @override
  String get contactsFavorites => 'Preferiti';

  @override
  String get contactsRecent => 'Recenti';

  @override
  String get contactsOrganization => 'Organizzazione';

  @override
  String get contactsAnnouncement => 'Annunci';

  @override
  String get contactsNewApplications => 'Nuove richieste';

  @override
  String get contactsCustomerGroups => 'Gruppi di clienti';

  @override
  String get contactsAllCustomers => 'Tutti i clienti';

  @override
  String get contactsMyCustomers => 'I miei clienti';

  @override
  String get contactsViewAll => 'Mostra tutto';

  @override
  String get contactsMyContacts => 'I miei contatti';

  @override
  String get contactsMyAdvisor => 'Il mio consulente';

  @override
  String get contactsNoAdvisor => 'Nessun consulente ancora assegnato';

  @override
  String get contactsAdvisorLoading => 'Caricamento…';

  @override
  String get contactsNavigateFailed => 'Navigazione non riuscita. Riprova.';

  @override
  String get contactsEmpty => 'Nessun contatto';

  @override
  String get contactsNoAnnouncement => 'Nessun annuncio';

  @override
  String get contactsOfficialBadge => 'Ufficiale';

  @override
  String get contactsCustomerBadge => 'Cliente';

  @override
  String get contactsEmptyCustomers => 'Nessun cliente';

  @override
  String get myTitle => 'Io';

  @override
  String get myEnterpriseInfo => 'Informazioni aziendali';

  @override
  String get myEnterpriseManage => 'Gestione aziendale';

  @override
  String get myQrCode => 'Codice QR';

  @override
  String get myFavorites => 'Preferiti';

  @override
  String get myLanguage => 'Lingua';

  @override
  String get myTimezone => 'Fuso orario';

  @override
  String get myAutoTranslate => 'Traduzione automatica';

  @override
  String get myNetworkSwitch => 'Cambia linea';

  @override
  String get mySettings => 'Impostazioni';

  @override
  String get myLogout => 'Esci';

  @override
  String get myLogoutConfirm => 'Vuoi davvero uscire?';

  @override
  String get myLeaveEnterprise => 'Lascia l’azienda';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Vuoi davvero lasciare questa azienda? Perderai l’accesso ai dati aziendali.';

  @override
  String get myLeaveEnterpriseSuccess => 'Hai lasciato l’azienda';

  @override
  String get myLeaveEnterpriseFailed => 'Impossibile uscire. Riprova.';

  @override
  String get myLppIdCopied => 'ID StartLink copiato';

  @override
  String myLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count contatti';
  }

  @override
  String get myAutoSelect => 'Automatico';

  @override
  String get myPresenceStatus => 'Stato di presenza';

  @override
  String get myPresenceStatusTitle => 'Imposta presenza';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Occupato';

  @override
  String get myPresenceAway => 'Assente';

  @override
  String get myPresenceInvisible => 'Invisibile';

  @override
  String get profileTitle => 'Il mio profilo';

  @override
  String get profileName => 'Nome';

  @override
  String get profileGender => 'Genere';

  @override
  String get profileBirthday => 'Compleanno';

  @override
  String get profileRegion => 'Regione';

  @override
  String get profileSignature => 'Presentazione';

  @override
  String get profileSignatureHint => 'Racconta qualcosa di te';

  @override
  String get profileTapTapText => 'Toc toc';

  @override
  String get profileTapTapHint =>
      'Testo visualizzato quando ricevi un tocco (max 20 caratteri)';

  @override
  String get profileAccountSection => 'Account';

  @override
  String get profileBasicSection => 'Informazioni di base';

  @override
  String get profileLppId => 'ID StartLink';

  @override
  String get profileLppIdNotSet => 'Non impostato';

  @override
  String get profileMobile => 'Telefono';

  @override
  String get profileMobileUnbound => 'Non collegata';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailUnbound => 'Non collegata';

  @override
  String get profileQrCode => 'Il mio codice QR';

  @override
  String get profileChangePassword => 'Cambia password';

  @override
  String get profileGenderMale => 'Maschio';

  @override
  String get profileGenderFemale => 'Femmina';

  @override
  String get profileGenderOther => 'Altro';

  @override
  String get profileGenderUnset => 'Non impostato';

  @override
  String get profileSaveFailed => 'Salvataggio non riuscito. Riprova.';

  @override
  String get profileLppIdTitle => 'ID StartLink';

  @override
  String get profileLppIdSetOnce =>
      'L’ID StartLink può essere modificato una sola volta. Scegli con attenzione.';

  @override
  String get profileLppIdChangeFailed =>
      'Modifica non riuscita (l’ID StartLink può essere modificato una sola volta)';

  @override
  String get profileChangePasswordOld => 'Password attuale';

  @override
  String get profileChangePasswordNew => 'Nuova password';

  @override
  String get profileChangePasswordConfirm => 'Conferma nuova password';

  @override
  String get profileChangePasswordMismatch => 'Le password non coincidono';

  @override
  String get profileChangePasswordSuccess =>
      'Password modificata. Accedi di nuovo.';

  @override
  String get profileChangePasswordFailed =>
      'Impossibile modificare la password. Riprova.';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsSectionEnterprise => 'Azienda';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsSectionGeneral => 'Generali';

  @override
  String get settingsSectionFeatures => 'Funzioni';

  @override
  String get settingsSectionAbout => 'Informazioni';

  @override
  String get settingsEnterpriseInfo => 'Informazioni aziendali';

  @override
  String get settingsProfile => 'Il mio profilo';

  @override
  String get settingsAccountSecurity => 'Sicurezza dell’account';

  @override
  String get settingsNotification => 'Notifiche';

  @override
  String get settingsDisplay => 'Schermo';

  @override
  String get settingsFriendPrivacy => 'Privacy';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Cronologia chat';

  @override
  String get settingsAbout => 'Informazioni su StartLink';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsTimezone => 'Fuso orario';

  @override
  String get settingsAutoTranslate => 'Traduzione automatica';

  @override
  String get settingsNetworkSwitch => 'Cambia linea';

  @override
  String get enterpriseInfoTitle => 'Informazioni aziendali';

  @override
  String get enterpriseName => 'Nome';

  @override
  String get enterpriseDescription => 'Descrizione';

  @override
  String get enterpriseUpdateSuccess => 'Aggiornato con successo';

  @override
  String get enterpriseUpdateFailed => 'Aggiornamento non riuscito. Riprova.';

  @override
  String get enterpriseLeave => 'Lascia l’azienda';

  @override
  String get enterpriseLeaveConfirm => 'Vuoi davvero lasciare questa azienda?';

  @override
  String get enterpriseLeaveSuccess => 'Hai lasciato l’azienda';

  @override
  String get enterpriseLeaveFailed => 'Impossibile uscire. Riprova.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Il proprietario non può uscire direttamente. Trasferisci prima la proprietà.';

  @override
  String get enterpriseMemberCount => 'Membri';

  @override
  String get enterpriseCreatedAt => 'Creazione';

  @override
  String get enterpriseCode => 'Codice aziendale';

  @override
  String get enterpriseInviteMembers => 'Invita membri';

  @override
  String get enterpriseCopyInviteCode => 'Copia codice di invito';

  @override
  String get enterpriseInviteCodeCopied => 'Codice di invito copiato';

  @override
  String get groupCreateTitle => 'Nuovo gruppo';

  @override
  String get groupNameHint => 'Inserisci il nome del gruppo';

  @override
  String get groupCreateSuccess => 'Gruppo creato';

  @override
  String get groupCreateFailed => 'Impossibile creare il gruppo';

  @override
  String get groupSettings => 'Impostazioni del gruppo';

  @override
  String get groupName => 'Nome del gruppo';

  @override
  String get groupAvatar => 'Immagine del gruppo';

  @override
  String get groupAnnouncement => 'Annuncio';

  @override
  String get groupMembers => 'Membri';

  @override
  String get groupAddMember => 'Aggiungi membri';

  @override
  String get groupRemoveMember => 'Rimuovi membro';

  @override
  String get groupRemoveMemberConfirm => 'Rimuovere questo membro?';

  @override
  String get groupSetAdmin => 'Nomina amministratore';

  @override
  String get groupRemoveAdmin => 'Rimuovi amministratore';

  @override
  String get groupTransferOwner => 'Trasferisci proprietà';

  @override
  String get groupTransferOwnerConfirm =>
      'Trasferire la proprietà del gruppo a questo membro?';

  @override
  String get groupTransferOwnerSuccess => 'Proprietà trasferita';

  @override
  String get groupTransferOwnerFailed => 'Trasferimento non riuscito. Riprova.';

  @override
  String get groupLeave => 'Lascia il gruppo';

  @override
  String get groupLeaveConfirm => 'Lasciare questo gruppo?';

  @override
  String get groupLeaveSuccess => 'Hai lasciato il gruppo';

  @override
  String get groupLeaveFailed => 'Impossibile uscire. Riprova.';

  @override
  String get groupDissolve => 'Sciogli il gruppo';

  @override
  String get groupDissolveConfirm =>
      'Sciogliere questo gruppo? Tutti i membri saranno rimossi.';

  @override
  String get groupDissolveSuccess => 'Gruppo sciolto';

  @override
  String get groupDissolveFailed =>
      'Impossibile sciogliere il gruppo. Riprova.';

  @override
  String get groupQrCode => 'Codice QR del gruppo';

  @override
  String get groupMuteAll => 'Silenzia tutti';

  @override
  String get groupMuteAllOn => 'Attiva silenziamento generale';

  @override
  String get groupMuteAllOff => 'Disattiva silenziamento generale';

  @override
  String get groupAllowMemberInvite => 'Consenti inviti dai membri';

  @override
  String get groupAllowMemberModifyTitle =>
      'Consenti ai membri di cambiare il nome del gruppo';

  @override
  String get groupAllowMemberAtAll => 'Consenti ai membri di menzionare @Tutti';

  @override
  String get groupAllowMemberViewMemberList =>
      'Consenti ai membri di vedere l’elenco dei membri';

  @override
  String get groupAllowQrCodeJoin => 'Consenti accesso tramite codice QR';

  @override
  String get groupRequireApproval => 'Richiedi approvazione per aderire';

  @override
  String get groupAllowMemberAddFriend =>
      'Consenti ai membri di aggiungersi come amici';

  @override
  String get groupRoleOwner => 'Proprietario';

  @override
  String get groupRoleAdmin => 'Amministratore';

  @override
  String get groupRoleMember => 'Membro';

  @override
  String get groupNoMembers => 'Nessun membro';

  @override
  String get groupNoAnnouncements => 'Nessun annuncio';

  @override
  String get groupCreateAnnouncement => 'Pubblica annuncio';

  @override
  String get groupEditAnnouncement => 'Modifica annuncio';

  @override
  String get groupDeleteAnnouncement => 'Elimina annuncio';

  @override
  String get groupDeleteAnnouncementConfirm => 'Eliminare questo annuncio?';

  @override
  String get groupAnnouncementTitle => 'Titolo';

  @override
  String get groupAnnouncementContent => 'Contenuto';

  @override
  String get groupAnnouncementPin => 'Fissa annuncio';

  @override
  String groupMemberCount(int count) {
    return '$count membri';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count selezionati';
  }

  @override
  String get groupJoinRequestApprove => 'Accetto';

  @override
  String get groupJoinRequestReject => 'Rifiuta';

  @override
  String get groupJoinRequests => 'Richieste di adesione';

  @override
  String get groupNoJoinRequests => 'Nessuna richiesta di adesione';

  @override
  String get groupReadReceipts => 'Conferme di lettura';

  @override
  String groupReadCount(int count) {
    return '$count letti';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count non letti';
  }

  @override
  String get friendAddTitle => 'Aggiungi contatto';

  @override
  String get friendSearchHint => 'Telefono / E-mail / ID StartLink';

  @override
  String get friendRequestSent => 'Richiesta di amicizia inviata';

  @override
  String get friendRequestFailed => 'Invio non riuscito. Riprova.';

  @override
  String get friendAlreadyFriend => 'Siete già contatti';

  @override
  String get friendNewFriendsTitle => 'Nuovi amici';

  @override
  String get friendNoRequests => 'Nessuna richiesta di amicizia';

  @override
  String get friendAccept => 'Accetta';

  @override
  String get friendReject => 'Rifiuta';

  @override
  String get friendAccepted => 'Accettata';

  @override
  String get friendRejected => 'Rifiutato';

  @override
  String get friendDeleteConfirm => 'Rimuovere questo contatto?';

  @override
  String get friendDeleteSuccess => 'Contatto rimosso';

  @override
  String get friendDeleteFailed => 'Rimozione non riuscita. Riprova.';

  @override
  String get friendRemarkName => 'Nome del contatto';

  @override
  String get friendGroupName => 'Gruppo';

  @override
  String get friendSendMessage => 'Messaggio';

  @override
  String get friendMatchTypeLppId => 'Trovato tramite ID StartLink';

  @override
  String get friendMatchTypeMobile => 'Trovato tramite telefono';

  @override
  String get friendMatchTypeEmail => 'Trovato tramite e-mail';

  @override
  String get friendSearchEmpty => 'Nessun utente trovato';

  @override
  String get friendAddMessage => 'Vorrei aggiungerti ai miei contatti';

  @override
  String get friendBlockConfirm => 'Bloccare questo utente?';

  @override
  String get friendUnblockConfirm => 'Sbloccare questo utente?';

  @override
  String get friendBlockSuccess => 'Bloccato';

  @override
  String get friendUnblockSuccess => 'Sbloccato';

  @override
  String get profilePageTitle => 'Informazioni Personali';

  @override
  String get profilePageSendMessage => 'Messaggio';

  @override
  String get profilePageAddFriend => 'Aggiungi amico';

  @override
  String get profilePageAlreadyFriend => 'Siete già amici';

  @override
  String get profilePageBlocked => 'Bloccato';

  @override
  String get profilePageBlock => 'Blocca';

  @override
  String get profilePageUnblock => 'Sblocca';

  @override
  String get profilePageHidden => 'Questo utente ha nascosto il suo profilo';

  @override
  String get profilePageFriendsOnly =>
      'Questo utente mostra il profilo solo agli amici';

  @override
  String get profilePageLppId => 'ID StartLink';

  @override
  String get profilePageRemarkName => 'Osservazioni';

  @override
  String get profilePageEditRemark => 'Modifica nome del contatto';

  @override
  String get profilePageSaveRemarkSuccess => 'Nome del contatto salvato';

  @override
  String get profilePageSaveRemarkFailed =>
      'Salvataggio non riuscito. Riprova.';

  @override
  String get searchTitle => 'Cerca';

  @override
  String get searchHint => 'Cerca per telefono, e-mail o ID StartLink';

  @override
  String get searchNoResults => 'Nessun risultato';

  @override
  String get searchMessages => 'Messaggi';

  @override
  String get searchUsers => 'Utenti';

  @override
  String get searchFailed => 'Ricerca non riuscita. Riprova.';

  @override
  String get scanTitle => 'Scansiona';

  @override
  String get scanFailed => 'Riconoscimento non riuscito. Riprova.';

  @override
  String get scanInvalidQrCode => 'Codice QR non valido';

  @override
  String get scanFlashOn => 'Accendi torcia';

  @override
  String get scanFlashOff => 'Spegni torcia';

  @override
  String get scanAlbum => 'Scegli dall’album';

  @override
  String get favoritesTitle => 'Preferiti';

  @override
  String get favoritesEmpty => 'Nessun elemento salvato';

  @override
  String get favoritesAll => 'Tutti';

  @override
  String get favoritesText => 'Testo';

  @override
  String get favoritesImage => 'Immagini';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Messaggi vocali';

  @override
  String get favoritesFile => 'File';

  @override
  String get favoritesOther => 'Altro';

  @override
  String get favoritesDeleteConfirm => 'Rimuovere dai preferiti?';

  @override
  String get favoritesDeleteSuccess => 'Rimosso dai salvati';

  @override
  String get favoritesDeleteFailed => 'Impossibile rimuovere';

  @override
  String get favoritesOriginalRecalled => 'Messaggio ritirato';

  @override
  String get favoritesViewOriginal => 'Mostra originale';

  @override
  String get favoritesSearchHint => 'Cerca nei preferiti';

  @override
  String get favoritesNoResults => 'Nessun preferito corrispondente';

  @override
  String get noticeTitle => 'Annunci';

  @override
  String get noticeEmpty => 'Nessun annuncio';

  @override
  String get noticeDetail => 'Dettagli dell’annuncio';

  @override
  String get noticePublishedAt => 'Pubblicazione';

  @override
  String get noticePriorityNormal => 'Normale';

  @override
  String get noticePriorityImportant => 'Importante';

  @override
  String get noticePriorityUrgent => 'Urgente';

  @override
  String get organizationTitle => 'Organizzazione';

  @override
  String get organizationEmpty => 'Nessuna informazione sui reparti';

  @override
  String get organizationMembers => 'Membri';

  @override
  String get organizationDepartment => 'Reparto';

  @override
  String get organizationPosition => 'Posizione';

  @override
  String get organizationLeader => 'Responsabile';

  @override
  String get qrCodeTitle => 'Il mio codice QR';

  @override
  String get qrCodeSave => 'Salva nell\'album';

  @override
  String get qrCodeShare => 'Condividi';

  @override
  String get qrCodeSaveSuccess => 'Salvato nell\'album';

  @override
  String get qrCodeSaveFailed => 'Salvataggio non riuscito. Riprova.';

  @override
  String get qrCodeRefresh => 'Aggiorna codice QR';

  @override
  String get qrCodeExpired => 'Codice QR scaduto. Aggiornalo.';

  @override
  String get qrCodeScanToAdd => 'Scansiona per aggiungermi ai contatti';

  @override
  String get spacePersonal => 'Personale';

  @override
  String get spaceEnterprise => 'Azienda';

  @override
  String get spaceJoinByCode => 'Aderisci con codice aziendale';

  @override
  String get spaceJoinByInvite => 'Aderisci con codice di invito';

  @override
  String get spaceEnterCode => 'Inserisci il codice aziendale';

  @override
  String get spaceEnterInviteCode => 'Inserisci il codice di invito';

  @override
  String get spaceSearchEnterprise => 'Cerca azienda';

  @override
  String get spaceJoinRequestSent =>
      'Richiesta inviata, in attesa di approvazione';

  @override
  String get spaceJoinRequestPending => 'Approvazione in attesa';

  @override
  String get spaceJoinRequestApproved => 'Richiesta approvata';

  @override
  String get spaceJoinRequestRejected => 'Richiesta rifiutata';

  @override
  String get spaceAlreadyMember => 'Sei già un membro';

  @override
  String get spaceAutoApproved => 'Approvazione automatica. Benvenuto!';

  @override
  String get spacePendingApprovalHint =>
      'Registrazione riuscita. La richiesta di adesione è stata inviata.';

  @override
  String get spaceNoSpaces => 'Nessuno spazio';

  @override
  String get spaceInviteExpired => 'Codice di invito scaduto';

  @override
  String get spaceInviteTargetMismatch =>
      'Questo codice di invito non è destinato al tuo account';

  @override
  String get spaceAcceptInviteSuccess => 'Adesione all’azienda riuscita';

  @override
  String get spaceAcceptInviteFailed => 'Impossibile aderire. Riprova.';

  @override
  String get spaceTenantSelectTitle => 'Seleziona spazio';

  @override
  String get spaceTenantSelectHint => 'Scegli uno spazio da aprire';

  @override
  String get spaceEnterPersonal => 'Apri spazio personale';

  @override
  String get spaceEnterEnterprise => 'Apri spazio aziendale';

  @override
  String get aboutTitle => 'Informazioni su StartLink';

  @override
  String get aboutVersion => 'Versione';

  @override
  String get aboutTerms => 'Termini di servizio';

  @override
  String get aboutPrivacy => 'Informativa sulla privacy';

  @override
  String get aboutOpenSource => 'Licenze open source';

  @override
  String get aboutCheckUpdate => 'Cerca aggiornamenti';

  @override
  String get aboutLatestVersion => 'Stai utilizzando l\'ultima versione';

  @override
  String get aboutUpdateAvailable => 'Nuova versione disponibile';

  @override
  String get aboutUpdateNow => 'Aggiorna ora';

  @override
  String get aboutUpdateLater => 'Più tardi';

  @override
  String get notificationTitle => 'Notifiche';

  @override
  String get notificationGlobalMute => 'Non disturbare';

  @override
  String get notificationSound => 'Suono';

  @override
  String get notificationVibration => 'Vibrazione';

  @override
  String get notificationPreview => 'Anteprima messaggi';

  @override
  String get notificationDndStart => 'Inizio di Non disturbare';

  @override
  String get notificationDndEnd => 'Fine di Non disturbare';

  @override
  String get blacklistTitle => 'In lista nera';

  @override
  String get blacklistEmpty => 'Nessun utente bloccato';

  @override
  String get blacklistRemove => 'Sblocca';

  @override
  String get blacklistRemoveConfirm => 'Sbloccare questo utente?';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackTypeComplaint => 'Reclamo';

  @override
  String get feedbackTypeSuggestion => 'Suggerimento';

  @override
  String get feedbackTypeBug => 'Segnalazione di errore';

  @override
  String get feedbackContent => 'Descrizione';

  @override
  String get feedbackContentHint =>
      'Descrivi il problema o il suggerimento in dettaglio';

  @override
  String get feedbackContact => 'Recapito (facoltativo)';

  @override
  String get feedbackSubmit => 'Invia';

  @override
  String get feedbackSuccess => 'Feedback inviato. Grazie!';

  @override
  String get feedbackFailed => 'Invio non riuscito. Riprova.';

  @override
  String get networkTitle => 'Cambia linea';

  @override
  String get networkAutoSelect => 'Automatico';

  @override
  String get networkManual => 'Manuale';

  @override
  String get timezoneTitle => 'Fuso orario';

  @override
  String get timezoneAuto => 'Segui il sistema';

  @override
  String get autoTranslateTitle => 'Traduzione automatica';

  @override
  String get autoTranslateEnabled => 'Attiva traduzione automatica';

  @override
  String get autoTranslateLanguage => 'Lingua di destinazione';

  @override
  String get displayTitle => 'Schermo';

  @override
  String get displayFontSize => 'Dimensione del carattere';

  @override
  String get displayChatBackground => 'Sfondo chat';

  @override
  String get displayDarkMode => 'Aspetto';

  @override
  String get displayDarkModeSystem => 'Segui il sistema';

  @override
  String get displayDarkModeSystemHint =>
      'Cambia automaticamente in base alle impostazioni di sistema';

  @override
  String get displayDarkModeOff => 'Chiaro';

  @override
  String get displayDarkModeOffHint => 'Usa sempre il tema chiaro';

  @override
  String get displayDarkModeOn => 'Scuro';

  @override
  String get displayDarkModeOnHint => 'Usa sempre il tema scuro';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Cronologia chat';

  @override
  String get chatHistoryClear => 'Cancella tutta la cronologia';

  @override
  String get chatHistoryClearConfirm =>
      'Cancellare tutta la cronologia chat? L’operazione è irreversibile.';

  @override
  String get chatHistoryClearSuccess => 'Cronologia chat cancellata';

  @override
  String get accountSecurityTitle => 'Sicurezza dell’account';

  @override
  String get accountSecurityChangePassword => 'Cambia password';

  @override
  String get accountSecurityChangeMobile => 'Cambia numero di telefono';

  @override
  String get accountSecurityChangeEmail => 'Cambia e-mail';

  @override
  String get accountSecurityLoggedDevices => 'Dispositivi connessi';

  @override
  String get accountSecurityDeactivate => 'Elimina account';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Tutti i dati saranno eliminati definitivamente dopo 7 giorni. Eliminare l’account?';

  @override
  String get loggedDevicesTitle => 'Dispositivi connessi';

  @override
  String get loggedDevicesCurrent => 'Questo dispositivo';

  @override
  String get loggedDevicesRevoke => 'Disconnetti';

  @override
  String get loggedDevicesRevokeConfirm => 'Disconnettere questo dispositivo?';

  @override
  String get loggedDevicesRevokeSuccess => 'Dispositivo disconnesso';

  @override
  String get loggedDevicesRevokeFailed => 'Operazione non riuscita. Riprova.';

  @override
  String get loggedDevicesLastActive => 'Ultima attività';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Desktop';

  @override
  String get loggedDevicesTypeUnknown => 'Dispositivo sconosciuto';

  @override
  String get privacySettingsTitle => 'Privacy';

  @override
  String get privacySearchableByMobile =>
      'Consenti ricerca tramite numero di telefono';

  @override
  String get privacySearchableByLppId =>
      'Consenti ricerca tramite ID StartLink';

  @override
  String get privacyAllowFriendRequest => 'Consenti richieste di amicizia';

  @override
  String get privacyProfileVisibility => 'Visibilità del profilo';

  @override
  String get privacyEveryone => 'Tutti';

  @override
  String get privacyFriendsOfFriends => 'Amici di amici';

  @override
  String get privacyNobody => 'Nessuno';

  @override
  String get privacyFriendsOnly => 'Solo amici';

  @override
  String get privacySaveSuccess => 'Impostazioni salvate';

  @override
  String get privacySaveFailed => 'Salvataggio non riuscito. Riprova.';

  @override
  String get fontSizeTitle => 'Dimensione del carattere';

  @override
  String get fontSizeSmall => 'Piccolo';

  @override
  String get fontSizeNormal => 'Normale';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get fontSizeExtraLarge => 'Molto grande';

  @override
  String get fontSizePreview => 'Anteprima';

  @override
  String get chatBackgroundTitle => 'Sfondo chat';

  @override
  String get chatBackgroundDefault => 'Predefinito';

  @override
  String get chatBackgroundCustom => 'Personalizzato';

  @override
  String get chatBackgroundReset => 'Ripristina Predefinite';

  @override
  String get termsTitle => 'Termini di servizio';

  @override
  String get privacyPolicyTitle => 'Informativa sulla privacy';

  @override
  String get recentContactsTitle => 'Recenti';

  @override
  String get recentContactsEmpty => 'Nessun contatto recente';

  @override
  String get inviteFriendsTitle => 'Invita amici';

  @override
  String get inviteFriendsCopyLink => 'Copia link di invito';

  @override
  String get inviteFriendsLinkCopied => 'Link di invito copiato';

  @override
  String get imageViewerTitle => 'Foto';

  @override
  String get imageViewerSave => 'Salva nell\'album';

  @override
  String get imageViewerSaveSuccess => 'Salvato nell\'album';

  @override
  String get imageViewerSaveFailed => 'Salvataggio non riuscito. Riprova.';

  @override
  String get customerServiceTitle => 'Postazione assistenza';

  @override
  String get customerServiceQueue => 'In coda';

  @override
  String get customerServiceActive => 'Attive';

  @override
  String get customerServiceClaim => 'Accetta';

  @override
  String get customerServiceTakeover => 'Prendi in carico';

  @override
  String get customerServiceClose => 'Termina assistenza';

  @override
  String get customerServiceCloseConfirm =>
      'Terminare questa sessione di assistenza?';

  @override
  String get customerServiceNoQueue => 'Nessuna sessione in coda';

  @override
  String get customerServiceNoActive => 'Nessuna sessione attiva';

  @override
  String get customerServiceVisitor => 'Visitatore';

  @override
  String get customerServiceCustomer => 'Cliente';

  @override
  String get customerServiceAssignedTo => 'Assegnato a';

  @override
  String get customerServiceTransferConversation => 'Trasferisci chat';

  @override
  String get marketingToolbar => 'Strumenti marketing';

  @override
  String get callIncoming => 'Chiamata in arrivo';

  @override
  String get callOutgoing => 'Chiamata in uscita';

  @override
  String get callAccept => 'Accetta';

  @override
  String get callReject => 'Rifiuta';

  @override
  String get callHangup => 'Termina';

  @override
  String get callMissed => 'Chiamata persa';

  @override
  String get callDuration => 'Durata';

  @override
  String get callAudio => 'Chiamata vocale';

  @override
  String get callGeneric => 'Chiamata';

  @override
  String get callVideo => 'Videochiamata';

  @override
  String get callConnecting => 'Connessione…';

  @override
  String get callRinging => 'Squillo…';

  @override
  String get callEnded => 'Chiamata terminata';

  @override
  String get callFailed => 'Chiamata non riuscita';

  @override
  String get callRejected => 'Chiamata rifiutata';

  @override
  String get callTimeout => 'Nessuna risposta';

  @override
  String get callCancelled => 'Annullata';

  @override
  String get callUnknownPeer => 'Sconosciuto';

  @override
  String get callVideoInvitation => 'Invito a videochiamata';

  @override
  String get callAudioInvitation => 'Invito a chiamata vocale';

  @override
  String get callAnswerAudio => 'Rispondi con audio';

  @override
  String get callAnswerVideo => 'Rispondi con video';

  @override
  String get callViewProfile => 'Mostra profilo';

  @override
  String get callOpeningCamera => 'Apertura fotocamera…';

  @override
  String get callWaitingRemoteVideo =>
      'In attesa del video dell’altra persona…';

  @override
  String get callCameraOff => 'Fotocamera disattivata';

  @override
  String get callCameraOn => 'Fotocamera attivata';

  @override
  String get callMicrophoneOff => 'Microfono disattivato';

  @override
  String get callMicrophoneOn => 'Microfono attivato';

  @override
  String get callSpeakerOff => 'Altoparlante disattivato';

  @override
  String get callSpeakerOn => 'Altoparlante attivato';

  @override
  String get callVideoPermissionFailure =>
      'Impossibile avviare la videochiamata. Controlla le autorizzazioni di fotocamera e microfono e riprova.';

  @override
  String get callAudioPermissionFailure =>
      'Impossibile avviare la chiamata vocale. Controlla l’autorizzazione del microfono e riprova.';

  @override
  String get callIncompleteIncoming =>
      'Le informazioni sulla chiamata in arrivo sono incomplete e non è possibile rispondere.';

  @override
  String get callInProgress => 'In chiamata';

  @override
  String get callCalling => 'Chiamata in corso…';

  @override
  String callEndedMedia(String media) {
    return '$media terminata';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media rifiutata';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media senza risposta';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media annullata';
  }

  @override
  String get callConnectionLost => 'Connessione della chiamata persa';

  @override
  String get callAdminEnded => 'Chiamata terminata da un amministratore';

  @override
  String callFailedMedia(String media) {
    return '$media non riuscita';
  }

  @override
  String get callBusy => 'L’altra persona è occupata';

  @override
  String callDurationValue(String duration) {
    return 'Durata chiamata $duration';
  }

  @override
  String get callNotConnected => 'Non connessa';

  @override
  String get callDialed => 'In uscita';

  @override
  String get callAnswered => 'Risposta';

  @override
  String get callRejectedByPeer => 'Rifiutata dall’altra persona';

  @override
  String get callRejectedBySelf => 'Rifiutato';

  @override
  String get callPeerDidNotAnswer => 'L’altra persona non ha risposto';

  @override
  String get callMissedIncoming => 'Chiamata in arrivo persa';

  @override
  String get callPeerCancelled => 'Annullata dall’altra persona';

  @override
  String get notificationNewMessageTitle => 'Nuovo messaggio StartLink';

  @override
  String get notificationOnlineServiceTitle =>
      'Nuovo messaggio di assistenza clienti';

  @override
  String get notificationNewMessageBody => 'Hai ricevuto un nuovo messaggio';

  @override
  String get notificationImagePreview => 'Ha inviato un’immagine';

  @override
  String get notificationVideoPreview => 'Ha inviato un video';

  @override
  String get notificationVoicePreview => 'Ha inviato un messaggio vocale';

  @override
  String get notificationFilePreview => 'Ha inviato un file';

  @override
  String get notificationContactPreview => 'Ha inviato una scheda contatto';

  @override
  String get notificationCallLogPreview => 'Ha inviato un registro chiamata';

  @override
  String get notificationLocationPreview => 'Ha condiviso una posizione';

  @override
  String get notificationLinkPreview => 'Ha condiviso un link';

  @override
  String notificationMentionMe(String body) {
    return 'Ti ha menzionato: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender ti ha menzionato: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Ha menzionato tutti: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender ha menzionato tutti: $body';
  }

  @override
  String get notificationSecurityTitle => 'Avviso di sicurezza dell’account';

  @override
  String get notificationSecurityBody =>
      'Le impostazioni di sicurezza del tuo account StartLink sono cambiate. Controllale ora.';

  @override
  String get notificationFriendAcceptedTitle =>
      'Richiesta di amicizia accettata';

  @override
  String get notificationFriendRejectedTitle =>
      'Richiesta di amicizia rifiutata';

  @override
  String get notificationFriendAcceptedBody =>
      'L’altra persona ha accettato la tua richiesta di amicizia';

  @override
  String get notificationFriendRejectedBody =>
      'L’altra persona ha rifiutato la tua richiesta di amicizia';

  @override
  String get notificationVideoCallTitle => 'Invito a videochiamata';

  @override
  String get notificationAudioCallTitle => 'Invito a chiamata vocale';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller ti ha invitato a una videochiamata';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller ti ha invitato a una chiamata vocale';
  }

  @override
  String get notificationMessageChannelName => 'Messaggi';

  @override
  String get notificationMessageChannelDescription =>
      'Messaggi chat, registri chiamate e avvisi di sistema';

  @override
  String get notificationCallChannelName => 'Chiamate';

  @override
  String get notificationCallChannelDescription =>
      'Avvisi di chiamate vocali e video';

  @override
  String get notificationSecurityChannelName => 'Sicurezza dell’account';

  @override
  String get notificationSecurityChannelDescription =>
      'Avvisi di accesso e modifica della password o del numero di cellulare';

  @override
  String get notificationUnknownCaller => 'Chiamante sconosciuto';

  @override
  String get pendingJoinRequestsTitle => 'Nuove richieste';

  @override
  String get pendingJoinRequestsEmpty => 'Nessuna richiesta';

  @override
  String get pendingJoinRequestApprove => 'Accetto';

  @override
  String get pendingJoinRequestReject => 'Rifiuta';

  @override
  String get pendingJoinRequestApproveSuccess => 'Approvata';

  @override
  String get pendingJoinRequestRejectSuccess => 'Rifiutata';

  @override
  String get pendingJoinRequestFailed => 'Operazione non riuscita. Riprova.';

  @override
  String get myCustomersTitle => 'I miei clienti';

  @override
  String get myCustomersEmpty => 'Nessun cliente';

  @override
  String get groupListTitle => 'Gruppi';

  @override
  String get groupListEmpty => 'Nessun gruppo';

  @override
  String get addFriendTitle => 'Aggiungi contatto';

  @override
  String get addFriendSearchHint => 'Telefono / E-mail / ID StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String get addFriendButton => 'Aggiungi';

  @override
  String get addFriendCannotAddSelf => 'Non puoi aggiungere te stesso';

  @override
  String get addFriendUnsupportedUser =>
      'Questo utente non può essere aggiunto. Puoi scrivergli direttamente.';

  @override
  String get addFriendMessageHint => 'Inserisci un messaggio';

  @override
  String get addFriendSendRequest => 'Invia richiesta';

  @override
  String get joinCompanyTitle => 'Unisciti a un’azienda';

  @override
  String get joinCompanyCodeHint => 'Inserisci il codice aziendale';

  @override
  String get joinCompanySearchHint => 'Cerca nome azienda';

  @override
  String get joinCompanyApply => 'Richiedi adesione';

  @override
  String get joinCompanyApplySuccess => 'Richiesta inviata';

  @override
  String get joinCompanyApplyFailed => 'Richiesta non riuscita. Riprova.';

  @override
  String get joinCompanyAutoApproved => 'Approvazione automatica. Benvenuto!';

  @override
  String get joinCompanyPending =>
      'Richiesta inviata, in attesa di approvazione';

  @override
  String get joinCompanyInviteCodeHint => 'Inserisci il codice di invito';

  @override
  String get joinCompanyAcceptInvite => 'Accetta invito';

  @override
  String get joinCompanyNoResults => 'Nessuna azienda trovata';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count membri';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Ora del Pacifico';

  @override
  String get timezoneNameMountainTime => 'Ora delle Montagne Rocciose';

  @override
  String get timezoneNameCentralTime => 'Ora centrale';

  @override
  String get timezoneNameEasternTime => 'Ora orientale';

  @override
  String get timezoneNameAtlanticTime => 'Ora dell’Atlantico';

  @override
  String get timezoneNameBrasilia => 'Brasilia';

  @override
  String get timezoneNameAzores => 'Azzorre';

  @override
  String get timezoneNameLondonDublin => 'Londra/Dublino';

  @override
  String get timezoneNameBerlinParisRome => 'Berlino/Parigi/Roma';

  @override
  String get timezoneNameCairoHelsinki => 'Il Cairo/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Mosca/Riyad';

  @override
  String get timezoneNameTehran => 'Teheran';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Baku';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karachi/Tashkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/Nuova Delhi';

  @override
  String get timezoneNameKathmandu => 'Katmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dacca/Almaty';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoi/Giacarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Pechino/Shanghai/Hong Kong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokyo/Seul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Isole Salomone';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Figi';

  @override
  String get networkSmartSelectBestRoute =>
      'Selezione intelligente del percorso migliore';

  @override
  String get networkTesting => 'Test in corso…';

  @override
  String get networkTestingShort => 'Test in corso';

  @override
  String networkLatencyMs(int ms) {
    return 'Latenza $ms ms';
  }

  @override
  String get networkConnectionMode => 'Modalità di connessione';

  @override
  String get networkDirectMode => 'Modalità diretta';

  @override
  String get networkProxyMode => 'Modalità proxy';

  @override
  String get networkDirectModeDesc => 'Connessione diretta al server';

  @override
  String get networkProxyModeDesc => 'Connessione tramite un server proxy';

  @override
  String get networkDirectRoutes => 'Percorsi diretti';

  @override
  String get networkProxyRoutes => 'Percorsi proxy';

  @override
  String get networkTestAll => 'Testa tutti';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Nodo Hong Kong';

  @override
  String get networkSingaporeNode => 'Nodo Singapore';

  @override
  String get networkJapanNode => 'Nodo Giappone';

  @override
  String get networkUnitedStatesNode => 'Nodo Stati Uniti';

  @override
  String get networkHint =>
      'Suggerimenti:\n• Modalità diretta: più veloce e adatta all’uso nazionale\n• Modalità proxy: più stabile per comunicazioni internazionali\n• Tocca l’icona di aggiornamento per testare la latenza di un percorso';

  @override
  String get teenModeTitle => 'Modalità adolescenti';

  @override
  String get teenModeStatusOn => 'Attivato';

  @override
  String get teenModeStatusOff => 'Disattivata';

  @override
  String get teenModeStatusLoading => 'Caricamento';

  @override
  String get teenModeUnavailable =>
      'Lo stato della modalità adolescenti è temporaneamente non disponibile';

  @override
  String get teenModeInvalidResponse =>
      'La modalità adolescenti ha restituito una risposta non valida';

  @override
  String get teenModeEnableDescription =>
      'Le regole della piattaforma limiteranno il tempo di utilizzo e alcune funzioni.';

  @override
  String get teenModePasscode => 'Codice di accesso';

  @override
  String get teenModeCurrentPasscode => 'Codice di accesso attuale';

  @override
  String get teenModeNewPasscode => 'Nuovo codice di accesso';

  @override
  String get teenModePasscodeHint => 'Inserisci 4–6 cifre';

  @override
  String get teenModeEnable => 'Attiva modalità adolescenti';

  @override
  String get teenModeDisable => 'Disattiva modalità adolescenti';

  @override
  String get teenModeChangePasscode => 'Cambia codice di accesso';

  @override
  String get teenModeSource => 'Attivata da';

  @override
  String get teenModeDailyUsage => 'Utilizzato oggi';

  @override
  String get teenModeRemaining => 'Tempo rimanente';

  @override
  String get teenModeMinutesUnit => 'Minuti';

  @override
  String get teenModeUnlimited => 'Illimitato';

  @override
  String get teenModeRequestExtension => 'Richiedi più tempo';

  @override
  String get teenModeExtensionSubmitted =>
      'La richiesta di tempo è stata inviata a un tutore';

  @override
  String get teenModeTimeLimitReached =>
      'Il limite di utilizzo di oggi è stato raggiunto';

  @override
  String get teenModeCurfewActive => 'Questo è un periodo di utilizzo limitato';

  @override
  String get teenModeReliefHint =>
      'Puoi comunque consultare la cronologia, contattare l’assistenza ufficiale e segnalare problemi.';

  @override
  String get teenModeRestrictedNotice =>
      'La modalità adolescenti impedisce attualmente l’invio di messaggi';

  @override
  String get teenModeActionBlocked =>
      'La modalità adolescenti impedisce attualmente questa azione';

  @override
  String get teenModeMyRequests => 'Le mie richieste';

  @override
  String get guardianCenterTitle => 'Centro tutori';

  @override
  String get guardianRelationships => 'Relazioni di tutela';

  @override
  String get guardianMinors => 'Minori sotto la mia supervisione';

  @override
  String get guardianApprovals => 'Approvazioni in attesa';

  @override
  String get guardianBind => 'Inserisci codice di collegamento';

  @override
  String get guardianCreateMinorCode => 'Sono un minore — crea codice';

  @override
  String get guardianCreateGuardianCode => 'Sono un tutore — crea codice';

  @override
  String get guardianRelation => 'Relazione';

  @override
  String get guardianPrimary => 'Tutore principale';

  @override
  String get guardianCode => 'Codice di collegamento a 6 cifre';

  @override
  String get guardianCodeHint =>
      'Inserisci il codice fornito dall’altra persona';

  @override
  String get guardianCodeCreated =>
      'Codice creato. Condividilo prima della scadenza.';

  @override
  String get guardianEmpty => 'Nessuna relazione di tutela';

  @override
  String get guardianNoMinors => 'Nessun minore supervisionato';

  @override
  String get guardianUnbind => 'Rimuovi relazione';

  @override
  String get guardianExtend => 'Aggiungi tempo per il minore';

  @override
  String get guardianPolicyTitle => 'Regole di utilizzo';

  @override
  String get guardianPolicyLocked => 'Bloccato dalla piattaforma';

  @override
  String get approvalEmpty => 'Nessuna richiesta';

  @override
  String get approvalApprove => 'Accetto';

  @override
  String get approvalReject => 'Rifiuta';

  @override
  String get approvalPending => 'In attesa';

  @override
  String get approvalApproved => 'Approvata';

  @override
  String get approvalRejected => 'Rifiutato';

  @override
  String get approvalExpired => 'Scaduto';

  @override
  String get approvalCancelled => 'Annullato';

  @override
  String get approvalReplayFailed =>
      'L’azione originale non è riuscita. Riprova.';

  @override
  String get requestCancelled => 'Richiesta annullata';

  @override
  String get kycTitle => 'Verifica dell\'identità';

  @override
  String get kycNotRequired => 'Verifica dell’identità non necessaria';

  @override
  String get kycVerified => 'Identità verificata';

  @override
  String get kycDeclared => 'Informazioni di identità inviate';

  @override
  String get kycPending => 'In verifica';

  @override
  String get kycRejected => 'Verifica rifiutata';

  @override
  String get kycNone => 'Nessuna informazione di identità inviata';

  @override
  String get kycRealName => 'Nome completo';

  @override
  String get kycIdNumber => 'Numero di documento';

  @override
  String get kycIdType => 'Tipo di documento';

  @override
  String get kycApplicability =>
      'Inserisci i tuoi dati reali per il documento selezionato. I tipi accettati sono nell’elenco.';

  @override
  String get kycCamera => 'Scatta foto';

  @override
  String get kycGallery => 'Scegli dalla galleria';

  @override
  String get kycPhotoLimit => 'Massimo per foto';

  @override
  String get kycSelectPhoto => 'Seleziona foto';

  @override
  String get kycPhotoSelected => 'Selezionata';

  @override
  String get kycViewPhoto => 'Tocca per vedere la foto';

  @override
  String get kycReplacePhoto => 'Scegli un’altra foto';

  @override
  String get kycDisclosure =>
      'Usiamo nome, numero del documento e foto del documento per verificare la tua identità. Senza questi dati non puoi inviare la richiesta e alcune funzioni limitate potrebbero non essere disponibili.';

  @override
  String get kycConsent =>
      'Acconsento separatamente al trattamento di queste informazioni di identità';

  @override
  String get kycConsentRequired =>
      'Fornisci un consenso separato prima dell’invio';

  @override
  String get kycResubmitTitle => 'Invia nuovamente le informazioni di identità';

  @override
  String get kycResubmitWarning =>
      'Un nuovo invio sostituirà la richiesta in attesa. Continuare?';

  @override
  String get kycSubmitting => 'Invio in corso';

  @override
  String get kycSubmitFailed => 'Invio non riuscito. Riprova.';

  @override
  String get kycSubmitUnavailable =>
      'Impossibile inviare le informazioni di identità ora';

  @override
  String get kycResubmitNotAllowed =>
      'Un nuovo invio non è disponibile dopo il rifiuto. Contatta l’assistenza se necessario.';

  @override
  String get kycDailyLimit =>
      'Hai raggiunto il limite di invii di oggi. Riprova domani.';

  @override
  String get kycTypeUnavailable =>
      'Nessun tipo di documento disponibile. Riprova più tardi.';

  @override
  String get kycNameInvalid => 'Il nome legale deve contenere 2–64 caratteri';

  @override
  String get kycNumberRequired => 'Inserisci il numero del documento';

  @override
  String get kycFrontRequired => 'Carica il fronte del documento';

  @override
  String get kycBackRequired => 'Carica il retro del documento';

  @override
  String get kycPhotoTooLarge =>
      'La foto supera il limite di dimensione. Comprimila e riprova.';

  @override
  String get kycAccountChanged =>
      'L’account o lo spazio è cambiato. Riapri questa pagina.';

  @override
  String get kycPhotoInvalid => 'Scegli un’immagine valida';

  @override
  String get kycPortraitSide => 'Lato con il ritratto';

  @override
  String get kycEmblemSide => 'Lato con l’emblema';

  @override
  String get kycPassportDataPage => 'Pagina dati del passaporto';

  @override
  String get kycPassportOtherPage =>
      'Pagina visti o pagina vuota del passaporto';

  @override
  String get kycFront => 'Fronte della carta d\'identità';

  @override
  String get kycBack => 'Retro della carta d\'identità';

  @override
  String get kycRequired =>
      'La verifica dell’identità è necessaria prima di creare un gruppo';

  @override
  String get kycGoVerify => 'Verifica ora';

  @override
  String get kycStatusUnknown =>
      'Stato dell’identità non disponibile. Aggiorna più tardi.';

  @override
  String get kycSuperseded =>
      'Un invio successivo ha sostituito questo. Controlla l’ultimo stato dell’identità.';

  @override
  String get kycMediaNotFound =>
      'La foto del documento non è disponibile in questo spazio. Selezionala di nuovo prima dell’invio.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Invio collettivo ai clienti';

  @override
  String get officialAccountBadge => 'Ufficiale';

  @override
  String get officialAccountOpenConversation => 'Apri conversazione';

  @override
  String get officialAccountJoinHint =>
      'Aggiungendo questo account aderisci all’azienda come cliente. Non è necessaria l’approvazione di amicizia.';

  @override
  String get officialAccountJoinDisabled =>
      'Questa azienda non accetta nuovi clienti. Contatta l’assistenza.';

  @override
  String get officialAccountRemoved =>
      'Sei stato rimosso da questa azienda. Chiedi all’azienda di invitarti nuovamente.';

  @override
  String get officialAccountBanned =>
      'Il tuo account è stato disattivato in questa azienda.';

  @override
  String get officialAccountUnavailable =>
      'Questo account ufficiale non è disponibile al momento.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'L’adesione a un’azienda non è consentita nella modalità attuale.';

  @override
  String get officialAccountPlatformRequired =>
      'Usa un account della piattaforma per aggiungere questo account ufficiale.';

  @override
  String get officialAccountOpenFailed =>
      'Impossibile aprire la conversazione. Riprova.';

  @override
  String get officialAccountAccountChanged =>
      'L’account o lo spazio è cambiato. Apri di nuovo.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'La directory aziendale non è aggiornata. Riprova tra poco.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Sincronizzazione dell’account ufficiale non riuscita. I contenuti locali restano disponibili.';

  @override
  String get officialAccountInboxSyncing =>
      'Sincronizzazione dei messaggi dell’account ufficiale';

  @override
  String get diagnosticsTitle => 'Diagnostica';

  @override
  String get diagnosticsExplanation =>
      'I registri sono anonimizzati e contengono informazioni operative e sugli errori per questo account e spazio, oltre agli eventi pubblici di avvio. Contenuti delle chat e credenziali sono esclusi.';

  @override
  String get diagnosticsHour => 'Ultima ora';

  @override
  String get diagnosticsDay => 'Ultime 24 ore';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Eventi disponibili: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'I registri sono salvati su questo dispositivo e restano disponibili dopo il riavvio.';

  @override
  String get diagnosticsNotPersistent =>
      'Alcuni registri non sono stati salvati. Aggiorna per riprovare.';

  @override
  String get diagnosticsExport => 'Esporta e condividi';

  @override
  String get diagnosticsRefresh => 'Aggiorna';

  @override
  String get diagnosticsClear => 'Cancella i registri di questo spazio';

  @override
  String get diagnosticsClearConfirm =>
      'Cancellare i registri diagnostici di questo spazio? La cronologia chat verrà conservata.';

  @override
  String get diagnosticsShared =>
      'Condivisione di sistema completata. Verifica il file nell’app destinataria.';

  @override
  String get diagnosticsCancelled =>
      'Condivisione annullata. Puoi esportare di nuovo.';

  @override
  String get diagnosticsUnconfirmed =>
      'Impossibile confermare la condivisione. Controlla l’app destinataria.';

  @override
  String get diagnosticsFailed => 'Operazione non riuscita. Riprova.';
}
