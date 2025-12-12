import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';

/// Simple labeled toggle row used across Settings screens.
class ToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: context.primary),
        12.width,
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: context.primary,
        ),
      ],
    );
  }
}
