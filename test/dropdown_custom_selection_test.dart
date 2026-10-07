import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:uicons_pro/uicons_pro.dart';

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

  testWidgets('Los dropdowns usan uicons y aceptan otro icono', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            DropdownCustom<String>(
              items: ['Uno'],
              getName: (item) => item,
              tooltip: 'Elegir',
              hintText: 'Uno',
            ),
            DropdownSearch<String>(
              items: ['Dos'],
              getName: (item) => item,
              tooltip: 'Buscar',
              hintText: 'Dos',
              dropdownIcon: Icons.expand_more,
              dropdownIconColor: Colors.red,
            ),
          ],
        ),
      ),
    ));

    expect(find.byIcon(UIconsPro.regularRounded.angle_small_down), findsOneWidget);
    final customIcon = tester.widget<Icon>(find.byIcon(Icons.expand_more));
    expect(customIcon.color, Colors.red);
    expect(tester.takeException(), isNull);
  });

  testWidgets('DropdownCustom aplica estilos individuales a las opciones', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DropdownCustom<String>(
          items: ['Uno', 'Dos'],
          initialItem: 'Uno',
          getName: (item) => item,
          tooltip: 'Elegir',
          hintText: 'Elegir',
          menuBackgroundColor: Colors.black,
          optionStyleBuilder: (item, isSelected) => DropdownOptionStyle(
            backgroundColor: isSelected ? Colors.green : Colors.grey,
            textColor: isSelected ? Colors.white : Colors.black,
            borderColor: item == 'Dos' ? Colors.blue : null,
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Uno'));
    await tester.pumpAndSettle();
    final options = find.byType(PopupMenuItem<String>);
    expect(options, findsNWidgets(2));
    final firstContainer = tester.widget<Container>(
      find.descendant(of: options.first, matching: find.byType(Container)).first,
    );
    final secondContainer = tester.widget<Container>(
      find.descendant(of: options.last, matching: find.byType(Container)).first,
    );
    expect((firstContainer.decoration as BoxDecoration).color, Colors.green);
    expect((secondContainer.decoration as BoxDecoration).color, Colors.grey);
    expect((secondContainer.decoration as BoxDecoration).border, isNotNull);
  });
}
