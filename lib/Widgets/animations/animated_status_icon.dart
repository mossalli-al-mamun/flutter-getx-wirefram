import 'package:flutter/material.dart';

/// A reusable pulsing/glowing icon widget with default icon & color.
/// Can be used for success, error, info, or any custom icon/color.
class AnimatedStatusIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final Duration duration;
  final bool pulse;

  /// Default icon: check_circle_outline_rounded
  /// Default color: green
  const AnimatedStatusIcon({
    super.key,
    this.icon = Icons.check_circle_outline_rounded,
    this.color = Colors.green,
    this.size = 84,
    this.duration = const Duration(milliseconds: 1400),
    this.pulse = true,
  });

  @override
  State<AnimatedStatusIcon> createState() => _AnimatedStatusIconState();
}

class _AnimatedStatusIconState extends State<AnimatedStatusIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.pulse) _controller.repeat(reverse: true);

    _scale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glow = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final scale = widget.pulse ? _scale.value : 1.0;
        final glow = widget.pulse ? _glow.value : 0.0;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.6 + glow * 0.4,
                colors: [
                  widget.color.withOpacity(0.25 + glow * 0.15),
                  widget.color.withOpacity(0.45 + glow * 0.25),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(glow),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              size: widget.size * 0.5,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
