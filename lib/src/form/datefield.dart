// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/pickers/date_picker_field.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import '../../pizzacorn_ui.dart'; // Importa DatePickerCustom, colores, estilos, etc.

/// PIZZACORN_UI CANDIDATE
/// Widget: DatePickerField
/// Motivo: Campo de texto para seleccionar fecha (ej. de nacimiento) usando DatePickerCustom.
/// API: DatePickerField(controller: myController, labelText: "Fecha de Nacimiento", onDateSelected: (date) => ...)

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

  DatePickerField({
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
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late DateTime _currentSelectedDate;

  @override
  void initState() {
    super.initState();
    // Usa la fecha inicial proporcionada o una por defecto (ej. hoy o hace 20 años)
    _currentSelectedDate =
        widget.initialDate ??
        DateTime(
          DateTime.now().year - 20,
          DateTime.now().month,
          DateTime.now().day,
        );

    // Inicializa el texto del controlador si no tiene texto y hay una fecha inicial
    if (widget.controller.text.isEmpty && widget.initialDate != null) {
      widget.controller.text = DateFormat(
        'dd/MM/yyyy',
      ).format(_currentSelectedDate);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.enabled) return;

    final DateTime? picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled:
          true, // Importante para que el picker no se corte en pantallas pequeñas
      builder: (BuildContext builderContext) {
        return DatePickerCustom(
          initialDateTime: _currentSelectedDate,
          minimumDate: widget.minimumDate,
          maximumDate: widget.maximumDate,
          onDateTimeChanged: (DateTime newDate) {
            // Este callback se mantiene por si el DatePickerCustom es usado en otro contexto
            // que necesita updates intermedios. Para este campo, usaremos el valor de pop.
          },
        );
      },
    );

    // Si se seleccionó una fecha y es diferente a la actual
    if (picked != null && picked != _currentSelectedDate) {
      setState(() {
        _currentSelectedDate = picked;
        widget.controller.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_currentSelectedDate);
      });
      widget.onDateSelected?.call(picked); // Notifica al widget padre
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.labelText,
      hint: "Toca para abrir el selector de fecha",
      button: true, // Se comporta como un botón para la accesibilidad
      enabled: widget.enabled,
      child: TextFormField(
        controller: widget.controller,
        readOnly: true, // Impide que se escriba directamente
        enabled: widget.enabled,
        onTap: () => _selectDate(context), // Abre el picker al tocar
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          suffixIcon: Icon(Icons.calendar_today, color: COLOR_SUBTEXT),
          // El resto de la decoración se hereda de InputDecorationTheme
          // definido en PizzacornTheme() (theme.dart)
        ),
        validator: widget.validator,
        style: styleBody(
          color: widget.enabled ? COLOR_TEXT : COLOR_TEXT_BLOCKED,
        ),
      ),
    );
  }
}
