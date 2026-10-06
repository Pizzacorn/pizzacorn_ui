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

  testWidgets('AnimatedGradientBorder admite gradiente lineal fijo', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: AnimatedGradientBorder(
            animated: false,
            gradientType: PizzacornGradientType.linear,
            colors: [Colors.red, Colors.blue],
            child: SizedBox(width: 40, height: 20),
          ),
        ),
      ),
    );

    final DecoratedBox decoration = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(AnimatedGradientBorder),
        matching: find.byType(DecoratedBox),
      ).first,
    );
    expect((decoration.decoration as BoxDecoration).gradient, isA<LinearGradient>());
    expect(
      tester.state<AnimatedGradientBorderState>(
        find.byType(AnimatedGradientBorder),
      ).animationController.isAnimating,
      isFalse,
    );
  });

  testWidgets('AnimatedGradientBorder mueve el centro radial', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: AnimatedGradientBorder(
            gradientType: PizzacornGradientType.radial,
            colors: [Colors.red, Colors.blue],
            child: SizedBox(width: 40, height: 20),
          ),
        ),
      ),
    );

    RadialGradient readGradient() {
      final DecoratedBox decoration = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(AnimatedGradientBorder),
          matching: find.byType(DecoratedBox),
        ).first,
      );
      return (decoration.decoration as BoxDecoration).gradient! as RadialGradient;
    }

    final AlignmentGeometry firstCenter = readGradient().center;
    await tester.pump(Duration(milliseconds: 500));
    expect(readGradient().center, isNot(firstCenter));
  });

  testWidgets('AnimatedGradientBorder activa y detiene la animación al cambiar', (
    tester,
  ) async {
    Widget buildBorder(bool animated) {
      return MaterialApp(
        home: Center(
          child: AnimatedGradientBorder(
            animated: animated,
            gradientType: PizzacornGradientType.linear,
            child: SizedBox(width: 40, height: 20),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildBorder(false));
    final AnimatedGradientBorderState state = tester.state<
        AnimatedGradientBorderState>(find.byType(AnimatedGradientBorder));
    expect(state.animationController.isAnimating, isFalse);

    await tester.pumpWidget(buildBorder(true));
    expect(state.animationController.isAnimating, isTrue);

    await tester.pumpWidget(buildBorder(false));
    expect(state.animationController.isAnimating, isFalse);
    expect(tester.takeException(), isNull);
  });
}
