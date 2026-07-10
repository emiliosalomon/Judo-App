import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/screens/techniques_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets(
    'Zeigt Kyu-Zuordnung für bekannte Techniken und "weiterführend" für den Rest',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: TechniquesScreen())),
      );

      // O-soto-gari und Harai-goshi sind Teil des 5. Kyu-Programms.
      expect(find.text('ab 5. Kyu'), findsNWidgets(2));
      // Yoko-gake (letzte Gokyo-Technik) ist in keinem Kyu-Programm enthalten.
      expect(find.text('Yoko-gake'), findsOneWidget);
    },
  );

  testWidgets(
    'Techniken sind nach Guertelfarbe sortiert (fruehere Kyu-Stufe zuerst), '
    'nicht nach der rohen Gokyo-Reihenfolge',
    (WidgetTester tester) async {
      // In der rohen Gokyo-Liste steht O-soto-gari (ab 5. Kyu) VOR O-goshi
      // (ab 9. Kyu) - nach Guertelfarbe sortiert muss O-goshi (fruehere,
      // niedrigere Stufe) aber zuerst erscheinen.
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: TechniquesScreen())),
      );

      final oGoshiY = tester.getTopLeft(find.text('O-goshi')).dy;
      final oSotoGariY = tester.getTopLeft(find.text('O-soto-gari')).dy;
      expect(oGoshiY, lessThan(oSotoGariY));
    },
  );

  testWidgets(
    'Antippen von O-uchi-gari klappt zuerst das Bild inline auf, erst ein '
    'zweites Antippen oeffnet die Medien-Detailseite',
    (WidgetTester tester) async {
      // Grosses Testfenster, damit O-uchi-gari in der langen Gokyo-Liste
      // ohne Scrollen erreichbar ist. O-uchi-gari ist "weiterfuehrend"
      // (keiner Kyu-Stufe zugeordnet) und landet durch die Sortierung nach
      // Guertelfarbe entsprechend weit unten in der Liste.
      tester.view.physicalSize = const Size(400, 8000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: TechniquesScreen())),
      );

      await tester.tap(find.text('O-uchi-gari'));
      await tester.pump();

      expect(find.text('Auf YouTube ansehen'), findsNothing);
      expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);

      await tester.tap(find.text('O-uchi-gari'));
      await tester.pumpAndSettle();

      expect(find.text('Auf YouTube ansehen'), findsOneWidget);
    },
  );
}
