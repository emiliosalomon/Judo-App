import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/judo_theme.dart';
import 'judo_logo.dart';

/// Kreisfoermiges Auswahlrad: Logo in der Mitte, Kategorien drumherum.
/// Ziehen dreht das Rad, Antippen einer Kategorie waehlt sie aus.
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
  double _rotation = 0;
  double _dragStartRotation = 0;
  Offset? _dragStartFocal;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = math.min(constraints.maxWidth, constraints.maxHeight);
        final radius = diameter / 2 * 0.60;
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
                  size: 136,
                  isDragging: _isDragging,
                  wheelRotation: _rotation,
                ),
                for (var i = 0; i < count; i++)
                  ..._wheelItem(
                    category: widget.categories[i],
                    angle: _rotation + anglePer * i - math.pi / 2,
                    baseAngle: anglePer * i - math.pi / 2,
                    radius: radius,
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
    required double baseAngle,
    required double radius,
    required Offset center,
  }) {
    const bubbleSize = 108.0;
    const labelWidth = 96.0;
    const labelGap = 8.0;
    final dx = center.dx + radius * math.cos(angle) - bubbleSize / 2;
    final dy = center.dy + radius * math.sin(angle) - bubbleSize / 2;

    // Beschriftung bleibt an einer festen Position stehen (baseAngle, ohne
    // _rotation) - beim Ziehen bewegt sich nur das innere Symbol (die
    // Buttons), die Schrift drumherum bleibt waagrecht und ortsfest.
    final labelRadius = radius + bubbleSize / 2 + labelGap;
    final labelDx =
        center.dx + labelRadius * math.cos(baseAngle) - labelWidth / 2;
    final labelDy = center.dy + labelRadius * math.sin(baseAngle) - 20;

    return [
      Positioned(
        left: dx,
        top: dy,
        child: Transform.rotate(
          // Gegendrehung, damit Icon/Kanji beim Rad-Drehen aufrecht bleiben.
          angle: -_rotation,
          child: GestureDetector(
            onTap: () => widget.onSelect(category),
            child: _CategoryBubble(category: category, size: bubbleSize),
          ),
        ),
      ),
      Positioned(
        left: labelDx,
        top: labelDy,
        width: labelWidth,
        child: IgnorePointer(
          child: Text(
            category.titleDe,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: JudoColors.black,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, color: JudoColors.white, size: size * 0.40),
              const SizedBox(height: 2),
              Text(
                category.kanji,
                style: TextStyle(
                  color: const Color(0xFFFF5C77),
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
