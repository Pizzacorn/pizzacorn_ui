import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';
import '../text/textstyles.dart';

/// AppBar con botón de back estándar Pizzacorn.
///
/// Uso:
/// ```dart
/// appBar: AppBarBack(
///   context: context,
///   title: 'Detalle',
/// )
/// ```
PreferredSizeWidget AppBarBack({
  required BuildContext context,
  String title = "",
  Color? color,
  Color? textColor,
  Color? iconColor,
  VoidCallback? onBack,
}) {
  final Color effectiveColor = color ?? COLOR_BACKGROUND_SECONDARY;
  final Color effectiveTextColor = textColor ?? COLOR_TEXT;
  final Color effectiveIconColor = iconColor ?? COLOR_TEXT;

  return AppBar(
    toolbarHeight: 65,
    backgroundColor: effectiveColor,
    elevation: 0,
    title: TextSubtitle(title, color: effectiveTextColor),
    leading: IconButton(
      splashColor: COLOR_ACCENT.withValues(alpha: 0.2),
      highlightColor: COLOR_ACCENT.withValues(alpha: 0.2),
      onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.arrow_back_ios),
      color: effectiveIconColor,
      iconSize: 20,
    ),
  );
}