import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/data/technique_media_data.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/models/kata_info.dart';
import 'package:judo_app/screens/kata_detail_screen.dart';

void main() {
  const infoWithImage = KataInfo(
    name: 'Test-Kata',
    meaning: 'Test-Bedeutung',
    description: 'Test-Beschreibung',
    overviewImage: TechniqueImage.asset(
      'assets/images/kata/test-kata.jpg',
      attribution: 'Test-Quelle',
    ),
  );

  const infoWithoutImage = KataInfo(
    name: 'Test-Kata',
    meaning: 'Test-Bedeutung',
    description: 'Test-Beschreibung',
  );

  testWidgets(
    'Kata-Detailseite zeigt ein Uebersichtsbild samt Quellenangabe an, '
    'wenn eines hinterlegt ist',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: KataDetailScreen(
            info: infoWithImage,
            requiredForGrade: '1. Dan',
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      await tester.scrollUntilVisible(find.textContaining('Test-Quelle'), 200);
      expect(find.textContaining('Test-Quelle'), findsOneWidget);
    },
  );

  testWidgets(
    'Kata-Detailseite zeigt kein Bild an, solange keines hinterlegt ist',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: KataDetailScreen(
            info: infoWithoutImage,
            requiredForGrade: '1. Dan',
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
      expect(find.text(AppStrings.imageAttributionPrefix), findsNothing);
    },
  );
}
