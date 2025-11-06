import 'package:flutter/material.dart';

import '../Utils/global_variables.dart';

enum SnackType { info, success, error }

class AppSnackBar {
  // Contextless, global show using rootScaffoldMessengerKey
  static void showGlobal(
    String message, {
    SnackType type = SnackType.info,
    int durationSeconds = 3,
  }) {
    final messenger = GlobalVariables.rootScaffoldMessengerKey.currentState;
    if (messenger == null) return; // App not ready yet

    final themeContext = messenger.context;
    final theme = Theme.of(themeContext);

    final colors = _resolveColors(type, theme);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: colors.$2),
        ),
        backgroundColor: colors.$1,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: durationSeconds),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Backward-compatible, context-based show
  static void show(
    BuildContext context,
    String message, {
    SnackType type = SnackType.info,
    int durationSeconds = 3,
  }) {
    final theme = Theme.of(context);
    final colors = _resolveColors(type, theme);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: colors.$2),
        ),
        backgroundColor: colors.$1,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: durationSeconds),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Convenience helpers
  static void success(BuildContext context, String message, {int durationSeconds = 3}) {
    show(context, message, type: SnackType.success, durationSeconds: durationSeconds);
  }

  static void error(BuildContext context, String message, {int durationSeconds = 4}) {
    show(context, message, type: SnackType.error, durationSeconds: durationSeconds);
  }

  static void info(BuildContext context, String message, {int durationSeconds = 3}) {
    show(context, message, type: SnackType.info, durationSeconds: durationSeconds);
  }

  // Contextless convenience helpers
  static void successGlobal(String message, {int durationSeconds = 3}) {
    showGlobal(message, type: SnackType.success, durationSeconds: durationSeconds);
  }

  static void errorGlobal(String message, {int durationSeconds = 4}) {
    showGlobal(message, type: SnackType.error, durationSeconds: durationSeconds);
  }

  static void infoGlobal(String message, {int durationSeconds = 3}) {
    showGlobal(message, type: SnackType.info, durationSeconds: durationSeconds);
  }

  // Returns (bgColor, fgColor)
  static (Color, Color) _resolveColors(SnackType type, ThemeData theme) {
    switch (type) {
      case SnackType.success:
        return (Colors.green.shade600, Colors.white);
      case SnackType.error:
        return (Colors.red.shade600, Colors.white);
      case SnackType.info:
      default:
        return (theme.colorScheme.inverseSurface, theme.colorScheme.onInverseSurface);
    }
  }
}
