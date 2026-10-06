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
  final double selectedBorderWidth;
  final int? maxLines;

  const SelectorList(
    this.options, {
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.spaceSize = SPACE_SMALL,
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
    this.selectedBorderWidth = 2,
    this.maxLines,
  }) : assert(selectedBorderWidth >= 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          SelectorListItem(
            options[i],
            isSelected: selectedIndex == i,
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
            selectedBorderWidth: selectedBorderWidth,
            maxLines: maxLines,
            onTap: () => onChanged(i),
          ),
          if (i < options.length - 1) Space(spaceSize),
        ],
      ],
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
  final double selectedBorderWidth;
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
    this.selectedBorderWidth = 2,
    this.maxLines,
    required this.onTap,
  }) : assert(selectedBorderWidth >= 0);

  @override
  Widget build(BuildContext context) {
    final bool animatedBackground = isSelected && selectedBackgroundGradient;
    final bool animatedBorder = isSelected && selectedBorderGradient;
    final bool solidBorder =
        isSelected && !animatedBorder && selectedBorderColor != null;
    final Color? backgroundColor = animatedBackground
        ? null
        : isSelected
        ? selectedBackgroundColor ?? selectedColor
        : COLOR_BACKGROUND_SECONDARY;

    final Color contentColor = isSelected
        ? selectedTextColor ??
              (selectedBackgroundColor != null && !animatedBackground
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IgnorePointer(
                      child: customTextStyle == null
                          ? TextBody(
                              label,
                              color: contentColor,
                              fontWeight: isSelected ? WEIGHT_BOLD : WEIGHT_NORMAL,
                              textAlign: TextAlign.left,
                              maxlines: maxLines,
                            )
                          : Text(
                              bodyUppercase ? label.toUpperCase() : label,
                              style: finalTextStyle,
                              textAlign: TextAlign.left,
                              maxLines: maxLines == 0 ? null : maxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),
                ),
                if (isSelected) Space(SPACE_SMALL),
                if (isSelected)
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

    if (animatedBackground) {
      item = AnimatedGradientBorder(
        radius: RADIUS,
        borderWidth: 0,
        colors: selectedGradientColors,
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

    if (animatedBorder) {
      item = AnimatedGradientBorder(
        radius: RADIUS,
        borderWidth: selectedBorderWidth,
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
