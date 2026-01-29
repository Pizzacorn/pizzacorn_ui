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

  const BottomBarCustom({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
    required this.titles,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
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
        height: 125,
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              COLOR_BACKGROUND_SECONDARY.withValues(alpha: 0),
              effectiveBg,
              effectiveBg,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 75,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: effectiveBg,
                borderRadius: BorderRadius.circular(RADIUS),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(titles.length, (index) {
                  return BottomItem(
                    title: titles[index],
                    iconData: icons[index],
                    isSelected: currentIndex == index,
                    onTap: () => onTap(index),
                    activeColor: effectiveActiveColor,
                    inactiveColor: effectiveInactiveColor,
                  );
                }),
              ),
            ),
          ],
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

  const BottomItem({
    super.key,
    required this.title,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: "Pestaña $title",
        selected: isSelected,
        button: true,
        onTap: onTap,
        child: Container(
          height: double.infinity,
          alignment: Alignment.topCenter,
          child: TextButton(
            style: styleTransparent(),
            onPressed: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                AnimatedContainer(
                  padding: const EdgeInsets.all(5),
                  duration: const Duration(milliseconds: 200),
                  child: buildIconContent(),
                ),
                if (isSelected)
                  TextSmall(
                    title,
                    maxlines: 1,
                    textAlign: TextAlign.center,
                    fontWeight: WEIGHT_BOLD,
                    color: activeColor,
                  ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIconContent() {
    final Color color = isSelected ? activeColor : inactiveColor;

    if (iconData is IconData) {
      return Icon(iconData, size: 20, color: color);
    } else if (iconData is String) {
      return SvgPicture.asset(
        iconData,
        height: 20,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return const SizedBox(width: 20, height: 20);
  }
}
