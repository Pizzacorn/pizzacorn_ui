import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

enum MoreMenuCustom { edit, delete, duplicate }

class MoreMenuButton extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final Color? iconColor;
  final double iconSize;
  final String tooltip;
  final Color? backgroundColor;

  MoreMenuButton({
    super.key,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
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
        }
      },
      itemBuilder: (context) {
        final List<PopupMenuEntry<MoreMenuCustom>> items =
            <PopupMenuEntry<MoreMenuCustom>>[];

        if (onEdit != null) {
          items.add(
            PopupMenuItem(
              value: MoreMenuCustom.edit,
              child: TextCaption("Editar"),
            ),
          );
        }

        if (onDelete != null) {
          items.add(
            PopupMenuItem(
              value: MoreMenuCustom.delete,
              child: TextCaption("Eliminar"),
            ),
          );
        }

        if (onDuplicate != null) {
          items.add(
            PopupMenuItem(
              value: MoreMenuCustom.duplicate,
              child: TextCaption("Duplicar"),
            ),
          );
        }

        return items;
      },
    );
  }
}
