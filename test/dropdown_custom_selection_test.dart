import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:uicons_pro/uicons_pro.dart';

void main() {
  testWidgets('DropdownCustom aplica selectedTextStyle solo al seleccionarse', (
    tester,
  ) async {
    Widget buildDropdown(bool selected) => MaterialApp(
      home: Scaffold(
        body: DropdownCustom<String>(
          items: ['Uno'],
          initialItem: 'Uno',
          getName: (item) => item,
          tooltip: 'Elegir',
          hintText: 'Elegir',
          selected: selected,
          selectedTextColor: Colors.blue,
          selectedTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );

    await tester.pumpWidget(buildDropdown(false));
    expect(tester.widget<Text>(find.text('Uno')).style?.fontWeight, isNot(FontWeight.bold));

    await tester.pumpWidget(buildDropdown(true));
    final selectedText = tester.widget<Text>(find.text('Uno'));
    expect(selectedText.style?.fontWeight, FontWeight.bold);
    expect(selectedText.style?.color, Colors.blue);
  });

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

  testWidgets('Los desplegables reservan espacio para el icono con texto largo', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 600);
    addTearDown(tester.view.reset);
    const longLabel = 'Una opción con una descripción demasiado larga para el campo';

    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
        child: child!,
      ),
      home: Scaffold(
        body: Column(
          children: [
            DropdownCustom<String>(
              items: const [longLabel],
              getName: (item) => item,
              hintText: longLabel,
              tooltip: 'Elegir',
              selected: true,
              selectedTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownSearch<String>(
              items: const [longLabel],
              getName: (item) => item,
              hintText: longLabel,
              tooltip: 'Buscar',
            ),
          ],
        ),
      ),
    ));

    expect(find.byIcon(UIconsPro.regularRounded.angle_small_down), findsNWidgets(2));
    expect(tester.widgetList<Text>(find.text(longLabel)).every((text) => text.maxLines == 1), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('El selector abre en diálogo por teclado y acepta una coincidencia sin tildes', (tester) async {
    String? selection;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DropdownSearch<String>(
          items: const ['Málaga', 'Cádiz', 'Català'],
          initialItem: 'Cádiz',
          getName: (item) => item,
          hintText: 'Ciudad',
          tooltip: 'Elegir ciudad',
          onChanged: (item) => selection = item,
        ),
      ),
    ));

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    final field = find.byType(EditableText);
    expect(tester.widget<EditableText>(field).focusNode.hasFocus, isTrue);
    expect(tester.widget<ListTile>(find.widgetWithText(ListTile, 'Cádiz')).selected, isTrue);

    await tester.enterText(field, 'catala');
    await tester.pump();
    expect(find.widgetWithText(ListTile, 'Català'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Málaga'), findsNothing);

    await tester.enterText(field, '  MALAGA  ');
    await tester.pump();
    expect(find.widgetWithText(ListTile, 'Cádiz'), findsNothing);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(selection, 'Málaga');
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('Málaga'), findsOneWidget);
  });

  testWidgets('El selector compacto cabe con el teclado y muestra un vacío personalizable', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 430);
    addTearDown(tester.view.reset);
    int changes = 0;
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
        child: child!,
      ),
      home: Scaffold(
        body: DropdownSearch<String>(
          items: const ['Málaga', 'Cádiz'],
          getName: (item) => item,
          tooltip: 'Elegir ciudad',
          hintText: 'Ciudad',
          searchHintText: 'Filtrar ciudades',
          emptyText: 'Ninguna ciudad',
          onChanged: (item) => changes++,
        ),
      ),
    ));
    await tester.tap(find.text('Ciudad'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    final field = find.byType(EditableText);
    expect(tester.widget<EditableText>(field).focusNode.hasFocus, isFalse);
    expect(find.text('Filtrar ciudades'), findsOneWidget);

    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    await tester.enterText(field, 'Sin coincidencias');
    await tester.pumpAndSettle();
    expect(find.text('Ninguna ciudad'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    expect(changes, 0);
    expect(tester.takeException(), isNull);
  });
}
