import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/config.dart';

/// Rodea cualquier widget con un borde de colores en movimiento.
class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final double radius;
  final double borderWidth;
  final List<Color> colors;
  final Duration duration;

  // ignore: prefer_const_constructors_in_immutables
  AnimatedGradientBorder({
    super.key,
    required this.child,
    this.radius = 18,
    this.borderWidth = 2,
    this.colors = const [],
    this.duration = const Duration(milliseconds: 2600),
  }) : assert(radius >= 0),
       assert(borderWidth >= 0),
       assert(duration > Duration.zero);

  @override
  AnimatedGradientBorderState createState() => AnimatedGradientBorderState();
}

class AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void didUpdateWidget(AnimatedGradientBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      animationController.duration = widget.duration;
      animationController.repeat();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> sourceColors = widget.colors.isEmpty
        ? [COLOR_ACCENT, COLOR_ACCENT_SECONDARY, COLOR_INFO, COLOR_DONE]
        : widget.colors;
    final List<Color> gradientColors = sourceColors.length == 1
        ? [sourceColors.first, sourceColors.first]
        : [...sourceColors, sourceColors.first];
    final double innerRadius = max(0, widget.radius - widget.borderWidth);

    return AnimatedBuilder(
      animation: animationController,
      child: Padding(
        padding: EdgeInsets.all(widget.borderWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: widget.child,
        ),
      ),
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: SweepGradient(
              colors: gradientColors,
              transform: GradientRotation(animationController.value * 2 * pi),
            ),
          ),
          child: child,
        );
      },
    );
  }
}
