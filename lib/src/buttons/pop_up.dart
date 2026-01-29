import 'package:flutter/material.dart';

import '../../pizzacorn_ui.dart';

class PopupMenuOptions extends StatelessWidget {
  final List<String> labels;
  final List<Future<void> Function()> onPressedList;

  /// Opcional: iconos por item (si la lista está vacía, no muestra iconos)
  final List<IconData> icons;

  /// Opcional: habilitar/deshabilitar items (si está vacía, todo enabled)
  final List<bool> enabledList;

  /// Opcional: índices considerados "peligro" (por ejemplo: eliminar)
  /// Nota: si TextBody no soporta color, solo afectará al icono (si hay icono).
  final List<int> dangerIndexes;
  final Color dangerIconColor;

  /// Opcional: añade un divider DESPUÉS de estos índices
  /// Ej: dividerAfterIndexes: [0] => divider tras el item 0
  final List<int> dividerAfterIndexes;

  /// Opcional: ancho mínimo del menú
  final double? minWidth;

  /// Botón principal (los 3 puntos)
  final IconData buttonIcon;
  final Color buttonIconColor;
  final double buttonIconSize;
  final String tooltip;

  /// Espacio entre icono y texto dentro del item
  final double space;

  /// Si false, no ejecuta Navigator.pop automáticamente (normalmente true)
  /// PopupMenuButton ya cierra el menú al seleccionar, pero lo dejo por si luego quieres cambiar a custom.
  final bool closeOnSelect;

  PopupMenuOptions({
    super.key,
    required this.labels,
    required this.onPressedList,
    this.icons = const [],
    this.enabledList = const [],
    this.dangerIndexes = const [],
    this.dangerIconColor = Colors.red,
    this.dividerAfterIndexes = const [],
    this.minWidth,
    this.buttonIcon = Icons.more_vert,
    this.buttonIconColor = Colors.white,
    this.buttonIconSize = 14,
    this.tooltip = "",
    this.space = SPACE_SMALL,
    this.closeOnSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) return SizedBox();
    if (onPressedList.length != labels.length) return SizedBox();

    return PopupMenuButton<int>(
      tooltip: tooltip,
      icon: Icon(buttonIcon, color: buttonIconColor, size: buttonIconSize),
      onSelected: (int index) async {
        final bool enabled = getEnabled(index);
        if (!enabled) return;

        await onPressedList[index]();
      },
      itemBuilder: (context) {
        final List<PopupMenuEntry<int>> items = <PopupMenuEntry<int>>[];

        for (int i = 0; i < labels.length; i++) {
          final bool enabled = getEnabled(i);

          final Widget row = Row(
            children: [
              if (hasIcon(i))
                Icon(
                  icons[i],
                  size: 16,
                  color: isDanger(i) ? dangerIconColor : null,
                ),
              if (hasIcon(i)) Space(space),
              Expanded(child: TextBody(labels[i])),
            ],
          );

          final Widget child = minWidth == null
              ? row
              : ConstrainedBox(
                  constraints: BoxConstraints(minWidth: minWidth!),
                  child: row,
                );

          items.add(
            PopupMenuItem<int>(value: i, enabled: enabled, child: child),
          );

          if (shouldAddDividerAfter(i)) {
            items.add(PopupMenuDivider());
          }
        }

        return items;
      },
    );
  }

  bool hasIcon(int index) {
    if (icons.isEmpty) return false;
    if (index < 0) return false;
    if (index >= icons.length) return false;
    return true;
  }

  bool getEnabled(int index) {
    if (enabledList.isEmpty) return true;
    if (index < 0) return false;
    if (index >= enabledList.length) return true;
    return enabledList[index];
  }

  bool isDanger(int index) {
    for (int i = 0; i < dangerIndexes.length; i++) {
      if (dangerIndexes[i] == index) return true;
    }
    return false;
  }

  bool shouldAddDividerAfter(int index) {
    for (int i = 0; i < dividerAfterIndexes.length; i++) {
      if (dividerAfterIndexes[i] == index) return true;
    }
    return false;
  }
}
