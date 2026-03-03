import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';
import '../layout/space.dart';
import '../text/textstyles.dart';

Future<void> openBottomSheet(
    BuildContext context,
    Widget widget, {
      bool noBarrierColor = false,
      bool disableDrag = false,
      double height = 400,
      Function()? onBack,
    }) async {
  // Don Sput, recuerda que en pizzacorn_ui preferimos usar nuestras constantes
  // de color si están disponibles en lugar del scheme genérico
  final Color backgroundColor = COLOR_BACKGROUND;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: noBarrierColor
        ? Colors.transparent
        : Colors.black.withOpacity(0.1), // Usamos opacity estándar
    useSafeArea: true,
    elevation: 0,
    enableDrag: !disableDrag,
    builder: (context) {
      return Padding(
        // Este padding es el que empuja el contenido hacia arriba de forma natural
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          // REGLA PIZZACORN: Nada de const en decoraciones reactivas
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RADIUS * 2), // Usando tus constantes
              topRight: Radius.circular(RADIUS * 2),
            ),
          ),
          // Quitamos la suma del viewInsets aquí.
          // El BoxConstraint del bottomSheet ya se encarga de posicionarlo.
          height: height,
          width: MediaQuery.of(context).size.width,
          child: widget,
        ),
      );
    },
  ).then((value) {
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
      bool isError = true,
      bool isAlert = false,
      bool isDone = false,
      Color? color,
      Color? textColor,
    }) {
  final scheme = Theme.of(context).colorScheme;

  // 1. Lógica de colores según el tipo de aviso
  // Prioridad: manual > error > alert > done > default (error)
  Color effectiveColor = color ?? scheme.error;
  IconData iconData = Icons.info_outline;

  if (isError) {
    effectiveColor = COLOR_ERROR;
    iconData = Icons.close_rounded;
  } else if (isAlert) {
    effectiveColor = COLOR_ALERT;
    iconData = Icons.warning_amber_rounded;
  } else if (isDone) {
    effectiveColor = COLOR_DONE;
    iconData = Icons.check_circle_outline_rounded;
  }else {
    effectiveColor = COLOR_INFO;
    iconData = Icons.info_outline;
  }

  // 2. Color de texto/iconos (usando el del parámetro o el de pizzacorn_ui)
  final Color effectiveTextColor = textColor ?? COLOR_BACKGROUND;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: effectiveColor,
      elevation: 8,
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          Icon(
            iconData,
            color: effectiveTextColor,
            size: 20,
          ),
          Space(SPACE_SMALL),
          Expanded(
            child: TextBody(
              text,
              maxlines: 5,
              fontWeight: FontWeight.w500,
              color: effectiveTextColor,
            ),
          ),
        ],
      ),
    ),
  );
}
