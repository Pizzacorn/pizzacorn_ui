import 'package:flutter/material.dart';
import 'package:uicons_pro/uicons_pro.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: SelectorList
/// Motivo: Selector de opción única con feedback visual vibrante, área de toque total garantizada y soporte de color ACCENT.
/// API: SelectorList(options, selectedIndex: index, onChanged: (i) => ...)
class SelectorList extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double spaceSize;
  final Color? selectedColor;

  const SelectorList(
      this.options, {
        super.key,
        required this.selectedIndex,
        required this.onChanged,
        this.spaceSize = SPACE_SMALL,
        this.selectedColor,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          _SelectorItem(
            options[i],
            isSelected: selectedIndex == i,
            selectedColor: selectedColor ?? COLOR_ACCENT,
            onTap: () => onChanged(i),
          ),
          if (i < options.length - 1) Space(spaceSize),
        ],
      ],
    );
  }
}

class _SelectorItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _SelectorItem(
      this.label, {
        required this.isSelected,
        required this.selectedColor,
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
      // Material e InkWell VAN DENTRO del container decorado para no perder el radio
      // y para que el InkWell detecte el área completa.
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
            // El behavior opaque obliga a registrar el click en toda la superficie
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: IgnorePointer(
                    child: TextBody(
                      label,
                      color: contentColor,
                      fontWeight: isSelected ? WEIGHT_BOLD : WEIGHT_NORMAL,
                    ),
                  )
                ),
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