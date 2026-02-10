import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Botón de Icono personalizado al estilo Pizzacorn con soporte para bordes y radio
class ButtonCustomIcon extends StatefulWidget {
  final void Function() onPressed;
  final String iconSvg;
  final String iconSvgNoColor;
  final IconData icon;
  final double size;
  final double padding;
  final Color? color;
  final Color? colorBackground;

  // NUEVOS JUGUETES PARA EL SEÑOR SPUTO
  final double radius;
  final Color? borderColor;
  final double borderWidth;

  ButtonCustomIcon({
    super.key,
    required this.onPressed,
    this.iconSvg = "",
    this.iconSvgNoColor = "",
    this.icon = Icons.add,
    this.size = 20,
    this.padding = 15,
    this.color,
    this.colorBackground,
    this.radius = 100, // Por defecto casi circular
    this.borderColor,
    this.borderWidth = 0,
  });

  @override
  ButtonCustomIconState createState() => ButtonCustomIconState();
}

class ButtonCustomIconState extends State<ButtonCustomIcon> {
  @override
  Widget build(BuildContext context) {
    // REGLA: Sin guiones bajos en variables locales
    final Color finalColor = widget.color ?? COLOR_TEXT;
    final Color finalColorBackground = widget.colorBackground ?? Colors.transparent;
    final Color finalBorderColor = widget.borderColor ?? Colors.transparent;

    return IconButton(
      iconSize: widget.size,
      style: IconButton.styleFrom(
        backgroundColor: finalColorBackground,
        padding: EdgeInsets.all(widget.padding),
        // Configuración de la forma y borde
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          side: widget.borderWidth > 0
              ? BorderSide(color: finalBorderColor, width: widget.borderWidth)
              : BorderSide.none,
        ),
      ),
      icon: buildIcon(finalColor),
      onPressed: widget.onPressed,
    );
  }

  /// Helper para decidir qué icono mostrar
  Widget buildIcon(Color color) {
    if (widget.iconSvgNoColor.isNotEmpty) {
      return SvgCustom(
        icon: widget.iconSvgNoColor,
        size: widget.size,
        noColor: true,
      );
    }

    if (widget.iconSvg.isNotEmpty) {
      return SvgCustom(
          icon: widget.iconSvg,
          size: widget.size,
          color: color
      );
    }

    return Icon(widget.icon, color: color, size: widget.size);
  }
}