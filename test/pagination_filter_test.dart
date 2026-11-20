import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  test('El filtro conserva el tipo del modelo al pasar por el provider dinámico', () {
    final PaginationParams<String> params = PaginationParams<String>(
      collection: 'Community',
      fromJson: (data) => data['id'] as String,
      itemFilter: (item) => item != 'blocked',
    );

    final PaginationParams<dynamic> providerParams = params;
    expect(providerParams.itemFilter!('visible'), isTrue);
    expect(providerParams.itemFilter!('blocked'), isFalse);
  });

  test('queryKey separa búsquedas y conserva la identidad al reconstruir los parámetros', () {
    PaginationParams<String> params({required String search, required String sort}) {
      return PaginationParams<String>(
        collection: 'Community',
        identifier: 'communitySearch',
        queryKey: (search: search, sort: sort),
        fromJson: (data) => data['id'] as String,
        itemFilter: (item) => item.contains(search),
      );
    }

    final first = paginationProvider(params(search: 'club', sort: 'newest'));
    final rebuilt = paginationProvider(params(search: 'club', sort: 'newest'));
    expect(first, rebuilt);
    expect(first.hashCode, rebuilt.hashCode);
    expect(first, isNot(paginationProvider(params(search: 'equipo', sort: 'newest'))));
    expect(first, isNot(paginationProvider(params(search: 'club', sort: 'oldest'))));
  });
}
