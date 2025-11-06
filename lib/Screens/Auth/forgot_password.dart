import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Navigation/navigation_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:flutter_getx_wireframe/Widgets/app_scaffold.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../Config/themes/appStyles/form_style.dart';
import '../../Config/themes/text_styles.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../../Services/apiController/auth_api_controller.dart';
import '../../Widgets/buttons/app_text_button.dart';
import '../../Widgets/buttons/primary_button.dart';
import '../../Widgets/headers/auth_header.dart';
import '../../Widgets/headers/navigation_header.dart' show NavigationHeader;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthApiController authDataGetX = Get.find<AuthApiController>();

  bool get areAllFieldsFilled {
    final formState = _formKey.currentState;
    if (formState == null) return false;

    return formState.fields.entries.every(
      (entry) =>
          entry.value.value != null &&
          entry.value.value.toString().trim().isNotEmpty,
    );
  }

  Future<void> handleForgotPassword() async {
    if (_formKey.currentState!.saveAndValidate()) {
      // final formData = _formKey.currentState!.value;

      // await authDataGetX.forgotPassword(context, formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: NavigationHeader(),
      body: Column(
        children: [
          // Header
          AuthHeader(
            title: tr.forgotPassword,
            subTitle: tr.forgotPasswordSubtitle,
          ),

          40.height,

          // Forgot Password Form
          FormBuilder(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email Field Label
                Text(tr.email, style: AppTextStyle.labelMedium),

                10.height,

                // Email Text Field
                FormBuilderTextField(
                  name: tr.email,
                  initialValue: '',
                  cursorColor: context.primary,
                  decoration: appFormStyle(
                    context: context,
                    hintText: tr.emailPlaceholder,
                    suffixIcon: Icon(FeatherIcons.mail),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),

                30.height,

                // Send Reset Link Button
                Obx(
                  () => PrimaryButton(
                    label: tr.sendResetLink,
                    isDisable: !areAllFieldsFilled,
                    isLoading: authDataGetX.isLoading.value,
                    onPressed: handleForgotPassword,
                  ),
                ),

                20.height,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr.rememberPassword,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
