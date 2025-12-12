import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../../Controller/security/biometric_credentials_controller.dart';

class BiometricCredentialsForm extends StatefulWidget {
  const BiometricCredentialsForm({super.key});

  @override
  State<BiometricCredentialsForm> createState() =>
      _BiometricCredentialsFormState();
}

class _BiometricCredentialsFormState extends State<BiometricCredentialsForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final BiometricCredentialsController _ctl;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _ctl = Get.put(BiometricCredentialsController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<BiometricCredentialsController>()) {
      Get.delete<BiometricCredentialsController>();
    }
    super.dispose();
  }

  void _closeDialog([Map<String, String>? result]) {
    // Works whether dialog is shown via Get.dialog or showDialog
    if (Get.isDialogOpen ?? false) {
      Get.back(result: result);
    } else {
      Navigator.of(context, rootNavigator: true).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final loading = _ctl.isLoading.value;
      final errKey = _ctl.errorText.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'email',
                  enabled: !loading,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: tr['biometricEmailLabel'],
                    hintText: tr['emailPlaceholder'],
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: tr['fieldRequired']),
                        (value) {
                      final v = (value ?? '').trim();
                      if (v.contains('@')) {
                        final emailValidator =
                        FormBuilderValidators.email(errorText: tr['invalidEmail']);
                        return emailValidator(v);
                      }
                      if (v.length < 3) return tr['usernameTooShort'];
                      return null;
                    },
                  ]),
                ),
                12.height,
                FormBuilderTextField(
                  name: 'password',
                  enabled: !loading,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: tr['biometricPasswordLabel'],
                    hintText: tr['passwordPlaceholder'],
                    suffixIcon: IconButton(
                      onPressed:
                      loading ? null : () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: tr['fieldRequired']),
                        (v) {
                      final s = (v ?? '').toString();
                      if (s.length < 6) return tr['passwordTooShort'];
                      return null;
                    },
                  ]),
                ),
              ],
            ),
          ),
          if (errKey != null) ...[
            10.height,
            Text(
              tr[errKey],
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ],
          16.height,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: loading ? null : () => _closeDialog(null),
                  child: Text(tr['cancel']),
                ),
              ),
              10.width,
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: loading
                      ? null
                      : () async {
                    if (_formKey.currentState?.saveAndValidate() != true) return;
                    final values = _formKey.currentState!.value;
                    final email = values['email']?.toString().trim() ?? '';
                    final password = values['password']?.toString() ?? '';
                    final ok = await _ctl.verify(email, password);
                    if (ok) {
                      _closeDialog({'email': email, 'password': password});
                    }
                  },
                  icon: loading
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                      : const Icon(Icons.fingerprint_rounded),
                  label: Text(tr['biometricEnableNow']),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
