import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

typedef MonthlyCalendarEventIndicatorBuilder =
    Widget Function(DateTime day, int eventCount);
typedef MonthlyCalendarEventIndicatorColorBuilder =
    Color Function(DateTime day, int eventCount);
typedef MonthlyCalendarTypedEventIndicatorBuilder =
    Widget Function(
      DateTime day,
      List<MonthlyCalendarEvent> eventList,
      int markedCount,
    );

class MonthlyCalendarEvent {
  final DateTime date;
  final String type;
  final int count;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? child;

  MonthlyCalendarEvent({
    DateTime? date,
    this.type = '',
    this.count = 1,
    this.backgroundColor,
    this.textColor,
    this.child,
  }) : date = date ?? DateTime(2000);
}

class MonthlyCalendar extends StatefulWidget {
  final DateTime startDate;
  final DateTime? lastDate;
  final CalendarSelectionMode selectionMode;
  final DateTime initialDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final ValueChanged<DateTime>? onDaySelected;
  final ValueChanged<DateTimeRange>? onRangeSelected;
  final ValueChanged<DateTime>? onMonthChange;
  final List<DateTime> markedDates;
  final List<MonthlyCalendarEvent> events;
  final List<DateTime> blockedDays;
  final List<int> blockedWeekdays;
  final CalendarStyle style;
  final double dayBoxSize;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? eventIndicatorBackgroundColor;
  final Color? eventIndicatorTextColor;
  final MonthlyCalendarEventIndicatorColorBuilder?
      eventIndicatorBackgroundColorBuilder;
  final MonthlyCalendarEventIndicatorColorBuilder?
      eventIndicatorTextColorBuilder;
  final MonthlyCalendarEventIndicatorBuilder? eventIndicatorBuilder;
  final Map<String, Color> eventIndicatorBackgroundColors;
  final Map<String, Color> eventIndicatorTextColors;
  final MonthlyCalendarTypedEventIndicatorBuilder? typedEventIndicatorBuilder;

  MonthlyCalendar({
    super.key,
    required this.startDate,
    this.lastDate,
    this.selectionMode = CalendarSelectionMode.single,
    required this.initialDate,
    this.initialStartDate,
    this.initialEndDate,
    this.onDaySelected,
    this.onRangeSelected,
    this.onMonthChange,
    this.markedDates = const [],
    this.events = const [],
    this.blockedDays = const [],
    this.blockedWeekdays = const [],
    required this.style,
    this.dayBoxSize = 50,
    this.padding,
    this.backgroundColor,
    this.eventIndicatorBackgroundColor,
    this.eventIndicatorTextColor,
    this.eventIndicatorBackgroundColorBuilder,
    this.eventIndicatorTextColorBuilder,
    this.eventIndicatorBuilder,
    this.eventIndicatorBackgroundColors = const {},
    this.eventIndicatorTextColors = const {},
    this.typedEventIndicatorBuilder,
  });

  @override
  State<MonthlyCalendar> createState() => MonthlyCalendarState();
}

class MonthlyCalendarState extends State<MonthlyCalendar> {
  late DateTime currentMonth;
  DateTime? selectedDay;
  DateTime? startSelected;
  DateTime? endSelected;

  DateFormat formatMonthText = DateFormat("MMMM", "es_ES");
  DateFormat formatYear = DateFormat("yyyy", "es_ES");

  @override
  void initState() {
    super.initState();
    final base = widget.selectionMode == CalendarSelectionMode.single
        ? widget.initialDate
        : (widget.initialStartDate ?? widget.initialDate);

    currentMonth = DateTime(base.year, base.month, 1);

    if (widget.selectionMode == CalendarSelectionMode.single) {
      selectedDay = widget.initialDate;
    } else {
      startSelected = widget.initialStartDate ?? widget.initialDate;
      endSelected = widget.initialEndDate;
    }
  }

  void changeMonth(int offset) {
    final newMonth = DateTime(
      currentMonth.year,
      currentMonth.month + offset,
      1,
    );
    final minMonth = DateTime(widget.startDate.year, widget.startDate.month, 1);
    if (newMonth.isBefore(minMonth)) return;
    if (widget.lastDate != null) {
      final maxMonth = DateTime(
        widget.lastDate!.year,
        widget.lastDate!.month,
        1,
      );
      if (newMonth.isAfter(maxMonth)) return;
    }
    setState(() => currentMonth = newMonth);
    if (widget.onMonthChange != null) widget.onMonthChange!(currentMonth);
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<MonthlyCalendarEvent> getEventsForDay(DateTime day) {
    final List<MonthlyCalendarEvent> eventList = <MonthlyCalendarEvent>[];
    for (int i = 0; i < widget.events.length; i++) {
      if (isSameDay(widget.events[i].date, day)) {
        eventList.add(widget.events[i]);
      }
    }
    return eventList;
  }

  Widget buildEventIndicator(DateTime day, int eventCount) {
    if (widget.eventIndicatorBuilder != null) {
      return widget.eventIndicatorBuilder!(day, eventCount);
    }

    final Color backgroundColor =
        widget.eventIndicatorBackgroundColorBuilder?.call(day, eventCount) ??
        widget.eventIndicatorBackgroundColor ??
        widget.style.highlightedCircle.background;
    final Color textColor =
        widget.eventIndicatorTextColorBuilder?.call(day, eventCount) ??
        widget.eventIndicatorTextColor ??
        widget.style.highlightedCircle.textColor;

    return Container(
      width: widget.style.highlightedCircle.size,
      height: widget.style.highlightedCircle.size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.style.highlightedCircle.border.color,
          width: widget.style.highlightedCircle.border.width,
        ),
      ),
      child: Center(
        child: TextSmall(
          '$eventCount',
          color: textColor,
          fontSize: widget.style.highlightedCircle.textSize,
        ),
      ),
    );
  }

  Widget buildTypedEventIndicator(
    DateTime day,
    List<MonthlyCalendarEvent> eventList,
    int markedCount,
  ) {
    if (widget.typedEventIndicatorBuilder != null) {
      return widget.typedEventIndicatorBuilder!(day, eventList, markedCount);
    }

    if (eventList.isEmpty && markedCount > 0) {
      return buildEventIndicator(day, markedCount);
    }

    final List<Widget> indicatorList = <Widget>[];

    if (markedCount > 0) {
      indicatorList.add(buildEventIndicator(day, markedCount));
    }

    for (int i = 0; i < eventList.length; i++) {
      final MonthlyCalendarEvent event = eventList[i];
      final int eventCount = event.count < 1 ? 1 : event.count;
      final Color backgroundColor =
          event.backgroundColor ??
          widget.eventIndicatorBackgroundColors[event.type] ??
          widget.eventIndicatorBackgroundColorBuilder?.call(day, eventCount) ??
          widget.eventIndicatorBackgroundColor ??
          widget.style.highlightedCircle.background;
      final Color textColor =
          event.textColor ??
          widget.eventIndicatorTextColors[event.type] ??
          widget.eventIndicatorTextColorBuilder?.call(day, eventCount) ??
          widget.eventIndicatorTextColor ??
          widget.style.highlightedCircle.textColor;

      indicatorList.add(
        Container(
          width: widget.style.highlightedCircle.size,
          height: widget.style.highlightedCircle.size,
          margin: EdgeInsets.only(left: indicatorList.isEmpty ? 0 : 2),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.style.highlightedCircle.border.color,
              width: widget.style.highlightedCircle.border.width,
            ),
          ),
          child: Center(
            child:
                event.child ??
                TextSmall(
                  '$eventCount',
                  color: textColor,
                  fontSize: widget.style.highlightedCircle.textSize,
                ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: indicatorList,
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    ).day;
    final offset = currentMonth.weekday - 1;
    final List<DateTime?> cells = <DateTime?>[];

    for (int i = 0; i < offset; i++) {
      cells.add(null);
    }
    for (int i = 1; i <= daysInMonth; i++) {
      cells.add(DateTime(currentMonth.year, currentMonth.month, i));
    }

    final calendarContent = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 16, color: COLOR_TEXT),
              onPressed: () => changeMonth(-1),
            ),
            Column(
              children: [
                TextSubtitle(
                  formatMonthText.format(currentMonth).toUpperCase(),
                ),
                TextCaption(formatYear.format(currentMonth)),
              ],
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 16, color: COLOR_TEXT),
              onPressed: () => changeMonth(1),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            for (int i = 0; i < 7; i++)
              Expanded(
                child: Center(
                  child: TextCaption(['L', 'M', 'X', 'J', 'V', 'S', 'D'][i]),
                ),
              ),
          ],
        ),
        Space(PADDING_SMALL_SIZE),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: cells.length,
          itemBuilder: (context, idx) {
            final day = cells[idx];
            if (day == null) return Container();

            // 📅 Normalizamos la fecha de inicio para comparar solo fechas sin horas
            final today = DateTime(
              widget.startDate.year,
              widget.startDate.month,
              widget.startDate.day,
            );

            // 🚫 Un día es pasado si es estrictamente anterior a widget.startDate (today)
            final bool isPast = day.isBefore(today);

            final bool blocked =
                isPast || // 🚫 Bloqueo de días pasados a startDate
                    widget.blockedDays.any((d) => isSameDay(d, day)) ||
                    widget.blockedWeekdays.contains(day.weekday) ||
                    (widget.lastDate != null && day.isAfter(widget.lastDate!));

            int highlightedCount = 0;
            for (int i = 0; i < widget.markedDates.length; i++) {
              if (isSameDay(widget.markedDates[i], day)) highlightedCount++;
            }
            final List<MonthlyCalendarEvent> eventList = getEventsForDay(day);
            final bool hasHighlightedEvents =
                highlightedCount > 0 || eventList.isNotEmpty;

            final bool isSingleSel =
                widget.selectionMode == CalendarSelectionMode.single &&
                    selectedDay != null &&
                    isSameDay(day, selectedDay!);
            final bool isStart =
                widget.selectionMode == CalendarSelectionMode.range &&
                    startSelected != null &&
                    isSameDay(day, startSelected!);
            final bool isEnd =
                widget.selectionMode == CalendarSelectionMode.range &&
                    endSelected != null &&
                    isSameDay(day, endSelected!);
            final bool inRange =
                widget.selectionMode == CalendarSelectionMode.range &&
                    startSelected != null &&
                    endSelected != null &&
                    day.isAfter(startSelected!) &&
                    day.isBefore(endSelected!);

            var bg = widget.style.backgroundUnselected;
            var txt = widget.style.textUnselected;
            var bc = widget.style.borderUnselected;
            var bw = widget.style.borderWidthUnselected;

            if (blocked) {
              bg = widget.style.backgroundBlocked;
              txt = widget.style.textBlocked;
            } else if (isSingleSel || isStart || isEnd) {
              bg = widget.style.backgroundSelected;
              txt = widget.style.textSelected;
              bc = widget.style.borderSelected;
              bw = widget.style.borderWidthSelected;
            } else if (inRange) {
              bg = widget.style.backgroundRange;
              txt = widget.style.textRange;
              bc = widget.style.borderRange;
              bw = widget.style.borderWidthRange;
            } else if (isPast && !widget.style.showPastHighlighted) {
              bg = widget.style.backgroundPast;
              txt = widget.style.textPast;
              bc = widget.style.borderPast;
            } else if (hasHighlightedEvents) {
              if (isPast && widget.style.showPastHighlighted) {
                bg = widget.style.pastHighlightedBackground;
                txt = widget.style.pastHighlightedTextColor;
                bc = widget.style.pastHighlightedBorderColor;
                bw = widget.style.pastHighlightedBorderWidth;
              } else {
                bg = widget.style.backgroundHighlighted;
                txt = widget.style.textHighlighted;
                bc = widget.style.borderHighlighted;
                bw = widget.style.borderWidthHighlighted;
              }
            }

            BorderRadius radius = BorderRadius.circular(RADIUS);
            if (widget.selectionMode == CalendarSelectionMode.range) {
              if (isStart && !isEnd) {
                radius = BorderRadius.only(
                  topLeft: Radius.circular(RADIUS),
                  bottomLeft: Radius.circular(RADIUS),
                );
              } else if (!isStart && isEnd) {
                radius = BorderRadius.only(
                  topRight: Radius.circular(RADIUS),
                  bottomRight: Radius.circular(RADIUS),
                );
              } else if (inRange) {
                radius = BorderRadius.zero;
              }
            }

            return GestureDetector(
              onTap: blocked
                  ? null
                  : () {
                      if (widget.selectionMode ==
                          CalendarSelectionMode.single) {
                        setState(() => selectedDay = day);
                        if (widget.onDaySelected != null) {
                          widget.onDaySelected!(day);
                        }
                      } else {
                        if (startSelected == null || endSelected != null) {
                          setState(() {
                            startSelected = day;
                            endSelected = null;
                          });
                        } else if (day.isBefore(startSelected!)) {
                          setState(() => startSelected = day);
                        } else {
                          setState(() => endSelected = day);
                          if (widget.onRangeSelected != null) {
                            widget.onRangeSelected!(
                              DateTimeRange(
                                start: startSelected!,
                                end: endSelected!,
                              ),
                            );
                          }
                        }
                      }
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  border: Border.all(color: bc, width: bw),
                  borderRadius: radius,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: TextBody(
                        '${day.day}',
                        fontWeight: FontWeight.w600,
                        color: txt,
                      ),
                    ),
                    if (hasHighlightedEvents &&
                        widget.style.showHighlightedCircle)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: buildTypedEventIndicator(
                          day,
                          eventList,
                          highlightedCount,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );

    if (widget.padding == null && widget.backgroundColor == null) {
      return calendarContent;
    }

    return Container(
      padding: widget.padding,
      color: widget.backgroundColor,
      child: calendarContent,
    );
  }
}
