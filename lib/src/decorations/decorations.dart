import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Genera un BorderRadius uniforme usando el token de la librería
BorderRadius BorderRadiusCustomAll({double? radius}) {
  // Si no se pasa radio, usamos el token global RADIUS de config.dart
  return BorderRadius.circular(radius ?? RADIUS);
}

/// Decoración estándar para contenedores Pizzacorn
BoxDecoration BoxDecorationCustom({
  bool radiusSmall = true,
  bool noShadow = false,
  Color? color,
}) {
  return BoxDecoration(
    // REGLA: Sin const para que sea reactivo
    boxShadow: noShadow
        ? []
        : [
            BoxShadow(
              color: COLOR_SHADOW.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
    color: color ?? COLOR_BACKGROUND,
    borderRadius: BorderRadiusCustomAll(
      // radiusSmall usa RADIUS (6), si es false podría usar uno mayor (ej: 12)
      radius: radiusSmall ? RADIUS : RADIUS * 2,
    ),
  );
}
