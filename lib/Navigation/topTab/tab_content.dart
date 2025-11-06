import 'package:flutter/material.dart';


class TabContent extends StatelessWidget {
  final String? label;
  final double? width;

  const TabContent({
    super.key,
    required this.label,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: width, // Set your desired tab width
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 22), // Adjust the padding as needed
        child: Tab(text: label),
      ),
    );
  }
}
