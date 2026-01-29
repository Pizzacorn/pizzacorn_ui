import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:pizzacorn_ui/src/calendars/calendar_style.dart';

/// Slider de calendario horizontal infinito al estilo Pizzacorn
class SliderCalendar extends StatefulWidget {
  final DateTime startDate;
  final DateTime? lastDate;
  final CalendarSelectionMode selectionMode;

  final DateTime initialDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  final List<DateTime> markedDates;
  final List<DateTime> blockedDays;
  final List<int> blockedWeekdays;

  final CalendarStyle style;
  final double dayBoxSize;

  final void Function(DateTime)? onDaySelected;
  final void Function(DateTimeRange)? onRangeSelected;
  final void Function(DateTime)? onMonthChange;

  SliderCalendar({
    super.key,
    required this.startDate,
    this.lastDate,
    this.selectionMode = CalendarSelectionMode.single,
    required this.initialDate,
    this.initialStartDate,
    this.initialEndDate,
    this.markedDates = const [],
    this.blockedDays = const [],
    this.blockedWeekdays = const [],
    required this.style,
    this.dayBoxSize = 50,
    this.onDaySelected,
    this.onRangeSelected,
    this.onMonthChange,
  });

  @override
  State<SliderCalendar> createState() => SliderCalendarState();
}

class SliderCalendarState extends State<SliderCalendar> {
  late List<DateTime> days;
  int selectedIndex = 0;
  late ScrollController scrollController; // REGLA: Sin guion bajo
  DateTime? lastNotifiedMonth;
  double spacing = 5.0;
  int currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    // Generamos los primeros 60 días
    days = <DateTime>[];
    for (int i = 0; i < 60; i++) {
      days.add(widget.startDate.add(Duration(days: i)));
    }

    // Buscamos el índice inicial
    for (int i = 0; i < days.length; i++) {
      if (isSameDay(days[i], widget.initialDate)) {
        selectedIndex = i;
        break;
      }
    }

    currentMonth = widget.initialDate.month;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedIndex >= 0) {
        scrollController.jumpTo(selectedIndex * (widget.dayBoxSize + spacing));
      }
    });

    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void onScroll() {
    // 🔁 Carga infinita: REGLA bucle con índice no aplica aquí por lógica de scroll,
    // pero sí en la generación de datos.
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 500) {
      final DateTime last = days.last;
      for (int i = 1; i <= 30; i++) {
        days.add(last.add(Duration(days: i)));
      }
      setState(() {});
    }

    // 🧠 Detectar mes visible
    for (int i = 0; i < days.length; i++) {
      final double itemOffset = i * (widget.dayBoxSize + spacing);
      final double itemEnd = itemOffset + widget.dayBoxSize;

      if (itemOffset >= scrollController.offset &&
          itemEnd <=
              scrollController.offset +
                  scrollController.position.viewportDimension) {
        final DateTime visibleDay = days[i];
        if (visibleDay.month != currentMonth) {
          setState(() => currentMonth = visibleDay.month);
          if (widget.onMonthChange != null) {
            widget.onMonthChange!(
              DateTime(visibleDay.year, visibleDay.month, 1),
            );
          }
        }
        break;
      }
    }
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool isToday(DateTime d) => isSameDay(d, DateTime.now());

  void onTap(int idx) {
    final day = days[idx];
    bool isBlocked =
        widget.blockedDays.any((d) => isSameDay(d, day)) ||
        widget.blockedWeekdays.contains(day.weekday) ||
        (widget.lastDate != null && day.isAfter(widget.lastDate!)) ||
        day.isBefore(widget.startDate);

    if (isBlocked && !isToday(day)) return;

    setState(() => selectedIndex = idx);
    scrollController.animateTo(
      idx * (widget.dayBoxSize + spacing),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    if (widget.onDaySelected != null) widget.onDaySelected!(day);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.dayBoxSize,
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.only(left: DOUBLE_PADDING),
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, i) {
          final DateTime d = days[i];

          bool isBlocked =
              widget.blockedDays.any((b) => isSameDay(b, d)) ||
              widget.blockedWeekdays.contains(d.weekday) ||
              (widget.lastDate != null && d.isAfter(widget.lastDate!)) ||
              d.isBefore(widget.startDate);

          if (isToday(d)) isBlocked = false;

          int markedCount = 0;
          for (int j = 0; j < widget.markedDates.length; j++) {
            if (isSameDay(widget.markedDates[j], d)) markedCount++;
          }

          final bool isSel = i == selectedIndex;

          var bg = widget.style.backgroundUnselected;
          var txt = widget.style.textUnselected;
          var brd = widget.style.borderUnselected;
          var bw = widget.style.borderWidthUnselected;

          if (isBlocked) {
            bg = widget.style.backgroundBlocked;
            txt = widget.style.textBlocked;
          } else if (isSel) {
            bg = widget.style.backgroundSelected;
            txt = widget.style.textSelected;
            brd = widget.style.borderSelected;
            bw = widget.style.borderWidthSelected;
          } else if (markedCount > 0) {
            bg = widget.style.backgroundHighlighted;
            txt = widget.style.textHighlighted;
            brd = widget.style.borderHighlighted;
            bw = widget.style.borderWidthHighlighted;
          }

          return GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              width: widget.dayBoxSize,
              height: widget.dayBoxSize,
              margin: EdgeInsets.only(right: spacing),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(
                  RADIUS,
                ), // Usando token global
                border: Border.all(color: brd, width: bw),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextCaption(
                          [
                            'Lun',
                            'Mar',
                            'Mié',
                            'Jue',
                            'Vie',
                            'Sáb',
                            'Dom',
                          ][d.weekday - 1],
                          color: txt,
                        ),
                        TextSubtitle(
                          '${d.day}',
                          color: txt,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  if (markedCount > 0 && widget.style.showHighlightedCircle)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: widget.style.highlightedCircle.size,
                        height: widget.style.highlightedCircle.size,
                        decoration: BoxDecoration(
                          color: widget.style.highlightedCircle.background,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.style.highlightedCircle.border.color,
                            width: widget.style.highlightedCircle.border.width,
                          ),
                        ),
                        child: Center(
                          child: TextSmall(
                            '$markedCount',
                            color: widget.style.highlightedCircle.textColor,
                            fontSize: widget.style.highlightedCircle.textSize,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
