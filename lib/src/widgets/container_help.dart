import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// ℹ️ Contenedor reutilizable para mostrar ayudas y explicaciones breves.
class ContainerHelp extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double iconSize;
  final int? maxlines;
  final EdgeInsetsGeometry? padding;
  final bool compact;

  // ignore: prefer_const_constructors_in_immutables
  ContainerHelp({
    super.key,
    this.text = "",
    this.icon = Icons.info_outline_rounded,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.iconSize = 24,
    this.maxlines,
    this.padding,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? COLOR_INFO;

    return Container(
      width: double.infinity,
      padding: padding ?? PADDING_ALL_SMALL,
      decoration: BoxDecoration(
        color: backgroundColor ?? effectiveColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(RADIUS),
        border: Border.all(
          color: borderColor ?? effectiveColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            compact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: effectiveColor,
            size: iconSize,
          ),
          Space(SPACE_SMALL),
          Expanded(
            child: compact
                ? TextCaption(
                    text,
                    color: textColor ?? COLOR_TEXT,
                    maxlines: maxlines ?? 5,
                  )
                : TextBody(
                    text,
                    color: textColor ?? COLOR_SUBTEXT,
                    maxlines: maxlines,
                  ),
          ),
        ],
      ),
    );
  }
}
