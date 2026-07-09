import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:judo_app/main.dart';
import 'package:judo_app/models/category.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Home zeigt Titel und alle Kategorien im Auswahlrad', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());
    await tester.pumpAndSettle();

    expect(find.text('Judo App'), findsOneWidget);
    for (final category in judoCategories) {
      expect(find.text(category.kanji), findsOneWidget);
      expect(find.text(category.titleDe), findsOneWidget);
    }
    // Lernanreiz-Leiste (Serie/Sterne/Pokale).
    expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    // Erster Besuch heute -> Serie beginnt bei 1.
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Antippen von Weiterführende Techniken zeigt den Gokyo-Katalog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());
    await tester.pumpAndSettle();

    final techniques = judoCategories.firstWhere((c) => c.id == 'techniques');
    await tester.tap(find.text(techniques.kanji));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Weiterführende Techniken'),
      ),
      findsOneWidget,
    );
    expect(find.text('De-ashi-barai'), findsOneWidget);
  });

  testWidgets('Antippen von Guertelpruefung oeffnet Kyu/Dan-Uebersicht', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());
    await tester.pumpAndSettle();

    final beltExam = judoCategories.firstWhere((c) => c.id == 'belt-exam');
    await tester.tap(find.text(beltExam.kanji));
    await tester.pumpAndSettle();

    expect(find.text('Kyu (Schülergrade)'), findsOneWidget);
    expect(find.text('Dan (Meistergrade)'), findsOneWidget);
    expect(find.text('10. Kyu – Weiß-Gelb'), findsOneWidget);
  });
}
