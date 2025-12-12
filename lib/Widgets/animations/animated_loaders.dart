import 'package:flutter/material.dart';
import 'dart:math';

enum WaveLoaderMode {
  dot,
  line,
  circular,
}

class FlexibleWaveLoader extends StatefulWidget {
  final WaveLoaderMode mode;
  final int dotCount;
  final double dotSize;       // width/height for dot or line
  final double lineHeight;    // max height in line mode
  final double spacing;       // horizontal spacing (ignored in circular)
  final double circularRadius; // only used in circular mode
  final Color? color;
  final Duration duration;
  final bool pulse;           // dot/line pulse

  const FlexibleWaveLoader({
    super.key,
    this.mode = WaveLoaderMode.dot,
    this.dotCount = 5,
    this.dotSize = 8,
    this.lineHeight = 28,
    this.spacing = 4,
    this.circularRadius = 24,
    this.color,
    this.duration = const Duration(milliseconds: 1200),
    this.pulse = false,
  });

  @override
  State<FlexibleWaveLoader> createState() => _FlexibleWaveLoaderState();
}

class _FlexibleWaveLoaderState extends State<FlexibleWaveLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateHeight(int index, double progress) {
    final phase = (progress + index / widget.dotCount) % 1.0;
    final wave = sin(phase * pi);
    return widget.mode == WaveLoaderMode.line
        ? widget.dotSize + wave * (widget.lineHeight - widget.dotSize)
        : widget.dotSize;
  }

  double _calculateOffset(int index, double progress) {
    if (widget.mode == WaveLoaderMode.dot) {
      final phase = (progress + index / widget.dotCount) % 1.0;
      return -sin(phase * pi) * (widget.lineHeight - widget.dotSize) / 2;
    }
    return 0;
  }

  double _calculateScale(int index, double progress) {
    if (!widget.pulse) return 1.0;
    final phase = (progress + index / widget.dotCount) % 1.0;
    return 0.8 + (sin(phase * 2 * pi) + 1) * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    if (widget.mode == WaveLoaderMode.circular) {
      return SizedBox(
        width: widget.circularRadius * 2 + widget.dotSize * 2,
        height: widget.circularRadius * 2 + widget.dotSize * 2,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return Stack(
              alignment: Alignment.center,
              children: List.generate(widget.dotCount, (i) {
                final angle = 2 * pi * i / widget.dotCount;
                final progress = (_controller.value + i / widget.dotCount) % 1.0;
                final alpha = 0.3 + 0.7 * sin(progress * pi);

                final dx = cos(angle) * widget.circularRadius;
                final dy = sin(angle) * widget.circularRadius;

                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Opacity(
                    opacity: alpha.clamp(0.0, 1.0),
                    child: Container(
                      width: widget.dotSize,
                      height: widget.dotSize,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      );
    }

    // Dot or Line mode
    return SizedBox(
      height: widget.lineHeight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final progress = _controller.value;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.dotCount, (i) {
              final height = _calculateHeight(i, progress);
              final offsetY = _calculateOffset(i, progress);
              final scale = _calculateScale(i, progress);

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
                child: Transform.translate(
                  offset: Offset(0, offsetY),
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: widget.dotSize,
                      height: height,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(widget.dotSize),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}


///examples
//FlexibleWaveLoader(
//   mode: WaveLoaderMode.dot,
//   dotCount: 5,
//   dotSize: 10,
//   lineHeight: 28,
//   spacing: 6,
//   pulse: true,
//   color: Colors.orange,
// )

//FlexibleWaveLoader(
//   mode: WaveLoaderMode.line,
//   dotCount: 5,
//   dotSize: 8,
//   lineHeight: 28,
//   spacing: 6,
//   pulse: true,
//   color: Colors.orange,
// )

//FlexibleWaveLoader(
//   mode: WaveLoaderMode.circular,
//   dotCount: 8,
//   dotSize: 8,
//   circularRadius: 24,
//   color: Colors.blue,
// )




class OrbitingDotWaveLoader extends StatefulWidget {
  final int dotCount;
  final double dotSize;
  final double orbitRadius;
  final Color? color;
  final Duration duration;
  final bool pulse; // should each dot scale
  final double verticalOffset; // for wave effect along circle

  const OrbitingDotWaveLoader({
    super.key,
    this.dotCount = 8,
    this.dotSize = 8,
    this.orbitRadius = 24,
    this.color,
    this.duration = const Duration(milliseconds: 1200),
    this.pulse = false,
    this.verticalOffset = 6,
  });

  @override
  State<OrbitingDotWaveLoader> createState() => _OrbitingDotWaveLoaderState();
}

class _OrbitingDotWaveLoaderState extends State<OrbitingDotWaveLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateScale(int index, double progress) {
    if (!widget.pulse) return 1.0;
    final phase = (progress + index / widget.dotCount) % 1.0;
    return 0.8 + (sin(phase * 2 * pi) + 1) * 0.1;
  }

  double _calculateOffset(int index, double progress) {
    final phase = (progress + index / widget.dotCount) % 1.0;
    return -sin(phase * pi) * widget.verticalOffset;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: widget.orbitRadius * 2 + widget.dotSize * 2,
      height: widget.orbitRadius * 2 + widget.dotSize * 2,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final progress = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: List.generate(widget.dotCount, (i) {
              final angle = 2 * pi * i / widget.dotCount;

              final dx = cos(angle) * widget.orbitRadius;
              final dy = sin(angle) * widget.orbitRadius + _calculateOffset(i, progress);

              final scale = _calculateScale(i, progress);

              return Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

///example
//const Center(
//   child: OrbitingDotWaveLoader(
//     dotCount: 8,
//     dotSize: 8,
//     orbitRadius: 28,
//     verticalOffset: 6,
//     pulse: true,
//     color: Colors.orange,
//     duration: Duration(milliseconds: 1200),
//   ),
// )


