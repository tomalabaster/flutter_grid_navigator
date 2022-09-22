import 'dart:math';

import 'package:flutter/material.dart';

class EightWaySwipeDetector extends StatefulWidget {
  final Widget child;
  final double threshold;
  final void Function(Offset direction)? onSwipe;

  const EightWaySwipeDetector({
    Key? key,
    required this.child,
    this.threshold = 50,
    required this.onSwipe,
  }) : super(key: key);

  @override
  State<EightWaySwipeDetector> createState() => _EightWaySwipeDetectorState();
}

class _EightWaySwipeDetectorState extends State<EightWaySwipeDetector> {
  late Offset _startPos;
  late Offset _endPos;
  late bool _isSwiping;

  @override
  void initState() {
    super.initState();

    _resetSwipe();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: _handleSwipeStart,
      onPanUpdate: _handleSwipeUpdate,
      onPanCancel: _resetSwipe,
      onPanEnd: _handleSwipeEnd,
      child: widget.child,
    );
  }

  void _resetSwipe() {
    _isSwiping = false;
    _startPos = Offset.zero;
    _endPos = Offset.zero;
  }

  void _handleSwipeStart(DragStartDetails details) {
    _isSwiping = true;
    _startPos = details.localPosition;
    _endPos = details.localPosition;
  }

  void _handleSwipeUpdate(DragUpdateDetails details) {
    _endPos = details.localPosition;

    _maybeTriggerSwipe();
  }

  void _handleSwipeEnd(DragEndDetails details) {
    _maybeTriggerSwipe();
    _resetSwipe();
  }

  void _maybeTriggerSwipe() {
    if (_isSwiping == false) return;

    Offset moveDelta = _endPos - _startPos;
    final distance = moveDelta.distance;

    if (distance >= max(widget.threshold, 1)) {
      moveDelta /= distance;

      final direction =
          Offset(moveDelta.dx.roundToDouble(), moveDelta.dy.roundToDouble());

      widget.onSwipe?.call(direction);

      _resetSwipe();
    }
  }
}
