import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../pizzacorn_ui.dart';

/// ShimmerCustom
///
/// Efecto shimmer reutilizable usando los colores del sistema Pizzacorn.
/// - [period]: duración del ciclo del shimmer.
/// - [colorBase]: color base del efecto (por defecto COLOR_TEXT).
/// - [colorHighlight]: color de highlight (por defecto COLOR_TEXT con alpha).
/// - [child]: widget sobre el que aplicar el shimmer.
class ShimmerCustom extends StatelessWidget {
  final Duration period;
  final Color? colorBase;
  final Color? colorHighlight;
  final Widget child;

  const ShimmerCustom({
    super.key,
    this.period = const Duration(seconds: 3),
    this.colorBase,
    this.colorHighlight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBase = colorBase ?? COLOR_TEXT;
    final Color effectiveHighlight =
        colorHighlight ?? COLOR_TEXT.withValues(alpha: 0.7);

    return Shimmer.fromColors(
      baseColor: effectiveBase,
      highlightColor: effectiveHighlight,
      period: period,
      child: child,
    );
  }
}
