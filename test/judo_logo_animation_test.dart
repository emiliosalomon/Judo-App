import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/widgets/judo_logo.dart';
import 'package:judo_app/widgets/judo_throw_painter.dart';

JudoThrowPainter _painterOf(WidgetTester tester) {
  final finder = find.byWidgetPredicate(
    (widget) => widget is CustomPaint && widget.painter is JudoThrowPainter,
  );
  return tester.widget<CustomPaint>(finder).painter as JudoThrowPainter;
}

void main() {
  testWidgets(
    'Ziehen zeigt den Wurfansatz, Loslassen fuehrt zurueck und danach zur Verbeugung',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: JudoLogo(isDragging: false))),
      );

      // Ruhezustand: kein Wurfansatz, keine Verbeugung.
      expect(_painterOf(tester).throwBlend, 0);
      expect(_painterOf(tester).bowBlend, 0);

      // Ziehen beginnt.
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: JudoLogo(isDragging: true))),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(_painterOf(tester).throwBlend, greaterThan(0.9));

      // Loslassen: erst zurueck zum Stehen ...
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: JudoLogo(isDragging: false))),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(_painterOf(tester).throwBlend, lessThan(0.1));

      // ... dann Verbeugung: bowBlend steigt zwischenzeitlich an.
      await tester.pump(const Duration(milliseconds: 200));
      expect(_painterOf(tester).bowBlend, greaterThan(0.1));

      // Und kehrt danach wieder auf 0 zurueck.
      await tester.pumpAndSettle();
      expect(_painterOf(tester).bowBlend, 0);
    },
  );
}
