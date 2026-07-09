import 'package:flutter/material.dart';
import '../theme/judo_theme.dart';

/// App-Logo: eigenes Bild (Wurfszene, vom Nutzer per KI-Bildtool erstellt).
/// Dreht sich mit dem Auswahlrad mit, solange gezogen wird, und macht
/// danach ein kurzes Verbeugungs-"Nicken" (Skalier-Bounce, da ein
/// statisches Bild keine Pose wechseln kann wie die vorherige
/// Vektor-Illustration).
class JudoLogo extends StatefulWidget {
  final double size;
  final bool isDragging;
  final double wheelRotation;

  const JudoLogo({
    super.key,
    this.size = 120,
    this.isDragging = false,
    this.wheelRotation = 0,
  });

  @override
  State<JudoLogo> createState() => _JudoLogoState();
}

class _JudoLogoState extends State<JudoLogo> with TickerProviderStateMixin {
  late final AnimationController _rotationSettleController;
  late final AnimationController _bowController;
  double _rotationAtRelease = 0;

  @override
  void initState() {
    super.initState();
    _rotationSettleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _bowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void didUpdateWidget(covariant JudoLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isDragging && oldWidget.isDragging) {
      _rotationAtRelease = oldWidget.wheelRotation;
      _rotationSettleController
        ..value = 0
        ..forward().then((_) => _playBow());
    }
  }

  Future<void> _playBow() async {
    if (!mounted) return;
    await _bowController.forward();
    if (!mounted) return;
    await _bowController.reverse();
  }

  @override
  void dispose() {
    _rotationSettleController.dispose();
    _bowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: JudoColors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _rotationSettleController,
            _bowController,
          ]),
          builder: (context, child) {
            final settleT = Curves.easeOut.transform(
              _rotationSettleController.value,
            );
            final angle = widget.isDragging
                ? widget.wheelRotation
                : _rotationAtRelease * (1 - settleT);
            final bowScale =
                1 - (Curves.easeInOut.transform(_bowController.value) * 0.08);
            return Transform.rotate(
              angle: angle,
              child: Transform.scale(scaleY: bowScale, child: child),
            );
          },
          child: Image.asset('assets/images/judo_logo.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
