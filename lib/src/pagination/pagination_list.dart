import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SliverListCustom<T> extends ConsumerWidget {
  final PaginationParams<T> params;
  final Widget Function(T item) itemBuilder;
  final T itemPlaceholder;
  final Widget? emptyWidget;
  final double itemSpacing;

  const SliverListCustom({super.key,
    required this.params,
    required this.itemBuilder,
    required this.itemPlaceholder,
    this.emptyWidget,
    this.itemSpacing = SPACE_SMALL, // 👈 Por defecto SPACE_SMALL
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginationProvider(params));
    final controller = ref.read(paginationProvider(params).notifier);

    // 1. ESTADO DE CARGA INICIAL (5 Elementos Skeleton)
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
            childCount: 5, // 🟢 Forzamos 5 para que se vea el skeleton al cargar
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

    // 4. LISTA REAL PAGINADA
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) {
              // 🟢 OPTIMIZACIÓN: Pre-fetch cuando faltan 5 elementos para evitar lag
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
                  Space(itemSpacing), // 🟢 Usando el nuevo espaciado
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
                  Space(itemSpacing), // 🟢 Usando el nuevo espaciado
                ],
              ),
            ),
          ),
      ],
    );
  }
}