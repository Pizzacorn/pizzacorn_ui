// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/buttons/more_menu_button.dart
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

enum MoreMenuCustom { edit, delete, duplicate, report } // <-- Añadido 'report'

class MoreMenuButton extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final VoidCallback? onReport; // <-- Nuevo callback para reportar
  final Color? iconColor;
  final double iconSize;
  final String tooltip;
  final Color? backgroundColor;

  MoreMenuButton({
    super.key,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
    this.onReport, // <-- Añadido al constructor
    this.iconColor,
    this.iconSize = 18,
    this.tooltip = 'Más opciones',
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Resolvemos los colores dinámicos basándonos en los tokens de la librería
    final Color finalIconColor = iconColor ?? COLOR_SUBTEXT;
    final Color finalBackgroundColor = backgroundColor ?? COLOR_BACKGROUND;

    return PopupMenuButton<MoreMenuCustom>(
      tooltip: tooltip,
      icon: Icon(Icons.more_vert, color: finalIconColor, size: iconSize),
      color: finalBackgroundColor,
      onSelected: (action) {
        if (action == MoreMenuCustom.edit && onEdit != null) {
          onEdit!();
        } else if (action == MoreMenuCustom.delete && onDelete != null) {
          onDelete!();
        } else if (action == MoreMenuCustom.duplicate && onDuplicate != null) {
          onDuplicate!();
        } else if (action == MoreMenuCustom.report && onReport != null) { // <-- Lógica para reportar
          onReport!();
        }
      },
      itemBuilder: (context) {
        final List<PopupMenuEntry<MoreMenuCustom>> items =
        <PopupMenuEntry<MoreMenuCustom>>[];

        if (onEdit != null) {
          items.add(
            PopupMenuItem<MoreMenuCustom>( // Especificando el tipo para mayor claridad
              value: MoreMenuCustom.edit,
              child: TextCaption("Editar"), // Semántico por defecto
            ),
          );
        }

        if (onDelete != null) {
          items.add(
            PopupMenuItem<MoreMenuCustom>(
              value: MoreMenuCustom.delete,
              child: TextCaption("Eliminar"), // Semántico por defecto
            ),
          );
        }

        if (onDuplicate != null) {
          items.add(
            PopupMenuItem<MoreMenuCustom>(
              value: MoreMenuCustom.duplicate,
              child: TextCaption("Duplicar"), // Semántico por defecto
            ),
          );
        }

        // <-- NUEVO: Opción de Reportar
        if (onReport != null) {
          items.add(
            PopupMenuItem<MoreMenuCustom>(
              value: MoreMenuCustom.report,
              child: TextCaption("Reportar"), // Semántico por defecto
            ),
          );
        }

        return items;
      },
    );
  }
}