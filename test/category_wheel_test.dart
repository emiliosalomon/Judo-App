import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/models/category.dart';
import 'package:judo_app/widgets/category_wheel.dart';

void main() {
  testWidgets(
    'Beim Ziehen wandern die Kreis-Buttons (mit deutscher Beschriftung) '
    'mit, das japanische Zeichen aussen bleibt ortsfest stehen',
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
      final kanjiLabelBefore = tester.getTopLeft(find.text(category.kanji));
      final bubbleBefore = tester.getTopLeft(find.text(category.titleDe));

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
      final bubbleAfter = tester.getTopLeft(find.text(category.titleDe));

      expect(kanjiLabelAfter, kanjiLabelBefore);
      expect(bubbleAfter, isNot(bubbleBefore));
    },
  );
}
