import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';
import '../layout/space.dart';

/// Bottom sheet sencillo con UN botón totalmente personalizable.
class BottomSheetCustomOneButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  // Colores del botón
  final Color? colorButton;
  final Color? textColor;
  final Color? borderColor;
  final bool border;

  final bool hasBackground;

  const BottomSheetCustomOneButton({
    super.key,
    required this.title,
    this.onPressed,
    this.colorButton,
    this.textColor,
    this.borderColor,
    this.border = false,
    this.hasBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    // Si no se pasa color, usamos ACCENT por defecto
    final Color effectiveButtonColor = colorButton ?? COLOR_ACCENT;

    return Container(
      padding: const EdgeInsets.only(
        bottom: SPACE_BIG,
        left: SPACE_MEDIUM,
        right: SPACE_MEDIUM,
        top: SPACE_MEDIUM,
      ),
      decoration: BoxDecoration(
        color: hasBackground ? COLOR_BACKGROUND : Colors.transparent,
        boxShadow: hasBackground ? [BoxShadowCustom()] : [],
      ),
      child: ButtonCustom(
        text: title,
        color: effectiveButtonColor,
        textColor: textColor,      // 🔥 Ahora controlas el texto
        borderColor: borderColor,  // 🔥 Ahora controlas el borde
        border: border,            // 🔥 Puedes activar el borde
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
      ),
    );
  }
}

/// Bottom sheet con DOS botones con control total de estilo.
class BottomSheetCustomTwoButtons extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;
  final Color? colorBackground;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;
  final bool hasBackground;

  // Personalización Botón Izquierdo
  final Color? leftColor;
  final Color? leftTextColor;
  final Color? leftBorderColor;
  final bool leftBorder;

  // Personalización Botón Derecho
  final Color? rightColor;
  final Color? rightTextColor;
  final Color? rightBorderColor;
  final bool rightBorder;

  const BottomSheetCustomTwoButtons({
    super.key,
    this.leftTitle = "",
    this.rightTitle = "",
    this.onLeftPressed,
    this.onRightPressed,
    this.colorBackground,
    this.hasBackground = true,
    // Defaults para el izquierdo (Suele ser el de cancelar)
    this.leftColor = Colors.transparent,
    this.leftTextColor,
    this.leftBorderColor,
    this.leftBorder = true,
    // Defaults para el derecho (Suele ser el de acción)
    this.rightColor,
    this.rightTextColor,
    this.rightBorderColor,
    this.rightBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackground = colorBackground ?? COLOR_BACKGROUND;

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
                border: leftBorder,
                color: leftColor,
                textColor: leftTextColor ?? COLOR_TEXT,
                borderColor: leftBorderColor ?? COLOR_BORDER,
                onPressed: onLeftPressed!,
              ),
            ),

          if (showLeft && showRight)
            Space(SPACE_SMALL),

          // Botón Derecho
          if (showRight)
            Expanded(
              child: ButtonCustom(
                text: rightTitle,
                color: rightColor ?? COLOR_ACCENT,
                textColor: rightTextColor,
                borderColor: rightBorderColor,
                border: rightBorder,
                onPressed: onRightPressed!,
              ),
            ),
        ],
      ),
    );
  }
}

/// Sombras estándar Pizzacorn.
BoxShadow BoxShadowCustom() {
  return BoxShadow(
    color: COLOR_SHADOW.withValues(alpha: 0.2),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
}