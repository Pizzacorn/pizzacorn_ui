import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:pizzacorn_ui/src/utils/uicons_helper.dart';
import 'dart:math';

/// PIZZACORN_UI CANDIDATE
/// Widget: IconGalleryPage
/// Motivo: Un selector visual de iconos UiconsPro con búsqueda y resaltado, ahora con paginación y personalización de grid.
/// API: IconGalleryPage(initialSelectedIconName: 'home', onIconSelected: (iconName) => ...)
class IconGalleryPage extends StatefulWidget {
  final String? initialSelectedIconName;
  final ValueChanged<String>? onIconSelected;
  final int crossAxisCount;
  final bool showAppBar;
  final bool popOnSelect;
  final bool showIconName;

  const IconGalleryPage({
    super.key,
    this.initialSelectedIconName,
    this.onIconSelected,
    this.crossAxisCount = 4,
    this.showAppBar = true,
    this.popOnSelect = true,
    this.showIconName = true,
  });

  @override
  State<IconGalleryPage> createState() => IconGalleryPageState();
}

class IconGalleryPageState extends State<IconGalleryPage> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<MapEntry<String, IconData>> allIcons = [];
  List<MapEntry<String, IconData>> filteredAllIcons = [];
  List<MapEntry<String, IconData>> displayedIcons = [];

  String? currentSelectedIconName;
  IconData? currentSelectedIconData;

  static const int pageSize = 60; 
  bool hasMore = true;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    currentSelectedIconName = widget.initialSelectedIconName;
    loadAllIcons();
    applyInitialPaginationAndScroll();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.9 &&
        !isLoadingMore &&
        hasMore) {
      loadMoreIcons();
    }
  }

  void loadAllIcons() {
    allIcons = UIconsMappingHelper.allRegularRoundedIconsMap.entries.toList();
    filteredAllIcons = List.from(allIcons);
    hasMore = filteredAllIcons.length > pageSize;
  }

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

  void filterIcons(String query) {
    setState(() {
      filteredAllIcons = allIcons
          .where((entry) => entry.key.toLowerCase().contains(query.toLowerCase()))
          .toList();
      displayedIcons.clear();
      displayedIcons.addAll(filteredAllIcons.take(pageSize));
      hasMore = filteredAllIcons.length > displayedIcons.length;
      isLoadingMore = false;

      if (currentSelectedIconName != null && !filteredAllIcons.any((e) => e.key == currentSelectedIconName)) {
        currentSelectedIconName = null;
        currentSelectedIconData = null;
      }
    });
  }

  void selectIcon(MapEntry<String, IconData> selectedItem) {
    setState(() {
      currentSelectedIconName = selectedItem.key;
      currentSelectedIconData = selectedItem.value;
    });
    if (widget.onIconSelected != null) {
      widget.onIconSelected!(selectedItem.key);
    }
    if (widget.popOnSelect) {
      Navigator.pop(context, selectedItem.key);
    }
  }

  void loadMoreIcons() {
    if (isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 300)).then((_) {
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

  void scrollToIndex(int originalIndexInFilteredAllIcons) {
    if (originalIndexInFilteredAllIcons == -1) return;

    while (displayedIcons.length < originalIndexInFilteredAllIcons + 1 && hasMore) {
      final int currentLength = displayedIcons.length;
      final int numToLoad = min(pageSize, filteredAllIcons.length - currentLength);
      if (numToLoad > 0) {
        displayedIcons.addAll(filteredAllIcons.skip(currentLength).take(numToLoad));
        hasMore = filteredAllIcons.length > displayedIcons.length;
      } else {
        break;
      }
    }
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int actualDisplayIndex = displayedIcons.indexWhere(
              (entry) => entry.key == filteredAllIcons[originalIndexInFilteredAllIcons].key);

      if (actualDisplayIndex != -1) {
        final double screenWidth = MediaQuery.of(context).size.width;
        const double horizontalPadding = 16;
        final int crossAxisCount = widget.crossAxisCount;
        const double crossAxisSpacing = 10;
        const double mainAxisSpacing = 10;

        final double gridViewWidth = screenWidth - (2 * horizontalPadding);
        final double itemWidth = (gridViewWidth - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;
        final double itemHeight = itemWidth;

        final int rowIndex = actualDisplayIndex ~/ crossAxisCount;
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
      appBar: widget.showAppBar ? AppBarBack(context: context, title: "Seleccionar Icono") : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFieldCustom(
              controller: searchController,
              hintText: 'Busca un icono',
              onChanged: filterIcons,
            ),
          ),
          Space(20),
          Expanded(
            child: GridView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: displayedIcons.length + (hasMore ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == displayedIcons.length) {
                  return const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                final item = displayedIcons[i];
                final bool isSelected = item.key == currentSelectedIconName;
                return IconCard(
                  name: item.key,
                  icon: item.value,
                  isSelected: isSelected,
                  onTap: () => selectIcon(item),
                  showIconName: widget.showIconName,
                  crossAxisCount: widget.crossAxisCount,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IconCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showIconName;
  final int crossAxisCount;

  const IconCard({
    super.key,
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.showIconName = true,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    // Si hay más de 8 columnas, forzamos ocultar el nombre porque no cabría
    final bool effectiveShowName = showIconName && crossAxisCount <= 8;
    
    // El padding se ajusta según la densidad del grid para que respire
    final double dynamicPadding = max(2.0, 8.0 - (crossAxisCount / 3));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(dynamicPadding),
        decoration: BoxDecoration(
          color: isSelected ? COLOR_ACCENT.withValues(alpha: 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(max(4, 12 - (crossAxisCount ~/ 2).toDouble())),
          border: Border.all(
            color: isSelected ? COLOR_ACCENT : Colors.grey.shade200,
            width: isSelected ? max(1.0, 3.0 - (crossAxisCount / 10)) : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  icon, 
                  // El tamaño ahora es relativo al espacio disponible (FittedBox se encargará de que no rompa)
                  size: max(12.0, (140 / crossAxisCount)), 
                  color: isSelected ? COLOR_ACCENT : Colors.black87
                ),
              ),
            ),
            if (effectiveShowName) ...[
              Space(4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: TextCaption(
                  name,
                  textAlign: TextAlign.center,
                  maxlines: 1,
                  color: isSelected ? COLOR_ACCENT : Colors.black87,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
