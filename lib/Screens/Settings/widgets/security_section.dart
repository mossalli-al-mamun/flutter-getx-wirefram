import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Widgets/alerts/app_alert.dart';
import '../../../Widgets/form/biometric_credentials_form.dart';
import 'settings_section_header.dart';
import 'settings_list_tile.dart';
import '../../../Controller/locale/localization_service_controller.dart';
import '../../../Utils/security/biometric_auth_service.dart';
import '../../../Widgets/app_toast.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    final bio = Get.find<BiometricAuthService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionHeader(title: tr['security']),
        Obx(
              () => SettingsListTile(
            icon: Icons.fingerprint_rounded,
            title: tr['biometricLogin'],
            subtitle: tr['useFaceTouchId'],
            trailing: Switch(
              value: bio.enabled.value,
              onChanged: (v) async {
                // Turning OFF
                if (!v) {
                  bool confirmed = false;
                  if (context.mounted) {
                    // confirmed = await ConfirmDialog.show(
                    //   context,
                    //   title: tr['disableBiometricLoginTitle'],
                    //   message: tr['disableBiometricLoginMessage'],
                    //   confirmLabel: tr['disable'],
                    //   cancelLabel: tr['cancel'],
                    //   danger: true,
                    // );
                    confirmed = await AppAlert.showConfirm(
                      context,
                      title: tr['disableBiometricLoginTitle'],
                      message: tr['disableBiometricLoginMessage'],
                      danger: false,
                      barrierDismissible: false,
                      showLeading: false,
                    );
                  }
                  if (!confirmed) {
                    // User canceled; leave as enabled. Switch reflects bio.enabled via Obx.
                    return;
                  }
                  await bio.setBiometricEnabled(false);
                  if (context.mounted) {
                    AppToast.show(context, tr['biometricsDisabledSuccess']);
                  }
                  return;
                }

                // Turning ON
                final can = await bio.canCheckBiometrics();
                if (!can) {
                  if (context.mounted) {
                    AppToast.show(context, tr['biometricsNotAvailable']);
                  }
                  return; // Do not flip; switch reflects bio.enabled
                }

                bool confirmed = false;
                if (context.mounted) {
                  confirmed = await AppAlert.showBiometricEnable(context);
                }
                if (!confirmed) {
                  return; // User canceled; keep disabled
                }

                // Step 1: Verify biometrics immediately after enabling confirmation
                final bioOk = await bio.verifyBiometrics(
                  reason: tr['biometricPromptReason'],
                );
                if (!bioOk) {
                  if (context.mounted) {
                    await AppAlert.showInfo(
                      context,
                      success: false,
                      message: tr['biometricVerifyFailed'],
                    );
                  }
                  return;
                }

                // Step 2: Ask for credentials to save securely and verify inline inside the dialog
                Map<String, String>? creds;
                if (context.mounted) {
                  creds = await AppAlert.showBiometricCredentials(
                    context,
                    form: const BiometricCredentialsForm(),
                    barrierDismissible: false,
                  );
                }
                if (creds == null) {
                  // User cancelled or verification failed inside dialog; do not enable
                  return;
                }

                // Step 3: Save and enable (credentials already server-verified in dialog)
                await bio.saveCredentials(
                  creds['email'] ?? '',
                  creds['password'] ?? '',
                );
                await bio.setBiometricEnabled(true);
                if (context.mounted) {
                  // await
                  // FancyResultDialog.show(
                  //   context,
                  //   success: true,
                  //   message: tr['biometricsEnabledSuccess'],
                  // );
                  await AppAlert.showInfo(
                    context,
                    success: true,
                    message: tr['biometricVerifyFailed'],
                  );
                  // await AppAlert.showInfo(context, message: tr['biometricsEnabledSuccess']);
                }
              },
            ),
          ),
        ),
        SettingsListTile(
          icon: Icons.phonelink_lock_rounded,
          title: tr['twoFactorAuthentication'],
        ),
      ],
    );
  }
}
