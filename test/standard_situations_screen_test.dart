import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/screens/standard_situations_screen.dart';

void main() {
  testWidgets(
    'Standardsituationen listet Gürtelstufen mit Anwendungsaufgaben auf',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: StandardSituationsScreen()),
      );

      expect(find.text('10. Kyu – Weiß-Gelb'), findsOneWidget);
      // Einstiegsstufe ohne Technikprogramm darf nicht auftauchen.
      expect(find.text('11. Kyu – Weiß (Sonne)'), findsNothing);

      await tester.dragUntilVisible(
        find.text('1. Kyu – Braun'),
        find.byType(ListView),
        const Offset(0, -300),
      );
      expect(find.text('1. Kyu – Braun'), findsOneWidget);
    },
  );

  testWidgets(
    'Antippen einer Anwendungsaufgabe mit hinterlegter Erklaerung klappt '
    'diese zuerst inline auf, erst ein zweites Antippen oeffnet die '
    'Medien-Detailseite',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: StandardSituationsScreen()),
      );

      await tester.tap(find.text('10. Kyu – Weiß-Gelb'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Nage-waza → Osae-komi-waza'));
      await tester.pump();

      expect(find.text('Auf YouTube ansehen'), findsNothing);
      expect(find.textContaining('Stand-Boden-Übergang'), findsOneWidget);

      await tester.tap(find.text('Nage-waza → Osae-komi-waza'));
      await tester.pumpAndSettle();

      expect(find.text('Auf YouTube ansehen'), findsOneWidget);
      expect(find.textContaining('Stand-Boden-Übergang'), findsOneWidget);
    },
  );
}
