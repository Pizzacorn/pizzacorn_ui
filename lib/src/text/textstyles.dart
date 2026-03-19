// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/text/textstyles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/config.dart';

/// Enum para decidir qué familia usar
enum PizzacornFontType { primary, secondary }

/// Clase para mapear cada estilo a una familia
class PizzacornTextFonts {
  final PizzacornFontType big;
  final PizzacornFontType title;
  final PizzacornFontType subtitle;
  final PizzacornFontType body;
  final PizzacornFontType button;
  final PizzacornFontType caption;
  final PizzacornFontType small;

  const PizzacornTextFonts({
    this.big = PizzacornFontType.primary,
    this.title = PizzacornFontType.primary,
    this.subtitle = PizzacornFontType.primary,
    this.body = PizzacornFontType.secondary,
    this.button = PizzacornFontType.secondary,
    this.caption = PizzacornFontType.secondary,
    this.small = PizzacornFontType.secondary,
  });
}

/// =================== CONFIG GLOBAL (Fonts, Sizes, Weights) ===================
class PizzacornTextConfig {
  static String primaryFontFamily = 'Montserrat';
  static String secondaryFontFamily = 'Montserrat';

  static PizzacornTextSizes sizes = const PizzacornTextSizes();
  static PizzacornTextWeights weights = const PizzacornTextWeights();
  static PizzacornTextFonts fonts = const PizzacornTextFonts();

  static void configure({
    String? primaryFontFamily,
    String? secondaryFontFamily,
    PizzacornTextSizes? sizes,
    PizzacornTextWeights? weights,
    PizzacornTextFonts? fonts,
  }) {
    if (primaryFontFamily != null && primaryFontFamily.trim().isNotEmpty) {
      PizzacornTextConfig.primaryFontFamily = primaryFontFamily.trim();
    }
    if (secondaryFontFamily != null && secondaryFontFamily.trim().isNotEmpty) {
      PizzacornTextConfig.secondaryFontFamily = secondaryFontFamily.trim();
    }
    if (sizes != null) PizzacornTextConfig.sizes = sizes;
    if (weights != null) PizzacornTextConfig.weights = weights;
    if (fonts != null) PizzacornTextConfig.fonts = fonts;
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
    this.big = 26,
    this.title = 18,
    this.subtitle = 16,
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
    this.normal = FontWeight.w400,
    this.bold = FontWeight.w600,
  });
}

/// =================== LÍNEAS ===================
const int MAXLINES = 5;

/// =================== GETTERS DINÁMICOS ===================
double get TEXT_BIG_SIZE => PizzacornTextConfig.sizes.big;
double get TEXT_TITLE_SIZE => PizzacornTextConfig.sizes.title;
double get TEXT_SUBTITLE_SIZE => PizzacornTextConfig.sizes.subtitle;
double get TEXT_BODY_SIZE => PizzacornTextConfig.sizes.body;
double get TEXT_BUTTON_SIZE => PizzacornTextConfig.sizes.button;
double get TEXT_CAPTION_SIZE => PizzacornTextConfig.sizes.caption;
double get TEXT_SMALL_SIZE => PizzacornTextConfig.sizes.small;

FontWeight get WEIGHT_NORMAL => PizzacornTextConfig.weights.normal;
FontWeight get WEIGHT_BOLD => PizzacornTextConfig.weights.bold;


/// =================== WIDGETS ===================

// Helper para construir el texto sin Semantics
Widget _buildText(
    String text,
    TextStyle style, {
      TextAlign textAlign = TextAlign.start,
      int? maxlines,
      TextOverflow textOverflow = TextOverflow.ellipsis,
      bool isUppercase = false,
    }) {
  return Text(
    isUppercase ? text.toUpperCase() : text,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines == 0 ? null : maxlines,
    style: style,
  );
}


/// =================== BASE DE ESTILO UNIFICADA ===================
TextStyle getStyle({
  required PizzacornFontType fontType,
  required double size,
  required FontWeight weight,
  required Color color,
  double letterspacing = 0,
  bool shadow = false,
  bool underlined = false,
  bool strikethrough = false,
  double height = 1.2,
}) {
  final String family = (fontType == PizzacornFontType.primary)
      ? PizzacornTextConfig.primaryFontFamily
      : PizzacornTextConfig.secondaryFontFamily;

  List<TextDecoration> decorations = [];
  if (underlined) decorations.add(TextDecoration.underline);
  if (strikethrough) decorations.add(TextDecoration.lineThrough);

  try {
    return GoogleFonts.getFont(
      family,
      fontSize: size,
      letterSpacing: letterspacing,
      fontWeight: weight,
      height: height,
      color: color,
      decoration: TextDecoration.combine(decorations),
      shadows: shadow ? [Shadow(blurRadius: 70, color: COLOR_SUBTEXT)] : null,
    );
  } catch (_) {
    return (fontType == PizzacornFontType.primary)
        ? GoogleFonts.leagueGothic(
      fontSize: size,
      letterSpacing: letterspacing,
      fontWeight: weight,
      height: height,
      color: color,
      decoration: TextDecoration.combine(decorations),
      shadows: shadow ? [Shadow(blurRadius: 70, color: COLOR_SUBTEXT)] : null,
    )
        : GoogleFonts.raleway(
      fontSize: size,
      letterSpacing: letterspacing,
      fontWeight: weight,
      height: height,
      color: color,
      decoration: TextDecoration.combine(decorations),
      shadows: shadow ? [Shadow(blurRadius: 70, color: COLOR_SUBTEXT)] : null,
    );
  }
}

TextStyle getStyleCustom(
    double size,
    FontWeight weight,
    Color color, {
      double letterspacing = 0,
      bool shadow = false,
      bool underlined = false,
      bool strikethrough = false,
      double height = 1.2,
    }) {
  return getStyle(
    fontType: PizzacornFontType.primary,
    size: size,
    weight: weight,
    color: color,
    letterspacing: letterspacing,
    shadow: shadow,
    underlined: underlined,
    strikethrough: strikethrough,
    height: height,
  );
}

TextStyle getStyleSecondaryCustom(
    double size,
    FontWeight weight,
    Color color, {
      double letterspacing = 0,
      bool shadow = false,
      bool underlined = false,
      bool strikethrough = false,
      double height = 1.2,
    }) {
  return getStyle(
    fontType: PizzacornFontType.secondary,
    size: size,
    weight: weight,
    color: color,
    letterspacing: letterspacing,
    shadow: shadow,
    underlined: underlined,
    strikethrough: strikethrough,
    height: height,
  );
}

/// =================== ESTILOS DINÁMICOS ===================

TextStyle styleBig({Color? color, FontWeight? fontWeight, double? fontSize, double letterspacing = 0, bool shadow = false, bool strikethrough = false, double height = 1.2}) {
  return getStyle(fontType: PizzacornTextConfig.fonts.big, size: fontSize ?? TEXT_BIG_SIZE, weight: fontWeight ?? WEIGHT_BOLD, color: color ?? COLOR_TEXT, letterspacing: letterspacing, shadow: shadow, strikethrough: strikethrough, height: height);
}

TextStyle styleTitle({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyle(fontType: PizzacornTextConfig.fonts.title, size: size ?? TEXT_TITLE_SIZE, weight: fontWeight ?? WEIGHT_BOLD, color: color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

TextStyle styleSubtitle({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyle(fontType: PizzacornTextConfig.fonts.subtitle, size: size ?? TEXT_SUBTITLE_SIZE, weight: fontWeight ?? WEIGHT_BOLD, color: color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

TextStyle styleBody({Color? color, FontWeight? fontWeight, double? size, bool shadow = false, bool strikethrough = false, double height = 1.2}) {
  return getStyle(fontType: PizzacornTextConfig.fonts.body, size: size ?? TEXT_BODY_SIZE, weight: fontWeight ?? WEIGHT_NORMAL, color: color ?? COLOR_TEXT, shadow: shadow, strikethrough: strikethrough, height: height);
}

TextStyle styleButton({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyle(fontType: PizzacornTextConfig.fonts.button, size: size ?? TEXT_BUTTON_SIZE, weight: fontWeight ?? WEIGHT_BOLD, color: color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

TextStyle styleCaption({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyle(fontType: PizzacornTextConfig.fonts.caption, size: size ?? TEXT_CAPTION_SIZE, weight: fontWeight ?? WEIGHT_NORMAL, color: color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

TextStyle styleSmall({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyle(fontType: PizzacornTextConfig.fonts.small, size: size ?? TEXT_SMALL_SIZE, weight: fontWeight ?? WEIGHT_NORMAL, color: color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

/// =================== WIDGETS ===================

Widget TextBig(String text, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false}) {
  return _buildText(text, styleBig(fontSize: fontSize, fontWeight: fontWeight, color: color, shadow: shadow, strikethrough: strikethrough), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase);
}

Widget TextTitle(String text, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false, double height = 1.2}) {
  return _buildText(text, styleTitle(size: fontSize, fontWeight: fontWeight, color: color, strikethrough: strikethrough, height: height), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase);
}

Widget TextSubtitle(String text, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false, double height = 1.2}) {
  return _buildText(text, styleSubtitle(size: fontSize, fontWeight: fontWeight, color: color, strikethrough: strikethrough, height: height), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase);
}

Widget TextBody(String texto, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int? maxlines, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false, double height = 1.2}) {
  return _buildText(texto, styleBody(size: fontSize, fontWeight: fontWeight, color: color, shadow: shadow, strikethrough: strikethrough, height: height), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase);
}

Widget TextButtonCustom(String texto, {double? fontSize, bool shadow = false, bool strikethrough = false, Color? color, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false}) {
  return Text(
    isUppercase ? texto.toUpperCase() : texto,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines,
    style: styleButton(size: fontSize, fontWeight: fontWeight, color: color ?? COLOR_TEXT_BUTTONS, strikethrough: strikethrough),
  );
}

Widget TextCaption(String texto, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false}) {
  return _buildText(texto, styleCaption(size: fontSize, fontWeight: fontWeight, color: color ?? COLOR_SUBTEXT, strikethrough: strikethrough), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase);
}

Widget TextSmall(String texto, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false}) {
  return _buildText(texto, styleSmall(size: fontSize, fontWeight: fontWeight, color: color, strikethrough: strikethrough), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase);
}

Widget TextCustom(String texto, {double? fontSize, bool shadow = false, bool strikethrough = false, Color? color, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, double espacioLetras = 0, double height = 1, bool isUppercase = false}) {
  return _buildText(
    texto,
    getStyle(fontType: PizzacornFontType.primary, size: fontSize ?? TEXT_BUTTON_SIZE, weight: fontWeight ?? WEIGHT_BOLD, color: color ?? COLOR_TEXT, letterspacing: espacioLetras, shadow: shadow, strikethrough: strikethrough, height: height),
    textAlign: textAlign,
    maxlines: maxlines,
    textOverflow: textOverflow,
    isUppercase: isUppercase,
  );
}
