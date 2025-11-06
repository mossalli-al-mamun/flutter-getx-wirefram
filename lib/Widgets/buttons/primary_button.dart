import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/appStyles/index.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import '../../Config/themes/app_colors.dart';
import '../app_loaders.dart';

enum IconPosition { start, end }

class PrimaryButton extends StatelessWidget {
  final String? label;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;
  final bool? isDisable;
  final bool? isLoading;
  final VoidCallback onPressed;
  final IconData? icon;
  final IconPosition iconPosition;
  final MainAxisAlignment? mainAxisAlignment;
  final bool? shrinkWrap;
  final bool iconWithText; // New parameter

  const PrimaryButton({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.height = 65.0,
    this.width,
    this.isDisable = false,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.iconPosition = IconPosition.end,
    this.mainAxisAlignment,
    this.shrinkWrap = false,
    this.iconWithText = false, // Default: space between
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor =
    isDisable == true ? context.disabledColor : color ?? context.primary;
    final foregroundColor =
        textColor ?? theme.colorScheme.onPrimary;

    final bool shrink = shrinkWrap == true && width == null;

    // Determine alignment based on icon presence and iconWithText
    MainAxisAlignment effectiveAlignment;
    if (mainAxisAlignment != null) {
      effectiveAlignment = mainAxisAlignment!;
    } else if (icon != null && !iconWithText) {
      // Icon present and NOT with text = space between
      effectiveAlignment = MainAxisAlignment.spaceBetween;
    } else {
      // No icon OR icon with text = center
      effectiveAlignment = MainAxisAlignment.center;
    }

    return SizedBox(
      height: height,
      width: shrink ? null : width ?? double.infinity,
      child: Stack(
        children: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: effectiveColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: const Size(65, 55),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onPressed: isDisable == true || isLoading == true ? null : onPressed,
            child: Row(
              mainAxisSize: shrink ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: effectiveAlignment,
              children: [
                // Start Icon
                if (icon != null && iconPosition == IconPosition.start) ...[
                  Icon(icon, color: foregroundColor),
                  const SizedBox(width: 8),
                ],

                // Label Text
                Flexible(
                  child: Text(
                    label ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: AppTextStyle.titleMedium.copyWith(color: foregroundColor),
                  ),
                ),

                // End Icon
                if (icon != null && iconPosition == IconPosition.end) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: foregroundColor),
                ],
              ],
            ),
          ),

          // Loading Overlay
          if (isLoading == true)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: AppLoader(
                    color: AppColors.whiteColor,
                    size: .7,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Usage Examples:
//
// 1. Icon at end, with text (centered together):
// PrimaryButton(
//   label: 'Next',
//   icon: Icons.arrow_forward,
//   iconPosition: IconPosition.end,
//   iconWithText: true,
//   onPressed: () {},
// )
//
// 2. Icon at start, with text (centered together):
// PrimaryButton(
//   label: 'Back',
//   icon: Icons.arrow_back,
//   iconPosition: IconPosition.start,
//   iconWithText: true,
//   onPressed: () {},
// )
//
// 3. Icon at end, space between:
// PrimaryButton(
//   label: 'Continue',
//   icon: Icons.arrow_forward,
//   iconPosition: IconPosition.end,
//   iconWithText: false, // or omit (default)
//   onPressed: () {},
// )
//
// 4. Icon at start, space between:
// PrimaryButton(
//   label: 'Go Back',
//   icon: Icons.arrow_back,
//   iconPosition: IconPosition.start,
//   iconWithText: false,
//   onPressed: () {},
// )

