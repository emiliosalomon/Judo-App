import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/screens/quiz_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets(
    'Runde starten zeigt die erste Frage mit 3 Antwortmoeglichkeiten; '
    'Antippen einer Antwort sperrt weitere Auswahl und zeigt Feedback',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: QuizScreen())),
      );

      expect(find.text(AppStrings.quizStartButton), findsOneWidget);
      await tester.tap(find.text(AppStrings.quizStartButton));
      await tester.pump();

      expect(find.text(AppStrings.quizQuestionProgress(1, 10)), findsOneWidget);
      final options = find.byType(GestureDetector);
      expect(options, findsNWidgets(3));

      await tester.tap(options.first);
      await tester.pump();

      // Nach der Antwort erscheint entweder das Richtig- oder
      // Falsch-Feedback, und ein Weiter-Button.
      final correctFeedback = find.text(AppStrings.quizCorrectFeedback);
      final anyWrongFeedback = find.textContaining('Leider falsch');
      expect(
        correctFeedback.evaluate().isNotEmpty ||
            anyWrongFeedback.evaluate().isNotEmpty,
        isTrue,
      );
      expect(find.text(AppStrings.quizNextButton), findsOneWidget);

      // Ein zweites Antippen einer (jetzt gesperrten) Option darf den
      // Zustand nicht mehr aendern - GestureDetectors mit onTap == null
      // reagieren nicht mehr, die Frage bleibt bei 1/10.
      await tester.tap(options.at(1));
      await tester.pump();
      expect(find.text(AppStrings.quizQuestionProgress(1, 10)), findsOneWidget);
    },
  );

  testWidgets(
    'Eine komplette Runde fuehrt zur Ergebnis-Ansicht mit Punktestand',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: QuizScreen())),
      );

      await tester.tap(find.text(AppStrings.quizStartButton));
      await tester.pump();

      for (var i = 0; i < 10; i++) {
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pump();
        final nextOrFinish =
            find.text(AppStrings.quizNextButton).evaluate().isNotEmpty
            ? find.text(AppStrings.quizNextButton)
            : find.text(AppStrings.quizFinishButton);
        await tester.tap(nextOrFinish);
        await tester.pump();
      }

      expect(find.text(AppStrings.quizFinishedTitle), findsOneWidget);
      expect(find.textContaining('von 10 richtig'), findsOneWidget);
      expect(find.text(AppStrings.quizPlayAgainButton), findsOneWidget);
    },
  );
}
