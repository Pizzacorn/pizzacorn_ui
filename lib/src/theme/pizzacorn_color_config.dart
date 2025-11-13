import 'package:flutter/material.dart';

/// Config central de colores y tokens de diseño Pizzacorn.
///
/// La idea es:
/// - Tener valores por defecto (los tuyos).
/// - Poder sobreescribirlos al inicio de cada app con [ConfigurePizzacornColors].

class PizzacornColorConfig {
  // COLORES  /////////////////////////////////////////////////////////////////

  /// Background
  static Color background = const Color(0xFFF5F5F5);
  static Color backgroundSecondary = const Color(0xFFFFFFFF);
  static Color backgroundTerciary = const Color(0xFFE8E8E8);

  /// Accent
  static Color accent = const Color(0xFF00E89C);
  static Color accent2 = const Color(0xFF00BC7F);
  static Color accentOpacity = const Color(0x3C00E89C);
  static Color accentPressed = const Color(0x9300E89C);
  static Color accentHover = const Color(0xF200E89C);
  static Color accentObscure = const Color(0xFF009364);

  static Color alerts = const Color(0xFFDF8146);

  static Color accentSecondary = const Color(0xFF1B1E2A);
  static Color accentSecondaryPressed = const Color(0x9D1B1E2A);
  static Color accentSecondaryHover = const Color(0xD31B1E2A);

  /// Blocked
  static Color textDisable = const Color(0x33001014);
  static Color backgroundDisable = const Color(0x4DF1F1F1);
  static Color subtextPast = const Color(0xFFADACB6);

  /// Text
  static Color text = const Color(0xFF1B1E2A);
  static Color subtext = const Color(0xFF777581);
  static Color textButtons = const Color(0xFFFFFFFF);

  /// Blocked
  static Color textBlocked = const Color(0x33001014);
  static Color backgroundBlocked = const Color(0x4DF1F1F1);

  /// Textfields
  static Color textfields = backgroundSecondary;

  /// Border
  static Color border = const Color(0xFFD8D8D8);
  static Color borderFocus = accent;
  static Color borderNoFocus = accent;

  /// Filter
  static Color filter = accent;

  /// Shadow
  static Color shadow = accent;

  /// Alerts
  static Color error = const Color.fromRGBO(243, 26, 26, 1.0);
  static Color alert = const Color.fromRGBO(253, 221, 59, 1.0);
  static Color done = const Color.fromRGBO(3, 218, 198, 1);
  static Color info = Colors.blue;

  /// Utils
  static Color divider = border;

  // DOUBLES /////////////////////////////////////////////////////////////////

  /// Valores dimensionales
  static double radius = 0;

  /// Textfields
  static double sizeBorder = 1;
  static double sizeBorderFocus = 1;

  /// Margin
  static double marginDouble = 8;
}

/// Getters públicos con tus nombres de siempre ///////////////////////////////
/// Estos los usas en TODA la app / librería igual que antes, pero ahora
/// pueden cambiar en runtime llamando a [ConfigurePizzacornColors].

// COLORES
Color get COLOR_BACKGROUND => PizzacornColorConfig.background;
Color get COLOR_BACKGROUND_SECONDARY => PizzacornColorConfig.backgroundSecondary;
Color get COLOR_BACKGROUND_TERCIARY => PizzacornColorConfig.backgroundTerciary;

Color get COLOR_ACCENT => PizzacornColorConfig.accent;
Color get COLOR_ACCENT_OPACITY => PizzacornColorConfig.accentOpacity;
Color get COLOR_ACCENT_PRESSED => PizzacornColorConfig.accentPressed;
Color get COLOR_ACCENT_HOVER => PizzacornColorConfig.accentHover;
Color get COLOR_ACCENT_OBSCURE => PizzacornColorConfig.accentObscure;

Color get COLOR_ALERTS => PizzacornColorConfig.alerts;

Color get COLOR_ACCENT_SECONDARY => PizzacornColorConfig.accentSecondary;
Color get COLOR_ACCENT_SECONDARY_PRESSED => PizzacornColorConfig.accentSecondaryPressed;
Color get COLOR_ACCENT_SECONDARY_HOVER => PizzacornColorConfig.accentSecondaryHover;

Color get COLOR_TEXT_DISABLE => PizzacornColorConfig.textDisable;
Color get COLOR_BACKGROUND_DISABLE => PizzacornColorConfig.backgroundDisable;
Color get COLOR_SUBTEXT_PAST => PizzacornColorConfig.subtextPast;

Color get COLOR_TEXT => PizzacornColorConfig.text;
Color get COLOR_SUBTEXT => PizzacornColorConfig.subtext;
Color get COLOR_TEXT_BUTTONS => PizzacornColorConfig.textButtons;

Color get COLOR_TEXT_BLOCKED => PizzacornColorConfig.textBlocked;
Color get COLOR_BACKGROUND_BLOCKED => PizzacornColorConfig.backgroundBlocked;

Color get COLOR_TEXTFIELDS => PizzacornColorConfig.textfields;

Color get COLOR_BORDER => PizzacornColorConfig.border;
Color get COLOR_BORDER_FOCUS => PizzacornColorConfig.borderFocus;
Color get COLOR_BORDER_NOFOCUS => PizzacornColorConfig.borderNoFocus;

Color get COLOR_FILTER => PizzacornColorConfig.filter;

Color get COLOR_SHADOW => PizzacornColorConfig.shadow;

Color get COLOR_ERROR => PizzacornColorConfig.error;
Color get COLOR_ALERT => PizzacornColorConfig.alert;
Color get COLOR_DONE => PizzacornColorConfig.done;
Color get COLOR_INFO => PizzacornColorConfig.info;

Color get COLOR_DIVIDER => PizzacornColorConfig.divider;

// DOUBLES
double get RADIUS => PizzacornColorConfig.radius;
double get SIZE_BORDE => PizzacornColorConfig.sizeBorder;
double get SIZE_BORDER_FOCUS => PizzacornColorConfig.sizeBorderFocus;
double get MARGIN_DOUBLE => PizzacornColorConfig.marginDouble;

/// Función para configurar los colores/tokens al inicio de la app.
///
/// La llamas en main() ANTES de runApp().
///
/// Puedes pasar solo lo que quieras cambiar; el resto se queda con el default.
void ConfigurePizzacornColors({
  // Background
  Color? background,
  Color? backgroundSecondary,
  Color? backgroundTerciary,

  // Accent
  Color? accent,
  Color? accent2,
  Color? accentOpacity,
  Color? accentPressed,
  Color? accentHover,
  Color? accentObscure,
  Color? alerts,
  Color? accentSecondary,
  Color? accentSecondaryPressed,
  Color? accentSecondaryHover,

  // Blocked / text
  Color? textDisable,
  Color? backgroundDisable,
  Color? subtextPast,

  Color? text,
  Color? subtext,
  Color? textButtons,

  Color? textBlocked,
  Color? backgroundBlocked,

  // Textfields / borders
  Color? textfields,
  Color? border,
  Color? borderFocus,
  Color? borderNoFocus,

  // Misc
  Color? filter,
  Color? shadow,
  Color? error,
  Color? alert,
  Color? done,
  Color? info,
  Color? divider,

  // Doubles
  double? radius,
  double? sizeBorder,
  double? sizeBorderFocus,
  double? marginDouble,
}) {
  // Background
  if (background != null) {
    PizzacornColorConfig.background = background;
  }
  if (backgroundSecondary != null) {
    PizzacornColorConfig.backgroundSecondary = backgroundSecondary;
  }
  if (backgroundTerciary != null) {
    PizzacornColorConfig.backgroundTerciary = backgroundTerciary;
  }

  // Accent
  if (accent != null) {
    PizzacornColorConfig.accent = accent;
  }
  if (accent2 != null) {
    PizzacornColorConfig.accent2 = accent2;
  }
  if (accentOpacity != null) {
    PizzacornColorConfig.accentOpacity = accentOpacity;
  }
  if (accentPressed != null) {
    PizzacornColorConfig.accentPressed = accentPressed;
  }
  if (accentHover != null) {
    PizzacornColorConfig.accentHover = accentHover;
  }
  if (accentObscure != null) {
    PizzacornColorConfig.accentObscure = accentObscure;
  }
  if (alerts != null) {
    PizzacornColorConfig.alerts = alerts;
  }
  if (accentSecondary != null) {
    PizzacornColorConfig.accentSecondary = accentSecondary;
  }
  if (accentSecondaryPressed != null) {
    PizzacornColorConfig.accentSecondaryPressed = accentSecondaryPressed;
  }
  if (accentSecondaryHover != null) {
    PizzacornColorConfig.accentSecondaryHover = accentSecondaryHover;
  }

  // Blocked / text
  if (textDisable != null) {
    PizzacornColorConfig.textDisable = textDisable;
  }
  if (backgroundDisable != null) {
    PizzacornColorConfig.backgroundDisable = backgroundDisable;
  }
  if (subtextPast != null) {
    PizzacornColorConfig.subtextPast = subtextPast;
  }

  if (text != null) {
    PizzacornColorConfig.text = text;
  }
  if (subtext != null) {
    PizzacornColorConfig.subtext = subtext;
  }
  if (textButtons != null) {
    PizzacornColorConfig.textButtons = textButtons;
  }

  if (textBlocked != null) {
    PizzacornColorConfig.textBlocked = textBlocked;
  }
  if (backgroundBlocked != null) {
    PizzacornColorConfig.backgroundBlocked = backgroundBlocked;
  }

  // Textfields / borders
  if (textfields != null) {
    PizzacornColorConfig.textfields = textfields;
  }
  if (border != null) {
    PizzacornColorConfig.border = border;
  }
  if (borderFocus != null) {
    PizzacornColorConfig.borderFocus = borderFocus;
  }
  if (borderNoFocus != null) {
    PizzacornColorConfig.borderNoFocus = borderNoFocus;
  }

  // Misc
  if (filter != null) {
    PizzacornColorConfig.filter = filter;
  }
  if (shadow != null) {
    PizzacornColorConfig.shadow = shadow;
  }
  if (error != null) {
    PizzacornColorConfig.error = error;
  }
  if (alert != null) {
    PizzacornColorConfig.alert = alert;
  }
  if (done != null) {
    PizzacornColorConfig.done = done;
  }
  if (info != null) {
    PizzacornColorConfig.info = info;
  }
  if (divider != null) {
    PizzacornColorConfig.divider = divider;
  }

  // Doubles
  if (radius != null) {
    PizzacornColorConfig.radius = radius;
  }
  if (sizeBorder != null) {
    PizzacornColorConfig.sizeBorder = sizeBorder;
  }
  if (sizeBorderFocus != null) {
    PizzacornColorConfig.sizeBorderFocus = sizeBorderFocus;
  }
  if (marginDouble != null) {
    PizzacornColorConfig.marginDouble = marginDouble;
  }
}
