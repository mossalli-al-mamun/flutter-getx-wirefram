import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../animations/animated_status_icon.dart';

/// A lightweight full-screen overlay that shows an attractive success animation
/// right after authentication succeeds. It masks any short delays before
/// navigating to the dashboard.
///
/// Usage:
///   final handle = AuthSuccessOverlay.show(context);
///   // ... do post-login work ...
///   await handle.close();
class SuccessOverlay {
  SuccessOverlay._();

  /// Shows the overlay and returns a handle you can call `close()` on.
  /// A minimum display time is enforced to let the animation be seen.
  static SuccessOverlayHandle show(
    BuildContext context, {
    Duration minDisplay = const Duration(milliseconds: 800),
    String? title,
    String? subtitle,
  }) {
    final overlayState = Overlay.of(context);

    final start = DateTime.now();
    final entry = OverlayEntry(
      builder: (ctx) => _SuccessWidget(title: title, subtitle: subtitle),
    );

    overlayState.insert(entry);

    Future<void> ensureMinTime() async {
      final elapsed = DateTime.now().difference(start);
      if (elapsed < minDisplay) {
        await Future.delayed(minDisplay - elapsed);
      }
    }

    return SuccessOverlayHandle._(
      closeImpl: () async {
        await ensureMinTime();
        try {
          entry.remove();
        } catch (_) {}
      },
    );
  }
}

class SuccessOverlayHandle {
  final Future<void> Function() _closeImpl;
  bool _closed = false;

  SuccessOverlayHandle._({required Future<void> Function() closeImpl})
    : _closeImpl = closeImpl;

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _closeImpl();
  }
}

class _SuccessWidget extends StatefulWidget {
  final String? title;
  final String? subtitle;

  const _SuccessWidget({this.title, this.subtitle});

  @override
  State<_SuccessWidget> createState() => _AuthSuccessWidgetState();
}

class _AuthSuccessWidgetState extends State<_SuccessWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.title ?? tr['dialogSuccessTone3'];
    final subtitle = widget.subtitle ?? tr['welcomeBack'];

    return AbsorbPointer(
      absorbing: true,
      child: Container(
        color: Colors.black.withValues(alpha: 0.25),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Material(
              color: theme.cardColor,
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedStatusIcon(),
                    16.height,
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    8.height,
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

