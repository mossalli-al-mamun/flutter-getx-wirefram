import 'package:flutter/material.dart';

class AppColors {
  static const whiteColor = Colors.white;
  static const blackColor = Colors.black;
  static const redColor = Colors.red;

  static var greyColor = _hexToColor('#808080');

  static const primaryColor = Color(0xff2563EB);
  static const secondaryColor = Color(0xff64748B);
  static const disabledColor = Color(0XffCBD5E1);

  /// Helper function to convert hex color codes to [Color]
  static Color _hexToColor(String hexCode) {
    final buffer = StringBuffer();
    if (hexCode.length == 6 || hexCode.length == 7) {
      buffer.write('ff'); // Add alpha if missing
    }
    buffer.write(hexCode.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
