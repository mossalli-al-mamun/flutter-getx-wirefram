import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';

InputDecoration style({
  String? label,
  String? hintText,
  IconData? prefixIcon,
  IconData? suffixIcon,
  bool isPassword = false,
  bool obscureText = false,
  bool isRequired = false,
  required BuildContext context,
  VoidCallback? onToggleVisibility,
}) {
  return InputDecoration(
    // Use if no need danger color for asterisk
    // labelText: label ?? hintText,

    //Custom label with asterisk if required
    label: label != null
        ? RichText(
      text: TextSpan(
        text: label,
        style: context.labelExtraLarge?.copyWith(
          color: context.onSurfaceVariant,
        ),
        children: isRequired
            ? [
          TextSpan(
            text: ' *',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: context.dangerColor),
          ),
        ]
            : [],
      ),
    )
        : null,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    hintText: hintText,
    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    suffixIcon: isPassword
        ? IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(obscureText ? FeatherIcons.eyeOff : FeatherIcons.eye),
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
