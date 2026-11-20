import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class PaginationTestDocument implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class PaginationTestController extends PaginationController<dynamic> {
  final cursors = <DocumentSnapshot?>[];
  final requests = <Completer<(List<dynamic>, DocumentSnapshot?, bool)>>[];

  @override
  Future<(List<dynamic>, DocumentSnapshot?, bool)> readVisiblePage({
    DocumentSnapshot? afterDocument,
  }) {
    final request = Completer<(List<dynamic>, DocumentSnapshot?, bool)>();
    requests.add(request);
    cursors.add(afterDocument);
    return request.future;
  }
}

void main() {
  final params = PaginationParams<String>(
    collection: 'paginationTest',
    fromJson: (data) => data['label'] as String,
    itemFilter: (item) => item.isNotEmpty,
  );

  const loadingMessages = PaginationMessages(loading: 'Cargando catálogo');
  const placeholder = 'Placeholder';
  final variants = <String, Widget Function(Widget Function(String))>{
    'la lista vertical': (itemBuilder) => SliverListCustom<String>(
      params: params,
      itemBuilder: itemBuilder,
      itemPlaceholder: placeholder,
      autoLoadMore: false,
      showSkeleton: false,
      messages: loadingMessages,
    ),
    'el grid': (itemBuilder) => SliverGridCustom<String>(
      params: params,
      itemBuilder: itemBuilder,
      itemPlaceholder: placeholder,
      minItemWidth: 180,
      autoLoadMore: false,
      showSkeleton: false,
      messages: loadingMessages,
    ),
    'la lista horizontal': (itemBuilder) => SliverListHorizontalCustom<String>(
      params: params,
      itemBuilder: itemBuilder,
      itemPlaceholder: placeholder,
      autoLoadMore: false,
      showSkeleton: false,
      messages: loadingMessages,
    ),
  };
  final variantNames = variants.keys.toList();

  for (int i = 0; i < variantNames.length; i++) {
    final variantName = variantNames[i];
    testWidgets('El indicador sustituye al skeleton en $variantName', (tester) async {
      final controller = PaginationTestController();
      final builtItems = <String>[];
      await tester.pumpWidget(ProviderScope(
        overrides: [paginationProvider.overrideWith(() => controller)],
        child: MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                variants[variantName]!((item) {
                  builtItems.add(item);
                  return SizedBox(width: 160, child: Text(item));
                }),
              ],
            ),
          ),
        ),
      ));

      final indicator = find.byType(CircularProgressIndicator);
      expect(indicator, findsOneWidget);
      expect(tester.widget<CircularProgressIndicator>(indicator).semanticsLabel,
          loadingMessages.loading);
      expect(builtItems, isEmpty);

      final nextCursor = PaginationTestDocument();
      controller.requests.single.complete((['Primer resultado'], nextCursor, true));
      await tester.pumpAndSettle();
      expect(indicator, findsNothing);
      await tester.tap(find.text('Cargar más resultados'));
      await tester.pump();
      expect(indicator, findsOneWidget);
      expect(find.text('Primer resultado'), findsOneWidget);
      expect(builtItems, isNot(contains(placeholder)));

      controller.requests.last.complete((['Segundo resultado'], nextCursor, false));
      await tester.pumpAndSettle();
      expect(indicator, findsNothing);
      expect(find.text('Segundo resultado'), findsOneWidget);
    });
  }

  testWidgets('La lista recupera la primera carga y oculta el error técnico', (tester) async {
    final controller = PaginationTestController();
    await tester.pumpWidget(ProviderScope(
      overrides: [paginationProvider.overrideWith(() => controller)],
      child: MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverListCustom<String>(
                params: params,
                itemBuilder: (item) => ListTile(title: Text(item)),
                itemPlaceholder: 'Cargando',
                messages: const PaginationMessages(
                  initialError: 'Could not load results',
                  retry: 'Try again',
                ),
              ),
            ],
          ),
        ),
      ),
    ));
    controller.requests.single.completeError(StateError('Detalle técnico'));
    await tester.pumpAndSettle();
    expect(find.text('Could not load results'), findsOneWidget);
    expect(find.textContaining('Detalle técnico'), findsNothing);

    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(controller.cursors, [null, null]);
    controller.requests.last.complete((['Primer resultado'], null, false));
    await tester.pumpAndSettle();
    expect(find.text('Primer resultado'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('El grid usa el ancho local para el esqueleto, los datos y la página siguiente', (tester) async {
    final controller = PaginationTestController();
    final width = ValueNotifier<double>(300);
    addTearDown(width.dispose);
    await tester.pumpWidget(ProviderScope(
      overrides: [paginationProvider.overrideWith(() => controller)],
      child: MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: ValueListenableBuilder<double>(
              valueListenable: width,
              builder: (context, value, child) => SizedBox(
                width: value,
                child: CustomScrollView(
                  slivers: [
                    SliverGridCustom<String>(
                      params: params,
                      itemPlaceholder: 'Cargando',
                      itemBuilder: (item) => Center(child: Text(item)),
                      minItemWidth: 150,
                      autoLoadMore: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));

    int columns(SliverGrid grid) =>
        (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
            .crossAxisCount;
    expect(tester.widgetList<SliverGrid>(find.byType(SliverGrid)).map(columns), [1]);
    width.value = 640;
    await tester.pump();
    expect(tester.widgetList<SliverGrid>(find.byType(SliverGrid)).map(columns), [4]);

    final nextCursor = PaginationTestDocument();
    controller.requests.single.complete((['Resultado'], nextCursor, true));
    await tester.pumpAndSettle();
    final loadMore = find.text('Cargar más resultados');
    expect(loadMore, findsOneWidget);
    expect(controller.requests, hasLength(1));
    await tester.tap(loadMore);
    await tester.pump();
    expect(controller.cursors, [null, nextCursor]);
    expect(tester.widgetList<SliverGrid>(find.byType(SliverGrid)).map(columns), [4, 4]);
    controller.requests.last.complete((['Segundo resultado'], nextCursor, false));
    await tester.pumpAndSettle();
    expect(find.text('Segundo resultado'), findsOneWidget);
    expect(loadMore, findsNothing);
  });

  testWidgets('La lista horizontal reintenta desde el cursor de una página filtrada', (tester) async {
    final controller = PaginationTestController();
    await tester.pumpWidget(ProviderScope(
      overrides: [paginationProvider.overrideWith(() => controller)],
      child: MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverListHorizontalCustom<String>(
                params: params,
                itemBuilder: (item) => SizedBox(width: 200, child: Text(item)),
                itemPlaceholder: 'Cargando',
                autoLoadMore: false,
              ),
            ],
          ),
        ),
      ),
    ));

    final nextCursor = PaginationTestDocument();
    controller.requests.single.complete(([], nextCursor, true));
    await tester.pumpAndSettle();
    expect(find.text('No hay resultados'), findsNothing);
    await tester.tap(find.text('Cargar más resultados'));
    await tester.pump();
    controller.requests.last.completeError(StateError('Fallo temporal'));
    await tester.pumpAndSettle();
    expect(find.text('No se pudieron cargar más resultados.'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    expect(controller.cursors, [null, nextCursor, nextCursor]);
    controller.requests.last.complete((['Resultado visible'], nextCursor, false));
    await tester.pumpAndSettle();
    expect(find.text('Resultado visible'), findsOneWidget);
  });

  test('Una página anterior queda descartada cuando se refresca el resultado', () async {
    final controller = PaginationTestController();
    final container = ProviderContainer(
      overrides: [paginationProvider.overrideWith(() => controller)],
    );
    addTearDown(container.dispose);
    final provider = paginationProvider(params);
    final subscription = container.listen(provider, (previous, next) {});
    addTearDown(subscription.close);

    await Future<void>.delayed(Duration.zero);
    final oldCursor = PaginationTestDocument();
    controller.requests.single.complete((['Anterior'], oldCursor, true));
    await Future<void>.delayed(Duration.zero);

    final previousPage = controller.fetchMore();
    final refresh = controller.refresh();
    expect(container.read(provider).isFetchingMore, isFalse);
    final newCursor = PaginationTestDocument();
    controller.requests.last.complete((['Actualizado'], newCursor, true));
    await refresh;
    controller.requests[1].complete((['Página desactualizada'], oldCursor, false));
    await previousPage;

    expect(container.read(provider).items, ['Actualizado']);
    expect(container.read(provider).hasMore, isTrue);
    expect(controller.lastDocument, same(newCursor));
  });
}
