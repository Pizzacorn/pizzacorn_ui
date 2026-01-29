import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart'; // Importa todos los componentes de la lib

// NOTA IMPORTANTE, DON SPUTKNIF:
// Los widgets `ShimmerCustom`, `SvgCustom` y `ProfileImageCustom`
// se asumen que YA EXISTEN y están EXPORTADOS desde 'pizzacorn_ui.dart'.
// Si no es así, deberá definirlos o importarlos desde donde correspondan.
// Para que este ejemplo compile, puedes usar stubs simples si aún no los tienes:

/*
class ShimmerCustom extends StatelessWidget {
  final Widget child;
  const ShimmerCustom({super.key, required this.child});
  @override Widget build(BuildContext context) => child;
}

class ProfileImageCustom extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onPressed;
  const ProfileImageCustom({super.key, this.imageUrl, this.onPressed});
  @override Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.person),
    onPressed: onPressed,
  );
}
*/

/// PIZZACORN_UI CANDIDATE
/// Widget: AppBarHome
/// Motivo: AppBar principal con navegación a menú (Drawer), título/logo dinámico y acceso al perfil de usuario.
/// API: AppBarHome(context: context, onMenuPressed: () => ..., title: "Mi Título", profileImageUrl: "url.jpg", onProfilePressed: () => ...)
PreferredSizeWidget AppBarHome({
  required BuildContext context,
  required VoidCallback onMenuPressed, // Función para abrir el Drawer.
  String backgroundAsset =
      "assets/image/background_players.png", // Path del asset para el fondo.
  double backgroundOpacity = 0.3,
  String?
  title, // Si se proporciona, se muestra como título; si es null/vacío, se muestra el logo.
  String? logoAsset =
      "assets/icon/logo.svg", // Path del asset para el logo si no hay título.
  String? profileImageUrl, // URL de la imagen de perfil del usuario.
  VoidCallback?
  onProfilePressed, // Función a ejecutar al pulsar la imagen de perfil.
  VoidCallback?
  onProfileUpdate, // Función para ejecutar al volver de la página de perfil (ej. setState).
  Color? appBarBackgroundColor, // Color de fondo si no quieres el COLOR_ACCENT
  Color? iconColor, // Color de los iconos y texto principal.
}) {
  final Color effectiveAppBarBg = appBarBackgroundColor ?? COLOR_ACCENT;
  final Color effectiveIconColor = iconColor ?? COLOR_TEXT;

  return AppBar(
    toolbarHeight: 80,
    elevation: 0,
    backgroundColor:
        effectiveAppBarBg, // Usa el color de fondo configurable o COLOR_ACCENT.
    flexibleSpace: Opacity(
      opacity: backgroundOpacity,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundAsset), // Carga la imagen de fondo.
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              effectiveAppBarBg,
              BlendMode.color, // Mezcla el color de fondo con la imagen.
            ),
          ),
        ),
      ),
    ),

    leadingWidth: 250, // Permite que el área de leading sea más ancha.
    leading: ShimmerCustom(
      // Asumimos que ShimmerCustom existe y está exportado.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Botón de Menú para abrir el Drawer
          Semantics(
            label: "Abrir menú de navegación", // Etiqueta para accesibilidad.
            button: true,
            child: IconButton(
              icon: Icon(Icons.menu, size: 22, color: effectiveIconColor),
              onPressed: onMenuPressed, // Usa el callback proporcionado.
            ),
          ),
          Space(SPACE_SMALL), // Espacio de su librería.
          // Título o Logo (condicionalmente)
          if (title != null && title.trim().isNotEmpty)
            Flexible(
              child: TextBig(title, color: effectiveIconColor),
            ) // TextBig con el título.
          else if (logoAsset != null && logoAsset.trim().isNotEmpty)
            SvgCustom(
              // Asumimos que SvgCustom existe y está exportado.
              fullIcon: logoAsset,
              size: 40,
              color: effectiveIconColor,
              semanticLabel:
                  "Logo de la aplicación Pizzacorn", // Etiqueta para accesibilidad del logo.
            ),
        ],
      ),
    ),

    // 'title' se deja nulo ya que el contenido principal se gestiona en 'leading'
    // para un control más fino del diseño y la interacción.
    title: null,
    centerTitle: false, // Alinea el 'title' (que es nulo) a la izquierda.

    actions: [
      // Imagen de perfil si se proporciona URL e interacción.
      if (profileImageUrl != null &&
          profileImageUrl.trim().isNotEmpty &&
          onProfilePressed != null)
        Semantics(
          label:
              "Ver y editar perfil de usuario", // Etiqueta para accesibilidad.
          button: true,
          child: ProfileImageCustom(
            // Asumimos que ProfileImageCustom existe y está exportado.
            imageUrl: profileImageUrl,
            onPressed: () {
              onProfilePressed(); // Ejecuta la función para ir al perfil.
              if (onProfileUpdate != null) {
                // Ejecuta la función de actualización si se proporciona,
                // por ejemplo, para refrescar la UI al volver del perfil.
                onProfileUpdate();
              }
            },
          ),
        ),
      SizedBox(width: DOUBLE_PADDING), // Espacio de su librería.
    ],
  );
}
