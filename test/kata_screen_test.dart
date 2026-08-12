import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/screens/kata_screen.dart';

void main() {
  testWidgets('Kata-Liste zeigt alle 6 Kata, Antippen öffnet Detailinhalte', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: KataScreen()));

    expect(find.text('Nage-no-Kata'), findsOneWidget);
    expect(find.text('Kodokan Goshin-Jutsu'), findsOneWidget);
    expect(find.text('Koshiki-no-Kata'), findsOneWidget);

    await tester.tap(find.text('Nage-no-Kata'));
    await tester.pumpAndSettle();

    expect(find.text('Formen des Werfens'), findsOneWidget);
    expect(
      find.textContaining('Seoi-nage', skipOffstage: false),
      findsOneWidget,
    );
  });

  testWidgets(
    'Kata-Detailseite zeigt oben einen Button fuer den gesamten Ablauf und '
    'jede Einzeltechnik ist antippbar (Video-Auswahlmenue)',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: KataScreen()));
      await tester.tap(find.text('Nage-no-Kata'));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.watchFullKataOnYoutube), findsOneWidget);

      final techniqueRow = find.ancestor(
        of: find.textContaining('Seoi-nage', skipOffstage: false),
        matching: find.byType(InkWell),
      );
      expect(techniqueRow, findsOneWidget);
    },
  );

  testWidgets(
    'Auch die vier zuvor nur zusammengefassten Kata (Goshin-Jutsu, Ju-no-'
    'Kata, Kime-no-Kata, Koshiki-no-Kata) zeigen jetzt Einzeltechniken '
    'statt nur Gruppen-Zusammenfassungen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: KataScreen()));

      await tester.tap(find.text('Ju-no-Kata'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Ryote-dori', skipOffstage: false),
        findsWidgets,
      );
      final techniqueRow = find.ancestor(
        of: find.textContaining('Tsuki-dashi', skipOffstage: false),
        matching: find.byType(InkWell),
      );
      expect(techniqueRow, findsOneWidget);
    },
  );
}
