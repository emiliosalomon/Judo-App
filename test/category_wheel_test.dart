import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/models/category.dart';
import 'package:judo_app/theme/judo_theme.dart';
import 'package:judo_app/widgets/category_wheel.dart';

void main() {
  testWidgets(
    'Beim Ziehen wandern Kreis-Button und zugehoeriges japanisches Zeichen '
    'gemeinsam auf der Kreisbahn mit (Zuordnung bleibt erhalten)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 360,
              height: 360,
              child: CategoryWheel(
                categories: judoCategories,
                onSelect: (_) {},
              ),
            ),
          ),
        ),
      );
      // Kein pumpAndSettle(): das Rad hat einen dauerhaft pulsierenden
      // Leucht-Effekt (repeat()), der nie "zur Ruhe kommt".
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final category = judoCategories.first;
      final label = bubbleLabelForCategory(category);
      final kanjiLabelBefore = tester.getTopLeft(find.text(category.kanji));
      final bubbleBefore = tester.getTopLeft(find.text(label));

      // Rad um ein Viertel Umdrehung ziehen (Startpunkt bewusst abseits des
      // Mittelpunkts, sonst ist der Drehwinkel am Anfang undefiniert).
      final wheelCenter = tester.getCenter(find.byType(CategoryWheel));
      await tester.dragFrom(
        wheelCenter + const Offset(0, -100),
        const Offset(150, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final kanjiLabelAfter = tester.getTopLeft(find.text(category.kanji));
      final bubbleAfter = tester.getTopLeft(find.text(label));

      // Beide wandern gemeinsam auf der Kreisbahn mit - die Zuordnung
      // Zeichen <-> Kategorie darf sich beim Drehen nie loesen.
      expect(kanjiLabelAfter, isNot(kanjiLabelBefore));
      expect(bubbleAfter, isNot(bubbleBefore));
    },
  );

  testWidgets(
    'Kein Kanji-Zeichen ragt weit ueber den Bildschirmrand hinaus '
    '(Bug: Zeichen beim rechten Rad-Button stand ausserhalb des Bildschirms)',
    (WidgetTester tester) async {
      const boxSize = 360.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: boxSize,
              height: boxSize,
              child: CategoryWheel(
                categories: judoCategories,
                onSelect: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Derselbe grosszuegige Sicherheitsnetz-Saum wie im Widget selbst
      // (siehe CategoryWheel._wheelItem) - alles darueber hinaus waere
      // wieder der urspruengliche Bug (Zeichen komplett ausserhalb des
      // sichtbaren Bereichs).
      const tolerance = boxSize * 0.15;

      for (final category in judoCategories) {
        final rect = tester.getRect(find.text(category.kanji));
        expect(
          rect.left,
          greaterThanOrEqualTo(-tolerance),
          reason: '${category.kanji} ragt links zu weit heraus',
        );
        expect(
          rect.right,
          lessThanOrEqualTo(boxSize + tolerance),
          reason: '${category.kanji} ragt rechts zu weit heraus',
        );
        expect(
          rect.top,
          greaterThanOrEqualTo(-tolerance),
          reason: '${category.kanji} ragt oben zu weit heraus',
        );
        expect(
          rect.bottom,
          lessThanOrEqualTo(boxSize + tolerance),
          reason: '${category.kanji} ragt unten zu weit heraus',
        );
      }
    },
  );

  testWidgets('Kein Kanji-Zeichen ueberlappt den zugehoerigen Kreis-Button '
      '(Bug: Zeichen wurde optisch in den Kreis hineingezogen)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            height: 360,
            child: CategoryWheel(categories: judoCategories, onSelect: (_) {}),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    // Die Rad-Buttons sind die einzigen kreisfoermigen Container mit
    // rotem Rand im Baum (das zentrale Logo ist zwar auch kreisfoermig,
    // hat aber keinen Rand) - darueber laesst sich ihr tatsaechlicher
    // Kreis (Mittelpunkt + Radius) unabhaengig von der internen
    // Positionierungs-Formel ermitteln.
    final circleFinder = find.byWidgetPredicate((widget) {
      if (widget is! Container || widget.decoration is! BoxDecoration) {
        return false;
      }
      final decoration = widget.decoration! as BoxDecoration;
      return decoration.shape == BoxShape.circle &&
          decoration.border?.top.color == JudoColors.red;
    });
    expect(circleFinder, findsNWidgets(judoCategories.length));

    void checkNoOverlap() {
      for (var i = 0; i < judoCategories.length; i++) {
        final bubbleRect = tester.getRect(circleFinder.at(i));
        final bubbleCenter = bubbleRect.center;
        final bubbleRadius = bubbleRect.width / 2;

        final kanjiRect = tester.getRect(find.text(judoCategories[i].kanji));
        // Naechster Punkt des (achsenparallelen) Kanji-Rechtecks zum
        // Kreismittelpunkt - liegt dieser ausserhalb des Kreisradius,
        // ueberlappt das Zeichen den Kreis nirgends.
        final nearestX = bubbleCenter.dx.clamp(kanjiRect.left, kanjiRect.right);
        final nearestY = bubbleCenter.dy.clamp(kanjiRect.top, kanjiRect.bottom);
        final distance = (Offset(nearestX, nearestY) - bubbleCenter).distance;

        expect(
          distance,
          greaterThanOrEqualTo(bubbleRadius - 1),
          reason:
              '${judoCategories[i].kanji} ueberlappt seinen Kreis-Button '
              '(Abstand $distance < Radius $bubbleRadius)',
        );
      }
    }

    checkNoOverlap();

    // Auch waehrend des Ziehens selbst (bevor die Einrast-Animation nach
    // dem Loslassen greift) darf sich nichts ueberlappen - das Rad kann in
    // diesem Moment an jeder beliebigen Zwischenstellung stehen.
    final wheelCenter = tester.getCenter(find.byType(CategoryWheel));
    await tester.dragFrom(
      wheelCenter + const Offset(0, -100),
      const Offset(37, 0),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    checkNoOverlap();
  });

  testWidgets('Rad rastet nach dem Loslassen immer in einer der festen '
      'Grundpositionen ein, egal wie weit gezogen wurde', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            height: 360,
            child: CategoryWheel(categories: judoCategories, onSelect: (_) {}),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    final wheelCenter = tester.getCenter(find.byType(CategoryWheel));
    final circleFinder = find.byWidgetPredicate((widget) {
      if (widget is! Container || widget.decoration is! BoxDecoration) {
        return false;
      }
      final decoration = widget.decoration! as BoxDecoration;
      return decoration.shape == BoxShape.circle &&
          decoration.border?.top.color == JudoColors.red;
    });

    // Ein willkuerlicher, nicht auf 90 Grad ausgerichteter Ziehweg -
    // genau der Fall, der vorher an einer Zwischenstellung stehen blieb.
    await tester.dragFrom(
      wheelCenter + const Offset(0, -100),
      const Offset(37, 0),
    );
    await tester.pump();
    // Laenger als die 320ms-Einrast-Animation warten, bis sie fertig ist.
    await tester.pump(const Duration(milliseconds: 500));

    final anglePer = 2 * math.pi / judoCategories.length;
    for (var i = 0; i < judoCategories.length; i++) {
      final bubbleCenter = tester.getCenter(circleFinder.at(i));
      final offset = bubbleCenter - wheelCenter;
      final angle = math.atan2(offset.dy, offset.dx);
      // Kategorie 0 sitzt bei Rotation 0 nicht auf der 3-Uhr-Linie
      // (angle == 0), sondern eine viertel Umdrehung "davor" oben (siehe
      // `- math.pi / 2` in category_wheel.dart) - dieselbe konstante
      // Verschiebung muss hier vor dem Schritt-Vergleich abgezogen werden,
      // sonst passt das Raster nur zufaellig bei Kategorienanzahlen, bei
      // denen 90 Grad ein Vielfaches von anglePer ist (z.B. 4, nicht 5).
      final stepsFromZero = (angle + math.pi / 2) / anglePer;
      final distanceFromNearestStep =
          (stepsFromZero - stepsFromZero.roundToDouble()).abs();
      expect(
        distanceFromNearestStep,
        lessThan(0.02),
        reason:
            '${judoCategories[i].titleDe} steht nicht auf einer der festen '
            'Grundpositionen (Winkel-Schritt-Abweichung '
            '$distanceFromNearestStep)',
      );
    }
  });
}
