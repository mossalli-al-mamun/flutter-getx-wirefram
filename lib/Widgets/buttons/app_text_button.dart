import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/appStyles/index.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';

enum TextButtonIconPosition { start, end }

class AppTextButton extends StatelessWidget {
  final String? label;
  final Color? textColor;
  final double? height;
  final double? width;
  final bool isDisable;
  final bool isLoading;
  final VoidCallback onPressed;
  final IconData? icon;
  final TextButtonIconPosition iconPosition;
  final MainAxisAlignment? mainAxisAlignment;
  final bool shrinkWrap;
  final bool iconWithText;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;
  final double? iconSize;
  final bool underline;

  const AppTextButton({
    super.key,
    required this.label,
    this.textColor,
    this.height,
    this.width,
    this.isDisable = false,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.iconPosition = TextButtonIconPosition.end,
    this.mainAxisAlignment,
    this.shrinkWrap = true,
    this.iconWithText = true,
    this.textStyle,
    this.buttonStyle,
    this.iconSize = 18,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isDisable
        ? context.disabledColor
        : textColor ?? context.primary;

    final bool shrink = shrinkWrap && width == null;

    // Determine alignment based on icon presence and iconWithText
    MainAxisAlignment effectiveAlignment;
    if (mainAxisAlignment != null) {
      effectiveAlignment = mainAxisAlignment!;
    } else if (icon != null && !iconWithText) {
      effectiveAlignment = MainAxisAlignment.spaceBetween;
    } else {
      effectiveAlignment = MainAxisAlignment.center;
    }

    return SizedBox(
      height: height,
      width: shrink ? null : width,
      child: Stack(
        children: [
          TextButton(
            style:
                buttonStyle ??
                TextButton.styleFrom(
                  foregroundColor: foregroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: const Size(48, 36),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            onPressed: isDisable || isLoading ? null : onPressed,
            child: Row(
              mainAxisSize: shrink ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: effectiveAlignment,
              children: [
                // Start Icon
                if (icon != null &&
                    iconPosition == TextButtonIconPosition.start) ...[
                  Icon(icon, size: iconSize, color: foregroundColor),
                  const SizedBox(width: 6),
                ],

                // Label Text
                Flexible(
                  child: Text(
                    label ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style:
                        textStyle ??
                        AppTextStyle.bodyMedium.copyWith(
                          color: foregroundColor,
                          decoration: underline
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          decorationColor: foregroundColor,
                        ),
                  ),
                ),

                // End Icon
                if (icon != null &&
                    iconPosition == TextButtonIconPosition.end) ...[
                  const SizedBox(width: 6),
                  Icon(icon, size: iconSize, color: foregroundColor),
                ],
              ],
            ),
          ),

          // Loading Overlay
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        foregroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

// 1. Basic text button:
// AppTextButton(
//   label: 'Learn More',
//   onPressed: () {},
// )

// 2. With underline:
// AppTextButton(
//   label: 'Forgot Password?',
//   underline: true,
//   onPressed: () {},
// )

// 3. With icon at start:
// AppTextButton(
//   label: 'Back',
//   icon: Icons.arrow_back,
//   iconPosition: TextButtonIconPosition.start,
//   onPressed: () {},
// )

// 4. With icon at end:
// AppTextButton(
//   label: 'Next',
//   icon: Icons.arrow_forward,
//   iconPosition: TextButtonIconPosition.end,
//   onPressed: () {},
// )

// 5. Icon with text (centered):
// AppTextButton(
//   label: 'Download',
//   icon: Icons.download,
//   iconPosition: TextButtonIconPosition.start,
//   iconWithText: true,
//   onPressed: () {},
// )

// 6. Icon with space between:
// AppTextButton(
//   label: 'Open',
//   icon: Icons.open_in_new,
//   iconWithText: false,
//   shrinkWrap: false,
//   width: 200,
//   onPressed: () {},
// )

// 7. Custom color:
// AppTextButton(
//   label: 'Delete',
//   textColor: Colors.red,
//   icon: Icons.delete_outline,
//   iconPosition: TextButtonIconPosition.start,
//   onPressed: () {},
// )

// 8. Loading state:
// AppTextButton(
//   label: 'Loading...',
//   isLoading: true,
//   onPressed: () {},
// )

// 9. Disabled state:
// AppTextButton(
//   label: 'Unavailable',
//   isDisable: true,
//   onPressed: () {},
// )

// 10. Full width text button:
// AppTextButton(
//   label: 'Show All',
//   shrinkWrap: false,
//   width: double.infinity,
//   onPressed: () {},
// )
