import 'package:flutter/material.dart';
import '../data/kyu_grades_data.dart';
import '../l10n/strings.dart';
import '../theme/belt_colors.dart';
import '../theme/judo_theme.dart';
import '../widgets/belt_knot_icon.dart';

/// Grad-uebergreifende Sicht auf die "Anwendungsaufgaben" aus dem
/// Kyu-Pruefungsprogramm — dieselben Daten wie in der Guertelpruefung,
/// hier gebuendelt ueber alle Grade hinweg durchsuchbar.
class StandardSituationsScreen extends StatelessWidget {
  const StandardSituationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gradesWithTasks = judoKyuGrades
        .where((grade) => grade.anwendungsaufgaben.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.standardSituationsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(AppStrings.standardSituationsIntro),
          for (final grade in gradesWithTasks)
            Builder(
              builder: (context) {
                final beltColors = beltColorsFromName(grade.beltName);
                return ExpansionTile(
                  leading: BeltKnotIcon(colors: beltColors, size: 32),
                  title: Text(grade.title),
                  iconColor: JudoColors.red,
                  collapsedIconColor: JudoColors.black,
                  children: [
                    for (final aufgabe in grade.anwendungsaufgaben)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BeltKnotIcon(colors: beltColors, size: 26),
                            const SizedBox(width: 10),
                            Expanded(child: Text(aufgabe)),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
