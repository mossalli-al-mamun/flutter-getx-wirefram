import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../../Config/themes/extensions/colors_ext.dart';
import '../../../../Config/themes/text_styles.dart';
import '../FloatingField/style.dart';
import '../../../../Utils/extensions/size_extension.dart';

class AppFormField extends StatelessWidget {
  final String name;
  final String? label;
  final String? hintText;
  final String? initialValue;
  final bool isPasswordField;
  final bool showPassword;
  final VoidCallback? togglePasswordVisibility;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final bool isLastField;
  final bool isRequired;
  final TextInputType? keyboardType;

  const AppFormField({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.initialValue,
    this.isPasswordField = false,
    this.showPassword = false,
    this.togglePasswordVisibility,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isLastField = false,
    this.isRequired = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional required asterisk
        if (label != null && label!.isNotEmpty)
          RichText(
            text: TextSpan(
              text: label,
              style: AppTextStyle.labelMedium.copyWith(
                color: context.textPrimaryColor,
              ),
              children: isRequired
                  ? [
                TextSpan(
                  text: ' *',
                  style: AppTextStyle.labelMedium.copyWith(
                    color: context.dangerColor,
                  ),
                )
              ]
                  : [],
            ),
          ),

        10.height,

        // TextField
        FormBuilderTextField(
          name: name,
          initialValue: initialValue,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: isPasswordField && !showPassword,
          cursorColor: context.primary,
          decoration: style(
            context: context,
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            isPassword: isPasswordField,
            obscureText: showPassword,
            onToggleVisibility: togglePasswordVisibility,
          ),
        ),

        (isLastField ? 5 : 24).height,
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
// import 'package:flutter_getx_wireframe/Config/themes/text_styles.dart';
// import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
// import 'package:flutter_getx_wireframe/Widgets/form/AppFormFields/NonFloatingField/style.dart';
//
// class AppFormField extends StatelessWidget {
//   final String name;
//   final String? label;
//   final String? hintText;
//   final String? initialValue;
//   final bool isPasswordField;
//   final bool showPassword;
//   final VoidCallback? togglePasswordVisibility;
//   final IconData? prefixIcon;
//   final IconData? suffixIcon;
//   final String? Function(String?)? validator;
//   final bool isLastField;
//   final TextInputType? keyboardType;
//
//   const AppFormField({
//     super.key,
//     required this.name,
//     this.label,
//     this.hintText,
//     this.initialValue,
//     this.isPasswordField = false,
//     this.showPassword = false,
//     this.togglePasswordVisibility,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.validator,
//     this.isLastField = false,
//     this.keyboardType,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Custom Label above the field
//         if (label != null && label!.isNotEmpty)
//           Text(
//             label!,
//             style: AppTextStyle.labelMedium.copyWith(color: context.textPrimaryColor),
//           ),
//         10.height,
//
//         // Text Field
//         FormBuilderTextField(
//           name: name,
//           initialValue: initialValue,
//           validator: validator,
//           keyboardType: keyboardType,
//           obscureText: isPasswordField && !showPassword,
//           cursorColor: context.primary,
//           decoration: style(
//             context: context,
//             hintText: hintText,
//             prefixIcon: prefixIcon,
//             suffixIcon: suffixIcon,
//             isPassword: isPasswordField,
//             obscureText: showPassword,
//             onToggleVisibility: togglePasswordVisibility,
//           ),
//         ),
//
//         // Spacing after field
//         (isLastField ? 5 : 24).height,
//       ],
//     );
//   }}


