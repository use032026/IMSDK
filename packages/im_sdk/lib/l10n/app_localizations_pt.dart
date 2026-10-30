// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get navWorkbench => 'Área de trabalho';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed =>
      'Não foi possível carregar os dados da conta';

  @override
  String get startupFailureTitle => 'Falha ao iniciar';

  @override
  String get startupFailureMessage => 'Verifique a conexão e tente novamente';

  @override
  String get privacyConsentTitle =>
      'Termos de Serviço e Política de Privacidade';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Boas-vindas ao $brand. Para oferecer acesso à conta, mensagens instantâneas, colaboração empresarial, atendimento ao cliente online, notificações e proteção de segurança, precisamos tratar as informações necessárias conforme os Termos de Serviço e a Política de Privacidade.\n\nAntes de você tocar em «Concordar», não lemos a área de transferência, não inicializamos o JPush/JCore nem os SDKs de notificações dos fabricantes e não os usamos para acessar Android ID, OAID, listas de aplicativos instalados, endereços MAC ou informações semelhantes. Se você recusar por enquanto, salvaremos sua escolha; você poderá continuar lendo os documentos e decidir novamente depois.\n\nApós seu consentimento, para entregar notificações de mensagens, atendimento e chamadas recebidas, o JPush/JCore e os serviços de notificações dos fabricantes poderão tratar modelo do dispositivo, versão do Android, pacote e versão do aplicativo, tipo de rede, endereço IP, Android ID, OAID, ID de registro de notificações, token de notificações do fabricante e dados de entrega e clique das notificações. Desativamos recursos não essenciais, como notificações inteligentes, listas de aplicativos instalados, MAC, IMEI, IMSI, listas de Wi-Fi, ativação automática e inicialização vinculada.\n\nA área de transferência só é acessada quando você copia ou cola ativamente. As permissões de câmera, microfone, notificações e outras permissões do sistema só são solicitadas quando você usa o recurso correspondente. Negar uma permissão afeta apenas esse recurso. Leia os documentos completos abaixo e escolha se concorda.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Boas-vindas ao $brand. Para oferecer acesso à conta, mensagens instantâneas, colaboração empresarial, atendimento ao cliente online, notificações e proteção de segurança, precisamos tratar as informações necessárias conforme os Termos de Serviço e a Política de Privacidade.\n\nAntes de você tocar em «Concordar», não lemos a área de transferência, não inicializamos o JPush/JCore, não registramos o aplicativo no serviço Apple Push Notification (APNs) e não obtemos identificadores de notificações, como o ID de registro JPush ou o token de dispositivo APNs. Se você recusar por enquanto, salvaremos sua escolha; você poderá continuar lendo os documentos e decidir novamente depois.\n\nApós seu consentimento, para entregar notificações de mensagens, atendimento e chamadas recebidas, poderemos tratar modelo do iPhone, versão do iOS, pacote e versão do aplicativo, tipo de rede, endereço IP, IDFV, ID de registro JPush, token de dispositivo APNs e dados de entrega e clique das notificações. O JPush/JCore conecta-se ao serviço de notificações; o Apple APNs trata o identificador do aplicativo, o token de dispositivo e o conteúdo das notificações para entregar notificações do sistema. O aplicativo iOS atual não usa serviços de publicidade nem obtém IDFA.\n\nA área de transferência só é acessada quando você copia ou cola ativamente. As permissões de câmera, microfone, notificações e outras permissões do sistema só são solicitadas quando você usa o recurso correspondente. Negar uma permissão afeta apenas esse recurso. Leia os documentos completos abaixo e escolha se concorda.';
  }

  @override
  String get privacyConsentTermsLink => 'Termo de Uso';

  @override
  String get privacyConsentConjunction => 'e';

  @override
  String get privacyConsentPrivacyLink => 'Política de Privacidade';

  @override
  String get privacyConsentDecline => 'Não concordar';

  @override
  String get privacyConsentDeclinedExit =>
      'Você não concordou com os Termos de Serviço e a Política de Privacidade. O aplicativo será fechado.';

  @override
  String get privacyConsentAccept => 'Aceitar';

  @override
  String get privacyConsentRuntimeFailure =>
      'Falha ao iniciar. Verifique a conexão e tente novamente.';

  @override
  String get privacyConsentSaveFailure =>
      'Não foi possível salvar sua escolha. Tente novamente.';

  @override
  String get appUpdateRequiredTitle => 'Atualização necessária para continuar';

  @override
  String get appUpdateOptionalTitle => 'Nova versão disponível';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version está disponível';
  }

  @override
  String get appUpdateLater => 'Depois';

  @override
  String get appUpdateNow => 'Atualizar agora';

  @override
  String get appUpdateProcessing => 'Processando…';

  @override
  String get appUpdateInvalidUrl =>
      'O endereço de atualização é inválido. Tente mais tarde.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Não foi possível abrir o link de atualização. Tente mais tarde.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Download interrompido. Verifique a conexão e tente novamente.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Falha na verificação do pacote. Baixe novamente.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Permita que o $brand instale atualizações nas configurações do sistema.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Não foi possível abrir o instalador do sistema. Verifique as permissões de instalação.';

  @override
  String get appUpdateGenericFailure =>
      'Falha na atualização. Verifique a conexão e tente novamente.';

  @override
  String get appUpdateUnavailable =>
      'A nova versão ainda não está disponível para download. Tente mais tarde.';

  @override
  String get appUpdateCheckFailed =>
      'Não foi possível verificar atualizações. Tente mais tarde.';

  @override
  String get appUpdateChecking => 'Verificando';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonSearch => 'Buscar';

  @override
  String get commonLoading => 'Carregando…';

  @override
  String get commonLoadFailed => 'Falha ao carregar';

  @override
  String get commonRetry => 'Tentar novamente';

  @override
  String get commonEmpty => 'Sem dados';

  @override
  String get commonCopy => 'Copiar';

  @override
  String get commonForward => 'Encaminhar';

  @override
  String get commonFavorite => 'Favoritar';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonSend => 'Enviar';

  @override
  String get commonDone => 'Concluído';

  @override
  String get commonMore => 'Mais';

  @override
  String get commonSettings => 'Configurações';

  @override
  String get commonCopied => 'Copiado';

  @override
  String get commonUnknown => 'Desconhecidos';

  @override
  String get commonNotSet => 'Não configurado';

  @override
  String get commonUnbound => 'Não vinculado';

  @override
  String get commonViewAll => 'Ver tudo';

  @override
  String get commonSubmit => 'Enviar';

  @override
  String get commonAdd => 'Adicionar';

  @override
  String get commonRemove => 'Remover';

  @override
  String get commonCreate => 'Criar';

  @override
  String get commonUpdate => 'Atualizar';

  @override
  String get commonUpload => 'Enviar arquivo';

  @override
  String get commonShare => 'Compartilhar';

  @override
  String get commonBlock => 'Bloquear';

  @override
  String get commonUnblock => 'Desbloquear';

  @override
  String get commonMute => 'Silenciar';

  @override
  String get commonUnmute => 'Ativar som';

  @override
  String get commonPin => 'Fixar';

  @override
  String get commonUnpin => 'Desafixar';

  @override
  String get commonMarkRead => 'Marcar como lida';

  @override
  String get commonMarkUnread => 'Marcar como não lida';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Falha na operação. Tente novamente.';

  @override
  String get commonNetworkError => 'Erro de rede. Verifique a conexão.';

  @override
  String get navMessages => 'Mensagem';

  @override
  String get navContacts => 'Contatos';

  @override
  String get navMe => 'Eu';

  @override
  String get authLoginTitle => 'Entrar no StartLink';

  @override
  String get authTabMobile => 'Telefone';

  @override
  String get authTabEmail => 'E-mail';

  @override
  String get authTabLoginName => 'ID StartLink';

  @override
  String get authHintMobile => 'Digite o número de telefone';

  @override
  String get authHintEmail => 'Por favor, insira o e-mail';

  @override
  String get authHintPassword => 'Digite a senha';

  @override
  String get authHintCode => 'Digite o código de verificação';

  @override
  String get authHintLoginName => 'Digite o ID StartLink (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Login';

  @override
  String get authGetCode => 'Obter código de verificação';

  @override
  String authResendCode(int seconds) {
    return 'Reenviar em $seconds s';
  }

  @override
  String get authUsePassword => 'Usar senha';

  @override
  String get authUseCode => 'Usar código de verificação';

  @override
  String get authAgreementPrefix => 'Li e concordo com os ';

  @override
  String get authAgreementAnd => 'e';

  @override
  String get authTermsLink => 'Termo de Uso';

  @override
  String get authPrivacyLink => 'Política de Privacidade';

  @override
  String get authCaptchaTitle => 'Verificação de segurança';

  @override
  String get authCaptchaHint => 'Digite a resposta';

  @override
  String get authCaptchaFailed =>
      'Não foi possível obter o captcha. Tente novamente.';

  @override
  String get authErrorEmptyCode => 'Digite o código de verificação';

  @override
  String get authErrorEmptyPassword => 'Digite a senha';

  @override
  String get authErrorEmptyLoginName => 'Digite o ID StartLink';

  @override
  String get authErrorWrongCredentials => 'Conta ou senha incorreta';

  @override
  String get authDeactivatingTitle => 'Exclusão da conta';

  @override
  String get authDeactivatingContent =>
      'Sua conta está no período de arrependimento da exclusão (7 dias).\n\nPara cancelar a exclusão, toque em «Cancelar exclusão»; caso contrário, toque em «Continuar» para acessar o aplicativo.';

  @override
  String get authContinueUse => 'Continuar';

  @override
  String get authCancelDeactivation => 'Cancelar exclusão';

  @override
  String get authDeactivationCancelled =>
      'Exclusão cancelada, conta restaurada';

  @override
  String get authDeactivationCancelFailed =>
      'Falha ao cancelar. Tente novamente.';

  @override
  String get authLogout => 'Sair';

  @override
  String get authLogoutConfirm => 'Tem certeza de que deseja sair?';

  @override
  String get authSendingCode => 'Enviando…';

  @override
  String get authCodeSent => 'Código de verificação enviado com sucesso';

  @override
  String get authLoginFailed => 'Falha ao entrar. Tente novamente.';

  @override
  String get authRegisterFailed => 'Falha no cadastro. Tente novamente.';

  @override
  String get authEnterpriseCode => 'Código da empresa';

  @override
  String get authEnterpriseCodeHint => 'Digite o código da empresa';

  @override
  String get authPendingApproval =>
      'Cadastro concluído. Sua solicitação de entrada na empresa foi enviada e aguarda aprovação.';

  @override
  String get authNoAccount => 'Não tem conta?';

  @override
  String get authRegisterNow => 'Cadastrar agora';

  @override
  String get authCountryPickerTitle => 'Selecione o país ou região';

  @override
  String get authCountrySearchHint => 'Buscar país ou região';

  @override
  String get authCountryChinaMainland => 'China continental';

  @override
  String get authCountryHongKong => 'Hong Kong, China';

  @override
  String get authCountryMacau => 'Macau, China';

  @override
  String get authCountryTaiwan => 'Taiwan, China';

  @override
  String get authCountryUnitedStates => 'Estados Unidos';

  @override
  String get authCountryUnitedKingdom => 'Reino Unido';

  @override
  String get authCountryJapan => 'Japão';

  @override
  String get authCountrySouthKorea => 'Coreia do Sul';

  @override
  String get authCountrySingapore => 'Singapura';

  @override
  String get authCountryMalaysia => 'Malásia';

  @override
  String get authCountryAustralia => 'Austrália';

  @override
  String get authCountryCanada => 'Canadá';

  @override
  String get authCountryGermany => 'Alemanha';

  @override
  String get authCountryFrance => 'França';

  @override
  String get authCountryIndia => 'Índia';

  @override
  String get authCountryThailand => 'Tailândia';

  @override
  String get authCountryVietnam => 'Vietnã';

  @override
  String get authCountryIndonesia => 'Indonésia';

  @override
  String get authCountryPhilippines => 'Filipinas';

  @override
  String get authQuickLoginTitle => 'Acesso rápido';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Entrando. Aguarde.';

  @override
  String get authRoleOwner => 'Proprietário';

  @override
  String get authRoleAdministrator => 'Administrador';

  @override
  String get authRoleCustomerService => 'Atendimento ao cliente';

  @override
  String get authRoleTechnicalSupport => 'Suporte técnico';

  @override
  String get authRoleEmployee => 'Funcionário';

  @override
  String get authRoleMember => 'Membro';

  @override
  String get authRoleEnterpriseCustomer => 'Cliente da empresa';

  @override
  String get authUnavailablePrefix => 'Indisponível · ';

  @override
  String get authUnassignedService => 'Nenhum atendente atribuído';

  @override
  String authAssignedService(String staff) {
    return 'Atribuído a $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Cliente · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Funcionário · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count usuários';
  }

  @override
  String get authMetaPhone => 'Telefone';

  @override
  String get authMetaIdentity => 'Identidade';

  @override
  String get authRegisterTitle => 'Cadastrar';

  @override
  String get authNickname => 'Apelido';

  @override
  String get authNicknameHint => 'Defina um apelido';

  @override
  String get authPassword => 'Senha';

  @override
  String get authPasswordSetHint =>
      'Defina uma senha (pelo menos 6 caracteres)';

  @override
  String get authConfirmPassword => 'Confirmar senha';

  @override
  String get authConfirmPasswordHint => 'Digite a senha novamente';

  @override
  String get authVerificationCode => 'Código de verificação';

  @override
  String get authRegisterAndLogin => 'Cadastrar e entrar';

  @override
  String get authHaveAccount => 'Já tem uma conta?';

  @override
  String get authGoLogin => 'Fazer login';

  @override
  String get authEmailVerificationUnavailable =>
      'A verificação por e-mail está indisponível. Cadastre-se com um número de celular.';

  @override
  String get authSmsVerificationUnavailable =>
      'A verificação por SMS está indisponível. Cadastre-se com um e-mail.';

  @override
  String get authSendFailed => 'Não foi possível enviar. Tente novamente.';

  @override
  String get authErrorEmptyNickname => 'Digite um apelido';

  @override
  String get authErrorInvalidMobile => 'Digite um número de celular válido';

  @override
  String get authErrorInvalidEmail => 'Formato de e-mail inválido.';

  @override
  String get authErrorPasswordTooShort =>
      'A senha deve ter pelo menos 6 caracteres';

  @override
  String get authErrorPasswordMismatch => 'As senhas não coincidem';

  @override
  String get authErrorVerificationRequired =>
      'Solicite e digite primeiro o código de verificação';

  @override
  String get authRegisterErrorTitle => 'Falha no cadastro';

  @override
  String get authGotIt => 'Entendi';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Empresa «$code» não encontrada. Verifique o código da empresa.';
  }

  @override
  String get authTenantSearchFailed => 'Falha na busca. Tente novamente.';

  @override
  String get authInvitationInvalid =>
      'O código de convite é inválido. Verifique e tente novamente.';

  @override
  String get authCollapseJoin => 'Ocultar informações de entrada';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Convite válido: $name';
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
  String get authSelectOrganization => 'Selecione a organização';

  @override
  String get authNoOrganization => 'Nenhuma organização disponível';

  @override
  String get authNoOrganizationHint =>
      'Peça a um administrador que convide você para uma organização';

  @override
  String get authPersonalSpace => 'Espaço pessoal';

  @override
  String get authPersonalSpaceSubtitle =>
      'Conversas com amigos e favoritos pessoais';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Não foi possível verificar a identidade do espaço. Tente novamente.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Não foi possível restaurar o espaço pessoal. Tente novamente.';

  @override
  String get authJoinEnterpriseFailed =>
      'Não foi possível entrar na empresa. Tente mais tarde.';

  @override
  String get homeTitle => 'Mensagem';

  @override
  String get homeGatewayConnectingTitle => 'Conectando';

  @override
  String get homePersonalSpace => 'Pessoal';

  @override
  String get homeOfficialService => 'Serviço oficial';

  @override
  String get homeSwitchSpace => 'Trocar espaço';

  @override
  String get homeSpaceSubtitle => 'Pessoal · Empresa';

  @override
  String get homeJoinEnterprise => 'Entrar em empresa';

  @override
  String get homeCreateGroup => 'Novo grupo';

  @override
  String get homeAddFriend => 'Adicionar contato';

  @override
  String get homeScan => 'Escanear';

  @override
  String get homeJoinNewSpace => 'Entrar em novo espaço';

  @override
  String get homeSearchConversation => 'Buscar';

  @override
  String get homeNoMessages => 'Sem mensagens';

  @override
  String get homeDeleteConversation => 'Excluir conversa';

  @override
  String get homeDeleteConversationConfirm =>
      'Excluir esta conversa? O histórico será apagado.';

  @override
  String get homePersonalNote => 'Eu (notas pessoais)';

  @override
  String get homeWorkNote => 'Eu (notas de trabalho)';

  @override
  String homeConversationCount(int count) {
    return '$count conversas';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count não lidas';
  }

  @override
  String get chatInputHint => 'Digite uma mensagem…';

  @override
  String get chatVoiceHint => 'Segure para falar';

  @override
  String get chatVoiceRelease => 'Solte para enviar';

  @override
  String get chatVoiceCancel => 'Deslize para cima para cancelar';

  @override
  String get chatMenuCopy => 'Copiar';

  @override
  String get chatMenuForward => 'Encaminhar';

  @override
  String get chatMenuRecall => 'Retirar';

  @override
  String get chatMenuDelete => 'Excluir';

  @override
  String get chatMenuFavorite => 'Favoritar';

  @override
  String get chatMenuReply => 'Responder';

  @override
  String get chatMenuMultiSelect => 'Selecionar';

  @override
  String get chatMenuTranslate => 'Traduzir';

  @override
  String get chatMenuVoiceToText => 'Converter em texto';

  @override
  String get chatMenuTextToSpeech => 'Ler em voz alta';

  @override
  String get chatStatusRecalled => 'Mensagem retirada';

  @override
  String get chatRecallSuccess => 'Retirada';

  @override
  String get chatRecallFailed => 'Falha ao retirar';

  @override
  String get chatRecallTimeout =>
      'Mensagens com mais de 2 minutos não podem ser retiradas';

  @override
  String get chatTranslateFailed => 'Falha na tradução. Tente novamente.';

  @override
  String get chatTranslateNotConfigured => 'Serviço de tradução indisponível';

  @override
  String get chatVoiceToTextFailed => 'Falha na conversão. Tente novamente.';

  @override
  String get chatTextToSpeechFailed =>
      'Falha na leitura em voz alta. Tente novamente.';

  @override
  String get chatVoiceToText => 'Converter';

  @override
  String get chatForwardSuccess => 'Encaminhado';

  @override
  String get chatForwardFailed => 'Falha ao encaminhar. Tente novamente.';

  @override
  String get chatNoConversations => 'Nenhuma conversa para encaminhar';

  @override
  String get chatSendFailed => 'Falha ao enviar';

  @override
  String get chatResend => 'Reenviar';

  @override
  String get chatNotFriend => 'Não está na lista de contatos';

  @override
  String get chatNotFriendHint =>
      'Vocês ainda não são contatos. Não é possível enviar mensagens.';

  @override
  String get chatMutedHint => 'Todos os membros estão silenciados';

  @override
  String get chatFileUploadFailed =>
      'Falha ao enviar o arquivo. Tente novamente.';

  @override
  String get chatFileStatusNotDownloaded => 'Não baixado';

  @override
  String get chatFileStatusDownloaded => 'Baixado';

  @override
  String get chatFileStatusUploading => 'Enviando arquivo';

  @override
  String get chatFileStatusUploadFailed => 'Falha no upload';

  @override
  String get chatCardSendFailed => 'Falha ao enviar o cartão de contato';

  @override
  String get chatFavoriteSuccess => 'Favoritado';

  @override
  String get chatFavoriteFailed => 'Falha ao adicionar aos favoritos';

  @override
  String get chatLoadFailed => 'Falha ao carregar';

  @override
  String get chatImageMessage => '[Imagem]';

  @override
  String get chatVoiceMessage => '[Áudio]';

  @override
  String get chatVideoMessage => '[Vídeo]';

  @override
  String get chatFileMessage => '[Arquivo]';

  @override
  String get chatLocationMessage => '[Localização]';

  @override
  String get chatContactCardMessage => '[Contato]';

  @override
  String get chatCallLogMessage => '[Chamada]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Lida por $count';
  }

  @override
  String get chatUnread => 'Não lida';

  @override
  String get chatRecalledSelf => 'Você retirou uma mensagem';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender retirou uma mensagem';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Tradução: $translation';
  }

  @override
  String get chatMessageDeleted => 'Mensagem excluída';

  @override
  String get chatPeer => 'Outra pessoa';

  @override
  String get chatSelf => 'Eu';

  @override
  String get chatGenericMessage => '[Mensagem]';

  @override
  String get chatVoiceHideText => 'Ocultar texto';

  @override
  String get chatVoiceShowText => 'Converter em texto';

  @override
  String get chatFileDefaultName => 'Arquivo';

  @override
  String get chatContactDefaultName => 'Contato';

  @override
  String get chatContactCardTitle => 'Cartão de contato';

  @override
  String get chatCallMissed => 'Perdida';

  @override
  String get chatCallCancelled => 'Cancelada';

  @override
  String get chatCallRejected => 'Recusada';

  @override
  String get chatCallDisconnected => 'Desconectada';

  @override
  String get chatCallEnded => 'Chamada encerrada';

  @override
  String get chatCallFailed => 'Falha na chamada';

  @override
  String chatCallDuration(String duration) {
    return 'Duração $duration';
  }

  @override
  String get chatVideoCallTitle => 'Chamada de vídeo';

  @override
  String get chatVoiceCallTitle => 'Chamada de voz';

  @override
  String get chatToolPhotos => 'Fotos';

  @override
  String get chatToolCamera => 'Câmera';

  @override
  String get chatToolFile => 'Arquivo';

  @override
  String get chatToolLocation => 'Localização';

  @override
  String get chatToolContactCard => 'Contato';

  @override
  String get chatToolVoiceCall => 'Chamada de voz';

  @override
  String get chatToolVideoCall => 'Chamada de vídeo';

  @override
  String get chatToolFavorites => 'Favoritos';

  @override
  String get chatToolTranslate => 'Traduzir';

  @override
  String get chatTranslationChooseLanguage => 'Escolha o idioma de tradução';

  @override
  String get chatTranslationEnterText => 'Digite o texto primeiro';

  @override
  String get chatTranslationMentionsUnsupported =>
      'A tradução está indisponível para mensagens com menções';

  @override
  String get chatTranslationScheduledUnsupported =>
      'A tradução está indisponível ao editar uma mensagem agendada';

  @override
  String get chatTranslationFailed => 'Falha na tradução. Tente novamente.';

  @override
  String get chatTranslationEmpty =>
      'Nenhuma tradução recebida. Tente novamente.';

  @override
  String get chatTranslationTranslating => 'Traduzindo…';

  @override
  String get chatTranslationSend => 'Enviar tradução';

  @override
  String get chatTranslationSending => 'Enviando…';

  @override
  String get chatTranslationExpand => 'Mostrar mais';

  @override
  String get chatTranslationCollapse => 'Mostrar menos';

  @override
  String get chatFileTooLarge => 'O arquivo excede o limite de 100 MB';

  @override
  String get chatInputMutedAdminOnly =>
      'Só o proprietário ou membros selecionados podem falar.';

  @override
  String get chatImageUploadUnsupported =>
      'Falha ao enviar a imagem. O suporte do servidor ainda não está disponível.';

  @override
  String get chatFavoriteLongPressHint =>
      'Segure uma mensagem para adicioná-la aos favoritos';

  @override
  String chatSelectedCount(int count) {
    return '$count selecionados';
  }

  @override
  String get chatLocationSheetTitle => 'Enviar localização';

  @override
  String get chatLocationNameLabel => 'Nome do lugar';

  @override
  String get chatLocationNameHint => 'Ex.: escritório, endereço do cliente';

  @override
  String get chatLocationAddressLabel => 'Endereço';

  @override
  String get chatLocationOptionalHint => 'Opcional';

  @override
  String get chatLocationLatitudeLabel => 'Latitude';

  @override
  String get chatLocationLatitudeHint => 'De -90 a 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitude';

  @override
  String get chatLocationLongitudeHint => 'De -180 a 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Digite $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label está fora do intervalo';
  }

  @override
  String get chatLocationDefaultTitle => 'Localização';

  @override
  String get chatMutedFullNotice =>
      'Este grupo está silenciado. Só o proprietário ou membros selecionados podem falar.';

  @override
  String get chatNotFriendSendBlocked =>
      'Vocês não são mais amigos e não é possível enviar mensagens';

  @override
  String get chatPersonalNotesTitle => 'Notas pessoais';

  @override
  String get chatWorkNotesTitle => 'Notas de trabalho';

  @override
  String get chatPersonalNotesDescription =>
      'Registre pensamentos pessoais e informações importantes aqui\nSincronizados entre dispositivos, disponíveis a qualquer hora';

  @override
  String get chatWorkNotesDescription =>
      'Registre tarefas e salve materiais de trabalho aqui\nOs espaços de equipe ficam separados e seguros';

  @override
  String get chatNoMessages => 'Sem mensagens';

  @override
  String chatReplyTo(String sender) {
    return 'Responder a $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature estará disponível em breve';
  }

  @override
  String get chatForwardSelectTitle => 'Escolha a conversa';

  @override
  String get chatContactSelectTitle => 'Escolha o contato';

  @override
  String get chatNoContacts => 'Nenhum contato';

  @override
  String get contactsTitle => 'Contatos';

  @override
  String get contactsSearch => 'Buscar contatos';

  @override
  String get contactsNewFriends => 'Novos amigos';

  @override
  String get contactsGroups => 'Grupos';

  @override
  String get contactsFavorites => 'Favoritos';

  @override
  String get contactsRecent => 'Recentes';

  @override
  String get contactsOrganization => 'Organização';

  @override
  String get contactsAnnouncement => 'Anúncios';

  @override
  String get contactsNewApplications => 'Novas solicitações';

  @override
  String get contactsCustomerGroups => 'Grupos de clientes';

  @override
  String get contactsAllCustomers => 'Todos os clientes';

  @override
  String get contactsMyCustomers => 'Meus clientes';

  @override
  String get contactsViewAll => 'Ver tudo';

  @override
  String get contactsMyContacts => 'Meus contatos';

  @override
  String get contactsMyAdvisor => 'Meu consultor';

  @override
  String get contactsNoAdvisor => 'Nenhum consultor atribuído ainda';

  @override
  String get contactsAdvisorLoading => 'Carregando…';

  @override
  String get contactsNavigateFailed => 'Falha na navegação. Tente novamente.';

  @override
  String get contactsEmpty => 'Nenhum contato';

  @override
  String get contactsNoAnnouncement => 'Nenhum anúncio';

  @override
  String get contactsOfficialBadge => 'Oficial';

  @override
  String get contactsCustomerBadge => 'Cliente';

  @override
  String get contactsEmptyCustomers => 'Nenhum cliente';

  @override
  String get myTitle => 'Eu';

  @override
  String get myEnterpriseInfo => 'Informações da empresa';

  @override
  String get myEnterpriseManage => 'Gestão da empresa';

  @override
  String get myQrCode => 'Código QR';

  @override
  String get myFavorites => 'Favoritos';

  @override
  String get myLanguage => 'Idioma do Sistema';

  @override
  String get myTimezone => 'Fuso horário';

  @override
  String get myAutoTranslate => 'Tradução automática';

  @override
  String get myNetworkSwitch => 'Alterar linha';

  @override
  String get mySettings => 'Configurações';

  @override
  String get myLogout => 'Sair';

  @override
  String get myLogoutConfirm => 'Tem certeza de que deseja sair?';

  @override
  String get myLeaveEnterprise => 'Sair da empresa';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Tem certeza de que deseja sair desta empresa? Você perderá o acesso aos dados da empresa.';

  @override
  String get myLeaveEnterpriseSuccess => 'Você saiu da empresa';

  @override
  String get myLeaveEnterpriseFailed => 'Falha ao sair. Tente novamente.';

  @override
  String get myLppIdCopied => 'ID StartLink copiado';

  @override
  String myLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count contatos';
  }

  @override
  String get myAutoSelect => 'Automático';

  @override
  String get myPresenceStatus => 'Status de presença';

  @override
  String get myPresenceStatusTitle => 'Definir presença';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Ocupado';

  @override
  String get myPresenceAway => 'Ausente';

  @override
  String get myPresenceInvisible => 'Invisível';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileName => 'Nome';

  @override
  String get profileGender => 'Sexo';

  @override
  String get profileBirthday => 'Aniversário';

  @override
  String get profileRegion => 'Região';

  @override
  String get profileSignature => 'Biografia';

  @override
  String get profileSignatureHint => 'Conte um pouco sobre você';

  @override
  String get profileTapTapText => 'Toque';

  @override
  String get profileTapTapHint =>
      'Texto exibido ao receber um toque (máx. 20 caracteres)';

  @override
  String get profileAccountSection => 'Conta';

  @override
  String get profileBasicSection => 'Informações básicas';

  @override
  String get profileLppId => 'ID StartLink';

  @override
  String get profileLppIdNotSet => 'Não configurado';

  @override
  String get profileMobile => 'Telefone';

  @override
  String get profileMobileUnbound => 'Não vinculado';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileEmailUnbound => 'Não vinculado';

  @override
  String get profileQrCode => 'Meu código QR';

  @override
  String get profileChangePassword => 'Editar senha';

  @override
  String get profileGenderMale => 'Masculino';

  @override
  String get profileGenderFemale => 'Feminino';

  @override
  String get profileGenderOther => 'Outros';

  @override
  String get profileGenderUnset => 'Não configurado';

  @override
  String get profileSaveFailed => 'Falha ao salvar. Tente novamente.';

  @override
  String get profileLppIdTitle => 'ID StartLink';

  @override
  String get profileLppIdSetOnce =>
      'O ID StartLink só pode ser alterado uma vez. Escolha com cuidado.';

  @override
  String get profileLppIdChangeFailed =>
      'Falha na alteração (o ID StartLink só pode ser alterado uma vez)';

  @override
  String get profileChangePasswordOld => 'Senha atual';

  @override
  String get profileChangePasswordNew => 'Nova Senha';

  @override
  String get profileChangePasswordConfirm => 'Confirmar nova senha';

  @override
  String get profileChangePasswordMismatch => 'As senhas não coincidem';

  @override
  String get profileChangePasswordSuccess => 'Senha alterada. Entre novamente.';

  @override
  String get profileChangePasswordFailed =>
      'Falha ao alterar a senha. Tente novamente.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionEnterprise => 'Empresa';

  @override
  String get settingsSectionAccount => 'Conta';

  @override
  String get settingsSectionGeneral => 'Geral';

  @override
  String get settingsSectionFeatures => 'Recursos';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsEnterpriseInfo => 'Informações da empresa';

  @override
  String get settingsProfile => 'Perfil';

  @override
  String get settingsAccountSecurity => 'Segurança da conta';

  @override
  String get settingsNotification => 'Notificações';

  @override
  String get settingsDisplay => 'Exibição';

  @override
  String get settingsFriendPrivacy => 'Privacidade';

  @override
  String get settingsChat => 'Conversa';

  @override
  String get settingsChatHistory => 'Histórico de conversas';

  @override
  String get settingsAbout => 'Sobre o StartLink';

  @override
  String get settingsLanguage => 'Idioma do Sistema';

  @override
  String get settingsTimezone => 'Fuso horário';

  @override
  String get settingsAutoTranslate => 'Tradução automática';

  @override
  String get settingsNetworkSwitch => 'Alterar linha';

  @override
  String get enterpriseInfoTitle => 'Informações da empresa';

  @override
  String get enterpriseName => 'Nome';

  @override
  String get enterpriseDescription => 'Descrição';

  @override
  String get enterpriseUpdateSuccess => 'Upload bem-sucedido';

  @override
  String get enterpriseUpdateFailed => 'Falha na atualização. Tente novamente.';

  @override
  String get enterpriseLeave => 'Sair da empresa';

  @override
  String get enterpriseLeaveConfirm =>
      'Tem certeza de que deseja sair desta empresa?';

  @override
  String get enterpriseLeaveSuccess => 'Você saiu da empresa';

  @override
  String get enterpriseLeaveFailed => 'Falha ao sair. Tente novamente.';

  @override
  String get enterpriseLeaveOwnerError =>
      'O proprietário não pode sair diretamente. Transfira a propriedade primeiro.';

  @override
  String get enterpriseMemberCount => 'Membros';

  @override
  String get enterpriseCreatedAt => 'Criação';

  @override
  String get enterpriseCode => 'Código da empresa';

  @override
  String get enterpriseInviteMembers => 'Convidar membros';

  @override
  String get enterpriseCopyInviteCode => 'Copiar código de convite';

  @override
  String get enterpriseInviteCodeCopied => 'Código de convite copiado';

  @override
  String get groupCreateTitle => 'Novo grupo';

  @override
  String get groupNameHint => 'Digite o nome do grupo';

  @override
  String get groupCreateSuccess => 'Grupo criado';

  @override
  String get groupCreateFailed => 'Falha ao criar o grupo';

  @override
  String get groupSettings => 'Configurações do grupo';

  @override
  String get groupName => 'Nome do grupo';

  @override
  String get groupAvatar => 'Imagem do grupo';

  @override
  String get groupAnnouncement => 'Anúncio';

  @override
  String get groupMembers => 'Membros';

  @override
  String get groupAddMember => 'Adicionar membros';

  @override
  String get groupRemoveMember => 'Remover membro';

  @override
  String get groupRemoveMemberConfirm => 'Remover este membro?';

  @override
  String get groupSetAdmin => 'Definir como administrador';

  @override
  String get groupRemoveAdmin => 'Remover administrador';

  @override
  String get groupTransferOwner => 'Transferir propriedade';

  @override
  String get groupTransferOwnerConfirm =>
      'Transferir a propriedade do grupo para este membro?';

  @override
  String get groupTransferOwnerSuccess => 'Propriedade transferida';

  @override
  String get groupTransferOwnerFailed =>
      'Falha na transferência. Tente novamente.';

  @override
  String get groupLeave => 'Sair do grupo';

  @override
  String get groupLeaveConfirm => 'Sair deste grupo?';

  @override
  String get groupLeaveSuccess => 'Você saiu do grupo';

  @override
  String get groupLeaveFailed => 'Falha ao sair. Tente novamente.';

  @override
  String get groupDissolve => 'Dissolver grupo';

  @override
  String get groupDissolveConfirm =>
      'Dissolver este grupo? Todos os membros serão removidos.';

  @override
  String get groupDissolveSuccess => 'Grupo dissolvido';

  @override
  String get groupDissolveFailed => 'Falha ao dissolver. Tente novamente.';

  @override
  String get groupQrCode => 'Código QR do grupo';

  @override
  String get groupMuteAll => 'Silenciar todos';

  @override
  String get groupMuteAllOn => 'Ativar silêncio para todos';

  @override
  String get groupMuteAllOff => 'Desativar silêncio para todos';

  @override
  String get groupAllowMemberInvite => 'Permitir convites por membros';

  @override
  String get groupAllowMemberModifyTitle =>
      'Permitir que membros alterem o nome do grupo';

  @override
  String get groupAllowMemberAtAll => 'Permitir que membros mencionem @Todos';

  @override
  String get groupAllowMemberViewMemberList =>
      'Permitir que membros vejam a lista de membros';

  @override
  String get groupAllowQrCodeJoin => 'Permitir entrada por código QR';

  @override
  String get groupRequireApproval => 'Exigir aprovação para entrar';

  @override
  String get groupAllowMemberAddFriend =>
      'Permitir que membros se adicionem como amigos';

  @override
  String get groupRoleOwner => 'Proprietário';

  @override
  String get groupRoleAdmin => 'Administrador';

  @override
  String get groupRoleMember => 'Membro';

  @override
  String get groupNoMembers => 'Nenhum membro';

  @override
  String get groupNoAnnouncements => 'Nenhum anúncio';

  @override
  String get groupCreateAnnouncement => 'Publicar anúncio';

  @override
  String get groupEditAnnouncement => 'Editar anúncio';

  @override
  String get groupDeleteAnnouncement => 'Excluir anúncio';

  @override
  String get groupDeleteAnnouncementConfirm => 'Excluir este anúncio?';

  @override
  String get groupAnnouncementTitle => 'Título';

  @override
  String get groupAnnouncementContent => 'Conteúdo';

  @override
  String get groupAnnouncementPin => 'Fixar anúncio';

  @override
  String groupMemberCount(int count) {
    return '$count membros';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count selecionados';
  }

  @override
  String get groupJoinRequestApprove => 'Aceitar';

  @override
  String get groupJoinRequestReject => 'Recusar';

  @override
  String get groupJoinRequests => 'Solicitações de entrada';

  @override
  String get groupNoJoinRequests => 'Nenhuma solicitação de entrada';

  @override
  String get groupReadReceipts => 'Confirmações de leitura';

  @override
  String groupReadCount(int count) {
    return '$count lidas';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count não lidas';
  }

  @override
  String get friendAddTitle => 'Adicionar contato';

  @override
  String get friendSearchHint => 'Telefone / E-mail / ID StartLink';

  @override
  String get friendRequestSent => 'Solicitação de amizade enviada';

  @override
  String get friendRequestFailed => 'Falha ao enviar. Tente novamente.';

  @override
  String get friendAlreadyFriend => 'Vocês já são contatos';

  @override
  String get friendNewFriendsTitle => 'Novos amigos';

  @override
  String get friendNoRequests => 'Nenhuma solicitação de amizade';

  @override
  String get friendAccept => 'Aceitar';

  @override
  String get friendReject => 'Recusar';

  @override
  String get friendAccepted => 'Aceita';

  @override
  String get friendRejected => 'Recusado';

  @override
  String get friendDeleteConfirm => 'Remover este contato?';

  @override
  String get friendDeleteSuccess => 'Contato removido';

  @override
  String get friendDeleteFailed => 'Falha ao remover. Tente novamente.';

  @override
  String get friendRemarkName => 'Apelido';

  @override
  String get friendGroupName => 'Grupo';

  @override
  String get friendSendMessage => 'Mensagem';

  @override
  String get friendMatchTypeLppId => 'Encontrado pelo ID StartLink';

  @override
  String get friendMatchTypeMobile => 'Encontrado pelo telefone';

  @override
  String get friendMatchTypeEmail => 'Encontrado pelo e-mail';

  @override
  String get friendSearchEmpty => 'Nenhum usuário encontrado';

  @override
  String get friendAddMessage => 'Gostaria de adicionar você aos meus contatos';

  @override
  String get friendBlockConfirm => 'Bloquear este usuário?';

  @override
  String get friendUnblockConfirm => 'Desbloquear este usuário?';

  @override
  String get friendBlockSuccess => 'Bloqueado';

  @override
  String get friendUnblockSuccess => 'Desbloqueado';

  @override
  String get profilePageTitle => 'Detalhes do Perfil';

  @override
  String get profilePageSendMessage => 'Mensagem';

  @override
  String get profilePageAddFriend => 'Adicionar amigo';

  @override
  String get profilePageAlreadyFriend => 'Vocês já são amigos';

  @override
  String get profilePageBlocked => 'Bloqueado';

  @override
  String get profilePageBlock => 'Bloquear';

  @override
  String get profilePageUnblock => 'Desbloquear';

  @override
  String get profilePageHidden => 'Este usuário ocultou o perfil';

  @override
  String get profilePageFriendsOnly =>
      'Este usuário mostra o perfil apenas para amigos';

  @override
  String get profilePageLppId => 'ID StartLink';

  @override
  String get profilePageRemarkName => 'Observação';

  @override
  String get profilePageEditRemark => 'Editar apelido';

  @override
  String get profilePageSaveRemarkSuccess => 'Apelido salvo';

  @override
  String get profilePageSaveRemarkFailed => 'Falha ao salvar. Tente novamente.';

  @override
  String get searchTitle => 'Buscar';

  @override
  String get searchHint => 'Buscar por telefone, e-mail ou ID StartLink';

  @override
  String get searchNoResults => 'Nenhum resultado encontrado';

  @override
  String get searchMessages => 'Mensagem';

  @override
  String get searchUsers => 'Usuários';

  @override
  String get searchFailed => 'Falha na busca. Tente novamente.';

  @override
  String get scanTitle => 'Escanear';

  @override
  String get scanFailed => 'Falha no reconhecimento. Tente novamente.';

  @override
  String get scanInvalidQrCode => 'Código QR inválido';

  @override
  String get scanFlashOn => 'Ligar lanterna';

  @override
  String get scanFlashOff => 'Desligar lanterna';

  @override
  String get scanAlbum => 'Escolher do álbum';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesEmpty => 'Sem favoritos';

  @override
  String get favoritesAll => 'Todos';

  @override
  String get favoritesText => 'Texto';

  @override
  String get favoritesImage => 'Imagens';

  @override
  String get favoritesVideo => 'Vídeo';

  @override
  String get favoritesVoice => 'Áudios';

  @override
  String get favoritesFile => 'Arquivos';

  @override
  String get favoritesOther => 'Outros';

  @override
  String get favoritesDeleteConfirm => 'Remover dos favoritos?';

  @override
  String get favoritesDeleteSuccess => 'Favorito removido com sucesso';

  @override
  String get favoritesDeleteFailed => 'Falha ao remover';

  @override
  String get favoritesOriginalRecalled => 'Mensagem retirada';

  @override
  String get favoritesViewOriginal => 'Ver original';

  @override
  String get favoritesSearchHint => 'Buscar favoritos';

  @override
  String get favoritesNoResults => 'Nenhum favorito correspondente';

  @override
  String get noticeTitle => 'Anúncios';

  @override
  String get noticeEmpty => 'Nenhum anúncio';

  @override
  String get noticeDetail => 'Detalhes do anúncio';

  @override
  String get noticePublishedAt => 'Publicado';

  @override
  String get noticePriorityNormal => 'normal';

  @override
  String get noticePriorityImportant => 'Importante';

  @override
  String get noticePriorityUrgent => 'Urgente';

  @override
  String get organizationTitle => 'Organização';

  @override
  String get organizationEmpty => 'Nenhuma informação de departamento';

  @override
  String get organizationMembers => 'Membros';

  @override
  String get organizationDepartment => 'Departamento';

  @override
  String get organizationPosition => 'Cargo';

  @override
  String get organizationLeader => 'Responsável';

  @override
  String get qrCodeTitle => 'Meu código QR';

  @override
  String get qrCodeSave => 'salvar na galeria';

  @override
  String get qrCodeShare => 'Compartilhar';

  @override
  String get qrCodeSaveSuccess => 'Salvo na galeria';

  @override
  String get qrCodeSaveFailed => 'Falha ao salvar. Tente novamente.';

  @override
  String get qrCodeRefresh => 'Atualizar código QR';

  @override
  String get qrCodeExpired => 'Código QR expirado. Atualize.';

  @override
  String get qrCodeScanToAdd => 'Escaneie para me adicionar aos contatos';

  @override
  String get spacePersonal => 'Pessoal';

  @override
  String get spaceEnterprise => 'Empresa';

  @override
  String get spaceJoinByCode => 'Entrar com código da empresa';

  @override
  String get spaceJoinByInvite => 'Entrar com código de convite';

  @override
  String get spaceEnterCode => 'Digite o código da empresa';

  @override
  String get spaceEnterInviteCode => 'Digite o código de convite';

  @override
  String get spaceSearchEnterprise => 'Buscar empresa';

  @override
  String get spaceJoinRequestSent =>
      'Solicitação enviada, aguardando aprovação';

  @override
  String get spaceJoinRequestPending => 'Aprovação pendente';

  @override
  String get spaceJoinRequestApproved => 'Solicitação aprovada';

  @override
  String get spaceJoinRequestRejected => 'Solicitação recusada';

  @override
  String get spaceAlreadyMember => 'Você já é membro';

  @override
  String get spaceAutoApproved => 'Aprovado automaticamente. Boas-vindas!';

  @override
  String get spacePendingApprovalHint =>
      'Cadastro concluído. Sua solicitação de entrada foi enviada.';

  @override
  String get spaceNoSpaces => 'Nenhum espaço';

  @override
  String get spaceInviteExpired => 'Código de convite expirado';

  @override
  String get spaceInviteTargetMismatch =>
      'Este código de convite não é para sua conta';

  @override
  String get spaceAcceptInviteSuccess => 'Entrada na empresa concluída';

  @override
  String get spaceAcceptInviteFailed => 'Falha ao entrar. Tente novamente.';

  @override
  String get spaceTenantSelectTitle => 'Selecione o espaço';

  @override
  String get spaceTenantSelectHint => 'Escolha um espaço para acessar';

  @override
  String get spaceEnterPersonal => 'Acessar espaço pessoal';

  @override
  String get spaceEnterEnterprise => 'Acessar espaço da empresa';

  @override
  String get aboutTitle => 'Sobre o StartLink';

  @override
  String get aboutVersion => 'Versão';

  @override
  String get aboutTerms => 'Termos de Serviço';

  @override
  String get aboutPrivacy => 'Política de Privacidade';

  @override
  String get aboutOpenSource => 'Licenças de código aberto';

  @override
  String get aboutCheckUpdate => 'Verificar atualizações';

  @override
  String get aboutLatestVersion => 'Já é a versão mais recente';

  @override
  String get aboutUpdateAvailable => 'Nova versão disponível';

  @override
  String get aboutUpdateNow => 'Atualizar agora';

  @override
  String get aboutUpdateLater => 'Mais tarde';

  @override
  String get notificationTitle => 'Notificações';

  @override
  String get notificationGlobalMute => 'Não perturbe';

  @override
  String get notificationSound => 'Voz';

  @override
  String get notificationVibration => 'Vibração';

  @override
  String get notificationPreview => 'Prévia de mensagens';

  @override
  String get notificationDndStart => 'Início do Não perturbe';

  @override
  String get notificationDndEnd => 'Fim do Não perturbe';

  @override
  String get blacklistTitle => 'Lista negra';

  @override
  String get blacklistEmpty => 'Nenhum usuário bloqueado';

  @override
  String get blacklistRemove => 'Desbloquear';

  @override
  String get blacklistRemoveConfirm => 'Desbloquear este usuário?';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackTypeComplaint => 'Reclamação';

  @override
  String get feedbackTypeSuggestion => 'Sugestão';

  @override
  String get feedbackTypeBug => 'Relatar erro';

  @override
  String get feedbackContent => 'Descrição';

  @override
  String get feedbackContentHint =>
      'Descreva seu problema ou sugestão em detalhes';

  @override
  String get feedbackContact => 'Contato (opcional)';

  @override
  String get feedbackSubmit => 'Enviar';

  @override
  String get feedbackSuccess => 'Feedback enviado. Obrigado!';

  @override
  String get feedbackFailed => 'Falha ao enviar. Tente novamente.';

  @override
  String get networkTitle => 'Alterar linha';

  @override
  String get networkAutoSelect => 'Automático';

  @override
  String get networkManual => 'Manual';

  @override
  String get timezoneTitle => 'Fuso horário';

  @override
  String get timezoneAuto => 'Seguir o sistema';

  @override
  String get autoTranslateTitle => 'Tradução automática';

  @override
  String get autoTranslateEnabled => 'Ativar tradução automática';

  @override
  String get autoTranslateLanguage => 'Idioma de destino';

  @override
  String get displayTitle => 'Exibição';

  @override
  String get displayFontSize => 'Tamanho da Fonte';

  @override
  String get displayChatBackground => 'Plano de fundo da conversa';

  @override
  String get displayDarkMode => 'Aparência';

  @override
  String get displayDarkModeSystem => 'Seguir o sistema';

  @override
  String get displayDarkModeSystemHint =>
      'Alternar automaticamente conforme a configuração do sistema';

  @override
  String get displayDarkModeOff => 'Claro';

  @override
  String get displayDarkModeOffHint => 'Usar sempre o tema claro';

  @override
  String get displayDarkModeOn => 'Escuro';

  @override
  String get displayDarkModeOnHint => 'Usar sempre o tema escuro';

  @override
  String get chatSettingsTitle => 'Conversa';

  @override
  String get chatHistoryTitle => 'Histórico de conversas';

  @override
  String get chatHistoryClear => 'Limpar todo o histórico';

  @override
  String get chatHistoryClearConfirm =>
      'Limpar todo o histórico de conversas? Isso não pode ser desfeito.';

  @override
  String get chatHistoryClearSuccess => 'Histórico de conversas limpo';

  @override
  String get accountSecurityTitle => 'Segurança da conta';

  @override
  String get accountSecurityChangePassword => 'Editar senha';

  @override
  String get accountSecurityChangeMobile => 'Trocar Número de Telefone';

  @override
  String get accountSecurityChangeEmail => 'Alterar e-mail';

  @override
  String get accountSecurityLoggedDevices => 'Dispositivos conectados';

  @override
  String get accountSecurityDeactivate => 'Excluir conta';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Todos os dados serão excluídos permanentemente após 7 dias. Excluir a conta?';

  @override
  String get loggedDevicesTitle => 'Dispositivos conectados';

  @override
  String get loggedDevicesCurrent => 'Este dispositivo';

  @override
  String get loggedDevicesRevoke => 'Sair';

  @override
  String get loggedDevicesRevokeConfirm => 'Sair deste dispositivo?';

  @override
  String get loggedDevicesRevokeSuccess => 'Dispositivo desconectado';

  @override
  String get loggedDevicesRevokeFailed => 'Falha. Tente novamente.';

  @override
  String get loggedDevicesLastActive => 'Última atividade';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Desktop';

  @override
  String get loggedDevicesTypeUnknown => 'Dispositivo desconhecido';

  @override
  String get privacySettingsTitle => 'Privacidade';

  @override
  String get privacySearchableByMobile =>
      'Permitir busca pelo número de telefone';

  @override
  String get privacySearchableByLppId => 'Permitir busca pelo ID StartLink';

  @override
  String get privacyAllowFriendRequest => 'Permitir solicitações de amizade';

  @override
  String get privacyProfileVisibility => 'Visibilidade do perfil';

  @override
  String get privacyEveryone => 'Todos';

  @override
  String get privacyFriendsOfFriends => 'Amigos de amigos';

  @override
  String get privacyNobody => 'Ninguém';

  @override
  String get privacyFriendsOnly => 'Somente amigos';

  @override
  String get privacySaveSuccess => 'Configurações salvas';

  @override
  String get privacySaveFailed => 'Falha ao salvar. Tente novamente.';

  @override
  String get fontSizeTitle => 'Tamanho da Fonte';

  @override
  String get fontSizeSmall => 'Pequeno';

  @override
  String get fontSizeNormal => 'Padrão';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get fontSizeExtraLarge => 'Extra Grande';

  @override
  String get fontSizePreview => 'Prévia';

  @override
  String get chatBackgroundTitle => 'Plano de fundo da conversa';

  @override
  String get chatBackgroundDefault => 'Padrão';

  @override
  String get chatBackgroundCustom => 'Personalizado';

  @override
  String get chatBackgroundReset => 'Restaurar padrão';

  @override
  String get termsTitle => 'Termos de Serviço';

  @override
  String get privacyPolicyTitle => 'Política de Privacidade';

  @override
  String get recentContactsTitle => 'Recentes';

  @override
  String get recentContactsEmpty => 'Nenhum contato recente';

  @override
  String get inviteFriendsTitle => 'Convidar amigos';

  @override
  String get inviteFriendsCopyLink => 'Copiar link de convite';

  @override
  String get inviteFriendsLinkCopied => 'Link de convite copiado';

  @override
  String get imageViewerTitle => 'Foto';

  @override
  String get imageViewerSave => 'salvar na galeria';

  @override
  String get imageViewerSaveSuccess => 'Salvo na galeria';

  @override
  String get imageViewerSaveFailed => 'Falha ao salvar. Tente novamente.';

  @override
  String get customerServiceTitle => 'Central de atendimento';

  @override
  String get customerServiceQueue => 'Na fila';

  @override
  String get customerServiceActive => 'Ativas';

  @override
  String get customerServiceClaim => 'Aceitar';

  @override
  String get customerServiceTakeover => 'Assumir';

  @override
  String get customerServiceClose => 'Encerrar atendimento';

  @override
  String get customerServiceCloseConfirm =>
      'Encerrar esta sessão de atendimento?';

  @override
  String get customerServiceNoQueue => 'Nenhuma sessão na fila';

  @override
  String get customerServiceNoActive => 'Nenhuma sessão ativa';

  @override
  String get customerServiceVisitor => 'Visitante';

  @override
  String get customerServiceCustomer => 'Cliente';

  @override
  String get customerServiceAssignedTo => 'Atribuído a';

  @override
  String get customerServiceTransferConversation => 'Transferir conversa';

  @override
  String get marketingToolbar => 'Ferramentas de marketing';

  @override
  String get callIncoming => 'Chamada recebida';

  @override
  String get callOutgoing => 'Chamada efetuada';

  @override
  String get callAccept => 'Aceitar';

  @override
  String get callReject => 'Recusar';

  @override
  String get callHangup => 'Encerrar';

  @override
  String get callMissed => 'Chamada perdida';

  @override
  String get callDuration => 'Duração';

  @override
  String get callAudio => 'Chamada de voz';

  @override
  String get callGeneric => 'Chamada';

  @override
  String get callVideo => 'Chamada de vídeo';

  @override
  String get callConnecting => 'Conectando…';

  @override
  String get callRinging => 'Chamando…';

  @override
  String get callEnded => 'Chamada encerrada';

  @override
  String get callFailed => 'Falha na chamada';

  @override
  String get callRejected => 'Chamada recusada';

  @override
  String get callTimeout => 'Sem resposta';

  @override
  String get callCancelled => 'Cancelada';

  @override
  String get callUnknownPeer => 'Desconhecidos';

  @override
  String get callVideoInvitation => 'Convite para chamada de vídeo';

  @override
  String get callAudioInvitation => 'Convite para chamada de voz';

  @override
  String get callAnswerAudio => 'Atender com áudio';

  @override
  String get callAnswerVideo => 'Atender com vídeo';

  @override
  String get callViewProfile => 'Ver perfil';

  @override
  String get callOpeningCamera => 'Abrindo câmera…';

  @override
  String get callWaitingRemoteVideo => 'Aguardando o vídeo da outra pessoa…';

  @override
  String get callCameraOff => 'Câmera desligada';

  @override
  String get callCameraOn => 'Câmera ligada';

  @override
  String get callMicrophoneOff => 'Microfone desligado';

  @override
  String get callMicrophoneOn => 'Microfone ligado';

  @override
  String get callSpeakerOff => 'Alto-falante desligado';

  @override
  String get callSpeakerOn => 'Alto-falante ligado';

  @override
  String get callVideoPermissionFailure =>
      'Não foi possível iniciar a chamada de vídeo. Verifique as permissões de câmera e microfone e tente novamente.';

  @override
  String get callAudioPermissionFailure =>
      'Não foi possível iniciar a chamada de voz. Verifique a permissão do microfone e tente novamente.';

  @override
  String get callIncompleteIncoming =>
      'As informações da chamada recebida estão incompletas e não é possível atendê-la.';

  @override
  String get callInProgress => 'Em chamada';

  @override
  String get callCalling => 'Chamando…';

  @override
  String callEndedMedia(String media) {
    return '$media encerrada';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media recusada';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media não atendida';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media cancelada';
  }

  @override
  String get callConnectionLost => 'Conexão da chamada perdida';

  @override
  String get callAdminEnded => 'Chamada encerrada por um administrador';

  @override
  String callFailedMedia(String media) {
    return 'Falha em $media';
  }

  @override
  String get callBusy => 'A outra pessoa está ocupada';

  @override
  String callDurationValue(String duration) {
    return 'Duração da chamada $duration';
  }

  @override
  String get callNotConnected => 'Não conectada';

  @override
  String get callDialed => 'Efetuada';

  @override
  String get callAnswered => 'Atendida';

  @override
  String get callRejectedByPeer => 'Recusada pela outra pessoa';

  @override
  String get callRejectedBySelf => 'Recusado';

  @override
  String get callPeerDidNotAnswer => 'A outra pessoa não atendeu';

  @override
  String get callMissedIncoming => 'Chamada recebida perdida';

  @override
  String get callPeerCancelled => 'Cancelada pela outra pessoa';

  @override
  String get notificationNewMessageTitle => 'Nova mensagem StartLink';

  @override
  String get notificationOnlineServiceTitle => 'Nova mensagem de atendimento';

  @override
  String get notificationNewMessageBody => 'Você recebeu uma nova mensagem';

  @override
  String get notificationImagePreview => 'Enviou uma imagem';

  @override
  String get notificationVideoPreview => 'Enviou um vídeo';

  @override
  String get notificationVoicePreview => 'Enviou uma mensagem de voz';

  @override
  String get notificationFilePreview => 'Enviou um arquivo';

  @override
  String get notificationContactPreview => 'Enviou um cartão de contato';

  @override
  String get notificationCallLogPreview => 'Enviou um registro de chamada';

  @override
  String get notificationLocationPreview => 'Compartilhou uma localização';

  @override
  String get notificationLinkPreview => 'Compartilhou um link';

  @override
  String notificationMentionMe(String body) {
    return 'Mencionou você: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender mencionou você: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Mencionou todos: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender mencionou todos: $body';
  }

  @override
  String get notificationSecurityTitle => 'Alerta de segurança da conta';

  @override
  String get notificationSecurityBody =>
      'As configurações de segurança da sua conta StartLink mudaram. Verifique agora.';

  @override
  String get notificationFriendAcceptedTitle => 'Solicitação de amizade aceita';

  @override
  String get notificationFriendRejectedTitle =>
      'Solicitação de amizade recusada';

  @override
  String get notificationFriendAcceptedBody =>
      'A outra pessoa aceitou sua solicitação de amizade';

  @override
  String get notificationFriendRejectedBody =>
      'A outra pessoa recusou sua solicitação de amizade';

  @override
  String get notificationVideoCallTitle => 'Convite para chamada de vídeo';

  @override
  String get notificationAudioCallTitle => 'Convite para chamada de voz';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller convidou você para uma chamada de vídeo';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller convidou você para uma chamada de voz';
  }

  @override
  String get notificationMessageChannelName => 'Mensagens';

  @override
  String get notificationMessageChannelDescription =>
      'Mensagens de conversa, registros de chamadas e alertas do sistema';

  @override
  String get notificationCallChannelName => 'Chamadas';

  @override
  String get notificationCallChannelDescription =>
      'Alertas de chamadas de voz e vídeo';

  @override
  String get notificationSecurityChannelName => 'Segurança da conta';

  @override
  String get notificationSecurityChannelDescription =>
      'Alertas de login e alterações de senha ou número de celular';

  @override
  String get notificationUnknownCaller => 'Chamador desconhecido';

  @override
  String get pendingJoinRequestsTitle => 'Novas solicitações';

  @override
  String get pendingJoinRequestsEmpty => 'Nenhuma solicitação';

  @override
  String get pendingJoinRequestApprove => 'Aceitar';

  @override
  String get pendingJoinRequestReject => 'Recusar';

  @override
  String get pendingJoinRequestApproveSuccess => 'Aprovada';

  @override
  String get pendingJoinRequestRejectSuccess => 'Recusada';

  @override
  String get pendingJoinRequestFailed => 'Falha na operação. Tente novamente.';

  @override
  String get myCustomersTitle => 'Meus clientes';

  @override
  String get myCustomersEmpty => 'Nenhum cliente';

  @override
  String get groupListTitle => 'Grupos';

  @override
  String get groupListEmpty => 'Nenhum grupo';

  @override
  String get addFriendTitle => 'Adicionar contato';

  @override
  String get addFriendSearchHint => 'Telefone / E-mail / ID StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String get addFriendButton => 'Adicionar';

  @override
  String get addFriendCannotAddSelf => 'Você não pode adicionar a si mesmo';

  @override
  String get addFriendUnsupportedUser =>
      'Este usuário não pode ser adicionado. Você pode enviar mensagens diretamente.';

  @override
  String get addFriendMessageHint => 'Digite uma mensagem';

  @override
  String get addFriendSendRequest => 'Enviar solicitação';

  @override
  String get joinCompanyTitle => 'Entrar em empresa';

  @override
  String get joinCompanyCodeHint => 'Digite o código da empresa';

  @override
  String get joinCompanySearchHint => 'Buscar nome da empresa';

  @override
  String get joinCompanyApply => 'Solicitar entrada';

  @override
  String get joinCompanyApplySuccess => 'Solicitação enviada';

  @override
  String get joinCompanyApplyFailed => 'Falha ao solicitar. Tente novamente.';

  @override
  String get joinCompanyAutoApproved =>
      'Aprovado automaticamente. Boas-vindas!';

  @override
  String get joinCompanyPending => 'Solicitação enviada, aguardando aprovação';

  @override
  String get joinCompanyInviteCodeHint => 'Digite o código de convite';

  @override
  String get joinCompanyAcceptInvite => 'Aceitar convite';

  @override
  String get joinCompanyNoResults => 'Nenhuma empresa encontrada';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count membros';
  }

  @override
  String get timezoneNameHawaii => 'Havaí';

  @override
  String get timezoneNameAlaska => 'Alasca';

  @override
  String get timezoneNamePacificTime => 'Horário do Pacífico';

  @override
  String get timezoneNameMountainTime => 'Horário das Montanhas';

  @override
  String get timezoneNameCentralTime => 'Horário Central';

  @override
  String get timezoneNameEasternTime => 'Horário do Leste';

  @override
  String get timezoneNameAtlanticTime => 'Horário do Atlântico';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Açores';

  @override
  String get timezoneNameLondonDublin => 'Londres/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlim/Paris/Roma';

  @override
  String get timezoneNameCairoHelsinki => 'Cairo/Helsinque';

  @override
  String get timezoneNameMoscowRiyadh => 'Moscou/Riad';

  @override
  String get timezoneNameTehran => 'Teerã';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Baku';

  @override
  String get timezoneNameKabul => 'Cabul';

  @override
  String get timezoneNameKarachiTashkent => 'Carachi/Tashkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/Nova Délhi';

  @override
  String get timezoneNameKathmandu => 'Catmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Daca/Almaty';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanói/Jacarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Pequim/Xangai/Hong Kong/Taipé';

  @override
  String get timezoneNameTokyoSeoul => 'Tóquio/Seul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Ilhas Salomão';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute =>
      'Selecionar a melhor rota automaticamente';

  @override
  String get networkTesting => 'Testando…';

  @override
  String get networkTestingShort => 'Testando';

  @override
  String networkLatencyMs(int ms) {
    return 'Latência $ms ms';
  }

  @override
  String get networkConnectionMode => 'Modo de conexão';

  @override
  String get networkDirectMode => 'Modo direto';

  @override
  String get networkProxyMode => 'Modo proxy';

  @override
  String get networkDirectModeDesc => 'Conectar diretamente ao servidor';

  @override
  String get networkProxyModeDesc => 'Conectar por um servidor proxy';

  @override
  String get networkDirectRoutes => 'Rotas diretas';

  @override
  String get networkProxyRoutes => 'Rotas proxy';

  @override
  String get networkTestAll => 'Testar todas';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Nó de Hong Kong';

  @override
  String get networkSingaporeNode => 'Nó de Singapura';

  @override
  String get networkJapanNode => 'Nó do Japão';

  @override
  String get networkUnitedStatesNode => 'Nó dos Estados Unidos';

  @override
  String get networkHint =>
      'Dicas:\n• Modo direto: mais rápido e adequado ao uso nacional\n• Modo proxy: mais estável para comunicação internacional\n• Toque no ícone de atualizar para testar a latência de uma rota';

  @override
  String get teenModeTitle => 'Modo adolescente';

  @override
  String get teenModeStatusOn => 'Ativado';

  @override
  String get teenModeStatusOff => 'Desativado';

  @override
  String get teenModeStatusLoading => 'Carregando';

  @override
  String get teenModeUnavailable =>
      'O status do modo adolescente está temporariamente indisponível';

  @override
  String get teenModeInvalidResponse =>
      'O modo adolescente retornou uma resposta inválida';

  @override
  String get teenModeEnableDescription =>
      'As regras da plataforma limitarão o tempo de uso e alguns recursos.';

  @override
  String get teenModePasscode => 'Código de acesso';

  @override
  String get teenModeCurrentPasscode => 'Código de acesso atual';

  @override
  String get teenModeNewPasscode => 'Novo código de acesso';

  @override
  String get teenModePasscodeHint => 'Digite de 4 a 6 dígitos';

  @override
  String get teenModeEnable => 'Ativar modo adolescente';

  @override
  String get teenModeDisable => 'Desativar modo adolescente';

  @override
  String get teenModeChangePasscode => 'Alterar código de acesso';

  @override
  String get teenModeSource => 'Ativado por';

  @override
  String get teenModeDailyUsage => 'Usado hoje';

  @override
  String get teenModeRemaining => 'Tempo restante';

  @override
  String get teenModeMinutesUnit => 'Minutos';

  @override
  String get teenModeUnlimited => 'Ilimitado';

  @override
  String get teenModeRequestExtension => 'Solicitar mais tempo';

  @override
  String get teenModeExtensionSubmitted =>
      'A solicitação de tempo foi enviada a um responsável';

  @override
  String get teenModeTimeLimitReached => 'O limite de uso de hoje foi atingido';

  @override
  String get teenModeCurfewActive => 'Este é um período de uso restrito';

  @override
  String get teenModeReliefHint =>
      'Você ainda pode ver o histórico, contatar o suporte oficial e relatar problemas.';

  @override
  String get teenModeRestrictedNotice =>
      'O modo adolescente impede o envio de mensagens no momento';

  @override
  String get teenModeActionBlocked =>
      'O modo adolescente impede esta ação no momento';

  @override
  String get teenModeMyRequests => 'Minhas solicitações';

  @override
  String get guardianCenterTitle => 'Central de responsáveis';

  @override
  String get guardianRelationships => 'Vínculos com responsáveis';

  @override
  String get guardianMinors => 'Crianças sob minha supervisão';

  @override
  String get guardianApprovals => 'Aprovações pendentes';

  @override
  String get guardianBind => 'Digite o código de vínculo';

  @override
  String get guardianCreateMinorCode => 'Sou menor — criar código';

  @override
  String get guardianCreateGuardianCode => 'Sou responsável — criar código';

  @override
  String get guardianRelation => 'Relacionamento';

  @override
  String get guardianPrimary => 'Responsável principal';

  @override
  String get guardianCode => 'Código de vínculo de 6 dígitos';

  @override
  String get guardianCodeHint => 'Digite o código fornecido pela outra pessoa';

  @override
  String get guardianCodeCreated =>
      'Código criado. Compartilhe antes de expirar.';

  @override
  String get guardianEmpty => 'Nenhum vínculo com responsáveis';

  @override
  String get guardianNoMinors => 'Nenhuma criança supervisionada';

  @override
  String get guardianUnbind => 'Remover vínculo';

  @override
  String get guardianExtend => 'Adicionar tempo para a criança';

  @override
  String get guardianPolicyTitle => 'Regras de uso';

  @override
  String get guardianPolicyLocked => 'Bloqueado pela plataforma';

  @override
  String get approvalEmpty => 'Nenhuma solicitação';

  @override
  String get approvalApprove => 'Aceitar';

  @override
  String get approvalReject => 'Recusar';

  @override
  String get approvalPending => 'Pendente';

  @override
  String get approvalApproved => 'Aprovada';

  @override
  String get approvalRejected => 'Recusado';

  @override
  String get approvalExpired => 'Expirado';

  @override
  String get approvalCancelled => 'Cancelado';

  @override
  String get approvalReplayFailed => 'A ação original falhou. Tente novamente.';

  @override
  String get requestCancelled => 'Solicitação cancelada';

  @override
  String get kycTitle => 'Autenticação de Nome Real';

  @override
  String get kycNotRequired => 'A verificação de identidade não é necessária';

  @override
  String get kycVerified => 'Identidade verificada';

  @override
  String get kycDeclared => 'Informações de identidade enviadas';

  @override
  String get kycPending => 'Em análise';

  @override
  String get kycRejected => 'Verificação recusada';

  @override
  String get kycNone => 'Nenhuma informação de identidade enviada';

  @override
  String get kycRealName => 'Nome Real';

  @override
  String get kycIdNumber => 'Número do documento';

  @override
  String get kycIdType => 'Tipo de documento';

  @override
  String get kycApplicability =>
      'Digite seus dados reais para o documento selecionado. Os tipos aceitos aparecem na lista.';

  @override
  String get kycCamera => 'Tirar foto';

  @override
  String get kycGallery => 'Escolher da galeria';

  @override
  String get kycPhotoLimit => 'Máximo por foto';

  @override
  String get kycSelectPhoto => 'Selecionar foto';

  @override
  String get kycPhotoSelected => 'Selecionada';

  @override
  String get kycViewPhoto => 'Toque para ver a foto';

  @override
  String get kycReplacePhoto => 'Escolher outra foto';

  @override
  String get kycDisclosure =>
      'Usamos seu nome, número do documento e fotos do documento para verificar sua identidade. Sem essas informações, não é possível enviar a solicitação e alguns recursos restritos podem ficar indisponíveis.';

  @override
  String get kycConsent =>
      'Dou consentimento específico para este tratamento das informações de identidade';

  @override
  String get kycConsentRequired =>
      'Forneça consentimento específico antes de enviar';

  @override
  String get kycResubmitTitle => 'Reenviar informações de identidade';

  @override
  String get kycResubmitWarning =>
      'O novo envio substituirá sua solicitação pendente. Continuar?';

  @override
  String get kycSubmitting => 'Enviando';

  @override
  String get kycSubmitFailed => 'Falha ao enviar. Tente novamente.';

  @override
  String get kycSubmitUnavailable =>
      'Não é possível enviar informações de identidade agora';

  @override
  String get kycResubmitNotAllowed =>
      'O reenvio não está disponível após uma recusa. Contate o suporte se necessário.';

  @override
  String get kycDailyLimit =>
      'Você atingiu o limite de envios de hoje. Tente amanhã.';

  @override
  String get kycTypeUnavailable =>
      'Nenhum tipo de documento disponível. Tente mais tarde.';

  @override
  String get kycNameInvalid => 'O nome legal deve ter de 2 a 64 caracteres';

  @override
  String get kycNumberRequired => 'Digite o número do documento';

  @override
  String get kycFrontRequired => 'Envie a frente do documento';

  @override
  String get kycBackRequired => 'Envie o verso do documento';

  @override
  String get kycPhotoTooLarge =>
      'A foto excede o limite de tamanho. Comprima e tente novamente.';

  @override
  String get kycAccountChanged =>
      'A conta ou o espaço mudou. Reabra esta página.';

  @override
  String get kycPhotoInvalid => 'Escolha uma imagem válida';

  @override
  String get kycPortraitSide => 'Face com Foto';

  @override
  String get kycEmblemSide => 'Face com Emblema Nacional';

  @override
  String get kycPassportDataPage => 'Página de dados do passaporte';

  @override
  String get kycPassportOtherPage =>
      'Página de visto ou página em branco do passaporte';

  @override
  String get kycFront => 'Frente do Documento';

  @override
  String get kycBack => 'Verso do documento';

  @override
  String get kycRequired =>
      'É necessário verificar a identidade antes de criar um grupo';

  @override
  String get kycGoVerify => 'Verificar agora';

  @override
  String get kycStatusUnknown =>
      'Status de identidade indisponível. Atualize mais tarde.';

  @override
  String get kycSuperseded =>
      'Um envio posterior substituiu este. Verifique seu status de identidade mais recente.';

  @override
  String get kycMediaNotFound =>
      'A foto do documento não está disponível neste espaço. Selecione novamente antes de enviar.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Envio em massa para clientes';

  @override
  String get officialAccountBadge => 'Oficial';

  @override
  String get officialAccountOpenConversation => 'Abrir conversa';

  @override
  String get officialAccountJoinHint =>
      'Adicionar esta conta faz você entrar na empresa como cliente. Não é necessária aprovação de amizade.';

  @override
  String get officialAccountJoinDisabled =>
      'Esta empresa não está aceitando novos clientes. Contate o suporte.';

  @override
  String get officialAccountRemoved =>
      'Você foi removido desta empresa. Peça à empresa que convide você novamente.';

  @override
  String get officialAccountBanned => 'Sua conta foi desativada nesta empresa.';

  @override
  String get officialAccountUnavailable =>
      'Esta conta oficial está indisponível no momento.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Não é permitido entrar em uma empresa no modo atual.';

  @override
  String get officialAccountPlatformRequired =>
      'Use uma conta da plataforma para adicionar esta conta oficial.';

  @override
  String get officialAccountOpenFailed =>
      'Não foi possível abrir a conversa. Tente novamente.';

  @override
  String get officialAccountAccountChanged =>
      'A conta ou o espaço mudou. Abra novamente.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'O diretório da empresa não está atualizado. Tente novamente em instantes.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Falha ao sincronizar a conta oficial. O conteúdo local continua disponível.';

  @override
  String get officialAccountInboxSyncing =>
      'Sincronizando mensagens da conta oficial';

  @override
  String get diagnosticsTitle => 'Diagnóstico';

  @override
  String get diagnosticsExplanation =>
      'Os registros têm dados sensíveis ocultados e contêm informações operacionais e de erros desta conta e espaço, além de eventos públicos de inicialização. Conteúdo das conversas e credenciais são excluídos.';

  @override
  String get diagnosticsHour => 'Última hora';

  @override
  String get diagnosticsDay => 'Últimas 24 horas';

  @override
  String get diagnosticsWeek => 'Últimos 7 dias';

  @override
  String diagnosticsEventCount(int count) {
    return 'Eventos disponíveis: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Os registros são salvos neste dispositivo e continuam disponíveis após reiniciar.';

  @override
  String get diagnosticsNotPersistent =>
      'Alguns registros não foram salvos. Atualize para tentar novamente.';

  @override
  String get diagnosticsExport => 'Exportar e compartilhar';

  @override
  String get diagnosticsRefresh => 'Atualizar';

  @override
  String get diagnosticsClear => 'Limpar registros deste espaço';

  @override
  String get diagnosticsClearConfirm =>
      'Limpar os registros de diagnóstico deste espaço? O histórico de conversas será mantido.';

  @override
  String get diagnosticsShared =>
      'Compartilhamento do sistema concluído. Confirme o arquivo no aplicativo destinatário.';

  @override
  String get diagnosticsCancelled =>
      'Compartilhamento cancelado. Você pode exportar novamente.';

  @override
  String get diagnosticsUnconfirmed =>
      'Não foi possível confirmar o compartilhamento. Verifique o aplicativo destinatário.';

  @override
  String get diagnosticsFailed => 'Falha na operação. Tente novamente.';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class AppLocalizationsPtPt extends AppLocalizationsPt {
  AppLocalizationsPtPt() : super('pt_PT');

  @override
  String get navWorkbench => 'Área de trabalho';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed =>
      'Não foi possível carregar os dados da conta';

  @override
  String get startupFailureTitle => 'Falha ao iniciar';

  @override
  String get startupFailureMessage => 'Verifique a ligação e tente de novo';

  @override
  String get privacyConsentTitle =>
      'Termos de Serviço e Política de Privacidade';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Bem-vindo ao $brand. Para disponibilizar o acesso à conta, mensagens instantâneas, colaboração empresarial, apoio ao cliente online, notificações e proteção de segurança, precisamos de tratar as informações necessárias de acordo com os Termos de Serviço e a Política de Privacidade.\n\nAntes de tocar em «Concordar», não lemos a área de transferência, não inicializamos o JPush/JCore nem os SDK de notificações dos fabricantes e não os utilizamos para aceder ao Android ID, OAID, listas de aplicações instaladas, endereços MAC ou informações semelhantes. Se recusar por agora, guardaremos a sua escolha; poderá continuar a ler os documentos e decidir novamente mais tarde.\n\nApós o seu consentimento, para entregar notificações de mensagens, apoio ao cliente e chamadas recebidas, o JPush/JCore e os serviços de notificações dos fabricantes poderão tratar o modelo do dispositivo, a versão do Android, o pacote e a versão da aplicação, o tipo de rede, o endereço IP, Android ID, OAID, o ID de registo de notificações, o token de notificações do fabricante e os dados de entrega e de cliques nas notificações. Desativámos funções não essenciais, incluindo notificações inteligentes, listas de aplicações instaladas, MAC, IMEI, IMSI, listas de Wi-Fi, ativação automática e arranque associado.\n\nA área de transferência só é consultada quando copia ou cola ativamente. As permissões de câmara, microfone, notificações e outras permissões do sistema só são solicitadas quando utiliza a função correspondente. Recusar uma permissão afeta apenas essa função. Leia os documentos completos abaixo e escolha se concorda.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Bem-vindo ao $brand. Para disponibilizar o acesso à conta, mensagens instantâneas, colaboração empresarial, apoio ao cliente online, notificações e proteção de segurança, precisamos de tratar as informações necessárias de acordo com os Termos de Serviço e a Política de Privacidade.\n\nAntes de tocar em «Concordar», não lemos a área de transferência, não inicializamos o JPush/JCore, não registamos a aplicação no serviço Apple Push Notification (APNs) e não obtemos identificadores de notificações, como o ID de registo JPush ou o token de dispositivo APNs. Se recusar por agora, guardaremos a sua escolha; poderá continuar a ler os documentos e decidir novamente mais tarde.\n\nApós o seu consentimento, para entregar notificações de mensagens, apoio ao cliente e chamadas recebidas, poderemos tratar o modelo do iPhone, a versão do iOS, o pacote e a versão da aplicação, o tipo de rede, o endereço IP, IDFV, o ID de registo JPush, o token de dispositivo APNs e os dados de entrega e de cliques nas notificações. O JPush/JCore liga-se ao serviço de notificações; o Apple APNs trata o identificador da aplicação, o token de dispositivo e o conteúdo das notificações para entregar notificações do sistema. A aplicação iOS atual não utiliza serviços publicitários nem obtém IDFA.\n\nA área de transferência só é consultada quando copia ou cola ativamente. As permissões de câmara, microfone, notificações e outras permissões do sistema só são solicitadas quando utiliza a função correspondente. Recusar uma permissão afeta apenas essa função. Leia os documentos completos abaixo e escolha se concorda.';
  }

  @override
  String get privacyConsentTermsLink => 'Termos de Utilização';

  @override
  String get privacyConsentConjunction => 'e';

  @override
  String get privacyConsentPrivacyLink => 'Política de Privacidade';

  @override
  String get privacyConsentDecline => 'Não concordar';

  @override
  String get privacyConsentDeclinedExit =>
      'Não concordou com os Termos de Serviço e a Política de Privacidade. A aplicação será agora encerrada.';

  @override
  String get privacyConsentAccept => 'Aceitar';

  @override
  String get privacyConsentRuntimeFailure =>
      'Falha ao iniciar. Verifique a ligação e tente de novo.';

  @override
  String get privacyConsentSaveFailure =>
      'Não foi possível guardar a sua escolha. Tente de novo.';

  @override
  String get appUpdateRequiredTitle => 'Atualização necessária para continuar';

  @override
  String get appUpdateOptionalTitle => 'Nova versão disponível';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version está disponível';
  }

  @override
  String get appUpdateLater => 'Mais tarde';

  @override
  String get appUpdateNow => 'Atualizar agora';

  @override
  String get appUpdateProcessing => 'A processar…';

  @override
  String get appUpdateInvalidUrl =>
      'O endereço de atualização é inválido. Tente mais tarde.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Não foi possível abrir o link de atualização. Tente mais tarde.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Transferência interrompido. Verifique a ligação e tente de novo.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Falha na verificação do pacote. Transfira novamente.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Permita que o $brand instale atualizações nas definições do sistema.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Não foi possível abrir o instalador do sistema. Verifique as permissões de instalação.';

  @override
  String get appUpdateGenericFailure =>
      'Falha na atualização. Verifique a ligação e tente de novo.';

  @override
  String get appUpdateUnavailable =>
      'A nova versão ainda não está disponível para transferência. Tente mais tarde.';

  @override
  String get appUpdateCheckFailed =>
      'Não foi possível verificar atualizações. Tente mais tarde.';

  @override
  String get appUpdateChecking => 'A verificar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonSearch => 'pesquisar';

  @override
  String get commonLoading => 'A carregar…';

  @override
  String get commonLoadFailed => 'Falha ao carregar';

  @override
  String get commonRetry => 'Tentar de novo';

  @override
  String get commonEmpty => 'Sem dados';

  @override
  String get commonCopy => 'Copiar';

  @override
  String get commonForward => 'Encaminhar';

  @override
  String get commonFavorite => 'Favoritar';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonSend => 'Enviar';

  @override
  String get commonDone => 'Concluído';

  @override
  String get commonMore => 'Mais';

  @override
  String get commonSettings => 'Definições';

  @override
  String get commonCopied => 'Copiado';

  @override
  String get commonUnknown => 'Desconhecido';

  @override
  String get commonNotSet => 'Não definido';

  @override
  String get commonUnbound => 'Não vinculado';

  @override
  String get commonViewAll => 'Ver tudo';

  @override
  String get commonSubmit => 'Enviar';

  @override
  String get commonAdd => 'Adicionar';

  @override
  String get commonRemove => 'Remover';

  @override
  String get commonCreate => 'Criar';

  @override
  String get commonUpdate => 'Atualizar';

  @override
  String get commonUpload => 'Carregar';

  @override
  String get commonShare => 'Partilhar';

  @override
  String get commonBlock => 'Bloquear';

  @override
  String get commonUnblock => 'Desbloquear';

  @override
  String get commonMute => 'Silenciar';

  @override
  String get commonUnmute => 'Ativar som';

  @override
  String get commonPin => 'Fixar';

  @override
  String get commonUnpin => 'Desafixar';

  @override
  String get commonMarkRead => 'Marcar como lida';

  @override
  String get commonMarkUnread => 'Marcar como não lida';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Falha na operação. Tente de novo.';

  @override
  String get commonNetworkError => 'Erro de rede. Verifique a ligação.';

  @override
  String get navMessages => 'Mensagem';

  @override
  String get navContacts => 'Contactos';

  @override
  String get navMe => 'Eu';

  @override
  String get authLoginTitle => 'Entrar no StartLink';

  @override
  String get authTabMobile => 'Telefone';

  @override
  String get authTabEmail => 'Email';

  @override
  String get authTabLoginName => 'ID StartLink';

  @override
  String get authHintMobile => 'Introduza o número de telefone';

  @override
  String get authHintEmail => 'Insira o e-mail';

  @override
  String get authHintPassword => 'Introduza a senha';

  @override
  String get authHintCode => 'Introduza o código de verificação';

  @override
  String get authHintLoginName => 'Introduza o ID StartLink (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Iniciar Sessão';

  @override
  String get authGetCode => 'Obter código de verificação';

  @override
  String authResendCode(int seconds) {
    return 'Reenviar em $seconds s';
  }

  @override
  String get authUsePassword => 'Usar palavra-passe';

  @override
  String get authUseCode => 'Usar código de verificação';

  @override
  String get authAgreementPrefix => 'Li e concordo com os ';

  @override
  String get authAgreementAnd => 'e';

  @override
  String get authTermsLink => 'Termos de Utilização';

  @override
  String get authPrivacyLink => 'Política de Privacidade';

  @override
  String get authCaptchaTitle => 'Verificação de segurança';

  @override
  String get authCaptchaHint => 'Introduza a resposta';

  @override
  String get authCaptchaFailed =>
      'Não foi possível obter o captcha. Tente de novo.';

  @override
  String get authErrorEmptyCode => 'Introduza o código de verificação';

  @override
  String get authErrorEmptyPassword => 'Introduza a senha';

  @override
  String get authErrorEmptyLoginName => 'Introduza o ID StartLink';

  @override
  String get authErrorWrongCredentials => 'Conta ou palavra-passe incorreta';

  @override
  String get authDeactivatingTitle => 'Eliminação da conta';

  @override
  String get authDeactivatingContent =>
      'A sua conta está no período de reflexão para eliminação (7 dias).\n\nPara cancelar a eliminação, toque em «Cancelar eliminação»; caso contrário, toque em «Continuar» para aceder à aplicação.';

  @override
  String get authContinueUse => 'Continuar';

  @override
  String get authCancelDeactivation => 'Cancelar eliminação';

  @override
  String get authDeactivationCancelled =>
      'Eliminação cancelada, conta restaurada';

  @override
  String get authDeactivationCancelFailed =>
      'Falha ao cancelar. Tente de novo.';

  @override
  String get authLogout => 'Sair';

  @override
  String get authLogoutConfirm => 'Tem a certeza de que deseja sair?';

  @override
  String get authSendingCode => 'A enviar…';

  @override
  String get authCodeSent => 'Código de verificação enviado com sucesso';

  @override
  String get authLoginFailed => 'Falha ao entrar. Tente de novo.';

  @override
  String get authRegisterFailed => 'Falha no registo. Tente de novo.';

  @override
  String get authEnterpriseCode => 'Código da empresa';

  @override
  String get authEnterpriseCodeHint => 'Introduza o código da empresa';

  @override
  String get authPendingApproval =>
      'Registo concluído. Sua solicitação de entrada na empresa foi enviada e aguarda aprovação.';

  @override
  String get authNoAccount => 'Sem conta?';

  @override
  String get authRegisterNow => 'Registar agora';

  @override
  String get authCountryPickerTitle => 'Selecione o país ou região';

  @override
  String get authCountrySearchHint => 'Pesquisar país ou região';

  @override
  String get authCountryChinaMainland => 'China continental';

  @override
  String get authCountryHongKong => 'Hong Kong, China';

  @override
  String get authCountryMacau => 'Macau, China';

  @override
  String get authCountryTaiwan => 'Taiwan, China';

  @override
  String get authCountryUnitedStates => 'Estados Unidos';

  @override
  String get authCountryUnitedKingdom => 'Reino Unido';

  @override
  String get authCountryJapan => 'Japão';

  @override
  String get authCountrySouthKorea => 'Coreia do Sul';

  @override
  String get authCountrySingapore => 'Singapura';

  @override
  String get authCountryMalaysia => 'Malásia';

  @override
  String get authCountryAustralia => 'Austrália';

  @override
  String get authCountryCanada => 'Canadá';

  @override
  String get authCountryGermany => 'Alemanha';

  @override
  String get authCountryFrance => 'França';

  @override
  String get authCountryIndia => 'Índia';

  @override
  String get authCountryThailand => 'Tailândia';

  @override
  String get authCountryVietnam => 'Vietnã';

  @override
  String get authCountryIndonesia => 'Indonésia';

  @override
  String get authCountryPhilippines => 'Filipinas';

  @override
  String get authQuickLoginTitle => 'Acesso rápido';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Entrando. Aguarde.';

  @override
  String get authRoleOwner => 'Proprietário';

  @override
  String get authRoleAdministrator => 'Administrador';

  @override
  String get authRoleCustomerService => 'Atendimento ao cliente';

  @override
  String get authRoleTechnicalSupport => 'Apoio técnico';

  @override
  String get authRoleEmployee => 'Funcionário';

  @override
  String get authRoleMember => 'Membro';

  @override
  String get authRoleEnterpriseCustomer => 'Cliente da empresa';

  @override
  String get authUnavailablePrefix => 'Indisponível · ';

  @override
  String get authUnassignedService => 'Nenhum assistente atribuído';

  @override
  String authAssignedService(String staff) {
    return 'Atribuído a $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Cliente · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Funcionário · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count utilizadores';
  }

  @override
  String get authMetaPhone => 'Telefone';

  @override
  String get authMetaIdentity => 'Identidade';

  @override
  String get authRegisterTitle => 'Registar';

  @override
  String get authNickname => 'Apelido';

  @override
  String get authNicknameHint => 'Defina um alcunha';

  @override
  String get authPassword => 'Senha';

  @override
  String get authPasswordSetHint =>
      'Defina uma palavra-passe (pelo menos 6 caracteres)';

  @override
  String get authConfirmPassword => 'Confirmar senha';

  @override
  String get authConfirmPasswordHint => 'Introduza a palavra-passe novamente';

  @override
  String get authVerificationCode => 'Código de verificação';

  @override
  String get authRegisterAndLogin => 'Registar e entrar';

  @override
  String get authHaveAccount => 'Já tem uma conta?';

  @override
  String get authGoLogin => 'Entrar';

  @override
  String get authEmailVerificationUnavailable =>
      'A verificação por e-mail está indisponível. Registe-se com um número de telemóvel.';

  @override
  String get authSmsVerificationUnavailable =>
      'A verificação por SMS está indisponível. Registe-se com um e-mail.';

  @override
  String get authSendFailed => 'Não foi possível enviar. Tente de novo.';

  @override
  String get authErrorEmptyNickname => 'Introduza um alcunha';

  @override
  String get authErrorInvalidMobile =>
      'Introduza um número de telemóvel válido';

  @override
  String get authErrorInvalidEmail => 'Introduza um endereço de e-mail válido';

  @override
  String get authErrorPasswordTooShort =>
      'A palavra-passe deve ter pelo menos 6 caracteres';

  @override
  String get authErrorPasswordMismatch => 'As palavras-passe não coincidem';

  @override
  String get authErrorVerificationRequired =>
      'Solicite e introduza primeiro o código de verificação';

  @override
  String get authRegisterErrorTitle => 'Falha no registo';

  @override
  String get authGotIt => 'Entendi';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Empresa «$code» não encontrada. Verifique o código da empresa.';
  }

  @override
  String get authTenantSearchFailed => 'Falha na pesquisa. Tente de novo.';

  @override
  String get authInvitationInvalid =>
      'O código de convite é inválido. Verifique e tente de novo.';

  @override
  String get authCollapseJoin => 'Ocultar informações de entrada';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Convite válido: $name';
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
  String get authSelectOrganization => 'Selecione a organização';

  @override
  String get authNoOrganization => 'Nenhuma organização disponível';

  @override
  String get authNoOrganizationHint =>
      'Peça a um administrador que o convide para uma organização';

  @override
  String get authPersonalSpace => 'Espaço pessoal';

  @override
  String get authPersonalSpaceSubtitle =>
      'Conversas com amigos e favoritos pessoais';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Não foi possível verificar a identidade do espaço. Tente de novo.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Não foi possível restaurar o espaço pessoal. Tente de novo.';

  @override
  String get authJoinEnterpriseFailed =>
      'Não foi possível entrar na empresa. Tente mais tarde.';

  @override
  String get homeTitle => 'Mensagem';

  @override
  String get homeGatewayConnectingTitle => 'A ligar';

  @override
  String get homePersonalSpace => 'Pessoal';

  @override
  String get homeOfficialService => 'Serviço oficial';

  @override
  String get homeSwitchSpace => 'Trocar espaço';

  @override
  String get homeSpaceSubtitle => 'Pessoal · Empresa';

  @override
  String get homeJoinEnterprise => 'Entrar em empresa';

  @override
  String get homeCreateGroup => 'Novo grupo';

  @override
  String get homeAddFriend => 'Adicionar contacto';

  @override
  String get homeScan => 'Ler código';

  @override
  String get homeJoinNewSpace => 'Entrar em novo espaço';

  @override
  String get homeSearchConversation => 'Pesquisar';

  @override
  String get homeNoMessages => 'Sem mensagens';

  @override
  String get homeDeleteConversation => 'Eliminar conversa';

  @override
  String get homeDeleteConversationConfirm =>
      'Eliminar esta conversa? O histórico será apagado.';

  @override
  String get homePersonalNote => 'Eu (notas pessoais)';

  @override
  String get homeWorkNote => 'Eu (notas de trabalho)';

  @override
  String homeConversationCount(int count) {
    return '$count conversas';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count não lidas';
  }

  @override
  String get chatInputHint => 'Introduza uma mensagem…';

  @override
  String get chatVoiceHint => 'Segure para falar';

  @override
  String get chatVoiceRelease => 'Solte para enviar';

  @override
  String get chatVoiceCancel => 'Deslize para cima para cancelar';

  @override
  String get chatMenuCopy => 'Copiar';

  @override
  String get chatMenuForward => 'Encaminhar';

  @override
  String get chatMenuRecall => 'Retirar';

  @override
  String get chatMenuDelete => 'Eliminar';

  @override
  String get chatMenuFavorite => 'Favoritar';

  @override
  String get chatMenuReply => 'Responder';

  @override
  String get chatMenuMultiSelect => 'Selecionar';

  @override
  String get chatMenuTranslate => 'Traduzir';

  @override
  String get chatMenuVoiceToText => 'Converter em texto';

  @override
  String get chatMenuTextToSpeech => 'Ler em voz alta';

  @override
  String get chatStatusRecalled => 'Mensagem retirada';

  @override
  String get chatRecallSuccess => 'Retirada';

  @override
  String get chatRecallFailed => 'Falha ao retirar';

  @override
  String get chatRecallTimeout =>
      'Mensagens com mais de 2 minutos não podem ser retiradas';

  @override
  String get chatTranslateFailed => 'Falha na tradução. Tente de novo.';

  @override
  String get chatTranslateNotConfigured => 'Serviço de tradução indisponível';

  @override
  String get chatVoiceToTextFailed => 'Falha na conversão. Tente de novo.';

  @override
  String get chatTextToSpeechFailed =>
      'Falha na leitura em voz alta. Tente de novo.';

  @override
  String get chatVoiceToText => 'Converter';

  @override
  String get chatForwardSuccess => 'Encaminhado';

  @override
  String get chatForwardFailed => 'Falha ao encaminhar. Tente de novo.';

  @override
  String get chatNoConversations => 'Nenhuma conversa para encaminhar';

  @override
  String get chatSendFailed => 'Falha ao enviar';

  @override
  String get chatResend => 'Reenviar';

  @override
  String get chatNotFriend => 'Não está na lista de contactos';

  @override
  String get chatNotFriendHint =>
      'Ainda não são contactos. Não é possível enviar mensagens.';

  @override
  String get chatMutedHint => 'Todos os membros estão silenciados';

  @override
  String get chatFileUploadFailed =>
      'Falha ao enviar o ficheiro. Tente de novo.';

  @override
  String get chatFileStatusNotDownloaded => 'Não transferido';

  @override
  String get chatFileStatusDownloaded => 'Transferido';

  @override
  String get chatFileStatusUploading => 'A enviar ficheiro';

  @override
  String get chatFileStatusUploadFailed => 'Falha ao carregar';

  @override
  String get chatCardSendFailed => 'Falha ao enviar o cartão de contacto';

  @override
  String get chatFavoriteSuccess => 'Adicionado aos Favoritos';

  @override
  String get chatFavoriteFailed => 'Falha ao adicionar aos favoritos';

  @override
  String get chatLoadFailed => 'Falha ao carregar';

  @override
  String get chatImageMessage => '[Imagem]';

  @override
  String get chatVoiceMessage => '[Áudio]';

  @override
  String get chatVideoMessage => '[Vídeo]';

  @override
  String get chatFileMessage => '[Ficheiro]';

  @override
  String get chatLocationMessage => '[Localização]';

  @override
  String get chatContactCardMessage => '[Contacto]';

  @override
  String get chatCallLogMessage => '[Chamada]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Lida por $count';
  }

  @override
  String get chatUnread => 'Não lida';

  @override
  String get chatRecalledSelf => 'Retirou uma mensagem';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender retirou uma mensagem';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Tradução: $translation';
  }

  @override
  String get chatMessageDeleted => 'Mensagem eliminada';

  @override
  String get chatPeer => 'Outra pessoa';

  @override
  String get chatSelf => 'Eu';

  @override
  String get chatGenericMessage => '[Mensagem]';

  @override
  String get chatVoiceHideText => 'Ocultar texto';

  @override
  String get chatVoiceShowText => 'Converter em texto';

  @override
  String get chatFileDefaultName => 'Ficheiro';

  @override
  String get chatContactDefaultName => 'Contacto';

  @override
  String get chatContactCardTitle => 'Cartão de contacto';

  @override
  String get chatCallMissed => 'Perdida';

  @override
  String get chatCallCancelled => 'Cancelada';

  @override
  String get chatCallRejected => 'Recusada';

  @override
  String get chatCallDisconnected => 'Desligada';

  @override
  String get chatCallEnded => 'Chamada encerrada';

  @override
  String get chatCallFailed => 'Falha na chamada';

  @override
  String chatCallDuration(String duration) {
    return 'Duração $duration';
  }

  @override
  String get chatVideoCallTitle => 'Chamada de vídeo';

  @override
  String get chatVoiceCallTitle => 'Chamada de voz';

  @override
  String get chatToolPhotos => 'Fotografias';

  @override
  String get chatToolCamera => 'Câmara';

  @override
  String get chatToolFile => 'Ficheiro';

  @override
  String get chatToolLocation => 'Localização';

  @override
  String get chatToolContactCard => 'Contacto';

  @override
  String get chatToolVoiceCall => 'Chamada de voz';

  @override
  String get chatToolVideoCall => 'Chamada de vídeo';

  @override
  String get chatToolFavorites => 'Favoritos';

  @override
  String get chatToolTranslate => 'Traduzir';

  @override
  String get chatTranslationChooseLanguage => 'Escolha o idioma de tradução';

  @override
  String get chatTranslationEnterText => 'Introduza o texto primeiro';

  @override
  String get chatTranslationMentionsUnsupported =>
      'A tradução está indisponível para mensagens com menções';

  @override
  String get chatTranslationScheduledUnsupported =>
      'A tradução está indisponível ao editar uma mensagem agendada';

  @override
  String get chatTranslationFailed => 'Falha na tradução. Tente de novo.';

  @override
  String get chatTranslationEmpty =>
      'Nenhuma tradução recebida. Tente de novo.';

  @override
  String get chatTranslationTranslating => 'A traduzir…';

  @override
  String get chatTranslationSend => 'Enviar tradução';

  @override
  String get chatTranslationSending => 'A enviar…';

  @override
  String get chatTranslationExpand => 'Mostrar mais';

  @override
  String get chatTranslationCollapse => 'Mostrar menos';

  @override
  String get chatFileTooLarge => 'O ficheiro ultrapassa o limite de 100 MB';

  @override
  String get chatInputMutedAdminOnly =>
      'Só o proprietário ou membros selecionados podem falar.';

  @override
  String get chatImageUploadUnsupported =>
      'Falha ao enviar a imagem. O apoio do servidor ainda não está disponível.';

  @override
  String get chatFavoriteLongPressHint =>
      'Segure uma mensagem para adicioná-la aos favoritos';

  @override
  String chatSelectedCount(int count) {
    return '$count selecionados';
  }

  @override
  String get chatLocationSheetTitle => 'Enviar localização';

  @override
  String get chatLocationNameLabel => 'Nome do lugar';

  @override
  String get chatLocationNameHint => 'Ex.: escritório, endereço do cliente';

  @override
  String get chatLocationAddressLabel => 'Endereço';

  @override
  String get chatLocationOptionalHint => 'Opcional';

  @override
  String get chatLocationLatitudeLabel => 'Latitude';

  @override
  String get chatLocationLatitudeHint => 'De -90 a 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitude';

  @override
  String get chatLocationLongitudeHint => 'De -180 a 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Introduza $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label está fora do intervalo';
  }

  @override
  String get chatLocationDefaultTitle => 'Localização';

  @override
  String get chatMutedFullNotice =>
      'Este grupo está silenciado. Só o proprietário ou membros selecionados podem falar.';

  @override
  String get chatNotFriendSendBlocked =>
      'Já não são amigos e não é possível enviar mensagens';

  @override
  String get chatPersonalNotesTitle => 'Notas pessoais';

  @override
  String get chatWorkNotesTitle => 'Notas de trabalho';

  @override
  String get chatPersonalNotesDescription =>
      'Registre pensamentos pessoais e informações importantes aqui\nSincronizados entre dispositivos, disponíveis a qualquer hora';

  @override
  String get chatWorkNotesDescription =>
      'Registre tarefas e guarde materiais de trabalho aqui\nOs espaços de equipa ficam separados e seguros';

  @override
  String get chatNoMessages => 'Sem mensagens';

  @override
  String chatReplyTo(String sender) {
    return 'Responder a $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature estará disponível em breve';
  }

  @override
  String get chatForwardSelectTitle => 'Escolha a conversa';

  @override
  String get chatContactSelectTitle => 'Escolha o contacto';

  @override
  String get chatNoContacts => 'Nenhum contacto';

  @override
  String get contactsTitle => 'Contactos';

  @override
  String get contactsSearch => 'Pesquisar contactos';

  @override
  String get contactsNewFriends => 'Novos amigos';

  @override
  String get contactsGroups => 'Grupos';

  @override
  String get contactsFavorites => 'Favoritos';

  @override
  String get contactsRecent => 'Recentes';

  @override
  String get contactsOrganization => 'Organização';

  @override
  String get contactsAnnouncement => 'Anúncios';

  @override
  String get contactsNewApplications => 'Novas solicitações';

  @override
  String get contactsCustomerGroups => 'Grupos de clientes';

  @override
  String get contactsAllCustomers => 'Todos os clientes';

  @override
  String get contactsMyCustomers => 'Meus clientes';

  @override
  String get contactsViewAll => 'Ver tudo';

  @override
  String get contactsMyContacts => 'Meus contactos';

  @override
  String get contactsMyAdvisor => 'Meu consultor';

  @override
  String get contactsNoAdvisor => 'Nenhum consultor atribuído ainda';

  @override
  String get contactsAdvisorLoading => 'A carregar…';

  @override
  String get contactsNavigateFailed => 'Falha na navegação. Tente de novo.';

  @override
  String get contactsEmpty => 'Nenhum contacto';

  @override
  String get contactsNoAnnouncement => 'Nenhum anúncio';

  @override
  String get contactsOfficialBadge => 'Oficial';

  @override
  String get contactsCustomerBadge => 'Cliente';

  @override
  String get contactsEmptyCustomers => 'Nenhum cliente';

  @override
  String get myTitle => 'Eu';

  @override
  String get myEnterpriseInfo => 'Informações da empresa';

  @override
  String get myEnterpriseManage => 'Gestão da empresa';

  @override
  String get myQrCode => 'Código QR';

  @override
  String get myFavorites => 'Favoritos';

  @override
  String get myLanguage => 'Idioma do Sistema';

  @override
  String get myTimezone => 'Fuso horário';

  @override
  String get myAutoTranslate => 'Tradução automática';

  @override
  String get myNetworkSwitch => 'Mudar Linha';

  @override
  String get mySettings => 'Definições';

  @override
  String get myLogout => 'Sair';

  @override
  String get myLogoutConfirm => 'Tem a certeza de que deseja sair?';

  @override
  String get myLeaveEnterprise => 'Sair da empresa';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Tem a certeza de que deseja sair desta empresa? O utilizador perderá o acesso aos dados da empresa.';

  @override
  String get myLeaveEnterpriseSuccess => 'Saiu da empresa';

  @override
  String get myLeaveEnterpriseFailed => 'Falha ao sair. Tente de novo.';

  @override
  String get myLppIdCopied => 'ID StartLink copiado';

  @override
  String myLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count contactos';
  }

  @override
  String get myAutoSelect => 'Automático';

  @override
  String get myPresenceStatus => 'Status de presença';

  @override
  String get myPresenceStatusTitle => 'Definir presença';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Ocupado';

  @override
  String get myPresenceAway => 'Ausente';

  @override
  String get myPresenceInvisible => 'Invisível';

  @override
  String get profileTitle => 'Informação do perfil';

  @override
  String get profileName => 'Nome';

  @override
  String get profileGender => 'Sexo';

  @override
  String get profileBirthday => 'Aniversário';

  @override
  String get profileRegion => 'Região';

  @override
  String get profileSignature => 'Biografia';

  @override
  String get profileSignatureHint => 'Conte um pouco sobre si';

  @override
  String get profileTapTapText => 'Toque';

  @override
  String get profileTapTapHint =>
      'Texto exibido ao receber um toque (máx. 20 caracteres)';

  @override
  String get profileAccountSection => 'Conta';

  @override
  String get profileBasicSection => 'Informações básicas';

  @override
  String get profileLppId => 'ID StartLink';

  @override
  String get profileLppIdNotSet => 'Não definido';

  @override
  String get profileMobile => 'Telefone';

  @override
  String get profileMobileUnbound => 'Não vinculado';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailUnbound => 'Não vinculado';

  @override
  String get profileQrCode => 'Meu código QR';

  @override
  String get profileChangePassword => 'Alterar palavra-passe';

  @override
  String get profileGenderMale => 'Masculino';

  @override
  String get profileGenderFemale => 'Feminino';

  @override
  String get profileGenderOther => 'Outros';

  @override
  String get profileGenderUnset => 'Não definido';

  @override
  String get profileSaveFailed => 'Falha ao guardar. Tente de novo.';

  @override
  String get profileLppIdTitle => 'ID StartLink';

  @override
  String get profileLppIdSetOnce =>
      'O ID StartLink só pode ser alterado uma vez. Escolha com cuidado.';

  @override
  String get profileLppIdChangeFailed =>
      'Falha na alteração (o ID StartLink só pode ser alterado uma vez)';

  @override
  String get profileChangePasswordOld => 'Palavra-passe atual';

  @override
  String get profileChangePasswordNew => 'Nova Senha';

  @override
  String get profileChangePasswordConfirm => 'Confirmar nova senha';

  @override
  String get profileChangePasswordMismatch => 'As palavras-passe não coincidem';

  @override
  String get profileChangePasswordSuccess =>
      'Palavra-passe alterada. Entre novamente.';

  @override
  String get profileChangePasswordFailed =>
      'Falha ao alterar a palavra-passe. Tente de novo.';

  @override
  String get settingsTitle => 'Definições';

  @override
  String get settingsSectionEnterprise => 'Empresa';

  @override
  String get settingsSectionAccount => 'Conta';

  @override
  String get settingsSectionGeneral => 'Geral';

  @override
  String get settingsSectionFeatures => 'Recursos';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsEnterpriseInfo => 'Informações da empresa';

  @override
  String get settingsProfile => 'Informação do perfil';

  @override
  String get settingsAccountSecurity => 'Segurança da conta';

  @override
  String get settingsNotification => 'Notificações';

  @override
  String get settingsDisplay => 'Exibição';

  @override
  String get settingsFriendPrivacy => 'Privacidade';

  @override
  String get settingsChat => 'Conversa';

  @override
  String get settingsChatHistory => 'Histórico de conversas';

  @override
  String get settingsAbout => 'Sobre o StartLink';

  @override
  String get settingsLanguage => 'Idioma do Sistema';

  @override
  String get settingsTimezone => 'Fuso horário';

  @override
  String get settingsAutoTranslate => 'Tradução automática';

  @override
  String get settingsNetworkSwitch => 'Mudar Linha';

  @override
  String get enterpriseInfoTitle => 'Informações da empresa';

  @override
  String get enterpriseName => 'Nome';

  @override
  String get enterpriseDescription => 'Descrição';

  @override
  String get enterpriseUpdateSuccess => 'Atualização bem-sucedida';

  @override
  String get enterpriseUpdateFailed => 'Falha na atualização. Tente de novo.';

  @override
  String get enterpriseLeave => 'Sair da empresa';

  @override
  String get enterpriseLeaveConfirm =>
      'Tem a certeza de que deseja sair desta empresa?';

  @override
  String get enterpriseLeaveSuccess => 'Saiu da empresa';

  @override
  String get enterpriseLeaveFailed => 'Falha ao sair. Tente de novo.';

  @override
  String get enterpriseLeaveOwnerError =>
      'O proprietário não pode sair diretamente. Transfira a propriedade primeiro.';

  @override
  String get enterpriseMemberCount => 'Membros';

  @override
  String get enterpriseCreatedAt => 'Criação';

  @override
  String get enterpriseCode => 'Código da empresa';

  @override
  String get enterpriseInviteMembers => 'Convidar membros';

  @override
  String get enterpriseCopyInviteCode => 'Copiar código de convite';

  @override
  String get enterpriseInviteCodeCopied => 'Código de convite copiado';

  @override
  String get groupCreateTitle => 'Novo grupo';

  @override
  String get groupNameHint => 'Introduza o nome do grupo';

  @override
  String get groupCreateSuccess => 'Grupo criado';

  @override
  String get groupCreateFailed => 'Falha ao criar o grupo';

  @override
  String get groupSettings => 'Definições do grupo';

  @override
  String get groupName => 'Nome do grupo';

  @override
  String get groupAvatar => 'Imagem do grupo';

  @override
  String get groupAnnouncement => 'Anúncio';

  @override
  String get groupMembers => 'Membros';

  @override
  String get groupAddMember => 'Adicionar membros';

  @override
  String get groupRemoveMember => 'Remover membro';

  @override
  String get groupRemoveMemberConfirm => 'Remover este membro?';

  @override
  String get groupSetAdmin => 'Definir como administrador';

  @override
  String get groupRemoveAdmin => 'Remover administrador';

  @override
  String get groupTransferOwner => 'Transferir propriedade';

  @override
  String get groupTransferOwnerConfirm =>
      'Transferir a propriedade do grupo para este membro?';

  @override
  String get groupTransferOwnerSuccess => 'Propriedade transferida';

  @override
  String get groupTransferOwnerFailed =>
      'Falha na transferência. Tente de novo.';

  @override
  String get groupLeave => 'Sair do grupo';

  @override
  String get groupLeaveConfirm => 'Sair deste grupo?';

  @override
  String get groupLeaveSuccess => 'Saiu do grupo';

  @override
  String get groupLeaveFailed => 'Falha ao sair. Tente de novo.';

  @override
  String get groupDissolve => 'Dissolver grupo';

  @override
  String get groupDissolveConfirm =>
      'Dissolver este grupo? Todos os membros serão removidos.';

  @override
  String get groupDissolveSuccess => 'Grupo dissolvido';

  @override
  String get groupDissolveFailed => 'Falha ao dissolver. Tente de novo.';

  @override
  String get groupQrCode => 'Código QR do grupo';

  @override
  String get groupMuteAll => 'Silenciar todos';

  @override
  String get groupMuteAllOn => 'Ativar silêncio para todos';

  @override
  String get groupMuteAllOff => 'Desativar silêncio para todos';

  @override
  String get groupAllowMemberInvite => 'Permitir convites por membros';

  @override
  String get groupAllowMemberModifyTitle =>
      'Permitir que membros alterem o nome do grupo';

  @override
  String get groupAllowMemberAtAll => 'Permitir que membros mencionem @Todos';

  @override
  String get groupAllowMemberViewMemberList =>
      'Permitir que membros vejam a lista de membros';

  @override
  String get groupAllowQrCodeJoin => 'Permitir entrada por código QR';

  @override
  String get groupRequireApproval => 'Exigir aprovação para entrar';

  @override
  String get groupAllowMemberAddFriend =>
      'Permitir que membros se adicionem como amigos';

  @override
  String get groupRoleOwner => 'Proprietário';

  @override
  String get groupRoleAdmin => 'Administrador';

  @override
  String get groupRoleMember => 'Membro';

  @override
  String get groupNoMembers => 'Nenhum membro';

  @override
  String get groupNoAnnouncements => 'Nenhum anúncio';

  @override
  String get groupCreateAnnouncement => 'Publicar anúncio';

  @override
  String get groupEditAnnouncement => 'Editar anúncio';

  @override
  String get groupDeleteAnnouncement => 'Eliminar anúncio';

  @override
  String get groupDeleteAnnouncementConfirm => 'Eliminar este anúncio?';

  @override
  String get groupAnnouncementTitle => 'Título';

  @override
  String get groupAnnouncementContent => 'Conteúdo';

  @override
  String get groupAnnouncementPin => 'Fixar anúncio';

  @override
  String groupMemberCount(int count) {
    return '$count membros';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count selecionados';
  }

  @override
  String get groupJoinRequestApprove => 'Aceitar';

  @override
  String get groupJoinRequestReject => 'Recusar';

  @override
  String get groupJoinRequests => 'Solicitações de entrada';

  @override
  String get groupNoJoinRequests => 'Nenhuma solicitação de entrada';

  @override
  String get groupReadReceipts => 'Confirmações de leitura';

  @override
  String groupReadCount(int count) {
    return '$count lidas';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count não lidas';
  }

  @override
  String get friendAddTitle => 'Adicionar contacto';

  @override
  String get friendSearchHint => 'Telefone / E-mail / ID StartLink';

  @override
  String get friendRequestSent => 'Solicitação de amizade enviada';

  @override
  String get friendRequestFailed => 'Falha ao enviar. Tente de novo.';

  @override
  String get friendAlreadyFriend => 'Já são contactos';

  @override
  String get friendNewFriendsTitle => 'Novos amigos';

  @override
  String get friendNoRequests => 'Nenhuma solicitação de amizade';

  @override
  String get friendAccept => 'Aceitar';

  @override
  String get friendReject => 'Recusar';

  @override
  String get friendAccepted => 'Aceita';

  @override
  String get friendRejected => 'Rejeitado';

  @override
  String get friendDeleteConfirm => 'Remover este contacto?';

  @override
  String get friendDeleteSuccess => 'Contacto removido';

  @override
  String get friendDeleteFailed => 'Falha ao remover. Tente de novo.';

  @override
  String get friendRemarkName => 'Alcunha';

  @override
  String get friendGroupName => 'Grupo';

  @override
  String get friendSendMessage => 'Mensagem';

  @override
  String get friendMatchTypeLppId => 'Encontrado pelo ID StartLink';

  @override
  String get friendMatchTypeMobile => 'Encontrado pelo telefone';

  @override
  String get friendMatchTypeEmail => 'Encontrado pelo e-mail';

  @override
  String get friendSearchEmpty => 'Nenhum utilizador encontrado';

  @override
  String get friendAddMessage => 'Gostaria de o adicionar aos meus contactos';

  @override
  String get friendBlockConfirm => 'Bloquear este utilizador?';

  @override
  String get friendUnblockConfirm => 'Desbloquear este utilizador?';

  @override
  String get friendBlockSuccess => 'Bloqueado';

  @override
  String get friendUnblockSuccess => 'Desbloqueado';

  @override
  String get profilePageTitle => 'Detalhes do perfil';

  @override
  String get profilePageSendMessage => 'Mensagem';

  @override
  String get profilePageAddFriend => 'Adicionar amigo';

  @override
  String get profilePageAlreadyFriend => 'Já são amigos';

  @override
  String get profilePageBlocked => 'Bloqueado';

  @override
  String get profilePageBlock => 'Bloquear';

  @override
  String get profilePageUnblock => 'Desbloquear';

  @override
  String get profilePageHidden => 'Este utilizador ocultou o perfil';

  @override
  String get profilePageFriendsOnly =>
      'Este utilizador mostra o perfil apenas para amigos';

  @override
  String get profilePageLppId => 'ID StartLink';

  @override
  String get profilePageRemarkName => 'Nota';

  @override
  String get profilePageEditRemark => 'Editar alcunha';

  @override
  String get profilePageSaveRemarkSuccess => 'Alcunha guardado';

  @override
  String get profilePageSaveRemarkFailed => 'Falha ao guardar. Tente de novo.';

  @override
  String get searchTitle => 'pesquisar';

  @override
  String get searchHint => 'Pesquisar por telefone, e-mail ou ID StartLink';

  @override
  String get searchNoResults => 'Nenhum resultado encontrado';

  @override
  String get searchMessages => 'Mensagem';

  @override
  String get searchUsers => 'Utilizadores';

  @override
  String get searchFailed => 'Falha na pesquisa. Tente de novo.';

  @override
  String get scanTitle => 'Ler código';

  @override
  String get scanFailed => 'Falha no reconhecimento. Tente de novo.';

  @override
  String get scanInvalidQrCode => 'Código QR inválido';

  @override
  String get scanFlashOn => 'Ligar lanterna';

  @override
  String get scanFlashOff => 'Desligar lanterna';

  @override
  String get scanAlbum => 'Escolher do álbum';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesEmpty => 'Sem favoritos';

  @override
  String get favoritesAll => 'Todos';

  @override
  String get favoritesText => 'Texto';

  @override
  String get favoritesImage => 'Imagens';

  @override
  String get favoritesVideo => 'Vídeo';

  @override
  String get favoritesVoice => 'Áudios';

  @override
  String get favoritesFile => 'Ficheiros';

  @override
  String get favoritesOther => 'Outros';

  @override
  String get favoritesDeleteConfirm => 'Remover dos favoritos?';

  @override
  String get favoritesDeleteSuccess => 'Favorito removido com sucesso';

  @override
  String get favoritesDeleteFailed => 'Falha ao remover';

  @override
  String get favoritesOriginalRecalled => 'Mensagem retirada';

  @override
  String get favoritesViewOriginal => 'Ver original';

  @override
  String get favoritesSearchHint => 'Pesquisar favoritos';

  @override
  String get favoritesNoResults => 'Nenhum favorito correspondente';

  @override
  String get noticeTitle => 'Anúncios';

  @override
  String get noticeEmpty => 'Nenhum anúncio';

  @override
  String get noticeDetail => 'Detalhes do anúncio';

  @override
  String get noticePublishedAt => 'Publicado';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Importante';

  @override
  String get noticePriorityUrgent => 'Urgente';

  @override
  String get organizationTitle => 'Organização';

  @override
  String get organizationEmpty => 'Nenhuma informação de departamento';

  @override
  String get organizationMembers => 'Membros';

  @override
  String get organizationDepartment => 'Departamento';

  @override
  String get organizationPosition => 'Cargo';

  @override
  String get organizationLeader => 'Responsável';

  @override
  String get qrCodeTitle => 'Meu código QR';

  @override
  String get qrCodeSave => 'guardar no álbum';

  @override
  String get qrCodeShare => 'Partilhar';

  @override
  String get qrCodeSaveSuccess => 'guardado no álbum';

  @override
  String get qrCodeSaveFailed => 'Falha ao guardar. Tente de novo.';

  @override
  String get qrCodeRefresh => 'Atualizar código QR';

  @override
  String get qrCodeExpired => 'Código QR expirado. Atualize.';

  @override
  String get qrCodeScanToAdd => 'Leia para me adicionar aos contactos';

  @override
  String get spacePersonal => 'Pessoal';

  @override
  String get spaceEnterprise => 'Empresa';

  @override
  String get spaceJoinByCode => 'Entrar com código da empresa';

  @override
  String get spaceJoinByInvite => 'Entrar com código de convite';

  @override
  String get spaceEnterCode => 'Introduza o código da empresa';

  @override
  String get spaceEnterInviteCode => 'Introduza o código de convite';

  @override
  String get spaceSearchEnterprise => 'Pesquisar empresa';

  @override
  String get spaceJoinRequestSent =>
      'Solicitação enviada, a aguardar aprovação';

  @override
  String get spaceJoinRequestPending => 'Aprovação pendente';

  @override
  String get spaceJoinRequestApproved => 'Solicitação aprovada';

  @override
  String get spaceJoinRequestRejected => 'Solicitação recusada';

  @override
  String get spaceAlreadyMember => 'Já é membro';

  @override
  String get spaceAutoApproved => 'Aprovado automaticamente. Boas-vindas!';

  @override
  String get spacePendingApprovalHint =>
      'Registo concluído. Sua solicitação de entrada foi enviada.';

  @override
  String get spaceNoSpaces => 'Nenhum espaço';

  @override
  String get spaceInviteExpired => 'Código de convite expirado';

  @override
  String get spaceInviteTargetMismatch =>
      'Este código de convite não é para a sua conta';

  @override
  String get spaceAcceptInviteSuccess => 'Entrada na empresa concluída';

  @override
  String get spaceAcceptInviteFailed => 'Falha ao entrar. Tente de novo.';

  @override
  String get spaceTenantSelectTitle => 'Selecione o espaço';

  @override
  String get spaceTenantSelectHint => 'Escolha um espaço para aceder a';

  @override
  String get spaceEnterPersonal => 'Aceder a espaço pessoal';

  @override
  String get spaceEnterEnterprise => 'Aceder a espaço da empresa';

  @override
  String get aboutTitle => 'Sobre o StartLink';

  @override
  String get aboutVersion => 'Versão';

  @override
  String get aboutTerms => 'Termos de Serviço';

  @override
  String get aboutPrivacy => 'Política de Privacidade';

  @override
  String get aboutOpenSource => 'Licenças de código aberto';

  @override
  String get aboutCheckUpdate => 'Verificar atualizações';

  @override
  String get aboutLatestVersion => 'Já é a versão mais recente';

  @override
  String get aboutUpdateAvailable => 'Nova versão disponível';

  @override
  String get aboutUpdateNow => 'Atualizar agora';

  @override
  String get aboutUpdateLater => 'Mais tarde';

  @override
  String get notificationTitle => 'Notificações';

  @override
  String get notificationGlobalMute => 'Não perturbe';

  @override
  String get notificationSound => 'Voz';

  @override
  String get notificationVibration => 'Vibração';

  @override
  String get notificationPreview => 'Prévia de mensagens';

  @override
  String get notificationDndStart => 'Início do Não perturbe';

  @override
  String get notificationDndEnd => 'Fim do Não perturbe';

  @override
  String get blacklistTitle => 'Lista negra';

  @override
  String get blacklistEmpty => 'Nenhum utilizador bloqueado';

  @override
  String get blacklistRemove => 'Desbloquear';

  @override
  String get blacklistRemoveConfirm => 'Desbloquear este utilizador?';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackTypeComplaint => 'Reclamação';

  @override
  String get feedbackTypeSuggestion => 'Sugestão';

  @override
  String get feedbackTypeBug => 'Relatar erro';

  @override
  String get feedbackContent => 'Descrição';

  @override
  String get feedbackContentHint =>
      'Descreva o seu problema ou sugestão em detalhes';

  @override
  String get feedbackContact => 'Contacto (opcional)';

  @override
  String get feedbackSubmit => 'Enviar';

  @override
  String get feedbackSuccess => 'Feedback enviado. Obrigado!';

  @override
  String get feedbackFailed => 'Falha ao enviar. Tente de novo.';

  @override
  String get networkTitle => 'Mudar Linha';

  @override
  String get networkAutoSelect => 'Automático';

  @override
  String get networkManual => 'Manual';

  @override
  String get timezoneTitle => 'Fuso horário';

  @override
  String get timezoneAuto => 'Seguir o sistema';

  @override
  String get autoTranslateTitle => 'Tradução automática';

  @override
  String get autoTranslateEnabled => 'Ativar tradução automática';

  @override
  String get autoTranslateLanguage => 'Idioma de destino';

  @override
  String get displayTitle => 'Exibição';

  @override
  String get displayFontSize => 'Tamanho da Fonte';

  @override
  String get displayChatBackground => 'Plano de fundo da conversa';

  @override
  String get displayDarkMode => 'Aparência';

  @override
  String get displayDarkModeSystem => 'Seguir o sistema';

  @override
  String get displayDarkModeSystemHint =>
      'Alternar automaticamente conforme a definição do sistema';

  @override
  String get displayDarkModeOff => 'Claro';

  @override
  String get displayDarkModeOffHint => 'Usar sempre o tema claro';

  @override
  String get displayDarkModeOn => 'Escuro';

  @override
  String get displayDarkModeOnHint => 'Usar sempre o tema escuro';

  @override
  String get chatSettingsTitle => 'Conversa';

  @override
  String get chatHistoryTitle => 'Histórico de conversas';

  @override
  String get chatHistoryClear => 'Limpar todo o histórico';

  @override
  String get chatHistoryClearConfirm =>
      'Limpar todo o histórico de conversas? Isso não pode ser desfeito.';

  @override
  String get chatHistoryClearSuccess => 'Histórico de conversas limpo';

  @override
  String get accountSecurityTitle => 'Segurança da conta';

  @override
  String get accountSecurityChangePassword => 'Alterar palavra-passe';

  @override
  String get accountSecurityChangeMobile => 'Alterar número de telemóvel';

  @override
  String get accountSecurityChangeEmail => 'Alterar e-mail';

  @override
  String get accountSecurityLoggedDevices => 'Dispositivos ligados';

  @override
  String get accountSecurityDeactivate => 'Eliminar conta';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Todos os dados serão eliminados permanentemente após 7 dias. Eliminar a conta?';

  @override
  String get loggedDevicesTitle => 'Dispositivos ligados';

  @override
  String get loggedDevicesCurrent => 'Este dispositivo';

  @override
  String get loggedDevicesRevoke => 'Sair';

  @override
  String get loggedDevicesRevokeConfirm => 'Sair deste dispositivo?';

  @override
  String get loggedDevicesRevokeSuccess => 'Dispositivo desligado';

  @override
  String get loggedDevicesRevokeFailed => 'Falha. Tente de novo.';

  @override
  String get loggedDevicesLastActive => 'Última atividade';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Desktop';

  @override
  String get loggedDevicesTypeUnknown => 'Dispositivo desconhecido';

  @override
  String get privacySettingsTitle => 'Privacidade';

  @override
  String get privacySearchableByMobile =>
      'Permitir pesquisa pelo número de telefone';

  @override
  String get privacySearchableByLppId => 'Permitir pesquisa pelo ID StartLink';

  @override
  String get privacyAllowFriendRequest => 'Permitir solicitações de amizade';

  @override
  String get privacyProfileVisibility => 'Visibilidade do perfil';

  @override
  String get privacyEveryone => 'Todos';

  @override
  String get privacyFriendsOfFriends => 'Amigos de amigos';

  @override
  String get privacyNobody => 'Ninguém';

  @override
  String get privacyFriendsOnly => 'Somente amigos';

  @override
  String get privacySaveSuccess => 'Definições guardadas';

  @override
  String get privacySaveFailed => 'Falha ao guardar. Tente de novo.';

  @override
  String get fontSizeTitle => 'Tamanho da Fonte';

  @override
  String get fontSizeSmall => 'Pequeno';

  @override
  String get fontSizeNormal => 'Padrão';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get fontSizeExtraLarge => 'Extra Grande';

  @override
  String get fontSizePreview => 'Prévia';

  @override
  String get chatBackgroundTitle => 'Plano de fundo da conversa';

  @override
  String get chatBackgroundDefault => 'Padrão';

  @override
  String get chatBackgroundCustom => 'Personalizado';

  @override
  String get chatBackgroundReset => 'Restaurar predefinições';

  @override
  String get termsTitle => 'Termos de Serviço';

  @override
  String get privacyPolicyTitle => 'Política de Privacidade';

  @override
  String get recentContactsTitle => 'Recentes';

  @override
  String get recentContactsEmpty => 'Nenhum contacto recente';

  @override
  String get inviteFriendsTitle => 'Convidar amigos';

  @override
  String get inviteFriendsCopyLink => 'Copiar link de convite';

  @override
  String get inviteFriendsLinkCopied => 'Link de convite copiado';

  @override
  String get imageViewerTitle => 'Fotografia';

  @override
  String get imageViewerSave => 'guardar no álbum';

  @override
  String get imageViewerSaveSuccess => 'guardado no álbum';

  @override
  String get imageViewerSaveFailed => 'Falha ao guardar. Tente de novo.';

  @override
  String get customerServiceTitle => 'Central de atendimento';

  @override
  String get customerServiceQueue => 'Na fila';

  @override
  String get customerServiceActive => 'Ativas';

  @override
  String get customerServiceClaim => 'Aceitar';

  @override
  String get customerServiceTakeover => 'Assumir';

  @override
  String get customerServiceClose => 'Encerrar atendimento';

  @override
  String get customerServiceCloseConfirm =>
      'Encerrar esta sessão de atendimento?';

  @override
  String get customerServiceNoQueue => 'Nenhuma sessão na fila';

  @override
  String get customerServiceNoActive => 'Nenhuma sessão ativa';

  @override
  String get customerServiceVisitor => 'Visitante';

  @override
  String get customerServiceCustomer => 'Cliente';

  @override
  String get customerServiceAssignedTo => 'Atribuído a';

  @override
  String get customerServiceTransferConversation => 'Transferir conversa';

  @override
  String get marketingToolbar => 'Ferramentas de marketing';

  @override
  String get callIncoming => 'Chamada recebida';

  @override
  String get callOutgoing => 'Chamada efetuada';

  @override
  String get callAccept => 'Aceitar';

  @override
  String get callReject => 'Recusar';

  @override
  String get callHangup => 'Encerrar';

  @override
  String get callMissed => 'Chamada perdida';

  @override
  String get callDuration => 'Duração';

  @override
  String get callAudio => 'Chamada de voz';

  @override
  String get callGeneric => 'Chamada';

  @override
  String get callVideo => 'Chamada de vídeo';

  @override
  String get callConnecting => 'A ligar…';

  @override
  String get callRinging => 'Chamando…';

  @override
  String get callEnded => 'Chamada encerrada';

  @override
  String get callFailed => 'Falha na chamada';

  @override
  String get callRejected => 'Chamada recusada';

  @override
  String get callTimeout => 'Sem resposta';

  @override
  String get callCancelled => 'Cancelada';

  @override
  String get callUnknownPeer => 'Desconhecido';

  @override
  String get callVideoInvitation => 'Convite para chamada de vídeo';

  @override
  String get callAudioInvitation => 'Convite para chamada de voz';

  @override
  String get callAnswerAudio => 'Atender com áudio';

  @override
  String get callAnswerVideo => 'Atender com vídeo';

  @override
  String get callViewProfile => 'Ver perfil';

  @override
  String get callOpeningCamera => 'A abrir câmara…';

  @override
  String get callWaitingRemoteVideo => 'A aguardar o vídeo da outra pessoa…';

  @override
  String get callCameraOff => 'Câmara desligada';

  @override
  String get callCameraOn => 'Câmara ligada';

  @override
  String get callMicrophoneOff => 'Microfone desligado';

  @override
  String get callMicrophoneOn => 'Microfone ligado';

  @override
  String get callSpeakerOff => 'Altifalante desligado';

  @override
  String get callSpeakerOn => 'Altifalante ligado';

  @override
  String get callVideoPermissionFailure =>
      'Não foi possível iniciar a chamada de vídeo. Verifique as permissões de câmara e microfone e tente de novo.';

  @override
  String get callAudioPermissionFailure =>
      'Não foi possível iniciar a chamada de voz. Verifique a permissão do microfone e tente de novo.';

  @override
  String get callIncompleteIncoming =>
      'As informações da chamada recebida estão incompletas e não é possível atendê-la.';

  @override
  String get callInProgress => 'Em chamada';

  @override
  String get callCalling => 'Chamando…';

  @override
  String callEndedMedia(String media) {
    return '$media encerrada';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media recusada';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media não atendida';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media cancelada';
  }

  @override
  String get callConnectionLost => 'Ligação da chamada perdida';

  @override
  String get callAdminEnded => 'Chamada encerrada por um administrador';

  @override
  String callFailedMedia(String media) {
    return 'Falha em $media';
  }

  @override
  String get callBusy => 'A outra pessoa está ocupada';

  @override
  String callDurationValue(String duration) {
    return 'Duração da chamada $duration';
  }

  @override
  String get callNotConnected => 'Não ligada';

  @override
  String get callDialed => 'Efetuada';

  @override
  String get callAnswered => 'Atendida';

  @override
  String get callRejectedByPeer => 'Recusada pela outra pessoa';

  @override
  String get callRejectedBySelf => 'Rejeitado';

  @override
  String get callPeerDidNotAnswer => 'A outra pessoa não atendeu';

  @override
  String get callMissedIncoming => 'Chamada recebida perdida';

  @override
  String get callPeerCancelled => 'Cancelada pela outra pessoa';

  @override
  String get notificationNewMessageTitle => 'Nova mensagem StartLink';

  @override
  String get notificationOnlineServiceTitle => 'Nova mensagem de atendimento';

  @override
  String get notificationNewMessageBody => 'Recebeu uma nova mensagem';

  @override
  String get notificationImagePreview => 'Enviou uma imagem';

  @override
  String get notificationVideoPreview => 'Enviou um vídeo';

  @override
  String get notificationVoicePreview => 'Enviou uma mensagem de voz';

  @override
  String get notificationFilePreview => 'Enviou um ficheiro';

  @override
  String get notificationContactPreview => 'Enviou um cartão de contacto';

  @override
  String get notificationCallLogPreview => 'Enviou um registo de chamada';

  @override
  String get notificationLocationPreview => 'Compartilhou uma localização';

  @override
  String get notificationLinkPreview => 'Compartilhou um link';

  @override
  String notificationMentionMe(String body) {
    return 'Mencionou-o: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender mencionou-o: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Mencionou todos: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender mencionou todos: $body';
  }

  @override
  String get notificationSecurityTitle => 'Alerta de segurança da conta';

  @override
  String get notificationSecurityBody =>
      'As definições de segurança da a sua conta StartLink mudaram. Verifique agora.';

  @override
  String get notificationFriendAcceptedTitle => 'Solicitação de amizade aceita';

  @override
  String get notificationFriendRejectedTitle =>
      'Solicitação de amizade recusada';

  @override
  String get notificationFriendAcceptedBody =>
      'A outra pessoa aceitou sua solicitação de amizade';

  @override
  String get notificationFriendRejectedBody =>
      'A outra pessoa recusou sua solicitação de amizade';

  @override
  String get notificationVideoCallTitle => 'Convite para chamada de vídeo';

  @override
  String get notificationAudioCallTitle => 'Convite para chamada de voz';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller convidou-o para uma chamada de vídeo';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller convidou-o para uma chamada de voz';
  }

  @override
  String get notificationMessageChannelName => 'Mensagens';

  @override
  String get notificationMessageChannelDescription =>
      'Mensagens de conversa, registos de chamadas e alertas do sistema';

  @override
  String get notificationCallChannelName => 'Chamadas';

  @override
  String get notificationCallChannelDescription =>
      'Alertas de chamadas de voz e vídeo';

  @override
  String get notificationSecurityChannelName => 'Segurança da conta';

  @override
  String get notificationSecurityChannelDescription =>
      'Alertas de login e alterações de palavra-passe ou número de telemóvel';

  @override
  String get notificationUnknownCaller => 'Chamador desconhecido';

  @override
  String get pendingJoinRequestsTitle => 'Novas solicitações';

  @override
  String get pendingJoinRequestsEmpty => 'Nenhuma solicitação';

  @override
  String get pendingJoinRequestApprove => 'Aceitar';

  @override
  String get pendingJoinRequestReject => 'Recusar';

  @override
  String get pendingJoinRequestApproveSuccess => 'Aprovada';

  @override
  String get pendingJoinRequestRejectSuccess => 'Recusada';

  @override
  String get pendingJoinRequestFailed => 'Falha na operação. Tente de novo.';

  @override
  String get myCustomersTitle => 'Meus clientes';

  @override
  String get myCustomersEmpty => 'Nenhum cliente';

  @override
  String get groupListTitle => 'Grupos';

  @override
  String get groupListEmpty => 'Nenhum grupo';

  @override
  String get addFriendTitle => 'Adicionar contacto';

  @override
  String get addFriendSearchHint => 'Telefone / E-mail / ID StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String get addFriendButton => 'Adicionar';

  @override
  String get addFriendCannotAddSelf => 'Não pode adicionar a si mesmo';

  @override
  String get addFriendUnsupportedUser =>
      'Este utilizador não pode ser adicionado. Pode enviar mensagens diretamente.';

  @override
  String get addFriendMessageHint => 'Introduza uma mensagem';

  @override
  String get addFriendSendRequest => 'Enviar solicitação';

  @override
  String get joinCompanyTitle => 'Entrar em empresa';

  @override
  String get joinCompanyCodeHint => 'Introduza o código da empresa';

  @override
  String get joinCompanySearchHint => 'Pesquisar nome da empresa';

  @override
  String get joinCompanyApply => 'Solicitar entrada';

  @override
  String get joinCompanyApplySuccess => 'Solicitação enviada';

  @override
  String get joinCompanyApplyFailed => 'Falha ao solicitar. Tente de novo.';

  @override
  String get joinCompanyAutoApproved =>
      'Aprovado automaticamente. Boas-vindas!';

  @override
  String get joinCompanyPending => 'Solicitação enviada, a aguardar aprovação';

  @override
  String get joinCompanyInviteCodeHint => 'Introduza o código de convite';

  @override
  String get joinCompanyAcceptInvite => 'Aceitar convite';

  @override
  String get joinCompanyNoResults => 'Nenhuma empresa encontrada';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count membros';
  }

  @override
  String get timezoneNameHawaii => 'Havaí';

  @override
  String get timezoneNameAlaska => 'Alasca';

  @override
  String get timezoneNamePacificTime => 'Horário do Pacífico';

  @override
  String get timezoneNameMountainTime => 'Horário das Montanhas';

  @override
  String get timezoneNameCentralTime => 'Horário Central';

  @override
  String get timezoneNameEasternTime => 'Horário do Leste';

  @override
  String get timezoneNameAtlanticTime => 'Horário do Atlântico';

  @override
  String get timezoneNameBrasilia => 'Brasília';

  @override
  String get timezoneNameAzores => 'Açores';

  @override
  String get timezoneNameLondonDublin => 'Londres/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlim/Paris/Roma';

  @override
  String get timezoneNameCairoHelsinki => 'Cairo/Helsinque';

  @override
  String get timezoneNameMoscowRiyadh => 'Moscou/Riad';

  @override
  String get timezoneNameTehran => 'Teerã';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Baku';

  @override
  String get timezoneNameKabul => 'Cabul';

  @override
  String get timezoneNameKarachiTashkent => 'Carachi/Tashkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/Nova Délhi';

  @override
  String get timezoneNameKathmandu => 'Catmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Daca/Almaty';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanói/Jacarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Pequim/Xangai/Hong Kong/Taipé';

  @override
  String get timezoneNameTokyoSeoul => 'Tóquio/Seul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Ilhas Salomão';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute =>
      'Selecionar a melhor rota automaticamente';

  @override
  String get networkTesting => 'A testar…';

  @override
  String get networkTestingShort => 'A testar';

  @override
  String networkLatencyMs(int ms) {
    return 'Latência $ms ms';
  }

  @override
  String get networkConnectionMode => 'Modo de ligação';

  @override
  String get networkDirectMode => 'Modo direto';

  @override
  String get networkProxyMode => 'Modo proxy';

  @override
  String get networkDirectModeDesc => 'Ligar diretamente ao servidor';

  @override
  String get networkProxyModeDesc => 'Ligar por um servidor proxy';

  @override
  String get networkDirectRoutes => 'Rotas diretas';

  @override
  String get networkProxyRoutes => 'Rotas proxy';

  @override
  String get networkTestAll => 'Testar todas';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Nó de Hong Kong';

  @override
  String get networkSingaporeNode => 'Nó de Singapura';

  @override
  String get networkJapanNode => 'Nó do Japão';

  @override
  String get networkUnitedStatesNode => 'Nó dos Estados Unidos';

  @override
  String get networkHint =>
      'Dicas:\n• Modo direto: mais rápido e adequado ao uso nacional\n• Modo proxy: mais estável para comunicação internacional\n• Toque no ícone de atualizar para testar a latência de uma rota';

  @override
  String get teenModeTitle => 'Modo adolescente';

  @override
  String get teenModeStatusOn => 'Ativado';

  @override
  String get teenModeStatusOff => 'Desativado';

  @override
  String get teenModeStatusLoading => 'A carregar';

  @override
  String get teenModeUnavailable =>
      'O status do modo adolescente está temporariamente indisponível';

  @override
  String get teenModeInvalidResponse =>
      'O modo adolescente retornou uma resposta inválida';

  @override
  String get teenModeEnableDescription =>
      'As regras da plataforma limitarão o tempo de uso e alguns recursos.';

  @override
  String get teenModePasscode => 'Código de acesso';

  @override
  String get teenModeCurrentPasscode => 'Código de acesso atual';

  @override
  String get teenModeNewPasscode => 'Novo código de acesso';

  @override
  String get teenModePasscodeHint => 'Introduza de 4 a 6 dígitos';

  @override
  String get teenModeEnable => 'Ativar modo adolescente';

  @override
  String get teenModeDisable => 'Desativar modo adolescente';

  @override
  String get teenModeChangePasscode => 'Alterar código de acesso';

  @override
  String get teenModeSource => 'Ativado por';

  @override
  String get teenModeDailyUsage => 'Usado hoje';

  @override
  String get teenModeRemaining => 'Tempo restante';

  @override
  String get teenModeMinutesUnit => 'Minutos';

  @override
  String get teenModeUnlimited => 'Ilimitado';

  @override
  String get teenModeRequestExtension => 'Solicitar mais tempo';

  @override
  String get teenModeExtensionSubmitted =>
      'A solicitação de tempo foi enviada a um responsável';

  @override
  String get teenModeTimeLimitReached => 'O limite de uso de hoje foi atingido';

  @override
  String get teenModeCurfewActive => 'Este é um período de uso restrito';

  @override
  String get teenModeReliefHint =>
      'Ainda pode ver o histórico, contactar o apoio oficial e relatar problemas.';

  @override
  String get teenModeRestrictedNotice =>
      'O modo adolescente impede o envio de mensagens no momento';

  @override
  String get teenModeActionBlocked =>
      'O modo adolescente impede esta ação no momento';

  @override
  String get teenModeMyRequests => 'Minhas solicitações';

  @override
  String get guardianCenterTitle => 'Central de responsáveis';

  @override
  String get guardianRelationships => 'Vínculos com responsáveis';

  @override
  String get guardianMinors => 'Crianças sob minha supervisão';

  @override
  String get guardianApprovals => 'Aprovações pendentes';

  @override
  String get guardianBind => 'Introduza o código de vínculo';

  @override
  String get guardianCreateMinorCode => 'Sou menor — criar código';

  @override
  String get guardianCreateGuardianCode => 'Sou responsável — criar código';

  @override
  String get guardianRelation => 'Relacionamento';

  @override
  String get guardianPrimary => 'Responsável principal';

  @override
  String get guardianCode => 'Código de vínculo de 6 dígitos';

  @override
  String get guardianCodeHint =>
      'Introduza o código fornecido pela outra pessoa';

  @override
  String get guardianCodeCreated => 'Código criado. Partilhe antes de expirar.';

  @override
  String get guardianEmpty => 'Nenhum vínculo com responsáveis';

  @override
  String get guardianNoMinors => 'Nenhuma criança supervisionada';

  @override
  String get guardianUnbind => 'Remover vínculo';

  @override
  String get guardianExtend => 'Adicionar tempo para a criança';

  @override
  String get guardianPolicyTitle => 'Regras de uso';

  @override
  String get guardianPolicyLocked => 'Bloqueado pela plataforma';

  @override
  String get approvalEmpty => 'Nenhuma solicitação';

  @override
  String get approvalApprove => 'Aceitar';

  @override
  String get approvalReject => 'Recusar';

  @override
  String get approvalPending => 'Pendente';

  @override
  String get approvalApproved => 'Aprovada';

  @override
  String get approvalRejected => 'Rejeitado';

  @override
  String get approvalExpired => 'Expirado';

  @override
  String get approvalCancelled => 'Cancelado';

  @override
  String get approvalReplayFailed => 'A ação original falhou. Tente de novo.';

  @override
  String get requestCancelled => 'Solicitação cancelada';

  @override
  String get kycTitle => 'Autenticação de Nome Real';

  @override
  String get kycNotRequired => 'A verificação de identidade não é necessária';

  @override
  String get kycVerified => 'Identidade verificada';

  @override
  String get kycDeclared => 'Informações de identidade enviadas';

  @override
  String get kycPending => 'Em análise';

  @override
  String get kycRejected => 'Verificação recusada';

  @override
  String get kycNone => 'Nenhuma informação de identidade enviada';

  @override
  String get kycRealName => 'Nome Real';

  @override
  String get kycIdNumber => 'Número do Documento';

  @override
  String get kycIdType => 'Tipo de documento';

  @override
  String get kycApplicability =>
      'Introduza seus dados reais para o documento selecionado. Os tipos aceitos aparecem na lista.';

  @override
  String get kycCamera => 'Tirar fotografia';

  @override
  String get kycGallery => 'Escolher da galeria';

  @override
  String get kycPhotoLimit => 'Máximo por fotografia';

  @override
  String get kycSelectPhoto => 'Selecionar foto';

  @override
  String get kycPhotoSelected => 'Selecionada';

  @override
  String get kycViewPhoto => 'Toque para ver a fotografia';

  @override
  String get kycReplacePhoto => 'Escolher outra fotografia';

  @override
  String get kycDisclosure =>
      'Usamos seu nome, número do documento e fotografias do documento para verificar sua identidade. Sem essas informações, não é possível enviar a solicitação e alguns recursos restritos podem ficar indisponíveis.';

  @override
  String get kycConsent =>
      'Dou consentimento específico para este tratamento das informações de identidade';

  @override
  String get kycConsentRequired =>
      'Forneça consentimento específico antes de enviar';

  @override
  String get kycResubmitTitle => 'Reenviar informações de identidade';

  @override
  String get kycResubmitWarning =>
      'O novo envio substituirá sua solicitação pendente. Continuar?';

  @override
  String get kycSubmitting => 'A enviar';

  @override
  String get kycSubmitFailed => 'Falha ao enviar. Tente de novo.';

  @override
  String get kycSubmitUnavailable =>
      'Não é possível enviar informações de identidade agora';

  @override
  String get kycResubmitNotAllowed =>
      'O reenvio não está disponível após uma recusa. Contacte o apoio se necessário.';

  @override
  String get kycDailyLimit =>
      'Atingiu o limite de envios de hoje. Tente amanhã.';

  @override
  String get kycTypeUnavailable =>
      'Nenhum tipo de documento disponível. Tente mais tarde.';

  @override
  String get kycNameInvalid => 'O nome legal deve ter de 2 a 64 caracteres';

  @override
  String get kycNumberRequired => 'Introduza o número do documento';

  @override
  String get kycFrontRequired => 'Envie a frente do documento';

  @override
  String get kycBackRequired => 'Envie o verso do documento';

  @override
  String get kycPhotoTooLarge =>
      'A fotografia ultrapassa o limite de tamanho. Comprima e tente de novo.';

  @override
  String get kycAccountChanged =>
      'A conta ou o espaço mudou. Reabra esta página.';

  @override
  String get kycPhotoInvalid => 'Escolha uma imagem válida';

  @override
  String get kycPortraitSide => 'Foto';

  @override
  String get kycEmblemSide => 'Emblema Nacional';

  @override
  String get kycPassportDataPage => 'Página de dados do passaporte';

  @override
  String get kycPassportOtherPage =>
      'Página de visto ou página em branco do passaporte';

  @override
  String get kycFront => 'Frente do Documento';

  @override
  String get kycBack => 'Verso do Documento';

  @override
  String get kycRequired =>
      'É necessário verificar a identidade antes de criar um grupo';

  @override
  String get kycGoVerify => 'Verificar agora';

  @override
  String get kycStatusUnknown =>
      'Status de identidade indisponível. Atualize mais tarde.';

  @override
  String get kycSuperseded =>
      'Um envio posterior substituiu este. Verifique seu status de identidade mais recente.';

  @override
  String get kycMediaNotFound =>
      'A fotografia do documento não está disponível neste espaço. Selecione novamente antes de enviar.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Envio em massa para clientes';

  @override
  String get officialAccountBadge => 'Oficial';

  @override
  String get officialAccountOpenConversation => 'Abrir conversa';

  @override
  String get officialAccountJoinHint =>
      'Ao adicionar esta conta, adere à empresa como cliente. Não é necessária aprovação de amizade.';

  @override
  String get officialAccountJoinDisabled =>
      'Esta empresa não está a aceitar novos clientes. Contacte o apoio.';

  @override
  String get officialAccountRemoved =>
      'Foi removido desta empresa. Peça à empresa que o convide novamente.';

  @override
  String get officialAccountBanned => 'Sua conta foi desativada nesta empresa.';

  @override
  String get officialAccountUnavailable =>
      'Esta conta oficial está indisponível no momento.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Não é permitido entrar em uma empresa no modo atual.';

  @override
  String get officialAccountPlatformRequired =>
      'Use uma conta da plataforma para adicionar esta conta oficial.';

  @override
  String get officialAccountOpenFailed =>
      'Não foi possível abrir a conversa. Tente de novo.';

  @override
  String get officialAccountAccountChanged =>
      'A conta ou o espaço mudou. Abra novamente.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'O diretório da empresa não está atualizado. Tente de novo dentro de instantes.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Falha ao sincronizar a conta oficial. O conteúdo local continua disponível.';

  @override
  String get officialAccountInboxSyncing =>
      'A sincronizar mensagens da conta oficial';

  @override
  String get diagnosticsTitle => 'Diagnóstico';

  @override
  String get diagnosticsExplanation =>
      'Os registos são expurgados e contêm informações operacionais e de erros desta conta e espaço, além de eventos públicos de arranque. O conteúdo das conversas e as credenciais são excluídos.';

  @override
  String get diagnosticsHour => 'Última hora';

  @override
  String get diagnosticsDay => 'Últimas 24 horas';

  @override
  String get diagnosticsWeek => 'Últimos 7 dias';

  @override
  String diagnosticsEventCount(int count) {
    return 'Eventos disponíveis: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Os registos são guardados neste dispositivo e continuam disponíveis após reiniciar.';

  @override
  String get diagnosticsNotPersistent =>
      'Alguns registos não foram guardados. Atualize para tentar novamente.';

  @override
  String get diagnosticsExport => 'Exportar e partilhar';

  @override
  String get diagnosticsRefresh => 'Atualizar';

  @override
  String get diagnosticsClear => 'Limpar registos deste espaço';

  @override
  String get diagnosticsClearConfirm =>
      'Limpar os registos de diagnóstico deste espaço? O histórico de conversas será mantido.';

  @override
  String get diagnosticsShared =>
      'Partilha do sistema concluída. Confirme o ficheiro na aplicação destinatária.';

  @override
  String get diagnosticsCancelled =>
      'Partilha cancelado. Pode exportar novamente.';

  @override
  String get diagnosticsUnconfirmed =>
      'Não foi possível confirmar a partilha. Verifique a aplicação destinatária.';

  @override
  String get diagnosticsFailed => 'Falha na operação. Tente de novo.';
}
