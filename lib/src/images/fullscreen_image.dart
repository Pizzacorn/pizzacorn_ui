import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pizzacorn_ui/src/overlays/loading_widget.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: FullScreenImagePage
/// Motivo: Visualizador de imágenes con zoom (PhotoView) estandarizado.
/// API: FullScreenImagePage("https://...", title: "Foto de perfil")

class FullScreenImagePage extends StatelessWidget {
  // El contenido (la url de la imagen) es posicional
  final String image;
  final String title;
  final Color? backgroundColor;

  const FullScreenImagePage(
    this.image, {
    super.key,
    this.title = "Imagen",
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBg = backgroundColor ?? COLOR_BACKGROUND;

    return Scaffold(
      backgroundColor: effectiveBg,
      appBar: AppBarBack(context: context, title: title),
      extendBody: true,
      body: Semantics(
        label: "Visor de imagen: $title",
        image: true,
        child: SizedBox.expand(
          child: PhotoView(
            backgroundDecoration: BoxDecoration(color: effectiveBg),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 5,
            imageProvider: NetworkImage(image),
            loadingBuilder: (context, event) => const Center(
              child:
                  LoadingCustomWidget(), // Asumiendo que tienes un loading en la lib
            ),
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(Icons.broken_image, color: COLOR_SUBTEXT, size: 50),
            ),
          ),
        ),
      ),
    );
  }
}
