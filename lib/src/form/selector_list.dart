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
  final int? maxLines;

  const SelectorList(
    this.options, {
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.spaceSize = SPACE_SMALL,
    this.selectedColor,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          SelectorListItem(
            options[i],
            isSelected: selectedIndex == i,
            selectedColor: selectedColor ?? COLOR_ACCENT,
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
  final int? maxLines;
  final VoidCallback onTap;

  const SelectorListItem(
    this.label, {
    required this.isSelected,
    required this.selectedColor,
    this.maxLines,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected
        ? selectedColor
        : COLOR_BACKGROUND_SECONDARY;

    final Color contentColor = isSelected
        ? Colors.white
        : COLOR_TEXT;

    return AnimatedContainer(
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
                      child: TextBody(
                        label,
                        color: contentColor,
                        fontWeight: isSelected ? WEIGHT_BOLD : WEIGHT_NORMAL,
                        textAlign: TextAlign.left,
                        maxlines: maxLines,
                      ),
                    ),
                  ),
                ),
                if (isSelected) Space(SPACE_SMALL),
                if (isSelected)
                  Icon(
                    UIconsPro.regularRounded.check,
                    color: contentColor,
                    size: 14,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
