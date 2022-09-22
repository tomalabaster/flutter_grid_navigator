import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedCutoutOverlay extends StatelessWidget {
  final Widget child;
  final Size cutoutSize;
  final Key animationKey;
  final Offset swipeDirection;
  final Duration? duration;
  final double opacity;
  final double scaleAmount;

  const AnimatedCutoutOverlay({
    Key? key,
    required this.child,
    required this.cutoutSize,
    required this.animationKey,
    this.duration,
    required this.swipeDirection,
    required this.opacity,
    this.scaleAmount = 0.25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Animate(
          effects: [
            CustomEffect(
              builder: _buildAnimatedCutout,
              curve: Curves.easeOut,
              duration: duration,
            )
          ],
          key: animationKey,
          onComplete: (c) => c.reverse(),
          child: IgnorePointer(
            child: Container(
              color: Colors.black.withOpacity(opacity),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedCutout(
    BuildContext context,
    double value,
    Widget child,
  ) {
    final size = Size(
      cutoutSize.width * (1 - scaleAmount * value * swipeDirection.dx.abs()),
      cutoutSize.height * (1 - scaleAmount * value * swipeDirection.dy.abs()),
    );

    return ClipPath(
      clipper: _CutoutClipper(cutoutSize: size),
      child: child,
    );
  }
}

class _CutoutClipper extends CustomClipper<Path> {
  final Size cutoutSize;

  const _CutoutClipper({
    Listenable? reclip,
    required this.cutoutSize,
  }) : super(reclip: reclip);

  @override
  Path getClip(Size size) {
    double padX = (size.width - cutoutSize.width) / 2;
    double padY = (size.height - cutoutSize.height) / 2;

    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()
        ..addRect(
            Rect.fromLTRB(padX, padY, size.width - padX, size.height - padY))
        ..close(),
    );
  }

  @override
  bool shouldReclip(_CutoutClipper oldClipper) =>
      oldClipper.cutoutSize != cutoutSize;
}
