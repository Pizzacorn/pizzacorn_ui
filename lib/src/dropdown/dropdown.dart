import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Dropdown elegante basado en PopupMenu al estilo Pizzacorn
class DropdownCustom<T> extends StatefulWidget {
  final List<T> items;
  final T? initialItem;
  final ValueChanged<T>? onChanged;
  final String Function(T) getName;
  final String tooltip;
  final String hintText;

  DropdownCustom({
    super.key,
    required this.items,
    this.initialItem,
    this.onChanged,
    required this.getName,
    required this.tooltip,
    required this.hintText,
  });

  @override
  DropdownCustomState<T> createState() => DropdownCustomState<T>();
}

class DropdownCustomState<T> extends State<DropdownCustom<T>> {
  T? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialItem;
  }

  @override
  Widget build(BuildContext context) {
    // Resolvemos el texto a mostrar
    String currentText = widget.hintText;
    if (selectedItem != null) {
      currentText = widget.getName(selectedItem as T);
    }

    return PopupMenuButton<T>(
      tooltip: widget.tooltip,
      // Usamos los estilos y tokens de la librería
      style: styleTransparent(),
      color: COLOR_BACKGROUND,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
      ),
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: COLOR_BACKGROUND_SECONDARY,
          borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // REGLA: Parámetro posicional para el texto
            TextBody(currentText),
            Spacer(),
            RotatedBox(
              quarterTurns: 3,
              child: SvgCustom(icon: "atras", size: 12),
            ),
          ],
        ),
      ),
      onSelected: (T item) {
        setState(() {
          selectedItem = item;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(item);
        }
      },
      itemBuilder: (BuildContext context) {
        // REGLA: Prohibido .map().toList(). Usamos bucle con índice.
        final List<PopupMenuEntry<T>> menuItems = <PopupMenuEntry<T>>[];
        for (int i = 0; i < widget.items.length; i++) {
          final T item = widget.items[i];
          menuItems.add(
            PopupMenuItem<T>(
              value: item,
              child: TextBody(widget.getName(item)),
            ),
          );
        }
        return menuItems;
      },
    );
  }
}