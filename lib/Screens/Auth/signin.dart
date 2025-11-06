import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Navigation/navigation_ext.dart';
import 'package:flutter_getx_wireframe/Navigation/routes.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:flutter_getx_wireframe/Widgets/app_scaffold.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Config/themes/text_styles.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../../Services/apiController/auth_api_controller.dart';
import '../../Widgets/app_divider.dart';
import '../../Widgets/buttons/app_text_button.dart';
import '../../Widgets/buttons/social_button.dart';
import '../../Widgets/check_box.dart';
import '../../Widgets/form/unified_input_field.dart';
import '../../Widgets/headers/auth_header.dart';
import '../../Widgets/buttons/primary_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, this.purpose});

  final String? purpose;

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthApiController authDataGetX = Get.find<AuthApiController>();

  bool showPassword = false;
  bool keepMeSignedIn = false;

  @override
  void dispose() {
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleKeepMeSignedIn(bool? value) {
    setState(() {
      keepMeSignedIn = value ?? false;
    });
  }

  bool get areAllFieldsFilled {
    final formState = _formKey.currentState;
    if (formState == null) return false;

    return formState.fields.entries.every(
      (entry) =>
          entry.value.value != null &&
          entry.value.value.toString().trim().isNotEmpty,
    );
  }

  Future<void> handleSignIn() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = Map<String, dynamic>.from(_formKey.currentState!.value);
      formData['keepMeSignedIn'] = keepMeSignedIn;
      await authDataGetX.signIn(context, formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> formFields = [
      {
        'name': 'Email',
        'label': tr.email,
        'placeHolder': tr.emailPlaceholder,
        'suffixIcon': FeatherIcons.mail,
        'initialValue': '',
        'required': true,
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
        'required': true,
        'obscureText': true,
        'validators': FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(8),
        ]),
      },
    ];

    return AppScaffold(
      body: Column(
        children: [
          // Header
          AuthHeader(title: tr.login, subTitle: tr.letsLogin),

          40.height,

          // Sign In Form
          FormBuilder(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Fields
                ...formFields.asMap().entries.map((entry) {
                  final field = entry.value;
                  final isPasswordField = field['name'] == 'Password';

                  // return AppFormFieldFloating(
                  //   name: field['name']!,
                  //   label: field['label'],
                  //   hintText: field['placeHolder'],
                  //   isPassword: isPasswordField,
                  //   obscureText: isPasswordField && !showPassword,
                  //   onToggleVisibility: togglePasswordVisibility,
                  //   validator: field['validators'],
                  //   isRequired: field['required'],
                  //   spacing: 25,
                  // );

                  // return AppFormField(
                  //   name: field['name']!,
                  //   label: field['label'],
                  //   hintText: field['placeHolder'],
                  //   isPasswordField: isPasswordField,
                  //   showPassword: showPassword,
                  //   togglePasswordVisibility: togglePasswordVisibility,
                  //   validator: field['validators'],
                  //   isLastField: isLastField,
                  //   isRequired: field['required'],
                  // );

                  return UnifiedInputField(
                    style: InputFieldStyle.standard,
                    name: field['name']!,
                    label: field['label'],
                    hintText: field['placeHolder'],
                    isPassword: isPasswordField,
                    // validator: field['validators'],
                    isRequired: field['required'],
                  );
                }),

                20.height,

                // Keep Me Signed In & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Keep Me Signed In Checkbox
                    InkWell(
                      onTap: () => toggleKeepMeSignedIn(!keepMeSignedIn),
                      borderRadius: BorderRadius.circular(4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: CustomCheckBox(
                              value: keepMeSignedIn,
                              onChanged: toggleKeepMeSignedIn,
                            ),
                          ),
                          Text(tr.rememberMe),
                        ],
                      ),
                    ),

                    // Forgot Password Button
                    AppTextButton(
                      label: tr.forgotPassword,
                      underline: true,
                      onPressed: () {
                        context.pushNamed(AppRoutes.forgotPassword);
                      },
                    ),
                  ],
                ),

                20.height,

                // Sign In Button
                Obx(
                  () => PrimaryButton(
                    label: tr.login,
                    isDisable: !areAllFieldsFilled,
                    isLoading: authDataGetX.isLoading.value,
                    onPressed: handleSignIn,
                  ),
                ),

                20.height,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr.dontHaveAccount,
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),

                    AppTextButton(
                      label: tr.createAccount,
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
                        context.pushNamed(AppRoutes.signUp);
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
                        // TODO: handle Facebook login
                      },
                    ),
                    SocialButton(
                      icon: FontAwesomeIcons.google,
                      onTap: () {
                        // TODO: handle Google login
                      },
                    ),
                    SocialButton(
                      icon: FeatherIcons.facebook,
                      onTap: () {
                        // TODO: handle Apple login
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
