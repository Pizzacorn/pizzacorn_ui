import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('MultiSelector muestra selección y comunica el toque', (
    tester,
  ) async {
    String changedItem = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiSelector(
            items: ['Fuerza', 'Movilidad'],
            selectedItems: ['Fuerza'],
            selectedGradientColors: [Colors.red, Colors.blue],
            selectedTextColor: Colors.white,
            unselectedTextColor: Colors.green,
            selectedTextStyle: TextStyle(fontSize: 16),
            unselectedTextStyle: TextStyle(fontSize: 12),
            onChanged: (item) => changedItem = item,
          ),
        ),
      ),
    );

    final AnimatedGradientBorder gradient = tester.widget<AnimatedGradientBorder>(
      find.byType(AnimatedGradientBorder),
    );
    expect(gradient.animated, isFalse);
    expect(gradient.gradientType, PizzacornGradientType.linear);
    expect(gradient.colors, [Colors.red, Colors.blue]);
    expect(tester.widget<Text>(find.text('Fuerza')).style?.fontSize, 16);
    expect(tester.widget<Text>(find.text('Movilidad')).style?.fontSize, 12);

    await tester.tap(
      find.ancestor(
        of: find.text('Movilidad'),
        matching: find.byType(InkWell),
      ).first,
    );
    expect(changedItem, 'Movilidad');
  });

  testWidgets('MultiSelector admite fondo radial animado', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiSelector(
            items: ['Fuerza'],
            selectedItems: ['Fuerza'],
            selectedGradientAnimated: true,
            selectedGradientType: PizzacornGradientType.radial,
            selectedGradientColors: [Colors.orange, Colors.purple],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final AnimatedGradientBorder gradient = tester.widget<AnimatedGradientBorder>(
      find.byType(AnimatedGradientBorder),
    );
    expect(gradient.animated, isTrue);
    expect(gradient.gradientType, PizzacornGradientType.radial);
  });

  testWidgets('MultiSelector admite fondo sólido', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiSelector(
            items: ['Fuerza'],
            selectedItems: ['Fuerza'],
            selectedBackgroundGradient: false,
            selectedBackgroundColor: Colors.orange,
            selectedBorderColor: Colors.purple,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.byType(AnimatedGradientBorder), findsNothing);
    final AnimatedContainer chip = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final BoxDecoration decoration = chip.decoration! as BoxDecoration;
    expect(decoration.color, Colors.orange);
    expect(decoration.border?.top.color, Colors.purple);
  });
}
