import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Separador de secciones con título y divisor integrado al estilo Pizzacorn
class SubtitleField extends StatelessWidget {
  final String title;
  final bool hasTopMargin;

  SubtitleField({
    super.key,
    required this.title,
    this.hasTopMargin = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ REGLA: Sin const y usando tokens de config.dart
              if (hasTopMargin) Space(PADDING_SIZE),

              Row(
                children: [
                  // ✅ REGLA: Parámetro posicional para el texto
                  TextSubtitle(
                    title.isNotEmpty ? title : "Sección",
                    fontWeight: FontWeight.bold,
                    color: COLOR_TEXT,
                  ),

                  Space(PADDING_SMALL_SIZE),

                  // La línea decorativa que ocupa el resto del espacio
                  Expanded(
                    child: Divider(
                      color: COLOR_TEXT.withOpacity(0.1),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              Space(PADDING_SMALL_SIZE),
            ],
          ),
        ),
      ],
    );
  }
}