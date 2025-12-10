import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/config.dart';

/// =================== CONFIG GLOBAL (Fonts, Sizes, Weights) ===================
/// Úsalo en tu app antes de runApp(), por ejemplo:
///
/// PizzacornTextConfig.configure(
///   primaryFontFamily: 'Montserrat',
///   secondaryFontFamily: 'Inter',
///   sizes: PizzacornTextSizes(
///     big: 40,
///     title: 26,
///     subtitle: 22,
///     body: 13,
///     button: 13,
///     caption: 11,
///     small: 9,
///   ),
///   weights: PizzacornTextWeights(
///     normal: FontWeight.w400,
///     bold: FontWeight.w700,
///   ),
/// );
class PizzacornTextConfig {
  static String primaryFontFamily = 'League Gothic';
  static String secondaryFontFamily = 'Raleway';

  static PizzacornTextSizes sizes = const PizzacornTextSizes();
  static PizzacornTextWeights weights = const PizzacornTextWeights();

  static void configure({
    String? primaryFontFamily,
    String? secondaryFontFamily,
    PizzacornTextSizes? sizes,
    PizzacornTextWeights? weights,
  }) {
    if (primaryFontFamily != null && primaryFontFamily.trim().isNotEmpty) {
      PizzacornTextConfig.primaryFontFamily = primaryFontFamily.trim();
    }
    if (secondaryFontFamily != null && secondaryFontFamily.trim().isNotEmpty) {
      PizzacornTextConfig.secondaryFontFamily = secondaryFontFamily.trim();
    }
    if (sizes != null) PizzacornTextConfig.sizes = sizes;
    if (weights != null) PizzacornTextConfig.weights = weights;
  }
}

class PizzacornTextSizes {
  final double big;
  final double title;
  final double subtitle;
  final double body;
  final double button;
  final double caption;
  final double small;

  const PizzacornTextSizes({
    this.big = 38,
    this.title = 24,
    this.subtitle = 20,
    this.body = 12,
    this.button = 12,
    this.caption = 10,
    this.small = 8,
  });
}

class PizzacornTextWeights {
  final FontWeight normal;
  final FontWeight bold;

  const PizzacornTextWeights({
    this.normal = FontWeight.w500,
    this.bold = FontWeight.w600,
  });
}

/// =================== LÍNEAS ===================
const int MAXLINES = 5;

/// =================== GETTERS DINÁMICOS (no romper API) ===================
/// Tamaños (antes eran const)
double get TEXT_BIG_SIZE => PizzacornTextConfig.sizes.big;
double get TEXT_TITLE_SIZE => PizzacornTextConfig.sizes.title;
double get TEXT_SUBTITLE_SIZE => PizzacornTextConfig.sizes.subtitle;
double get TEXT_BODY_SIZE => PizzacornTextConfig.sizes.body;
double get TEXT_BUTTON_SIZE => PizzacornTextConfig.sizes.button;
double get TEXT_CAPTION_SIZE => PizzacornTextConfig.sizes.caption;
double get TEXT_SMALL_SIZE => PizzacornTextConfig.sizes.small;

/// Pesos (antes eran const)
FontWeight get WEIGHT_NORMAL => PizzacornTextConfig.weights.normal;
FontWeight get WEIGHT_BOLD => PizzacornTextConfig.weights.bold;


/// =================== BASES DE ESTILO ===================
TextStyle getStyleCustom(
    double size,
    FontWeight weight,
    Color color, {
      double letterspacing = 0,
      bool shadow = false,
      bool underlined = false,
      double height = 1.2,
    }) {
  try {
    return GoogleFonts.getFont(
      PizzacornTextConfig.primaryFontFamily,
      fontSize: size,
      letterSpacing: letterspacing,
      fontWeight: weight,
      height: height,
      color: color,
      decoration: underlined ? TextDecoration.underline : TextDecoration.none,
      shadows: shadow ? [Shadow(blurRadius: 70, color: COLOR_SUBTEXT)] : null,
    );
  } catch (_) {
    return GoogleFonts.leagueGothic(
      fontSize: size,
      letterSpacing: letterspacing,
      fontWeight: weight,
      height: height,
      color: color,
      decoration: underlined ? TextDecoration.underline : TextDecoration.none,
      shadows: shadow ? [Shadow(blurRadius: 70, color: COLOR_SUBTEXT)] : null,
    );
  }
}

TextStyle getStyleSecondaryCustom(
    double size,
    FontWeight weight,
    Color color, {
      double letterspacing = 0,
      bool shadow = false,
      bool underlined = false,
      double height = 1.2,
    }) {
  try {
    return GoogleFonts.getFont(
      PizzacornTextConfig.secondaryFontFamily,
      fontSize: size,
      letterSpacing: letterspacing,
      fontWeight: weight,
      height: height,
      color: color,
      decoration: underlined ? TextDecoration.underline : TextDecoration.none,
      shadows: shadow ? [Shadow(blurRadius: 70, color: COLOR_SUBTEXT)] : null,
    );
  } catch (_) {
    return GoogleFonts.raleway(
      fontSize: size,
      letterSpacing: letterspacing,
      fontWeight: weight,
      height: height,
      color: color,
      decoration: underlined ? TextDecoration.underline : TextDecoration.none,
      shadows: shadow ? [Shadow(blurRadius: 70, color: COLOR_SUBTEXT)] : null,
    );
  }
}

/// =================== ESTILOS ===================

TextStyle styleBig({
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
  double letterspacing = 0,
  bool shadow = false,
  double height = 1.2,
}) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return getStyleCustom(
    fontSize ?? TEXT_BIG_SIZE,
    fontWeight ?? WEIGHT_BOLD,
    effectiveColor,
    letterspacing: letterspacing,
    shadow: shadow,
    height: height,
  );
}

TextStyle styleTitle({
  Color? color,
  FontWeight? fontWeight,
  double? size,
  double height = 1.2,
}) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return getStyleCustom(
    size ?? TEXT_TITLE_SIZE,
    fontWeight ?? WEIGHT_BOLD,
    effectiveColor,
    height: height,
  );
}

TextStyle styleSubtitle({
  Color? color,
  FontWeight? fontWeight,
  double? size,
  double height = 1.2,
}) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return getStyleCustom(
    size ?? TEXT_SUBTITLE_SIZE,
    fontWeight ?? WEIGHT_BOLD,
    effectiveColor,
    height: height,
  );
}

TextStyle styleBody({
  Color? color,
  FontWeight? fontWeight,
  double? size,
  bool shadow = false,
  double height = 1.2,
}) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return getStyleSecondaryCustom(
    size ?? TEXT_BODY_SIZE,
    fontWeight ?? WEIGHT_NORMAL,
    effectiveColor,
    shadow: shadow,
    height: height,
  );
}

TextStyle styleButton({
  Color? color,
  FontWeight? fontWeight,
  double? size,
  double height = 1.2,
}) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return getStyleSecondaryCustom(
    size ?? TEXT_BUTTON_SIZE,
    fontWeight ?? WEIGHT_BOLD,
    effectiveColor,
    height: height,
  );
}

TextStyle styleCaption({
  Color? color,
  FontWeight? fontWeight,
  double? size,
  double height = 1.2,
}) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return getStyleSecondaryCustom(
    size ?? TEXT_CAPTION_SIZE,
    fontWeight ?? WEIGHT_NORMAL,
    effectiveColor,
    height: height,
  );
}

TextStyle styleSmall({
  Color? color,
  FontWeight? fontWeight,
  double? size,
  double height = 1.2,
}) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return getStyleSecondaryCustom(
    size ?? TEXT_SMALL_SIZE,
    fontWeight ?? WEIGHT_NORMAL,
    effectiveColor,
    height: height,
  );
}

/// =================== WIDGETS ===================

Widget TextBig(
    String text, {
      double? fontSize,
      Color? color,
      bool shadow = false,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.start,
      int maxlines = MAXLINES,
      TextOverflow textOverflow = TextOverflow.ellipsis,
      double espacioLetras = 0,
      bool isUppercase = false,
    }) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return Text(
    isUppercase ? text.toUpperCase() : text,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines,
    style: styleBig(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
      shadow: shadow,
    ),
  );
}

Widget TextTitle(
    String text, {
      double? fontSize,
      Color? color,
      bool shadow = false,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.start,
      int maxlines = MAXLINES,
      TextOverflow textOverflow = TextOverflow.ellipsis,
      double espacioLetras = 0,
      bool isUppercase = false,
      double height = 1.2,
    }) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return Text(
    isUppercase ? text.toUpperCase() : text,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines,
    style: styleTitle(
      size: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
      height: height,
    ),
  );
}

Widget TextSubtitle(
    String text, {
      double? fontSize,
      Color? color,
      bool shadow = false,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.start,
      int maxlines = MAXLINES,
      TextOverflow textOverflow = TextOverflow.ellipsis,
      double espacioLetras = 0,
      bool isUppercase = false,
      double height = 1.2,
    }) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return Text(
    isUppercase ? text.toUpperCase() : text,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines,
    style: styleSubtitle(
      size: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
      height: height,
    ),
  );
}

Widget TextBody(
    String texto, {
      double? fontSize,
      Color? color,
      bool shadow = false,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.start,
      int? maxlines,
      TextOverflow textOverflow = TextOverflow.ellipsis,
      double espacioLetras = 0,
      bool isUppercase = false,
      double height = 1.2,
    }) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return Text(
    isUppercase ? texto.toUpperCase() : texto,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines == 0 ? null : maxlines,
    style: styleBody(
      size: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
      shadow: shadow,
      height: height,
    ),
  );
}

Widget TextButtonCustom(
    String texto, {
      double? fontSize,
      bool shadow = false,
      Color? color,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.start,
      int maxlines = MAXLINES,
      TextOverflow textOverflow = TextOverflow.ellipsis,
      double espacioLetras = 0,
      bool isUppercase = false,
    }) {
  final Color effectiveColor = color ?? COLOR_TEXT_BUTTONS;

  return Text(
    isUppercase ? texto.toUpperCase() : texto,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines,
    style: styleButton(
      size: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
    ),
  );
}

Widget TextCaption(
    String texto, {
      double? fontSize,
      Color? color,
      bool shadow = false,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.start,
      int maxlines = MAXLINES,
      TextOverflow textOverflow = TextOverflow.ellipsis,
      double espacioLetras = 0,
      bool isUppercase = false,
    }) {
  final Color effectiveColor = color ?? COLOR_SUBTEXT;

  return Text(
    isUppercase ? texto.toUpperCase() : texto,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines,
    style: styleCaption(
      size: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
    ),
  );
}

Widget TextSmall(
    String texto, {
      double? fontSize,
      Color? color,
      bool shadow = false,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.start,
      int maxlines = MAXLINES,
      TextOverflow textOverflow = TextOverflow.ellipsis,
      double espacioLetras = 0,
      bool isUppercase = false,
    }) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return Text(
    isUppercase ? texto.toUpperCase() : texto,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines,
    style: styleSmall(
      size: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
    ),
  );
}

Widget TextCustom(
    String texto, {
      double? fontSize,
      bool shadow = false,
      Color? color,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.start,
      int maxlines = MAXLINES,
      TextOverflow textOverflow = TextOverflow.ellipsis,
      double espacioLetras = 0,
      double height = 1,
      bool isUppercase = false,
    }) {
  final Color effectiveColor = color ?? COLOR_TEXT;

  return Text(
    isUppercase ? texto.toUpperCase() : texto,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines,
    style: getStyleCustom(
      fontSize ?? TEXT_BUTTON_SIZE,
      fontWeight ?? WEIGHT_BOLD,
      effectiveColor,
      letterspacing: espacioLetras,
      shadow: shadow,
      height: height,
    ),
  );
}
