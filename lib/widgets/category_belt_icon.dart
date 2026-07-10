import 'package:flutter/material.dart';
import '../theme/belt_colors.dart';

/// Kleiner Stapel farbiger Guertel-Balken (Weiss bis Schwarz), als
/// Rad-Symbol fuer die Kategorie "Guertelpruefung" - zeigt anschaulicher als
/// ein einzelnes Icon, dass es um den gesamten Guertelweg geht.
class CategoryBeltIcon extends StatelessWidget {
  final double size;

  const CategoryBeltIcon({super.key, this.size = 32});

  static const _colors = [
    BeltColors.weiss,
    BeltColors.gelb,
    BeltColors.gruen,
    BeltColors.schwarz,
  ];

  @override
  Widget build(BuildContext context) {
    final barHeight = size * 0.15;
    final gap = size * 0.09;
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < _colors.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            Container(
              width: size,
              height: barHeight,
              decoration: BoxDecoration(
                color: _colors[i],
                borderRadius: BorderRadius.circular(barHeight / 2),
                border: Border.all(color: Colors.black26, width: 1),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
