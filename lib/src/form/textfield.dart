import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../pizzacorn_ui.dart';


class TextFieldCustom extends StatefulWidget {
  const TextFieldCustom({
    Key? key,
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
    this.height = 60,
    this.onTap,
    this.readOnly = false,
    this.width = double.infinity,

    // ⬇ Antes llevaban default con TEXT_BODY_SIZE (no-const)
    this.hintSize,
    this.textSize,

    this.filled = true,

    // ⬇ Antes: this.radius = RADIUS
    this.radius,

    // ⬇ Antes: this.colorFill = COLOR_BACKGROUND_SECONDARY
    this.colorFill,

    // ⬇ Antes: this.colorHint = COLOR_SUBTEXT
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
    this.prefixIcon = "",
    this.prefixIconSize = 18,
    this.sufixIcon = "",
    this.prefixText = "",
    this.sufixText = "",
    this.focusNode,
    this.inputFormatters,
    this.textStyleCustom,
    this.autofocus = false,
  }) : super(key: key);

  // CONTROL
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readOnly;
  final Function()? onTap;

  // TAMAÑOS / LAYOUT
  final double height;
  final double width;
  final double? radius;       // ⬅ ahora nullable
  final double? textSize;     // ⬅ ahora nullable
  final double? hintSize;     // ⬅ ahora nullable
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
  final String sufixIcon;
  final String prefixIcon;
  final String prefixText;
  final String sufixText;
  final TextStyle? textStyleCustom;
  final Color? colorFill;     // ⬅ ahora nullable
  final Color? colorHint;     // ⬅ ahora nullable

  // TECLADO
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;

  // PASSWORD
  final bool password;

  // ICONOS
  final double prefixIconSize;

  // CALLBACKS
  final void Function(String)? onChanged;
  final void Function()? onSuffixPressed;
  final void Function()? onPrefixPressed;
  final void Function()? onEditingComplete;

  // VALIDACIÓN EXTRA
  final FormFieldValidator<String>? validator;

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  late FocusNode _focusNode;
  bool _obscureVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      // reconstruye para que aparezca/desaparezca el icono de ocultar teclado
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  bool get _isNumericKeyboard {
    final type = widget.textInputType;
    return type == TextInputType.number ||
        type == TextInputType.phone ||
        type == const TextInputType.numberWithOptions() ||
        type == const TextInputType.numberWithOptions(decimal: true);
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Aquí resolvemos los "defaults dinámicos" usando tu config
    final double effectiveTextSize = widget.textSize ?? TEXT_BODY_SIZE;
    final double effectiveHintSize = widget.hintSize ?? TEXT_BODY_SIZE;
    final double effectiveRadius   = widget.radius ?? RADIUS;
    final Color effectiveFill      = widget.colorFill ?? COLOR_BACKGROUND_SECONDARY;
    final Color effectiveHintColor = widget.colorHint ?? COLOR_SUBTEXT;

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        boxShadow: widget.shadow ? [BoxShadowCustom()] : null,
      ),
      child: TextFormField(
        focusNode: _focusNode,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        obscureText: widget.password ? !_obscureVisible : false,
        textCapitalization: widget.textCapitalization,
        textAlignVertical: widget.textAlignVertical,
        style: widget.textStyleCustom ??
            styleBody(
              color: COLOR_TEXT,
              size: effectiveTextSize,
            ),
        inputFormatters: widget.inputFormatters ?? [],
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength == 0 ? null : widget.maxLength,
        autofocus: widget.autofocus,
        onChanged: (value) {
          if (widget.onChanged != null) widget.onChanged!(value);
        },
        onEditingComplete: widget.onEditingComplete,
        autovalidateMode: widget.errorText.isNotEmpty
            ? AutovalidateMode.onUserInteraction
            : widget.autovalidateMode,
        validator: (value) {
          if (widget.validator != null) {
            return widget.validator!(value);
          }
          if (widget.errorText.isNotEmpty &&
              (value == null || value.isEmpty)) {
            return widget.errorText;
          }
          return null;
        },
        decoration: InputDecoration(
          filled: widget.filled,
          fillColor: effectiveFill,

          // HINT / LABEL / HELPER
          hintText: widget.hintText.isNotEmpty ? widget.hintText : null,
          hintStyle: styleBody(
            color: effectiveHintColor,
            size: effectiveHintSize,
          ),
          labelText: widget.labelText.isNotEmpty ? widget.labelText : null,
          labelStyle: styleBody(
            color: effectiveHintColor,
            size: effectiveHintSize,
          ),
          helperText: widget.helperText.isNotEmpty ? widget.helperText : null,
          helperStyle: styleBody(
            color: effectiveHintColor,
            size: effectiveHintSize,
          ),
          errorStyle: styleCaption(color: COLOR_ERROR),

          // BORDE
          border: widget.filled
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveRadius),
            borderSide: BorderSide.none,
          )
              : null,

          contentPadding:
          widget.noPadding ? EdgeInsets.zero : null,

          // SUFFIX
          suffixText:
          widget.sufixText.isNotEmpty ? widget.sufixText : null,
          suffixIcon: _buildSuffixIcon(context),

          // PREFIX
          prefixText:
          widget.prefixText.isNotEmpty ? widget.prefixText : null,
          prefixStyle: styleBody(color: COLOR_ACCENT),
          prefixIconConstraints:
          const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: widget.prefixIcon.isNotEmpty
              ? TextButton(
            style: styleTransparent(),
            onPressed: () {
              if (widget.onPrefixPressed != null) {
                widget.onPrefixPressed!();
              }
            },
            child: Padding(
              padding:
              const EdgeInsets.only(left: 15, right: 15),
              child: SvgCustom(
                icon: widget.prefixIcon,
                size: widget.prefixIconSize,
              ),
            ),
          )
              : null,
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    // Password: icono de candado
    if (widget.password) {
      return IconButton(
        icon: Icon(
          _obscureVisible ? Icons.lock_open_outlined : Icons.lock_outline,
          color: COLOR_ACCENT,
        ),
        onPressed: () {
          setState(() {
            _obscureVisible = !_obscureVisible;
          });
        },
      );
    }

    // Suffix SVG con callback
    if (widget.sufixIcon.isNotEmpty) {
      return TextButton(
        style: styleTransparent(),
        onPressed: () {
          if (widget.onSuffixPressed != null) {
            widget.onSuffixPressed!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SvgCustom(
            icon: widget.sufixIcon,
            size: 16,
          ),
        ),
      );
    }

    // Teclado numérico: botón para ocultar si está en foco
    if (_isNumericKeyboard && _focusNode.hasFocus) {
      return IconButton(
        icon: Icon(
          Icons.keyboard_hide_outlined,
          color: COLOR_BORDER,
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
        },
      );
    }

    return null;
  }
}
