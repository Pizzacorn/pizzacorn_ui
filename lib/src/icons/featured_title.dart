import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: FeaturedTitle
/// Motivo: Versión ampliada de FeaturedSubtitle con un estilo visual más marcado,
/// ideal para secciones de configuración o paneles de control.
class FeaturedTitle extends StatelessWidget {
  /// El icono a mostrar.
  final IconData icon;

  /// El título principal destacado.
  final String title;

  /// El texto secundario o descripción.
  final String subtitle;

  /// Color de acento general. Por defecto usa [COLOR_ACCENT].
  final Color? color;

  /// Color específico del icono.
  final Color? iconColor;

  /// Color de fondo específico para el contenedor del icono.
  final Color? iconBackgroundColor;

  /// Acción opcional al pulsar el icono.
  final VoidCallback? onIconTap;

  const FeaturedTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color,
    this.iconColor,
    this.iconBackgroundColor,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 Resolución de colores siguiendo las reglas del Gran Maestro de la Pizza
    final Color effectiveIconColor = iconColor ?? color ?? COLOR_ACCENT;
    final Color effectiveBgColor = iconBackgroundColor ?? effectiveIconColor.withValues(alpha: 0.1);

    return Row(
      children: [
        FeaturedIconCustom(
          icon: icon,
          size: 20,
          padding: 11, // Para llegar a los 42px de ancho/alto (20 + 11 + 11)
          backgroundColor: effectiveBgColor,
          iconColor: effectiveIconColor,
          onTap: onIconTap,
        ),
        Space(SPACE_SMALL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextTitle(
                title,
                fontWeight: FontWeight.w700,
              ),
              Space(SPACE_SMALLEST),
              TextCaption(
                subtitle,
                color: COLOR_SUBTEXT,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
