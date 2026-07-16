import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/quiz_data.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/screens/quiz_screen.dart';
import 'package:judo_app/services/progress_controller.dart';
import 'package:judo_app/services/progress_scope.dart';
import 'package:judo_app/services/progress_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_helpers.dart';

/// Findet nur die GestureDetectors der 3 Antwortoptionen (nicht z.B. die
/// des "Zurück"-Buttons) - die Optionen sind in eine eigene, mit
/// `Key('quiz-options')` markierte Column gepackt.
Finder _answerOptions() => find.descendant(
  of: find.byKey(const Key('quiz-options')),
  matching: find.byType(GestureDetector),
);

/// Rundenstart (Intro-Button, "Nochmal spielen", "Falsche wiederholen")
/// zeigt erst kurz "Hajime!" an (siehe QuizScreen._beginRound), bevor die
/// Frage erscheint - [finder] antippen und die Verzoegerung abwarten.
Future<void> _tapAndAwaitHajime(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}

/// Tippt den "Weiter"/"Ergebnis ansehen"-Button an und schliesst danach
/// eine ggf. aufpoppende Medaillen-/Pokal-Belohnung wieder, damit der
/// naechste Test-Schritt nicht durch den Dialog blockiert wird.
Future<void> _tapNextAndDismissAnyReward(WidgetTester tester) async {
  final nextOrFinish =
      find.text(AppStrings.quizNextButton).evaluate().isNotEmpty
      ? find.text(AppStrings.quizNextButton)
      : find.text(AppStrings.quizFinishButton);
  await tester.tap(nextOrFinish);
  await tester.pump();
  // Der Belohnungs-Dialog hat eine 380ms-Einblend-Animation (elasticOut) -
  // ohne zu warten sitzt sein Schliessen-Button noch nicht an der
  // finalen Position/Groesse und ist nicht trefferbar.
  await tester.pump(const Duration(milliseconds: 400));
  final rewardClose = find.text(AppStrings.rewardCloseLabel);
  if (rewardClose.evaluate().isNotEmpty) {
    await tester.tap(rewardClose);
    await tester.pump();
  }
}

void main() {
  testWidgets(
    'Runde starten zeigt die erste Frage mit 3 Antwortmoeglichkeiten; '
    'Antippen einer Antwort sperrt weitere Auswahl und zeigt Feedback',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: QuizScreen())),
      );

      expect(find.text(AppStrings.quizStartButton), findsOneWidget);
      await _tapAndAwaitHajime(tester, find.text(AppStrings.quizStartButton));

      expect(find.text(AppStrings.quizQuestionProgress(1, 10)), findsOneWidget);
      final options = _answerOptions();
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
    'Die Technik-Frage ist antippbar (Video-Hinweis wird angezeigt) - '
    'wird nicht tatsaechlich angetippt, da das einen echten launchUrl()-'
    'Aufruf ohne Platform-Mock ausloesen wuerde',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: QuizScreen())),
      );

      await _tapAndAwaitHajime(tester, find.text(AppStrings.quizStartButton));

      expect(find.text(AppStrings.quizTechniqueVideoHint), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
    },
  );

  testWidgets(
    'Eine komplette Runde fuehrt zur Ergebnis-Ansicht mit Punktestand',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: QuizScreen())),
      );

      await _tapAndAwaitHajime(tester, find.text(AppStrings.quizStartButton));

      for (var i = 0; i < 10; i++) {
        await tester.tap(_answerOptions().first);
        await tester.pump();
        await _tapNextAndDismissAnyReward(tester);
      }

      expect(find.text(AppStrings.quizFinishedTitle), findsOneWidget);
      expect(find.textContaining('von 10 richtig'), findsOneWidget);
      expect(find.text(AppStrings.quizPlayAgainButton), findsOneWidget);
    },
  );

  testWidgets(
    'Zurueck-Button auf dem Intro- und dem Frage-Bildschirm verlaesst das '
    'Quiz (Navigator.pop)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    ),
                    child: const Text('Quiz oeffnen'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Quiz oeffnen'));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.quizTitle), findsOneWidget);

      // Zurueck auf dem Intro-Bildschirm.
      await tester.tap(find.text(AppStrings.quizExitButton));
      await tester.pumpAndSettle();
      expect(find.text('Quiz oeffnen'), findsOneWidget);

      // Nochmal oeffnen, diesmal eine Runde starten und waehrend des
      // Beantwortens ueber den Zurueck-Button aussteigen.
      await tester.tap(find.text('Quiz oeffnen'));
      await tester.pumpAndSettle();
      await _tapAndAwaitHajime(tester, find.text(AppStrings.quizStartButton));
      await tester.tap(find.text(AppStrings.quizExitButton));
      await tester.pumpAndSettle();
      expect(find.text('Quiz oeffnen'), findsOneWidget);
    },
  );

  testWidgets('Nach 5 richtig gelernten Techniken insgesamt erscheint eine '
      'Medaillen-Belohnung', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await ProgressStore.load();
    final controller = ProgressController(store);

    await tester.pumpWidget(
      ProgressScope(
        controller: controller,
        child: const MaterialApp(home: QuizScreen()),
      ),
    );

    await _tapAndAwaitHajime(tester, find.text(AppStrings.quizStartButton));

    var safetyLimit = 60;
    while (controller.countCompletedWithPrefix('quiz:') < 5 &&
        safetyLimit > 0) {
      safetyLimit--;
      await tester.tap(_answerOptions().first);
      await tester.pump();
      await _tapNextAndDismissAnyReward(tester);
      if (find.text(AppStrings.quizPlayAgainButton).evaluate().isNotEmpty) {
        await _tapAndAwaitHajime(
          tester,
          find.text(AppStrings.quizPlayAgainButton),
        );
      }
    }

    expect(
      controller.countCompletedWithPrefix('quiz:'),
      greaterThanOrEqualTo(5),
    );
    expect(find.text(AppStrings.quizMedalTitle), findsOneWidget);
  });

  testWidgets(
    'Falsch beantwortete Technik landet in der Wiederholungsliste und kann '
    'gezielt nochmal geuebt werden; richtige Antwort entfernt sie wieder',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final store = await ProgressStore.load();
      final controller = ProgressController(store);
      final technique = quizTechniquePool.first;
      controller.markLearned('quiz-wrong:$technique');

      await tester.pumpWidget(
        ProgressScope(
          controller: controller,
          child: const MaterialApp(home: QuizScreen()),
        ),
      );

      expect(find.text(AppStrings.quizReviewButton(1)), findsOneWidget);
      await _tapAndAwaitHajime(
        tester,
        find.text(AppStrings.quizReviewButton(1)),
      );

      // Die Wiederholungsrunde hat genau 1 Frage - und zwar zur zuvor als
      // falsch markierten Technik.
      expect(find.text(AppStrings.quizQuestionProgress(1, 1)), findsOneWidget);
      expect(find.text(technique), findsOneWidget);

      await tester.tap(_answerOptions().first);
      await tester.pump();

      if (find.text(AppStrings.quizCorrectFeedback).evaluate().isNotEmpty) {
        expect(controller.isCompleted('quiz-wrong:$technique'), isFalse);
      } else {
        expect(controller.isCompleted('quiz-wrong:$technique'), isTrue);
      }
    },
  );

  testWidgets('"Vorherige Technik" fuehrt zur zuvor schon beantworteten Frage '
      'zurueck (Feedback + Weiter-Button sofort sichtbar, kein erneutes '
      'Zaehlen beim Antippen der - gesperrten - Optionen)', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final store = await ProgressStore.load();
    final controller = ProgressController(store);

    await tester.pumpWidget(
      ProgressScope(
        controller: controller,
        child: const MaterialApp(home: QuizScreen()),
      ),
    );

    // Auf der ersten Frage gibt es noch keine vorherige - der Button
    // fehlt.
    await _tapAndAwaitHajime(tester, find.text(AppStrings.quizStartButton));
    expect(find.text(AppStrings.quizPreviousQuestionButton), findsNothing);

    await tester.tap(_answerOptions().first);
    await tester.pump();
    final scoreBefore = controller.countCompletedWithPrefix('quiz:');

    await _tapNextAndDismissAnyReward(tester);
    expect(find.text(AppStrings.quizQuestionProgress(2, 10)), findsOneWidget);
    expect(find.text(AppStrings.quizPreviousQuestionButton), findsOneWidget);

    // Zurueck zur ersten Frage: schon beantwortet, also sofort Feedback
    // + Weiter-Button statt antippbarer Optionen.
    await tester.tap(find.text(AppStrings.quizPreviousQuestionButton));
    await tester.pump();
    expect(find.text(AppStrings.quizQuestionProgress(1, 10)), findsOneWidget);
    expect(find.text(AppStrings.quizNextButton), findsOneWidget);

    // Erneutes Antippen einer (gesperrten) Option darf den Fortschritt
    // nicht veraendern.
    await tester.tap(_answerOptions().first);
    await tester.pump();
    expect(controller.countCompletedWithPrefix('quiz:'), scoreBefore);
  });

  testWidgets(
    'Guertelstufen-Auswahl schraenkt die Runde auf die gewaehlten Stufen '
    'ein: nur "10. Kyu" ausgewaehlt zeigt nur dessen Techniken',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: QuizScreen())),
      );

      await tester.tap(find.text(AppStrings.quizGradeSelectionButton));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.quizGradeSelectionTitle), findsOneWidget);
      expect(find.text('10. Kyu – Weiß-Gelb'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('1. Dan'), 300);
      expect(find.text('1. Dan'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('10. Kyu – Weiß-Gelb'), -300);

      // Kyu-Sektion abwaehlen, dann nur 10. Kyu wieder anhaken.
      final kyuSectionNone = find
          .text(AppStrings.quizGradeSelectionSelectNone)
          .first;
      await tester.tap(kyuSectionNone);
      await tester.pump();
      await tester.tap(find.text('10. Kyu – Weiß-Gelb'));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(
        find.text(AppStrings.quizGradeSelectionSummary(1)),
        findsOneWidget,
      );

      await _tapAndAwaitHajime(tester, find.text(AppStrings.quizStartButton));
      // 10. Kyu hat nur 2 Techniken (Uki-goshi, O-soto-otoshi) - die
      // erste Frage muss eine davon zeigen, und die Runde hat nur 2
      // Fragen statt der sonst ueblichen 10.
      final showsUkiGoshi = find.text('Uki-goshi').evaluate().isNotEmpty;
      final showsOSotoOtoshi = find.text('O-soto-otoshi').evaluate().isNotEmpty;
      expect(showsUkiGoshi || showsOSotoOtoshi, isTrue);
      expect(find.text(AppStrings.quizQuestionProgress(1, 2)), findsOneWidget);
    },
  );

  testWidgets(
    'Ohne ausgewaehlte Guertelstufe ist der Start-Button deaktiviert und '
    'ein Hinweis erscheint',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: QuizScreen())),
      );

      await tester.tap(find.text(AppStrings.quizGradeSelectionButton));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text(AppStrings.quizGradeSelectionSelectNone).first,
      );
      await tester.pump();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.quizNoGradesSelectedHint), findsOneWidget);
      final startButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, AppStrings.quizStartButton),
      );
      expect(startButton.onPressed, isNull);
    },
  );
}
