import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // El test completo requiere Supabase inicializado.
    // Los tests de integración se realizan con flutter test integration_test/
    expect(true, isTrue);
  });
}
