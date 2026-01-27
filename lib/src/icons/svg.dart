import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Icono SVG con color configurable.
///
/// - [icon]: nombre del icono dentro de `assets/icons/` (sin .svg).
/// - [fullIcon]: ruta completa alternativa (si la quieres usar tal cual).
/// - [color]: color del icono (por defecto [COLOR_ACCENT]).
/// - [noColor]: si es true, no aplica colorFilter.
/// - [blendMode]: modo de mezcla para el color.
/// - [size]: tamaño del icono (ancho y alto).
Widget SvgCustom({
  String icon = "",
  Color? color,
  bool noColor = false,
  String? semanticLabel,
  BlendMode blendMode = BlendMode.srcIn,
  double size = 24,
  String fullIcon = "",
}) {
  final Color effectiveColor = color ?? COLOR_ACCENT;

  return Semantics(
    label: semanticLabel,
      excludeSemantics: semanticLabel == null, // Si no hay label, que lo ignore
    child: SvgPicture.asset(
      fullIcon.isNotEmpty ? fullIcon : "assets/icons/$icon.svg",
      height: size,
      width: size,
      colorFilter: noColor
          ? null
          : ColorFilter.mode(
        effectiveColor,
        blendMode,
      ),
    )
  );

}

/// Icono SVG sin aplicar ningún color (usa los colores del propio asset).
Widget SvgCustomNoColor({
  String icon = "",
  double size = 24,
  String fullIcon = "",
}) {
  return SvgPicture.asset(
    fullIcon.isNotEmpty ? fullIcon : "assets/icons/$icon.svg",
    height: size,
    width: size,
  );
}
