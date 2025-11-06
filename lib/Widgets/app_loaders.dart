import 'package:flutter/material.dart';

import '../Config/themes/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader(
      {super.key,
      this.size = 1.0,
      this.value,
      this.color = AppColors.primaryColor,
      this.strokeWidth = 4.0});

  final double size;
  final double? value;
  final Color color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: size,
      child: Center(
        child: CircularProgressIndicator(
          color: color,
          value: value,
          strokeWidth: strokeWidth!,
        ),
      ),
    );
  }
}

/// Transparent loader overlay
class OverLayLoader extends StatelessWidget {
  const OverLayLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black38, // Semi-transparent background color
        child: const Center(
          child: AppLoader(),
        ),
      ),
    );
  }
}
