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

/// AppBar con botón de cerrar (X) y borde inferior.
///
/// Uso:
/// ```dart
/// appBar: AppBarClose(
///   context: context,
///   title: 'Editar',
/// )
/// ```
PreferredSizeWidget AppBarClose({
  required BuildContext context,
  String title = "",
  Color? color,
  VoidCallback? onClose,
}) {
  final Color effectiveColor = color ?? COLOR_BACKGROUND_SECONDARY;

  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: COLOR_BORDER,
            width: 1,
          ),
        ),
      ),
      child: AppBar(
        toolbarHeight: 60,
        backgroundColor: effectiveColor,
        elevation: 0,
        title: TextSubtitle(
          title,
          fontWeight: FontWeight.normal,
        ),
        leading: IconButton(
          splashColor: COLOR_ACCENT.withValues(alpha: 0.2),
          highlightColor: COLOR_ACCENT.withValues(alpha: 0.2),
          onPressed: onClose ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.close),
          color: COLOR_TEXT,
          iconSize: 20,
        ),
      ),
    ),
  );
}
