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
}
