import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

PreferredSizeWidget AppBarClose({
  required BuildContext context,
  String title = "",
  Color? color,
  VoidCallback? onClose,
  double height = 60,
  bool showBottomBorder = true, // <-- Nuevo parámetro para decidir si aparece la barra
}) {
  // Si el texto es vacío, no se renderiza nada (tamaño cero)
  if (title.isEmpty) {
    return const PreferredSize(
      preferredSize: Size.zero,
      child: SizedBox.shrink(),
    );
  }

  final Color effectiveColor = color ?? COLOR_BACKGROUND_SECONDARY;

  return PreferredSize(
    preferredSize: Size.fromHeight(height),
    child: Container(
      // La barra de abajo solo aparece si showBottomBorder es true
      decoration: BoxDecoration(
        border: showBottomBorder
            ? Border(bottom: BorderSide(color: COLOR_BORDER, width: 1))
            : null,
      ),
      child: AppBar(
        toolbarHeight: height,
        backgroundColor: effectiveColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: TextSubtitle(title, fontWeight: FontWeight.normal),
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