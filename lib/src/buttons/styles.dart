import 'package:flutter/material.dart';

import '../../pizzacorn_ui.dart';

/// Estilo de botón transparente con ripple suave usando el color de acento.
ButtonStyle styleTransparent() {
  return TextButton.styleFrom(
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    side: BorderSide.none,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
      side: BorderSide.none,
    ),
  ).copyWith(
    splashFactory: InkRipple.splashFactory,
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
        if (states.contains(MaterialState.pressed)) {
          return COLOR_ACCENT.withValues(alpha: 0.05);
        }
        return null;
      },
    ),
  );
}