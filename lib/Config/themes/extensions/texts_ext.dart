import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';

extension TextsExt on BuildContext {
  TextStyle? get labelSmall => texts.labelSmall;
  TextStyle? get labelMedium => texts.labelMedium;
  TextStyle? get labelLarge => texts.labelLarge;
  TextStyle? get labelExtraLarge => texts.labelMedium?.copyWith(fontSize: 16);
  TextStyle? get titleLarge => texts.titleLarge;
  TextStyle? get titleLargeBold => texts.titleLarge?.copyWith(fontWeight: FontWeight.bold);
  TextStyle? get titleMedium => texts.titleMedium;
  TextStyle? get titleMediumBold => texts.titleMedium?.copyWith(fontWeight: FontWeight.bold);
  TextStyle? get titleSmall => texts.titleSmall;
  TextStyle? get titleExtraLarge => texts.titleMedium?.copyWith(fontSize: 20);
  TextStyle? get bodySmall => texts.bodySmall;
  TextStyle? get bodyMedium => texts.bodyMedium;
  TextStyle? get bodyLarge => texts.bodyLarge;
  TextStyle? get bodyExtraLarge => texts.bodyMedium?.copyWith(fontSize: 16);
  TextStyle? get displaySmall => texts.displaySmall;
  TextStyle? get displayMedium => texts.displayMedium;
  TextStyle? get displayLarge => texts.displayLarge;
  TextStyle? get displayExtraLarge => texts.displayMedium?.copyWith(fontSize: 24);
}