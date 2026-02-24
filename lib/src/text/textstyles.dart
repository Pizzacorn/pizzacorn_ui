// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/text/textstyles.dart
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
  static String primaryFontFamily = 'Montserrat';
  static String secondaryFontFamily = 'Montserrat';

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


/// =================== WIDGETS ===================

// Helper para construir el texto con Semantics
Widget _buildSemanticsText(
    String text,
    TextStyle style, {
      TextAlign textAlign = TextAlign.start,
      int? maxlines, // Nullable para poder ser 'null' si es 0 o no se especifica
      TextOverflow textOverflow = TextOverflow.ellipsis,
      bool isUppercase = false,
      bool isHeader = false, // Para diferenciar si es header o no
    }) {
  // El widget de texto base
  final Widget textWidget = Text(
    isUppercase ? text.toUpperCase() : text,
    overflow: textOverflow,
    textAlign: textAlign,
    maxLines: maxlines == 0 ? null : maxlines, // Permitir null para scroll infinito
    style: style,
  );

  // El Semantics se mantiene para la accesibilidad de navegación (header, button, etc.)
  // Se envuelve el widget de texto directamente con Semantics, ya no con SelectableRegion
  return Semantics(
    label: text,
    header: isHeader, // Aplicar header solo si se indica
    child: textWidget,
  );
}


/// =================== BASES DE ESTILO ===================
TextStyle getStyleCustom(
    double size,
    FontWeight weight,
    Color color, {
      double letterspacing = 0,
      bool shadow = false,
      bool underlined = false,
      bool strikethrough = false, // 🚀 Nueva opción
      double height = 1.2,
    }) {

  // Combinamos decoraciones si es necesario
  List<TextDecoration> decorations = [];
  if (underlined) decorations.add(TextDecoration.underline);
  if (strikethrough) decorations.add(TextDecoration.lineThrough);

  try {
    return GoogleFonts.getFont(
      PizzacornTextConfig.primaryFontFamily,
      fontSize: size,
      letterSpacing: letterspacing,
      fontWeight: weight,
      height: height,
      color: color,
      decoration: TextDecoration.combine(decorations),
      shadows: shadow ? [Shadow(blurRadius: 70, color: COLOR_SUBTEXT)] : null,
    );
  } catch (_) {
    return GoogleFonts.leagueGothic(
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

TextStyle getStyleSecondaryCustom(
    double size,
    FontWeight weight,
    Color color, {
      double letterspacing = 0,
      bool shadow = false,
      bool underlined = false,
      bool strikethrough = false, // 🚀 Nueva opción
      double height = 1.2,
    }) {

  List<TextDecoration> decorations = [];
  if (underlined) decorations.add(TextDecoration.underline);
  if (strikethrough) decorations.add(TextDecoration.lineThrough);

  try {
    return GoogleFonts.getFont(
      PizzacornTextConfig.secondaryFontFamily,
      fontSize: size,
      letterSpacing: letterspacing,
      fontWeight: weight,
      height: height,
      color: color,
      decoration: TextDecoration.combine(decorations),
      shadows: shadow ? [Shadow(blurRadius: 70, color: COLOR_SUBTEXT)] : null,
    );
  } catch (_) {
    return GoogleFonts.raleway(
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

/// =================== ESTILOS (Actualizados con strikethrough) ===================

TextStyle styleBig({Color? color, FontWeight? fontWeight, double? fontSize, double letterspacing = 0, bool shadow = false, bool strikethrough = false, double height = 1.2}) {
  return getStyleCustom(fontSize ?? TEXT_BIG_SIZE, fontWeight ?? WEIGHT_BOLD, color ?? COLOR_TEXT, letterspacing: letterspacing, shadow: shadow, strikethrough: strikethrough, height: height);
}

TextStyle styleTitle({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyleCustom(size ?? TEXT_TITLE_SIZE, fontWeight ?? WEIGHT_BOLD, color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

TextStyle styleSubtitle({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyleCustom(size ?? TEXT_SUBTITLE_SIZE, fontWeight ?? WEIGHT_BOLD, color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

TextStyle styleBody({Color? color, FontWeight? fontWeight, double? size, bool shadow = false, bool strikethrough = false, double height = 1.2}) {
  return getStyleSecondaryCustom(size ?? TEXT_BODY_SIZE, fontWeight ?? WEIGHT_NORMAL, color ?? COLOR_TEXT, shadow: shadow, strikethrough: strikethrough, height: height);
}

TextStyle styleButton({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyleSecondaryCustom(size ?? TEXT_BUTTON_SIZE, fontWeight ?? WEIGHT_BOLD, color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

TextStyle styleCaption({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyleSecondaryCustom(size ?? TEXT_CAPTION_SIZE, fontWeight ?? WEIGHT_NORMAL, color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

TextStyle styleSmall({Color? color, FontWeight? fontWeight, double? size, bool strikethrough = false, double height = 1.2}) {
  return getStyleSecondaryCustom(size ?? TEXT_SMALL_SIZE, fontWeight ?? WEIGHT_NORMAL, color ?? COLOR_TEXT, strikethrough: strikethrough, height: height);
}

/// =================== WIDGETS (Actualizados con strikethrough) ===================

Widget TextBig(String text, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false}) {
  return _buildSemanticsText(text, styleBig(fontSize: fontSize, fontWeight: fontWeight, color: color, shadow: shadow, strikethrough: strikethrough), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase, isHeader: true);
}

Widget TextTitle(String text, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false, double height = 1.2}) {
  return _buildSemanticsText(text, styleTitle(size: fontSize, fontWeight: fontWeight, color: color, strikethrough: strikethrough, height: height), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase, isHeader: true);
}

Widget TextSubtitle(String text, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false, double height = 1.2}) {
  return _buildSemanticsText(text, styleSubtitle(size: fontSize, fontWeight: fontWeight, color: color, strikethrough: strikethrough, height: height), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase, isHeader: true);
}

Widget TextBody(String texto, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int? maxlines, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false, double height = 1.2}) {
  return _buildSemanticsText(texto, styleBody(size: fontSize, fontWeight: fontWeight, color: color, shadow: shadow, strikethrough: strikethrough, height: height), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase, isHeader: false);
}

Widget TextButtonCustom(String texto, {double? fontSize, bool shadow = false, bool strikethrough = false, Color? color, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false}) {
  return Semantics(
    label: texto,
    button: true,
    child: Text(
      isUppercase ? texto.toUpperCase() : texto,
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxlines,
      style: styleButton(size: fontSize, fontWeight: fontWeight, color: color ?? COLOR_TEXT_BUTTONS, strikethrough: strikethrough),
    ),
  );
}

Widget TextCaption(String texto, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false}) {
  return _buildSemanticsText(texto, styleCaption(size: fontSize, fontWeight: fontWeight, color: color ?? COLOR_SUBTEXT, strikethrough: strikethrough), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase, isHeader: false);
}

Widget TextSmall(String texto, {double? fontSize, Color? color, bool shadow = false, bool strikethrough = false, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, bool isUppercase = false}) {
  return _buildSemanticsText(texto, styleSmall(size: fontSize, fontWeight: fontWeight, color: color, strikethrough: strikethrough), textAlign: textAlign, maxlines: maxlines, textOverflow: textOverflow, isUppercase: isUppercase, isHeader: false);
}

Widget TextCustom(String texto, {double? fontSize, bool shadow = false, bool strikethrough = false, Color? color, FontWeight? fontWeight, TextAlign textAlign = TextAlign.start, int maxlines = MAXLINES, TextOverflow textOverflow = TextOverflow.ellipsis, double espacioLetras = 0, double height = 1, bool isUppercase = false}) {
  return _buildSemanticsText(
    texto,
    getStyleCustom(fontSize ?? TEXT_BUTTON_SIZE, fontWeight ?? WEIGHT_BOLD, color ?? COLOR_TEXT, letterspacing: espacioLetras, shadow: shadow, strikethrough: strikethrough, height: height),
    textAlign: textAlign,
    maxlines: maxlines,
    textOverflow: textOverflow,
    isUppercase: isUppercase,
    isHeader: false,
  );
}