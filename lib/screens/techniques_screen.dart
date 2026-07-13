import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../data/kyu_grades_data.dart';
import '../data/technique_translations_data.dart';
import '../data/techniques_data.dart';
import '../l10n/strings.dart';
import '../models/kyu_grade.dart';
import '../services/progress_scope.dart';
import '../theme/belt_colors.dart';
import '../theme/judo_theme.dart';
import '../widgets/belt_knot_icon.dart';
import '../widgets/celebrating_checkbox.dart';
import '../widgets/expandable_technique_row.dart';

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
                          ExpandableTechniqueRow(
                            technique: technik,
                            rowBuilder: (context, onTap, expanded) => ListTile(
                              contentPadding: const EdgeInsets.only(left: 16),
                              dense: true,
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CelebratingCheckbox(
                                    value: progress.isCompleted(
                                      'dan:${grade.dan}:$technik',
                                    ),
                                    activeColor: beltColorsFromName(
                                      grade.beltDescription,
                                    ).first,
                                    onChanged: (_) => progress.toggle(
                                      'dan:${grade.dan}:$technik',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  BeltKnotIcon(
                                    colors: beltColorsFromName(
                                      grade.beltDescription,
                                    ),
                                    size: 28,
                                  ),
                                ],
                              ),
                              title: Text(
                                technik,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: JudoColors.black,
                                ),
                              ),
                              subtitle: _translationSubtitle(technik),
                              trailing: const Icon(Icons.play_circle_outline),
                              onTap: onTap,
                            ),
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

/// Deutsche Uebersetzung als ListTile-Subtitle, oder `null` wenn keine
/// hinterlegt ist.
Widget? _translationSubtitle(String technique) {
  final translation = translateTechnique(technique);
  return translation == null ? null : Text(translation);
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

/// Sortiert Techniken nach Guertelfarbe/Kyu-Fortschritt: Techniken aus
/// niedrigeren Guertelstufen (hohe Kyu-Zahl, z.B. 11. Kyu) zuerst, dann
/// aufsteigend Richtung 1. Kyu, "weiterfuehrende" Techniken ohne
/// zugeordnete Guertelstufe zuletzt. Innerhalb derselben Stufe bleibt die
/// urspruengliche Reihenfolge erhalten.
List<String> _sortedByBelt(List<String> techniques) {
  final indexed = techniques.indexed.toList();
  indexed.sort((a, b) {
    final gradeA = _firstKyuGradeCovering(a.$2);
    final gradeB = _firstKyuGradeCovering(b.$2);
    if (gradeA == null && gradeB == null) return a.$1.compareTo(b.$1);
    if (gradeA == null) return 1;
    if (gradeB == null) return -1;
    final cmp = gradeB.kyu.compareTo(gradeA.kyu);
    return cmp != 0 ? cmp : a.$1.compareTo(b.$1);
  });
  return [for (final entry in indexed) entry.$2];
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
          for (final technique in _sortedByBelt(techniques))
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
    final beltColors = covered
        ? beltColorsFromName(coveringGrade!.beltName)
        : const [Color(0xFF9E9E9E)];
    return ExpandableTechniqueRow(
      technique: name,
      rowBuilder: (context, onTap, expanded) => ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CelebratingCheckbox(
              value: progress.isCompleted(id),
              activeColor: beltColors.first,
              onChanged: (_) => progress.toggle(id),
            ),
            const SizedBox(width: 4),
            BeltKnotIcon(colors: beltColors, size: 28),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: JudoColors.black,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: covered ? JudoColors.black : JudoColors.red,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                covered
                    ? AppStrings.coveredFromGrade(coveringGrade!.kyu)
                    : AppStrings.notCoveredLabel,
                style: const TextStyle(
                  color: JudoColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        subtitle: _translationSubtitle(name),
        trailing: const Icon(Icons.play_circle_outline),
        onTap: onTap,
      ),
    );
  }
}
