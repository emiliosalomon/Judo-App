import 'package:flutter/material.dart';
import '../data/kyu_grades_data.dart';
import '../theme/judo_theme.dart';

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
      appBar: AppBar(title: const Text('Standardsituationen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Anwendungsaufgaben aus dem OeJV-Kyu-Programm, gebündelt über '
            'alle Gürtelstufen. Dieselben Inhalte findest du auch direkt bei '
            'der jeweiligen Gürtelstufe.',
          ),
          for (final grade in gradesWithTasks)
            ExpansionTile(
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
                        const Text('•  '),
                        Expanded(child: Text(aufgabe)),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
