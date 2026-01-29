import 'dart:ui';
import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';

class BlurCustom extends StatelessWidget {
  // El contenido es posicional siguiendo la ley de la lib
  final Widget child;

  // Intensidad del blur en X e Y
  final double sigmaX;
  final double sigmaY;

  const BlurCustom(
    this.child, {
    super.key,
    this.sigmaX = 100.0,
    this.sigmaY = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      // Difuminamos SOLO el child
      imageFilter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
      child: child,
    );
  }
}
