import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/text_styles.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/texts_ext.dart';

import '../app_colors.dart';

InputDecoration appFormStyle({
  String? labelText,
  String? hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  BoxConstraints? prefixIconConstraints,
  required BuildContext context,
}) {
  return InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: context.dangerColor),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: context.disabledColor),
    ),
    labelText: labelText,
    filled: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintText: hintText,
    isDense: true,
    // Explicitly set error style to ensure it's visible
    errorStyle: TextStyle(color: context.dangerColor, fontSize: 12.0),
    errorMaxLines: 2,
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    prefixIconConstraints: prefixIconConstraints,
  );
}

InputDecoration appFormDropdownStyle({
  String? labelText,
  String? hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  required BuildContext context,
}) {
  return InputDecoration(
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: AppColors.disabledColor),
    ),
    // suffixIconColor: AppColors.primaryColor,
    labelText: labelText,
    filled: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon ?? Icon(FeatherIcons.chevronDown),
    hintText: hintText,
    isDense: true,
    // Explicitly set error style to ensure it's visible
    errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
    errorMaxLines: 2,
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),

    // labelText: 'Email',
  );
}

InputDecoration appSearchFieldStyle({
  String? labelText,
  String? hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  required BuildContext context,
}) {
  return InputDecoration(
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    // suffixIconColor: AppColors.primaryColor,
    filled: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintText: hintText,
    isDense: true,
  );
}

InputDecoration appInputFieldStyle({
  String? labelText,
  String? hintText,
  EdgeInsetsGeometry? contentPadding,
  TextStyle? hintStyle,
  bool isEnabled = true,
  required BuildContext context,
}) {
  return InputDecoration(
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
    ),

    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
    filled: true,
    hintText: hintText,
    isDense: true,
    // Explicitly set error style to ensure it's visible
    errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
    errorMaxLines: 2,
    contentPadding: contentPadding,
  );
}
