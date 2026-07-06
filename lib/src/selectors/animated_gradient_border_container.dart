import 'dart:math';

import 'package:flutter/material.dart';

import '../../pizzacorn_ui.dart';

/// ✨ Contenedor con borde animado para selectores premium.
class AnimatedGradientBorderContainer extends StatefulWidget {
  final Widget child;
  final bool selected;
  final double radius;
  final double borderWidth;
  final Color color;
  final EdgeInsetsGeometry padding;
  final DecorationImage? backgroundImage;
  final bool borderSimple;
  final bool borderGradient;
  final Color? borderSimpleColor;
  final List<Color> borderGradientColors;
  final double selectedOverlayOpacity;
  final VoidCallback? onTap;

  // ignore: prefer_const_constructors_in_immutables
  AnimatedGradientBorderContainer({
    super.key,
    required this.child,
    required this.selected,
    required this.radius,
    required this.borderWidth,
    required this.color,
    required this.padding,
    this.backgroundImage,
    this.borderSimple = false,
    this.borderGradient = true,
    this.borderSimpleColor,
    this.borderGradientColors = const [],
    this.selectedOverlayOpacity = 0,
    this.onTap,
  });

  @override
  AnimatedGradientBorderContainerState createState() {
    return AnimatedGradientBorderContainerState();
  }
}

class AnimatedGradientBorderContainerState
    extends State<AnimatedGradientBorderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final bool useGradient = widget.selected && widget.borderGradient;
        final bool useSimple =
            widget.selected && widget.borderSimple && !widget.borderGradient;
        final bool showBorder = useGradient || useSimple;
        final double currentBorderWidth = showBorder ? widget.borderWidth : 0;
        final double innerRadius = max(0, widget.radius - currentBorderWidth);
        final double overlayOpacity = widget.selected
            ? widget.selectedOverlayOpacity.clamp(0, 1).toDouble()
            : 0;

        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: useGradient
                  ? SweepGradient(
                      colors: getGradientColors(),
                      stops: getGradientStops(),
                      transform: GradientRotation(
                        animationController.value * 2 * pi,
                      ),
                    )
                  : null,
              color: useSimple
                  ? widget.borderSimpleColor ?? COLOR_ACCENT
                  : useGradient
                  ? null
                  : widget.color,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            child: AnimatedPadding(
              duration: Duration(milliseconds: 420),
              curve: Curves.easeInOutCubic,
              padding: EdgeInsets.all(currentBorderWidth),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(innerRadius),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.color,
                    image: widget.backgroundImage,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            opacity: overlayOpacity,
                            child: Container(
                              decoration: BoxDecoration(
                                color: useSimple
                                    ? widget.borderSimpleColor ?? COLOR_ACCENT
                                    : null,
                                gradient: useGradient
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: getSourceGradientColors(),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: widget.padding, child: widget.child),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Color> getGradientColors() {
    final List<Color> sourceColors = getSourceGradientColors();

    if (sourceColors.isEmpty) {
      return [COLOR_ACCENT, COLOR_ACCENT];
    }

    if (sourceColors.length == 1) {
      return [sourceColors.first, sourceColors.first];
    }

    return [...sourceColors, sourceColors.first];
  }

  List<Color> getSourceGradientColors() {
    if (widget.borderGradientColors.isNotEmpty) {
      return widget.borderGradientColors;
    }

    return [COLOR_ACCENT, COLOR_ACCENT_SECONDARY, COLOR_INFO, COLOR_DONE];
  }

  List<double> getGradientStops() {
    final colors = getGradientColors();
    final stops = <double>[];

    for (int i = 0; i < colors.length; i++) {
      stops.add(i / (colors.length - 1));
    }

    return stops;
  }
}
