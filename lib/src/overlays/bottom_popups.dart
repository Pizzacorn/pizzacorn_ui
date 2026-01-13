import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Barra de acciones inferior para Popups al estilo Pizzacorn
class BottomSheetPopUps extends StatelessWidget {
  final Function? onPressedDelete;
  final Function? onPressedSave;
  final String title;

  BottomSheetPopUps({
    super.key,
    this.onPressedSave,
    this.onPressedDelete,
    this.title = "Continuar",
  });

  @override
  Widget build(BuildContext context) {
    // Definimos dimensiones fijas para los botones de acción
    double width = 150;
    double height = 50;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        // Usamos el token de color de borde de tu config.dart
        border: Border(
          top: BorderSide(color: COLOR_BORDER, width: 1.0),
        ),
        color: COLOR_BACKGROUND,
      ),
      child: Row(
        children: [
          // Espaciado inicial
          Space(DOUBLE_PADDING),

          // Botón de eliminar (solo si hay función)
          onPressedDelete != null
              ? ButtonCustom(
            height: height,
            width: width,
            text: "Eliminar",
            onlyText: true,
            textColor: COLOR_ERROR,
            onPressed: () {
              onPressedDelete!();
            },
          )
              : SizedBox.shrink(),

          Spacer(),

          // Botón de acción principal (Guardar/Continuar)
          ButtonCustom(
            height: height,
            width: width,
            text: title,
            // Usamos COLOR_BACKGROUND para el texto sobre el color accent del botón
            textColor: COLOR_BACKGROUND,
            onPressed: () {
              if (onPressedSave != null) {
                onPressedSave!();
              }
            },
          ),

          // Espaciado final usando tu token reactivo
          Space(DOUBLE_PADDING),
        ],
      ),
    );
  }
}