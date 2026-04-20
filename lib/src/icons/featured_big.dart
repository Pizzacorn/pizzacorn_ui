import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: FeaturedBig
/// Motivo: Versión ampliada de FeaturedSubtitle con un estilo visual más marcado,
/// ideal para secciones de configuración o paneles de control.
class FeaturedTitle extends StatelessWidget {
  /// El icono a mostrar.
  final IconData icon;

  /// El título principal destacado.
  final String title;

  /// El texto secundario o descripción.
  final String subtitle;

  /// Color de acento para el icono y su contenedor. Por defecto usa [COLOR_ACCENT].
  final Color? color;

  /// Acción opcional al pulsar el icono.
  final VoidCallback? onIconTap;

  const FeaturedTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? COLOR_ACCENT;

    return Row(
      children: [
        FeaturedIconCustom(
          icon: icon,
          size: 20,
          padding: 11,
          backgroundColor: accentColor.withValues(alpha: 0.14),
          iconColor: accentColor,
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
