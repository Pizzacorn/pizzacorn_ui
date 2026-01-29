// C:/Users/hola/StudioProjects/pizzacorn_ui/lib/src/pickers/date_picker.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Selector de fecha nativo (Cupertino) envuelto en el estilo Pizzacorn
class DatePickerCustom extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime? minimumDate; // ¡Nuevo: fecha mínima seleccionable!
  final DateTime? maximumDate; // ¡Nuevo: fecha máxima seleccionable!

  DatePickerCustom({
    super.key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
    this.minimumDate, // Añadido al constructor
    this.maximumDate, // Añadido al constructor
  });

  @override
  DatePickerCustomState createState() => DatePickerCustomState();
}

class DatePickerCustomState extends State<DatePickerCustom> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    // Asegura que la fecha inicial esté dentro de los límites si se han especificado.
    selectedDateTime = widget.initialDateTime;
    if (widget.minimumDate != null && selectedDateTime.isBefore(widget.minimumDate!)) {
      selectedDateTime = widget.minimumDate!;
    }
    if (widget.maximumDate != null && selectedDateTime.isAfter(widget.maximumDate!)) {
      selectedDateTime = widget.maximumDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: 350, // Un poco más de aire para el diseño
          padding: PADDING_ALL,
          decoration: BoxDecoration(
            color: COLOR_BACKGROUND,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RADIUS),
              topRight: Radius.circular(RADIUS),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // REGLA: Texto posicional
              TextSubtitle("Selecciona la fecha"),

              Space(PADDING_SMALL_SIZE),

              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: styleBody(
                        color: COLOR_TEXT,
                        size: 18,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: selectedDateTime,
                    onDateTimeChanged: (value) {
                      setState(() {
                        selectedDateTime = value;
                      });
                    },
                    minimumDate: widget.minimumDate, // ¡Pasa minimumDate!
                    maximumDate: widget.maximumDate, // ¡Pasa maximumDate!
                    // Por defecto, CupertinoDatePicker ya tiene unos límites amplios,
                    // pero si los proporciona, los usará.
                  ),
                ),
              ),

              Space(PADDING_SMALL_SIZE),

              Row(
                children: [
                  Expanded(
                    child: ButtonCustom(
                      text: "Cancelar",
                      border: true,
                      onPressed: () {
                        // Pop sin resultado para Cancelar
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Space(PADDING_SMALL_SIZE),

                  Expanded(
                    child: ButtonCustom(
                      text: "Continuar",
                      onPressed: () {
                        widget.onDateTimeChanged(selectedDateTime); // Notifica al callback original
                        Navigator.pop(context, selectedDateTime); // ¡Pop con la fecha seleccionada!
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}