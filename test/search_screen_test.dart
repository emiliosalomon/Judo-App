import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/screens/search_screen.dart';

void main() {
  testWidgets(
    'Eingabe ohne Bindestrich findet Vorschläge und öffnet die Detailseite',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SearchScreen()));

      // "osotogari" statt "O-soto-gari" — genau das Problem, das die
      // Textvorschläge lösen sollen.
      await tester.enterText(find.byType(TextField), 'osotogari');
      await tester.pumpAndSettle();

      expect(find.textContaining('O-soto-gari'), findsWidgets);

      await tester.tap(find.textContaining('O-soto-gari').first);
      await tester.pumpAndSettle();

      expect(find.text('Nage-waza (Wurftechnik)'), findsOneWidget);
    },
  );

  testWidgets('Leere Eingabe zeigt keine Vorschläge', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));

    expect(
      find.text('Tippe einen Begriff ein — Vorschläge erscheinen automatisch.'),
      findsOneWidget,
    );
  });
}
