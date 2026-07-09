import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../data/kyu_grades_data.dart';
import '../data/techniques_data.dart';
import '../l10n/strings.dart';
import '../models/kyu_grade.dart';
import '../services/progress_scope.dart';
import '../theme/judo_theme.dart';

/// Kompletter Technik-Katalog (Kodokan-Gokyo + Katame-waza), mit Kennzeichnung
/// welche Technik schon Teil des Kyu-Pruefungsprogramms ist ("bereits im
/// Guertelprogramm") vs. wirklich darueber hinausgehend ("weiterfuehrend").
class TechniquesScreen extends StatelessWidget {
  const TechniquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.techniquesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(AppStrings.techniquesIntro),
          _TechniqueSection(
            title: AppStrings.nageWazaGokyoSection,
            techniques: kodokanGokyoNageWaza,
          ),
          _TechniqueSection(
            title: AppStrings.osaeKomiWazaSection,
            techniques: osaeKomiWaza,
          ),
          _TechniqueSection(
            title: AppStrings.shimeWazaSection,
            techniques: shimeWaza,
          ),
          _TechniqueSection(
            title: AppStrings.kansetsuWazaSection,
            techniques: kansetsuWaza,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            AppStrings.zusatztechnikenPerDanTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(AppStrings.zusatztechnikenPerDanIntro),
          Builder(
            builder: (context) {
              final progress = ProgressScope.of(context);
              return Column(
                children: [
                  for (final grade in judoDanGrades.where(
                    (g) => g.zusatztechniken.isNotEmpty,
                  ))
                    ExpansionTile(
                      title: Text(
                        AppStrings.zusatztechnikenSectionTitle(grade.title),
                      ),
                      iconColor: JudoColors.red,
                      collapsedIconColor: JudoColors.black,
                      children: [
                        for (final technik in grade.zusatztechniken)
                          CheckboxListTile(
                            contentPadding: const EdgeInsets.only(left: 16),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            title: Text(technik),
                            value: progress.isCompleted(
                              'dan:${grade.dan}:$technik',
                            ),
                            onChanged: (_) =>
                                progress.toggle('dan:${grade.dan}:$technik'),
                          ),
                      ],
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

/// Ab welchem Kyu-Grad [techniqueName] erstmals im Pruefungsprogramm
/// vorkommt (Substring-Abgleich gegen Nage-/Katame-waza-Listen), oder null
/// wenn die Technik nicht Teil des Kyu-Programms ist.
KyuGrade? _firstKyuGradeCovering(String techniqueName) {
  final needle = techniqueName.toLowerCase();
  for (final grade in judoKyuGrades) {
    final haystack = [
      ...grade.nageWaza,
      ...grade.katameWaza,
    ].map((t) => t.toLowerCase()).join(' | ');
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
            AppStrings.techniqueSectionTitle(title, techniques.length),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: JudoColors.red,
            ),
          ),
          const SizedBox(height: 8),
          for (final technique in techniques)
            _TechniqueRow(
              name: technique,
              coveringGrade: _firstKyuGradeCovering(technique),
            ),
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
    final progress = ProgressScope.of(context);
    final id = 'gokyo:$name';
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      value: progress.isCompleted(id),
      onChanged: (_) => progress.toggle(id),
      title: Row(
        children: [
          Expanded(child: Text(name)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: covered ? JudoColors.black : JudoColors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              covered
                  ? AppStrings.coveredFromGrade(coveringGrade!.kyu)
                  : AppStrings.notCoveredLabel,
              style: const TextStyle(color: JudoColors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
