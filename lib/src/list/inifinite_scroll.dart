import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// ListView con scroll infinito integrado al estilo Pizzacorn
class InfiniteListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final ScrollController? controller;

  InfiniteListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onLoadMore,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.controller,
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
    if (widget.controller == null) {
      scrollController.dispose();
    }
    super.dispose();
  }

  void onScroll() {
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
            padding: PADDING,
            child: Center(child: TextCaption("No hay más registros")),
          ),
      ],
    );
  }
}
