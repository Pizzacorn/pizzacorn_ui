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

  return Container(
    padding: PADDING_ALL_SMALL,
    decoration: BoxDecoration(
      color: accentColor.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(RADIUS),
      border: Border.all(
        color: accentColor.withValues(alpha: 0.25),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: accentColor,
          size: 18,
        ),
        Space(SPACE_SMALL),
        Expanded(
          child: TextCaption(
            text,
            color: textColor ?? COLOR_TEXT,
            maxlines: maxlines,
          ),
        ),
      ],
    ),
  );
}
