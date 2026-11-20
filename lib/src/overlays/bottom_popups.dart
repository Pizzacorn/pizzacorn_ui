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
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: PADDING,
      decoration: BoxDecoration(
        // Usamos el token de color de borde de tu config.dart
        border: Border(top: BorderSide(color: COLOR_BORDER, width: 1.0)),
        color: COLOR_BACKGROUND,
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              heightFactor: 1,
              alignment: AlignmentDirectional.centerStart,
              child: onPressedDelete == null
                  ? const SizedBox.shrink()
                  : ButtonCustom(
                      width: 150,
                      text: "Eliminar",
                      onlyText: true,
                      textColor: COLOR_ERROR,
                      onPressed: () => onPressedDelete!(),
                    ),
            ),
          ),
          if (onPressedDelete != null) Space(SPACE_SMALL),
          Flexible(
            flex: onPressedDelete != null ? 1 : 2,
            child: Align(
              heightFactor: 1,
              alignment: AlignmentDirectional.centerEnd,
              child: ButtonCustom(
                height: 50,
                width: 150,
                text: title,
                onPressed: onPressedSave == null ? null : () => onPressedSave!(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
