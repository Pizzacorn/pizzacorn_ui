import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Selector de opciones en cuadrícula al estilo Pizzacorn
class ChoiceField extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final void Function(String) onSelected;

  // Configuración de Layout
  final int crossAxisCount;
  final double mainAxisExtent;

  ChoiceField({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.crossAxisCount = 3,
    this.mainAxisExtent = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ REGLA: Parámetro posicional para el texto
        if (title.isNotEmpty) TextBody(title),

        Space(PADDING_SMALL_SIZE),

        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: COLOR_BORDER),
            borderRadius: BorderRadius.circular(RADIUS),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: options.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              mainAxisExtent: mainAxisExtent,
            ),
            itemBuilder: (context, i) {
              // ✅ REGLA: Bucle con índice (GridView.builder ya lo gestiona)
              final String option = options[i];
              final bool isSelected = selected == option;

              return GestureDetector(
                onTap: () => onSelected(option),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? COLOR_ACCENT.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(RADIUS),
                    border: Border.all(
                      color: isSelected ? COLOR_ACCENT : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        size: 16,
                        color: isSelected
                            ? COLOR_ACCENT
                            : COLOR_TEXT.withOpacity(0.5),
                      ),

                      Space(PADDING_SMALL_SIZE),

                      Flexible(
                        child: TextBody(
                          option,
                          color: isSelected ? COLOR_ACCENT : COLOR_TEXT,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          maxlines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Space(PADDING_SIZE),
      ],
    );
  }
}