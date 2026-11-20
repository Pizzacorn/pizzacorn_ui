import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'pagination_status.dart' show PaginationStatus;

class SliverGridCustom<T> extends ConsumerWidget {
  final PaginationParams<T> params;
  final Widget Function(T item) itemBuilder;
  final T itemPlaceholder;
  final Widget? emptyWidget;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int crossAxisCount;

  /// Ancho mínimo deseado por celda cuando las columnas son adaptables.
  final double? minItemWidth;

  final double childAspectRatio;
  final bool autoLoadMore;
  final bool showSkeleton;
  final PaginationMessages messages;
  // Añadimos el extractor de ID opcional igual que en la lista
  final String Function(T item)? idExtractor;

  SliverGridCustom({
    super.key,
    required this.params,
    required this.itemBuilder,
    required this.itemPlaceholder,
    this.emptyWidget,
    this.mainAxisSpacing = SPACE_SMALL,
    this.crossAxisSpacing = SPACE_SMALL,
    this.crossAxisCount = 2,
    this.minItemWidth,
    this.childAspectRatio = 1.0,
    this.autoLoadMore = true,
    this.showSkeleton = true,
    this.messages = const PaginationMessages(),
    this.idExtractor,
  }) : assert(minItemWidth == null || (minItemWidth > 0 && minItemWidth.isFinite));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginationProvider(params));
    final controller = ref.read(paginationProvider(params).notifier);
    final double? itemWidth = minItemWidth;

    if (itemWidth == null) {
      return buildGrid(
        state: state,
        controller: controller,
        columnCount: crossAxisCount,
      );
    }
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final int fittingColumns =
            ((constraints.crossAxisExtent + crossAxisSpacing) /
                    (itemWidth + crossAxisSpacing))
                .floor();
        return buildGrid(
          state: state,
          controller: controller,
          columnCount: fittingColumns < 1 ? 1 : fittingColumns,
        );
      },
    );
  }

  Widget buildGrid({
    required PaginationState<dynamic> state,
    required PaginationController<dynamic> controller,
    required int columnCount,
  }) {
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columnCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
    // 1. ESTADO DE CARGA INICIAL
    if (state.isLoading && state.items.isEmpty) {
      if (!showSkeleton) {
        return SliverToBoxAdapter(
          child: PaginationStatus(loading: true, loadingLabel: messages.loading),
        );
      }

      return buildSkeleton(
        gridDelegate: gridDelegate,
        itemCount: columnCount > 6 ? columnCount : 6,
      );
    }

    // 2. ESTADO DE ERROR INICIAL
    if (state.error.isNotEmpty && state.items.isEmpty) {
      return SliverToBoxAdapter(
        child: PaginationStatus(
          message: controller.lastDocument == null
              ? messages.initialError
              : messages.loadMoreError,
          actionLabel: messages.retry,
          onAction: controller.retry,
        ),
      );
    }

    // 3. ESTADO VACÍO
    if (state.items.isEmpty) {
      if (state.hasMore && params.itemFilter != null) {
        return SliverToBoxAdapter(
          child: PaginationStatus(
            actionLabel: messages.loadMore,
            onAction: controller.fetchMore,
            loading: state.isFetchingMore,
            loadingLabel: messages.loading,
          ),
        );
      }
      if (emptyWidget == null) {
        return SliverToBoxAdapter(
          child: PaginationStatus(message: messages.empty),
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
          gridDelegate: gridDelegate,
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              if (autoLoadMore &&
                  i == state.items.length - 1 &&
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

        if (state.isFetchingMore && showSkeleton)
          SliverPadding(
            padding: EdgeInsets.only(top: mainAxisSpacing),
            sliver: buildSkeleton(
              gridDelegate: gridDelegate,
              itemCount: columnCount,
            ),
          )
        else if (state.isFetchingMore)
          SliverToBoxAdapter(
            child: PaginationStatus(loading: true, loadingLabel: messages.loading),
          )
        else if (state.error.isNotEmpty)
          SliverToBoxAdapter(
            child: PaginationStatus(
              message: messages.loadMoreError,
              actionLabel: messages.retry,
              onAction: controller.retry,
            ),
          )
        else if (!autoLoadMore && state.hasMore)
          SliverToBoxAdapter(
            child: PaginationStatus(
              actionLabel: messages.loadMore,
              onAction: controller.fetchMore,
            ),
          ),
        SliverToBoxAdapter(child: Space(SPACE_MEDIUM)),
      ],
    );
  }

  Widget buildSkeleton({
    required SliverGridDelegate gridDelegate,
    required int itemCount,
  }) {
    return Skeletonizer.sliver(
      enabled: true,
      child: SliverGrid(
        gridDelegate: gridDelegate,
        delegate: SliverChildBuilderDelegate(
          (context, index) => itemBuilder(itemPlaceholder),
          childCount: itemCount,
        ),
      ),
    );
  }
}
