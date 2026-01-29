import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class WebAdapterCustom extends StatelessWidget {
  final List<Widget> children;

  WebAdapterCustom({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    // WEBSIZE debe estar definido en tu config.dart
    if (MediaQuery.of(context).size.width > WEBSIZE) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    } else {
      // REGLA: Aunque sea una columna, mantenemos la consistencia de children
      return Column(children: children);
    }
  }
}
