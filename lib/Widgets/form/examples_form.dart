// ==========================
// Example 1: Sign Up Form with Gender Selection
// ==========================

import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Utils/app_logger.dart';
import 'package:flutter_getx_wireframe/Widgets/app_scaffold.dart';
import 'package:get/get.dart';

import '../../Controller/form/form_controller.dart';
import '../../Controller/form/form_field_config.dart';
import 'dynamic_form.dart';

class SignUpFormExample extends StatelessWidget {
  SignUpFormExample({super.key});

  final controller = Get.put(DynamicFormController());

  @override
  Widget build(BuildContext context) {
    final fields = [
      // Full Name
      FormFieldConfig(
        name: 'fullName',
        label: 'Full Name',
        type: FormFieldType.text,
        placeholder: 'Enter your full name',
        prefixIcon: Icons.person_outline,
        isRequired: true,
        validator: (value) {
          if (value.toString().length < 3) {
            return 'Name must be at least 3 characters';
          }
          return null;
        },
      ),

      // Email
      FormFieldConfig(
        name: 'email',
        label: 'Email Address',
        type: FormFieldType.email,
        placeholder: 'you@example.com',
        prefixIcon: Icons.email_outlined,
        isRequired: true,
        validator: (value) {
          if (!GetUtils.isEmail(value.toString())) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),

      // Phone
      FormFieldConfig(
        name: 'phone',
        label: 'Phone Number',
        type: FormFieldType.phone,
        placeholder: '+880 1234-567890',
        prefixIcon: Icons.phone_outlined,
        isRequired: true,
      ),

      // Password
      FormFieldConfig(
        name: 'password',
        label: 'Password',
        type: FormFieldType.password,
        placeholder: 'Enter a strong password',
        isRequired: true,
        validator: (value) {
          if (value.toString().length < 8) {
            return 'Password must be at least 8 characters';
          }
          return null;
        },
      ),

      // Confirm Password
      FormFieldConfig(
        name: 'confirmPassword',
        label: 'Confirm Password',
        type: FormFieldType.password,
        placeholder: 'Re-enter your password',
        isRequired: true,
        validator: (value) {
          if (value != controller.getFieldValue('password')) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),

      // Gender (Radio)
      FormFieldConfig(
        name: 'gender',
        label: 'Gender',
        type: FormFieldType.radio,
        isRequired: true,
        options: [
          FormFieldOption(label: 'Male', value: 'male', icon: Icons.male),
          FormFieldOption(label: 'Female', value: 'female', icon: Icons.female),
          FormFieldOption(
            label: 'Other',
            value: 'other',
            icon: Icons.transgender,
          ),
        ],
      ),

      // Date of Birth
      FormFieldConfig(
        name: 'dateOfBirth',
        label: 'Date of Birth',
        type: FormFieldType.date,
        placeholder: 'Select your date of birth',
        isRequired: true,
        formatter: (date) {
          if (date is DateTime) {
            return '${date.day}/${date.month}/${date.year}';
          }
          return '';
        },
      ),

      // Terms & Conditions
      FormFieldConfig(
        name: 'agreeToTerms',
        label: 'I agree to Terms & Conditions',
        type: FormFieldType.switch_,
        initialValue: false,
        isRequired: true,
        validator: (value) {
          if (value != true) {
            return 'You must agree to terms and conditions';
          }
          return null;
        },
      ),
    ];

    controller.initialize(fields);

    return AppScaffold(
      body: DynamicForm(
        controller: controller,
        fields: fields,
        submitButton: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                      if (controller.validate()) {
                        controller.setLoading(true);

                        // Simulate API call
                        await Future.delayed(const Duration(seconds: 2));

                        final formData = controller.getFormData();
                        appLogger('Form Data: $formData');

                        controller.setLoading(false);

                        Get.snackbar(
                          'Success',
                          'Account created successfully!',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================
// Example 2: Profile Form with Conditional Fields
// ==========================

class ProfileFormExample extends StatelessWidget {
  ProfileFormExample({super.key});

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

    return AppScaffold(
      body: DynamicForm(
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
                      appLogger('Profile Data: $data');
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
    );
  }
}

// ==========================
// Example 3: Survey/Feedback Form
// ==========================

class FeedbackFormExample extends StatelessWidget {
  FeedbackFormExample({super.key});

  final controller = Get.put(DynamicFormController());

  @override
  Widget build(BuildContext context) {
    final fields = [
      FormFieldConfig(
        name: 'rating',
        label: 'How would you rate our service?',
        type: FormFieldType.radio,
        isRequired: true,
        options: [
          FormFieldOption(label: '⭐ Poor', value: 1),
          FormFieldOption(label: '⭐⭐ Fair', value: 2),
          FormFieldOption(label: '⭐⭐⭐ Good', value: 3),
          FormFieldOption(label: '⭐⭐⭐⭐ Very Good', value: 4),
          FormFieldOption(label: '⭐⭐⭐⭐⭐ Excellent', value: 5),
        ],
      ),

      FormFieldConfig(
        name: 'satisfaction',
        label: 'Overall Satisfaction',
        type: FormFieldType.slider,
        min: 0,
        max: 10,
        divisions: 10,
        initialValue: 7.0,
        formatter: (value) => '${value.toInt()}/10',
      ),

      FormFieldConfig(
        name: 'recommend',
        label: 'Would you recommend us to others?',
        type: FormFieldType.radio,
        isRequired: true,
        options: [
          FormFieldOption(label: 'Yes', value: true, icon: Icons.thumb_up),
          FormFieldOption(label: 'No', value: false, icon: Icons.thumb_down),
        ],
      ),

      FormFieldConfig(
        name: 'improvements',
        label: 'What can we improve?',
        type: FormFieldType.checkbox,
        options: [
          FormFieldOption(label: 'Customer Service', value: 'service'),
          FormFieldOption(label: 'Product Quality', value: 'quality'),
          FormFieldOption(label: 'Pricing', value: 'pricing'),
          FormFieldOption(label: 'Delivery Speed', value: 'delivery'),
          FormFieldOption(label: 'Website/App', value: 'tech'),
        ],
      ),

      FormFieldConfig(
        name: 'comments',
        label: 'Additional Comments',
        type: FormFieldType.textArea,
        placeholder: 'Share your thoughts...',
        maxLines: 6,
        minLines: 4,
      ),

      FormFieldConfig(
        name: 'email',
        label: 'Email (optional)',
        type: FormFieldType.email,
        placeholder: 'For follow-up',
        prefixIcon: Icons.email_outlined,
      ),
    ];

    controller.initialize(fields);

    return AppScaffold(
      body: DynamicForm(
        controller: controller,
        fields: fields,
        submitButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton.icon(
            onPressed: () {
              if (controller.validate()) {
                final data = controller.getFormData();
                appLogger('Feedback Data: $data');
                Get.snackbar(
                  'Thank You!',
                  'Your feedback has been submitted',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
                controller.reset(fields);
              }
            },
            icon: const Icon(Icons.send),
            label: const Text('Submit Feedback'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================
// Example 4: Job Application Form
// ==========================

class JobApplicationFormExample extends StatelessWidget {
  JobApplicationFormExample({super.key});

  final controller = Get.put(DynamicFormController());

  @override
  Widget build(BuildContext context) {
    final fields = [
      FormFieldConfig(
        name: 'position',
        label: 'Applying For',
        type: FormFieldType.dropdown,
        isRequired: true,
        options: [
          FormFieldOption(label: 'Frontend Developer', value: 'frontend'),
          FormFieldOption(label: 'Backend Developer', value: 'backend'),
          FormFieldOption(label: 'Full Stack Developer', value: 'fullstack'),
          FormFieldOption(label: 'Mobile Developer', value: 'mobile'),
          FormFieldOption(label: 'UI/UX Designer', value: 'design'),
        ],
      ),

      FormFieldConfig(
        name: 'employmentType',
        label: 'Employment Type',
        type: FormFieldType.radio,
        isRequired: true,
        options: [
          FormFieldOption(label: 'Full-time', value: 'fulltime'),
          FormFieldOption(label: 'Part-time', value: 'parttime'),
          FormFieldOption(label: 'Contract', value: 'contract'),
          FormFieldOption(label: 'Freelance', value: 'freelance'),
        ],
      ),

      FormFieldConfig(
        name: 'experience',
        label: 'Years of Experience',
        type: FormFieldType.slider,
        min: 0,
        max: 20,
        divisions: 20,
        initialValue: 2.0,
        formatter: (value) => '${value.toInt()} years',
      ),

      FormFieldConfig(
        name: 'skills',
        label: 'Technical Skills',
        type: FormFieldType.checkbox,
        isRequired: true,
        options: [
          FormFieldOption(label: 'Flutter/Dart', value: 'flutter'),
          FormFieldOption(label: 'React/Next.js', value: 'react'),
          FormFieldOption(label: 'Node.js', value: 'node'),
          FormFieldOption(label: 'Python', value: 'python'),
          FormFieldOption(label: 'Java/Kotlin', value: 'java'),
          FormFieldOption(label: 'UI/UX Design', value: 'design'),
        ],
      ),

      FormFieldConfig(
        name: 'availableFrom',
        label: 'Available From',
        type: FormFieldType.date,
        isRequired: true,
        formatter: (date) {
          if (date is DateTime) {
            return '${date.day}/${date.month}/${date.year}';
          }
          return '';
        },
      ),

      FormFieldConfig(
        name: 'expectedSalary',
        label: 'Expected Salary (BDT)',
        type: FormFieldType.number,
        placeholder: 'e.g., 50000',
        prefixIcon: Icons.money,
      ),

      FormFieldConfig(
        name: 'coverLetter',
        label: 'Cover Letter',
        type: FormFieldType.textArea,
        placeholder: 'Tell us why you\'re the perfect fit...',
        maxLines: 8,
        minLines: 5,
      ),
    ];

    controller.initialize(fields);

    return AppScaffold(
      body: DynamicForm(
        controller: controller,
        fields: fields,
        submitButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: () {
              if (controller.validate()) {
                final data = controller.getFormData();
                appLogger('Application Data: $data');
                Get.snackbar(
                  'Success',
                  'Application submitted successfully!',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Submit Application'),
          ),
        ),
      ),
    );
  }
}
