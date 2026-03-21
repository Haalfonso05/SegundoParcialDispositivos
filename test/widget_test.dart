import 'package:flutter_test/flutter_test.dart';

import 'package:parcial_flutter/app.dart';

void main() {
  testWidgets('Carga la pantalla de inicio', (WidgetTester tester) async {
    await tester.pumpWidget(const ParcialFlutterApp());
    await tester.pumpAndSettle();

    expect(find.text('Dispositivos Moviles'), findsOneWidget);
  });
}
