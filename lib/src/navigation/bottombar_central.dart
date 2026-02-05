// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/navigation/bottombar_central.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Necesario para los iconos SVG
import '../../pizzacorn_ui.dart'; // Importamos la librería principal para tokens y widgets
import '../utils/color_utils.dart'; // Para el método .withValues(alpha: )

/// PIZZACORN_UI CANDIDATE
/// Widget: BottomBarCentral
/// Motivo: Barra de navegación inferior con 4 elementos laterales y un botón de acción central flotante.
/// API: BottomBarCentral(currentIndex: 0, onTap: (i) => ..., onCenterTap: () => ..., icons: [...], titles: [...])
class BottomBarCentral extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onCenterTap;
  final List<dynamic> icons; // 4 iconos (2 izquierda, 2 derecha)
  final List<String> titles; // 4 títulos
  final dynamic centerIcon; // Icono del botón central
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? centerButtonColor;

  const BottomBarCentral({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
    required this.icons,
    required this.titles,
    this.centerIcon = Icons.add,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.centerButtonColor,
  }) : assert(
  icons.length == 4 && titles.length == 4,
  "Don Sputknif, esta barra necesita exactamente 4 iconos y 4 títulos para el equilibrio Pizzacorn.",
  );

  @override
  Widget build(BuildContext context) {

    final Color effectiveActiveColor = activeColor ?? COLOR_ACCENT;
    final Color effectiveInactiveColor = inactiveColor ?? COLOR_TEXT.withValues(alpha: 0.8);
    final Color effectiveBg = backgroundColor ?? COLOR_BACKGROUND;
    final Color effectiveCenterColor = centerButtonColor ?? COLOR_ACCENT;

    return Semantics(

      explicitChildNodes: true,

      child: Container(

        height: 140,
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 20),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              COLOR_BACKGROUND_SECONDARY.withValues(alpha: 0),
              effectiveBg.withValues(alpha: 0.5),
              effectiveBg,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Stack(

          alignment: Alignment.bottomCenter,

          children: [

            Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: effectiveBg,
                borderRadius: BorderRadius.circular(RADIUS),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Lado Izquierdo
                  _BottomBarCentralItem(
                    title: titles[0],
                    iconData: icons[0],
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                    activeColor: effectiveActiveColor,
                    inactiveColor: effectiveInactiveColor,
                  ),

                  _BottomBarCentralItem(
                    title: titles[1],
                    iconData: icons[1],
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                    activeColor: effectiveActiveColor,
                    inactiveColor: effectiveInactiveColor,
                  ),

                  // Espacio central para el botón circular (Hueco 3 de 5)
                  const Expanded(child: SizedBox.shrink()),


                  // Lado Derecho
                  _BottomBarCentralItem(
                    title: titles[2],
                    iconData: icons[2],
                    isSelected: currentIndex == 2, // Nota: el index real de la página suele saltar el centro
                    onTap: () => onTap(2),
                    activeColor: effectiveActiveColor,
                    inactiveColor: effectiveInactiveColor,
                  ),

                  _BottomBarCentralItem(
                    title: titles[3],
                    iconData: icons[3],
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
                    activeColor: effectiveActiveColor,
                    inactiveColor: effectiveInactiveColor,
                  ),

                ],
              ),
            ),

            // 2. Botón Circular Central Flotante
            Align(
              alignment: Alignment.center,
              child: Semantics(
                label: "Botón de acción central",
                button: true,
                onTap: onCenterTap,
                child: GestureDetector(
                  onTap: onCenterTap,
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      color: effectiveCenterColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: effectiveCenterColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(color: currentIndex == 4 ? effectiveActiveColor : effectiveBg, width: 3),
                    ),
                    child: Center(
                      child: _buildCenterIcon(centerIcon, Colors.white),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildCenterIcon(dynamic icon, Color color) {
    if (icon is IconData) {
      return Icon(icon, size: 28, color: color);
    } else if (icon is String) {
      return SvgPicture.asset(
        icon,
        height: 28,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    return const Icon(Icons.add, size: 28, color: Colors.white);
  }
}

/// Helper para los ítems de la barra inferior (BottomBarCentral)
class _BottomBarCentralItem extends StatelessWidget {
  final String title;
  final dynamic iconData;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  const _BottomBarCentralItem({
    super.key, // Añadido super.key para la consistencia
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
                  child: _buildIconContent(),
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

  Widget _buildIconContent() {
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