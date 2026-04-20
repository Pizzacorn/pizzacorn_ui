import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Widget destacado con icono, titulo y descripcion.
class FeaturedSubtitle extends StatelessWidget {
  /// Icono principal del bloque.
  final IconData icon;

  /// Titulo destacado.
  final String title;

  /// Texto descriptivo del bloque.
  final String body;

  /// Tamano del icono.
  final double iconSize;

  /// Color de fondo del icono.
  final Color? iconBackgroundColor;

  /// Color del icono.
  final Color? iconColor;

  /// Accion opcional al pulsar el icono.
  final VoidCallback? onIconTap;

  // ignore: prefer_const_constructors_in_immutables
  FeaturedSubtitle({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.iconSize = 28,
    this.iconBackgroundColor,
    this.iconColor,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FeaturedIconCustom(
          icon: icon,
          size: iconSize,
          backgroundColor: iconBackgroundColor,
          iconColor: iconColor,
          onTap: onIconTap,
        ),
        Space(SPACE_SMALL),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [TextSubtitle(title), TextBody(body)],
          ),
        ),
      ],
    );
  }
}
