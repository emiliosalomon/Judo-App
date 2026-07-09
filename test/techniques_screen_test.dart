import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/screens/techniques_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets(
    'Zeigt Kyu-Zuordnung für bekannte Techniken und "weiterführend" für den Rest',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(
          const MaterialApp(home: TechniquesScreen()),
        ),
      );

      // O-soto-gari und Harai-goshi sind Teil des 5. Kyu-Programms.
      expect(find.text('ab 5. Kyu'), findsNWidgets(2));
      // Yoko-gake (letzte Gokyo-Technik) ist in keinem Kyu-Programm enthalten.
      expect(find.text('Yoko-gake'), findsOneWidget);
    },
  );
}
