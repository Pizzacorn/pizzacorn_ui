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
  VoidCallback? onBack,
}) {
  final Color effectiveColor = color ?? COLOR_BACKGROUND_SECONDARY;

  return AppBar(
    toolbarHeight: 65,
    backgroundColor: effectiveColor,
    elevation: 0,
    title: TextSubtitle(title),
    leading: IconButton(
      splashColor: COLOR_ACCENT.withValues(alpha: 0.2),
      highlightColor: COLOR_ACCENT.withValues(alpha: 0.2),
      onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.arrow_back_ios),
      color: COLOR_TEXT,
      iconSize: 20,
    ),
  );
}
