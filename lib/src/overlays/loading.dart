import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';


/// Overlay de carga simple.
/// Envuelve [child] en un Stack y, si [loading] es true,
/// muestra un modal con un loader centrado.
class Loading extends StatelessWidget {
  final bool loading;
  final double opacity;
  final Color? color;
  final Widget? progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;

  const Loading({
    super.key,
    required this.loading,
    this.opacity = 0.3,
    this.color,
    this.progressIndicator,
    this.offset,
    this.dismissible = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> stackChildren = [
      child,
    ];

    if (loading) {
      final Color effectiveColor = color ?? Colors.black;
      final Widget effectiveIndicator =
          progressIndicator ?? CircularProgressIndicator(color: COLOR_ACCENT);

      Widget layOutProgressIndicator;

      if (offset == null) {
        layOutProgressIndicator = Center(child: effectiveIndicator);
      } else {
        layOutProgressIndicator = Stack(
          children: [
            Positioned(
              left: offset!.dx,
              top: offset!.dy,
              child: effectiveIndicator,
            ),
          ],
        );
      }

      stackChildren.addAll([
        Opacity(
          opacity: opacity,
          child: ModalBarrier(
            dismissible: dismissible,
            color: effectiveColor,
          ),
        ),
        Center(
          child: Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: COLOR_BACKGROUND_SECONDARY,
              borderRadius: BorderRadiusAll(),
              boxShadow: [BoxShadowCustom()],
            ),
            child: layOutProgressIndicator,
          ),
        ),
      ]);
    }

    return Stack(
      children: stackChildren,
    );
  }
}

/// Overlay de carga con texto debajo del loader.
class LoadingWithText extends StatelessWidget {
  final bool loading;
  final double opacity;
  final Color? color;
  final Widget? progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;
  final String text;

  const LoadingWithText({
    super.key,
    required this.loading,
    this.opacity = 0.3,
    this.color,
    this.progressIndicator,
    this.offset,
    this.dismissible = false,
    required this.child,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> stackChildren = [
      child,
    ];

    if (loading) {
      final Color effectiveColor = color ?? Colors.grey;
      final Widget effectiveIndicator =
          progressIndicator ?? CircularProgressIndicator(color: COLOR_ACCENT);

      Widget layOutProgressIndicator;

      if (offset == null) {
        layOutProgressIndicator = Center(child: effectiveIndicator);
      } else {
        layOutProgressIndicator = Stack(
          children: [
            Positioned(
              left: offset!.dx,
              top: offset!.dy,
              child: effectiveIndicator,
            ),
          ],
        );
      }

      stackChildren.addAll([
        Opacity(
          opacity: opacity,
          child: ModalBarrier(
            dismissible: dismissible,
            color: effectiveColor,
          ),
        ),
        Center(
          child: Container(
            height: 110,
            width: 110,
            padding: const EdgeInsets.all(SPACE_SMALL),
            decoration: BoxDecoration(
              color: COLOR_BACKGROUND_SECONDARY,
              borderRadius: BorderRadiusAll(),
              boxShadow: [BoxShadowCustom()],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                layOutProgressIndicator,
                Space(SPACE_SMALL),
                TextCaption(
                  text,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ]);
    }

    return Stack(
      children: stackChildren,
    );
  }
}

/// Helpers de decoración usados por los loadings.
/// Si ya los tienes definidos en otro lado, puedes unificarlos ahí.
BorderRadius BorderRadiusAll([double? radius]) {
  return BorderRadius.circular(radius ?? RADIUS);
}