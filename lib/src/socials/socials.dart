// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/social/social_icons_row.dart
import 'package:flutter/material.dart';
import 'package:uicons_pro/uicons_pro.dart'; // Para los iconos de redes sociales
import 'package:url_launcher/url_launcher.dart';
import '../../pizzacorn_ui.dart'; // Importamos la librería principal para tokens y openSnackbar
import '../models/social_model.dart'; // Importamos el SocialModel definido en la librería

/// PIZZACORN_UI CANDIDATE
/// Widget: SocialIconsRowWidget
/// Motivo: Muestra una fila de iconos de redes sociales clicables, con soporte de accesibilidad.
/// API: SocialIconsRowWidget(socials: mySocials, iconSize: 24)
class SocialIconsRowWidget extends StatelessWidget {
  final SocialModel socials; // AHORA ACEPTA SOCIALMODEL DIRECTAMENTE (definido en pizzacorn_ui)
  final double iconSize;
  final MainAxisAlignment alignment;

  const SocialIconsRowWidget({
    super.key,
    required this.socials,
    this.iconSize = 20.0,
    this.alignment = MainAxisAlignment.center,
  });

  // Helper function para construir un icono de red social individual
  Widget buildSocialIcon( // Renombrado a camelCase y sin _
      BuildContext context,
      IconData icon,
      String url,
      String semanticLabel,
      double size,
      Color color,
      ) {
    if (url.isEmpty) return const SizedBox.shrink(); // Oculta el icono si la URL está vacía

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size / 8), // Padding dinámico para espaciar
      child: Semantics(
        label: semanticLabel,
        button: true,
        hint: "Abrir perfil de $semanticLabel",
        child: IconButton(
          icon: Icon(icon, color: color, size: size),
          color: COLOR_ACCENT, // COLOR_ACCENT se usa aquí como overlay para el ripple
          onPressed: () async {
            final Uri uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              // ACCESIBILIDAD: Snackbar si no se puede abrir
              openSnackbar(context, text: "No se pudo abrir $semanticLabel");
            }
          },
          tooltip: "Abrir perfil de $semanticLabel", // Accesibilidad para lectores de pantalla
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = COLOR_ACCENT; // Usamos el token global COLOR_ACCENT

    // La fila de iconos de redes sociales para el usuario
    return SingleChildScrollView( // Permite scroll horizontal si hay muchos iconos
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min, // Imprescindible para que la Row no ocupe todo el ancho
        children: [
          buildSocialIcon(context, UIconsPro.brands.brands_instagram, socials.instagram, 'Instagram', iconSize, iconColor),
          buildSocialIcon(context, UIconsPro.brands.brands_twitter, socials.twitter, 'Twitter', iconSize, iconColor),
          buildSocialIcon(context, UIconsPro.brands.brands_linkedin, socials.linkedin, 'LinkedIn', iconSize, iconColor),
          buildSocialIcon(context, UIconsPro.brands.brands_facebook, socials.facebook, 'Facebook', iconSize, iconColor),
          buildSocialIcon(context, UIconsPro.brands.brands_tik_tok, socials.tiktok, 'TikTok', iconSize, iconColor),
          buildSocialIcon(context, UIconsPro.brands.brands_youtube, socials.youtube, 'YouTube', iconSize, iconColor),
          buildSocialIcon(context, UIconsPro.brands.brands_twitch, socials.twitch, 'Twitch', iconSize, iconColor),
          buildSocialIcon(context, UIconsPro.regularRounded.play_alt, socials.kick, 'Kick', iconSize, iconColor),
          // Para la Web personal
          buildSocialIcon(context, UIconsPro.regularRounded.globe, socials.web, 'Web', iconSize, iconColor),
          // Para el Email de contacto (si se quiere como icono)
          buildSocialIcon(context, UIconsPro.regularRounded.envelope, socials.email, 'Email', iconSize, iconColor),
        ],
      ),
    );
  }
}