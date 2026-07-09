import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
