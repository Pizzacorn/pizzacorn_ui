import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('StepSliderCustom selecciona pasos y muestra sus etiquetas', (
    tester,
  ) async {
    int selectedStep = 2;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return StepSliderCustom(
                steps: 4,
                selectedStep: selectedStep,
                optionLabels: ["Menos", "Bajo", "Equilibrado", "Alto", "Más"],
                selectedColor: Colors.blue,
                unselectedColor: Colors.grey,
                thumbBorder: true,
                thumbBorderColor: Colors.blue,
                onChanged: (value) {
                  setState(() => selectedStep = value);
                },
              );
            },
          ),
        ),
      ),
    );

    expect(find.text("Menos"), findsOneWidget);
    expect(find.text("Más"), findsOneWidget);
    await tester.tapAt(tester.getTopRight(find.byType(Slider)).translate(-20, 20));
    await tester.pump();
    expect(selectedStep, 4);
  });

  testWidgets('StepSliderCustom anima el gradiente solo cuando se solicita', (
    tester,
  ) async {
    Widget buildSlider(bool animated) {
      return MaterialApp(
        home: Scaffold(
          body: StepSliderCustom(
            steps: 4,
            selectedStep: 2,
            optionLabels: ["Menos", "Bajo", "Equilibrado", "Alto", "Más"],
            selectedGradient: true,
            selectedGradientAnimated: animated,
            selectedGradientColors: [Colors.blue, Colors.purple],
            onChanged: (_) {},
          ),
        ),
      );
    }

    await tester.pumpWidget(buildSlider(true));
    expect(
      tester.state<StepSliderCustomState>(find.byType(StepSliderCustom))
          .gradientController
          .isAnimating,
      isTrue,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).gradient is LinearGradient,
      ),
      findsOneWidget,
    );

    await tester.pumpWidget(buildSlider(false));
    expect(
      tester.state<StepSliderCustomState>(find.byType(StepSliderCustom))
          .gradientController
          .isAnimating,
      isFalse,
    );
  });
}
