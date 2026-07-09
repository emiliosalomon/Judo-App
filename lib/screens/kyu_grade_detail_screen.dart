import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/kyu_grade.dart';
import '../models/theory_question.dart';
import '../services/progress_scope.dart';
import '../theme/judo_theme.dart';
import 'technique_media_screen.dart';

class KyuGradeDetailScreen extends StatelessWidget {
  final KyuGrade grade;

  const KyuGradeDetailScreen({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
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
          if (grade.minAge != null)
            Text(
              AppStrings.minAgeLabel(grade.minAge!),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (trackableCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              AppStrings.learnedProgress(completedCount, trackableCount),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: JudoColors.red,
              ),
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
          ),
          _TrackableSection(
            title: AppStrings.sectionNageWaza,
            items: grade.nageWaza,
            idPrefix: 'kyu:${grade.kyu}:',
          ),
          _TrackableSection(
            title: AppStrings.sectionKatameWaza,
            items: grade.katameWaza,
            idPrefix: 'kyu:${grade.kyu}:',
          ),
          _TrackableSection(
            title: AppStrings.sectionAnwendungsaufgaben,
            items: grade.anwendungsaufgaben,
            idPrefix: 'kyu:${grade.kyu}:',
          ),
          _TheorySection(
            title: AppStrings.sectionTheorieThemen,
            questions: grade.theorieThemen,
          ),
          _Section(
            title: AppStrings.sectionZusatzbegriffe,
            items: grade.zusatzbegriffe,
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

  const _TrackableSection({
    required this.title,
    required this.items,
    required this.idPrefix,
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
              leading: Checkbox(
                value: progress.isCompleted('$idPrefix$item'),
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

  const _Section({required this.title, required this.items});

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
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('${AppStrings.bullet}$item'),
            ),
        ],
      ),
    );
  }
}
