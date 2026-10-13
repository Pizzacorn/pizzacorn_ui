// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/segmented/segmented.dart
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: SegmentedControlCustom
/// Motivo: Control de segmentos personalizable que reacciona a los tokens de color globales.
/// API: SegmentedControlCustom(segments: ["Uno", "Dos"], currentIndex: 0, onValueChanged: (i) => ...)
class SegmentedControlCustom extends StatelessWidget {
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

  /// Colores personalizados (ahora nullables para usar tokens en el build)
  final Color? thumbColor;
  final Color? backgroundColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final List<Color> selectedGradientColors;
  final PizzacornGradientType selectedGradientType;
  final bool selectedGradientAnimated;
  final Duration selectedGradientDuration;
  final Color? unselectedCounterTextColor;
  final Color? selectedCounterTextColor;

  /// Radio de curva del thumb
  final double thumbRadius;
  /// Altura del control
  final double height;

  const SegmentedControlCustom({
    super.key, // Usando super.key moderno
    required this.items,
    this.itemsSecondary,
    required this.currentIndex,
    required this.onValueChanged,
    this.padding = const EdgeInsets.all(0),
    this.thumbColor,
    this.backgroundColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.selectedGradientColors = const [],
    this.selectedGradientType = PizzacornGradientType.linear,
    this.selectedGradientAnimated = false,
    this.selectedGradientDuration = const Duration(milliseconds: 2600),
    this.unselectedCounterTextColor,
    this.selectedCounterTextColor,
    this.thumbRadius = 0,
    this.height = 32.0,
  }) : assert(itemsSecondary == null || itemsSecondary.length == items.length,
  'secondaryTexts debe tener la misma longitud que segments'),
       assert(selectedGradientDuration > Duration.zero);

  @override
  Widget build(BuildContext context) {
    // 🔥 RESOLUCIÓN DE COLORES (Regla de Oro: Tokens dinámicos en el build)
    final Color effectiveThumbColor = thumbColor ?? COLOR_ACCENT;
    final Color effectiveBgColor = backgroundColor ?? COLOR_BACKGROUND_SECONDARY;
    final Color effectiveActiveText = activeTextColor ?? COLOR_TEXT;
    final Color effectiveInactiveText = inactiveTextColor ?? COLOR_SUBTEXT;

    return Padding(
      padding: padding,
      child: LayoutBuilder(builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final segmentWidth = totalWidth / items.length;

        return Stack(
          children: [
            // Fondo
            Container(
              width: totalWidth,
              height: height,
              decoration: BoxDecoration(
                color: effectiveBgColor,
                borderRadius: BorderRadius.circular(thumbRadius),
              ),
            ),

            // Thumb animado
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: currentIndex * segmentWidth,
              top: 0,
              child: selectedGradientColors.isNotEmpty
                  ? SegmentedSelectionGradient(
                      colors: selectedGradientColors,
                      gradientType: selectedGradientType,
                      animated: selectedGradientAnimated,
                      duration: selectedGradientDuration,
                      borderRadius: thumbRadius,
                      child: SizedBox(width: segmentWidth, height: height),
                    )
                  : Container(
                      width: segmentWidth,
                      height: height,
                      decoration: BoxDecoration(
                        color: effectiveThumbColor,
                        borderRadius: BorderRadius.circular(thumbRadius),
                      ),
                    ),
            ),

            // Opciones encima
            Row(
              children: items.asMap().entries.map((entry) {
                final idx = entry.key;
                final label = entry.value;
                final secondary = itemsSecondary != null
                    ? itemsSecondary![idx]
                    : '';
                final selected = idx == currentIndex;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(thumbRadius),
                    onTap: () => onValueChanged(idx),
                    child: SizedBox(
                      width: segmentWidth,
                      height: height,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextCaption(
                              label,
                              color: selected
                                  ? effectiveActiveText
                                  : effectiveInactiveText,
                              fontWeight: selected
                                  ? WEIGHT_BOLD
                                  : WEIGHT_NORMAL,
                            ),
                            if (secondary.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              TextCaption(
                                secondary,
                                color: selected
                                    ? selectedCounterTextColor ?? effectiveActiveText
                                    : unselectedCounterTextColor ?? effectiveInactiveText,
                                fontSize: 10,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }),
    );
  }
}
