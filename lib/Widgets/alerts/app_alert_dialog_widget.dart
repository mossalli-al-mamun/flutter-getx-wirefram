import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import '../../Controller/locale/localization_service_controller.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String? confirmText; // primary button
  final String? secondaryText; // secondary button for failure
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onSecondary;
  final VoidCallback? onCancel;
  final bool success; // ✅ new
  final bool danger;
  final Color? backgroundColor;
  final Widget? leading;
  final MainAxisAlignment actionsAlignment;

  const AppAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmText,
    this.secondaryText,
    this.cancelText,
    this.onConfirm,
    this.onSecondary,
    this.onCancel,
    this.success = true,
    this.danger = false,
    this.backgroundColor,
    this.leading,
    this.actionsAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = danger
        ? context.dangerColor
        : theme.colorScheme.primary;
    final Color bg = backgroundColor ?? theme.cardColor;

    // Build buttons without Expanded
    final List<Widget> buttons = [];

    // Always show cancel button if provided
    if (cancelText != null) {
      buttons.add(
        OutlinedButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
          child: Text(cancelText ?? tr.cancel),
        ),
      );
    }

    // Conditional main button
    if (success && confirmText != null) {
      // success → show filed button
      buttons.add(
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
      );
    } else if (!success) {
      // failure → show outline button
      buttons.add(
        OutlinedButton(
          onPressed: () {
            onSecondary?.call();
            Navigator.of(context).pop(false);
          },
          style: ButtonStyle(
            side: WidgetStateProperty.all(BorderSide(color: accent)),
          ),
          child: Text(tr.ok),
        ),
      );
    }

    // Actions widget
    Widget actionsWidget;
    if (buttons.isEmpty) {
      actionsWidget = const SizedBox.shrink();
    } else if (buttons.length == 1) {
      actionsWidget = SizedBox(width: double.infinity, child: buttons.first);
    } else {
      actionsWidget = Row(
        mainAxisAlignment: actionsAlignment,
        children: [
          Expanded(child: buttons[0]),
          10.width,
          Expanded(child: buttons[1]),
        ],
      );
    }

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      backgroundColor: bg,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: leading != null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading!, 16.height],
          Text(
            title,
            textAlign: leading != null ? TextAlign.center : TextAlign.start,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      // content: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     content ??
      //         (message != null
      //             ? Text(
      //                 message!,
      //                 textAlign: leading != null
      //                     ? TextAlign.center
      //                     : TextAlign.start,
      //                 style: theme.textTheme.bodyMedium?.copyWith(
      //                   color: theme.colorScheme.onSurfaceVariant,
      //                 ),
      //               )
      //             : const SizedBox.shrink()),
      //     if (buttons.isNotEmpty) ...[16.height, actionsWidget],
      //   ],
      // ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Always show the message if provided
          if (message != null)
            Text(
              message!,
              textAlign: leading != null ? TextAlign.center : TextAlign.start,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

          // Then custom content if any
          if (content != null) ...[
            if (message != null) 12.height,
            // spacing between message and content
            content!,
          ],

          // Action buttons
          if (buttons.isNotEmpty) ...[16.height, actionsWidget],
        ],
      ),

      actions: null, // do not use actions
    );
  }
}
