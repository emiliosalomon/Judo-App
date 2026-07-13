import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/widgets/judo_logo.dart';

void main() {
  testWidgets(
    'Uebersteht den vollen Zieh-Loslassen-Verbeugen-Zyklus ohne Fehler und '
    'zeigt weiterhin das Logo-Bild',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: JudoLogo(isDragging: false, wheelRotation: 0)),
        ),
      );
      expect(find.byType(Image), findsOneWidget);

      // Ziehen beginnt, Rad dreht sich.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: JudoLogo(isDragging: true, wheelRotation: math.pi / 2),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Image), findsOneWidget);

      // Loslassen: Rotation faedelt sich zurueck, danach Verbeugungs-Bounce.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: JudoLogo(isDragging: false, wheelRotation: math.pi / 2),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Image), findsOneWidget);

      // Zyklus laeuft vollstaendig aus, ohne Exception.
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Antippen des Logos loest den Verbeugungs-Bounce aus, ohne Fehler '
    '(auch wenn die Tonwiedergabe in Tests nicht verfuegbar ist)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: JudoLogo(isDragging: false, wheelRotation: 0)),
        ),
      );

      await tester.tap(find.byType(JudoLogo));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Image), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
