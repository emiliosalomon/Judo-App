import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/belt_colors.dart';
import '../theme/judo_theme.dart';

/// Grosses Pokal-Symbol, umringt von einem Kranz aus Guertelfarben (Weiss
/// bis Schwarz) - Belohnungs-Grafik fuer eine komplett abgehakte
/// Guertelstufe.
class BeltRingTrophy extends StatelessWidget {
  final double size;

  const BeltRingTrophy({super.key, this.size = 160});

  static const _colors = [
    BeltColors.weiss,
    BeltColors.gelb,
    BeltColors.orange,
    BeltColors.gruen,
    BeltColors.blau,
    BeltColors.braun,
    BeltColors.schwarz,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _BeltRingPainter(colors: _colors),
          ),
          Icon(Icons.emoji_events, size: size * 0.46, color: JudoColors.gold),
        ],
      ),
    );
  }
}

class _BeltRingPainter extends CustomPainter {
  final List<Color> colors;

  _BeltRingPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.13;
    final radius = size.width / 2 - strokeWidth / 2;
    final sweep = (2 * math.pi) / colors.length;
    final gap = sweep * 0.16;
    for (var i = 0; i < colors.length; i++) {
      final start = -math.pi / 2 + sweep * i + gap / 2;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep - gap,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BeltRingPainter oldDelegate) => false;
}
