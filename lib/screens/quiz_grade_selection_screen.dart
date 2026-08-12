import 'package:flutter/material.dart';

import '../data/dan_grades_data.dart';
import '../data/kyu_grades_data.dart';
import '../data/quiz_data.dart';
import '../l10n/strings.dart';
import '../theme/judo_theme.dart';

/// Ergebnis der Guertelstufen-Auswahl: die aktuelle Auswahl, und ob direkt
/// eine Runde damit gestartet werden soll (Start-Button auf diesem
/// Bildschirm) statt nur zum Quiz-Intro zurueckzukehren (Zurueck-Pfeil/
/// Systemzurueck).
typedef QuizGradeSelectionResult = (Set<String> selection, bool startNow);

/// Checkbox-Auswahl, welche Guertelstufen (und ggf. weiterfuehrende/Kata-
/// Techniken) im Quiz abgefragt werden sollen. Gibt beim Verlassen (Zurueck-
/// Pfeil, Systemzurueck oder Start-Button) immer die aktuelle Auswahl
/// zurueck.
class QuizGradeSelectionScreen extends StatefulWidget {
  final Set<String> initialSelection;

  const QuizGradeSelectionScreen({super.key, required this.initialSelection});

  @override
  State<QuizGradeSelectionScreen> createState() =>
      _QuizGradeSelectionScreenState();
}

class _QuizGradeSelectionScreenState extends State<QuizGradeSelectionScreen> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initialSelection};
  }

  void _leave() =>
      Navigator.of(context).pop<QuizGradeSelectionResult>((_selected, false));

  void _startNow() =>
      Navigator.of(context).pop<QuizGradeSelectionResult>((_selected, true));

  void _toggle(String label, bool value) {
    setState(() {
      if (value) {
        _selected.add(label);
      } else {
        _selected.remove(label);
      }
    });
  }

  void _selectAll(Iterable<String> labels) {
    setState(() => _selected.addAll(labels));
  }

  void _selectNone(Iterable<String> labels) {
    setState(() => _selected.removeAll(labels));
  }

  @override
  Widget build(BuildContext context) {
    final kyuLabels = [
      for (final grade in judoKyuGrades)
        if (techniquesOfKyuGrade(grade).isNotEmpty) grade.title,
    ];
    final danLabels = [
      for (final grade in judoDanGrades)
        if (techniquesOfDanGrade(grade).isNotEmpty) grade.title,
    ];
    final hasOther = quizTechniquesWithoutGrade.isNotEmpty;

    return PopScope<QuizGradeSelectionResult>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _leave,
          ),
          title: const Text(AppStrings.quizGradeSelectionTitle),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: _selected.isEmpty ? null : _startNow,
                style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
                child: const Text(AppStrings.quizStartButton),
              ),
              if (_selected.isEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  AppStrings.quizNoGradesSelectedHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: JudoColors.red),
                ),
              ],
            ],
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                AppStrings.quizGradeSelectionIntro,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _SectionHeader(
                title: AppStrings.tabKyu,
                onSelectAll: () => _selectAll(kyuLabels),
                onSelectNone: () => _selectNone(kyuLabels),
              ),
              for (final label in kyuLabels)
                CheckboxListTile(
                  value: _selected.contains(label),
                  onChanged: (value) => _toggle(label, value ?? false),
                  title: Text(label),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              const SizedBox(height: 12),
              _SectionHeader(
                title: AppStrings.tabDan,
                onSelectAll: () => _selectAll(danLabels),
                onSelectNone: () => _selectNone(danLabels),
              ),
              for (final label in danLabels)
                CheckboxListTile(
                  value: _selected.contains(label),
                  onChanged: (value) => _toggle(label, value ?? false),
                  title: Text(label),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              if (hasOther) ...[
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: _selected.contains(quizOtherCategoryLabel),
                  onChanged: (value) =>
                      _toggle(quizOtherCategoryLabel, value ?? false),
                  title: const Text(quizOtherCategoryLabel),
                  subtitle: const Text(
                    AppStrings.quizGradeSelectionOtherSubtitle,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSelectAll;
  final VoidCallback onSelectNone;

  const _SectionHeader({
    required this.title,
    required this.onSelectAll,
    required this.onSelectNone,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: JudoColors.red),
          ),
        ),
        TextButton(
          onPressed: onSelectAll,
          child: const Text(AppStrings.quizGradeSelectionSelectAll),
        ),
        TextButton(
          onPressed: onSelectNone,
          child: const Text(AppStrings.quizGradeSelectionSelectNone),
        ),
      ],
    );
  }
}
