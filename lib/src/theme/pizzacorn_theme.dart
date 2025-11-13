// lib/src/theme/pizzacorn_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'pizzacorn_color_config.dart';
import '../layout/space.dart';
import '../text/textstyles.dart';



/// THEME ///////////////////////////////////////////////////////////////////////
ThemeData PizzacornTheme() {
  return ThemeData(
    platform: TargetPlatform.iOS,

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: COLOR_ACCENT,
      onPrimary: COLOR_TEXT_BUTTONS,
      surface: COLOR_BACKGROUND_SECONDARY,
      onSurface: COLOR_TEXT,
      secondary: COLOR_ACCENT_SECONDARY,
      onSecondary: COLOR_TEXT_BUTTONS,
      error: COLOR_ERROR,
      onError: COLOR_TEXT_BUTTONS,
    ),

    /// BACKGROUNDS
    brightness: Brightness.light,
    scaffoldBackgroundColor: COLOR_BACKGROUND,

    /// CARDS
    cardTheme: CardThemeData(
      color: COLOR_BACKGROUND_SECONDARY,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RADIUS),
      ),
    ),

    /// TEXTFIELDS
    inputDecorationTheme: InputDecorationTheme(
      /// Estilo Inicio
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
        borderSide: BorderSide(color: COLOR_BORDER, width: SIZE_BORDE),
      ),

      /// Estilo Focus
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
        borderSide: BorderSide(color: COLOR_BORDER_FOCUS, width: SIZE_BORDER_FOCUS),
      ),

      /// Estilo error
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
        borderSide: BorderSide(color: COLOR_ERROR, width: SIZE_BORDER_FOCUS),
      ),

      /// Estilo foco en error
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
        borderSide: BorderSide(color: COLOR_ERROR, width: SIZE_BORDER_FOCUS),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
        borderSide: BorderSide(color: COLOR_BORDER_NOFOCUS, width: SIZE_BORDER_FOCUS),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
        borderSide: BorderSide(color: COLOR_BORDER, width: SIZE_BORDER_FOCUS),
      ),

      /// Estilo textos
      labelStyle: styleCaption(),
      hintStyle: styleCaption(),
      helperStyle: styleCaption(),
      floatingLabelStyle: styleCaption(),

      /// Relleno
      filled: true,
      fillColor: COLOR_BACKGROUND_TERCIARY,
      contentPadding: const EdgeInsets.all(20),

      /// Color de iconos
      prefixIconColor: COLOR_TEXT,
      suffixIconColor: COLOR_TEXT,
    ),

    /// BUTTONS
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        /// Estilo borde
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(color: COLOR_ACCENT_PRESSED, width: 0);
          }
          return BorderSide(color: COLOR_ACCENT, width: 0);
        }),

        /// Forma
        shape: WidgetStateProperty.resolveWith((states) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          );
        }),

        /// Fondo
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return COLOR_ACCENT_PRESSED;
          } else if (states.contains(WidgetState.hovered)) {
            return COLOR_ACCENT_HOVER;
          }
          return COLOR_ACCENT;
        }),
      ),
    ),

    /// APPBAR
    appBarTheme: AppBarTheme(
      backgroundColor: COLOR_BACKGROUND,
      surfaceTintColor: COLOR_BACKGROUND,
      iconTheme: IconThemeData(color: COLOR_TEXT),
    ),

    /// DIVIDER
    dividerTheme: DividerThemeData(
      color: COLOR_DIVIDER,
      space: SPACE_BIG,
      indent: 1,
      endIndent: 1,
      thickness: 1,
    ),

    /// ICONS
    iconTheme: IconThemeData(color: COLOR_TEXT),

    /// CHECKBOX
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return COLOR_ACCENT;
        } else {
          return COLOR_BACKGROUND;
        }
      }),
      checkColor: WidgetStateProperty.resolveWith((states) {
        return COLOR_BACKGROUND;
      }),
      side: BorderSide(color: COLOR_SUBTEXT),
    ),

    /// DRAWER
    drawerTheme: DrawerThemeData(
      width: 200,
      backgroundColor: COLOR_BACKGROUND,
      elevation: 10,
    ),

    /// SWITCH
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return COLOR_ACCENT_PRESSED;
        } else if (states.contains(WidgetState.hovered)) {
          return COLOR_ACCENT_HOVER;
        }
        return COLOR_ACCENT;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return COLOR_ACCENT_PRESSED;
        } else if (states.contains(WidgetState.hovered)) {
          return COLOR_SUBTEXT;
        } else if (states.contains(WidgetState.focused)) {
          return COLOR_SUBTEXT;
        } else if (states.contains(WidgetState.disabled)) {
          return COLOR_SUBTEXT;
        } else {
          return COLOR_SUBTEXT;
        }
      }),
    ),

    /// CURSOR / SELECCIÓN
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: COLOR_ACCENT,
      selectionHandleColor: COLOR_ACCENT,
      selectionColor: COLOR_ACCENT.withValues(alpha: 0.3),
    ),

    /// SNACKBAR
    snackBarTheme: SnackBarThemeData(
      backgroundColor: COLOR_BACKGROUND,
      behavior: SnackBarBehavior.floating,
      contentTextStyle: styleCaption(),
      elevation: 5,
    ),

    /// DROPDOWN
    canvasColor: COLOR_BACKGROUND_SECONDARY,
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: styleBody(),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
          borderSide: BorderSide(color: COLOR_SUBTEXT, width: SIZE_BORDE),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
          borderSide:
          BorderSide(color: COLOR_ACCENT, width: SIZE_BORDER_FOCUS),
        ),
        filled: true,
        prefixIconColor: COLOR_SUBTEXT,
        hintStyle: styleBody(color: COLOR_SUBTEXT),
      ),
    ),

    bottomAppBarTheme: BottomAppBarThemeData(
      color: COLOR_BACKGROUND,
      elevation: 10,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: COLOR_BACKGROUND,
      elevation: 10,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: COLOR_BACKGROUND,
      elevation: 10,
      dragHandleColor: COLOR_TEXT,
      surfaceTintColor: COLOR_BACKGROUND,
      modalBackgroundColor: COLOR_BACKGROUND,
      modalBarrierColor: COLOR_BACKGROUND,
      shadowColor: COLOR_ACCENT,
    ),

    chipTheme: const ChipThemeData(),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: COLOR_BACKGROUND,
      sizeConstraints: BoxConstraints(minHeight: 70, minWidth: 70),
    ),

    cupertinoOverrideTheme: const CupertinoThemeData(),
    dataTableTheme: const DataTableThemeData(),
    dialogTheme: const DialogThemeData(),
    expansionTileTheme: const ExpansionTileThemeData(
      shape: Border(),
    ),
    listTileTheme: const ListTileThemeData(),
    navigationBarTheme: const NavigationBarThemeData(),
    outlinedButtonTheme: const OutlinedButtonThemeData(),
    pageTransitionsTheme: const PageTransitionsTheme(),
    popupMenuTheme: const PopupMenuThemeData(),
    progressIndicatorTheme: const ProgressIndicatorThemeData(),
    radioTheme: const RadioThemeData(),
    scrollbarTheme: const ScrollbarThemeData(),
    sliderTheme: const SliderThemeData(),
    tabBarTheme: const TabBarThemeData(),
    timePickerTheme: const TimePickerThemeData(),
    toggleButtonsTheme: const ToggleButtonsThemeData(),
    tooltipTheme: const TooltipThemeData(),
    typography: Typography(),
    visualDensity: const VisualDensity(),
  );
}

/// Extension útil que ya usabas.
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
