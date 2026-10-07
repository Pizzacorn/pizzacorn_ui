import 'dart:convert';

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

  testWidgets('SelectorList horizontal reparte el ancho entre las opciones', (
    tester,
  ) async {
    int changedIndex = -1;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: SelectorList(
              ['Casi ninguno', '1–2', '3–4', '5 o más'],
              selectedIndex: 2,
              horizontal: true,
              selectedBorderGradient: true,
              selectedBackgroundColor: Colors.white,
              selectedGradientColors: [Colors.blue, Colors.pink],
              onChanged: (index) => changedIndex = index,
            ),
          ),
        ),
      ),
    );

    final List<Finder> items = [
      find.text('Casi ninguno'),
      find.text('1–2'),
      find.text('3–4'),
      find.text('5 o más'),
    ];
    for (int i = 0; i < items.length; i++) {
      expect(items[i], findsOneWidget);
    }
    expect(find.byType(Icon), findsNothing);
    expect(find.byType(AnimatedGradientBorder), findsOneWidget);
    final Finder firstItem = find.ancestor(
      of: items[0],
      matching: find.byType(SelectorListItem),
    );
    final Finder secondItem = find.ancestor(
      of: items[1],
      matching: find.byType(SelectorListItem),
    );
    expect(tester.getSize(firstItem).width, closeTo(92.5, 0.01));
    expect(tester.getSize(firstItem), tester.getSize(secondItem));

    await tester.tap(
      find.ancestor(of: items[3], matching: find.byType(InkWell)).first,
    );
    expect(changedIndex, 3);
  });

  testWidgets('SelectorList crea dos filas de tres columnas sin perder opciones', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 330,
            child: SelectorList(
              ['Uno', 'Dos', 'Tres', 'Cuatro', 'Cinco'],
              selectedIndex: 4,
              horizontal: true,
              rows: 2,
              columns: 3,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    final Finder firstItem = find.ancestor(
      of: find.text('Uno'),
      matching: find.byType(SelectorListItem),
    );
    final Finder fourthItem = find.ancestor(
      of: find.text('Cuatro'),
      matching: find.byType(SelectorListItem),
    );
    expect(find.byType(SelectorListItem), findsNWidgets(5));
    expect(tester.getSize(firstItem).width, closeTo(103.33, 0.02));
    expect(tester.getTopLeft(fourthItem).dy, greaterThan(tester.getTopLeft(firstItem).dy));
    expect(tester.getTopLeft(fourthItem).dx, tester.getTopLeft(firstItem).dx);
  });

  testWidgets('SelectorList admite borde lineal fijo y fondo radial animado', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectorList(
            ['Primera'],
            selectedIndex: 0,
            selectedBorderGradient: true,
            selectedBorderGradientAnimated: false,
            selectedBorderGradientType: PizzacornGradientType.linear,
            selectedBackgroundGradient: true,
            selectedBackgroundGradientAnimated: true,
            selectedBackgroundGradientType: PizzacornGradientType.radial,
            selectedGradientColors: [Colors.red, Colors.blue],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final List<AnimatedGradientBorder> gradients = tester
        .widgetList<AnimatedGradientBorder>(find.byType(AnimatedGradientBorder))
        .toList();
    expect(gradients.length, 2);
    expect(gradients[0].gradientType, PizzacornGradientType.linear);
    expect(gradients[0].animated, isFalse);
    expect(gradients[1].gradientType, PizzacornGradientType.radial);
    expect(gradients[1].animated, isTrue);
  });

  testWidgets('SelectorList muestra imagen y subtítulo por opción', (tester) async {
    final image = MemoryImage(base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScL/nwAAAABJRU5ErkJggg==',
    ));
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SelectorList(
          ['Ancho', 'Intermedio'],
          subtitles: ['Estructura amplia', 'Estructura equilibrada'],
          images: [image, null],
          selectedIndex: 1,
          onChanged: (_) {},
          selectedBackgroundColor: Colors.white,
          selectedTextColor: Colors.black,
        ),
      ),
    ));

    expect(find.text('Estructura amplia'), findsOneWidget);
    expect(find.text('Estructura equilibrada'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
