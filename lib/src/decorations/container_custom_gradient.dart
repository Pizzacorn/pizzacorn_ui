import 'dart:math';

import 'package:flutter/material.dart';

import '../../pizzacorn_ui.dart';

class ContainerCustomGradient extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double radius;
  final double borderWidth;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry margin;
  final AlignmentGeometry alignment;
  final Gradient? gradient;
  final List<BoxShadow> boxShadow;
  final VoidCallback? onTap;

  // ignore: prefer_const_constructors_in_immutables
  ContainerCustomGradient({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = 0,
    this.radius = 18,
    this.borderWidth = 2,
    this.color = Colors.black,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.gradient,
    this.boxShadow = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry currentPadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: DOUBLE_PADDING,
          vertical: DOUBLE_PADDING_SMALL,
        );
    final Gradient currentGradient =
        gradient ??
        LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            COLOR_ACCENT,
            COLOR_ACCENT_SECONDARY,
            COLOR_INFO,
            COLOR_DONE,
          ],
        );

    final double currentHeight = height;
    final double innerRadius = max(0, radius - borderWidth);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: currentHeight > 0 ? currentHeight : null,
        margin: margin,
        decoration: BoxDecoration(
          gradient: currentGradient,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: boxShadow,
        ),
        child: Padding(
          padding: EdgeInsets.all(borderWidth),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerRadius),
            child: Container(
              alignment: alignment,
              padding: currentPadding,
              color: color,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
