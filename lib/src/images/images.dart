import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../pizzacorn_ui.dart';

class ImageCustom extends StatelessWidget {
  final String imageUrl;
  final String placeholder;
  final double width;
  final double height;
  final BoxFit fit;
  final bool isCircular;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  // Don Sput, aquí está el nuevo parámetro
  final Color? backgroundColor;

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
    this.backgroundColor, // Añadido aquí
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    // Si no viene color, usamos el secundario por defecto
    final Color effectiveBgColor = backgroundColor ?? COLOR_BACKGROUND_SECONDARY;

    // Caso: URL vacía
    if (imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWidth),
          color: effectiveBgColor,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(placeholder, width: width, height: height, fit: fit),
      );
    }

    // Carga de red
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
        color: effectiveBgColor, // Aplicamos el color aquí
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          clippedImage,
          if (overlay != null) overlay!
        ],
      ),
    );
  }
}
