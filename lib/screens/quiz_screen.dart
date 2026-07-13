import 'dart:math';

import 'package:flutter/material.dart';

import '../data/quiz_data.dart';
import '../l10n/strings.dart';
import '../services/progress_scope.dart';
import '../theme/judo_theme.dart';
import '../widgets/confetti_burst.dart';

enum _QuizStage { intro, playing, finished }

/// Farbe fuer "richtige Antwort" im Quiz - bewusst nicht Teil der
/// Marken-Farbpalette (Rot/Weiss/Schwarz), sondern dieselbe Gruen-Note wie
/// im Konfetti (confetti_burst.dart), rein als universelles Feedback-Signal.
const _correctColor = Color(0xFF2E9E4C);

/// Multiple-Choice-Karteikarten-Quiz: zeigt eine Technik (japanischer
/// Name), drei deutsche Uebersetzungen zur Auswahl, eine davon richtig.
/// Eine richtig beantwortete Technik zaehlt als "gelernt" (Sterne-Zaehler).
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

  void _startRound() {
    final techniques = pickQuizTechniques(
      min(_roundSize, quizTechniquePool.length),
      _random,
    );
    setState(() {
      _techniques = techniques;
      _index = 0;
      _score = 0;
      _stage = _QuizStage.playing;
      _question = generateQuestion(techniques[0], _random);
      _selectedAnswer = null;
    });
  }

  void _selectAnswer(String answer, Offset tapPosition) {
    final question = _question;
    if (question == null || _selectedAnswer != null) return;
    final correct = answer == question.correctAnswer;
    if (correct) {
      _score++;
      ProgressScope.of(context).markLearned('quiz:${question.technique}');
      showConfettiBurst(context, tapPosition);
    }
    setState(() => _selectedAnswer = answer);
  }

  void _nextQuestion() {
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
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.quizTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: switch (_stage) {
            _QuizStage.intro => _IntroView(onStart: _startRound),
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

  const _IntroView({required this.onStart});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 28),
          FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
            child: const Text(AppStrings.quizStartButton),
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
        Text(
          AppStrings.quizQuestionProgress(index + 1, total),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        Text(
          question.technique,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: JudoColors.red),
        ),
        const SizedBox(height: 28),
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
              onTap: answered ? null : (position) => onSelect(option, position),
            ),
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
