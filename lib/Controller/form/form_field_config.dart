// ==========================
// Form Field Models
// ==========================

import 'package:flutter/material.dart';

enum FormFieldType {
  text,
  email,
  password,
  phone,
  number,
  date,
  time,
  dateTime,
  radio,
  checkbox,
  dropdown,
  multiSelect,
  slider,
  switch_,
  textArea,
}

class FormFieldConfig {
  final String name;
  final String label;
  final FormFieldType type;
  final dynamic initialValue;
  final String? placeholder;
  final String? Function(dynamic)? validator;
  final bool isRequired;
  final bool isEnabled;

  // Icon properties
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  // Field-specific properties
  final List<FormFieldOption>? options; // For radio, dropdown, checkbox
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final double? min; // For slider
  final double? max; // For slider
  final int? divisions; // For slider
  final String? Function(dynamic)? formatter; // Format display value

  // Layout properties
  final double spacing;
  final CrossAxisAlignment? alignment;

  // Conditional logic
  final bool Function(Map<String, dynamic>)? showWhen;
  final Function(dynamic, Map<String, dynamic>)? onChanged;

  FormFieldConfig({
    required this.name,
    required this.label,
    required this.type,
    this.initialValue,
    this.placeholder,
    this.validator,
    this.isRequired = false,
    this.isEnabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.options,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.min,
    this.max,
    this.divisions,
    this.formatter,
    this.spacing = 16,
    this.alignment,
    this.showWhen,
    this.onChanged,
  });
}

class FormFieldOption {
  final String label;
  final dynamic value;
  final IconData? icon;
  final bool isEnabled;

  FormFieldOption({
    required this.label,
    required this.value,
    this.icon,
    this.isEnabled = true,
  });
}