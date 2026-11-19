import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: CheckboxPolitics
/// Motivo: Checkbox legal estandarizado con enlaces de texto.
/// API: CheckboxPolitics(value: true, onTap: () => ..., onLegalTap: () => ..., onPrivacyTap: () => ...)
/// Opcionales: `color`, `checkColor`, `linkColor` y `linkFontWeight` para adaptarlo a cada marca.

class CheckboxPolitics extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  final VoidCallback? onLegalTap;
  final VoidCallback? onPrivacyTap;
  final String labelPre;
  final String labelLegal;
  final String labelMid;
  final String labelPrivacy;

  // 🆕 OPCIONALES (no cambian el uso anterior)
  /// Color de la casilla (relleno y borde). Por defecto COLOR_ACCENT.
  final Color? color;
  /// Color de la marca de verificación. Por defecto COLOR_BACKGROUND.
  final Color? checkColor;
  /// Color de los enlaces del texto. Por defecto COLOR_ACCENT.
  final Color? linkColor;
  /// Grosor de los enlaces. Por defecto WEIGHT_BOLD.
  final FontWeight? linkFontWeight;

  const CheckboxPolitics({
    super.key,
    required this.value,
    required this.onTap,
    this.onLegalTap,
    this.onPrivacyTap,
    this.labelPre = 'Confirmas que aceptas y has leído nuestro ',
    this.labelLegal = 'AVISO LEGAL Y CONDICIONES DE USO',
    this.labelMid = ' y nuestra ',
    this.labelPrivacy = 'POLÍTICA DE PRIVACIDAD.',
    this.color,
    this.checkColor,
    this.linkColor,
    this.linkFontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? COLOR_ACCENT;
    final Color effectiveCheckColor = checkColor ?? COLOR_BACKGROUND;
    final TextStyle linkStyle = styleCaption(
      color: linkColor ?? COLOR_ACCENT,
      fontWeight: linkFontWeight ?? WEIGHT_BOLD,
    );

    return Semantics(
      label: "Aceptar políticas y condiciones",
      checked: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: CupertinoCheckbox(
              activeColor: effectiveColor,
              focusColor: COLOR_BACKGROUND,
              checkColor: effectiveCheckColor,
              side: BorderSide(color: effectiveColor, width: 2),
              value: value,
              onChanged: (bool? newValue) => onTap(),
            ),
          ),

          Space(SPACE_SMALL),

          Expanded(
            child: RichText(
              maxLines: 5,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: styleCaption(),
                children: [
                  TextSpan(text: labelPre),
                  TextSpan(
                    text: labelLegal,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = onLegalTap,
                  ),
                  TextSpan(text: labelMid),
                  TextSpan(
                    text: labelPrivacy,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
