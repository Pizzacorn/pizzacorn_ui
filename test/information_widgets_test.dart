import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets("ContainerHelp muestra el icono y el texto", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContainerHelp(
            text: "Ayuda contextual",
            icon: Icons.info_outline_rounded,
          ),
        ),
      ),
    );

    expect(find.text("Ayuda contextual"), findsOneWidget);
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });

  testWidgets("disclaimerWidget admite otro icono y puede ocultarlo", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: disclaimerWidget(text: "Aviso", icon: Icons.warning_amber_rounded),
      ),
    ));
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: disclaimerWidget(
          text: "Aviso sin icono",
          icon: Icons.warning_amber_rounded,
          showIcon: false,
        ),
      ),
    ));
    expect(find.text("Aviso sin icono"), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
  });

  testWidgets("ImageCustom carga su placeholder incluido", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageCustom(
            imageUrl: "",
            width: 80,
            height: 80,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets("BottomSheetInfo funciona sin botones", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomSheetInfo(
            title: "Información",
            body: "Contenido",
          ),
        ),
      ),
    );

    expect(find.text("Información"), findsOneWidget);
    expect(find.text("Contenido"), findsOneWidget);
    expect(find.byType(ButtonCustom), findsNothing);
  });

  testWidgets("BottomSheetInfo muestra el disclaimer reutilizable", (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomSheetInfo(
            title: "Certificación",
            disclaimer: "La app adapta las opciones a tus permisos.",
          ),
        ),
      ),
    );

    expect(
      find.text("La app adapta las opciones a tus permisos."),
      findsOneWidget,
    );
    expect(find.byType(ContainerHelp), findsOneWidget);
  });

  testWidgets("BottomSheetInfo ejecuta sus dos acciones", (tester) async {
    int leftPresses = 0;
    int rightPresses = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomSheetInfo(
            title: "Acciones",
            leftButtonTitle: "Volver",
            onLeftButtonPressed: () {
              leftPresses++;
            },
            rightButtonTitle: "Continuar",
            onRightButtonPressed: () {
              rightPresses++;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text("Volver"));
    await tester.tap(find.text("Continuar"));

    expect(leftPresses, 1);
    expect(rightPresses, 1);
  });

  test("BottomSheetInfo impide varias cabeceras visuales", () {
    expect(
      () => BottomSheetInfo(
        icon: Icons.info_outline_rounded,
        imageAsset: "assets/images/example.png",
      ),
      throwsAssertionError,
    );
  });
}
