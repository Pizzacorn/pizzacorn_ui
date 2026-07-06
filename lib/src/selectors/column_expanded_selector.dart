import 'dart:math';

import 'package:flutter/material.dart';

import '../../pizzacorn_ui.dart';

class ColumnExpandedSelectorModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String value;

  ColumnExpandedSelectorModel({
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

class ColumnExpandedSelector extends StatefulWidget {
  final List<ColumnExpandedSelectorModel> items;
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
  ColumnExpandedSelector({
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
  ColumnExpandedSelectorState createState() {
    return ColumnExpandedSelectorState();
  }
}

class ColumnExpandedSelectorState extends State<ColumnExpandedSelector> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectInitialItem();
    });
  }

  @override
  void didUpdateWidget(covariant ColumnExpandedSelector oldWidget) {
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
        final children = <Widget>[];
        final double totalGap = SPACE_SMALL * (widget.items.length - 1);
        final double availableHeight = max(0, constraints.maxHeight - totalGap);
        final int selectedIndex = getSelectedIndex();
        final double calculatedExpandedHeight = availableHeight * 0.68;
        final double calculatedCompactHeight = widget.items.length > 1
            ? (availableHeight - calculatedExpandedHeight) /
                  (widget.items.length - 1)
            : availableHeight;
        final double compactHeight = max(
          widget.heightCompressed,
          calculatedCompactHeight,
        );
        final double expandedHeight = widget.items.length > 1
            ? max(
                0,
                availableHeight - (compactHeight * (widget.items.length - 1)),
              )
            : max(widget.heightCompressed, calculatedExpandedHeight);
        final double emptyHeight = widget.items.isNotEmpty
            ? availableHeight / widget.items.length
            : 0;

        for (int i = 0; i < widget.items.length; i++) {
          final ColumnExpandedSelectorModel item = widget.items[i];
          final bool selected = i == selectedIndex;
          final double itemHeight = selectedIndex >= 0
              ? selected
                    ? expandedHeight
                    : compactHeight
              : emptyHeight;

          children.add(
            AnimatedContainer(
              duration: Duration(milliseconds: 520),
              curve: Curves.easeInOutCubic,
              height: itemHeight,
              width: double.infinity,
              constraints: BoxConstraints(minWidth: widget.widthCompressed),
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

          if (i < widget.items.length - 1) {
            children.add(Space(SPACE_SMALL));
          }
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
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

  DecorationImage? buildBackgroundImage(ColumnExpandedSelectorModel item) {
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

  Widget buildContent(ColumnExpandedSelectorModel item, bool selected) {
    final bool showSubtitle =
        item.subtitle.isNotEmpty && (selected || widget.showSubtitleCompressed);
    final TextStyle titleStyle = selected
        ? widget.styleTitleExpanded ?? styleSubtitle(color: COLOR_TEXT)
        : widget.styleTitleCompressed ?? styleSubtitle(color: COLOR_TEXT);
    final TextStyle subtitleStyle =
        widget.styleSubTitleExpanded ?? styleBody(color: COLOR_TEXT);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: item.title, style: titleStyle),
                if (showSubtitle) TextSpan(text: "\n"),
                if (showSubtitle)
                  TextSpan(text: item.subtitle, style: subtitleStyle),
              ],
            ),
            maxLines: showSubtitle
                ? selected
                      ? 5
                      : 3
                : 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: selected
              ? Icon(
                  Icons.check_circle_rounded,
                  key: ValueKey("check"),
                  color: COLOR_TEXT,
                  size: 24,
                )
              : SizedBox(key: ValueKey("empty"), width: 0, height: 24),
        ),
      ],
    );
  }
}
