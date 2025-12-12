import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import '../../../../Controller/locale/localization_service_controller.dart';

class SheetHeader extends StatelessWidget {
  /// Total number of items (optional)
  final int? totalItems;

  /// Leading icon (default: event_busy)
  final IconData icon;

  /// Optional callback when close button is pressed
  final VoidCallback? onClose;

  /// Optional custom title and subtitle
  final String? title;
  final String? subtitle;

  const SheetHeader({
    super.key,
    this.totalItems,
    this.icon = Icons.event_busy_rounded,
    this.onClose,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic title
    final titleText = title ?? 'Header title';

    final subtitleText =
        subtitle ??
        (tr['viewUpcomingLeaves'] != 'viewUpcomingLeaves'
            ? tr['viewUpcomingLeaves']
            : 'View upcoming leaves');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _DragHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
          child: Row(
            children: [
              // Leading icon container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: context.primary, size: 24),
              ),
              14.width,

              // Title & subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: context.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    2.height,
                    Text(
                      subtitleText,
                      style: context.bodySmall?.copyWith(
                        color: context.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Close button
              IconButton(
                tooltip: tr.close,
                onPressed: onClose ?? () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: context.onSurfaceVariant,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: context.surfaceContainerHighest?.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: context.dividerColor.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: context.dividerColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
