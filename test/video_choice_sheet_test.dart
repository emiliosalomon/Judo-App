import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/l10n/strings.dart';
import 'package:judo_app/services/app_edition.dart';
import 'package:judo_app/widgets/video_choice_sheet.dart';

void main() {
  testWidgets(
    'chooseTechniqueVideo zeigt fuer eine Technik mit kuratiertem Video '
    'beide Optionen (Standbild/ganzes Video) - Pro-Feature (siehe '
    'app_edition.dart), daher nur relevant wenn mit '
    '--dart-define=PRO_EDITION=true getestet wird. Nicht tatsaechlich '
    'angetippt, da das einen echten launchUrl()-Aufruf ohne Platform-Mock '
    'ausloesen wuerde',
    (WidgetTester tester) async {
      if (!isProEdition) return;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () => chooseTechniqueVideo(context, 'O-soto-gari'),
                  child: const Text('oeffnen'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('oeffnen'));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.videoChoiceStandbildOption), findsOneWidget);
      expect(find.text(AppStrings.videoChoiceFullOption), findsOneWidget);
    },
  );
}
