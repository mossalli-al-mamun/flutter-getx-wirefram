import 'package:flutter/material.dart';

enum LabelPosition { start, center, end }

// Reusable Divider with Label
class AppDivider extends StatelessWidget {
  final String? label;
  final LabelPosition labelPosition;
  final Axis direction;
  final double thickness;
  final Color? color;
  final TextStyle? labelStyle;
  final double spacing;

  const AppDivider({
    super.key,
    this.label,
    this.labelPosition = LabelPosition.center,
    this.direction = Axis.horizontal,
    this.thickness = 1,
    this.color,
    this.labelStyle,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null || label!.isEmpty) {
      return _buildDivider();
    }

    if (direction == Axis.horizontal) {
      return _buildHorizontalDivider(context);
    } else {
      return _buildVerticalDivider(context);
    }
  }

  Widget _buildDivider() {
    if (direction == Axis.horizontal) {
      return Divider(thickness: thickness, color: color);
    } else {
      return VerticalDivider(thickness: thickness, color: color);
    }
  }

  Widget _buildHorizontalDivider(BuildContext context) {
    final labelWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing),
      child: Text(label!, style: labelStyle),
    );

    switch (labelPosition) {
      case LabelPosition.start:
        return Row(
          children: [
            labelWidget,
            Expanded(
              child: Divider(thickness: thickness, color: color),
            ),
          ],
        );
      case LabelPosition.end:
        return Row(
          children: [
            Expanded(
              child: Divider(thickness: thickness, color: color),
            ),
            labelWidget,
          ],
        );
      case LabelPosition.center:
        return Row(
          children: [
            Expanded(
              child: Divider(thickness: thickness, color: color),
            ),
            labelWidget,
            Expanded(
              child: Divider(thickness: thickness, color: color),
            ),
          ],
        );
    }
  }

  Widget _buildVerticalDivider(BuildContext context) {
    final labelWidget = Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: Text(label!, style: labelStyle),
    );

    switch (labelPosition) {
      case LabelPosition.start:
        return Column(
          children: [
            labelWidget,
            Expanded(
              child: VerticalDivider(thickness: thickness, color: color),
            ),
          ],
        );
      case LabelPosition.end:
        return Column(
          children: [
            Expanded(
              child: VerticalDivider(thickness: thickness, color: color),
            ),
            labelWidget,
          ],
        );
      case LabelPosition.center:
        return Column(
          children: [
            Expanded(
              child: VerticalDivider(thickness: thickness, color: color),
            ),
            labelWidget,
            Expanded(
              child: VerticalDivider(thickness: thickness, color: color),
            ),
          ],
        );
    }
  }
}

// Usage Examples

// Horizontal divider with start label
// AppDivider(
//   label: 'Start',
//   labelPosition: LabelPosition.start,
// ),

// Vertical divider with start label
// SizedBox(
//   height: 100,
//   width:80,
//   child: AppDivider(
//     label: 'Start',
//     labelPosition: LabelPosition.start,
//     direction: Axis.vertical,
//   ),
// )

// Plain divider (no label)
// const AppDivider(),