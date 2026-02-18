import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GridCustom<T> extends ConsumerWidget {
  final PaginationParams<T> params;
  final Widget Function(T item) itemBuilder;
  final T itemPlaceholder;
  final Widget? emptyWidget;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int crossAxisCount;
  final double childAspectRatio;

  GridCustom({
    required this.params,
    required this.itemBuilder,
    required this.itemPlaceholder,
    this.emptyWidget,
    this.mainAxisSpacing = SPACE_SMALL,
    this.crossAxisSpacing = SPACE_SMALL,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos el mismo provider de paginación que la lista
    final state = ref.watch(paginationProvider(params));
    final controller = ref.read(paginationProvider(params).notifier);

    // 1. ESTADO DE CARGA INICIAL (Cargamos 6 para llenar el grid de skeletons)
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

    // 2. ESTADO DE ERROR
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
      return SliverToBoxAdapter(
        child: emptyWidget ?? Center(
          child: Padding(
            padding: PADDING_ALL,
            child: TextBody("No hay resultados"),
          ),
        ),
      );
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
              // Pre-fetch cuando quedan pocos elementos
              final fetchThreshold = state.items.length - 4;
              if (i >= fetchThreshold && state.hasMore && !state.isFetchingMore && !state.isLoading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.fetchMore();
                });
              }

              final item = state.items[i];
              return itemBuilder(item);
            },
            childCount: state.items.length,
          ),
        ),

        // 5. CARGANDO MÁS (Fila de skeletons inferior)
        if (state.isFetchingMore)
          Skeletonizer.sliver(
            enabled: true,
            child: SliverPadding(
              padding: EdgeInsets.only(top: mainAxisSpacing),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing,
                  childAspectRatio: childAspectRatio,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, i) => itemBuilder(itemPlaceholder),
                  childCount: crossAxisCount, // Una fila de skeletons
                ),
              ),
            ),
          ),

        // Espaciador final para que no pegue abajo del todo
        SliverToBoxAdapter(child: Space(SPACE_MEDIUM)),
      ],
    );
  }
}