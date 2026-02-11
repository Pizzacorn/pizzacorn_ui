import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

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

  // ICONS
  final String iconBegin;
  final String iconFinal;
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
    final Color effectiveColor = color ?? COLOR_ACCENT;

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

    String label = semanticLabel ?? text;
    if (label.isEmpty && richTexts.isNotEmpty) {
      for (var map in richTexts) { label += "${map.values.first} "; }
    }

    return Semantics(
      label: label.trim(),
      button: true,
      enabled: onPressed != null,
      child: SizedBox(
        height: richTexts.isNotEmpty || onlyText ? 35 : finalHeight,
        width: width,
        child: Material(
          type: MaterialType.transparency,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            side: border
                ? BorderSide(color: effectiveBorderColor, width: borderWidth)
                : BorderSide.none,
          ),
          child: InkWell(
            splashColor: effectiveColorSplash,
            onTap: onPressed,
            onLongPress: onLongPressed,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
                // Lógica de Gradiente: Se quita si es texto simple o richText
                gradient: !hasGradient || richTexts.isNotEmpty || onlyText
                    ? null
                    : LinearGradient(
                  colors: [effectiveGradientPrimary, effectiveGradientSecondary],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                // Lógica de Color: Ahora NO depende de "border", se pinta siempre si no hay gradiente
                color: hasGradient || richTexts.isNotEmpty || onlyText
                    ? null
                    : effectiveColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  mainAxisAlignment: mainAxisAlignment,
                  children: [
                    if (iconBegin.isNotEmpty || iconBeginData != null)
                      Padding(
                        padding: EdgeInsets.only(right: text.isNotEmpty ? 10 : 0),
                        child: iconBeginData != null
                            ? Icon(iconBeginData, size: iconSize, color: iconColor)
                            : (iconNoColor
                            ? SvgCustomNoColor(icon: iconBegin, size: iconSize)
                            : SvgCustom(icon: iconBegin, size: iconSize, color: iconColor)),
                      ),
                    if (text.isNotEmpty)
                      Flexible(
                        child: TextButtonCustom(
                          text,
                          color: effectiveTextColor,
                          fontSize: customSizeText != 0 ? customSizeText : TEXT_BUTTON_SIZE,
                        ),
                      )
                    else if (richTexts.isNotEmpty)
                      RichText(text: TextSpan(children: buildRichTextChildren())),
                    if (iconFinal.isNotEmpty || iconFinalData != null)
                      Padding(
                        padding: EdgeInsets.only(left: text.isNotEmpty ? 10 : 0),
                        child: iconFinalData != null
                            ? Icon(iconFinalData, size: iconSize, color: iconColor)
                            : (iconNoColor
                            ? SvgCustomNoColor(icon: iconFinal, size: iconSize)
                            : SvgCustom(icon: iconFinal, size: iconSize, color: iconColor)),
                      ),
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
    return richTexts.map((textData) {
      final String key = textData.keys.first;
      final String value = textData.values.first;
      return TextSpan(
        text: value,
        style: key == "destacado"
            ? styleBody(fontWeight: FontWeight.bold, color: COLOR_ACCENT)
            : styleBody(),
      );
    }).toList();
  }
}