// import 'package:flutter/material.dart';
// import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
//
// import '../../Config/themes/appStyles/text_styles.dart';
// import '../../Config/themes/app_colors.dart';
// import '../../Utils/device_dimension.dart';
//
// class SecondaryButton extends StatelessWidget {
//   final String? label;
//   final Color? color;
//   final Color? textColor;
//   final double? height;
//   final double? width;
//   final bool? isDisable;
//   final Function onPressed;
//   final IconData? icon;
//   final bool? shrinkWrap;
//
//   const SecondaryButton({
//     super.key,
//     required this.label,
//     this.color,
//     this.textColor,
//     this.height = 60.0,
//     this.width,
//     this.isDisable = false,
//     required this.onPressed,
//     this.icon,
//     this.shrinkWrap = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final bool shrink = shrinkWrap == true && width == null;
//
//     final ButtonStyle style = OutlinedButton.styleFrom(
//       backgroundColor: isDisable == true
//           ? context.disabledColor
//           : AppColors.whiteColor,
//       side: BorderSide(width: 1, color: context.primary),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//     );
//
//     return Container(
//       height: height,
//       width: width,
//       constraints: shrink
//           ? null
//           : BoxConstraints(
//               maxWidth: deviceDimension(context).width,
//               minHeight: 30.0,
//             ),
//       child: OutlinedButton(
//         style: style,
//         onPressed: () => isDisable == false ? onPressed() : null,
//         child: Row(
//           mainAxisSize: shrink ? MainAxisSize.min : MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (icon != null) ...[
//               Icon(icon, color: context.primary, size: 25),
//               const SizedBox(width: 10),
//             ],
//             if (shrink)
//               Text(
//                 label!,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//                 style: AppTextStyle.titleSmall.copyWith(
//                   color: isDisable == true ? context.disabledColor : null,
//                 ),
//               )
//             else
//               Flexible(
//                 child: Text(
//                   label!,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                   style: AppTextStyle.titleSmall.copyWith(
//                     color: isDisable == true ? context.disabledColor : null,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/appStyles/index.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import '../app_loaders.dart';
import 'primary_button.dart';


class SecondaryButton extends StatelessWidget {
  final String? label;
  final Color? borderColor;
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
  final bool iconWithText;
  final double borderWidth;

  const SecondaryButton({
    super.key,
    required this.label,
    this.borderColor,
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
    this.iconWithText = false,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = isDisable == true
        ? context.disabledColor
        : borderColor ?? context.primary;
    final foregroundColor = isDisable == true
        ? context.disabledColor
        : textColor ?? context.primary;

    final bool shrink = shrinkWrap == true && width == null;

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
      width: shrink ? null : width ?? double.infinity,
      child: Stack(
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: effectiveBorderColor,
                width: borderWidth,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: const Size(65, 55),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              foregroundColor: foregroundColor,
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
                    color: foregroundColor,
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
// 1. Basic outlined button:
// SecondaryButton(
//   label: 'Cancel',
//   onPressed: () {},
// )
//
// 2. With icon and custom border:
// SecondaryButton(
//   label: 'Delete',
//   icon: Icons.delete_outline,
//   iconPosition: IconPosition.start,
//   iconWithText: true,
//   borderColor: Colors.red,
//   textColor: Colors.red,
//   onPressed: () {},
// )
//
// 3. Loading state:
// SecondaryButton(
//   label: 'Processing',
//   isLoading: true,
//   onPressed: () {},
// )
