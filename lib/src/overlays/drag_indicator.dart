import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';

class DragIndicatorCustom extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  final Color? backgroundColor;

  const DragIndicatorCustom({
    super.key,
    this.height = 3,
    this.width = 50,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      width: double.infinity,
      alignment: Alignment.center,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? COLOR_TEXT,
          borderRadius: BorderRadius.circular(RADIUS),
        ),
      ),
    );
  }
}
