import 'package:flutter/material.dart';
import '../theme/judo_theme.dart';
import 'judo_throw_painter.dart';

/// App-Logo: stilisierter Judoka, der beim Drehen des Auswahlrads einen
/// Wurfansatz zeigt (inkl. Uke), danach wieder aufrecht steht und sich
/// verbeugt. Reagiert auf [isDragging]/[wheelRotation] von CategoryWheel.
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
  late final AnimationController _throwController;
  late final AnimationController _bowController;

  @override
  void initState() {
    super.initState();
    _throwController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: widget.isDragging ? 1 : 0,
    );
    _bowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void didUpdateWidget(covariant JudoLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDragging && !oldWidget.isDragging) {
      _bowController.stop();
      _bowController.value = 0;
      _throwController.animateTo(1, curve: Curves.easeOut);
    } else if (!widget.isDragging && oldWidget.isDragging) {
      _throwController
          .animateTo(0, curve: Curves.easeIn)
          .then((_) => _playBow());
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
    _throwController.dispose();
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
        color: JudoColors.white,
        border: Border.all(color: JudoColors.red, width: widget.size * 0.05),
        boxShadow: [
          BoxShadow(
            color: JudoColors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(widget.size * 0.12),
          child: SizedBox.expand(
            child: AnimatedBuilder(
              animation: Listenable.merge([_throwController, _bowController]),
              builder: (context, _) {
                return Transform.rotate(
                  angle: widget.isDragging ? widget.wheelRotation : 0,
                  child: CustomPaint(
                    painter: JudoThrowPainter(
                      throwBlend: _throwController.value,
                      bowBlend: _bowController.value,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
