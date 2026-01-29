import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../pizzacorn_ui.dart';

class ImageCustom extends StatelessWidget {
  final String imageUrl;
  final String placeholder;
  final double width;
  final double height;
  final BoxFit fit;

  /// Si true, dibuja la imagen como un círculo.
  final bool isCircular;

  /// Radio de esquinas cuando no es circular.
  final double borderRadius;

  /// Ancho del borde.
  final double borderWidth;

  /// Color del borde.
  final Color borderColor;

  /// Widget para pintar encima de la imagen.
  final Widget? overlay;

  const ImageCustom({
    super.key,
    required this.imageUrl,
    this.placeholder = 'assets/image/placeholder.jpg',
    this.width = double.infinity,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.isCircular = false,
    this.borderRadius = 5,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay URL válida, mostramos solo el placeholder local
    if (imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWidth),
          color: COLOR_BACKGROUND_SECONDARY,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(placeholder, width: width, height: height, fit: fit),
      );
    }

    // Carga de red con CachedNetworkImage
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (ctx, url) =>
          Image.asset(placeholder, width: width, height: height, fit: fit),
      errorWidget: (ctx, url, err) =>
          Image.asset(placeholder, width: width, height: height, fit: fit),
    );

    final clippedImage = isCircular
        ? ClipOval(child: imageWidget)
        : ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: imageWidget,
          );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        color: COLOR_BACKGROUND_SECONDARY,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [clippedImage, if (overlay != null) overlay!],
      ),
    );
  }
}

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
