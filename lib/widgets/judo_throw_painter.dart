import 'package:flutter/material.dart';
import '../theme/judo_theme.dart';

/// Gelenkpunkte fuer eine Tori-Pose (Kopf/Schulter/Hueft/Fuesse/Hand),
/// interpolierbar zwischen Posen (stehend/werfend/verbeugend).
class ToriPose {
  final Offset head;
  final Offset shoulder;
  final Offset hip;
  final Offset footLeft;
  final Offset footRight;
  final Offset hand;

  const ToriPose({
    required this.head,
    required this.shoulder,
    required this.hip,
    required this.footLeft,
    required this.footRight,
    required this.hand,
  });

  static ToriPose lerp(ToriPose a, ToriPose b, double t) {
    return ToriPose(
      head: Offset.lerp(a.head, b.head, t)!,
      shoulder: Offset.lerp(a.shoulder, b.shoulder, t)!,
      hip: Offset.lerp(a.hip, b.hip, t)!,
      footLeft: Offset.lerp(a.footLeft, b.footLeft, t)!,
      footRight: Offset.lerp(a.footRight, b.footRight, t)!,
      hand: Offset.lerp(a.hand, b.hand, t)!,
    );
  }
}

/// Aufrechter Ruhestand, Arme an der Seite.
const toriStanding = ToriPose(
  head: Offset(50, 22),
  shoulder: Offset(50, 34),
  hip: Offset(50, 58),
  footLeft: Offset(42, 92),
  footRight: Offset(58, 92),
  hand: Offset(50, 50),
);

/// Dynamischer Wurfansatz (Schulterwurf-Silhouette), Greifarm nach oben.
const toriThrowing = ToriPose(
  head: Offset(35, 30),
  shoulder: Offset(40, 42),
  hip: Offset(52, 65),
  footLeft: Offset(25, 95),
  footRight: Offset(68, 92),
  hand: Offset(78, 20),
);

/// Verbeugung (Rei): Oberkoerper nach vorn geneigt, Beine bleiben stehen.
const toriBowing = ToriPose(
  head: Offset(50, 48),
  shoulder: Offset(50, 46),
  hip: Offset(50, 58),
  footLeft: Offset(42, 92),
  footRight: Offset(58, 92),
  hand: Offset(44, 58),
);

const _ukeHead = Offset(18, 42);
const _ukeHip = Offset(36, 18);
const _ukeKneeA = Offset(58, 8);
const _ukeFootA = Offset(80, 14);
const _ukeKneeB = Offset(54, 22);
const _ukeFootB = Offset(76, 30);
const _ukeTrailingArm = Offset(28, 34);

/// Zeichnet den stilisierten Judoka (Tori, blauer Kimono) und - waehrend
/// [throwBlend] > 0 - Uke (weisser Kimono, schwarze Kontur) in einer
/// Wurfszene. Eigene Vektor-Illustration, Koordinaten in einem
/// 100x100-Raster.
///
/// [throwBlend]: 0 = stehend/verbeugend, 1 = voller Wurfansatz (Uke sichtbar).
/// [bowBlend]: 0 = neutral, 1 = verbeugt. Wird nur wirksam, wenn throwBlend
/// nahe 0 ist (man verbeugt sich nicht waehrend eines Wurfs).
///
/// Koerper werden vor den Koepfen gezeichnet, damit sich ueberlappende
/// Gliedmassen nie einen Kopf verdecken.
class JudoThrowPainter extends CustomPainter {
  final double throwBlend;
  final double bowBlend;

  const JudoThrowPainter({this.throwBlend = 1, this.bowBlend = 0});

  static const _limbWidthFactor = 0.09;
  static const _headRadiusFactor = 0.08;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    canvas.save();
    canvas.scale(scale, scale);

    final basePose = ToriPose.lerp(toriStanding, toriBowing, bowBlend);
    final pose = ToriPose.lerp(basePose, toriThrowing, throwBlend);

    _paintToriBody(canvas, pose);
    if (throwBlend > 0.02) {
      _paintUkeBody(canvas, throwBlend);
    }
    // Koepfe zuletzt, damit sie nie von Gliedmassen verdeckt werden.
    _paintToriHead(canvas, pose);
    if (throwBlend > 0.02) {
      _paintUkeHead(canvas, throwBlend);
    }

    canvas.restore();
  }

  void _paintToriBody(Canvas canvas, ToriPose pose) {
    final limb = Paint()
      ..color = JudoColors.blue
      ..strokeWidth = 100 * _limbWidthFactor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(pose.hip, pose.footLeft, limb);
    canvas.drawLine(pose.hip, pose.footRight, limb);
    canvas.drawLine(pose.hip, pose.shoulder, limb);
    canvas.drawLine(pose.shoulder, pose.head, limb);
    canvas.drawLine(pose.shoulder, pose.hand, limb);
  }

  void _paintToriHead(Canvas canvas, ToriPose pose) {
    canvas.drawCircle(
      pose.head,
      100 * _headRadiusFactor,
      Paint()..color = JudoColors.blue,
    );
  }

  void _paintUkeBody(Canvas canvas, double opacity) {
    final outline = Paint()
      ..color = JudoColors.black.withValues(alpha: opacity)
      ..strokeWidth = 100 * _limbWidthFactor + 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final limb = Paint()
      ..color = JudoColors.white.withValues(alpha: opacity)
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

  void _paintUkeHead(Canvas canvas, double opacity) {
    canvas.drawCircle(
      _ukeHead,
      100 * _headRadiusFactor,
      Paint()..color = JudoColors.white.withValues(alpha: opacity),
    );
    canvas.drawCircle(
      _ukeHead,
      100 * _headRadiusFactor,
      Paint()
        ..color = JudoColors.black.withValues(alpha: opacity)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant JudoThrowPainter oldDelegate) =>
      oldDelegate.throwBlend != throwBlend || oldDelegate.bowBlend != bowBlend;
}
