import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: CheckBulletCustom
/// Motivo: Fila de lista de ventajas: círculo de color con un check y un texto al lado.
/// API: CheckBulletCustom("Todas tus reservas en un solo sitio")
/// Opcionales: `color`, `iconColor`, `textColor`, `size` y `fontSize` (útil sobre fondos oscuros).
class CheckBulletCustom extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final double size;
  final double? fontSize;

  // ignore: prefer_const_constructors_in_immutables
  CheckBulletCustom(
    this.text, {
    super.key,
    this.color,
    this.iconColor,
    this.textColor,
    this.size = 40,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color ?? COLOR_ACCENT,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            size: size * 0.5,
            color: iconColor ?? COLOR_TEXT_BUTTONS,
          ),
        ),
        Space(SPACE_SMALL + 4),
        Expanded(
          child: TextBody(
            text,
            color: textColor ?? COLOR_TEXT,
            fontSize: fontSize,
            maxlines: 3,
          ),
        ),
      ],
    );
  }
}
