import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';
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
  final Color backgroundColor = COLOR_BACKGROUND;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: noBarrierColor
        ? Colors.transparent
        : Colors.black.withValues(alpha: 0.1),
    useSafeArea: true,
    elevation: 0,
    enableDrag: !disableDrag,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(RADIUS * 2),
            topRight: Radius.circular(RADIUS * 2),
          ),
        ),
        height: height + MediaQuery.of(context).viewInsets.bottom,
        width: MediaQuery.of(context).size.width,
        child: widget,
      );
    },
  ).then((value) {
    if (onBack != null) {
      onBack();
    }
  });
}

/// PIZZACORN_UI CANDIDATE
/// Widget: openStupidSheet
/// Motivo: Abre un BottomSheet "Floating Card" usando StupidSimpleSheetRoute.
Future<void> openStupidSheet(
    BuildContext context,
    Widget widget, {
      bool isDismissible = true,
      Color? backgroundColor,
      Function()? onBack,
    }) async {
  await Navigator.of(context).push(
    StupidSimpleSheetRoute(
      child: widget,
    ),
  ).then((value) {
    if (onBack != null) {
      onBack();
    }
  });
}

/// PIZZACORN_UI CANDIDATE
/// Widget: openStupidCupertinoSheet
/// Motivo: Abre un BottomSheet estilo Cupertino "Stacking" (iOS 13+) con navegación integrada.
Future<void> openStupidCupertinoSheet(
    BuildContext context,
    Widget widget, {
      String title = "",
      Function()? onBack,
    }) async {
  await Navigator.of(context).push(
    StupidSimpleCupertinoSheetRoute(
      child: CupertinoPageScaffold(
        backgroundColor: COLOR_BACKGROUND,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            if (title.isNotEmpty)
              CupertinoSliverNavigationBar(
                backgroundColor: COLOR_BACKGROUND.withValues(alpha: 0.9),
                largeTitle: TextSubtitle(title),
                border: null,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: TextBody("Cerrar", color: COLOR_ACCENT),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            SliverToBoxAdapter(child: widget),
          ],
        ),
      ),
    ),
  ).then((value) {
    if (onBack != null) {
      onBack();
    }
  });
}

/// Abre un BottomSheet que NO se puede cerrar ni arrastrando ni con el
/// botón de atrás del sistema.
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
    backgroundColor: Colors.transparent,
    elevation: 50,
    builder: (BuildContext ctx) {
      return PopScope(
        onPopInvokedWithResult: (didPop, result) async {
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
