// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/list/inifinite_scroll.dart
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: InfiniteListView
/// Motivo: ListView con scroll infinito integrado y física forzada para permitir scroll siempre.
/// API: InfiniteListView(itemCount: 10, itemBuilder: (ctx, i) => ..., onLoadMore: () async {})
class InfiniteListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final ScrollController? controller;
  final ScrollPhysics? physics; // Permitimos personalizar si fuera necesario

  const InfiniteListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onLoadMore,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.controller,
    this.physics,
  });

  @override
  State<InfiniteListView> createState() => InfiniteListViewState();
}

class InfiniteListViewState extends State<InfiniteListView> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller ?? ScrollController();
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    // Solo destruimos el controller si lo creamos nosotros
    if (widget.controller == null) {
      scrollController.dispose();
    }
    super.dispose();
  }

  void onScroll() {
    // Lanzamos la carga cuando falten 200px para el final
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoadingMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            // 🚀 LA CLAVE: Forzamos que siempre se pueda scrollear
            physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder,
          ),
        ),

        if (widget.isLoadingMore)
          Padding(
            padding: PADDING,
            child: Center(
              child: CircularProgressIndicator(
                color: COLOR_ACCENT,
                strokeWidth: 2,
              ),
            ),
          ),

        if (!widget.hasMore && widget.itemCount > 0)
          Padding(
            padding: PADDING_ALL_SMALL,
            child: Center(
              child: TextCaption("No hay más registros"),
            ),
          ),
      ],
    );
  }
}