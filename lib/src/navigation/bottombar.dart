import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: BottomBarCustom
/// Motivo: Navegación principal estandarizada con soporte para UIconsPro y SVGs.
/// API: BottomBarCustom(currentIndex: index, onTap: (i) => ..., icons: [UIconsPro.regularRounded.home, "assets/svg/map.svg"], titles: ["Inicio", "Mapa"])
class BottomBarCustom extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<dynamic> icons; // Acepta IconData (UIconsPro) o String (SVG Path)
  final List<String> titles;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? notificationColor;
  final List<bool>? notifications;
  final double notificationSize;
  final List<Color>? selectedGradientColors;
  final bool selectedGradientAnimated;
  final PizzacornGradientType selectedGradientType;

  /// Decide si los títulos son siempre visibles o solo en la pestaña activa.
  final bool alwaysShowTitles;

  /// Si es true, la barra aparece flotando con márgenes y bordes redondeados.
  /// Si es false, se pega al fondo sin márgenes laterales.
  final bool isFloating;

  /// Altura del cuerpo de la barra (donde están los iconos).
  final double height;

  /// Padding inferior adicional (útil para el efecto flotante o safe area manual).
  final double? paddingBottom;

  const BottomBarCustom({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
    required this.titles,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.notificationColor,
    this.notifications,
    this.notificationSize = 8,
    this.selectedGradientColors,
    this.selectedGradientAnimated = false,
    this.selectedGradientType = PizzacornGradientType.linear,
    this.alwaysShowTitles = false,
    this.isFloating = true,
    this.height = 75,
    this.paddingBottom,
  }) : assert(
         icons.length == titles.length,
         "La lista de iconos y títulos debe tener el mismo tamaño, Don Sput.",
       ),
       assert(notifications == null || notifications.length == titles.length);

  @override
  Widget build(BuildContext context) {
    final Color effectiveActiveColor = activeColor ?? COLOR_ACCENT;
    final Color effectiveInactiveColor =
        inactiveColor ?? COLOR_TEXT.withValues(alpha: 0.8);
    final Color effectiveBg = backgroundColor ?? COLOR_BACKGROUND;
    final Color effectiveNotificationColor = notificationColor ?? COLOR_ERROR;

    return Semantics(
      explicitChildNodes: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: paddingBottom ?? (isFloating ? 20 : 0)),
        decoration: isFloating
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    COLOR_BACKGROUND_SECONDARY.withValues(alpha: 0),
                    effectiveBg.withValues(alpha: 0.8),
                    effectiveBg,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              )
            : null,
        child: Container(
          height: height,
          margin: isFloating
              ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
              : EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: isFloating ? BorderRadius.circular(RADIUS) : null,
            border: !isFloating
                ? Border(top: BorderSide(color: COLOR_BORDER, width: 0.5))
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isFloating ? 0.1 : 0.05),
                blurRadius: 10,
                offset: Offset(0, isFloating ? 4 : -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(titles.length, (index) {
              return BottomItem(
                title: titles[index],
                iconData: icons[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
                activeColor: effectiveActiveColor,
                inactiveColor: effectiveInactiveColor,
                hasNotification: notifications != null && notifications![index],
                notificationColor: effectiveNotificationColor,
                notificationSize: notificationSize,
                alwaysShowTitles: alwaysShowTitles,
                selectedGradientColors: selectedGradientColors,
                selectedGradientAnimated: selectedGradientAnimated,
                selectedGradientType: selectedGradientType,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class BottomItem extends StatefulWidget {
  final String title;
  final dynamic iconData;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final bool hasNotification;
  final Color? notificationColor;
  final double notificationSize;
  final bool alwaysShowTitles;
  final List<Color>? selectedGradientColors;
  final bool selectedGradientAnimated;
  final PizzacornGradientType selectedGradientType;

  const BottomItem({
    super.key,
    required this.title,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    this.hasNotification = false,
    this.notificationColor,
    this.notificationSize = 8,
    required this.alwaysShowTitles,
    this.selectedGradientColors,
    this.selectedGradientAnimated = false,
    this.selectedGradientType = PizzacornGradientType.linear,
  });

  @override
  State<BottomItem> createState() => BottomItemState();
}

class BottomItemState extends State<BottomItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    updateAnimation();
  }

  @override
  void didUpdateWidget(BottomItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateAnimation();
  }

  void updateAnimation() {
    if (widget.isSelected && widget.selectedGradientAnimated &&
        widget.selectedGradientColors != null &&
        widget.selectedGradientColors!.isNotEmpty) {
      if (!animationController.isAnimating) animationController.repeat();
    } else {
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
    final Color effectiveNotificationColor = widget.notificationColor ?? COLOR_ERROR;
    final bool useGradient = widget.isSelected &&
        widget.selectedGradientColors != null &&
        widget.selectedGradientColors!.isNotEmpty;

    return Expanded(
      child: Semantics(
        label: "Pestaña ${widget.title}",
        selected: widget.isSelected,
        button: true,
        onTap: widget.onTap,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: widget.activeColor.withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  useGradient ? gradientContent(child: buildIconContent()) : buildIconContent(),
                  if (widget.hasNotification)
                    Positioned(
                      top: -2,
                      right: -4,
                      child: Container(
                        width: widget.notificationSize,
                        height: widget.notificationSize,
                        decoration: BoxDecoration(
                          color: effectiveNotificationColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: COLOR_BACKGROUND,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (widget.isSelected || widget.alwaysShowTitles) ...[
                const SizedBox(height: 4),
                Builder(builder: (context) {
                  final Widget label = TextSmall(
                  widget.title,
                  maxlines: 1,
                  textAlign: TextAlign.center,
                  fontWeight: widget.isSelected ? WEIGHT_BOLD : WEIGHT_NORMAL,
                  color: widget.isSelected ? widget.activeColor : widget.inactiveColor,
                  );
                  return useGradient ? gradientContent(child: label) : label;
                }),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIconContent() {
    final Color color = widget.isSelected ? widget.activeColor : widget.inactiveColor;

    if (widget.iconData is IconData) {
      return Icon(widget.iconData, size: 22, color: color);
    } else if (widget.iconData is String) {
      return SvgPicture.asset(
        widget.iconData,
        height: 22,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return const SizedBox(width: 22, height: 22);
  }

  Widget gradientContent({required Widget child}) {
    final List<Color> colors = widget.selectedGradientColors!;
    final List<Color> gradientColors = colors.length == 1
        ? [colors.first, colors.first]
        : colors;
    return AnimatedBuilder(
      animation: animationController,
      child: child,
      builder: (context, child) {
        final double angle = animationController.value * 2 * pi;
        final Gradient gradient = switch (widget.selectedGradientType) {
          PizzacornGradientType.linear => LinearGradient(
              colors: gradientColors,
              transform: widget.selectedGradientAnimated ? GradientRotation(angle) : null,
            ),
          PizzacornGradientType.radial => RadialGradient(
              colors: gradientColors,
              center: widget.selectedGradientAnimated
                  ? Alignment(cos(angle) * 0.6, sin(angle) * 0.6)
                  : Alignment.center,
              radius: 1.2,
            ),
          PizzacornGradientType.sweep => SweepGradient(
              colors: [...gradientColors, gradientColors.first],
              transform: widget.selectedGradientAnimated ? GradientRotation(angle) : null,
            ),
        };
        return ShaderMask(
          shaderCallback: gradient.createShader,
          blendMode: BlendMode.srcIn,
          child: child,
        );
      },
    );
  }
}
