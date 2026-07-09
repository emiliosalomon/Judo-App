import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/kyu_grade.dart';
import '../models/theory_question.dart';
import '../services/progress_scope.dart';
import '../theme/belt_colors.dart';
import '../theme/judo_theme.dart';
import '../widgets/belt_knot_icon.dart';
import '../widgets/belt_progress_bar.dart';
import '../widgets/celebrating_checkbox.dart';
import 'technique_media_screen.dart';

class KyuGradeDetailScreen extends StatelessWidget {
  final KyuGrade grade;

  const KyuGradeDetailScreen({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final beltColors = beltColorsFromName(grade.beltName);
    final trackableCount =
        grade.ukemiWaza.length +
        grade.nageWaza.length +
        grade.katameWaza.length +
        grade.anwendungsaufgaben.length;
    final completedCount = progress.countCompletedWithPrefix(
      'kyu:${grade.kyu}:',
    );

    return Scaffold(
      appBar: AppBar(title: Text(grade.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              BeltKnotIcon(colors: beltColors, size: 34),
              const SizedBox(width: 10),
              if (grade.minAge != null)
                Text(
                  AppStrings.minAgeLabel(grade.minAge!),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
          if (trackableCount > 0) ...[
            const SizedBox(height: 12),
            Text(
              AppStrings.learnedProgress(completedCount, trackableCount),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: JudoColors.red,
              ),
            ),
            const SizedBox(height: 6),
            BeltProgressBar(
              progress: trackableCount == 0
                  ? 0
                  : completedCount / trackableCount,
              color: beltColors.first,
            ),
          ],
          if (grade.hinweis != null) ...[
            const SizedBox(height: 12),
            Text(grade.hinweis!, style: Theme.of(context).textTheme.bodyLarge),
          ],
          _TrackableSection(
            title: AppStrings.sectionUkemiWaza,
            items: grade.ukemiWaza,
            idPrefix: 'kyu:${grade.kyu}:',
            beltColor: beltColors.first,
          ),
          _TrackableSection(
            title: AppStrings.sectionNageWaza,
            items: grade.nageWaza,
            idPrefix: 'kyu:${grade.kyu}:',
            beltColor: beltColors.first,
          ),
          _TrackableSection(
            title: AppStrings.sectionKatameWaza,
            items: grade.katameWaza,
            idPrefix: 'kyu:${grade.kyu}:',
            beltColor: beltColors.first,
          ),
          _TrackableSection(
            title: AppStrings.sectionAnwendungsaufgaben,
            items: grade.anwendungsaufgaben,
            idPrefix: 'kyu:${grade.kyu}:',
            beltColor: beltColors.first,
          ),
          _TheorySection(
            title: AppStrings.sectionTheorieThemen,
            questions: grade.theorieThemen,
          ),
          _Section(
            title: AppStrings.sectionZusatzbegriffe,
            items: grade.zusatzbegriffe,
            beltColors: beltColors,
          ),
        ],
      ),
    );
  }
}

/// Abschnitt mit ankreuzbaren Punkten (Lernfortschritt wird gespeichert).
class _TrackableSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final String idPrefix;
  final Color beltColor;

  const _TrackableSection({
    required this.title,
    required this.items,
    required this.idPrefix,
    required this.beltColor,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final progress = ProgressScope.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: JudoColors.red,
            ),
          ),
          for (final item in items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: CelebratingCheckbox(
                value: progress.isCompleted('$idPrefix$item'),
                activeColor: beltColor,
                onChanged: (_) => progress.toggle('$idPrefix$item'),
              ),
              title: Text(item),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TechniqueMediaScreen(technique: item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Theorie-Fragen als Karteikarten: antippen zeigt die Antwort, nochmal
/// antippen blendet sie wieder aus (Lernprinzip).
class _TheorySection extends StatelessWidget {
  final String title;
  final List<TheoryQuestion> questions;

  const _TheorySection({required this.title, required this.questions});

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: JudoColors.red,
            ),
          ),
          for (final q in questions)
            ExpansionTile(
              title: Text(q.question),
              tilePadding: EdgeInsets.zero,
              iconColor: JudoColors.red,
              collapsedIconColor: JudoColors.black,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: Text(
                    q.answer ?? AppStrings.answerPending,
                    style: q.answer == null
                        ? const TextStyle(fontStyle: FontStyle.italic)
                        : null,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<Color> beltColors;

  const _Section({
    required this.title,
    required this.items,
    required this.beltColors,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: JudoColors.red,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BeltKnotIcon(colors: beltColors, size: 22),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
