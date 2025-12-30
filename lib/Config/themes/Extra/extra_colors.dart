import 'package:flutter/material.dart';

class ExtraColors extends ThemeExtension<ExtraColors> {
  final Color success;
  final Color warning;
  final Color info;

  const ExtraColors({
    required this.success,
    required this.warning,
    required this.info,
  });

  @override
  ExtraColors copyWith({Color? success, Color? warning, Color? info}) {
    return ExtraColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  ThemeExtension<ExtraColors> lerp(
      ThemeExtension<ExtraColors>? other,
      double t,
      ) {
    if (other is! ExtraColors) return this;
    return ExtraColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}
