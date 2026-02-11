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
  final TextInputType? textInputType;
  final int maxLength;

  // NUEVOS CAMPOS
  final int maxLines;
  final int minLines;

  const TitleAndTextField(
      this.title, { // El título es parámetro posicional según la ley
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
        this.textInputType,
        this.maxLength = 0,
        this.maxLines = 1, // Por defecto 1 como un TextField normal
        this.minLines = 1,
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
          // Sin const según la ley Pizzacorn
          TextBody(title, fontWeight: FontWeight.bold),

          Space(spaceSize),

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
            textInputType: textInputType ?? TextInputType.name,
            maxLength: maxLength,
            // Pasamos los nuevos parámetros
            maxLines: maxLines,
            minLines: minLines,
          ),
        ],
      ),
    );
  }
}