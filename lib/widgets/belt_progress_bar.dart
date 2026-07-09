import 'package:flutter/material.dart';

/// Animierter Fortschrittsbalken mit Leucht-Effekt in der Guertelfarbe.
/// Fuellt sich weich beim Aendern von [progress] (0.0-1.0).
class BeltProgressBar extends StatelessWidget {
  final double progress;
  final Color color;

  const BeltProgressBar({
    super.key,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 14,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: value > 0
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 0.5,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
