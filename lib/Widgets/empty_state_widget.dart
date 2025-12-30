import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import '../Widgets/buttons/primary_button.dart';

class EmptyStateWidget extends StatefulWidget {
  final IconData icon;
  final String? title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;
  final bool showButton;
  final bool animated;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
    this.showButton = true,
    this.animated = true,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _offset = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.animated) {
      _controller.forward();
    } else {
      _controller.value = 1.0; // instantly visible if not animated
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // fractional alignment to shift widget slightly up
    final alignment = Alignment(0, -0.2);

    return SizedBox.expand(
      child: Stack(
        alignment: alignment,
        children: [
          SlideTransition(
            position: _offset,
            child: FadeTransition(
              opacity: _opacity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: context.primaryContainer.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 48,
                      color: context.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  16.height,
                  if (widget.title != null)
                    Text(
                      widget.title!,
                      style: context.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (widget.subtitle != null) ...[
                    8.height,
                    Text(
                      widget.subtitle!,
                      style: context.bodyMedium?.copyWith(
                        color: context.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (widget.showButton &&
              widget.buttonLabel != null &&
              widget.onButtonPressed != null)
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: PrimaryButton(
                label: widget.buttonLabel!,
                icon: Icons.add,
                mainAxisAlignment: MainAxisAlignment.center,
                iconPosition: IconPosition.start,
                onPressed: widget.onButtonPressed!,
              ),
            ),
        ],
      ),
    );
  }
}
