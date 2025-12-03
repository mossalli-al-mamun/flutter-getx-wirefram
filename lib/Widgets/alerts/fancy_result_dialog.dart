import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import '../../Controller/locale/localization_service_controller.dart';

/// A lightweight, attractive result dialog used after submitting a leave request.
/// - success=true shows a success/attention card with pulsating accent.
/// - success=false shows an error-styled card.
/// Uses only core Flutter animations (no extra deps).
class FancyResultDialog extends StatefulWidget {
  final bool success;
  final String? message; // optional server message
  final VoidCallback? onPrimary; // e.g., View History
  final String? primaryLabel;

  const FancyResultDialog({
    super.key,
    required this.success,
    this.message,
    this.onPrimary,
    this.primaryLabel,
  });

  static Future<void> show(
    BuildContext context, {
    required bool success,
    String? message,
    VoidCallback? onPrimary,
    String? primaryLabel,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) => FancyResultDialog(
        success: success,
        message: message,
        onPrimary: onPrimary,
        primaryLabel: primaryLabel,
      ),
    );
  }

  @override
  State<FancyResultDialog> createState() => _FancyResultDialogState();
}

class _FancyResultDialogState extends State<FancyResultDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.98, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glow = Tween<double>(begin: 0.2, end: 0.55).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final success = widget.success;
    final Color accent = success ? Colors.orange : context.dangerColor;
    final Color bg = theme.cardColor;

    final title = success ? tr['leaveSubmittedTitle'] : tr['leaveSubmissionFailed'];
    final subtitle = widget.message ??
        (success ? tr['leaveSubmittedMessage'] : tr['tryAgain']);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: bg,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_controller]),
              builder: (context, _) {
                return Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          accent.withValues(alpha: 0.25 + _glow.value * 0.15),
                          accent.withValues(alpha: 0.45 + _glow.value * 0.25),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: _glow.value),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      success ? Icons.schedule_rounded : Icons.error_outline_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                );
              },
            ),
            16.height,
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            8.height,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            16.height,
            Row(
              children: [
                if (widget.onPrimary != null) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onPrimary?.call();
                      },
                      child: Text(widget.primaryLabel ?? 'View history'),
                    ),
                  ),
                  10.width,
                ],
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(tr.ok),
                  ),
                ),
              ],
            ),
            6.height,
          ],
        ),
      ),
    );
  }
}
