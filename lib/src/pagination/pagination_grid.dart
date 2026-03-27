import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SliverGridCustom<T> extends ConsumerWidget {
  final PaginationParams<T> params;
  final Widget Function(T item) itemBuilder;
  final T itemPlaceholder;
  final Widget? emptyWidget;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int crossAxisCount;
  final double childAspectRatio;
  // Añadimos el extractor de ID opcional igual que en la lista
  final String Function(T item)? idExtractor;

  const SliverGridCustom({
    super.key,
    required this.params,
    required this.itemBuilder,
    required this.itemPlaceholder,
    this.emptyWidget,
    this.mainAxisSpacing = SPACE_SMALL,
    this.crossAxisSpacing = SPACE_SMALL,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.idExtractor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginationProvider(params));
    final controller = ref.read(paginationProvider(params).notifier);

    // 1. ESTADO DE CARGA INICIAL
    if (state.isLoading && state.items.isEmpty) {
      return Skeletonizer.sliver(
        enabled: true,
        child: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, i) => itemBuilder(itemPlaceholder),
            childCount: 6,
          ),
        ),
      );
    }

    // 2. ESTADO DE ERROR INICIAL
    if (state.error.isNotEmpty && state.items.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: PADDING_ALL,
            child: TextBody("Error: ${state.error}", maxlines: 50),
          ),
        ),
      );
    }

    // 3. ESTADO VACÍO
    if (state.items.isEmpty) {
      if (emptyWidget == null) {
        return SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: PADDING_ALL,
              child: TextBody("No hay resultados"),
            ),
          ),
        );
      }

      return (emptyWidget is RenderObjectWidget && emptyWidget.runtimeType.toString().contains('Sliver'))
          ? emptyWidget!
          : SliverToBoxAdapter(child: emptyWidget);
    }

    // 4. GRID REAL PAGINADO
    return SliverMainAxisGroup(
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              // 🚀 Lógica de carga idéntica a la lista para mantener consistencia
              if (i == state.items.length - 1 &&
                  state.hasMore &&
                  !state.isFetchingMore &&
                  !state.isLoading &&
                  state.error.isEmpty) {
                Future.microtask(() => controller.fetchMore());
              }

              final item = state.items[i];
              final itemKey = idExtractor != null ? idExtractor!(item) : i.toString();

              return Container(
                key: ValueKey(itemKey),
                child: itemBuilder(item),
              );
            },
            childCount: state.items.length,
          ),
        ),

        // 5. ZONA INFERIOR: SKELETON O ERROR DE PAGINACIÓN
        if (state.hasMore || state.error.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Skeleton de una fila si está cargando más
                if (state.isFetchingMore)
                  Skeletonizer(
                    enabled: true,
                    child: Padding(
                      padding: EdgeInsets.only(top: mainAxisSpacing),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: mainAxisSpacing,
                          crossAxisSpacing: crossAxisSpacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: crossAxisCount,
                        itemBuilder: (context, i) => itemBuilder(itemPlaceholder),
                      ),
                    ),
                  ),

                // Mensaje de error si la paginación falló, con botón para reintentar
                if (state.error.isNotEmpty && state.items.isNotEmpty)
                  Padding(
                    padding: PADDING_ALL,
                    child: Column(
                      children: [
                        TextBody("Error al cargar más: ${state.error}", maxlines: 3),
                        Space(SPACE_SMALL),
                        ElevatedButton(
                          onPressed: () => controller.fetchMore(),
                          child: TextBody("Reintentar"),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        SliverToBoxAdapter(child: Space(SPACE_MEDIUM)),
      ],
    );
  }
}
