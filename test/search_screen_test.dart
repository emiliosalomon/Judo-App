import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/screens/search_screen.dart';

import 'test_helpers.dart';

void main() {
  final quickJumpField = find.byKey(const ValueKey('quickJumpField'));
  final aiSearchField = find.byKey(const ValueKey('aiSearchField'));

  testWidgets(
    'Eingabe ohne Bindestrich findet Vorschläge und öffnet die Detailseite',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: SearchScreen())),
      );

      // "osotogari" statt "O-soto-gari" — genau das Problem, das die
      // Textvorschläge lösen sollen.
      await tester.enterText(quickJumpField, 'osotogari');
      await tester.pumpAndSettle();

      expect(find.textContaining('O-soto-gari'), findsWidgets);

      await tester.tap(find.textContaining('O-soto-gari').first);
      await tester.pumpAndSettle();

      expect(find.text('Nage-waza (Wurftechnik)'), findsOneWidget);
    },
  );

  testWidgets('Ohne Fokus auf das Suchfeld werden keine Vorschläge gezeigt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      await wrapWithProgress(const MaterialApp(home: SearchScreen())),
    );

    // Mehrere Scrollable-Widgets im Baum (die Haupt-ListView plus interne
    // Scrollables der Textfelder) - explizit das erste, die Haupt-ListView
    // selbst, verwenden statt der automatischen Erkennung.
    await tester.scrollUntilVisible(
      find.text('Antippen zeigt Vorschläge, Tippen grenzt sie weiter ein.'),
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('searchScreenList')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(
      find.text('Antippen zeigt Vorschläge, Tippen grenzt sie weiter ein.'),
      findsOneWidget,
    );
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets(
    'Antippen des leeren Suchfelds zeigt bereits Vorschläge vor jeder Eingabe',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: SearchScreen())),
      );

      await tester.tap(quickJumpField);
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsWidgets);
    },
  );

  testWidgets(
    'KI-Suche zeigt vor jeder Eingabe einen Hinweistext statt Treffern',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: SearchScreen())),
      );

      expect(find.text(AppStrings.aiSearchEmptyState), findsOneWidget);
    },
  );

  testWidgets(
    'KI-Suche findet zu einer Frage die passende Antwort und zeigt sie direkt an',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: SearchScreen())),
      );

      // Bewusst andere Gross-/Kleinschreibung und ohne Fragezeichen als die
      // hinterlegte Frage - genau der Fall, den die Suche abfangen soll.
      await tester.enterText(aiSearchField, 'was ist judo');
      await tester.pumpAndSettle();

      expect(find.text('Was ist Judo?'), findsOneWidget);
      expect(find.textContaining('Jigoro Kano'), findsWidgets);
    },
  );

  testWidgets(
    'KI-Suche zeigt einen Hinweis an, wenn keine passende Antwort gefunden wird',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: SearchScreen())),
      );

      await tester.enterText(aiSearchField, 'xyzxyzxyz123');
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.aiSearchNoMatch), findsOneWidget);
    },
  );

  testWidgets(
    'Treffer mit bekanntem Ziel bietet einen Button, um mehr dazu anzusehen',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await wrapWithProgress(const MaterialApp(home: SearchScreen())),
      );

      await tester.enterText(aiSearchField, 'Was ist die Kata Nage-no-Kata?');
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.aiSearchOpenSource), findsWidgets);

      await tester.tap(find.text(AppStrings.aiSearchOpenSource).first);
      await tester.pumpAndSettle();

      expect(find.text('Nage-no-Kata'), findsWidgets);
    },
  );
}
