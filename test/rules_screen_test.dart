import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/rules_data.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/models/rules_topic.dart';
import 'package:judo_app/screens/rules_screen.dart';
import 'package:judo_app/screens/rules_topic_detail_screen.dart';

void main() {
  testWidgets('Regelwerk-Uebersicht zeigt alle Themenbereiche an', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RulesScreen()));

    expect(find.text(AppStrings.rulesTitle), findsOneWidget);
    for (final topic in judoRulesTopics) {
      expect(find.text(topic.title), findsOneWidget);
    }
  });

  testWidgets(
    'Tippen auf ein Thema oeffnet die Detailseite mit allen Abschnitten',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RulesScreen()));

      final firstTopic = judoRulesTopics.first;
      await tester.tap(find.text(firstTopic.title));
      await tester.pumpAndSettle();

      expect(find.byType(RulesTopicDetailScreen), findsOneWidget);
      for (final section in firstTopic.sections) {
        final finder = find.text(section.title);
        if (tester.any(finder)) continue;
        await tester.scrollUntilVisible(finder, 200);
        expect(finder, findsOneWidget);
      }
    },
  );

  testWidgets(
    'Abschnitt ohne Text und ohne Stichpunkte zeigt den Hinweis auf die '
    'offizielle Quelle',
    (WidgetTester tester) async {
      const topic = RulesTopic(
        id: 'test',
        title: 'Test-Thema',
        sections: [RulesSection(title: 'Test-Abschnitt')],
      );

      await tester.pumpWidget(
        const MaterialApp(home: RulesTopicDetailScreen(topic: topic)),
      );

      expect(find.text(AppStrings.rulesPendingNote), findsOneWidget);
    },
  );

  testWidgets(
    'Abschnitt ohne Text, aber mit Stichpunkten zeigt nur die Stichpunkte '
    '(nicht den Quellen-Hinweis)',
    (WidgetTester tester) async {
      const topic = RulesTopic(
        id: 'test',
        title: 'Test-Thema',
        sections: [
          RulesSection(
            title: 'Test-Abschnitt',
            bullets: ['Erster Punkt', 'Zweiter Punkt'],
          ),
        ],
      );

      await tester.pumpWidget(
        const MaterialApp(home: RulesTopicDetailScreen(topic: topic)),
      );

      expect(find.text(AppStrings.rulesPendingNote), findsNothing);
      expect(find.textContaining('Erster Punkt'), findsOneWidget);
      expect(find.textContaining('Zweiter Punkt'), findsOneWidget);
    },
  );

  test('Kein Regelwerk-Abschnitt ist mehr unbeantwortet (weder Text noch '
      'Stichpunkte) - alle bekannten Quellen wurden eingearbeitet', () {
    for (final topic in judoRulesTopics) {
      for (final section in topic.sections) {
        expect(
          section.text != null || section.bullets.isNotEmpty,
          isTrue,
          reason:
              '"${topic.title} – ${section.title}" hat weder Text noch '
              'Stichpunkte.',
        );
      }
    }
  });
}
