import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/judo_theme.dart';

/// Zeigt kurz einen kleinen Konfetti-Burst an [position] (globale
/// Koordinaten), z.B. wenn eine Technik als gelernt abgehakt wird. Entfernt
/// sich selbst nach Ablauf der Animation (kein Timer, nur AnimationController
/// -> testfreundlich).
void showConfettiBurst(BuildContext context, Offset position) {
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) =>
        _ConfettiBurst(position: position, onDone: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _ConfettiBurst extends StatefulWidget {
  final Offset position;
  final VoidCallback onDone;

  const _ConfettiBurst({required this.position, required this.onDone});

  @override
  State<_ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<_ConfettiBurst>
    with SingleTickerProviderStateMixin {
  static const _colors = [
    JudoColors.red,
    JudoColors.blue,
    Color(0xFFFFD500),
    Color(0xFF2E9E4C),
    JudoColors.black,
  ];
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _particles = List.generate(14, (i) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = 36 + random.nextDouble() * 34;
      return _Particle(
        direction: Offset(math.cos(angle), math.sin(angle)) * speed,
        color: _colors[random.nextInt(_colors.length)],
        size: 5 + random.nextDouble() * 4,
      );
    });
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 650),
          )
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) widget.onDone();
          })
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final fade = (1 - t).clamp(0.0, 1.0);
          return Stack(
            children: [
              for (final particle in _particles)
                Positioned(
                  left:
                      widget.position.dx +
                      particle.direction.dx * t -
                      particle.size / 2,
                  top:
                      widget.position.dy +
                      particle.direction.dy * t +
                      60 * t * t -
                      particle.size / 2,
                  child: Opacity(
                    opacity: fade,
                    child: Container(
                      width: particle.size,
                      height: particle.size,
                      decoration: BoxDecoration(
                        color: particle.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Particle {
  final Offset direction;
  final Color color;
  final double size;

  _Particle({required this.direction, required this.color, required this.size});
}
