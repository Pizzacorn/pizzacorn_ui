import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: CheckboxPolitics
/// Motivo: Checkbox legal estandarizado con enlaces de texto.
/// API: CheckboxPolitics(value: true, onTap: () => ..., onLegalTap: () => ..., onPrivacyTap: () => ...)

class CheckboxPolitics extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  final VoidCallback? onLegalTap;
  final VoidCallback? onPrivacyTap;
  final String labelPre;
  final String labelLegal;
  final String labelMid;
  final String labelPrivacy;

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
  });

  @override
  Widget build(BuildContext context) {
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
              activeColor: COLOR_ACCENT,
              focusColor: COLOR_BACKGROUND,
              checkColor: COLOR_BACKGROUND,
              side: BorderSide(color: COLOR_ACCENT, width: 2),
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
                    style: styleCaption(
                      color: COLOR_ACCENT,
                      fontWeight: WEIGHT_BOLD,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = onLegalTap,
                  ),
                  TextSpan(text: labelMid),
                  TextSpan(
                    text: labelPrivacy,
                    style: styleCaption(
                      color: COLOR_ACCENT,
                      fontWeight: WEIGHT_BOLD,
                    ),
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
