import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Navigation/navigation_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:flutter_getx_wireframe/Widgets/app_scaffold.dart';
import 'package:flutter_getx_wireframe/Widgets/headers/navigation_header.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Config/themes/appStyles/form_style.dart';
import '../../Config/themes/text_styles.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../../Services/apiController/auth_api_controller.dart';
import '../../Widgets/app_divider.dart';
import '../../Widgets/buttons/app_text_button.dart';
import '../../Widgets/buttons/social_button.dart';
import '../../Widgets/check_box.dart';
import '../../Widgets/headers/auth_header.dart';
import '../../Widgets/buttons/primary_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthApiController authDataGetX = Get.put(AuthApiController());

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool agreeToTerms = false;

  @override
  void dispose() {
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      showConfirmPassword = !showConfirmPassword;
    });
  }

  void toggleAgreeToTerms(bool? value) {
    setState(() {
      agreeToTerms = value ?? false;
    });
  }

  bool get areAllFieldsFilled {
    final formState = _formKey.currentState;
    if (formState == null) return false;

    return formState.fields.entries.every(
          (entry) =>
              entry.value.value != null &&
              entry.value.value.toString().trim().isNotEmpty,
        ) &&
        agreeToTerms;
  }

  Future<void> handleSignUp() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;

      // Add agreeToTerms to form data
      formData['agreeToTerms'] = agreeToTerms;

      // await authDataGetX.signUp(context, formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> formFields = [
      {
        'name': 'FullName',
        'label': tr.fullName,
        'placeHolder': tr.fullNamePlaceholder,
        'suffixIcon': FeatherIcons.user,
        'initialValue': '',
        'validators': FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(3),
        ]),
      },
      {
        'name': 'Email',
        'label': tr.email,
        'placeHolder': tr.emailPlaceholder,
        'suffixIcon': FeatherIcons.mail,
        'initialValue': '',
        'validators': FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.email(),
        ]),
      },
      {
        'name': 'Password',
        'label': tr.password,
        'placeHolder': tr['passwordPlaceholder'],
        'suffixIcon': FeatherIcons.eyeOff,
        'initialValue': '',
        'obscureText': true,
        'validators': FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(8),
        ]),
      },
      {
        'name': 'ConfirmPassword',
        'label': tr.confirmPassword,
        'placeHolder': tr.confirmPasswordPlaceholder,
        'suffixIcon': FeatherIcons.eyeOff,
        'initialValue': '',
        'obscureText': true,
        'isConfirmPassword': true,
        'validators': FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          (val) {
            if (val != _formKey.currentState?.fields['Password']?.value) {
              return tr.passwordsDoNotMatch;
            }
            return null;
          },
        ]),
      },
    ];

    return AppScaffold(
      appBar: NavigationHeader(),
      body: Column(
        children: [
          // Header
          AuthHeader(title: tr.createAccount, subTitle: tr.letsSignUp),

          40.height,

          // Sign Up Form
          FormBuilder(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Fields
                ...formFields.asMap().entries.map((entry) {
                  final index = entry.key;
                  final field = entry.value;
                  final isLastField = index == formFields.length - 1;
                  final isPasswordField = field['name'] == 'Password';
                  final isConfirmPasswordField =
                      field['isConfirmPassword'] == true;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field Label
                      Text(
                        field['label'] ?? field['name'],
                        style: AppTextStyle.labelMedium,
                      ),

                      10.height,

                      // Text Field
                      FormBuilderTextField(
                        name: field['name']!,
                        initialValue: field['initialValue'],
                        obscureText:
                            (isPasswordField && !showPassword) ||
                            (isConfirmPasswordField && !showConfirmPassword),
                        cursorColor: context.primary,
                        decoration: appFormStyle(
                          context: context,
                          hintText: field['placeHolder'],
                          suffixIcon: isPasswordField
                              ? IconButton(
                                  onPressed: togglePasswordVisibility,
                                  icon: Icon(
                                    showPassword
                                        ? FeatherIcons.eye
                                        : FeatherIcons.eyeOff,
                                  ),
                                )
                              : isConfirmPasswordField
                              ? IconButton(
                                  onPressed: toggleConfirmPasswordVisibility,
                                  icon: Icon(
                                    showConfirmPassword
                                        ? FeatherIcons.eye
                                        : FeatherIcons.eyeOff,
                                  ),
                                )
                              : Icon(field['suffixIcon']),
                        ),
                        validator: field['validators'],
                      ),

                      (isLastField ? 5 : 24).height,
                    ],
                  );
                }),

                20.height,

                // Terms and Conditions Checkbox
                InkWell(
                  onTap: () => toggleAgreeToTerms(!agreeToTerms),
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: CustomCheckBox(
                          value: agreeToTerms,
                          onChanged: toggleAgreeToTerms,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              tr.iAgreeToThe,
                              style: AppTextStyle.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to terms and conditions
                              },
                              child: Text(
                                tr.termsAndConditions,
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: context.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                20.height,

                // Sign Up Button
                Obx(
                  () => PrimaryButton(
                    label: tr.createAccount,
                    isDisable: !areAllFieldsFilled,
                    isLoading: authDataGetX.isLoading.value,
                    onPressed: handleSignUp,
                  ),
                ),

                20.height,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr.alreadyHaveAccount,
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),

                    AppTextButton(
                      label: tr.login,
                      underline: true,
                      buttonStyle: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 5,
                        ),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ],
                ),

                25.height,

                // Divider
                AppDivider(label: tr.orContinueWith),

                25.height,

                // Social Auth Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialButton(
                      icon: FontAwesomeIcons.apple,
                      onTap: () {
                        // TODO: handle Apple signup
                      },
                    ),
                    SocialButton(
                      icon: FontAwesomeIcons.google,
                      onTap: () {
                        // TODO: handle Google signup
                      },
                    ),
                    SocialButton(
                      icon: FeatherIcons.facebook,
                      onTap: () {
                        // TODO: handle Facebook signup
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
