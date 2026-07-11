import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/screens/search_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets(
    'Eingabe ohne Bindestrich findet Vorschläge und öffnet die Detailseite',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: SearchScreen())),
      );

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

  testWidgets('Ohne Fokus auf das Suchfeld werden keine Vorschläge gezeigt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      await wrapWithProgress(const MaterialApp(home: SearchScreen())),
    );

    expect(
      find.text('Antippen zeigt Vorschläge, Tippen grenzt sie weiter ein.'),
      findsOneWidget,
    );
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets(
    'Antippen des leeren Suchfelds zeigt bereits Vorschläge vor jeder Eingabe',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: SearchScreen())),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsWidgets);
    },
  );
}
