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

    await tester.tap(find.text('O-soto-gari RL'));
    await tester.pump();

    expect(find.textContaining('1 von'), findsOneWidget);

    final checkbox = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'O-soto-gari RL'),
    );
    expect(checkbox.value, isTrue);
  });
}
