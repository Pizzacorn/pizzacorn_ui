import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';
import '../layout/space.dart';

/// Bottom sheet sencillo con UN botón.
/// Suele usarse como footer fijo de un modal/bottomSheet.
class BottomSheetCustomOneButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? colorButton;

  const BottomSheetCustomOneButton({
    super.key,
    required this.title,
    this.colorButton,
    required this.onPressed,
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
        color: COLOR_BACKGROUND,
        boxShadow: [BoxShadowCustom()],
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
class BottomSheetCustomTwoButtons extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;
  final Color? colorBackground;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;

  const BottomSheetCustomTwoButtons({
    super.key,
    required this.leftTitle,
    required this.rightTitle,
    required this.onLeftPressed,
    required this.onRightPressed,
    this.colorBackground,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackground = colorBackground ?? COLOR_BACKGROUND;

    return Container(
      padding: const EdgeInsets.only(
        bottom: SPACE_MEDIUM,
        left: SPACE_MEDIUM,
        right: SPACE_MEDIUM,
        top: SPACE_MEDIUM,
      ),
      decoration: BoxDecoration(
        color: effectiveBackground,
        //boxShadow: [BoxShadowCustom()],
      ),
      child: Row(
        children: [
          Expanded(
            child: ButtonCustom(
              text: leftTitle,
              border: true,
              onPressed: () {
                if (onLeftPressed != null) {
                  onLeftPressed!();
                }
              },
            ),
          ),
          const SizedBox(width: SPACE_SMALL),
          Expanded(
            child: ButtonCustom(
              text: rightTitle,
              onPressed: () {
                if (onRightPressed != null) {
                  onRightPressed!();
                }
              },
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
