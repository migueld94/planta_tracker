import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class CircularPlantaTracker extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const CircularPlantaTracker({
    super.key,
    this.size = 50.0,
    this.color = green,
    this.duration = const Duration(seconds: 20),
  });

  @override
  CircularPlantaTrackerState createState() => CircularPlantaTrackerState();
}

class CircularPlantaTrackerState extends State<CircularPlantaTracker>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo/logo_transparente.png',
            height: widget.size * 0.9,
            width: widget.size * 0.9,
          ),
          AnimatedBuilder(
            animation: _controller!,
            child: CircularProgressIndicator(
              color: widget.color,
              strokeWidth: 1.5,
              strokeAlign: 2,
            ),
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller!.value * 2 * math.pi,
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}
