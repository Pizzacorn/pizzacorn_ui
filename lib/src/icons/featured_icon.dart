import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: FeaturedIcon
/// Motivo: Contenedor estilizado para iconos destacados, ideal para listas,
/// tarjetas de características o indicadores de estado.
/// API: FeaturedIcon(icon: Icons.star, onTap: () => ...)
class FeaturedIconCustom extends StatelessWidget {
  /// El icono a mostrar
  final IconData icon;

  /// Color de fondo del contenedor. Por defecto usa [COLOR_ACCENT] con opacidad.
  final Color? backgroundColor;

  /// Color del icono. Por defecto usa [COLOR_ACCENT].
  final Color? iconColor;

  /// Tamaño del icono (no del contenedor completo).
  final double size;

  /// Espaciado interno entre el icono y el borde del contenedor.
  final double padding;

  /// Radio de curvatura de los bordes. Por defecto usa el token [RADIUS].
  final double? borderRadius;

  /// Acción opcional al pulsar el icono.
  final VoidCallback? onTap;

  const FeaturedIconCustom({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = 25,
    this.padding = 10,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 RESOLUCIÓN DE COLORES Y ESTILOS (Tokens de pizzacorn_ui)
    final Color effectiveIconColor = iconColor ?? COLOR_ACCENT;
    final Color effectiveBgColor = backgroundColor ?? effectiveIconColor.withValues(alpha: 0.14);
    final double effectiveRadius = borderRadius ?? RADIUS;

    // Si tiene onTap, le metemos un InkWell para que el feedback visual sea pro
    Widget content = Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.all(Radius.circular(effectiveRadius)),
      ),
      child: Icon(
        icon,
        color: effectiveIconColor,
        size: size,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: content,
      );
    }

    return content;
  }
}