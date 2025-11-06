import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';

InputDecoration style({
  String? hintText,
  IconData? prefixIcon,
  IconData? suffixIcon,
  bool isPassword = false,
  bool obscureText = false,
  required BuildContext context,
  VoidCallback? onToggleVisibility,
}) {
  return InputDecoration(
    hintText: hintText,
    labelText: null,
    floatingLabelBehavior: FloatingLabelBehavior.never, // <-- prevents floating
    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    suffixIcon: isPassword
        ? IconButton(
      onPressed: onToggleVisibility,
      icon: Icon(
        obscureText ? FeatherIcons.eyeOff : FeatherIcons.eye,
      ),
    )
        : (suffixIcon != null ? Icon(suffixIcon) : null),
    filled: true,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: context.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: context.dangerColor, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: context.dangerColor, width: 1.5),
    ),
    errorStyle: TextStyle(color: context.dangerColor, fontSize: 12),
  );
}


