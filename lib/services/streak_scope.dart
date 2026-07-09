import 'package:flutter/widgets.dart';
import 'streak_controller.dart';

/// Stellt den [StreakController] app-weit ueber den BuildContext bereit.
class StreakScope extends InheritedNotifier<StreakController> {
  const StreakScope({
    super.key,
    required StreakController controller,
    required super.child,
  }) : super(notifier: controller);

  static StreakController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StreakScope>();
    assert(scope != null, 'No StreakScope found in context');
    return scope!.notifier!;
  }
}
