import 'package:flutter/material.dart';

import '../Widgets/app_loaders.dart';

class LoaderHelper {
  static OverlayEntry? _currentLoader;

  /// Shows a loading overlay
  static void show({
    required BuildContext context,
    bool barrierDismissible = false,
    Color barrierColor = Colors.black54,
  }) {
    // Dismiss any existing loader first
    dismiss();

    final overlay = Overlay.of(context);

    _currentLoader = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Semi-transparent barrier
          ModalBarrier(
            dismissible: barrierDismissible,
            color: barrierColor,
          ),
          // Centered loader
          const Center(child: AppLoader()),
        ],
      ),
    );

    overlay.insert(_currentLoader!);
  }

  /// Dismisses the current loader if visible
  static void dismiss() {
    _currentLoader?.remove();
    _currentLoader = null;
  }

  /// Runs a future with loader automatically shown/hidden
  static Future<T> runWithLoader<T>({
    required BuildContext context,
    required Future<T> future,
    bool barrierDismissible = false,
  }) async {
    show(context: context, barrierDismissible: barrierDismissible);
    try {
      return await future;
    } finally {
      dismiss();
    }
  }
}