// ==========================
// Unified App Form Field
// ==========================
// A single, dynamic form field component that handles all input types
// and works seamlessly with flutter_form_builder

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:flutter_getx_wireframe/Utils/app_logger.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:flutter_getx_wireframe/Widgets/buttons/primary_button.dart';
import 'package:flutter_getx_wireframe/Widgets/form/input_field_style.dart';
export 'package:flutter_getx_wireframe/Widgets/form/input_field_style.dart';

/// Uses InputFieldStyle from input_field_style.dart for styling.

/// Main unified form field widget
class UnifiedInputField extends StatefulWidget {
  // Core properties
  final String name;
  final String? label;
  final String? hintText;
  final String? initialValue;

  // Field behavior
  final bool isRequired;
  final bool isPassword;
  final bool isEnabled;
  final bool readOnly;

  // Styling
  final InputFieldStyle style;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final double spacing;

  // Input configuration
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? cursorHeight;

  // Callbacks
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final VoidCallback? onTap;

  // Advanced
  final TextEditingController? controller;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final double? width;

  const UnifiedInputField({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.initialValue,
    this.isRequired = false,
    this.isPassword = false,
    this.isEnabled = true,
    this.readOnly = false,
    this.style = InputFieldStyle.floating,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.spacing = 16.0,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.cursorHeight,
    this.validator,
    this.onChanged,
    this.onTap,
    this.controller,
    this.contentPadding,
    this.hintStyle,
    this.textStyle,
    this.width,
  });

  @override
  State<UnifiedInputField> createState() => _UnifiedFormFieldState();
}

class _UnifiedFormFieldState extends State<UnifiedInputField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in container for spacing
    final field = SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show label on top for standard style
          if (widget.style == InputFieldStyle.standard &&
              widget.label != null &&
              widget.label!.isNotEmpty)
            _buildTopLabel(context),

          if (widget.style == InputFieldStyle.standard &&
              widget.label != null &&
              widget.label!.isNotEmpty)
            10.height,

          // The actual form field
          FormBuilderTextField(
            name: widget.name,
            initialValue: widget.initialValue,
            controller: widget.controller,
            enabled: widget.isEnabled,
            readOnly: widget.readOnly,
            obscureText: widget.isPassword && _obscureText,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            minLines: widget.minLines,
            cursorHeight: widget.cursorHeight ?? 20.0,
            cursorColor: context.primary,
            style: widget.textStyle ?? context.bodyMedium,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            decoration: _buildDecoration(context),
          ),
        ],
      ),
    );

    // Add bottom spacing
    return Padding(
      padding: EdgeInsets.only(bottom: widget.spacing),
      child: field,
    );
  }

  /// Build label for standard style (appears above field)
  Widget _buildTopLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: context.labelMedium?.copyWith(
          color: context.onSurface,
        ),
        children: widget.isRequired
            ? [
          TextSpan(
            text: ' *',
            style: context.labelMedium?.copyWith(
              color: context.error,
            ),
          ),
        ]
            : [],
      ),
    );
  }

  /// Build input decoration based on centralized style builder
  InputDecoration _buildDecoration(BuildContext context) {
    return buildInputDecoration(
      context: context,
      style: widget.style,
      labelWidget: (widget.style == InputFieldStyle.floating && widget.label != null)
          ? _buildFloatingLabel(context)
          : null,
      labelText: widget.style == InputFieldStyle.outlined ? widget.label : null,
      hintText: widget.hintText,
      hintStyle: widget.hintStyle,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(context),
      maxLines: widget.maxLines,
      cursorHeight: widget.cursorHeight,
      textStyle: widget.textStyle,
      contentPadding: widget.contentPadding,
      filled: true,
      fillColor: null, // use default from builder
    );
  }

  /// Build floating label with optional required asterisk
  Widget _buildFloatingLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: context.labelLarge?.copyWith(
          color: context.onSurfaceVariant,
        ),
        children: widget.isRequired
            ? [
          TextSpan(
            text: ' *',
            style: context.labelMedium?.copyWith(
              color: context.error,
            ),
          ),
        ]
            : [],
      ),
    );
  }

  /// Build suffix icon (handles password visibility toggle)
  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.isPassword) {
      return IconButton(
        onPressed: _togglePasswordVisibility,
        icon: Icon(
          _obscureText ? FeatherIcons.eyeOff : FeatherIcons.eye,
          color: context.onSurfaceVariant,
        ),
      );
    }

    if (widget.suffixIcon != null) {
      return widget.onSuffixTap != null
          ? IconButton(
        onPressed: widget.onSuffixTap,
        icon: Icon(
          widget.suffixIcon,
          color: context.onSurfaceVariant,
        ),
      )
          : Icon(
        widget.suffixIcon,
        color: context.onSurfaceVariant,
      );
    }

    return null;
  }
}

// ==========================
// Example Usage
// ==========================

class ExampleFormUsage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  ExampleFormUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          // Standard style with label on top
          UnifiedInputField(
            name: 'username',
            label: 'Username',
            hintText: 'Enter your username',
            isRequired: true,
            style: InputFieldStyle.standard,
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username is required';
              }
              return null;
            },
          ),

          // Floating label style
          UnifiedInputField(
            name: 'email',
            label: 'Email Address',
            hintText: 'you@example.com',
            isRequired: true,
            style: InputFieldStyle.floating,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Invalid email';
              }
              return null;
            },
          ),

          // Password field
          UnifiedInputField(
            name: 'password',
            label: 'Password',
            isRequired: true,
            isPassword: true,
            style: InputFieldStyle.floating,
            prefixIcon: Icons.lock_outline,
          ),

          // Text area
          UnifiedInputField(
            name: 'bio',
            label: 'Bio',
            hintText: 'Tell us about yourself',
            style: InputFieldStyle.floating,
            maxLines: 4,
            minLines: 3,
          ),

          // Phone number
          UnifiedInputField(
            name: 'phone',
            label: 'Phone Number',
            isRequired: true,
            style: InputFieldStyle.outlined,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
          ),

          // Submit button
          PrimaryButton(
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final values = _formKey.currentState!.value;
                appLogger('Form values: $values');
              }
            },
            label: 'Submit',
          ),
        ],
      ),
    );
  }
}