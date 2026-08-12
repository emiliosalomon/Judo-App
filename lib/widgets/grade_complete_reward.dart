import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../theme/judo_theme.dart';
import 'belt_ring_trophy.dart';

/// Grosse Belohnungs-Anzeige, wenn eine Guertelstufe komplett abgehakt
/// wurde: Pokal mit Guertelfarben-Kranz + Glueckwunsch.
Future<void> showGradeCompleteReward(
  BuildContext context, {
  required String gradeTitle,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: AppStrings.beltCompleteBadge,
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (context, _, _) =>
        _GradeCompleteContent(gradeTitle: gradeTitle),
    transitionBuilder: (context, animation, _, child) {
      final t = Curves.elasticOut.transform(animation.value.clamp(0, 1));
      return Opacity(
        opacity: animation.value.clamp(0, 1),
        child: Transform.scale(scale: t, child: child),
      );
    },
  );
}

class _GradeCompleteContent extends StatelessWidget {
  final String gradeTitle;

  const _GradeCompleteContent({required this.gradeTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
          decoration: BoxDecoration(
            color: JudoColors.black,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: JudoColors.gold, width: 3),
            boxShadow: [
              BoxShadow(
                color: JudoColors.gold.withValues(alpha: 0.5),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BeltRingTrophy(size: 160),
              const SizedBox(height: 20),
              const Text(
                AppStrings.beltCompleteBadge,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: JudoColors.gold,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                gradeTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: JudoColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
                child: const Text(AppStrings.rewardCloseLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
