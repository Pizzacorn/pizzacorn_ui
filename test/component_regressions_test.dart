import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('Cerrar la carga deja la ruta abierta y se puede volver a mostrar', (tester) async {
    late StateSetter update;
    bool loading = true;
    int dismissals = 0;
    int backgroundActions = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push<void>(MaterialPageRoute(
              builder: (context) => Scaffold(
                body: StatefulBuilder(
                  builder: (context, setState) {
                    update = setState;
                    return Loading(
                      loading: loading,
                      dismissible: true,
                      onDismiss: () => dismissals++,
                      child: Center(
                        child: TextButton(
                          autofocus: true,
                          onPressed: () => backgroundActions++,
                          child: const Text('Pantalla de edición'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
            child: const Text('Abrir pantalla'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Abrir pantalla'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(backgroundActions, 0);

    await tester.tapAt(const Offset(20, 200));
    await tester.pumpAndSettle();
    expect(dismissals, 1);
    expect(find.text('Pantalla de edición'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.text('Pantalla de edición'));
    expect(backgroundActions, 1);

    update(() => loading = false);
    await tester.pump();
    update(() => loading = true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('El grid expandido permite seleccionar una quinta opción con teclado', (tester) async {
    final items = List.generate(
      5,
      (index) => GridExpandedSelectorModel(title: 'Opción ${index + 1}'),
    );
    String selected = 'Opción 1';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 360,
            height: 520,
            child: StatefulBuilder(
              builder: (context, setState) => GridExpandedSelector(
                items: items,
                selectedItem: selected,
                onChanged: (value) => setState(() => selected = value),
                borderGradient: false,
              ),
            ),
          ),
        ),
      ),
    ));

    for (int i = 0; i < items.length; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(selected, 'Opción 5');
    expect(find.text('Opción 5'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('La gráfica conserva su consulta al reconstruirse y permite reintentar', (tester) async {
    final requests = <Completer<List<BarChartPointModel>>>[];
    final Future<List<BarChartPointModel>> Function() loadPoints = () {
      final request = Completer<List<BarChartPointModel>>();
      requests.add(request);
      return request.future;
    };
    final title = ValueNotifier('Primera gráfica');
    addTearDown(title.dispose);

    await tester.pumpWidget(MaterialApp(
      home: ValueListenableBuilder<String>(
        valueListenable: title,
        builder: (context, value, child) => BarChartPage(
          barChartConfig: BarChartConfig(title: value),
          loadPoints: loadPoints,
        ),
      ),
    ));
    expect(requests, hasLength(1));
    title.value = 'Gráfica actualizada';
    await tester.pump();
    expect(requests, hasLength(1));

    requests.single.completeError(StateError('Detalle técnico'));
    await tester.pumpAndSettle();
    expect(find.text('No se pudo cargar la gráfica.'), findsOneWidget);
    expect(find.textContaining('Detalle técnico'), findsNothing);
    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    expect(requests, hasLength(2));
    requests.last.complete([BarChartPointModel(label: 'Enero', value: 24)]);
    await tester.pumpAndSettle();
    expect(find.text('Enero'), findsNWidgets(2));
  });
}
