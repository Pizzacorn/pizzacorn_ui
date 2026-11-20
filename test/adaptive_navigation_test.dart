import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  const destinations = [
    AdaptiveNavigationDestination(value: 'home', label: 'Inicio', icon: Icons.home),
    AdaptiveNavigationDestination(
      value: 'inbox',
      label: 'Bandeja',
      icon: Icons.inbox,
      notificationCount: 3,
      notificationLabel: '3 mensajes pendientes',
    ),
    AdaptiveNavigationDestination(
      value: 'settings',
      label: 'Ajustes',
      icon: Icons.settings,
      enabled: false,
    ),
  ];

  testWidgets('La navegación usa el ancho local y conserva el contenido al cambiar de barra', (tester) async {
    final width = ValueNotifier<double>(350);
    addTearDown(width.dispose);
    String selected = 'home';
    await tester.pumpWidget(MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: ValueListenableBuilder<double>(
          valueListenable: width,
          builder: (context, value, child) => SizedBox(
            width: value,
            child: StatefulBuilder(
              builder: (context, setState) => AdaptiveNavigationScaffold(
                destinations: destinations,
                selectedValue: selected,
                onDestinationSelected: (value) => setState(() => selected = value),
                body: const TextField(),
              ),
            ),
          ),
        ),
      ),
    ));

    expect(tester.widget<Scaffold>(find.byType(Scaffold)).bottomNavigationBar, isNotNull);
    await tester.tap(find.text('Bandeja'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Texto conservado');
    final beforeResize = tester.state<EditableTextState>(find.byType(EditableText));

    width.value = 780;
    await tester.pumpAndSettle();
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).bottomNavigationBar, isNull);
    expect(tester.state<EditableTextState>(find.byType(EditableText)), same(beforeResize));
    expect(find.text('Texto conservado'), findsOneWidget);
    expect(selected, 'inbox');
    expect(tester.getCenter(find.text('Bandeja')).dx, lessThan(208));
  });

  testWidgets('La acción central y los destinos mantienen semántica y acciones distintas', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 640);
    addTearDown(tester.view.reset);
    final selections = <String>[];
    int actionCount = 0;
    await tester.pumpWidget(MaterialApp(
      home: AdaptiveNavigationScaffold(
        destinations: destinations,
        selectedValue: 'inbox',
        onDestinationSelected: selections.add,
        primaryAction: AdaptiveNavigationAction(
          label: 'Crear',
          icon: Icons.add,
          onPressed: () => actionCount++,
        ),
        body: const SizedBox.shrink(),
      ),
    ));

    final inbox = tester.getSemantics(find.bySemanticsLabel('Bandeja')).getSemanticsData();
    expect(inbox.hasFlag(SemanticsFlag.isSelected), isTrue);
    expect(inbox.value, '3 mensajes pendientes');
    final disabled = tester.getSemantics(find.bySemanticsLabel('Ajustes')).getSemanticsData();
    expect(disabled.hasFlag(SemanticsFlag.isEnabled), isFalse);
    expect(tester.getTopLeft(find.text('Inicio')).dy, greaterThan(550));
    expect(tester.getCenter(find.text('Inicio')).dx, lessThan(tester.getCenter(find.text('Crear')).dx));
    expect(tester.getCenter(find.text('Crear')).dx, lessThan(tester.getCenter(find.text('Bandeja')).dx));

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(actionCount, 1);
    expect(selections, isEmpty);
    await tester.tap(find.text('Ajustes'));
    expect(selections, isEmpty);
    await tester.tap(find.text('Inicio'));
    expect(selections, ['home']);
  });

  testWidgets('La barra compacta desplaza hasta la selección con muchos destinos', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(660, 560);
    addTearDown(tester.view.reset);
    final manyDestinations = List.generate(
      10,
      (index) => AdaptiveNavigationDestination(
        value: index,
        label: 'Destino ${index + 1}',
        icon: Icons.circle_outlined,
      ),
    );

    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
        child: child!,
      ),
      home: AdaptiveNavigationScaffold(
        destinations: manyDestinations,
        selectedValue: 9,
        onDestinationSelected: (value) {},
        body: const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();
    expect(tester.getCenter(find.text('Destino 10')).dx, inInclusiveRange(0, 660));

    tester.view.physicalSize = const Size(320, 560);
    await tester.pumpAndSettle();
    final selectedCenter = tester.getCenter(find.text('Destino 10'));
    expect(selectedCenter.dx, inInclusiveRange(0, 320));
    expect(tester.takeException(), isNull);
  });
}
