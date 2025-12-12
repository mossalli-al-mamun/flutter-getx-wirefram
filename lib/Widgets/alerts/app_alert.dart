import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../animations/animated_status_icon.dart';
import 'app_alert_dialog_widget.dart';

class AppAlert {
  /// Confirm dialog
  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool danger = false,
    bool barrierDismissible = false,
    bool showLeading = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppAlertDialog(
        title: title,
        message: message,
        confirmText: confirmText ?? tr.confirm,
        cancelText: cancelText ?? tr.cancel,
        danger: danger,
        leading: showLeading
            ? AnimatedStatusIcon(
                icon: danger
                    ? Icons.warning_amber_rounded
                    : Icons.help_outline_rounded,
                color: danger ? Colors.red : Colors.orange,
                size: 72,
              )
            : null,
      ),
    );
    return result == true;
  }

  /// Info / success dialog
  static Future<void> showInfo(
      BuildContext context, {
        String? title,
        String? message,
        String? buttonText,
        IconData? icon,
        Color? color,
        bool success = true, // ✅ new
        bool barrierDismissible = true,
      }) {
    // Determine defaults based on success/failure state
    final theme = Theme.of(context);
    final bool isSuccess = success;
    final IconData defaultIcon = isSuccess
        ? Icons.check_circle_outline_rounded
        : Icons.error_outline_rounded;

    // final isSuccess = success;
    final Color accent = success ? Colors.orange : context.dangerColor;
    final Color bg = theme.cardColor;

    final successTitles = [tr['dialogSuccessTone3'], tr['dialogSuccessTone5']];
    final failTitles = [tr['dialogFailedTone1'], tr['dialogFailedTone2']];
    final titleValue =
        title ??
            (success
                ? successTitles.elementAt(
              DateTime.now().millisecond % successTitles.length,
            )
                : failTitles.elementAt(
              DateTime.now().millisecond % failTitles.length,
            ));

    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppAlertDialog(
        title: titleValue,
        message: message,
        confirmText: buttonText ?? tr.ok,
        cancelText: null,
        backgroundColor: bg,
        success: success,
        leading: AnimatedStatusIcon(
          icon: icon ?? defaultIcon,
          color: color ?? accent,
          size: 80,
        ),
      ),
    );
  }

  /// Biometric enable dialog
  static Future<bool> showBiometricEnable(
    BuildContext context, {
    bool barrierDismissible = true, // added
  }) async {
    final res = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppAlertDialog(
        title: tr['enableBiometricLoginTitle'],
        message: tr['enableBiometricLoginMessage'],
        confirmText: tr['enable'],
        cancelText: tr['noThanks'],
        leading: const AnimatedStatusIcon(
          icon: Icons.fingerprint_rounded,
          color: Colors.blue,
          size: 84,
        ),
      ),
    );
    return res == true;
  }

  /// Biometric credentials dialog (custom form)
  static Future<Map<String, String>?> showBiometricCredentials(
    BuildContext context, {
    required Widget form,
    bool barrierDismissible = false, // added
  }) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppAlertDialog(
        title: tr['biometricEnterCredentialsTitle'],
        message: tr['biometricEnterCredentialsSubtitle'],
        confirmText: null,
        cancelText: null,
        content: form,
        leading: const AnimatedStatusIcon(
          icon: Icons.fingerprint_rounded,
          color: Colors.blue,
          size: 84,
        ),
      ),
    );
    return result;
  }
}
