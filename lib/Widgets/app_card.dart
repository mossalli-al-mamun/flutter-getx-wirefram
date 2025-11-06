import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import 'package:flutter_getx_wireframe/Widgets/custom_shadow.dart';

import '../Config/themes/app_sizes.dart';

/// A highly reusable card component that can be used as:
/// - Selector card (with selection state)
/// - Regular card (without selection state)
/// - Custom shadow card
/// - Icon + Label card or just Content card
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    this.onTap,
    this.isSelected = false,
    this.showSelectionState = false,
    this.icon,
    this.label,
    this.child,
    this.padding,
    this.borderRadius = AppSizes.large,
    this.selectedBorderWidth = AppSizes.extraSmall,
    this.unselectedBorderWidth = 1,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.backgroundColor,
    this.iconSize = AppSizes.extraExtraLarge,
    this.iconColor,
    this.selectedIconColor,
    this.labelStyle,
    this.selectedLabelStyle,
    this.shadows,
    this.elevation = 0,
    this.enableShadow = true,
    this.width,
    this.height,
    this.alignment,
    this.splashColor,
    this.highlightColor,
  }) : assert(
         child != null || (icon != null && label != null),
         'Either provide child OR both icon and label',
       );

  // Core properties
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showSelectionState;

  // Content properties
  final IconData? icon;
  final String? label;
  final Widget? child;

  // Layout properties
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  // Border properties
  final double selectedBorderWidth;
  final double unselectedBorderWidth;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;

  // Background properties
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;

  // Icon properties
  final double iconSize;
  final Color? iconColor;
  final Color? selectedIconColor;

  // Text properties
  final TextStyle? labelStyle;
  final TextStyle? selectedLabelStyle;

  // Shadow properties
  final List<BoxShadow>? shadows;
  final double elevation;
  final bool enableShadow;

  // Interaction properties
  final Color? splashColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final cs = context;
    final isDark = context.themeBrightness == Brightness.dark;

    // Determine colors based on selection state
    final effectiveBorderColor = showSelectionState
        ? (isSelected
              ? (selectedBorderColor ?? cs.primary)
              : (unselectedBorderColor ??
                    cs.outlineVariant.withValues(alpha: 0.5)))
        : (unselectedBorderColor ?? cs.outlineVariant.withValues(alpha: 0.5));

    final effectiveBorderWidth = showSelectionState
        ? (isSelected ? selectedBorderWidth : unselectedBorderWidth)
        : unselectedBorderWidth;

    final effectiveBackgroundColor =
        backgroundColor ??
        (showSelectionState
            ? (isSelected
                  ? (selectedColor ?? cs.primaryContainer.withOpacity(0.3))
                  : (unselectedColor ?? Colors.transparent))
            : (unselectedColor ?? Colors.transparent));

    final effectiveIconColor = showSelectionState
        ? (isSelected
              ? (selectedIconColor ?? cs.primary)
              : (iconColor ?? cs.onSurfaceVariant))
        : (iconColor ?? cs.onSurfaceVariant);

    final effectiveLabelStyle = showSelectionState
        ? (isSelected
              ? (selectedLabelStyle ??
                    TextStyle(
                      fontSize: AppSizes.extraLarge2,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ))
              : (labelStyle ??
                    TextStyle(
                      fontSize: AppSizes.extraLarge2,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurfaceVariant,
                    )))
        : (labelStyle ??
              TextStyle(
                fontSize: AppSizes.extraLarge2,
                fontWeight: FontWeight.w500,
                color: cs.onSurface,
              ));

    // Default shadow
    final effectiveShadows =
        shadows ??
        (enableShadow ? [customShadow(context, elevation: elevation)] : null);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
        boxShadow: effectiveShadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: Container(
            padding:
                padding ??
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            alignment: alignment,
            child:
                child ??
                _buildDefaultContent(effectiveIconColor, effectiveLabelStyle),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultContent(Color iconColor, TextStyle labelStyle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) Icon(icon, color: iconColor, size: iconSize),
        if (icon != null && label != null) 8.height,
        if (label != null)
          Text(
            label!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: labelStyle,
          ),
      ],
    );
  }
}

// ============================================
// USAGE EXAMPLES
// ============================================

// Example 1: Theme Selector Card (your original use case)
// class ThemeSelectorCard extends StatelessWidget {
//   const ThemeSelectorCard({
//     super.key,
//     required this.label,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   final String label;
//   final IconData icon;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       icon: icon,
//       label: label,
//       isSelected: isSelected,
//       showSelectionState: true,
//       onTap: onTap,
//       enableShadow: false, // No shadow for theme selector
//     );
//   }
// }
//
// Example 2: Card with Custom Shadow
// class CustomShadowCard extends StatelessWidget {
//   const CustomShadowCard({
//     super.key,
//     required this.child,
//     this.onTap,
//     this.elevation = 4,
//   });
//
//   final Widget child;
//   final VoidCallback? onTap;
//   final double elevation;
//
//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       child: child,
//       onTap: onTap,
//       elevation: elevation,
//       enableShadow: true,
//       backgroundColor: Theme.of(context).cardColor,
//       unselectedBorderColor: Colors.transparent,
//       padding: const EdgeInsets.all(16),
//     );
//   }
// }
//
// // Example 3: Feature Card with Icon
// class FeatureCard extends StatelessWidget {
//   const FeatureCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });
//
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//
//     return AppCard(
//       icon: icon,
//       label: title,
//       onTap: onTap,
//       enableShadow: true,
//       elevation: 2,
//       backgroundColor: cs.surface,
//       iconColor: cs.primary,
//       iconSize: 32,
//       labelStyle: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: cs.onSurface,
//       ),
//     );
//   }
// }
//
// // Example 4: Selectable Option Card
// class SelectableOptionCard extends StatelessWidget {
//   const SelectableOptionCard({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   final String title;
//   final String description;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//
//     return AppCard(
//       isSelected: isSelected,
//       showSelectionState: true,
//       onTap: onTap,
//       enableShadow: true,
//       elevation: 1,
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: isSelected ? cs.primary : cs.onSurface,
//                   ),
//                 ),
//               ),
//               if (isSelected)
//                 Icon(
//                   Icons.check_circle,
//                   color: cs.primary,
//                   size: 24,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             description,
//             style: TextStyle(
//               fontSize: 14,
//               color: cs.onSurfaceVariant,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Example 5: Custom Styled Card
// class CustomStyledCard extends StatelessWidget {
//   const CustomStyledCard({
//     super.key,
//     required this.child,
//     this.onTap,
//   });
//
//   final Widget child;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       child: child,
//       onTap: onTap,
//       enableShadow: true,
//       shadows: [
//         BoxShadow(
//           color: Colors.blue.withOpacity(0.1),
//           blurRadius: 20,
//           offset: const Offset(0, 4),
//           spreadRadius: 2,
//         ),
//         BoxShadow(
//           color: Colors.purple.withOpacity(0.05),
//           blurRadius: 30,
//           offset: const Offset(0, 10),
//           spreadRadius: -5,
//         ),
//       ],
//       borderRadius: 16,
//       backgroundColor: Colors.white,
//       unselectedBorderColor: Colors.grey.shade200,
//       padding: const EdgeInsets.all(20),
//     );
//   }
// }
