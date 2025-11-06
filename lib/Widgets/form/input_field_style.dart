import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';

/// Centralized, reusable InputDecoration builder for all input fields.
///
/// This keeps styles consistent and allows app-wide customization from one
/// place without touching each field widget implementation.

/// Enum for different field styles used across inputs
enum InputFieldStyle {
  standard, // Label above
  floating, // Floating label inside the field
  outlined, // Material outlined with labelText
}

/// Helper to compute dynamic vertical padding based on font/cursor
EdgeInsetsGeometry _computeContentPadding({
  required double fontSize,
  double? cursorHeight,
  EdgeInsetsGeometry? override,
}) {
  if (override != null) return override;
  final double baseCursorHeight = cursorHeight ?? fontSize * 1.3;
  final double verticalPadding = (baseCursorHeight - fontSize) / 2 + 15;
  return EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 15);
}

OutlineInputBorder _buildBorder({
  required BuildContext context,
  required Color color,
  required InputFieldStyle style,
  double width = 1.5,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      style == InputFieldStyle.outlined ? 12 : 6,
    ),
    borderSide: BorderSide(color: color, width: width),
  );
}

/// Build a complete InputDecoration according to the given style
InputDecoration buildInputDecoration({
  required BuildContext context,
  required InputFieldStyle style,
  // Labeling
  Widget? labelWidget, // used for floating custom label (can include asterisk)
  String? labelText, // used for outlined style
  // Texts
  String? hintText,
  TextStyle? hintStyle,
  // Icons
  IconData? prefixIcon,
  Widget? suffixIcon,
  // Layout
  int? maxLines,
  double? cursorHeight,
  TextStyle? textStyle,
  EdgeInsetsGeometry? contentPadding,
  // Colors and fill
  bool? filled,
  Color? fillColor,
}) {
  final cs = context; // using context extensions for colors
  final double fontSize = textStyle?.fontSize ?? 16;

  return InputDecoration(
    // Label handling
    label: style == InputFieldStyle.floating ? labelWidget : null,
    labelText: style == InputFieldStyle.outlined ? labelText : null,
    floatingLabelBehavior:
        style == InputFieldStyle.floating ? FloatingLabelBehavior.auto : FloatingLabelBehavior.always,

    // Hint
    hintText: hintText,
    hintStyle: hintStyle,

    // Icons
    prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: cs.onSurfaceVariant) : null,
    suffixIcon: suffixIcon,

    // Field visuals
    filled: filled ?? true,
    fillColor: fillColor ?? cs.surface,
    isDense: true,
    alignLabelWithHint: (maxLines ?? 1) != 1,

    // Padding
    contentPadding: _computeContentPadding(
      fontSize: fontSize,
      cursorHeight: cursorHeight,
      override: contentPadding,
    ),

    // Borders
    enabledBorder: _buildBorder(
      context: context,
      color: cs.outline.withValues(alpha: 0.5),
      style: style,
    ),
    focusedBorder: _buildBorder(
      context: context,
      color: cs.primary,
      style: style,
      width: 1.5,
    ),
    errorBorder: _buildBorder(
      context: context,
      color: cs.error,
      style: style,
    ),
    focusedErrorBorder: _buildBorder(
      context: context,
      color: cs.error,
      style: style,
      width: 1.5,
    ),
    disabledBorder: _buildBorder(
      context: context,
      color: cs.outline.withValues(alpha: 0.3),
      style: style,
    ),

    // Error style
    errorStyle: TextStyle(color: cs.error, fontSize: 12),
  );
}
