import 'package:flutter/material.dart';

class SampleAnimations extends StatefulWidget {
  const SampleAnimations({super.key});

  @override
  State<SampleAnimations> createState() => _SampleAnimationsState();
}

class _SampleAnimationsState extends State<SampleAnimations>
    with TickerProviderStateMixin {
  final Color toggleColor = Colors.green;

  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _slideAnimation;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _slideController]),
          builder: (context, _) {
            final glow = _glowAnimation.value;
            final slideShift =
                (_slideController.value * 0.15); // adds soft motion

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                // match your slider radius
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0 + slideShift, 0.5 + slideShift, 1.0],
                  colors: [
                    toggleColor.withValues(alpha: 0.1 + glow * 0.10),
                    // near toggle
                    toggleColor.withValues(alpha: 0.1 + glow * 0.10),
                    // mid flow
                    toggleColor.withValues(alpha: 0.25 + glow * 0.25),
                    // rich glow end
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    // Positioned.fill(
    //   child: IgnorePointer(
    //     ignoring: true,
    //     child: AnimatedBuilder(
    //       animation: _pulseController,
    //       builder: (context, _) {
    //         return CustomPaint(
    //           painter: _RipplePainter(
    //             color: toggleColor.withOpacity(0.15),
    //             progress: _pulseController.value,
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // ),

    // Positioned.fill(
    //   child: AnimatedBuilder(
    //     animation: _pulseController,
    //     builder: (context, _) {
    //       final angle = _pulseController.value * 2 * 3.1416;
    //       final orbitRadius = 24.0;
    //       final center = Alignment.center.alongSize(Size.zero);
    //       return Stack(
    //         children: [
    //           for (int i = 0; i < 3; i++)
    //             Transform.translate(
    //               offset: Offset(
    //                 orbitRadius * Math.cos(angle + i * 2.09),
    //                 orbitRadius * Math.sin(angle + i * 2.09),
    //               ),
    //               child: Align(
    //                 alignment: Alignment.center,
    //                 child: Container(
    //                   width: 6,
    //                   height: 6,
    //                   decoration: BoxDecoration(
    //                     color: toggleColor.withOpacity(0.6),
    //                     shape: BoxShape.circle,
    //                     boxShadow: [
    //                       BoxShadow(
    //                         color: toggleColor.withOpacity(0.5),
    //                         blurRadius: 6,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //         ],
    //       );
    //     },
    //   ),
    // ),

    //Breathing Gradient
    // Positioned.fill(
    //   child: AnimatedBuilder(
    //     animation: _pulseController,
    //     builder: (context, _) {
    //       final glow = _glowAnimation.value;
    //       return Container(
    //         decoration: BoxDecoration(
    //           gradient: RadialGradient(
    //             center: Alignment.center,
    //             radius: glow,
    //             colors: [
    //               toggleColor.withOpacity(0.1),
    //               Colors.transparent,
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // ),

    //Breathing Gradient with ico
    // Positioned.fill(child: AnimatedBuilder(
    //   animation: _controller,
    //   builder: (context, _) {
    //     return Transform.scale(
    //       scale: _scale.value,
    //       child: Container(
    //         width: 96,
    //         height: 96,
    //         decoration: BoxDecoration(
    //           shape: BoxShape.circle,
    //           gradient: LinearGradient(
    //             colors: [
    //               theme.colorScheme.primary
    //                   .withValues(alpha: 0.25 + _glow.value * 0.15),
    //               theme.colorScheme.primary
    //                   .withValues(alpha: 0.45 + _glow.value * 0.25),
    //             ],
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //           ),
    //           boxShadow: [
    //             BoxShadow(
    //               color: theme.colorScheme.primary
    //                   .withValues(alpha: _glow.value),
    //               blurRadius: 24,
    //               spreadRadius: 2,
    //             ),
    //           ],
    //         ),
    //         child: const Icon(
    //           Icons.check_rounded,
    //           size: 48,
    //           color: Colors.white,
    //         ),
    //       ),
    //     );
    //   },
    // ));

    //Shimmer
    // Positioned.fill(
    //   child: IgnorePointer(
    //     ignoring: true,
    //     child: AnimatedBuilder(
    //       animation: _slideController,
    //       builder: (context, _) {
    //         final dx = (_slideController.value * 2) - 1; // -1..1
    //         return Align(
    //           alignment: Alignment(dx, 0),
    //           child: Container(
    //             width: 60,
    //             decoration: BoxDecoration(
    //               gradient: LinearGradient(
    //                 begin: Alignment.centerLeft,
    //                 end: Alignment.centerRight,
    //                 colors: [
    //                   Colors.transparent,
    //                   toggleColor.withOpacity(0.12),
    //                   Colors.transparent,
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // ),
  }
}

class _RipplePainter extends CustomPainter {
  final Color color;
  final double progress;

  _RipplePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.6;
    final radius = progress * maxRadius;
    final opacity = (1 - progress).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
