import 'package:flutter/material.dart';
import '../layout/space.dart';
import '../navigation/navigation_helpers.dart';
import '../text/textstyles.dart';
import '../utils/color_utils.dart';

Future<void> OpenBottomSheet(
    Widget widget, {
      bool noBarrierColor = false,
      bool disableDrag = false,
      Function()? onBack,
    }) async {
  final context = NavigationService.navigatorKey.currentContext!;
  final scheme = Theme.of(context).colorScheme;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // Usamos el surface del theme con alpha 0 para integrarlo con la app
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
/// [widget] → contenido del bottomsheet.
/// [onBack] → callback que se ejecuta cuando se cierre de forma manual
/// (por código).
Future<void> OpenBottomNoBack(
    Widget widget,
    Function()? onBack,
    ) async {
  final context = NavigationService.navigatorKey.currentContext!;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.1),
    // Aquí dejamos transparente para que el propio widget defina el fondo
    backgroundColor: Colors.transparent,
    elevation: 50,
    builder: (BuildContext context) {
      return PopScope(
        // Impide que se haga pop con el botón de atrás del sistema
        onPopInvoked: (value) async {
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
/// [widget] → contenido del diálogo.
/// [onBack] → callback al cerrarse el diálogo.
Future<void> OpenDialog(
    Widget widget, {
      Function()? onBack,
    }) async {
  final context = NavigationService.navigatorKey.currentContext!;

  await showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.2),
    builder: (BuildContext context) {
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
/// [text] → mensaje a mostrar.
/// [color] → color de fondo del snackbar. Si es null, se usa [ColorScheme.error].
void OpenSnackbar({
  String text = "",
  Color? color,
}) {
  final context = NavigationService.navigatorKey.currentContext;
  if (context == null) return;

  final scheme = Theme.of(context).colorScheme;

  // Si no se pasa color, usamos por defecto el color de error del theme
  final Color effectiveColor = color ?? scheme.error;

  // Elegimos un icono base según el tipo de color.
  // Si quieres algo más fino, se puede evolucionar a un enum (error/info/done).
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
            color: BestOnColor(effectiveColor),
            size: 18,
          ),
          Space(SPACE_SMALL),
          Expanded(
            child: TextBody(
              text,
              maxlines: 5,
              color: BestOnColor(effectiveColor),
            ),
          ),
        ],
      ),
    ),
  );
}
