import 'package:flutter/material.dart';
import 'package:im_sdk/app/theme/theme.dart';

/// 通过 BuildContext 动态获取当前主题颜色
/// 用法：context.colors.background
extension AppThemeExtension on BuildContext {
  AppColorTokens get colors => AppColorTokens(this);
}

class AppColorTokens {
  final BuildContext _context;
  const AppColorTokens(this._context);

  ThemeData get _theme => Theme.of(_context);
  ColorScheme get _scheme => _theme.colorScheme;

  bool get isDark => _theme.brightness == Brightness.dark;

  // 背景色
  Color get background => _theme.scaffoldBackgroundColor;
  Color get backgroundChat =>
      isDark ? AppDarkColors.surface : AppColors.background;

  // 卡片/列表项背景
  Color get surface => _scheme.surface;
  Color get surfaceVariant => _scheme.surfaceContainerHighest;
  Color get elevatedSurface => _scheme.surfaceContainerHigh;

  // 文字
  Color get textPrimary => _scheme.onSurface;
  Color get textSecondary => _scheme.onSurfaceVariant;
  Color get textTertiary => _scheme.onSurface.withValues(alpha: 0.42);

  // 分割线
  Color get divider => _theme.dividerColor;

  // 主色
  Color get primary => _scheme.primary;
  Color get onPrimary => _scheme.onPrimary;

  // 消息气泡
  Color get selfBubble => _scheme.primaryContainer;
  Color get otherBubble => _scheme.surface;

  // 输入框背景
  Color get inputBackground => _scheme.surfaceContainerHighest;

  // 搜索框背景
  Color get searchBackground => _scheme.surfaceContainerHighest;

  // 危险色
  Color get danger => _scheme.error;
  Color get onDanger => _scheme.onError;
  Color get dangerContainer => _scheme.errorContainer;
  Color get onDangerContainer => _scheme.onErrorContainer;

  // 警告提示
  Color get warningContainer =>
      isDark ? const Color(0xFF4D3600) : const Color(0xFFFFF4E5);
  Color get onWarningContainer =>
      isDark ? const Color(0xFFFFD180) : const Color(0xFF8A4B00);

  // 图标色
  Color get icon => _scheme.onSurface;
  Color get iconSecondary => _scheme.onSurfaceVariant;

  // 遮罩与阴影
  Color get modalBarrier => _scheme.scrim.withValues(alpha: 0.42);
  Color get shadow => _scheme.shadow.withValues(alpha: isDark ? 0.32 : 0.08);
}
