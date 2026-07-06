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

  SliverListCustom({
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

class PaginationListCustom<T> extends ConsumerWidget {
  final PaginationParams<T> params;
  final Widget Function(T item) itemBuilder;
  final T itemPlaceholder;
  final Widget? emptyWidget;
  final double height;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final String Function(T item)? idExtractor;

  PaginationListCustom({
    super.key,
    required this.params,
    required this.itemBuilder,
    required this.itemPlaceholder,
    this.emptyWidget,
    this.height = 200,
    this.itemSpacing = SPACE_SMALL,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.idExtractor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginationProvider(params));
    final controller = ref.read(paginationProvider(params).notifier);

    // 1. ESTADO DE CARGA INICIAL
    if (state.isLoading && state.items.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: height,
          child: Skeletonizer(
            enabled: true,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: padding,
              physics: physics,
              itemCount: 3,
              separatorBuilder: (context, i) => SizedBox(width: itemSpacing),
              itemBuilder: (context, i) {
                return itemBuilder(itemPlaceholder);
              },
            ),
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

    // 4. LISTA HORIZONTAL REAL PAGINADA
    final bool showFooter = state.hasMore || state.error.isNotEmpty;
    final int itemCount = state.items.length + (showFooter ? 1 : 0);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: padding,
          physics: physics,
          itemCount: itemCount,
          separatorBuilder: (context, i) => SizedBox(width: itemSpacing),
          itemBuilder: (context, i) {
            if (i < state.items.length) {
              // 🚀 Pedimos más datos cuando el usuario alcanza el último item.
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
            }

            // 5. ZONA FINAL: SKELETON O ERROR DE PAGINACIÓN
            if (state.isFetchingMore) {
              return Skeletonizer(
                enabled: true,
                child: itemBuilder(itemPlaceholder),
              );
            }

            if (state.error.isNotEmpty && state.items.isNotEmpty) {
              return SizedBox(
                width: 220,
                child: Padding(
                  padding: PADDING_ALL,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
              );
            }

            return SizedBox(width: itemSpacing);
          },
        ),
      ),
    );
  }
}

class SliverListHorizontalCustom<T> extends PaginationListCustom<T> {
  SliverListHorizontalCustom({
    super.key,
    required super.params,
    required super.itemBuilder,
    required super.itemPlaceholder,
    super.emptyWidget,
    super.height,
    super.itemSpacing,
    super.padding,
    super.physics,
    super.idExtractor,
  });
}
