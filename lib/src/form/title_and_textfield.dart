import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: TitleAndTextField
/// Motivo: Combina un título (TextBody) con un campo de texto (TextFieldCustom) para formularios estandarizados.
/// API: TitleAndTextField("Nombre", controller: myController, hintText: "Tu nombre")
/// Con `outlined: true` el campo se dibuja con borde visible y el título queda encima.
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

  // 🆕 OPCIONALES (no cambian el uso anterior)
  /// Campo de contraseña (con botón para mostrar/ocultar).
  final bool password;
  /// Campo con borde visible (ver TextFieldCustom.outlined).
  final bool outlined;
  /// Altura del campo. Por defecto FIELD_HEIGHT.
  final double? height;
  /// Radio del campo. Por defecto RADIUS.
  final double? radius;
  /// Tamaño del título. Por defecto el de TextBody.
  final double? titleSize;
  /// Relleno del campo. Por defecto COLOR_BACKGROUND_SECONDARY.
  final Color? colorFill;
  /// Color de los iconos del campo (por ejemplo el de la contraseña).
  final Color? iconColor;
  /// Color del borde en reposo (solo con `outlined`).
  final Color? borderColor;
  /// Icono con la contraseña visible.
  final IconData? passwordVisibleIcon;
  /// Icono con la contraseña oculta.
  final IconData? passwordHiddenIcon;

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
        this.password = false,
        this.outlined = false,
        this.height,
        this.radius,
        this.titleSize,
        this.colorFill,
        this.iconColor,
        this.borderColor,
        this.passwordVisibleIcon,
        this.passwordHiddenIcon,
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
          TextBody(title, fontWeight: FontWeight.bold, fontSize: titleSize),

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
            textInputType: textInputType ??
                (password ? TextInputType.visiblePassword : TextInputType.name),
            maxLength: maxLength,
            // Pasamos los nuevos parámetros
            maxLines: maxLines,
            minLines: minLines,
            password: password,
            outlined: outlined,
            height: height,
            radius: radius,
            colorFill: colorFill,
            iconColor: iconColor,
            borderColor: borderColor,
            passwordVisibleIcon: passwordVisibleIcon,
            passwordHiddenIcon: passwordHiddenIcon,
          ),
        ],
      ),
    );
  }
}
