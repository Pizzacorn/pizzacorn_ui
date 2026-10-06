import 'package:flutter/material.dart';

import '../effects/animated_gradient_border.dart';
import '../layout/space.dart';
import '../text/textstyles.dart';
import '../theme/config.dart';

/// Selector múltiple que delega al callback la activación de cada opción.
class MultiSelector extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<String> onChanged;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? selectedIconColor;
  final Color? unselectedIconColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final List<Color> selectedGradientColors;
  final bool selectedBackgroundGradient;
  final bool selectedGradientAnimated;
  final PizzacornGradientType selectedGradientType;
  final double spacing;
  final double runSpacing;

  // ignore: prefer_const_constructors_in_immutables
  MultiSelector({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectedGradientColors = const [],
    this.selectedBackgroundGradient = true,
    this.selectedGradientAnimated = false,
    this.selectedGradientType = PizzacornGradientType.linear,
    this.spacing = SPACE_SMALL,
    this.runSpacing = SPACE_SMALL,
  }) : assert(spacing >= 0),
       assert(runSpacing >= 0);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (int i = 0; i < items.length; i++) {
      final String item = items[i];
      final bool selected = selectedItems.contains(item);
      final Color textColor = selected
          ? selectedTextColor ?? COLOR_TEXT_BUTTONS
          : unselectedTextColor ?? COLOR_TEXT;
      final TextStyle? customTextStyle = selected
          ? selectedTextStyle
          : unselectedTextStyle;
      final TextStyle effectiveTextStyle = styleCaption(
        color: textColor,
        fontWeight: selected ? FontWeight.w800 : FontWeight.w400,
      ).merge(customTextStyle);
      final bool captionUppercase = PizzacornTextConfig.fonts.caption ==
              PizzacornFontType.primary
          ? PizzacornTextConfig.primaryUppercase
          : PizzacornTextConfig.secondaryUppercase;

      Widget chip = AnimatedContainer(
        duration: Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected && selectedBackgroundGradient
              ? null
              : selected
              ? selectedBackgroundColor ?? COLOR_ACCENT
              : unselectedBackgroundColor ?? COLOR_BACKGROUND_TERCIARY,
          borderRadius: BorderRadius.circular(RADIUS),
          border: Border.all(
            color: selected
                ? selectedBorderColor ?? Colors.transparent
                : unselectedBorderColor ?? COLOR_BORDER,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(RADIUS),
            onTap: () => onChanged(item),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DOUBLE_PADDING_SMALL + 4,
                vertical: DOUBLE_PADDING_SMALL,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? Icons.check_rounded : Icons.add_rounded,
                    size: 18,
                    color: selected
                        ? selectedIconColor ?? textColor
                        : unselectedIconColor ?? COLOR_SUBTEXT,
                  ),
                  Space(SPACE_SMALLEST),
                  customTextStyle == null
                      ? TextCaption(
                          item,
                          color: textColor,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w400,
                        )
                      : Text(
                          captionUppercase ? item.toUpperCase() : item,
                          style: selected && selectedTextColor != null
                              ? effectiveTextStyle.copyWith(
                                  color: selectedTextColor,
                                )
                              : unselectedTextColor != null && !selected
                              ? effectiveTextStyle.copyWith(
                                  color: unselectedTextColor,
                                )
                              : effectiveTextStyle,
                        ),
                ],
              ),
            ),
          ),
        ),
      );

      if (selected && selectedBackgroundGradient) {
        chip = AnimatedGradientBorder(
          radius: RADIUS,
          borderWidth: 0,
          colors: selectedGradientColors.isEmpty
              ? [COLOR_ACCENT, COLOR_ACCENT_SECONDARY]
              : selectedGradientColors,
          animated: selectedGradientAnimated,
          gradientType: selectedGradientType,
          child: chip,
        );
      }

      children.add(chip);
    }

    return Wrap(spacing: spacing, runSpacing: runSpacing, children: children);
  }
}
