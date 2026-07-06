import 'dart:math';

import 'package:flutter/material.dart';

import '../../pizzacorn_ui.dart';

class GridExpandedSelectorModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String value;

  GridExpandedSelectorModel({
    this.title = "",
    this.subtitle = "",
    this.imageUrl = "",
    this.value = "",
  });

  String get currentValue {
    if (value.isNotEmpty) {
      return value;
    }

    return title;
  }
}

class GridExpandedSelector extends StatefulWidget {
  final List<GridExpandedSelectorModel> items;
  final String selectedItem;
  final int initialSelectedIndex;
  final TextStyle? styleTitleExpanded;
  final TextStyle? styleTitleCompressed;
  final TextStyle? styleSubTitleExpanded;
  final bool showSubtitleCompressed;
  final double widthCompressed;
  final double heightCompressed;
  final bool borderSimple;
  final bool borderGradient;
  final Color? borderSimpleColor;
  final List<Color> borderGradientColors;
  final double selectedOverlayOpacity;
  final ValueChanged<String> onChanged;

  // ignore: prefer_const_constructors_in_immutables
  GridExpandedSelector({
    super.key,
    required this.items,
    required this.selectedItem,
    this.initialSelectedIndex = 0,
    this.styleTitleExpanded,
    this.styleTitleCompressed,
    this.styleSubTitleExpanded,
    this.showSubtitleCompressed = false,
    this.widthCompressed = 0,
    this.heightCompressed = 0,
    this.borderSimple = false,
    this.borderGradient = true,
    this.borderSimpleColor,
    this.borderGradientColors = const [],
    this.selectedOverlayOpacity = 0,
    required this.onChanged,
  });

  @override
  GridExpandedSelectorState createState() {
    return GridExpandedSelectorState();
  }
}

class GridExpandedSelectorState extends State<GridExpandedSelector> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectInitialItem();
    });
  }

  @override
  void didUpdateWidget(covariant GridExpandedSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectInitialItem();
    });
  }

  void selectInitialItem() {
    if (widget.selectedItem.isNotEmpty || widget.items.isEmpty) {
      return;
    }

    final int safeIndex = widget.initialSelectedIndex.clamp(
      0,
      widget.items.length - 1,
    );
    widget.onChanged(widget.items[safeIndex].currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int selectedIndex = getSelectedIndex();
        final double gap = SPACE_SMALL;
        final int selectedColumn = selectedIndex.isOdd ? 1 : 0;
        final int selectedRow = selectedIndex >= 2 ? 1 : 0;
        final double availableWidth = max(0, constraints.maxWidth - gap);
        final double availableHeight = max(0, constraints.maxHeight - gap);
        final double calculatedCompactWidth = availableWidth * 0.26;
        final double calculatedCompactHeight = availableHeight * 0.14;
        final double compactWidth = min(
          availableWidth,
          max(widget.widthCompressed, calculatedCompactWidth),
        );
        final double compactHeight = min(
          availableHeight,
          max(widget.heightCompressed, calculatedCompactHeight),
        );
        final double expandedWidth = max(0, availableWidth - compactWidth);
        final double expandedHeight = max(0, availableHeight - compactHeight);
        final double leftWidth = selectedColumn == 0
            ? expandedWidth
            : compactWidth;
        final double rightWidth = selectedColumn == 1
            ? expandedWidth
            : compactWidth;
        final double topHeight = selectedRow == 0
            ? expandedHeight
            : compactHeight;
        final double bottomHeight = selectedRow == 1
            ? expandedHeight
            : compactHeight;
        final children = <Widget>[];

        for (int i = 0; i < widget.items.length; i++) {
          if (!getCanRenderItem(i)) {
            continue;
          }

          final GridExpandedSelectorModel item = widget.items[i];
          final bool selected = i == selectedIndex;
          final Rect itemRect = getItemRect(
            index: i,
            leftWidth: leftWidth,
            rightWidth: rightWidth,
            topHeight: topHeight,
            bottomHeight: bottomHeight,
            gap: gap,
          );

          children.add(
            AnimatedPositioned(
              duration: Duration(milliseconds: 560),
              curve: Curves.easeInOutCubic,
              left: itemRect.left,
              top: itemRect.top,
              width: itemRect.width,
              height: itemRect.height,
              child: AnimatedGradientBorderContainer(
                selected: selected,
                onTap: () {
                  widget.onChanged(item.currentValue);
                },
                radius: 8,
                borderWidth: 3.5,
                color: COLOR_BACKGROUND_TERCIARY,
                padding: PADDING_ALL,
                backgroundImage: buildBackgroundImage(item),
                borderSimple: widget.borderSimple,
                borderGradient: widget.borderGradient,
                borderSimpleColor: widget.borderSimpleColor,
                borderGradientColors: widget.borderGradientColors,
                selectedOverlayOpacity: widget.selectedOverlayOpacity,
                child: buildContent(item, selected),
              ),
            ),
          );
        }

        return Stack(children: children);
      },
    );
  }

  int getSelectedIndex() {
    for (int i = 0; i < widget.items.length; i++) {
      if (widget.items[i].currentValue == widget.selectedItem) {
        return i;
      }
    }

    if (widget.selectedItem.isEmpty && widget.items.isNotEmpty) {
      return widget.initialSelectedIndex.clamp(0, widget.items.length - 1);
    }

    return -1;
  }

  Rect getItemRect({
    required int index,
    required double leftWidth,
    required double rightWidth,
    required double topHeight,
    required double bottomHeight,
    required double gap,
  }) {
    final int column = index.isOdd ? 1 : 0;
    final int row = index >= 2 ? 1 : 0;
    final double left = column == 0 ? 0 : leftWidth + gap;
    final double top = row == 0 ? 0 : topHeight + gap;
    final double width = column == 0 ? leftWidth : rightWidth;
    final double height = row == 0 ? topHeight : bottomHeight;

    return Rect.fromLTWH(left, top, width, height);
  }

  bool getCanRenderItem(int index) {
    if (index < 0) {
      return false;
    }

    return index < 4;
  }

  DecorationImage? buildBackgroundImage(GridExpandedSelectorModel item) {
    if (item.imageUrl.isEmpty) {
      return null;
    }

    return DecorationImage(
      image: NetworkImage(item.imageUrl),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        COLOR_BACKGROUND_TERCIARY.withValues(alpha: 0.72),
        BlendMode.srcOver,
      ),
    );
  }

  Widget buildContent(GridExpandedSelectorModel item, bool selected) {
    final bool showSubtitle =
        item.subtitle.isNotEmpty && (selected || widget.showSubtitleCompressed);
    final TextStyle titleStyle = selected
        ? widget.styleTitleExpanded ?? styleSubtitle(color: COLOR_TEXT)
        : widget.styleTitleCompressed ?? styleSubtitle(color: COLOR_TEXT);
    final TextStyle subtitleStyle =
        widget.styleSubTitleExpanded ?? styleBody(color: COLOR_TEXT);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: titleStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (showSubtitle) Space(SPACE_SMALLEST),
          if (showSubtitle)
            Text(
              item.subtitle,
              textAlign: TextAlign.center,
              style: subtitleStyle,
              maxLines: selected ? 3 : 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
