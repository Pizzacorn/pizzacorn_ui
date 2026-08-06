import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

PreferredSizeWidget AppbarStepper({
  required BuildContext context,
  String title = "",
  Color? color,
  Color? textColor,
  Color? iconColor,
  bool useTextSubtitle = false,
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
          useTextSubtitle
              ? TextSubtitle(
                  title,
                  color: effectiveTextColor,
                  fontWeight: WEIGHT_BOLD,
                  textAlign: TextAlign.start,
                )
              : TextBody(
                  title,
                  color: effectiveTextColor,
                  fontWeight: WEIGHT_BOLD,
                  textAlign: TextAlign.start,
                ),
          if (pageController != null && pageCount > 0) ...[
            Space(4),
            AppbarStepperIndicator(
              pageController: pageController,
              pageCount: pageCount,
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

class AppbarStepperIndicator extends StatelessWidget {
  final PageController pageController;
  final int pageCount;
  final double height;
  final double spacing;

  AppbarStepperIndicator({
    super.key,
    required this.pageController,
    required this.pageCount,
    this.height = 2,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    if (pageCount <= 0) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        final int currentPage = getCurrentPage();

        return Row(
          children: [
            for (int i = 0; i < pageCount; i++) ...[
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: height,
                  decoration: BoxDecoration(
                    color: i <= currentPage
                        ? COLOR_ACCENT
                        : COLOR_ACCENT.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
              ),
              if (i < pageCount - 1)
                SizedBox(
                  width: spacing,
                ),
            ],
          ],
        );
      },
    );
  }

  int getCurrentPage() {
    if (!pageController.hasClients) {
      return clampCurrentPage(pageController.initialPage);
    }

    final double page =
        pageController.page ?? pageController.initialPage.toDouble();
    return clampCurrentPage(page.floor());
  }

  int clampCurrentPage(int page) {
    if (page < 0) {
      return 0;
    }

    if (page >= pageCount) {
      return pageCount - 1;
    }

    return page;
  }
}
