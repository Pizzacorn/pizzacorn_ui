import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../pizzacorn_ui.dart';

class TextFieldCustom extends StatefulWidget {
  const TextFieldCustom({
    super.key,
    this.controller,
    this.onChanged,
    this.onSuffixPressed,
    this.onPrefixPressed,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.errorText = "",
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.helperText = "",
    this.labelText = "",
    this.hintText = "",
    this.shadow = false,
    this.height,
    this.onTap,
    this.readOnly = false,
    this.width = double.infinity,
    this.hintSize,
    this.textSize,
    this.filled = true,
    this.radius,
    this.colorFill,
    this.colorHint,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength = 0,
    this.elevation = 5,
    this.noPadding = false,
    this.textCapitalization = TextCapitalization.none,
    this.textInputType = TextInputType.text,
    this.password = false,
    this.textAlignVertical = TextAlignVertical.center,
    this.prefixIconSvg = "",
    this.iconSize = 18, // ⬅ Renombrado a camelCase
    this.iconColor,    // ⬅ Añadido para control total
    this.sufixIconSvg = "",
    this.prefixText = "",
    this.sufixText = "",
    this.focusNode,
    this.inputFormatters,
    this.textStyleCustom,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.outlined = false,
    this.borderColor,
    this.borderColorFocus,
    this.borderWidth,
    this.passwordVisibleIcon,
    this.passwordHiddenIcon,
  });

  // ... (RESTO DE VARIABLES SE MANTIENEN IGUAL)
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readOnly;
  final Function()? onTap;
  final double? height;
  final double width;
  final double? radius;
  final double? textSize;
  final double? hintSize;
  final double elevation;
  final bool shadow;
  final bool filled;
  final bool noPadding;
  final int maxLines;
  final int maxLength;
  final int minLines;
  final TextAlignVertical textAlignVertical;
  final String labelText;
  final String hintText;
  final String helperText;
  final String errorText;
  final String sufixIconSvg;
  final String prefixIconSvg;
  final String prefixText;
  final String sufixText;
  final TextStyle? textStyleCustom;
  final Color? colorFill;
  final Color? colorHint;

  // ICONOS (ACTUALIZADOS)
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  // 🔲 BORDE VISIBLE (opcional). Con `outlined: false` el campo es el de siempre (relleno sin borde).
  /// Dibuja un contorno con COLOR_BORDER_NOFOCUS / COLOR_BORDER_FOCUS y BORDER_SIZE / BORDER_SIZE_FOCUS.
  final bool outlined;
  /// Color del borde en reposo. Por defecto COLOR_BORDER_NOFOCUS.
  final Color? borderColor;
  /// Color del borde con foco. Por defecto COLOR_BORDER_FOCUS.
  final Color? borderColorFocus;
  /// Grosor del borde (reposo y foco). Por defecto BORDER_SIZE / BORDER_SIZE_FOCUS.
  final double? borderWidth;

  // 👁️ ICONOS DE CONTRASEÑA (opcionales). Por defecto candado cerrado / abierto.
  /// Icono cuando la contraseña se está viendo.
  final IconData? passwordVisibleIcon;
  /// Icono cuando la contraseña está oculta.
  final IconData? passwordHiddenIcon;

  final double iconSize; // ⬅ camelCase
  final Color? iconColor; // ⬅ Nuevo

  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final bool password;
  final void Function(String)? onChanged;
  final void Function()? onSuffixPressed;
  final void Function()? onPrefixPressed;
  final void Function()? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;

  @override
  State<TextFieldCustom> createState() => TextFieldCustomState();
}

class TextFieldCustomState extends State<TextFieldCustom> {
  late FocusNode focusNode;
  bool obscureVisible = false;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(onFocusChange);
  }

  void onFocusChange() => setState(() {});

  @override
  void didUpdateWidget(covariant TextFieldCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) return;

    focusNode.removeListener(onFocusChange);
    if (oldWidget.focusNode == null) focusNode.dispose();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    focusNode.removeListener(onFocusChange);
    if (widget.focusNode == null) focusNode.dispose();
    super.dispose();
  }

  bool isNumericKeyboard() {
    final type = widget.textInputType;
    return type == TextInputType.number ||
        type == TextInputType.phone ||
        type == const TextInputType.numberWithOptions() ||
        type == const TextInputType.numberWithOptions(decimal: true);
  }

  @override
  Widget build(BuildContext context) {
    final double effectiveTextSize = widget.textSize ?? TEXT_BODY_SIZE;
    final double effectiveHintSize = widget.hintSize ?? TEXT_BODY_SIZE;
    final double effectiveRadius = widget.radius ?? RADIUS;
    final Color effectiveFill = widget.colorFill ?? COLOR_BACKGROUND_SECONDARY;
    final Color effectiveHintColor = widget.colorHint ?? COLOR_SUBTEXT;
    final double finalHeight = widget.height ?? FIELD_HEIGHT;
    // Color de icono por defecto es COLOR_ACCENT si no se pasa nada
    final Color effectiveIconColor = widget.iconColor ?? COLOR_ACCENT;
    final bool hasFixedSingleLineHeight = widget.maxLines == 1 && widget.minLines == 1;
    // 🔲 Bordes del modo contorneado
    final Color effectiveBorderColor = widget.borderColor ?? COLOR_BORDER_NOFOCUS;
    final Color effectiveBorderColorFocus = widget.borderColorFocus ?? COLOR_BORDER_FOCUS;
    final double effectiveBorderWidth = widget.borderWidth ?? BORDER_SIZE;
    final double effectiveBorderWidthFocus = widget.borderWidth ?? BORDER_SIZE_FOCUS;

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        boxShadow: widget.shadow ? [BoxShadowCustom()] : null,
      ),
      child: TextFormField(
        focusNode: focusNode,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        obscureText: widget.password ? !obscureVisible : false,
        textCapitalization: widget.textCapitalization,
        textAlignVertical: widget.textAlignVertical,
        style: widget.textStyleCustom ?? styleBody(color: COLOR_TEXT, size: effectiveTextSize),
        inputFormatters: widget.inputFormatters ?? [],
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength == 0 ? null : widget.maxLength,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        autovalidateMode: widget.errorText.isNotEmpty ? AutovalidateMode.onUserInteraction : widget.autovalidateMode,
        validator: (value) {
          if (widget.validator != null) return widget.validator!(value);
          if (widget.errorText.isNotEmpty && (value == null || value.isEmpty)) return widget.errorText;
          return null;
        },
        decoration: InputDecoration(
          constraints: hasFixedSingleLineHeight
              ? BoxConstraints(minHeight: finalHeight)
              : null,
          filled: widget.filled,
          fillColor: effectiveFill,
          hintText: widget.hintText.isNotEmpty ? widget.hintText : null,
          hintStyle: styleBody(color: effectiveHintColor, size: effectiveHintSize),
          labelText: widget.labelText.isNotEmpty ? widget.labelText : null,
          labelStyle: styleBody(color: effectiveHintColor, size: effectiveHintSize),
          helperText: widget.helperText.isNotEmpty ? widget.helperText : null,
          helperStyle: styleBody(color: effectiveHintColor, size: effectiveHintSize),
          helperMaxLines: 3,
          errorStyle: styleCaption(color: COLOR_ERROR),
          errorMaxLines: 3,
          counterText: widget.maxLength == 0 ? null : "",
          border: widget.outlined
              ? buildOutlineBorder(effectiveRadius, effectiveBorderColor, effectiveBorderWidth)
              : widget.filled
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveRadius),
            borderSide: BorderSide.none,
          )
              : null,
          enabledBorder: widget.outlined
              ? buildOutlineBorder(effectiveRadius, effectiveBorderColor, effectiveBorderWidth)
              : null,
          focusedBorder: widget.outlined || widget.filled
              ? buildOutlineBorder(effectiveRadius, effectiveBorderColorFocus, effectiveBorderWidthFocus)
              : null,
          errorBorder: widget.outlined
              ? buildOutlineBorder(effectiveRadius, COLOR_ERROR, effectiveBorderWidth)
              : null,
          focusedErrorBorder: widget.outlined
              ? buildOutlineBorder(effectiveRadius, COLOR_ERROR, effectiveBorderWidthFocus)
              : null,
          contentPadding: widget.noPadding
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(
            horizontal: 15,
            vertical: hasFixedSingleLineHeight
                ? ((finalHeight - effectiveTextSize * 1.5) / 2).clamp(0, double.infinity)
                : 15,
          ),
          suffixText: widget.sufixText.isNotEmpty ? widget.sufixText : null,
          suffixIcon: buildSuffixIcon(context, effectiveIconColor),
          prefixText: widget.prefixText.isNotEmpty ? widget.prefixText : null,
          prefixStyle: styleBody(color: COLOR_ACCENT),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: buildPrefixIcon(effectiveIconColor),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineBorder(double radius, Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget? buildPrefixIcon(Color iconColor) {
    if (widget.prefixIcon != null) {
      return IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        onPressed: widget.onPrefixPressed,
        icon: Icon(widget.prefixIcon, size: widget.iconSize, color: iconColor),
      );
    }
    if (widget.prefixIconSvg.isNotEmpty) {
      return TextButton(
        style: styleTransparent(),
        onPressed: widget.onPrefixPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SvgCustom(
            icon: widget.prefixIconSvg,
            size: widget.iconSize,
            color: iconColor, // Asumiendo que SvgCustom acepta color
          ),
        ),
      );
    }
    return null;
  }

  Widget? buildSuffixIcon(BuildContext context, Color iconColor) {
    if (widget.password) {
      return IconButton(
        tooltip: obscureVisible ? 'Ocultar contraseña' : 'Mostrar contraseña',
        icon: Icon(
          obscureVisible
              ? (widget.passwordVisibleIcon ?? Icons.lock_open_outlined)
              : (widget.passwordHiddenIcon ?? Icons.lock_outline),
          color: iconColor,
        ),
        onPressed: () => setState(() => obscureVisible = !obscureVisible),
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        onPressed: widget.onSuffixPressed,
        icon: Icon(widget.suffixIcon, size: widget.iconSize, color: iconColor),
      );
    }

    if (widget.sufixIconSvg.isNotEmpty) {
      return TextButton(
        style: styleTransparent(),
        onPressed: widget.onSuffixPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SvgCustom(
            icon: widget.sufixIconSvg,
            size: widget.iconSize,
            color: iconColor, // Asumiendo que SvgCustom acepta color
          ),
        ),
      );
    }

    if (isNumericKeyboard() && focusNode.hasFocus) {
      return IconButton(
        icon: Icon(Icons.keyboard_hide_outlined, color: COLOR_BORDER),
        onPressed: () => FocusScope.of(context).unfocus(),
      );
    }

    return null;
  }
}
