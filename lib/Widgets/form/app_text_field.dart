// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
//
// import 'AppFormFields/FloatingField/style.dart';
//
// class AppTextField extends StatefulWidget {
//   final double? width;
//   final double? cursorHeight;
//   final String? hintText;
//   final EdgeInsetsGeometry? contentPadding;
//   final TextStyle? hintStyle;
//   final TextStyle? textStyle;
//   final bool isEnabled;
//   final TextInputType? keyboardType;
//   final List<TextInputFormatter>? inputFormatters;
//   final String? Function(String?)? validator;
//   final Function? onChanged;
//   final int? limitValue;
//   final TextEditingController? controller;
//   final bool obscureText;
//   final String? label;
//   final IconData? prefixIcon;
//   final IconData? suffixIcon;
//   final VoidCallback? onSuffixTap;
//   final int? maxLength;
//   final int? maxLines;
//   final int? minLines;
//   final bool? readOnly;
//   final VoidCallback? onTap;
//   final bool isPassword;
//   final VoidCallback? onToggleVisibility;
//   final bool isRequired;
//
//   const AppTextField({
//     super.key,
//     this.width,
//     this.cursorHeight,
//     this.hintText,
//     this.contentPadding = const EdgeInsets.symmetric(
//       horizontal: 15,
//       vertical: 20,
//     ),
//     this.hintStyle,
//     this.textStyle,
//     this.isEnabled = true,
//     this.keyboardType,
//     this.validator,
//     this.limitValue,
//     this.onChanged,
//     this.inputFormatters,
//     this.controller,
//     this.obscureText = false,
//     this.onTap,
//     this.label,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.onSuffixTap,
//     this.maxLength,
//     this.maxLines,
//     this.minLines,
//     this.readOnly,
//     this.isPassword = false,
//     this.onToggleVisibility,
//     this.isRequired = false,
//   });
//
//   @override
//   State<AppTextField> createState() => _AppTextFieldState();
// }
//
// class _AppTextFieldState extends State<AppTextField> {
//   String? _validateInput(String? value) {
//     // Use the custom validator if provided
//     if (widget.validator != null) {
//       return widget.validator!(value);
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       enabled: widget.isEnabled,
//       keyboardType: widget.keyboardType,
//       inputFormatters: widget.inputFormatters,
//       cursorColor: context.primary,
//       cursorHeight: widget.cursorHeight ?? 20.0,
//       obscureText: widget.obscureText,
//       validator: _validateInput,
//       onChanged: (value) {
//         if (widget.onChanged != null) {
//           widget.onChanged!(value);
//         }
//       },
//       decoration: style(
//         context: context,
//         // label: displayLabel,
//         label: widget.label,
//         hintText: widget.hintText,
//         prefixIcon: widget.prefixIcon,
//         suffixIcon: widget.suffixIcon,
//         isPassword: widget.isPassword,
//         onToggleVisibility: widget.onToggleVisibility,
//         obscureText: widget.obscureText,
//         isRequired: widget.isRequired,
//       ),
//       // style: widget.textStyle ?? AppTextStyle.bodyMedium,
//     );
//   }
// }
