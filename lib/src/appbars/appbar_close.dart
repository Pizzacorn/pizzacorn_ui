import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

PreferredSizeWidget AppBarClose({
  required BuildContext context,
  String title = "",  Color? color,
  Color? textColor,
  Color? iconColor,
  VoidCallback? onClose,
  double height = 60,
  bool showBottomBorder = true,
}) {
  final Color effectiveColor = color ?? COLOR_BACKGROUND_SECONDARY;
  final Color effectiveTextColor = textColor ?? COLOR_TEXT;
  final Color effectiveIconColor = iconColor ?? COLOR_TEXT;

  return PreferredSize(
    preferredSize: Size.fromHeight(height),
    child: Container(
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
        title: title.isNotEmpty
            ? TextSubtitle(title, fontWeight: FontWeight.normal, color: effectiveTextColor)
            : null,
        leading: IconButton(
          splashColor: COLOR_ACCENT.withValues(alpha: 0.2),
          highlightColor: COLOR_ACCENT.withValues(alpha: 0.2),
          onPressed: onClose ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.close),
          color: effectiveIconColor,
          iconSize: 20,
        ),
      ),
    ),
  );
}