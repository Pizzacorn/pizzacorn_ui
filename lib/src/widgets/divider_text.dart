import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: DividerTextCustom
/// Motivo: Separador horizontal con un texto en medio ("o", "ó continúa con"...), típico entre login y redes.
/// API: DividerTextCustom() o DividerTextCustom(text: "o continúa con")
class DividerTextCustom extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final double? fontSize;

  // ignore: prefer_const_constructors_in_immutables
  DividerTextCustom({
    super.key,
    this.text = "o",
    this.color,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final Color lineColor = color ?? COLOR_DIVIDER;
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: lineColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SPACE_SMALL + 2),
          child: TextCaption(
            text,
            color: textColor ?? COLOR_SUBTEXT,
            fontSize: fontSize,
          ),
        ),
        Expanded(child: Container(height: 1, color: lineColor)),
      ],
    );
  }
}
