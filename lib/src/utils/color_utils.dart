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

  // Candidatos:
  // - Uno "oscuro" (típico color de texto)
  // - Uno "claro" (suele ser blanco o similar)
  final Color darkCandidate = scheme.onSurface;
  final Color lightCandidate = scheme.onPrimary;

  final double contrastWithDark = ContrastRatio(bg, darkCandidate);
  final double contrastWithLight = ContrastRatio(bg, lightCandidate);

  return (contrastWithLight >= contrastWithDark)
      ? lightCandidate
      : darkCandidate;
}

/// Contraste WCAG 2.1: (L1 + 0.05) / (L2 + 0.05)
double ContrastRatio(Color a, Color b) {
  final double la = a.computeLuminance();
  final double lb = b.computeLuminance();
  final double L1 = math.max(la, lb);
  final double L2 = math.min(la, lb);
  return (L1 + 0.05) / (L2 + 0.05);
}
