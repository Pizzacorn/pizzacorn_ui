import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import '../icons/svg.dart';

/// Botón custom Pizzacorn
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
  final double padding;
  final double iconSize;
  final String iconBegin;
  final String iconFinal;
  final Color iconColor;
  final bool iconNoColor;

  // COLOR
  final Color? color;
  final Color? colorSplash;
  final bool hasGradient;
  final Color? colorGradientPrimary;
  final Color? colorGradientSecondary;

  ButtonCustom({
    super.key,
    this.onPressed,
    this.onLongPressed,
    this.width = double.infinity,
    this.height, // Lo dejamos nulo aquí para resolverlo en el build
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.border = false,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius,
    this.text = "",
    this.customSizeText = 0,
    this.richTexts = const [],
    this.textColor,
    this.color,
    this.padding = 0,
    this.colorSplash,
    this.hasGradient = false,
    this.colorGradientPrimary,
    this.colorGradientSecondary,
    this.iconBegin = "",
    this.iconFinal = "",
    this.iconColor = Colors.white,
    this.iconNoColor = false,
    this.iconSize = 22,
    this.onlyText = false,
  });

  @override
  Widget build(BuildContext context) {
    // RESOLUCIÓN DE TOKENS REACTIVOS (REGLA DE ORO: Sin const)
    final Color effectiveTextColor = textColor ?? COLOR_TEXT;
    final Color effectiveBorderColor = borderColor ?? COLOR_BORDER;
    final double effectiveBorderRadius = borderRadius ?? RADIUS;
    final Color effectiveColor = color ?? COLOR_ACCENT;
    final Color effectiveColorSplash = colorSplash ?? COLOR_ACCENT_PRESSED;
    final Color effectiveGradientPrimary = colorGradientPrimary ?? COLOR_ACCENT;
    final Color effectiveGradientSecondary = colorGradientSecondary ?? COLOR_ACCENT_SECONDARY;

    // Altura reactiva basada en config.dart
    final double finalHeight = height ?? BUTTON_HEIGHT;

    return SizedBox(
      // Si tiene richText u onlyText, mantenemos un tamaño compacto, si no, el token
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
          splashColor: richTexts.isNotEmpty || onlyText || border
              ? effectiveColorSplash.withOpacity(0.02)
              : effectiveColorSplash,
          highlightColor: richTexts.isNotEmpty || onlyText || border
              ? effectiveColorSplash.withOpacity(0.02)
              : effectiveColorSplash.withOpacity(0.5),
          onTap: onPressed,
          onLongPress: onLongPressed,
          child: Ink(
            decoration: BoxDecoration(
              gradient: !hasGradient || richTexts.isNotEmpty || onlyText || border
                  ? null
                  : LinearGradient(
                colors: [
                  effectiveGradientPrimary,
                  effectiveGradientSecondary,
                ],
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
                  // ICONO INICIAL
                  if (iconBegin.isNotEmpty)
                    iconNoColor
                        ? SvgCustomNoColor(
                      icon: iconBegin,
                      size: iconSize,
                    )
                        : SvgCustom(
                      icon: iconBegin,
                      size: iconSize,
                      color: iconColor,
                    )
                  else if (iconFinal.isNotEmpty && text.isNotEmpty)
                    Space(iconSize),

                  // TEXTO O RICHTEXT
                  if (text.isNotEmpty)
                    TextButtonCustom(
                      text,
                      color: effectiveTextColor,
                      fontSize: customSizeText != 0 ? customSizeText : TEXT_BUTTON_SIZE,
                    )
                  else if (richTexts.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        children: buildRichTextChildren(),
                      ),
                    ),

                  // ICONO FINAL
                  if (iconFinal.isNotEmpty)
                    iconNoColor
                        ? SvgCustomNoColor(
                      icon: iconFinal,
                      size: iconSize,
                    )
                        : SvgCustom(
                      icon: iconFinal,
                      size: iconSize,
                      color: iconColor,
                    )
                  else if (iconBegin.isNotEmpty && text.isNotEmpty)
                    Space(iconSize),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// REGLA: Bucle con índice para construir el RichText
  List<TextSpan> buildRichTextChildren() {
    final List<TextSpan> children = <TextSpan>[];
    for (int i = 0; i < richTexts.length; i++) {
      final Map<String, String> textData = richTexts[i];
      final String key = textData.keys.first;
      final String value = textData.values.first;

      if (key == "destacado") {
        children.add(TextSpan(
          text: value,
          style: styleBody(
            fontWeight: FontWeight.bold,
            color: COLOR_ACCENT,
          ),
        ));
      } else {
        children.add(TextSpan(
          text: value,
          style: styleBody(),
        ));
      }
    }
    return children;
  }
}