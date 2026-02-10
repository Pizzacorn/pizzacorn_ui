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
    this.IconSize = 18,
    this.sufixIconSvg = "",
    this.prefixText = "",
    this.sufixText = "",
    this.focusNode,
    this.inputFormatters,
    this.textStyleCustom,
    this.autofocus = false,
    this.prefixIcon, // ⬅ Añadido IconData
    this.suffixIcon, // ⬅ Añadido IconData
  });

  // CONTROL
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readOnly;
  final Function()? onTap;

  // TAMAÑOS / LAYOUT
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

  // TEXTO / ESTILOS
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

  // ICONOS
  final IconData? prefixIcon; // ⬅ IconData para UIcons
  final IconData? suffixIcon; // ⬅ IconData para UIcons
  final double IconSize;

  // TECLADO
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;

  // PASSWORD
  final bool password;

  // CALLBACKS
  final void Function(String)? onChanged;
  final void Function()? onSuffixPressed;
  final void Function()? onPrefixPressed;
  final void Function()? onEditingComplete;

  // VALIDACIÓN EXTRA
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

  void onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    focusNode.removeListener(onFocusChange);
    if (widget.focusNode == null) {
      focusNode.dispose();
    }
    super.dispose();
  }

  bool isNumericKeyboard() {
    final type = widget.textInputType;
    return type == TextInputType.number ||
        type == TextInputType.phone ||
        type == TextInputType.multiline ||
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

    return Container(
      width: widget.width,
      height: widget.maxLines > 1 ? null : finalHeight,
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
        onChanged: (value) {
          if (widget.onChanged != null) widget.onChanged!(value);
        },
        onEditingComplete: widget.onEditingComplete,
        autovalidateMode: widget.errorText.isNotEmpty ? AutovalidateMode.onUserInteraction : widget.autovalidateMode,
        validator: (value) {
          if (widget.validator != null) return widget.validator!(value);
          if (widget.errorText.isNotEmpty && (value == null || value.isEmpty)) return widget.errorText;
          return null;
        },
        decoration: InputDecoration(
          filled: widget.filled,
          fillColor: effectiveFill,
          hintText: widget.hintText.isNotEmpty ? widget.hintText : null,
          hintStyle: styleBody(color: effectiveHintColor, size: effectiveHintSize),
          labelText: widget.labelText.isNotEmpty ? widget.labelText : null,
          labelStyle: styleBody(color: effectiveHintColor, size: effectiveHintSize),
          helperText: widget.helperText.isNotEmpty ? widget.helperText : null,
          helperStyle: styleBody(color: effectiveHintColor, size: effectiveHintSize),
          errorStyle: styleCaption(color: COLOR_ERROR),
          border: widget.filled
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveRadius),
            borderSide: BorderSide.none,
          )
              : null,
          contentPadding: widget.noPadding
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(
            horizontal: 15,
            vertical: (finalHeight - effectiveTextSize) / 2,
          ),
          suffixText: widget.sufixText.isNotEmpty ? widget.sufixText : null,
          suffixIcon: buildSuffixIcon(context),
          prefixText: widget.prefixText.isNotEmpty ? widget.prefixText : null,
          prefixStyle: styleBody(color: COLOR_ACCENT),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: buildPrefixIcon(),
        ),
      ),
    );
  }

  Widget? buildPrefixIcon() {
    // Prioridad 1: IconData (UIcons)
    if (widget.prefixIcon != null) {
      return IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        onPressed: widget.onPrefixPressed,
        icon: Icon(widget.prefixIcon, size: widget.IconSize, color: COLOR_ACCENT),
      );
    }
    // Prioridad 2: SVG
    if (widget.prefixIconSvg.isNotEmpty) {
      return TextButton(
        style: styleTransparent(),
        onPressed: widget.onPrefixPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SvgCustom(
            icon: widget.prefixIconSvg,
            size: widget.IconSize,
          ),
        ),
      );
    }
    return null;
  }

  Widget? buildSuffixIcon(BuildContext context) {
    if (widget.password) {
      return IconButton(
        icon: Icon(
          obscureVisible ? Icons.lock_open_outlined : Icons.lock_outline,
          color: COLOR_ACCENT,
        ),
        onPressed: () => setState(() => obscureVisible = !obscureVisible),
      );
    }

    // Prioridad 1: IconData (UIcons)
    if (widget.suffixIcon != null) {
      return IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        onPressed: widget.onSuffixPressed,
        icon: Icon(widget.suffixIcon, size: widget.IconSize, color: COLOR_ACCENT),
      );
    }

    // Prioridad 2: SVG
    if (widget.sufixIconSvg.isNotEmpty) {
      return TextButton(
        style: styleTransparent(),
        onPressed: widget.onSuffixPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SvgCustom(icon: widget.sufixIconSvg, size: widget.IconSize),
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