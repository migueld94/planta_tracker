import 'dart:math';

import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    required this.child,
    required this.duration,
    required this.shakeCount,
    required this.shakeOffset,
    super.key,
  });

  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration duration;

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  void shake() {
    animationController.forward();
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    animationController.addStatusListener(_updateStatus);
    super.initState();
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    animationController.dispose();
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final sineValue =
            sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
    );
  }
}
