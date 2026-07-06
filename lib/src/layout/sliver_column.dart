import 'package:flutter/material.dart';

class SliverColumn extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  SliverColumn({
    super.key,
    this.children = const [],
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget sliver = SliverMainAxisGroup(
      slivers: children,
    );

    if (padding != EdgeInsets.zero) {
      sliver = SliverPadding(
        padding: padding,
        sliver: sliver,
      );
    }

    if (backgroundColor != null) {
      sliver = DecoratedSliver(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        sliver: sliver,
      );
    }

    return sliver;
  }
}
