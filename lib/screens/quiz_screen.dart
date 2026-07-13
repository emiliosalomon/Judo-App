import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/quiz_data.dart';
import '../data/technique_video_data.dart';
import '../data/youtube_link.dart';
import '../l10n/strings.dart';
import '../services/progress_scope.dart';
import '../theme/judo_theme.dart';
import '../widgets/confetti_burst.dart';
import '../widgets/milestone_reward.dart';

enum _QuizStage { intro, playing, finished }

enum _Milestone { medal, trophy }

/// Farbe fuer "richtige Antwort" im Quiz - bewusst nicht Teil der
/// Marken-Farbpalette (Rot/Weiss/Schwarz), sondern dieselbe Gruen-Note wie
/// im Konfetti (confetti_burst.dart), rein als universelles Feedback-Signal.
const _correctColor = Color(0xFF2E9E4C);

/// Fortschritts-ID-Praefixe im gemeinsamen ProgressController-Speicher
/// (siehe progress_controller.dart) - eigener Namensraum, damit sich das
/// Quiz nicht mit den Kyu-/Dan-/Gokyo-IDs anderer Screens ueberschneidet.
const _masteredPrefix = 'quiz:';
const _wrongPrefix = 'quiz-wrong:';

const _medalInterval = 5;
const _trophyInterval = 20;

/// Multiple-Choice-Karteikarten-Quiz: zeigt eine Technik (japanischer
/// Name), drei deutsche Uebersetzungen zur Auswahl, eine davon richtig.
/// Eine richtig beantwortete Technik zaehlt als "gelernt" (Sterne-Zaehler);
/// je 5 gelernte Techniken gibt es eine Medaille, ab 20 einen Pokal. Falsch
/// beantwortete Techniken bleiben in einer "nochmal ueben"-Liste, bis sie
/// einmal richtig beantwortet wurden.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const _roundSize = 10;

  final _random = Random();
  _QuizStage _stage = _QuizStage.intro;
  List<String> _techniques = const [];
  QuizQuestion? _question;
  int _index = 0;
  int _score = 0;
  String? _selectedAnswer;
  _Milestone? _pendingMilestone;

  void _beginRound(List<String> techniques) {
    setState(() {
      _techniques = techniques;
      _index = 0;
      _score = 0;
      _stage = _QuizStage.playing;
      _question = generateQuestion(techniques[0], _random);
      _selectedAnswer = null;
    });
  }

  void _startRound() {
    _beginRound(
      pickQuizTechniques(min(_roundSize, quizTechniquePool.length), _random),
    );
  }

  void _startReviewRound(List<String> wrongTechniques) {
    if (wrongTechniques.isEmpty) return;
    _beginRound(wrongTechniques.toList()..shuffle(_random));
  }

  void _selectAnswer(String answer, Offset tapPosition) {
    final question = _question;
    if (question == null || _selectedAnswer != null) return;
    final progress = ProgressScope.of(context);
    final masteredId = '$_masteredPrefix${question.technique}';
    final wrongId = '$_wrongPrefix${question.technique}';
    final correct = answer == question.correctAnswer;
    if (correct) {
      _score++;
      final before = progress.countCompletedWithPrefix(_masteredPrefix);
      progress.markLearned(masteredId);
      progress.unmark(wrongId);
      showConfettiBurst(context, tapPosition);
      final after = progress.countCompletedWithPrefix(_masteredPrefix);
      if (after > before) {
        _pendingMilestone = after % _trophyInterval == 0
            ? _Milestone.trophy
            : after % _medalInterval == 0
            ? _Milestone.medal
            : null;
      }
    } else {
      progress.markLearned(wrongId);
    }
    setState(() => _selectedAnswer = answer);
  }

  void _resolvePendingMilestone() {
    final milestone = _pendingMilestone;
    _pendingMilestone = null;
    if (milestone == null) return;
    final total = ProgressScope.of(
      context,
    ).countCompletedWithPrefix(_masteredPrefix);
    switch (milestone) {
      case _Milestone.medal:
        showMilestoneReward(
          context,
          icon: Icons.workspace_premium,
          title: AppStrings.quizMedalTitle,
          subtitle: AppStrings.quizMedalSubtitle(total),
        );
      case _Milestone.trophy:
        showMilestoneReward(
          context,
          icon: Icons.emoji_events_rounded,
          title: AppStrings.quizTrophyTitle,
          subtitle: AppStrings.quizTrophySubtitle(total),
        );
    }
  }

  void _nextQuestion() {
    _resolvePendingMilestone();
    if (_index + 1 >= _techniques.length) {
      setState(() => _stage = _QuizStage.finished);
      return;
    }
    setState(() {
      _index++;
      _question = generateQuestion(_techniques[_index], _random);
      _selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.quizTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: switch (_stage) {
            _QuizStage.intro => _IntroView(
              onStart: _startRound,
              onReview: () => _startReviewRound(
                progress
                    .idsWithPrefix(_wrongPrefix)
                    .map((id) => id.substring(_wrongPrefix.length))
                    .toList(),
              ),
              reviewCount: progress.countCompletedWithPrefix(_wrongPrefix),
              masteredCount: progress.countCompletedWithPrefix(_masteredPrefix),
            ),
            _QuizStage.playing => _QuestionView(
              question: _question!,
              index: _index,
              total: _techniques.length,
              selectedAnswer: _selectedAnswer,
              onSelect: _selectAnswer,
              onNext: _nextQuestion,
            ),
            _QuizStage.finished => _ResultView(
              score: _score,
              total: _techniques.length,
              onPlayAgain: _startRound,
            ),
          },
        ),
      ),
    );
  }
}

class _IntroView extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onReview;
  final int reviewCount;
  final int masteredCount;

  const _IntroView({
    required this.onStart,
    required this.onReview,
    required this.reviewCount,
    required this.masteredCount,
  });

  @override
  Widget build(BuildContext context) {
    final medals = masteredCount ~/ _medalInterval;
    final trophies = masteredCount ~/ _trophyInterval;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.quiz, size: 72, color: JudoColors.red),
          const SizedBox(height: 20),
          Text(
            AppStrings.quizIntro,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (masteredCount > 0) ...[
            const SizedBox(height: 16),
            Text(
              AppStrings.quizProgressSummary(masteredCount, medals, trophies),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: JudoColors.black,
              ),
            ),
          ],
          const SizedBox(height: 28),
          FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
            child: const Text(AppStrings.quizStartButton),
          ),
          if (reviewCount > 0) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onReview,
              child: Text(AppStrings.quizReviewButton(reviewCount)),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.quizReviewIntro,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.quizExitButton),
          ),
        ],
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final QuizQuestion question;
  final int index;
  final int total;
  final String? selectedAnswer;
  final void Function(String answer, Offset tapPosition) onSelect;
  final VoidCallback onNext;

  const _QuestionView({
    required this.question,
    required this.index,
    required this.total,
    required this.selectedAnswer,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final answered = selectedAnswer != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text(AppStrings.quizExitButton),
          ),
        ),
        Text(
          AppStrings.quizQuestionProgress(index + 1, total),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => _openTechniqueVideo(context, question.technique),
          child: Column(
            children: [
              Text(
                question.technique,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: JudoColors.red),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 18,
                    color: JudoColors.black.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppStrings.quizTechniqueVideoHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: JudoColors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Column(
          key: const Key('quiz-options'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final option in question.options)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AnswerOption(
                  label: option,
                  status: !answered
                      ? _AnswerStatus.neutral
                      : option == question.correctAnswer
                      ? _AnswerStatus.correct
                      : option == selectedAnswer
                      ? _AnswerStatus.wrong
                      : _AnswerStatus.neutral,
                  onTap: answered
                      ? null
                      : (position) => onSelect(option, position),
                ),
              ),
          ],
        ),
        if (answered) ...[
          const SizedBox(height: 8),
          Text(
            selectedAnswer == question.correctAnswer
                ? AppStrings.quizCorrectFeedback
                : AppStrings.quizWrongFeedback(question.correctAnswer),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selectedAnswer == question.correctAnswer
                  ? _correctColor
                  : JudoColors.red,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onNext,
            style: FilledButton.styleFrom(backgroundColor: JudoColors.black),
            child: Text(
              index + 1 >= total
                  ? AppStrings.quizFinishButton
                  : AppStrings.quizNextButton,
            ),
          ),
        ],
      ],
    );
  }
}

/// Oeffnet das kuratierte YouTube-Video zu [technique] (oder eine
/// Suche, falls kein kuratierter Link hinterlegt ist) - fuer den Fall,
/// dass man die Technik im Quiz nicht kennt und sie sich kurz ansehen
/// will. Dieselbe Verlinkungslogik wie in expandable_technique_row.dart.
Future<void> _openTechniqueVideo(BuildContext context, String technique) async {
  final curated = findTechniqueVideo(technique);
  final uri = curated != null
      ? Uri.parse(curated)
      : youtubeSearchUrl(technique);
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AppStrings.couldNotOpenLink)));
  }
}

enum _AnswerStatus { neutral, correct, wrong }

class _AnswerOption extends StatelessWidget {
  final String label;
  final _AnswerStatus status;
  final void Function(Offset tapPosition)? onTap;

  const _AnswerOption({
    required this.label,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (background, border) = switch (status) {
      _AnswerStatus.neutral => (
        JudoColors.black.withValues(alpha: 0.04),
        JudoColors.black.withValues(alpha: 0.25),
      ),
      _AnswerStatus.correct => (
        _correctColor.withValues(alpha: 0.16),
        _correctColor,
      ),
      _AnswerStatus.wrong => (
        JudoColors.red.withValues(alpha: 0.12),
        JudoColors.red,
      ),
    };
    return GestureDetector(
      onTapDown: onTap == null
          ? null
          : (details) => onTap!(details.globalPosition),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 2),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onPlayAgain;

  const _ResultView({
    required this.score,
    required this.total,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            size: 72,
            color: JudoColors.gold,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.quizFinishedTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.quizScoreSummary(score, total),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: onPlayAgain,
            style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
            child: const Text(AppStrings.quizPlayAgainButton),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.quizBackButton),
          ),
        ],
      ),
    );
  }
}
