import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class DisclaimerWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool showIcon;
  final Color? color;
  final Color? textColor;
  final TextStyle? style;
  final int maxlines;

  // ignore: prefer_const_constructors_in_immutables
  DisclaimerWidget({
    super.key,
    this.text = "",
    this.icon = Icons.info_outline_rounded,
    this.showIcon = true,
    this.color,
    this.textColor,
    this.style,
    this.maxlines = 5,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = color ?? COLOR_INFO;

    return ContainerHelp(
      text: text,
      icon: icon,
      showIcon: showIcon,
      color: accentColor,
      backgroundColor: accentColor.withValues(alpha: 0.10),
      textColor: textColor ?? COLOR_TEXT,
      textStyle: style,
      borderColor: accentColor.withValues(alpha: 0.25),
      iconSize: 18,
      maxlines: maxlines,
      compact: true,
    );
  }
}
