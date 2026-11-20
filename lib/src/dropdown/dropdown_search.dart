import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:uicons_pro/uicons_pro.dart';

/// Dropdown con buscador integrado al estilo Pizzacorn
class DropdownSearch<T> extends StatefulWidget {
  final List<T> items;
  final T? initialItem;
  final ValueChanged<T>? onChanged;
  final String Function(T) getName;
  final String tooltip;
  final String hintText;
  final String searchHintText;
  final String emptyText;
  final IconData? dropdownIcon;
  final Color? dropdownIconColor;

  DropdownSearch({
    super.key,
    required this.items,
    this.initialItem,
    this.onChanged,
    required this.getName,
    required this.tooltip,
    required this.hintText,
    this.searchHintText = 'Buscar...',
    this.emptyText = 'No hay resultados',
    this.dropdownIcon,
    this.dropdownIconColor,
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

  @override
  void didUpdateWidget(DropdownSearch<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialItem != widget.initialItem) {
      selectedItem = widget.initialItem;
    }
  }

  Future<void> openSearchDialog() async {
    const double breakpoint = 600;
    final bool wide = MediaQuery.sizeOf(context).width >= breakpoint;
    final (T,)? result = await openAdaptiveModal<(T,)>(
      context: context,
      breakpoint: breakpoint,
      builder: (BuildContext context) {
        return DropdownSearchDialog<T>(
          items: widget.items,
          getName: widget.getName,
          selectedItem: selectedItem,
          searchHintText: widget.searchHintText,
          emptyText: widget.emptyText,
          embedded: true,
          autofocus: wide,
          onSelected: (T item) => Navigator.of(context).pop((item,)),
        );
      },
    );
    if (!mounted || result == null) return;
    final T item = result.$1;
    setState(() => selectedItem = item);
    widget.onChanged?.call(item);
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
      excludeFromSemantics: widget.tooltip == currentText,
      child: Semantics(
        button: true,
        child: Material(
          color: COLOR_BACKGROUND_SECONDARY,
          borderRadius: BorderRadius.circular(RADIUS),
          child: InkWell(
            onTap: openSearchDialog,
            mouseCursor: SystemMouseCursors.click,
            focusColor: COLOR_ACCENT.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(RADIUS),
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                width: constraints.hasBoundedWidth ? double.infinity : null,
                constraints: BoxConstraints(minHeight: FIELD_HEIGHT),
                padding: EdgeInsets.symmetric(
                  horizontal: PADDING_SIZE,
                  vertical: PADDING_SMALL_SIZE,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: TextBody(currentText, maxlines: 1)),
                    Space(SPACE_SMALL),
                    Icon(
                      widget.dropdownIcon ?? UIconsPro.regularRounded.angle_small_down,
                      color: widget.dropdownIconColor ?? COLOR_TEXT,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
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
  final T? selectedItem;
  final String searchHintText;
  final String emptyText;
  final bool autofocus;
  final bool embedded;

  const DropdownSearchDialog({
    super.key,
    required this.items,
    required this.getName,
    required this.onSelected,
    this.selectedItem,
    this.searchHintText = 'Buscar...',
    this.emptyText = 'No hay resultados',
    this.autofocus = false,
    this.embedded = false,
  });

  @override
  State<DropdownSearchDialog<T>> createState() =>
      DropdownSearchDialogState<T>();
}

class DropdownSearchDialogState<T> extends State<DropdownSearchDialog<T>> {
  static final RegExp accentPattern = RegExp(
    r'[aeiou][\u0300\u0301\u0302\u0303\u0308\u030a]|[áàäâãåéèëêíìïîóòöôõúùüû]',
  );
  static const Map<String, String> plainVowels = {
    'á': 'a',
    'à': 'a',
    'ä': 'a',
    'â': 'a',
    'ã': 'a',
    'å': 'a',
    'é': 'e',
    'è': 'e',
    'ë': 'e',
    'ê': 'e',
    'í': 'i',
    'ì': 'i',
    'ï': 'i',
    'î': 'i',
    'ó': 'o',
    'ò': 'o',
    'ö': 'o',
    'ô': 'o',
    'õ': 'o',
    'ú': 'u',
    'ù': 'u',
    'ü': 'u',
    'û': 'u',
  };

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

  String normalizeSearch({required String text}) {
    return text.trim().toLowerCase().replaceAllMapped(
      accentPattern,
      (match) {
        final String vowel = match[0]!;
        return plainVowels[vowel] ?? vowel[0];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // REGLA: Filtrado con bucle con índice (Prohibido for-in)
    final List<T> filteredItems = <T>[];
    for (int i = 0; i < widget.items.length; i++) {
      final T item = widget.items[i];
      if (query.isEmpty ||
          normalizeSearch(text: widget.getName(item)).contains(query)) {
        filteredItems.add(item);
      }
    }

    final content = Material(
      color: COLOR_BACKGROUND,
      child: SizedBox(
        width: 400,
        height: 500,
        child: CustomScrollView(
          primary: false,
          slivers: [
            SliverPadding(
              padding: PADDING_ALL,
              sliver: SliverToBoxAdapter(
                child: TextFieldCustom(
                  controller: searchController,
                  hintText: widget.searchHintText,
                  autofocus: widget.autofocus,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) =>
                      setState(() => query = normalizeSearch(text: value)),
                  onFieldSubmitted: (value) {
                    if (filteredItems.length == 1) {
                      widget.onSelected(filteredItems.single);
                    }
                  },
                ),
              ),
            ),
            if (filteredItems.isEmpty)
              SliverPadding(
                padding: PADDING_ALL,
                sliver: SliverToBoxAdapter(
                  child: Semantics(
                    liveRegion: true,
                    child: TextBody(widget.emptyText, textAlign: TextAlign.center),
                  ),
                ),
              )
            else
              SliverList.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, i) {
                  final T item = filteredItems[i];
                  final bool selected =
                      widget.selectedItem != null && widget.selectedItem == item;
                  return Semantics(
                    selected: selected,
                    child: ListTile(
                      selected: selected,
                      title: TextBody(widget.getName(item), maxlines: 0),
                      trailing: selected
                          ? Icon(UIconsPro.regularRounded.check, color: COLOR_ACCENT)
                          : null,
                      onTap: () => widget.onSelected(item),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
    if (widget.embedded) return SafeArea(top: false, child: content);
    return Dialog(
      backgroundColor: COLOR_BACKGROUND,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RADIUS),
      ),
      child: content,
    );
  }
}
