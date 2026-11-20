import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('El adaptador usa el ancho local y conserva el campo al redimensionar', (tester) async {
    final panelWidth = ValueNotifier<double>(320);
    addTearDown(panelWidth.dispose);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: ValueListenableBuilder<double>(
            valueListenable: panelWidth,
            builder: (context, width, child) => SizedBox(
              width: width,
              child: WebAdapterCustom(
                breakpoint: 500,
                children: [
                  SizedBox(width: 200, child: TextFieldCustom()),
                  const SizedBox(width: 100, height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    ));

    final flex = find.descendant(
      of: find.byType(WebAdapterCustom),
      matching: find.byType(Flex),
    );
    expect(tester.widget<Flex>(flex).direction, Axis.vertical);
    await tester.enterText(find.byType(TextFormField), 'Se conserva');
    panelWidth.value = 700;
    await tester.pump();
    expect(tester.widget<Flex>(flex).direction, Axis.horizontal);
    expect(tester.widget<EditableText>(find.byType(EditableText)).controller.text, 'Se conserva');
    expect(tester.takeException(), isNull);
  });

  testWidgets('El popup respeta la altura solicitada en una ventana estrecha', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 780));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(
      home: WebPopupCustom(
        height: 440,
        onPressedDelete: () {},
        onPressedSave: () {},
        child: const SizedBox.shrink(),
      ),
    ));

    expect(tester.getSize(find.byType(Scaffold)).height, 440);
    expect(tester.getSize(find.byType(Scaffold)).width, lessThan(320));
    expect(tester.takeException(), isNull);
  });

  testWidgets('El modal compacto permite llegar a las acciones con texto ampliado', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 300);
    addTearDown(tester.view.reset);
    bool? result;
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
        child: child!,
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await openAdaptiveModal<bool>(
                context: context,
                builder: (context) => BottomSheetInfo(
                  title: 'Confirma la selección',
                  body: List.filled(16, 'Comprueba los detalles de la solicitud.').join(' '),
                  leftButtonTitle: 'Seguir editando',
                  onLeftButtonPressed: () => Navigator.of(context).pop(false),
                  rightButtonTitle: 'Confirmar preferencias',
                  onRightButtonPressed: () => Navigator.of(context).pop(true),
                ),
              );
            },
            child: const Text('Abrir modal'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Abrir modal'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    final confirm = find.text('Confirmar preferencias');
    await tester.ensureVisible(confirm);
    await tester.pumpAndSettle();
    expect(tester.getCenter(confirm).dy, greaterThan(tester.getCenter(find.text('Seguir editando')).dy));
    expect(tester.takeException(), isNull);
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('El modal en una ventana ancha usa un diálogo que se cierra con Escape', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => openAdaptiveModal<void>(
              context: context,
              builder: (context) => BottomSheetInfo(title: 'Detalles'),
            ),
            child: const Text('Abrir diálogo'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Abrir diálogo'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('El teclado activa un segmento y semántica anuncia la selección', (tester) async {
    int currentIndex = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => SegmentedTabCustom(
            items: const ['Resumen', 'Detalles'],
            currentIndex: currentIndex,
            onValueChanged: (index) => setState(() => currentIndex = index),
          ),
        ),
      ),
    ));

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(currentIndex, 1);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Detalles'))
          .getSemanticsData()
          .hasFlag(SemanticsFlag.isSelected),
      isTrue,
    );
  });

  testWidgets('El gradiente queda estático con movimiento reducido', (tester) async {
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child!,
      ),
      home: AnimatedGradientBorder(child: const SizedBox(width: 50, height: 50)),
    ));

    final state = tester.state<AnimatedGradientBorderState>(
      find.byType(AnimatedGradientBorder),
    );
    expect(state.animationController.isAnimating, isFalse);
    expect(state.animationController.value, 0);
  });

  testWidgets('El botón expone una sola etiqueta accesible y sigue siendo activable', (tester) async {
    int activations = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ButtonCustom(
          text: 'Confirmar',
          onPressed: () => activations++,
        ),
      ),
    ));

    expect(find.bySemanticsLabel(RegExp(r'^Confirmar$')), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(activations, 1);
  });

  testWidgets('El calendario permite seleccionar una fecha con teclado', (tester) async {
    final date = DateTime(2026, 11, 2);
    DateTime? selectedDate;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 320,
            child: MonthlyCalendar(
              locale: 'en_US',
              startDate: date,
              initialDate: date,
              style: CalendarStyle(),
              showHeader: false,
              onDaySelected: (day) => selectedDate = day,
            ),
          ),
        ),
      ),
    ));

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(selectedDate, DateTime(2026, 11, 3));
    expect(find.bySemanticsLabel('Tuesday, November 3, 2026'), findsOneWidget);
  });
}
