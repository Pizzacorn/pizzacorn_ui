import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';


enum PizzacornBackground {
  classic,   // background1.json
  space,     // background2.json
  party,     // background3.json
  magic,     // background4.json
  ocean,     // background5.json
  sunset,    // background6.json
  forest,    // background7.json
  abstract,  // background8.json
  cloudy,    // background9.json
  premium;   // background10.json

  String get assetName => 'background${index + 1}.json';
}

class BackgroundLottieCustom extends StatelessWidget {
  final PizzacornBackground type;
  final double opacity;
  final BoxFit fit;
  final bool repeat;

  // Parámetros para tu BlurCustom
  final bool isBlurred;
  final double sigmaX;
  final double sigmaY;

  const BackgroundLottieCustom({
    super.key,
    this.type = PizzacornBackground.classic,
    this.opacity = 1.0,
    this.fit = BoxFit.cover,
    this.repeat = true,
    this.isBlurred = false,
    this.sigmaX = 10.0, // Valores más realistas por defecto, 100 es mucho blur
    this.sigmaY = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Creamos el contenido base (el Lottie)
    Widget content = Lottie.asset(
      'assets/lottie/${type.assetName}',
      package: 'pizzacorn_ui',
      width: double.infinity,
      height: double.infinity,
      fit: fit,
      repeat: repeat,
    );

    // 2. Si el usuario quiere blur, envolvemos con TU BlurCustom
    if (isBlurred) {
      content = BlurCustom(
        sigmaX: sigmaX,
        sigmaY: sigmaY,
        child: content,
      );
    }

    // 3. Aplicamos la opacidad al final de la cadena
    return Opacity(
      opacity: opacity,
      child: content,
    );
  }
}