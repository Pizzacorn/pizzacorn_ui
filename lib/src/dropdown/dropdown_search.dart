import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Dropdown con buscador integrado al estilo Pizzacorn
class DropdownSearch<T> extends StatefulWidget {
  final List<T> items;
  final T? initialItem;
  final ValueChanged<T>? onChanged;
  final String Function(T) getName;
  final String tooltip;
  final String hintText;

  DropdownSearch({
    super.key,
    required this.items,
    this.initialItem,
    this.onChanged,
    required this.getName,
    required this.tooltip,
    required this.hintText,
  });

  @override
  DropdownSearchState<T> createState() => DropdownSearchState<T>();
}

class DropdownSearchState<T> extends State<DropdownSearch<T>> {
  T? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialItem;
  }

  /// Función para abrir el buscador reactivo
  void openSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DropdownSearchDialog<T>(
          items: widget.items,
          getName: widget.getName,
          onSelected: (T item) {
            setState(() {
              selectedItem = item;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(item);
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Resolvemos el texto a mostrar basándonos en la selección
    String currentText = widget.hintText;
    if (selectedItem != null) {
      currentText = widget.getName(selectedItem as T);
    }

    return Tooltip(
      message: widget.tooltip,
      child: InkWell(
        onTap: openSearchDialog,
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
        child: Container(
          height: FIELD_HEIGHT, // Usando el nuevo token de altura que definimos
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: COLOR_BACKGROUND_SECONDARY,
            borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // REGLA: Parámetro posicional
              TextBody(currentText),
              Spacer(),
              RotatedBox(
                quarterTurns: 3,
                child: SvgCustom(icon: "atras", size: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Diálogo interno que gestiona el filtro en tiempo real (Sin guion bajo)
class DropdownSearchDialog<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) getName;
  final Function(T) onSelected;

  const DropdownSearchDialog({
    super.key,
    required this.items,
    required this.getName,
    required this.onSelected,
  });

  @override
  State<DropdownSearchDialog<T>> createState() =>
      DropdownSearchDialogState<T>();
}

class DropdownSearchDialogState<T> extends State<DropdownSearchDialog<T>> {
  String query = "";
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // REGLA: Filtrado con bucle con índice (Prohibido for-in)
    final List<T> filteredItems = <T>[];
    for (int i = 0; i < widget.items.length; i++) {
      final T item = widget.items[i];
      if (query.isEmpty || widget.getName(item).toLowerCase().contains(query)) {
        filteredItems.add(item);
      }
    }

    return Dialog(
      backgroundColor: COLOR_BACKGROUND,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RADIUS),
      ),
      child: Container(
        width: 400,
        constraints: BoxConstraints(maxHeight: 500),
        padding: PADDING_ALL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldCustom(
              controller: searchController,
              hintText: "Buscar...",
              onChanged: (value) {
                setState(() {
                  query = value.toLowerCase();
                });
              },
            ),
            Space(PADDING_SIZE),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (context, i) {
                  final T item = filteredItems[i];
                  return ListTile(
                    title: TextBody(widget.getName(item)),
                    onTap: () => widget.onSelected(item),
                  );
                },
              ),
            ),
            if (filteredItems.isEmpty)
              Padding(
                padding: EdgeInsets.all(PADDING_SIZE),
                child: Center(child: TextCaption("No hay resultados")),
              ),
          ],
        ),
      ),
    );
  }
}
