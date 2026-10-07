// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/segmented/segmented_cupertino.dart
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

enum SegmentedCounterPosition { below, right }

/// PIZZACORN_UI CANDIDATE
/// Widget: SegmentedCupertinoCustom
/// Motivo: Wrapper de CupertinoSlidingSegmentedControl que usa los tokens de pizzacorn_ui y soporta textos secundarios.
/// API: SegmentedCupertinoCustom(items: ["Hoy", "Mañana"], currentIndex: 0, onValueChanged: (i) => ...)
class SegmentedCupertinoCustom extends StatelessWidget {
  /// Lista de etiquetas que se mostrarán en cada segmento.
  final List<String> items;

  /// Textos secundarios (opcional), uno por segmento.
  final List<String>? itemsSecondary;
  final SegmentedCounterPosition counterPosition;
  final bool counterCircle;
  final Color? counterCircleColor;
  final List<Color> counterGradientColors;
  final PizzacornGradientType counterGradientType;
  final Color? counterTextColor;

  /// Puntos de notificación (opcional), uno por segmento.
  final List<bool>? notifications;

  /// Índice del segmento actualmente seleccionado.
  final int currentIndex;

  /// Callback que devuelve el índice cuando se pulsa un segmento.
  final ValueChanged<int> onValueChanged;

  /// Padding opcional alrededor del control.
  final EdgeInsetsGeometry padding;

  /// Colores personalizados (nullables para usar tokens).
  final Color? thumbColor;
  final List<Color> selectedGradientColors;
  final PizzacornGradientType selectedGradientType;
  final bool selectedGradientAnimated;
  final Duration selectedGradientDuration;
  final Color? backgroundColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final Color? notificationColor;

  /// Tamaño del punto de notificación.
  final double notificationSize;

  const SegmentedCupertinoCustom({
    super.key,
    required this.items,
    this.itemsSecondary,
    this.counterPosition = SegmentedCounterPosition.below,
    this.counterCircle = false,
    this.counterCircleColor,
    this.counterGradientColors = const [],
    this.counterGradientType = PizzacornGradientType.linear,
    this.counterTextColor,
    this.notifications,
    required this.currentIndex,
    required this.onValueChanged,
    this.padding = const EdgeInsets.all(0),
    this.thumbColor,
    this.selectedGradientColors = const [],
    this.selectedGradientType = PizzacornGradientType.linear,
    this.selectedGradientAnimated = false,
    this.selectedGradientDuration = const Duration(milliseconds: 2600),
    this.backgroundColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.notificationColor,
    this.notificationSize = 7,
  }) : assert(
          itemsSecondary == null || itemsSecondary.length == items.length,
          'itemsSecondary debe tener la misma longitud que items',
        ),
        assert(
          notifications == null || notifications.length == items.length,
          'notifications debe tener la misma longitud que items',
        ),
        assert(selectedGradientDuration > Duration.zero);

  @override
  Widget build(BuildContext context) {
    // 🔥 Resolución de colores con tokens vivos de pizzacorn_ui.
    final Color effectiveThumbColor = thumbColor ?? COLOR_ACCENT;
    final Color effectiveBgColor = backgroundColor ?? COLOR_BACKGROUND_SECONDARY;
    final Color effectiveActiveText = activeTextColor ?? Colors.white;
    final Color effectiveInactiveText = inactiveTextColor ?? COLOR_TEXT;
    final Color effectiveNotificationColor = notificationColor ?? COLOR_ERROR;
    final bool hasSelectedGradient = selectedGradientColors.isNotEmpty;

    // 🍕 Cupertino necesita un mapa por índice, así mantenemos control total.
    final Map<int, Widget> childrenMap = {};
    for (int i = 0; i < items.length; i++) {
      final bool isSelected = i == currentIndex;
      final String label = items[i];
      final String secondary = (itemsSecondary != null) ? itemsSecondary![i] : '';
      final bool hasNotification = notifications != null && notifications![i];
      final Color effectiveCounterTextColor = counterTextColor ??
          (counterCircle ? Colors.white :
              (isSelected ? effectiveActiveText : effectiveInactiveText));
      final Gradient? counterGradient = counterCircle && counterGradientColors.length >= 2
          ? switch (counterGradientType) {
              PizzacornGradientType.linear => LinearGradient(colors: counterGradientColors),
              PizzacornGradientType.radial => RadialGradient(colors: counterGradientColors),
              PizzacornGradientType.sweep => SweepGradient(colors: counterGradientColors),
            }
          : null;
      final Widget counterWidget = counterCircle
          ? Container(
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: counterGradient == null
                    ? counterCircleColor ?? effectiveThumbColor
                    : null,
                gradient: counterGradient,
              ),
              alignment: Alignment.center,
              child: TextCaption(secondary, color: effectiveCounterTextColor, fontSize: 10),
            )
          : TextCaption(
              secondary,
              color: effectiveCounterTextColor,
              fontSize: 10,
            );

      Widget segment = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextBody(
                  label,
                  color: isSelected ? effectiveActiveText : effectiveInactiveText,
                  fontWeight: isSelected ? WEIGHT_BOLD : WEIGHT_NORMAL,
                ),
                if (secondary.isNotEmpty && counterPosition == SegmentedCounterPosition.right) ...[
                  Space(SPACE_SMALLEST),
                  counterWidget,
                ],
                if (hasNotification) ...[
                  Space(SPACE_SMALLEST),
                  Container(
                    width: notificationSize,
                    height: notificationSize,
                    decoration: BoxDecoration(
                      color: effectiveNotificationColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            if (secondary.isNotEmpty && counterPosition == SegmentedCounterPosition.below) ...[
              Space(SPACE_SMALLEST),
              counterWidget,
            ],
          ],
        ),
      );
      if (isSelected && hasSelectedGradient) {
        segment = SegmentedSelectionGradient(
          colors: selectedGradientColors,
          gradientType: selectedGradientType,
          animated: selectedGradientAnimated,
          duration: selectedGradientDuration,
          child: segment,
        );
      }
      childrenMap[i] = segment;
    }

    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl<int>(
          backgroundColor: effectiveBgColor,
          thumbColor: hasSelectedGradient ? Colors.transparent : effectiveThumbColor,
          groupValue: currentIndex,
          children: childrenMap,
          onValueChanged: (int? value) {
            if (value != null) {
              onValueChanged(value);
            }
          },
        ),
      ),
    );
  }
}

/// Fondo degradado del segmento seleccionado.
class SegmentedSelectionGradient extends StatefulWidget {
  final List<Color> colors;
  final PizzacornGradientType gradientType;
  final bool animated;
  final Duration duration;
  final Widget child;

  const SegmentedSelectionGradient({
    super.key,
    required this.colors,
    required this.gradientType,
    required this.animated,
    required this.duration,
    required this.child,
  });

  @override
  State<SegmentedSelectionGradient> createState() => SegmentedSelectionGradientState();
}

class SegmentedSelectionGradientState extends State<SegmentedSelectionGradient>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animated) animationController.repeat();
  }

  @override
  void didUpdateWidget(SegmentedSelectionGradient oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) animationController.duration = widget.duration;
    if (widget.animated && !animationController.isAnimating) {
      animationController.repeat();
    } else if (!widget.animated && animationController.isAnimating) {
      animationController.stop();
      animationController.value = 0;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = widget.colors.length == 1
        ? [widget.colors.first, widget.colors.first]
        : widget.colors;
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final double angle = animationController.value * 2 * pi;
        final Gradient gradient = switch (widget.gradientType) {
          PizzacornGradientType.linear => LinearGradient(
              colors: colors,
              transform: widget.animated ? GradientRotation(angle) : null,
            ),
          PizzacornGradientType.radial => RadialGradient(
              colors: colors,
              center: widget.animated
                  ? Alignment(cos(angle) * 0.6, sin(angle) * 0.6)
                  : Alignment.center,
              radius: 1.2,
            ),
          PizzacornGradientType.sweep => SweepGradient(
              colors: [...colors, colors.first],
              transform: widget.animated ? GradientRotation(angle) : null,
            ),
        };
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: gradient,
          ),
          child: child,
        );
      },
    );
  }
}
