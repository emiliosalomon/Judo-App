import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/judo_theme.dart';
import 'category_belt_icon.dart';
import 'judo_logo.dart';

/// Manuelle Trennstellen fuer lange Kategorienamen, damit sie im schmalen
/// Rad-Button sauber an einer sinnvollen (Wort-)Stelle umbrechen statt
/// mitten im Wort abgeschnitten zu werden.
const _bubbleLabelBreaks = <String, String>{
  'belt-exam': 'Gürtel-\nprüfung',
  'standard-situations': 'Standard-\nsituationen',
  'techniques': 'Weiterführende\nTechniken',
};

/// Text, wie er im Rad-Button tatsaechlich angezeigt wird (mit manuellem
/// Umbruch bei langen Namen). Oeffentlich, damit Tests denselben Text zum
/// Suchen/Antippen verwenden koennen wie das UI selbst.
String bubbleLabelForCategory(JudoCategory category) =>
    _bubbleLabelBreaks[category.id] ?? category.titleDe;

/// Kreisfoermiges Auswahlrad: Logo in der Mitte, Kategorien drumherum.
/// Ziehen dreht das Rad - die Kreis-Buttons (mit deutscher Beschriftung und
/// Icon) samt dem zugehoerigen japanischen Schriftzeichen aussen wandern
/// gemeinsam auf der Kreisbahn mit, bleiben dabei aber immer aufrecht und
/// waagrecht lesbar (wie eine Wasserwaage). Antippen einer Kategorie waehlt
/// sie aus.
class CategoryWheel extends StatefulWidget {
  final List<JudoCategory> categories;
  final ValueChanged<JudoCategory> onSelect;

  const CategoryWheel({
    super.key,
    required this.categories,
    required this.onSelect,
  });

  @override
  State<CategoryWheel> createState() => _CategoryWheelState();
}

class _CategoryWheelState extends State<CategoryWheel> {
  // Mindestabstand zwischen Logo-Mittelpunkt und Kreisbahn, damit die
  // Buttons das zentrale Logo (samt "JUDO LIFE"-Schriftzug darauf) nie
  // ueberdecken, unabhaengig von der tatsaechlichen Bildschirmgroesse.
  static const double _minClearance = 12;

  double _rotation = 0;
  double _dragStartRotation = 0;
  Offset? _dragStartFocal;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = math.min(constraints.maxWidth, constraints.maxHeight);
        // An diameter gekoppelt (statt fester Pixelwerte), damit Logo und
        // Rad-Buttons auf kleinen/kurzen Bildschirmen mitschrumpfen statt
        // weit ueber die eigene Kreisflaeche hinauszuragen.
        final logoSize = (diameter * 0.33).clamp(70.0, 118.0);
        final bubbleSize = (diameter * 0.34).clamp(74.0, 124.0);
        final minRadius = logoSize / 2 + bubbleSize / 2 + _minClearance;
        final radius = math.max(diameter / 2 * 0.60, minRadius);
        final center = Offset(diameter / 2, diameter / 2);
        final count = widget.categories.length;
        final anglePer = (2 * math.pi) / count;

        return SizedBox(
          width: diameter,
          height: diameter,
          child: GestureDetector(
            onPanStart: (details) {
              _dragStartRotation = _rotation;
              _dragStartFocal = details.localPosition - center;
              setState(() => _isDragging = true);
            },
            onPanUpdate: (details) {
              final focal = _dragStartFocal;
              if (focal == null) return;
              final current = details.localPosition - center;
              final startAngle = math.atan2(focal.dy, focal.dx);
              final currentAngle = math.atan2(current.dy, current.dx);
              setState(() {
                _rotation = _dragStartRotation + (currentAngle - startAngle);
              });
            },
            onPanEnd: (_) => setState(() => _isDragging = false),
            onPanCancel: () => setState(() => _isDragging = false),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                JudoLogo(
                  size: logoSize,
                  isDragging: _isDragging,
                  wheelRotation: _rotation,
                ),
                for (var i = 0; i < count; i++)
                  ..._wheelItem(
                    category: widget.categories[i],
                    angle: _rotation + anglePer * i - math.pi / 2,
                    radius: radius,
                    bubbleSize: bubbleSize,
                    center: center,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _wheelItem({
    required JudoCategory category,
    required double angle,
    required double radius,
    required double bubbleSize,
    required Offset center,
  }) {
    const labelWidth = 52.0;
    const labelGap = 6.0;
    // Kreis-Button UND japanisches Schriftzeichen wandern gemeinsam auf
    // derselben Kreisbahn (angle, inkl. _rotation) mit, damit die Zuordnung
    // Zeichen <-> Kategorie beim Drehen immer stimmt.
    final dx = center.dx + radius * math.cos(angle) - bubbleSize / 2;
    final dy = center.dy + radius * math.sin(angle) - bubbleSize / 2;

    final labelRadius = radius + bubbleSize / 2 + labelGap;
    final labelDx = center.dx + labelRadius * math.cos(angle) - labelWidth / 2;
    final labelDy = center.dy + labelRadius * math.sin(angle) - 20;

    return [
      Positioned(
        left: dx,
        top: dy,
        // Keine Rotation hier: Positioned verschiebt nur die Position (per
        // cos/sin berechnet), es dreht den Inhalt nie von sich aus. Icon
        // und Beschriftung bleiben dadurch immer aufrecht/waagrecht lesbar,
        // egal wie das Rad gezogen wird (wie eine Wasserwaage) - nur der
        // Button selbst wandert auf der Kreisbahn mit.
        child: GestureDetector(
          onTap: () => widget.onSelect(category),
          child: _CategoryBubble(category: category, size: bubbleSize),
        ),
      ),
      Positioned(
        left: labelDx,
        top: labelDy,
        width: labelWidth,
        child: IgnorePointer(
          child: Text(
            category.kanji,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: JudoColors.red,
              height: 1.15,
            ),
          ),
        ),
      ),
    ];
  }
}

/// Rad-Button mit sanft pulsierendem Leucht-Rand (Arcade-/Slotmachine-Feel).
class _CategoryBubble extends StatefulWidget {
  final JudoCategory category;
  final double size;

  const _CategoryBubble({required this.category, required this.size});

  @override
  State<_CategoryBubble> createState() => _CategoryBubbleState();
}

class _CategoryBubbleState extends State<_CategoryBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final category = widget.category;
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final glow = Curves.easeInOut.transform(_pulse.value);
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              center: Alignment(-0.3, -0.3),
              radius: 0.95,
              colors: [Color(0xFF2E2E2E), JudoColors.black],
            ),
            border: Border.all(color: JudoColors.red, width: 3),
            boxShadow: [
              BoxShadow(
                color: JudoColors.red.withValues(alpha: 0.4 + glow * 0.4),
                blurRadius: 12 + glow * 12,
                spreadRadius: 1 + glow * 2,
              ),
              const BoxShadow(
                color: Colors.black45,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glanzlicht oben links fuer den "Arcade-Button"-Look.
          Positioned(
            top: size * 0.1,
            left: size * 0.16,
            child: Container(
              width: size * 0.34,
              height: size * 0.2,
              decoration: BoxDecoration(
                color: JudoColors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (category.id == 'belt-exam')
                  CategoryBeltIcon(size: size * 0.22)
                else
                  Icon(
                    category.icon,
                    color: JudoColors.white,
                    size: size * 0.2,
                  ),
                const SizedBox(height: 6),
                Text(
                  bubbleLabelForCategory(category),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: JudoColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.08,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
