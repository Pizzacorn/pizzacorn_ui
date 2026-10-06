import 'package:flutter/material.dart';
import 'package:uicons_pro/uicons_pro.dart';
import '../../pizzacorn_ui.dart';

/// 🍕 Selector de opción única con área de toque completa y soporte de color ACCENT.
/// API: SelectorList(options, selectedIndex: index, onChanged: (i) => ...)
class SelectorList extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double spaceSize;
  /// Distribuye las opciones en filas de celdas con el mismo ancho.
  final bool horizontal;
  /// Número mínimo de filas en modo horizontal.
  final int rows;
  /// Celdas por fila; si se omite, se calcula a partir de [rows].
  final int? columns;
  /// En horizontal se oculta el check por defecto.
  final bool? showSelectedCheck;
  final Color? selectedColor;
  final Color? selectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? selectedTextColor;
  final Color? selectedCheckColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final List<Color> selectedGradientColors;
  final bool selectedBorderGradient;
  final bool selectedBackgroundGradient;
  final bool selectedBorderGradientAnimated;
  final bool selectedBackgroundGradientAnimated;
  final PizzacornGradientType selectedBorderGradientType;
  final PizzacornGradientType selectedBackgroundGradientType;
  final double selectedBorderWidth;
  final int? maxLines;

  const SelectorList(
    this.options, {
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.spaceSize = SPACE_SMALL,
    this.horizontal = false,
    this.rows = 1,
    this.columns,
    this.showSelectedCheck,
    this.selectedColor,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.selectedTextColor,
    this.selectedCheckColor,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectedGradientColors = const [],
    this.selectedBorderGradient = false,
    this.selectedBackgroundGradient = false,
    this.selectedBorderGradientAnimated = true,
    this.selectedBackgroundGradientAnimated = true,
    this.selectedBorderGradientType = PizzacornGradientType.sweep,
    this.selectedBackgroundGradientType = PizzacornGradientType.sweep,
    this.selectedBorderWidth = 2,
    this.maxLines,
  }) : assert(selectedBorderWidth >= 0),
       assert(rows > 0),
       assert(columns == null || columns > 0);

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return buildHorizontal();
    }

    final List<Widget> children = [];
    for (int i = 0; i < options.length; i++) {
      children.add(buildItem(i));
      if (i < options.length - 1) {
        children.add(Space(spaceSize));
      }
    }
    return Column(children: children);
  }

  Widget buildHorizontal() {
    if (options.isEmpty) {
      return SizedBox.shrink();
    }

    final int columnCount = columns ?? (options.length + rows - 1) ~/ rows;
    final int rowCount = rows > (options.length + columnCount - 1) ~/ columnCount
        ? rows
        : (options.length + columnCount - 1) ~/ columnCount;
    final List<Widget> rowWidgets = [];

    for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      final List<Widget> cells = [];
      for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
        final int itemIndex = rowIndex * columnCount + columnIndex;
        cells.add(
          Expanded(
            child: itemIndex < options.length
                ? buildItem(itemIndex)
                : SizedBox.shrink(),
          ),
        );
        if (columnIndex < columnCount - 1) {
          cells.add(SizedBox(width: spaceSize));
        }
      }
      rowWidgets.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cells,
          ),
        ),
      );
      if (rowIndex < rowCount - 1) {
        rowWidgets.add(SizedBox(height: spaceSize));
      }
    }

    return Column(children: rowWidgets);
  }

  SelectorListItem buildItem(int index) {
    return SelectorListItem(
      options[index],
      isSelected: selectedIndex == index,
      selectedColor: selectedColor ?? COLOR_ACCENT,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedBorderColor: selectedBorderColor,
      selectedTextColor: selectedTextColor,
      selectedCheckColor: selectedCheckColor,
      selectedTextStyle: selectedTextStyle,
      unselectedTextStyle: unselectedTextStyle,
      selectedGradientColors: selectedGradientColors,
      selectedBorderGradient: selectedBorderGradient,
      selectedBackgroundGradient: selectedBackgroundGradient,
      selectedBorderGradientAnimated: selectedBorderGradientAnimated,
      selectedBackgroundGradientAnimated: selectedBackgroundGradientAnimated,
      selectedBorderGradientType: selectedBorderGradientType,
      selectedBackgroundGradientType: selectedBackgroundGradientType,
      selectedBorderWidth: selectedBorderWidth,
      horizontal: horizontal,
      showSelectedCheck: showSelectedCheck ?? !horizontal,
      maxLines: maxLines,
      onTap: () => onChanged(index),
    );
  }
}

class SelectorListItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color? selectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? selectedTextColor;
  final Color? selectedCheckColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final List<Color> selectedGradientColors;
  final bool selectedBorderGradient;
  final bool selectedBackgroundGradient;
  final bool selectedBorderGradientAnimated;
  final bool selectedBackgroundGradientAnimated;
  final PizzacornGradientType selectedBorderGradientType;
  final PizzacornGradientType selectedBackgroundGradientType;
  final double selectedBorderWidth;
  final bool horizontal;
  final bool showSelectedCheck;
  final int? maxLines;
  final VoidCallback onTap;

  const SelectorListItem(
    this.label, {
    required this.isSelected,
    required this.selectedColor,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.selectedTextColor,
    this.selectedCheckColor,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectedGradientColors = const [],
    this.selectedBorderGradient = false,
    this.selectedBackgroundGradient = false,
    this.selectedBorderGradientAnimated = true,
    this.selectedBackgroundGradientAnimated = true,
    this.selectedBorderGradientType = PizzacornGradientType.sweep,
    this.selectedBackgroundGradientType = PizzacornGradientType.sweep,
    this.selectedBorderWidth = 2,
    this.horizontal = false,
    this.showSelectedCheck = true,
    this.maxLines,
    required this.onTap,
  }) : assert(selectedBorderWidth >= 0);

  @override
  Widget build(BuildContext context) {
    final bool gradientBackground = isSelected && selectedBackgroundGradient;
    final bool gradientBorder = isSelected && selectedBorderGradient;
    final bool solidBorder =
        isSelected && !gradientBorder && selectedBorderColor != null;
    final Color? backgroundColor = gradientBackground
        ? null
        : isSelected
        ? selectedBackgroundColor ?? selectedColor
        : COLOR_BACKGROUND_SECONDARY;

    final Color contentColor = isSelected
        ? selectedTextColor ??
              (selectedBackgroundColor != null && !gradientBackground
                  ? COLOR_TEXT
                  : Colors.white)
        : COLOR_TEXT;
    final TextStyle? customTextStyle = isSelected
        ? selectedTextStyle
        : unselectedTextStyle;
    final TextStyle effectiveTextStyle = styleBody(
      color: contentColor,
      fontWeight: isSelected ? WEIGHT_BOLD : WEIGHT_NORMAL,
    ).merge(customTextStyle);
    final TextStyle finalTextStyle = isSelected && selectedTextColor != null
        ? effectiveTextStyle.copyWith(color: selectedTextColor)
        : effectiveTextStyle;
    final bool bodyUppercase = PizzacornTextConfig.fonts.body ==
            PizzacornFontType.primary
        ? PizzacornTextConfig.primaryUppercase
        : PizzacornTextConfig.secondaryUppercase;

    Widget item = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(RADIUS),
      ),
      // 🍕 Material e InkWell van dentro del container decorado para respetar el radio.
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RADIUS),
          highlightColor: Colors.white.withOpacity(0.1),
          splashColor: Colors.white.withOpacity(0.1),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: horizontal
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: horizontal
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: IgnorePointer(
                      child: customTextStyle == null
                          ? TextBody(
                              label,
                              color: contentColor,
                              fontWeight: isSelected ? WEIGHT_BOLD : WEIGHT_NORMAL,
                              textAlign: horizontal
                                  ? TextAlign.center
                                  : TextAlign.left,
                              maxlines: maxLines,
                            )
                          : Text(
                              bodyUppercase ? label.toUpperCase() : label,
                              style: finalTextStyle,
                              textAlign: horizontal
                                  ? TextAlign.center
                                  : TextAlign.left,
                              maxLines: maxLines == 0 ? null : maxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),
                ),
                if (isSelected && showSelectedCheck) Space(SPACE_SMALL),
                if (isSelected && showSelectedCheck)
                  Icon(
                    UIconsPro.regularRounded.check,
                    color: selectedCheckColor ?? contentColor,
                    size: 14,
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (gradientBackground) {
      item = AnimatedGradientBorder(
        radius: RADIUS,
        borderWidth: 0,
        colors: selectedGradientColors,
        animated: selectedBackgroundGradientAnimated,
        gradientType: selectedBackgroundGradientType,
        child: item,
      );
    }

    if (solidBorder) {
      item = AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: selectedBorderColor,
          borderRadius: BorderRadius.circular(RADIUS),
        ),
        padding: EdgeInsets.all(selectedBorderWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            (RADIUS - selectedBorderWidth).clamp(0.0, double.infinity).toDouble(),
          ),
          child: item,
        ),
      );
    }

    if (gradientBorder) {
      item = AnimatedGradientBorder(
        radius: RADIUS,
        borderWidth: selectedBorderWidth,
        animated: selectedBorderGradientAnimated,
        gradientType: selectedBorderGradientType,
        colors: selectedGradientColors.isNotEmpty
            ? selectedGradientColors
            : selectedBorderColor == null
            ? const []
            : [selectedBorderColor!],
        child: item,
      );
    }

    return item;
  }
}
