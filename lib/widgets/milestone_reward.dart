import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../theme/judo_theme.dart';

/// Kleine Belohnungs-Anzeige fuer Zwischenziele (z.B. Quiz-Medaillen/-Pokale)
/// - dieselbe Optik wie die grosse Guertelstufen-Belohnung
/// (grade_complete_reward.dart), aber generisch statt an Guertelfarben
/// gebunden.
Future<void> showMilestoneReward(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (context, _, _) =>
        _MilestoneContent(icon: icon, title: title, subtitle: subtitle),
    transitionBuilder: (context, animation, _, child) {
      final t = Curves.elasticOut.transform(animation.value.clamp(0, 1));
      return Opacity(
        opacity: animation.value.clamp(0, 1),
        child: Transform.scale(scale: t, child: child),
      );
    },
  );
}

class _MilestoneContent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MilestoneContent({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

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
              Icon(icon, size: 96, color: JudoColors.gold),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: JudoColors.gold,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
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
