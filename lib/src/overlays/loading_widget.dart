import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: LoadingWidget
/// Motivo: Loader estandarizado para toda la suite de apps.
/// API: LoadingWidget() o LoadingWidget(size: 30)

class LoadingCustomWidget extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const LoadingCustomWidget({
    super.key,
    this.size = 25.0,
    this.color,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? COLOR_ACCENT,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}