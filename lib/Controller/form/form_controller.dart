// ==========================
// Dynamic Form Controller
// ==========================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/form/unified_dropdown_field.dart';
import 'form_field_config.dart';

class DynamicFormController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  final RxMap<String, dynamic> formData = <String, dynamic>{}.obs;
  final RxMap<String, bool> fieldVisibility = <String, bool>{}.obs;
  final RxMap<String, FormFieldType> fieldTypes = <String, FormFieldType>{}.obs;
  final RxBool isLoading = false.obs;

  GlobalKey<FormState> get formKey => _formKey;

  void initialize(List<FormFieldConfig> fields) {
    for (var field in fields) {
      formData[field.name] = field.initialValue;
      fieldVisibility[field.name] = true;
      fieldTypes[field.name] = field.type;
    }
  }

  void updateField(String name, dynamic value) {
    formData[name] = value;
    formData.refresh();
  }

  void updateFieldType(String name, FormFieldType type) {
    fieldTypes[name] = type;
  }

  dynamic getFieldValue(String name) {
    return formData[name];
  }

  void updateFieldVisibility(List<FormFieldConfig> fields) {
    for (var field in fields) {
      if (field.showWhen != null) {
        fieldVisibility[field.name] = field.showWhen!(formData);
      }
    }
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  /// Get form data with UI objects (DropdownOption, DateTime, etc.)
  /// Use this for internal form logic and display
  Map<String, dynamic> getFormData() {
    return Map<String, dynamic>.from(formData);
  }

  /// Get API-ready form data with primitive values extracted
  /// Use this when submitting to API
  Map<String, dynamic> getApiData() {
    final apiData = <String, dynamic>{};

    formData.forEach((key, value) {
      apiData[key] = _extractApiValue(value);
    });

    return apiData;
  }

  /// Extract primitive value from any field type
  dynamic _extractApiValue(dynamic value) {
    if (value == null) return null;

    // Handle DropdownOption - extract the value
    if (value is DropdownOption) {
      return value.value;
    }

    // Handle Map (in case you're using maps as dropdown values)
    if (value is Map) {
      return value['value'] ?? value['id'];
    }

    // Handle List of DropdownOptions (for multi-select)
    if (value is List) {
      return value.map((item) => _extractApiValue(item)).toList();
    }

    // Handle DateTime - convert to ISO string or your preferred format
    if (value is DateTime) {
      return value.toString().split(' ')[0]; // YYYY-MM-DD format
      // Or use: return value.toIso8601String();
    }

    // Handle TimeOfDay
    if (value is TimeOfDay) {
      return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    }

    // Return as-is for other types (String, int, bool, etc.)
    return value;
  }

  /// Helper method to extract just the value from a field
  /// Useful for getting primitive values in onChanged callbacks
  dynamic extractFieldValue(String fieldName) {
    return _extractApiValue(formData[fieldName]);
  }

  /// Validate and get API data in one call
  /// Returns null if validation fails
  Map<String, dynamic>? validateAndGetApiData() {
    if (validate()) {
      return getApiData();
    }
    return null;
  }

  void reset(List<FormFieldConfig> fields) {
    _formKey.currentState?.reset();
    for (var field in fields) {
      formData[field.name] = field.initialValue;
    }
    formData.refresh();
  }

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  /// Clear a field's value
  void clearField(String name) {
    updateField(name, null);
  }

  /// Clear multiple fields at once
  void clearFields(List<String> fieldNames) {
    for (var name in fieldNames) {
      formData[name] = null;
    }
    formData.refresh();
  }

  /// Set multiple field values at once
  void setFieldValues(Map<String, dynamic> values) {
    formData.addAll(values);
    formData.refresh();
  }
}