import 'package:flutter/material.dart';

/// A reusable pulsing/glowing icon widget.
/// Can be used for success, error, info, or any custom icon/color.
class AnimatedStatusIcon extends StatefulWidget {
  final IconData icon; // Custom icon
  final Color color; // Icon/gradient accent color
  final double size; // Total widget size
  final Duration duration; // Animation duration
  final bool pulse; // If true, enable pulsing animation

  const AnimatedStatusIcon({
    super.key,
    required this.icon,
    required this.color,
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

    if (widget.pulse) {
      _controller.repeat(reverse: true);
    }

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

///example
//// Info
// AnimatedStatusIcon(
//   icon: Icons.info_outline_rounded,
//   color: Colors.blue,
// );
//
// // Custom size & pulse off
// AnimatedStatusIcon(
//   icon: Icons.star,
//   color: Colors.orange,
//   size: 60,
//   pulse: false,
// );
