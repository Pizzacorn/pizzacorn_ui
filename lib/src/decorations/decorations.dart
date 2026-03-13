import 'package:flutter/material.dart';import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Genera un BorderRadius uniforme usando el token de la librería
BorderRadius BorderRadiusCustomAll({double? radius}) {
  return BorderRadius.circular(radius ?? RADIUS);
}

/// Decoración estándar para contenedores Pizzacorn
///
/// Ahora permite control total de sombras y bordes por parámetros.
BoxDecoration DecorationCustom({
  Color? color,
  double? radius,
  bool hasShadow = true,
  Color? shadowColor,
  double blur = 12,
  Offset offset = const Offset(0, 4),
  double alpha = 0.08,
  bool hasBorder = false,
  Color? borderColor,
  double borderWidth = 1,
}) {
  return BoxDecoration(
    color: color ?? COLOR_BACKGROUND,
    borderRadius: BorderRadius.circular(radius ?? RADIUS),
    border: hasBorder
        ? Border.all(color: borderColor ?? COLOR_BORDER, width: borderWidth)
        : null,
    boxShadow: hasShadow
        ? [
      BoxShadow(
        color: (shadowColor ?? Colors.black).withValues(alpha: alpha),
        blurRadius: blur,
        offset: offset,
      ),
    ]
        : null,
  );
}

/// Decoración antigua (se mantiene por compatibilidad si es necesario)
BoxDecoration BoxDecorationCustom({
  bool radiusSmall = true,
  bool noShadow = false,
  Color? color,
}) {
  return BoxDecoration(
    boxShadow: noShadow
        ? []
        : [
      BoxShadow(
        color: COLOR_SHADOW.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
    color: color ?? COLOR_BACKGROUND,
    borderRadius: BorderRadiusCustomAll(
      radius: radiusSmall ? RADIUS : RADIUS * 2,
    ),
  );
}