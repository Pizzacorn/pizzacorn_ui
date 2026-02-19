import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Selector de hora nativo (Cupertino) envuelto en el estilo Pizzacorn
class TimePickerCustom extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  TimePickerCustom({
    super.key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
  });

  @override
  TimePickerCustomState createState() => TimePickerCustomState();
}

class TimePickerCustomState extends State<TimePickerCustom> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: 350, // Altura optimizada para el layout
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
              // REGLA: Texto posicional (Regla 3)
              TextSubtitle("Selecciona la hora"),

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
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: selectedDateTime,
                    use24hFormat: true,
                    onDateTimeChanged: (value) {
                      setState(() {
                        selectedDateTime = value;
                      });
                    },
                  ),
                ),
              ),

              Space(PADDING_SMALL_SIZE),

              Row(
                children: [
                  Expanded(
                    child: ButtonCustom(
                      text: "Cancelar",
                      border: true, // Estilo secundario para cancelar
                      color: COLOR_BACKGROUND,
                      borderColor: COLOR_BORDER,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Space(PADDING_SMALL_SIZE),

                  Expanded(
                    child: ButtonCustom(
                      text: "Continuar",
                      onPressed: () {
                        widget.onDateTimeChanged(selectedDateTime);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
