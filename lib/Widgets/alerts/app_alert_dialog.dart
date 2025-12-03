import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';

import '../../Controller/locale/localization_service_controller.dart';

/// AppAlertDialog: a reusable, styled alert for consistency across the app.
///
/// Use AppAlert.showConfirm(...) for quick confirm dialogs.
class AppAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool danger; // when true, uses danger accent for confirm
  final bool barrierDismissible;

  const AppAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.danger = false,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = danger ? context.dangerColor : theme.colorScheme.primary;

    final Widget dialogContent = content ??
        (message != null
            ? Text(
                message!,
                style: theme.textTheme.bodyMedium,
              )
            : const SizedBox.shrink());

    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      content: dialogContent,
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: () {
              onCancel?.call();
              Navigator.of(context).pop(false);
            },
            child: Text(cancelText ?? tr.cancel),
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          child: Text(confirmText ?? tr.ok),
        ),
      ],
    );
  }
}

/// Convenience API for showing app-styled alerts.
class AppAlert {
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    String? confirmText,
    String? cancelText,
    bool danger = false,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppAlertDialog(
        title: title,
        message: message,
        content: content,
        confirmText: confirmText ?? tr.ok,
        cancelText: cancelText ?? tr.cancel,
        danger: danger,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    String? buttonText,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AppAlertDialog(
        title: title,
        message: message,
        content: content,
        confirmText: buttonText ?? tr.ok,
        cancelText: null,
      ),
    );
  }
}
