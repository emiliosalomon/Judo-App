import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/models/category.dart';
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
      const diameter = 360.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: diameter,
              height: diameter,
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

      // Derselbe kleine Toleranzsaum wie im Widget selbst (siehe
      // CategoryWheel._wheelItem) - alles darueber hinaus waere wieder der
      // urspruengliche Bug (Zeichen komplett ausserhalb des sichtbaren
      // Bereichs).
      const tolerance = diameter * 0.06;

      for (final category in judoCategories) {
        final rect = tester.getRect(find.text(category.kanji));
        expect(
          rect.left,
          greaterThanOrEqualTo(-tolerance),
          reason: '${category.kanji} ragt links zu weit heraus',
        );
        expect(
          rect.right,
          lessThanOrEqualTo(diameter + tolerance),
          reason: '${category.kanji} ragt rechts zu weit heraus',
        );
        expect(
          rect.top,
          greaterThanOrEqualTo(-tolerance),
          reason: '${category.kanji} ragt oben zu weit heraus',
        );
        expect(
          rect.bottom,
          lessThanOrEqualTo(diameter + tolerance),
          reason: '${category.kanji} ragt unten zu weit heraus',
        );
      }
    },
  );
}
