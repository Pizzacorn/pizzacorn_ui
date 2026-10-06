import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('AnimatedGradientBorder conserva el tamaño del hijo y anima el borde', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: AnimatedGradientBorder(
            borderWidth: 3,
            colors: [Colors.red, Colors.blue],
            child: SizedBox(width: 80, height: 40, child: Text('Contenido')),
          ),
        ),
      ),
    );

    expect(find.text('Contenido'), findsOneWidget);
    expect(tester.getSize(find.byType(AnimatedGradientBorder)), Size(86, 46));

    final DecoratedBox before = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(AnimatedGradientBorder),
        matching: find.byType(DecoratedBox),
      ).first,
    );
    final SweepGradient firstGradient =
        (before.decoration as BoxDecoration).gradient! as SweepGradient;

    await tester.pump(Duration(milliseconds: 500));

    final DecoratedBox after = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(AnimatedGradientBorder),
        matching: find.byType(DecoratedBox),
      ).first,
    );
    final SweepGradient secondGradient =
        (after.decoration as BoxDecoration).gradient! as SweepGradient;
    expect(secondGradient.transform, isNot(firstGradient.transform));
  });
}
