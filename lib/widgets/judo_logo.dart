import 'package:flutter/material.dart';
import '../theme/judo_theme.dart';

/// Platzhalter fuer das finale Logo (zwei Judoka im Wurf, blauer/weisser
/// Kimono). Sobald die Grafik vorliegt, hier durch Image.asset ersetzen.
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_martial_arts,
            color: JudoColors.black,
            size: size * 0.42,
          ),
          const SizedBox(height: 2),
          Text(
            '柔道',
            style: TextStyle(
              color: JudoColors.red,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.16,
            ),
          ),
        ],
      ),
    );
  }
}
