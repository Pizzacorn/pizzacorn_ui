import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart'; // Importa todos los componentes de la lib

// NOTA IMPORTANTE, DON SPUTKNIF:
// Los widgets `ShimmerCustom`, `SvgCustom` y `ProfileImageCustom`
// se asumen que YA EXISTEN y están EXPORTADOS desde 'pizzacorn_ui.dart'.
// Si no es así, deberá definirlos o importarlos desde donde correspondan.
// Para que este ejemplo compile, puedes usar stubs simples si aún no los tienes:

// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/appbars/appbar_home.dart
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/src/images/profile_image.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: AppBarHome
/// Motivo: AppBar principal flexible con soporte para logo, menú lateral y perfil de usuario.
/// API: AppBarHome(context, scaffoldKey: key, logoAsset: "...", userImage: "...")
PreferredSizeWidget AppBarHome({
  required BuildContext context,
  required GlobalKey<ScaffoldState> scaffoldKey,
  String logoAsset = "assets/image/logobar.png",
  String userImage = "",
  IconData? iconMenu,
  bool hasIconMenu = true,
  VoidCallback? onUserPressed,
  Color? appBarBackgroundColor,
  Color? iconColor,
  double toolbarHeight = 80,
  double logoWidth = 150,
}) {
  // 🔥 RESOLUCIÓN DE COLORES REACTIVOS
  final Color effectiveAppBarBg = appBarBackgroundColor ?? COLOR_BACKGROUND;
  final Color effectiveIconColor = iconColor ?? COLOR_TEXT;
  final IconData effectiveMenuIcon = iconMenu ?? Icons.menu_rounded;

  return AppBar(
    toolbarHeight: toolbarHeight,
    elevation: 0,
    backgroundColor: effectiveAppBarBg,
    leadingWidth: 250, // Espacio suficiente para Icono + Espacio + Logo
    automaticallyImplyLeading: false,
    leading: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Botón de Menú lateral (Drawer)
        if (hasIconMenu)
          Semantics(
            label: "Abrir menú de navegación",
            button: true,
            child: IconButton(
              icon: Icon(
                  effectiveMenuIcon,
                  size: 22,
                  color: effectiveIconColor
              ),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
              tooltip: "Abrir menú",
            ),
          ),

        if (hasIconMenu) Space(SPACE_SMALL),

        // Logo de la App
        Semantics(
          label: "Logo de la aplicación",
          image: true,
          child: Image.asset(
            logoAsset,
            width: logoWidth,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),
      ],
    ),

    actions: [
      // Imagen de Perfil
      if (userImage.isNotEmpty || onUserPressed != null)
        Semantics(
          label: "Perfil de usuario",
          button: true,
          child: ProfileImageCustom(
            imageUrl: userImage,
            onPressed: onUserPressed,
          ),
        ),

      Space(SPACE_MEDIUM),
    ],
  );
}
