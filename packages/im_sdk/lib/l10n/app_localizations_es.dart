// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navWorkbench => 'Panel de trabajo';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed =>
      'No se pudieron cargar los datos de la cuenta';

  @override
  String get startupFailureTitle => 'Error de inicio';

  @override
  String get startupFailureMessage =>
      'Comprueba la conexión e inténtalo de nuevo';

  @override
  String get privacyConsentTitle =>
      'Términos de servicio y política de privacidad';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Te damos la bienvenida a $brand. Para ofrecer inicio de sesión, mensajería instantánea, colaboración empresarial, atención al cliente en línea, notificaciones de mensajes y protección de seguridad, necesitamos tratar la información necesaria conforme a las Condiciones del servicio y la Política de privacidad.\n\nAntes de que pulses Aceptar, no leeremos el portapapeles, no inicializaremos JPush/JCore ni los SDK de notificaciones de los fabricantes, ni los utilizaremos para acceder a Android ID, OAID, listas de aplicaciones instaladas, direcciones MAC ni información similar. Si rechazas por ahora, guardaremos tu elección; podrás seguir leyendo los documentos y decidir más adelante.\n\nTras tu aceptación, para enviar notificaciones de mensajes, atención al cliente y llamadas entrantes, JPush/JCore y los servicios de notificaciones de los fabricantes podrán tratar el modelo del dispositivo, la versión de Android, el paquete y la versión de la aplicación, el tipo de red, la dirección IP, Android ID, OAID, el Registration ID de notificaciones, el token del fabricante y los datos de entrega y pulsación de notificaciones. Hemos desactivado funciones no esenciales como las notificaciones inteligentes, las listas de aplicaciones instaladas, MAC, IMEI, IMSI, las listas de redes Wi-Fi, la activación automática y el inicio vinculado.\n\nSolo se accede al portapapeles cuando utilizas copiar o pegar. Los permisos de cámara, micrófono, notificaciones y otros permisos del sistema solo se solicitan cuando utilizas la función correspondiente. Denegar un permiso solo afecta a esa función. Revisa los documentos completos que aparecen a continuación y decide si aceptas.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Te damos la bienvenida a $brand. Para ofrecer inicio de sesión, mensajería instantánea, colaboración empresarial, atención al cliente en línea, notificaciones de mensajes y protección de seguridad, necesitamos tratar la información necesaria conforme a las Condiciones del servicio y la Política de privacidad.\n\nAntes de que pulses Aceptar, no leeremos el portapapeles, no inicializaremos JPush/JCore, no nos registraremos en el servicio de notificaciones de Apple (APNs) ni obtendremos identificadores como el Registration ID de JPush o el token del dispositivo de APNs. Si rechazas por ahora, guardaremos tu elección; podrás seguir leyendo los documentos y decidir más adelante.\n\nTras tu aceptación, para enviar notificaciones de mensajes, atención al cliente y llamadas entrantes, podremos tratar el modelo de iPhone, la versión de iOS, el paquete y la versión de la aplicación, el tipo de red, la dirección IP, IDFV, el Registration ID de JPush, el token del dispositivo de APNs y los datos de entrega y pulsación de notificaciones. JPush/JCore se conecta al servicio de notificaciones; APNs de Apple trata el identificador de la aplicación, el token del dispositivo y el contenido de la notificación para entregar las notificaciones del sistema. La aplicación iOS actual no utiliza servicios publicitarios ni obtiene IDFA.\n\nSolo se accede al portapapeles cuando utilizas copiar o pegar. Los permisos de cámara, micrófono, notificaciones y otros permisos del sistema solo se solicitan cuando utilizas la función correspondiente. Denegar un permiso solo afecta a esa función. Revisa los documentos completos que aparecen a continuación y decide si aceptas.';
  }

  @override
  String get privacyConsentTermsLink => 'Acuerdo de usuario';

  @override
  String get privacyConsentConjunction => 'y';

  @override
  String get privacyConsentPrivacyLink => 'Política de privacidad';

  @override
  String get privacyConsentDecline => 'No aceptar';

  @override
  String get privacyConsentDeclinedExit =>
      'No has aceptado las Condiciones del servicio y la Política de privacidad. La aplicación se cerrará.';

  @override
  String get privacyConsentAccept => 'Aceptar';

  @override
  String get privacyConsentRuntimeFailure =>
      'Error de inicio. Comprueba la conexión e inténtalo de nuevo.';

  @override
  String get privacyConsentSaveFailure =>
      'No se pudo guardar tu elección. Inténtalo de nuevo.';

  @override
  String get appUpdateRequiredTitle => 'Es necesario actualizar para continuar';

  @override
  String get appUpdateOptionalTitle => 'Nueva versión disponible';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version está disponible';
  }

  @override
  String get appUpdateLater => 'Más tarde';

  @override
  String get appUpdateNow => 'Actualizar ahora';

  @override
  String get appUpdateProcessing => 'Procesando...';

  @override
  String get appUpdateInvalidUrl =>
      'La dirección de actualización no es válida. Inténtalo más tarde.';

  @override
  String get appUpdateOpenUrlFailed =>
      'No se pudo abrir el enlace de actualización. Inténtalo más tarde.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Descarga interrumpida. Comprueba la conexión e inténtalo de nuevo.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'No se pudo verificar el paquete. Descárgalo de nuevo.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Permite que $brand instale actualizaciones en los ajustes del sistema.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'No se pudo abrir el instalador del sistema. Comprueba los permisos de instalación.';

  @override
  String get appUpdateGenericFailure =>
      'Error de actualización. Comprueba la conexión e inténtalo de nuevo.';

  @override
  String get appUpdateUnavailable =>
      'La nueva versión aún no está disponible para descargar. Inténtalo más tarde.';

  @override
  String get appUpdateCheckFailed =>
      'No se pudieron buscar actualizaciones. Inténtalo más tarde.';

  @override
  String get appUpdateChecking => 'Buscando';

  @override
  String get commonConfirm => 'Aceptar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonSearch => 'Buscar';

  @override
  String get commonLoading => 'Cargando...';

  @override
  String get commonLoadFailed => 'Error al cargar';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonEmpty => 'Sin datos';

  @override
  String get commonCopy => 'Copiar';

  @override
  String get commonForward => 'Reenviar';

  @override
  String get commonFavorite => 'Guardar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonSend => 'Enviar';

  @override
  String get commonDone => 'Listo';

  @override
  String get commonMore => 'Más';

  @override
  String get commonSettings => 'Configuración';

  @override
  String get commonCopied => 'Copiado';

  @override
  String get commonUnknown => 'Desconocido';

  @override
  String get commonNotSet => 'Sin configurar';

  @override
  String get commonUnbound => 'No vinculado';

  @override
  String get commonViewAll => 'Ver todo';

  @override
  String get commonSubmit => 'Enviar';

  @override
  String get commonAdd => 'Añadir';

  @override
  String get commonRemove => 'Eliminar';

  @override
  String get commonCreate => 'Crear';

  @override
  String get commonUpdate => 'Actualizar';

  @override
  String get commonUpload => 'Subir';

  @override
  String get commonShare => 'Compartir';

  @override
  String get commonBlock => 'Bloquear';

  @override
  String get commonUnblock => 'Desbloquear';

  @override
  String get commonMute => 'Silenciar';

  @override
  String get commonUnmute => 'Activar sonido';

  @override
  String get commonPin => 'Fijados';

  @override
  String get commonUnpin => 'Desfijar';

  @override
  String get commonMarkRead => 'Marcar como leído';

  @override
  String get commonMarkUnread => 'Marcar como no leído';

  @override
  String get commonOnline => 'En línea';

  @override
  String get commonOffline => 'Sin conexión';

  @override
  String get commonOperationFailed =>
      'La operación ha fallado. Inténtalo de nuevo';

  @override
  String get commonNetworkError => 'Error de red. Comprueba la conexión';

  @override
  String get navMessages => 'Mensajes';

  @override
  String get navContacts => 'Contactos';

  @override
  String get navMe => 'Yo';

  @override
  String get authLoginTitle => 'Iniciar sesión en StartLink';

  @override
  String get authTabMobile => 'Teléfono';

  @override
  String get authTabEmail => 'Correo electrónico';

  @override
  String get authTabLoginName => 'ID de StartLink';

  @override
  String get authHintMobile => 'Introduce el número de teléfono';

  @override
  String get authHintEmail => 'Ingrese su dirección de correo electrónico';

  @override
  String get authHintPassword => 'Introduzca la contraseña';

  @override
  String get authHintCode => 'Introduce el código de verificación';

  @override
  String get authHintLoginName => 'Introduce el ID de StartLink (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Iniciar sesión';

  @override
  String get authGetCode => 'Solicitar código';

  @override
  String authResendCode(int seconds) {
    return 'Reenviar en $seconds s';
  }

  @override
  String get authUsePassword => 'Usar contraseña';

  @override
  String get authUseCode => 'Usar código de verificación';

  @override
  String get authAgreementPrefix => 'He leído y acepto las ';

  @override
  String get authAgreementAnd => 'y';

  @override
  String get authTermsLink => 'Acuerdo de usuario';

  @override
  String get authPrivacyLink => 'Política de privacidad';

  @override
  String get authCaptchaTitle => 'Verificación de seguridad';

  @override
  String get authCaptchaHint => 'Introduce la respuesta';

  @override
  String get authCaptchaFailed =>
      'No se pudo obtener el captcha. Inténtalo de nuevo';

  @override
  String get authErrorEmptyCode => 'Introduce el código de verificación';

  @override
  String get authErrorEmptyPassword => 'Introduzca la contraseña';

  @override
  String get authErrorEmptyLoginName => 'Introduce el ID de StartLink';

  @override
  String get authErrorWrongCredentials => 'Cuenta o contraseña incorrectas';

  @override
  String get authDeactivatingTitle => 'Eliminación de cuenta';

  @override
  String get authDeactivatingContent =>
      'Tu cuenta está en el período de espera para la eliminación (7 días).\n\nPara cancelar la eliminación, pulsa «Cancelar eliminación»; de lo contrario, pulsa «Continuar» para entrar en la aplicación.';

  @override
  String get authContinueUse => 'Continuar';

  @override
  String get authCancelDeactivation => 'Cancelar eliminación';

  @override
  String get authDeactivationCancelled =>
      'Eliminación cancelada; cuenta restaurada';

  @override
  String get authDeactivationCancelFailed =>
      'No se pudo cancelar. Inténtalo de nuevo';

  @override
  String get authLogout => 'Cerrar sesión';

  @override
  String get authLogoutConfirm => '¿Quieres cerrar sesión?';

  @override
  String get authSendingCode => 'Enviando...';

  @override
  String get authCodeSent => 'Código de verificación enviado';

  @override
  String get authLoginFailed => 'No se pudo iniciar sesión. Inténtalo de nuevo';

  @override
  String get authRegisterFailed => 'Error de registro. Inténtalo de nuevo';

  @override
  String get authEnterpriseCode => 'Código de empresa';

  @override
  String get authEnterpriseCodeHint => 'Introduce el código de empresa';

  @override
  String get authPendingApproval =>
      'Registro completado. Tu solicitud para unirte a la empresa se ha enviado y está pendiente de aprobación.';

  @override
  String get authNoAccount => '¿No tienes una cuenta?';

  @override
  String get authRegisterNow => 'Registrarse ahora';

  @override
  String get authCountryPickerTitle => 'Selecciona el país o la región';

  @override
  String get authCountrySearchHint => 'Buscar país o región';

  @override
  String get authCountryChinaMainland => 'China continental';

  @override
  String get authCountryHongKong => 'Hong Kong, China';

  @override
  String get authCountryMacau => 'Macao, China';

  @override
  String get authCountryTaiwan => 'Taiwán, China';

  @override
  String get authCountryUnitedStates => 'Estados Unidos';

  @override
  String get authCountryUnitedKingdom => 'Reino Unido';

  @override
  String get authCountryJapan => 'Japón';

  @override
  String get authCountrySouthKorea => 'Corea del Sur';

  @override
  String get authCountrySingapore => 'Singapur';

  @override
  String get authCountryMalaysia => 'Malasia';

  @override
  String get authCountryAustralia => 'Australia';

  @override
  String get authCountryCanada => 'Canadá';

  @override
  String get authCountryGermany => 'Alemania';

  @override
  String get authCountryFrance => 'Francia';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Tailandia';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesia';

  @override
  String get authCountryPhilippines => 'Filipinas';

  @override
  String get authQuickLoginTitle => 'Inicio de sesión rápido';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Iniciando sesión. Espera.';

  @override
  String get authRoleOwner => 'Propietario';

  @override
  String get authRoleAdministrator => 'Administrador';

  @override
  String get authRoleCustomerService => 'Atención al cliente';

  @override
  String get authRoleTechnicalSupport => 'Soporte técnico';

  @override
  String get authRoleEmployee => 'Empleado';

  @override
  String get authRoleMember => 'Miembro';

  @override
  String get authRoleEnterpriseCustomer => 'Cliente empresarial';

  @override
  String get authUnavailablePrefix => 'No disponible · ';

  @override
  String get authUnassignedService => 'Sin agente asignado';

  @override
  String authAssignedService(String staff) {
    return 'Asignado a $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Cliente · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Empleado · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count usuarios';
  }

  @override
  String get authMetaPhone => 'Teléfono';

  @override
  String get authMetaIdentity => 'Identidad';

  @override
  String get authRegisterTitle => 'Registrarse';

  @override
  String get authNickname => 'Apodo';

  @override
  String get authNicknameHint => 'Establece un apodo';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authPasswordSetHint =>
      'Establece una contraseña (al menos 6 caracteres)';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authConfirmPasswordHint => 'Introduce la contraseña de nuevo';

  @override
  String get authVerificationCode => 'Código de verificación';

  @override
  String get authRegisterAndLogin => 'Registrarse e iniciar sesión';

  @override
  String get authHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get authGoLogin => 'Iniciar sesión';

  @override
  String get authEmailVerificationUnavailable =>
      'La verificación por correo no está disponible. Regístrate con un número de móvil.';

  @override
  String get authSmsVerificationUnavailable =>
      'La verificación por SMS no está disponible. Regístrate con un correo electrónico.';

  @override
  String get authSendFailed => 'No se pudo enviar. Inténtalo de nuevo.';

  @override
  String get authErrorEmptyNickname => 'Introduce un apodo';

  @override
  String get authErrorInvalidMobile => 'Introduce un número de móvil válido';

  @override
  String get authErrorInvalidEmail =>
      'Introduce una dirección de correo válida';

  @override
  String get authErrorPasswordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get authErrorPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get authErrorVerificationRequired =>
      'Primero solicita e introduce el código de verificación';

  @override
  String get authRegisterErrorTitle => 'Error de registro';

  @override
  String get authGotIt => 'Entendido';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'No se encontró la empresa «$code». Comprueba el código de empresa.';
  }

  @override
  String get authTenantSearchFailed => 'Error de búsqueda. Inténtalo de nuevo.';

  @override
  String get authInvitationInvalid =>
      'El código de invitación no es válido. Compruébalo e inténtalo de nuevo.';

  @override
  String get authCollapseJoin => 'Ocultar información de incorporación';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Invitación válida: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Empresa encontrada: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Seleccionar organización';

  @override
  String get authNoOrganization => 'No hay organizaciones disponibles';

  @override
  String get authNoOrganizationHint =>
      'Pide a un administrador que te invite a una organización';

  @override
  String get authPersonalSpace => 'Espacio personal';

  @override
  String get authPersonalSpaceSubtitle =>
      'Chats con amigos y favoritos personales';

  @override
  String get authSpaceIdentityValidationFailed =>
      'No se pudo verificar la identidad del espacio. Inténtalo de nuevo.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'No se pudo restaurar el espacio personal. Inténtalo de nuevo.';

  @override
  String get authJoinEnterpriseFailed =>
      'No se pudo entrar en la empresa. Inténtalo más tarde.';

  @override
  String get homeTitle => 'Mensajes';

  @override
  String get homeGatewayConnectingTitle => 'Conectando';

  @override
  String get homePersonalSpace => 'Personal';

  @override
  String get homeOfficialService => 'Servicio oficial';

  @override
  String get homeSwitchSpace => 'Cambiar de espacio';

  @override
  String get homeSpaceSubtitle => 'Personal · Empresa';

  @override
  String get homeJoinEnterprise => 'Unirse a una empresa';

  @override
  String get homeCreateGroup => 'Nuevo grupo';

  @override
  String get homeAddFriend => 'Añadir contacto';

  @override
  String get homeScan => 'Escanear';

  @override
  String get homeJoinNewSpace => 'Unirse a un nuevo espacio';

  @override
  String get homeSearchConversation => 'Buscar';

  @override
  String get homeNoMessages => 'No hay mensajes';

  @override
  String get homeDeleteConversation => 'Eliminar chat';

  @override
  String get homeDeleteConversationConfirm =>
      '¿Eliminar este chat? Se borrará el historial.';

  @override
  String get homePersonalNote => 'Yo (notas personales)';

  @override
  String get homeWorkNote => 'Yo (notas de trabajo)';

  @override
  String homeConversationCount(int count) {
    return '$count chats';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count sin leer';
  }

  @override
  String get chatInputHint => 'Escribe un mensaje...';

  @override
  String get chatVoiceHint => 'Mantén pulsado para hablar';

  @override
  String get chatVoiceRelease => 'Suelta para enviar';

  @override
  String get chatVoiceCancel => 'Desliza hacia arriba para cancelar';

  @override
  String get chatMenuCopy => 'Copiar';

  @override
  String get chatMenuForward => 'Reenviar';

  @override
  String get chatMenuRecall => 'Retirar';

  @override
  String get chatMenuDelete => 'Eliminar';

  @override
  String get chatMenuFavorite => 'Guardar';

  @override
  String get chatMenuReply => 'Responder';

  @override
  String get chatMenuMultiSelect => 'Seleccionar';

  @override
  String get chatMenuTranslate => 'Traducir';

  @override
  String get chatMenuVoiceToText => 'Convertir a texto';

  @override
  String get chatMenuTextToSpeech => 'Leer en voz alta';

  @override
  String get chatStatusRecalled => 'Mensaje retirado';

  @override
  String get chatRecallSuccess => 'Retirado';

  @override
  String get chatRecallFailed => 'No se pudo retirar';

  @override
  String get chatRecallTimeout =>
      'No se pueden retirar mensajes enviados hace más de 2 minutos';

  @override
  String get chatTranslateFailed => 'Error de traducción. Inténtalo de nuevo';

  @override
  String get chatTranslateNotConfigured =>
      'Servicio de traducción no disponible';

  @override
  String get chatVoiceToTextFailed => 'Error de conversión. Inténtalo de nuevo';

  @override
  String get chatTextToSpeechFailed =>
      'No se pudo leer en voz alta. Inténtalo de nuevo';

  @override
  String get chatVoiceToText => 'Convertir';

  @override
  String get chatForwardSuccess => 'Reenviado';

  @override
  String get chatForwardFailed => 'No se pudo reenviar. Inténtalo de nuevo';

  @override
  String get chatNoConversations => 'No hay chats a los que reenviar';

  @override
  String get chatSendFailed => 'No se pudo enviar';

  @override
  String get chatResend => 'Reenviar código';

  @override
  String get chatNotFriend => 'No está en tus contactos';

  @override
  String get chatNotFriendHint =>
      'Aún no sois contactos. No se pueden enviar mensajes.';

  @override
  String get chatMutedHint => 'Todos los miembros están silenciados';

  @override
  String get chatFileUploadFailed =>
      'No se pudo subir el archivo. Inténtalo de nuevo';

  @override
  String get chatFileStatusNotDownloaded => 'Sin descargar';

  @override
  String get chatFileStatusDownloaded => 'Descargado';

  @override
  String get chatFileStatusUploading => 'Subiendo';

  @override
  String get chatFileStatusUploadFailed => 'Carga fallida';

  @override
  String get chatCardSendFailed => 'No se pudo enviar la tarjeta de contacto';

  @override
  String get chatFavoriteSuccess => 'Guardado';

  @override
  String get chatFavoriteFailed => 'No se pudo añadir a favoritos';

  @override
  String get chatLoadFailed => 'Error al cargar';

  @override
  String get chatImageMessage => '[Imagen]';

  @override
  String get chatVoiceMessage => '[Audio]';

  @override
  String get chatVideoMessage => '[Vídeo]';

  @override
  String get chatFileMessage => '[Archivo]';

  @override
  String get chatLocationMessage => '[Ubicación]';

  @override
  String get chatContactCardMessage => '[Contacto]';

  @override
  String get chatCallLogMessage => '[Llamada]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Leído por $count';
  }

  @override
  String get chatUnread => 'Sin leer';

  @override
  String get chatRecalledSelf => 'Has retirado un mensaje';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender ha retirado un mensaje';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Traducción: $translation';
  }

  @override
  String get chatMessageDeleted => 'Mensaje eliminado';

  @override
  String get chatPeer => 'Otros';

  @override
  String get chatSelf => 'Yo';

  @override
  String get chatGenericMessage => '[Mensaje]';

  @override
  String get chatVoiceHideText => 'Ocultar texto';

  @override
  String get chatVoiceShowText => 'Convertir a texto';

  @override
  String get chatFileDefaultName => 'Archivo';

  @override
  String get chatContactDefaultName => 'Contacto';

  @override
  String get chatContactCardTitle => 'Tarjeta de contacto';

  @override
  String get chatCallMissed => 'Perdida';

  @override
  String get chatCallCancelled => 'Cancelada';

  @override
  String get chatCallRejected => 'Rechazada';

  @override
  String get chatCallDisconnected => 'Desconectada';

  @override
  String get chatCallEnded => 'Llamada finalizada';

  @override
  String get chatCallFailed => 'Error de llamada';

  @override
  String chatCallDuration(String duration) {
    return 'Duración: $duration';
  }

  @override
  String get chatVideoCallTitle => 'Videollamada';

  @override
  String get chatVoiceCallTitle => 'Llamada de voz';

  @override
  String get chatToolPhotos => 'Fotos';

  @override
  String get chatToolCamera => 'Cámara';

  @override
  String get chatToolFile => 'Archivo';

  @override
  String get chatToolLocation => 'Ubicación';

  @override
  String get chatToolContactCard => 'Contacto';

  @override
  String get chatToolVoiceCall => 'Llamada de voz';

  @override
  String get chatToolVideoCall => 'Videollamada';

  @override
  String get chatToolFavorites => 'Favoritos';

  @override
  String get chatToolTranslate => 'Traducir';

  @override
  String get chatTranslationChooseLanguage => 'Elegir idioma de traducción';

  @override
  String get chatTranslationEnterText => 'Primero introduce un texto';

  @override
  String get chatTranslationMentionsUnsupported =>
      'La traducción no está disponible para mensajes con menciones';

  @override
  String get chatTranslationScheduledUnsupported =>
      'La traducción no está disponible al editar un mensaje programado';

  @override
  String get chatTranslationFailed => 'Error de traducción. Inténtalo de nuevo';

  @override
  String get chatTranslationEmpty =>
      'No se recibió ninguna traducción. Inténtalo de nuevo';

  @override
  String get chatTranslationTranslating => 'Traduciendo…';

  @override
  String get chatTranslationSend => 'Enviar traducción';

  @override
  String get chatTranslationSending => 'Enviando…';

  @override
  String get chatTranslationExpand => 'Mostrar más';

  @override
  String get chatTranslationCollapse => 'Mostrar menos';

  @override
  String get chatFileTooLarge => 'El archivo supera el límite (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Solo pueden escribir el propietario o los miembros seleccionados.';

  @override
  String get chatImageUploadUnsupported =>
      'No se pudo subir la imagen. El servidor aún no ofrece esta función.';

  @override
  String get chatFavoriteLongPressHint =>
      'Mantén pulsado un mensaje para añadirlo a favoritos';

  @override
  String chatSelectedCount(int count) {
    return '$count seleccionados';
  }

  @override
  String get chatLocationSheetTitle => 'Enviar ubicación';

  @override
  String get chatLocationNameLabel => 'Nombre del lugar';

  @override
  String get chatLocationNameHint => 'P. ej., oficina, dirección del cliente';

  @override
  String get chatLocationAddressLabel => 'Dirección';

  @override
  String get chatLocationOptionalHint => 'Opcional';

  @override
  String get chatLocationLatitudeLabel => 'Latitud';

  @override
  String get chatLocationLatitudeHint => 'De -90 a 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitud';

  @override
  String get chatLocationLongitudeHint => 'De -180 a 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Introduce $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label está fuera del intervalo permitido';
  }

  @override
  String get chatLocationDefaultTitle => 'Ubicación';

  @override
  String get chatMutedFullNotice =>
      'Este grupo está silenciado. Solo pueden escribir el propietario o los miembros seleccionados.';

  @override
  String get chatNotFriendSendBlocked =>
      'Ya no sois amigos y no puedes enviar mensajes';

  @override
  String get chatPersonalNotesTitle => 'Notas personales';

  @override
  String get chatWorkNotesTitle => 'Notas de trabajo';

  @override
  String get chatPersonalNotesDescription =>
      'Anota tus ideas y guarda información importante aquí\nSincronizadas entre dispositivos para acceder en cualquier momento';

  @override
  String get chatWorkNotesDescription =>
      'Anota tareas y guarda material de trabajo aquí\nLos espacios de equipo se mantienen separados y seguros';

  @override
  String get chatNoMessages => 'No hay mensajes';

  @override
  String chatReplyTo(String sender) {
    return 'Responder a $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature estará disponible próximamente';
  }

  @override
  String get chatForwardSelectTitle => 'Elegir chat';

  @override
  String get chatContactSelectTitle => 'Elegir contacto';

  @override
  String get chatNoContacts => 'Sin contactos';

  @override
  String get contactsTitle => 'Contactos';

  @override
  String get contactsSearch => 'Buscar contactos';

  @override
  String get contactsNewFriends => 'Nuevos amigos';

  @override
  String get contactsGroups => 'Grupos';

  @override
  String get contactsFavorites => 'Favoritos';

  @override
  String get contactsRecent => 'Recientes';

  @override
  String get contactsOrganization => 'Organización';

  @override
  String get contactsAnnouncement => 'Anuncios';

  @override
  String get contactsNewApplications => 'Nuevas solicitudes';

  @override
  String get contactsCustomerGroups => 'Grupos de clientes';

  @override
  String get contactsAllCustomers => 'Todos los clientes';

  @override
  String get contactsMyCustomers => 'Mis clientes';

  @override
  String get contactsViewAll => 'Ver todo';

  @override
  String get contactsMyContacts => 'Mis contactos';

  @override
  String get contactsMyAdvisor => 'Mi asesor';

  @override
  String get contactsNoAdvisor => 'Aún no hay asesor asignado';

  @override
  String get contactsAdvisorLoading => 'Cargando...';

  @override
  String get contactsNavigateFailed => 'No se pudo abrir. Inténtalo de nuevo';

  @override
  String get contactsEmpty => 'Sin contactos';

  @override
  String get contactsNoAnnouncement => 'Sin anuncios';

  @override
  String get contactsOfficialBadge => 'Oficial';

  @override
  String get contactsCustomerBadge => 'Cliente';

  @override
  String get contactsEmptyCustomers => 'Sin clientes';

  @override
  String get myTitle => 'Yo';

  @override
  String get myEnterpriseInfo => 'Información de la empresa';

  @override
  String get myEnterpriseManage => 'Gestión de la empresa';

  @override
  String get myQrCode => 'Código QR';

  @override
  String get myFavorites => 'Favoritos';

  @override
  String get myLanguage => 'Idioma';

  @override
  String get myTimezone => 'Zona horaria';

  @override
  String get myAutoTranslate => 'Traducción automática';

  @override
  String get myNetworkSwitch => 'Cambiar línea';

  @override
  String get mySettings => 'Configuración';

  @override
  String get myLogout => 'Cerrar sesión';

  @override
  String get myLogoutConfirm => '¿Quieres cerrar sesión?';

  @override
  String get myLeaveEnterprise => 'Salir de la empresa';

  @override
  String get myLeaveEnterpriseConfirm =>
      '¿Quieres salir de esta empresa? Perderás el acceso a sus datos.';

  @override
  String get myLeaveEnterpriseSuccess => 'Has salido de la empresa';

  @override
  String get myLeaveEnterpriseFailed => 'No se pudo salir. Inténtalo de nuevo';

  @override
  String get myLppIdCopied => 'ID de StartLink copiado';

  @override
  String myLppIdLabel(String lppId) {
    return 'ID de StartLink: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count contactos';
  }

  @override
  String get myAutoSelect => 'Automático';

  @override
  String get myPresenceStatus => 'Estado de conexión';

  @override
  String get myPresenceStatusTitle => 'Establecer estado';

  @override
  String get myPresenceOnline => 'En línea';

  @override
  String get myPresenceBusy => 'Ocupado';

  @override
  String get myPresenceAway => 'Ausente';

  @override
  String get myPresenceInvisible => 'Invisible';

  @override
  String get profileTitle => 'Mi perfil';

  @override
  String get profileName => 'Nombre';

  @override
  String get profileGender => 'Género';

  @override
  String get profileBirthday => 'Fecha de nacimiento';

  @override
  String get profileRegion => 'Región';

  @override
  String get profileSignature => 'Biografía';

  @override
  String get profileSignatureHint => 'Cuéntanos algo sobre ti';

  @override
  String get profileTapTapText => 'Toquecito';

  @override
  String get profileTapTapHint =>
      'Texto que se muestra al darte un toque (máx. 20 caracteres)';

  @override
  String get profileAccountSection => 'Cuenta';

  @override
  String get profileBasicSection => 'Información básica';

  @override
  String get profileLppId => 'ID de StartLink';

  @override
  String get profileLppIdNotSet => 'Sin configurar';

  @override
  String get profileMobile => 'Teléfono';

  @override
  String get profileMobileUnbound => 'No vinculado';

  @override
  String get profileEmail => 'Correo electrónico';

  @override
  String get profileEmailUnbound => 'No vinculado';

  @override
  String get profileQrCode => 'Mi código QR';

  @override
  String get profileChangePassword => 'Cambiar contraseña';

  @override
  String get profileGenderMale => 'Masculino';

  @override
  String get profileGenderFemale => 'Femenino';

  @override
  String get profileGenderOther => 'Otro';

  @override
  String get profileGenderUnset => 'Sin configurar';

  @override
  String get profileSaveFailed => 'No se pudo guardar. Inténtalo de nuevo';

  @override
  String get profileLppIdTitle => 'ID de StartLink';

  @override
  String get profileLppIdSetOnce =>
      'El ID de StartLink solo puede cambiarse una vez. Elígelo con cuidado.';

  @override
  String get profileLppIdChangeFailed =>
      'No se pudo cambiar (el ID de StartLink solo puede cambiarse una vez)';

  @override
  String get profileChangePasswordOld => 'Contraseña actual';

  @override
  String get profileChangePasswordNew => 'Nueva contraseña';

  @override
  String get profileChangePasswordConfirm => 'Confirmar nueva contraseña';

  @override
  String get profileChangePasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get profileChangePasswordSuccess =>
      'Contraseña cambiada. Inicia sesión de nuevo.';

  @override
  String get profileChangePasswordFailed =>
      'No se pudo cambiar la contraseña. Inténtalo de nuevo';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsSectionEnterprise => 'Empresa';

  @override
  String get settingsSectionAccount => 'Cuenta';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionFeatures => 'Funciones';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsEnterpriseInfo => 'Información de la empresa';

  @override
  String get settingsProfile => 'Mi perfil';

  @override
  String get settingsAccountSecurity => 'Seguridad de la cuenta';

  @override
  String get settingsNotification => 'Notificaciones';

  @override
  String get settingsDisplay => 'Pantalla';

  @override
  String get settingsFriendPrivacy => 'Privacidad';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Historial de chat';

  @override
  String get settingsAbout => 'Acerca de StartLink';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTimezone => 'Zona horaria';

  @override
  String get settingsAutoTranslate => 'Traducción automática';

  @override
  String get settingsNetworkSwitch => 'Cambiar línea';

  @override
  String get enterpriseInfoTitle => 'Información de la empresa';

  @override
  String get enterpriseName => 'Nombre';

  @override
  String get enterpriseDescription => 'Descripción';

  @override
  String get enterpriseUpdateSuccess => 'Actualizado correctamente';

  @override
  String get enterpriseUpdateFailed =>
      'No se pudo actualizar. Inténtalo de nuevo';

  @override
  String get enterpriseLeave => 'Salir de la empresa';

  @override
  String get enterpriseLeaveConfirm => '¿Quieres salir de esta empresa?';

  @override
  String get enterpriseLeaveSuccess => 'Has salido de la empresa';

  @override
  String get enterpriseLeaveFailed => 'No se pudo salir. Inténtalo de nuevo';

  @override
  String get enterpriseLeaveOwnerError =>
      'El propietario no puede salir directamente. Primero debe transferir la propiedad.';

  @override
  String get enterpriseMemberCount => 'Miembros';

  @override
  String get enterpriseCreatedAt => 'Creado';

  @override
  String get enterpriseCode => 'Código de empresa';

  @override
  String get enterpriseInviteMembers => 'Invitar miembros';

  @override
  String get enterpriseCopyInviteCode => 'Copiar código de invitación';

  @override
  String get enterpriseInviteCodeCopied => 'Código de invitación copiado';

  @override
  String get groupCreateTitle => 'Nuevo grupo';

  @override
  String get groupNameHint => 'Introduce el nombre del grupo';

  @override
  String get groupCreateSuccess => 'Grupo creado';

  @override
  String get groupCreateFailed => 'No se pudo crear el grupo';

  @override
  String get groupSettings => 'Ajustes del grupo';

  @override
  String get groupName => 'Nombre del grupo';

  @override
  String get groupAvatar => 'Avatar del grupo';

  @override
  String get groupAnnouncement => 'Anuncio';

  @override
  String get groupMembers => 'Miembros';

  @override
  String get groupAddMember => 'Añadir miembros';

  @override
  String get groupRemoveMember => 'Eliminar miembro';

  @override
  String get groupRemoveMemberConfirm => '¿Eliminar a este miembro?';

  @override
  String get groupSetAdmin => 'Nombrar administrador';

  @override
  String get groupRemoveAdmin => 'Retirar como administrador';

  @override
  String get groupTransferOwner => 'Transferir propiedad';

  @override
  String get groupTransferOwnerConfirm =>
      '¿Transferir la propiedad del grupo a este miembro?';

  @override
  String get groupTransferOwnerSuccess => 'Propiedad transferida';

  @override
  String get groupTransferOwnerFailed =>
      'No se pudo transferir. Inténtalo de nuevo';

  @override
  String get groupLeave => 'Salir del grupo';

  @override
  String get groupLeaveConfirm => '¿Salir de este grupo?';

  @override
  String get groupLeaveSuccess => 'Has salido del grupo';

  @override
  String get groupLeaveFailed => 'No se pudo salir. Inténtalo de nuevo';

  @override
  String get groupDissolve => 'Disolver grupo';

  @override
  String get groupDissolveConfirm =>
      '¿Disolver este grupo? Se eliminarán todos sus miembros.';

  @override
  String get groupDissolveSuccess => 'Grupo disuelto';

  @override
  String get groupDissolveFailed => 'No se pudo disolver. Inténtalo de nuevo';

  @override
  String get groupQrCode => 'Código QR del grupo';

  @override
  String get groupMuteAll => 'Silenciar a todos';

  @override
  String get groupMuteAllOn => 'Activar silencio para todos';

  @override
  String get groupMuteAllOff => 'Desactivar silencio para todos';

  @override
  String get groupAllowMemberInvite => 'Permitir invitaciones de miembros';

  @override
  String get groupAllowMemberModifyTitle =>
      'Permitir que los miembros cambien el nombre del grupo';

  @override
  String get groupAllowMemberAtAll =>
      'Permitir que los miembros mencionen a todos';

  @override
  String get groupAllowMemberViewMemberList =>
      'Permitir que los miembros vean la lista de miembros';

  @override
  String get groupAllowQrCodeJoin => 'Permitir unirse mediante código QR';

  @override
  String get groupRequireApproval => 'Exigir aprobación para unirse';

  @override
  String get groupAllowMemberAddFriend =>
      'Permitir que los miembros se añadan entre sí';

  @override
  String get groupRoleOwner => 'Propietario';

  @override
  String get groupRoleAdmin => 'Administrador';

  @override
  String get groupRoleMember => 'Miembro';

  @override
  String get groupNoMembers => 'Sin miembros';

  @override
  String get groupNoAnnouncements => 'Sin anuncios';

  @override
  String get groupCreateAnnouncement => 'Publicar anuncio';

  @override
  String get groupEditAnnouncement => 'Editar anuncio';

  @override
  String get groupDeleteAnnouncement => 'Eliminar anuncio';

  @override
  String get groupDeleteAnnouncementConfirm => '¿Eliminar este anuncio?';

  @override
  String get groupAnnouncementTitle => 'Título';

  @override
  String get groupAnnouncementContent => 'Contenido';

  @override
  String get groupAnnouncementPin => 'Fijar anuncio';

  @override
  String groupMemberCount(int count) {
    return '$count miembros';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count seleccionados';
  }

  @override
  String get groupJoinRequestApprove => 'Aceptar';

  @override
  String get groupJoinRequestReject => 'Rechazar';

  @override
  String get groupJoinRequests => 'Solicitudes de incorporación';

  @override
  String get groupNoJoinRequests => 'Sin solicitudes de incorporación';

  @override
  String get groupReadReceipts => 'Confirmaciones de lectura';

  @override
  String groupReadCount(int count) {
    return '$count han leído';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count sin leer';
  }

  @override
  String get friendAddTitle => 'Añadir contacto';

  @override
  String get friendSearchHint => 'Teléfono / Correo / ID de StartLink';

  @override
  String get friendRequestSent => 'Solicitud de amistad enviada';

  @override
  String get friendRequestFailed => 'No se pudo enviar. Inténtalo de nuevo';

  @override
  String get friendAlreadyFriend => 'Ya sois contactos';

  @override
  String get friendNewFriendsTitle => 'Nuevos amigos';

  @override
  String get friendNoRequests => 'Sin solicitudes de amistad';

  @override
  String get friendAccept => 'Aceptar';

  @override
  String get friendReject => 'Rechazar';

  @override
  String get friendAccepted => 'Aceptada';

  @override
  String get friendRejected => 'Rechazado';

  @override
  String get friendDeleteConfirm => '¿Eliminar este contacto?';

  @override
  String get friendDeleteSuccess => 'Contacto eliminado';

  @override
  String get friendDeleteFailed => 'No se pudo eliminar. Inténtalo de nuevo';

  @override
  String get friendRemarkName => 'Apodo';

  @override
  String get friendGroupName => 'Grupo';

  @override
  String get friendSendMessage => 'Mensaje';

  @override
  String get friendMatchTypeLppId => 'Encontrado por ID de StartLink';

  @override
  String get friendMatchTypeMobile => 'Encontrado por teléfono';

  @override
  String get friendMatchTypeEmail => 'Encontrado por correo';

  @override
  String get friendSearchEmpty => 'No se encontraron usuarios';

  @override
  String get friendAddMessage => 'Me gustaría añadirte como contacto';

  @override
  String get friendBlockConfirm => '¿Bloquear a este usuario?';

  @override
  String get friendUnblockConfirm => '¿Desbloquear a este usuario?';

  @override
  String get friendBlockSuccess => 'Bloqueado';

  @override
  String get friendUnblockSuccess => 'Desbloqueado';

  @override
  String get profilePageTitle => 'Información personal';

  @override
  String get profilePageSendMessage => 'Mensaje';

  @override
  String get profilePageAddFriend => 'Añadir amigo';

  @override
  String get profilePageAlreadyFriend => 'Ya sois amigos';

  @override
  String get profilePageBlocked => 'Bloqueado';

  @override
  String get profilePageBlock => 'Bloquear';

  @override
  String get profilePageUnblock => 'Desbloquear';

  @override
  String get profilePageHidden => 'Este usuario ha ocultado su perfil';

  @override
  String get profilePageFriendsOnly =>
      'Este usuario solo muestra su perfil a sus amigos';

  @override
  String get profilePageLppId => 'ID de StartLink';

  @override
  String get profilePageRemarkName => 'Observaciones';

  @override
  String get profilePageEditRemark => 'Editar apodo';

  @override
  String get profilePageSaveRemarkSuccess => 'Apodo guardado';

  @override
  String get profilePageSaveRemarkFailed =>
      'No se pudo guardar. Inténtalo de nuevo';

  @override
  String get searchTitle => 'Buscar';

  @override
  String get searchHint => 'Buscar por teléfono, correo o ID de StartLink';

  @override
  String get searchNoResults => 'No se encontraron resultados';

  @override
  String get searchMessages => 'Mensajes';

  @override
  String get searchUsers => 'Usuarios';

  @override
  String get searchFailed => 'Error de búsqueda. Inténtalo de nuevo';

  @override
  String get scanTitle => 'Escanear';

  @override
  String get scanFailed => 'No se pudo reconocer. Inténtalo de nuevo';

  @override
  String get scanInvalidQrCode => 'Código QR no válido';

  @override
  String get scanFlashOn => 'Encender linterna';

  @override
  String get scanFlashOff => 'Apagar linterna';

  @override
  String get scanAlbum => 'Elegir del álbum';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesEmpty => 'Aún no has guardado nada';

  @override
  String get favoritesAll => 'Todos';

  @override
  String get favoritesText => 'Texto';

  @override
  String get favoritesImage => 'Imágenes';

  @override
  String get favoritesVideo => 'Vídeo';

  @override
  String get favoritesVoice => 'Audio';

  @override
  String get favoritesFile => 'Archivos';

  @override
  String get favoritesOther => 'Otro';

  @override
  String get favoritesDeleteConfirm => '¿Quitar de favoritos?';

  @override
  String get favoritesDeleteSuccess => 'Eliminado de guardados';

  @override
  String get favoritesDeleteFailed => 'No se pudo quitar';

  @override
  String get favoritesOriginalRecalled => 'Mensaje retirado';

  @override
  String get favoritesViewOriginal => 'Ver original';

  @override
  String get favoritesSearchHint => 'Buscar en favoritos';

  @override
  String get favoritesNoResults => 'Sin favoritos coincidentes';

  @override
  String get noticeTitle => 'Anuncios';

  @override
  String get noticeEmpty => 'Sin anuncios';

  @override
  String get noticeDetail => 'Detalles del anuncio';

  @override
  String get noticePublishedAt => 'Publicado';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Importante';

  @override
  String get noticePriorityUrgent => 'Urgente';

  @override
  String get organizationTitle => 'Organización';

  @override
  String get organizationEmpty => 'Sin información de departamento';

  @override
  String get organizationMembers => 'Miembros';

  @override
  String get organizationDepartment => 'Departamento';

  @override
  String get organizationPosition => 'Puesto';

  @override
  String get organizationLeader => 'Responsable';

  @override
  String get qrCodeTitle => 'Mi código QR';

  @override
  String get qrCodeSave => 'Guardar en álbum';

  @override
  String get qrCodeShare => 'Compartir';

  @override
  String get qrCodeSaveSuccess => 'Guardado en el álbum';

  @override
  String get qrCodeSaveFailed => 'No se pudo guardar. Inténtalo de nuevo';

  @override
  String get qrCodeRefresh => 'Actualizar código QR';

  @override
  String get qrCodeExpired => 'El código QR ha caducado. Actualízalo';

  @override
  String get qrCodeScanToAdd => 'Escanea para añadirme como contacto';

  @override
  String get spacePersonal => 'Personal';

  @override
  String get spaceEnterprise => 'Empresa';

  @override
  String get spaceJoinByCode => 'Unirse con código de empresa';

  @override
  String get spaceJoinByInvite => 'Unirse con código de invitación';

  @override
  String get spaceEnterCode => 'Introduce el código de empresa';

  @override
  String get spaceEnterInviteCode => 'Introduce el código de invitación';

  @override
  String get spaceSearchEnterprise => 'Buscar empresa';

  @override
  String get spaceJoinRequestSent =>
      'Solicitud enviada, pendiente de aprobación';

  @override
  String get spaceJoinRequestPending => 'Aprobación pendiente';

  @override
  String get spaceJoinRequestApproved => 'Solicitud aprobada';

  @override
  String get spaceJoinRequestRejected => 'Solicitud rechazada';

  @override
  String get spaceAlreadyMember => 'Ya eres miembro';

  @override
  String get spaceAutoApproved => 'Aprobado automáticamente. ¡Bienvenido!';

  @override
  String get spacePendingApprovalHint =>
      'Registro completado. Tu solicitud de incorporación se ha enviado.';

  @override
  String get spaceNoSpaces => 'Sin espacios';

  @override
  String get spaceInviteExpired => 'El código de invitación ha caducado';

  @override
  String get spaceInviteTargetMismatch =>
      'Este código de invitación no es para tu cuenta';

  @override
  String get spaceAcceptInviteSuccess => 'Te has unido a la empresa';

  @override
  String get spaceAcceptInviteFailed => 'No se pudo unir. Inténtalo de nuevo';

  @override
  String get spaceTenantSelectTitle => 'Seleccionar espacio';

  @override
  String get spaceTenantSelectHint => 'Elige un espacio para entrar';

  @override
  String get spaceEnterPersonal => 'Entrar en el espacio personal';

  @override
  String get spaceEnterEnterprise => 'Entrar en el espacio empresarial';

  @override
  String get aboutTitle => 'Acerca de StartLink';

  @override
  String get aboutVersion => 'Versión';

  @override
  String get aboutTerms => 'Condiciones del servicio';

  @override
  String get aboutPrivacy => 'Política de privacidad';

  @override
  String get aboutOpenSource => 'Licencias de código abierto';

  @override
  String get aboutCheckUpdate => 'Buscar actualizaciones';

  @override
  String get aboutLatestVersion => 'Estás utilizando la última versión';

  @override
  String get aboutUpdateAvailable => 'Nueva versión disponible';

  @override
  String get aboutUpdateNow => 'Actualizar ahora';

  @override
  String get aboutUpdateLater => 'Más tarde';

  @override
  String get notificationTitle => 'Notificaciones';

  @override
  String get notificationGlobalMute => 'No molestar';

  @override
  String get notificationSound => 'Sonido';

  @override
  String get notificationVibration => 'Vibración';

  @override
  String get notificationPreview => 'Vista previa de mensajes';

  @override
  String get notificationDndStart => 'Inicio de No molestar';

  @override
  String get notificationDndEnd => 'Fin de No molestar';

  @override
  String get blacklistTitle => 'En lista negra';

  @override
  String get blacklistEmpty => 'Sin usuarios bloqueados';

  @override
  String get blacklistRemove => 'Desbloquear';

  @override
  String get blacklistRemoveConfirm => '¿Desbloquear a este usuario?';

  @override
  String get feedbackTitle => 'Comentarios';

  @override
  String get feedbackTypeComplaint => 'Reclamación';

  @override
  String get feedbackTypeSuggestion => 'Sugerencia';

  @override
  String get feedbackTypeBug => 'Informe de error';

  @override
  String get feedbackContent => 'Descripción';

  @override
  String get feedbackContentHint =>
      'Describe el problema o la sugerencia con detalle';

  @override
  String get feedbackContact => 'Contacto (opcional)';

  @override
  String get feedbackSubmit => 'Enviar';

  @override
  String get feedbackSuccess => 'Comentarios enviados. ¡Gracias!';

  @override
  String get feedbackFailed => 'No se pudo enviar. Inténtalo de nuevo';

  @override
  String get networkTitle => 'Cambiar línea';

  @override
  String get networkAutoSelect => 'Automático';

  @override
  String get networkManual => 'Manual';

  @override
  String get timezoneTitle => 'Zona horaria';

  @override
  String get timezoneAuto => 'Seguir al sistema';

  @override
  String get autoTranslateTitle => 'Traducción automática';

  @override
  String get autoTranslateEnabled => 'Activar traducción automática';

  @override
  String get autoTranslateLanguage => 'Idioma de destino';

  @override
  String get displayTitle => 'Pantalla';

  @override
  String get displayFontSize => 'Tamaño de fuente';

  @override
  String get displayChatBackground => 'Fondo del chat';

  @override
  String get displayDarkMode => 'Apariencia';

  @override
  String get displayDarkModeSystem => 'Seguir al sistema';

  @override
  String get displayDarkModeSystemHint =>
      'Cambiar automáticamente según los ajustes del sistema';

  @override
  String get displayDarkModeOff => 'Claro';

  @override
  String get displayDarkModeOffHint => 'Usar siempre el tema claro';

  @override
  String get displayDarkModeOn => 'Oscuro';

  @override
  String get displayDarkModeOnHint => 'Usar siempre el tema oscuro';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Historial de chat';

  @override
  String get chatHistoryClear => 'Borrar todo el historial';

  @override
  String get chatHistoryClearConfirm =>
      '¿Borrar todo el historial de chat? No se puede deshacer.';

  @override
  String get chatHistoryClearSuccess => 'Historial de chat borrado';

  @override
  String get accountSecurityTitle => 'Seguridad de la cuenta';

  @override
  String get accountSecurityChangePassword => 'Cambiar contraseña';

  @override
  String get accountSecurityChangeMobile => 'Cambiar número de teléfono';

  @override
  String get accountSecurityChangeEmail => 'Cambiar correo electrónico';

  @override
  String get accountSecurityLoggedDevices => 'Dispositivos con sesión iniciada';

  @override
  String get accountSecurityDeactivate => 'Eliminar cuenta';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Todos los datos se eliminarán permanentemente después de 7 días. ¿Eliminar la cuenta?';

  @override
  String get loggedDevicesTitle => 'Dispositivos con sesión iniciada';

  @override
  String get loggedDevicesCurrent => 'Este dispositivo';

  @override
  String get loggedDevicesRevoke => 'Cerrar sesión';

  @override
  String get loggedDevicesRevokeConfirm =>
      '¿Cerrar sesión en este dispositivo?';

  @override
  String get loggedDevicesRevokeSuccess => 'Sesión cerrada en el dispositivo';

  @override
  String get loggedDevicesRevokeFailed => 'Ha fallado. Inténtalo de nuevo';

  @override
  String get loggedDevicesLastActive => 'Última actividad';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Escritorio';

  @override
  String get loggedDevicesTypeUnknown => 'Dispositivo desconocido';

  @override
  String get privacySettingsTitle => 'Privacidad';

  @override
  String get privacySearchableByMobile =>
      'Permitir búsquedas por número de teléfono';

  @override
  String get privacySearchableByLppId =>
      'Permitir búsquedas por ID de StartLink';

  @override
  String get privacyAllowFriendRequest => 'Permitir solicitudes de amistad';

  @override
  String get privacyProfileVisibility => 'Visibilidad del perfil';

  @override
  String get privacyEveryone => 'Todos';

  @override
  String get privacyFriendsOfFriends => 'Amigos de amigos';

  @override
  String get privacyNobody => 'Nadie';

  @override
  String get privacyFriendsOnly => 'Solo amigos';

  @override
  String get privacySaveSuccess => 'Ajustes guardados';

  @override
  String get privacySaveFailed => 'No se pudo guardar. Inténtalo de nuevo';

  @override
  String get fontSizeTitle => 'Tamaño de fuente';

  @override
  String get fontSizeSmall => 'Pequeño';

  @override
  String get fontSizeNormal => 'Normal';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get fontSizeExtraLarge => 'Extragrande';

  @override
  String get fontSizePreview => 'Vista previa';

  @override
  String get chatBackgroundTitle => 'Fondo del chat';

  @override
  String get chatBackgroundDefault => 'Predeterminado';

  @override
  String get chatBackgroundCustom => 'Personalizado';

  @override
  String get chatBackgroundReset => 'Restaurar valores predeterminados';

  @override
  String get termsTitle => 'Condiciones del servicio';

  @override
  String get privacyPolicyTitle => 'Política de privacidad';

  @override
  String get recentContactsTitle => 'Recientes';

  @override
  String get recentContactsEmpty => 'Sin contactos recientes';

  @override
  String get inviteFriendsTitle => 'Invitar amigos';

  @override
  String get inviteFriendsCopyLink => 'Copiar enlace de invitación';

  @override
  String get inviteFriendsLinkCopied => 'Enlace de invitación copiado';

  @override
  String get imageViewerTitle => 'Foto';

  @override
  String get imageViewerSave => 'Guardar en álbum';

  @override
  String get imageViewerSaveSuccess => 'Guardado en el álbum';

  @override
  String get imageViewerSaveFailed => 'No se pudo guardar. Inténtalo de nuevo';

  @override
  String get customerServiceTitle => 'Panel de atención';

  @override
  String get customerServiceQueue => 'En cola';

  @override
  String get customerServiceActive => 'En atención';

  @override
  String get customerServiceClaim => 'Aceptar';

  @override
  String get customerServiceTakeover => 'Tomar el control';

  @override
  String get customerServiceClose => 'Finalizar atención';

  @override
  String get customerServiceCloseConfirm =>
      '¿Finalizar esta sesión de atención?';

  @override
  String get customerServiceNoQueue => 'Sin sesiones en cola';

  @override
  String get customerServiceNoActive => 'Sin sesiones en atención';

  @override
  String get customerServiceVisitor => 'Visitante';

  @override
  String get customerServiceCustomer => 'Cliente';

  @override
  String get customerServiceAssignedTo => 'Asignado a';

  @override
  String get customerServiceTransferConversation => 'Transferir chat';

  @override
  String get marketingToolbar => 'Herramientas de marketing';

  @override
  String get callIncoming => 'Llamada entrante';

  @override
  String get callOutgoing => 'Llamada saliente';

  @override
  String get callAccept => 'Aceptar';

  @override
  String get callReject => 'Rechazar';

  @override
  String get callHangup => 'Finalizar';

  @override
  String get callMissed => 'Llamada perdida';

  @override
  String get callDuration => 'Duración';

  @override
  String get callAudio => 'Llamada de voz';

  @override
  String get callGeneric => 'Llamar';

  @override
  String get callVideo => 'Videollamada';

  @override
  String get callConnecting => 'Conectando...';

  @override
  String get callRinging => 'Sonando...';

  @override
  String get callEnded => 'Llamada finalizada';

  @override
  String get callFailed => 'Error de llamada';

  @override
  String get callRejected => 'Llamada rechazada';

  @override
  String get callTimeout => 'Sin respuesta';

  @override
  String get callCancelled => 'Cancelada';

  @override
  String get callUnknownPeer => 'Desconocido';

  @override
  String get callVideoInvitation => 'Invitación a videollamada';

  @override
  String get callAudioInvitation => 'Invitación a llamada de audio';

  @override
  String get callAnswerAudio => 'Responder con audio';

  @override
  String get callAnswerVideo => 'Responder con vídeo';

  @override
  String get callViewProfile => 'Ver perfil';

  @override
  String get callOpeningCamera => 'Abriendo la cámara...';

  @override
  String get callWaitingRemoteVideo =>
      'Esperando el vídeo de la otra persona...';

  @override
  String get callCameraOff => 'Cámara desactivada';

  @override
  String get callCameraOn => 'Cámara activada';

  @override
  String get callMicrophoneOff => 'Micrófono desactivado';

  @override
  String get callMicrophoneOn => 'Micrófono activado';

  @override
  String get callSpeakerOff => 'Altavoz desactivado';

  @override
  String get callSpeakerOn => 'Altavoz activado';

  @override
  String get callVideoPermissionFailure =>
      'No se pudo iniciar la videollamada. Comprueba los permisos de cámara y micrófono e inténtalo de nuevo.';

  @override
  String get callAudioPermissionFailure =>
      'No se pudo iniciar la llamada de audio. Comprueba el permiso del micrófono e inténtalo de nuevo.';

  @override
  String get callIncompleteIncoming =>
      'La información de la llamada entrante está incompleta y no se puede responder.';

  @override
  String get callInProgress => 'En llamada';

  @override
  String get callCalling => 'Llamando...';

  @override
  String callEndedMedia(String media) {
    return '$media finalizada';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media rechazada';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media sin respuesta';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media cancelada';
  }

  @override
  String get callConnectionLost => 'Se perdió la conexión de la llamada';

  @override
  String get callAdminEnded => 'Un administrador finalizó la llamada';

  @override
  String callFailedMedia(String media) {
    return 'Error en $media';
  }

  @override
  String get callBusy => 'La otra persona está ocupada';

  @override
  String callDurationValue(String duration) {
    return 'Duración de la llamada: $duration';
  }

  @override
  String get callNotConnected => 'Sin conexión';

  @override
  String get callDialed => 'Saliente';

  @override
  String get callAnswered => 'Respondida';

  @override
  String get callRejectedByPeer => 'Rechazada por la otra persona';

  @override
  String get callRejectedBySelf => 'Rechazado';

  @override
  String get callPeerDidNotAnswer => 'La otra persona no respondió';

  @override
  String get callMissedIncoming => 'Llamada entrante perdida';

  @override
  String get callPeerCancelled => 'Cancelada por la otra persona';

  @override
  String get notificationNewMessageTitle => 'Nuevo mensaje de StartLink';

  @override
  String get notificationOnlineServiceTitle =>
      'Nuevo mensaje de atención al cliente';

  @override
  String get notificationNewMessageBody => 'Has recibido un nuevo mensaje';

  @override
  String get notificationImagePreview => 'Envió una imagen';

  @override
  String get notificationVideoPreview => 'Envió un vídeo';

  @override
  String get notificationVoicePreview => 'Envió un mensaje de voz';

  @override
  String get notificationFilePreview => 'Envió un archivo';

  @override
  String get notificationContactPreview => 'Envió una tarjeta de contacto';

  @override
  String get notificationCallLogPreview => 'Envió un registro de llamada';

  @override
  String get notificationLocationPreview => 'Compartió una ubicación';

  @override
  String get notificationLinkPreview => 'Compartió un enlace';

  @override
  String notificationMentionMe(String body) {
    return 'Te mencionaron: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender te mencionó: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Mención a todos: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender mencionó a todos: $body';
  }

  @override
  String get notificationSecurityTitle => 'Alerta de seguridad de la cuenta';

  @override
  String get notificationSecurityBody =>
      'Los ajustes de seguridad de tu cuenta de StartLink han cambiado. Revísalos ahora.';

  @override
  String get notificationFriendAcceptedTitle => 'Solicitud de amistad aceptada';

  @override
  String get notificationFriendRejectedTitle =>
      'Solicitud de amistad rechazada';

  @override
  String get notificationFriendAcceptedBody =>
      'La otra persona aceptó tu solicitud de amistad';

  @override
  String get notificationFriendRejectedBody =>
      'La otra persona rechazó tu solicitud de amistad';

  @override
  String get notificationVideoCallTitle => 'Invitación a videollamada';

  @override
  String get notificationAudioCallTitle => 'Invitación a llamada de voz';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller te invitó a una videollamada';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller te invitó a una llamada de voz';
  }

  @override
  String get notificationMessageChannelName => 'Mensajes';

  @override
  String get notificationMessageChannelDescription =>
      'Mensajes de chat, registros de llamadas y alertas del sistema';

  @override
  String get notificationCallChannelName => 'Llamadas';

  @override
  String get notificationCallChannelDescription =>
      'Alertas de llamadas de voz y vídeo';

  @override
  String get notificationSecurityChannelName => 'Seguridad de la cuenta';

  @override
  String get notificationSecurityChannelDescription =>
      'Alertas de inicio de sesión y cambios de contraseña o número de móvil';

  @override
  String get notificationUnknownCaller => 'Persona desconocida';

  @override
  String get pendingJoinRequestsTitle => 'Nuevas solicitudes';

  @override
  String get pendingJoinRequestsEmpty => 'Sin solicitudes';

  @override
  String get pendingJoinRequestApprove => 'Aceptar';

  @override
  String get pendingJoinRequestReject => 'Rechazar';

  @override
  String get pendingJoinRequestApproveSuccess => 'Aprobada';

  @override
  String get pendingJoinRequestRejectSuccess => 'Rechazada';

  @override
  String get pendingJoinRequestFailed =>
      'La operación ha fallado. Inténtalo de nuevo';

  @override
  String get myCustomersTitle => 'Mis clientes';

  @override
  String get myCustomersEmpty => 'Sin clientes';

  @override
  String get groupListTitle => 'Grupos';

  @override
  String get groupListEmpty => 'Sin grupos';

  @override
  String get addFriendTitle => 'Añadir contacto';

  @override
  String get addFriendSearchHint => 'Teléfono / Correo / ID de StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'ID de StartLink: $lppId';
  }

  @override
  String get addFriendButton => 'Añadir';

  @override
  String get addFriendCannotAddSelf => 'No puedes añadirte a ti mismo';

  @override
  String get addFriendUnsupportedUser =>
      'No puedes añadir a este usuario. Puedes enviarle mensajes directamente.';

  @override
  String get addFriendMessageHint => 'Introduce un mensaje';

  @override
  String get addFriendSendRequest => 'Enviar solicitud';

  @override
  String get joinCompanyTitle => 'Unirse a una empresa';

  @override
  String get joinCompanyCodeHint => 'Introduce el código de empresa';

  @override
  String get joinCompanySearchHint => 'Buscar nombre de empresa';

  @override
  String get joinCompanyApply => 'Solicitar incorporación';

  @override
  String get joinCompanyApplySuccess => 'Solicitud enviada';

  @override
  String get joinCompanyApplyFailed =>
      'No se pudo solicitar. Inténtalo de nuevo';

  @override
  String get joinCompanyAutoApproved =>
      'Aprobado automáticamente. ¡Bienvenido!';

  @override
  String get joinCompanyPending => 'Solicitud enviada, pendiente de aprobación';

  @override
  String get joinCompanyInviteCodeHint => 'Introduce el código de invitación';

  @override
  String get joinCompanyAcceptInvite => 'Aceptar invitación';

  @override
  String get joinCompanyNoResults => 'No se encontraron empresas';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count miembros';
  }

  @override
  String get timezoneNameHawaii => 'Hawái';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Hora del Pacífico';

  @override
  String get timezoneNameMountainTime => 'Hora de la Montaña';

  @override
  String get timezoneNameCentralTime => 'Hora Central';

  @override
  String get timezoneNameEasternTime => 'Hora del Este';

  @override
  String get timezoneNameAtlanticTime => 'Hora del Atlántico';

  @override
  String get timezoneNameBrasilia => 'Brasilia';

  @override
  String get timezoneNameAzores => 'Azores';

  @override
  String get timezoneNameLondonDublin => 'Londres/Dublín';

  @override
  String get timezoneNameBerlinParisRome => 'Berlín/París/Roma';

  @override
  String get timezoneNameCairoHelsinki => 'El Cairo/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moscú/Riad';

  @override
  String get timezoneNameTehran => 'Teherán';

  @override
  String get timezoneNameDubaiBaku => 'Dubái/Bakú';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karachi/Taskent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Bombay/Nueva Delhi';

  @override
  String get timezoneNameKathmandu => 'Katmandú';

  @override
  String get timezoneNameDhakaAlmaty => 'Daca/Almatý';

  @override
  String get timezoneNameYangon => 'Rangún';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanói/Yakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Pekín/Shanghái/Hong Kong/Taipéi';

  @override
  String get timezoneNameTokyoSeoul => 'Tokio/Seúl';

  @override
  String get timezoneNameAdelaide => 'Adelaida';

  @override
  String get timezoneNameSydneyMelbourne => 'Sídney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Islas Salomón';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiyi';

  @override
  String get networkSmartSelectBestRoute =>
      'Seleccionar la mejor ruta automáticamente';

  @override
  String get networkTesting => 'Probando...';

  @override
  String get networkTestingShort => 'Probando';

  @override
  String networkLatencyMs(int ms) {
    return 'Latencia: $ms ms';
  }

  @override
  String get networkConnectionMode => 'Modo de conexión';

  @override
  String get networkDirectMode => 'Modo directo';

  @override
  String get networkProxyMode => 'Modo proxy';

  @override
  String get networkDirectModeDesc => 'Conectar directamente al servidor';

  @override
  String get networkProxyModeDesc => 'Conectar a través de un servidor proxy';

  @override
  String get networkDirectRoutes => 'Rutas directas';

  @override
  String get networkProxyRoutes => 'Rutas proxy';

  @override
  String get networkTestAll => 'Probar todas';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Nodo de Hong Kong';

  @override
  String get networkSingaporeNode => 'Nodo de Singapur';

  @override
  String get networkJapanNode => 'Nodo de Japón';

  @override
  String get networkUnitedStatesNode => 'Nodo de Estados Unidos';

  @override
  String get networkHint =>
      'Consejos:\n• Modo directo: más rápido y adecuado para uso nacional\n• Modo proxy: más estable para comunicaciones internacionales\n• Pulsa el icono de actualización para probar la latencia de una ruta';

  @override
  String get teenModeTitle => 'Modo para menores';

  @override
  String get teenModeStatusOn => 'Activado';

  @override
  String get teenModeStatusOff => 'Desactivado';

  @override
  String get teenModeStatusLoading => 'Cargando';

  @override
  String get teenModeUnavailable =>
      'El estado del modo para menores no está disponible temporalmente';

  @override
  String get teenModeInvalidResponse =>
      'El modo para menores devolvió una respuesta no válida';

  @override
  String get teenModeEnableDescription =>
      'Las reglas de la plataforma limitarán el tiempo de uso y algunas funciones.';

  @override
  String get teenModePasscode => 'Código de acceso';

  @override
  String get teenModeCurrentPasscode => 'Código actual';

  @override
  String get teenModeNewPasscode => 'Nuevo código';

  @override
  String get teenModePasscodeHint => 'Introduce entre 4 y 6 dígitos';

  @override
  String get teenModeEnable => 'Activar modo para menores';

  @override
  String get teenModeDisable => 'Desactivar modo para menores';

  @override
  String get teenModeChangePasscode => 'Cambiar código';

  @override
  String get teenModeSource => 'Activado por';

  @override
  String get teenModeDailyUsage => 'Uso de hoy';

  @override
  String get teenModeRemaining => 'Tiempo restante';

  @override
  String get teenModeMinutesUnit => 'Minutos';

  @override
  String get teenModeUnlimited => 'Sin límite';

  @override
  String get teenModeRequestExtension => 'Solicitar más tiempo';

  @override
  String get teenModeExtensionSubmitted =>
      'La solicitud de tiempo se ha enviado a un tutor';

  @override
  String get teenModeTimeLimitReached =>
      'Se ha alcanzado el límite de uso de hoy';

  @override
  String get teenModeCurfewActive => 'Este es un período de uso restringido';

  @override
  String get teenModeReliefHint =>
      'Puedes seguir consultando el historial, contactar con el soporte oficial y comunicar problemas.';

  @override
  String get teenModeRestrictedNotice =>
      'El modo para menores impide enviar mensajes en este momento';

  @override
  String get teenModeActionBlocked =>
      'El modo para menores impide esta acción en este momento';

  @override
  String get teenModeMyRequests => 'Mis solicitudes';

  @override
  String get guardianCenterTitle => 'Centro de tutores';

  @override
  String get guardianRelationships => 'Relaciones de tutela';

  @override
  String get guardianMinors => 'Menores a mi cargo';

  @override
  String get guardianApprovals => 'Aprobaciones pendientes';

  @override
  String get guardianBind => 'Introduce el código de vinculación';

  @override
  String get guardianCreateMinorCode => 'Soy menor: crear código';

  @override
  String get guardianCreateGuardianCode => 'Soy tutor: crear código';

  @override
  String get guardianRelation => 'Relación';

  @override
  String get guardianPrimary => 'Tutor principal';

  @override
  String get guardianCode => 'Código de vinculación de 6 dígitos';

  @override
  String get guardianCodeHint =>
      'Introduce el código proporcionado por la otra persona';

  @override
  String get guardianCodeCreated =>
      'Código creado. Compártelo antes de que caduque.';

  @override
  String get guardianEmpty => 'Sin relaciones de tutela';

  @override
  String get guardianNoMinors => 'Sin menores a cargo';

  @override
  String get guardianUnbind => 'Eliminar relación';

  @override
  String get guardianExtend => 'Añadir tiempo al menor';

  @override
  String get guardianPolicyTitle => 'Reglas de uso';

  @override
  String get guardianPolicyLocked => 'Bloqueado por la plataforma';

  @override
  String get approvalEmpty => 'Sin solicitudes';

  @override
  String get approvalApprove => 'Aceptar';

  @override
  String get approvalReject => 'Rechazar';

  @override
  String get approvalPending => 'Pendiente';

  @override
  String get approvalApproved => 'Aprobada';

  @override
  String get approvalRejected => 'Rechazado';

  @override
  String get approvalExpired => 'Expirado';

  @override
  String get approvalCancelled => 'Cancelada';

  @override
  String get approvalReplayFailed =>
      'La acción original ha fallado. Inténtala de nuevo.';

  @override
  String get requestCancelled => 'Solicitud cancelada';

  @override
  String get kycTitle => 'Verificación de identidad';

  @override
  String get kycNotRequired => 'No se requiere verificación de identidad';

  @override
  String get kycVerified => 'Identidad verificada';

  @override
  String get kycDeclared => 'Información de identidad enviada';

  @override
  String get kycPending => 'En revisión';

  @override
  String get kycRejected => 'Revisión rechazada';

  @override
  String get kycNone => 'No se ha enviado información de identidad';

  @override
  String get kycRealName => 'Nombre completo';

  @override
  String get kycIdNumber => 'Número de documento';

  @override
  String get kycIdType => 'Tipo de documento';

  @override
  String get kycApplicability =>
      'Introduce tus datos reales para el documento seleccionado. Los tipos aceptados aparecen en la lista.';

  @override
  String get kycCamera => 'Hacer foto';

  @override
  String get kycGallery => 'Elegir de la galería';

  @override
  String get kycPhotoLimit => 'Máximo por foto';

  @override
  String get kycSelectPhoto => 'Seleccionar foto';

  @override
  String get kycPhotoSelected => 'Seleccionado';

  @override
  String get kycViewPhoto => 'Pulsa para ver la foto';

  @override
  String get kycReplacePhoto => 'Elegir otra foto';

  @override
  String get kycDisclosure =>
      'Utilizamos tu nombre, número de documento y fotos del documento para revisar tu identidad. Sin estos datos no podrás enviar la solicitud y algunas funciones restringidas podrían no estar disponibles.';

  @override
  String get kycConsent =>
      'Doy mi consentimiento específico para el tratamiento de estos datos de identidad';

  @override
  String get kycConsentRequired =>
      'Da tu consentimiento específico antes de enviar';

  @override
  String get kycResubmitTitle => 'Volver a enviar información de identidad';

  @override
  String get kycResubmitWarning =>
      'El nuevo envío sustituirá tu solicitud pendiente. ¿Continuar?';

  @override
  String get kycSubmitting => 'Enviando';

  @override
  String get kycSubmitFailed => 'No se pudo enviar. Inténtalo de nuevo.';

  @override
  String get kycSubmitUnavailable =>
      'No se puede enviar información de identidad en este momento';

  @override
  String get kycResubmitNotAllowed =>
      'No se puede volver a enviar tras el rechazo. Contacta con soporte si lo necesitas.';

  @override
  String get kycDailyLimit =>
      'Has alcanzado el límite de envíos de hoy. Inténtalo mañana.';

  @override
  String get kycTypeUnavailable =>
      'No hay tipos de documento disponibles. Inténtalo más tarde.';

  @override
  String get kycNameInvalid =>
      'El nombre legal debe tener entre 2 y 64 caracteres';

  @override
  String get kycNumberRequired => 'Introduce el número de documento';

  @override
  String get kycFrontRequired => 'Sube el anverso del documento';

  @override
  String get kycBackRequired => 'Sube el reverso del documento';

  @override
  String get kycPhotoTooLarge =>
      'La foto supera el límite de tamaño. Comprímela e inténtalo de nuevo.';

  @override
  String get kycAccountChanged =>
      'La cuenta o el espacio ha cambiado. Vuelve a abrir esta página.';

  @override
  String get kycPhotoInvalid => 'Elige una imagen válida';

  @override
  String get kycPortraitSide => 'Cara con retrato';

  @override
  String get kycEmblemSide => 'Reverso del DNI';

  @override
  String get kycPassportDataPage => 'Página de datos del pasaporte';

  @override
  String get kycPassportOtherPage =>
      'Página de visados o página adicional del pasaporte';

  @override
  String get kycFront => 'Frente del documento de identidad';

  @override
  String get kycBack => 'Reverso del documento de identidad';

  @override
  String get kycRequired =>
      'Debes verificar tu identidad antes de crear un grupo';

  @override
  String get kycGoVerify => 'Verificar ahora';

  @override
  String get kycStatusUnknown =>
      'El estado de identidad no está disponible. Actualiza más tarde.';

  @override
  String get kycSuperseded =>
      'Un envío posterior ha sustituido a este. Consulta tu estado de identidad más reciente.';

  @override
  String get kycMediaNotFound =>
      'La foto del documento no está disponible en este espacio. Vuelve a seleccionarla antes de enviar.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Envío masivo a clientes';

  @override
  String get officialAccountBadge => 'Oficial';

  @override
  String get officialAccountOpenConversation => 'Abrir conversación';

  @override
  String get officialAccountJoinHint =>
      'Al añadir esta cuenta te unes a la empresa como cliente. No se requiere aprobación de amistad.';

  @override
  String get officialAccountJoinDisabled =>
      'Esta empresa no acepta nuevos clientes. Contacta con soporte.';

  @override
  String get officialAccountRemoved =>
      'Te han eliminado de esta empresa. Pide que te inviten de nuevo.';

  @override
  String get officialAccountBanned =>
      'Tu cuenta está deshabilitada en esta empresa.';

  @override
  String get officialAccountUnavailable =>
      'Esta cuenta oficial no está disponible actualmente.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'El modo actual no permite unirse a una empresa.';

  @override
  String get officialAccountPlatformRequired =>
      'Usa una cuenta de plataforma para añadir esta cuenta oficial.';

  @override
  String get officialAccountOpenFailed =>
      'No se pudo abrir la conversación. Inténtalo de nuevo.';

  @override
  String get officialAccountAccountChanged =>
      'La cuenta o el espacio ha cambiado. Ábrelo de nuevo.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'El directorio empresarial no está actualizado. Inténtalo dentro de un momento.';

  @override
  String get officialAccountInboxSyncFailed =>
      'No se pudo sincronizar la cuenta oficial. El contenido local sigue disponible.';

  @override
  String get officialAccountInboxSyncing =>
      'Sincronizando mensajes de la cuenta oficial';

  @override
  String get diagnosticsTitle => 'Diagnóstico';

  @override
  String get diagnosticsExplanation =>
      'Los registros están desensibilizados y contienen información operativa y de errores de esta cuenta y este espacio, además de eventos públicos de inicio. No incluyen contenido de chats ni credenciales.';

  @override
  String get diagnosticsHour => 'Última hora';

  @override
  String get diagnosticsDay => 'Últimas 24 horas';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Eventos disponibles: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Los registros se guardan en este dispositivo y siguen disponibles después de reiniciar.';

  @override
  String get diagnosticsNotPersistent =>
      'Algunos registros no se han guardado. Actualiza para reintentarlo.';

  @override
  String get diagnosticsExport => 'Exportar y compartir';

  @override
  String get diagnosticsRefresh => 'Actualizar';

  @override
  String get diagnosticsClear => 'Borrar registros de este espacio';

  @override
  String get diagnosticsClearConfirm =>
      '¿Borrar los registros de diagnóstico de este espacio? Se conservará el historial de chat.';

  @override
  String get diagnosticsShared =>
      'La acción de compartir del sistema ha finalizado. Comprueba el archivo en la aplicación receptora.';

  @override
  String get diagnosticsCancelled =>
      'Se canceló el uso compartido. Puedes exportar de nuevo.';

  @override
  String get diagnosticsUnconfirmed =>
      'No se pudo confirmar el uso compartido. Comprueba la aplicación receptora.';

  @override
  String get diagnosticsFailed =>
      'La operación ha fallado. Inténtalo de nuevo.';
}
