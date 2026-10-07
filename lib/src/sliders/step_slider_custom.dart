import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/config.dart';

/// Selector discreto con pista, gradiente y etiquetas configurables.
class StepSliderCustom extends StatefulWidget {
  final int steps;
  final int selectedStep;
  final ValueChanged<int> onChanged;
  final List<String> optionLabels;
  final TextStyle? optionTextStyle;
  final TextStyle? selectedOptionTextStyle;
  final bool showAllOptionLabels;
  final Color? selectedColor;
  final Color? unselectedColor;
  final bool selectedGradient;
  final bool selectedGradientAnimated;
  final List<Color> selectedGradientColors;
  final Color? thumbColor;
  final bool thumbBorder;
  final Color? thumbBorderColor;
  final double thumbBorderWidth;
  final double thumbRadius;
  final double trackHeight;
  final Color? stepColor;
  final double stepWidth;
  final double stepHeight;

  StepSliderCustom({
    super.key,
    required this.steps,
    required this.selectedStep,
    required this.onChanged,
    required this.optionLabels,
    this.optionTextStyle,
    this.selectedOptionTextStyle,
    this.showAllOptionLabels = false,
    this.selectedColor,
    this.unselectedColor,
    this.selectedGradient = false,
    this.selectedGradientAnimated = false,
    this.selectedGradientColors = const [],
    this.thumbColor,
    this.thumbBorder = false,
    this.thumbBorderColor,
    this.thumbBorderWidth = 1.5,
    this.thumbRadius = 12,
    this.trackHeight = 6,
    this.stepColor,
    this.stepWidth = 1.5,
    this.stepHeight = 10,
  }) : assert(steps > 0),
       assert(selectedStep >= 0 && selectedStep <= steps),
       assert(optionLabels.length == steps + 1),
       assert(selectedGradientColors.length != 1),
       assert(thumbBorderWidth >= 0),
       assert(thumbRadius > 0),
       assert(trackHeight > 0),
       assert(stepWidth >= 0),
       assert(stepHeight >= 0);

  @override
  State<StepSliderCustom> createState() => StepSliderCustomState();
}

class StepSliderCustomState extends State<StepSliderCustom>
    with SingleTickerProviderStateMixin {
  late final AnimationController gradientController;

  @override
  void initState() {
    super.initState();
    gradientController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2600),
    );
    updateGradientAnimation();
  }

  @override
  void didUpdateWidget(StepSliderCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGradient != widget.selectedGradient ||
        oldWidget.selectedGradientAnimated != widget.selectedGradientAnimated) {
      updateGradientAnimation();
    }
  }

  void updateGradientAnimation() {
    if (widget.selectedGradient && widget.selectedGradientAnimated) {
      gradientController.repeat();
    } else {
      gradientController.stop();
      gradientController.value = 0;
    }
  }

  @override
  void dispose() {
    gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.selectedColor ?? COLOR_ACCENT;
    final inactiveColor = widget.unselectedColor ?? COLOR_BACKGROUND_SECONDARY;
    final gradientColors = widget.selectedGradientColors.isEmpty
        ? [COLOR_ACCENT, COLOR_ACCENT_SECONDARY]
        : widget.selectedGradientColors;
    final defaultTextStyle = TextStyle(color: COLOR_SUBTEXT, fontSize: 11);

    return Column(
      children: [
        SizedBox(
          height: math.max(44, widget.thumbRadius * 2 + 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = math.max(
                0.0,
                constraints.maxWidth - widget.thumbRadius * 2,
              );
              final progress = widget.selectedStep / widget.steps;
              return AnimatedBuilder(
                animation: gradientController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Positioned(
                        left: widget.thumbRadius,
                        right: widget.thumbRadius,
                        child: Container(
                          height: widget.trackHeight,
                          color: inactiveColor,
                        ),
                      ),
                      Positioned(
                        left: widget.thumbRadius,
                        width: trackWidth * progress,
                        child: Container(
                          height: widget.trackHeight,
                          decoration: BoxDecoration(
                            color: widget.selectedGradient ? null : activeColor,
                            gradient: widget.selectedGradient
                                ? LinearGradient(
                                    colors: gradientColors,
                                    transform: widget.selectedGradientAnimated
                                        ? GradientRotation(
                                            gradientController.value * 2 * math.pi,
                                          )
                                        : null,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      for (int i = 0; i <= widget.steps; i++)
                        Positioned(
                          left: widget.thumbRadius +
                              trackWidth * i / widget.steps -
                              widget.stepWidth / 2,
                          child: Container(
                            width: widget.stepWidth,
                            height: widget.stepHeight,
                            color: widget.stepColor ?? COLOR_BORDER,
                          ),
                        ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.thumbRadius,
                          ),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 0,
                              activeTrackColor: Colors.transparent,
                              inactiveTrackColor: Colors.transparent,
                              thumbShape: SliderComponentShape.noThumb,
                              overlayShape: SliderComponentShape.noOverlay,
                              tickMarkShape: SliderTickMarkShape.noTickMark,
                              showValueIndicator: ShowValueIndicator.never,
                            ),
                            child: Slider(
                              value: widget.selectedStep.toDouble(),
                              min: 0,
                              max: widget.steps.toDouble(),
                              divisions: widget.steps,
                              label: widget.optionLabels[widget.selectedStep],
                              onChanged: (value) {
                                final step = value.round();
                                if (step != widget.selectedStep) {
                                  widget.onChanged(step);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: widget.thumbRadius +
                            trackWidth * progress -
                            widget.thumbRadius,
                        child: IgnorePointer(
                          child: Container(
                            width: widget.thumbRadius * 2,
                            height: widget.thumbRadius * 2,
                            decoration: BoxDecoration(
                              color: widget.thumbColor ?? COLOR_BACKGROUND,
                              shape: BoxShape.circle,
                              border: widget.thumbBorder
                                  ? Border.all(
                                      color: widget.thumbBorderColor ?? activeColor,
                                      width: widget.thumbBorderWidth,
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: COLOR_SHADOW.withValues(alpha: 0.2),
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < widget.optionLabels.length; i++)
              if (widget.showAllOptionLabels ||
                  i == 0 ||
                  i == widget.optionLabels.length - 1)
                Flexible(
                  child: Text(
                    widget.optionLabels[i],
                    style: i == widget.selectedStep
                        ? widget.selectedOptionTextStyle ??
                            widget.optionTextStyle ??
                            defaultTextStyle
                        : widget.optionTextStyle ?? defaultTextStyle,
                    textAlign: i == 0
                        ? TextAlign.left
                        : i == widget.steps
                            ? TextAlign.right
                            : TextAlign.center,
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
