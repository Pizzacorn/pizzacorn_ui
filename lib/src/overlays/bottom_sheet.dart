import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';
import '../layout/space.dart';

/// Bottom sheet sencillo con UN botón.
/// Suele usarse como footer fijo de un modal/bottomSheet.
/// Bottom sheet sencillo con UN botón.
/// Suele usarse como footer fijo de un modal/bottomSheet.
class BottomSheetCustomOneButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? colorButton;
  final bool hasBackground; // <-- El nuevo parámetro de Don Sputo

  const BottomSheetCustomOneButton({
    super.key,
    required this.title,
    this.colorButton,
    required this.onPressed,
    this.hasBackground = true, // Por defecto true para no romper lo anterior
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveButtonColor = colorButton ?? COLOR_ACCENT;

    return Container(
      padding: const EdgeInsets.only(
        bottom: SPACE_BIG,
        left: SPACE_MEDIUM,
        right: SPACE_MEDIUM,
        top: SPACE_MEDIUM,
      ),
      decoration: BoxDecoration(
        // Si tiene background ponemos color y sombra, si no, transparente
        color: hasBackground ? COLOR_BACKGROUND : Colors.transparent,
        boxShadow: hasBackground ? [BoxShadowCustom()] : [],
      ),
      child: ButtonCustom(
        text: title,
        color: effectiveButtonColor,
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
      ),
    );
  }
}

/// Bottom sheet con DOS botones (izquierda y derecha).
/// Ideal para "Cancelar / Aceptar" o similares.
/// Bottom sheet con DOS botones (izquierda y derecha).
/// Ideal para "Cancelar / Aceptar" o similares.
class BottomSheetCustomTwoButtons extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;
  final Color? colorBackground;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;
  final bool hasBackground; // <-- El nuevo parámetro de Don Sput

  const BottomSheetCustomTwoButtons({
    super.key,
    this.leftTitle = "",
    this.rightTitle = "",
    this.onLeftPressed,
    this.onRightPressed,
    this.colorBackground,
    this.hasBackground = true, // Por defecto true
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackground = colorBackground ?? COLOR_BACKGROUND;

    // Comprobamos si debemos mostrar cada botón
    final bool showLeft = leftTitle.isNotEmpty && onLeftPressed != null;
    final bool showRight = rightTitle.isNotEmpty && onRightPressed != null;

    return Container(
      padding: const EdgeInsets.all(SPACE_MEDIUM),
      decoration: BoxDecoration(
        color: hasBackground ? effectiveBackground : Colors.transparent,
      ),
      child: Row(
        children: [
          // Botón Izquierdo
          if (showLeft)
            Expanded(
              child: ButtonCustom(
                text: leftTitle,
                border: true,
                onPressed: onLeftPressed!,
              ),
            ),

          // Espaciador (Solo si ambos están visibles)
          if (showLeft && showRight)
            Space(SPACE_SMALL),

          // Botón Derecho
          if (showRight)
            Expanded(
              child: ButtonCustom(
                text: rightTitle,
                onPressed: onRightPressed!,
              ),
            ),
        ],
      ),
    );
  }
}

/// Sombras estándar Pizzacorn.
/// Si ya la tienes definida en otro archivo (por ejemplo en `loading.dart`),
/// puedes moverla a un helper compartido y reutilizarla.
BoxShadow BoxShadowCustom() {
  return BoxShadow(
    color: COLOR_SHADOW.withValues(alpha: 0.2),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
}
