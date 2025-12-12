import 'dart:async';

import 'package:flutter/material.dart';

/// A reusable carousel widget with optional auto-slide, dots indicator,
/// and conditional padding during user drag.
class ReusableCarousel extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Interval for auto-sliding. When null or itemCount <= 1, auto-slide is disabled.
  final Duration? autoSlideInterval;

  /// Called when the current page changes.
  final ValueChanged<int>? onPageChanged;

  /// Provide a custom [PageController]. If null, an internal controller is used.
  final PageController? controller;

  /// Fraction of the viewport each page should occupy. Default 1.0 (full width).
  final double viewportFraction;

  /// Whether to show a simple dots indicator below the pages.
  final bool showDots;

  /// Primary color for selected dot.
  final Color? dotActiveColor;

  /// Color for inactive dots.
  final Color? dotInactiveColor;

  /// Size (diameter/height) of the dots.
  final double dotSize;

  /// Horizontal spacing between dots.
  final double dotSpacing;

  /// Enable infinite scroll looping. When true and itemCount > 1, the
  /// carousel allows unbounded paging in both directions.
  final bool infiniteScroll;

  /// If true, applies [paddingBuilder] output only when the user is manually dragging.
  final bool enablePaddingDuringUserDrag;

  /// Builder that returns per-index padding when [enablePaddingDuringUserDrag] is true.
  /// If null, defaults to EdgeInsets.only(left: index == 0 ? 0 : 7).
  final EdgeInsets Function(int index, bool isUserDragging)? paddingBuilder;

  const ReusableCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.autoSlideInterval = const Duration(seconds: 4),
    this.onPageChanged,
    this.controller,
    this.viewportFraction = 1.0,
    this.showDots = true,
    this.dotActiveColor,
    this.dotInactiveColor,
    this.dotSize = 6,
    this.dotSpacing = 3,
    this.infiniteScroll = false,
    this.enablePaddingDuringUserDrag = false,
    this.paddingBuilder,
  });

  @override
  State<ReusableCarousel> createState() => _ReusableCarouselState();
}

class _ReusableCarouselState extends State<ReusableCarousel> {
  late final PageController _controller;
  Timer? _timer;
  bool _ownsController = false;
  bool _isUserDragging = false;

  bool get _isInfinite => widget.infiniteScroll && widget.itemCount > 1;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    if (_ownsController) {
      final initial = _isInfinite ? widget.itemCount * 1000 : 0;
      _controller = PageController(
        viewportFraction: widget.viewportFraction,
        initialPage: initial,
      );
    } else {
      _controller = widget.controller!;
    }
    _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant ReusableCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart auto-slide if interval or itemCount changes
    if (oldWidget.autoSlideInterval != widget.autoSlideInterval ||
        oldWidget.itemCount != widget.itemCount) {
      _restartAutoSlide();
    }
  }

  void _startAutoSlide() {
    _timer?.cancel();
    final interval = widget.autoSlideInterval;
    if (interval == null || interval.inMilliseconds <= 0) return;
    if (widget.itemCount <= 1) return;
    _timer = Timer.periodic(interval, (_) {
      if (!mounted) return;
      final currentPage = (_controller.page ?? 0).round();
      final int next = _isInfinite ? (currentPage + 1) : ((currentPage + 1) % widget.itemCount);
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _restartAutoSlide() {
    _timer?.cancel();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _startAutoSlide();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  EdgeInsets _paddingForIndex(int index) {
    final builder = widget.paddingBuilder;
    if (builder != null) return builder(index, _isUserDragging);
    // default behavior: add left padding for non-first pages
    return EdgeInsets.only(left: index == 0 ? 0 : 7);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.dotActiveColor ?? theme.colorScheme.primary;
    final inactiveColor = widget.dotInactiveColor ?? theme.disabledColor;

    return Column(
      children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (!widget.enablePaddingDuringUserDrag) return false;
              if (notification is ScrollStartNotification && notification.dragDetails != null) {
                if (!_isUserDragging) setState(() => _isUserDragging = true);
              } else if (notification is ScrollUpdateNotification && notification.dragDetails != null) {
                if (!_isUserDragging) setState(() => _isUserDragging = true);
              } else if (notification is ScrollEndNotification) {
                if (_isUserDragging) setState(() => _isUserDragging = false);
              }
              return false;
            },
            child: PageView.builder(
              controller: _controller,
              clipBehavior: Clip.none,
              itemCount: _isInfinite ? null : widget.itemCount,
              onPageChanged: (i) {
                _restartAutoSlide();
                final logical = _isInfinite ? (i % widget.itemCount) : i;
                widget.onPageChanged?.call(logical);
              },
              itemBuilder: (context, index) {
                final logical = _isInfinite ? (index % widget.itemCount) : index;
                final page = widget.itemBuilder(context, logical);
                if (!widget.enablePaddingDuringUserDrag) return page;
                final pad = _paddingForIndex(logical);
                return Padding(padding: _isUserDragging ? pad : EdgeInsets.zero, child: page);
              },
            ),
          ),
        ),
        if (widget.showDots && widget.itemCount > 1) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: widget.dotSize + 2,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final current = (_controller.hasClients ? _controller.page : 0) ?? 0;
                final int selectedIndex = _isInfinite
                    ? (current.round() % widget.itemCount)
                    : current.round();
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(widget.itemCount, (i) {
                    final selected = selectedIndex == i;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: widget.dotSpacing),
                      width: selected ? widget.dotSize + 4 : widget.dotSize,
                      height: widget.dotSize,
                      decoration: BoxDecoration(
                        color: selected ? activeColor : inactiveColor,
                        borderRadius: BorderRadius.circular(widget.dotSize / 2),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
