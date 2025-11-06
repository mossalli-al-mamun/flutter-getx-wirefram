import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';

class BoxImageContainer extends StatelessWidget {
  const BoxImageContainer(
      {super.key,
      this.height = 90.0,
      this.width = 90.0,
      this.lineStroke = 1.0,
      this.child});

  final double height;
  final double width;
  final double lineStroke;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: context.disabledColor, width: lineStroke)),
      child: child,
    );
  }
}
