import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Enum for different shape types
enum ShapeType { circle, oval, rectangle, stadium, diamond }

/// Enum for different icon/image types
enum IconContentType {
  materialIcon,
  svgAsset,
  svgNetwork,
  imageAsset,
  imageNetwork,
  imageFile,
  widget,
}

/// Highly customizable shape container with support for various icon types
class CustomShapeIcon extends StatelessWidget {
  // Shape properties
  final ShapeType shapeType;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Gradient? gradient;

  // Border properties
  final Color borderColor;
  final double borderWidth;
  final BorderStyle borderStyle;

  // Icon/Image content
  final dynamic content;
  final IconContentType contentType;
  final double? contentSize;
  final Color? contentColor;
  final BoxFit imageFit;

  // Additional customization
  final double borderRadius;
  final EdgeInsets? padding;
  final List<BoxShadow>? shadows;
  final BlendMode? colorBlendMode;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const CustomShapeIcon({
    super.key,
    required this.content,
    required this.contentType,
    this.shapeType = ShapeType.circle,
    this.width = 60.0,
    this.height = 60.0,
    this.backgroundColor,
    this.gradient,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1.0,
    this.borderStyle = BorderStyle.solid,
    this.contentSize,
    this.contentColor,
    this.imageFit = BoxFit.contain,
    this.borderRadius = 12.0,
    this.padding,
    this.shadows,
    this.colorBlendMode,
    this.onTap,
    this.semanticLabel,
  });

  // Factory constructors for common use cases
  factory CustomShapeIcon.icon({
    required IconData icon,
    ShapeType shapeType = ShapeType.circle,
    double size = 60.0,
    double? iconSize,
    Color? iconColor,
    Color? backgroundColor,
    Gradient? gradient,
    Color borderColor = Colors.transparent,
    double borderWidth = 1.0,
    double borderRadius = 12.0,
    EdgeInsets? padding,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return CustomShapeIcon(
      content: icon,
      contentType: IconContentType.materialIcon,
      shapeType: shapeType,
      width: size,
      height: size,
      contentSize: iconSize ?? size * 0.5,
      contentColor: iconColor,
      backgroundColor: backgroundColor,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      padding: padding,
      shadows: shadows,
      onTap: onTap,
    );
  }

  factory CustomShapeIcon.svg({
    required String assetPath,
    ShapeType shapeType = ShapeType.circle,
    double size = 60.0,
    double? iconSize,
    Color? iconColor,
    Color? backgroundColor,
    Gradient? gradient,
    Color borderColor = Colors.transparent,
    double borderWidth = 1.0,
    double borderRadius = 12.0,
    EdgeInsets? padding,
    List<BoxShadow>? shadows,
    BoxFit fit = BoxFit.contain,
    VoidCallback? onTap,
  }) {
    return CustomShapeIcon(
      content: assetPath,
      contentType: IconContentType.svgAsset,
      shapeType: shapeType,
      width: size,
      height: size,
      contentSize: iconSize ?? size * 0.55,
      contentColor: iconColor,
      backgroundColor: backgroundColor,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      padding: padding,
      shadows: shadows,
      imageFit: fit,
      onTap: onTap,
    );
  }

  factory CustomShapeIcon.image({
    required String path,
    bool isNetwork = false,
    ShapeType shapeType = ShapeType.circle,
    double size = 60.0,
    Color? backgroundColor,
    Gradient? gradient,
    Color borderColor = Colors.transparent,
    double borderWidth = 1.0,
    double borderRadius = 12.0,
    EdgeInsets? padding,
    List<BoxShadow>? shadows,
    BoxFit fit = BoxFit.cover,
    VoidCallback? onTap,
  }) {
    return CustomShapeIcon(
      content: path,
      contentType: isNetwork
          ? IconContentType.imageNetwork
          : IconContentType.imageAsset,
      shapeType: shapeType,
      width: size,
      height: size,
      backgroundColor: backgroundColor,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      padding: padding,
      shadows: shadows,
      imageFit: fit,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.all(width * 0.15);

    Widget container = Container(
      width: width,
      height: height,
      padding: effectivePadding,
      decoration: ShapeDecoration(
        color: gradient == null
            ? (backgroundColor ?? Colors.transparent)
            : null,
        gradient: gradient,
        shadows: shadows,
        shape: _getShapeBorder(),
      ),
      child: _buildContent(context),
    );

    if (onTap != null) {
      container = GestureDetector(onTap: onTap, child: container);
    }

    if (semanticLabel != null) {
      container = Semantics(label: semanticLabel, child: container);
    }

    return container;
  }

  ShapeBorder _getShapeBorder() {
    final borderSide = BorderSide(
      color: borderColor,
      width: borderWidth,
      style: borderStyle,
    );

    switch (shapeType) {
      case ShapeType.circle:
        return CircleBorder(side: borderSide);
      case ShapeType.oval:
        return OvalBorder(side: borderSide);
      case ShapeType.rectangle:
        return RoundedRectangleBorder(
          side: borderSide,
          borderRadius: BorderRadius.circular(borderRadius),
        );
      case ShapeType.stadium:
        return StadiumBorder(side: borderSide);
      case ShapeType.diamond:
        return BeveledRectangleBorder(
          side: borderSide,
          borderRadius: BorderRadius.circular(borderRadius),
        );
    }
  }

  Widget _buildContent(BuildContext context) {
    switch (contentType) {
      case IconContentType.materialIcon:
        return Icon(
          content as IconData,
          size: contentSize,
          color: contentColor,
        );

      case IconContentType.svgAsset:
        return SvgPicture.asset(
          content as String,
          width: contentSize,
          height: contentSize,
          fit: imageFit,
          colorFilter: contentColor != null
              ? ColorFilter.mode(
                  contentColor!,
                  colorBlendMode ?? BlendMode.srcIn,
                )
              : null,
        );

      case IconContentType.svgNetwork:
        return SvgPicture.network(
          content as String,
          width: contentSize,
          height: contentSize,
          fit: imageFit,
          colorFilter: contentColor != null
              ? ColorFilter.mode(
                  contentColor!,
                  colorBlendMode ?? BlendMode.srcIn,
                )
              : null,
        );

      case IconContentType.imageAsset:
        return Image.asset(
          content as String,
          width: contentSize,
          height: contentSize,
          fit: imageFit,
          color: contentColor,
          colorBlendMode: colorBlendMode,
        );

      case IconContentType.imageNetwork:
        return Image.network(
          content as String,
          width: contentSize,
          height: contentSize,
          fit: imageFit,
          color: contentColor,
          colorBlendMode: colorBlendMode,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        );

      case IconContentType.imageFile:
        return Image.file(
          content,
          width: contentSize,
          height: contentSize,
          fit: imageFit,
          color: contentColor,
          colorBlendMode: colorBlendMode,
        );

      case IconContentType.widget:
        return content as Widget;
    }
  }
}

// Example usage demonstrations

// Material Icon with Circle
// CustomShapeIcon.icon(
//   icon: Icons.favorite,
//   iconColor: Colors.red,
//   backgroundColor: Colors.red.shade50,
//   borderColor: Colors.red,
//   borderWidth: 2,
// ),
//
// // SVG Asset with Rounded Rectangle
// CustomShapeIcon.svg(
//   assetPath: 'assets/icons/logo.svg',
//   shapeType: ShapeType.rectangle,
//   backgroundColor: Colors.blue.shade50,
//   borderColor: Colors.blue,
//   borderWidth: 2,
// ),
//
// // Image with Stadium Shape
// CustomShapeIcon.image(
//   path: 'https://picsum.photos/200',
//   isNetwork: true,
//   shapeType: ShapeType.stadium,
//   size: 80,
//   borderColor: Colors.purple,
//   borderWidth: 3,
//   fit: BoxFit.cover,
// ),
//
// // Icon with Gradient Background
// CustomShapeIcon.icon(
//   icon: Icons.star,
//   iconColor: Colors.white,
//   gradient: LinearGradient(colors: [Colors.orange, Colors.pink]),
//   shapeType: ShapeType.diamond,
//   shadows: [
//     BoxShadow(
//       color: Colors.black26,
//       blurRadius: 8,
//       offset: Offset(0, 4),
//     ),
//   ],
// ),
//
// // Custom Widget Content
// CustomShapeIcon(
//   content: Text(
//     '42',
//     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//   ),
//   contentType: IconContentType.widget,
//   shapeType: ShapeType.circle,
//   backgroundColor: Colors.green.shade100,
//   borderColor: Colors.green,
//   borderWidth: 2,
// ),
