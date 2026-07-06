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
  final Widget? centerWidget;
  final bool? glass;
  final Offset? offset;
  final bool dismissible;
  final double containerSize;
  final double containerRadius;
  final EdgeInsetsGeometry containerPadding;
  final Widget child;

  const Loading({
    super.key,
    required this.loading,
    this.opacity = 0.3,
    this.color,
    this.progressIndicator,
    this.centerWidget,
    this.glass,
    this.offset,
    this.dismissible = false,
    this.containerSize = 90,
    this.containerRadius = 20,
    this.containerPadding = const EdgeInsets.all(15),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> stackChildren = [child];

    if (loading) {
      final Color effectiveColor = color ?? Colors.black;
      final Widget effectiveIndicator =
          centerWidget ??
          progressIndicator ??
          PizzacornGlassConfig.loadingWidget ??
          CircularProgressIndicator(color: COLOR_ACCENT);

      stackChildren.addAll([
        Opacity(
          opacity: opacity,
          child: ModalBarrier(dismissible: dismissible, color: effectiveColor),
        ),
        LoadingCustomCenter(
          centerWidget: effectiveIndicator,
          offset: offset,
          glass: glass,
          containerSize: containerSize,
          containerRadius: containerRadius,
          containerPadding: containerPadding,
        ),
      ]);
    }

    return Stack(children: stackChildren);
  }
}

class LoadingCustom extends StatelessWidget {
  final bool loading;
  final double opacity;
  final Color? color;
  final Widget? centerWidget;
  final Widget? progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final bool? glass;
  final double containerSize;
  final double containerRadius;
  final EdgeInsetsGeometry containerPadding;
  final Widget child;

  LoadingCustom({
    super.key,
    required this.loading,
    this.opacity = 0.3,
    this.color,
    this.centerWidget,
    this.progressIndicator,
    this.offset,
    this.dismissible = false,
    this.glass,
    this.containerSize = 90,
    this.containerRadius = 20,
    this.containerPadding = const EdgeInsets.all(15),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: loading,
      opacity: opacity,
      color: color,
      centerWidget: centerWidget,
      progressIndicator: progressIndicator,
      offset: offset,
      dismissible: dismissible,
      glass: glass,
      containerSize: containerSize,
      containerRadius: containerRadius,
      containerPadding: containerPadding,
      child: child,
    );
  }
}

class LoadingCustomCenter extends StatelessWidget {
  final Widget centerWidget;
  final Offset? offset;
  final bool? glass;
  final double containerSize;
  final double containerRadius;
  final EdgeInsetsGeometry containerPadding;

  LoadingCustomCenter({
    super.key,
    required this.centerWidget,
    this.offset,
    this.glass,
    this.containerSize = 90,
    this.containerRadius = 20,
    this.containerPadding = const EdgeInsets.all(15),
  });

  @override
  Widget build(BuildContext context) {
    if (offset != null) {
      return Positioned(left: offset!.dx, top: offset!.dy, child: centerWidget);
    }

    final bool effectiveGlass = glass ?? PizzacornGlassConfig.loadingGlass;

    return Center(
      child: SizedBox(
        height: containerSize,
        width: containerSize,
        child: effectiveGlass
            ? GlassContainerCustom(
                radius: containerRadius,
                padding: containerPadding,
                child: Center(child: centerWidget),
              )
            : Container(
                padding: containerPadding,
                decoration: BoxDecoration(
                  color: COLOR_BACKGROUND_SECONDARY,
                  borderRadius: BorderRadius.circular(containerRadius),
                  boxShadow: [BoxShadowCustom()],
                ),
                child: Center(child: centerWidget),
              ),
      ),
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
    final List<Widget> stackChildren = [child];

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
          child: ModalBarrier(dismissible: dismissible, color: effectiveColor),
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
                TextCaption(text, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ]);
    }

    return Stack(children: stackChildren);
  }
}

/// Helpers de decoración usados por los loadings.
/// Si ya los tienes definidos en otro lado, puedes unificarlos ahí.
BorderRadius BorderRadiusAll([double? radius]) {
  return BorderRadius.circular(radius ?? RADIUS);
}
