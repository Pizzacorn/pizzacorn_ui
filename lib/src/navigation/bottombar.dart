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

  /// Decide si los títulos son siempre visibles o solo en la pestaña activa.
  final bool alwaysShowTitles;

  /// Si es true, la barra aparece flotando con márgenes y bordes redondeados.
  /// Si es false, se pega al fondo sin márgenes laterales.
  final bool isFloating;

  /// Altura del cuerpo de la barra (donde están los iconos).
  final double height;

  /// Padding inferior adicional (útil para el efecto flotante o safe area manual).
  final double paddingBottom;

  const BottomBarCustom({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
    required this.titles,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.alwaysShowTitles = false,
    this.isFloating = true,
    this.height = 75,
    this.paddingBottom = 20,
  }) : assert(
         icons.length == titles.length,
         "La lista de iconos y títulos debe tener el mismo tamaño, Don Sput.",
       );

  @override
  Widget build(BuildContext context) {
    final Color effectiveActiveColor = activeColor ?? COLOR_ACCENT;
    final Color effectiveInactiveColor =
        inactiveColor ?? COLOR_TEXT.withValues(alpha: 0.8);
    final Color effectiveBg = backgroundColor ?? COLOR_BACKGROUND;

    return Semantics(
      explicitChildNodes: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: paddingBottom),
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
                alwaysShowTitles: alwaysShowTitles,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  final String title;
  final dynamic iconData;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final bool alwaysShowTitles;

  const BottomItem({
    super.key,
    required this.title,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.alwaysShowTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: "Pestaña $title",
        selected: isSelected,
        button: true,
        onTap: onTap,
        child: InkWell(
          onTap: onTap,
          splashColor: activeColor.withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              buildIconContent(),
              if (isSelected || alwaysShowTitles) ...[
                const SizedBox(height: 4),
                TextSmall(
                  title,
                  maxlines: 1,
                  textAlign: TextAlign.center,
                  fontWeight: isSelected ? WEIGHT_BOLD : WEIGHT_NORMAL,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIconContent() {
    final Color color = isSelected ? activeColor : inactiveColor;

    if (iconData is IconData) {
      return Icon(iconData, size: 22, color: color);
    } else if (iconData is String) {
      return SvgPicture.asset(
        iconData,
        height: 22,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return const SizedBox(width: 22, height: 22);
  }
}
