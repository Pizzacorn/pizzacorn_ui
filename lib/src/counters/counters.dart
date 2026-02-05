// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/layout/counter_row.dart
import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart'; // Importamos la librería principal para tokens y widgets

class CounterRow extends StatelessWidget {
  final List<String> subtitleTexts; // Lista de textos para los títulos (ej: "15")
  final List<String> captionTexts; // Lista de textos para las etiquetas (ej: "Seguidores")
  final Color? dividerColor; // Color de los separadores
  final double dividerHeight; // Altura de los separadores
  final double spaceBetweenTexts; // Espacio entre el subtítulo y el caption

  const CounterRow({
    super.key,
    required this.subtitleTexts,
    required this.captionTexts,
    this.dividerColor,
    this.dividerHeight = 20,
    this.spaceBetweenTexts = SPACE_SMALLEST, // Usamos la constante del manifiesto
  }) : assert(subtitleTexts.length == captionTexts.length,
  'Las listas de subtitleTexts y captionTexts deben tener el mismo número de elementos.');

  @override
  Widget build(BuildContext context) {
    final Color effectiveDividerColor = dividerColor ?? COLOR_TEXT; // Token global por defecto

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // APLICANDO LA LEY: Bucle con índice para construir los contadores
        for (int i = 0; i < subtitleTexts.length; i++) ...[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextSubtitle(subtitleTexts[i]), // Usamos el texto de la lista
                Space(spaceBetweenTexts), // Constante de espacio posicional
                TextCaption(captionTexts[i]), // Usamos el texto de la lista
              ],
            ),
          ),
          // Añadimos un separador, pero no después del último elemento
          if (i < subtitleTexts.length - 1)
            Container(
              width: 1,
              color: effectiveDividerColor,
              height: dividerHeight,
            ),
        ],
      ],
    );
  }
}