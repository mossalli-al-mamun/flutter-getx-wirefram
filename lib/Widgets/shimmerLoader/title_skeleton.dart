import 'package:flutter/material.dart';
import 'box_skeleton.dart';

/// A reusable shimmer placeholder for a title + subtitle block.
class TitleSkeleton extends StatelessWidget {
  const TitleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        BoxSkeleton(width: 120, height: 18),
        SizedBox(height: 6),
        BoxSkeleton(width: 180, height: 14),
      ],
    );
  }
}