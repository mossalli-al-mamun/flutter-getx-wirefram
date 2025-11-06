// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
//
// import 'style.dart';
//
// class AppFormFieldFloating extends StatelessWidget {
//   final String name;
//   final String? label;
//   final String? initialValue;
//   final String? hintText;
//   final bool isPassword;
//   final bool obscureText;
//   final VoidCallback? onToggleVisibility;
//   final IconData? prefixIcon;
//   final IconData? suffixIcon;
//   final String? Function(String?)? validator;
//   final TextInputType? keyboardType;
//   final TextCapitalization textCapitalization;
//   final double spacing; // 👈 Add spacing control
//
//   const AppFormFieldFloating({
//     super.key,
//     required this.name,
//     this.label,
//     this.hintText,
//     this.initialValue,
//     this.isPassword = false,
//     this.obscureText = false,
//     this.onToggleVisibility,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.validator,
//     this.keyboardType,
//     this.textCapitalization = TextCapitalization.none,
//     this.spacing = 16.0, // 👈 default bottom spacing between fields
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: spacing),
//       child: FormBuilderTextField(
//         name: name,
//         initialValue: initialValue,
//         validator: validator,
//         keyboardType: keyboardType,
//         textCapitalization: textCapitalization,
//         obscureText: isPassword && obscureText,
//         cursorColor: context.primary,
//         decoration: style(
//           context: context,
//           label: label,
//           hintText: hintText,
//           prefixIcon: prefixIcon,
//           suffixIcon: suffixIcon,
//           isPassword: isPassword,
//           onToggleVisibility: onToggleVisibility,
//           obscureText: obscureText,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';

import 'style.dart';

class AppFormFieldFloating extends StatelessWidget {
  final String name;
  final String? label;
  final String? initialValue;
  final String? hintText;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final double spacing;
  final bool isRequired; // 👈 New: marks field as required

  const AppFormFieldFloating({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.initialValue,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.spacing = 16.0,
    this.isRequired = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    // Use if no need danger color for asterisk
    // Combine label with asterisk if required
    // final displayLabel = isRequired && label != null && label!.isNotEmpty
    //     ? '${label!} *'
    //     : label;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: FormBuilderTextField(
        name: name,
        initialValue: initialValue,
        validator: validator,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        obscureText: isPassword && obscureText,
        cursorColor: context.primary,
        decoration: style(
          context: context,
          // label: displayLabel,
          label: label,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isPassword: isPassword,
          onToggleVisibility: onToggleVisibility,
          obscureText: obscureText,
          isRequired: isRequired
        ),
      ),
    );
  }
}

