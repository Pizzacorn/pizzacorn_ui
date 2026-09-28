import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  setUp(() {
    PizzacornTextConfig.configure(
      primaryUppercase: false,
      secondaryUppercase: false,
      fonts: const PizzacornTextFonts(),
    );
  });

  testWidgets("La fuente primaria puede mostrarse en mayúsculas", (
    tester,
  ) async {
    PizzacornTextConfig.configure(primaryUppercase: true);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [TextBig("Título principal"), TextBody("Texto normal")],
          ),
        ),
      ),
    );

    expect(find.text("TÍTULO PRINCIPAL"), findsOneWidget);
    expect(find.text("Texto normal"), findsOneWidget);
  });

  testWidgets("La fuente secundaria puede mostrarse en mayúsculas", (
    tester,
  ) async {
    PizzacornTextConfig.configure(secondaryUppercase: true);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [TextTitle("Título normal"), TextBody("Texto secundario")],
          ),
        ),
      ),
    );

    expect(find.text("Título normal"), findsOneWidget);
    expect(find.text("TEXTO SECUNDARIO"), findsOneWidget);
  });

  testWidgets("La regla sigue la familia asignada al estilo", (tester) async {
    PizzacornTextConfig.configure(
      primaryUppercase: true,
      fonts: const PizzacornTextFonts(body: PizzacornFontType.primary),
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TextBody("Cuerpo primario"))),
    );

    expect(find.text("CUERPO PRIMARIO"), findsOneWidget);
  });
}
