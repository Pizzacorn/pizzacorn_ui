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

  const GridCustom({ // 🟢 Añadido const y super.key
    super.key,
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
    // 🟢 MAGIA: Quitamos el <T> y dejamos que infiera por 'params'
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
              // Pre-fetch
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

        // 5. CARGANDO MÁS
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
                  childCount: crossAxisCount,
                ),
              ),
            ),
          ),

        SliverToBoxAdapter(child: Space(SPACE_MEDIUM)),
      ],
    );
  }
}