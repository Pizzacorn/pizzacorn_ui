// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/segmented/segmented_tab.dart
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: SegmentedTabCustom
/// Motivo: Selector tipo TabBar con indicador animado inferior, minimalista y reactivo.
/// API: SegmentedTabCustom(items: ["Explorar", "Mis Citas"], currentIndex: 0, onValueChanged: (i) => ...)
class SegmentedTabCustom extends StatelessWidget {
  /// Títulos de los segmentos
  final List<String> items;
  /// Textos secundarios opcionales
  final List<String>? itemsSecondary;
  /// Índice del segmento seleccionado
  final int currentIndex;
  /// Callback que devuelve el nuevo índice pulsado
  final ValueChanged<int> onValueChanged;

  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final EdgeInsetsGeometry padding;
  final double indicatorHeight;

  const SegmentedTabCustom({
    super.key,
    required this.items,
    this.itemsSecondary,
    required this.currentIndex,
    required this.onValueChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.padding = EdgeInsets.zero,
    this.indicatorHeight = 2.0,
  }) : assert(itemsSecondary == null || itemsSecondary.length == items.length,
  'secondaryTexts debe tener la misma longitud que items');

  @override
  Widget build(BuildContext context) {
    // 🔥 Colores marca de la casa, Don Sputknif
    final Color effectiveBgColor = backgroundColor ?? Colors.transparent;
    final Color effectiveAccent = selectedColor ?? COLOR_ACCENT;
    final Color effectiveText = unselectedColor ?? COLOR_SUBTEXT.withValues(alpha: 0.5);

    return Container(
      color: effectiveBgColor,
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Bucle con índice marca de la casa
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => onValueChanged(i),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextBody(
                            items[i],
                            color: currentIndex == i ? effectiveAccent : effectiveText,
                            fontWeight: currentIndex == i ? WEIGHT_BOLD : WEIGHT_NORMAL,
                          ),
                          if (itemsSecondary != null && itemsSecondary![i].isNotEmpty) ...[
                            Space(SPACE_SMALLEST),
                            TextCaption(
                              itemsSecondary![i],
                              color: currentIndex == i ? effectiveAccent : effectiveText,
                              fontSize: 10,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Línea indicadora animada
          Stack(
            children: [
              Container(
                height: indicatorHeight,
                color: Colors.white.withOpacity(0.1), // Línea de fondo tenue
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment(
                  items.length > 1
                      ? (currentIndex / (items.length - 1) * 2) - 1
                      : 0,
                  0,
                ),
                child: FractionallySizedBox(
                  widthFactor: 1 / items.length,
                  child: Container(
                    height: indicatorHeight,
                    color: effectiveAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}