import 'package:dio/dio.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// AppError sealed class 层级
// ---------------------------------------------------------------------------

sealed class AppError {
  const AppError();
}

/// 网络层错误（无连接、超时、DNS 失败等）
class NetworkError extends AppError {
  final String message;
  const NetworkError(this.message);

  @override
  String toString() => 'NetworkError($message)';
}

/// 服务端业务错误（HTTP 成功但 code != OK）
class ServerError extends AppError {
  final String code;
  final String message;
  final int? statusCode;
  final String? requestId;
  const ServerError({
    required this.code,
    required this.message,
    this.statusCode,
    this.requestId,
  });

  @override
  String toString() {
    final status = statusCode == null ? '' : ', HTTP $statusCode';
    final request = requestId == null ? '' : ', requestId=$requestId';
    return 'ServerError($code$status$request: $message)';
  }
}

/// 认证错误（需要重新登录或刷新 Token）
class AuthError extends AppError {
  final String code;
  const AuthError(this.code);

  @override
  String toString() => 'AuthError($code)';
}

// ---------------------------------------------------------------------------
// 错误码常量
// ---------------------------------------------------------------------------

abstract final class _ErrorCodes {
  // 认证类
  static const authInvalidCredentials = 'AUTH_INVALID_CREDENTIALS';
  static const authInvalidToken = 'AUTH_INVALID_TOKEN';
  static const authCaptchaRequired = 'AUTH_CAPTCHA_REQUIRED';
  static const authVerificationRequired = 'AUTH_VERIFICATION_REQUIRED';
  static const authEmailExists = 'AUTH_EMAIL_EXISTS';
  static const authMobileExists = 'AUTH_MOBILE_EXISTS';

  // 验证码类
  static const verifyTooFrequent = 'VERIFY_TOO_FREQUENT';
  static const verifyHourlyLimit = 'VERIFY_HOURLY_LIMIT';
  static const verifyDailyLimit = 'VERIFY_DAILY_LIMIT';

  // 租户类
  static const tenantNotMember = 'TENANT_NOT_MEMBER';
  static const tenantSuspended = 'TENANT_SUSPENDED';

  // 消息类
  static const msgGroupMuted = 'MSG_GROUP_MUTED';
  static const msgMemberMuted = 'MSG_MEMBER_MUTED';
  static const msgDuplicateClientMsgId = 'MSG_DUPLICATE_CLIENT_MSG_ID';

  // 青少年模式客户端合同校验
  static const teenInvalidResponse = 'TEEN_INVALID_RESPONSE';

  // 限流
  static const rateLimited = 'RATE_LIMITED';
}

// ---------------------------------------------------------------------------
// ErrorHandler
// ---------------------------------------------------------------------------

class ErrorHandler {
  ErrorHandler._();

  /// 将 DioException 转换为 AppError
  static AppError fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkError('请求超时，请检查网络连接');

      case DioExceptionType.connectionError:
        return const NetworkError('无法连接到服务器，请检查网络');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final body = e.response?.data;
        if (statusCode == 401) {
          if (body is Map<String, dynamic>) {
            final code = body['code'] as String?;
            if (code == _ErrorCodes.authInvalidCredentials) {
              return fromServerCode(
                code!,
                body['message'] as String? ?? '账号或密码错误',
                statusCode: statusCode,
                requestId: body['requestId'] as String?,
              );
            }
          }
          return const AuthError(_ErrorCodes.authInvalidToken);
        }
        if (body is Map<String, dynamic>) {
          final code = body['code'] as String? ?? 'SERVER_ERROR';
          final message = body['message'] as String? ?? '服务器错误';
          final requestId = body['requestId'] as String?;
          return fromServerCode(
            code,
            message,
            statusCode: statusCode,
            requestId: requestId,
          );
        }
        return NetworkError('服务器返回错误 (HTTP $statusCode)');

      case DioExceptionType.cancel:
        return const NetworkError('请求已取消');

      case DioExceptionType.unknown:
      default:
        return NetworkError(e.message ?? '未知网络错误');
    }
  }

  /// 将服务端业务错误码映射为 AppError
  ///
  /// 特殊规则：
  /// - [_ErrorCodes.msgDuplicateClientMsgId] 视为成功（幂等），调用方不应将其当作错误
  ///   但此处仍返回 ServerError，由上层（SendMessageUseCase）捕获并忽略。
  static AppError fromServerCode(
    String code,
    String message, {
    int? statusCode,
    String? requestId,
  }) {
    ServerError serverError() => ServerError(
          code: code,
          message: message,
          statusCode: statusCode,
          requestId: requestId,
        );

    switch (code) {
      // 认证错误 → AuthError（触发 Token 刷新或跳转登录）
      case _ErrorCodes.authInvalidCredentials:
      case _ErrorCodes.authInvalidToken:
        return AuthError(code);

      // 需要图形验证码 → ServerError（展示验证码弹窗）
      case _ErrorCodes.authCaptchaRequired:
        return serverError();

      // 需要短信/邮件验证码
      case _ErrorCodes.authVerificationRequired:
        return serverError();

      // 验证码发送过于频繁 → ServerError（禁用发送按钮，显示冷却提示）
      case _ErrorCodes.verifyTooFrequent:
      case _ErrorCodes.verifyHourlyLimit:
      case _ErrorCodes.verifyDailyLimit:
        return serverError();

      // 租户权限 → ServerError
      case _ErrorCodes.tenantNotMember:
      case _ErrorCodes.tenantSuspended:
        return serverError();

      // 消息禁言 → ServerError
      case _ErrorCodes.msgGroupMuted:
      case _ErrorCodes.msgMemberMuted:
        return serverError();

      // 重复 clientMsgId → 视为成功（幂等），返回特殊 ServerError 供上层识别
      case _ErrorCodes.msgDuplicateClientMsgId:
        return serverError();

      // 限流 → ServerError
      case _ErrorCodes.rateLimited:
        return serverError();

      // 其他未知错误码
      default:
        return serverError();
    }
  }

  /// 判断某个 ServerError 是否应视为幂等成功（重复消息 ID）
  static bool isDuplicateClientMsgId(AppError error) {
    return error is ServerError &&
        error.code == _ErrorCodes.msgDuplicateClientMsgId;
  }

  static String localizedMessage(
    AppError error,
    AppLocalizations l10n,
  ) {
    if (error is NetworkError) return error.message;
    if (error is AuthError) {
      switch (error.code) {
        case _ErrorCodes.authInvalidCredentials:
          return _localizedByLocale(
            l10n,
            zh: '账号或密码错误',
            zhTw: '帳號或密碼錯誤',
            en: 'Incorrect account or password',
            ja: 'アカウントまたはパスワードが正しくありません',
            ko: '계정 또는 비밀번호가 올바르지 않습니다',
            vi: 'Sai tài khoản hoặc mật khẩu',
          );
        case _ErrorCodes.authInvalidToken:
          return _localizedByLocale(
            l10n,
            zh: '登录已失效，请重新登录',
            zhTw: '登入已失效，請重新登入',
            en: 'Your session has expired. Please sign in again.',
            ja: 'ログインの有効期限が切れました。再度ログインしてください。',
            ko: '로그인이 만료되었습니다. 다시 로그인해 주세요.',
            vi: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
          );
      }
    }
    if (error is! ServerError) return error.toString();
    if (_isDuplicateEmail(error)) {
      return _localizedByLocale(
        l10n,
        zh: '该邮箱已注册，请直接登录',
        zhTw: '此電子郵件已註冊，請直接登入',
        en: 'This email is already registered. Please sign in.',
        ja: 'このメールアドレスは登録済みです。ログインしてください。',
        ko: '이미 등록된 이메일입니다. 로그인해 주세요.',
        vi: 'Email này đã được đăng ký. Vui lòng đăng nhập.',
      );
    }
    if (_isDuplicateMobile(error)) {
      return _localizedByLocale(
        l10n,
        zh: '该手机号已注册，请直接登录',
        zhTw: '此手機號碼已註冊，請直接登入',
        en: 'This mobile number is already registered. Please sign in.',
        ja: 'この携帯電話番号は登録済みです。ログインしてください。',
        ko: '이미 등록된 휴대폰 번호입니다. 로그인해 주세요.',
        vi: 'Số điện thoại này đã được đăng ký. Vui lòng đăng nhập.',
      );
    }
    switch (error.code) {
      case _ErrorCodes.authInvalidCredentials:
        return _localizedByLocale(
          l10n,
          zh: '账号或密码错误',
          zhTw: '帳號或密碼錯誤',
          en: 'Incorrect account or password',
          ja: 'アカウントまたはパスワードが正しくありません',
          ko: '계정 또는 비밀번호가 올바르지 않습니다',
          vi: 'Sai tài khoản hoặc mật khẩu',
        );
      case _ErrorCodes.authInvalidToken:
        return _localizedByLocale(
          l10n,
          zh: '登录已失效，请重新登录',
          zhTw: '登入已失效，請重新登入',
          en: 'Your session has expired. Please sign in again.',
          ja: 'ログインの有効期限が切れました。再度ログインしてください。',
          ko: '로그인이 만료되었습니다. 다시 로그인해 주세요.',
          vi: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
        );
      case _ErrorCodes.authCaptchaRequired:
        return _localizedByLocale(
          l10n,
          zh: '请先完成图形验证码',
          zhTw: '請先完成圖形驗證碼',
          en: 'Please complete the captcha first.',
          ja: '先に画像認証を完了してください。',
          ko: '먼저 캡차 인증을 완료해 주세요.',
          vi: 'Vui lòng hoàn thành mã xác thực hình ảnh trước.',
        );
      case _ErrorCodes.authVerificationRequired:
        return _localizedByLocale(
          l10n,
          zh: '请先获取并填写验证码',
          zhTw: '請先取得並填寫驗證碼',
          en: 'Please request and enter the verification code first.',
          ja: '先に認証コードを取得して入力してください。',
          ko: '먼저 인증 코드를 받아 입력해 주세요.',
          vi: 'Vui lòng lấy và nhập mã xác minh trước.',
        );
      case _ErrorCodes.verifyTooFrequent:
        return _localizedByLocale(
          l10n,
          zh: '验证码发送过于频繁，请稍后再试',
          zhTw: '驗證碼發送過於頻繁，請稍後再試',
          en: 'Verification requests are too frequent. Please try again later.',
          ja: '認証コードの送信が多すぎます。しばらくしてから再度お試しください。',
          ko: '인증 코드 요청이 너무 잦습니다. 잠시 후 다시 시도해 주세요.',
          vi: 'Yêu cầu mã xác minh quá thường xuyên. Vui lòng thử lại sau.',
        );
      case _ErrorCodes.verifyHourlyLimit:
        return _localizedByLocale(
          l10n,
          zh: '本小时验证码发送已达上限',
          zhTw: '本小時驗證碼發送已達上限',
          en: 'The hourly verification limit has been reached.',
          ja: '1時間あたりの認証コード送信上限に達しました。',
          ko: '시간당 인증 코드 전송 한도에 도달했습니다.',
          vi: 'Đã đạt giới hạn gửi mã xác minh trong giờ này.',
        );
      case _ErrorCodes.verifyDailyLimit:
        return _localizedByLocale(
          l10n,
          zh: '今日验证码发送已达上限',
          zhTw: '今日驗證碼發送已達上限',
          en: 'The daily verification limit has been reached.',
          ja: '本日の認証コード送信上限に達しました。',
          ko: '오늘 인증 코드 전송 한도에 도달했습니다.',
          vi: 'Đã đạt giới hạn gửi mã xác minh trong ngày.',
        );
      case _ErrorCodes.tenantNotMember:
        return _localizedByLocale(
          l10n,
          zh: '当前账号不属于该租户，请确认企业后再试',
          zhTw: '目前帳號不屬於該租戶，請確認企業後再試',
          en: 'This account does not belong to the selected tenant.',
          ja: 'このアカウントは選択したテナントに所属していません。',
          ko: '이 계정은 선택한 테넌트에 속해 있지 않습니다.',
          vi: 'Tài khoản này không thuộc tenant đã chọn.',
        );
      case _ErrorCodes.tenantSuspended:
        return _localizedByLocale(
          l10n,
          zh: '当前租户已停用，请联系管理员',
          zhTw: '目前租戶已停用，請聯絡管理員',
          en: 'The selected tenant has been suspended.',
          ja: '選択したテナントは停止されています。',
          ko: '선택한 테넌트가 비활성화되었습니다.',
          vi: 'Tenant đã chọn đã bị tạm ngưng.',
        );
      case _ErrorCodes.rateLimited:
        return _localizedByLocale(
          l10n,
          zh: '操作过于频繁，请稍后再试',
          zhTw: '操作過於頻繁，請稍後再試',
          en: 'Too many requests. Please try again later.',
          ja: '操作が多すぎます。しばらくしてから再度お試しください。',
          ko: '요청이 너무 많습니다. 잠시 후 다시 시도해 주세요.',
          vi: 'Thao tác quá thường xuyên. Vui lòng thử lại sau.',
        );
      case _ErrorCodes.teenInvalidResponse:
        return l10n.teenModeInvalidResponse;
      default:
        return error.message;
    }
  }

  static bool _isDuplicateEmail(ServerError error) {
    if (error.code == _ErrorCodes.authEmailExists) return true;
    final text = error.message.toLowerCase();
    return text.contains('email already registered') ||
        text.contains('email already exists') ||
        text.contains('邮箱已注册') ||
        text.contains('邮箱已经注册') ||
        text.contains('邮箱已存在');
  }

  static bool _isDuplicateMobile(ServerError error) {
    if (error.code == _ErrorCodes.authMobileExists) return true;
    final text = error.message.toLowerCase();
    return text.contains('mobile already registered') ||
        text.contains('mobile already exists') ||
        text.contains('phone already registered') ||
        text.contains('phone already exists') ||
        text.contains('手机号已注册') ||
        text.contains('手机号已经注册') ||
        text.contains('手机号已存在');
  }

  static String _localizedByLocale(
    AppLocalizations l10n, {
    required String zh,
    required String zhTw,
    required String en,
    required String ja,
    required String ko,
    required String vi,
  }) {
    final locale = l10n.localeName.toLowerCase();
    if (locale.startsWith('zh_tw')) return zhTw;
    if (locale.startsWith('zh')) return zh;
    if (locale.startsWith('ja')) return ja;
    if (locale.startsWith('ko')) return ko;
    if (locale.startsWith('vi')) return vi;
    return en;
  }
}
