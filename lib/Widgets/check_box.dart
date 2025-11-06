import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import '../Config/themes/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Offset? origin;
  final double scale;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final double borderWidth;
  final bool isDisabled;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.origin,
    this.scale = 1.2,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    // Determine effective colors
    final effectiveActiveColor = isDisabled
        ? context.disabledColor
        : activeColor ?? context.primary;

    final effectiveCheckColor = checkColor ?? AppColors.whiteColor;

    final effectiveBorderColor = isDisabled
        ? context.disabledColor
        : borderColor ?? context.disabledColor;

    final effectiveBackgroundColor = !isDark && value != true
        ? AppColors.whiteColor
        : null;

    return Transform.scale(
      scale: scale,
      origin: origin,
      child: Checkbox(
        value: value,
        onChanged: isDisabled ? null : onChanged,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return context.disabledColor.withValues(alpha: 0.3);
          }
          if (states.contains(WidgetState.selected)) {
            return effectiveActiveColor;
          }
          return effectiveBackgroundColor;
        }),
        checkColor: effectiveCheckColor,
        side: BorderSide(width: borderWidth, color: effectiveBorderColor),
      ),
    );
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

// 1. Basic checkbox:
// CustomCheckBox(
//   value: isChecked,
//   onChanged: (value) {
//     setState(() => isChecked = value);
//   },
// )

// 2. Disabled checkbox:
// CustomCheckBox(
//   value: true,
//   onChanged: (value) {},
//   isDisabled: true,
// )

// 3. Custom colors:
// CustomCheckBox(
//   value: isAccepted,
//   onChanged: (value) {
//     setState(() => isAccepted = value);
//   },
//   activeColor: Colors.green,
//   checkColor: Colors.white,
//   borderColor: Colors.green,
// )

// 4. Custom scale:
// CustomCheckBox(
//   value: isSelected,
//   onChanged: (value) {
//     setState(() => isSelected = value);
//   },
//   scale: 1.5,
// )

// 5. With custom border width:
// CustomCheckBox(
//   value: isAgreed,
//   onChanged: (value) {
//     setState(() => isAgreed = value);
//   },
//   borderWidth: 2.0,
//   borderColor: Colors.blue,
// )

// 6. In a form with label (like SignIn page):
// InkWell(
//   onTap: () => setState(() => isChecked = !isChecked),
//   borderRadius: BorderRadius.circular(4),
//   child: Row(
//     children: [
//       SizedBox(
//         width: 30,
//         child: CustomCheckBox(
//           value: isChecked,
//           onChanged: (value) {
//             setState(() => isChecked = value ?? false);
//           },
//         ),
//       ),
//       const SizedBox(width: 8),
//       Text('Keep me signed in'),
//     ],
//   ),
// )
