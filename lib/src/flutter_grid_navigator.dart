import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'animated_cutout_overlay.dart';
import 'eight_way_swipe_detector.dart';

class FlutterGridNavigator extends StatefulWidget {
  final List<Widget?> grid;
  final Duration swipeDuration;

  const FlutterGridNavigator({
    Key? key,
    required this.grid,
    this.swipeDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<FlutterGridNavigator> createState() => _FlutterGridNavigatorState();
}

class _FlutterGridNavigatorState extends State<FlutterGridNavigator> {
  late int _gridSize;
  late int _index;
  late Offset _lastSwipeDirection;

  @override
  void initState() {
    super.initState();

    _gridSize = sqrt(widget.grid.length).round();
    _index = ((_gridSize * _gridSize) / 2).round();
    _lastSwipeDirection = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    const padding = 24.0;

    final mediaQuery = MediaQuery.of(context);
    final childSize =
        Size(mediaQuery.size.width * 0.66, mediaQuery.size.height * 0.6);

    var gridOffset = _calculateCurrentOffset(padding, childSize) +
        Offset(0, -mediaQuery.padding.top / 2);

    final offsetTweenDuration = widget.swipeDuration;
    final cutoutTweenDuration = offsetTweenDuration * 0.5;

    return AnimatedCutoutOverlay(
      animationKey: ValueKey(_index),
      cutoutSize: childSize,
      swipeDirection: _lastSwipeDirection,
      duration: cutoutTweenDuration,
      opacity: 0.7,
      child: SafeArea(
        bottom: false,
        child: OverflowBox(
          maxWidth: _gridSize * childSize.width + padding * (_gridSize - 1),
          maxHeight: _gridSize * childSize.height + padding * (_gridSize - 1),
          alignment: Alignment.center,
          child: EightWaySwipeDetector(
            onSwipe: (direction) => _onSwipe(direction: direction),
            threshold: 30,
            child: TweenAnimationBuilder<Offset>(
              tween: Tween(begin: gridOffset, end: gridOffset),
              duration: offsetTweenDuration,
              curve: Curves.easeOut,
              builder: (_, value, child) =>
                  Transform.translate(offset: value, child: child),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: _gridSize,
                childAspectRatio: childSize.aspectRatio,
                mainAxisSpacing: padding,
                crossAxisSpacing: padding,
                children: List.generate(
                  widget.grid.length,
                  (index) => _gridTile(
                    index: index,
                    swipeDuration: widget.swipeDuration,
                    childSize: childSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Converts a swipe direction into a new index
  void _onSwipe({
    required Offset direction,
  }) {
    // Calculate new index, y swipes move by an entire row, x swipes move one index at a time
    int newIndex = _index;

    if (direction.dy != 0) {
      newIndex += _gridSize * (direction.dy > 0 ? -1 : 1);
    }

    if (direction.dx != 0) {
      newIndex += (direction.dx > 0 ? -1 : 1);
    }

    // keep the index in range
    if (newIndex < 0 || newIndex > widget.grid.length - 1) {
      return;
    }
    // prevent right-swipe when at right side
    if (direction.dx < 0 && newIndex % _gridSize == 0) {
      return;
    }
    // prevent left-swipe when at left side
    if (direction.dx > 0 && newIndex % _gridSize == _gridSize - 1) {
      return;
    }

    if (widget.grid[newIndex] == null) {
      return;
    }

    _lastSwipeDirection = direction;

    HapticFeedback.lightImpact();

    _setIndex(newIndex);
  }

  void _setIndex(int index) {
    if (index < 0 || index >= widget.grid.length) {
      return;
    }

    setState(() => _index = index);
  }

  /// Determine the required offset to show the current selected index.
  /// index=0 is top-left, and the index=max is bottom-right.
  Offset _calculateCurrentOffset(double padding, Size size) {
    final halfCount = (_gridSize / 2).floorToDouble();
    final paddedChildSize = Size(size.width + padding, size.height + padding);

    // Get the starting offset that would show the top-left image (index 0)
    final originOffset = Offset(
        halfCount * paddedChildSize.width, halfCount * paddedChildSize.height);

    // Add the offset for the row/col
    final col = _index % _gridSize;
    final row = (_index / _gridSize).floor();

    final indexedOffset =
        Offset(-paddedChildSize.width * col, -paddedChildSize.height * row);

    return originOffset + indexedOffset;
  }

  Widget _gridTile({
    required int index,
    required Duration swipeDuration,
    required Size childSize,
  }) {
    final selected = index == _index;

    final child = widget.grid[index] ?? const SizedBox.shrink();

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      tween: Tween(begin: 1, end: selected ? 1 : 0.9),
      builder: (_, value, child) => Transform.scale(scale: value, child: child),
      child: SizedBox(
        width: childSize.width,
        height: childSize.height,
        child: child,
      ).animate().fade(),
    );
  }
}
