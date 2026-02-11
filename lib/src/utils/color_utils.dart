import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Devuelve el color de texto del theme que mejor contrasta sobre [bg].
///
/// Usa:
/// - [ColorScheme.onSurface] como candidato oscuro
/// - [ColorScheme.onPrimary] como candidato claro
///
/// Uso:
/// ```dart
/// final textColor = BestOnColor(miColorDeFondo, context);
/// ```
Color BestOnColor(Color bg, BuildContext context) {
  final scheme = Theme.of(context).colorScheme;

  // .computeLuminance() devuelve un valor de 0 (negro) a 1 (blanco)
  // 0.5 es la mitad, pero 0.15 - 0.2 suele ser el límite para rojos/azules intensos
  if (bg.computeLuminance() < 0.25) {
    return Colors.white;
  }

  final double contrastWithDark = ContrastRatio(bg, scheme.onSurface);
  final double contrastWithLight = ContrastRatio(bg, Colors.white);

  return (contrastWithLight >= contrastWithDark)
      ? Colors.white
      : scheme.onSurface;
}

/// Contraste WCAG 2.1: (L1 + 0.05) / (L2 + 0.05)
double ContrastRatio(Color a, Color b) {
  final double la = a.computeLuminance();
  final double lb = b.computeLuminance();
  final double L1 = math.max(la, lb);
  final double L2 = math.min(la, lb);
  return (L1 + 0.05) / (L2 + 0.05);
}
