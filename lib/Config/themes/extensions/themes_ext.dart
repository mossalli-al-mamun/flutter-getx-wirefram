import 'package:flutter/material.dart';

extension ThemesExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get texts => Theme.of(this).textTheme;
  Brightness get themeBrightness => Theme.of(this).brightness;
}