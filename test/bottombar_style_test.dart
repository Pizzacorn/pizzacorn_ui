import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('La barra fija elimina el espacio flotante y admite gradiente', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomBarCustom(
            currentIndex: 0,
            onTap: (index) {},
            icons: const [Icons.home, Icons.search],
            titles: const ['Inicio', 'Buscar'],
            isFloating: false,
            selectedGradientColors: const [Colors.red, Colors.blue],
          ),
        ),
      ),
    );

    final BottomItem selectedItem = tester.widget<BottomItem>(
      find.widgetWithText(BottomItem, 'Inicio'),
    );
    expect(selectedItem.selectedGradientColors, [Colors.red, Colors.blue]);
    expect(find.byType(ShaderMask), findsNWidgets(2));
    final Container outerContainer = tester.widget<Container>(
      find.ancestor(
        of: find.byType(BottomItem).first,
        matching: find.byType(Container),
      ).last,
    );
    expect(outerContainer.padding, const EdgeInsets.only(bottom: 0));
  });
}
