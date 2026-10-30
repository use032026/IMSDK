// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navWorkbench => 'Espace de travail';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed =>
      'Impossible de charger les données du compte';

  @override
  String get startupFailureTitle => 'Échec du démarrage';

  @override
  String get startupFailureMessage => 'Vérifiez votre connexion et réessayez';

  @override
  String get privacyConsentTitle =>
      'Conditions d\'utilisation et Politique de confidentialité';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Bienvenue sur $brand. Pour proposer la connexion au compte, la messagerie instantanée, la collaboration en entreprise, le service client en ligne, les notifications et la protection de la sécurité, nous devons traiter les informations nécessaires conformément aux Conditions d’utilisation et à la Politique de confidentialité.\n\nAvant que vous touchiez « Accepter », nous ne lisons pas le presse-papiers, n’initialisons ni JPush/JCore ni les SDK de notifications des fabricants et ne les utilisons pas pour accéder à Android ID, OAID, à la liste des applications installées, aux adresses MAC ou à des informations similaires. Si vous refusez pour le moment, nous enregistrons votre choix ; vous pouvez poursuivre la lecture des documents et décider à nouveau plus tard.\n\nAprès votre accord, pour transmettre les notifications de messages, de service client et d’appels entrants, JPush/JCore et les services de notifications des fabricants peuvent traiter le modèle de l’appareil, la version Android, le package et la version de l’application, le type de réseau, l’adresse IP, Android ID, OAID, l’identifiant d’inscription aux notifications, le jeton du fabricant et les données de remise et de clic sur les notifications. Nous avons désactivé les fonctions non essentielles : notifications intelligentes, liste des applications installées, MAC, IMEI, IMSI, listes Wi-Fi, réveil automatique et démarrage lié.\n\nLe presse-papiers n’est consulté que lorsque vous copiez ou collez vous-même. Les autorisations de caméra, de microphone, de notifications et les autres autorisations système ne sont demandées que lorsque vous utilisez la fonction correspondante. Le refus d’une autorisation affecte uniquement cette fonction. Veuillez lire les documents complets ci-dessous et choisir si vous acceptez.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Bienvenue sur $brand. Pour proposer la connexion au compte, la messagerie instantanée, la collaboration en entreprise, le service client en ligne, les notifications et la protection de la sécurité, nous devons traiter les informations nécessaires conformément aux Conditions d’utilisation et à la Politique de confidentialité.\n\nAvant que vous touchiez « Accepter », nous ne lisons pas le presse-papiers, n’initialisons pas JPush/JCore, ne nous inscrivons pas auprès du service Apple Push Notification (APNs) et n’obtenons aucun identifiant de notifications tel que l’identifiant d’inscription JPush ou le jeton d’appareil APNs. Si vous refusez pour le moment, nous enregistrons votre choix ; vous pouvez poursuivre la lecture des documents et décider à nouveau plus tard.\n\nAprès votre accord, pour transmettre les notifications de messages, de service client et d’appels entrants, nous pouvons traiter le modèle d’iPhone, la version iOS, le package et la version de l’application, le type de réseau, l’adresse IP, IDFV, l’identifiant d’inscription JPush, le jeton d’appareil APNs et les données de remise et de clic sur les notifications. JPush/JCore se connecte au service de notifications ; Apple APNs traite l’identifiant de l’application, le jeton d’appareil et le contenu des notifications pour remettre les notifications système. L’application iOS actuelle n’utilise aucun service publicitaire et n’obtient pas d’IDFA.\n\nLe presse-papiers n’est consulté que lorsque vous copiez ou collez vous-même. Les autorisations de caméra, de microphone, de notifications et les autres autorisations système ne sont demandées que lorsque vous utilisez la fonction correspondante. Le refus d’une autorisation affecte uniquement cette fonction. Veuillez lire les documents complets ci-dessous et choisir si vous acceptez.';
  }

  @override
  String get privacyConsentTermsLink => 'Conditions d\'utilisation';

  @override
  String get privacyConsentConjunction => 'et';

  @override
  String get privacyConsentPrivacyLink => 'Politique de confidentialité';

  @override
  String get privacyConsentDecline => 'Refuser';

  @override
  String get privacyConsentDeclinedExit =>
      'Vous n’avez pas accepté les Conditions d’utilisation et la Politique de confidentialité. L’application va se fermer.';

  @override
  String get privacyConsentAccept => 'Accepter';

  @override
  String get privacyConsentRuntimeFailure =>
      'Échec du démarrage. Vérifiez votre connexion et réessayez.';

  @override
  String get privacyConsentSaveFailure =>
      'Impossible d’enregistrer votre choix. Veuillez réessayer.';

  @override
  String get appUpdateRequiredTitle => 'Mise à jour requise pour continuer';

  @override
  String get appUpdateOptionalTitle => 'Nouvelle version disponible';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version est disponible';
  }

  @override
  String get appUpdateLater => 'Plus tard';

  @override
  String get appUpdateNow => 'Mettre à jour maintenant';

  @override
  String get appUpdateProcessing => 'Traitement en cours…';

  @override
  String get appUpdateInvalidUrl =>
      'L’adresse de mise à jour n’est pas valide. Réessayez plus tard.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Impossible d’ouvrir le lien de mise à jour. Réessayez plus tard.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Téléchargement interrompu. Vérifiez votre connexion et réessayez.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Échec de la vérification du package. Téléchargez-le à nouveau.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Autorisez $brand à installer des mises à jour dans les réglages système.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Impossible d’ouvrir le programme d’installation. Vérifiez les autorisations d’installation.';

  @override
  String get appUpdateGenericFailure =>
      'Échec de la mise à jour. Vérifiez votre connexion et réessayez.';

  @override
  String get appUpdateUnavailable =>
      'La nouvelle version n’est pas encore disponible au téléchargement. Réessayez plus tard.';

  @override
  String get appUpdateCheckFailed =>
      'Impossible de rechercher des mises à jour. Réessayez plus tard.';

  @override
  String get appUpdateChecking => 'Vérification en cours';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get commonLoadFailed => 'Échec du chargement';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonEmpty => 'Aucune donnée';

  @override
  String get commonCopy => 'Copier';

  @override
  String get commonForward => 'Transférer';

  @override
  String get commonFavorite => 'Enregistrer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonSend => 'Envoyer';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonMore => 'Plus';

  @override
  String get commonSettings => 'Paramètres';

  @override
  String get commonCopied => 'Copié';

  @override
  String get commonUnknown => 'Inconnu';

  @override
  String get commonNotSet => 'Non défini';

  @override
  String get commonUnbound => 'Non lié';

  @override
  String get commonViewAll => 'Tout afficher';

  @override
  String get commonSubmit => 'Envoyer';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonRemove => 'Supprimer';

  @override
  String get commonCreate => 'Créer';

  @override
  String get commonUpdate => 'Mettre à jour';

  @override
  String get commonUpload => 'Téléverser';

  @override
  String get commonShare => 'Partager';

  @override
  String get commonBlock => 'Bloquer';

  @override
  String get commonUnblock => 'Débloquer';

  @override
  String get commonMute => 'Mettre en sourdine';

  @override
  String get commonUnmute => 'Réactiver le son';

  @override
  String get commonPin => 'Épinglé';

  @override
  String get commonUnpin => 'Désépingler';

  @override
  String get commonMarkRead => 'Marquer comme lu';

  @override
  String get commonMarkUnread => 'Marquer comme non lu';

  @override
  String get commonOnline => 'En ligne';

  @override
  String get commonOffline => 'Hors ligne';

  @override
  String get commonOperationFailed =>
      'Échec de l’opération. Veuillez réessayer.';

  @override
  String get commonNetworkError => 'Erreur réseau. Vérifiez votre connexion.';

  @override
  String get navMessages => 'Messages';

  @override
  String get navContacts => 'Contacts';

  @override
  String get navMe => 'Moi';

  @override
  String get authLoginTitle => 'Se connecter à StartLink';

  @override
  String get authTabMobile => 'Téléphone';

  @override
  String get authTabEmail => 'E-mail';

  @override
  String get authTabLoginName => 'Identifiant StartLink';

  @override
  String get authHintMobile => 'Saisissez le numéro de téléphone';

  @override
  String get authHintEmail => 'Entrez votre adresse e-mail';

  @override
  String get authHintPassword => 'Entrez le mot de passe';

  @override
  String get authHintCode => 'Saisissez le code de vérification';

  @override
  String get authHintLoginName =>
      'Saisissez l’identifiant StartLink (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Se connecter';

  @override
  String get authGetCode => 'Obtenir le code';

  @override
  String authResendCode(int seconds) {
    return 'Renvoyer dans $seconds s';
  }

  @override
  String get authUsePassword => 'Utiliser un mot de passe';

  @override
  String get authUseCode => 'Utiliser un code de vérification';

  @override
  String get authAgreementPrefix => 'J\'ai lu et j\'accepte les';

  @override
  String get authAgreementAnd => 'et';

  @override
  String get authTermsLink => 'Conditions d\'utilisation';

  @override
  String get authPrivacyLink => 'Politique de confidentialité';

  @override
  String get authCaptchaTitle => 'Vérification de sécurité';

  @override
  String get authCaptchaHint => 'Saisissez la réponse';

  @override
  String get authCaptchaFailed =>
      'Impossible d’obtenir le captcha. Veuillez réessayer.';

  @override
  String get authErrorEmptyCode => 'Veuillez saisir le code de vérification';

  @override
  String get authErrorEmptyPassword => 'Entrez le mot de passe';

  @override
  String get authErrorEmptyLoginName =>
      'Veuillez saisir l’identifiant StartLink';

  @override
  String get authErrorWrongCredentials => 'Compte ou mot de passe incorrect';

  @override
  String get authDeactivatingTitle => 'Suppression du compte';

  @override
  String get authDeactivatingContent =>
      'Votre compte est dans le délai de rétractation de suppression (7 jours).\n\nPour annuler la suppression, touchez « Annuler la suppression » ; sinon, touchez « Continuer » pour accéder à l’application.';

  @override
  String get authContinueUse => 'Continuer';

  @override
  String get authCancelDeactivation => 'Annuler la suppression';

  @override
  String get authDeactivationCancelled =>
      'Suppression annulée, compte restauré';

  @override
  String get authDeactivationCancelFailed =>
      'Échec de l’annulation. Veuillez réessayer.';

  @override
  String get authLogout => 'Se déconnecter';

  @override
  String get authLogoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get authSendingCode => 'Envoi en cours…';

  @override
  String get authCodeSent => 'Code de vérification envoyé';

  @override
  String get authLoginFailed => 'Échec de la connexion. Veuillez réessayer.';

  @override
  String get authRegisterFailed =>
      'Échec de l’inscription. Veuillez réessayer.';

  @override
  String get authEnterpriseCode => 'Code d’entreprise';

  @override
  String get authEnterpriseCodeHint => 'Saisissez le code d’entreprise';

  @override
  String get authPendingApproval =>
      'Inscription réussie. Votre demande d’adhésion à l’entreprise a été envoyée et attend une approbation.';

  @override
  String get authNoAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get authRegisterNow => 'S’inscrire maintenant';

  @override
  String get authCountryPickerTitle => 'Choisissez un pays ou une région';

  @override
  String get authCountrySearchHint => 'Rechercher un pays ou une région';

  @override
  String get authCountryChinaMainland => 'Chine continentale';

  @override
  String get authCountryHongKong => 'Hong Kong, Chine';

  @override
  String get authCountryMacau => 'Macao, Chine';

  @override
  String get authCountryTaiwan => 'Taïwan, Chine';

  @override
  String get authCountryUnitedStates => 'États-Unis';

  @override
  String get authCountryUnitedKingdom => 'Royaume-Uni';

  @override
  String get authCountryJapan => 'Japon';

  @override
  String get authCountrySouthKorea => 'Corée du Sud';

  @override
  String get authCountrySingapore => 'Singapour';

  @override
  String get authCountryMalaysia => 'Malaisie';

  @override
  String get authCountryAustralia => 'Australie';

  @override
  String get authCountryCanada => 'Canada';

  @override
  String get authCountryGermany => 'Allemagne';

  @override
  String get authCountryFrance => 'France';

  @override
  String get authCountryIndia => 'Inde';

  @override
  String get authCountryThailand => 'Thaïlande';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonésie';

  @override
  String get authCountryPhilippines => 'Philippines';

  @override
  String get authQuickLoginTitle => 'Connexion rapide';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress =>
      'Connexion en cours. Veuillez patienter.';

  @override
  String get authRoleOwner => 'Propriétaire';

  @override
  String get authRoleAdministrator => 'Administrateur';

  @override
  String get authRoleCustomerService => 'Service client';

  @override
  String get authRoleTechnicalSupport => 'Assistance technique';

  @override
  String get authRoleEmployee => 'Employé';

  @override
  String get authRoleMember => 'Membre';

  @override
  String get authRoleEnterpriseCustomer => 'Client de l’entreprise';

  @override
  String get authUnavailablePrefix => 'Indisponible · ';

  @override
  String get authUnassignedService => 'Aucun conseiller attribué';

  @override
  String authAssignedService(String staff) {
    return 'Attribué à $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Client · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Employé · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count utilisateurs';
  }

  @override
  String get authMetaPhone => 'Téléphone';

  @override
  String get authMetaIdentity => 'Identité';

  @override
  String get authRegisterTitle => 'S\'inscrire';

  @override
  String get authNickname => 'Pseudonyme';

  @override
  String get authNicknameHint => 'Définissez un pseudo';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authPasswordSetHint =>
      'Définissez un mot de passe (au moins 6 caractères)';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authConfirmPasswordHint => 'Saisissez à nouveau le mot de passe';

  @override
  String get authVerificationCode => 'Code de vérification';

  @override
  String get authRegisterAndLogin => 'S’inscrire et se connecter';

  @override
  String get authHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get authGoLogin => 'Se connecter';

  @override
  String get authEmailVerificationUnavailable =>
      'La vérification par e-mail est indisponible. Inscrivez-vous avec un numéro de mobile.';

  @override
  String get authSmsVerificationUnavailable =>
      'La vérification par SMS est indisponible. Inscrivez-vous avec une adresse e-mail.';

  @override
  String get authSendFailed => 'Impossible d’envoyer. Veuillez réessayer.';

  @override
  String get authErrorEmptyNickname => 'Saisissez un pseudo';

  @override
  String get authErrorInvalidMobile => 'Saisissez un numéro de mobile valide';

  @override
  String get authErrorInvalidEmail => 'Saisissez une adresse e-mail valide';

  @override
  String get authErrorPasswordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get authErrorPasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get authErrorVerificationRequired =>
      'Demandez puis saisissez d’abord le code de vérification';

  @override
  String get authRegisterErrorTitle => 'Échec de l’inscription';

  @override
  String get authGotIt => 'Compris';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Entreprise « $code » introuvable. Vérifiez le code d’entreprise.';
  }

  @override
  String get authTenantSearchFailed =>
      'Échec de la recherche. Veuillez réessayer.';

  @override
  String get authInvitationInvalid =>
      'Le code d’invitation n’est pas valide. Vérifiez-le et réessayez.';

  @override
  String get authCollapseJoin => 'Masquer les informations d’adhésion';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Invitation valide : $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Entreprise trouvée : $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Choisissez une organisation';

  @override
  String get authNoOrganization => 'Aucune organisation disponible';

  @override
  String get authNoOrganizationHint =>
      'Demandez à un administrateur de vous inviter dans une organisation';

  @override
  String get authPersonalSpace => 'Espace personnel';

  @override
  String get authPersonalSpaceSubtitle =>
      'Discussions avec vos amis et favoris personnels';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Impossible de vérifier l’identité de l’espace. Veuillez réessayer.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Impossible de restaurer l’espace personnel. Veuillez réessayer.';

  @override
  String get authJoinEnterpriseFailed =>
      'Impossible de rejoindre l’entreprise. Réessayez plus tard.';

  @override
  String get homeTitle => 'Messages';

  @override
  String get homeGatewayConnectingTitle => 'Connexion en cours';

  @override
  String get homePersonalSpace => 'Personnel';

  @override
  String get homeOfficialService => 'Service officiel';

  @override
  String get homeSwitchSpace => 'Changer d’espace';

  @override
  String get homeSpaceSubtitle => 'Personnel · Entreprise';

  @override
  String get homeJoinEnterprise => 'Rejoindre une entreprise';

  @override
  String get homeCreateGroup => 'Nouveau groupe';

  @override
  String get homeAddFriend => 'Ajouter un contact';

  @override
  String get homeScan => 'Scanner';

  @override
  String get homeJoinNewSpace => 'Rejoindre un nouvel espace';

  @override
  String get homeSearchConversation => 'Rechercher';

  @override
  String get homeNoMessages => 'Aucun message';

  @override
  String get homeDeleteConversation => 'Supprimer la discussion';

  @override
  String get homeDeleteConversationConfirm =>
      'Supprimer cette discussion ? L’historique sera effacé.';

  @override
  String get homePersonalNote => 'Moi (notes personnelles)';

  @override
  String get homeWorkNote => 'Moi (notes professionnelles)';

  @override
  String homeConversationCount(int count) {
    return '$count discussions';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count non lus';
  }

  @override
  String get chatInputHint => 'Saisissez un message…';

  @override
  String get chatVoiceHint => 'Maintenez pour parler';

  @override
  String get chatVoiceRelease => 'Relâchez pour envoyer';

  @override
  String get chatVoiceCancel => 'Glissez vers le haut pour annuler';

  @override
  String get chatMenuCopy => 'Copier';

  @override
  String get chatMenuForward => 'Transférer';

  @override
  String get chatMenuRecall => 'Retirer';

  @override
  String get chatMenuDelete => 'Supprimer';

  @override
  String get chatMenuFavorite => 'Enregistrer';

  @override
  String get chatMenuReply => 'Répondre';

  @override
  String get chatMenuMultiSelect => 'Sélectionner';

  @override
  String get chatMenuTranslate => 'Traduire';

  @override
  String get chatMenuVoiceToText => 'Convertir en texte';

  @override
  String get chatMenuTextToSpeech => 'Lire à voix haute';

  @override
  String get chatStatusRecalled => 'Message retiré';

  @override
  String get chatRecallSuccess => 'Retiré';

  @override
  String get chatRecallFailed => 'Impossible de retirer le message';

  @override
  String get chatRecallTimeout =>
      'Les messages de plus de 2 minutes ne peuvent plus être retirés';

  @override
  String get chatTranslateFailed =>
      'Échec de la traduction. Veuillez réessayer.';

  @override
  String get chatTranslateNotConfigured => 'Service de traduction indisponible';

  @override
  String get chatVoiceToTextFailed =>
      'Échec de la conversion. Veuillez réessayer.';

  @override
  String get chatTextToSpeechFailed =>
      'Échec de la lecture à voix haute. Veuillez réessayer.';

  @override
  String get chatVoiceToText => 'Convertir';

  @override
  String get chatForwardSuccess => 'Transféré';

  @override
  String get chatForwardFailed => 'Échec du transfert. Veuillez réessayer.';

  @override
  String get chatNoConversations =>
      'Aucune discussion vers laquelle transférer';

  @override
  String get chatSendFailed => 'Échec de l’envoi';

  @override
  String get chatResend => 'Renvoyer';

  @override
  String get chatNotFriend => 'Absent de la liste de contacts';

  @override
  String get chatNotFriendHint =>
      'Vous n’êtes pas encore contacts. Impossible d’envoyer des messages.';

  @override
  String get chatMutedHint => 'Tous les membres sont en sourdine';

  @override
  String get chatFileUploadFailed =>
      'Échec du téléversement du fichier. Veuillez réessayer.';

  @override
  String get chatFileStatusNotDownloaded => 'Non téléchargé';

  @override
  String get chatFileStatusDownloaded => 'Téléchargé';

  @override
  String get chatFileStatusUploading => 'Téléversement en cours';

  @override
  String get chatFileStatusUploadFailed => 'Échec de l\'envoi';

  @override
  String get chatCardSendFailed => 'Impossible d’envoyer la fiche de contact';

  @override
  String get chatFavoriteSuccess => 'Enregistré';

  @override
  String get chatFavoriteFailed => 'Impossible d’ajouter aux favoris';

  @override
  String get chatLoadFailed => 'Échec du chargement';

  @override
  String get chatImageMessage => '[Image]';

  @override
  String get chatVoiceMessage => '[Message vocal]';

  @override
  String get chatVideoMessage => '[Vidéo]';

  @override
  String get chatFileMessage => '[Fichier]';

  @override
  String get chatLocationMessage => '[Position]';

  @override
  String get chatContactCardMessage => '[Contact]';

  @override
  String get chatCallLogMessage => '[Appel]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Lu par $count';
  }

  @override
  String get chatUnread => 'Non lu';

  @override
  String get chatRecalledSelf => 'Vous avez retiré un message';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender a retiré un message';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Traduction : $translation';
  }

  @override
  String get chatMessageDeleted => 'Message supprimé';

  @override
  String get chatPeer => 'Autre personne';

  @override
  String get chatSelf => 'Moi';

  @override
  String get chatGenericMessage => '[Message]';

  @override
  String get chatVoiceHideText => 'Masquer le texte';

  @override
  String get chatVoiceShowText => 'Convertir en texte';

  @override
  String get chatFileDefaultName => 'Fichier';

  @override
  String get chatContactDefaultName => 'Contact';

  @override
  String get chatContactCardTitle => 'Fiche de contact';

  @override
  String get chatCallMissed => 'Manqué';

  @override
  String get chatCallCancelled => 'Annulé';

  @override
  String get chatCallRejected => 'Refusé';

  @override
  String get chatCallDisconnected => 'Déconnecté';

  @override
  String get chatCallEnded => 'Appel terminé';

  @override
  String get chatCallFailed => 'Échec de l’appel';

  @override
  String chatCallDuration(String duration) {
    return 'Durée $duration';
  }

  @override
  String get chatVideoCallTitle => 'Appel vidéo';

  @override
  String get chatVoiceCallTitle => 'Appel vocal';

  @override
  String get chatToolPhotos => 'Photos';

  @override
  String get chatToolCamera => 'Appareil photo';

  @override
  String get chatToolFile => 'Fichier';

  @override
  String get chatToolLocation => 'Localisation';

  @override
  String get chatToolContactCard => 'Contact';

  @override
  String get chatToolVoiceCall => 'Appel vocal';

  @override
  String get chatToolVideoCall => 'Appel vidéo';

  @override
  String get chatToolFavorites => 'Favoris';

  @override
  String get chatToolTranslate => 'Traduire';

  @override
  String get chatTranslationChooseLanguage =>
      'Choisissez la langue de traduction';

  @override
  String get chatTranslationEnterText => 'Saisissez d’abord du texte';

  @override
  String get chatTranslationMentionsUnsupported =>
      'La traduction est indisponible pour les messages contenant des mentions';

  @override
  String get chatTranslationScheduledUnsupported =>
      'La traduction est indisponible pendant la modification d’un message programmé';

  @override
  String get chatTranslationFailed => 'Échec de la traduction. Réessayez.';

  @override
  String get chatTranslationEmpty => 'Aucune traduction reçue. Réessayez.';

  @override
  String get chatTranslationTranslating => 'Traduction en cours…';

  @override
  String get chatTranslationSend => 'Envoyer la traduction';

  @override
  String get chatTranslationSending => 'Envoi en cours…';

  @override
  String get chatTranslationExpand => 'Afficher plus';

  @override
  String get chatTranslationCollapse => 'Afficher moins';

  @override
  String get chatFileTooLarge => 'Le fichier dépasse la limite de 100 Mo';

  @override
  String get chatInputMutedAdminOnly =>
      'Seuls le propriétaire ou les membres sélectionnés peuvent écrire.';

  @override
  String get chatImageUploadUnsupported =>
      'Échec du téléversement de l’image. La prise en charge serveur n’est pas encore disponible.';

  @override
  String get chatFavoriteLongPressHint =>
      'Maintenez un message pour l’ajouter aux favoris';

  @override
  String chatSelectedCount(int count) {
    return '$count sélectionnés';
  }

  @override
  String get chatLocationSheetTitle => 'Envoyer la position';

  @override
  String get chatLocationNameLabel => 'Nom du lieu';

  @override
  String get chatLocationNameHint => 'Par ex. bureau, adresse du client';

  @override
  String get chatLocationAddressLabel => 'Adresse';

  @override
  String get chatLocationOptionalHint => 'Facultatif';

  @override
  String get chatLocationLatitudeLabel => 'Latitude';

  @override
  String get chatLocationLatitudeHint => 'De -90 à 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitude';

  @override
  String get chatLocationLongitudeHint => 'De -180 à 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Saisissez $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label est hors limites';
  }

  @override
  String get chatLocationDefaultTitle => 'Localisation';

  @override
  String get chatMutedFullNotice =>
      'Ce groupe est en sourdine. Seuls le propriétaire ou les membres sélectionnés peuvent écrire.';

  @override
  String get chatNotFriendSendBlocked =>
      'Vous n’êtes plus amis et ne pouvez pas envoyer de messages';

  @override
  String get chatPersonalNotesTitle => 'Notes personnelles';

  @override
  String get chatWorkNotesTitle => 'Notes professionnelles';

  @override
  String get chatPersonalNotesDescription =>
      'Consignez vos idées et vos informations importantes ici\nSynchronisées sur tous vos appareils, accessibles à tout moment';

  @override
  String get chatWorkNotesDescription =>
      'Consignez vos tâches et vos documents professionnels ici\nLes espaces d’équipe restent séparés et sécurisés';

  @override
  String get chatNoMessages => 'Aucun message';

  @override
  String chatReplyTo(String sender) {
    return 'Répondre à $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature sera bientôt disponible';
  }

  @override
  String get chatForwardSelectTitle => 'Choisissez une discussion';

  @override
  String get chatContactSelectTitle => 'Choisissez un contact';

  @override
  String get chatNoContacts => 'Aucun contact';

  @override
  String get contactsTitle => 'Contacts';

  @override
  String get contactsSearch => 'Rechercher des contacts';

  @override
  String get contactsNewFriends => 'Nouveaux amis';

  @override
  String get contactsGroups => 'Groupes';

  @override
  String get contactsFavorites => 'Favoris';

  @override
  String get contactsRecent => 'Récents';

  @override
  String get contactsOrganization => 'Organisation';

  @override
  String get contactsAnnouncement => 'Annonces';

  @override
  String get contactsNewApplications => 'Nouvelles demandes';

  @override
  String get contactsCustomerGroups => 'Groupes de clients';

  @override
  String get contactsAllCustomers => 'Tous les clients';

  @override
  String get contactsMyCustomers => 'Mes clients';

  @override
  String get contactsViewAll => 'Tout afficher';

  @override
  String get contactsMyContacts => 'Mes contacts';

  @override
  String get contactsMyAdvisor => 'Mon conseiller';

  @override
  String get contactsNoAdvisor => 'Aucun conseiller attribué pour le moment';

  @override
  String get contactsAdvisorLoading => 'Chargement…';

  @override
  String get contactsNavigateFailed =>
      'Échec de la navigation. Veuillez réessayer.';

  @override
  String get contactsEmpty => 'Aucun contact';

  @override
  String get contactsNoAnnouncement => 'Aucune annonce';

  @override
  String get contactsOfficialBadge => 'Officiel';

  @override
  String get contactsCustomerBadge => 'Client';

  @override
  String get contactsEmptyCustomers => 'Aucun client';

  @override
  String get myTitle => 'Moi';

  @override
  String get myEnterpriseInfo => 'Informations sur l’entreprise';

  @override
  String get myEnterpriseManage => 'Gestion de l’entreprise';

  @override
  String get myQrCode => 'Code QR';

  @override
  String get myFavorites => 'Favoris';

  @override
  String get myLanguage => 'Langue';

  @override
  String get myTimezone => 'Fuseau horaire';

  @override
  String get myAutoTranslate => 'Traduction automatique';

  @override
  String get myNetworkSwitch => 'Changer de ligne';

  @override
  String get mySettings => 'Paramètres';

  @override
  String get myLogout => 'Se déconnecter';

  @override
  String get myLogoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get myLeaveEnterprise => 'Quitter l’entreprise';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Voulez-vous vraiment quitter cette entreprise ? Vous perdrez l’accès à ses données.';

  @override
  String get myLeaveEnterpriseSuccess => 'Entreprise quittée';

  @override
  String get myLeaveEnterpriseFailed =>
      'Impossible de quitter. Veuillez réessayer.';

  @override
  String get myLppIdCopied => 'Identifiant StartLink copié';

  @override
  String myLppIdLabel(String lppId) {
    return 'Identifiant StartLink : $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count contacts';
  }

  @override
  String get myAutoSelect => 'Automatique';

  @override
  String get myPresenceStatus => 'Statut de présence';

  @override
  String get myPresenceStatusTitle => 'Définir la présence';

  @override
  String get myPresenceOnline => 'En ligne';

  @override
  String get myPresenceBusy => 'Occupé';

  @override
  String get myPresenceAway => 'Absent';

  @override
  String get myPresenceInvisible => 'Invisible';

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get profileName => 'Nom';

  @override
  String get profileGender => 'Sexe';

  @override
  String get profileBirthday => 'Date de naissance';

  @override
  String get profileRegion => 'Région';

  @override
  String get profileSignature => 'Présentation';

  @override
  String get profileSignatureHint => 'Parlez un peu de vous';

  @override
  String get profileTapTapText => 'Petit signe';

  @override
  String get profileTapTapHint =>
      'Texte affiché lors d’un petit signe (20 caractères max.)';

  @override
  String get profileAccountSection => 'Compte';

  @override
  String get profileBasicSection => 'Informations de base';

  @override
  String get profileLppId => 'Identifiant StartLink';

  @override
  String get profileLppIdNotSet => 'Non défini';

  @override
  String get profileMobile => 'Téléphone';

  @override
  String get profileMobileUnbound => 'Non lié';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileEmailUnbound => 'Non lié';

  @override
  String get profileQrCode => 'Mon code QR';

  @override
  String get profileChangePassword => 'Modifier le mot de passe';

  @override
  String get profileGenderMale => 'Homme';

  @override
  String get profileGenderFemale => 'Femme';

  @override
  String get profileGenderOther => 'Autre';

  @override
  String get profileGenderUnset => 'Non défini';

  @override
  String get profileSaveFailed =>
      'Échec de l’enregistrement. Veuillez réessayer.';

  @override
  String get profileLppIdTitle => 'Identifiant StartLink';

  @override
  String get profileLppIdSetOnce =>
      'L’identifiant StartLink ne peut être modifié qu’une seule fois. Choisissez avec soin.';

  @override
  String get profileLppIdChangeFailed =>
      'Échec de la modification (l’identifiant StartLink ne peut être modifié qu’une fois)';

  @override
  String get profileChangePasswordOld => 'Mot de passe actuel';

  @override
  String get profileChangePasswordNew => 'Nouveau mot de passe';

  @override
  String get profileChangePasswordConfirm =>
      'Confirmation du nouveau mot de passe';

  @override
  String get profileChangePasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get profileChangePasswordSuccess =>
      'Mot de passe modifié. Veuillez vous reconnecter.';

  @override
  String get profileChangePasswordFailed =>
      'Impossible de modifier le mot de passe. Veuillez réessayer.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionEnterprise => 'Entreprise';

  @override
  String get settingsSectionAccount => 'Compte';

  @override
  String get settingsSectionGeneral => 'Général';

  @override
  String get settingsSectionFeatures => 'Fonctionnalités';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsEnterpriseInfo => 'Informations sur l’entreprise';

  @override
  String get settingsProfile => 'Mon profil';

  @override
  String get settingsAccountSecurity => 'Sécurité du compte';

  @override
  String get settingsNotification => 'Notifications';

  @override
  String get settingsDisplay => 'Affichage';

  @override
  String get settingsFriendPrivacy => 'Confidentialité';

  @override
  String get settingsChat => 'Discussion';

  @override
  String get settingsChatHistory => 'Historique des discussions';

  @override
  String get settingsAbout => 'À propos de StartLink';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsTimezone => 'Fuseau horaire';

  @override
  String get settingsAutoTranslate => 'Traduction automatique';

  @override
  String get settingsNetworkSwitch => 'Changer de ligne';

  @override
  String get enterpriseInfoTitle => 'Informations sur l’entreprise';

  @override
  String get enterpriseName => 'Nom';

  @override
  String get enterpriseDescription => 'Description';

  @override
  String get enterpriseUpdateSuccess => 'Mis à jour avec succès';

  @override
  String get enterpriseUpdateFailed =>
      'Échec de la mise à jour. Veuillez réessayer.';

  @override
  String get enterpriseLeave => 'Quitter l’entreprise';

  @override
  String get enterpriseLeaveConfirm =>
      'Voulez-vous vraiment quitter cette entreprise ?';

  @override
  String get enterpriseLeaveSuccess => 'Entreprise quittée';

  @override
  String get enterpriseLeaveFailed =>
      'Impossible de quitter. Veuillez réessayer.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Le propriétaire ne peut pas quitter directement. Transférez d’abord la propriété.';

  @override
  String get enterpriseMemberCount => 'Membres';

  @override
  String get enterpriseCreatedAt => 'Création';

  @override
  String get enterpriseCode => 'Code d’entreprise';

  @override
  String get enterpriseInviteMembers => 'Inviter des membres';

  @override
  String get enterpriseCopyInviteCode => 'Copier le code d’invitation';

  @override
  String get enterpriseInviteCodeCopied => 'Code d’invitation copié';

  @override
  String get groupCreateTitle => 'Nouveau groupe';

  @override
  String get groupNameHint => 'Saisissez le nom du groupe';

  @override
  String get groupCreateSuccess => 'Groupe créé';

  @override
  String get groupCreateFailed => 'Impossible de créer le groupe';

  @override
  String get groupSettings => 'Réglages du groupe';

  @override
  String get groupName => 'Nom du groupe';

  @override
  String get groupAvatar => 'Image du groupe';

  @override
  String get groupAnnouncement => 'Annonce';

  @override
  String get groupMembers => 'Membres';

  @override
  String get groupAddMember => 'Ajouter des membres';

  @override
  String get groupRemoveMember => 'Retirer un membre';

  @override
  String get groupRemoveMemberConfirm => 'Retirer ce membre ?';

  @override
  String get groupSetAdmin => 'Nommer administrateur';

  @override
  String get groupRemoveAdmin => 'Retirer les droits d’administrateur';

  @override
  String get groupTransferOwner => 'Transférer la propriété';

  @override
  String get groupTransferOwnerConfirm =>
      'Transférer la propriété du groupe à ce membre ?';

  @override
  String get groupTransferOwnerSuccess => 'Propriété transférée';

  @override
  String get groupTransferOwnerFailed =>
      'Échec du transfert. Veuillez réessayer.';

  @override
  String get groupLeave => 'Quitter le groupe';

  @override
  String get groupLeaveConfirm => 'Quitter ce groupe ?';

  @override
  String get groupLeaveSuccess => 'Groupe quitté';

  @override
  String get groupLeaveFailed => 'Impossible de quitter. Veuillez réessayer.';

  @override
  String get groupDissolve => 'Dissoudre le groupe';

  @override
  String get groupDissolveConfirm =>
      'Dissoudre ce groupe ? Tous les membres seront retirés.';

  @override
  String get groupDissolveSuccess => 'Groupe dissous';

  @override
  String get groupDissolveFailed =>
      'Impossible de dissoudre. Veuillez réessayer.';

  @override
  String get groupQrCode => 'Code QR du groupe';

  @override
  String get groupMuteAll => 'Mettre tous les membres en sourdine';

  @override
  String get groupMuteAllOn => 'Activer la sourdine générale';

  @override
  String get groupMuteAllOff => 'Désactiver la sourdine générale';

  @override
  String get groupAllowMemberInvite =>
      'Autoriser les invitations par les membres';

  @override
  String get groupAllowMemberModifyTitle =>
      'Autoriser les membres à modifier le nom du groupe';

  @override
  String get groupAllowMemberAtAll =>
      'Autoriser les membres à mentionner @Tous';

  @override
  String get groupAllowMemberViewMemberList =>
      'Autoriser les membres à consulter la liste des membres';

  @override
  String get groupAllowQrCodeJoin => 'Autoriser l’adhésion par code QR';

  @override
  String get groupRequireApproval => 'Exiger une approbation pour rejoindre';

  @override
  String get groupAllowMemberAddFriend =>
      'Autoriser les membres à s’ajouter comme amis';

  @override
  String get groupRoleOwner => 'Propriétaire';

  @override
  String get groupRoleAdmin => 'Administrateur';

  @override
  String get groupRoleMember => 'Membre';

  @override
  String get groupNoMembers => 'Aucun membre';

  @override
  String get groupNoAnnouncements => 'Aucune annonce';

  @override
  String get groupCreateAnnouncement => 'Publier une annonce';

  @override
  String get groupEditAnnouncement => 'Modifier l’annonce';

  @override
  String get groupDeleteAnnouncement => 'Supprimer l’annonce';

  @override
  String get groupDeleteAnnouncementConfirm => 'Supprimer cette annonce ?';

  @override
  String get groupAnnouncementTitle => 'Titre';

  @override
  String get groupAnnouncementContent => 'Contenu';

  @override
  String get groupAnnouncementPin => 'Épingler l’annonce';

  @override
  String groupMemberCount(int count) {
    return '$count membres';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count sélectionnés';
  }

  @override
  String get groupJoinRequestApprove => 'Accepter';

  @override
  String get groupJoinRequestReject => 'Refuser';

  @override
  String get groupJoinRequests => 'Demandes d’adhésion';

  @override
  String get groupNoJoinRequests => 'Aucune demande d’adhésion';

  @override
  String get groupReadReceipts => 'Confirmations de lecture';

  @override
  String groupReadCount(int count) {
    return '$count lus';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count non lus';
  }

  @override
  String get friendAddTitle => 'Ajouter un contact';

  @override
  String get friendSearchHint => 'Téléphone / E-mail / Identifiant StartLink';

  @override
  String get friendRequestSent => 'Demande d’ami envoyée';

  @override
  String get friendRequestFailed => 'Échec de l’envoi. Veuillez réessayer.';

  @override
  String get friendAlreadyFriend => 'Déjà contacts';

  @override
  String get friendNewFriendsTitle => 'Nouveaux amis';

  @override
  String get friendNoRequests => 'Aucune demande d’ami';

  @override
  String get friendAccept => 'Accepter';

  @override
  String get friendReject => 'Refuser';

  @override
  String get friendAccepted => 'Accepté';

  @override
  String get friendRejected => 'Rejeté';

  @override
  String get friendDeleteConfirm => 'Retirer ce contact ?';

  @override
  String get friendDeleteSuccess => 'Contact retiré';

  @override
  String get friendDeleteFailed => 'Impossible de retirer. Veuillez réessayer.';

  @override
  String get friendRemarkName => 'Nom du contact';

  @override
  String get friendGroupName => 'Groupe';

  @override
  String get friendSendMessage => 'Message';

  @override
  String get friendMatchTypeLppId => 'Trouvé par identifiant StartLink';

  @override
  String get friendMatchTypeMobile => 'Trouvé par téléphone';

  @override
  String get friendMatchTypeEmail => 'Trouvé par e-mail';

  @override
  String get friendSearchEmpty => 'Aucun utilisateur trouvé';

  @override
  String get friendAddMessage => 'Je souhaite vous ajouter à mes contacts';

  @override
  String get friendBlockConfirm => 'Bloquer cet utilisateur ?';

  @override
  String get friendUnblockConfirm => 'Débloquer cet utilisateur ?';

  @override
  String get friendBlockSuccess => 'Bloqué';

  @override
  String get friendUnblockSuccess => 'Débloqué';

  @override
  String get profilePageTitle => 'Informations personnelles';

  @override
  String get profilePageSendMessage => 'Message';

  @override
  String get profilePageAddFriend => 'Ajouter un ami';

  @override
  String get profilePageAlreadyFriend => 'Déjà amis';

  @override
  String get profilePageBlocked => 'Bloqué';

  @override
  String get profilePageBlock => 'Bloquer';

  @override
  String get profilePageUnblock => 'Débloquer';

  @override
  String get profilePageHidden => 'Cet utilisateur a masqué son profil';

  @override
  String get profilePageFriendsOnly =>
      'Cet utilisateur affiche son profil uniquement à ses amis';

  @override
  String get profilePageLppId => 'Identifiant StartLink';

  @override
  String get profilePageRemarkName => 'Remarques';

  @override
  String get profilePageEditRemark => 'Modifier le nom du contact';

  @override
  String get profilePageSaveRemarkSuccess => 'Nom du contact enregistré';

  @override
  String get profilePageSaveRemarkFailed =>
      'Échec de l’enregistrement. Veuillez réessayer.';

  @override
  String get searchTitle => 'Rechercher';

  @override
  String get searchHint =>
      'Rechercher par téléphone, e-mail ou identifiant StartLink';

  @override
  String get searchNoResults => 'Aucun résultat';

  @override
  String get searchMessages => 'Messages';

  @override
  String get searchUsers => 'Utilisateurs';

  @override
  String get searchFailed => 'Échec de la recherche. Veuillez réessayer.';

  @override
  String get scanTitle => 'Scanner';

  @override
  String get scanFailed => 'Échec de la reconnaissance. Veuillez réessayer.';

  @override
  String get scanInvalidQrCode => 'Code QR non valide';

  @override
  String get scanFlashOn => 'Allumer la lampe';

  @override
  String get scanFlashOff => 'Éteindre la lampe';

  @override
  String get scanAlbum => 'Choisir dans l’album';

  @override
  String get favoritesTitle => 'Favoris';

  @override
  String get favoritesEmpty => 'Rien n\'a encore été enregistré';

  @override
  String get favoritesAll => 'Tous';

  @override
  String get favoritesText => 'Texte';

  @override
  String get favoritesImage => 'Images';

  @override
  String get favoritesVideo => 'Vidéo';

  @override
  String get favoritesVoice => 'Messages vocaux';

  @override
  String get favoritesFile => 'Fichiers';

  @override
  String get favoritesOther => 'Autre';

  @override
  String get favoritesDeleteConfirm => 'Retirer des favoris ?';

  @override
  String get favoritesDeleteSuccess => 'Retiré de la collection';

  @override
  String get favoritesDeleteFailed => 'Impossible de retirer';

  @override
  String get favoritesOriginalRecalled => 'Message retiré';

  @override
  String get favoritesViewOriginal => 'Afficher l’original';

  @override
  String get favoritesSearchHint => 'Rechercher dans les favoris';

  @override
  String get favoritesNoResults => 'Aucun favori correspondant';

  @override
  String get noticeTitle => 'Annonces';

  @override
  String get noticeEmpty => 'Aucune annonce';

  @override
  String get noticeDetail => 'Détails de l’annonce';

  @override
  String get noticePublishedAt => 'Publié';

  @override
  String get noticePriorityNormal => 'normal';

  @override
  String get noticePriorityImportant => 'Important';

  @override
  String get noticePriorityUrgent => 'Urgent';

  @override
  String get organizationTitle => 'Organisation';

  @override
  String get organizationEmpty => 'Aucune information sur les services';

  @override
  String get organizationMembers => 'Membres';

  @override
  String get organizationDepartment => 'Service';

  @override
  String get organizationPosition => 'Poste';

  @override
  String get organizationLeader => 'Responsable';

  @override
  String get qrCodeTitle => 'Mon code QR';

  @override
  String get qrCodeSave => 'Enregistrer dans l\'album';

  @override
  String get qrCodeShare => 'Partager';

  @override
  String get qrCodeSaveSuccess => 'Enregistré dans l\'album';

  @override
  String get qrCodeSaveFailed =>
      'Échec de l’enregistrement. Veuillez réessayer.';

  @override
  String get qrCodeRefresh => 'Actualiser le code QR';

  @override
  String get qrCodeExpired => 'Code QR expiré. Veuillez l’actualiser.';

  @override
  String get qrCodeScanToAdd => 'Scannez pour m’ajouter à vos contacts';

  @override
  String get spacePersonal => 'Personnel';

  @override
  String get spaceEnterprise => 'Entreprise';

  @override
  String get spaceJoinByCode => 'Rejoindre avec un code d’entreprise';

  @override
  String get spaceJoinByInvite => 'Rejoindre avec un code d’invitation';

  @override
  String get spaceEnterCode => 'Saisissez le code d’entreprise';

  @override
  String get spaceEnterInviteCode => 'Saisissez le code d’invitation';

  @override
  String get spaceSearchEnterprise => 'Rechercher une entreprise';

  @override
  String get spaceJoinRequestSent => 'Demande envoyée, approbation en attente';

  @override
  String get spaceJoinRequestPending => 'Approbation en attente';

  @override
  String get spaceJoinRequestApproved => 'Demande approuvée';

  @override
  String get spaceJoinRequestRejected => 'Demande refusée';

  @override
  String get spaceAlreadyMember => 'Vous êtes déjà membre';

  @override
  String get spaceAutoApproved => 'Approuvé automatiquement. Bienvenue !';

  @override
  String get spacePendingApprovalHint =>
      'Inscription réussie. Votre demande d’adhésion a été envoyée.';

  @override
  String get spaceNoSpaces => 'Aucun espace';

  @override
  String get spaceInviteExpired => 'Code d’invitation expiré';

  @override
  String get spaceInviteTargetMismatch =>
      'Ce code d’invitation n’est pas destiné à votre compte';

  @override
  String get spaceAcceptInviteSuccess => 'Entreprise rejointe avec succès';

  @override
  String get spaceAcceptInviteFailed =>
      'Impossible de rejoindre. Veuillez réessayer.';

  @override
  String get spaceTenantSelectTitle => 'Choisissez un espace';

  @override
  String get spaceTenantSelectHint => 'Choisissez un espace à ouvrir';

  @override
  String get spaceEnterPersonal => 'Ouvrir l’espace personnel';

  @override
  String get spaceEnterEnterprise => 'Ouvrir l’espace d’entreprise';

  @override
  String get aboutTitle => 'À propos de StartLink';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutTerms => 'Conditions d\'utilisation';

  @override
  String get aboutPrivacy => 'Politique de confidentialité';

  @override
  String get aboutOpenSource => 'Licences open source';

  @override
  String get aboutCheckUpdate => 'Rechercher des mises à jour';

  @override
  String get aboutLatestVersion => 'Vous utilisez la dernière version';

  @override
  String get aboutUpdateAvailable => 'Nouvelle version disponible';

  @override
  String get aboutUpdateNow => 'Mettre à jour maintenant';

  @override
  String get aboutUpdateLater => 'Plus tard';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get notificationGlobalMute => 'Ne pas déranger';

  @override
  String get notificationSound => 'Son';

  @override
  String get notificationVibration => 'Vibration';

  @override
  String get notificationPreview => 'Aperçu des messages';

  @override
  String get notificationDndStart => 'Début du mode Ne pas déranger';

  @override
  String get notificationDndEnd => 'Fin du mode Ne pas déranger';

  @override
  String get blacklistTitle => 'Sur liste noire';

  @override
  String get blacklistEmpty => 'Aucun utilisateur bloqué';

  @override
  String get blacklistRemove => 'Débloquer';

  @override
  String get blacklistRemoveConfirm => 'Débloquer cet utilisateur ?';

  @override
  String get feedbackTitle => 'Avis et suggestions';

  @override
  String get feedbackTypeComplaint => 'Réclamation';

  @override
  String get feedbackTypeSuggestion => 'Suggestion';

  @override
  String get feedbackTypeBug => 'Signalement de bug';

  @override
  String get feedbackContent => 'Description';

  @override
  String get feedbackContentHint =>
      'Décrivez votre problème ou votre suggestion en détail';

  @override
  String get feedbackContact => 'Coordonnées (facultatif)';

  @override
  String get feedbackSubmit => 'Envoyer';

  @override
  String get feedbackSuccess => 'Avis envoyé. Merci !';

  @override
  String get feedbackFailed => 'Échec de l’envoi. Veuillez réessayer.';

  @override
  String get networkTitle => 'Changer de ligne';

  @override
  String get networkAutoSelect => 'Automatique';

  @override
  String get networkManual => 'Manuel';

  @override
  String get timezoneTitle => 'Fuseau horaire';

  @override
  String get timezoneAuto => 'Suivre le système';

  @override
  String get autoTranslateTitle => 'Traduction automatique';

  @override
  String get autoTranslateEnabled => 'Activer la traduction automatique';

  @override
  String get autoTranslateLanguage => 'Langue cible';

  @override
  String get displayTitle => 'Affichage';

  @override
  String get displayFontSize => 'Taille de police';

  @override
  String get displayChatBackground => 'Arrière-plan des discussions';

  @override
  String get displayDarkMode => 'Apparence';

  @override
  String get displayDarkModeSystem => 'Suivre le système';

  @override
  String get displayDarkModeSystemHint =>
      'Changer automatiquement selon le réglage système';

  @override
  String get displayDarkModeOff => 'Clair';

  @override
  String get displayDarkModeOffHint => 'Toujours utiliser le thème clair';

  @override
  String get displayDarkModeOn => 'Sombre';

  @override
  String get displayDarkModeOnHint => 'Toujours utiliser le thème sombre';

  @override
  String get chatSettingsTitle => 'Discussion';

  @override
  String get chatHistoryTitle => 'Historique des discussions';

  @override
  String get chatHistoryClear => 'Effacer tout l’historique';

  @override
  String get chatHistoryClearConfirm =>
      'Effacer tout l’historique des discussions ? Cette action est irréversible.';

  @override
  String get chatHistoryClearSuccess => 'Historique effacé';

  @override
  String get accountSecurityTitle => 'Sécurité du compte';

  @override
  String get accountSecurityChangePassword => 'Modifier le mot de passe';

  @override
  String get accountSecurityChangeMobile => 'Changer de numéro de téléphone';

  @override
  String get accountSecurityChangeEmail => 'Changer l’adresse e-mail';

  @override
  String get accountSecurityLoggedDevices => 'Appareils connectés';

  @override
  String get accountSecurityDeactivate => 'Supprimer le compte';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Toutes les données seront définitivement supprimées après 7 jours. Supprimer le compte ?';

  @override
  String get loggedDevicesTitle => 'Appareils connectés';

  @override
  String get loggedDevicesCurrent => 'Cet appareil';

  @override
  String get loggedDevicesRevoke => 'Déconnecter';

  @override
  String get loggedDevicesRevokeConfirm => 'Déconnecter cet appareil ?';

  @override
  String get loggedDevicesRevokeSuccess => 'Appareil déconnecté';

  @override
  String get loggedDevicesRevokeFailed => 'Échec. Veuillez réessayer.';

  @override
  String get loggedDevicesLastActive => 'Dernière activité';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Ordinateur';

  @override
  String get loggedDevicesTypeUnknown => 'Appareil inconnu';

  @override
  String get privacySettingsTitle => 'Confidentialité';

  @override
  String get privacySearchableByMobile =>
      'Autoriser la recherche par numéro de téléphone';

  @override
  String get privacySearchableByLppId =>
      'Autoriser la recherche par identifiant StartLink';

  @override
  String get privacyAllowFriendRequest => 'Autoriser les demandes d’ami';

  @override
  String get privacyProfileVisibility => 'Visibilité du profil';

  @override
  String get privacyEveryone => 'Tout le monde';

  @override
  String get privacyFriendsOfFriends => 'Amis d’amis';

  @override
  String get privacyNobody => 'Personne';

  @override
  String get privacyFriendsOnly => 'Amis uniquement';

  @override
  String get privacySaveSuccess => 'Réglages enregistrés';

  @override
  String get privacySaveFailed =>
      'Échec de l’enregistrement. Veuillez réessayer.';

  @override
  String get fontSizeTitle => 'Taille de police';

  @override
  String get fontSizeSmall => 'Petit';

  @override
  String get fontSizeNormal => 'Normal';

  @override
  String get fontSizeLarge => 'Grand';

  @override
  String get fontSizeExtraLarge => 'Très grand';

  @override
  String get fontSizePreview => 'Aperçu';

  @override
  String get chatBackgroundTitle => 'Arrière-plan des discussions';

  @override
  String get chatBackgroundDefault => 'Par défaut';

  @override
  String get chatBackgroundCustom => 'Personnalisé';

  @override
  String get chatBackgroundReset => 'Restaurer les paramètres par défaut';

  @override
  String get termsTitle => 'Conditions d\'utilisation';

  @override
  String get privacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get recentContactsTitle => 'Récents';

  @override
  String get recentContactsEmpty => 'Aucun contact récent';

  @override
  String get inviteFriendsTitle => 'Inviter des amis';

  @override
  String get inviteFriendsCopyLink => 'Copier le lien d’invitation';

  @override
  String get inviteFriendsLinkCopied => 'Lien d’invitation copié';

  @override
  String get imageViewerTitle => 'Photo';

  @override
  String get imageViewerSave => 'Enregistrer dans l\'album';

  @override
  String get imageViewerSaveSuccess => 'Enregistré dans l\'album';

  @override
  String get imageViewerSaveFailed =>
      'Échec de l’enregistrement. Veuillez réessayer.';

  @override
  String get customerServiceTitle => 'Bureau du service client';

  @override
  String get customerServiceQueue => 'En attente';

  @override
  String get customerServiceActive => 'Actifs';

  @override
  String get customerServiceClaim => 'Accepter';

  @override
  String get customerServiceTakeover => 'Prendre en charge';

  @override
  String get customerServiceClose => 'Terminer le service';

  @override
  String get customerServiceCloseConfirm =>
      'Terminer cette session de service ?';

  @override
  String get customerServiceNoQueue => 'Aucune session en attente';

  @override
  String get customerServiceNoActive => 'Aucune session active';

  @override
  String get customerServiceVisitor => 'Visiteur';

  @override
  String get customerServiceCustomer => 'Client';

  @override
  String get customerServiceAssignedTo => 'Attribué à';

  @override
  String get customerServiceTransferConversation => 'Transférer la discussion';

  @override
  String get marketingToolbar => 'Outils marketing';

  @override
  String get callIncoming => 'Appel entrant';

  @override
  String get callOutgoing => 'Appel sortant';

  @override
  String get callAccept => 'Accepter';

  @override
  String get callReject => 'Refuser';

  @override
  String get callHangup => 'Terminer';

  @override
  String get callMissed => 'Appel manqué';

  @override
  String get callDuration => 'Durée';

  @override
  String get callAudio => 'Appel vocal';

  @override
  String get callGeneric => 'Appel';

  @override
  String get callVideo => 'Appel vidéo';

  @override
  String get callConnecting => 'Connexion en cours…';

  @override
  String get callRinging => 'Sonnerie…';

  @override
  String get callEnded => 'Appel terminé';

  @override
  String get callFailed => 'Échec de l’appel';

  @override
  String get callRejected => 'Appel refusé';

  @override
  String get callTimeout => 'Aucune réponse';

  @override
  String get callCancelled => 'Annulé';

  @override
  String get callUnknownPeer => 'Inconnu';

  @override
  String get callVideoInvitation => 'Invitation à un appel vidéo';

  @override
  String get callAudioInvitation => 'Invitation à un appel vocal';

  @override
  String get callAnswerAudio => 'Répondre en audio';

  @override
  String get callAnswerVideo => 'Répondre en vidéo';

  @override
  String get callViewProfile => 'Afficher le profil';

  @override
  String get callOpeningCamera => 'Ouverture de la caméra…';

  @override
  String get callWaitingRemoteVideo =>
      'En attente de la vidéo de l’autre personne…';

  @override
  String get callCameraOff => 'Caméra désactivée';

  @override
  String get callCameraOn => 'Caméra activée';

  @override
  String get callMicrophoneOff => 'Microphone désactivé';

  @override
  String get callMicrophoneOn => 'Microphone activé';

  @override
  String get callSpeakerOff => 'Haut-parleur désactivé';

  @override
  String get callSpeakerOn => 'Haut-parleur activé';

  @override
  String get callVideoPermissionFailure =>
      'Impossible de démarrer l’appel vidéo. Vérifiez les autorisations de caméra et de microphone, puis réessayez.';

  @override
  String get callAudioPermissionFailure =>
      'Impossible de démarrer l’appel vocal. Vérifiez l’autorisation du microphone et réessayez.';

  @override
  String get callIncompleteIncoming =>
      'Les informations sur l’appel entrant sont incomplètes. Impossible de répondre.';

  @override
  String get callInProgress => 'En communication';

  @override
  String get callCalling => 'Appel en cours…';

  @override
  String callEndedMedia(String media) {
    return '$media terminé';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media refusé';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media sans réponse';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media annulé';
  }

  @override
  String get callConnectionLost => 'Connexion de l’appel perdue';

  @override
  String get callAdminEnded => 'Appel terminé par un administrateur';

  @override
  String callFailedMedia(String media) {
    return 'Échec de $media';
  }

  @override
  String get callBusy => 'L’autre personne est occupée';

  @override
  String callDurationValue(String duration) {
    return 'Durée de l’appel $duration';
  }

  @override
  String get callNotConnected => 'Non connecté';

  @override
  String get callDialed => 'Sortant';

  @override
  String get callAnswered => 'Répondu';

  @override
  String get callRejectedByPeer => 'Refusé par l’autre personne';

  @override
  String get callRejectedBySelf => 'Rejeté';

  @override
  String get callPeerDidNotAnswer => 'L’autre personne n’a pas répondu';

  @override
  String get callMissedIncoming => 'Appel entrant manqué';

  @override
  String get callPeerCancelled => 'Annulé par l’autre personne';

  @override
  String get notificationNewMessageTitle => 'Nouveau message StartLink';

  @override
  String get notificationOnlineServiceTitle =>
      'Nouveau message du service client';

  @override
  String get notificationNewMessageBody => 'Vous avez reçu un nouveau message';

  @override
  String get notificationImagePreview => 'A envoyé une image';

  @override
  String get notificationVideoPreview => 'A envoyé une vidéo';

  @override
  String get notificationVoicePreview => 'A envoyé un message vocal';

  @override
  String get notificationFilePreview => 'A envoyé un fichier';

  @override
  String get notificationContactPreview => 'A envoyé une fiche de contact';

  @override
  String get notificationCallLogPreview => 'A envoyé un journal d’appel';

  @override
  String get notificationLocationPreview => 'A partagé une position';

  @override
  String get notificationLinkPreview => 'A partagé un lien';

  @override
  String notificationMentionMe(String body) {
    return 'Vous a mentionné : $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender vous a mentionné : $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'A mentionné tout le monde : $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender a mentionné tout le monde : $body';
  }

  @override
  String get notificationSecurityTitle => 'Alerte de sécurité du compte';

  @override
  String get notificationSecurityBody =>
      'Les réglages de sécurité de votre compte StartLink ont changé. Vérifiez-les maintenant.';

  @override
  String get notificationFriendAcceptedTitle => 'Demande d’ami acceptée';

  @override
  String get notificationFriendRejectedTitle => 'Demande d’ami refusée';

  @override
  String get notificationFriendAcceptedBody =>
      'L’autre personne a accepté votre demande d’ami';

  @override
  String get notificationFriendRejectedBody =>
      'L’autre personne a refusé votre demande d’ami';

  @override
  String get notificationVideoCallTitle => 'Invitation à un appel vidéo';

  @override
  String get notificationAudioCallTitle => 'Invitation à un appel vocal';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller vous a invité à un appel vidéo';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller vous a invité à un appel vocal';
  }

  @override
  String get notificationMessageChannelName => 'Messages';

  @override
  String get notificationMessageChannelDescription =>
      'Messages de discussion, journaux d’appels et alertes système';

  @override
  String get notificationCallChannelName => 'Appels';

  @override
  String get notificationCallChannelDescription =>
      'Alertes d’appels vocaux et vidéo';

  @override
  String get notificationSecurityChannelName => 'Sécurité du compte';

  @override
  String get notificationSecurityChannelDescription =>
      'Alertes de connexion et de changement de mot de passe ou de numéro de mobile';

  @override
  String get notificationUnknownCaller => 'Appelant inconnu';

  @override
  String get pendingJoinRequestsTitle => 'Nouvelles demandes';

  @override
  String get pendingJoinRequestsEmpty => 'Aucune demande';

  @override
  String get pendingJoinRequestApprove => 'Accepter';

  @override
  String get pendingJoinRequestReject => 'Refuser';

  @override
  String get pendingJoinRequestApproveSuccess => 'Approuvé';

  @override
  String get pendingJoinRequestRejectSuccess => 'Refusé';

  @override
  String get pendingJoinRequestFailed =>
      'Échec de l’opération. Veuillez réessayer.';

  @override
  String get myCustomersTitle => 'Mes clients';

  @override
  String get myCustomersEmpty => 'Aucun client';

  @override
  String get groupListTitle => 'Groupes';

  @override
  String get groupListEmpty => 'Aucun groupe';

  @override
  String get addFriendTitle => 'Ajouter un contact';

  @override
  String get addFriendSearchHint =>
      'Téléphone / E-mail / Identifiant StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'Identifiant StartLink : $lppId';
  }

  @override
  String get addFriendButton => 'Ajouter';

  @override
  String get addFriendCannotAddSelf =>
      'Vous ne pouvez pas vous ajouter vous-même';

  @override
  String get addFriendUnsupportedUser =>
      'Cet utilisateur ne peut pas être ajouté. Vous pouvez lui écrire directement.';

  @override
  String get addFriendMessageHint => 'Saisissez un message';

  @override
  String get addFriendSendRequest => 'Envoyer la demande';

  @override
  String get joinCompanyTitle => 'Rejoindre une entreprise';

  @override
  String get joinCompanyCodeHint => 'Saisissez le code d’entreprise';

  @override
  String get joinCompanySearchHint => 'Rechercher le nom de l’entreprise';

  @override
  String get joinCompanyApply => 'Demander à rejoindre';

  @override
  String get joinCompanyApplySuccess => 'Demande envoyée';

  @override
  String get joinCompanyApplyFailed =>
      'Échec de la demande. Veuillez réessayer.';

  @override
  String get joinCompanyAutoApproved => 'Approuvé automatiquement. Bienvenue !';

  @override
  String get joinCompanyPending => 'Demande envoyée, approbation en attente';

  @override
  String get joinCompanyInviteCodeHint => 'Saisissez le code d’invitation';

  @override
  String get joinCompanyAcceptInvite => 'Accepter l’invitation';

  @override
  String get joinCompanyNoResults => 'Aucune entreprise trouvée';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count membres';
  }

  @override
  String get timezoneNameHawaii => 'Hawaï';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Heure du Pacifique';

  @override
  String get timezoneNameMountainTime => 'Heure des Rocheuses';

  @override
  String get timezoneNameCentralTime => 'Heure du Centre';

  @override
  String get timezoneNameEasternTime => 'Heure de l’Est';

  @override
  String get timezoneNameAtlanticTime => 'Heure de l’Atlantique';

  @override
  String get timezoneNameBrasilia => 'Brasilia';

  @override
  String get timezoneNameAzores => 'Açores';

  @override
  String get timezoneNameLondonDublin => 'Londres/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Rome';

  @override
  String get timezoneNameCairoHelsinki => 'Le Caire/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moscou/Riyad';

  @override
  String get timezoneNameTehran => 'Téhéran';

  @override
  String get timezoneNameDubaiBaku => 'Dubaï/Bakou';

  @override
  String get timezoneNameKabul => 'Kaboul';

  @override
  String get timezoneNameKarachiTashkent => 'Karachi/Tachkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/New Delhi';

  @override
  String get timezoneNameKathmandu => 'Katmandou';

  @override
  String get timezoneNameDhakaAlmaty => 'Dacca/Almaty';

  @override
  String get timezoneNameYangon => 'Rangoun';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoï/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Pékin/Shanghai/Hong Kong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokyo/Séoul';

  @override
  String get timezoneNameAdelaide => 'Adélaïde';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Îles Salomon';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fidji';

  @override
  String get networkSmartSelectBestRoute =>
      'Choisir intelligemment le meilleur itinéraire';

  @override
  String get networkTesting => 'Test en cours…';

  @override
  String get networkTestingShort => 'Test en cours';

  @override
  String networkLatencyMs(int ms) {
    return 'Latence $ms ms';
  }

  @override
  String get networkConnectionMode => 'Mode de connexion';

  @override
  String get networkDirectMode => 'Mode direct';

  @override
  String get networkProxyMode => 'Mode proxy';

  @override
  String get networkDirectModeDesc => 'Connexion directe au serveur';

  @override
  String get networkProxyModeDesc => 'Connexion par un serveur proxy';

  @override
  String get networkDirectRoutes => 'Itinéraires directs';

  @override
  String get networkProxyRoutes => 'Itinéraires proxy';

  @override
  String get networkTestAll => 'Tout tester';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Nœud de Hong Kong';

  @override
  String get networkSingaporeNode => 'Nœud de Singapour';

  @override
  String get networkJapanNode => 'Nœud du Japon';

  @override
  String get networkUnitedStatesNode => 'Nœud des États-Unis';

  @override
  String get networkHint =>
      'Conseils :\n• Mode direct : plus rapide et adapté à un usage national\n• Mode proxy : plus stable pour les communications transfrontalières\n• Touchez l’icône d’actualisation pour tester la latence d’un itinéraire';

  @override
  String get teenModeTitle => 'Mode adolescent';

  @override
  String get teenModeStatusOn => 'Activé';

  @override
  String get teenModeStatusOff => 'Désactivé';

  @override
  String get teenModeStatusLoading => 'Chargement';

  @override
  String get teenModeUnavailable =>
      'Le statut du mode adolescent est temporairement indisponible';

  @override
  String get teenModeInvalidResponse =>
      'Le mode adolescent a renvoyé une réponse non valide';

  @override
  String get teenModeEnableDescription =>
      'Les règles de la plateforme limiteront le temps d’utilisation et certaines fonctions.';

  @override
  String get teenModePasscode => 'Code d’accès';

  @override
  String get teenModeCurrentPasscode => 'Code d’accès actuel';

  @override
  String get teenModeNewPasscode => 'Nouveau code d’accès';

  @override
  String get teenModePasscodeHint => 'Saisissez 4 à 6 chiffres';

  @override
  String get teenModeEnable => 'Activer le mode adolescent';

  @override
  String get teenModeDisable => 'Désactiver le mode adolescent';

  @override
  String get teenModeChangePasscode => 'Modifier le code d’accès';

  @override
  String get teenModeSource => 'Activé par';

  @override
  String get teenModeDailyUsage => 'Utilisé aujourd’hui';

  @override
  String get teenModeRemaining => 'Temps restant';

  @override
  String get teenModeMinutesUnit => 'Minutes';

  @override
  String get teenModeUnlimited => 'Illimité';

  @override
  String get teenModeRequestExtension => 'Demander plus de temps';

  @override
  String get teenModeExtensionSubmitted =>
      'La demande de temps a été envoyée à un responsable légal';

  @override
  String get teenModeTimeLimitReached =>
      'La limite d’utilisation du jour est atteinte';

  @override
  String get teenModeCurfewActive =>
      'L’utilisation est restreinte pendant cette période';

  @override
  String get teenModeReliefHint =>
      'Vous pouvez toujours consulter l’historique, contacter l’assistance officielle et signaler des problèmes.';

  @override
  String get teenModeRestrictedNotice =>
      'Le mode adolescent empêche actuellement l’envoi de messages';

  @override
  String get teenModeActionBlocked =>
      'Le mode adolescent empêche actuellement cette action';

  @override
  String get teenModeMyRequests => 'Mes demandes';

  @override
  String get guardianCenterTitle => 'Espace des responsables légaux';

  @override
  String get guardianRelationships => 'Liens de responsabilité légale';

  @override
  String get guardianMinors => 'Enfants sous ma supervision';

  @override
  String get guardianApprovals => 'Approbations en attente';

  @override
  String get guardianBind => 'Saisissez le code de liaison';

  @override
  String get guardianCreateMinorCode => 'Je suis un enfant — créer un code';

  @override
  String get guardianCreateGuardianCode =>
      'Je suis responsable légal — créer un code';

  @override
  String get guardianRelation => 'Relation';

  @override
  String get guardianPrimary => 'Responsable légal principal';

  @override
  String get guardianCode => 'Code de liaison à 6 chiffres';

  @override
  String get guardianCodeHint =>
      'Saisissez le code fourni par l’autre personne';

  @override
  String get guardianCodeCreated =>
      'Code créé. Partagez-le avant son expiration.';

  @override
  String get guardianEmpty => 'Aucun lien de responsabilité légale';

  @override
  String get guardianNoMinors => 'Aucun enfant supervisé';

  @override
  String get guardianUnbind => 'Supprimer le lien';

  @override
  String get guardianExtend => 'Ajouter du temps pour l’enfant';

  @override
  String get guardianPolicyTitle => 'Règles d’utilisation';

  @override
  String get guardianPolicyLocked => 'Verrouillé par la plateforme';

  @override
  String get approvalEmpty => 'Aucune demande';

  @override
  String get approvalApprove => 'Accepter';

  @override
  String get approvalReject => 'Refuser';

  @override
  String get approvalPending => 'En attente';

  @override
  String get approvalApproved => 'Approuvé';

  @override
  String get approvalRejected => 'Rejeté';

  @override
  String get approvalExpired => 'Expiré';

  @override
  String get approvalCancelled => 'Annulé';

  @override
  String get approvalReplayFailed =>
      'L’action initiale a échoué. Veuillez la réessayer.';

  @override
  String get requestCancelled => 'Demande annulée';

  @override
  String get kycTitle => 'Vérification d\'identité';

  @override
  String get kycNotRequired => 'La vérification d’identité n’est pas requise';

  @override
  String get kycVerified => 'Identité vérifiée';

  @override
  String get kycDeclared => 'Informations d’identité envoyées';

  @override
  String get kycPending => 'En cours d’examen';

  @override
  String get kycRejected => 'Vérification refusée';

  @override
  String get kycNone => 'Aucune information d’identité envoyée';

  @override
  String get kycRealName => 'Nom complet';

  @override
  String get kycIdNumber => 'Numéro de pièce d\'identité';

  @override
  String get kycIdType => 'Type de document';

  @override
  String get kycApplicability =>
      'Saisissez vos informations réelles pour le document choisi. Les types acceptés figurent dans la liste.';

  @override
  String get kycCamera => 'Prendre une photo';

  @override
  String get kycGallery => 'Choisir dans la galerie';

  @override
  String get kycPhotoLimit => 'Maximum par photo';

  @override
  String get kycSelectPhoto => 'Sélectionner une photo';

  @override
  String get kycPhotoSelected => 'Sélectionnée';

  @override
  String get kycViewPhoto => 'Touchez pour voir la photo';

  @override
  String get kycReplacePhoto => 'Choisir une autre photo';

  @override
  String get kycDisclosure =>
      'Nous utilisons votre nom, le numéro et les photos de votre document pour vérifier votre identité. Sans ces informations, vous ne pouvez pas envoyer de demande et certaines fonctions restreintes peuvent être indisponibles.';

  @override
  String get kycConsent =>
      'Je consens séparément au traitement de ces informations d’identité';

  @override
  String get kycConsentRequired =>
      'Veuillez donner votre consentement distinct avant l’envoi';

  @override
  String get kycResubmitTitle => 'Renvoyer les informations d’identité';

  @override
  String get kycResubmitWarning =>
      'Ce nouvel envoi remplacera votre demande en cours. Continuer ?';

  @override
  String get kycSubmitting => 'Envoi en cours';

  @override
  String get kycSubmitFailed => 'Échec de l’envoi. Réessayez.';

  @override
  String get kycSubmitUnavailable =>
      'Impossible d’envoyer les informations d’identité actuellement';

  @override
  String get kycResubmitNotAllowed =>
      'Un nouvel envoi est impossible après un refus. Contactez l’assistance si nécessaire.';

  @override
  String get kycDailyLimit =>
      'Vous avez atteint la limite d’envoi du jour. Réessayez demain.';

  @override
  String get kycTypeUnavailable =>
      'Aucun type de document disponible. Réessayez plus tard.';

  @override
  String get kycNameInvalid =>
      'Le nom légal doit contenir de 2 à 64 caractères';

  @override
  String get kycNumberRequired => 'Saisissez le numéro de votre document';

  @override
  String get kycFrontRequired => 'Téléversez le recto de votre document';

  @override
  String get kycBackRequired => 'Téléversez le verso de votre document';

  @override
  String get kycPhotoTooLarge =>
      'La photo dépasse la taille limite. Compressez-la et réessayez.';

  @override
  String get kycAccountChanged =>
      'Le compte ou l’espace a changé. Rouvrez cette page.';

  @override
  String get kycPhotoInvalid => 'Choisissez une image valide';

  @override
  String get kycPortraitSide => 'Face avec le portrait';

  @override
  String get kycEmblemSide => 'Face avec l’emblème';

  @override
  String get kycPassportDataPage => 'Page d’identité du passeport';

  @override
  String get kycPassportOtherPage => 'Page de visa ou page vierge du passeport';

  @override
  String get kycFront => 'Recto de la pièce d\'identité';

  @override
  String get kycBack => 'Verso de la pièce d\'identité';

  @override
  String get kycRequired =>
      'La vérification d’identité est requise avant de créer un groupe';

  @override
  String get kycGoVerify => 'Vérifier maintenant';

  @override
  String get kycStatusUnknown =>
      'Statut d’identité indisponible. Actualisez plus tard.';

  @override
  String get kycSuperseded =>
      'Un envoi ultérieur a remplacé celui-ci. Vérifiez votre dernier statut d’identité.';

  @override
  String get kycMediaNotFound =>
      'La photo du document est indisponible dans cet espace. Sélectionnez-la à nouveau avant l’envoi.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Diffusion aux clients';

  @override
  String get officialAccountBadge => 'Officiel';

  @override
  String get officialAccountOpenConversation => 'Ouvrir la conversation';

  @override
  String get officialAccountJoinHint =>
      'L’ajout de ce compte vous fait rejoindre l’entreprise comme client. Aucune approbation d’ami n’est nécessaire.';

  @override
  String get officialAccountJoinDisabled =>
      'Cette entreprise n’accepte pas de nouveaux clients. Contactez l’assistance.';

  @override
  String get officialAccountRemoved =>
      'Vous avez été retiré de cette entreprise. Demandez-lui de vous inviter à nouveau.';

  @override
  String get officialAccountBanned =>
      'Votre compte a été désactivé dans cette entreprise.';

  @override
  String get officialAccountUnavailable =>
      'Ce compte officiel est actuellement indisponible.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Le mode actuel ne permet pas de rejoindre une entreprise.';

  @override
  String get officialAccountPlatformRequired =>
      'Utilisez un compte de plateforme pour ajouter ce compte officiel.';

  @override
  String get officialAccountOpenFailed =>
      'Impossible d’ouvrir la conversation. Veuillez réessayer.';

  @override
  String get officialAccountAccountChanged =>
      'Le compte ou l’espace a changé. Veuillez rouvrir.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'L’annuaire de l’entreprise n’est pas à jour. Réessayez dans un instant.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Échec de la synchronisation du compte officiel. Le contenu local reste disponible.';

  @override
  String get officialAccountInboxSyncing =>
      'Synchronisation des messages du compte officiel';

  @override
  String get diagnosticsTitle => 'Diagnostic';

  @override
  String get diagnosticsExplanation =>
      'Les journaux sont expurgés et contiennent des informations de fonctionnement et d’erreurs pour ce compte et cet espace, ainsi que les événements publics de démarrage. Le contenu des discussions et les identifiants de connexion sont exclus.';

  @override
  String get diagnosticsHour => 'Dernière heure';

  @override
  String get diagnosticsDay => 'Dernières 24 heures';

  @override
  String get diagnosticsWeek => '7J';

  @override
  String diagnosticsEventCount(int count) {
    return 'Événements disponibles : $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Les journaux sont enregistrés sur cet appareil et restent disponibles après redémarrage.';

  @override
  String get diagnosticsNotPersistent =>
      'Certains journaux n’ont pas été enregistrés. Actualisez pour réessayer.';

  @override
  String get diagnosticsExport => 'Exporter et partager';

  @override
  String get diagnosticsRefresh => 'Actualiser';

  @override
  String get diagnosticsClear => 'Effacer les journaux de cet espace';

  @override
  String get diagnosticsClearConfirm =>
      'Effacer les journaux de diagnostic de cet espace ? L’historique des discussions sera conservé.';

  @override
  String get diagnosticsShared =>
      'Partage système terminé. Vérifiez le fichier dans l’application destinataire.';

  @override
  String get diagnosticsCancelled =>
      'Partage annulé. Vous pouvez exporter à nouveau.';

  @override
  String get diagnosticsUnconfirmed =>
      'Impossible de confirmer le partage. Vérifiez l’application destinataire.';

  @override
  String get diagnosticsFailed => 'Échec de l’opération. Veuillez réessayer.';
}
