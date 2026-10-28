import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('Permite configurar borde y sombra sin alterar los valores por defecto', (tester) async {
    Future<BoxDecoration> decoration({required bool isFloating, bool? hasBorder, Color? borderColor, bool hasShadow = true}) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomBarCustom(
            currentIndex: 0,
            onTap: (index) {},
            icons: const [Icons.home],
            titles: const ['Inicio'],
            isFloating: isFloating,
            hasBorder: hasBorder,
            borderColor: borderColor,
            hasShadow: hasShadow,
          ),
        ),
      ));
      final containers = tester.widgetList<Container>(find.byType(Container));
      return containers.firstWhere((container) => container.decoration is BoxDecoration &&
          (container.decoration as BoxDecoration).color != null).decoration as BoxDecoration;
    }

    expect((await decoration(isFloating: false)).border, isNotNull);
    expect((await decoration(isFloating: true)).border, isNull);
    final custom = await decoration(isFloating: true, hasBorder: true,
        borderColor: Colors.red, hasShadow: false);
    expect(custom.border!.top.color, Colors.red);
    expect(custom.boxShadow, isNull);
    expect((await decoration(isFloating: false, hasBorder: false)).border, isNull);
  });

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
