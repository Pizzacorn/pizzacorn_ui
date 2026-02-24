import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easyadmin/config/imports.dart'; // Import global según tus reglas
import 'package:skeletonizer/skeletonizer.dart';

class SliverListCustom<T> extends ConsumerWidget {
  final PaginationParams<T> params;
  final Widget Function(T item) itemBuilder;
  final T itemPlaceholder;
  final Widget? emptyWidget;
  final double itemSpacing;

  const SliverListCustom({
    super.key,
    required this.params,
    required this.itemBuilder,
    required this.itemPlaceholder,
    this.emptyWidget,
    this.itemSpacing = SPACE_SMALL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado y el controlador de la paginación
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
            childCount: 5,
          ),
        ),
      );
    }

    // 2. ESTADO DE ERROR (Blindado por Don Sputknif)
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

    // 3. ESTADO VACÍO (Con detección inteligente de Slivers)
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

      // Si Don Sput nos pasa un Sliver, lo soltamos tal cual.
      // Si nos pasa un Widget normal (Box), lo envolvemos en un adapter.
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
              // OPTIMIZACIÓN: Pre-fetch al llegar al final
              final fetchThreshold = state.items.length - 5;
              if (i >= fetchThreshold && state.hasMore && !state.isFetchingMore && !state.isLoading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.fetchMore();
                });
              }

              final item = state.items[i];
              return Column(
                children: [
                  itemBuilder(item),
                  Space(itemSpacing),
                ],
              );
            },
            childCount: state.items.length,
          ),
        ),

        // 5. CARGANDO MÁS (Skeleton inferior)
        if (state.isFetchingMore)
          Skeletonizer.sliver(
            enabled: true,
            child: SliverToBoxAdapter(
              child: Column(
                children: [
                  itemBuilder(itemPlaceholder),
                  Space(itemSpacing),
                ],
              ),
            ),
          ),
      ],
    );
  }
}