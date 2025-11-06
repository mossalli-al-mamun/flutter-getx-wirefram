// ==========================
// Dynamic Form Controller
// ==========================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'form_field_config.dart';

class DynamicFormController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  final RxMap<String, dynamic> formData = <String, dynamic>{}.obs;
  final RxMap<String, bool> fieldVisibility = <String, bool>{}.obs;
  final RxBool isLoading = false.obs;

  GlobalKey<FormState> get formKey => _formKey;

  void initialize(List<FormFieldConfig> fields) {
    for (var field in fields) {
      formData[field.name] = field.initialValue;
      fieldVisibility[field.name] = true;
    }
  }

  void updateField(String name, dynamic value) {
    formData[name] = value;
    formData.refresh();
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

  Map<String, dynamic> getFormData() {
    return Map<String, dynamic>.from(formData);
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
}