import 'package:flutter/material.dart';
import 'confetti_burst.dart';

/// Checkbox mit kurzem Bounce + Konfetti-Burst beim Abhaken (nicht beim
/// Entfernen des Hakens) - fuers Lern-/Belohnungsgefuehl.
class CelebratingCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;

  const CelebratingCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  State<CelebratingCheckbox> createState() => _CelebratingCheckboxState();
}

class _CelebratingCheckboxState extends State<CelebratingCheckbox>
    with SingleTickerProviderStateMixin {
  final _boxKey = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.35,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.35,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(bool? newValue) {
    if (newValue == true && widget.value == false) {
      _controller.forward(from: 0);
      final box = _boxKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.attached) {
        final position = box.localToGlobal(box.size.center(Offset.zero));
        showConfettiBurst(context, position);
      }
    }
    widget.onChanged(newValue);
  }

  // Groesserer, besser lesbarer/tippbarer Haken als das Material-Default.
  static const _baseScale = 1.5;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      key: _boxKey,
      animation: _scale,
      builder: (context, child) =>
          Transform.scale(scale: _baseScale * _scale.value, child: child),
      child: Checkbox(
        value: widget.value,
        activeColor: widget.activeColor,
        onChanged: _handleChanged,
      ),
    );
  }
}
