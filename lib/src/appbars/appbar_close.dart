import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

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