import 'package:flutter/material.dart';
import '../theme/judo_theme.dart';
import 'judo_throw_painter.dart';

/// App-Logo: zwei Judoka im Wurf (Tori blau, Uke weiss/schwarz umrandet),
/// als eigene Vektor-Illustration gezeichnet (siehe JudoThrowPainter).
class JudoLogo extends StatelessWidget {
  final double size;

  const JudoLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: JudoColors.white,
        border: Border.all(color: JudoColors.red, width: size * 0.05),
        boxShadow: [
          BoxShadow(
            color: JudoColors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(size * 0.12),
          child: SizedBox.expand(
            child: CustomPaint(painter: const JudoThrowPainter()),
          ),
        ),
      ),
    );
  }
}
