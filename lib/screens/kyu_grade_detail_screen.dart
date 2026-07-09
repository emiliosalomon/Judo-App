import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/kyu_grade.dart';
import '../services/progress_scope.dart';
import '../theme/judo_theme.dart';

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
          _Section(
            title: AppStrings.sectionTheorieThemen,
            items: grade.theorieThemen,
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
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              title: Text(item),
              value: progress.isCompleted('$idPrefix$item'),
              onChanged: (_) => progress.toggle('$idPrefix$item'),
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
