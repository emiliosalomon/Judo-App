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
import '../widgets/expandable_technique_row.dart';
import '../widgets/grade_complete_reward.dart';

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
    final idPrefix = 'kyu:${grade.kyu}:';
    final completedCount = progress.countCompletedWithPrefix(idPrefix);

    // War vor diesem Tap noch nicht komplett? Wenn der Tap die Stufe auf
    // 100% bringt, wird direkt danach die grosse Belohnung gezeigt.
    void handleToggle(BuildContext context, String id) {
      final wasComplete =
          trackableCount > 0 && completedCount == trackableCount;
      progress.toggle(id);
      if (!wasComplete && trackableCount > 0) {
        final nowCompleted = progress.countCompletedWithPrefix(idPrefix);
        if (nowCompleted == trackableCount) {
          showGradeCompleteReward(context, gradeTitle: grade.title);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(grade.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              BeltKnotIcon(colors: beltColors, size: 42),
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
            idPrefix: idPrefix,
            beltColor: beltColors.first,
            onToggle: handleToggle,
          ),
          _TrackableSection(
            title: AppStrings.sectionNageWaza,
            items: grade.nageWaza,
            idPrefix: idPrefix,
            beltColor: beltColors.first,
            onToggle: handleToggle,
          ),
          _TrackableSection(
            title: AppStrings.sectionKatameWaza,
            items: grade.katameWaza,
            idPrefix: idPrefix,
            beltColor: beltColors.first,
            onToggle: handleToggle,
          ),
          _TrackableSection(
            title: AppStrings.sectionAnwendungsaufgaben,
            items: grade.anwendungsaufgaben,
            idPrefix: idPrefix,
            beltColor: beltColors.first,
            onToggle: handleToggle,
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
  final void Function(BuildContext context, String id) onToggle;

  const _TrackableSection({
    required this.title,
    required this.items,
    required this.idPrefix,
    required this.beltColor,
    required this.onToggle,
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
            ExpandableTechniqueRow(
              technique: item,
              rowBuilder: (context, onTap, expanded) => ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: CelebratingCheckbox(
                  value: progress.isCompleted('$idPrefix$item'),
                  activeColor: beltColor,
                  onChanged: (_) => onToggle(context, '$idPrefix$item'),
                ),
                title: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: JudoColors.black,
                  ),
                ),
                trailing: Icon(
                  expanded ? Icons.play_circle_outline : Icons.chevron_right,
                ),
                onTap: onTap,
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
                  BeltKnotIcon(colors: beltColors, size: 28),
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
