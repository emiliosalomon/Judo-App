import 'package:flutter/material.dart';
import '../theme/judo_theme.dart';

/// Zeichnet zwei stilisierte Judoka in einer Wurfszene (Schulterwurf-Silhouette):
/// Tori (blauer Kimono) gebeugt nach vorn, Uke (weisser Kimono, schwarze
/// Kontur) wird ueber die Schulter geworfen. Eigene Vektor-Illustration
/// (kein Fremdmaterial), Koordinaten in einem 100x100-Raster.
class JudoThrowPainter extends CustomPainter {
  const JudoThrowPainter();

  static const _limbWidthFactor = 0.09;
  static const _headRadiusFactor = 0.08;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    canvas.save();
    canvas.scale(scale, scale);

    _paintTori(canvas);
    _paintUke(canvas);

    canvas.restore();
  }

  void _paintTori(Canvas canvas) {
    final limb = Paint()
      ..color = JudoColors.blue
      ..strokeWidth = 100 * _limbWidthFactor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final head = Paint()..color = JudoColors.blue;

    const headCenter = Offset(35, 30);
    const shoulder = Offset(40, 42);
    const hip = Offset(52, 65);
    const footLeft = Offset(25, 95);
    const footRight = Offset(68, 92);
    const gripHand = Offset(78, 20);

    // Beine (stabiler Stand)
    canvas.drawLine(hip, footLeft, limb);
    canvas.drawLine(hip, footRight, limb);
    // Rumpf + Greifarm nach oben zu Uke
    canvas.drawLine(hip, shoulder, limb);
    canvas.drawLine(shoulder, headCenter, limb);
    canvas.drawLine(shoulder, gripHand, limb);

    canvas.drawCircle(headCenter, 100 * _headRadiusFactor, head);
  }

  void _paintUke(Canvas canvas) {
    final outline = Paint()
      ..color = JudoColors.black
      ..strokeWidth = 100 * _limbWidthFactor + 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final limb = Paint()
      ..color = JudoColors.white
      ..strokeWidth = 100 * _limbWidthFactor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final headFill = Paint()..color = JudoColors.white;
    final headOutline = Paint()
      ..color = JudoColors.black
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Uke fliegt im Bogen ueber Tori, Beine nach oben geschleudert.
    const headCenter = Offset(10, 55);
    const hip = Offset(30, 15);
    const kneeA = Offset(55, 3);
    const footA = Offset(78, 8);
    const kneeB = Offset(50, 18);
    const footB = Offset(72, 25);
    const trailingArm = Offset(20, 40);

    void boneLine(Offset a, Offset b) {
      canvas.drawLine(a, b, outline);
      canvas.drawLine(a, b, limb);
    }

    boneLine(headCenter, hip);
    boneLine(hip, kneeA);
    boneLine(kneeA, footA);
    boneLine(hip, kneeB);
    boneLine(kneeB, footB);
    boneLine(hip, trailingArm);

    canvas.drawCircle(headCenter, 100 * _headRadiusFactor, headFill);
    canvas.drawCircle(headCenter, 100 * _headRadiusFactor, headOutline);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
