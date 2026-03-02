import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../pizzacorn_ui.dart';

class ProfileImageCustom extends StatelessWidget {
  /// La URL de la imagen
  final String imageUrl;

  /// Tamaño del widget (alto y ancho)
  final double size;

  /// Borde exterior
  final Color? outerBorderColor;
  final double outerBorderWidth;

  /// Borde interior (usado por ImageCustom)
  final Color? innerBorderColor;
  final double innerBorderWidth;

  /// Acción al pulsar
  final VoidCallback? onPressed;

  /// Si es true, se elimina el espacio entre los bordes y solo se ve uno
  final bool singleBorder;

  const ProfileImageCustom({
    super.key,
    required this.imageUrl,
    this.onPressed,
    this.size = 55,
    this.outerBorderColor,
    this.outerBorderWidth = 2,
    this.innerBorderColor,
    this.innerBorderWidth = 2,
    this.singleBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final double innerSize = size - (singleBorder ? 0 : outerBorderWidth * 2);

    final Color effectiveOuterBorderColor = outerBorderColor ?? COLOR_ACCENT;
    final Color effectiveInnerBorderColor =
        innerBorderColor ?? COLOR_BACKGROUND;

    return SizedBox(
      height: size,
      width: size,
      child: Container(
        padding: EdgeInsets.all(singleBorder ? 0 : outerBorderWidth),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: effectiveOuterBorderColor,
            width: singleBorder
                ? outerBorderWidth + innerBorderWidth
                : outerBorderWidth,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: TextButton(
          style: styleTransparent(),
          onPressed: onPressed,
          child: ImageCustom(
            imageUrl: imageUrl,
            width: innerSize,
            height: innerSize,
            fit: BoxFit.cover,
            isCircular: true,
            borderWidth: singleBorder ? 0 : innerBorderWidth,
            borderColor: effectiveInnerBorderColor,
          ),
        ),
      ),
    );
  }
}