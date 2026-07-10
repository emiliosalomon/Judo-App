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

  testWidgets(
    'Antippen einer Technikzeile mit Bild klappt zuerst das Bild inline '
    'auf (ohne Bildschirmwechsel), erst ein zweites Antippen oeffnet die '
    'Medien-Detailseite',
    (WidgetTester tester) async {
      final grade = judoKyuGrades.firstWhere((g) => g.kyu == 5);

      await tester.pumpWidget(
        await wrapWithProgress(
          MaterialApp(home: KyuGradeDetailScreen(grade: grade)),
        ),
      );

      // O-soto-gari hat ein kuratiertes Bild (technique_media_data.dart).
      await tester.tap(find.text('O-soto-gari RL'));
      await tester.pump();

      // Kein Bildschirmwechsel: die Zeile ist noch da, kein Video-Button.
      expect(find.text('O-soto-gari RL'), findsOneWidget);
      expect(find.text('Auf YouTube ansehen'), findsNothing);
      expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);

      await tester.tap(find.text('O-soto-gari RL'));
      await tester.pumpAndSettle();

      expect(find.text('Auf YouTube ansehen'), findsOneWidget);
    },
  );

  testWidgets('Abhaken des letzten Punkts einer Guertelstufe zeigt die '
      'Pokal-Belohnung, ein Zwischenschritt aber nicht', (
    WidgetTester tester,
  ) async {
    // Grosses Testfenster, damit alle Checkboxen der Stufe ohne Scrollen
    // erreichbar sind (die Stufe hat mehr Punkte, als in die
    // Standard-Testviewport-Groesse passen).
    tester.view.physicalSize = const Size(400, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final grade = judoKyuGrades.firstWhere((g) => g.kyu == 10);

    await tester.pumpWidget(
      await wrapWithProgress(
        MaterialApp(home: KyuGradeDetailScreen(grade: grade)),
      ),
    );

    final checkboxCount = tester.widgetList(find.byType(Checkbox)).length;
    expect(checkboxCount, greaterThan(1));

    for (var i = 0; i < checkboxCount - 1; i++) {
      await tester.tap(find.byType(Checkbox).at(i));
      await tester.pump();
    }
    expect(find.text('Gürtel komplett!'), findsNothing);

    await tester.tap(find.byType(Checkbox).at(checkboxCount - 1));
    await tester.pumpAndSettle();

    expect(find.text('Gürtel komplett!'), findsOneWidget);
    // grade.title steht sowohl in der AppBar als auch in der
    // Belohnungs-Anzeige - deshalb findsWidgets statt findsOneWidget.
    expect(find.text(grade.title), findsWidgets);
  });
}
