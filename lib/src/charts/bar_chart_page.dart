import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// 📈 Página visual de barras.
class BarChartPage extends StatelessWidget {
  BarChartPage({
    super.key,
    required this.barChartConfig,
  });

  BarChartConfig barChartConfig;

  String getValueText(double value) {
    final String normalizedValue = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);

    return '${barChartConfig.valuePrefix}$normalizedValue${barChartConfig.valueSuffix}';
  }

  @override
  Widget build(BuildContext context) {
    final BarChartService barChartService = BarChartService(
      barChartConfig: barChartConfig,
    );

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBarBack(
        context: context,
        title: barChartConfig.title,
      ),
      body: FutureBuilder<List<BarChartPointModel>>(
        future: barChartService.getPointList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingCustomWidget());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: PADDING_ALL,
                child: TextBody(
                  snapshot.error.toString(),
                  maxlines: 10,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final List<BarChartPointModel> pointList =
              snapshot.data ?? <BarChartPointModel>[];

          if (pointList.isEmpty) {
            return Center(
              child: Padding(
                padding: PADDING_ALL,
                child: TextBody(
                  barChartConfig.emptyText,
                  textAlign: TextAlign.center,
                  maxlines: 5,
                ),
              ),
            );
          }

          double maxValue = 0;
          for (int i = 0; i < pointList.length; i++) {
            if (pointList[i].value > maxValue) {
              maxValue = pointList[i].value;
            }
          }

          if (maxValue <= 0) {
            maxValue = 1;
          }

          return ListView(
            padding: PADDING_ALL,
            children: [
              Container(
                padding: PADDING_ALL,
                decoration: DecorationCustom(
                  color: COLOR_BACKGROUND_SECONDARY,
                  hasShadow: false,
                  hasBorder: true,
                  borderColor: COLOR_BORDER.withValues(alpha: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitle(barChartConfig.title),
                    Space(SPACE_SMALL),
                    TextCaption(
                      'Total barras: ${pointList.length}',
                    ),
                  ],
                ),
              ),
              Space(SPACE_MEDIUM),
              SizedBox(
                height: 320,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (int i = 0; i < pointList.length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            right: i == pointList.length - 1 ? 0 : SPACE_SMALL,
                          ),
                          child: buildBarItem(
                            pointList[i],
                            maxValue,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Space(SPACE_MEDIUM),
              for (int i = 0; i < pointList.length; i++)
                Container(
                  margin: EdgeInsets.only(
                    bottom: i == pointList.length - 1 ? 0 : SPACE_SMALL,
                  ),
                  padding: PADDING_ALL_SMALL,
                  decoration: DecorationCustom(
                    color: COLOR_BACKGROUND_SECONDARY,
                    hasShadow: false,
                    hasBorder: true,
                    borderColor: COLOR_BORDER.withValues(alpha: 0.35),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextBody(
                          pointList[i].label,
                          maxlines: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Space(SPACE_SMALL),
                      TextCaption(
                        getValueText(pointList[i].value),
                        color: COLOR_ACCENT,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildBarItem(
    BarChartPointModel pointModel,
    double maxValue,
  ) {
    final double normalizedHeight = (pointModel.value / maxValue) * 180;

    return SizedBox(
      width: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextCaption(
            getValueText(pointModel.value),
            textAlign: TextAlign.center,
            maxlines: 2,
            color: COLOR_ACCENT,
            fontWeight: FontWeight.w700,
          ),
          Space(SPACE_SMALL),
          Container(
            width: 52,
            height: normalizedHeight < 8 ? 8 : normalizedHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  COLOR_ACCENT,
                  COLOR_ACCENT_SECONDARY,
                ],
              ),
            ),
          ),
          Space(SPACE_SMALL),
          TextSmall(
            pointModel.label,
            textAlign: TextAlign.center,
            maxlines: 3,
            color: COLOR_SUBTEXT,
          ),
        ],
      ),
    );
  }
}
