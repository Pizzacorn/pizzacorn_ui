// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/appbars/appbar_back_action.dart
import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: AppBarBackAction
/// Motivo: AppBar con botón de retroceso y menú de acciones (MoreMenuButton) integrado.
/// API: AppBarBackAction(context: context, title: "Detalle", onEdit: () => ...)
PreferredSizeWidget AppBarBackAction({
  required BuildContext context,
  String title = "",
  Color? color,
  Color? textColor,
  Color? iconColor,
  VoidCallback? onBack,
  // Callbacks para el MoreMenuButton
  VoidCallback? onEdit,
  VoidCallback? onDelete,
  VoidCallback? onDuplicate,
  VoidCallback? onReport,
}) {
  final Color effectiveColor = color ?? COLOR_BACKGROUND_SECONDARY;
  final Color effectiveTextColor = textColor ?? COLOR_TEXT;
  final Color effectiveIconColor = iconColor ?? COLOR_TEXT;

  return AppBar(
    toolbarHeight: 65,
    backgroundColor: effectiveColor,
    elevation: 0,
    centerTitle: false,
    title: TextSubtitle(title, color: effectiveTextColor),
    leading: IconButton(
      splashColor: COLOR_ACCENT.withValues(alpha: 0.2),
      highlightColor: COLOR_ACCENT.withValues(alpha: 0.2),
      onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.arrow_back_ios),
      color: effectiveIconColor,
      iconSize: 20,
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: MoreMenuButton(
          onEdit: onEdit,
          onDelete: onDelete,
          onDuplicate: onDuplicate,
          onReport: onReport,
          iconColor: effectiveIconColor,
          iconSize: 22,
        ),
      ),
    ],
  );
}