import 'package:flutter/material.dart';

/// Gezeichneter Guertelknoten (zwei gekreuzte Baender + dunkler Knoten) als
/// farbiges Aufzaehlungszeichen vor Technik-/Guertel-Eintraegen. Bei
/// zweifarbigen Guerteln (z.B. Weiß-Gelb) bekommt jedes Band seine eigene
/// Farbe.
class BeltKnotIcon extends StatelessWidget {
  final List<Color> colors;
  final double size;

  const BeltKnotIcon({super.key, required this.colors, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BeltKnotPainter(colors: colors)),
    );
  }
}

class _BeltKnotPainter extends CustomPainter {
  final List<Color> colors;

  _BeltKnotPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final length = size.width * 0.98;
    final thickness = size.height * 0.34;
    final firstColor = colors.first;
    final secondColor = colors.length > 1 ? colors[1] : colors.first;

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: length,
      height: thickness,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(thickness / 2));
    final outline = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    canvas.save();
    canvas.rotate(-0.62);
    canvas.drawRRect(rrect, Paint()..color = firstColor);
    canvas.drawRRect(rrect, outline);
    canvas.restore();

    canvas.save();
    canvas.rotate(0.62);
    canvas.drawRRect(rrect, Paint()..color = secondColor);
    canvas.drawRRect(rrect, outline);
    canvas.restore();

    canvas.restore();

    final knotSize = size.width * 0.32;
    final knotRect = Rect.fromCenter(
      center: center,
      width: knotSize,
      height: knotSize * 0.78,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(knotRect, const Radius.circular(3)),
      Paint()..color = Colors.black87,
    );
  }

  @override
  bool shouldRepaint(covariant _BeltKnotPainter oldDelegate) =>
      oldDelegate.colors != colors;
}
