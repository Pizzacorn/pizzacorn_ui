// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/inputs/title_and_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: TitleAndTextField
/// Motivo: Combina un título (TextBody) con un campo de texto (TextFieldCustom) para formularios estandarizados.
/// API: TitleAndTextField("Nombre", controller: myController, hintText: "Tu nombre")
class TitleAndTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final List<TextInputFormatter> inputFormatters;
  final double spaceSize;
  final VoidCallback? onTap;

  const TitleAndTextField(
      this.title, { // El contenido (título) es parámetro posicional según la ley
        super.key,
        required this.controller,
        this.hintText = "",
        this.labelText = "",
        this.autofocus = false,
        this.textCapitalization = TextCapitalization.none,
        this.validator,
        this.readOnly = false,
        this.onChanged,
        this.focusNode,
        this.inputFormatters = const [],
        this.spaceSize = SPACE_SMALL,
        this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: title,
      explicitChildNodes: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextBody(
            title,
            fontWeight: FontWeight.bold,
          ),
          Space(spaceSize), // Constante de espacio posicional
          TextFieldCustom(
            controller: controller,
            hintText: hintText,
            labelText: labelText,
            autofocus: autofocus,
            textCapitalization: textCapitalization,
            validator: validator,
            readOnly: readOnly,
            onChanged: onChanged,
            focusNode: focusNode,
            inputFormatters: inputFormatters,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}