import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SliverListCustom<T> extends ConsumerWidget {
  final PaginationParams<T> params;
  final Widget Function(T item) itemBuilder;
  final T itemPlaceholder;
  final Widget? emptyWidget;
  final double itemSpacing;
  // Añadimos un extractor de ID opcional para que la Key sea 100% segura
  final String Function(T item)? idExtractor;

  const SliverListCustom({
    super.key,
    required this.params,
    required this.itemBuilder,
    required this.itemPlaceholder,
    this.emptyWidget,
    this.itemSpacing = SPACE_SMALL,
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
        child: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) {
              return Column(
                children: [
                  itemBuilder(itemPlaceholder),
                  Space(itemSpacing),
                ],
              );
            },
            childCount: 2,
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

    // 4. LISTA REAL PAGINADA
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) {
              // 🚀 SOLUCIÓN DEL BUCLE: Añadimos 'state.error.isEmpty'
              // Si hay un error, dejamos de pedir más automáticamente.
              if (i == state.items.length - 1 &&
                  state.hasMore &&
                  !state.isFetchingMore &&
                  !state.isLoading &&
                  state.error.isEmpty) {
                Future.microtask(() => controller.fetchMore());
              }

              final item = state.items[i];
              // Usamos el idExtractor si nos lo pasas, sino tiramos del índice
              final itemKey = idExtractor != null ? idExtractor!(item) : i.toString();

              return Column(
                key: ValueKey(itemKey),
                children: [
                  itemBuilder(item),
                  Space(itemSpacing),
                ],
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
                // Skeleton solo si está cargando de verdad
                if (state.isFetchingMore)
                  Skeletonizer(
                    enabled: true,
                    child: Column(
                      children: [
                        itemBuilder(itemPlaceholder),
                        Space(itemSpacing),
                      ],
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
      ],
    );
  }
}