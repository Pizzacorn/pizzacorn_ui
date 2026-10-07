import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:uicons_pro/uicons_pro.dart';

/// Estilo opcional de una entrada del menú desplegable.
class DropdownOptionStyle {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Gradient? gradient;
  final TextStyle? textStyle;
  final double borderWidth;

  const DropdownOptionStyle({
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.gradient,
    this.textStyle,
    this.borderWidth = 1,
  }) : assert(borderWidth >= 0);
}

/// Dropdown elegante basado en PopupMenu al estilo Pizzacorn
class DropdownCustom<T> extends StatefulWidget {
  final List<T> items;
  final T? initialItem;
  final ValueChanged<T>? onChanged;
  final String Function(T) getName;
  final String tooltip;
  final String hintText;
  final bool selected;
  final bool borderGradient;
  final bool backgroundGradient;
  final List<Color> gradientColors;
  final Color? selectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? selectedBorderColor;
  final double borderWidth;
  final double height;
  final EdgeInsetsGeometry contentPadding;
  final IconData? dropdownIcon;
  final Color? dropdownIconColor;
  final Color? menuBackgroundColor;
  final DropdownOptionStyle? Function(T item, bool isSelected)? optionStyleBuilder;

  DropdownCustom({
    super.key,
    required this.items,
    this.initialItem,
    this.onChanged,
    required this.getName,
    required this.tooltip,
    required this.hintText,
    this.selected = false,
    this.borderGradient = false,
    this.backgroundGradient = false,
    this.gradientColors = const [],
    this.selectedBackgroundColor,
    this.selectedTextColor,
    this.selectedBorderColor,
    this.borderWidth = 1.5,
    this.height = 55,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    this.dropdownIcon,
    this.dropdownIconColor,
    this.menuBackgroundColor,
    this.optionStyleBuilder,
  }) : assert(borderWidth >= 0),
       assert(height > 0),
       assert(gradientColors.length != 1);

  @override
  DropdownCustomState<T> createState() => DropdownCustomState<T>();
}

class DropdownCustomState<T> extends State<DropdownCustom<T>> {
  T? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialItem;
  }

  @override
  void didUpdateWidget(DropdownCustom<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialItem != widget.initialItem) {
      selectedItem = widget.initialItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Resolvemos el texto a mostrar
    String currentText = widget.hintText;
    if (selectedItem != null) {
      currentText = widget.getName(selectedItem as T);
    }

    final colors = widget.gradientColors.isEmpty
        ? [COLOR_ACCENT, COLOR_ACCENT_SECONDARY]
        : widget.gradientColors;
    final backgroundColor = widget.selected
        ? widget.selectedBackgroundColor ?? COLOR_BACKGROUND
        : COLOR_BACKGROUND_SECONDARY;
    final textColor = widget.selected
        ? widget.selectedTextColor ??
            (widget.backgroundGradient ? COLOR_TEXT_BUTTONS : COLOR_TEXT)
        : COLOR_TEXT;

    Widget field = Container(
      height: widget.height,
      padding: widget.contentPadding,
      decoration: BoxDecoration(
        color: widget.selected && widget.backgroundGradient
            ? null
            : backgroundColor,
        gradient: widget.selected && widget.backgroundGradient
            ? LinearGradient(colors: colors)
            : null,
        border: widget.selected && !widget.borderGradient
            ? Border.all(
                color: widget.selectedBorderColor ?? COLOR_ACCENT,
                width: widget.borderWidth,
              )
            : null,
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextBody(currentText, color: textColor),
          Spacer(),
          Icon(
            widget.dropdownIcon ?? UIconsPro.regularRounded.angle_small_down,
            color: widget.dropdownIconColor ?? textColor,
            size: 16,
          ),
        ],
      ),
    );
    if (widget.selected && widget.borderGradient) {
      field = AnimatedGradientBorder(
        radius: RADIUS,
        borderWidth: widget.borderWidth,
        colors: colors,
        animated: false,
        gradientType: PizzacornGradientType.linear,
        child: field,
      );
    }

    return PopupMenuButton<T>(
      tooltip: widget.tooltip,
      // Usamos los estilos y tokens de la librería
      style: styleTransparent(),
      color: widget.menuBackgroundColor ?? COLOR_BACKGROUND,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(RADIUS)),
      ),
      child: field,
      onSelected: (T item) {
        setState(() {
          selectedItem = item;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(item);
        }
      },
      itemBuilder: (BuildContext context) {
        // REGLA: Prohibido .map().toList(). Usamos bucle con índice.
        final List<PopupMenuEntry<T>> menuItems = <PopupMenuEntry<T>>[];
        for (int i = 0; i < widget.items.length; i++) {
          final T item = widget.items[i];
          final DropdownOptionStyle? optionStyle =
              widget.optionStyleBuilder?.call(item, selectedItem == item);
          menuItems.add(
            PopupMenuItem<T>(
              value: item,
              padding: optionStyle == null ? null : EdgeInsets.zero,
              child: optionStyle == null
                  ? TextBody(widget.getName(item))
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: optionStyle.gradient == null
                            ? optionStyle.backgroundColor
                            : null,
                        gradient: optionStyle.gradient,
                        border: optionStyle.borderColor == null
                            ? null
                            : Border.all(
                                color: optionStyle.borderColor!,
                                width: optionStyle.borderWidth,
                              ),
                        borderRadius: BorderRadius.circular(RADIUS),
                      ),
                      child: optionStyle.textStyle == null
                          ? TextBody(
                              widget.getName(item),
                              color: optionStyle.textColor ?? COLOR_TEXT,
                            )
                          : Text(
                              widget.getName(item),
                              style: styleBody(
                                color: optionStyle.textColor ?? COLOR_TEXT,
                              ).merge(optionStyle.textStyle),
                            ),
                    ),
            ),
          );
        }
        return menuItems;
      },
    );
  }
}
