import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';

import '../../../Widgets/custom_shape_icon.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CustomShapeIcon.icon(
                icon: icon,
                iconColor: context.primary,
                backgroundColor: context.primaryContainer.withValues(alpha: 0.4),
                shapeType: ShapeType.rectangle,
                size: 40,
              ),
              16.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: context.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      2.height,
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                8.width,
                trailing!,
              ] else ...[
                8.width,
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
