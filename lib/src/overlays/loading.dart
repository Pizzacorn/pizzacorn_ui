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
  final VoidCallback? onDismiss;
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
    this.onDismiss,
    this.containerSize = 90,
    this.containerRadius = 20,
    this.containerPadding = const EdgeInsets.all(15),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: loading,
      opacity: opacity,
      color: color ?? Colors.black,
      dismissible: dismissible,
      onDismiss: onDismiss,
      indicatorBuilder: (context) => LoadingCustomCenter(
        centerWidget: centerWidget ??
            progressIndicator ??
            PizzacornGlassConfig.loadingWidget ??
            CircularProgressIndicator(color: COLOR_ACCENT, semanticsLabel: 'Cargando'),
        offset: offset,
        glass: glass,
        containerSize: containerSize,
        containerRadius: containerRadius,
        containerPadding: containerPadding,
      ),
      child: child,
    );
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
  final VoidCallback? onDismiss;
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
    this.onDismiss,
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
      onDismiss: onDismiss,
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
  final VoidCallback? onDismiss;
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
    this.onDismiss,
    required this.child,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: loading,
      opacity: opacity,
      color: color ?? Colors.grey,
      dismissible: dismissible,
      onDismiss: onDismiss,
      indicatorBuilder: (context) {
        final Widget effectiveIndicator =
            progressIndicator ?? CircularProgressIndicator(color: COLOR_ACCENT);
        final Widget positionedIndicator = offset == null
            ? Center(child: effectiveIndicator)
            : SizedBox(
                height: 40 + (offset!.dy > 0 ? offset!.dy : 0),
                child: Stack(
                  children: [
                    Positioned(
                      left: offset!.dx,
                      top: offset!.dy,
                      child: effectiveIndicator,
                    ),
                  ],
                ),
              );

        return Center(
          child: Container(
            constraints: const BoxConstraints(minWidth: 110, maxWidth: 260),
            padding: const EdgeInsets.all(SPACE_SMALL),
            decoration: BoxDecoration(
              color: COLOR_BACKGROUND_SECONDARY,
              borderRadius: BorderRadiusAll(),
              boxShadow: [BoxShadowCustom()],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                positionedIndicator,
                Space(SPACE_SMALL),
                Semantics(
                  liveRegion: true,
                  child: TextCaption(text, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class LoadingOverlay extends StatefulWidget {
  final bool loading;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final double opacity;
  final Color color;
  final WidgetBuilder indicatorBuilder;
  final Widget child;

  LoadingOverlay({
    super.key,
    required this.loading,
    required this.dismissible,
    required this.onDismiss,
    required this.opacity,
    required this.color,
    required this.indicatorBuilder,
    required this.child,
  });

  @override
  State<LoadingOverlay> createState() => LoadingOverlayState();
}

class LoadingOverlayState extends State<LoadingOverlay> {
  bool dismissed = false;

  @override
  void didUpdateWidget(covariant LoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.loading) dismissed = false;
  }

  void dismiss() {
    if (dismissed) return;
    setState(() => dismissed = true);
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bool visible = widget.loading && !dismissed;
    return Stack(
      children: [
        ExcludeFocus(
          excluding: visible,
          child: ExcludeSemantics(excluding: visible, child: widget.child),
        ),
        if (visible) ...[
          Opacity(
            opacity: widget.opacity,
            child: ModalBarrier(
              dismissible: widget.dismissible,
              onDismiss: dismiss,
              color: widget.color,
            ),
          ),
          widget.indicatorBuilder(context),
        ],
      ],
    );
  }
}

/// Helpers de decoración usados por los loadings.
/// Si ya los tienes definidos en otro lado, puedes unificarlos ahí.
BorderRadius BorderRadiusAll([double? radius]) {
  return BorderRadius.circular(radius ?? RADIUS);
}
