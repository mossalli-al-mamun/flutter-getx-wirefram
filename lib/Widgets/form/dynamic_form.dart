// ==========================
// Dynamic Form Widget
// ==========================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/form/form_controller.dart';
import '../../Controller/form/form_field_config.dart';
import 'unified_input_field.dart';

class DynamicForm extends StatelessWidget {
  final DynamicFormController controller;
  final List<FormFieldConfig> fields;
  final Widget? submitButton;
  final EdgeInsets? padding;
  final double? spacing;

  const DynamicForm({
    super.key,
    required this.controller,
    required this.fields,
    this.submitButton,
    this.padding,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...fields.map((field) => Obx(() {
              final isVisible = controller.fieldVisibility[field.name] ?? true;
              if (!isVisible) return const SizedBox.shrink();

              return Padding(
                padding: EdgeInsets.only(bottom: spacing ?? field.spacing),
                child: _buildField(context, field),
              );
            })),
            if (submitButton != null) submitButton!,
          ],
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, FormFieldConfig field) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.email:
      case FormFieldType.phone:
      case FormFieldType.number:
        return _buildTextField(context, field);

      case FormFieldType.password:
        return _buildPasswordField(context, field);

      case FormFieldType.textArea:
        return _buildTextAreaField(context, field);

      case FormFieldType.radio:
        return _buildRadioField(context, field);

      case FormFieldType.checkbox:
        return _buildCheckboxField(context, field);

      case FormFieldType.dropdown:
        return _buildDropdownField(context, field);

      case FormFieldType.date:
        return _buildDateField(context, field);

      case FormFieldType.time:
        return _buildTimeField(context, field);

      case FormFieldType.slider:
        return _buildSliderField(context, field);

      case FormFieldType.switch_:
        return _buildSwitchField(context, field);

      default:
        return _buildTextField(context, field);
    }
  }

  // Text Field
  Widget _buildTextField(BuildContext context, FormFieldConfig field) {
    return UnifiedInputField(
      controller: TextEditingController(
        text: controller.getFieldValue(field.name)?.toString() ?? '',
      ),
      name: field.name,
      label: field.label,
      hintText: field.placeholder,
      prefixIcon: field.prefixIcon,
      suffixIcon: field.suffixIcon,
      keyboardType: _getKeyboardType(field.type),
      maxLength: field.maxLength,
      isEnabled: field.isEnabled,
      isRequired: field.isRequired,
      validator: (value) {
        if (field.isRequired && (value == null || value.trim().isEmpty)) {
          return '${field.label} is required';
        }
        return field.validator?.call(value);
      },
      onChanged: (value) {
        controller.updateField(field.name, value);
        field.onChanged?.call(value, controller.getFormData());
        controller.updateFieldVisibility(fields);
      },
    );
  }

  // Password Field
  Widget _buildPasswordField(BuildContext context, FormFieldConfig field) {
    final RxBool obscureText = true.obs;

    return Obx(() => UnifiedInputField(
      controller: TextEditingController(
        text: controller.getFieldValue(field.name)?.toString() ?? '',
      ),
      name: field.name,
      label: field.label,
      hintText: field.placeholder,
      prefixIcon: field.prefixIcon ?? Icons.lock_outline,
      suffixIcon: obscureText.value ? Icons.visibility_off : Icons.visibility,
      onSuffixTap: () => obscureText.value = !obscureText.value,
      isRequired: field.isRequired,
      validator: (value) {
        if (field.isRequired && (value == null || value.trim().isEmpty)) {
          return '${field.label} is required';
        }
        return field.validator?.call(value);
      },
      onChanged: (value) {
        controller.updateField(field.name, value);
        field.onChanged?.call(value, controller.getFormData());
      },
    ));
  }

  // Text Area Field
  Widget _buildTextAreaField(BuildContext context, FormFieldConfig field) {
    return UnifiedInputField(
      controller: TextEditingController(
        text: controller.getFieldValue(field.name)?.toString() ?? '',
      ),
      name: field.name,
      label: field.label,
      hintText: field.placeholder,
      maxLines: field.maxLines ?? 4,
      minLines: field.minLines ?? 3,
      isEnabled: field.isEnabled,
      isRequired: field.isRequired,
      validator: (value) {
        if (field.isRequired && (value == null || value.trim().isEmpty)) {
          return '${field.label} is required';
        }
        return field.validator?.call(value);
      },
      onChanged: (value) {
        controller.updateField(field.name, value);
        field.onChanged?.call(value, controller.getFormData());
      },
    );
  }

  // Radio Field
  Widget _buildRadioField(BuildContext context, FormFieldConfig field) {
    return FormField<dynamic>(
      initialValue: controller.getFieldValue(field.name),
      validator: (value) {
        if (field.isRequired && value == null) {
          return '${field.label} is required';
        }
        return field.validator?.call(value);
      },
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label + (field.isRequired ? ' *' : ''),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: field.options?.map((option) {
                return Obx(() {
                  final isSelected = controller.getFieldValue(field.name) == option.value;
                  return RadioOptionCard(
                    label: option.label,
                    icon: option.icon,
                    isSelected: isSelected,
                    onTap: option.isEnabled ? () {
                      controller.updateField(field.name, option.value);
                      formFieldState.didChange(option.value);
                      field.onChanged?.call(option.value, controller.getFormData());
                      controller.updateFieldVisibility(fields);
                    } : null,
                  );
                });
              }).toList() ?? [],
            ),
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  formFieldState.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Checkbox Field (Multiple Selection)
  Widget _buildCheckboxField(BuildContext context, FormFieldConfig field) {
    return FormField<List<dynamic>>(
      initialValue: controller.getFieldValue(field.name) ?? [],
      validator: (value) {
        if (field.isRequired && (value == null || value.isEmpty)) {
          return '${field.label} is required';
        }
        return field.validator?.call(value);
      },
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label + (field.isRequired ? ' *' : ''),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...field.options?.map((option) {
              return Obx(() {
                final selectedValues = List<dynamic>.from(
                    controller.getFieldValue(field.name) ?? []
                );
                final isSelected = selectedValues.contains(option.value);

                return CheckboxListTile(
                  title: Text(option.label),
                  value: isSelected,
                  enabled: option.isEnabled,
                  onChanged: option.isEnabled ? (bool? checked) {
                    if (checked == true) {
                      selectedValues.add(option.value);
                    } else {
                      selectedValues.remove(option.value);
                    }
                    controller.updateField(field.name, selectedValues);
                    formFieldState.didChange(selectedValues);
                    field.onChanged?.call(selectedValues, controller.getFormData());
                  } : null,
                );
              });
            }).toList() ?? [],
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  formFieldState.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Dropdown Field
  Widget _buildDropdownField(BuildContext context, FormFieldConfig field) {
    return DropdownButtonFormField<dynamic>(
      initialValue: controller.getFieldValue(field.name),
      decoration: buildInputDecoration(
        context: context,
        style: InputFieldStyle.standard,
        hintText: field.placeholder,
        prefixIcon: field.prefixIcon,
      ),
      items: field.options?.map((option) {
        return DropdownMenuItem(
          value: option.value,
          enabled: option.isEnabled,
          child: Text(option.label),
        );
      }).toList(),
      validator: (value) {
        if (field.isRequired && value == null) {
          return '${field.label} is required';
        }
        return field.validator?.call(value);
      },
      onChanged: field.isEnabled ? (value) {
        controller.updateField(field.name, value);
        field.onChanged?.call(value, controller.getFormData());
        controller.updateFieldVisibility(fields);
      } : null,
    );
  }

  // Date Field
  Widget _buildDateField(BuildContext context, FormFieldConfig field) {
    return UnifiedInputField(
      controller: TextEditingController(
        text: field.formatter?.call(controller.getFieldValue(field.name)) ??
            controller.getFieldValue(field.name)?.toString() ?? '',
      ),
      name: field.name,
      label: field.label,
      hintText: field.placeholder,
      prefixIcon: field.prefixIcon ?? Icons.calendar_today,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: controller.getFieldValue(field.name) ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          controller.updateField(field.name, date);
          field.onChanged?.call(date, controller.getFormData());
        }
      },
      validator: (value) {
        if (field.isRequired && controller.getFieldValue(field.name) == null) {
          return '${field.label} is required';
        }
        return field.validator?.call(controller.getFieldValue(field.name));
      },
    );
  }

  // Time Field
  Widget _buildTimeField(BuildContext context, FormFieldConfig field) {
    return UnifiedInputField(
      controller: TextEditingController(
        text: field.formatter?.call(controller.getFieldValue(field.name)) ??
            controller.getFieldValue(field.name)?.toString() ?? '',
      ),
      name: field.name,
      label: field.label,
      hintText: field.placeholder,
      prefixIcon: field.prefixIcon ?? Icons.access_time,
      readOnly: true,
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: controller.getFieldValue(field.name) ?? TimeOfDay.now(),
        );
        if (time != null) {
          controller.updateField(field.name, time);
          field.onChanged?.call(time, controller.getFormData());
        }
      },
      validator: (value) {
        if (field.isRequired && controller.getFieldValue(field.name) == null) {
          return '${field.label} is required';
        }
        return field.validator?.call(controller.getFieldValue(field.name));
      },
    );
  }

  // Slider Field
  Widget _buildSliderField(BuildContext context, FormFieldConfig field) {
    return Obx(() {
      final value = (controller.getFieldValue(field.name) ?? field.min ?? 0).toDouble();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${field.label}: ${field.formatter?.call(value) ?? value.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: value,
            min: field.min ?? 0,
            max: field.max ?? 100,
            divisions: field.divisions,
            label: field.formatter?.call(value) ?? value.toString(),
            onChanged: field.isEnabled ? (newValue) {
              controller.updateField(field.name, newValue);
              field.onChanged?.call(newValue, controller.getFormData());
            } : null,
          ),
        ],
      );
    });
  }

  // Switch Field
  Widget _buildSwitchField(BuildContext context, FormFieldConfig field) {
    return Obx(() {
      final value = controller.getFieldValue(field.name) ?? false;
      return SwitchListTile(
        title: Text(field.label),
        subtitle: field.placeholder != null ? Text(field.placeholder!) : null,
        value: value,
        onChanged: field.isEnabled ? (newValue) {
          controller.updateField(field.name, newValue);
          field.onChanged?.call(newValue, controller.getFormData());
          controller.updateFieldVisibility(fields);
        } : null,
      );
    });
  }

  TextInputType _getKeyboardType(FormFieldType type) {
    switch (type) {
      case FormFieldType.email:
        return TextInputType.emailAddress;
      case FormFieldType.phone:
        return TextInputType.phone;
      case FormFieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}

// ==========================
// Radio Option Card Widget
// ==========================

class RadioOptionCard extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const RadioOptionCard({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer : cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? cs.onPrimaryContainer : cs.onSurface,
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? cs.onPrimaryContainer : cs.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}