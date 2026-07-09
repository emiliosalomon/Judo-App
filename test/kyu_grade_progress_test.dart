import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/kyu_grades_data.dart';
import 'package:judo_app/screens/kyu_grade_detail_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Ankreuzen einer Technik aktualisiert den Fortschrittszähler', (
    WidgetTester tester,
  ) async {
    final grade = judoKyuGrades.firstWhere((g) => g.kyu == 5);

    await tester.pumpWidget(
      await wrapWithProgress(
        MaterialApp(home: KyuGradeDetailScreen(grade: grade)),
      ),
    );

    expect(find.textContaining('0 von'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    expect(find.textContaining('1 von'), findsOneWidget);

    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
    expect(checkbox.value, isTrue);
  });

  testWidgets('Antippen einer Technikzeile öffnet die Medien-Detailseite', (
    WidgetTester tester,
  ) async {
    final grade = judoKyuGrades.firstWhere((g) => g.kyu == 5);

    await tester.pumpWidget(
      await wrapWithProgress(
        MaterialApp(home: KyuGradeDetailScreen(grade: grade)),
      ),
    );

    await tester.tap(find.text('O-soto-gari RL'));
    await tester.pumpAndSettle();

    expect(find.text('Auf YouTube ansehen'), findsOneWidget);
  });
}
