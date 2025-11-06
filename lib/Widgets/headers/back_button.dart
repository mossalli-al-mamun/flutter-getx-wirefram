import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class AppBackButton extends StatelessWidget {
  final Function? onPressed;

  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 4),
      icon: const Icon(Icons.arrow_back_outlined),
      onPressed: () => onPressed != null ? onPressed!() : navigator?.pop(),
    );
  }
}
