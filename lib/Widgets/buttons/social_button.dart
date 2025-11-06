import 'package:flutter/material.dart';

// Reusable Social Button
class SocialButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final Color? iconColor;
  final VoidCallback onTap;
  final SocialButtonSize size;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? iconSize;

  const SocialButton({
    super.key,
    this.icon,
    this.imagePath,
    this.iconColor,
    required this.onTap,
    this.size = SocialButtonSize.medium,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius,
    this.iconSize,
  }) : assert(
         icon != null || imagePath != null,
         'Either icon or imagePath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDimensions();
    final effectiveIconSize = iconSize ?? dimensions.iconSize;
    final effectiveBorderRadius = borderRadius ?? 8.0;

    return InkWell(
      borderRadius: BorderRadius.circular(effectiveBorderRadius),
      onTap: onTap,
      child: Container(
        height: dimensions.height,
        width: dimensions.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor ?? Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
        ),
        child: Center(child: _buildContent(effectiveIconSize)),
      ),
    );
  }

  Widget _buildContent(double size) {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error, size: size, color: Colors.red);
        },
      );
    } else {
      return Icon(icon, color: iconColor, size: size);
    }
  }

  _ButtonDimensions _getDimensions() {
    switch (size) {
      case SocialButtonSize.small:
        return _ButtonDimensions(height: 40, width: 70, iconSize: 20);
      case SocialButtonSize.medium:
        return _ButtonDimensions(height: 50, width: 90, iconSize: 24);
      case SocialButtonSize.large:
        return _ButtonDimensions(height: 60, width: 110, iconSize: 28);
      case SocialButtonSize.custom:
        return _ButtonDimensions(height: 50, width: 90, iconSize: 24);
    }
  }
}

enum SocialButtonSize { small, medium, large, custom }

class _ButtonDimensions {
  final double height;
  final double width;
  final double iconSize;

  _ButtonDimensions({
    required this.height,
    required this.width,
    required this.iconSize,
  });
}

// Usage Examples

// SocialButton(
//   icon: Icons.g_mobiledata,
//   iconColor: Colors.red,
//   onTap: () {},
//   size: SocialButtonSize.medium,
// ),
//
// SocialButton(
//   icon: Icons.facebook,
//   iconColor: Colors.blue,
//   onTap: () {},
//   size: SocialButtonSize.large,
// ),
//
// SocialButton(
//   imagePath: 'assets/icons/apple_logo.png',
//   onTap: () {},
//   size: SocialButtonSize.small,
// ),
