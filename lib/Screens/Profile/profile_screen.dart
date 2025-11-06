import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Widgets/app_scaffold.dart';
import 'package:get/get.dart';

import '../../Controller/form/form_controller.dart';
import '../../Controller/form/form_field_config.dart';
import '../../Widgets/form/dynamic_form.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final controller = Get.put(DynamicFormController());

  @override
  Widget build(BuildContext context) {
    final fields = [
      FormFieldConfig(
        name: 'fullName',
        label: 'Full Name',
        type: FormFieldType.text,
        prefixIcon: Icons.person_outline,
        isRequired: true,
      ),

      FormFieldConfig(
        name: 'email',
        label: 'Email',
        type: FormFieldType.email,
        prefixIcon: Icons.email_outlined,
        isRequired: true,
      ),

      FormFieldConfig(
        name: 'bio',
        label: 'Bio',
        type: FormFieldType.textArea,
        placeholder: 'Tell us about yourself...',
        maxLines: 5,
        minLines: 3,
      ),

      FormFieldConfig(
        name: 'country',
        label: 'Country',
        type: FormFieldType.dropdown,
        placeholder: 'Select your country',
        prefixIcon: Icons.public,
        isRequired: true,
        options: [
          FormFieldOption(label: 'Bangladesh', value: 'BD'),
          FormFieldOption(label: 'United States', value: 'US'),
          FormFieldOption(label: 'United Kingdom', value: 'UK'),
          FormFieldOption(label: 'India', value: 'IN'),
          FormFieldOption(label: 'Pakistan', value: 'PK'),
        ],
      ),

      // Show city only if country is selected
      FormFieldConfig(
        name: 'city',
        label: 'City',
        type: FormFieldType.text,
        prefixIcon: Icons.location_city,
        showWhen: (formData) => formData['country'] != null,
      ),

      FormFieldConfig(
        name: 'interests',
        label: 'Interests',
        type: FormFieldType.checkbox,
        options: [
          FormFieldOption(label: 'Technology', value: 'tech'),
          FormFieldOption(label: 'Sports', value: 'sports'),
          FormFieldOption(label: 'Music', value: 'music'),
          FormFieldOption(label: 'Travel', value: 'travel'),
          FormFieldOption(label: 'Reading', value: 'reading'),
        ],
      ),

      FormFieldConfig(
        name: 'experienceYears',
        label: 'Years of Experience',
        type: FormFieldType.slider,
        min: 0,
        max: 50,
        divisions: 50,
        initialValue: 5.0,
        formatter: (value) => '${value.toInt()} years',
      ),

      FormFieldConfig(
        name: 'receiveNotifications',
        label: 'Receive email notifications',
        type: FormFieldType.switch_,
        initialValue: true,
      ),
    ];

    controller.initialize(fields);

    // return JobApplicationFormExample();
    // return FeedbackFormExample();
    // return ProfileFormExample();
    // return SignUpFormExample();

    return AppScaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child:
        DynamicForm(
          controller: controller,
          fields: fields,
          submitButton: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.reset(fields),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.validate()) {
                        final data = controller.getFormData();
                        Get.snackbar(
                          'Success',
                          'Profile updated successfully!',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
