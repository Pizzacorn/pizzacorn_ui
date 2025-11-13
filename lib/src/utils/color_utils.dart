import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../navigation/navigation_helpers.dart';


Color BestOnColor(Color bg) {

  final context = NavigationService.navigatorKey.currentContext;

  // Si por lo que sea no tenemos contexto, usamos negro/blanco clásico.
  if (context == null) {
    final double contrastWithBlack = ContrastRatio(bg, Colors.black);
    final double contrastWithWhite = ContrastRatio(bg, Colors.white);
    return (contrastWithWhite >= contrastWithBlack) ? Colors.white : Colors.black;
  }

  final scheme = Theme.of(context).colorScheme;

  // Colores candidatos sacados del theme:
  // - uno "oscuro" (texto habitual)
  // - uno "claro" (suele ser el onPrimary, normalmente blanco)
  final Color darkCandidate = scheme.onSurface;
  final Color lightCandidate = scheme.onPrimary;

  final double contrastWithDark = ContrastRatio(bg, darkCandidate);
  final double contrastWithLight = ContrastRatio(bg, lightCandidate);

  return (contrastWithLight >= contrastWithDark) ? lightCandidate : darkCandidate;
}

/// Contraste WCAG 2.1: (L1 + 0.05) / (L2 + 0.05)
double ContrastRatio(Color a, Color b) {
  final double la = a.computeLuminance();
  final double lb = b.computeLuminance();
  final double L1 = math.max(la, lb);
  final double L2 = math.min(la, lb);
  return (L1 + 0.05) / (L2 + 0.05);
}
