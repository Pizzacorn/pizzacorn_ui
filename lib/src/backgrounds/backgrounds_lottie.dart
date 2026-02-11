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

  /// Devuelve el nombre del archivo basado en el índice (1-10)
  String get assetName {
    // index empieza en 0, por eso sumamos 1
    return 'background${index + 1}.json';
  }
}

class BackgroundCustom extends StatelessWidget {
  final Widget child;
  final PizzacornBackground type;
  final double opacity;
  final BoxFit fit;

  const BackgroundCustom({
    super.key,
    required this.child,
    this.type = PizzacornBackground.classic,
    this.opacity = 1.0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: opacity,
          child: Lottie.asset(
            'assets/lottie/${type.assetName}',
            package: 'pizzacorn_ui', // Crucial para que encuentre los archivos en la lib
            width: double.infinity,
            height: double.infinity,
            fit: fit,
          ),
        ),
        // Ponemos el child dentro de un SafeArea opcional o directo
        child,
      ],
    );
  }
}