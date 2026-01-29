import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Botón de Icono personalizado al estilo Pizzacorn
class ButtonCustomIcon extends StatefulWidget {
  final void Function() onPressed;
  final String iconSvg;
  final String iconSvgNoColor;
  final IconData iconData;
  final double size;
  final double padding;
  final Color? color;
  final Color? colorBackground;

  ButtonCustomIcon({
    super.key,
    required this.onPressed,
    this.iconSvg = "",
    this.iconSvgNoColor = "",
    this.iconData = Icons.add,
    this.size = 20,
    this.padding = 15,
    this.color,
    this.colorBackground,
  });

  @override
  ButtonCustomIconState createState() => ButtonCustomIconState();
}

class ButtonCustomIconState extends State<ButtonCustomIcon> {
  @override
  Widget build(BuildContext context) {
    // Resolvemos los colores dinámicos usando los tokens de la librería
    // REGLA: Sin guiones bajos en variables locales
    final Color finalColor = widget.color ?? COLOR_TEXT;
    final Color finalColorBackground =
        widget.colorBackground ?? Colors.transparent;

    return IconButton(
      // Usamos el token de fondo si no se especifica
      color: finalColorBackground,
      iconSize: widget.size,
      focusColor: finalColorBackground,
      // Suponiendo que estiloColor es un helper de tu lib
      style: IconButton.styleFrom(
        backgroundColor: finalColorBackground,
        padding: EdgeInsets.all(widget.padding),
      ),
      icon: buildIcon(finalColor),
      onPressed: () {
        widget.onPressed();
      },
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
      return SvgCustom(icon: widget.iconSvg, size: widget.size, color: color);
    }

    return Icon(widget.iconData, color: color, size: widget.size);
  }
}
