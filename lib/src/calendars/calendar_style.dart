import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

enum CalendarSelectionMode { single, range }

class HighlightedCircleBorderStyle {
  final Color color;
  final double width;

  HighlightedCircleBorderStyle({
    this.color = Colors.white,
    this.width = 1.0,
  });
}

class HighlightedCircleStyle {
  final double size;
  final double textSize;
  final Color background;
  final Color textColor;
  final HighlightedCircleBorderStyle border;

  HighlightedCircleStyle({
    this.size = 20.0,
    this.textSize = 10.0,
    this.background = Colors.blue,
    this.textColor = Colors.white,
    // REGLA: Eliminamos el const del parámetro por defecto para evitar el error
    HighlightedCircleBorderStyle? border,
  }) : border = border ?? HighlightedCircleBorderStyle();
}

class CalendarStyle {
  final Color backgroundSelected;
  final Color backgroundRange;
  final Color backgroundUnselected;
  final Color backgroundBlocked;
  final Color backgroundHighlighted;
  final Color backgroundPast;

  final Color textSelected;
  final Color textRange;
  final Color textUnselected;
  final Color textBlocked;
  final Color textHighlighted;
  final Color textPast;

  final Color borderSelected;
  final Color borderRange;
  final Color borderUnselected;
  final Color borderHighlighted;
  final Color borderPast;

  final double borderWidthSelected;
  final double borderWidthRange;
  final double borderWidthUnselected;
  final double borderWidthHighlighted;

  final bool showPastHighlighted;
  final Color pastHighlightedBackground;
  final double pastHighlightedBorderWidth;
  final Color pastHighlightedBorderColor;
  final Color pastHighlightedTextColor;

  final bool showHighlightedCircle;
  final HighlightedCircleStyle highlightedCircle;

  CalendarStyle({
    Color? backgroundSelected,
    Color? backgroundRange,
    Color? backgroundUnselected,
    Color? backgroundBlocked,
    Color? backgroundHighlighted,
    Color? backgroundPast,

    Color? textSelected,
    Color? textRange,
    Color? textUnselected,
    Color? textBlocked,
    Color? textHighlighted,
    Color? textPast,

    Color? borderSelected,
    Color? borderRange,
    Color? borderUnselected,
    Color? borderHighlighted,
    Color? borderPast,

    this.borderWidthSelected = 2.0,
    this.borderWidthRange = 2.0,
    this.borderWidthUnselected = 1.0,
    this.borderWidthHighlighted = 2.0,

    this.showPastHighlighted = false,
    this.pastHighlightedBackground = const Color(0xFFE0E0E0),
    this.pastHighlightedBorderWidth = 1.5,
    this.pastHighlightedBorderColor = const Color(0xFFBDBDBD),
    this.pastHighlightedTextColor = const Color(0xFF757575),

    this.showHighlightedCircle = true,
    HighlightedCircleStyle? highlightedCircle,
  })  : backgroundSelected = backgroundSelected ?? COLOR_ACCENT,
        backgroundRange = backgroundRange ?? COLOR_ACCENT.withOpacity(0.2),
        backgroundUnselected = backgroundUnselected ?? COLOR_BACKGROUND,
        backgroundBlocked = backgroundBlocked ?? COLOR_BACKGROUND_TERCIARY,
        backgroundHighlighted = backgroundHighlighted ?? COLOR_BACKGROUND,
        backgroundPast = backgroundPast ?? COLOR_BACKGROUND,
        textSelected = textSelected ?? COLOR_BACKGROUND,
        textRange = textRange ?? COLOR_TEXT,
        textUnselected = textUnselected ?? COLOR_TEXT,
        textBlocked = textBlocked ?? COLOR_SUBTEXT,
        textHighlighted = textHighlighted ?? COLOR_ACCENT,
        textPast = textPast ?? COLOR_SUBTEXT,
        borderSelected = borderSelected ?? COLOR_ACCENT,
        borderRange = borderRange ?? Colors.transparent,
        borderUnselected = borderUnselected ?? COLOR_BACKGROUND,
        borderHighlighted = borderHighlighted ?? COLOR_BACKGROUND,
        borderPast = borderPast ?? COLOR_BACKGROUND,
        highlightedCircle = highlightedCircle ?? HighlightedCircleStyle(
          background: COLOR_ACCENT,
          textColor: COLOR_BACKGROUND,
        );
}