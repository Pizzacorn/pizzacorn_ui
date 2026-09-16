import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

Widget disclaimerWidget({
  String text = "",
  IconData icon = Icons.info_outline_rounded,
  Color? color,
  Color? textColor,
  int maxlines = 5,
}) {
  final Color accentColor = color ?? COLOR_INFO;

  return ContainerHelp(
    text: text,
    icon: icon,
    color: accentColor,
    backgroundColor: accentColor.withValues(alpha: 0.10),
    textColor: textColor ?? COLOR_TEXT,
    borderColor: accentColor.withValues(alpha: 0.25),
    iconSize: 18,
    maxlines: maxlines,
    compact: true,
  );
}
