import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'pagination_status.dart' show PaginationStatus;

class SliverListCustom<T> extends ConsumerWidget {
  final PaginationParams<T> params;
  final Widget Function(T item) itemBuilder;
  final T itemPlaceholder;
  final Widget? emptyWidget;
  final double itemSpacing;
  final bool autoLoadMore;
  final bool showSkeleton;
  final PaginationMessages messages;
  // Añadimos un extractor de ID opcional para que la Key sea 100% segura
  final String Function(T item)? idExtractor;

  SliverListCustom({
    super.key,
    required this.params,
    required this.itemBuilder,
    required this.itemPlaceholder,
    this.emptyWidget,
    this.itemSpacing = SPACE_SMALL,
    this.autoLoadMore = true,
    this.showSkeleton = true,
    this.messages = const PaginationMessages(),
    this.idExtractor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginationProvider(params));
    final controller = ref.read(paginationProvider(params).notifier);

    // 1. ESTADO DE CARGA INICIAL
    if (state.isLoading && state.items.isEmpty) {
      if (!showSkeleton) {
        return SliverToBoxAdapter(
          child: PaginationStatus(loading: true, loadingLabel: messages.loading),
        );
      }

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

    // 4. LISTA REAL PAGINADA
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
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
        if (state.isFetchingMore)
          SliverToBoxAdapter(
            child: showSkeleton
                ? Skeletonizer(
                    enabled: true,
                    child: Column(
                      children: [
                        itemBuilder(itemPlaceholder),
                        Space(itemSpacing),
                      ],
                    ),
                  )
                : PaginationStatus(
                    loading: true,
                    loadingLabel: messages.loading,
                  ),
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
  final bool autoLoadMore;
  final bool showSkeleton;
  final PaginationMessages messages;
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
    this.autoLoadMore = true,
    this.showSkeleton = true,
    this.messages = const PaginationMessages(),
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
          child: showSkeleton
              ? Skeletonizer(
                  enabled: true,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: padding,
                    physics: physics,
                    itemCount: 3,
                    separatorBuilder: (context, i) => SizedBox(width: itemSpacing),
                    itemBuilder: (context, i) => itemBuilder(itemPlaceholder),
                  ),
                )
              : PaginationStatus(loading: true, loadingLabel: messages.loading),
        ),
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
            }

            // 5. ZONA FINAL: SKELETON O ERROR DE PAGINACIÓN
            if (state.isFetchingMore && showSkeleton) {
              return Skeletonizer(
                enabled: true,
                child: itemBuilder(itemPlaceholder),
              );
            }

            if (state.isFetchingMore || state.error.isNotEmpty || !autoLoadMore) {
              return SizedBox(
                width: 220,
                child: PaginationStatus(
                  loading: state.isFetchingMore,
                  loadingLabel: messages.loading,
                  message: state.error.isNotEmpty ? messages.loadMoreError : null,
                  actionLabel: state.error.isNotEmpty ? messages.retry : messages.loadMore,
                  onAction: state.error.isNotEmpty ? controller.retry : controller.fetchMore,
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
    super.autoLoadMore,
    super.showSkeleton,
    super.messages,
    super.idExtractor,
  });
}
