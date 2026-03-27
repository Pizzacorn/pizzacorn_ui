import 'package:flutter/material.dart';

class AppBarDrag extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final double width;
  final Color? color;
  final Color? backgroundColor;

  const AppBarDrag({
    super.key,
    this.height = 40,
    this.width = 40,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      width: double.infinity,
      height: height,
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: 5,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}