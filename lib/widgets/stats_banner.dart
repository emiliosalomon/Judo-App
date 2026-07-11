import 'package:flutter/material.dart';
import '../data/dan_grades_data.dart';
import '../data/kyu_grades_data.dart';
import '../l10n/strings.dart';
import '../models/kyu_grade.dart';
import '../services/progress_controller.dart';
import '../services/progress_scope.dart';
import '../services/streak_scope.dart';
import '../theme/judo_theme.dart';

int kyuTrackableCount(KyuGrade grade) =>
    grade.ukemiWaza.length +
    grade.nageWaza.length +
    grade.katameWaza.length +
    grade.anwendungsaufgaben.length;

/// Anzahl der Guertelstufen (Kyu + Dan-Zusatztechniken), bei denen alle
/// abhakbaren Punkte als gelernt markiert sind ("Pokal" pro voller Guertel).
int countTrophies(ProgressController progress) {
  var trophies = 0;
  for (final grade in judoKyuGrades) {
    final total = kyuTrackableCount(grade);
    if (total == 0) continue;
    if (progress.countCompletedWithPrefix('kyu:${grade.kyu}:') == total) {
      trophies++;
    }
  }
  for (final grade in judoDanGrades) {
    final total = grade.zusatztechniken.length;
    if (total == 0) continue;
    if (progress.countCompletedWithPrefix('dan:${grade.dan}:') == total) {
      trophies++;
    }
  }
  return trophies;
}

/// Duolingo-artige Leiste mit Lern-Serie, gesammelten Sternen und Pokalen -
/// soll fuers Weiterlernen motivieren.
class StatsBanner extends StatelessWidget {
  const StatsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final streak = StreakScope.of(context);
    final stars = progress.countCompletedWithPrefix('');
    final trophies = countTrophies(progress);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatPill(
          icon: Icons.local_fire_department_rounded,
          color: JudoColors.flame,
          value: streak.current,
          label: AppStrings.streakLabel,
          tooltip: AppStrings.streakDaysTooltip(streak.current),
        ),
        _StatPill(
          icon: Icons.star_rounded,
          color: JudoColors.gold,
          value: stars,
          label: AppStrings.starsLabel,
        ),
        _StatPill(
          icon: Icons.emoji_events_rounded,
          color: JudoColors.gold,
          value: trophies,
          label: AppStrings.trophiesLabel,
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final String label;
  final String? tooltip;

  const _StatPill({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.55), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: JudoColors.black,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: JudoColors.black,
            ),
          ),
        ],
      ),
    );
    return tooltip == null ? pill : Tooltip(message: tooltip!, child: pill);
  }
}
