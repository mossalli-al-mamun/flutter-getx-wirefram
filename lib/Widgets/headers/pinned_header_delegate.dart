import 'package:flutter/material.dart';

/// A reusable SliverPersistentHeaderDelegate with configurable min/max height
/// and a builder that exposes shrinkOffset and overlapsContent.
class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget Function(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) builder;

  PinnedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  bool shouldRebuild(covariant PinnedHeaderDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight || maxHeight != oldDelegate.maxHeight;
  }
}
