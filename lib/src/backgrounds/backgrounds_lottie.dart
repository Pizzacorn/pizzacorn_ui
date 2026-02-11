import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
  final Widget child;
  final PizzacornBackground type;
  final double opacity;
  final BoxFit fit;
  final bool repeat; // <--- Nueva propiedad

  const BackgroundLottieCustom({
    super.key,
    required this.child,
    this.type = PizzacornBackground.classic,
    this.opacity = 1.0,
    this.fit = BoxFit.cover,
    this.repeat = true, // Por defecto suele ser mejor que se repita
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: opacity,
          child: Lottie.asset(
            'assets/lottie/${type.assetName}',
            package: 'pizzacorn_ui',
            width: double.infinity,
            height: double.infinity,
            fit: fit,
            repeat: repeat, // <--- Aplicamos la propiedad aquí
          ),
        ),
        child,
      ],
    );
  }
}