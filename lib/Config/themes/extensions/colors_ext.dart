import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';

extension ColorsExt on BuildContext {
  Color get primary => colors.primary;

  Color get onPrimary => colors.onPrimary;

  Color get secondary => colors.secondary;

  Color get textPrimaryColor => colors.onSurface;

  Color get textSecondaryColor => colors.onSecondary;

  Color get surface => colors.surface; //old background
  Color get onSurface => colors.onSurface;

  Color get onSurfaceVariant => colors.onSurfaceVariant;

  Color? get surfaceContainerHighest => colors.surfaceContainerHighest; //old surfaceVariant


  Color get disabledColor => colors.onSurface.withValues(alpha: .12);

  Color get dangerColor => colors.error;

  Color get error => colors.error;

  Color get primaryContainer => colors.primaryContainer;

  Color get outlineVariant => colors.outlineVariant;

  Color get outline => colors.outline;

  Color get cardColor => theme.cardColor;

  Color get dividerColor => theme.dividerColor;

  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  Color? get iconColor => theme.iconTheme.color;

  Color? get secondaryContainer => theme.colorScheme.secondaryContainer;

  Color? get onSecondaryContainer => theme.colorScheme.onSecondaryContainer;

}


