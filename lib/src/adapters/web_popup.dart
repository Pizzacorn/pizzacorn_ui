import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:pizzacorn_ui/src/appbars/appbar_close.dart';
import 'package:pizzacorn_ui/src/decorations/decorations.dart';
import 'package:pizzacorn_ui/src/overlays/bottom_popups.dart';

class WebPopupCustom extends StatelessWidget {
  final Widget child;
  final double height;  final double width;
  final bool loading;
  final String titleAppbar;
  final Function? onPressedDelete;
  final Function? onPressedSave;
  final String titleButton;
  final bool noBottom;

  WebPopupCustom({
    super.key,
    required this.child,
    this.height = 800,
    this.width = 800,
    this.loading = false,
    this.noBottom = false,
    this.onPressedSave,
    this.onPressedDelete,
    this.titleButton = "Continuar",
    this.titleAppbar = "Atrás",
  });

  @override
  Widget build(BuildContext context) {
    // Calculamos dimensiones dinámicas
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double finalWidth = screenWidth < width ? screenWidth : width;
    final double finalHeight = screenWidth < height ? screenHeight : height;

    return Container(
      margin: PADDING, // Usando tus tokens
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: finalWidth,
          height: finalHeight,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          decoration: BoxDecorationCustom(), // Asumiendo que es de tu lib
          child: Loading(
            loading: loading,
            child: Scaffold(
              backgroundColor: COLOR_BACKGROUND,
              appBar: AppBarClose(
                context: context,
                title: titleAppbar,
              ),
              body: child,
              bottomNavigationBar: noBottom
                  ? null
                  : BottomSheetPopUps(
                onPressedDelete: onPressedDelete,
                onPressedSave: onPressedSave,
                title: titleButton,
              ),
            ),
          ),
        ),
      ),
    );
  }
}