import 'package:flutter_test/flutter_test.dart';

import 'package:judo_app/main.dart';
import 'package:judo_app/models/category.dart';

void main() {
  testWidgets('Home zeigt Titel und alle Kategorien im Auswahlrad', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());

    expect(find.text('Judo App'), findsOneWidget);
    for (final category in judoCategories) {
      expect(find.text(category.kanji), findsOneWidget);
    }
  });

  testWidgets(
    'Antippen von Weiterführende Techniken zeigt den Gokyo-Katalog',
    (WidgetTester tester) async {
      await tester.pumpWidget(const JudoApp());

      final techniques = judoCategories.firstWhere(
        (c) => c.id == 'techniques',
      );
      await tester.tap(find.text(techniques.kanji));
      await tester.pumpAndSettle();

      expect(find.text('Weiterführende Techniken'), findsOneWidget);
      expect(find.text('De-ashi-barai'), findsOneWidget);
    },
  );

  testWidgets('Antippen von Guertelpruefung oeffnet Kyu/Dan-Uebersicht', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());

    final beltExam = judoCategories.firstWhere((c) => c.id == 'belt-exam');
    await tester.tap(find.text(beltExam.kanji));
    await tester.pumpAndSettle();

    expect(find.text('Kyu (Schülergrade)'), findsOneWidget);
    expect(find.text('Dan (Meistergrade)'), findsOneWidget);
    expect(find.text('10. Kyu – Weiß-Gelb'), findsOneWidget);
  });
}
