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

  // ICONS (SVG)
  final String iconBegin;
  final String iconFinal;

  // ICONS (IconData / IconsPro)
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  // Compatibilidad con los nombres antiguos.
  final IconData? iconBeginData;
  final IconData? iconFinalData;

  // SOCIAL ICONS
  final bool isGoogleButton;
  final bool isAppleButton;

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

  // ignore: prefer_const_constructors_in_immutables
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
    this.prefixIcon,
    this.suffixIcon,
    this.iconBeginData,
    this.iconFinalData,
    this.isGoogleButton = false,
    this.isAppleButton = false,
    this.iconColor = Colors.white,
    this.iconNoColor = false,
    this.iconSize = 18,
    this.onlyText = false,
    this.semanticLabel,
  }) : assert(
         !(isGoogleButton && isAppleButton),
         "ButtonCustom no puede ser Google y Apple a la vez.",
       );

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? COLOR_ACCENT;

    final HSLColor hsl = HSLColor.fromColor(effectiveColor);
    final Color autoDarkenedSplash = hsl
        .withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0))
        .toColor();

    final Color effectiveColorSplash = colorSplash ?? autoDarkenedSplash;
    final Color effectiveTextColor =
        textColor ?? (border ? COLOR_TEXT : COLOR_TEXT_BUTTONS);
    final Color effectiveBorderColor = borderColor ?? COLOR_BORDER;
    final double effectiveBorderRadius = borderRadius ?? RADIUS;
    final Color effectiveGradientPrimary = colorGradientPrimary ?? COLOR_ACCENT;
    final Color effectiveGradientSecondary =
        colorGradientSecondary ?? COLOR_ACCENT_SECONDARY;
    final String socialIcon = isGoogleButton
        ? "google"
        : isAppleButton
        ? "apple"
        : "";

    final double finalHeight = height ?? BUTTON_HEIGHT;

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
                gradient: !hasGradient || richTexts.isNotEmpty || onlyText
                    ? null
                    : LinearGradient(
                        colors: [
                          effectiveGradientPrimary,
                          effectiveGradientSecondary,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                color: hasGradient || richTexts.isNotEmpty || onlyText
                    ? null
                    : effectiveColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  mainAxisAlignment: mainAxisAlignment,
                  children: [
                    if (socialIcon.isNotEmpty ||
                        prefixIcon != null ||
                        iconBeginData != null ||
                        iconBegin.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          right: text.isNotEmpty ? 10 : 0,
                        ),
                        child: socialIcon.isNotEmpty
                            ? SvgCustomNoColor(
                                fullIcon:
                                    "packages/pizzacorn_ui/assets/icons/$socialIcon.svg",
                                size: iconSize,
                              )
                            : buildIcon(prefixIcon ?? iconBeginData, iconBegin),
                      ),
                    if (text.isNotEmpty)
                      Flexible(
                        child: TextButtonCustom(
                          text,
                          color: effectiveTextColor,
                          fontSize: customSizeText != 0
                              ? customSizeText
                              : TEXT_BUTTON_SIZE,
                        ),
                      )
                    else if (richTexts.isNotEmpty)
                      RichText(
                        text: TextSpan(children: buildRichTextChildren()),
                      ),
                    if (suffixIcon != null ||
                        iconFinalData != null ||
                        iconFinal.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          left: text.isNotEmpty ? 10 : 0,
                        ),
                        child: buildIcon(
                          suffixIcon ?? iconFinalData,
                          iconFinal,
                        ),
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

  Widget buildIcon(IconData? data, String svgPath) {
    if (data != null) {
      return Icon(data, size: iconSize, color: iconColor);
    }
    if (svgPath.isNotEmpty) {
      return iconNoColor
          ? SvgCustomNoColor(icon: svgPath, size: iconSize)
          : SvgCustom(icon: svgPath, size: iconSize, color: iconColor);
    }
    return const SizedBox.shrink();
  }

  List<TextSpan> buildRichTextChildren() {
    final List<TextSpan> textSpanList = [];
    for (int i = 0; i < richTexts.length; i++) {
      final Map<String, String> textData = richTexts[i];
      final String key = textData.keys.first;
      final String value = textData.values.first;
      textSpanList.add(
        TextSpan(
          text: value,
          style: key == "destacado"
              ? styleBody(fontWeight: FontWeight.bold, color: COLOR_ACCENT)
              : styleBody(),
        ),
      );
    }
    return textSpanList;
  }
}

/// PIZZACORN_UI CANDIDATE
/// Widget: OptionButton
/// Motivo: Un boton de fila ideal para menus de opciones, perfiles o configuraciones.
class OptionButton extends StatelessWidget {
  final String title;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final Color? suffixIconColor;
  final VoidCallback? onTap;
  final bool hasShadow;

  const OptionButton({
    super.key,
    required this.title,
    this.prefixIcon,
    this.suffixIcon,
    this.color,
    this.textColor,
    this.iconColor,
    this.suffixIconColor,
    this.onTap,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor = textColor ?? COLOR_TEXT;
    final Color effectiveIconColor = iconColor ?? effectiveTextColor;
    final Color effectiveSuffixIconColor =
        suffixIconColor ?? Colors.grey.shade400;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RADIUS),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: DecorationCustom(
          color: color ?? COLOR_BACKGROUND,
          hasShadow: hasShadow,
        ),
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: 20, color: effectiveIconColor),
              Space(SPACE_SMALL),
            ],
            Expanded(
              child: TextBody(
                title,
                color: effectiveTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (suffixIcon != null)
              Icon(suffixIcon, size: 16, color: effectiveSuffixIconColor),
          ],
        ),
      ),
    );
  }
}
