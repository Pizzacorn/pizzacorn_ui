import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('DropdownCustom actualiza el valor externo y el estilo seleccionado', (
    tester,
  ) async {
    Widget buildDropdown(String value) {
      return MaterialApp(
        home: Scaffold(
          body: DropdownCustom<String>(
            items: ["Descanso", "Media"],
            initialItem: value,
            getName: (item) => item,
            tooltip: "Duración",
            hintText: "Descanso",
            selected: value != "Descanso",
            borderGradient: true,
            gradientColors: [Colors.blue, Colors.red],
          ),
        ),
      );
    }

    await tester.pumpWidget(buildDropdown("Descanso"));
    expect(find.text("Descanso"), findsOneWidget);
    expect(find.byType(AnimatedGradientBorder), findsNothing);

    await tester.pumpWidget(buildDropdown("Media"));
    expect(find.text("Media"), findsOneWidget);
    expect(find.byType(AnimatedGradientBorder), findsOneWidget);
  });
}
