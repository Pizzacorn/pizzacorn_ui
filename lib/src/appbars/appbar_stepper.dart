import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

PreferredSizeWidget AppbarStepper({
  required BuildContext context,
  String title = "",
  Color? color,
  Color? textColor,
  Color? iconColor,
  PageController? pageController,
  int pageCount = 0,
  bool goToLogin = false,
  Widget? loginPage,
  VoidCallback? onBack,
}) {
  final Color effectiveColor = color ?? COLOR_BACKGROUND;
  final Color effectiveTextColor = textColor ?? COLOR_TEXT;
  final Color effectiveIconColor = iconColor ?? COLOR_TEXT;

  return AppBar(
    toolbarHeight: 80,
    backgroundColor: effectiveColor,
    elevation: 0,
    centerTitle: false,
    titleSpacing: 0,
    leading: IconButton(
      splashColor: COLOR_ACCENT.withValues(alpha: 0.2),
      highlightColor: COLOR_ACCENT.withValues(alpha: 0.2),
      onPressed: () {
        if (onBack != null) {
          onBack();
          return;
        }

        if (goToLogin) {
          goToClear(context, loginPage ?? SelectorCustomPage());
          return;
        }

        goBack(context);
      },
      icon: const Icon(Icons.arrow_back_ios),
      color: effectiveIconColor,
      iconSize: 20,
    ),
    title: Padding(
      padding: PADDING,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextBody(
            title,
            color: effectiveTextColor,
            fontWeight: WEIGHT_BOLD,
            textAlign: TextAlign.start,
          ),
          if (pageController != null && pageCount > 0) ...[
            Space(4),
            LayoutBuilder(
              builder: (context, constraints) {
                final int count = pageCount;
                final double maxWidth = constraints.maxWidth;
                const double spacing = 8;
                final double dotWidth =
                    (maxWidth - (count - 1) * spacing) / count;

                return SmoothPageIndicator(
                  controller: pageController,
                  count: pageCount,
                  effect: WormEffect(
                    dotHeight: 2,
                    dotWidth: dotWidth,
                    spacing: spacing,
                    activeDotColor: COLOR_ACCENT,
                    dotColor: COLOR_ACCENT.withValues(alpha: 0.3),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    ),
    actions: [
      Space(SPACE_BIG),
    ],
  );
}
