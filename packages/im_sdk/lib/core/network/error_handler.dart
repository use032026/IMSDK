import 'package:dio/dio.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:im_sdk/generated/l10n/sdk_resources.dart'
    show sdkNetworkErrorMessages;

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
          return _localizedByLocale(l10n, '账号或密码错误');
        case _ErrorCodes.authInvalidToken:
          return _localizedByLocale(l10n, '登录已失效，请重新登录');
      }
    }
    if (error is! ServerError) return error.toString();
    if (_isDuplicateEmail(error)) {
      return _localizedByLocale(l10n, '该邮箱已注册，请直接登录');
    }
    if (_isDuplicateMobile(error)) {
      return _localizedByLocale(l10n, '该手机号已注册，请直接登录');
    }
    switch (error.code) {
      case _ErrorCodes.authInvalidCredentials:
        return _localizedByLocale(l10n, '账号或密码错误');
      case _ErrorCodes.authInvalidToken:
        return _localizedByLocale(l10n, '登录已失效，请重新登录');
      case _ErrorCodes.authCaptchaRequired:
        return _localizedByLocale(l10n, '请先完成图形验证码');
      case _ErrorCodes.authVerificationRequired:
        return _localizedByLocale(l10n, '请先获取并填写验证码');
      case _ErrorCodes.verifyTooFrequent:
        return _localizedByLocale(l10n, '验证码发送过于频繁，请稍后再试');
      case _ErrorCodes.verifyHourlyLimit:
        return _localizedByLocale(l10n, '本小时验证码发送已达上限');
      case _ErrorCodes.verifyDailyLimit:
        return _localizedByLocale(l10n, '今日验证码发送已达上限');
      case _ErrorCodes.tenantNotMember:
        return _localizedByLocale(l10n, '当前账号不属于该租户，请确认企业后再试');
      case _ErrorCodes.tenantSuspended:
        return _localizedByLocale(l10n, '当前租户已停用，请联系管理员');
      case _ErrorCodes.rateLimited:
        return _localizedByLocale(l10n, '操作过于频繁，请稍后再试');
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

  // Source phrases identify the existing message; locale/fallback order stays here.
  static String _localizedByLocale(AppLocalizations l10n, String source) {
    final messages = sdkNetworkErrorMessages[source]!;
    final locale = l10n.localeName.toLowerCase();
    if (locale.startsWith('zh_tw')) return messages['zhTw']!;
    if (locale.startsWith('zh')) return messages['zh']!;
    if (locale.startsWith('ja')) return messages['ja']!;
    if (locale.startsWith('ko')) return messages['ko']!;
    if (locale.startsWith('vi')) return messages['vi']!;
    return messages[l10n.localeName] ??
        messages[l10n.localeName.replaceAll('-', '_')] ??
        messages[locale.split(RegExp('[-_]')).first] ??
        messages['en']!;
  }
}
