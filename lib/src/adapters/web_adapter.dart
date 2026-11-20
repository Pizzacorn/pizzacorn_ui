import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class WebAdapterCustom extends StatelessWidget {
  final List<Widget> children;
  final double? breakpoint;

  const WebAdapterCustom({
    super.key,
    required this.children,
    this.breakpoint,
  }) : assert(breakpoint == null || breakpoint >= 0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final bool wide = availableWidth > (breakpoint ?? WEBSIZE);
        return Flex(
          direction: wide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment:
              wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: children,
        );
      },
    );
  }
}
