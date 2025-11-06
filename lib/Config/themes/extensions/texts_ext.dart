import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';

extension TextsExt on BuildContext {
  TextStyle? get labelSmall => texts.labelSmall;
  TextStyle? get labelMedium => texts.labelMedium;
  TextStyle? get labelLarge => texts.labelLarge;
  TextStyle? get labelExtraLarge => texts.labelMedium?.copyWith(fontSize: 16);
  TextStyle? get bodyMedium => texts.bodyMedium;
}