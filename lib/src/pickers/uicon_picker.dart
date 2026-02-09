import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:pizzacorn_ui/src/utils/uicons_helper.dart';
import 'dart:math'; // Necesario para la función min

/// PIZZACORN_UI CANDIDATE
/// Widget: IconGalleryPage
/// Motivo: Un selector visual de iconos UiconsPro con búsqueda y resaltado, ahora con paginación.
/// API: IconGalleryPage(initialSelectedIconName: 'home', onIconSelected: (icon) => ...)
class IconGalleryPage extends StatefulWidget {
  final String? initialSelectedIconName;
  final ValueChanged<MapEntry<String, IconData>>? onIconSelected;

  const IconGalleryPage({
    super.key,
    this.initialSelectedIconName,
    this.onIconSelected,
  });

  @override
  State<IconGalleryPage> createState() => IconGalleryPageState(); // Renombrado de _IconGalleryPageState
}

// Renombrado de _IconGalleryPageState a IconGalleryPageState
class IconGalleryPageState extends State<IconGalleryPage> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController(); // Para el scroll automático

  List<MapEntry<String, IconData>> allIcons = []; // Guarda todos los iconos disponibles (sin filtrar/paginar)
  List<MapEntry<String, IconData>> filteredAllIcons = []; // Iconos después de la búsqueda (sin paginar)
  List<MapEntry<String, IconData>> displayedIcons = []; // Iconos actualmente visibles en la UI (paginados)

  String? currentSelectedIconName;
  IconData? currentSelectedIconData;

  static const int pageSize = 40; // Número de iconos a cargar por "página"
  bool hasMore = true; // Indica si hay más iconos disponibles para cargar
  bool isLoadingMore = false; // Indica si se están cargando más iconos

  @override
  void initState() {
    super.initState();
    currentSelectedIconName = widget.initialSelectedIconName;
    loadAllIcons(); // Carga todos los iconos disponibles
    applyInitialPaginationAndScroll(); // Aplica la paginación inicial y maneja el scroll
    scrollController.addListener(scrollListener); // Añade el listener para cargar más al hacer scroll
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  // Listener para detectar cuando se llega cerca del final del scroll y cargar más iconos
  void scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.9 &&
        !isLoadingMore &&
        hasMore) {
      loadMoreIcons();
    }
  }

  // Carga todos los iconos desde la fuente de datos
  void loadAllIcons() {
    allIcons = UIconsMappingHelper.allRegularRoundedIconsMap.entries.toList();
    filteredAllIcons = List.from(allIcons);
    hasMore = filteredAllIcons.length > pageSize;
  }

  // Aplica la paginación inicial y, si un icono está preseleccionado, lo busca y hace scroll
  void applyInitialPaginationAndScroll() {
    setState(() {
      displayedIcons = filteredAllIcons.take(pageSize).toList();
      hasMore = filteredAllIcons.length > displayedIcons.length;
    });

    if (currentSelectedIconName != null) {
      final int initialIndex = filteredAllIcons.indexWhere((entry) => entry.key == currentSelectedIconName);
      if (initialIndex != -1) {
        currentSelectedIconData = filteredAllIcons[initialIndex].value;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToIndex(initialIndex);
        });
      }
    }
  }

  // Filtra los iconos basados en la búsqueda del usuario
  void filterIcons(String query) {
    setState(() {
      filteredAllIcons = allIcons
          .where((entry) => entry.key.toLowerCase().contains(query.toLowerCase()))
          .toList();
      displayedIcons.clear();
      displayedIcons.addAll(filteredAllIcons.take(pageSize)); // Resetea la paginación al filtrar
      hasMore = filteredAllIcons.length > displayedIcons.length;
      isLoadingMore = false; // Reinicia el estado de carga

      // Si el icono actualmente seleccionado es filtrado, se deselecciona
      if (currentSelectedIconName != null && !filteredAllIcons.any((e) => e.key == currentSelectedIconName)) {
        currentSelectedIconName = null;
        currentSelectedIconData = null;
      }
    });
  }

  // Selecciona un icono y cierra el picker
  void selectIcon(MapEntry<String, IconData> selectedItem) {
    setState(() {
      currentSelectedIconName = selectedItem.key;
      currentSelectedIconData = selectedItem.value;
    });
    if (widget.onIconSelected != null) {
      widget.onIconSelected!(selectedItem);
    }
    Navigator.pop(context, selectedItem); // Cierra el picker y devuelve el icono
  }

  // Carga más iconos al final de la lista
  void loadMoreIcons() {
    if (isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      final int currentLength = displayedIcons.length;
      final int numToLoad = min(pageSize, filteredAllIcons.length - currentLength);

      if (numToLoad > 0) {
        displayedIcons.addAll(filteredAllIcons.skip(currentLength).take(numToLoad));
      }

      setState(() {
        hasMore = filteredAllIcons.length > displayedIcons.length;
        isLoadingMore = false;
      });
    });
  }

  // Realiza scroll a un índice específico en la lista de iconos filtrados (no paginados)
  void scrollToIndex(int originalIndexInFilteredAllIcons) {
    if (originalIndexInFilteredAllIcons == -1) return;

    // Asegurarse de que el icono objetivo esté cargado en `displayedIcons`
    // Cargamos páginas hasta que el `originalIndexInFilteredAllIcons` esté visible
    while (displayedIcons.length < originalIndexInFilteredAllIcons + 1 && hasMore) {
      final int currentLength = displayedIcons.length;
      final int numToLoad = min(pageSize, filteredAllIcons.length - currentLength);
      if (numToLoad > 0) {
        displayedIcons.addAll(filteredAllIcons.skip(currentLength).take(numToLoad));
        hasMore = filteredAllIcons.length > displayedIcons.length;
      } else {
        break; // No hay más elementos para cargar
      }
    }
    setState(() {}); // Forzamos una actualización de la UI para mostrar los iconos cargados

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Encontramos el índice real del elemento dentro de la lista de `displayedIcons`
      final int actualDisplayIndex = displayedIcons.indexWhere(
              (entry) => entry.key == filteredAllIcons[originalIndexInFilteredAllIcons].key);

      if (actualDisplayIndex != -1) {
        final double screenWidth = MediaQuery.of(context).size.width;
        const double horizontalPadding = 16;
        const int crossAxisCount = 4;
        const double crossAxisSpacing = 10;
        const double mainAxisSpacing = 10;

        final double gridViewWidth = screenWidth - (2 * horizontalPadding);
        final double itemWidth =
            (gridViewWidth - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;
        final double itemHeight = itemWidth; // childAspectRatio es 1

        final int rowIndex = actualDisplayIndex ~/ crossAxisCount;
        // Calculamos el offset de scroll. Se excluye el padding inicial del GridView
        // porque ya se maneja con la propiedad `padding` del GridView.
        final double scrollOffset = (rowIndex * (itemHeight + mainAxisSpacing));

        if (scrollController.hasClients) {
          final double maxScrollExtent = scrollController.position.maxScrollExtent;
          final double finalOffset = scrollOffset.clamp(0.0, maxScrollExtent);

          scrollController.animateTo(
            finalOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarBack(context: context, title: "Seleccionar Icono"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFieldCustom(
              controller: searchController,
              hintText: 'Busca un icono',
              onChanged: filterIcons, // Renombrado de _filterIcons
            ),
          ),
          Space(20), // Usando Space con valor directo según el original
          Expanded(
            child: GridView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: displayedIcons.length + (hasMore ? 1 : 0), // Añade un espacio para el indicador de carga
              itemBuilder: (context, i) {
                if (i == displayedIcons.length) {
                  // Muestra un indicador de carga al final si hay más iconos disponibles
                  return const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                final item = displayedIcons[i];
                final bool isSelected = item.key == currentSelectedIconName;
                return IconCard( // Renombrado de _IconCard
                  name: item.key,
                  icon: item.value,
                  isSelected: isSelected,
                  onTap: () => selectIcon(item), // Renombrado de _selectIcon
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Renombrado de _IconCard a IconCard
class IconCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const IconCard({
    super.key, // Añadido super.key para consistencia
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected ? COLOR_ACCENT.withValues(alpha: 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? COLOR_ACCENT : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: isSelected ? COLOR_ACCENT : Colors.black87),
            Space(8), // Usando Space con valor directo según el original
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextCaption(
                name,
                textAlign: TextAlign.center,
                color: isSelected ? COLOR_ACCENT : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}