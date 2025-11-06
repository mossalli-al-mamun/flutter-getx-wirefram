import 'package:flutter/material.dart';

/// Provides theme-aware shimmer base/highlight and block colors.
class ShimmerPalette {
  final Color base;
  final Color highlight;
  final Color block;

  const ShimmerPalette({
    required this.base,
    required this.highlight,
    required this.block,
  });

  static ShimmerPalette of(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (isDark) {
      return ShimmerPalette(
        base: Colors.grey.shade800,
        highlight: Colors.grey.shade700,
        block: Colors.grey.shade900,
      );
    } else {
      return ShimmerPalette(
        base: Colors.grey.shade300,
        highlight: Colors.grey.shade100,
        block: Colors.white,
      );
    }
  }
}
