import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';

import '../../Controller/locale/localization_service_controller.dart';
import '../../Utils/status_utils.dart';

/// Reusable status chip used across list items
///
/// Keep the visual consistent with the app theme: soft background with a thin border
/// and readable foreground color.
class AppStatusChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final IconData? icon;
  final double? iconSize;

  const AppStatusChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.fontSize = 12,
    this.icon,
    this.iconSize,
  });

  /// Builds a status chip from a dynamic status key.
  ///
  /// This is the preferred way to create a status chip, as it centralizes the
  /// status definitions in [StatusHelper].
  factory AppStatusChip.fromStatus(
    BuildContext context, {
    required String statusKey,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 6,
    ),
    double fontSize = 12,
    double? iconSize,
  }) {
    final status = StatusHelper.getStatus(statusKey);
    return AppStatusChip.tone(
      context,
      label: tr[status.labelKey],
      tone: status.tone,
      icon: status.icon,
      padding: padding,
      fontSize: fontSize,
      iconSize: iconSize,
    );
  }

  /// Convenience factory mapping to common tones used in the app
  factory AppStatusChip.tone(
    BuildContext context, {
    required String label,
    required StatusTone tone,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 4,
    ),
    double fontSize = 12,
    IconData? icon,
    double? iconSize,
  }) {
    final colors = _toneColors(context, tone);
    return AppStatusChip(
      label: label,
      backgroundColor: colors.$1,
      foregroundColor: colors.$2,
      borderColor: colors.$3,
      padding: padding,
      fontSize: fontSize,
      icon: icon,
      iconSize: iconSize,
    );
  }

  static (Color, Color, Color) _toneFromRaw(Color base) =>
      (base.withValues(alpha: .12), base, base.withValues(alpha: .3));

  static (Color, Color, Color) _toneColors(
    BuildContext context,
    StatusTone tone,
  ) {
    switch (tone) {
      case StatusTone.success:
        return _toneFromRaw(context.success);
      case StatusTone.warning:
        return _toneFromRaw(context.warning);
      case StatusTone.error:
        return _toneFromRaw(context.error);
      case StatusTone.info:
        return _toneFromRaw(context.primary);
      case StatusTone.neutral:
        final theme = Theme.of(context);
        return (
          theme.colorScheme.surfaceContainerHighest,
          theme.colorScheme.onSurfaceVariant,
          theme.dividerColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: foregroundColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2),
    );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: icon == null
          ? text
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    size: iconSize ?? (fontSize + 2), color: foregroundColor),
                6.width,
                text,
              ],
            ),
    );
  }
}

enum StatusTone { success, warning, error, info, neutral }
