// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/form/datefield.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uicons_pro/uicons_pro.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Widget: DatePickerField
/// Motivo: Campo de texto que abre el selector de fecha Pizzacorn usando el helper de navegación global.
/// API: DatePickerField(controller: myController, labelText: "Nacimiento")
class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final DateTime? initialDate;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final ValueChanged<DateTime>? onDateSelected;
  final String labelText;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  const DatePickerField({
    super.key,
    required this.controller,
    this.initialDate,
    this.minimumDate,
    this.maximumDate,
    this.onDateSelected,
    this.labelText = "Seleccionar Fecha",
    this.hintText = "DD/MM/AAAA",
    this.validator,
    this.enabled = true,
  });

  @override
  State<DatePickerField> createState() => DatePickerFieldState();
}

class DatePickerFieldState extends State<DatePickerField> {
  late DateTime currentSelectedDate;

  @override
  void initState() {
    super.initState();
    currentSelectedDate = widget.initialDate ??
        DateTime(
          DateTime.now().year - 20,
          DateTime.now().month,
          DateTime.now().day,
        );

    if (widget.controller.text.isEmpty && widget.initialDate != null) {
      widget.controller.text = DateFormat('dd/MM/yyyy').format(currentSelectedDate);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    if (!widget.enabled) return;

    // USANDO LA LEY: openBottomSheet de overlays_helpers.dart
    await openBottomSheet(
      context,
      DatePickerCustom(
        initialDateTime: currentSelectedDate,
        minimumDate: widget.minimumDate,
        maximumDate: widget.maximumDate,
        onDateTimeChanged: (DateTime newDate) {
          // Actualizamos el estado interno y el controlador
          setState(() {
            currentSelectedDate = newDate;
            widget.controller.text = DateFormat('dd/MM/yyyy').format(newDate);
          });

          // Notificamos al padre si existe el callback
          if (widget.onDateSelected != null) {
            widget.onDateSelected!(newDate);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.labelText,
      hint: "Toca para abrir el selector de fecha",
      button: true,
      enabled: widget.enabled,
      child: TextFieldCustom( // Usamos nuestro TextFieldCustom para mantener la estética
        controller: widget.controller,
        readOnly: true,
        onTap: () => selectDate(context),
        labelText: widget.labelText,
        hintText: widget.hintText,
        validator: widget.validator,
        prefixIcon: UIconsPro.regularRounded.calendar_day,
      ),
    );
  }
}