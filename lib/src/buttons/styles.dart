import 'package:flutter/material.dart';

import '../../pizzacorn_ui.dart';

ButtonStyle styleTransparent() {
  return TextButton.styleFrom(
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero, // Eliminamos el padding interno
    minimumSize: Size.zero, // <-- ¡CLAVE! Eliminamos el tamaño mínimo de 48x48
    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // <-- ¡CLAVE! El área de toque se ajusta al contenido
    elevation: 0, // Aseguramos que no haya sombra
    side: BorderSide.none, // Eliminamos cualquier borde
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
      side: BorderSide.none, // Aseguramos que el borde de la forma también sea ninguno
    ),
  ).copyWith(
    splashFactory: InkRipple.splashFactory,
    overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.pressed)) {
        return COLOR_ACCENT.withValues(alpha: 0.05);
      }
      return null;
    }),
  );
}