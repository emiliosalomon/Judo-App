import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/screens/my_fights_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Leeres Tagebuch zeigt Hinweistext', (tester) async {
    await tester.pumpWidget(
      await wrapWithFightLog(const MaterialApp(home: MyFightsScreen())),
    );

    expect(find.text(AppStrings.myFightsEmptyState), findsOneWidget);
  });

  testWidgets('Zeigt einen Link-Button zu den Judo-Austria-Turnierterminen', (
    tester,
  ) async {
    await tester.pumpWidget(
      await wrapWithFightLog(const MaterialApp(home: MyFightsScreen())),
    );

    expect(find.text(AppStrings.judoAustriaTermineButton), findsOneWidget);
  });

  testWidgets(
    'Kampf ueber das Formular eintragen zeigt ihn danach in der Liste',
    (tester) async {
      // Grosser Viewport, damit das gesamte Formular (inkl. Speichern-Button
      // ganz unten) ohne Scrollen gebaut wird - ListView baut sonst nur
      // Kinder innerhalb des sichtbaren Bereichs.
      tester.view.physicalSize = const Size(400, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        await wrapWithFightLog(const MaterialApp(home: MyFightsScreen())),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.addFightTitle), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, AppStrings.fightTournamentLabel),
        'OeJV Landescup',
      );
      await tester.enterText(
        find.widgetWithText(TextField, AppStrings.fightLocationLabel),
        'Linz',
      );
      await tester.enterText(
        find.widgetWithText(TextField, AppStrings.fightPlacementLabel),
        '2. Platz',
      );
      await tester.enterText(
        find.widgetWithText(TextField, AppStrings.fightOpponentsCountLabel),
        '5',
      );

      await tester.tap(find.text(AppStrings.saveFightButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.myFightsTitle), findsOneWidget);
      expect(find.text('OeJV Landescup'), findsOneWidget);
      expect(find.text('Linz'), findsOneWidget);
      expect(find.text('2. Platz'), findsOneWidget);
      expect(
        find.text(AppStrings.fightOpponentsCountSummary(5)),
        findsOneWidget,
      );
    },
  );

  testWidgets('Speichern ohne Turnier/Ort zeigt Fehlermeldung', (tester) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      await wrapWithFightLog(const MaterialApp(home: MyFightsScreen())),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.saveFightButton));
    await tester.pump();

    expect(find.text(AppStrings.fightRequiredFieldsMissing), findsOneWidget);
    // Kein Navigations-Pop bei fehlenden Pflichtfeldern.
    expect(find.text(AppStrings.addFightTitle), findsOneWidget);
  });

  testWidgets('Kampf loeschen entfernt ihn nach Bestaetigung aus der Liste', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      await wrapWithFightLog(const MaterialApp(home: MyFightsScreen())),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, AppStrings.fightTournamentLabel),
      'Testturnier',
    );
    await tester.enterText(
      find.widgetWithText(TextField, AppStrings.fightLocationLabel),
      'Testort',
    );
    await tester.tap(find.text(AppStrings.saveFightButton));
    await tester.pumpAndSettle();

    expect(find.text('Testturnier'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.deleteConfirm));
    await tester.pumpAndSettle();

    expect(find.text('Testturnier'), findsNothing);
    expect(find.text(AppStrings.myFightsEmptyState), findsOneWidget);
  });
}
