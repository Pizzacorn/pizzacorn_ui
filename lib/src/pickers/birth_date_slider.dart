import 'package:flutter/cupertino.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class BirthDateSliderCustom extends StatelessWidget {
  final DateTime birthDate;
  final ValueChanged<DateTime> onChanged;
  final double height;
  final double width;
  final DateTime minimumDate;
  final DateTime? maximumDate;
  final DatePickerDateOrder dateOrder;
  final Brightness brightness;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  BirthDateSliderCustom({
    super.key,
    required this.birthDate,
    required this.onChanged,
    this.height = 330,
    this.width = double.infinity,
    DateTime? minimumDate,
    this.maximumDate,
    this.dateOrder = DatePickerDateOrder.dmy,
    this.brightness = Brightness.dark,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  }) : minimumDate = minimumDate ?? DateTime(1920);

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor = textColor ?? COLOR_TEXT;

    return SizedBox(
      height: height,
      width: width,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: brightness,
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: styleTitle(
              color: effectiveTextColor,
              size: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          dateOrder: dateOrder,
          initialDateTime: birthDate,
          maximumDate: maximumDate ?? DateTime.now(),
          minimumDate: minimumDate,
          onDateTimeChanged: (date) {
            onChanged(date);
          },
        ),
      ),
    );
  }
}
