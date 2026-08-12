import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/techniques_data.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/screens/techniques_az_screen.dart';

void main() {
  testWidgets('Zeigt beide Abschnitte mit korrekter Technik-Anzahl', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TechniquesAZScreen()));

    final bodenCount =
        osaeKomiWaza.length + shimeWaza.length + kansetsuWaza.length;
    expect(
      find.text(
        AppStrings.techniqueSectionTitle(
          AppStrings.standTechniquesSection,
          kodokanGokyoNageWaza.length,
        ),
      ),
      findsOneWidget,
    );

    final groundSectionFinder = find.text(
      AppStrings.techniqueSectionTitle(
        AppStrings.groundTechniquesSection,
        bodenCount,
      ),
    );
    await tester.scrollUntilVisible(groundSectionFinder, 300);
    expect(groundSectionFinder, findsOneWidget);
  });

  testWidgets(
    'Standtechniken stehen alphabetisch, nicht in Gokyo-Reihenfolge',
    (WidgetTester tester) async {
      // In der rohen Gokyo-Liste steht 'De-ashi-barai' vor 'Ashi-guruma' -
      // alphabetisch muss 'Ashi-guruma' zuerst kommen.
      await tester.pumpWidget(const MaterialApp(home: TechniquesAZScreen()));

      final ashiGurumaY = tester.getTopLeft(find.text('Ashi-guruma')).dy;
      final deAshiBaraiY = tester.getTopLeft(find.text('De-ashi-barai')).dy;
      expect(ashiGurumaY, lessThan(deAshiBaraiY));
    },
  );

  testWidgets('Zeigt die deutsche Uebersetzung direkt als Untertitel an', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TechniquesAZScreen()));

    // O-soto-gari ist die einzige Technik mit "Großes Außensicheln" als
    // Uebersetzung (Ko-soto-gari hat "Kleines Außensicheln").
    expect(find.text('Großes Außensicheln'), findsOneWidget);
  });
}
