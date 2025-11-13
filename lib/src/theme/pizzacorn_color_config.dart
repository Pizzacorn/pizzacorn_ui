import 'package:flutter/material.dart';

class PizzacornThemeConfig {
  // COLORES  /////////////////////////////////////////////////////////////////

  /// Background
  static Color background = const Color(0xFFF5F5F5);
  static Color backgroundSecondary = const Color(0xFFFFFFFF);
  static Color backgroundTerciary = const Color(0xFFE8E8E8);

  /// Accent
  static Color accent = const Color(0xFF00E89C);
  static Color accentPressed = const Color(0x9300E89C);
  static Color accentHover = const Color(0xF200E89C);

  static Color accentSecondary = const Color(0xFF1B1E2A);
  static Color accentSecondaryPressed = const Color(0x9D1B1E2A);
  static Color accentSecondaryHover = const Color(0xD31B1E2A);

  /// Text
  static Color text = const Color(0xFF1B1E2A);
  static Color subtext = const Color(0xFF777581);
  static Color textButtons = const Color(0xFFFFFFFF);

  /// Blocked
  static Color textBlocked = const Color(0x33001014);
  static Color accentBlocked = const Color(0x33001014);
  static Color backgroundBlocked = const Color(0x4DF1F1F1);

  /// Border
  static Color border = const Color(0xFFD8D8D8);
  static Color borderFocus = accent;
  static Color borderNoFocus = accent;

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
  static double marginSize = 10;
  static double paddingSize = 20;
  static double paddingSmallSize = 10;

  /// Textfields
  static double borderSize = 1;
  static double borderSizeFocus = 1;

}

/// Getters públicos con tus nombres de siempre ///////////////////////////////
/// Estos los usas en TODA la app / librería igual que antes, pero ahora
/// pueden cambiar en runtime llamando a [ConfigurePizzacornColors].

// COLORES
Color get COLOR_BACKGROUND => PizzacornThemeConfig.background;
Color get COLOR_BACKGROUND_SECONDARY => PizzacornThemeConfig.backgroundSecondary;
Color get COLOR_BACKGROUND_TERCIARY => PizzacornThemeConfig.backgroundTerciary;

Color get COLOR_ACCENT => PizzacornThemeConfig.accent;
Color get COLOR_ACCENT_PRESSED => PizzacornThemeConfig.accentPressed;
Color get COLOR_ACCENT_HOVER => PizzacornThemeConfig.accentHover;

Color get COLOR_ACCENT_SECONDARY => PizzacornThemeConfig.accentSecondary;
Color get COLOR_ACCENT_SECONDARY_PRESSED => PizzacornThemeConfig.accentSecondaryPressed;
Color get COLOR_ACCENT_SECONDARY_HOVER => PizzacornThemeConfig.accentSecondaryHover;

Color get COLOR_TEXT => PizzacornThemeConfig.text;
Color get COLOR_SUBTEXT => PizzacornThemeConfig.subtext;
Color get COLOR_TEXT_BUTTONS => PizzacornThemeConfig.textButtons;

Color get COLOR_TEXT_BLOCKED => PizzacornThemeConfig.textBlocked;
Color get COLOR_BACKGROUND_BLOCKED => PizzacornThemeConfig.backgroundBlocked;
Color get COLOR_ACCENT_BLOCKED => PizzacornThemeConfig.accentBlocked;

Color get COLOR_BORDER => PizzacornThemeConfig.border;
Color get COLOR_BORDER_FOCUS => PizzacornThemeConfig.borderFocus;
Color get COLOR_BORDER_NOFOCUS => PizzacornThemeConfig.borderNoFocus;

Color get COLOR_SHADOW => PizzacornThemeConfig.shadow;

Color get COLOR_ERROR => PizzacornThemeConfig.error;
Color get COLOR_ALERT => PizzacornThemeConfig.alert;
Color get COLOR_DONE => PizzacornThemeConfig.done;
Color get COLOR_INFO => PizzacornThemeConfig.info;

Color get COLOR_DIVIDER => PizzacornThemeConfig.divider;

// DOUBLES
double get RADIUS => PizzacornThemeConfig.radius;
double get BORDER_SIZE => PizzacornThemeConfig.borderSize;
double get BORDER_SIZE_FOCUS => PizzacornThemeConfig.borderSizeFocus;
double get MARGIN_SIZE => PizzacornThemeConfig.marginSize;
double get PADDING_SIZE => PizzacornThemeConfig.paddingSize;
double get PADDING_SMALL_SIZE => PizzacornThemeConfig.paddingSmallSize;

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
  Color? accentPressed,
  Color? accentHover,
  Color? accentSecondary,
  Color? accentSecondaryPressed,
  Color? accentSecondaryHover,

  // Blocked / text
  Color? text,
  Color? subtext,
  Color? textButtons,

  Color? textBlocked,
  Color? backgroundBlocked,
  Color? accentBlocked,

  // borders
  Color? border,
  Color? borderFocus,
  Color? borderNoFocus,

  // Misc
  Color? shadow,
  Color? error,
  Color? alert,
  Color? done,
  Color? info,
  Color? divider,

  // Doubles
  double? radius,
  double? borderSize,
  double? borderSizeFocus,
  double? marginSize,
  double? paddingSize,
  double? paddingSmallSize,

}) {
  // Background
  if (background != null) {
    PizzacornThemeConfig.background = background;
  }
  if (backgroundSecondary != null) {
    PizzacornThemeConfig.backgroundSecondary = backgroundSecondary;
  }
  if (backgroundTerciary != null) {
    PizzacornThemeConfig.backgroundTerciary = backgroundTerciary;
  }

  // Accent
  if (accent != null) {
    PizzacornThemeConfig.accent = accent;
  }
  if (accentPressed != null) {
    PizzacornThemeConfig.accentPressed = accentPressed;
  }
  if (accentHover != null) {
    PizzacornThemeConfig.accentHover = accentHover;
  }
  if (accentSecondary != null) {
    PizzacornThemeConfig.accentSecondary = accentSecondary;
  }
  if (accentSecondaryPressed != null) {
    PizzacornThemeConfig.accentSecondaryPressed = accentSecondaryPressed;
  }
  if (accentSecondaryHover != null) {
    PizzacornThemeConfig.accentSecondaryHover = accentSecondaryHover;
  }

  // Blocked / text
  if (text != null) {
    PizzacornThemeConfig.text = text;
  }
  if (subtext != null) {
    PizzacornThemeConfig.subtext = subtext;
  }
  if (textButtons != null) {
    PizzacornThemeConfig.textButtons = textButtons;
  }

  if (textBlocked != null) {
    PizzacornThemeConfig.textBlocked = textBlocked;
  }
  if (backgroundBlocked != null) {
    PizzacornThemeConfig.backgroundBlocked = backgroundBlocked;
  }
  if (accentBlocked != null) {
    PizzacornThemeConfig.accentBlocked = accentBlocked;
  }

  // Textfields / borders
  if (border != null) {
    PizzacornThemeConfig.border = border;
  }
  if (borderFocus != null) {
    PizzacornThemeConfig.borderFocus = borderFocus;
  }
  if (borderNoFocus != null) {
    PizzacornThemeConfig.borderNoFocus = borderNoFocus;
  }

  // Misc
  if (shadow != null) {
    PizzacornThemeConfig.shadow = shadow;
  }
  if (error != null) {
    PizzacornThemeConfig.error = error;
  }
  if (alert != null) {
    PizzacornThemeConfig.alert = alert;
  }
  if (done != null) {
    PizzacornThemeConfig.done = done;
  }
  if (info != null) {
    PizzacornThemeConfig.info = info;
  }
  if (divider != null) {
    PizzacornThemeConfig.divider = divider;
  }

  // Doubles
  if (radius != null) {
    PizzacornThemeConfig.radius = radius;
  }
  if (borderSize != null) {
    PizzacornThemeConfig.borderSize = borderSize;
  }
  if (borderSizeFocus != null) {
    PizzacornThemeConfig.borderSizeFocus = borderSizeFocus;
  }
  if (marginSize != null) {
    PizzacornThemeConfig.marginSize = marginSize;
  }
  if (paddingSize != null) {
    PizzacornThemeConfig.paddingSize = paddingSize;
  }
  if (paddingSmallSize != null) {
    PizzacornThemeConfig.paddingSmallSize = paddingSmallSize;
  }
}
