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

  testWidgets('Antippen einer Kategorie oeffnet die Detailseite', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());

    final beltExam = judoCategories.firstWhere((c) => c.id == 'belt-exam');
    await tester.tap(find.text(beltExam.kanji));
    await tester.pumpAndSettle();

    expect(find.text('${beltExam.titleDe} (${beltExam.kanji})'), findsOneWidget);
  });
}
