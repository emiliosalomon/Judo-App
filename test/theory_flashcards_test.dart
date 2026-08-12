import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/kyu_grades_data.dart';
import 'package:judo_app/screens/kyu_grade_detail_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets(
    'Theorie-Frage antippen zeigt Antwort, nochmal antippen blendet sie aus',
    (WidgetTester tester) async {
      final grade = judoKyuGrades.firstWhere((g) => g.kyu == 10);
      final question = grade.theorieThemen.first;

      await tester.pumpWidget(
        await wrapWithProgress(
          MaterialApp(home: KyuGradeDetailScreen(grade: grade)),
        ),
      );

      Future<void> scrollQuestionIntoView() async {
        await tester.dragUntilVisible(
          find.text(question.question),
          find.byType(ListView),
          const Offset(0, -100),
        );
        // dragUntilVisible haelt an, sobald irgendein Teil des Ziels im
        // Viewport liegt - das kann noch knapp am unteren Rand sein, wo
        // tap() (zielt auf den Mittelpunkt) danebengreift. Ein kleiner
        // Nachschlag stellt sicher, dass der Mittelpunkt sicher im Bild ist.
        await tester.drag(find.byType(ListView), const Offset(0, -80));
        await tester.pumpAndSettle();
      }

      await scrollQuestionIntoView();
      expect(find.text(question.question), findsOneWidget);
      expect(find.text(question.answer!), findsNothing);

      await tester.tap(find.text(question.question));
      await tester.pumpAndSettle();
      expect(find.text(question.answer!), findsOneWidget);

      // Die aufgeklappte Antwort verschiebt die Frage im Layout - erneut
      // sichtbar scrollen, bevor sie ein zweites Mal angetippt wird.
      await scrollQuestionIntoView();
      await tester.tap(find.text(question.question));
      await tester.pumpAndSettle();
      expect(find.text(question.answer!), findsNothing);
    },
  );

  test(
    'Jede Theorie-Frage hat entweder eine Antwort oder ist bewusst leer',
    () {
      for (final grade in judoKyuGrades) {
        for (final q in grade.theorieThemen) {
          // Antwort ist entweder ein nicht-leerer String oder explizit null
          // (fehlende Quelle) — nie ein leerer String.
          expect(q.answer == null || q.answer!.isNotEmpty, isTrue);
        }
      }
    },
  );
}
