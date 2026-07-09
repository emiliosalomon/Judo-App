import 'package:flutter/material.dart';
import '../theme/judo_theme.dart';

/// Zeichnet zwei stilisierte Judoka in einer Wurfszene (Schulterwurf-Silhouette):
/// Tori (blauer Kimono) gebeugt nach vorn, Uke (weisser Kimono, schwarze
/// Kontur) wird ueber die Schulter geworfen. Eigene Vektor-Illustration
/// (kein Fremdmaterial), Koordinaten in einem 100x100-Raster.
///
/// Koerper werden vor den Koepfen gezeichnet, damit sich ueberlappende
/// Gliedmassen nie einen Kopf verdecken.
class JudoThrowPainter extends CustomPainter {
  const JudoThrowPainter();

  static const _limbWidthFactor = 0.09;
  static const _headRadiusFactor = 0.08;

  static const _toriHead = Offset(44, 34);
  static const _toriShoulder = Offset(46, 44);
  static const _toriHip = Offset(52, 60);
  static const _toriFootLeft = Offset(34, 90);
  static const _toriFootRight = Offset(66, 88);
  static const _toriGripHand = Offset(72, 22);

  static const _ukeHead = Offset(18, 42);
  static const _ukeHip = Offset(36, 18);
  static const _ukeKneeA = Offset(58, 8);
  static const _ukeFootA = Offset(80, 14);
  static const _ukeKneeB = Offset(54, 22);
  static const _ukeFootB = Offset(76, 30);
  static const _ukeTrailingArm = Offset(28, 34);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    canvas.save();
    canvas.scale(scale, scale);

    _paintToriBody(canvas);
    _paintUkeBody(canvas);
    // Koepfe zuletzt, damit sie nie von Gliedmassen verdeckt werden.
    _paintToriHead(canvas);
    _paintUkeHead(canvas);

    canvas.restore();
  }

  void _paintToriBody(Canvas canvas) {
    final limb = Paint()
      ..color = JudoColors.blue
      ..strokeWidth = 100 * _limbWidthFactor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Beine (stabiler Stand)
    canvas.drawLine(_toriHip, _toriFootLeft, limb);
    canvas.drawLine(_toriHip, _toriFootRight, limb);
    // Rumpf + Greifarm nach oben zu Uke
    canvas.drawLine(_toriHip, _toriShoulder, limb);
    canvas.drawLine(_toriShoulder, _toriHead, limb);
    canvas.drawLine(_toriShoulder, _toriGripHand, limb);
  }

  void _paintToriHead(Canvas canvas) {
    canvas.drawCircle(
      _toriHead,
      100 * _headRadiusFactor,
      Paint()..color = JudoColors.blue,
    );
  }

  void _paintUkeBody(Canvas canvas) {
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

    void boneLine(Offset a, Offset b) {
      canvas.drawLine(a, b, outline);
      canvas.drawLine(a, b, limb);
    }

    // Uke fliegt im Bogen ueber Tori, Beine nach oben geschleudert.
    boneLine(_ukeHead, _ukeHip);
    boneLine(_ukeHip, _ukeKneeA);
    boneLine(_ukeKneeA, _ukeFootA);
    boneLine(_ukeHip, _ukeKneeB);
    boneLine(_ukeKneeB, _ukeFootB);
    boneLine(_ukeHip, _ukeTrailingArm);
  }

  void _paintUkeHead(Canvas canvas) {
    canvas.drawCircle(
      _ukeHead,
      100 * _headRadiusFactor,
      Paint()..color = JudoColors.white,
    );
    canvas.drawCircle(
      _ukeHead,
      100 * _headRadiusFactor,
      Paint()
        ..color = JudoColors.black
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
