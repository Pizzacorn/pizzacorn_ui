// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/segmented/segmented_cupertino.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: SegmentedCupertinoCustom
/// Motivo: Wrapper de CupertinoSlidingSegmentedControl que usa los tokens de pizzacorn_ui y soporta textos secundarios.
/// API: SegmentedCupertinoCustom(items: ["Hoy", "Mañana"], currentIndex: 0, onValueChanged: (i) => ...)
class SegmentedCupertinoCustom extends StatelessWidget {
  /// Lista de etiquetas que se mostrarán en cada segmento
  final List<String> items;
  /// Textos secundarios (opcional), uno por segmento
  final List<String>? itemsSecondary;
  /// Índice del segmento actualmente seleccionado
  final int currentIndex;
  /// Callback que devuelve el índice cuando se pulsa un segmento
  final ValueChanged<int> onValueChanged;
  /// Padding opcional alrededor del control
  final EdgeInsetsGeometry padding;

  /// Colores personalizados (nullables para usar tokens)
  final Color? thumbColor;
  final Color? backgroundColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;

  const SegmentedCupertinoCustom({
    super.key,
    required this.items,
    this.itemsSecondary,
    required this.currentIndex,
    required this.onValueChanged,
    this.padding = const EdgeInsets.all(0),
    this.thumbColor,
    this.backgroundColor,
    this.activeTextColor,
    this.inactiveTextColor,
  }) : assert(itemsSecondary == null || itemsSecondary.length == items.length,
  'secondaryTexts debe tener la misma longitud que items');

  @override
  Widget build(BuildContext context) {
    // 🔥 RESOLUCIÓN DE COLORES (Tokens de pizzacorn_ui)
    final Color effectiveThumbColor = thumbColor ?? COLOR_ACCENT;
    final Color effectiveBgColor = backgroundColor ?? COLOR_BACKGROUND_SECONDARY;
    final Color effectiveActiveText = activeTextColor ?? Colors.white;
    final Color effectiveInactiveText = inactiveTextColor ?? COLOR_TEXT;

    // Transformamos la lista de Strings en el Mapa que necesita Cupertino internamente
    // Bucle con índice para el Señor Sputo
    final Map<int, Widget> childrenMap = {};
    for (int i = 0; i < items.length; i++) {
      final bool isSelected = i == currentIndex;
      final String label = items[i];
      final String secondary = (itemsSecondary != null) ? itemsSecondary![i] : '';

      childrenMap[i] = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextBody(
              label,
              color: isSelected ? effectiveActiveText : effectiveInactiveText,
              fontWeight: isSelected ? WEIGHT_BOLD : WEIGHT_NORMAL,
            ),
            if (secondary.isNotEmpty) ...[
              Space(SPACE_SMALLEST), // Usando tu widget Space de la librería
              TextCaption(
                secondary,
                color: isSelected ? effectiveActiveText : effectiveInactiveText,
                fontSize: 10,
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl<int>(
          backgroundColor: effectiveBgColor,
          thumbColor: effectiveThumbColor,
          groupValue: currentIndex,
          children: childrenMap,
          onValueChanged: (int? value) {
            if (value != null) {
              onValueChanged(value);
            }
          },
        ),
      ),
    );
  }
}