import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uicons_pro/uicons_pro.dart';
import '../../pizzacorn_ui.dart';

class TimePickerField extends StatefulWidget {
  final TextEditingController controller;
  final DateTime? initialTime;
  final ValueChanged<DateTime>? onTimeSelected;
  final String labelText;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  const TimePickerField({
    super.key,
    required this.controller,
    this.initialTime,
    this.onTimeSelected,
    this.labelText = "Seleccionar Hora",
    this.hintText = "00:00",
    this.validator,
    this.enabled = true,
  });

  @override
  State<TimePickerField> createState() => TimePickerFieldState();
}

class TimePickerFieldState extends State<TimePickerField> {
  late DateTime currentSelectedTime;

  @override
  void initState() {
    super.initState();
    currentSelectedTime = widget.initialTime ?? DateTime.now();

    if (widget.controller.text.isEmpty && widget.initialTime != null) {
      widget.controller.text = DateFormat('HH:mm').format(currentSelectedTime);
    }
  }

  /// PIZZACORN HELPER: Mapea la hora al icono de UIconsPro aproximado
  IconData _getClockIcon(DateTime time) {
    int hour = time.hour;
    int minutes = time.minute;

    // Convertimos a formato 12h para los iconos
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    // Decidimos si mostramos la hora en punto o y media (umbral de 15 min antes/después)
    bool isHalf = minutes >= 15 && minutes < 45;

    // Si los minutos pasan de 45, redondeamos a la siguiente hora en punto
    if (minutes >= 45) {
      hour = (hour == 12) ? 1 : hour + 1;
      isHalf = false;
    }

    switch (hour) {
      case 1: return isHalf ? UIconsPro.regularRounded.clock_one_thirty : UIconsPro.regularRounded.clock_one;
      case 2: return isHalf ? UIconsPro.regularRounded.clock_two_thirty : UIconsPro.regularRounded.clock_two;
      case 3: return isHalf ? UIconsPro.regularRounded.clock_three_thirty : UIconsPro.regularRounded.clock_three;
      case 4: return isHalf ? UIconsPro.regularRounded.clock_four_thirty : UIconsPro.regularRounded.clock_four_thirty; // Asumo clock_four si existe, si no usa fallback
      case 5: return isHalf ? UIconsPro.regularRounded.clock_five_thirty : UIconsPro.regularRounded.clock_five;
      case 6: return isHalf ? UIconsPro.regularRounded.clock_six_thirty : UIconsPro.regularRounded.clock_six;
      case 7: return isHalf ? UIconsPro.regularRounded.clock_seven_thirty : UIconsPro.regularRounded.clock_seven;
      case 8: return isHalf ? UIconsPro.regularRounded.clock_eight_thirty : UIconsPro.regularRounded.clock_eight_thirty; // Idem clock_eight
      case 9: return isHalf ? UIconsPro.regularRounded.clock_nine_thirty : UIconsPro.regularRounded.clock_nine;
      case 10: return isHalf ? UIconsPro.regularRounded.clock_ten_thirty : UIconsPro.regularRounded.clock_ten;
      case 11: return isHalf ? UIconsPro.regularRounded.clock_eleven_thirty : UIconsPro.regularRounded.clock_eleven;
      case 12: return isHalf ? UIconsPro.regularRounded.clock_twelve_thirty : UIconsPro.regularRounded.clock_twelve;
      default: return UIconsPro.regularRounded.clock;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    if (!widget.enabled) return;

    await openBottomSheet(
      context,
      TimePickerCustom(
        initialDateTime: currentSelectedTime,
        onDateTimeChanged: (DateTime newTime) {
          setState(() {
            currentSelectedTime = newTime;
            widget.controller.text = DateFormat('HH:mm').format(newTime);
          });

          if (widget.onTimeSelected != null) {
            widget.onTimeSelected!(newTime);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sincronizamos la hora interna si el controller ha sido modificado externamente
    if (widget.controller.text.isNotEmpty) {
      try {
        final parsed = DateFormat('HH:mm').parse(widget.controller.text);
        currentSelectedTime = DateTime(
          currentSelectedTime.year,
          currentSelectedTime.month,
          currentSelectedTime.day,
          parsed.hour,
          parsed.minute,
        );
      } catch (_) {}
    }

    return Semantics(
      label: widget.labelText,
      hint: "Toca para abrir el selector de hora",
      button: true,
      enabled: widget.enabled,
      child: TextFieldCustom(
        controller: widget.controller,
        readOnly: true,
        onTap: () => selectTime(context),
        labelText: widget.labelText,
        hintText: widget.hintText,
        validator: widget.validator,
        // ¡MAGIA! El icono cambia según la hora seleccionada
        prefixIcon: _getClockIcon(currentSelectedTime),
      ),
    );
  }
}