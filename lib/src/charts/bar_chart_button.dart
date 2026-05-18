import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// 🚀 Botón rápido para abrir gráficas de barras.
class BarChartButton extends StatelessWidget {
  BarChartButton({
    super.key,
    required this.barChartConfig,
    this.text = '',
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.border = false,
  });

  BarChartConfig barChartConfig;
  String text;
  double? width;
  double? height;
  Color? color;
  Color? textColor;
  bool border;

  @override
  Widget build(BuildContext context) {
    return ButtonCustom(
      text: text.isNotEmpty ? text : barChartConfig.buttonText,
      width: width,
      height: height,
      color: color,
      textColor: textColor,
      border: border,
      prefixIcon: Icons.bar_chart_rounded,
      onPressed: () {
        goTo(
          context,
          BarChartPage(
            barChartConfig: barChartConfig,
          ),
        );
      },
    );
  }
}
