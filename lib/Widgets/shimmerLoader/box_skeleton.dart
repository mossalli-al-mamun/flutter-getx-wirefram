import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Config/themes/app_sizes.dart';
import 'shimmer_palette.dart';

/// A reusable shimmer box placeholder.
///
/// Provides flexible width and height using either fixed values or fractional factors.
/// Ideal for image boxes, icons, or rectangular blocks.
class BoxSkeleton extends StatelessWidget {
  final double? width;
  final double? height; // Explicit height (takes precedence)
  final double widthFactor; // Used if width == null
  final double heightFactor; // Used if height == null
  final double borderRadius;
  final bool enabled;

  const BoxSkeleton({
    super.key,
    this.width,
    this.height,
    this.widthFactor = 1.0,
    this.heightFactor = 1.0,
    this.borderRadius = AppSizes.medium,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final pal = ShimmerPalette.of(context);

    final child = Container(
      decoration: BoxDecoration(
        color: pal.block,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
    );

    return Shimmer.fromColors(
      baseColor: pal.base,
      highlightColor: pal.highlight,
      enabled: enabled,

      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: width != null ? null : widthFactor,
          heightFactor: height != null ? null : heightFactor,
          child: SizedBox(width: width, height: height ?? 15, child: child),
        ),
      ),
    );
  }
}
