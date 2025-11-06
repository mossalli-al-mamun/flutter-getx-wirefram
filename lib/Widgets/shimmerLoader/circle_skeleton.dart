import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/themes/app_sizes.dart';
import 'shimmer_palette.dart';

/// A reusable circular or rounded avatar shimmer placeholder.
///
/// Supports configurable [size] and [borderRadius] for future-proof flexibility.
class CircleSkeleton extends StatelessWidget {
  final double size;
  final double borderRadius;
  final bool enabled;

  const CircleSkeleton({
    super.key,
    this.size = 90,
    this.borderRadius = AppSizes.extraExtraExtraLarge,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final pal = ShimmerPalette.of(context);
    return Shimmer.fromColors(
      baseColor: pal.base,
      highlightColor: pal.highlight,
      enabled: enabled,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: pal.block,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
