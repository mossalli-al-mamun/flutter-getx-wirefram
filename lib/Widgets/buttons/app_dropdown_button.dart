import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/appStyles/index.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:flutter_getx_wireframe/Widgets/buttons/primary_button.dart';

// enum DropdownIconPosition { start, end }

class AppDropdownButton extends StatelessWidget {
  final String? label;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconColor;
  final double? height;
  final double? width;
  final bool isDisable;
  final VoidCallback onPressed;
  final IconData? icon;
  final IconPosition iconPosition;
  final double borderWidth;
  final bool outlined;
  final TextStyle? textStyle;
  final double? iconSize;

  const AppDropdownButton({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.iconColor,
    this.height = 36.0,
    this.width,
    this.isDisable = false,
    required this.onPressed,
    this.icon,
    this.iconPosition = IconPosition.end,
    this.borderWidth = 1.5,
    this.outlined = false,
    this.textStyle,
    this.iconSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine effective colors
    final effectiveBackgroundColor = isDisable
        ? context.disabledColor.withValues(alpha: 0.1)
        : outlined
        ? Colors.transparent
        : (backgroundColor ?? (isDark ? theme.cardColor : null));

    final effectiveBorderColor = isDisable
        ? context.disabledColor
        : borderColor ?? (outlined ? context.primary : Colors.transparent);

    final effectiveTextColor = isDisable
        ? context.disabledColor
        : textColor ?? theme.textTheme.bodyLarge?.color;

    final effectiveIconColor = isDisable
        ? context.disabledColor
        : iconColor ?? effectiveTextColor;

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: isDisable ? null : onPressed,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          border: Border.all(
            color: effectiveBorderColor,
            width: outlined || borderColor != null ? borderWidth : 0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: width != null ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Start Icon (custom icon)
            if (icon != null && iconPosition == IconPosition.start) ...[
              Icon(icon, size: iconSize, color: effectiveIconColor),
              8.width,
            ],

            // Label Text
            Flexible(
              child: Text(
                label ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    textStyle ??
                    AppTextStyle.bodyMedium.copyWith(color: effectiveTextColor),
              ),
            ),

            5.width,

            // Chevron Icon (always at the end)
            Icon(
              FeatherIcons.chevronDown,
              size: iconSize,
              color: effectiveIconColor,
            ),

            // End Icon (custom icon after chevron)
            if (icon != null && iconPosition == IconPosition.end) ...[
              8.width,
              Icon(icon, size: iconSize, color: effectiveIconColor),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

// 1. Basic dropdown:
// AppDropdownButton(
//   label: 'Select Option',
//   onPressed: () {},
// )

// 2. Outlined style:
// AppDropdownButton(
//   label: 'Select Category',
//   outlined: true,
//   onPressed: () {},
// )

// 3. With custom colors:
// AppDropdownButton(
//   label: 'Select Date',
//   backgroundColor: Colors.blue.shade50,
//   textColor: Colors.blue.shade900,
//   iconColor: Colors.blue,
//   onPressed: () {},
// )

// 4. With start icon:
// AppDropdownButton(
//   label: 'Select Country',
//   icon: Icons.flag,
//   iconPosition: DropdownIconPosition.start,
//   onPressed: () {},
// )

// 5. Disabled state:
// AppDropdownButton(
//   label: 'Disabled',
//   isDisable: true,
//   onPressed: () {},
// )

// 6. Outlined with custom border:
// AppDropdownButton(
//   label: 'Select Priority',
//   outlined: true,
//   borderColor: Colors.red,
//   textColor: Colors.red,
//   iconColor: Colors.red,
//   borderWidth: 2.0,
//   onPressed: () {},
// )

// 7. Fixed width:
// AppDropdownButton(
//   label: 'Filter',
//   width: 150,
//   outlined: true,
//   onPressed: () {},
// )
