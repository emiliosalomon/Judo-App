import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/rules_data.dart';
import 'package:judo_app/l10n/strings.dart';
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
    'Abschnitt ohne Text zeigt stattdessen den Hinweis auf die offizielle Quelle',
    (WidgetTester tester) async {
      final topicWithPendingSection = judoRulesTopics.firstWhere(
        (topic) => topic.sections.any((section) => section.text == null),
      );

      await tester.pumpWidget(const MaterialApp(home: RulesScreen()));
      await tester.tap(find.text(topicWithPendingSection.title));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.rulesPendingNote), findsOneWidget);
    },
  );
}
