import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('SelectorList conserva el estilo activo existente', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectorList(
            ['Primera', 'Segunda'],
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final AnimatedContainer selectedContainer = tester.widget<AnimatedContainer>(
      find.ancestor(
        of: find.text('Primera'),
        matching: find.byType(AnimatedContainer),
      ).first,
    );
    expect((selectedContainer.decoration as BoxDecoration).color, COLOR_ACCENT);
    expect(find.byType(AnimatedGradientBorder), findsNothing);
  });

  testWidgets('SelectorList aplica borde animado y fondo sólido al activo', (
    tester,
  ) async {
    int changedIndex = -1;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectorList(
            ['Primera', 'Segunda'],
            selectedIndex: 0,
            selectedBackgroundColor: Colors.white,
            selectedBorderGradient: true,
            selectedGradientColors: [Colors.blue, Colors.pink],
            onChanged: (index) => changedIndex = index,
          ),
        ),
      ),
    );

    expect(find.byType(AnimatedGradientBorder), findsOneWidget);
    final AnimatedGradientBorder border = tester.widget<AnimatedGradientBorder>(
      find.byType(AnimatedGradientBorder),
    );
    expect(border.colors, [Colors.blue, Colors.pink]);
    expect(find.text('Primera'), findsOneWidget);
    final AnimatedContainer background = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(AnimatedGradientBorder),
        matching: find.byType(AnimatedContainer),
      ).first,
    );
    expect((background.decoration as BoxDecoration).color, Colors.white);

    await tester.tap(
      find.ancestor(
        of: find.text('Segunda'),
        matching: find.byType(InkWell),
      ).first,
    );
    expect(changedIndex, 1);
  });

  testWidgets('SelectorList admite fondo animado y borde sólido', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectorList(
            ['Primera', 'Segunda'],
            selectedIndex: 0,
            selectedBackgroundGradient: true,
            selectedBorderColor: Colors.red,
            selectedGradientColors: [Colors.blue, Colors.pink],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final AnimatedGradientBorder gradient = tester.widget<AnimatedGradientBorder>(
      find.byType(AnimatedGradientBorder),
    );
    expect(gradient.borderWidth, 0);
    expect(gradient.colors, [Colors.blue, Colors.pink]);
    expect(find.text('Primera'), findsOneWidget);
    final AnimatedContainer border = tester.widget<AnimatedContainer>(
      find.ancestor(
        of: find.byType(AnimatedGradientBorder),
        matching: find.byType(AnimatedContainer),
      ).first,
    );
    expect((border.decoration as BoxDecoration).color, Colors.red);
  });

  testWidgets('SelectorList personaliza check y textos por estado', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectorList(
            ['Primera', 'Segunda'],
            selectedIndex: 0,
            selectedCheckColor: Colors.pink,
            selectedTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            unselectedTextStyle: TextStyle(
              fontSize: 14,
              color: Colors.green,
            ),
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final Text selectedText = tester.widget<Text>(find.text('Primera'));
    final Text unselectedText = tester.widget<Text>(find.text('Segunda'));
    expect(selectedText.style?.fontSize, 18);
    expect(selectedText.style?.fontWeight, FontWeight.w700);
    expect(unselectedText.style?.fontSize, 14);
    expect(unselectedText.style?.color, Colors.green);
    expect(tester.widget<Icon>(find.byType(Icon).first).color, Colors.pink);
  });
}
