import 'package:flutter/gestures.dart';
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
    // Fallback por si la fuente no está disponible
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
    // Fallback por si la fuente no está disponible
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

// Helper para construir el texto con Semantics y SelectableRegion
Widget _buildSelectableSemanticsText(
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
    maxLines: maxlines == 0
        ? null
        : maxlines, // Permitir null para scroll infinito
    style: style,
  );

  // El SelectableRegion permite la selección de texto
  final Widget selectableText = SelectableRegion(
    selectionControls: MaterialTextSelectionControls(),
    child: textWidget,
  );

  // El Semantics se mantiene para la accesibilidad de navegación (header, button, etc.)
  // Se envuelve el SelectableRegion con Semantics
  return Semantics(
    label: text,
    header: isHeader, // Aplicar header solo si se indica
    child: selectableText,
  );
}

// --- Widgets de Texto ---

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

  return _buildSelectableSemanticsText(
    text,
    styleBig(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
      shadow: shadow,
    ),
    textAlign: textAlign,
    maxlines: maxlines,
    textOverflow: textOverflow,
    isUppercase: isUppercase,
    isHeader: true, // TextBig es un header
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

  return _buildSelectableSemanticsText(
    text,
    styleTitle(
      size: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
      height: height,
    ),
    textAlign: textAlign,
    maxlines: maxlines,
    textOverflow: textOverflow,
    isUppercase: isUppercase,
    isHeader: true, // TextTitle es un header
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

  return _buildSelectableSemanticsText(
    text,
    styleSubtitle(
      size: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
      height: height,
    ),
    textAlign: textAlign,
    maxlines: maxlines,
    textOverflow: textOverflow,
    isUppercase: isUppercase,
    isHeader: true, // TextSubtitle es un header
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

  return _buildSelectableSemanticsText(
    texto,
    styleBody(
      size: fontSize,
      fontWeight: fontWeight,
      color: effectiveColor,
      shadow: shadow,
      height: height,
    ),
    textAlign: textAlign,
    maxlines: maxlines,
    textOverflow: textOverflow,
    isUppercase: isUppercase,
    isHeader: false, // TextBody no es un header por defecto
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

  // Los botones no suelen ser seleccionables, solo "tappables".
  // Mantenemos el Semantics para que se identifique como botón.
  return Semantics(
    label: texto,
    button: true,
    child: Text(
      isUppercase ? texto.toUpperCase() : texto,
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxlines,
      style: styleButton(
        size: fontSize,
        fontWeight: fontWeight,
        color: effectiveColor,
      ),
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

  // Ahora TextCaption también es seleccionable.
  return _buildSelectableSemanticsText(
    texto,
    styleCaption(size: fontSize, fontWeight: fontWeight, color: effectiveColor),
    textAlign: textAlign,
    maxlines: maxlines,
    textOverflow: textOverflow,
    isUppercase: isUppercase,
    isHeader: false, // TextCaption no es un header por defecto
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

  // Ahora TextSmall también es seleccionable.
  return _buildSelectableSemanticsText(
    texto,
    styleSmall(size: fontSize, fontWeight: fontWeight, color: effectiveColor),
    textAlign: textAlign,
    maxlines: maxlines,
    textOverflow: textOverflow,
    isUppercase: isUppercase,
    isHeader: false, // TextSmall no es un header por defecto
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

  // Ahora TextCustom también es seleccionable.
  return _buildSelectableSemanticsText(
    texto,
    getStyleCustom(
      fontSize ??
          TEXT_BUTTON_SIZE, // Usa TEXT_BUTTON_SIZE como fallback si no se da fontSize
      fontWeight ??
          WEIGHT_BOLD, // Usa WEIGHT_BOLD como fallback si no se da fontWeight
      effectiveColor,
      letterspacing: espacioLetras,
      shadow: shadow,
      height: height,
    ),
    textAlign: textAlign,
    maxlines: maxlines,
    textOverflow: textOverflow,
    isUppercase: isUppercase,
    isHeader: false, // TextCustom no es un header por defecto
  );
}
