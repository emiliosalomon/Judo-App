import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/main.dart';
import 'package:judo_app/models/category.dart';
import 'package:judo_app/services/app_edition.dart';
import 'package:judo_app/widgets/category_wheel.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    '"Meine Kämpfe"-Button ist ein Pro-Feature (siehe app_edition.dart) '
    'und in der Free-Edition (Standard beim Testen ohne '
    '--dart-define=PRO_EDITION=true) nicht sichtbar',
    (WidgetTester tester) async {
      await tester.pumpWidget(const JudoApp());
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(
        find.text(AppStrings.myFightsButtonLabel),
        isProEdition ? findsOneWidget : findsNothing,
      );
    },
  );

  testWidgets('Home zeigt Titel und alle Kategorien im Auswahlrad', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());
    // Zusaetzlicher Pump fuer den AuthGate-Ladezustand (GuestChoiceStore +
    // Stores werden nacheinander asynchron geladen), danach wie gehabt:
    // Kein pumpAndSettle(): das Rad hat einen dauerhaft pulsierenden
    // Leucht-Effekt (repeat()), der nie "zur Ruhe kommt".
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Judo App'), findsOneWidget);
    for (final category in judoCategories) {
      expect(find.text(category.kanji), findsOneWidget);
      expect(find.text(bubbleLabelForCategory(category)), findsOneWidget);
    }
    // Lernanreiz-Leiste (Serie/Sterne/Pokale).
    expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    // Erster Besuch heute -> Serie beginnt bei 1.
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Antippen von Weiterführende Techniken zeigt den Gokyo-Katalog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());
    // Zusaetzlicher Pump fuer den AuthGate-Ladezustand (GuestChoiceStore +
    // Stores werden nacheinander asynchron geladen), danach wie gehabt:
    // Kein pumpAndSettle(): das Rad hat einen dauerhaft pulsierenden
    // Leucht-Effekt (repeat()), der nie "zur Ruhe kommt".
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    final techniques = judoCategories.firstWhere((c) => c.id == 'techniques');
    await tester.tap(find.text(bubbleLabelForCategory(techniques)));
    // Kein pumpAndSettle(): das Rad hat einen dauerhaft pulsierenden
    // Leucht-Effekt (repeat()), der nie "zur Ruhe kommt".
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Weiterführende Techniken'),
      ),
      findsOneWidget,
    );
    expect(find.text('De-ashi-barai'), findsOneWidget);
  });

  testWidgets('Antippen von Guertelpruefung oeffnet Kyu/Dan-Uebersicht', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());
    // Zusaetzlicher Pump fuer den AuthGate-Ladezustand (GuestChoiceStore +
    // Stores werden nacheinander asynchron geladen), danach wie gehabt:
    // Kein pumpAndSettle(): das Rad hat einen dauerhaft pulsierenden
    // Leucht-Effekt (repeat()), der nie "zur Ruhe kommt".
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    final beltExam = judoCategories.firstWhere((c) => c.id == 'belt-exam');
    await tester.tap(find.text(bubbleLabelForCategory(beltExam)));
    // Kein pumpAndSettle(): das Rad hat einen dauerhaft pulsierenden
    // Leucht-Effekt (repeat()), der nie "zur Ruhe kommt".
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Kyu (Schülergrade)'), findsOneWidget);
    expect(find.text('Dan (Meistergrade)'), findsOneWidget);
    expect(find.text('10. Kyu – Weiß-Gelb'), findsOneWidget);
  });

  testWidgets('Suche ist keine Rad-Kategorie mehr, sondern eine Leiste unten, '
      'die die Suchseite oeffnet', (WidgetTester tester) async {
    await tester.pumpWidget(const JudoApp());
    // Zusaetzlicher Pump fuer den AuthGate-Ladezustand (GuestChoiceStore +
    // Stores werden nacheinander asynchron geladen), danach wie gehabt:
    // Kein pumpAndSettle(): das Rad hat einen dauerhaft pulsierenden
    // Leucht-Effekt (repeat()), der nie "zur Ruhe kommt".
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(judoCategories.any((c) => c.id == 'search'), isFalse);
    expect(find.text('Suche'), findsNothing);

    await tester.tap(
      find.text('Technik, Kata, Begriff ... (z.B. "osotogari")'),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Suche')),
      findsOneWidget,
    );
  });

  testWidgets('Antippen von Technik-Quiz oeffnet das Quiz', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JudoApp());
    // Zusaetzlicher Pump fuer den AuthGate-Ladezustand (GuestChoiceStore +
    // Stores werden nacheinander asynchron geladen), danach wie gehabt:
    // Kein pumpAndSettle(): das Rad hat einen dauerhaft pulsierenden
    // Leucht-Effekt (repeat()), der nie "zur Ruhe kommt".
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    final quiz = judoCategories.firstWhere((c) => c.id == 'quiz');
    await tester.tap(find.text(bubbleLabelForCategory(quiz)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Technik-Quiz'),
      ),
      findsOneWidget,
    );
  });
}
