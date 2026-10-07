import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('El contador puede mostrarse a la derecha con círculo radial', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SegmentedCupertinoCustom(
          items: ['Gimnasio', 'Casa'],
          itemsSecondary: ['7', '3'],
          currentIndex: 0,
          onValueChanged: (_) {},
          counterPosition: SegmentedCounterPosition.right,
          counterCircle: true,
          counterGradientColors: [Colors.blue, Colors.green],
          counterGradientType: PizzacornGradientType.radial,
        ),
      ),
    ));

    expect(find.text('7'), findsOneWidget);
    final label = tester.getTopLeft(find.text('Gimnasio'));
    final counter = tester.getTopLeft(find.text('7'));
    expect(counter.dx, greaterThan(label.dx));
    expect((tester.widgetList<Container>(find.byType(Container))
        .any((container) => container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).gradient is RadialGradient)), isTrue);
  });

  testWidgets('La selección admite gradiente radial animado', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SegmentedCupertinoCustom(
          items: ['Gimnasio', 'Casa'],
          currentIndex: 0,
          onValueChanged: (_) {},
          selectedGradientColors: [Colors.blue, Colors.green],
          selectedGradientType: PizzacornGradientType.radial,
          selectedGradientAnimated: true,
        ),
      ),
    ));
    final selection = tester.widget<SegmentedSelectionGradient>(
      find.byType(SegmentedSelectionGradient),
    );
    expect(selection.animated, isTrue);
    final decoration = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(SegmentedSelectionGradient),
        matching: find.byType(DecoratedBox),
      ).first,
    ).decoration as BoxDecoration;
    expect(decoration.gradient, isA<RadialGradient>());
  });

  testWidgets('El círculo usa colores distintos según la selección', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SegmentedCupertinoCustom(
          items: ['Gimnasio', 'Casa'],
          itemsSecondary: ['7', '3'],
          currentIndex: 0,
          onValueChanged: (_) {},
          counterCircle: true,
          selectedCounterCircleColor: Colors.green,
          unselectedCounterCircleColor: Colors.grey,
        ),
      ),
    ));

    final selectedCircle = tester.widget<Container>(
      find.ancestor(of: find.text('7'), matching: find.byType(Container)).first,
    );
    final unselectedCircle = tester.widget<Container>(
      find.ancestor(of: find.text('3'), matching: find.byType(Container)).first,
    );
    expect((selectedCircle.decoration as BoxDecoration).color, Colors.green);
    expect((unselectedCircle.decoration as BoxDecoration).color, Colors.grey);
  });
}
