import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Botón custom Pizzacorn - Versión Equilibrada y Centrada con Soporte de Accesibilidad
/// Soporta Iconos SVG e IconData (UIconsPro) con Splash dinámico oscurecido.
class ButtonCustom extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onLongPressed;

  final double? width;
  final double? height;
  final MainAxisAlignment mainAxisAlignment;

  // TEXT
  final Color? textColor;
  final String text;
  final bool onlyText;
  final double customSizeText;

  // RICHTEXT
  final List<Map<String, String>> richTexts;

  // BORDER
  final bool border;
  final double? borderRadius;
  final Color? borderColor;
  final double borderWidth;

  // ICONS (SVG)
  final String iconBegin;
  final String iconFinal;

  // ICONS (ICON DATA)
  final IconData? iconBeginData;
  final IconData? iconFinalData;

  final double padding;
  final double iconSize;
  final Color iconColor;
  final bool iconNoColor;

  // COLOR
  final Color? color;
  final Color? colorSplash;
  final bool hasGradient;
  final Color? colorGradientPrimary;
  final Color? colorGradientSecondary;

  // ACCESSIBILITY
  final String? semanticLabel;

  ButtonCustom({
    super.key,
    this.onPressed,
    this.onLongPressed,
    this.width = double.infinity,
    this.height,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.border = false,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius,
    this.text = "",
    this.customSizeText = 0,
    this.richTexts = const [],
    this.textColor,
    this.color,
    this.padding = 15,
    this.colorSplash,
    this.hasGradient = false,
    this.colorGradientPrimary,
    this.colorGradientSecondary,
    this.iconBegin = "",
    this.iconFinal = "",
    this.iconBeginData,
    this.iconFinalData,
    this.iconColor = Colors.white,
    this.iconNoColor = false,
    this.iconSize = 18,
    this.onlyText = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Lógica de Colores Efectivos
    final Color effectiveColor = color ?? COLOR_ACCENT;

    // PIZZACORN DYNAMIC SPLASH: Oscurecemos el color de acento un 15% para el splash
    final HSLColor hsl = HSLColor.fromColor(effectiveColor);
    final Color autoDarkenedSplash = hsl
        .withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0))
        .toColor();

    final Color effectiveColorSplash = colorSplash ?? autoDarkenedSplash;
    final Color effectiveTextColor = textColor ?? (border ? COLOR_TEXT : COLOR_TEXT_BUTTONS);
    final Color effectiveBorderColor = borderColor ?? COLOR_BORDER;
    final double effectiveBorderRadius = borderRadius ?? RADIUS;
    final Color effectiveGradientPrimary = colorGradientPrimary ?? COLOR_ACCENT;
    final Color effectiveGradientSecondary = colorGradientSecondary ?? COLOR_ACCENT_SECONDARY;

    final double finalHeight = height ?? BUTTON_HEIGHT;

    // 2. Lógica de Accesibilidad
    String label = semanticLabel ?? text;
    if (label.isEmpty && richTexts.isNotEmpty) {
      for (int i = 0; i < richTexts.length; i++) {
        label += "${richTexts[i].values.first} ";
      }
    }

    return Semantics(
      label: label.trim(),
      button: true,
      enabled: onPressed != null,
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: SizedBox(
        height: richTexts.isNotEmpty || onlyText ? 35 : finalHeight,
        width: width,
        child: Material(
          type: MaterialType.transparency,
          clipBehavior: Clip.antiAlias,
          shape: border
              ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            side: BorderSide(
              color: effectiveBorderColor,
              width: borderWidth,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          )
              : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          child: InkWell(
            splashColor: effectiveColorSplash,
            onTap: onPressed,
            onLongPress: onLongPressed,
            excludeFromSemantics: true,
            child: Ink(
              decoration: BoxDecoration(
                gradient: !hasGradient || richTexts.isNotEmpty || onlyText || border
                    ? null
                    : LinearGradient(
                  colors: [effectiveGradientPrimary, effectiveGradientSecondary],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                color: hasGradient || richTexts.isNotEmpty || onlyText || border
                    ? null
                    : effectiveColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  mainAxisAlignment: mainAxisAlignment,
                  children: [
                    // ICON BEGIN (SVG o IconData)
                    if (iconBegin.isNotEmpty || iconBeginData != null)
                      Padding(
                        padding: EdgeInsets.only(right: text.isNotEmpty ? 10 : 0),
                        child: iconBeginData != null
                            ? Icon(iconBeginData, size: iconSize, color: iconColor)
                            : (iconNoColor
                            ? SvgCustomNoColor(icon: iconBegin, size: iconSize)
                            : SvgCustom(icon: iconBegin, size: iconSize, color: iconColor)),
                      )
                    // Compensación para centrado si solo hay icono al final
                    else if ((iconFinal.isNotEmpty || iconFinalData != null) &&
                        text.isNotEmpty &&
                        mainAxisAlignment == MainAxisAlignment.center)
                      SizedBox(width: iconSize + 10),

                    // TEXTO O RICHTEXT
                    if (text.isNotEmpty)
                      Flexible(
                        child: TextButtonCustom(
                          text,
                          color: effectiveTextColor,
                          fontSize: customSizeText != 0 ? customSizeText : TEXT_BUTTON_SIZE,
                        ),
                      )
                    else if (richTexts.isNotEmpty)
                      RichText(
                        text: TextSpan(children: buildRichTextChildren()),
                      ),

                    // ICON FINAL (SVG o IconData)
                    if (iconFinal.isNotEmpty || iconFinalData != null)
                      Padding(
                        padding: EdgeInsets.only(left: text.isNotEmpty ? 10 : 0),
                        child: iconFinalData != null
                            ? Icon(iconFinalData, size: iconSize, color: iconColor)
                            : (iconNoColor
                            ? SvgCustomNoColor(icon: iconFinal, size: iconSize)
                            : SvgCustom(icon: iconFinal, size: iconSize, color: iconColor)),
                      )
                    // Compensación para centrado si solo hay icono al principio
                    else if ((iconBegin.isNotEmpty || iconBeginData != null) &&
                        text.isNotEmpty &&
                        mainAxisAlignment == MainAxisAlignment.center)
                      SizedBox(width: iconSize + 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> buildRichTextChildren() {
    final List<TextSpan> children = <TextSpan>[];
    for (int i = 0; i < richTexts.length; i++) {
      final Map<String, String> textData = richTexts[i];
      final String key = textData.keys.first;
      final String value = textData.values.first;

      if (key == "destacado") {
        children.add(
          TextSpan(
            text: value,
            style: styleBody(fontWeight: FontWeight.bold, color: COLOR_ACCENT),
          ),
        );
      } else {
        children.add(TextSpan(text: value, style: styleBody()));
      }
    }
    return children;
  }
}
