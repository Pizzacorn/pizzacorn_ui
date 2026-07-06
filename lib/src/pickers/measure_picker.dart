import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:tape_slider/tape_slider.dart';

enum MeasurePickerType { horizontal, vertical }

class MeasurePickerCustom extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final double division;
  final String unit;
  final MeasurePickerType type;
  final ValueChanged<double> onChanged;
  final double height;
  final double verticalHeight;
  final Color? valueColor;
  final Color? unitColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? minorLabelColor;
  final Color? majorLabelColor;
  final Color? indicatorColor;
  final double valueFontSize;
  final double unitFontSize;
  final FontWeight valueFontWeight;
  final FontWeight unitFontWeight;
  final double itemExtent;
  final double trackHeight;
  final double trackWidth;
  final double indicatorThickness;
  final int tickInterval;
  final int? labelInterval;
  final double slidingAreaExtent;
  final bool showLabels;

  MeasurePickerCustom({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.division,
    required this.unit,
    required this.type,
    required this.onChanged,
    this.height = 300,
    this.verticalHeight = 430,
    this.valueColor,
    this.unitColor,
    this.activeColor,
    this.inactiveColor,
    this.minorLabelColor,
    this.majorLabelColor,
    this.indicatorColor,
    this.valueFontSize = 42,
    this.unitFontSize = 28,
    this.valueFontWeight = FontWeight.w800,
    this.unitFontWeight = FontWeight.w800,
    this.itemExtent = 13,
    this.trackHeight = 125,
    this.trackWidth = double.infinity,
    this.indicatorThickness = 3,
    this.tickInterval = 1,
    this.labelInterval,
    this.slidingAreaExtent = 92,
    this.showLabels = false,
  });

  @override
  MeasurePickerCustomState createState() => MeasurePickerCustomState();
}

class MeasurePickerCustomState extends State<MeasurePickerCustom>
    with SingleTickerProviderStateMixin {
  late double currentValue;
  late AnimationController slideController;
  Animation<double>? slideAnimation;

  @override
  void initState() {
    super.initState();
    currentValue = snapValue(widget.value);
    slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 420),
    );
  }

  @override
  void didUpdateWidget(covariant MeasurePickerCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    final double nextValue = snapValue(widget.value);
    if (nextValue != currentValue) {
      currentValue = nextValue;
    }
  }

  @override
  void dispose() {
    slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double safeValue = currentValue;
    final String displayValue = safeValue % 1 == 0
        ? safeValue.toInt().toString()
        : safeValue.toStringAsFixed(1).replaceAll(".", ",");
    final bool isVertical = widget.type == MeasurePickerType.vertical;
    final Color effectiveValueColor = widget.valueColor ?? COLOR_TEXT;
    final Color effectiveUnitColor = widget.unitColor ?? COLOR_SUBTEXT;

    return SizedBox(
      height: isVertical ? widget.verticalHeight : widget.height,
      width: double.infinity,
      child: Column(
        children: [
          Space(SPACE_BIG),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextBig(
                displayValue,
                color: effectiveValueColor,
                fontSize: widget.valueFontSize,
                fontWeight: widget.valueFontWeight,
              ),
              Padding(
                padding: EdgeInsets.only(left: 6, bottom: 5),
                child: TextCustom(
                  widget.unit,
                  color: effectiveUnitColor,
                  fontSize: widget.unitFontSize,
                  fontWeight: widget.unitFontWeight,
                ),
              ),
            ],
          ),
          Space(SPACE_MEDIUM),
          Expanded(
            child: Center(
              child: isVertical
                  ? buildVerticalPicker()
                  : buildHorizontalPicker(safeValue),
            ),
          ),
          Space(SPACE_MEDIUM),
        ],
      ),
    );
  }

  Widget buildHorizontalPicker(double safeValue) {
    final Color effectiveActiveColor = widget.activeColor ?? COLOR_TEXT;
    final Color effectiveInactiveColor =
        widget.inactiveColor ?? COLOR_TEXT.withValues(alpha: 0.26);
    final Color effectiveMinorLabelColor =
        widget.minorLabelColor ?? COLOR_TEXT.withValues(alpha: 0.55);
    final Color effectiveMajorLabelColor = widget.majorLabelColor ?? COLOR_TEXT;
    final Color effectiveIndicatorColor = widget.indicatorColor ?? COLOR_ACCENT;

    return TapeSlider(
      initialValue: safeValue,
      minValue: widget.min,
      maxValue: widget.max,
      orientation: Axis.horizontal,
      itemExtent: widget.itemExtent,
      activeColor: effectiveActiveColor,
      inactiveColor: effectiveInactiveColor,
      trackHeight: widget.trackHeight,
      trackWidth: widget.trackWidth,
      majorTickLabelStyle: styleSmall(color: effectiveMajorLabelColor),
      minorTickLabelStyle: styleSmall(color: effectiveMinorLabelColor),
      showLabels: widget.showLabels,
      indicatorThickness: widget.indicatorThickness,
      indicatorColor: effectiveIndicatorColor,
      tickInterval: widget.tickInterval,
      labelInterval: widget.labelInterval ?? (widget.unit == "cm" ? 10 : 5),
      slidingAreaExtent: widget.slidingAreaExtent,
      onValueChanged: (newValue) {
        updateValue(newValue);
      },
    );
  }

  Widget buildVerticalPicker() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (details) {
        slideController.stop();
      },
      onVerticalDragUpdate: (details) {
        final double rawValue =
            currentValue + (details.delta.dy / 10 * widget.division);
        updateValue(rawValue);
      },
      onVerticalDragEnd: (details) {
        animateVerticalMomentum(details.primaryVelocity ?? 0);
      },
      child: SizedBox(
        height: 220,
        width: 125,
        child: CustomPaint(
          painter: VerticalMeasurePainterCustom(
            value: currentValue,
            min: widget.min,
            max: widget.max,
            division: widget.division,
            itemExtent: 10,
            inactiveColor:
                widget.inactiveColor ?? COLOR_TEXT.withValues(alpha: 0.26),
            activeColor:
                widget.activeColor ?? COLOR_TEXT.withValues(alpha: 0.55),
            indicatorColor: widget.indicatorColor ?? COLOR_ACCENT,
            indicatorThickness: widget.indicatorThickness,
          ),
        ),
      ),
    );
  }

  void animateVerticalMomentum(double velocity) {
    if (velocity.abs() < 120) {
      return;
    }

    final double valueVelocity = (velocity / 10) * widget.division;
    final double distance = (valueVelocity * 0.18).clamp(-36, 36).toDouble();
    final double startValue = currentValue;
    final double endValue = snapValue(currentValue + distance);

    if (startValue == endValue) {
      return;
    }

    slideAnimation = Tween<double>(begin: startValue, end: endValue).animate(
      CurvedAnimation(parent: slideController, curve: Curves.decelerate),
    );

    slideController
      ..duration = Duration(
        milliseconds: (260 + velocity.abs().clamp(0, 1800) * 0.16).round(),
      )
      ..reset();

    void listener() {
      final Animation<double>? animation = slideAnimation;
      if (animation == null) {
        return;
      }

      final double nextValue = snapValue(animation.value);
      if (nextValue == currentValue) {
        return;
      }

      setState(() {
        currentValue = nextValue;
      });
      widget.onChanged(nextValue);
    }

    slideController.addListener(listener);
    slideController.forward().whenComplete(() {
      slideController.removeListener(listener);
    });
  }

  void updateValue(double rawValue) {
    final double snappedValue = snapValue(rawValue);

    if (snappedValue == currentValue) {
      return;
    }

    setState(() {
      currentValue = snappedValue;
    });
    widget.onChanged(snappedValue);
  }

  double snapValue(double rawValue) {
    final double clampedValue = rawValue
        .clamp(widget.min, widget.max)
        .toDouble();
    final int steps = ((clampedValue - widget.min) / widget.division).round();
    final double snappedValue = widget.min + (steps * widget.division);

    return snappedValue.clamp(widget.min, widget.max).toDouble();
  }
}

class VerticalMeasurePainterCustom extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final double division;
  final double itemExtent;
  final Color inactiveColor;
  final Color activeColor;
  final Color indicatorColor;
  final double indicatorThickness;

  VerticalMeasurePainterCustom({
    required this.value,
    required this.min,
    required this.max,
    required this.division,
    required this.itemExtent,
    required this.inactiveColor,
    required this.activeColor,
    required this.indicatorColor,
    required this.indicatorThickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerY = size.height / 2;
    final Paint minorPaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = 1;
    final Paint majorPaint = Paint()
      ..color = activeColor
      ..strokeWidth = 1.4;
    final Paint indicatorPaint = Paint()
      ..color = indicatorColor
      ..strokeWidth = indicatorThickness
      ..strokeCap = StrokeCap.round;

    final int totalSteps = ((max - min) / division).round();

    for (int i = 0; i <= totalSteps; i++) {
      final double tickValue = min + (i * division);
      final double y = centerY - ((tickValue - value) / division * itemExtent);

      if (y < 0 || y > size.height) {
        continue;
      }

      final bool isMajor = tickValue % 10 == 0;
      final double tickWidth = isMajor ? 48 : 35;
      final Paint tickPaint = isMajor ? majorPaint : minorPaint;
      final double startX = (size.width - tickWidth) / 2;
      final double endX = startX + tickWidth;

      canvas.drawLine(Offset(startX, y), Offset(endX, y), tickPaint);
    }

    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant VerticalMeasurePainterCustom oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.min != min ||
        oldDelegate.max != max ||
        oldDelegate.division != division ||
        oldDelegate.itemExtent != itemExtent ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.indicatorColor != indicatorColor ||
        oldDelegate.indicatorThickness != indicatorThickness;
  }
}
