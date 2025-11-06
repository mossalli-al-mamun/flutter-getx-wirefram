import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import '../Config/themes/text_styles.dart';
import '../Config/themes/app_colors.dart';
import '../Controller/locale/localization_service_controller.dart';
import '../Utils/device_dimension.dart';
import '../Widgets/buttons/primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String? title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;
  final bool showButton;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final double verticalOffset = showButton ? -40 : 0;

    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered content with conditional offset
          AnimatedAlign(
            alignment: Alignment(0, verticalOffset / 100), // smooth slide up
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 48, color: AppColors.greyColor),
                ),
                16.height,
                title != null
                    ? Text(
                        title!,
                        style: AppTextStyle.titleSmall,
                        textAlign: TextAlign.center,
                      )
                    : SizedBox.shrink(),
                8.height,
                SizedBox(
                  width: deviceDimension(context).width * 0.6,
                  child: Text(
                    subtitle ?? tr.emptyData('Results'),
                    style: AppTextStyle.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          if (showButton && buttonLabel != null && onButtonPressed != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PrimaryButton(
                  label: buttonLabel!,
                  icon: Icons.add,
                  mainAxisAlignment: MainAxisAlignment.center,
                  iconPosition: IconPosition.start,
                  onPressed: onButtonPressed!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
