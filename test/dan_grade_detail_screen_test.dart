import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/models/dan_grade.dart';
import 'package:judo_app/screens/dan_grade_detail_screen.dart';
import 'package:judo_app/widgets/celebrating_checkbox.dart';

import 'test_helpers.dart';

void main() {
  testWidgets(
    'Gonosen/Gaeshi- und Renraku/Rensoku-Ketten werden angezeigt, wenn '
    'hinterlegt',
    (WidgetTester tester) async {
      const grade = DanGrade(
        dan: 4,
        beltDescription: 'Schwarz',
        kata: 'Ju-no-Kata',
        gonosenGaeshiWaza: ['Tai-otoshi → Ko-soto-gake'],
        renrakuRensokuWaza: ['Seoi-nage → Ko-uchi-gake'],
      );

      await tester.pumpWidget(
        await wrapWithProgress(
          const MaterialApp(home: DanGradeDetailScreen(grade: grade)),
        ),
      );

      expect(find.text(AppStrings.gonosenGaeshiWazaLabel), findsOneWidget);
      expect(find.text(AppStrings.renrakuRensokuWazaLabel), findsOneWidget);
      expect(find.textContaining('Tai-otoshi → Ko-soto-gake'), findsOneWidget);
      expect(find.textContaining('Seoi-nage → Ko-uchi-gake'), findsOneWidget);
    },
  );

  testWidgets(
    'Ohne hinterlegte Ketten werden die Ueberschriften nicht angezeigt',
    (WidgetTester tester) async {
      const grade = DanGrade(
        dan: 6,
        beltDescription: 'Rot-Weiß',
        kata: 'Koshiki-no-Kata',
      );

      await tester.pumpWidget(
        await wrapWithProgress(
          const MaterialApp(home: DanGradeDetailScreen(grade: grade)),
        ),
      );

      expect(find.text(AppStrings.gonosenGaeshiWazaLabel), findsNothing);
      expect(find.text(AppStrings.renrakuRensokuWazaLabel), findsNothing);
    },
  );

  testWidgets(
    'Antippen einer Zusatztechnik mit kuratierter Erklaerung klappt diese '
    'auf, trotz Suffix wie "(min. 3 Varianten)"',
    (WidgetTester tester) async {
      const grade = DanGrade(
        dan: 3,
        beltDescription: 'Schwarz',
        kata: 'Kodokan Goshin-Jutsu',
        zusatztechniken: ['Ude-hishigi-hara-gatame (min. 3 Varianten)'],
      );

      await tester.pumpWidget(
        await wrapWithProgress(
          const MaterialApp(home: DanGradeDetailScreen(grade: grade)),
        ),
      );

      await tester.tap(
        find.textContaining('Ude-hishigi-hara-gatame (min. 3 Varianten)'),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Hara'), findsWidgets);
    },
  );

  testWidgets(
    'Zusatztechniken haben ein Fortschritts-Haekchen, das sich antippen '
    'laesst (unabhaengig vom Zusatztechniken-Programm der Kyu-Stufen)',
    (WidgetTester tester) async {
      const grade = DanGrade(
        dan: 2,
        beltDescription: 'Schwarz',
        kata: 'Katame-no-Kata',
        zusatztechniken: ['Tama-guruma'],
      );

      await tester.pumpWidget(
        await wrapWithProgress(
          const MaterialApp(home: DanGradeDetailScreen(grade: grade)),
        ),
      );

      final checkboxFinder = find.byType(CelebratingCheckbox);
      expect(checkboxFinder, findsOneWidget);
      expect(tester.widget<CelebratingCheckbox>(checkboxFinder).value, isFalse);

      await tester.tap(checkboxFinder);
      await tester.pump();

      expect(tester.widget<CelebratingCheckbox>(checkboxFinder).value, isTrue);
    },
  );
}
