import 'package:flutter/material.dart';

import '../layout/space.dart';
import '../theme/config.dart';

class OnboardingProgressSegments extends StatelessWidget {
  final double progress;
  final int segments;
  final bool showSegments;
  final bool separate;
  final double height;
  final double gap;
  final double separateGap;
  final List<Color>? gradientColors;
  final Color? accentColor;
  final Color? backgroundColor;

  // ignore: prefer_const_constructors_in_immutables
  OnboardingProgressSegments({
    super.key,
    required this.progress,
    this.segments = 5,
    this.showSegments = true,
    this.separate = false,
    this.height = 6,
    this.gap = SPACE_SMALLEST,
    this.separateGap = SPACE_MEDIUM,
    this.gradientColors,
    this.accentColor,
    this.backgroundColor,
  }) : assert(segments > 0),
       assert(height > 0),
       assert(gap >= 0),
       assert(separateGap >= 0),
       assert(gradientColors == null || gradientColors.length >= 2),
       assert(gradientColors == null || accentColor == null);

  @override
  Widget build(BuildContext context) {
    final double safeProgress = progress.isFinite ? progress.clamp(0.0, 1.0) : 0;
    final Color trackColor = backgroundColor ?? COLOR_BACKGROUND_TERCIARY;
    final Color fillColor = accentColor ?? COLOR_ACCENT;
    final int trackCount = showSegments ? segments : 1;
    final double trackGap = showSegments ? gap : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        if (separate) {
          final double visibleGap = safeProgress > 0 && safeProgress < 1
              ? separateGap.clamp(0.0, width)
              : 0;
          final double availableWidth = width - visibleGap;
          final double filledWidth = availableWidth * safeProgress;

          return SizedBox(
            height: height,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  width: filledWidth,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height / 2),
                    color: gradientColors == null ? fillColor : null,
                    gradient: gradientColors == null
                        ? null
                        : LinearGradient(colors: gradientColors!),
                  ),
                ),
                SizedBox(width: visibleGap),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(height / 2),
                    child: SizedBox(
                      height: height,
                      child: ColoredBox(color: trackColor),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final double activeWidth = width * safeProgress;
        final List<Widget> tracks = [];
        final List<Widget> fills = [];

        for (int i = 0; i < trackCount; i++) {
          tracks.add(
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height / 2),
                child: SizedBox(
                  height: height,
                  child: ColoredBox(color: trackColor),
                ),
              ),
            ),
          );
          fills.add(
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height / 2),
                child: SizedBox(
                  height: height,
                  child: ColoredBox(color: fillColor),
                ),
              ),
            ),
          );
          if (i < trackCount - 1) {
            tracks.add(SizedBox(width: trackGap));
            fills.add(SizedBox(width: trackGap));
          }
        }

        Widget filledTrack = Row(children: fills);
        if (gradientColors != null) {
          filledTrack = ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => LinearGradient(
              colors: gradientColors!,
            ).createShader(Rect.fromLTWH(0, 0, activeWidth > 0 ? activeWidth : 1, height)),
            child: filledTrack,
          );
        }

        return SizedBox(
          height: height,
          child: Stack(
            children: [
              Row(children: tracks),
              ClipRect(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  width: activeWidth,
                  child: OverflowBox(
                    alignment: Alignment.centerLeft,
                    minWidth: width,
                    maxWidth: width,
                    child: filledTrack,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
