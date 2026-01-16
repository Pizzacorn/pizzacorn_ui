import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:pizzacorn_ui/src/calendars/calendar_style.dart';

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
  final List<DateTime> blockedDays;
  final List<int> blockedWeekdays;
  final CalendarStyle style;
  final double dayBoxSize;

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
    this.blockedDays = const [],
    this.blockedWeekdays = const [],
    required this.style,
    this.dayBoxSize = 50,
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
    final newMonth = DateTime(currentMonth.year, currentMonth.month + offset, 1);
    final minMonth = DateTime(widget.startDate.year, widget.startDate.month, 1);
    if (newMonth.isBefore(minMonth)) return;
    if (widget.lastDate != null) {
      final maxMonth = DateTime(widget.lastDate!.year, widget.lastDate!.month, 1);
      if (newMonth.isAfter(maxMonth)) return;
    }
    setState(() => currentMonth = newMonth);
    if (widget.onMonthChange != null) widget.onMonthChange!(currentMonth);
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final offset = currentMonth.weekday - 1;
    final List<DateTime?> cells = <DateTime?>[];

    for (int i = 0; i < offset; i++) {
      cells.add(null);
    }
    for (int i = 1; i <= daysInMonth; i++) {
      cells.add(DateTime(currentMonth.year, currentMonth.month, i));
    }

    return Column(
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
                TextSubtitle(formatMonthText.format(currentMonth).toUpperCase()),
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

            final today = DateTime(widget.startDate.year, widget.startDate.month, widget.startDate.day);
            final bool blocked = widget.blockedDays.any((d) => isSameDay(d, day)) ||
                widget.blockedWeekdays.contains(day.weekday) ||
                (widget.lastDate != null && day.isAfter(widget.lastDate!));

            final bool pastDay = day.isBefore(today);
            int highlightedCount = 0;
            for (int i = 0; i < widget.markedDates.length; i++) {
              if (isSameDay(widget.markedDates[i], day)) highlightedCount++;
            }

            final bool isSingleSel = widget.selectionMode == CalendarSelectionMode.single &&
                selectedDay != null && isSameDay(day, selectedDay!);
            final bool isStart = widget.selectionMode == CalendarSelectionMode.range &&
                startSelected != null && isSameDay(day, startSelected!);
            final bool isEnd = widget.selectionMode == CalendarSelectionMode.range &&
                endSelected != null && isSameDay(day, endSelected!);
            final bool inRange = widget.selectionMode == CalendarSelectionMode.range &&
                startSelected != null && endSelected != null &&
                day.isAfter(startSelected!) && day.isBefore(endSelected!);

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
            } else if (pastDay && !widget.style.showPastHighlighted) {
              bg = widget.style.backgroundPast;
              txt = widget.style.textPast;
              bc = widget.style.borderPast;
            } else if (highlightedCount > 0) {
              if (pastDay && widget.style.showPastHighlighted) {
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
                radius = BorderRadius.only(topLeft: Radius.circular(RADIUS), bottomLeft: Radius.circular(RADIUS));
              } else if (!isStart && isEnd) {
                radius = BorderRadius.only(topRight: Radius.circular(RADIUS), bottomRight: Radius.circular(RADIUS));
              } else if (inRange) {
                radius = BorderRadius.zero;
              }
            }

            return GestureDetector(
              onTap: blocked ? null : () {
                if (widget.selectionMode == CalendarSelectionMode.single) {
                  setState(() => selectedDay = day);
                  if (widget.onDaySelected != null) widget.onDaySelected!(day);
                } else {
                  if (startSelected == null || endSelected != null) {
                    setState(() { startSelected = day; endSelected = null; });
                  } else if (day.isBefore(startSelected!)) {
                    setState(() => startSelected = day);
                  } else {
                    setState(() => endSelected = day);
                    if (widget.onRangeSelected != null) {
                      widget.onRangeSelected!(DateTimeRange(start: startSelected!, end: endSelected!));
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
                      child: TextBody('${day.day}', fontWeight: FontWeight.w600, color: txt),
                    ),
                    if (highlightedCount > 0 && widget.style.showHighlightedCircle)
                      Positioned(
                        right: 2, top: 2,
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
                              '$highlightedCount',
                              color: widget.style.highlightedCircle.textColor,
                              fontSize: widget.style.highlightedCircle.textSize,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}