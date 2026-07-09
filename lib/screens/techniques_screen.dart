import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../data/kyu_grades_data.dart';
import '../data/techniques_data.dart';
import '../models/kyu_grade.dart';
import '../theme/judo_theme.dart';

/// Kompletter Technik-Katalog (Kodokan-Gokyo + Katame-waza), mit Kennzeichnung
/// welche Technik schon Teil des Kyu-Pruefungsprogramms ist ("bereits im
/// Guertelprogramm") vs. wirklich darueber hinausgehend ("weiterfuehrend").
class TechniquesScreen extends StatelessWidget {
  const TechniquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weiterführende Techniken')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Vollständiger Technik-Katalog nach dem klassischen Kodokan-'
            'Gokyo. Techniken, die schon Teil deines Kyu-Programms sind, '
            'sind entsprechend markiert.',
          ),
          _TechniqueSection(title: 'Nage-waza (Kodokan Gokyo)', techniques: kodokanGokyoNageWaza),
          _TechniqueSection(title: 'Osae-komi-waza', techniques: osaeKomiWaza),
          _TechniqueSection(title: 'Shime-waza', techniques: shimeWaza),
          _TechniqueSection(title: 'Kansetsu-waza', techniques: kansetsuWaza),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Zusatztechniken je Dan-Grad',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Weitere anerkannte Techniken (Shinmeisho-no-waza u.a.), die erst '
            'ab bestimmten Dan-Prüfungen dazukommen.',
          ),
          for (final grade in judoDanGrades.where((g) => g.zusatztechniken.isNotEmpty))
            ExpansionTile(
              title: Text('${grade.title} – Zusatztechniken'),
              iconColor: JudoColors.red,
              collapsedIconColor: JudoColors.black,
              children: [
                for (final technik in grade.zusatztechniken)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [const Text('•  '), Expanded(child: Text(technik))],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Ab welchem Kyu-Grad [techniqueName] erstmals im Pruefungsprogramm
/// vorkommt (Substring-Abgleich gegen Nage-/Katame-waza-Listen), oder null
/// wenn die Technik nicht Teil des Kyu-Programms ist.
KyuGrade? _firstKyuGradeCovering(String techniqueName) {
  final needle = techniqueName.toLowerCase();
  for (final grade in judoKyuGrades) {
    final haystack = [...grade.nageWaza, ...grade.katameWaza]
        .map((t) => t.toLowerCase())
        .join(' | ');
    if (haystack.contains(needle)) return grade;
  }
  return null;
}

class _TechniqueSection extends StatelessWidget {
  final String title;
  final List<String> techniques;

  const _TechniqueSection({required this.title, required this.techniques});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title (${techniques.length})',
            style: const TextStyle(fontWeight: FontWeight.bold, color: JudoColors.red),
          ),
          const SizedBox(height: 8),
          for (final technique in techniques)
            _TechniqueRow(name: technique, coveringGrade: _firstKyuGradeCovering(technique)),
        ],
      ),
    );
  }
}

class _TechniqueRow extends StatelessWidget {
  final String name;
  final KyuGrade? coveringGrade;

  const _TechniqueRow({required this.name, required this.coveringGrade});

  @override
  Widget build(BuildContext context) {
    final covered = coveringGrade != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: covered ? JudoColors.black : JudoColors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              covered ? 'ab ${coveringGrade!.kyu}. Kyu' : 'weiterführend',
              style: const TextStyle(color: JudoColors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
