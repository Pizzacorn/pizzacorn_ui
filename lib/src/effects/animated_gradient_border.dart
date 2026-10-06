import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/config.dart';

enum PizzacornGradientType { sweep, linear, radial }

/// Rodea cualquier widget con un gradiente fijo o animado.
class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final double radius;
  final double borderWidth;
  final List<Color> colors;
  final Duration duration;
  final bool animated;
  final PizzacornGradientType gradientType;

  // ignore: prefer_const_constructors_in_immutables
  AnimatedGradientBorder({
    super.key,
    required this.child,
    this.radius = 18,
    this.borderWidth = 2,
    this.colors = const [],
    this.duration = const Duration(milliseconds: 2600),
    this.animated = true,
    this.gradientType = PizzacornGradientType.sweep,
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
    );
    if (widget.animated) {
      animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedGradientBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      animationController.duration = widget.duration;
    }
    if (widget.animated &&
        (!oldWidget.animated || oldWidget.duration != widget.duration)) {
      animationController.repeat();
    } else if (!widget.animated && oldWidget.animated) {
      animationController.stop();
      animationController.value = 0;
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
        : sourceColors;
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
        final double angle = animationController.value * 2 * pi;
        final Gradient gradient = switch (widget.gradientType) {
          PizzacornGradientType.linear => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradientColors,
              transform: widget.animated ? GradientRotation(angle) : null,
            ),
          PizzacornGradientType.radial => RadialGradient(
              center: widget.animated
                  ? Alignment(cos(angle) * 0.6, sin(angle) * 0.6)
                  : Alignment.center,
              radius: 1.2,
              colors: gradientColors,
            ),
          PizzacornGradientType.sweep => SweepGradient(
              colors: gradientColors.length == 2 && sourceColors.length == 1
                  ? gradientColors
                  : [...gradientColors, gradientColors.first],
              transform: widget.animated ? GradientRotation(angle) : null,
            ),
        };
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: gradient,
          ),
          child: child,
        );
      },
    );
  }
}
