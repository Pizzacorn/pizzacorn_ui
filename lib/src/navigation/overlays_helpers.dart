import 'package:flutter/material.dart';

import '../layout/space.dart';
import '../text/textstyles.dart';
import '../utils/color_utils.dart';

/// Abre un BottomSheet estándar.
///
/// Uso:
/// ```dart
/// openBottomSheet(
///   context,
///   MiWidgetBottomSheet(),
/// );
/// ```
Future<void> openBottomSheet(
  BuildContext context,
  Widget widget, {
  bool noBarrierColor = false,
  bool disableDrag = false,
  Function()? onBack,
}) async {
  final scheme = Theme.of(context).colorScheme;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // Fondo basado en el surface del theme
    backgroundColor: scheme.surface.withValues(alpha: 0),
    barrierColor: noBarrierColor
        ? Colors.transparent
        : Colors.black.withValues(alpha: 0.1),
    useSafeArea: true,
    elevation: 0,
    enableDrag: !disableDrag,
    builder: (context) {
      return widget;
    },
  ).then((_) {
    if (onBack != null) {
      onBack();
    }
  });
}

/// Abre un BottomSheet que NO se puede cerrar ni arrastrando ni con el
/// botón de atrás del sistema.
///
/// Ideal para procesos críticos (pagos, cargando algo importante, etc.).
///
/// Uso:
/// ```dart
/// openBottomNoBack(
///   context,
///   MiWidgetBottomSheetBloqueado(),
///   onBack: () { ... },
/// );
/// ```
Future<void> openBottomNoBack(
  BuildContext context,
  Widget widget, {
  Function()? onBack,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.1),
    // Dejado transparente para que el widget defina su propio fondo
    backgroundColor: Colors.transparent,
    elevation: 50,
    builder: (BuildContext ctx) {
      return PopScope(
        // Impide que se haga pop con el botón de atrás del sistema
        onPopInvoked: (didPop) async {
          return;
        },
        child: Builder(
          builder: (context) {
            return widget;
          },
        ),
      );
    },
  ).then((value) {
    if (onBack != null) {
      onBack();
    }
  });
}

/// Abre un diálogo estándar usando el [widget] que le pases.
///
/// Uso:
/// ```dart
/// openDialog(
///   context,
///   MiDialogCustom(),
/// );
/// ```
Future<void> openDialog(
  BuildContext context,
  Widget widget, {
  Function()? onBack,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.2),
    builder: (BuildContext ctx) {
      return widget;
    },
  ).then((value) {
    if (onBack != null) {
      onBack();
    }
  });
}

/// Muestra un Snackbar Pizzacorn™ con ícono automático.
///
/// Uso:
/// ```dart
/// openSnackbar(
///   context,
///   text: 'Guardado correctamente',
/// );
/// ```
///
/// [text] → mensaje a mostrar.
/// [color] → color de fondo del snackbar. Si es null, se usa [ColorScheme.error].
void openSnackbar(
    BuildContext context, {
      String text = "",
      Color? color,
      Color? textColor, // <-- Nuevo parámetro añadido
    }) {
  final scheme = Theme.of(context).colorScheme;

  // Si no se pasa color, usamos por defecto el color de error del theme
  final Color effectiveColor = color ?? scheme.error;

  // Si el usuario no pasa textColor, calculamos el mejor contraste automáticamente
  final Color effectiveTextColor = textColor ?? BestOnColor(effectiveColor, context);

  // Elegimos un icono base según el tipo de color.
  IconData iconData = Icons.done;

  if (effectiveColor == scheme.error) {
    iconData = Icons.clear;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: effectiveColor,
      elevation: 100,
      content: Row(
        children: [
          Icon(
            iconData,
            color: effectiveTextColor, // <-- Usamos el color efectivo
            size: 18,
          ),
          Space(SPACE_SMALL),
          Expanded(
            child: TextBody(
              text,
              maxlines: 5,
              color: effectiveTextColor, // <-- Usamos el color efectivo
            ),
          ),
        ],
      ),
    ),
  );
}
