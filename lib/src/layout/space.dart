import 'package:flutter/material.dart';

/// ESPACIOS PIZZACORN ////////////////////////////////////////////////////////
const double SPACE_BIGGER = 60;
const double SPACE_BIG = 40;
const double SPACE_MEDIUM = 20;
const double SPACE_SMALL = 10;
const double SPACE_SMALLEST = 5;

/// Widget de espacio Pizzacorn.
///
/// Crea un espacio cuadrado (mismo [space] en alto y ancho).
Widget Space(double space) {
  return SizedBox(
    height: space,
    width: space,
  );
}