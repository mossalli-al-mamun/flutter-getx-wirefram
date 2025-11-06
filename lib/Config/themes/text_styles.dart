import 'package:flutter/material.dart';

class AppTextStyle {
  static BuildContext? _context;

  static void init(BuildContext context) => _context = context;

  static ThemeData get theme => Theme.of(_context!);

  static TextStyle get displayLarge => theme.textTheme.displayLarge!;
  static TextStyle get displayMedium => theme.textTheme.displayMedium!;
  static TextStyle get displaySmall => theme.textTheme.displaySmall!;

  static TextStyle get headlineLarge => theme.textTheme.headlineLarge!;
  static TextStyle get headlineMedium => theme.textTheme.headlineMedium!;
  static TextStyle get headlineSmall => theme.textTheme.headlineSmall!;

  static TextStyle get titleLarge => theme.textTheme.titleLarge!;
  static TextStyle get titleMedium => theme.textTheme.titleMedium!;
  static TextStyle get titleSmall => theme.textTheme.titleSmall!;

  static TextStyle get bodyLarge => theme.textTheme.bodyLarge!;
  static TextStyle get bodyMedium => theme.textTheme.bodyMedium!;
  static TextStyle get bodySmall => theme.textTheme.bodySmall!;

  static TextStyle get labelLarge => theme.textTheme.labelLarge!;
  static TextStyle get labelMedium => theme.textTheme.labelMedium!;
  static TextStyle get labelSmall => theme.textTheme.labelSmall!;
  static TextStyle get labelLargeBold => labelLarge.copyWith(fontWeight: FontWeight.bold);

}
