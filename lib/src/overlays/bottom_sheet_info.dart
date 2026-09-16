import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// 🍕 Bottom sheet informativo reutilizable con contenido visual opcional.
///
/// Muestra cero, uno o dos botones según las acciones recibidas. El botón
/// izquierdo usa borde y el derecho usa el color principal.
class BottomSheetInfo extends StatelessWidget {
  final String title;
  final String body;
  final String infoText;
  final String disclaimer;
  final IconData disclaimerIcon;
  final Color? disclaimerColor;
  final Color? disclaimerTextColor;
  final int disclaimerMaxlines;

  // 🎨 Cabecera visual. Solo debe configurarse una opción.
  final Widget? topWidget;
  final IconData? icon;
  final String imageUrl;
  final String imageAsset;
  final String lottieAsset;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final double visualSize;

  // 👈 Acción secundaria con borde.
  final String leftButtonTitle;
  final VoidCallback? onLeftButtonPressed;
  final IconData? leftButtonIcon;

  // 👉 Acción principal con fondo completo.
  final String rightButtonTitle;
  final VoidCallback? onRightButtonPressed;
  final IconData? rightButtonIcon;

  final Color? backgroundColor;
  final Color? infoBackgroundColor;
  final Color? leftButtonColor;
  final Color? rightButtonColor;

  // ignore: prefer_const_constructors_in_immutables
  BottomSheetInfo({
    super.key,
    this.title = "",
    this.body = "",
    this.infoText = "",
    this.disclaimer = "",
    this.disclaimerIcon = Icons.info_outline_rounded,
    this.disclaimerColor,
    this.disclaimerTextColor,
    this.disclaimerMaxlines = 5,
    this.topWidget,
    this.icon,
    this.imageUrl = "",
    this.imageAsset = "",
    this.lottieAsset = "",
    this.iconColor,
    this.iconBackgroundColor,
    this.visualSize = 80,
    this.leftButtonTitle = "",
    this.onLeftButtonPressed,
    this.leftButtonIcon,
    this.rightButtonTitle = "",
    this.onRightButtonPressed,
    this.rightButtonIcon,
    this.backgroundColor,
    this.infoBackgroundColor,
    this.leftButtonColor,
    this.rightButtonColor,
  }) : assert(
         (topWidget != null ? 1 : 0) +
                 (icon != null ? 1 : 0) +
                 (imageUrl.isNotEmpty ? 1 : 0) +
                 (imageAsset.isNotEmpty ? 1 : 0) +
                 (lottieAsset.isNotEmpty ? 1 : 0) <=
             1,
         "BottomSheetInfo solo admite una cabecera visual.",
       );

  @override
  Widget build(BuildContext context) {
    final bool showLeftButton =
        leftButtonTitle.isNotEmpty && onLeftButtonPressed != null;
    final bool showRightButton =
        rightButtonTitle.isNotEmpty && onRightButtonPressed != null;
    final Widget? visual = buildTopVisual();

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: PADDING_ALL,
        decoration: BoxDecoration(
          color: backgroundColor ?? COLOR_BACKGROUND,
          borderRadius: BorderRadius.vertical(top: Radius.circular(RADIUS)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visual != null) visual,
            if (visual != null) Space(SPACE_MEDIUM),
            if (title.isNotEmpty)
              TextTitle(
                title,
                textAlign: TextAlign.center,
              ),
            if (title.isNotEmpty && body.isNotEmpty) Space(SPACE_SMALL),
            if (body.isNotEmpty)
              TextBody(
                body,
                color: COLOR_SUBTEXT,
                textAlign: TextAlign.center,
              ),
            if (infoText.isNotEmpty) Space(SPACE_MEDIUM),
            if (infoText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: PADDING_ALL_SMALL,
                decoration: BoxDecoration(
                  color:
                      infoBackgroundColor ?? COLOR_ACCENT.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RADIUS),
                ),
                child: TextBody(
                  infoText,
                  textAlign: TextAlign.center,
                ),
              ),
            if (disclaimer.isNotEmpty) Space(SPACE_MEDIUM),
            if (disclaimer.isNotEmpty)
              disclaimerWidget(
                text: disclaimer,
                icon: disclaimerIcon,
                color: disclaimerColor,
                textColor: disclaimerTextColor,
                maxlines: disclaimerMaxlines,
              ),
            if (showLeftButton || showRightButton) Space(SPACE_MEDIUM),
            if (showLeftButton || showRightButton)
              Row(
                children: [
                  if (showLeftButton)
                    Expanded(
                      child: ButtonCustom(
                        text: leftButtonTitle,
                        prefixIcon: leftButtonIcon,
                        border: true,
                        color: Colors.transparent,
                        textColor: leftButtonColor ?? COLOR_TEXT,
                        borderColor: leftButtonColor ?? COLOR_BORDER,
                        iconColor: leftButtonColor ?? COLOR_TEXT,
                        onPressed: onLeftButtonPressed,
                      ),
                    ),
                  if (showLeftButton && showRightButton) Space(SPACE_SMALL),
                  if (showRightButton)
                    Expanded(
                      child: ButtonCustom(
                        text: rightButtonTitle,
                        prefixIcon: rightButtonIcon,
                        color: rightButtonColor ?? COLOR_ACCENT,
                        onPressed: onRightButtonPressed,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// 🖼️ Construye la única cabecera visual configurada.
  Widget? buildTopVisual() {
    if (topWidget != null) {
      return topWidget;
    }

    if (icon != null) {
      return Container(
        width: visualSize,
        height: visualSize,
        decoration: BoxDecoration(
          color:
              iconBackgroundColor ?? COLOR_ACCENT.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: visualSize * 0.5,
          color: iconColor ?? COLOR_ACCENT,
        ),
      );
    }

    if (imageUrl.isNotEmpty) {
      return ImageCustom(
        imageUrl: imageUrl,
        width: visualSize,
        height: visualSize,
        fit: BoxFit.contain,
        borderRadius: RADIUS,
      );
    }

    if (imageAsset.isNotEmpty) {
      return SizedBox(
        width: visualSize,
        height: visualSize,
        child: Image.asset(imageAsset, fit: BoxFit.contain),
      );
    }

    if (lottieAsset.isNotEmpty) {
      return SizedBox(
        width: visualSize,
        height: visualSize,
        child: Lottie.asset(lottieAsset, fit: BoxFit.contain),
      );
    }

    return null;
  }
}
